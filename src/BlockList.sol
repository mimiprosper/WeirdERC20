// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BlockableToken is ERC20 {

    uint immutable fee;
    
    // --- Access Control ---
    address owner;
    modifier auth() {
        require(msg.sender == owner, "unauthorised");
        _;
    }

    // --- BlockList ---
    mapping(address => bool) blocked;

    function block(address usr) public auth {
        blocked[usr] = true;
    }

    function allow(address usr) public auth {
        blocked[usr] = false;
    }

    // --- Init ---
    constructor(
        uint _initialSupply,
        uint _fee
    ) ERC20("TransferFeeToken", "TFT") {
        fee = _fee;
        _mint(msg.sender, _initialSupply);
    }

    // --- Token ---
    function transferFrom(
        address src,
        address dst,
        uint wad
    ) public override returns (bool) {
        require(!blocked[src], "blocked");
        require(!blocked[dst], "blocked");
        return super.transferFrom(src, dst, wad);
    }
}
