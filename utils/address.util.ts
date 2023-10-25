import fs from "fs";
import hre from "hardhat";
import path from "path";

export const getAddressPath = (networkName = hre.network.name) =>
  path.join(__dirname, `../address-lists/${networkName}.json`);

export const getAddressList = (
  networkName = hre.network.name
): Record<string, string> => {
  const addressPath = getAddressPath(networkName);
  try {
    const data = fs.readFileSync(addressPath);
    return JSON.parse(data.toString());
  } catch (e) {
    return {};
  }
};

export const getAddress = (
  key: string,
  networkName = hre.network.name
): string | undefined => {
  const addressPath = getAddressPath(networkName);
  try {
    const data = fs.readFileSync(addressPath);
    const json = JSON.parse(data.toString());
    return json[key];
  } catch (e) {
    return undefined;
  }
};

export const setAddress = (
  key: string,
  value: string,
  networkName = hre.network.name
) => {
  const addressPath = getAddressPath(networkName);
  const addressList = getAddressList();

  const pathArr = addressPath.split("/");
  const dirPath = [...pathArr].slice(-1).join("/");

  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath);
  }

  try {
    fs.writeFileSync(
      addressPath,
      JSON.stringify({ ...addressList, [key]: value })
    );
    return true;
  } catch (e) {
    return false;
  }
};

export const setAddresses = (
  newAddressList: Record<string, string>,
  networkName = hre.network.name
) => {
  const addressPath = getAddressPath(networkName);
  const addressList = getAddressList();

  const pathArr = addressPath.split("/");
  const dirPath = [...pathArr].slice(-1).join("/");

  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath);
  }

  try {
    fs.writeFileSync(
      addressPath,
      JSON.stringify({ ...addressList, ...newAddressList })
    );
    return true;
  } catch (e) {
    return false;
  }
};

export default {
  getAddressList,
  getAddressPath,
  getAddress,
  setAddress,
};
