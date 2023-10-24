
// SPDX-License-Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity ^0.8.0;

import "../abstracts/Ownable.sol";
import "../interfaces/IExecutorEnv.sol";

abstract contract AccessControllerSDK is Ownable {
  IExecutorEnv public executorEnv;
  string public envId;

  event ExecutorEnvSet(address indexed oldExecutorEnv, address indexed newExecutorEnv, address indexed caller);

  constructor(address executorEnv_, string memory envId_) {
    executorEnv = IExecutorEnv(executorEnv_);
    envId = envId_;
  }

  modifier onlyExecutor() {
    require(executorEnv.isExecutor(msg.sender, envId), "Authorization: Restricted only executor");
    _;
  }
}