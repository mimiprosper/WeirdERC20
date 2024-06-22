// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/BlockList.sol";

contract BlockableTokenTest is Test {
    BlockableToken token;
    address owner = address(0x123);
    address user1 = address(0x456);
    address user2 = address(0x789);
    uint initialSupply = 1000 * 10 ** 18;
    uint fee = 1;

    function setUp() public {
        vm.prank(owner);
        token = new BlockableToken(initialSupply, fee);
    }

    function testInitialSupply() public {
        assertEq(token.balanceOf(owner), initialSupply);
    }

    function testTransferBlockedUser() public {
        vm.prank(owner);
        token.transfer(user1, 100 * 10 ** 18);
        vm.prank(owner);
        token.block(user1);
        vm.prank(user1);
        vm.expectRevert("blocked");
        token.transfer(user2, 50 * 10 ** 18);
    }

    function testTransferFromBlockedUser() public {
        vm.prank(owner);
        token.transfer(user1, 100 * 10 ** 18);
        vm.prank(owner);
        token.block(user1);
        vm.prank(user1);
        vm.expectRevert("blocked");
        token.transferFrom(user1, user2, 50 * 10 ** 18);
    }
}
