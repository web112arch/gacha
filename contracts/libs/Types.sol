// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title Types Library
/// @notice Shared enums and helper functions for the Gacha System
library Types {

    /// @notice All contract tags used for indexing managed contracts (if needed)
    enum ContractTags {
        Main,
        Item,
        RewardPool,
        SBT,
        Max
    }

    /// @notice Gacha types available in the system
    enum GachaType {
        NOOB,       // 0
        APE,        // 1
        HODLER,     // 2
        OG,         // 3
        WHALE,      // 4 (uses entropy)
        DEGEN,      // 5 (uses entropy)
        Max
    }

    /// @notice Item rarity tiers
    enum Rarity {
        Common,         // 0
        Rare,           // 1
        Epic,           // 2
        Unique,         // 3
        Legendary,      // 4
        Degendary,      // 5
        Max
    }

    /// @notice Returns user score based on rarity
    function getScoreByRarity(uint8 rarityIndex) internal pure returns (uint256) {
        Rarity rarity = Rarity(rarityIndex);

        if (rarity == Rarity.Common)     return 1;
        if (rarity == Rarity.Rare)       return 5;
        if (rarity == Rarity.Epic)       return 20;
        if (rarity == Rarity.Unique)     return 100;
        if (rarity == Rarity.Legendary)  return 300;
        if (rarity == Rarity.Degendary)  return 1000;

        revert("Invalid rarity");
    }

    /// @notice Returns reward amount based on rarity
    function getRewardByRarity(uint8 rarityIndex) internal pure returns (uint256) {
        Rarity rarity = Rarity(rarityIndex);

        if (rarity == Rarity.Common)     return 15 ether;
        if (rarity == Rarity.Rare)       return 80 ether;
        if (rarity == Rarity.Epic)       return 800 ether;
        if (rarity == Rarity.Unique)     return 3_000 ether;
        if (rarity == Rarity.Legendary)  return 18_000 ether;
        if (rarity == Rarity.Degendary)  return 400_000 ether;

        revert("Invalid rarity");
    }

    /// @notice Returns gacha price by type
    function getPriceByGachaType(uint8 gachaIndex) internal pure returns (uint256) {
        GachaType gacha = GachaType(gachaIndex);

        if (gacha == GachaType.NOOB)     return 0 ether;
        if (gacha == GachaType.APE)      return 50 ether;
        if (gacha == GachaType.HODLER)   return 200 ether;
        if (gacha == GachaType.OG)       return 1_300 ether;
        if (gacha == GachaType.WHALE)    return 10_000 ether;
        if (gacha == GachaType.DEGEN)    return 150_000 ether;

        revert("Invalid gacha type");
    }
}
