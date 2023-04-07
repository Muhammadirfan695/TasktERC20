function listWhitelistMembers() external view returns (address[] memory) {
    require(msg.sender == owner(), "Only the contract owner can call this function.");

    uint256 count = 0;
    for (uint256 i = 0; i < balanceOf(owner()); i++) {
        uint256 tokenId = tokenOfOwnerByIndex(owner(), i);
        address wallet = address(tokenId);
        if (whitelist[wallet]) {
            count++;
        }
    }
    address[] memory members = new address[](count);
    uint256 index = 0;
    for (uint256 i = 0; i < balanceOf(owner()); i++) {
        uint256 tokenId = tokenOfOwnerByIndex(owner(), i);
        address wallet = address(tokenId);
        if (whitelist[wallet]) {
            members[index] = wallet;
            index++;
        }
    }
    return members;
}

function listWhitelistMembers() external view returns (address[] memory) {
    require(msg.sender == owner(), "Only the contract owner can call this function.");
    
    uint256 count = 0;
    for (uint256 i = 0; i < balanceOf(owner()); i++) {
        address wallet = tokenOfOwnerByIndex(owner(), i);
        if (whitelist[wallet]) {
            count++;
        }  
    }
    address[] memory members = new address[](count);
    uint256 index = 0;
    for (uint256 i = 0; i < balanceOf(owner()); i++) {
        address wallet = tokenOfOwnerByIndex(owner(), i);
        if (whitelist[wallet]) {
            members[index] = wallet;
            index++;
        }
    }
    return members;
}

mapping(address => bool) whitelist;

function listWhitelistMembers() external view returns (address[] memory) {
    uint256 count = 0;
    for (uint256 i = 0; i < balanceOf(owner()); i++) {
        address wallet = tokenOfOwnerByIndex(owner(), i);
        if (whitelist[wallet]) {
            count++;
        }
    }
    address[] memory members = new address[](count);
    uint256 index = 0;
    for (uint256 i = 0; i < balanceOf(owner()); i++) {
        address wallet = tokenOfOwnerByIndex(owner(), i);
        if (whitelist[wallet]) {
            members[index] = wallet;
            index++;
        }
    }
    return members;
}

function listWhitelistMembers() external view returns (address[] memory) {
    uint256 count = 0;
    for (uint256 i = 0; i < balanceOf(owner()); i++) {
        address wallet = tokenOfOwnerByIndex(owner(), i);
        if (whitelist[wallet]) {
            count++;
        }
    }
    address[] memory members = new address[](count);
    uint256 index

function listWhitelistMembers() external view returns (address[] memory) {
    uint256 count = 0;
    uint256 tokenCount = IERC721(this).balanceOf(address(this));
    for (uint256 i = 0; i < tokenCount; i++) {
        address wallet = IERC721(this).tokenOfOwnerByIndex(address(this), i);
        if (whitelist[wallet]) {
            count++;
        }
    }
    address[] memory members = new address[](count);
    uint256 index = 0;
    for (uint256 i = 0; i < tokenCount; i++) {
        address wallet = IERC721(this).tokenOfOwnerByIndex(address(this), i);
        if (whitelist[wallet]) {
            members[index] = wallet;
            index++;
        }
    }
    return members;
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFT is ERC721 {
    address[] private whitelist;

    bool public mintingAllowedOnlyForWhitelist = false;

    // Function to add a wallet address to the whitelist
    function addToWhitelist(address _wallet) external onlyOwner {
        require(!isWhitelisted(_wallet), "Address is already whitelisted");
        whitelist.push(_wallet);
    }

    // Function to start minting only for whitelist members
    function startMintingOnlyForWhitelist() external onlyOwner {
        mintingAllowedOnlyForWhitelist = true;
    }

    // Function to remove a wallet address from the whitelist
    function removeFromWhitelist(address _wallet) external onlyOwner {
        require(isWhitelisted(_wallet), "Address is not whitelisted");
        for (uint i = 0; i < whitelist.length; i++) {
            if (whitelist[i] == _wallet) {
                whitelist[i] = whitelist[whitelist.length - 1];
                whitelist.pop();
                break;
            }
        }
    }

    // Function to list all wallet addresses in the whitelist
    function listWhitelistMembers() external view onlyOwner returns (address[] memory) {
        return whitelist;
    }

    // Function to check if a wallet address is added to the whitelist
    function isWhitelisted(address _wallet) public view returns (bool) {
        for (uint i = 0; i < whitelist.length; i++) {
            if (whitelist[i] == _wallet) {
                return true;
            }
        }
        return false;
    }

    // Function to stop minting for whitelist members
    function stopMintingForWhitelist() external onlyOwner {
        mintingAllowedOnlyForWhitelist = false;
    }

    // Override the _beforeTokenTransfer function to check if minting is only allowed for whitelist members
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);
        if (from == address(0)) {
            // Minting new token
            if (mintingAllowedOnlyForWhitelist) {
                require(isWhitelisted(to), "Minting only allowed for whitelist members");
            }
        }
    }

    // Constructor
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {
    mapping(address => bool) private _whitelist;

    bool private _mintingStarted;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    // Function to add whitelist members
    function addWhitelistMember(address member) external onlyOwner {
        _whitelist[member] = true;
    }

    // Function to start minting only for whitelist members
    function startMintingForWhitelist() external onlyOwner {
        _mintingStarted = true;
    }

    // Function to remove whitelist members
    function removeWhitelistMember(address member) external onlyOwner {
        _whitelist[member] = false;
    }

    // Function to list whitelist members
    function listWhitelistMembers() external view onlyOwner returns (address[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < ERC721.totalSupply(); i++) {
            address owner = ERC721.ownerOf(i);
            if (_whitelist[owner]) {
                count++;
            }
        }
        address[] memory members = new address[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < ERC721.totalSupply(); i++) {
            address owner = ERC721.ownerOf(i);
            if (_whitelist[owner]) {
                members[index] = owner;
                index++;
            }
        }
        return members;
    }

    // Function to check if a wallet address is added in whitelist
    function isWhitelistMember(address member) external view returns (bool) {
        return _whitelist[member];
    }

    // Function to stop minting for whitelist members
    function stopMintingForWhitelist() external onlyOwner {
        _mintingStarted = false;
    }

    // Override _beforeTokenTransfer to enforce whitelist for minting
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
        if (!_mintingStarted && _whitelist[to]) {
            revert("Minting is only allowed for whitelist members");
        }
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // Override _mint to enforce whitelist for minting
    function _mint(address to, uint256 tokenId) internal virtual override {
        if (!_mintingStarted && _whitelist[to]) {
            revert("Minting is only allowed for whitelist members");
        }
        super._mint(to, tokenId);
    }
}

In Solidity, a mapping is a key-value store where each key is mapped to a value. The syntax for declaring a mapping is as follows:

typescript
Copy code
mapping (keyType => valueType) public myMapping;
Here, keyType is the data type of the mapping keys, and valueType is the data type of the mapping values. The public keyword makes the mapping publicly accessible, meaning that other contracts can read its values.

An array is a collection of elements of the same data type. In Solidity, you can declare an array using the following syntax:

java
Copy code
dataType[] public myArray;
Here, dataType is the data type of the array elements. The public keyword makes the array publicly accessible, meaning that other contracts can read and write its elements.

You can also declare a mapping of arrays, which is a mapping where each key is mapped to an array of values. Here's an example:

csharp
Copy code
mapping (address => uint[]) public balances;
This declares a mapping called balances where each key is an address and each value is an array of unsigned integers. You can access an element in the array for a given key using the square bracket notation:

css
Copy code
uint[] memory myBalance = balances[msg.sender];
uint myTokenCount = myBalance[0];
In this example, we're retrieving the balance array for the msg.sender address and accessing the first element in the array to get the token count for that address. Note that we're using the memory keyword to create a new memory array variable to store the array retrieved from the mapping. This is because mappings cannot be accessed directly in memory; they must first be retrieved and stored in a variable.// function listWhitelistMembers() public view returns (address[] memory) {
mapping (keyType => valueType) public myMapping;
dataType[] public myArray;
mapping (address => uint[]) public balances;
uint[] memory myBalance = balances[msg.sender];
uint myTokenCount = myBalance[0];

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WhitelistERC721 is ERC721, Ownable {

    mapping(address => bool) public whitelist;
    bool public mintingEnabled = false;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    function addToWhitelist(address[] memory _addresses) external onlyOwner {
        for (uint i = 0; i < _addresses.length; i++) {
            whitelist[_addresses[i]] = true;
        }
    }

    function startMintingForWhitelist() external onlyOwner {
        mintingEnabled = true;
    }

    function removeFromWhitelist(address[] memory _addresses) external onlyOwner {
        for (uint i = 0; i < _addresses.length; i++) {
            whitelist[_addresses[i]] = false;
        }
    }

    function getWhitelistMembers() external view returns (address[] memory) {
        uint count = 0;
        for (uint i = 0; i < balanceOf(owner()); i++) {
            address wallet = tokenOfOwnerByIndex(owner(), i);
            if (whitelist[wallet]) {
                count++;
            }
        }
        address[] memory result = new address[](count);
        count = 0;
        for (uint i = 0; i < balanceOf(owner()); i++) {
            address wallet = tokenOfOwnerByIndex(owner(), i);
            if (whitelist[wallet]) {
                result[count] = wallet;
                count++;
            }
        }
        return result;
    }

    function isWhitelisted(address _address) external view returns (bool) {
        return whitelist[_address];
    }

    function stopMintingForWhitelist() external onlyOwner {
        mintingEnabled = false;
    }

    function mint(address to, uint256 tokenId) public override {
        require(mintingEnabled && whitelist[msg.sender], "Minting not enabled for this address");
        super.mint(to, tokenId);
    }

}

//     uint count = 0;
//     for (uint i = 0; i < _tokenIds.current() ; i++) {
//         address owner = ownerOf(i);
//         if (whitelist[owner]) {
//             count++;
//         }
//     }
//     address[] memory members = new address[](count);
//     uint index = 0;
//     for (uint i = 0; i < _tokenIds.current(); i++) {
//         address owner = ownerOf(i);
//         if (whitelist[owner]) {
//             members[index] = owner;
//             index++;
//         }
//     }
//     return members;
// }
// for (uint256 i = 0; i < _numToMint; i++) {
        //     _safeMint(msg.sender, _getNextTokenId());
        // }
//   function _getNextTokenId() private view returns (uint256) {
//         return totalSupply() + 1;
//     }
function whitelistAddress(address _address) external {
        require(msg.sender == owner(), "Only owner can whitelist");
        ArrayWhitelisted.push(_address);
    }

    function isWhitelisted(address _address) public view returns (bool) {
        for (uint i = 0; i < ArrayWhitelisted.length; i++) {
            if (ArrayWhitelisted[i] == _address) {
                return true;
            }
        }
        return false;
    }

    function getWhitelist() public view returns (address[] memory) {
        return ArrayWhitelisted;
    }




function checkWhitelist(address[] storage ArrayWhitelisted) public view returns (bool) {
    for (uint i = 0; i < ArrayWhitelisted.length; i++) {
        if (ArrayWhitelisted[i] == msg.sender) {
            return true;
        }
    }
    return false;
}

// Usage
require(checkWhitelist(ArrayWhitelisted), "You are not whitelisted");

mapping (address => bool) public whitelist;

function listWhitelistMembers() public view returns (address[] memory) {
    uint count = 0;
    for (uint i = 0; i < totalSupply(); i++) {
        address owner = ownerOf(i);
        if (whitelist[owner]) {
            count++;
        }
    }
    address[] memory members = new address[](count);
    uint index = 0;
    for (uint i = 0; i < totalSupply(); i++) {
        address owner = ownerOf(i);
        if (whitelist[owner]) {
            members[index] = owner;
            index++;
        }
    }
    return members;
}

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFT is ERC721 {

    address[] public whitelist;

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}

    function whitelistAddress(address _address) external {
        require(msg.sender == owner(), "Only owner can whitelist");
        whitelist.push(_address);
    }

    function isWhitelisted(address _address) public view returns (bool) {
        for (uint i = 0; i < whitelist.length; i++) {
            if (whitelist[i] == _address) {
                return true;
            }
        }
        return false;
    }

    function getWhitelist() public view returns (address[] memory) {
        return whitelist;
    }
}

