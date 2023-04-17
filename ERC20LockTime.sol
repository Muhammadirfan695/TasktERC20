// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./ERC20.sol";

contract MyToken is ERC20    {
    // uint256 public balance;
    address public _owner;
    uint256 public _lockTime;
    bool public isLocked;
    address public tokenContract;
  
    //    mapping(address=> uint ) private _balances;
    event LogDepositeMade(address accountHoder, uint256 amount);

    constructor() ERC20("skils ", "min") {
        _owner = msg.sender;
        _mint(msg.sender, 10000 * 10**18);
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Ownable: caller is not the owner");
        _;
    }
    function setOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "invalid address");
        _owner = _newOwner;
    }

    function UserTransfer(address[] memory recipients, uint256 amount) public {
        require(amount > 0, "Invalid amount");
        require(block.timestamp > _lockTime, " locked!");
        for (uint256 i = 0; i < recipients.length; i++) {
            transfer(recipients[i], amount);
            // _balances[recipients[i]] += amount;
        }
    }

    function contractOwner(address[] memory recipients, uint256 amount) public {
        require(amount > 0, "Invalid amount");
        require(block.timestamp > _lockTime, " locked!");
        for (uint256 i = 0; i < recipients.length; i++) {
            transfer(recipients[i], amount);
            // _balances[recipients[i]] += amount;
        }
    }

    function withdrawTokens(uint256 amount) public {
  // Check that the caller has sufficient balance
  require(ERC20.balanceOf(msg.sender) >= amount, "Insufficient balance");

  // Transfer the tokens to the caller
     ERC20.transfer(msg.sender, amount);
    _balances[msg.sender] -= amount;
  // Update the contract balance
//   uint256 newBalance = ERC20.balanceOf(address(this)) - amount;
//   ERC20.transfer(address(this), newBalance);
}

    function mint(address to, uint256 amount) external onlyOwner {
        require(msg.sender == _owner, "only owner");
        _mint(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

event TransferReceived(address _from, uint _amount);
    event TransferSent(address _from, address _destAddr, uint _amount);
    
    // receive() payable external {
    //     balance += msg.value;
    //     emit TransferReceived(msg.sender, msg.value);
    // }    

    function lock(uint256 time) public onlyOwner {
        _lockTime = block.timestamp + time;
        isLocked = true;
    }

    function getUnlockTime() public view returns (uint256) {
        return _lockTime;
    }

    function unlock() public onlyOwner {
        require(
            block.timestamp > _lockTime,
            "Contract is locked until 10 minutes"
        );
        isLocked = false;
    }
}

   // function withdraw(uint amount, address payable destAddr) public {
    //     require(msg.sender == _owner, "Only owner can withdraw funds"); 
    //     require(amount <= balance, "Insufficient funds");
        
    //     destAddr.transfer(amount);
    //     balance -= amount;
    //     emit TransferSent(msg.sender, destAddr, amount);
    // }
    

    //    function withdraw() public onlyOwner {
    //     // require(!withdraw_locked, "Reentrant call detected");
    //     // withdraw_locked = true;

    //     uint256 amount = address(this).balance;
    //     balance.sendValue(payable(msg.sender), amount);

    //     // withdraw_locked = false;
    // }

// function withdraw(uint256 _amount) public {
//   require(_balances[msg.sender] >= _amount, "Insufficient balance");
//   _balances[msg.sender] -= _amount;
//   msg.sender.transfer(_balances);
// }

// function withdraw(uint amount, address payable destAddr) public {
//         require(msg.sender == _owner, "Only owner can withdraw funds"); 
//         require(amount <= _balances, "Insufficient funds");
        
//         destAddr.transfer(amount);
//         _balances -= amount;

// }
    // function withdrawTokens(uint256 amount) external {
    //     require(_balances[msg.sender] >= amount, "Insufficent funds");
    //     require(block.timestamp > _lockTime, " locked!");
    //     _balances[msg.sender]  = _balances[msg.sender]- amount;
    
    //       ERC20.transfer(msg.sender, amount);
    // }
// function withdrawTokenBalance(uint256 amount) public view {
//     uint256 balance = ERC20.balanceOf(address(this));
//     require(balanceOf >= amount , "There are no tokens to withdraw");
//      balanceOf[msg.sender] -= amount;
//     ERC20.transfer(msg.sender, balance);
// }
// function withdraw(uint256 _amount) public {
//     require(_balances[msg.sender] >= _amount, "Insufficient balance");
//     _balances[msg.sender] -= _amount;
//     ERC20.transfer(msg.sender,_amount);
// }
   
//   function viewBalance() public view returns (uint256) {
//         return _balances[msg.sender];
//     }
    //  function deposite() public payable returns (uint)
    //         {

    //         require ((_balances[msg.sender] + msg.value) >  _balances[msg.sender] && msg.sender!=address(0));
    //         _balances[msg.sender] += msg.value;
    //         emit LogDepositeMade(msg.sender , msg.value);
    //         return _balances[msg.sender];
    //         }

    //         function withdraw (uint withdrawAmount) public returns (uint)
    //         {

    //                 require (_balances[msg.sender] >= withdrawAmount);
    //                 require(msg.sender!=address(0));
    //                 require (_balances[msg.sender] > 0);
    //                 _balances[msg.sender]-= withdrawAmount;
    //                   msg.sender.transfer(withdrawAmount);
    //                 emit LogDepositeMade(msg.sender , withdrawAmount);
    //                 return _balances[msg.sender];

    //         }


    
    // function withdrawToken(uint256 amount) public {
    // // require(block.timestamp > locked, " locked!");
    // require(ERC20.balanceOf(address(this)) >= amount, "Insufficient balance");
    // ERC20.transfer(msg.sender , amount);
    // }

//     function withdrawToken(address _tokenAddress, uint _amount) public {
//   ERC20 token = ERC20(_tokenAddress);
//   token.transfer(msg.sender, _amount);
// }
