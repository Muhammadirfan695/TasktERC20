// SPDX-License-Identifier: MIT
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
    
    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);
}
contract ERC20 is IERC20{
      uint public totalSupply;
      mapping(address => uint) public _balances;
      mapping(address => mapping(address => uint)) public allowance;
      string public name = "Baskit Katik";
      string public symbol = "BLK";
      uint8 public decimals = 0;
       address public _creator;

    constructor() public{
        _creator = msg.sender;
        totalSupply = 50000;
        _balances[_creator] = totalSupply;
    }
    //  function totalSupply() public view override returns (uint256) {
    //     return _totalSupply;
    // }

    function balanceOf(address _ownerToken)
        public
        view
        override
        returns (uint256 balance)
    {
        return _balances[_ownerToken];
    }
       function transfer(address _to, uint amount) public virtual returns (bool){
           _balances[msg.sender] -= amount;
           _balances[_to] += amount;
           emit Transfer(msg.sender, _to, amount);
           return true;
       }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    function transferFrom(
        address _from,
        address _to, 
        uint256 amount
    ) public virtual returns (bool){
     allowance[_from][msg.sender] -= amount;
     _balances[_from] -= amount;
     _balances[_to] += amount;
        emit Transfer(_from, _to, amount);
        return true;
}

}
// contract ICOBLk is  ERC20{
//     // define the admin of
//     address public admistrator;

//  // Recipient acount
//  address payable public recipient;

// //  set price of token 0.001 ether = 1000000000000000
// uint public tokenPrice = 1000000000000000;
// // hardcap 500 ether = 500000000000000000000
// uint public icoTarget = 500000000000000000000;

// // dfine a state variable to track the funded amount
// uint public recieveFund;

// // maximum(10 ether) &minimum(0.0)

// uint public maxInvestment = 10000000000000000000;
// uint public minInvestment = 1000000000000000;

// // set the ICO Status
// enum Status{inactive, active, stopped, completed}
// Status public icoStatus;

// uint public icoStartTime = block.timestamp;

// // 5 days - duration
// uint public icoEndTime = block.timestamp + 432000;
// // Trading Start Time
// // uint public StatTrading = icoEndTime= 432000
// uint public startTrading = icoEndTime;
// modifier onlyOwner{
//     if(msg.sender == admistrator){
//         _;
//     }
// }

// function setStopStatus() public onlyOwner{
//     icoStatus = Status.stopped;
// }
// function setActiveStatus() public{
//     icoStatus = Status.active;
// }
// function getIcoStatus() public view returns(Status){
//     if(icoStatus == Status.stopped){
//         return Status.stopped;
//     }else if (block.timestamp >= icoStartTime && block.timestamp <= icoEndTime){
//         return Status.active;
//     }else if (block.timestamp <= icoStartTime){
//         return Status.inactive;
//     }else{
//         return Status.completed;
//             }
// }
// constructor(address payable _recipient) public{
//     admistrator = msg.sender;
//     recipient = _recipient;

// }
// function Investing() payable public returns(bool){
// //   check for hard cap 
//     icoStatus = getIcoStatus();
    
//     require(icoStatus == Status.active, "ICO is not active ");
//     require(icoTarget >= recieveFund + msg.value, "Target Achieved, Investment not accepted");

//     // Check for mximum >= minInvetment and maximum Investment
//     require(msg.value >= minInvestment && msg.value <= maxInvestment, "Investment not in allowed range");
//     uint tokens = msg.value/ tokenPrice;
//     _balances[msg.sender] += tokens;
//     _balances[_creator] -= tokens;

//     recipient.transfer(msg.value);

//     recieveFund += msg.value;
//     return true;
// }
// function burn() public onlyOwner returns(bool){
//     icoStatus = getIcoStatus();

//     require(icoStatus == Status.completed, "ICO not complete");
//     _balances[_creator] = 0;
// }
// function transfer(address _to, uint amount) public override returns (bool){
// require(block.timestamp > startTrading, "Trading is not allowed curenttly");
// super.transfer(_to, amount);
// return true;
// }
//   function transferFrom( address _from,address _to, uint256 amount) public override returns (bool){
//        require(block.timestamp > startTrading, "Trading is not allowed curenttly");
//        super.transferFrom(_from,_to, amount);
//        return true;
// }
// }

 