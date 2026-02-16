// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title ISBT
/// @notice Interface for the Soulbound Token (SBT)
interface ISBT {
    /// @notice Returns true if user already minted the SBT
    function hasMintedSBT(address user) external view returns (bool);

    /// @notice Mint SBT to a user
    function mint(address to) external;
}
