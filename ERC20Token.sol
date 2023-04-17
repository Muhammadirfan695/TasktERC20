// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {

    address public _owner;
    uint256 public Time = 2 minutes;
    uint256 public locked;
    bool public isLocked;
    event LogDepositeMade(address accountHoder, uint256 amount);
    constructor() ERC20("Skil token", "skc") {
        _owner = msg.sender;
        locked = block.timestamp + Time;
        _mint(address(this), 10000 * 10**18);
    }
    modifier onlyOwner {
        require(msg.sender == _owner, "Ownable: caller is not the owner");
        _;
    }
    function TokenTransferToUser(address[] memory recipients, uint256 amount) public {
        require(amount > 0, "Invalid amount");
        for (uint256 i = 0; i < recipients.length; i++) {
            ERC20.transfer(recipients[i], amount);
        }
    }
    function TokenTransferToContract(uint256 amount ) public {
        require(amount > 0, "Invalid amount");
           ERC20.transfer(address(this), amount);
            isLocked = true;
        
    }
 function withdrawToken(address _tokenAddress, uint _amount) public {
 require(block.timestamp > locked, " locked!");
 require(ERC20.balanceOf(address(this)) >= _amount, "Insufficient balance");
  ERC20 token = ERC20(_tokenAddress);
  token.transfer(msg.sender, _amount);
  }
}
 // function setOwner(address _newOwner) external onlyOwner {
    //     require(_newOwner != address(0), "invalid address");
    //     _owner = _newOwner;
    // }
