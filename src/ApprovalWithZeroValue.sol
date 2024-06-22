// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ApprovalWithZeroValueToken is ERC20 {
    // --- Init ---
      constructor(uint _initialSupply) ERC20("TransferFeeToken", "TFT") {
        _mint(msg.sender, _initialSupply);
    }

    // --- Token ---
    function approve(address usr, uint wad) override public returns (bool) {
        require(wad > 0, "no approval with zero value");
        return super.approve(usr, wad);
    }
}