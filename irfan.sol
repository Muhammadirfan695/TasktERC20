
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

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

contract Irfan  {

    IERC20 public Token;
    address public _owner;
    uint256 public _lockTime;
    bool public isLocked;

    mapping(address=>uint256) public balances;
    
    event LogDepositeMade(address accountHoder, uint256 amount);
    event TransferReceived(address _from, uint _amount);
    event TransferSent(address _from, address _destAddr, uint _amount);

    constructor() {
        _owner = msg.sender;
        Token = IERC20(0xe2899bddFD890e320e643044c6b95B9B0b84157A);

    }

    modifier onlyOwner {
        require(msg.sender == _owner, "Ownable: caller is not the owner");
        _;
    }

    function setOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "invalid address");
        _owner = _newOwner;
    }

    function TokenTransferToUser(address[] memory recipients, uint256 amount) public {
        require(amount > 0, "Invalid amount");
        require(block.timestamp > _lockTime, " locked!");
        for (uint256 i = 0; i < recipients.length; i++) {
            Token.transfer(recipients[i], amount);
            balances[recipients[i]] +=amount;
            balances[msg.sender] -=amount;
        }
    }

    function TokenTransferToContract( uint256 amount) public {
        // require(amount > 0, "Invalid amount");
        require(block.timestamp > _lockTime, " locked!");
        Token.transfer(address(this), amount);
        balances[address(this)] +=amount;
        balances[msg.sender] -=amount;
    }

    function withdrawToken(uint256 amount) public {
        require(Token.balanceOf(address(this)) >= amount, "Insufficient balance");
        Token.transfer(msg.sender, amount);
        balances[address(this)] -=amount;
        balances[msg.sender] +=amount;
    }

    function lock(uint256 time) public onlyOwner {
        _lockTime = block.timestamp + time;
        isLocked = true;
    }

    function getUnlockTime() public view returns (uint256) {
        return _lockTime;
    }

    function unlock() public onlyOwner {
        require(block.timestamp > _lockTime,"Contract is locked until 10 minutes");
        isLocked = false;
    }
}