// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
interface IERC20 {
    function transfer(address recipient, uint amount) external returns (bool);  
    event Transfer(address indexed from, address indexed to, uint amount);
}
// 2:45|| 93 percent
contract ReceiveSend {
    IERC20 public token;

    constructor(IERC20 _token)  {
        token = _token;
    }

    function receiveEther() public payable {
        // check if the transaction has enough Ether

        uint256 recieveEther = msg.value;
        require(recieveEther >= 1 ether, "Insufitient Blanace");

        // send tokens to the sender
        token.transfer(msg.sender, msg.value);
    }
}

 




// In summary, the main difference between ERC-20 and ERC-777 in Solidity is that ERC-777 is a more advanced 
// token standard that builds on the functionality of ERC-20, it offers additional features that can be used
//  to implement advanced smart contract logic and improve token security.

// Some of the key differences include:

// ERC-777 introduces the ability to use custom operators for token transfers, 
// which allows developers to specify custom logic for handling token transfers,
//  such as token locking, token burning, and token freezing.

// ERC-777 tokens can be sent to smart contracts that are not specifically designed to handle ERC-20 tokens,
//  which can increase the flexibility of decentralized applications that use these tokens.

// ERC-777 allows to handle data in the transfer, which means that can send data along with the token, 
// this can be useful for different use cases like sending metadata or other information that is not covered by the standard ERC-20.

// ERC-777 also includes a feature called "tokens received hooks" which allows the developer to specify custom 
// logic that is executed when a token is received.

// ERC-777 also includes a feature called "tokens sent hooks" which allows the developer to specify custom
//  logic that is executed when a token is sent.

// Overall, ERC-777 is a more advanced and flexible token standard than ERC-20,
//  but it requires a higher level of technical expertise to implement and may not be compatible with all
//  decentralized applications or exchanges.