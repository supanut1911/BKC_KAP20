// Sources flattened with hardhat v2.18.2 https://hardhat.org

// SPDX-License-Identifier: MIT

// File contracts/shared/abstracts/Committee.sol

// Original license: SPDX_License_Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity 0.8.18;

abstract contract Committee {
  address public committee;

  event CommitteeSet(address indexed oldCommittee, address indexed newCommittee, address indexed caller);

  modifier onlyCommittee() {
    require(msg.sender == committee, "Committee: Restricted only committee");
    _;
  }

  function setCommittee(address _committee) public virtual onlyCommittee {
    emit CommitteeSet(committee, _committee, msg.sender);
    committee = _committee;
  }
}


// File contracts/shared/interfaces/IKYCBitkubChain.sol

// Original license: SPDX_License_Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity 0.8.18;

interface IKYCBitkubChain {
  function kycsLevel(address _addr) external view returns (uint256);

  function setKycCompleted(address _addr, uint256 _level) external;
}


// File contracts/shared/abstracts/KYCHandler.sol

// Original license: SPDX_License_Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity 0.8.18;

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


// File contracts/shared/abstracts/AccessController.sol

// Original license: SPDX_License_Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity 0.8.18;


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


// File contracts/shared/abstracts/Context.sol

// Original license: SPDX_License_Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org



pragma solidity 0.8.18;

abstract contract Context {
  function _msgSender() internal view virtual returns (address) {
    return msg.sender;
  }

  function _msgData() internal view virtual returns (bytes calldata) {
    return msg.data;
  }
}


// File contracts/shared/abstracts/Pausable.sol

// Original license: SPDX_License_Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org
pragma solidity 0.8.18;

abstract contract Pausable is Context {
  event Paused(address account);

  event Unpaused(address account);

  bool private _paused;

  constructor() {
    _paused = false;
  }

  function paused() public view virtual returns (bool) {
    return _paused;
  }

  modifier whenNotPaused() {
    require(!paused(), "Pausable: paused");
    _;
  }

  modifier whenPaused() {
    require(paused(), "Pausable: not paused");
    _;
  }

  function _pause() internal virtual whenNotPaused {
    _paused = true;
    emit Paused(_msgSender());
  }

  function _unpause() internal virtual whenPaused {
    _paused = false;
    emit Unpaused(_msgSender());
  }
}


// File contracts/shared/interfaces/IKAP20/IKAP20.sol

// Original license: SPDX_License_Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity >=0.6.0;

interface IKAP20 {
  function totalSupply() external view returns (uint256);

  function decimals() external view returns (uint8);

  function symbol() external view returns (string memory);

  function name() external view returns (string memory);

  function balanceOf(address account) external view returns (uint256);

  function transfer(address recipient, uint256 amount) external returns (bool);

  function allowance(address _owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 amount) external returns (bool);

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external returns (bool);

  function adminTransfer(
    address sender,
    address recipient,
    uint256 amount
  ) external returns (bool success);

  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);
}


// File contracts/shared/interfaces/IKAP20/IKAP20SDK.sol

// Original license: SPDX_License_Identifier: MIT
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


// File contracts/shared/interfaces/IKAP20/IKToken.sol

// Original license: SPDX_License_Identifier: MIT
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


// File contracts/modules/sdk/KAP20.sol

// Original license: SPDX_License_Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity 0.8.18;





