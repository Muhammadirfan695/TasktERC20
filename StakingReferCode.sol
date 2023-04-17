// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}



interface IERC777 {
    function burn(uint256 amount, bytes calldata data) external;
    function send(address recipient, uint256 amount , bytes memory  data) external;                                                                                  
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    function transfer(address recipient, uint amount) external returns (bool);
}

contract StakingReferCode {
    IERC777 public token; 
    
    struct ReferralAccount {
        uint256 totalCommission;
        address referralAddress;
        uint256 commissionRate;
    }

    mapping(address => ReferralAccount) private _referralAccounts;

    mapping(address => uint256) private _referralBalances;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address private _defaultReferralAddress;

    struct ReferralLevel {
        uint256 commissionRate;
        address[] referrals;
    }
    
    mapping(uint256 => ReferralLevel) private _referralLevels;
    
    event ReferralCommissionPaid(
        address indexed payer,
        address indexed recipient,
        uint256 amount,
        uint256 level
    );

    constructor(IERC777 _token) {
        token = _token;
        _defaultReferralAddress = msg.sender;
        
        _referralLevels[1].commissionRate = 500;
        _referralLevels[2].commissionRate = 300;
        _referralLevels[3].commissionRate = 200;
        _referralLevels[4].commissionRate = 100;
        _referralLevels[5].commissionRate = 50;
        _referralLevels[6].commissionRate = 50;
    }

    function registerDefaultReferralAddress(address defaultReferralAddress) external {
        require(msg.sender == _defaultReferralAddress, "Only the default referral address can register a new default referral address");
        _defaultReferralAddress = defaultReferralAddress;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Staked amount must be greater than zero");

        token.transferFrom(msg.sender, address(this), amount);
        _balances[msg.sender] += amount;
        _updateReferralTree(msg.sender, _defaultReferralAddress, amount);
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(_balances[msg.sender] >= amount, "Insufficient balance");

        _balances[msg.sender] -= amount;
        _updateReferralTree(msg.sender, address(0), amount);

        token.transferFrom(address(this), msg.sender, amount);
    }

    function _updateReferralTree(address account, address referralAddress, uint256 amount) private {
        address currentReferralAddress = referralAddress == address(0) ? _defaultReferralAddress : referralAddress;
        uint256 totalCommission = 0;

        for (uint256 i = 1; i <= 6; i++) {
            address[] memory referrals = _referralLevels[i].referrals;

            if (referrals.length == 0) {
                continue;
            }

            uint256 commissionRate = _referralLevels[i].commissionRate;
            uint256 commission = amount * commissionRate / 10000;

            for (uint256 j = 0; j < referrals.length; j++) {
                address referralAccount = referrals[j];
                uint256 referralCommission = commission * _referralAccounts[referralAccount].commissionRate / 10000;

                if (referralAccount == currentReferralAddress) {
                    _referralAccounts[referralAccount].totalCommission += commission - referralCommission;
                } else {
                    _referralAccounts[referralAccount].totalCommission += referralCommission;
                }
                totalCommission += referralCommission;
            }
           
        }}
}