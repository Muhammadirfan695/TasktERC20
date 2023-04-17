

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
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
contract MyToken is ERC20 {
    ERC20 public token;
     using SafeMath for uint256;
    address public _owner;    
    uint256 public amount;
    uint256 public buyPrice = 100;
    constructor() ERC20("Skil token", "skc") {
        _owner = msg.sender;
        _mint(address(this), 100000000 * 10**18);
        _mint(msg.sender, 100000000 * 10**18);

    }

function buy() public payable {
        amount = msg.value * buyPrice;                    
        // transfer(address(this), msg.sender, amount);
        transfer(address(this), amount);
    }
    //  function mint(address to, uint256 amount) external  {
    //     require(msg.sender == _owner, "only owner");
    //     _mint(to, amount);
    // }
}