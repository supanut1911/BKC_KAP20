// SPDX-License-Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity 0.8.18;

interface IKYCBitkubChain {
  function kycsLevel(address _addr) external view returns (uint256);

  function setKycCompleted(address _addr, uint256 _level) external;
}
