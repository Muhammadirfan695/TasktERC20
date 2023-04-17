// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract ICO {
    IERC20 public token;
    address public _owner;
    uint256 public Time = 2 minutes;
    uint256 public locked;
    bool public isLocked;
   
    event LogDepositeMade(address accountHoder, uint256 amount);

    constructor(IERC20 _token) {

        _owner = msg.sender;
        token = _token;
         locked = block.timestamp + Time;
       
    } 
     modifier onlyOwner {
        require(msg.sender == _owner, "Ownable: caller is not the owner");
        _;
    }
    function setOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "invalid address");
        _owner = _newOwner;
    }



function transferTokenBalance(  uint256 _amount) public {
    
    require(token.balanceOf(tx.origin) >= _amount, "Insufficient balance");
    token.transferFrom( tx.origin , address(this), _amount);
}


 
  
     function withdrawToken(address _tokenAddress, uint _amount) public {
 require(block.timestamp > locked, " locked!");
 require(token.balanceOf(address(this)) >= _amount, "Insufficient balance");
  IERC20 token = IERC20(_tokenAddress);
  token.transfer(msg.sender, _amount);
  }
  
  
}