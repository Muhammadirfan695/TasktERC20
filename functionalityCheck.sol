

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// import "@openzeppelin/contracts/access/Ownable.sol";

 contract ontrat is ERC721Enumerable{
  address public erc721Address = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
  uint256 public mintFee = 111 ether;
//   event Mint(address indexed to, uint256 indexed tokenId);


    address public owner;
// Define a struct to hold the mint data for each wallet address
     // .Total supply 1000 mint passes 
    uint256 public constant max_Supply = 1000;
    //  Price of one mint is 111 matic
    uint256 public PriceRate = 1 ether;
    // MaxWallet Size
    uint256 public constant MAxWallet = 7;
    //  Minting should be for 7 days – this will be achieved manually by the admin function of turning the minting on and off 
    uint256 public constant MintPeriodofTime = 7;
    // string private _baseURI;
    // string public constant CCC_URI = "https://gateway.pinata.cloud/ipfs/QmToF92ZGLihXcjiHb3GXPdEPV9NnMkkAUhArximxW8Jh2";
    uint256 public mintStartTime;
    bool public mintingEnabled = true;
    // mapping(address => uint256) public mintedCounts;
    bool private _mintingEnabled = false;
    bool private _whitelistEnabled = false;
    mapping(address => bool) public _whitelist;
    // mapping(address => uint256) private _mintedCounts;
    address private _feeAddress = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C;
    string private _baseTokenURI = "https://gateway.pinata.cloud/ipfs/QmToF92ZGLihXcjiHb3GXPdEPV9NnMkkAUhArximxW8Jh2/";
    uint256 private _royaltyPercentage = 7;
    bool public _mintingAllowed;
    //  mapping(address => bool)
    uint256 public totalMinters;
    mapping(address => uint256) private _mintedTokens;
mapping(address => uint256) private _ownerMintedTokens;
    constructor() ERC721("Creative Creation Mint Pass", "CCC") {
        // // _baseTokenURI =;
        owner = msg.sender;
        // //  mintingEnabled = true;
        // mintStartTime = block.timestamp;
        _mint(msg.sender, 111); // Mint one token for the contract owner
    }
        modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
   function MintData() public view returns (address[] memory, uint256[] memory) {
    address[] memory wallets = new address[](totalMinters);
    uint256[] memory mintedAmounts = new uint256[](totalMinters);
    uint256 index = 0;
    
    // Add wallet addresses and minted token amounts from regular minting
    for (uint256 i = 0; i < totalMinters; i++) {
        address wallet = mint[i];
        uint256 minted = _mintedTokens[wallet];
        if (minted > 0) {
            wallets[index] = wallet;
            mintedAmounts[index] = minted;
            index++;
        }
    }
    
    // Add wallet addresses and minted token amounts from owner minting
    uint256 totalOwnersMinters;
    for (uint256 i = 0; i < totalOwnersMinters; i++) {
        address wallet = mint[i];
        uint256 minted = _ownerMintedTokens[wallet];
        if (minted > 0) {
            wallets[index] = wallet;
            mintedAmounts[index] = minted;
            index++;
        }
    }
    
    // Resize arrays to remove unused elements
    // if (index < totalMinters + totalOwnersMinters) {
    //     assembly {
    //         mstore(wallets, index)
    //         mstore(mintedAmounts, index)
    //     }
    // }
    
    return (wallets, mintedAmounts);
}

function mint(address to, uint256 tokenId) public  {
    require(to != address(0), "ERC721: mint to the zero address");
    require(!_exists(tokenId), "ERC721: token already minted");

    _mintedTokens[msg.sender] += 1;
    _mintedTokens[to] += 1;
    
    _mint(to, tokenId);
}

function mintByOwner(address to, uint256 tokenId) public  {
    require(to != address(0), "ERC721: mint to the zero address");
    require(!_exists(tokenId), "ERC721: token already minted");

    _ownerMintedTokens[msg.sender] += 1;
    _ownerMintedTokens[to] += 1;
    
    _mint(to, tokenId);
}


// function addKey(address key) public {
//     myMapping[key] = true;
//     mappingSize++;
// }

// function removeKey(address key) public {
//     myMapping[key] = false;
//     mappingSize--;
// }
// mapping(address => bool) myMapping;
// address[] public keys;

// function addKey(address key) public {
//     myMapping[key] = true;
//     keys.push(key);
// }

// function removeKey(address key) public {
//     myMapping[key] = false;
//     for (uint256 i = 0; i < keys.length; i++) {
//         if (keys[i] == key) {
//             keys[i] = keys[keys.length - 1];
//             keys.pop();
//             break;
//         }
//     }
// }

// function getKeyAtIndex(uint256 index) public view returns (address) {
//   

    function mint(uint256 _numToMint) external payable {
        if (_whitelistEnabled) {
            require(_whitelist[msg.sender], "You are not whitelisted");
        }
       
        require(totalSupply() + _numToMint <= max_Supply,"Not enough tokens left to mint");
        require( msg.value == _numToMint * PriceRate,"Incorrect payment amount");

        uint256 mintedCount = balanceOf(msg.sender);
        require(mintedCount + _numToMint <= MAxWallet,"Exceeded max mint per wallet");
        payable(_feeAddress).transfer(msg.value * _royaltyPercentage / 100);

        // require(msg.value >= mintFee, "Insufficient minting fees");
        for (uint256 i = 0; i < _numToMint; i++) {
            uint256 tokenId = totalSupply();
            _mint(msg.sender, tokenId);
        }
    }
    // withoutcost
    event Mint(address indexed _to, uint256 amount);
    function ownerMint(uint256 _numToMint) external onlyOwner {
        require(totalSupply() + _numToMint <= max_Supply,"Not enough tokens left to mint" );

        for (uint256 i = 0; i < _numToMint; i++) {
            uint256 tokenId = totalSupply();
            _mint(msg.sender, tokenId);
            emit Mint( msg.sender,_numToMint);
        }
    }
//     //  111 mint passes will be minted right after deployment of the smart contract and the mint passes should go in the owner’s wallet
// //    Function to get list of wallet addresses who have minted so far and the amount they’ve minted (Owner only function)
//     function getMintedTokensByWallet(address _wallet)
//         external
//         view
//         onlyOwner
//         returns (uint256[] memory)
//     {
//         uint256 tokenCount = balanceOf(_wallet);
//         uint256[] memory tokenIds = new uint256[](tokenCount);
//         for (uint256 i = 0; i < tokenCount; i++) {
//             tokenIds[i] = tokenOfOwnerByIndex(_wallet, i);
//         }
//         return tokenIds;
//     }

//     function MintingOnAngOff() public onlyOwner returns (uint256)  {
//         if (mintingEnabled) {
//             mintingEnabled = false;
//             mintStartTime = 0;
//         } else {
//             mintingEnabled = true;
//             mintStartTime = block.timestamp;
//         }
//          return mintStartTime + MintPeriodofTime * 1 days;
//     }

//     function withdraw() external onlyOwner {
//         payable(msg.sender).transfer(address(this).balance);
//     }

//     function transfer(
//         address from,
//         address to,
//         uint256 tokenId
//     ) external {
//         require(_isApprovedOrOwner(msg.sender, tokenId),"Not approved or not owner.");
//         require(ownerOf(tokenId) == from, "Not current owner.");
//         _safeTransfer(from, to, tokenId, "");
//     }

//     function _baseURI() internal view virtual override returns (string memory) {
//         return _baseTokenURI;
//     }

//     function setBaseURI(string memory baseURI) public onlyOwner {
//         _baseTokenURI = baseURI;
//     }
// /*
//     // function setMaxMintPerWallet(uint256 maxMintPerWallet) external onlyOwner {
//     //     MAxWallet = maxMintPerWallet;
//     // }

//     // function setMintPrice(uint256 mintPrice) external onlyOwner {
//     //     PriceRate = mintPrice;
//     // }
// */
//     function setMintingEnabled(bool enabled) external onlyOwner {
//         _mintingEnabled = enabled;
//     }

//     function setWhitelistEnabled(bool enabled) external onlyOwner {
//         _whitelistEnabled = enabled;
//     }

//     function addToWhitelist(address wallet) external onlyOwner {
//         _whitelist[wallet] = true;
//     }

//     function removeFromWhitelist(address wallet) external onlyOwner {
//         delete _whitelist[wallet];
//     }

//     function isWhitelisted(address wallet) public view returns (bool) {
//         return _whitelist[wallet];
//     }

//     function MintData(uint256 _tokenId) public {
//         require( msg.sender == owner,"Only the contract owner can mint new tokens" );
//         for (uint256 i = 0; i < _tokenId; i++) {
//             uint256 tokenId = totalSupply();
//             _mint(msg.sender, tokenId);
            
//             //  mintedTokens(msg.sender) += 1;
//         }
//     }

//     function getMintedCountByWallet(address _wallet)
//         external
//         view
//         onlyOwner
//         returns (uint256)
//     {
//         return balanceOf(_wallet);
//     }


//    address public erc721Address = 0x114A5f47378f6e1A619F65B8cc7338B9A818A291;
// uint256 public mintFee = 111 ether;

// function mint(address recipient) public payable {
//     require(msg.value >= mintFee, "Not enough ether sent for minting fee");
    
//     // Mint the token
//     uint256 tokenId = /* generate new token ID */;
//     /* perform any additional minting logic */
    
//     // Send the fee to the ERC721 contract
//     (bool sent, ) = erc721Address.call{value: mintFee}("");
//     require(sent, "Failed to send minting fee");
    
//     // Transfer the token to the recipient
//     /* perform any additional token transfer logic */
//     _safeMint(recipient, tokenId);
// }
 
}





