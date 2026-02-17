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

/// @title MainSecure
/// @notice Secure hub: gacha draw + Entropy RNG + sell/burn + rewards + SBT minting
contract MainSecure is Ownable2Step, ReentrancyGuard, Pausable {
    using Types for uint8;

    struct PendingDraw {
        address user;
        uint8 gachaTypeIndex;
        uint64 requestedAt;
    }

    event SequenceNumberRequested(uint64 indexed sequenceNumber, address indexed user, uint8 indexed gachaTypeIndex);
    event EntropyFulfilled(uint64 indexed sequenceNumber, address indexed user, uint8 indexed gachaTypeIndex);
    event DecreasedUserScore(address indexed user, uint256 score);
    event SBTMintingClosed(address indexed sender);
    event SBTMintingOpened(address indexed sender);

    error InvalidGachaType(uint8 idx);
    error NotEnoughEntropyFee(uint256 sent, uint256 required);
    error NoPendingDraw(uint64 sequenceNumber);
    error RefundFailed();
    error SBTMintingClosedError();
    error SBTAlreadyMinted();
    error RequiresUniqueHistory();
    error InvalidItemIdsLength(uint256 len);

    IEntropyV2 public immutable entropy;
    IItemNFT public immutable item;
    IRewardPool public immutable rewardPool;
    ISBT public immutable sbt;

    bool public sbtMintingOpened = true;

    mapping(uint64 => PendingDraw) public pendingDraws;

    constructor(
        address _entropy,
        address _item,
        address _rewardPool,
        address _sbt
    ) Ownable(msg.sender) {
        require(_entropy != address(0) && _item != address(0) && _rewardPool != address(0) && _sbt != address(0), "zero addr");
        require(_entropy.code.length > 0 && _item.code.length > 0 && _rewardPool.code.length > 0 && _sbt.code.length > 0, "not contract");

        entropy = IEntropyV2(_entropy);
        item = IItemNFT(_item);
        rewardPool = IRewardPool(_rewardPool);
        sbt = ISBT(_sbt);
    }

    // ===== Admin =====
    function pause() external onlyOwner { _pause(); }
    function unpause() external onlyOwner { _unpause(); }

    function openSbtMinting() external onlyOwner {
        if (sbtMintingOpened) revert();
        sbtMintingOpened = true;
        emit SBTMintingOpened(msg.sender);
    }

    function closeSbtMinting() external onlyOwner {
        if (!sbtMintingOpened) revert();
        sbtMintingOpened = false;
        emit SBTMintingClosed(msg.sender);
    }

    // ===== Core: draw =====
    function drawItem(
        uint8 gachaTypeIndex,
        uint256 deadline,
        bytes calldata permitSig
    ) external payable nonReentrant whenNotPaused {
        if (gachaTypeIndex >= uint8(Types.GachaType.Max)) revert InvalidGachaType(gachaTypeIndex);

        uint256 price = Types.getPriceByGachaType(gachaTypeIndex);

        // 1) deposit (token payment handled by RewardPool)
        if (price > 0) {
            rewardPool.deposit(msg.sender, price, deadline, permitSig);
        }

        Types.GachaType gt = Types.GachaType(gachaTypeIndex);

        // 2) RNG only for WHALE/DEGEN
        if (gt == Types.GachaType.WHALE || gt == Types.GachaType.DEGEN) {
            uint128 fee = entropy.getFeeV2();
            if (msg.value < fee) revert NotEnoughEntropyFee(msg.value, fee);

            uint64 seq = entropy.requestV2{value: fee}();

            pendingDraws[seq] = PendingDraw({
                user: msg.sender,
                gachaTypeIndex: gachaTypeIndex,
                requestedAt: uint64(block.timestamp)
            });

            _refundExcess(msg.value, fee);

            emit SequenceNumberRequested(seq, msg.sender, gachaTypeIndex);
        } else {
            // mint immediately
            item.mint(msg.sender, gachaTypeIndex);

            // refund all ETH (shouldn't be sent)
            if (msg.value > 0) _refundAll(msg.value);
        }
    }

    /// @notice Entropy fulfillment
    /// @dev IMPORTANT: this function must only be callable by the Entropy contract.
    /// If your Entropy SDK uses a different callback signature, adapt this function but KEEP the sender check.
    function entropyCallback(uint64 sequenceNumber, bytes32 randomNumber)
        external
        nonReentrant
        whenNotPaused
    {
        require(msg.sender == address(entropy), "only entropy");

        PendingDraw memory pd = pendingDraws[sequenceNumber];
        if (pd.user == address(0)) revert NoPendingDraw(sequenceNumber);

        delete pendingDraws[sequenceNumber];

        item.mintByEntropy(pd.user, pd.gachaTypeIndex, sequenceNumber, uint256(randomNumber));

        emit EntropyFulfilled(sequenceNumber, pd.user, pd.gachaTypeIndex);
    }

    // ===== Sell =====
    function sellItemBatch(uint256[] calldata itemIds) external nonReentrant whenNotPaused {
        uint256 len = itemIds.length;
        if (len == 0 || len > 50) revert InvalidItemIdsLength(len);

        uint256 totalReward;
        uint256 totalScore;

        for (uint256 i = 0; i < len; i++) {
            uint256 id = itemIds[i];

            (uint256 rarityIndex,,,,) = item.tokenInfo(id);

            totalReward += Types.getRewardByRarity(uint8(rarityIndex));
            totalScore  += Types.getScoreByRarity(uint8(rarityIndex));

            item.burn(msg.sender, id);
        }

        if (totalReward > 0) rewardPool.withdraw(msg.sender, totalReward);

        if (totalScore > 0) {
            item.decreaseUserScore(msg.sender, totalScore);
            emit DecreasedUserScore(msg.sender, totalScore);
        }
    }

    // ===== SBT =====
    function mintSBT() external nonReentrant whenNotPaused {
        if (!sbtMintingOpened) revert SBTMintingClosedError();
        if (!item.hasUniqueMinted(msg.sender)) revert RequiresUniqueHistory();
        if (sbt.hasMintedSBT(msg.sender)) revert SBTAlreadyMinted();

        sbt.mint(msg.sender);
    }

    // ===== Refund helpers =====
    function _refundExcess(uint256 sent, uint256 needed) internal {
        if (sent > needed) {
            unchecked {
                (bool ok,) = msg.sender.call{value: sent - needed}("");
                if (!ok) revert RefundFailed();
            }
        }
    }

    function _refundAll(uint256 amount) internal {
        (bool ok,) = msg.sender.call{value: amount}("");
        if (!ok) revert RefundFailed();
    }

    receive() external payable {}
}
