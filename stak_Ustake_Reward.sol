// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "./Token.sol";



contract StakingRewards {
    //   using SafeMath for uint256;
    struct Reward {
    address recipient;
    uint amount;
}

   
    ERC20 public token;
    uint256 public values; 
    uint256 public Time = 1 minutes;
    uint256 public locked;
    address public owner;
    mapping(address => uint256) public stakes;
    mapping(address => Stake) public userStake;
    uint public totalSupply;
    // User address => staked amount
    mapping(address => uint) public _balanceOf;

    mapping(address => uint256) rewards;
    uint256 public REWARD_RATE;
    uint256 public stakedTimestamp;
    event Staked(address staker, uint256 amount);
    event Claimed(address staker, uint256 reward);
mapping(uint => uint) public totalSupplyAt;
mapping(uint => mapping(address => uint)) public balancAt;
// Mapping to store the stake amounts for each address
mapping (address => uint) public stakes;
    constructor(ERC20 _token) {
        owner = msg.sender;
        token = _token;
        locked = block.timestamp + Time;
        // rewardsToken = IERC20(_rewardToken);
    }

    function stake(uint _amount) external {
       
        require(_amount > 0, "amount = 0");
         require(block.timestamp > locked , "Locked");
        token.transfer( address(this), _amount);
        _balanceOf[msg.sender] = _amount;
    }

    //  function getReward() public  {
    //     if(block.timestamp >= rewards[msg.sender]){
          
    //         rewards[msg.sender] = _balanceOf[msg.sender] * 10/100;
    //     }
    // }
       function unstake(uint amount) external { 
    //    lockTime[msg.sender] = block.timestamp + 1 minutes;
        
        _balanceOf[msg.sender] -= amount;
        totalSupply -= amount;

        token.transfer(msg.sender, amount);
    }
    // Function to distribute rewards to stakers
function distributeRewards() public {
    // Calculate the reward for each staker
    for (address staker : stakes) {
        rewards[staker] = (stakes[staker] * totalReward) / totalStake;
    }
}
    // uint[] public timestamps;
    //     function getReward() public{
    //     uint reward = 0;
    //     for (uint i = 0; i < timestamps.length; i++){
    //     uint t = timestamps[i];
    //     reward += (REWARD_RATE * balancAt[t][msg.sender]/ totalSupplyAt[t]) ;
    // }
   






}




}





// Mapping to store the rewards for each address
mapping (address => uint) public rewards;

// Variable to store the total stake
uint public totalStake;

// Function to allow users to stake an amount
function stake(uint _amount) public {
    require(msg.value == _amount); // Ensure the correct amount is sent
    stakes[msg.sender] += _amount; // Add the staked amount to the user's existing stake
    totalStake += _amount; // Add the staked amount to the total stake
}


























// contract Staking {
//     mapping(address => uint256) stakedAmounts;
//     mapping(address => uint256) rewards;
//     uint256 totalSupply;
//     event Staked(address staker, uint256 amount);
//     event Claimed(address staker, uint256 reward);

//     function stake(uint256 amount) public {
//         require(msg.sender.balance >= amount, "Insufficient funds");
//         stakedAmounts[msg.sender] += amount;
//         totalSupply += amount;
//         emit Staked(msg.sender, amount);
//     }

//     function claimReward() public {
//         require(stakedAmounts[msg.sender] > 0, "You have not staked any tokens");
//         uint256 reward = calculateReward(msg.sender);
//         rewards[msg.sender] += reward;
//         emit Claimed(msg.sender, reward);
//     }

//     function calculateReward(address staker) private view returns(uint256) {
//         return stakedAmounts[staker] * (block.timestamp - stakedTimestamp[staker]) / totalSupply;
//     }
// }


// function calculateTotalStakedRewards() public view returns(uint256) {
//     uint256 totalStakedRewards = 0;
//     address[] memory stakers = keys(stakedRewards);
//     for (uint i = 0; i < stakers.length; i++) {
//         totalStakedRewards += stakedRewards[stakers[i]];
//     }
//     return totalStakedRewards;
// }
    // 
