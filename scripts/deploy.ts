import { ethers, network, run } from "hardhat";

async function main() {
  const tokenMBPamount = ethers.utils.parseEther("0.20");

  const TokenMBP = await ethers.getContractFactory("CoinFlip");
  const tokenMBP = await TokenMBP.deploy({ value: tokenMBPamount });

  await tokenMBP.deployed();

  console.log(`CoinFlip deployed to ${tokenMBP.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
