// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title IEntropyV2
/// @notice Interface for Pyth Entropy V2 randomness provider
interface IEntropyV2 {
    /// @notice Returns the fee required to request randomness
    function getFeeV2() external view returns (uint128);

    /// @notice Requests randomness
    /// @dev Must send getFeeV2() as msg.value
    function requestV2() external payable returns (uint64);
}
