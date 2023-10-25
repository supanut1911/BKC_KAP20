import { ethers } from "hardhat";
import { setAddress } from "../utils/address.util";
async function main() {
  const contractName = "KKUBToken";

  const xToken = await ethers.deployContract(contractName, [
    "0x0B80357691c27c0c9Ba25123F832190C0b86aCA1",
    "0x5bcDFb971d6622eEf0bFcAf7EcB6120a822B1Cd3",
    "0xF2B8821FA1e5cE47A99bD67c9f9E1724e48FD680",
    4,
  ]);
  const XToken = await xToken.waitForDeployment();
  setAddress(contractName, await XToken.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
