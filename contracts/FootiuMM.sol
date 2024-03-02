// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PlayerPricing.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol"; // Import OpenZeppelin's IERC721 interface

contract FootiuMM {

    struct NFT {
        address nftAddress;
        uint256 tokenId;
        uint256 rating;
        bool locked;
    }

    mapping(address => NFT) public lockedNFTs; // Mapping to keep track of locked NFTs by owner address
    mapping(address => uint256) public points; // Mapping to keep track of points

    event PlayerLocked(address indexed seller, address indexed nftAddress, uint256 tokenId);

    PlayerPricing public pricingLibrary;

    constructor(address _pricingLibrary) {
        pricingLibrary = PlayerPricing(_pricingLibrary);
    }

    // Function to get the price using the library contract
    function getPrice(uint256 input) public view returns (uint256) {
        return pricingLibrary.calculatePrice(input);
    }

    // Updated function to lock up an NFT and attribute points based on its rating
    function lockUpNFT(address _nftAddress, uint256 _tokenId, uint256 _rating) external {
        require(!lockedNFTs[msg.sender].locked, "NFT already locked");

        IERC721 nftContract = IERC721(_nftAddress);

        // Transfer the NFT from the sender to this contract
        nftContract.transferFrom(msg.sender, address(this), _tokenId);

        // Attribute points based on rating
        points[msg.sender] += _rating;

        // Store the NFT details in the lockedNFTs mapping
        NFT memory newNFT = NFT(_nftAddress, _tokenId, _rating, true);
        lockedNFTs[msg.sender] = newNFT;

        emit PlayerLocked(msg.sender, _nftAddress, _tokenId);
    }

    function withdrawNFT(address _nftAddress, uint256 tokenId, uint256 pointsRequired) external {
        require(points[msg.sender] >= pointsRequired, "Insufficient points");
        IERC721 nftContract = IERC721(_nftAddress);

        // Transfer NFT to the caller
        nftContract.transferFrom(address(this), msg.sender, tokenId);

        // Deduct points from the caller
        points[msg.sender] -= pointsRequired;

        // Emit event or perform further actions
    }

    // Additional functions can be added as needed
}
