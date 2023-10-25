// SPDX-License-Identifier: MIT
// Sources flattened with hardhat v2.9.3 https://hardhat.org

pragma solidity 0.8.18;

import "../../shared/interfaces/IKAP20/IKAP20.sol";
import "../../shared/interfaces/IKAP20/IKAP20SDK.sol";
import "../../shared/interfaces/IKAP20/IKToken.sol";
import "../../shared/abstracts/Pausable.sol";
import "../../shared/abstracts/AccessController.sol";

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