// SPDX-License-Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity 0.8.18;

interface IExecutorEnv {
  function rootAdmin() external view returns (address);

  function isExecutor(address _addr, string calldata _env) external view returns (bool);
}
