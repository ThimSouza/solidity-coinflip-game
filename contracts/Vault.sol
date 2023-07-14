// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";

contract Vault is ERC4626 {
    constructor(
        IERC20 token,
        string memory name,
        string memory symbol
    ) ERC4626(token) ERC20(name, symbol) {}
}
