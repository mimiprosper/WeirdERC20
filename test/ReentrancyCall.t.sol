// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ReentrancyCall.sol";

contract ReentrantCallTest is Test {
    ReentrantToken token;
    address owner;
    address user1;
    address user2;

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        token = new ReentrantToken(1000);
        token.transfer(user1, 500);
    }

    function testInitialSupply() public view returns (uint256) {
        assertEq(token.totalSupply(), 1000);
        assertEq(token.balanceOf(owner), 500);
    }

    function testTransferFrom() public {
        vm.prank(user1);
        token.approve(owner, 100);

        bool success = token.transferFrom(user1, user2, 100);
        assertTrue(success);
        assertEq(token.balanceOf(user1), 400);
        assertEq(token.balanceOf(user2), 100);
    }
}