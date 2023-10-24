// SPDX-License-Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org



pragma solidity ^0.8.0;

abstract contract Context {
  function _msgSender() internal view virtual returns (address) {
    return msg.sender;
  }

  function _msgData() internal view virtual returns (bytes calldata) {
    return msg.data;
  }
}