// function calculateTotalStakedRewards() public view returns(uint256) {
//     uint256 totalStakedRewards = 0;
//     for (address staker in stakedRewards) {
//         totalStakedRewards += stakedRewards[staker];
//     }
//     return totalStakedRewards;
// }
    // function RewardsToken(uint256 percentage) public {
    // uint256 totalBalance = address(this).balance;
    // uint256 reward;
   
    // for (uint i = 0; i < users.length; i++) {
    //     reward = (users[i].balance * percentage) / 100;
    //     users[i].transfer(reward);
    // }
// }


// function claimReward() public {
//         require(stakedAmounts[msg.sender] > 0, "You have not staked any tokens");
//         uint256 reward = calculateReward(msg.sender);
//         rewards[msg.sender] += reward;
//         // emit Claimed(msg.sender, reward);
//     }

//     function calculateReward(address staker) private view returns(uint256) {
//         return stakedAmounts[staker] * (block.timestamp ) / totalSupply;
//     }
    // function calculateTotalStakedRewards() public view returns(uint256) {
    // uint256[] memory rewards = values(stakedRewards);
    // uint256 totalStakedRewards = 0;
    // for (uint i = 0; i < rewards.length; i++) {
    //     totalStakedRewards += rewards[i];
    // }
    // return totalStakedRewards;





// for (uint i = 0; i < users.length; i++) {
//     reward = (users[i].balance * percentage) / 100;
//     users[i].transfer(reward);
// }

// for (uint i = 0; i < users.keys().length; i++) {
//     reward = (users[users.keys()[i]].balance * percentage) / 100;
//     users[users.keys()[i]].transfer(reward);
// }


    //  function rewardPerToken() public view returns (uint) {
    //     if (totalSupply == 0) {
    //         return rewardPerTokenStored;
    //     }

    //     return
    //         rewardPerTokenStored +
    //         (5 * (lastTimeRewardApplicable() - updatedAt) * 1e18) /
    //         totalSupply;
    // }
//     function reward() public {
//     // calculate the reward amount
//     uint rewardAmount = totalSupply.mul(10).div(100);

//     // transfer the reward to the designated address
//     token.transfer(rewardAmount);
// }


// function generateReward() public {
//     // calculate the reward amount
//     uint reward = _balanceOf(address(this)) * 0.1;

//     // transfer the reward to the designated address
//     token.transfer(reward);
// }

//         function reward() public {
//         // require(block.timestamp >= lockTime[msg.sender]);
//         // rewards[msg.sender] = stakes[msg.sender] * 10/100;
//         // rewards[msg.sender] = stakes[msg.sender] * 10/100;
//         rewards[msg.sender] = 100 * 10/100;
// // rewards[msg.sender] = 10;

//     }

    // function unstake(uint _amount) external  {
    //     require(_amount > 0, "amount = 0");
    //     require(block.timestamp >= _amount)
    //     balanceOf[msg.sender] -= _amount;
    //     totalSupply -= _amount;
    //     token.transfer(msg.sender, _amount);
    // }

    // function _min(uint x, uint y) private pure returns (uint) {
    //     return x <= y ? x : y;
    // }
// }

//       function lastTimeRewardApplicable() public view returns (uint) {
//         return _min(finishAt, block.timestamp);
//     }
//   function rewardPerToken() public view returns (uint) {
//         if (totalSupply == 0) {
//             return rewardPerTokenStored;
//         }
//      return rewardPerTokenStored +(rewardRate * (lastTimeRewardApplicable() - updatedAt) * 1e18) /totalSupply;
//     }

// Erc20 function buy token in solidity  

// function buy() public payable {
//     require(msg.value >= tokenPrice); // check that enough Ether is sent
//     uint tokens = msg.value / tokenPrice; // calculate the number of tokens to be purchased
//     require(address(this).balance >= msg.value); // check that the contract has enough Ether
//     require(tokenBalance[msg.sender] + tokens <= totalSupply); // check that the total token supply will not be exceeded
//     tokenBalance[msg.sender] += tokens; // update the user's token balance
//     msg.sender.transfer(msg.value); // transfer the Ether to the contract
//     // emit TokenPurchase(msg.sender, tokens, msg.value); // emit an event to notify of the purchase
// }

