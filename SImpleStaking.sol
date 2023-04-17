// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC777 {
    function balanceOf(address account) external view returns(uint256);
    function withdrawStakingReward(uint256 _value) external;

}

contract Staking{

    IERC777 public ERC777;
     address public owner;
    // uint256 public lockTime = 3 minutes;
    uint256 public rewardTokenPerDay = 20;


  constructor(IERC777 _Reward){
      ERC777 = _Reward;
      owner = msg.sender;
  }
  struct userDetail{
      uint256 StakeTime;
      uint256 StakeAmount;
      uint256 withdraw;
  }
  mapping(address => userDetail) public UserInfo;
  mapping(address => bool) public isStaked;


  modifier onlyOwner{
      require (msg.sender == owner, "You are not Owner");
      _;
  }
  function chekBool(address user) public view returns (bool){
      return isStaked[user];
  }
  function stake() public payable{
      require(!isStaked[msg.sender], "Unstak first");
      UserInfo[msg.sender].StakeAmount += msg.value;
    //   UserInfo[msg.sender].stakeTime = block.timestamp;
    isStaked[msg.sender] = true;
  }
    function unStake() public {
      
        UserInfo[msg.sender].StakeTime = 0;
        UserInfo[msg.sender].StakeAmount = 0;
        isStaked[msg.sender]=false;
        payable (msg.sender).transfer(UserInfo[msg.sender].StakeAmount);
    }
    function calculateReward(address _user) public view returns(uint256){
        uint256 Reward;
        Reward = ((rewardTokenPerDay * 1 ether ) * UserInfo[_user].StakeAmount) / 1e18;
    }
}