abstract contract KAP20 is IKAP20, IKToken, Pausable, AccessController {
  mapping(address => uint256) _balances;

  mapping(address => mapping(address => uint256)) internal _allowances;

  uint256 public override totalSupply;

  string public override name;
  string public override symbol;
  uint8 public override decimals;

  constructor(
    string memory _name,
    string memory _symbol,
    uint8 _decimals,
    address _kyc,
    address _committee,
    address _transferRouter,
    uint256 _acceptedKycLevel
  ) {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
    kyc = IKYCBitkubChain(_kyc);
    committee = _committee;
    transferRouter = _transferRouter;
    acceptedKycLevel = _acceptedKycLevel;
  }

  function balanceOf(address account) public view virtual override returns (uint256) {
    return _balances[account];
  }

  function transfer(address recipient, uint256 amount) public virtual override whenNotPaused returns (bool) {
    _transfer(msg.sender, recipient, amount);
    return true;
  }

  function allowance(address owner, address spender) public view virtual override returns (uint256) {
    return _allowances[owner][spender];
  }

  function approve(address spender, uint256 amount) public virtual override returns (bool) {
    _approve(msg.sender, spender, amount);
    return true;
  }

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) public virtual override whenNotPaused returns (bool) {
    _transfer(sender, recipient, amount);

    uint256 currentAllowance = _allowances[sender][msg.sender];
    require(currentAllowance >= amount, "KAP20: Transfer amount exceeds allowance");
    unchecked {
      _approve(sender, msg.sender, currentAllowance - amount);
    }

    return true;
  }

  function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
    _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
    return true;
  }

  function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
    uint256 currentAllowance = _allowances[msg.sender][spender];
    require(currentAllowance >= subtractedValue, "KAP20: Decreased allowance below zero");
    unchecked {
      _approve(msg.sender, spender, currentAllowance - subtractedValue);
    }

    return true;
  }

  function _transfer(
    address sender,
    address recipient,
    uint256 amount
  ) internal virtual {
    require(sender != address(0), "KAP20: Transfer from the zero address");
    require(recipient != address(0), "KAP20: Transfer to the zero address");

    uint256 senderBalance = _balances[sender];
    require(senderBalance >= amount, "KAP20: Transfer amount exceeds balance");
    unchecked {
      _balances[sender] = senderBalance - amount;
    }
    _balances[recipient] += amount;

    emit Transfer(sender, recipient, amount);
  }

  function _mint(address account, uint256 amount) internal virtual {
    require(account != address(0), "KAP20: Mint to the zero address");

    totalSupply += amount;
    _balances[account] += amount;
    emit Transfer(address(0), account, amount);
  }

  function _burn(address account, uint256 amount) internal virtual {
    require(account != address(0), "KAP20: Burn from the zero address");

    uint256 accountBalance = _balances[account];
    require(accountBalance >= amount, "KAP20: Burn amount exceeds balance");
    unchecked {
      _balances[account] = accountBalance - amount;
    }
    totalSupply -= amount;

    emit Transfer(account, address(0), amount);
  }

  function _approve(
    address owner,
    address spender,
    uint256 amount
  ) internal virtual {
    require(owner != address(0), "KAP20: Approve from the zero address");
    require(spender != address(0), "KAP20: Approve to the zero address");

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  function adminTransfer(
    address sender,
    address recipient,
    uint256 amount
  ) public virtual override onlyCommittee returns (bool) {
    if (isActivatedOnlyKycAddress) {
      require(kyc.kycsLevel(sender) > 0 && kyc.kycsLevel(recipient) > 0, "KAP20: Only internal purpose");
    }
    uint256 senderBalance = _balances[sender];
    require(senderBalance >= amount, "KAP20: Transfer amount exceeds balance");
    unchecked {
      _balances[sender] = senderBalance - amount;
    }
    _balances[recipient] += amount;

    emit Transfer(sender, recipient, amount);

    return true;
  }

  function internalTransfer(
    address sender,
    address recipient,
    uint256 amount
  ) external override whenNotPaused onlyTransferRouter returns (bool) {
    require(
      kyc.kycsLevel(sender) >= acceptedKycLevel && kyc.kycsLevel(recipient) >= acceptedKycLevel,
      "KAP20: Only internal purpose"
    );

    _transfer(sender, recipient, amount);
    return true;
  }

  function externalTransfer(
    address sender,
    address recipient,
    uint256 amount
  ) external override whenNotPaused onlyTransferRouter returns (bool) {
    require(kyc.kycsLevel(sender) >= acceptedKycLevel, "KAP20: Only internal purpose");

    _transfer(sender, recipient, amount);
    return true;
  }
}


// File contracts/shared/abstracts/Ownable.sol

// Original license: SPDX_License_Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org



pragma solidity 0.8.18;

abstract contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  constructor() {
    _transferOwnership(_msgSender());
  }

  function owner() public view virtual returns (address) {
    return _owner;
  }

  modifier onlyOwner() {
    require(owner() == _msgSender(), "Ownable: Caller is not the owner");
    _;
  }

  function renounceOwnership() public virtual onlyOwner {
    _transferOwnership(address(0));
  }

  function transferOwnership(address newOwner) public virtual onlyOwner {
    require(newOwner != address(0), "Ownable: New owner is the zero address");
    _transferOwnership(newOwner);
  }

  function _transferOwnership(address newOwner) internal virtual {
    address oldOwner = _owner;
    _owner = newOwner;
    emit OwnershipTransferred(oldOwner, newOwner);
  }
}


// File contracts/shared/interfaces/IExecutorEnv.sol

// Original license: SPDX_License_Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity 0.8.18;

interface IExecutorEnv {
  function rootAdmin() external view returns (address);

  function isExecutor(address _addr, string calldata _env) external view returns (bool);
}


// File contracts/shared/abstracts/AccessControllerSDK.sol

// Original license: SPDX_License_Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity 0.8.18;


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


// File contracts/modules/sdk/KAP20SDK.sol

// Original license: SPDX_License_Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity 0.8.18;


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


// File contracts/NUTToken.sol

// Original license: SPDX_License_Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity 0.8.18;












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
