// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PausableToken is ERC20 {
    // --- Access Control ---
    address owner;
    uint fee;

    modifier auth() {
        require(msg.sender == owner, "unauthorised");
        _;
    }

    // --- Pause ---
    bool live = true;

    function stop() external auth {
        live = false;
    }

    function start() external auth {
        live = true;
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
    function approve(address usr, uint wad) public override returns (bool) {
        require(live, "paused");
        return super.approve(usr, wad);
    }

    function transfer(address dst, uint wad) public override returns (bool) {
        require(live, "paused");
        return super.transfer(dst, wad);
    }

    function transferFrom(
        address src,
        address dst,
        uint wad
    ) public override returns (bool) {
        require(live, "paused");
        return super.transferFrom(src, dst, wad);
    }
}
