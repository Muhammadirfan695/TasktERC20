// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.17;
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

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint256 amount) external  ;
    function transfer(address recipient, uint256 amount) external;
    function Mint(address account, uint256 amount) external ;
    function burn(uint256 amount) external  ;
}

contract USDCBuyer {
    IERC20 public usdtA;
    IERC20 public usdcC;
    address public owner;

modifier onlyOwner {
    require(msg.sender == owner, "Only contract owner can call this function");
    _;
}
    constructor(address _usdtAddress, address _usdcAddress) {
         owner = msg.sender;
        usdtA = IERC20(_usdtAddress);
        usdcC = IERC20(_usdcAddress);
    }

    function transferTokenBalance(  uint256 _amount) external {

    usdtA.transferFrom(msg.sender , address(this), _amount);
    usdcC.transferFrom(owner, msg.sender, _amount);
 }
}


