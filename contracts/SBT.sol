// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/// @title Soulbound Token (SBT)
/// @notice Non-transferable NFT used as achievement badge
contract SBT is ERC721, AccessControl {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    uint256 private _tokenIdCounter;

    mapping(address => bool) private _hasMinted;

    constructor() ERC721("Gacha Soulbound Token", "GSBT") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /// @notice Mint SBT (only authorized minter, typically Main contract)
    function mint(address to) external onlyRole(MINTER_ROLE) {
        require(!_hasMinted[to], "SBT already minted");

        _tokenIdCounter++;
        uint256 tokenId = _tokenIdCounter;

        _hasMinted[to] = true;
        _safeMint(to, tokenId);
    }

    /// @notice Returns true if user already minted SBT
    function hasMintedSBT(address user) external view returns (bool) {
        return _hasMinted[user];
    }

    /// 🔒 Disable transfers (Soulbound)
    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override returns (address) {

        address from = super._update(to, tokenId, auth);

        if (from != address(0) && to != address(0)) {
            revert("SBT is non-transferable");
        }

        return from;
    }
}
