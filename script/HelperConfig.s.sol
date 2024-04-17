// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig{
        address priceFeedAddress;   // ETH/USD price feed address
    }

    NetworkConfig public currentNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            currentNetworkConfig = getSepoliaConfig();
        } else if (block.chainid == 1) {
            currentNetworkConfig = getMainnetConfig();
        } else {
            currentNetworkConfig = getAnvilConfig();
        }
    }

    function getMainnetConfig() public pure returns (NetworkConfig memory){
        NetworkConfig memory ethConfig = NetworkConfig({priceFeedAddress: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return ethConfig;
    }
    function getSepoliaConfig() public pure returns (NetworkConfig memory){
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeedAddress: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }
    function getAnvilConfig() public returns (NetworkConfig memory){
        // if the current address is not 0 (ie: something alrdy assigned),
        // this means a mock price feed was alrdy previously setup,
        // then don't need to spin up another mock price feed,
        // just return that existing one
        if (currentNetworkConfig.priceFeedAddress != address(0)) {
            return currentNetworkConfig;
        }

        // spin up a mock price feed and broadcast onto anvil
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();
        
        NetworkConfig memory anvilConfig = NetworkConfig({priceFeedAddress: address(mockPriceFeed)});
        return anvilConfig;
    }
}