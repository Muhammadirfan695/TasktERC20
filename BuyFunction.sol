// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
library SafeMath {
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;
        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
       if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}
contract MyToken  {
    using SafeMath for uint256;

    ERC20 public token;
    address public _owner;    
    uint256 public amount;
    uint256 public tokenPerEth = 100000000000000000000;
    constructor(ERC20 _token)  {
     _owner = msg.sender;
    //token =ERC20(0x8c6AAc465302d9F6262b2907f00c62350Cf6fD74);  
      token = _token;
    }
    
  function buy() public payable{
        require(msg.value > 0, "Send the ETH to buy Token");
        address user = msg.sender;
        uint256 ethAmount = msg.value;
        uint256 tokenAmount = ((tokenPerEth).div(ethAmount));
        (bool sent) = transfer(user, tokenAmount);
        require(sent, "Falid");
    }

}










  // function buy() public payable {
//        require(msg.value > 0, "Send the ETH to buy Token"); 
//        amount = ((buyPrice).div(msg.value));                   
//         // transfer(address(this), msg.sender, amount);
//         token.transfer(msg.sender, amount);
//     }