// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";

/// @title RewardPool
/// @notice Holds reward tokens and processes deposits/withdrawals (only by authorized operator, e.g. Main)
contract RewardPool is AccessControl, ReentrancyGuard, Pausable {
    using SafeERC20 for IERC20;

    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");

    IERC20 public immutable rewardToken;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event OperatorSet(address indexed operator, bool enabled);

    error InvalidToken();
    error InvalidAmount();
    error PermitFailed();
    error InsufficientPoolBalance(uint256 needed, uint256 available);

    constructor(address _rewardToken, address admin) {
        if (_rewardToken == address(0)) revert InvalidToken();
        if (admin == address(0)) revert InvalidToken();

        rewardToken = IERC20(_rewardToken);

        _grantRole(DEFAULT_ADMIN_ROLE, admin);
    }

    /// @notice Admin can pause in emergencies
    function pause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    /// @notice Admin can unpause
    function unpause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    /// @notice Admin sets the operator (your Main contract)
    function setOperator(address operator, bool enabled) external onlyRole(DEFAULT_ADMIN_ROLE) {
        if (operator == address(0)) revert InvalidToken();

        if (enabled) _grantRole(OPERATOR_ROLE, operator);
        else _revokeRole(OPERATOR_ROLE, operator);

        emit OperatorSet(operator, enabled);
    }

    /// @notice Deposit tokens for gacha payment (called by Main)
    /// @dev If permitSig is provided, tries EIP-2612 permit first.
    /// permitSig format: abi.encode(uint8 v, bytes32 r, bytes32 s)
    function deposit(
        address user,
        uint256 amount,
        uint256 deadline,
        bytes calldata permitSig
    ) external nonReentrant whenNotPaused onlyRole(OPERATOR_ROLE) {
        if (user == address(0)) revert InvalidToken();
        if (amount == 0) revert InvalidAmount();

        // Optional permit (EIP-2612)
        if (permitSig.length != 0) {
            // Best-effort: if token doesn't support permit or signature invalid, revert.
            (uint8 v, bytes32 r, bytes32 s) = abi.decode(permitSig, (uint8, bytes32, bytes32));
            try IERC20Permit(address(rewardToken)).permit(user, address(this), amount, deadline, v, r, s) {
                // ok
            } catch {
                revert PermitFailed();
            }
        }

        rewardToken.safeTransferFrom(user, address(this), amount);
        emit Deposited(user, amount);
    }

    /// @notice Withdraw reward tokens to a user (called by Main)
    function withdraw(address user, uint256 amount) external nonReentrant whenNotPaused onlyRole(OPERATOR_ROLE) {
        if (user == address(0)) revert InvalidToken();
        if (amount == 0) revert InvalidAmount();

        uint256 bal = rewardToken.balanceOf(address(this));
        if (bal < amount) revert InsufficientPoolBalance(amount, bal);

        rewardToken.safeTransfer(user, amount);
        emit Withdrawn(user, amount);
    }

    /// @notice View current pool balance
    function poolBalance() external view returns (uint256) {
        return rewardToken.balanceOf(address(this));
    }

    /// @notice Recover tokens accidentally sent (NOT the main reward token)
    function recoverERC20(address token, address to, uint256 amount) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(token != address(rewardToken), "cannot recover reward token");
        IERC20(token).safeTransfer(to, amount);
    }

    receive() external payable {
        // Avoid receiving ETH; if it happens, it stays here unless you add a recover function for ETH.
        // Generally you shouldn't send ETH to RewardPool.
    }
}
