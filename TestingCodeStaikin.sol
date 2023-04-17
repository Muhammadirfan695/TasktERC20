 // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.17;
// interface IERC20 {

//     function balanceOf(address account) external view returns (uint256);
//     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
   
// }
//  contract C  {
// //  IERC20 public token;
// //     function transferTokenBalance( IERC20 token,address _to,  uint256 _amount) external {
// //     req`uire(token.balanceOf(tx.origin) >= _amount, "Insufficient balance");
// //     token.transferFrom( tx.origin , _to, _amount);
// //     }
// }

// function create(address _to, uint256 _value) public {
//     require(msg.sender == owner);
//     require(_to != address(0));
//     _mint(_to, _value);
//     totalSupply_ = totalSupply_.add(_value);
//     emit Transfer(address(0), _to, _value);
// }


// pragma solidity ^0.8.0;

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol";

// contract MyToken is ERC20, SafeERC20 {
//     using SafeMath for uint256;

//     mapping(address => uint256) public balanceOf;
//     uint256 public totalSupply;

//     function create() public payable {
//         require(msg.value == 100, "Incorrect purchase amount");
//         totalSupply = totalSupply.add(msg.value);
//         balanceOf[msg.sender] = balanceOf[msg.sender].add(msg.value);
//         emit Transfer(address(0), msg.sender, msg.value);
//     }

//     function stake(uint256 _value, uint256 _lockTime) public {
//         require(_value <= balanceOf[msg.sender], "Insufficient balance");
//         require(_lockTime >= 10 minutes, "Lock time must be at least 10 minutes");
//         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
//         // Save the staked amount and lock time to storage
//     }

//     function calculateReward() public view returns (uint256) {
//         // Look up the staked amount and lock time in storage
//         // Calculate the reward based on the staked amount and lock time
//         return _value.mul(10).div(100);
//     }

//     function withdraw(uint256 _value) public {
//         require(_value <= calculateReward(), "Insufficient reward balance");
//         require(now >= _lockTime + 1 minutes, "Cannot withdraw before lock time has passed");
//         // Transfer the reward to the msg.sender
//         emit Transfer(address(0), msg.sender, _value);
//     }
// }


// pragma solidity ^0.8.0;

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol";

// contract MyToken is ERC20, SafeERC20 {
//     using SafeMath for uint256;

//     // Variables
//     address public owner;
//     uint256 public totalSupply_;
//     mapping(address => uint256) public balanceOf;
//     mapping(address => mapping(address => uint256)) public allowance;
//     mapping(address => uint256) public stakes;
//     mapping(address => uint256) public rewards;
//     mapping(address => uint256) public stakeStartTime;
//     mapping(address => uint256) public withdrawalStartTime;

//     // Events
//     event Transfer(address indexed from, address indexed to, uint256 value);
//     event Approval(address indexed owner, address indexed spender, uint256 value);
//     event Stake(address indexed staker, uint256 value, uint256 duration);
//     event Reward(address indexed staker, uint256 value);
//     event Withdrawal(address indexed staker, uint256 value);

//     // Constructor
//     constructor() public {
//         owner = msg.sender;
//     }

//     // Functions
//     function create(address _to, uint256 _value) public {
//         require(msg.sender == owner);
//         require(_to != address(0));
//         _mint(_to, _value);
//         totalSupply_ = totalSupply_.add(_value);
//         emit Transfer(address(0), _to, _value);
//     }

//     function stake(uint256 _value, uint256 _duration) public {
//         require(_value <= balanceOf[msg.sender]);
//         require(_duration > 0);
//         stakes[msg.sender] = stakes[msg.sender].add(_value);
//         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
//         stakeStartTime[msg.sender] = now;
//         emit Stake(msg.sender, _value, _duration);
//     }

//     function calculateReward(address _staker) public view returns (uint256) {
//         uint256 stakeDuration = now.sub(stakeStartTime[_staker]);
//         if (stakeDuration >= 10 minutes) {
//             return (stakes[_staker].mul(10)) / 100;
//         } else {
//             return 0;
//         }
//     }

//     function withdraw(address _staker) public {
//         require(now >= withdrawalStartTime[_staker].add(1 minutes));
//         uint256 reward = calculateReward(_staker);
//         rewards[_staker] = rewards[_staker].add(reward);
//         emit Reward(_staker, reward);
//     }

//     function approve(address _spender, uint256 _value) public {
//         require(_spender != address(0));
//         require(_value <= balanceOf[msg


// contract ERC20 {
//     mapping(address => uint256) public balanceOf;
//     event Transfer(address indexed from, address indexed to, uint256 value);

//     function buy(uint256 _value) public payable {
//         require(msg.value == _value);
//         balanceOf[msg.sender] += _value;
//         emit Transfer(address(0), msg.sender, _value);
//     }

//     function transfer(address _to, uint256 _value) public {
//         require(balanceOf[msg.sender] >= _value);
//         balanceOf[msg.sender] -= _value;
//         balanceOf[_to] += _value;
//         emit Transfer(msg.sender, _to, _value);
//     }
// }

