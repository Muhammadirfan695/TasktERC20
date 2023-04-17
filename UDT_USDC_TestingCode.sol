// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.17;

// interface IERC20 {
//     // function transfer(address to, uint256 value) external returns (bool);
//     function transferFrom(address from, address to, uint256 value) external returns (bool);
//     function balanceOf(address account) external view returns (uint256);
// }
// interface IRERC20 {
//     function transfer(address to, uint256 value) external returns (bool);
//     // function transferFrom(address from, address to, uint256 value) external returns (bool);
//     function balanceOf(address account) external view returns (uint256);
// }

// contract ContractB {
//     using SafeMath for uint256;
//     IERC20 public USDTA;
//     IRERC20 public USDC;
    
//     constructor(address _USDT, address _USDC)  {
//         USDTA = IERC20(_USDT);
//         USDC = IRERC20(_USDC);
//     }

//     function transferTokenBalance(  uint256 _amount) external {
//      USDTA.transferFrom(msg.sender , address(this), _amount);
//     // tokenC.transfer(address());
    
//  }

// }



// Create ERC20 token with name USDT
// Create ERC20 token with name USDC
// create a Smart Contract to buy USDC buy USDT
// when someone will buy USDC with with USDT then USDT will burn and USDC will be minted
// when someone will sell USDC  then usdt will minted and USDC will burn




// import "./USDTA.sol";

// contract USDCBuyer {
//     ContractA public usdt;
//     ContractA public usdc;

//     constructor(address _usdtAddress, address _usdcAddress) {
//         usdt = ContractA(_usdtAddress);
//         usdc = ContractA(_usdcAddress);
//     }

//     function buyUSDC(uint256 _usdtAmount) public {
//         require(usdt.transferFrom(msg.sender, address(this), _usdtAmount), "USDT transfer failed");
//         uint256 usdcAmount = _usdtAmount; // 1:1 exchange rate
//         usdc.transfer(msg.sender, usdcAmount);
//         usdt.burn(_usdtAmount);
//     }

//     // function sellUSDC(uint256 _usdcAmount) public {
//     //     require(usdc.transferFrom(msg.sender, address(this), _usdcAmount), "USDC transfer failed");
//     //     uint256 usdtAmount = _usdcAmount; // 1:1 exchange rate
//     //     usdt._mint(msg.sender, usdtAmount);
//     //     usdc.burn(_usdcAmount);
//     // }
// }


// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// contract USDT is ERC20 {
//     constructor() ERC20("USDT", "USDT") {
//         _mint(msg.sender, 1000000 * 10 ** decimals());
//     }
// }

// contract USDC is ERC20 {
//     constructor() ERC20("USDC", "USDC") {
//         _mint(msg.sender, 1000000 * 10 ** decimals());
//     }
// }

// pragma solidity ^0.8.0;

// import "./USDT.sol";
// import "./USDC.sol";

// contract USDTUSDCExchange {
//     USDT public usdt;
//     USDC public usdc;

//     constructor(USDT _usdt, USDC _usdc) {
//         usdt = _usdt;
//         usdc = _usdc;
//     }

//     function buyUSDC(uint256 amount) public {
//         require(usdt.balanceOf(msg.sender) >= amount, "Insufficient USDT balance");

//         usdt.transferFrom(msg.sender, address(this), amount);
//         usdt.burn(amount);
//         usdc.mint(msg.sender, amount);
//     }

//     function sellUSDC(uint256 amount) public {
//         require(usdc.balanceOf(msg.sender) >= amount, "Insufficient USDC balance");

//         usdc.transferFrom(msg.sender, address(this), amount);
//         usdc.burn(amount);
//         usdt.mint(msg.sender, amount);
//     }
// }


// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// contract USDT is ERC20 {
//     constructor() ERC20("USDT", "USDT") {
//         _mint(msg.sender, 1000000 * 10 ** decimals());
//     }
// }

// contract USDC is ERC20 {
//     constructor() ERC20("USDC", "USDC") {
//         _mint(msg.sender, 1000000 * 10 ** decimals());
//     }
// }

// pragma solidity ^0.8.0;

// import "./USDT.sol";
// import "./USDC.sol";

// contract USDTUSDCExchange {
//     USDT public usdt;
//     USDC public usdc;

//     constructor(USDT _usdt, USDC _usdc) {
//         usdt = _usdt;
//         usdc = _usdc;
//     }

//     function buyUSDC(uint256 amount) public {
//         require(usdt.balanceOf(msg.sender) >= amount, "Insufficient USDT balance");

//         usdt.transferFrom(msg.sender, address(this), amount);
//         usdt.burn(amount);
//         usdc.mint(msg.sender, amount);
//     }

//     function sellUSDC(uint256 amount) public {
//         require(usdc.balanceOf(msg.sender) >= amount, "Insufficient USDC balance");

//         usdc.transferFrom(msg.sender, address(this), amount);
//         usdc.burn(amount);
//         usdt.mint(msg.sender, amount);
//     }
// }



