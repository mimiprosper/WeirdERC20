// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/*
Some tokens (e.g. USDT, KNC) do not allow approving an amount M > 0 when an existing amount N > 0 is already approved.
*/

contract ApprovalRaceToken is ERC20 {
    // --- Init ---
    constructor(string memory name, string memory symbol, uint _totalSupply) ERC20(name, symbol) {
        _mint(msg.sender, _totalSupply);
    }

    // --- Token ---
    function approve(address usr, uint wad) public override returns (bool) {
        require(allowance(msg.sender, usr) == 0, "unsafe-approve");
        return super.approve(usr, wad);
    }
}