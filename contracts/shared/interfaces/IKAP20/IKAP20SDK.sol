// SPDX-License-Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity 0.8.18;

interface IKAP20SDK {
  function approveBySDK(
    address _owner,
    address _spender,
    uint256 _amount
  ) external returns (bool);

  function transferFromBySDK(
    address _sender,
    address _recipient,
    uint256 _amount
  ) external returns (bool);
}