// Create ERC20 token with name USDT
// Create ERC20 token with name USDC

// create a Smart Contract to buy USDC buy USDT
// when someone will buy USDC with with USDT then USDT will burn and USDC will be minted
// when someone will sell USDC  then usdt will minted and USDC will burn in solidity


// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// contract USDT is ERC20 {
//     constructor() ERC20("USDT", "USDT") {
//         _mint(msg.sender, 1000000000 * 10 ** decimals());
//     }
// }

// contract USDC is ERC20 {
//     constructor() ERC20("USDC", "USDC") {
//         _mint(msg.sender, 1000000000 * 10 ** decimals());
//     }
// }

// contract USDCBuyer {
//     USDT usdt;
//     USDC usdc;

//     constructor(USDT _usdt, USDC _usdc) {
//         usdt = _usdt;
//         usdc = _usdc;
//     }

//     function buyUSDC(uint256 _usdtAmount) public {
//         require(_usdtAmount > 0, "Amount must be greater than 0");
//         require(usdt.balanceOf(msg.sender) >= _usdtAmount, "Insufficient USDT balance");

//         uint256 usdcAmount = _usdtAmount; // 1:1 exchange rate
//         usdt.transferFrom(msg.sender, address(this), _usdtAmount);
//         usdt.burn(_usdtAmount);
//         usdc.mint(msg.sender, usdcAmount);
//     }

//     function sellUSDC(uint256 _usdcAmount) public {
//         require(_usdcAmount > 0, "Amount must be greater than 0");
//         require(usdc.balanceOf(msg.sender) >= _usdcAmount, "Insufficient USDC balance");

//         uint256 usdtAmount = _usdcAmount; // 1:1 exchange rate
//         usdc.transferFrom(msg.sender, address(this), _usdcAmount);
//         usdc.burn(_usdcAmount);
//         usdt.mint(msg.sender, usdtAmount);
//     }
// }

// import "./USDT.sol";
// import "./USDC1.sol";

// contract USDTUSDCExchange {
//     USDT public usdt;
//     USDC public usdc;

//     constructor(USDT _usdt, USDC _usdc) {
//         usdt = _usdt;
//         usdc = _usdc;
//     }

//     function buyUSDC(uint256 amount) public {
//         require(usdt.balanceOf(msg.sender) >= amount, "Insufficient USDT balance");

//         usdt.transferFrom(msg.sender, address(this), amount);
//         // usdt._burn(amount);
//         // usdc.mint(msg.sender, amount);
//     }

//     function sellUSDC(uint256 amount) public {
//         require(usdc.balanceOf(msg.sender) >= amount, "Insufficient USDC balance");

//         usdc.transferFrom(msg.sender, address(this), amount);
//         // usdc.burn(amount);
//         // usdt.mint(msg.sender, amount);
//     }
// }


// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// contract USDT is ERC20 {
//     constructor() ERC20("USDT", "USDT") {
//         _mint(msg.sender, 1000000 * 10 ** decimals());
//     }
// }

// contract USDC is ERC20 {
//     constructor() ERC20("USDC", "USDC") {
//         _mint(msg.sender, 1000000 * 10 ** decimals());
//     }
// }

// pragma solidity ^0.8.0;

// import "./USDT.sol";
// import "./USDC.sol";

// contract USDTUSDCExchange {
//     USDT public usdt;
//     USDC public usdc;

//     constructor(USDT _usdt, USDC _usdc) {
//         usdt = _usdt;
//         usdc = _usdc;
//     }

//     function buyUSDC(uint256 amount) public {
//         require(usdt.balanceOf(msg.sender) >= amount, "Insufficient USDT balance");

//         usdt.transferFrom(msg.sender, address(this), amount);
//         usdt.burn(amount);
//         usdc.mint(msg.sender, amount);
//     }

//     function sellUSDC(uint256 amount) public {
//         require(usdc.balanceOf(msg.sender) >= amount, "Insufficient USDC balance");

//         usdc.transferFrom(msg.sender, address(this), amount);
//         usdc.burn(amount);
//         usdt.mint(msg.sender, amount);
//     }
// }



// Create ERC20 token with name USDT
// Create ERC20 token with name USDC

// create a Smart Contract to buy USDC buy USDT
// when someone will buy USDC with with USDT then USDT will burn and USDC will be minted
// when someone will sell USDC  then usdt will minted and USDC will burn in solidity




// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// contract USDT is ERC20 {
//     constructor() ERC20("USDT", "USDT") {
//         _mint(msg.sender, 1000000000 * 10 ** decimals());
//     }
// }

// contract USDC is ERC20 {
//     constructor() ERC20("USDC", "USDC") {
//         _mint(msg.sender, 1000000000 * 10 ** decimals());
//     }
// }

// contract USDCBuyer {
//     USDT usdt;
//     USDC usdc;

//     constructor(USDT _usdt, USDC _usdc) {
//         usdt = _usdt;
//         usdc = _usdc;
//     }

