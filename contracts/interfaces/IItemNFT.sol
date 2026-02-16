// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title IItemNFT
/// @notice Interface for the main Item NFT contract
interface IItemNFT {

    /// @notice Mint item without entropy (simple gacha)
    function mint(address to, uint8 gachaTypeIndex) external;

    /// @notice Mint item using entropy randomness
    function mintByEntropy(
        address to,
        uint8 gachaTypeIndex,
        uint64 sequenceNumber,
        uint256 randomSeed
    ) external;

    /// @notice Burn item (must validate ownership internally)
    function burn(address owner, uint256 tokenId) external;

    /// @notice Returns token metadata info
    function tokenInfo(uint256 tokenId)
        external
        view
        returns (
            uint256 rarityIndex,
            uint256 gachaTypeIndex,
            uint256 mintedAt,
            uint256 entropySequence,
            uint256 randomSeed
        );

    /// @notice Decrease user score after selling items
    function decreaseUserScore(address user, uint256 score) external;

    /// @notice Returns true if user has ever minted a Unique rarity
    function hasUniqueMinted(address user) external view returns (bool);
}
