// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        // address ethToUSDPriceFeedAddress = helperConfig.currentNetworkConfig();
            // #1
            // strictly, helpConfig.currentNetworkConfig() returns a struct, 
            // but since the struct has only 1 member which is an address, 
            // the pointer type in this case is both a struct and an address,
            // hence the name (ie: pointer) can be used as either type without explicit conversion

            // #2
            // currentNetworkConfig is a struct, but Solidity automatically defines a
            // getter function currentNetworkConfig() that provides access to its
            // contents

        vm.startBroadcast();    // after this line, everything is sent as transaction onto chain
        //FundMe fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        FundMe fundMe = new FundMe(helperConfig.currentNetworkConfig());
        vm.stopBroadcast();     // after this line, onchain transaction sending stops
        return fundMe;
    }
}