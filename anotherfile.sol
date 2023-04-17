
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ReceiverContract {
  function receiveTokens() public {
    // Do something here
  }
}

// This is the contract that will send the tokens
contract SenderContract {
//   using SafeERC20 for ERC20;

  ERC20 public token;
  ReceiverContract public receiver;

  constructor(ERC20 _token, address _receiver) public {
    token = _token;
    receiver = ReceiverContract(_receiver);
  }

  function sendTokens(uint256 _value) public {
    require(token.transfer(receiver.address, _value), "transfer failed");
  }
}





