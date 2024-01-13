// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {LinearBondedCurve} from "../src/SolidityHackingWorkshopV8.sol";

contract Exercise7_LinearBondedCurve is Test {
    LinearBondedCurve public curve;

    /**
     * Logic issue -
     * initially i transfered 1 eth i.e. 1e18 by calling buy function
     * my balance would become 1e18 and totalSupply become 1e18 according to this logic-
     *  uint tokenToReceive = (1e18 * msg.value) / (1e18 + totalSupply);
     *
     * now
     *
     * while sell(1e18)->
     * uint ethToReceive = ((1e18 + totalSupply) * _amount) / 1e18;
     * if totalSupply is 1e18 and _amount is 1e18, then ethToReceive is 2e18
     * meanwhile my balance is and my purcahse was of 1e18.
     */
    function setUp() public {
        curve = new LinearBondedCurve();
    }

    function test_sell() public {
        vm.deal(address(this), 1 ether);
        curve.buy{value: 1 ether}();
        vm.expectRevert();
        // _amount = 1 ether;
        curve.sell(1000000000000000000);
    }
}
