// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}



interface IERC777 {
    function burn(uint256 amount, bytes calldata data) external;
    function send(address recipient, uint256 amount , bytes memory  data) external;                                                                                  
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    function transfer(address recipient, uint amount) external returns (bool);
}

contract ReferralStaking {
    using SafeMath for uint256;

    struct User {
        address Structreferrer2;
        uint256[] levels;
    }

    mapping (address => User) public users;
    mapping (uint256 => uint256) public levelPercents;
    uint256 public constant MAX_LEVEL = 6;
    IERC777 public token;

    event NewUser(address indexed user, address indexed referrer);
    event Staked(address indexed user, uint256 amount, address indexed referrer, uint256[] levels);
    event Withdrawn(address indexed user, uint256 amount);

    constructor(IERC777 _token) {
        token = _token;
        levelPercents[0] = 50;
        levelPercents[1] = 30;
        levelPercents[2] = 20;
        levelPercents[3] = 10;
        levelPercents[4] = 5;
        levelPercents[5] = 5;
    }

    function register(address referrer) external {
        require(users[msg.sender].Structreferrer2 == address(0), "User already registered");
        if (referrer != address(0) && users[referrer].Structreferrer2 != address(0)) {
            users[msg.sender].Structreferrer2 = referrer;
        }
        users[msg.sender].levels = new uint256[](MAX_LEVEL);
        emit NewUser(msg.sender, referrer);
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Invalid amount");
        require(token.balanceOf(msg.sender) >= amount, "Insufficient balance");
        token.transferFrom(msg.sender,address(this),amount);
        users[msg.sender].levels[0] = amount.mul(levelPercents[0]).div(1000);
        address referrer1 = users[msg.sender].Structreferrer2;
        for (uint256 i = 1; i < MAX_LEVEL; i++) {
            if (referrer1 == address(0)) {
                break;
            }
                uint256 percent = levelPercents[i];
                users[referrer1].levels[i] = users[referrer1].levels[i].add(amount.mul(percent).div(1000));
                 referrer1 = users[referrer1].Structreferrer2;
        } 
         emit Staked(msg.sender, amount, users[msg.sender].Structreferrer2, users[msg.sender].levels);
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Invalid amount");
        require(token.balanceOf(address(this)) >= amount, "Insufficient balance");
        token.transferFrom(msg.sender,address(this), amount);
        emit Withdrawn(msg.sender, amount);
    }
}