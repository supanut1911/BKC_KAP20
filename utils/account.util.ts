import * as dotenv from "dotenv";
import * as fs from "fs";
import * as path from "path";

export const getAccounts = (networkName = "hardhat") => {
  const targetENVPath = path.join(__dirname, `../.env.${networkName}`);
  const envPath = fs.existsSync(targetENVPath)
    ? targetENVPath
    : path.join(__dirname, `../.env`);

  dotenv.config({
    path: envPath,
  });

  const arr = Object.entries(process.env);
  const privateKeys = arr
    .filter(([key]) => key.startsWith("PRIVATE_KEY"))
    .map(([, value]) => value || "")
    .filter((value) => value !== "");

  return privateKeys;
};

export default {
  getAccounts,
};
