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
           

interface IERC777 {
    function burn(uint256 amount, bytes calldata data) external;
    function send(address recipient, uint256 amount, bytes memory data) external;                                                                                  
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    function transfer(address recipient, uint amount) external returns (bool);
}

contract MyToken  {
    IERC777 public token; 
    mapping(address => uint256) private _referralBalances;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // Default referral address
    address private _defaultReferralAddress;

    // Referral levels and commission rates
    struct ReferralLevel {
        uint256 commissionRate;
        address[] referrals;
    }
    mapping(uint256 => ReferralLevel) private _referralLevels;

    // Event emitted when a referral commission is paid out
    event ReferralCommissionPaid(
        address indexed payer,
        address indexed recipient,
        uint256 amount,
        uint256 level
    );

    constructor(IERC777 _token, address defaultReferralAddress) {
        token = _token;
        _defaultReferralAddress = defaultReferralAddress;
        
        // Set up referral commission rates for each level
        _referralLevels[1].commissionRate = 500;  // 5%
        _referralLevels[2].commissionRate = 300;  // 3%
        _referralLevels[3].commissionRate = 200;  // 2%
        _referralLevels[4].commissionRate = 100;  // 1%
        _referralLevels[5].commissionRate = 50;   // 0.5%
        _referralLevels[6].commissionRate = 50;   // 0.5%
    }

    function registerDefaultReferralAddress(address defaultReferralAddress) external {
        _defaultReferralAddress = defaultReferralAddress;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Staked amount must be greater than zero");

        // Transfer tokens from sender to this contract
        token.transferFrom(msg.sender, address(this), amount);

        // Update balances and referral tree
        _balances[msg.sender] += amount;
        _updateReferralTree(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(_balances[msg.sender] >= amount, "Insufficient balance");

        // Update balances and referral tree
        _balances[msg.sender] -= amount;
        _updateReferralTree(msg.sender, address(0), amount);

        // Transfer tokens from this contract to sender
        token.transferFrom(address(this), msg.sender, amount);
    }

    function getReferralCommissionBalance() external view returns (uint256) {
        return _referralBalances[msg.sender];
    }

   function _updateReferralTree(address account, address referralAddress, uint256 amount) private {
    address currentReferralAddress = referralAddress == address(0) ? _defaultReferralAddress : referralAddress;
    uint256 totalCommission = 0;

    // Update referral balances and emit events for each level
    for (uint256 i = 1; i <= 6; i++) {
        address referral = _referralLevels[i].referrals.length > 0 ? _referralLevels[i].referrals[0] : address(0);
        uint256 commission = amount * _referralLevels[i].commissionRate / 10000;

        if (referral != address(0)) {
            _referralBalances[referral] += commission;
            totalCommission += commission;
            emit ReferralCommissionPaid(referral, account, commission, i);
        } else {
            totalCommission += commission;
        }
    }

    // Update the account's referral balance
    _referralBalances[currentReferralAddress] += totalCommission;

    // Update the referral tree for the account
    address parent = currentReferralAddress;
    for (uint256 i = 1; i <= 6; i++) {
        ReferralLevel storage level = _referralLevels[i];
        if (level.referrals.length > 0) {
            address[] storage referrals = level.referrals;
            if (!referrals.contains(account)) {
                // Add the account to the referral list for this level
                referrals.push(account);
                emit ReferralAdded(account, parent, i);
            }
            // Update the parent for the next level
            parent = account;
            // Update the commission rate for this level
            level.commissionRate = _getCommissionRate(i, referrals.length);
        }
    }
}


// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC777, Ownable {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // Default referral address
    address private _defaultReferralAddress;

    // Referral levels and commission rates
    struct ReferralLevel {
        uint256 commissionRate;
        address[] referrals;
    }
    mapping(uint256 => ReferralLevel) private _referralLevels;

    // Event emitted when a referral commission is paid out
    event ReferralCommissionPaid(
        address indexed payer,
        address indexed recipient,
        uint256 amount,
        uint256 level
    );

    constructor(string memory name, string memory symbol, address defaultReferralAddress)
        ERC777(name, symbol, new address[](0))
    {
        _defaultReferralAddress = defaultReferralAddress;
        
        // Set up referral commission rates for each level
        _referralLevels[1].commissionRate = 500;  // 5%
        _referralLevels[2].commissionRate = 300;  // 3%
        _referralLevels[3].commissionRate = 200;  // 2%
        _referralLevels[4].commissionRate = 100;  // 1%
        _referralLevels[5].commissionRate = 50;   // 0.5%
        _referralLevels[6].commissionRate = 50;   // 0.5%
    }

    function registerDefaultReferralAddress(address defaultReferralAddress) external onlyOwner {
        _defaultReferralAddress = defaultReferralAddress;
    }

    function stake(uint256 amount, address referralAddress) external {
        require(amount > 0, "Staked amount must be greater than zero");
        require(referralAddress != msg.sender, "Cannot refer yourself");

        // Transfer tokens from sender to this contract
        _transfer(msg.sender, address(this), amount);

        // Update balances and referral tree
        _balances[msg.sender] += amount;
        _updateReferralTree(msg.sender, referralAddress, amount);
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(_balances[msg.sender] >= amount, "Insufficient balance");

        // Update balances and referral tree
        _balances[msg.sender] -= amount;
        _updateReferralTree(msg.sender, address(0), amount);

        // Transfer tokens from this contract to sender
        _transfer(address(this), msg.sender, amount);
    }

 function _updateReferralTree(address account, address referralAddress, uint256 amount) private {
    address currentReferralAddress = referralAddress == address(0) ? _defaultReferralAddress : referralAddress;
    uint256 totalCommission = 0;

    // Update referral balances and emit events for each level
    for (uint256 i = 1; i <= 6; i++) {
        address referral = _referralLevels[i].referrals.length > 0 ? _referralLevels[i].referrals[0] : address(0);
        uint256 commission = amount * _referralLevels[i].commissionRate / 10000;

        if (referral != address(0)) {
            _referralBalances[referral] += commission;
            totalCommission += commission;
            emit ReferralCommissionPaid(referral, account, commission, i);
        } else {
            totalCommission += commission;
        }
    }

    // Update the account's referral balance
    _referralBalances[currentReferralAddress] += totalCommission;
}

               

function stake(uint256 _amount, address _referrer) external {
    require(!registered[msg.sender], "Already registered");
    require(_amount > 0, "Amount should be greater than 0");

    // Transfer tokens to the contract
    require(stakingToken.send(msg.sender, address(this), _amount, ""), "Transfer failed");

    // Add the user to the user list if not already present
    if (!registered[msg.sender]) {
        userList.push(msg.sender);
        registered[msg.sender] = true;
    }

    // Initialize the user
    User storage user = users[msg.sender];
    user.balance = user.balance.add(_amount);
    user.referrer = _referrer;

    // Update the total staked amount
    totalStaked = totalStaked.add(_amount);

    // Distribute referral rewards
    address referrer = user.referrer;
    for (uint256 i = 0; i < refRewards.length && referrer != address(0); i++) {
        uint256 reward = _amount.mul(refRewards[i]).div(1000);
        User storage referrerUser = users[referrer];
        referrerUser.levels.push(i);
        referrerUser.balance = referrerUser.balance.add(reward);
        totalStaked = totalStaked.add(reward);
        referrer = referrerUser.referrer;
    }
}

function stake(uint256 _amount, address _referrer) external {
    require(!registered[msg.sender], "Already registered");
    require(_amount > 0, "Amount should be greater than 0");

    // Transfer tokens to the contract
    stakingToken.operatorSend(msg.sender, address(this), _amount, "", "");

    // Add the user to the user list if not already present
    if (!registered[msg.sender]) {
        userList.push(msg.sender);
        registered[msg.sender] = true;
    }

    // Initialize the user
    User storage user = users[msg.sender];
    user.balance = user.balance.add(_amount);
    user.referrer = _referrer;

    // Update the total staked amount
    totalStaked = totalStaked.add(_amount);

    // Distribute referral rewards
    address referrer = user.referrer;
    for (uint256 i = 0; i < refRewards.length && referrer != address(0); i++) {
        uint256 reward = _amount.mul(refRewards[i]).div(1000);
        User storage referrerUser = users[referrer];
        referrerUser.levels.push(i);
        referrerUser.balance = referrerUser.balance.add(reward);
        totalStaked = totalStaked.add(reward);
        referrer = referrerUser.referrer;
    }
}

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Sender.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ReferralStaking is IERC777Recipient, IERC777Sender {
    using SafeMath for uint256;

    struct User {
        uint256 balance;
        uint256[] levels;
        address referrer;
    }

    mapping(address => User) public users;
    mapping(address => bool) public registered;
    address[] public userList;
    uint256 public totalStaked;
    IERC777 public stakingToken;
    uint256[] public refRewards = [5, 3, 2, 1, 0.5, 0.5];

    constructor(IERC777 _stakingToken) {
        stakingToken = _stakingToken;
    }

    function stake(uint256 _amount, address _referrer) external {
        require(!registered[msg.sender], "Already registered");
        require(_amount > 0, "Amount should be greater than 0");

        // Transfer tokens to the contract
        stakingToken.send(address(this), _amount, "");

        // Add the user to the user list if not already present
        if (!registered[msg.sender]) {
            userList.push(msg.sender);
            registered[msg.sender] = true;
        }

        // Initialize the user
        User storage user = users[msg.sender];
        user.balance = user.balance.add(_amount);
        user.referrer = _referrer;

        // Update the total staked amount
        totalStaked = totalStaked.add(_amount);

        // Distribute referral rewards
        address referrer = user.referrer;
        for (uint256 i = 0; i < refRewards.length && referrer != address(0); i++) {
            uint256 reward = _amount.mul(refRewards[i]).div(100);
            User storage referrerUser = users[referrer];
            referrerUser.levels.push(i);
            referrerUser.balance = referrerUser.balance.add(reward);
            totalStaked = totalStaked.add(reward);
            referrer = referrerUser.referrer;
        }
    }

    function getUserLevels(address user) external view returns (uint256[] memory) {
        return users[user].levels;
    }

    function getUserBalance(address user) external view returns (uint256) {
        return users[user].balance;
    }

    function getTotalStaked() external view returns (uint256) {
        return totalStaked;
    }

    // IERC777Recipient implementation
    function tokensReceived(
        address /* operator */,
        address /* from */,
        address /* to */,
        uint256 amount,
        bytes calldata /* data */,
        bytes calldata /* operatorData */
    ) external override {
        require(msg.sender == address(stakingToken), "Invalid token");
        totalStaked = totalStaked.add(amount);
    }

    // IERC777Sender implementation
    function tokensToSend(
        address /* operator */,
        address /* from */,
        address /* to */,
        uint256 /* amount */,
        bytes calldata /* data */,
        bytes calldata /* operatorData */
    ) external override {
        // Do nothing
    }
}

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.5.0/contracts/token/ERC777/ERC777.sol";

contract StakingToken is ERC777 {
    
    address public defaultReferrer;
    mapping(address => address) public referrers;
    mapping(address => uint256) public referralsCount;
    mapping(address => uint256) public referrerLevel;

    uint256[] public referralRewards = [5, 3, 2, 1, 0.5, 0.5];
    
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        address[] memory defaultReferrerAddress
    ) ERC777(name, symbol, initialSupply, defaultReferrerAddress) {
        defaultReferrer = defaultReferrerAddress[0];
    }
    
    function stake(uint256 amount, address referrer) external {
        require(amount > 0, "Cannot stake 0");
        super._burn(msg.sender, amount, "", "");
        
        if (referrer == address(0)) {
            referrer = defaultReferrer;
        }
        
        address currentReferrer = referrer;
        for (uint256 i = 0; i < referralRewards.length; i++) {
            uint256 reward = amount * referralRewards[i] / 100;
            if (currentReferrer == address(0)) {
                break;
            }
            super._mint(currentReferrer, reward, "", "");
            referralsCount[currentReferrer]++;
            referrerLevel[msg.sender] = i + 1;
            currentReferrer = referrers[currentReferrer];
        }
        referrers[msg.sender] = referrer;
    }
    
}

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC777/ERC777.sol";

contract MyToken is ERC777 {

    // Define the referral structure
    struct Referral {
        address referrer;
        uint256 level;
    }

    // Define the referral rewards for each level
    uint256[] public referralRewards = [5, 3, 2, 1, 0.5, 0.5];

    // Mapping of addresses to their referral data
    mapping(address => Referral) public referrals;

    constructor(
        string memory name,
        string memory symbol,
        address[] memory defaultOperators
    ) ERC777(name, symbol, defaultOperators) {}

    // Function to register a referral
    function registerReferral(address referrer, uint256 level) public {
        // Ensure that the referral is not already registered
        require(referrals[msg.sender].referrer == address(0), "Referral already registered");

        // Ensure that the referral level is valid
        require(level < referralRewards.length, "Invalid referral level");

        // Register the referral
        referrals[msg.sender] = Referral(referrer, level);

        // Pay the referral reward to the referrer
        uint256 reward = (referralRewards[level] * balanceOf(msg.sender)) / 100;
        if (reward > 0) {
            _mint(referrer, reward, "", "");
        }
    }

    // Function to get the total referral reward for an address
    function getReferralReward(address addr) public view returns (uint256) {
        uint256 totalReward = 0;
        address referrer = referrals[addr].referrer;
        uint256 level = referrals[addr].level;
     
        while (referrer != address(0) && level < referralRewards.length) {
            uint256 reward = (referralRewards[level] * balanceOf(addr)) / 100;
            totalReward += reward;
            addr = referrer;
            referrer = referrals[addr].referrer;
            level = referrals[addr].level;
        }

        return totalReward;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenStakingReferral is Ownable, IERC777Recipient {
    struct Referral {
        address referrer;
        uint256 level;
    }

    IERC777 private _token;
    mapping(address => Referral) private _referrals;
    mapping(address => uint256) private _referralRewards;

    uint256 private constant _DECIMALS = 1e18;
    uint256 private constant _LEVEL1_REFERRAL_RATE = 50; // 5% referral rate
    uint256 private constant _LEVEL2_REFERRAL_RATE = 30; // 3% referral rate
    uint256 private constant _LEVEL3_REFERRAL_RATE = 20; // 2% referral rate
    uint256 private constant _LEVEL4_REFERRAL_RATE = 10; // 1% referral rate
    uint256 private constant _LEVEL5_REFERRAL_RATE = 5; // 0.5% referral rate
    uint256 private constant _LEVEL6_REFERRAL_RATE = 5; // 0.5% referral rate

    constructor(address tokenAddress) {
        _token = IERC777(tokenAddress);
    }

    function setReferrer(address referrer) external {
        require(_referrals[msg.sender].referrer == address(0), "Referrer already set");
        require(referrer != msg.sender, "Cannot refer yourself");
        require(referrer != address(0), "Invalid referrer address");
        _referrals[msg.sender] = Referral(referrer, _referrals[referrer].level + 1);
    }

    function getReferralLevel(address account) public view returns (uint256) {
        return _referrals[account].level;
    }

    function getReferralReward(address account) public view returns (uint256) {
        return _referralRewards[account];
    }

    function receive777(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external override {
        if (_referrals[to].referrer != address(0)) {
            uint256 referralReward = 0;
            uint256 referrerLevel = _referrals[to].level;
            if (referrerLevel == 1) {
                referralReward = (amount * _LEVEL1_REFERRAL_RATE) / 1000;
            } else if (referrerLevel == 2) {
                referralReward = (amount * _LEVEL2_REFERRAL_RATE) / 1000;
            } else if (referrerLevel == 3) {
                referralReward = (amount * _LEVEL3_REFERRAL_RATE) / 1000;
            } else if (referrerLevel == 4) {
                referralReward = (amount * _LEVEL4_REFERRAL_RATE) / 1000;
            } else if (referrerLevel == 5) {
                referralReward = (amount * _LEVEL5_REFERRAL_RATE) / 1000;
            } else if (referrerLevel == 6) {
                referralReward = (amount * _LEVEL6_REFERRAL_RATE) / 1000;
            }

            if (referralReward > 0) {
                _referralRewards[_referrals[to

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenStakingReferralSystem is IERC777Recipient, Ownable {
    struct Referral {
        address referrer;
        uint256 level;
    }

    IERC777 private token;
    mapping(address => Referral) private referrals;
    mapping(uint256 => uint256) private referralRewards;

    uint256 private constant NUM_LEVELS = 6;

    constructor(address _token) {
        token = IERC777(_token);

        // Set default referral rewards
        referralRewards[1] = 5; // 1st level - 5%
        referralRewards[2] = 3; // 2nd level - 3%
        referralRewards[3] = 2; // 3rd level - 2%
        referralRewards[4] = 1; // 4th level - 1%
        referralRewards[5] = 0.5; // 5th level - 0.5%
        referralRewards[6] = 0.5; // 6th level - 0.5%
    }

    function setReferralReward(uint256 level, uint256 reward) external onlyOwner {
        require(level > 0 && level <= NUM_LEVELS, "Invalid level");
        referralRewards[level] = reward;
    }

    function tokenReceived(address operator, address from, uint256 amount, bytes calldata data, bytes calldata) external override {
        require(msg.sender == address(token), "Invalid token");

        // Parse referral data from `data` parameter
        address referrer = address(0);
        uint256 level = 1;
        if (data.length == 64) { // Data is a 64-byte hex string representing the referrer's address and referral level
            assembly {
                referrer := mload(add(data, 32))
                level := mload(add(data, 64))
            }
        }

        // Update referral info for recipient
        referrals[from] = Referral(referrer, level);

        // Distribute referral rewards to all levels up to 6
        address currentReferrer = referrer;
        for (uint256 i = 1; i <= NUM_LEVELS && currentReferrer != address(0); i++) {
            uint256 reward = amount * referralRewards[i] / 100;
            token.send(currentReferrer, reward, "");

            currentReferrer = referrals[currentReferrer].referrer;
        }
    }
}
token.approve(address(stakingContract), 100);
token.send(address(stakingContract

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Sender.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract MyTokenStaking is IERC777Recipient, IERC777Sender {
    using SafeMath for uint256;

    address public tokenAddress;
    uint256 public totalStaked;
    uint256 public constant MIN_STAKE_AMOUNT = 1000 * 10 ** 18;
    uint256 public constant LEVEL1_REFERRAL_RATE = 5; // 5%
    uint256 public constant LEVEL2_REFERRAL_RATE = 3; // 3%
    uint256 public constant LEVEL3_REFERRAL_RATE = 2; // 2%
    uint256 public constant LEVEL4_REFERRAL_RATE = 1; // 1%
    uint256 public constant LEVEL5_REFERRAL_RATE = 5e15; // 0.5%
    uint256 public constant LEVEL6_REFERRAL_RATE = 5e15; // 0.5%

    mapping(address => uint256) public stakedBalances;
    mapping(address => address) public referrers;

    constructor(address _tokenAddress) {
        tokenAddress = _tokenAddress;
    }

    function stake(uint256 amount, address referrer) public {
        require(amount >= MIN_STAKE_AMOUNT, "Stake amount must be at least 1000 tokens");
        require(IERC777(tokenAddress).balanceOf(msg.sender) >= amount, "Insufficient balance");

        // Transfer tokens to this contract
        IERC777(tokenAddress).send(address(this), amount, "");

        // Update staked balances
        totalStaked = totalStaked.add(amount);
        stakedBalances[msg.sender] = stakedBalances[msg.sender].add(amount);

        // Set referrer
        if (referrer != address(0) && referrer != msg.sender) {
            referrers[msg.sender] = referrer;
        }

        // Distribute referral rewards
        distributeReferralRewards(amount, msg.sender);
    }

    function unstake(uint256 amount) public {
        require(amount <= stakedBalances[msg.sender], "Insufficient staked balance");

        // Update staked balances
        totalStaked = totalStaked.sub(amount);
        stakedBalances[msg.sender] = stakedBalances[msg.sender].sub(amount);

        // Transfer tokens back to user
        IERC777(tokenAddress).send(msg.sender, amount, "");
    }

    function distributeReferralRewards(uint256 amount, address staker) internal {
        address referrer = referrers[staker];

        if (referrer == address(0)) {
            // No referrer, all rewards go to the contract owner
            IERC777(tokenAddress).send(owner(), amount.mul(LEVEL1_REFERRAL_RATE).div(100), "");
        } else {
            // Distribute rewards to referrers
            uint256 totalRewards = 0;

            for (uint i = 0; i < 6; i++) {
                uint256 referralRate = getReferralRate(i);

                if (referralRate == 0) {
                    break;
                }

                address currentReferrer = referrer;
                referrer = referrers[currentReferrer];

                if (currentReferrer == address(0)) {
                    //

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ReferralStaking is IERC777Recipient, Ownable {
    struct Staker {
        uint256 balance;
        uint256[6] referralRewards;
        address referrer;
    }

    IERC777 private token;
    mapping(address => Staker) private stakers;

    uint256 private constant LEVEL1_REFERRAL_REWARD = 5;   // 5% for level 1
    uint256 private constant LEVEL2_REFERRAL_REWARD = 3;   // 3% for level 2
    uint256 private constant LEVEL3_REFERRAL_REWARD = 2;   // 2% for level 3
    uint256 private constant LEVEL4_REFERRAL_REWARD = 1;   // 1% for level 4
    uint256 private constant LEVEL5_REFERRAL_REWARD = 5e15; // 0.5% for level 5
    uint256 private constant LEVEL6_REFERRAL_REWARD = 5e15; // 0.5% for level 6

    event Staked(address indexed staker, uint256 amount);
    event Unstaked(address indexed staker, uint256 amount);
    event ReferralRewardPaid(address indexed staker, uint256 level, uint256 amount);

    constructor(IERC777 _token) {
        token = _token;
    }

    function stake(uint256 amount, address referrer) external {
        require(amount > 0, "Amount must be greater than 0");
        require(referrer != msg.sender, "Cannot refer yourself");

        Staker storage staker = stakers[msg.sender];
        if (staker.referrer == address(0) && referrer != address(0) && referrer != msg.sender) {
            staker.referrer = referrer;
        }

        token.send(msg.sender, amount, "");

        staker.balance += amount;
        emit Staked(msg.sender, amount);

        // pay referral rewards
        address currentReferrer = staker.referrer;
        for (uint256 i = 1; i <= 6 && currentReferrer != address(0); i++) {
            uint256 reward = amount * getReferralRewardRate(i) / 100;
            if (reward > 0) {
                stakers[currentReferrer].referralRewards[i - 1] += reward;
                emit ReferralRewardPaid(currentReferrer, i, reward);
            }
            currentReferrer = stakers[currentReferrer].referrer;
        }
    }

    function unstake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");

        Staker storage staker = stakers[msg.sender];
        require(staker.balance >= amount, "Insufficient balance");

        staker.balance -= amount;
        emit Unstaked(msg.sender, amount);

        token.send(msg.sender, amount, "");
    }

    function claimReferralRewards() external {
        Staker storage staker = stakers[msg.sender];
        for (uint256 i = 0; i < 6; i++) {
            uint256 reward = staker.referralRewards[i];
            if (reward > 0) {
                staker.referralRewards[i] = 0;
               

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Sender.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is IERC777Recipient, IERC777Sender, Ownable {
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public referrals;
    address[] public referralsList;

    IERC777 private _token;
    uint256 private _defaultReferralPercent = 5;
    uint256[] private _referralPercents = [5, 3, 2, 1, 0.5, 0.5];

    constructor(IERC777 token) {
        _token = token;
    }

    function stake(uint256 amount, address referral) external {
        require(amount > 0, "Amount must be greater than zero");
        require(referral != msg.sender, "Referral cannot be yourself");

        uint256 referralPercent = _getReferralPercent(referral);

        uint256 referralAmount = amount * referralPercent / 100;
        if (referralAmount > 0) {
            _token.send(referral, referralAmount, "");
            referrals[referral][msg.sender] += referralAmount;
            if (referrals[referral][msg.sender] == referralAmount) {
                referralsList.push(msg.sender);
            }
        }

        _token.operatorSend(msg.sender, address(this), amount, "", "");

        balances[msg.sender] += amount - referralAmount;
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        _token.send(msg.sender, amount, "");
    }

    function getReferralAmount(address referral, address staker) external view returns (uint256) {
        return referrals[referral][staker];
    }

    function getReferralList(address referral) external view returns (address[] memory) {
        address[] memory list = new address[](referralsList.length);
        uint256 count = 0;
        for (uint256 i = 0; i < referralsList.length; i++) {
            address staker = referralsList[i];
            if (referrals[referral][staker] > 0) {
                list[count] = staker;
                count++;
            }
        }
        address[] memory result = new address[](count);
        for (uint256 i = 0; i < count; i++) {
            result[i] = list[i];
        }
        return result;
    }

    function setDefaultReferralPercent(uint256 percent) external onlyOwner {
        _defaultReferralPercent = percent;
    }

    function setReferralPercents(uint256[] memory percents) external onlyOwner {
        _referralPercents = percents;
    }

    function _getReferralPercent(address referral) private view returns (uint256) {
        uint256 level = 0;
        address parent = referral;
        while (level < _referralPercents.length && parent != address(0)) {
            parent = _getParent(parent);
            level++;
        }
        if (level == 0) {
            return _defaultReferralPercent;
        } else if (level

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Sender.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is IERC777Recipient, IERC777Sender, Ownable {
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public referrals;
    address[] public referralsList;

    IERC777 private _token;
    uint256 private _defaultReferralPercent = 5;
    uint256[] private _referralPercents = [5, 3, 2, 1, 0.5, 0.5];

    constructor(IERC777 token) {
        _token = token;
    }

    function stake(uint256 amount, address referral) external {
        require(amount > 0, "Amount must be greater than zero");
        require(referral != msg.sender, "Referral cannot be yourself");

        uint256 referralPercent = _getReferralPercent(referral);

        uint256 referralAmount = amount * referralPercent / 100;
        if (referralAmount > 0) {
            _token.send(referral, referralAmount, "");
            referrals[referral][msg.sender] += referralAmount;
            if (referrals[referral][msg.sender] == referralAmount) {
                referralsList.push(msg.sender);
            }
        }

        _token.operatorSend(msg.sender, address(this), amount, "", "");

        balances[msg.sender] += amount - referralAmount;
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        _token.send(msg.sender, amount, "");
    }

    function getReferralAmount(address referral, address staker) external view returns (uint256) {
        return referrals[referral][staker];
    }

    function getReferralList(address referral) external view returns (address[] memory) {
        address[] memory list = new address[](referralsList.length);
        uint256 count = 0;
        for (uint256 i = 0; i < referralsList.length; i++) {
            address staker = referralsList[i];
            if (referrals[referral][staker] > 0) {
                list[count] = staker;
                count++;
            }
        }
        address[] memory result = new address[](count);
        for (uint256 i = 0; i < count; i++) {
            result[i] = list[i];
        }
        return result;
    }

    function setDefaultReferralPercent(uint256 percent) external onlyOwner {
        _defaultReferralPercent = percent;
    }

    function setReferralPercents(uint256[] memory percents) external onlyOwner {
        _referralPercents = percents;
    }

    function _getReferralPercent(address referral) private view returns (uint256) {
        uint256 level = 0;
        address parent = referral;
        while (level < _referralPercents.length && parent != address(0)) {
            parent = _getParent(parent);
            level++;
        }
        if (level == 0) {
            return _defaultReferralPercent;
        } else if (level

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC777, Ownable {
    mapping (address => uint256) public stakedTokens;
    mapping (address => address) public referrals;
    uint256 public constant STAKING_PERCENTAGE = 5;
    uint256 public constant LEVEL_TWO_PERCENTAGE = 3;
    uint256 public constant LEVEL_THREE_PERCENTAGE = 2;
    uint256 public constant LEVEL_FOUR_PERCENTAGE = 1;
    uint256 public constant LEVEL_FIVE_PERCENTAGE = 0.5;
    uint256 public constant LEVEL_SIX_PERCENTAGE = 0.5;

    constructor(
        string memory name,
        string memory symbol,
        address[] memory defaultOperators
    ) ERC777(name, symbol, defaultOperators) {}

    function stakeTokens(uint256 amount, address referral) public {
        require(balanceOf(msg.sender) >= amount, "Not enough tokens to stake");
        super._burn(msg.sender, amount, "", "");
        stakedTokens[msg.sender] += amount;
        if (referral != address(0) && referral != msg.sender) {
            referrals[msg.sender] = referral;
        }
    }

    function getReferralRewards() public {
        uint256 totalRewards = getReferralRewards(msg.sender);
        require(totalRewards > 0, "No rewards to claim");
        stakedTokens[msg.sender] += totalRewards;
        emit Transfer(address(0), msg.sender, totalRewards);
    }

    function getReferralRewards(address staker) public view returns (uint256) {
        uint256 totalRewards = 0;
        address referral = referrals[staker];
        if (referral != address(0)) {
            uint256 levelOneRewards = (stakedTokens[staker] * STAKING_PERCENTAGE) / 100;
            totalRewards += levelOneRewards;
            address levelTwoReferral = referrals[referral];
            if (levelTwoReferral != address(0)) {
                uint256 levelTwoRewards = (stakedTokens[staker] * LEVEL_TWO_PERCENTAGE) / 100;
                totalRewards += levelTwoRewards;
                address levelThreeReferral = referrals[levelTwoReferral];
                if (levelThreeReferral != address(0)) {
                    uint256 levelThreeRewards = (stakedTokens[staker] * LEVEL_THREE_PERCENTAGE) / 100;
                    totalRewards += levelThreeRewards;
                    address levelFourReferral = referrals[levelThreeReferral];
                    if (levelFourReferral != address(0)) {
                        uint256 levelFourRewards = (stakedTokens[staker] * LEVEL_FOUR_PERCENTAGE) / 100;
                        totalRewards += levelFourRewards;
                        address levelFiveReferral = referrals[levelFourReferral];
                        if (levelFiveReferral != address(0)) {
                            uint256 levelFiveRewards = (stakedTokens[staker] * LEVEL_FIVE_PERCENTAGE) / 100;
                            totalRewards += levelFiveRewards;
                            address levelSixReferral = referrals[levelFiveReferral];
                            if (levelSixReferral != address(0)) {
                                uint256 levelSixRewards = (stakedTokens[staker] * LEVEL_SIX_PERCENTAGE) / 100;
                                totalRewards += levelSixRewards;
                           

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Sender.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenStakingReferral is Ownable, IERC777Recipient, IERC777Sender {
    struct ReferralLevel {
        uint256 rewardPercentage;
        address[] members;
        mapping(address => bool) memberExists;
    }

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => address) private _referral;

    IERC777 private _token;
    uint256 private _stakingPercentage;
    ReferralLevel[6] private _referralLevels;

    constructor(IERC777 token_, uint256 stakingPercentage_) {
        _token = token_;
        _stakingPercentage = stakingPercentage_;

        // Set referral rewards for each level
        _referralLevels[0] = ReferralLevel({rewardPercentage: 500, members: new address[](0)});
        _referralLevels[1] = ReferralLevel({rewardPercentage: 300, members: new address[](0)});
        _referralLevels[2] = ReferralLevel({rewardPercentage: 200, members: new address[](0)});
        _referralLevels[3] = ReferralLevel({rewardPercentage: 100, members: new address[](0)});
        _referralLevels[4] = ReferralLevel({rewardPercentage: 50, members: new address[](0)});
        _referralLevels[5] = ReferralLevel({rewardPercentage: 50, members: new address[](0)});
    }

    function stake(uint256 amount, address referral_) external {
        require(amount > 0, "TokenStakingReferral: cannot stake zero tokens");
        require(_token.balanceOf(msg.sender) >= amount, "TokenStakingReferral: insufficient balance");
        require(_token.allowance(msg.sender, address(this)) >= amount, "TokenStakingReferral: insufficient allowance");

        // Transfer tokens to contract and update balance
        _token.send(address(this), amount, "");

        _balances[msg.sender] += amount;

        // Check if referral exists
        if (referral_ != address(0) && referral_ != msg.sender && _balances[referral_] > 0) {
            _referral[msg.sender] = referral_;
            _addReferralMember(referral_, msg.sender);
        }

        // Update referrals for all levels
        address referrer = _referral[msg.sender];
        for (uint256 i = 0; i < 6 && referrer != address(0); i++) {
            uint256 rewardAmount = amount * _stakingPercentage * _referralLevels[i].rewardPercentage / 10000;

            _balances[referrer] += rewardAmount;

            referrer = _referral[referrer];
        }
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "TokenStakingReferral: cannot withdraw zero tokens");
        require(_balances[msg.sender] >= amount, "TokenStakingReferral: insufficient balance");

        _balances[msg.sender] -= amount;

        // Transfer tokens to sender
        _token.send(msg.sender, amount, "");
    }

    function balanceOf(address account) external view returns (uint

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.6.0/contracts/token/ERC777/IERC777.sol";

contract StakingReferralSystem {
    
    mapping(address => uint256) public referrals;  // track referral levels for each user
    mapping(uint256 => uint256) public referralRewards;  // referral reward percentages for each level
    
    IERC777 public token;  // the ERC777 token contract used for staking and rewards
    
    constructor(IERC777 _token) {
        token = _token;
        
        // set default referral rewards for each level
        referralRewards[1] = 5;
        referralRewards[2] = 3;
        referralRewards[3] = 2;
        referralRewards[4] = 1;
        referralRewards[5] = 0.5;
        referralRewards[6] = 0.5;
    }
    
    function stake(uint256 amount, address referrer) external {
        // transfer the staking amount from the user to this contract
        token.send(msg.sender, address(this), amount, "", "");
        
        // update referral levels for the user and their referrer
        for (uint256 i = 1; i <= 6; i++) {
            if (referrer == address(0)) break;
            referrals[msg.sender] = i;
            token.send(address(this), referrer, amount * referralRewards[i] / 100, "", "");
            referrer = getReferrer(referrer);
        }
    }
    
    function getReferrer(address user) internal view returns (address) {
        // get the referrer for a user based on their referral level
        for (uint256 i = 1; i < referrals[user]; i++) {
            user = getReferrer(user);
        }
        return user;
    }
    
}

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC777, Ownable {
    address public defaultAddress;
    mapping(address => uint256) public stake;
    mapping(address => address) public referral;
    
    constructor(
        string memory _name,
        string memory _symbol,
        address _defaultAddress,
        address[] memory _defaultRecipients,
        uint256[] memory _defaultAmounts
    ) ERC777(_name, _symbol, _defaultRecipients, _defaultAmounts) {
        defaultAddress = _defaultAddress;
    }
    
    function stakeTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Not enough balance to stake");
        stake[msg.sender] += amount;
        transfer(defaultAddress, amount);
    }
    
    function unstakeTokens(uint256 amount) public {
        require(stake[msg.sender] >= amount, "Not enough stake to withdraw");
        stake[msg.sender] -= amount;
        transfer(msg.sender, amount);
    }
    
    function refer(address referee) public {
        referral[referee] = msg.sender;
    }
    
    function transfer(address recipient, uint256 amount) public override {
        if (referral[recipient] != address(0)) {
            // If the recipient has a referrer, transfer 1% to the referrer
            uint256 referrerReward = amount / 100;
            super.transfer(referral[recipient], referrerReward);
            amount -= referrerReward;
        }
        super.transfer(recipient, amount);
    }
}

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakingReferralSystem is Ownable {
    ERC777 public token;

    mapping(address => address) public referrals;
    mapping(address => uint256) public stakes;

    uint256 public constant REFERRAL_BONUS_PERCENT = 5;
    address public constant DEFAULT_REFERRER = address(0x0);

    event Referral(address indexed referrer, address indexed referee);

    constructor(address _tokenAddress) {
        token = ERC777(_tokenAddress);
    }

    function stake(uint256 amount, address referrer) external {
        require(amount > 0, "Amount must be greater than 0");
        require(token.balanceOf(msg.sender) >= amount, "Insufficient balance");

        if (referrals[msg.sender] == address(0x0) && referrer != address(0x0) && referrer != msg.sender) {
            referrals[msg.sender] = referrer;
            emit Referral(referrer, msg.sender);
        }

        if (stakes[msg.sender] == 0 && referrals[msg.sender] == address(0x0)) {
            referrals[msg.sender] = DEFAULT_REFERRER;
            emit Referral(DEFAULT_REFERRER, msg.sender);
        }

        if (referrals[msg.sender] != address(0x0)) {
            uint256 referralBonus = amount * REFERRAL_BONUS_PERCENT / 100;
            token.send(referrals[msg.sender], referralBonus, "");
        }

        token.send(address(this), amount, "");

        stakes[msg.sender] += amount;
    }

    function unstake(uint256 amount) external {
        require(stakes[msg.sender] >= amount, "Insufficient stake");

        stakes[msg.sender] -= amount;

        token.send(msg.sender, amount, "");
    }
}

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ReferralSystem is Ownable {
    IERC777 private token;
    mapping (address => mapping(uint256 => uint256)) private referralRewards;

    event ReferralRewardsSet(address indexed referrer, uint256 indexed level, uint256 reward);

    constructor(address _token) {
        require(_token != address(0), "Invalid token address");
        token = IERC777(_token);
    }

    function setReferralRewards(address[] calldata _referrers, uint256[] calldata _levels, uint256[] calldata _rewards) external onlyOwner {
        require(_referrers.length == _levels.length && _levels.length == _rewards.length, "Invalid input lengths");

        for (uint256 i = 0; i < _referrers.length; i++) {
            referralRewards[_referrers[i]][_levels[i]] = _rewards[i];
            emit ReferralRewardsSet(_referrers[i], _levels[i], _rewards[i]);
        }
    }

    function claimReferralRewards(uint256 amount) external {
        require(amount > 0, "Invalid amount");

        address referrer = msg.sender;
        uint256 totalRewards = 0;

        for (uint256 i = 1; i <= 6; i++) {
            uint256 reward = referralRewards[referrer][i];
            if (reward > 0) {
                totalRewards += reward * amount / 10000;
                referrer = owner();
            } else {
                break;
            }
        }

        require(totalRewards > 0, "No rewards to claim");
        token.send(msg.sender, totalRewards, "");
    }
}

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ReferralSystem is Ownable {
    IERC777 private token;
    mapping (address => uint256) private referralRewards;

    event ReferralRewardsSet(address indexed referrer, uint256 reward);

    function setToken(address _token) external onlyOwner {
        require(_token != address(0), "Invalid token address");
        token = IERC777(_token);
    }

    function setReferralRewards(address[] calldata _referrers, uint256[] calldata _rewards) external onlyOwner {
        require(_referrers.length == _rewards.length, "Invalid input lengths");

        for (uint256 i = 0; i < _referrers.length; i++) {
            referralRewards[_referrers[i]] = _rewards[i];
            emit ReferralRewardsSet(_referrers[i], _rewards[i]);
        }
    }

    function claimReferralRewards(uint256 amount) external {
        require(amount > 0, "Invalid amount");

        address referrer = msg.sender;
        uint256 totalRewards = 0;

        while (referrer != address(0)) {
            uint256 reward = referralRewards[referrer];
            if (reward > 0) {
                totalRewards += reward;
            }
            referrer = owner();
        }

        require(totalRewards > 0, "No rewards to claim");
        token.send(msg.sender, amount * totalRewards / 1000, "");
    }
}

pragma solidity ^0.8.0;

contract ReferralSystem {
    mapping(address => address) public referrals;
    mapping(address => uint256) public referralRewards;
    
    event ReferralReward(address indexed referrer, address indexed referral, uint256 reward);
    
    function setReferral(address _referral) external {
        require(referrals[msg.sender] == address(0), "You have already referred someone");
        require(_referral != msg.sender, "You cannot refer yourself");
        referrals[msg.sender] = _referral;
    }
    
    function getReferralReward() external {
        address referrer = referrals[msg.sender];
        require(referrer != address(0), "You do not have a referrer");
        uint256 reward = referralRewards[referrer];
        require(reward > 0, "Referrer does not have any reward to give");
        referralRewards[referrer] = 0;
        payable(msg.sender).transfer(reward);
        emit ReferralReward(referrer, msg.sender, reward);
    }
    
    function addReferralReward(address _referrer, uint256 _reward) external {
        referralRewards[_referrer] += _reward;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ERC777 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract StakingERC777 {
    address public tokenAddress;
    mapping(address => address) public referrer;
    uint256[] public referralRewards = [500, 300, 200, 100, 50, 50];
    uint256 public referralLevel = 6;

    constructor(address _tokenAddress) {
        tokenAddress = _tokenAddress;
    }

    function stake(uint256 amount, address referrerAddress) public {
        require(amount > 0, "Amount must be greater than zero");
        ERC777 token = ERC777(tokenAddress);
        token.transferFrom(msg.sender, address(this), amount);

        if (referrerAddress != address(0) && referrerAddress != msg.sender && referrer[msg.sender] == address(0)) {
            referrer[msg.sender] = referrerAddress;
        }

        uint256 reward = amount * referralRewards[0];
        address currentReferrer = referrer[msg.sender];
        for (uint256 i = 0; i < referralLevel && currentReferrer != address(0); i++) {
            ERC777 tokenRef = ERC777(tokenAddress);
            tokenRef.transfer(currentReferrer, reward);
            reward = amount * referralRewards[i+1];
            currentReferrer = referrer[currentReferrer];
        }
    }
}

pragma solidity ^0.8.0;

contract ReferralSystem {
    mapping(address => uint256) public referralLevels;
    mapping(address => address) public referrers;

    function stake(uint256 amount) external {
        // code to stake the ERC777 token
        // ...

        // update referral levels and referrers
        address referrer = referrers[msg.sender];
        if (referrer != address(0)) {
            referralLevels[msg.sender] = referralLevels[referrer] + 1;
        }
    }

    function setReferrer(address referrer) external {
        require(referrer != msg.sender, "Cannot refer yourself");
        require(referrers[msg.sender] == address(0), "Referrer already set");
        require(referrer != address(0), "Invalid referrer address");

        referrers[msg.sender] = referrer;
    }

    function getReferralReward() external {
        uint256 amount = // calculate the staking rewards
        uint256 referralLevel = referralLevels[msg.sender];
        if (referralLevel >= 1) {
            address referrer = referrers[msg.sender];
            uint256 referralReward = 0;
            if (referralLevel == 1) {
                referralReward = amount * 5 / 100;
            } else if (referralLevel == 2) {
                referralReward = amount * 3 / 100;
            } else if (referralLevel == 3) {
                referralReward = amount * 2 / 100;
            } else if (referralLevel == 4) {
                referralReward = amount * 1 / 100;
            } else if (referralLevel == 5 || referralLevel == 6) {
                referralReward = amount * 1 / 200;
            }
            // code to transfer the referral reward to the referrer
            // ...
        }
    }
}

// Referral system smart contract

contract ReferralSystem {
    
    mapping(address => address) public referrer; // mapping of addresses to their referrers
    mapping(address => uint) public level; // mapping of addresses to their referral levels
    mapping(address => uint) public rewards; // mapping of addresses to their rewards earned
    
    uint public totalRewards; // total rewards earned by all users
    
    ERC777Token token; // ERC777 token contract instance
    
    // constructor to set the ERC777 token contract instance
    constructor(address _tokenAddress) public {
        token = ERC777Token(_tokenAddress);
    }
    
    // function to stake tokens and assign referrer and referral level
    function stakeTokens(address _referrer, uint _amount) public {
        require(token.balanceOf(msg.sender) >= _amount, "Insufficient balance");
        require(token.allowance(msg.sender, address(this)) >= _amount, "Insufficient allowance");
        require(_referrer != msg.sender, "Cannot refer yourself");
        require(referrer[msg.sender] == address(0), "Already referred");
        
        // assign referrer and referral level
        referrer[msg.sender] = _referrer;
        level[msg.sender] = level[_referrer] + 1;
        
        // transfer tokens and calculate rewards
        token.transferFrom(msg.sender, address(this), _amount);
        uint reward = calculateReward(_amount, level[msg.sender]);
        rewards[_referrer] += reward;
        totalRewards += reward;
    }
    
    // function to calculate the reward based on the staked amount and referral level
    function calculateReward(uint _amount, uint _level) internal pure returns (uint) {
        if (_level == 1) {
            return _amount * 5 / 100;
        } else if (_level == 2) {
            return _amount * 3 / 100;
        } else if (_level == 3) {
            return _amount * 2 / 100;
        } else if (_level == 4) {
            return _amount * 1 / 100;
        } else if (_level == 5 || _level == 6) {
            return _amount * 1 / 200;
        } else {
            return 0;
        }
    }
    
    // function to withdraw rewards
    function withdrawRewards() public {
        uint reward = rewards[msg.sender];
        require(reward > 0, "No rewards to withdraw");
        
        rewards[msg.sender] = 0;
        token.transfer(msg.sender, reward);
    }
    
}

// ERC777 token contract interface

interface ERC777Token {
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    function transfer(address recipient, uint amount) external returns (bool);
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ERC777 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract ReferralSystem {
    address public tokenAddress;
    mapping(address => uint256) public referrals;
    uint256[] public referralRewards = [500, 300, 200, 100, 50, 50];
    uint256 public referralLevel = 6;

    constructor(address _tokenAddress) {
        tokenAddress = _tokenAddress;
    }

    function stake(uint256 amount, address referrer) public {
        require(amount > 0, "Amount must be greater than zero");
        ERC777 token = ERC777(tokenAddress);
        token.transferFrom(msg.sender, address(this), amount);

        if (referrer != address(0) && referrer != msg.sender && referrals[msg.sender] == 0) {
            referrals[msg.sender] = referrals[referrer] + 1;
        }

        uint256 reward = amount * referralRewards[referrals[msg.sender]];
        for (uint256 i = 0; i < referralLevel; i++) {
            address ref = referrer;
            for (uint256 j = 0; j < i; j++) {
                ref = getReferrer(ref);
            }
            if (ref == address(0)) {
                break;
            }
            ERC777 tokenRef = ERC777(tokenAddress);
            tokenRef.transfer(ref, reward);
        }
    }

    function getReferrer(address account) public view returns (address) {
        if (referrals[account] > 0) {
            for (uint256 i = 1; i <= referralLevel; i++) {
                address ref = account;
                for (uint256 j = 0; j < i; j++) {
                    ref = getReferrer(ref);
                }
                if (referrals[ref] >= i) {
                    return ref;
                }
            }
        }
        return address(0);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ERC777 {
    function send(address recipient, uint256 amount, bytes memory data) external;
    function balanceOf(address account) external view returns (uint256);
}

contract ReferralSystem {
    address public owner;
    ERC777 public token;

    mapping(address => uint256) public referrer;
    mapping(address => uint256) public referrals;
    mapping(uint256 => uint256) public referralRewards;

    constructor(address _token) {
        owner = msg.sender;
        token = ERC777(_token);
        referralRewards[1] = 500; // 5%
        referralRewards[2] = 300; // 3%
        referralRewards[3] = 200; // 2%
        referralRewards[4] = 100; // 1%
        referralRewards[5] = 50; // 0.5%
        referralRewards[6] = 50; // 0.5%
    }

    function stake(uint256 amount, address referrerAddress) public {
        require(amount > 0, "Amount must be greater than 0");

        // Transfer tokens from user to contract
        token.send(address(this), amount, "");

        // Calculate referral rewards
        uint256 totalRewards = 0;
        address currentReferrer = referrerAddress;
        for (uint256 i = 1; i <= 6; i++) {
            if (currentReferrer == address(0)) {
                break;
            }
            uint256 reward = amount * referralRewards[i] / 10000; // Divide by 10000 to convert from basis points to percentage
            totalRewards += reward;
            referrals[currentReferrer] += 1;
            currentReferrer = referrer[currentReferrer];
        }

        // Distribute referral rewards
        uint256 remainingRewards = totalRewards;
        currentReferrer = referrerAddress;
        for (uint256 i = 1; i <= 6; i++) {
            if (currentReferrer == address(0)) {
                break;
            }
            uint256 reward = remainingRewards * referralRewards[i] / 10000;
            token.send(currentReferrer, reward, "");
            remainingRewards -= reward;
            currentReferrer = referrer[currentReferrer];
        }
    }

    function setReferrer(address referrerAddress) public {
        require(referrals[msg.sender] == 0, "Referrer can only be set once");
        require(referrerAddress != address(0), "Referrer cannot be 0x0");
        require(referrerAddress != msg.sender, "Cannot refer yourself");
        require(referrals[referrerAddress] > 0, "Referrer must have at least one referral");

        referrer[msg.sender] = referrerAddress;
    }

    function withdraw(uint256 amount) public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(amount <= token.balanceOf(address(this)), "Insufficient balance");

        token.send(owner, amount, "");
    }
}

contract StakingReferralSystem {
    mapping(address => address) public referrals;
    // mapping(address => uint256) public rewards;
    
    uint256 public constant COMMISSION_RATE_LEVEL1 = 5;
    uint256 public constant COMMISSION_RATE_LEVEL2 = 3;
    uint256 public constant COMMISSION_RATE_LEVEL3 = 2;
    uint256 public constant COMMISSION_RATE_LEVEL4 = 1;
    uint256 public constant COMMISSION_RATE_LEVEL5 = 0.5;
    uint256 public constant COMMISSION_RATE_LEVEL6 = 0.5;
    
    function stake(uint256 amount) public {
        // Stake the tokens and track the rewards earned
        // by the staker
        // rewards[msg.sender] += amount;
        
        // Check if the staker was referred by another user
        address referrer = referrals[msg.sender];
        if (referrer != address(0)) {
            // Calculate the commission for the referrer at each level
            uint256 commission = 0;
            uint256 totalCommission = 0;
            for (uint256 i = 1; i <= 6; i++) {
                if (referrer == address(0)) {
                    break;
                }
                if (i == 1) {
                    commission = (amount * COMMISSION_RATE_LEVEL1) / 100;
                } else if (i == 2) {
                    commission = (amount * COMMISSION_RATE_LEVEL2) / 100;
                } else if (i == 3) {
                    commission = (amount * COMMISSION_RATE_LEVEL3) / 100;
                } else if (i == 4) {
                    commission = (amount * COMMISSION_RATE_LEVEL4

contract StakingDirectReferralSystem {
    mapping(address => address) public directReferrals;
    mapping(address => uint256) public rewards;
    
    uint256 public constant COMMISSION_RATE_LEVEL1 = 5;
    uint256 public constant COMMISSION_RATE_LEVEL2 = 3;
    uint256 public constant COMMISSION_RATE_LEVEL3 = 2;
    uint256 public constant COMMISSION_RATE_LEVEL4 = 1;
    uint256 public constant COMMISSION_RATE_LEVEL5 = 0.5;
    uint256 public constant COMMISSION_RATE_LEVEL6 = 0.5;
    
    function stake(uint256 amount) public {
        // Stake the tokens and track the rewards earned
        // by the staker
        rewards[msg.sender] += amount;
        
        // Check if the staker was directly referred by another user
        address directReferrer = directReferrals[msg.sender];
        if (directReferrer != address(0)) {
            // Calculate the commission for the direct referrer at each level
            uint256 commission = 0;
            uint256 totalCommission = 0;
            for (uint256 i = 1; i <= 6; i++) {
                if (i == 1) {
                    commission = (amount * COMMISSION_RATE_LEVEL1) / 100;
                } else if (i == 2) {
                    commission = (amount * COMMISSION_RATE_LEVEL2) / 100;
                } else if (i == 3) {
                    commission = (amount * COMMISSION_RATE_LEVEL3) / 100;
                } else if (i == 4) {
                    commission = (amount * COMMISSION_RATE_LEVEL4) / 100;
                } else if (i == 5) {
                    commission = (amount * COMMISSION_RATE_LEVEL5) / 100;
                } else if (i == 6) {
                    commission = (amount * COMMISSION_RATE_LEVEL6) / 100;
                }
                
                // Credit the commission to the direct referrer's account
                rewards[directReferrer] += commission;
                totalCommission += commission;
                
                //

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";

contract GLDToken is ERC777 {
    constructor(uint256 initialSupply, address[] memory defaultOperators)
        ERC777("Gold", "GLD", defaultOperators)
    {
        _mint(msg.sender, initialSupply, "", "");
    }

    mapping(address => address) public referrers;
    uint[] public commissionRates = [5, 3, 2, 1, 0.5, 0.5];

    function stake(uint amount) public {
        // Transfer tokens to contract
        _transfer(msg.sender, address(this), amount);

        // Check if staker was referred
        address referrer = referrers[msg.sender];
        if (referrer != address(0)) {
            // Calculate and credit referral commission for level 1
            uint commission = amount * commissionRates[0] / 100;
            _transfer(address(this), referrer, commission);

            // Calculate and credit referral commissions for levels 2 to 6
            for (uint i = 1; i < commissionRates.length; i++) {
                referrer = referrers[referrer];
                if (referrer == address(0)) {
                    break;
                }
                commission = amount * commissionRates[i] / 100;
                _transfer(address(this), referrer, commission);
            }
        }

        // TODO: add staking functionality and rewards distribution
    }}

    // function setReferrer(address staker, address referrer) public {
    //     require(referrers[staker] == address(0), "Staker already has a referrer");
    //     require(staker != referrer, "Staker and referrer cannot be the same");

    //     referrers[staker] = referrer;
    // }

    // function withdraw(uint amount) public {
    //     // Calculate referral commissions earned by referrers
    //     address referrer = referrers[msg.sender];
    //     for (uint i =

// contract StakingReferCode {
//     IERC777 public token; 
//     // uint256 public commission;
//     mapping(address => uint256) private _referralBalances;
//     mapping(address => uint256) private _balances;
//     mapping(address => mapping(address => uint256)) private _allowances;

//     address private _defaultReferralAddress;

//     struct ReferralLevel {
//         uint256 commissionRate;
//         address[] referrals;
//     }
// mapping(address => ReferralAccount) private _referralAccounts;

// struct ReferralAccount {
//     uint256 totalCommission;
//     address referralAddress;
//     uint256 commissionRate;
// }
    
//     mapping(uint256 => ReferralLevel) private _referralLevels;
    
//     event ReferralCommissionPaid(
//         address indexed payer,
//         address indexed recipient,
//         uint256 amount,
//         uint256 level
//     );

//     constructor(IERC777 _token) {
//         token = _token;
//         _defaultReferralAddress = msg.sender;
        
//         _referralLevels[1].commissionRate = 500;
//         _referralLevels[2].commissionRate = 300;
//         _referralLevels[3].commissionRate = 200;
//         _referralLevels[4].commissionRate = 100;
//         _referralLevels[5].commissionRate = 50;
//         _referralLevels[6].commissionRate = 50;
//     }

//     function registerDefaultReferralAddress(address defaultReferralAddress) external {
//         require(msg.sender == _defaultReferralAddress, "Only the default referral address can register a new default referral address");
//         _defaultReferralAddress = defaultReferralAddress;
//     }

//     function stake(uint256 amount) external {
//         require(amount > 0, "Staked amount must be greater than zero");

//         token.transferFrom(msg.sender, address(this), amount);
//         _balances[msg.sender] += amount;
//         _updateReferralTree(msg.sender, _defaultReferralAddress, amount);
//     }

//     function withdraw(uint256 amount) external {
//         require(amount > 0, "Withdrawal amount must be greater than zero");
//         require(_balances[msg.sender] >= amount, "Insufficient balance");

//         _balances[msg.sender] -= amount;
//         _updateReferralTree(msg.sender, address(0), amount);

//         token.transferFrom(address(this), msg.sender, amount);
//     }
//     function _updateReferralTree(address account, address referralAddress, uint256 amount) private {
//     address currentReferralAddress = referralAddress == address(0) ? _defaultReferralAddress : referralAddress;
//     uint256 totalCommission = 0;

//     for (uint256 i = 1; i <= 6; i++) {
//         address[] memory referrals = _referralLevels[i].referrals;

//         if (referrals.length == 0) {
//             continue;
//         }

//         uint256 commissionRate = _referralLevels[i].commissionRate;
//         uint256 commission = amount * commissionRate / 10000;

//         for (uint256 j = 0; j < referrals.length; j++) {
//             address referralAccount = referrals[j];
//             uint256 referralCommission = commission * _referralAccounts[referralAccount].commissionRate / 10000;

//             if (referralAccount == currentReferralAddress) {
//                 _referralAccounts[referralAccount].totalCommission += commission - referralCommission;
//             } else {
//                 _referralAccounts[referralAccount].totalCommission += referralCommission;
//             }
//             totalCommission += referralCommission;
//         }
//         currentReferralAddress = _referralAccounts[currentReferralAddress].referralAddress;
//     }

//     _referralAccounts[_defaultReferralAddress].totalCommission += commission + totalCommission;
// }



























    
// function _updateReferralTree(address account, address referralAddress, uint256 amount) private {
//     address currentReferralAddress = referralAddress == address(0) ? _defaultReferralAddress : referralAddress;
//     uint256 totalCommission = 0;

//     for (uint256 i = 1; i <= 6; i++) {
//         address[] memory referrals = _referralLevels[i].referrals;

//         if (referrals.length == 0) {
//             continue;
//         }

//         uint256 commissionRate = _referralLevels[i].commissionRate;
//         uint256 commission = amount * commissionRate / 10000;

//         for (uint256 j = 0; j < referrals.length; j++) {
//             address referral = referrals[j];

//             if (referral == currentReferralAddress) {
//                 uint256 commissionShare = commission / (referrals.length - j);
//                 totalCommission += commissionShare;
//                 _balances[referral] += commissionShare;
//                 emit ReferralCommissionPaid(referral, commissionShare);
//                 break;
//             }
//         }

//         if (_referralAccounts[currentReferralAddress].referralAddress == address(0)) {
//             break;
//         }

//         currentReferralAddress = _referralAccounts[currentReferralAddress].referralAddress;
//     }

//     if (totalCommission > 0) {
//         _balances[_defaultReferralAddress] += totalCommission;
//         emit ReferralCommissionPaid(_defaultReferralAddress, totalCommission);
//     }
// }

}

// interface IERC777 {
//     function burn(uint256 amount, bytes calldata data) external;
//     function send(address recipient, uint256 amount , bytes memory  data) external;                                                                                  
//     function balanceOf(address account) external view returns (uint256);
//     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
//     function transfer(address recipient, uint amount) external returns (bool);
// }

// contract MyToken  {
//     IERC777  public token; 
//     mapping(address=> uint256) private _referralBalances;
//     mapping(address => uint256) private _balances;
//     mapping(address => mapping(address => uint256)) private _allowances;

//     // Default referral address
//     address private _defaultReferralAddress;

//     // Referral levels and commission rates
//     struct ReferralLevel {
//         uint256 commissionRate;
//         address[] referrals;
//     }
//     mapping(uint256 => ReferralLevel) private _referralLevels;

//     // Event emitted when a referral commission is paid out
//     event ReferralCommissionPaid(
//         address indexed payer,
//         address indexed recipient,
//         uint256 amount,
//         uint256 level
//     );

//     constructor(IERC777 _token ,address defaultReferralAddress)
//     {
//         token = _token;
//         _defaultReferralAddress = defaultReferralAddress;
        
//         // Set up referral commission rates for each level
//         _referralLevels[1].commissionRate = 500;  // 5%
//         _referralLevels[2].commissionRate = 300;  // 3%
//         _referralLevels[3].commissionRate = 200;  // 2%
//         _referralLevels[4].commissionRate = 100;  // 1%
//         _referralLevels[5].commissionRate = 50;   // 0.5%
//         _referralLevels[6].commissionRate = 50;   // 0.5%
//     }

//     function registerDefaultReferralAddress(address defaultReferralAddress) external  {
//         _defaultReferralAddress = defaultReferralAddress;
//     }

//     function stake(uint256 amount, address referralAddress) external {
//         require(amount > 0, "Staked amount must be greater than zero");
//         require(referralAddress != msg.sender, "Cannot refer yourself");

//         // Transfer tokens from sender to this contract
//         token.transferFrom(msg.sender, address(this), amount);

//         // Update balances and referral tree
//         _balances[msg.sender] += amount;
//         _updateReferralTree(msg.sender, referralAddress, amount);
//     }

//     function withdraw(uint256 amount) external {
//         require(amount > 0, "Withdrawal amount must be greater than zero");
//         require(_balances[msg.sender] >= amount, "Insufficient balance");

//         // Update balances and referral tree
//         _balances[msg.sender] -= amount;
//         _updateReferralTree(msg.sender, address(0), amount);

//         // Transfer tokens from this contract to sender
//         token.transferFrom(address(this), msg.sender, amount);
//     }

//  function _updateReferralTree(address account, address referralAddress, uint256 amount) private {
//     address currentReferralAddress = referralAddress == address(0) ? _defaultReferralAddress : referralAddress;
//     uint256 totalCommission = 0;

//     // Update referral balances and emit events for each level
//     for (uint256 i = 1; i <= 6; i++) {
//         address referral = _referralLevels[i].referrals.length > 0 ? _referralLevels[i].referrals[0] : address(0);
//         uint256 commission = amount * _referralLevels[i].commissionRate / 10000;

//         if (referral != address(0)) {
//             _referralBalances[referral] += commission;
//             totalCommission += commission;
//             emit ReferralCommissionPaid(referral, account, commission, i);
//         } else {
//             totalCommission += commission;
//         }
//     }

//     // Update the account's referral balance
//     _referralBalances[currentReferralAddress] += totalCommission;
// }
// }

// create smart contract ERC777 refferal system staking with defualt address register 1_6 level [5%, 3%,2%,1%,0.5,0.5] in in solidity
// contract MyToken  {
//     IERC777 public token;
//     mapping(address => uint256) private _balances;
//     mapping(address => mapping(address => uint256)) private _allowances;

   
//     address private _defaultReferralAddress;

   
//     struct ReferralLevel {
//         uint256 commissionRate;
//         address[] referrals;
//     }
//     mapping(uint256 => ReferralLevel) private _referralLevels;

//     event ReferralCommissionPaid(
//         address indexed payer,
//         address indexed recipient,
//         uint256 amount,
//         uint256 level
//     );

//     constructor(IERC777 _token)
  
//     {
//         token = _token;
        
//         _referralLevels[1].commissionRate = 500;  
//         _referralLevels[2].commissionRate = 300;  
//         _referralLevels[3].commissionRate = 200;  
//         _referralLevels[4].commissionRate = 100; 
//         _referralLevels[5].commissionRate = 50;   
//         _referralLevels[6].commissionRate = 50;   
//     }

//     function registerDefaultReferralAddress(address defaultReferralAddress) external  {
//         _defaultReferralAddress = defaultReferralAddress;
//     }

//     function stake(uint256 amount, address referralAddress) public {
//         require(amount > 0, "Staked amount must be greater than zero");
//         require(referralAddress != msg.sender, "Cannot refer yourself");

//         // Transfer tokens from sender to this contract
//         token.transferFrom(msg.sender, address(this), amount);

//         // Update balances and referral tree
//         _balances[msg.sender] += amount;
//         _updateReferralTree(msg.sender, referralAddress, amount);
//     }

//     function withdraw(uint256 amount) external {
//         require(amount > 0, "Withdrawal amount must be greater than zero");
//         require(_balances[msg.sender] >= amount, "Insufficient balance");

//         // Update balances and referral tree
//         _balances[msg.sender] -= amount;
//         _updateReferralTree(msg.sender, address(0), amount);

//         // Transfer tokens from this contract to sender
//         token.transferFrom(address(this), msg.sender, amount);
//     }

// function _updateReferralTree(address account, address referralAddress, uint256 amount) private {
//     address currentReferralAddress = referralAddress == address(0) ? _defaultReferralAddress : referralAddress;

//     // Update referral balances and emit events for each level
//     for (uint256 i = 1; i <= 6; i++) {
//         address referral = _referralLevels[i].referrals.length > 0 ? _referralLevels[i].referrals[0] : address(0);
//         uint256 commission = amount * _referralLevels[i].commissionRate / 10000;

//         if (referral != address(0)) {
//             _referralBalances[referral] += commission;
//             emit ReferralCommissionPaid(account, referral, commission, i);
//         }

//         if (currentReferralAddress == address(0)) {
//             break;
//         }

//         _referralLevels[i].referrals.push(currentReferralAddress);
//         currentReferralAddress = _referralTree[currentReferralAddress].parent;

//         if (currentReferralAddress == address(0)) {
//             break;
//         }
//     }
// }


// }



 

// contract ReferralStaking {
//     using SafeMath for uint256;

//     struct User {
//         address referrer;
//         uint256[] levels;
//     }

//     mapping (address => User) public users;
//     mapping (uint256 => uint256) public levelPercents;
//     uint256 public constant MAX_LEVEL = 6;
//     IERC777 public token;

//     event NewUser(address indexed user, address indexed referrer);
//     event Staked(address indexed user, uint256 amount, address indexed referrer, uint256[] levels);
//     event Withdrawn(address indexed user, uint256 amount);

//     constructor(IERC777 _token) {
//         token = _token;
//         levelPercents[0] = 50;
//         levelPercents[1] = 30;
//         levelPercents[2] = 20;
//         levelPercents[3] = 10;
//         levelPercents[4] = 5;
//         levelPercents[5] = 5;
//     }

//     function register(address referrer) external {
//         require(users[msg.sender].referrer == address(0), "User already registered");
//         if (referrer != address(0) && users[referrer].referrer != address(0)) {
//             users[msg.sender].referrer = referrer;
//         }
//         users[msg.sender].levels = new uint256[](MAX_LEVEL);
//         emit NewUser(msg.sender, referrer);
//     }

//     function stake(uint256 amount) external {
//         require(amount > 0, "Invalid amount");
//         require(token.balanceOf(msg.sender) >= amount, "Insufficient balance");
//         token.transferFrom(msg.sender,address(this),amount);
//         users[msg.sender].levels[0] = amount.mul(levelPercents[0]).div(1000);
//         address referrer = users[msg.sender].referrer;
//         for (uint256 i = 1; i < MAX_LEVEL; i++) {
//             if (referrer == address(0)) {
//                 break;
//             }
//                uint256 percent = levelPercents[i];
//                users[referrer].levels[i] = users[referrer].levels[i].add(amount.mul(percent).div(1000));
//                referrer = users[referrer].referrer;
//         }
//         emit Staked(msg.sender, amount, users[msg.sender].referrer, users[msg.sender].levels);
//     }

//     function withdraw(uint256 amount) external {
//         require(amount > 0, "Invalid amount");
//         require(token.balanceOf(address(this)) >= amount, "Insufficient balance");
//         token.send(msg.sender, amount, "");
//         emit Withdrawn(msg.sender, amount);
//     }
// }


//  import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.5.0/contracts/token/ERC777/ERC777.sol";
// // import "@openzeppelin/contracts/access/Ownable.sol";

// contract MyToken is ERC777 {
//  address public owner;
//     mapping(address => uint256) private _balances;
//     mapping(address => mapping(address => uint256)) private _allowances;

//     // Default referral address
//     address private _defaultReferralAddress;

//     // Referral levels and commission rates
//     struct ReferralLevel {
//         uint256 commissionRate;
//         address[] referrals;
//     }
//     mapping(uint256 => ReferralLevel) private _referralLevels;

//     // Event emitted when a referral commission is paid out
//     event ReferralCommissionPaid(
//         address indexed payer,
//         address indexed recipient,
//         uint256 amount,
//         uint256 level
//     );

//     // constructor(string memory name, string memory symbol, uint256 initialSupply, address defaultReferralAddress)
//     //     ERC777(name, symbol, new address[](0))
//     // {
//     //     _defaultReferralAddress = defaultReferralAddress;
//     //      owner = msg.sender;
//     //     _mint(owner, initialSupply, "");
//     //     // Set up referral commission rates for each level
//     //     _referralLevels[1].commissionRate = 500;  // 5%
//     //     _referralLevels[2].commissionRate = 300;  // 3%
//     //     _referralLevels[3].commissionRate = 200;  // 2%
//     //     _referralLevels[4].commissionRate = 100;  // 1%
//     //     _referralLevels[5].commissionRate = 50;   // 0.5%
//     //     _referralLevels[6].commissionRate = 50;   // 0.5%
        
//     // }
//           constructor(
//         string memory name,string memory symbol,uint256 initialSupply,address[] memory defaultReferrerAddress) ERC777(name, symbol, defaultReferrerAddress) {
//            owner = msg.sender;

//         _mint(owner, initialSupply, "", ""); //     token = _token;
//         //     // Set up referral commission rates for each level
//         _referralLevels[1].commissionRate = 500;  // 5%
//         _referralLevels[2].commissionRate = 300;  // 3%
//         _referralLevels[3].commissionRate = 200;  // 2%
//         _referralLevels[4].commissionRate = 100;  // 1%
//         _referralLevels[5].commissionRate = 50;   // 0.5%
//         _referralLevels[6].commissionRate = 50;   // 0.5%
//     }

//     function registerDefaultReferralAddress(address defaultReferralAddress) external  {
//         _defaultReferralAddress = defaultReferralAddress;
//     }

//     function stake(uint256 amount, address referralAddress) external {
//         require(amount > 0, "Staked amount must be greater than zero");
//         require(referralAddress != msg.sender, "Cannot refer yourself");

//         // Transfer tokens from sender to this contract
//         transferFrom(msg.sender, address(this), amount);

//         // Update balances and referral tree
//         _balances[msg.sender] += amount;
//         _updateReferralTree(msg.sender, referralAddress, amount);
//     }

//     function withdraw(uint256 amount) external {
//         require(amount > 0, "Withdrawal amount must be greater than zero");
//         require(_balances[msg.sender] >= amount, "Insufficient balance");

//         // Update balances and referral tree
//         _balances[msg.sender] -= amount;
//         _updateReferralTree(msg.sender, address(0), amount);

//         // Transfer tokens from this contract to sender
//         transferFrom(address(this), msg.sender, amount);
//     }

               
// function _updateReferralTree(address account, address referralAddress, uint256 amount) private {
//     address currentReferralAddress = referralAddress == address(0) ? _defaultReferralAddress : referralAddress;
//     uint256 totalCommission = 0;

//     // Update referral balances and emit events for each level
//     for (uint256 i = 1; i <= 6; i++) {
//         address referral = _referralLevels[i].referrals.length > 0 ? _referralLevels[i].referrals[0] : address(0);
//         uint256 commission = amount * _referralLevels[i].commissionRate / 10000;

//         if (referral != address(0)) {
//             // Add commission to referral balance
//             _balances[referral] += commission;
//             totalCommission += commission;

//             // Emit event for referral commission paid out
//             emit ReferralCommissionPaid(account, referral, commission, i);

//             // Move to next level of referrals
//             for (uint256 j = 1; j < _referralLevels[i].referrals.length; j++) {
//                 referral = _referralLevels[i].referrals[j];
//                 commission = amount * _referralLevels[i].commissionRate / 10000 / _referralLevels[i].referrals.length;

//                 // Add commission to referral balance
//                 _balances[referral] += commission;
//                 totalCommission += commission;

//                 // Emit event for referral commission paid out
//                 emit ReferralCommissionPaid(account, referral, commission, i);
//             }
//         } else {
//             // No more referrals at this level
//             break;
//         }
//     }

//     // Add remaining commission to current referral address if any
//     if (totalCommission < amount && currentReferralAddress != address(0)) {
//         uint256 remainingCommission = amount - totalCommission;

//         // Add commission to referral balance
//         _balances[currentReferralAddress] += remainingCommission;

//         // Emit event for referral commission paid out
//         emit ReferralCommissionPaid(account, currentReferralAddress, remainingCommission, 0);
//     }
// }
// }

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.5.0/contracts/token/ERC777/ERC777.sol";

// contract StakingToken is ERC777 {
//     using SafeMath for uint256;

//     struct userInfo {
//         address referrer;
//         // uint256 totalUser;
//            uint256 totalDeposit;
//         uint256[] levels;
//          uint256 directsNum;
//     }
//     address public defaultReferrer = 0x352eCa551729265f2011E0c772a3CbBc32a220Fb;
//  address public owner;
//  address public totalUser;
//     mapping (address => userInfo) public UserInfomation;
//     mapping (uint256 => uint256) public levelPercents;
//     uint256 public constant MAX_LEVEL = 6;
//     IERC777 public token;

//     event NewUser(address indexed user, address indexed referrer);
//     event Staked(address indexed user, uint256 amount, address indexed referrer, uint256[] levels);
//     event Withdrawn(address indexed user, uint256 amount);

   
//       constructor(
//         string memory name,string memory symbol,uint256 initialSupply,address[] memory defaultReferrerAddress) ERC777(name, symbol, defaultReferrerAddress) {
//            owner = msg.sender;
    
//         _mint(owner, initialSupply, "", ""); //     token = _token;
//         levelPercents[0] = 50;
//         levelPercents[1] = 30;
//         levelPercents[2] = 20;
//         levelPercents[3] = 10;
//         levelPercents[4] = 5;
//         levelPercents[5] = 5;
//     }

//     // function register(address referrer) external {
//     //     require(users[msg.sender].referrer == address(0), "User already registered");
//     //     if (referrer != address(0) && users[referrer].referrer != address(0)) {
//     //         users[msg.sender].referrer = referrer;
//     //     }
//     //     users[msg.sender].levels = new uint256[](MAX_LEVEL);
//     //     emit NewUser(msg.sender, referrer);
//     // }
//       function registerDefultr(address _referral) public {
//     require(UserInfomation[_referral].totalDeposit > 0 || _referral == defaultReferrer, "invalid refer");
//     userInfo storage user = UserInfomation[msg.sender];
//     require(user.referrer == address(0), "referrer bonded");
//     user.referrer = _referral;
//     UserInfomation[user.referrer].directsNum = UserInfomation[user.referrer].directsNum.add(1);
    
//     // Update the team number for the caller
//     // _updateTeamNum(msg.sender);
//     // totalUser = totalUser.add(1);
// }

//     function stake(uint256 amount) external {
//         require(amount > 0, "Invalid amount");
//         require(token.balanceOf(msg.sender) >= amount, "Insufficient balance");
//         token.send(address(this), amount, "");
//         UserInfomation[msg.sender].levels[0] = amount.mul(levelPercents[0]).div(100);
//         address referrer = UserInfomation[msg.sender].referrer;
//         for (uint256 i = 1; i < MAX_LEVEL; i++) {
//             if (referrer == address(0)) {
//                 break;
//             }
//             uint256 percent = levelPercents[i];
//             UserInfomation[referrer].levels[i] = UserInfomation[referrer].levels[i].add(amount.mul(percent).div(100));
//             referrer = UserInfomation[referrer].referrer;
//         }
//         emit Staked(msg.sender, amount, UserInfomation[msg.sender].referrer, UserInfomation[msg.sender].levels);
//     }

//     function withdraw(uint256 amount) external {
//         require(amount > 0, "Invalid amount");
//         require(token.balanceOf(address(this)) >= amount, "Insufficient balance");
//         token.send(msg.sender, amount, "");
//         emit Withdrawn(msg.sender, amount);
//     }
//     function getReferralLevels(address user) external view returns (uint256[] memory) {
//     return UserInfomation[user].levels;
// }

// }


// create a smart contract ERC777 1st of defualt address register function staking refferal base system
// then next 1 to 6 level level_1 on 5% , level_2 on 3%, level_3 on 2% , level_4 on 1% , level_5 on 0.5%, level_6 on 0.5% in solidity  


