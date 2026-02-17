import { ethers } from "hardhat";

async function main() {
  // 1) Deploy Token
  const GameToken = await ethers.getContractFactory("GameToken");
  const token = await GameToken.deploy();
  await token.waitForDeployment();
  const tokenAddr = await token.getAddress();
  console.log("GameToken:", tokenAddr);

  // 2) Deploy RewardPool (passa token)
  const RewardPool = await ethers.getContractFactory("RewardPool");
  const pool = await RewardPool.deploy(tokenAddr);
  await pool.waitForDeployment();
  const poolAddr = await pool.getAddress();
  console.log("RewardPool:", poolAddr);

  // 3) Deploy ItemNFT
  const ItemNFT = await ethers.getContractFactory("ItemNFT");
  const item = await ItemNFT.deploy();
  await item.waitForDeployment();
  const itemAddr = await item.getAddress();
  console.log("ItemNFT:", itemAddr);

  // 4) Deploy SBT
  const SBT = await ethers.getContractFactory("SBT");
  const sbt = await SBT.deploy();
  await sbt.waitForDeployment();
  const sbtAddr = await sbt.getAddress();
  console.log("SBT:", sbtAddr);

  // 5) Entropy address (VOCÊ precisa colocar o address correto da Base mainnet)
  const ENTROPY_ADDR = process.env.ENTROPY_ADDR;
  if (!ENTROPY_ADDR) throw new Error("Missing ENTROPY_ADDR in .env");
  console.log("Entropy:", ENTROPY_ADDR);

  // 6) Deploy MainSecure
  const MainSecure = await ethers.getContractFactory("MainSecure");
  const main = await MainSecure.deploy(ENTROPY_ADDR, itemAddr, poolAddr, sbtAddr);
  await main.waitForDeployment();
  const mainAddr = await main.getAddress();
  console.log("MainSecure:", mainAddr);

  // 7) Wire: setMain on RewardPool
  const txSetMain = await pool.setMain(mainAddr);
  await txSetMain.wait();
  console.log("RewardPool.setMain OK");

  // 8) Grant MINTER_ROLE to Main on ItemNFT + SBT
  const MINTER_ROLE = ethers.keccak256(ethers.toUtf8Bytes("MINTER_ROLE"));

  const txItemRole = await item.grantRole(MINTER_ROLE, mainAddr);
  await txItemRole.wait();
  console.log("ItemNFT MINTER_ROLE granted");

  const txSbtRole = await sbt.grantRole(MINTER_ROLE, mainAddr);
  await txSbtRole.wait();
  console.log("SBT MINTER_ROLE granted");

  console.log("\nDONE ✅");
  console.log({ tokenAddr, poolAddr, itemAddr, sbtAddr, mainAddr });
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
