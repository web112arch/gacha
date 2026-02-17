# gacha# 🎰 Gacha System on Base

A secure on-chain gacha system built for Base mainnet.

## 🔹 Overview

This project implements a complete NFT-based gacha system with:

- 🎲 Randomness via Pyth Entropy
- 🧱 ERC721 Item NFTs with rarity tiers
- 💰 RewardPool with ERC20 deposits and withdrawals
- 🏅 Soulbound Token (SBT) achievement badge
- 🔐 Reentrancy protection & pause mechanism

## 🏗 Architecture

MainSecure → Orchestrates all logic  
ItemNFT → NFT minting, rarity & score  
RewardPool → Manages deposits & withdrawals  
SBT → Non-transferable achievement NFT  
GameToken → In-game ERC20 currency  

## 🔐 Security Features

- ReentrancyGuard


