// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/*
Some tokens have low decimals (e.g. USDC has 6). Even more extreme, some tokens like Gemini USD only have 2 decimals.

This may result in larger than expected precision loss.
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LowDecimalToken is ERC20 {
     constructor(uint _initialSupply) ERC20("TransferFeeToken", "TFT") {
        // decimals = 2;
        _mint(msg.sender, _initialSupply);
    }
}
