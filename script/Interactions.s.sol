// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 private constant SEND_VALUE = 0.1 ether;

    function run() external {
        FundMe fundMe = FundMe(payable(DevOpsTools.get_most_recent_deployment("FundMe", block.chainid)));

        vm.startBroadcast();
        fundMe.fund{value: SEND_VALUE}();
        vm.stopBroadcast();

        console.log(">>>FundIntegrationTest");
        console.log(">>>FundMe contract funded with %s", SEND_VALUE);
    }
}

contract WithdrawFundMe is Script {}