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
