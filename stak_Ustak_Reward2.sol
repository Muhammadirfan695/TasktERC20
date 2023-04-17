// SPDX-License-Identifier:MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function balanceOf(address account) external view returns(uint256);
    function transfer(address receiver, uint256 tokenAmount) external  returns(bool);
    function transferFrom( address tokenOwner, address recipient, uint256 tokenAmount) external returns(bool);
}
contract Staking {

    IERC20 public token1;
    address public owner;
    uint256 public receiveToken;
    uint256 public lockTime = block.timestamp + 30 seconds; 
    uint256 public rewardPercentage = 10 ; 

    constructor(IERC20 _stake) {
        token1 = _stake;
        owner = msg.sender;
       
    }
    struct Staked {
        bool  isStaked;
        uint256 UserTime;
        uint256 UserAmount;
        
    }
    mapping(address => Staked) public staker;
    function stake(uint256 _tokenAmount) public  {
    // require(msg.sender != owner, "owner cannot stake!");
        require(staker[msg.sender].isStaked != true );
        require(block.timestamp > lockTime, "Lock time has not expired yet.");
        staker[msg.sender].isStaked = true; 
        staker[msg.sender].UserTime = block.timestamp;
        staker[msg.sender].UserAmount += _tokenAmount;
        token1.transferFrom( msg.sender, address(this), _tokenAmount ); 
        receiveToken += _tokenAmount;
    }
    function unStake() public  returns(bool isUnstaked){
       uint256 amount = staker[msg.sender].UserAmount;
       
        receiveToken -= amount;
        staker[msg.sender].isStaked = false; 
        staker[msg.sender].UserTime = 0;
        staker[msg.sender].UserAmount = 0;
        token1.transfer(msg.sender, amount);
        return true;
    }
    function RewardAmount(address _userAddr) public view returns(uint256) {
        uint256 Reward;
        require(staker[_userAddr].isStaked == true, "not a staker");
        Reward = staker[_userAddr].UserAmount * rewardPercentage/100 ; 
        return Reward;
    }
}
