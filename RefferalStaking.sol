// SPDX-License-Identifier: MIT
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
contract StakingToken  {
     using SafeMath for uint256;
      struct UserInfo {
        address referrer;
        uint256 totalDeposit;
        uint256 directsNum;
    }

    address public owner;
     IERC777 public token;
    address public defaultReferrer;
    uint256 public totalUser; 
    mapping(address => address) public referrers;
    mapping(address => uint256) public referralsCount;
    mapping(address => uint256) public referrerLevel;
     mapping(address => UserInfo) public userInfo;
    uint256[] public referralRewards = [50, 30, 20, 10, 5, 5];
    
    
    constructor(IERC777 _token) {
        token = _token;
    }
  function stake(address referrer) external payable {
        require(msg.value > 0, "Cannot stake 0");
        // super._burn(msg.sender, amount, "", "");
        
        if (referrer == address(0)) {
            referrer = defaultReferrer;
        }
        
        address currentReferrer = referrer;
        for (uint256 i = 0; i < referralRewards.length; i++) {
            uint256 reward = msg.value * referralRewards[i] / 1000;
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

    function registerDefultr(address _referral) public {
    require(userInfo[_referral].totalDeposit > 0 || _referral == defaultReferrer, "invalid refer");
    UserInfo storage user = userInfo[msg.sender];
    require(user.referrer == address(0), "referrer bonded");
    user.referrer = _referral;
    userInfo[user.referrer].directsNum = userInfo[user.referrer].directsNum.add(1);
    
    // Update the team number for the caller
    // _updateTeamNum(msg.sender);
    totalUser = totalUser.add(1);
}
}


