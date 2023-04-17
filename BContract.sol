// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
// interface IERC20 {
//     function balanceOf(address account) external view returns (uint256);
//     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
   
// }
// contract B  {  
// function transferTokenBalance( IERC20 tokenA ,address _to,  uint256 _amount) external {
//     require(tokenA.balanceOf(msg.sender) >= _amount, "Insufficient balance");
//     tokenA.transferFrom( msg.sender , _to, _amount);
 
// }}



interface ERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract TokenTransfer {
    ERC20 public tokenContract;

    constructor(address _tokenContract) {
        tokenContract = ERC20(_tokenContract);
    }
    function transferTokens(address _recipient, uint256 _amount) public {
        require(tokenContract.transfer(_recipient, _amount), "Token transfer failed");
    }
}



// interface IERC20 {
    
//     function totalSupply() external view returns (uint256);
//     function balanceOf(address account) external view returns (uint256);
//     function transfer(address recipient, uint256 amount) external returns (bool);
//     function allowance(address owner, address spender) external view returns (uint256);
//     function approve(address spender, uint256 amount) external returns (bool);
//     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
//     event Transfer(address indexed from, address indexed to, uint256 value);
//     event Approval(address indexed owner, address indexed spender, uint256 value);
// }

// contract Irfan  {

//     // IERC20 public Token;
//        IERC20 public token;
//     // address public _owner;
  
//     mapping(address=>uint256) public balances;  
//     event LogDepositeMade(address accountHoder, uint256 amount);

//     constructor(IERC20 _token) {

//         // _owner = msg.sender;
//         token = _token;

//     }
//     function TokenTransferToUser(address[] memory recipients, uint256 amount) public {
//         require(amount > 0, "Invalid amount");
//         for (uint256 i = 0; i < recipients.length; i++) {
//             token.transfer(recipients[i], amount);
//             balances[recipients[i]] +=amount;
//             balances[msg.sender] -=amount;
//         }
//     }

// }