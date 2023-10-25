// SPDX-License-Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity 0.8.18;

import "./shared/abstracts/KYCHandler.sol";
import "./shared/interfaces/IKYCBitkubChain.sol";
import "./shared/abstracts/Committee.sol";
import "./shared/abstracts/Context.sol";
import "./shared/abstracts/AccessController.sol";
import "./shared/abstracts/Pausable.sol";
import "./shared/interfaces/IKAP20/IKAP20.sol";
import "./shared/interfaces/IKAP20/IKToken.sol";
import "./modules/sdk/KAP20.sol";
import "./shared/abstracts/Ownable.sol";
import "./shared/interfaces/IExecutorEnv.sol";
import "./shared/interfaces/IKAP20/IKAP20SDK.sol";

contract NUTToken is KAP20, Ownable {
    constructor(
    address _kyc,
    address _committee,
    address _transferRouter,
    uint256 _acceptedKycLevel
    )
    KAP20(
        "NUT Token",
        "NUT",
        18,
        _kyc,
        _committee,
        _transferRouter,
        _acceptedKycLevel
    )
    {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}


