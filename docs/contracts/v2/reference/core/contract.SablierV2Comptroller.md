---
sidebar_position: 3
---
# SablierV2Comptroller

[Git Source](https://github.com/sablierhq/v2-core/blob/dd92abb9f3f01149a5be0e13eb517772181c5081/docs/contracts/v2/reference/core)

**Inherits:** [ISablierV2Comptroller](/docs/contracts/v2/reference/core/interfaces/interface.ISablierV2Comptroller.md),
[SablierV2Adminable](/docs/contracts/v2/reference/core/abstracts/abstract.SablierV2Adminable.md)

See the documentation in
[ISablierV2Comptroller](docs/contracts/v2/reference/core/interfaces/interface.ISablierV2Comptroller.md).

## State Variables

### flashFee

The global flash fee as an UD60x18 number where 100% = 1e18.

Notes:

- This is a fee percentage, not a fee amount. This should not be confused with the {IERC3156FlashLender-flashFee}
  function, which returns the fee amount for a given flash loan amount.
- Unlike the protocol fee, this is not a per-asset fee. It's a global fee applied to all flash loans.

```solidity
UD60x18 public override flashFee;
```

### \_flashAssets

_ERC-20 assets that can be flash loaned._

```solidity
mapping(IERC20 asset => bool supported) internal _flashAssets;
```

### \_protocolFees

_Global fees mapped by ERC-20 asset addresses._

```solidity
mapping(IERC20 asset => UD60x18 fee) internal _protocolFees;
```

## Functions

### constructor

_Emits a {TransferAdmin} event._

```solidity
constructor(address initialAdmin);
```

**Parameters**

| Name           | Type      | Description                                |
| -------------- | --------- | ------------------------------------------ |
| `initialAdmin` | `address` | The address of the initial contract admin. |

### getProtocolFee

Queries the protocol fee charged on all streams created with the provided ERC-20 asset across all Sablier V2 contracts.

```solidity
function getProtocolFee(IERC20 asset) external view override returns (UD60x18 protocolFee);
```

**Parameters**

| Name    | Type     | Description                                                     |
| ------- | -------- | --------------------------------------------------------------- |
| `asset` | `IERC20` | The contract address of the ERC-20 asset to make the query for. |

**Returns**

| Name          | Type      | Description                                              |
| ------------- | --------- | -------------------------------------------------------- |
| `protocolFee` | `UD60x18` | The protocol fee as an UD60x18 number where 100% = 1e18. |

### isFlashLoanable

Checks whether the provided ERC-20 asset is flash loanable or not.

```solidity
function isFlashLoanable(IERC20 asset) external view override returns (bool result);
```

**Parameters**

| Name    | Type     | Description |
| ------- | -------- | ----------- |
| `asset` | `IERC20` |             |

### setFlashFee

Sets a new flash fee that will be charged on all flash loans made with any ERC-20 asset.

Emits a {SetFlashFee} event. Notes:

- Does not revert if the fee is the same. Requirements:
- The caller must be the contract admin.

```solidity
function setFlashFee(UD60x18 newFlashFee) external override onlyAdmin;
```

**Parameters**

| Name          | Type      | Description                                                       |
| ------------- | --------- | ----------------------------------------------------------------- |
| `newFlashFee` | `UD60x18` | The new flash fee to set, as an UD60x18 number where 100% = 1e18. |

### setProtocolFee

Sets a new protocol fee that will be charged on all streams created with the provided ERC-20 asset across all Sablier V2
contracts.

Emits a {SetProtocolFee} event. Notes:

- The fee is not in units of the asset's decimals, but in the UD60x18 number format. Refer to the PRBMath documentation
  for more detail on the logic of UD60x18.
- Does not revert if the fee is the same. Requirements:
- The caller must be the contract admin.

```solidity
function setProtocolFee(IERC20 asset, UD60x18 newProtocolFee) external override onlyAdmin;
```

**Parameters**

| Name             | Type      | Description                                                          |
| ---------------- | --------- | -------------------------------------------------------------------- |
| `asset`          | `IERC20`  | The contract address of the ERC-20 asset to make the query for.      |
| `newProtocolFee` | `UD60x18` | The new protocol fee to set, as an UD60x18 number where 100% = 1e18. |

### toggleFlashAsset

Toggles the flash loanability of an ERC-20 asset. This flag is applied to all Sablier V2 contracts.

Emits a {ToggleFlashAsset} event. Requirements:

- The caller must be the admin.

```solidity
function toggleFlashAsset(IERC20 asset) external override onlyAdmin;
```

**Parameters**

| Name    | Type     | Description                                |
| ------- | -------- | ------------------------------------------ |
| `asset` | `IERC20` | The address of the ERC-20 asset to toggle. |