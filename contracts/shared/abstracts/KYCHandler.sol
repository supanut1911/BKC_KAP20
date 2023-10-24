// SPDX-License-Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity ^0.8.0;

import "../interfaces/IKYCBitkubChain.sol";

abstract contract KYCHandler {
  IKYCBitkubChain public kyc;

  uint256 public acceptedKycLevel;
  bool public isActivatedOnlyKycAddress;

  function _activateOnlyKycAddress() internal virtual {
    isActivatedOnlyKycAddress = true;
  }

  function _setKyc(IKYCBitkubChain _kyc) internal virtual {
    kyc = _kyc;
  }

  function _setAcceptedKycLevel(uint256 _kycLevel) internal virtual {
    acceptedKycLevel = _kycLevel;
  }
}