// SPDX-License-Identifier: MIT  
pragma solidity ^0.8.0;
interface IERC20 {

    function balanceOf(address account) external view returns (uint256);
      function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
   
}
contract StakeContract {
    mapping(address => mapping(uint => uint)) public userStakes;
    mapping(uint => uint) public stakeMultipliers;

    constructor() public {
        stakeMultipliers[1] = 110;
        stakeMultipliers[2] = 120;
        stakeMultipliers[3] = 130;
        stakeMultipliers[4] = 140;
        stakeMultipliers[5] = 150;
        stakeMultipliers[6] = 160;
    }

    function stake(uint _slot, uint _amount) public payable {
        require(_slot >= 1 && _slot <= 6, "Invalid slot selected");
        require(_amount > 0, "Invalid stake amount");
        require(msg.value == _amount, "Incorrect token amount");
        userStakes[msg.sender][_slot] = _amount;
    }

    function withdraw(IERC20 token, uint _slot) public {
        require(userStakes[msg.sender][_slot] > 0, "No stake found for this slot");
        uint amount = userStakes[msg.sender][_slot] * stakeMultipliers[_slot] / 100;
         msg.sender.transfer(amount);
        userStakes[msg.sender][_slot] = 0;
    }

    function getMultiplier(uint _slot) public view returns (uint) {
        return stakeMultipliers[_slot];
    }
}