function getWhitelistMembers() public view returns(address[] memory) {
    uint256 totalSupply = token.totalSupply();
    address[] memory whitelistMembers = new address[](totalSupply);
    uint256 count = 0;
    for (uint256 i = 0; i < totalSupply; i++) {
        address owner = token.ownerOf(i);
        if (whitelist[owner] == true) {
            whitelistMembers[count] = owner;
            count++;
        }
    }
    address[] memory result = new address[](count);
    for (uint256 i = 0; i < count; i++) {
        result[i] = whitelistMembers[i];
    }
    return result;
}

pragma solidity ^0.8.0;

contract Whitelist {
    address[] private allowed;

    function addAllowed(address addr) public {
        allowed.push(addr);
    }

    function removeAllowed(address addr) public {
        for (uint i = 0; i < allowed.length; i++) {
            if (allowed[i] == addr) {
                allowed[i] = allowed[allowed.length - 1];
                allowed.pop();
                break;
            }
        }
    }

    function isAllowed(address addr) public view returns (bool) {
        for (uint i = 0; i < allowed.length; i++) {
            if (allowed[i] == addr) {
                return true;
            }
        }
        return false;
    }

    function getAllowed() public view returns (address[] memory) {
        return allowed;
    }
}

mapping (address => uint) public mintCount;

function MintData() public view returns (address[] memory, uint[] memory) {
    uint length = 0;
    for (uint i = 0; i < mintPassList.length; i++) {
        if (mintCount[mintPassList[i].owner] > 0) {
            length++;
        }
    }
    address[] memory walletAddresses = new address[](length);
    uint[] memory mintCounts = new uint[](length);
    uint j = 0;
    for (uint i = 0; i < mintPassList.length; i++) {
        address owner = mintPassList[i].owner;
        uint count = mintCount[owner];
        if (count > 0) {
            walletAddresses[j] = owner;
            mintCounts[j] = count;
            j++;
        }
    }
    return (walletAddresses, mintCounts);
}

// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MintPass is ERC721 {
    
    address public owner;
    uint public totalSupply = 1000;
    uint public mintedSupply = 0;
    uint public price = 111 * 10**18; // 111 Matic
    uint public maxMintPerWallet = 7;
    bool public mintingEnabled = false;
    bool public whitelistMintingOnly = false;
    
    mapping(address => uint) public mintedCount;
    mapping(address => bool) public whitelist;
    
    address public CCCContract = 0x114A5f47378f6e1A619F65B8cc7338B9A818A291;
    uint public royaltyFee = 7;
    
    constructor() ERC721("MintPass", "MINT") {
        owner = msg.sender;
        mint(owner);
    }
    
    function mint(address to, uint amount) public payable {
        require(msg.sender == owner || (whitelistMintingOnly && whitelist[msg.sender]), "Minting not allowed");
        require(mintingEnabled, "Minting is not enabled");
        require(amount > 0 && mintedSupply + amount <= totalSupply, "Invalid amount to mint");
        require(amount + mintedCount[to] <= maxMintPerWallet, "Minting limit exceeded");
        require(msg.value >= amount * price, "Insufficient ether");
        
        mintedSupply += amount;
        mintedCount[to] += amount;
        
        for (uint i = 0; i < amount; i++) {
            _safeMint(to, mintedSupply - amount + i + 1);
        }
        
        if (msg.sender != owner) {
            uint royalty = (msg.value * royaltyFee) / 100;
            payable(owner).transfer(royalty);
        }
    }
    
    function ownerMint(address to, uint amount) public {
        require(msg.sender == owner, "Not authorized");
        mint(to, amount);
    }
    
    function enableMinting() public {
        require(msg.sender == owner, "Not authorized");
        mintingEnabled = true;
    }
    
    function disableMinting() public {
        require(msg.sender == owner, "Not authorized");
        mintingEnabled = false;
    }
    
    function setMaxMintPerWallet(uint value) public {
        require(msg.sender == owner, "Not authorized");
        maxMintPerWallet = value;
    }
    
    function setPrice(uint value) public {
        require(msg.sender == owner, "Not authorized");
        price = value;
    }
    
    function setRoyaltyFee(uint value) public {
        require(msg.sender == owner, "Not authorized");
        royaltyFee = value;
    }
    
    function setWhitelistMintingOnly(bool value) public {
        require(msg.sender == owner, "Not authorized");
        whitelistMintingOnly = value;
    }
    
    function addToWhitelist(address[] calldata addresses) public {
        require(msg.sender == owner, "Not authorized");
        for (uint i = 0; i < addresses.length; i++) {
            whitelist[addresses[i]] = true;
        }
    }
    
    function removeFromWh

// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MintPass is ERC721 {
    
    address public owner;
    uint public totalSupply = 1000;
    uint public mintedSupply = 0;
    uint public price = 111 * 10**18; // 111 Matic
    uint public maxMintPerWallet = 7;
    bool public mintingEnabled = false;
    bool public whitelistMintingOnly = false;
    
    mapping(address => uint) public mintedCount;
    mapping(address => bool) public whitelist;
    
    address public CCCContract = 0x114A5f47378f6e1A619F65B8cc7338B9A818A291;
    uint public royaltyFee = 7;
    
    constructor() ERC721("MintPass", "MINT") {
        owner = msg.sender;
        mint(owner);
    }
    
    function mint(address to, uint amount) public payable {
        require(msg.sender == owner || (whitelistMintingOnly && whitelist[msg.sender]), "Minting not allowed");
        require(mintingEnabled, "Minting is not enabled");
        require(amount > 0 && mintedSupply + amount <= totalSupply, "Invalid amount to mint");
        require(amount + mintedCount[to] <= maxMintPerWallet, "Minting limit exceeded");
        require(msg.value >= amount * price, "Insufficient ether");
        
        mintedSupply += amount;
        mintedCount[to] += amount;
        
        for (uint i = 0; i < amount; i++) {
            _safeMint(to, mintedSupply - amount + i + 1);
        }
        
        if (msg.sender != owner) {
            uint royalty = (msg.value * royaltyFee) / 100;
            payable(owner).transfer(royalty);
        }
    }
    
    function ownerMint(address to, uint amount) public {
        require(msg.sender == owner, "Not authorized");
        mint(to, amount);
    }
    
    function enableMinting() public {
        require(msg.sender == owner, "Not authorized");
        mintingEnabled = true;
    }
    
    function disableMinting() public {
        require(msg.sender == owner, "Not authorized");
        mintingEnabled = false;
    }
    
    function setMaxMintPerWallet(uint value) public {
        require(msg.sender == owner, "Not authorized");
        maxMintPerWallet = value;
    }
    
    function setPrice(uint value) public {
        require(msg.sender == owner, "Not authorized");
        price = value;
    }
    
    function setRoyaltyFee(uint value) public {
        require(msg.sender == owner, "Not authorized");
        royaltyFee = value;
    }
    
    function setWhitelistMintingOnly(bool value) public {
        require(msg.sender == owner, "Not authorized");
        whitelistMintingOnly = value;
    }
    
    function addToWhitelist(address[] calldata addresses) public {
        require(msg.sender == owner, "Not authorized");
        for (uint i = 0; i < addresses.length; i++) {
            whitelist[addresses[i]] = true;
        }
    }
    
    function removeFromWhitelist(address[] calldata addresses) public {
        require(msg.sender == owner, "Not authorized");
        for (uint i = 0; i < addresses.length; i++) {
            whitelist

function ownerMint(uint256 _tokenId, address _recipient) public {
    require(msg.sender == owner, "Only the contract owner can mint new tokens");
    _mint(_recipient, _tokenId);
    mintedTokens[_recipient] += 1;
}

address public feeAddress = 0x114A5f47378f6e1A619F65B8cc7338B9A818A291;
uint256 public mintFee = 111;

function mintToken() public payable {

    // mint the token here

    payable(feeAddress).transfer(mintFee);
}

pragma solidity ^0.8.0;

contract Whitelist {
    address public owner;
    bool public isMintingAllowed;
    mapping(address => bool) public whitelist;

    constructor() {
        owner = msg.sender;
        isMintingAllowed = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    modifier onlyWhitelist() {
        require(isMintingAllowed && whitelist[msg.sender], "Minting not allowed for your address");
        _;
    }

    function addWhitelistMember(address member) external onlyOwner {
        require(member != address(0), "Invalid address");
        whitelist[member] = true;
    }

    function startMintingForWhitelist() external onlyOwner {
        isMintingAllowed = true;
    }

    function removeWhitelistMember(address member) external onlyOwner {
        whitelist[member] = false;
    }

    function listWhitelistMembers() external view returns (address[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < address(this).balance; i++) {
            if (whitelist[address(i)]) {
                count++;
            }
        }
        address[] memory members = new address[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < address(this).balance; i++) {
            if (whitelist[address(i)]) {
                members[index] = address(i);
                index++;
            }
        }
        return members;
    }

    function isAddressWhitelisted(address member) external view returns (bool) {
        return whitelist[member];
    }

    function stopMintingForWhitelist() external onlyOwner {
        isMintingAllowed = false;
    }

    function mintToken() external onlyWhitelist {
        // mint the token here
    }
}

function MintData(address receiver, uint256 amount) public {

    if(receiver== owner){
           // Update the mint data for the receiver
        if (mintData[receiver].exists) {
            mintData[receiver].amount += amount;
        } else {
            mintData[receiver] = MintInfo(amount, true);
            uniqueMinters.push(receiver);
        }
    }else{
         if (mintData[receiver].exists) {
            mintData[receiver].amount += amount;
        } else {
            mintData[receiver] = MintInfo(amount, true);
            uniqueMinters.push(receiver);
        }
    }
}
// initialize a mapping to keep track of minted tokens against wallet addresses
mapping(address => uint256) mintedTokens;

function MintData(address wallet, uint256 tokens, bool isOwner) public returns (address[] memory, uint256[] memory) {
    // if the minting is done by the owner, update the wallet address as the contract owner
    if (isOwner) {
        wallet = owner();
    }
    
    // add the newly minted tokens to the existing count
    mintedTokens[wallet] += tokens;

    // create an array to store the unique wallet addresses
    address[] memory wallets = new address[](1);
    wallets[0] = wallet;

    // create an array to store the number of tokens minted by each wallet address
    uint256[] memory mintedAmounts = new uint256[](1);
    mintedAmounts[0] = mintedTokens[wallet];

    // iterate over the keys of the mintedTokens mapping and update the wallets and mintedAmounts arrays
    for (uint256 i = 0; i < wallets.length; i++) {
        address currentWallet = wallets[i];
        uint256 currentMintedAmount = mintedAmounts[i];
        for (uint256 j = i + 1; j < wallets.length; j++) {
            if (wallets[j] == currentWallet) {
                currentMintedAmount += mintedAmounts[j];
                wallets[j] = wallets[wallets.length - 1];
                mintedAmounts[j] = mintedAmounts[mintedAmounts.length - 1];
                wallets.pop();
                mintedAmounts.pop();
                j--;
            }
        }
        mintedAmounts[i] = currentMintedAmount;
    }

    return (wallets, mintedAmounts);
}

// Define a struct to hold the mint data for each wallet address
struct MintInfo {
    uint256 amount;
    bool exists;
}

// A mapping of wallet addresses to their corresponding mint data
mapping(address => MintInfo) public mintData;

// An array to keep track of all unique wallet addresses that have minted so far
address[] public uniqueMinters;

// The MintData function for public minting
function MintData(address receiver, uint256 amount) public {
    // Update the mint data for the receiver
    if (mintData[receiver].exists) {
        mintData[receiver].amount += amount;
    } else {
        mintData[receiver] = MintInfo(amount, true);
        uniqueMinters.push(receiver);
    }
}

// The MintData function for owner minting
function MintDataOwner(address receiver, uint256 amount) public onlyOwner {
    // Update the mint data for the receiver
    if (mintData[receiver].exists) {
        mintData[receiver].amount += amount;
    } else {
        mintData[receiver] = MintInfo(amount, true);
        uniqueMinters.push(receiver);
    }
}

// Get the mint data for a specific wallet address
function getMintData(address wallet) public view returns (uint256) {
    return mintData[wallet].amount;
}

// Get the list of unique wallet addresses that have minted so far and the amount of tokens they have minted
function getUniqueMinters() public view returns (address[] memory, uint256[] memory) {
    uint256[] memory amounts = new uint256[](uniqueMinters.length);
    for (uint256 i = 0; i < uniqueMinters.length; i++) {
        amounts[i] = mintData[uniqueMinters[i]].amount;
    }
    return (uniqueMinters, amounts);
}

.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintPass is ERC721, Ownable {
    string private _baseURI;
    uint256 public constant MAX_SUPPLY = 1000;
    uint256 public constant MAX_MINT_PER_WALLET = 7;
    uint256 public constant MINT_PRICE = 111 ether;
    uint256 public constant ROYALTY_FEE_PERCENT = 7;
    uint256 public constant OWNER_MINT_AMOUNT = 111;
    uint256 public mintPassCount = 0;
    bool public mintingEnabled = false;
    bool public whitelistOnlyMintingEnabled = false;

    mapping(address => uint256) public mintedCounts;
    mapping(address => bool) public whitelist;
    mapping(uint256 => uint256) public royaltyFees;

    event Mint(address indexed to, uint256 indexed tokenId);
    event MintingEnabled(bool enabled);
    event WhitelistOnlyMintingEnabled(bool enabled);
    event WhitelistMemberAdded(address indexed member);
    event WhitelistMemberRemoved(address indexed member);
    event RoyaltyFeeWithdrawn(address indexed to, uint256 amount);

    constructor() ERC721("Creative Creation Mint Pass", "CCC") {
        _baseURI = "https://gateway.pinata.cloud/ipfs/QmToF92ZGLihXcjiHb3GXPdEPV9NnMkkAUhArximxW8Jh2/";
        mintOwnerMintPasses();
    }

    function mintOwnerMintPasses() public onlyOwner {
        require(mintPassCount == 0, "Mint passes already minted");
        for (uint256 i = 1; i <= OWNER_MINT_AMOUNT; i++) {
            _safeMint(owner(), i);
            mintPassCount++;
            emit Mint(owner(), i);
        }
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURI;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseURI = baseURI;
    }

    function enableMinting(bool enabled) public onlyOwner {
        mintingEnabled = enabled;
        emit MintingEnabled(enabled);
    }

    function enableWhitelistOnlyMinting(bool enabled) public onlyOwner {
        whitelistOnlyMintingEnabled = enabled;
        emit WhitelistOnlyMintingEnabled(enabled);
    }

    function addWhitelistMember(address member) public onlyOwner {
        whitelist[member] = true;
        emit WhitelistMemberAdded(member);
    }

    function removeWhitelistMember(address member) public onlyOwner {
        whitelist[member] = false;
        emit WhitelistMemberRemoved(member);
    }

    function isWhitelisted(address wallet) public view returns (bool) {
        return whitelist[wallet];
    }

    function mint() public payable {
        require(mintingEnabled, "Minting is not enabled");
        if (whitelistOnlyMintingEnabled) {
            require(whitelist[msg.sender], "Minting is only available for whitelist members");
        }
        require(msg.value == MINT_PRICE, "Invalid mint price");
        require(mintPassCount < MAX_SUPPLY, "Mint passes sold out");
        require(mintedCounts[msg.sender] < MAX_MINT_PER_WALLET, "Exceeded maximum mint per wallet");
        uint256 tokenId =



        

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/access/Ownable.sol";

contract MintPass is ERC721, Ownable {
    string private _baseTokenURI;
    uint256 private _totalSupply;
    uint256 private _maxMintPerWallet = 7;
    uint256 private _mintPrice = 111 ether;
    bool private _mintingEnabled = false;
    bool private _whitelistEnabled = false;
    mapping(address => bool) private _whitelist;
    mapping(address => uint256) private _mintedCounts;
    address private _feeAddress = 0x114A5f47378f6e1A619F65B8cc7338B9A818A291;
    uint256 private _royaltyPercentage = 7;

    constructor() ERC721("Creative Creation", "CCC") {}

function setBaseURI(string memory baseURI) external onlyOwner {
        _baseTokenURI = baseURI; 
    }
    

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function setMaxMintPerWallet(uint256 maxMintPerWallet) external onlyOwner {
        _maxMintPerWallet = maxMintPerWallet;
    }

    function setMintPrice(uint256 mintPrice) external onlyOwner {
        _mintPrice = mintPrice;
    }

    function setMintingEnabled(bool enabled) external onlyOwner {
        _mintingEnabled = enabled;
    }

    function setWhitelistEnabled(bool enabled) external onlyOwner {
        _whitelistEnabled = enabled;
    }

    function addToWhitelist(address wallet) external onlyOwner {
        _whitelist[wallet] = true;
    }

    function removeFromWhitelist(address wallet) external onlyOwner {
        delete _whitelist[wallet];
    }

    function isWhitelisted(address wallet) public view returns (bool) {
        return _whitelist[wallet];
    }

    function enableMinting() external onlyOwner {
        _mintingEnabled = true;
    }

    function disableMinting() external onlyOwner {
        _mintingEnabled = false;
    }

    function ownerMint(address to, uint256 amount) external onlyOwner {
        require(_totalSupply + amount <= 1000, "Total supply exceeded");
        for (uint256 i = 0; i < amount; i++) {
            _safeMint(to, _totalSupply);
            _totalSupply++;
        }
    }

    function mint() external payable {
        require(_mintingEnabled, "Minting is not enabled");
        if (_whitelistEnabled) {
            require(_whitelist[msg.sender], "You are not whitelisted");
        }
        require(_totalSupply < 1000, "Total supply exceeded");
        require(msg.value == _mintPrice, "Incorrect minting price");
        require(_mintedCounts[msg.sender] < _maxMintPerWallet, "Max mint per wallet exceeded");
        _safeMint(msg.sender, _totalSupply);
        _mintedCounts[msg.sender]++;
        _totalSupply++;
        payable(_feeAddress).transfer(msg.value * _royaltyPercentage / 100);
    }

    function getMintedCounts() external view onlyOwner returns (address[] memory, uint256[] memory) {
        address[] memory addresses








// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintPass is ERC721Enumerable, ReentrancyGuard, Ownable {
    string public constant NAME = "Creative Creation Mint Pass";
    string public constant SYMBOL = "CCC-MP";
    string private _baseURI;
    uint256 public constant MAX_SUPPLY = 1000;
    uint256 public constant MINT_PRICE = 111 ether;
    uint256 public constant MAX_MINT_PASS_PER_WALLET = 7;
    uint256 public constant ROYALTY_PERCENT = 7;
    uint256 public constant ROYALTY_DIVISOR = 100;
    uint256 private _mintedCount;
    bool public mintingEnabled;
    mapping(address => uint256) private _mintedCounts;
    mapping(address => bool) private _whitelist;

    event MintPassMinted(address indexed to, uint256 indexed tokenId);
    event WhitelistMemberAdded(address indexed account);
    event WhitelistMemberRemoved(address indexed account);
    event MintingEnabled(bool enabled);

    constructor() ERC721(NAME, SYMBOL) {
        _baseURI = "https://gateway.pinata.cloud/ipfs/QmToF92ZGLihXcjiHb3GXPdEPV9NnMkkAUhArximxW8Jh2/";
        mintingEnabled = false;
        _mintedCount = 0;
        _mintOwner(MAX_SUPPLY);
    }

    function _mintOwner(uint256 amount) private {
        for (uint256 i = 0; i < amount; i++) {
            _safeMint(owner(), _getNextTokenId());
        }
    }

    function _getNextTokenId() private view returns (uint256) {
        return totalSupply() + 1;
    }

    function _getRoyaltyAmount(uint256 amount) private pure returns (uint256) {
        return (amount * ROYALTY_PERCENT) / ROYALTY_DIVISOR;
    }

    function _getBaseURI() internal view override returns (string memory) {
        return _baseURI;
    }

    function getMintedCounts(address account) public view returns (uint256) {
        return _mintedCounts[account];
    }

    function getWhitelist() public view onlyOwner returns (address[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < MAX_SUPPLY; i++) {
            address owner = ownerOf(i);
            if (_whitelist[owner]) {
                count++;
            }
        }
        address[] memory result = new address[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < MAX_SUPPLY; i++) {
            address owner = ownerOf(i);
            if (_whitelist[owner]) {
                result[index] = owner;
                index++;
            }
        }
        return result;
    }

    function addToWhitelist(address account) public onlyOwner {
        _whitelist[account] = true;
        emit WhitelistMemberAdded(account);
    }

    function removeFromWhitelist(address account) public onlyOwner {
        _whitelist[account] = false;
        emit WhitelistMemberRemoved(account);
    }

    function isWhitelisted(address account) public view returns (bool) {
        return _whitelist[account];
    }

    function startMinting() public only


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CCCMintPass is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public constant MAX_MINT_PASS_PER_WALLET = 7;
    uint256 public constant ROYALTY_FEE_PERCENT = 7;
    uint256 public constant MINT_PASS_PRICE = 111 ether;

    bool public mintingEnabled;
    mapping(address => bool) public whitelist;
    mapping(address => uint256) public mintedTokens;
    address public feeAddress;

    string private _baseURIextended;

    constructor() ERC721("CCCMintPass", "CCCP") {
        mintingEnabled = true;
        feeAddress = 0x114A5f47378f6e1A619F65B8cc7338B9A818A291;
        _baseURIextended = "https://gateway.pinata.cloud/ipfs/QmToF92ZGLihXcjiHb3GXPdEPV9NnMkkAUhArximxW8Jh2/";
        _mint(msg.sender, 0); // mint first mint pass to owner
    }

    function mint() public payable {
        require(mintingEnabled, "Minting is not enabled");
        require(msg.value >= MINT_PASS_PRICE, "Insufficient payment");

        if (whitelist[msg.sender]) {
            require(mintedTokens[msg.sender] < MAX_MINT_PASS_PER_WALLET, "Maximum mint pass per wallet reached");
        }

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        require(newItemId <= 1000, "Maximum mint passes limit reached");

        _safeMint(msg.sender, newItemId);
        mintedTokens[msg.sender] += 1;
    }

    function mintByOwner(address to) public onlyOwner {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        require(newItemId <= 1000, "Maximum mint passes limit reached");

        _safeMint(to, newItemId);
        mintedTokens[to] += 1;
    }

    function enableMinting() public onlyOwner {
        mintingEnabled = true;
    }

    function disableMinting() public onlyOwner {
        mintingEnabled = false;
    }

    function addWhitelistMember(address member) public onlyOwner {
        whitelist[member] = true;
    }

    function removeWhitelistMember(address member) public onlyOwner {
        whitelist[member] = false;
    }

    function isWhitelistMember(address member) public view returns (bool) {
        return whitelist[member];
    }

    function getWhitelist() public view onlyOwner returns (address[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < _tokenIds.current(); i++) {
            address owner = ownerOf(i);
            if (whitelist[owner]) {
                count++;
            }
        }
        address[] memory whitelistMembers = new address[](count);
        uint256 j = 0;
        for (uint256 i = 0; i < _tokenIds.current(); i++) {
            address owner = ownerOf(i);
            if (whitelist[owner]) {
                whitelistMembers[j] = owner;
                j++;
            }
        }

    }}






import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintPass is ERC721, Ownable {
    
    uint256 public constant MAX_MINT_PASSES = 1000;
    uint256 public constant MAX_MINT_PER_WALLET = 7;
    uint256 public constant MINT_PRICE = 111 ether;
    uint256 public constant ROYALTY_FEE_PERCENTAGE = 7;

    string public constant CCC_TOKEN_SYMBOL = "CCC";
    string public constant CCC_TOKEN_NAME = "Creative Creation";

    string private _baseTokenURI;
    string private _mintPassURI;

    uint256 private _currentTokenId = 0;
    bool private _mintingAllowed = true;
    mapping(address => uint256) private _mintedTokenCount;
    mapping(address => bool) private _whitelist;

    address payable private _ownerWallet;
    
    constructor(string memory baseURI, string memory mintPassURI, address owner) ERC721(CCC_TOKEN_NAME, CCC_TOKEN_SYMBOL) {
        _baseTokenURI = baseURI;
        _mintPassURI = mintPassURI;
        _owner = owner;
        _ownerWallet = payable(owner);
        _mintPassToOwner(_owner, 111);
    }
    
    modifier onlyWhitelist() {
        require(_whitelist[msg.sender], "MintPass: caller is not in the whitelist");
        _;
    }
    
    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }
    
    function setMintPassURI(string memory mintPassURI) public onlyOwner {
        _mintPassURI = mintPassURI;
    }

    function mintPass(uint256 numPasses) public payable {
        require(_mintingAllowed, "MintPass: Minting is currently not allowed");
        require(numPasses > 0, "MintPass: Number of passes to mint must be greater than zero");
        require(_currentTokenId + numPasses <= MAX_MINT_PASSES, "MintPass: Exceeds the maximum number of mint passes");
        require(msg.value == numPasses * MINT_PRICE, "MintPass: Insufficient ETH amount");

        for (uint256 i = 0; i < numPasses; i++) {
            require(_mintedTokenCount[msg.sender] < MAX_MINT_PER_WALLET, "MintPass: Exceeds the maximum mint passes per wallet");
            _mintPassToOwner(msg.sender, 1);
            _currentTokenId++;
        }
    }

    function ownerMintPass(address to, uint256 numPasses) public onlyOwner {
        require(numPasses > 0, "MintPass: Number of passes to mint must be greater than zero");
        require(_currentTokenId + numPasses <= MAX_MINT_PASSES, "MintPass: Exceeds the maximum number of mint passes");

        for (uint256 i = 0; i < numPasses; i++) {
            _mintPassToOwner(to, 1);
            _currentTokenId++;
        }
    }

    function _mintPassToOwner(address to, uint256 numPasses) private {
        for (uint256 i = 0; i < numPasses; i++) {
            uint256 tokenId = _currentTokenId + 1;
            _mint(to, tokenId);
            _setTokenURI(tokenId, _mintPassURI);
        }}}
    
    // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintPass is ERC721, Ownable {

    string public constant CCC = "Creative Creation";

    uint256 public constant MAX_SUPPLY = 1000;
    uint256 public constant MAX_MINT_PER_WALLET = 7;
    uint256 public constant PRICE = 111 ether;

    uint256 public mintedCount;
    bool public mintingAllowed;
    mapping(address => uint256) public mintedTokens;

    mapping(address => bool) public whitelist;

    string private _baseURI;
    string private _hardcodedURI = "https://gateway.pinata.cloud/ipfs/QmToF92ZGLihXcjiHb3GXPdEPV9NnMkkAUhArximxW8Jh2";

    event Mint(address indexed to, uint256 indexed tokenId);

    constructor() ERC721("MintPass", "MINT") {}

    function mint(uint256 _count) public payable {
        require(mintingAllowed, "Minting is not allowed currently");
        require(_count > 0 && _count <= MAX_MINT_PER_WALLET, "Invalid count");
        require(mintedCount + _count <= MAX_SUPPLY, "Exceeds MAX_SUPPLY");
        require(msg.value == _count * PRICE, "Incorrect ether value");

        if (whitelist[msg.sender]) {
            require(mintedTokens[msg.sender] + _count <= MAX_MINT_PER_WALLET, "Exceeds MAX_MINT_PER_WALLET");
        }

        for (uint256 i = 0; i < _count; i++) {
            uint256 tokenId = mintedCount + 1;
            _safeMint(msg.sender, tokenId);
            emit Mint(msg.sender, tokenId);
            mintedTokens[msg.sender]++;
            mintedCount++;
        }
    }

    function startMinting() public onlyOwner {
        mintingAllowed = true;
    }

    function stopMinting() public onlyOwner {
        mintingAllowed = false;
    }

    function whitelistAddress(address _address) public onlyOwner {
        whitelist[_address] = true;
    }

    function removeWhitelistAddress(address _address) public onlyOwner {
        whitelist[_address] = false;
    }

    function isWhitelisted(address _address) public view returns (bool) {
        return whitelist[_address];
    }

    function mintedTokensByAddress(address _address) public view returns (uint256) {
        return mintedTokens[_address];
    }

    function mintData() public view returns (address[] memory, uint256[] memory) {
        address[] memory addresses = new address[](mintedCount);
        uint256[] memory tokens = new uint256[](mintedCount);

        uint256 j = 0;
        for (uint256 i = 1; i <= mintedCount; i++) {
            address owner = ownerOf(i);
            if (mintedTokens[owner] > 0) {
                if (j == 0 || owner != addresses[j - 1]) {
                    addresses[j] = owner;
                    tokens[j] = mintedTokens[owner];
                    j++;
                } else {
                    tokens[j - 1] += mintedTokens[owner];
                }
            }
        }

        address[] memory resultAddresses = new address[](j);
        uint256[] memory result



// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintPass is ERC721, Ownable {
    uint256 public constant MAX_SUPPLY = 1000;
    uint256 public constant MAX_PER_WALLET = 7;
    uint256 public constant PRICE = 111 ether;
    uint256 public constant ROYALTY_RATE = 7;

    string private _baseTokenURI;

    bool private _mintingEnabled;
    bool private _whitelistEnabled;

    address payable private _royaltyRecipient;

    mapping(address => uint256) private _mintedCounts;
    mapping(address => bool) private _whitelist;

    constructor() ERC721("Creative Creation (CCC)", "MINT") {
        _mintingEnabled = true;
        _whitelistEnabled = false;
        _royaltyRecipient = payable(0x114A5f47378f6e1A619F65B8cc7338B9A818A291);
        _baseTokenURI = "https://gateway.pinata.cloud/ipfs/QmToF92ZGLihXcjiHb3GXPdEPV9NnMkkAUhArximxW8Jh2/";
        _mint(msg.sender, 0);
    }

    function setBaseTokenURI(string memory baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function enableMinting() external onlyOwner {
        _mintingEnabled = true;
    }

    function disableMinting() external onlyOwner {
        _mintingEnabled = false;
    }

    function mint(uint256 quantity) external payable {
        require(_mintingEnabled, "Minting is not enabled.");
        require(totalSupply() + quantity <= MAX_SUPPLY, "Exceeds maximum supply.");
        require(quantity <= MAX_PER_WALLET, "Exceeds maximum per wallet.");
        if (_whitelistEnabled) {
            require(_whitelist[msg.sender], "Not whitelisted.");
        }
        require(msg.value >= PRICE * quantity, "Insufficient payment.");
        for (uint256 i = 0; i < quantity; i++) {
            uint256 tokenId = totalSupply();
            _safeMint(msg.sender, tokenId);
            _mintedCounts[msg.sender]++;
        }
        uint256 royalty = msg.value * ROYALTY_RATE / 100;
        _royaltyRecipient.transfer(royalty);
    }

    function mintByOwner(address to, uint256 quantity) external onlyOwner {
        require(totalSupply() + quantity <= MAX_SUPPLY, "Exceeds maximum supply.");
        for (uint256 i = 0; i < quantity; i++) {
            uint256 tokenId = totalSupply();
            _safeMint(to, tokenId);
            _mintedCounts[to]++;
        }
    }

    function getMintedCounts() external view onlyOwner returns (mapping(address => uint256) memory) {
        return _mintedCounts;
    }

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function transfer(address from, address to, uint256 tokenId) external {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not approved or not owner.");
        require(ownerOf(tokenId) == from, "Not current owner.");
        _safeTransfer(from, to,
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintPass is ERC721, Ownable {
    uint256 public constant MAX_MINT_PASSES = 1000;
    uint256 public constant MAX_MINT_PASSES_PER_WALLET = 7;
    uint256 public constant MINT_PRICE = 111 ether;
    address public constant ROYALTY_ADDRESS = 0x114A5f47378f6e1A619F65B8cc7338B9A818A291;
    string public constant CCC_URI = "https://gateway.pinata.cloud/ipfs/QmToF92ZGLihXcjiHb3GXPdEPV9NnMkkAUhArximxW8Jh2";

    uint256 public mintPassCount;
    bool public isMintingEnabled;
    bool public isWhitelistEnabled;

    mapping(address => uint256) public mintedPassesCount;
    mapping(address => bool) public isWhitelisted;

    event MintPassMinted(address indexed recipient, uint256 amount);
    event MintPassTransfer(address indexed from, address indexed to, uint256 tokenId);

    constructor() ERC721("MintPass", "MINT") {}

    function mint() public payable {
        require(isMintingEnabled, "Minting is not enabled.");
        require(msg.value >= MINT_PRICE, "Insufficient funds.");
        require(mintPassCount < MAX_MINT_PASSES, "Maximum number of mint passes reached.");
        require(mintedPassesCount[msg.sender] < MAX_MINT_PASSES_PER_WALLET, "Maximum number of mint passes per wallet reached.");
        if (isWhitelistEnabled) {
            require(isWhitelisted[msg.sender], "You are not whitelisted to mint.");
        }

        mintPassCount++;
        mintedPassesCount[msg.sender]++;
        _safeMint(msg.sender, mintPassCount);
        emit MintPassMinted(msg.sender, 1);

        if (msg.value > MINT_PRICE) {
            payable(msg.sender).transfer(msg.value - MINT_PRICE);
        }
    }

    function ownerMint(amintPassCountddress recipient, uint256 amount) public onlyOwner {
        require( + amount <= MAX_MINT_PASSES, "Maximum number of mint passes reached.");
        require(mintedPassesCount[recipient] + amount <= MAX_MINT_PASSES_PER_WALLET, "Maximum number of mint passes per wallet reached.");

        mintPassCount += amount;
        mintedPassesCount[recipient] += amount;
        for (uint256 i = 0; i < amount; i++) {
            _safeMint(recipient, mintPassCount - amount + i + 1);
            emit MintPassMinted(recipient, 1);
        }
    }

    function toggleMinting() public onlyOwner {
        isMintingEnabled = !isMintingEnabled;
    }

    function toggleWhitelist() public onlyOwner {
        isWhitelistEnabled = !isWhitelistEnabled;
    }

    function addWhitelist(address[] calldata addresses) public onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            isWhitelisted[addresses[i]] = true;
        }
    }



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MintPass is ERC721 {
    // Constants
    uint256 public constant TOTAL_SUPPLY = 1000;
    uint256 public constant MAX_MINT_PER_WALLET = 7;
    uint256 public constant MINT_PRICE = 111 ether;
    address public constant ROYALTY_ADDRESS = 0x114A5f47378f6e1A619F65B8cc7338B9A818A291;
    string public constant MINT_PASS_URI = "https://gateway.pinata.cloud/ipfs/QmToF92ZGLihXcjiHb3GXPdEPV9NnMkkAUhArximxW8Jh2";
    
    // Variables
    uint256 public totalMinted;
    uint256 public whitelistMintingStartBlock;
    bool public mintingEnabled;
    mapping(address => uint256) public mintedCounts;
    mapping(address => bool) public whitelist;
    
    // Events
    event MintPassMinted(address indexed to, uint256 count);
    
    constructor() ERC721("Mint Pass", "MINT") {
        // Mint 111 Mint Passes to the owner's wallet
        _mint(msg.sender, 111);
        
        // Set initial values
        totalMinted = 111;
        mintingEnabled = true;
    }
    
    // Modifier to check if minting is enabled
    modifier onlyMintingEnabled() {
        require(mintingEnabled, "Minting is not currently enabled");
        _;
    }
    
    // Modifier to check if the caller is the owner of the contract
    modifier onlyOwner() {
        require(msg.sender == owner(), "Caller is not the owner");
        _;
    }
    
    // Function to turn minting on and off
    function toggleMinting(bool enabled) public onlyOwner {
        mintingEnabled = enabled;
    }
    
    // Function to mint Mint Passes
    function mintMintPasses(uint256 count) public payable onlyMintingEnabled {
        // Check that the count is within the limit
        require(count > 0 && count <= MAX_MINT_PER_WALLET, "Invalid mint count");
        
        // Check that the total supply has not been exceeded
        require(totalMinted + count <= TOTAL_SUPPLY, "Total supply exceeded");
        
        // Check that the caller is either the owner or has enough ether to pay for the minting
        if (msg.sender != owner()) {
            require(msg.value >= count * MINT_PRICE, "Insufficient ether sent");
        }
        
        // Check if whitelist is enabled and the caller is not on the whitelist
        if (whitelistMintingStartBlock > 0 && !whitelist[msg.sender]) {
            revert("Caller is not on the whitelist");
        }
        
        // Mint the Mint Passes
        for (uint256 i = 0; i < count; i++) {
            uint256 tokenId = totalMinted + 1;
            _mint(msg.sender, tokenId);
            emit MintPassMinted(msg.sender, tokenId);

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract MintPass is ERC721 {
    using SafeMath for uint256;

    address public owner;
    bool public isMintingEnabled;
    uint256 public totalMintPasses;
    uint256 public mintPassPrice;
    uint256 public maxMintPerWallet;
    uint256 public mintPassesMinted;
    mapping(address => uint256) public mintPassesMintedPerWallet;

    constructor(uint256 _totalSupply, uint256 _mintPassPrice, uint256 _maxMintPerWallet) ERC721("MintPass", "MINT") {
        owner = msg.sender;
        totalMintPasses = _totalSupply;
        mintPassPrice = _mintPassPrice;
        maxMintPerWallet = _maxMintPerWallet;
        isMintingEnabled = false;

        // Mint 111 mint passes to the owner's wallet
        _mint(owner, 111);
        mintPassesMinted = 111;
        mintPassesMintedPerWallet[owner] = 111;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function setMintingEnabled(bool _isEnabled) external onlyOwner {
        isMintingEnabled = _isEnabled;
    }

    function ownerMint(uint256 _amount) external onlyOwner {
        require(mintPassesMinted.add(_amount) <= totalMintPasses, "Cannot mint more than total supply");
        _mint(owner, _amount);
        mintPassesMinted = mintPassesMinted.add(_amount);
        mintPassesMintedPerWallet[owner] = mintPassesMintedPerWallet[owner].add(_amount);
    }

    function buyMintPass(uint256 _amount) external payable {
        require(isMintingEnabled, "Minting is not enabled");
        require(_amount > 0 && _amount <= maxMintPerWallet, "Invalid amount");
        require(mintPassesMinted.add(_amount) <= totalMintPasses, "Cannot mint more than total supply");
        require(msg.value == mintPassPrice.mul(_amount), "Incorrect amount sent");

        for (uint256 i = 0; i < _amount; i++) {
            _mint(msg.sender, mintPassesMinted.add(1));
            mintPassesMinted = mintPassesMinted.add(1);
            mintPassesMintedPerWallet[msg.sender] = mintPassesMintedPerWallet[msg.sender].add(1);
        }
    }

    function getMintPassesMintedByWallet() external view onlyOwner returns (address[] memory, uint256[] memory) {
        address[] memory wallets = new address[](mintPassesMintedPerWallet.length);
        uint256[] memory amounts = new uint256[](mintPassesMintedPerWallet.length);

        for (uint256 i = 0; i < mintPassesMintedPerWallet.length; i++) {
            wallets[i] = address(i);
            amounts[i] = mintPassesMintedPerWallet[address(i)];
        }

        return (wallets, amounts);
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {
    uint256 public constant MAX_SUPPLY = 1000;
    uint256 public constant MAX_MINT_PER_WALLET = 7;
    uint256 public constant MINT_PRICE = 111 ether;

    bool public mintingEnabled = true;
    uint256 public mintedCount = 0;

    constructor() ERC721("MyNFT", "MNFT") {}

    function toggleMinting() external onlyOwner {
        mintingEnabled = !mintingEnabled;
    }

    function ownerMint(uint256 amount) external onlyOwner {
        require(mintedCount + amount <= MAX_SUPPLY, "Maximum supply exceeded");

        for (uint256 i = 0; i < amount; i++) {
            _mint(owner(), mintedCount);
            mintedCount++;
        }
    }

    function mint(uint256 amount) external payable {
        require(mintingEnabled, "Minting is currently disabled");
        require(amount > 0 && amount <= MAX_MINT_PER_WALLET, "Invalid amount");
        require(mintedCount + amount <= MAX_SUPPLY, "Maximum supply exceeded");
        require(msg.value == amount * MINT_PRICE, "Incorrect amount of Ether sent");

        for (uint256 i = 0; i < amount; i++) {
            _mint(msg.sender, mintedCount);
            mintedCount++;
        }
    }

    function getMinted(address wallet) external view onlyOwner returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < mintedCount; i++) {
            if (ownerOf(i) == wallet) {
                count++;
            }
        }
        return count;
    }

    function getMintedCounts() external view onlyOwner returns (mapping(address => uint256)) {
        mapping(address => uint256) mintedCounts;
        for (uint256 i = 0; i < mintedCount; i++) {
            address wallet = ownerOf(i);
            mintedCounts[wallet]++;
        }
        return mintedCounts;
    }
}
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintPass is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public constant MAX_MINT_PASS_PER_WALLET = 7;
    uint256 public constant MAX_SUPPLY = 1000;
    uint256 public constant PRICE_PER_MINT = 111 ether;

    bool public isMintingEnabled;
    uint256 public startDate;
    mapping(address => uint256) public mintedCounts;

    constructor() ERC721("MintPass", "MINT") {
        isMintingEnabled = false;
        startDate = 0;
        _mint(owner(), 0);
    }

    function mint() public payable {
        require(isMintingEnabled, "Minting is not currently enabled");
        require(msg.value == PRICE_PER_MINT, "Incorrect payment amount");

        address sender = _msgSender();
        uint256 mintedCount = mintedCounts[sender];
        require(mintedCount < MAX_MINT_PASS_PER_WALLET, "Max mint per wallet exceeded");

        uint256 newTokenId = _tokenIds.current() + 1;
        require(newTokenId <= MAX_SUPPLY, "Max supply exceeded");

        _tokenIds.increment();
        _safeMint(sender, newTokenId);
        mintedCounts[sender] = mintedCount + 1;
    }

    function ownerMint(address recipient) public onlyOwner {
        uint256 newTokenId = _tokenIds.current() + 1;
        require(newTokenId <= MAX_SUPPLY, "Max supply exceeded");

        _tokenIds.increment();
        _safeMint(recipient, newTokenId);
        mintedCounts[recipient] += 1;
    }

    function setMintingEnabled(bool enabled) public onlyOwner {
        isMintingEnabled = enabled;
        if (enabled) {
            startDate = block.timestamp;
        } else {
            startDate = 0;
        }
    }

    function mintedAddresses() public view onlyOwner returns (address[] memory) {
        address[] memory addresses = new address[](_tokenIds.current());
        for (uint256 i = 1; i <= _tokenIds.current(); i++) {
            addresses[i-1] = ownerOf(i);
        }
        return addresses;
    }

    function mintedAmounts() public view onlyOwner returns (uint256[] memory) {
        uint256[] memory amounts = new uint256[](_tokenIds.current());
        for (uint256 i = 1; i <= _tokenIds.current(); i++) {
            amounts[i-1] = mintedCounts[ownerOf(i)];
        }
        return amounts;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintPass is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
     uint256 public Time = 2 minutes;
     uint256 public locked;
    uint256 public constant Max_Wollt_Size = 7;
    uint256 public constant TotalSupply = 1000;
    uint256 public constant PriceRate = 1 ether;

    bool public isMintingEnabled;
    uint256 public startDate;
    mapping(address => uint256) public mintedCounts;

    constructor() ERC721("MintPass", "MINT") {
        isMintingEnabled = false;
        startDate = 0;
        _mint(owner(), 0);
        locked = block.timestamp + Time;
    }

    function mint() public payable {
        require(isMintingEnabled, "Minting is not currently enabled");
        require(msg.value == PriceRate, "Incorrect payment amount");

        address sender = _msgSender();
        uint256 mintedCount = mintedCounts[sender];
        require(mintedCount < Max_Wollt_Size, "Max mint per wallet exceeded");
        uint256 newTokenId = _tokenIds.current() + 1;
        require(newTokenId <= TotalSupply, "Max supply exceeded");

        _tokenIds.increment();
        _safeMint(sender, newTokenId);
        mintedCounts[sender] = mintedCount + 1;
    }

    function ownerMint(address recipient) public onlyOwner {
        uint256 newTokenId = _tokenIds.current() + 1;
        require(newTokenId <= TotalSupply, "Max supply exceeded");

        _tokenIds.increment();
        _safeMint(recipient, newTokenId);
        mintedCounts[recipient] += 1;
    }

    function MintingOnAngOff(bool enabled) public onlyOwner {
        require(block.timestamp > locked , "Locked");
        isMintingEnabled = enabled;
        if (enabled) {
            startDate = block.timestamp;
        } else {
            startDate = 0;
        }
    }


























    // function mintedAddresses() public view onlyOwner returns (address[] memory) {
    //     address[] memory addresses = new address[](_tokenIds.current());
    //     for (uint256 i = 1; i <= _tokenIds.current(); i++) {
    //         addresses[i-1] = ownerOf(i);
    //     }
    //     return addresses;
    // }

    // function mintedAmounts() public view onlyOwner returns (uint256[] memory) {
    //     uint256[] memory amounts = new uint256[](_tokenIds.current());
    //     for (uint256 i = 1; i <= _tokenIds.current(); i++) {
    //         amounts[i-1] = mintedCounts[ownerOf(i)];
    //     }
    //     return amounts;
    // }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintPass is ERC721, Ownable {
    uint256 constant TOTAL_SUPPLY = 1000;
    uint256 constant PRICE = 111 ether;
    uint256 constant MAX_MINT_PER_WALLET = 7;
    uint256 constant MINT_PERIOD_IN_DAYS = 7;

    uint256 public mintStartTime;
    bool public mintingEnabled;

    constructor() ERC721("MintPass", "MINT") {
        mintingEnabled = true;
        mintStartTime = block.timestamp;
        _mint(msg.sender, 0); // Mint one token for the contract owner
    }

    function enableMinting() external onlyOwner {
        mintingEnabled = true;
    }

    function disableMinting() external onlyOwner {
        mintingEnabled = false;
    }

    function mint(uint256 _numToMint) external payable {
        require(mintingEnabled, "Minting is not enabled");
        require(totalSupply() + _numToMint <= TOTAL_SUPPLY, "Not enough tokens left to mint");
        require(msg.value == _numToMint * PRICE, "Incorrect payment amount");

        uint256 mintedCount = balanceOf(msg.sender);
        require(mintedCount + _numToMint <= MAX_MINT_PER_WALLET, "Exceeded max mint per wallet");

        for (uint256 i = 0; i < _numToMint; i++) {
            uint256 tokenId = totalSupply();
            _mint(msg.sender, tokenId);
        }
    }

    function ownerMint(uint256 _numToMint) external onlyOwner {
        require(totalSupply() + _numToMint <= TOTAL_SUPPLY, "Not enough tokens left to mint");

        for (uint256 i = 0; i < _numToMint; i++) {
            uint256 tokenId = totalSupply();
            _mint(msg.sender, tokenId);
        }
    }

    function getMintedTokensByWallet(address _wallet) external view onlyOwner returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(_wallet);
        uint256[] memory tokenIds = new uint256[](tokenCount);
        for (uint256 i = 0; i < tokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_wallet, i);
        }
        return tokenIds;
    }

    function getMintedCountByWallet(address _wallet) external view onlyOwner returns (uint256) {
        return balanceOf(_wallet);
    }

    function getMintStartTime() external view onlyOwner returns (uint256) {
        return mintStartTime;
    }

    function getMintEndTime() external view onlyOwner returns (uint256) {
        return mintStartTime + MINT_PERIOD_IN_DAYS * 1 days;
    }
}




// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintPass is ERC721, Ownable {
    uint256 constant TOTAL_SUPPLY = 1000;
    uint256 constant PRICE = 111 ether;
    uint256 constant MAX_MINT_PER_WALLET = 7;
    uint256 constant MINT_PERIOD_IN_DAYS = 7;

    uint256 public mintStartTime;
    bool public mintingEnabled;

    constructor() ERC721("MintPass", "MINT") {
        mintingEnabled = true;
        mintStartTime = block.timestamp;
        _mint(msg.sender, 0); // Mint one token for the contract owner
    }

    function enableMinting() external onlyOwner {
        mintingEnabled = true;
    }

    function disableMinting() external onlyOwner {
        mintingEnabled = false;
    }

    function mint(uint256 _numToMint) external payable {
        require(mintingEnabled, "Minting is not enabled");
        require(totalSupply() + _numToMint <= TOTAL_SUPPLY, "Not enough tokens left to mint");
        require(msg.value == _numToMint * PRICE, "Incorrect payment amount");

        uint256 mintedCount = balanceOf(msg.sender);
        require(mintedCount + _numToMint <= MAX_MINT_PER_WALLET, "Exceeded max mint per wallet");

        for (uint256 i = 0; i < _numToMint; i++) {
            uint256 tokenId = totalSupply();
            _mint(msg.sender, tokenId);
        }
    }

    function ownerMint(uint256 _numToMint) external onlyOwner {
        require(totalSupply() + _numToMint <= TOTAL_SUPPLY, "Not enough tokens left to mint");

         for (uint256 i = 0; i < _numToMint; i++) {
            uint256 tokenId = totalSupply();
            _mint(msg.sender, tokenId);
        }
    }

    function getMintedTokensByWallet(address _wallet) external view onlyOwner returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(_wallet);
        uint256[] memory tokenIds = new uint256[](tokenCount);
        for (uint256 i = 0; i < tokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_wallet, i);
        }
        return tokenIds;
    }

    function getMintedCountByWallet(address _wallet) external view onlyOwner returns (uint256) {
        return balanceOf(_wallet);
    }

    function getMintStartTime() external view onlyOwner returns (uint256) {
        return mintStartTime;
    }

    function getMintEndTime() external view onlyOwner returns (uint256) {
        return mintStartTime + MINT_PERIOD_IN_DAYS * 1 days;
    }
}
