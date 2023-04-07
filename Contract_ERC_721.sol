// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintPasses is ERC721, Ownable {
    // using Counters for Counters.Counter;
    // Counters.Counter private _tokenIdTracker;
     address public admin;
    bool public mintingAllowed;
    uint public mintingStartTime;
    uint public mintingEndTime;
    
    uint256 public TotalSupply = 1000;
    uint256 public MaxiMum_Wallet = 7;
    uint256 public constant MINT_PRICE = 1 ether;
    uint256 public totalMinted;
    bool public mintingEnabled;

    bool public isMintingEnabled;
    uint256 public mintedCount = 0;
  

 
 constructor() ERC721("Mint Pass", "MINT") {
            // // Mint 111 Mint Passes to the owner's wallet
            // _mint(msg.sender, 111);
            // // Set initial values
            // totalMinted = 111;
            // mintingEnabled = true;
     
    }
     function ownerMint(uint256 amount) external onlyOwner {
        require(mintedCount + amount <= TotalSupply, "Maximum supply exceeded");
        for (uint256 i = 0; i < amount; i++) {
            _mint(owner(), mintedCount);
            mintedCount++;
        }
    }
    function _mintPasses(uint256 amount) external payable {
            mintingEndTime = mintingStartTime + 2 minutes;
           require(mintingEnabled, "Minting is currently disabled"  );
         require(mintedCount + amount <= TotalSupply, "Maximum supply");     
         require(msg.value == amount * MINT_PRICE, "Incorrect amount of Ether sent");
         require(amount > 0 && amount <= MaxiMum_Wallet, " Invalid Amount" );
         mintingAllowed = true;

            for (uint256 i = 0; i < amount; i++) {
            _mint(msg.sender, mintedCount);
             mintedCount++;
        }
    }
   
 
    // function stopMinting() public {
    //     require(msg.sender == admin, "Only admin can stop minting");
    //     require(mintingAllowed, "Minting not allowed");
    //     mintingAllowed = false;
    // }

    // function mint(uint amount) public {
    //     require(mintingAllowed, "Minting not allowed");
    //     require(block.timestamp <= mintingEndTime, "Minting period ended");

    // }
}

















// .Total supply 1000 mint passes 
//  Price of one mint is 111 matic
// Function to turn the minting on and off by the owner (the account used to deploy the smart contract on the chain) only 
//  Minting should be for 7 days – this will be achieved manually by the admin function of turning the minting on and off 
//  111 mint passes will be minted right after deployment of the smart contract and the mint passes should go in the owner’s wallet
//  Maximum 7 mint passes should be minted per wallet 
// Owner should be able to mint as many mint passes without cost (Owner minting function) 
//  Function to get list of wallet addresses who have minted so far and the amount they’ve minted (Owner only function) in solidity ERC721




    // function withdraw() public onlyOwner {
    //     payable(owner()).transfer(address(this).balance);
    // }

    // receive() external payable {}





















// pragma solidity ^0.8.0;

// // Creative Creation Token Tracker (CCC)
// contract CCC {
    
//     // Variables
//     uint256 public totalSupply = 1000;
//     uint256 public mintPrice = 111 ether;
//     uint256 public maxMintPerWallet = 7;
//     uint256 public mintingDuration = 7 days;
//     uint256 public royaltyFee = 7; // 7% royalty on mint pass sale
//     address public owner;
//     address public mintFundsReceiver = 0x114A5f47378f6e1A619F65B8cc7338B9A818A291;
//     string public mintPassURI = "https://gateway.pinata.cloud/ipfs/QmToF92ZGLihXcjiHb3GXPdEPV9NnMkkAUhArximxW8Jh2";
    
//     // Structs
//     struct MintData {
//         uint256 amount;
//         uint256 lastMintedAt;
//     }
    
//     // Mappings
//     mapping(address => MintData) public mintData;
//     mapping(address => bool) public whitelist;
    
//     // Events
//     event Mint(address indexed _wallet, uint256 indexed _amount);
//     event FundsWithdrawn(address indexed _to, uint256 indexed _amount);
    
//     // Constructor
//     constructor() {
//         owner = msg.sender;
//         // Mint 111 mint passes to the owner's wallet
//         mint(owner, 111);
//     }
    
//     // Modifiers
//     modifier onlyOwner() {
//         require(msg.sender == owner, "Only owner can perform this action");
//         _;
//     }
    
//     modifier isMintingOn() {
//         require(mintingDuration == 0 || block.timestamp <= mintData[owner].lastMintedAt + mintingDuration, "Minting is not allowed at this time");
//         _;
//     }
    
//     modifier isWhitelisted() {
//         require(!whitelist[msg.sender], "Not whitelisted");
//         _;
//     }
    
//     // Owner functions
//     function setMintingDuration(uint256 _duration) external onlyOwner {
//         mintingDuration = _duration;
//     }
    
//     function toggleMinting(bool _isMintingOn) external onlyOwner {
//         mintData[owner].lastMintedAt = _isMintingOn ? block.timestamp : 0;
//     }
    
//     function ownerMint(address _to, uint256 _amount) external onlyOwner {
//         mint(_to, _amount);
//     }
    
//     function getMintData() external view onlyOwner returns (address[] memory, uint256[] memory) {
//         address[] memory wallets = new address[](totalSupply - mintData[owner].amount);
//         uint256[] memory amounts = new uint256[](totalSupply - mintData[owner].amount);
//         uint256 i = 0;
//         for (uint256 j = 0; j < totalSupply; j++) {
//             if (address(j) != owner && mintData[address(j)].amount > 0) {
//                 wallets[i] = address(j);
//                 amounts[i] = mintData[address(j)].amount;
//                 i++;
//             }
//         }
//         return (wallets, amounts);
//     }
    
//     function withdrawFunds(address _to, uint256 _amount) external onlyOwner {
//         require(address(this).balance >= _amount, "Insufficient balance");
//         payable(_to).transfer(_amount);
//         emit FundsWithdrawn(_to, _amount);
//     }

//     function addWhitelistMember(address _wallet) external only

    // _tokenIdTracker.increment();
        // uint256 tokenId = _tokenIdTracker.current();

      // _tokenIdTracker.increment();
            // uint256 tokenId = _tokenIdTracker.current();


















