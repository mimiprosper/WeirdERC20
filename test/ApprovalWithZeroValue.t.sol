// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ApprovalWithZeroValue.sol";

contract ApprovalWithZeroValueTokenTest is Test {
    ApprovalWithZeroValueToken token;
    address user1 = address(0x1);
    address user2 = address(0x2);
    
    function setUp() public {
        token = new ApprovalWithZeroValueToken(1000 * 10 ** 18);
        token.transfer(user1, 100 * 10 ** 18);  // Transfer some tokens to user1
    }

    function testInitialSupply() public {
        assertEq(token.totalSupply(), 1000 * 10 ** 18);
        assertEq(token.balanceOf(address(this)), 900 * 10 ** 18);
        assertEq(token.balanceOf(user1), 100 * 10 ** 18);
    }

    function testApprove() public {
        vm.prank(user1); // Set the next msg.sender to user1
        token.approve(user2, 50 * 10 ** 18);
        assertEq(token.allowance(user1, user2), 50 * 10 ** 18);
    }

    function testFailApproveZeroValue() public {
        vm.prank(user1); // Set the next msg.sender to user1
        token.approve(user2, 0); // This should fail
    }
}
