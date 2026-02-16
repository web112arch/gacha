// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title IRewardPool
/// @notice Interface for the Reward Pool (deposits & withdrawals)
interface IRewardPool {
    /// @notice Deposit the gacha price (usually ERC20 via permit/transferFrom inside the pool)
    function deposit(
        address user,
        uint256 amount,
        uint256 deadline,
        bytes calldata permitSig
    ) external;

    /// @notice Withdraw rewards to user
    function withdraw(address user, uint256 amount) external;
}
