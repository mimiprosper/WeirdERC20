// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ApprovalRaceToken.sol";

contract ApprovalRaceTokenTest is Test {
    ApprovalRaceToken token;
    address user1 = address(0x1);
    address user2 = address(0x2);

    function setUp() public {
        token = new ApprovalRaceToken("ApprovalRaceToken", "ART", 1000 * 10 ** 18);
    }

    function testInitialSupply() public {
        assertEq(token.totalSupply(), 1000 * 10 ** 18);
        assertEq(token.balanceOf(address(this)), 1000 * 10 ** 18);
    }

    function testApprove() public {
        vm.prank(user1);
        bool success = token.approve(user2, 100);
        assertTrue(success);
        assertEq(token.allowance(user1, user2), 100);
    }

    function testUnsafeApprove() public {
        vm.prank(user1);
        token.approve(user2, 100);

        vm.expectRevert("unsafe-approve");
        vm.prank(user1);
        token.approve(user2, 200);
    }
}

