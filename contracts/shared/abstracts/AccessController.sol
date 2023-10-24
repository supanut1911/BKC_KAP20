// SPDX-License-Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity ^0.8.0;

import "../abstracts/KYCHandler.sol";
import "../abstracts/Committee.sol";

abstract contract AccessController is KYCHandler, Committee {
  address public transferRouter;

  event TransferRouterSet(address indexed oldTransferRouter, address indexed newTransferRouter, address indexed caller);

  modifier onlyTransferRouter() {
    require(msg.sender == transferRouter, "AccessController: Restricted only transfer router");
    _;
  }

  function activateOnlyKycAddress() external onlyCommittee {
    _activateOnlyKycAddress();
  }

  function setKyc(IKYCBitkubChain _kyc) external onlyCommittee {
    _setKyc(_kyc);
  }

  function setAcceptedKycLevel(uint256 _kycLevel) external onlyCommittee {
    _setAcceptedKycLevel(_kycLevel);
  }

  function setTransferRouter(address _transferRouter) external onlyCommittee {
    emit TransferRouterSet(transferRouter, _transferRouter, msg.sender);
    transferRouter = _transferRouter;
  }
}