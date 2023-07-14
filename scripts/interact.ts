import { ethers } from "hardhat";

async function main() {
  const mintAmount = ethers.utils.parseEther("0.02");

  const Token = await ethers.getContractFactory("CoinFlip");
  const token = await Token.attach(
    "0x359b6aAA709727972f9C85f76De95c828864FAAE"
  );

  const addMinter = await token.flip(1, {
    value: ethers.utils.parseEther("0.02"),
  });

  console.log(`${addMinter}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
