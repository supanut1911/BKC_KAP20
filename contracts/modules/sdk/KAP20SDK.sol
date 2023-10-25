// SPDX-License-Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity 0.8.18;

import ".././sdk/KAP20.sol";
import "../../shared/abstracts/AccessControllerSDK.sol";

contract KAP20SDK is KAP20, IKAP20SDK, AccessControllerSDK {
  modifier onlyOwnerOrHolder(address _burner) {
    require(msg.sender == owner() || msg.sender == _burner, "KAP20SDK: Restricted only super admin or owner or holder");
    _;
  }

  modifier onlyOwnerOrCommittee() {
    require(msg.sender == owner() || msg.sender == committee, "KAP20SDK: Restricted only owner or committee");
    _;
  }

  ///////////////////////////////////////////////////////////////////////////////////////

  constructor(
    string memory _name,
    string memory _symbol,
    uint8 _decimals,
    address _kyc,
    address _committee,
    address _transferRouter,
    address _executorEnv,
    uint256 _acceptedKycLevel,
    string memory _envId
  )
    KAP20(_name, _symbol, _decimals, _kyc, _committee, _transferRouter, _acceptedKycLevel)
    AccessControllerSDK(_executorEnv, _envId)
  {}

  ///////////////////////////////////////////////////////////////////////////////////////

  function setExecutorEnv(address _executorEnv) external onlyCommittee {
    require(address(executorEnv) != _executorEnv, "Authorization: Same as old admin address");
    emit ExecutorEnvSet(address(executorEnv), _executorEnv, msg.sender);
    executorEnv = IExecutorEnv(_executorEnv);
  }

  function pause() external onlyOwner {
    _pause();
  }

  function unpause() external onlyOwner {
    _unpause();
  }

  ///////////////////////////////////////////////////////////////////////////////////////

  function approveBySDK(
    address _owner,
    address _spender,
    uint256 _amount
  ) external override onlyExecutor returns (bool) {
    require(kyc.kycsLevel(_owner) >= acceptedKycLevel, "KAP20: Owner address is not a KYC user");

    _approve(_owner, _spender, _amount);
    return true;
  }

  function transferFromBySDK(
    address _sender,
    address _recipient,
    uint256 _amount
  ) external override onlyExecutor returns (bool) {
    require(
      kyc.kycsLevel(_sender) >= acceptedKycLevel && kyc.kycsLevel(_recipient) >= acceptedKycLevel,
      "KAP20: Only internal purpose"
    );

    _transfer(_sender, _recipient, _amount);
    return true;
  }

  ///////////////////////////////////////////////////////////////////////////////////////

  function mint(address _to, uint256 _amount) external onlyOwner whenNotPaused {
    _mint(_to, _amount);
  }

  function burn(address _from, uint256 _amount) external onlyOwnerOrHolder(_from) whenNotPaused {
    _burn(_from, _amount);
  }
}