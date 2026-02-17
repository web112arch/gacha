// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";

/// @title GameToken
/// @notice ERC20 used as in-game currency for deposits/rewards
contract GameToken is ERC20, Ownable2Step {
    constructor() ERC20("Gacha Token", "GCH") Ownable(msg.sender) {
        // mint inicial opcional (ex.: 1 milhão com 18 decimais)
        _mint(msg.sender, 1_000_000 ether);
    }

    /// @notice Owner can mint more tokens if needed (opcional)
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
