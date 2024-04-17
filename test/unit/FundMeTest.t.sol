// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {Script} from "forge-std/Script.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address testUSER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(testUSER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        console.log(fundMe.getOwner());
        console.log(msg.sender);
        console.log(address(this));
        // assertEq(fundMe.i_owner(), address(this));
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();  // next line expected to fail
        fundMe.fund();      // sending 0 ETH; will fail
    }

    function testFundUpdatesFundersDataStructureCorrectly() public {
        vm.startPrank(testUSER);     // set the user for the next call or line to testUSER
        fundMe.fund{value: SEND_VALUE}();
        console.log(testUSER);
        console.log(testUSER.balance);
        console.log(msg.sender);
        console.log(msg.sender.balance);
        assertEq(fundMe.getFunder(0), testUSER);
        assertEq(fundMe.getAmountFunded_byFunderAddress(testUSER), SEND_VALUE);
        //assertEq(fundMe.getFunder(0), msg.sender);
        //assertEq(fundMe.getAmountFunded_byFunderAddress(msg.sender), SEND_VALUE);
        vm.stopPrank();
    }
}