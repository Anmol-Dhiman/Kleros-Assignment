// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {SnapShotToken} from "../src/SolidityHackingWorkshopV8.sol";

contract Exercise12_SnapShotToken is Test {
    SnapShotToken public snapShotToken;

    function setUp() public {
        snapShotToken = new SnapShotToken();
    }

    // past balance can be manipulated if attacker sends token to himself
    // also attacker can increase his balance by sending token to himself

    function test_UpdateCheckpoint() public {
        vm.deal(address(this), 1 ether);

        snapShotToken.buyToken{value: 1 ether}();

        require(
            snapShotToken.balances(address(this)) == 1,
            "invalid balance before transfer"
        );
        snapShotToken.transfer(address(this), 1);
        require(
            snapShotToken.balances(address(this)) == 2,
            "invalid balance after transfer"
        );
    }
}
