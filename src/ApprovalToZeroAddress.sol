// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/*
Some tokens (e.g. OpenZeppelin) will revert if trying to approve the zero address to spend tokens (i.e. a call to approve(address(0), amt)).
*/

contract ApprovalToZeroAddressToken is ERC20 {
    // --- Init ---
    constructor(uint _initialSupply) ERC20("TransferFeeToken", "TFT") {
        _mint(msg.sender, _initialSupply);
    }

    // --- Token ---
    function approve(address usr, uint wad) override public returns (bool) {
        require(usr != address(0), "no approval for the zero address");
        return super.approve(usr, wad);
    }
}