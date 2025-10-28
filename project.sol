// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BlockGallery
 * @dev A decentralized gallery for uploading and managing digital art on the blockchain.
 */
contract BlockGallery {
    address public owner;
    uint256 public artworkCount = 0;

    struct Artwork {
        uint256 id;
        address artist;
        string title;
        
        string imageHash; // IPFS or Arweave hash for decentralized storage
        uint256 timestamp;
    }


    mapping(uint256 => Artwork) public artworks;

    event ArtworkUploaded(uint256 indexed id, address indexed artist, string title, string imageHash);
    event ArtworkRemoved(uint256 indexed id, address indexed artist);

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Upload a new artwork to the gallery
     * @param _title Title of the artwork
     * @param _imageHash Hash of the artwork stored on IPFS or Arweave
     */
    function uploadArtwork(string memory _title, string memory _imageHash) external {
        require(bytes(_title).length > 0, "Title required");
        require(bytes(_imageHash).length > 0, "Image hash required");

        artworkCount++;
        artworks[artworkCount] = Artwork(artworkCount, msg.sender, _title, _imageHash, block.timestamp);

        emit ArtworkUploaded(artworkCount, msg.sender, _title, _imageHash);
    }

    /**
     * @notice Remove your artwork from the gallery
     * @param _id The ID of the artwork to remove
     */
    function removeArtwork(uint256 _id) external {
        Artwork memory art = artworks[_id];
        require(art.artist == msg.sender, "Only the artist can remove their artwork");

        delete artworks[_id];
        emit ArtworkRemoved(_id, msg.sender);
    }

    /**
     * @notice Get details of an artwork by ID
     * @param _id The ID of the artwork
     */
    function getArtwork(uint256 _id) external view returns (Artwork memory) {
        return artworks[_id];
    }
}
