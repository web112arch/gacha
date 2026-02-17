// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable2Step.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/// @dev ERC20 Permit padrão EIP-2612
interface IERC20Permit {
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
}

contract RewardPool is Ownable2Step, ReentrancyGuard, Pausable {
    using SafeERC20 for IERC20;

    IERC20 public immutable token;      // token usado para depósitos/recompensas
    address public main;                // contrato Main autorizado

    mapping(address => uint256) public deposited;   // quanto o usuário depositou (contabilidade simples)
    mapping(address => uint256) public withdrawn;   // quanto já sacou

    event MainUpdated(address indexed oldMain, address indexed newMain);
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    error NotMain(address caller);
    error ZeroAddress();
    error InsufficientPoolBalance(uint256 requested, uint256 available);

    modifier onlyMain() {
        if (msg.sender != main) revert NotMain(msg.sender);
        _;
    }

    constructor(address _token) Ownable(msg.sender) {
        if (_token == address(0)) revert ZeroAddress();
        if (_token.code.length == 0) revert("Token must be a contract");
        token = IERC20(_token);
    }

    /// @notice setar o Main uma única vez (ou permitir update pelo owner, se quiser)
    function setMain(address _main) external onlyOwner {
        if (_main == address(0)) revert ZeroAddress();
        if (_main.code.length == 0) revert("Main must be a contract");
        emit MainUpdated(main, _main);
        main = _main;
    }

    function pause() external onlyOwner { _pause(); }
    function unpause() external onlyOwner { _unpause(); }

    /// @notice Deposit chamado pelo Main em nome do usuário
    /// @dev Se permitSig vier preenchido, tenta executar permit antes de puxar os tokens
    function deposit(
        address user,
        uint256 amount,
        uint256 deadline,
        bytes calldata permitSig
    ) external nonReentrant whenNotPaused onlyMain {
        if (amount == 0) return;

        // Se veio permitSig, executa permit(user -> this contract/main)
        // Aqui o spender é este RewardPool (porque ele que fará transferFrom)
        if (permitSig.length == 65) {
            (uint8 v, bytes32 r, bytes32 s) = _splitSig(permitSig);
            IERC20Permit(address(token)).permit(user, address(this), amount, deadline, v, r, s);
        } else if (permitSig.length != 0) {
            revert("Invalid permitSig length");
        }

        // Puxa tokens do user para o pool
        token.safeTransferFrom(
