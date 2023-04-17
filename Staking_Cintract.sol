// SPDX-License-Identifier:MIT
pragma solidity ^0.8.15;

interface IERC20 {
    function balanceOf(address account) external view returns(uint256);
    function transfer(address receiver, uint256 tokenAmount) external  returns(bool);
    function transferFrom( address tokenOwner, address recipient, uint256 tokenAmount) external returns(bool);
}


contract Staking {
 event Stake(uint256);
    IERC20 public token1;
   
    address public owner;
   
    uint256 public receiveToken;
    uint256 public lockTime = 180 seconds; // 3 days    // 1 day === 1 mint
    uint256 public rewardAmountPerDay = 20 ;
    uint256 public rewardBurningPercentage = 3 ; // 3% of reward

   
    constructor(IERC20 _stake) {
        token1 = _stake;
        
        owner = msg.sender;
    }

    struct userDetail {
        bool  isStaked;
        uint256 StakeTime;
        uint256 StakeAmount;
        uint256 Withdraw;
    }
    mapping(address => userDetail) public UserInfo;



    function stake(uint256 _tokenAmount) public  {

        // require(msg.sender != owner, "owner cannot stake!");
        UserInfo[msg.sender].isStaked = true; 
        UserInfo[msg.sender].StakeTime = block.timestamp;
        UserInfo[msg.sender].StakeAmount += _tokenAmount;
        token1.transferFrom( msg.sender, address(this), _tokenAmount ); 
        receiveToken += _tokenAmount;
        emit Stake(_tokenAmount);
    }

    function unStake() public  returns(bool isUnstaked){
       uint256 amount = UserInfo[msg.sender].StakeAmount;
        receiveToken -= amount;
        UserInfo[msg.sender].isStaked = false; 
        UserInfo[msg.sender].StakeTime = 0;
        UserInfo[msg.sender].StakeAmount = 0;
        token1.transfer(msg.sender, amount);

        return true;
    }
   
    function calculateReward(address _user) public view returns(uint256) {
        
        uint256 Reward;
        // require(isStake(_user) == true, "not a staker");
        require(block.timestamp >= UserInfo[_user].StakeTime + lockTime, "time is not completed yet!");
        Reward = UserInfo[_user].StakeAmount * rewardAmountPerDay ; //  check days and add
        return Reward;
    }

  
   
  
   
}
// This message is indicating that there is a discrepancy in the expected and
//  the actual gas cost of a revert statement in a Solidity smart contract.

// In Ethereum, every operation in a smart contract costs a certain amount of gas,
//  and the cost is paid in Ether by the user who initiates the operation. 
//  Revert statements are used to cancel a transaction and refund the gas that was
//   already spent, but they also have a gas cost.

// When the actual gas cost of a revert statement is higher than the expected cost,
//  it may indicate an issue with the smart contract code or an unexpected behavior.
//   It could be that the revert statement is being executed in a loop or in a function
//    that is called multiple times, causing the gas cost to be higher than expected.

// To solve this issue, you can try to identify the cause of the higher gas cost 
// by analyzing the smart contract code and the execution path. You can also try 
// to refactor the code to minimize the number of revert statements, or optimize
//  the code to reduce the gas cost of other operations.

// It is also important to note that different versions of the Solidity compiler
//  may produce different gas costs for the same code, so you may want to try compiling
//   with different versions to see if that affects the gas cost.