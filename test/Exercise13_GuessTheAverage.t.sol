// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {GuessTheAverage} from "../src/SolidityHackingWorkshopV8.sol";

contract Exercise13_GuessTheAverage is Test {
    GuessTheAverage public game;

    /**
     * address[] public winners; -
     * winner at index 0 can withdraw rewards again and again
     */
    function setUp() public {
        game = new GuessTheAverage(uint32(100), uint32(200));
    }

    function test_distribute() public {
        address userA = vm.addr(1);
        address userB = vm.addr(2);

        vm.deal(userA, 1 ether);
        vm.deal(userB, 1 ether);
        vm.deal(address(this), 1 ether);

        // guess time
        vm.startPrank(userA);
        game.guess{value: 1 ether}(
            keccak256(
                abi.encodePacked(userA, uint256(5), bytes32(uint256(123)))
            )
        );
        vm.stopPrank();

        vm.startPrank(userB);
        game.guess{value: 1 ether}(
            keccak256(
                abi.encodePacked(userB, uint256(25), bytes32(uint256(1234)))
            )
        );
        vm.stopPrank();

        game.guess{value: 1 ether}(
            keccak256(
                abi.encodePacked(
                    address(this),
                    uint256(15),
                    bytes32(uint256(12345))
                )
            )
        );
        vm.warp(120);

        // reveal time
        vm.startPrank(userA);
        game.reveal(5, bytes32(uint256(123)));
        vm.stopPrank();

        vm.startPrank(userB);
        game.reveal(25, bytes32(uint256(1234)));
        vm.stopPrank();

        game.reveal(15, bytes32(uint256(12345)));

        vm.warp(330);
        // finding winner
        game.findWinners(0);
        console.log(game.winners(0));
        console.log(game.cursorDistribute());

        // userA is at first position, and can withdraw rewards again and again
        vm.startPrank(userA);
        // game.distribute(1);
        // game.distribute(2);
    }
}
