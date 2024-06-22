// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/PausableTokens.sol";

contract PausableTokenTest is Test {
    PausableToken token;
    address owner;
    address user;

    function setUp() public {
        owner = address(this);
        user = address(0x1234);
        token = new PausableToken(1000 * 10 ** 18, 1);
    }

    function testInitialSupply() public {
        assertEq(token.balanceOf(owner), 1000 * 10 ** 18);
    }

    function testPause() public {
        token.stop();
        vm.expectRevert(bytes("paused"));
        token.transfer(user, 100);
    }

    function testUnpause() public {
        token.stop();
        token.start();
        token.transfer(user, 100);
        assertEq(token.balanceOf(user), 100);
    }

    function testUnauthorizedPause() public {
        vm.prank(user);
        vm.expectRevert(bytes("unauthorised"));
        token.stop();
    }

    function testTransferWhilePaused() public {
        token.stop();
        vm.expectRevert(bytes("paused"));
        token.transfer(user, 100);
    }

    function testTransferFromWhilePaused() public {
        token.approve(user, 100);
        token.stop();
        vm.prank(user);
        vm.expectRevert(bytes("paused"));
        token.transferFrom(owner, user, 100);
    }
}