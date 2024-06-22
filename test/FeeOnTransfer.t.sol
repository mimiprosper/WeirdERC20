// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/FeeOnTransfer.sol";

contract TransferFeeTokenTest is Test {
    TransferFeeToken public transferFeeToken;
    address public owner;
    address public addr1;
    address public addr2;

    function setUp() public {
        owner = address(this);
        addr1 = address(0x1);
        addr2 = address(0x2);

        uint initialSupply = 1000 ether;
        uint fee = 1 ether;

        transferFeeToken = new TransferFeeToken(initialSupply, fee);
    }

    function testInitialSupply() public view returns (uint) {
        uint ownerBalance = transferFeeToken.balanceOf(owner);
        assertEq(ownerBalance, 1000 ether);
    }

    function testTransferWithFee() public {
        transferFeeToken.approve(addr1, 100 ether);

        vm.prank(addr1);
        transferFeeToken.transferFrom(owner, addr1, 100 ether);

        uint ownerBalance = transferFeeToken.balanceOf(owner);
        uint addr1Balance = transferFeeToken.balanceOf(addr1);

        assertEq(ownerBalance, 900 ether);
        assertEq(addr1Balance, 99 ether); // 100 - 1 fee
    }

    function testInsufficientBalance() public {
        transferFeeToken.approve(addr1, 1100 ether);

        vm.prank(addr1);
        vm.expectRevert("insufficient-balance");
        transferFeeToken.transferFrom(owner, addr1, 1100 ether);
    }

    function testInsufficientAllowance() public {
        transferFeeToken.approve(addr1, 50 ether);

        vm.prank(addr1);
        vm.expectRevert("insufficient-allowance");
        transferFeeToken.transferFrom(owner, addr1, 100 ether);
    }
}