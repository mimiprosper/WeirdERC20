// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/RevertZero.sol";

contract RevertZeroTest is Test {
    RevertZeroToken token;
    address owner = address(0xABCD);
    address recipient = address(0x1234);

    function setUp() public {
        // Initialize the contract with 1000 tokens
        token = new RevertZeroToken(1000 ether);
        // Transfer ownership of the initial supply to `owner`
        token.transfer(owner, 1000 ether);
    }

    function testInitialSupply() public {
        assertEq(token.balanceOf(owner), 1000 ether);
    }

    function testTransfer() public {
        vm.startPrank(owner);
        token.transfer(recipient, 100 ether);
        assertEq(token.balanceOf(recipient), 100 ether);
        assertEq(token.balanceOf(owner), 900 ether);
        vm.stopPrank();
    }

    function testZeroValueTransferFromReverts() public {
        vm.startPrank(owner);
        token.approve(address(this), 100 ether);
        vm.expectRevert("zero-value-transfer");
        token.transferFrom(owner, recipient, 0);
        vm.stopPrank();
    }

      // function testZeroValueTransferReverts() public {
    //     vm.startPrank(owner);
    //     vm.expectRevert("zero-value-transfer");
    //     token.transfer(recipient, 0);
    //     vm.stopPrank();
    // }

    // function testTransferFrom() public {
    //     vm.startPrank(owner);
    //     token.approve(address(this), 100 ether);
    //     token.transferFrom(owner, recipient, 100 ether);
    //     assertEq(token.balanceOf(recipient), 100 ether);
    //     assertEq(token.balanceOf(owner), 900 ether);
    //     vm.stopPrank();
    // }
}
