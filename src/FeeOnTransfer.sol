// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TransferFeeToken is ERC20 {

    uint immutable fee;

    // --- Init ---
    constructor(uint _initialSupply, uint _fee) ERC20("TransferFeeToken", "TFT") {
        fee = _fee;
        _mint(msg.sender, _initialSupply);
    }

    // --- Token ---
    function transferFrom(address src, address dst, uint wad) public override returns (bool) {
        require(balanceOf(src) >= wad, "insufficient-balance");
        if (src != msg.sender && allowance(src, msg.sender) != type(uint).max) {
            require(allowance(src, msg.sender) >= wad, "insufficient-allowance");
            _approve(src, msg.sender, allowance(src, msg.sender) - wad);
        }

        _transfer(src, dst, wad - fee);
        _burn(src, fee);

        return true;
    }
}