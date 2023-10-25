
// SPDX-License-Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity 0.8.18;

interface IKToken {
  function internalTransfer(
    address sender,
    address recipient,
    uint256 amount
  ) external returns (bool);

  function externalTransfer(
    address sender,
    address recipient,
    uint256 amount
  ) external returns (bool);
}
