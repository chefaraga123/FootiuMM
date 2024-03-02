// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DummyPlayer is ERC721, Ownable {

    // Mapping to store the ratings associated with each token ID
    mapping(uint256 => uint256) public tokenRatings;
    // Event to log the minting of a new NFT with its rating
    event NFTMinted(address indexed owner, uint256 indexed tokenId, uint256 rating);

    constructor() ERC721("MyNFT", "MNFT") Ownable(msg.sender) {}


    // Function to mint a new NFT with a pseudorandom rating
    function mintWithRandomRating(address to, uint256 tokenId) public {
        uint256 rating = generateRandomRating(tokenId);
        _safeMint(to, tokenId);
        tokenRatings[tokenId] = rating;
        emit NFTMinted(to, tokenId, rating);
    }

    // Function to generate a pseudorandom rating between 0 and 100 based on the token ID and current timestamp
    function generateRandomRating(uint256 tokenId) internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, tokenId))) % 101; // Rating between 0 and 100
    }

    // Get the rating of a given token ID
    function getRating(uint256 tokenId) public view returns (uint256) {
        return tokenRatings[tokenId];
    }
}
