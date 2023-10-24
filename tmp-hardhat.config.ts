import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";

require("hardhat-contract-sizer");

dotenv.config();

// task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
//   const accounts = await hre.ethers.getSigners();

//   for (const account of accounts) {
//     console.log(account.address);
//   }
// });

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    bkc_testnet: {
      url: `https://rpc-testnet.bitkubchain.io`,
      accounts: [process.env.PRIVATE_KEY!],
      chainId: 25925,
    },
    ethereum: {
      url: `https://eth-mainnet.g.alchemy.com/v2/w3YszEfe5xt9wxbVPXM29OOhf4Z0wMTj`,
      chainId: 1,
      gasPrice: 12 * 10 ** 9,
      accounts: process.env.ETH_SPV !== undefined ? [process.env.ETH_SPV] : [],
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};
export default config;
