// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
}

contract B {
    function receiveTokens(
        IERC20 token,
        address _to,
        uint256 _value
    ) public {
        require(
            token.balanceOf(address(this)) >= _value,
            "Isufitient Balance "
        );
        token.transfer(_to, _value);
    }
}

//  contract B  {
// function transferTokenBalance( IERC20 token, address _from, address _to,  uint256 _amount) external {
//     require(token.balanceOf(tx.origin) >= _amount, "Insufficient balance");
//     token.transferFrom(   _from ,_to, _amount);
//     }

// contract A {
//     function sendTokens(address _to, uint256 _value) public {
//         // Send
//         _to.transfer(_value);
//     }
// }

// contract B {
//     function receiveTokens(address _from, uint256 _value) public {
//         // Receive tokens
//         _from.transfer(_value);
//     }
//     function sendTokensToC(address _to, uint256 _value) public {
//         // Send tokens to contract C
//         contract C c = contract C(_to);
//         c.receiveTokens(msg.sender, _value);
//     }
// }

// contract C {
//     function receiveTokens(address _from, uint256 _value) public {
//         // Receive tokens
//     }
// }
// Note that this is an example code, it's not tested, and it's not recommended to use transfer function inside smart contract, because it's not safe, it's better to use approve and transferFrom functions.

//  from erc token approve token  contract A only Hold the token but trasferToken contract B code in solidity

// contract B {
//     function receiveTokens(address token ,uint256 value) public {
//         //  received tokens
//     }
// }
// pragma solidity ^0.8.0;
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";

// contract A is ERC20, SafeERC20 {
//     // Contract A's implementation of the ERC20 standard
// ...

//     function transferFrom(address from, address to, uint256 value) public returns (bool) {
//         // Check if the caller has sufficient allowance
//         require(allowance[msg.sender][from] >= value);

//         // Transfer tokens
//         balanceOf[from] = balanceOf[from].sub(value);
//         allowance[msg.sender][from] = allowance[msg.sender][from].sub(value);
//         balanceOf[to] = balanceOf[to].add(value);

//         // Send the tokens to contract B
//         B contractB = B(to);
//         contractB.receiveTokens(value);

//         emit Transfer(from, to, value);
//         return true;
//     }

//     function approve(address spender, uint256 value) public returns (bool) {
//         // Allow the spender to transfer tokens from the msg.sender's account
//         // ...
//     }
// }

// ontract ContractB {
//     Token public token;

//     function receiveTokens() public {
//         // ...
//     }
// }
// ERC-777 is a proposed standard for tokens on the Ethereum blockchain,
// which improves upon the existing ERC-20 standard. It provides additional 
// functionality such as the ability to handle advanced token operations and 
// the ability to call custom functions when tokens are transferred. 
// It is implemented in Solidity, the programming language used for smart contracts 
// on the Ethereum blockchain.