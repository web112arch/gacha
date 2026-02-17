// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable2Step.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

import "./interfaces/IEntropyV2.sol";
import "./interfaces/IItemNFT.sol";
import "./interfaces/IRewardPool.sol";
import "./interfaces/ISBT.sol";
import "./libs/Types.sol";

contract MainSecure is Ownable2Step, ReentrancyGuard, Pausable {

    IEntropyV2 public immutable entropy;
    IItemNFT public immutable item;
    IRewardPool public immutable rewardPool;
    ISBT public immutable sbt;

    bool public sbtMintingOpened = true;

    struct PendingDraw {
        address user;
        uint8 gachaTypeIndex;
    }

    mapping(uint64 => PendingDraw) public pendingDraws;

    event SequenceRequested(uint64 indexed sequence, address indexed user);
    event EntropyFulfilled(uint64 indexed sequence, address indexed user);
    event SBTMintingOpened();
    event SBTMintingClosed();

    error InvalidGachaType();
    error NotEnoughEntropyFee();
    error OnlyEntropy();
    error NoPendingDraw();
    error SBTClosed();

    constructor(
        address _entropy,
        address _item,
        address _rewardPool,
        address _sbt
    ) Ownable(msg.sender) {

        require(_entropy.code.length > 0, "Invalid entropy");
        require(_item.code.length > 0, "Invalid item");
        require(_rewardPool.code.length > 0, "Invalid pool");
        require(_sbt.code.length > 0, "Invalid sbt");

        entropy = IEntropyV2(_entropy);
        item = IItemNFT(_item);
        rewardPool = IRewardPool(_rewardPool);
        sbt = ISBT(_sbt);
    }

    // ======================
    // ADMIN
    // ======================

    function pause() external onlyOwner { _pause(); }
    function unpause() external onlyOwner { _unpause(); }

    function closeSBTMinting() external onlyOwner {
        sbtMintingOpened = false;
        emit SBTMintingClosed();
    }

    function openSBTMinting() external onlyOwner {
        sbtMintingOpened = true;
        emit SBTMintingOpened();
    }

    // ======================
    // DRAW
    // ======================

    function drawItem(
        uint8 gachaTypeIndex,
        uint256 deadline,
        bytes calldata permitSig
    )
        external
        payable
        nonReentrant
        whenNotPaused
    {
        if (gachaTypeIndex >= uint8(Types.GachaType.Max))
            revert InvalidGachaType();

        uint256 price = Types.getPriceByGachaType(gachaTypeIndex);

        if (price > 0) {
            rewardPool.deposit(msg.sender, price, deadline, permitSig);
        }

        Types.GachaType gt = Types.GachaType(gachaTypeIndex);

        if (
            gt == Types.GachaType.WHALE ||
            gt == Types.GachaType.DEGEN
        ) {
            uint128 fee = entropy.getFeeV2();
            if (msg.value < fee) revert NotEnoughEntropyFee();

            uint64 seq = entropy.requestV2{value: fee}();

            pendingD
