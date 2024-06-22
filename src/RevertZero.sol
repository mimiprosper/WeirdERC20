// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/*
Some tokens (e.g. LEND) revert when transferring a zero value amount.
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RevertZeroToken is ERC20 {
    // --- Init ---
    constructor(uint _initialSupply) ERC20("TransferFeeToken", "TFT") {
        _mint(msg.sender, _initialSupply);
    }

    // --- Token ---
    function transferFrom(address src, address dst, uint wad) override public returns (bool) {
        require(wad != 0, "zero-value-transfer");
        return super.transferFrom(src, dst, wad);
    }
}