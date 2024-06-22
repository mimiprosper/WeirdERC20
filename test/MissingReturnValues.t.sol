// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/MissingReturnValues.sol";

contract MissingReturnTokenTest is Test {
    MissingReturnToken token;

    function setUp() public {
        token = new MissingReturnToken(1000000 * 10**18); // Minting 1 million tokens
    }

    function testTransfer() public {
        address recipient = address(0x123); // Example recipient address
        uint amount = 500 * 10**18; // Sending 500 tokens

        // Transfer tokens
        token.transfer(recipient, amount);

        // Check balances
        assertEq(token.balanceOf(address(this)), 999500 * 10**18, "Sender balance should decrease");
        assertEq(token.balanceOf(recipient), 500 * 10**18, "Recipient balance should increase");
    }

    function testApproveAndTransferFrom() public {
        address spender = address(0x456); // Example spender address
        uint amount = 300 * 10**18; // Approving and transferring 300 tokens

        // Approve spender
        token.approve(spender, amount);

        // Transfer from sender to recipient via spender
        token.transferFrom(address(this), address(0x789), amount); // Assuming 0x789 is the recipient

        // Check balances
        assertEq(token.balanceOf(address(this)), 999700 * 10**18, "Sender balance should decrease further");
        assertEq(token.balanceOf(address(0x789)), 300 * 10**18, "Recipient balance should increase further");
    }
}
