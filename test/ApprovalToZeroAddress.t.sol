// test/ApprovalToZeroAddressToken.t.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ApprovalToZeroAddress.sol";

contract ApprovalToZeroAddressTest is Test {
    ApprovalToZeroAddressToken token;
    address user1 = address(0x1);
    address user2 = address(0x2);
    address zeroAddress = address(0);

    function setUp() public {
        token = new ApprovalToZeroAddressToken(1000 * 10 ** 18);
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

    function testApproveZeroAddress() public {
        vm.expectRevert("no approval for the zero address");
        vm.prank(user1);
        token.approve(zeroAddress, 100);
    }
}