//     function buyUSDC(uint256 _usdtAmount) public {
//         require(_usdtAmount > 0, "Amount must be greater than 0");
//         require(usdt.balanceOf(msg.sender) >= _usdtAmount, "Insufficient USDT balance");

//         uint256 usdcAmount = _usdtAmount; // 1:1 exchange rate
//         usdt.transferFrom(msg.sender, address(this), _usdtAmount);
//         usdt._burn(_usdtAmount);
//         usdc.mint(msg.sender, usdcAmount);
//     }

//     function sellUSDC(uint256 _usdcAmount) public {
//         require(_usdcAmount > 0, "Amount must be greater than 0");
//         require(usdc.balanceOf(msg.sender) >= _usdcAmount, "Insufficient USDC balance");

//         uint256 usdtAmount = _usdcAmount; // 1:1 exchange rate
//         usdc.transferFrom(msg.sender, address(this), _usdcAmount);
//         usdc.burn(_usdcAmount);
//         usdt.mint(msg.sender, usdtAmount);
//     }
// }

// import "./USDTA.sol";
// // import "./USDCC.sol";

// contract USDT is ERC20 {
//         constructor () ERC20("Arbitech Solution", "ArbiCoin",18) {
//          _mint(msg.sender,(100000*(10**18)));
//     }
// }

// contract USDC is ERC20 {
//     constructor() ERC20("USDC", "USDC",18) {
//          _mint(msg.sender,(100000*(10**18)));
//     }
// }


// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// contract USDT is ERC20 {
//     constructor() ERC20("USDT", "USDT") {
//         _mint(msg.sender, 1000000000 * 10 ** decimals());
//     }
// }

// contract USDC is ERC20 {
//     constructor() ERC20("USDC", "USDC") {
//         _mint(msg.sender, 1000000000 * 10 ** decimals());
//     }
// }
// contract USDCBuyer {
//     USDT usdt;
//     USDC usdc;

//     constructor(USDT _usdt, USDC _usdc) {
//         usdt = _usdt;
//         usdc = _usdc;
//     }

//     function buyUSDC(uint256 _usdtAmount) public {
//         require(_usdtAmount > 0, "Amount must be greater than 0");
//         require(usdt.balanceOf(msg.sender) >= _usdtAmount, "Insufficient USDT balance");

//         uint256 usdcAmount = _usdtAmount; // 1:1 exchange rate
//         usdt.transferFrom(msg.sender, address(this), _usdtAmount);
//         usdt._burn(_usdtAmount);
//         usdc.mint(msg.sender, usdcAmount);
//     }

//     function sellUSDC(uint256 _usdcAmount) public {
//         require(_usdcAmount > 0, "Amount must be greater than 0");
//         require(usdc.balanceOf(msg.sender) >= _usdcAmount, "Insufficient USDC balance");

//         uint256 usdtAmount = _usdcAmount; // 1:1 exchange rate
//         usdc.transferFrom(msg.sender, address(this), _usdcAmount);
//         usdc.burn(_usdcAmount);
//         usdt.mint(msg.sender, usdtAmount);
//     }
// }
 // function buyUSDC(uint256 _usdtAmount) public {
    //     require(usdt.transferFrom(msg.sender, address(this), _usdtAmount), "USDT transfer failed");
    //     uint256 usdcAmount = _usdtAmount; // 1:1 exchange rate
    //     usdc.transfer(msg.sender, usdcAmount);
    //     usdt.burn(_usdtAmount);
    // }

    // function sellUSDC(uint256 _usdcAmount) public {
    //     require(usdc.transferFrom(msg.sender, address(this), _usdcAmount), "USDC transfer failed");
    //     uint256 usdtAmount = _usdcAmount; // 1:1 exchange rate
    //     usdt.mint(msg.sender, usdtAmount);
    //     usdc.burn(_usdcAmount);
    // }

contract USDCBuyer {
    USDT usdt;
    USDC usdc;

    constructor(USDT _usdt, USDC _usdc) {
        usdt = _usdt;
        usdc = _usdc;
    }

    function buyUSDC(uint256 _usdtAmount) public {
        require(_usdtAmount > 0, "Amount must be greater than 0");
        require(usdt.balanceOf(msg.sender) >= _usdtAmount, "Insufficient USDT balance");

        uint256 usdcAmount = _usdtAmount; // 1:1 exchange rate
        usdt.transferFrom(msg.sender, address(this), _usdtAmount);
        usdt.burn(_usdtAmount);
        usdc.mint(msg.sender, usdcAmount);
    }

    function sellUSDC(uint256 _usdcAmount) public {
        require(_usdcAmount > 0, "Amount must be greater than 0");
        require(usdc.balanceOf(msg.sender) >= _usdcAmount, "Insufficient USDC balance");

        uint256 usdtAmount = _usdcAmount; // 1:1 exchange rate
        usdc.transferFrom(msg.sender, address(this), _usdcAmount);
        usdc.burn(_usdcAmount);
        usdt.mint(msg.sender, usdtAmount);
    }
}