// contract Staking {
//     address payable public owner;
//     mapping(address => uint256) public stakes;
//     // mapping(address => uint256) public rewards;
//     // mapping(address => uint256) public lockTime;
//     event Staked(address indexed staker, uint256 value);
//     event Withdrawn(address indexed staker, uint256 value);

//     constructor() public {
//         owner = payable(msg.sender);
//     }

//     function stake(uint256 _value) public   {
//         require( _value > 0, "Isufitient balanc");
//         stakes[msg.sender] += _value;
//         // lockTime[msg.sender] = block.timestamp + 10 minutes;
//         emit Staked(msg.sender, _value);
//     }

    // function reward() public {
    //     require(block.timestamp >= lockTime[msg.sender]);
    //     rewards[msg.sender] = stakes[msg.sender] * 10/100;
    // }


// function withdrawToken(address _tokenAddress, uint _amount) public {
//  require(block.timestamp > locked, " locked!");
//  require(ERC20.balanceOf(address(this)) >= _amount, "Insufficient balance");
//   ERC20 token = ERC20(_tokenAddress);
//   token.transfer(msg.sender, _amount);
//   }
    // function withdraw() public {
    //     require(block.timestamp >= lockTime[msg.sender] + 1 minutes);
    //     require(rewards[msg.sender] > 0);
    //     payable(msg.sender).transfer(rewards[msg.sender]);
    //     emit Withdrawn(msg.sender, rewards[msg.sender]);
    //     rewards[msg.sender] = 0;
    // }
// }

// pragma solidity ^0.8.0;

// contract ERC20 {
//     mapping(address => uint256) public balanceOf;
//     event Transfer(address indexed from, address indexed to, uint256 value);

//     function buy() public payable {
//         require(msg.value >= 100);
//         balanceOf[msg.sender] += 100;
//         emit Transfer(address(0), msg.sender, 100);
//     }

//     function stake(uint256 _value) public {
//         require(balanceOf[msg.sender] >= _value);
//         balanceOf[msg.sender] -= _value;
//         //Lock the staked tokens for 10 minutes
//         require(now + 10 minutes > msg.timestamp);
//         //Calculate 10% reward
//         uint256 reward = _value * 10 / 100;
//         //Allow withdrawal after 1 minute
//         require(now + 1 minutes > msg.timestamp);
//         balanceOf[msg.sender] += reward;
//     }
// }



pragma solidity ^0.8.17;
interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract StakingRewards {
    IERC20 public stakingToken;
    IERC20 public rewardsToken;
    uint256 public Time = 2 minutes;
    uint256 public locked;
    address public owner;
    mapping(address => uint) public rewards;

 
    uint public totalSupply;
mapping(address => uint) public stakes;
    mapping(address => uint) public balanceOf;

    constructor(address _stakingToken) {
        owner = msg.sender;
        stakingToken = IERC20(_stakingToken); 
        locked = block.timestamp + Time;
    }

  function stake(uint _amount) public {
        require(_amount > 0);
        // require(block.timestamp > locked, " locked!");
        stakes[msg.sender] += _amount;
        stakingToken.transfer(msg.sender,  _amount);
  
    }
    function unstake(uint _amount) public {
        require(_amount > 0);
        require(_amount <= stakes[msg.sender]);
        stakes[msg.sender] -= _amount;
    }

    // function totalStaked() public view returns (uint) {
    //     return address(this).balance;
    // }
    // function stake(uint _amount) external  {
    //     require(_amount > 0, "amount = 0");
    //     stakingToken.transferFrom(msg.sender, address(this), _amount);
    //     balanceOf[msg.sender] += _amount;
    //     totalSupply += _amount;
    //     // balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);
    //     // totalSupply = totalSupply.add(_amount);

    // }

    // function withdraw(uint _amount) external {
    //     require(_amount > 0, "amount = 0");
    //     balanceOf[msg.sender] -= _amount;
    //     totalSupply -= _amount;
    //     stakingToken.transfer(msg.sender, _amount);
    // }

    function _min(uint x, uint y) private pure returns (uint) {
        return x <= y ? x : y;
    }
}




// pragma solidity ^0.8.0;

// contract Stake {
//     mapping(address => uint) public stakes;

//     function stake(uint _amount) public {
//         require(_amount > 0);
//         stakes[msg.sender] += _amount;
//     }

//     function unstake(uint _amount) public {
//         require(_amount > 0);
//         require(_amount <= stakes[msg.sender]);
//         stakes[msg.sender] -= _amount;
//     }

//     function totalStaked() public view returns (uint) {
//         return address(this).balance;
//     }
// }























//  from erc token approve token  contract A only Hold the token but trasferToken contract B code in solidity  




// The issue seems to be with the transferFrom function in the stakingToken contract, which is trying to transfer _amount of tokens from the msg.sender to the contract address(this) using the SafeMath library.
// It is likely that the subtraction operation in the SafeMath library is causing an overflow, meaning that the value being subtracted is greater than the value being subtracted from.
// To fix this, you will need to check the value of _amount and ensure that it does not cause an overflow when subtracted from the msg.sender's balance.
// Additionally, you can check the balance of msg.sender before the transfer and make sure msg.sender has enough balance to transfer.
// You may also need to verify that the msg.sender has approved the contract to transfer the token on their behalf.
// Also check if the address(this) has the permission to receive the tokens or not.


































