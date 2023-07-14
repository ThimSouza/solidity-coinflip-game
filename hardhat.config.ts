import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();
const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.5.5",
      },
      {
        version: "0.8.17",
      },
    ],
  },
  networks: {
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [
        "c24b018dae53872ff4027c537cc60d708e4957a2a1c1804709670a942ef83a61",
      ],
    },
  },
};

export default config;
