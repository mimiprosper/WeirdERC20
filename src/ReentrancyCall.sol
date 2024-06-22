// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/*
Some tokens allow reentrant calls on transfer
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ReentrantToken is ERC20 {
    // --- Init ---
    // constructor(uint _totalSupply) public ERC20(_totalSupply) {}

    constructor(uint _totalSupply) ERC20("ReentrantToken", "RTK") {
        _mint(msg.sender, _totalSupply);
    }

    // --- Call Targets ---
    mapping(address => Target) public targets;
    struct Target {
        bytes data;
        address addr;
    }

    function setTarget(address addr, bytes calldata data) external {
        targets[msg.sender] = Target(data, addr);
    }

    // --- Token ---
    function transferFrom(
        address src,
        address dst,
        uint wad
    ) public override returns (bool res) {
        res = super.transferFrom(src, dst, wad);
        Target memory target = targets[src];
        if (target.addr != address(0)) {
            (bool status, ) = target.addr.call{gas: gasleft()}(target.data);
            require(status, "call failed");
        }
    }
}
