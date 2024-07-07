// Get funds from user
// Withdraw funds 
// Set minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    
    uint256 public minimumUsd = 5;

    function fund() public payable {
        // Allow users to send USD
        // Have a minimum USD ($) amount sent
        // How to send ETH to this contract?
        require(msg.value >= 1e18, "You didn't send enough ETH!");
    }
    
    // function withdraw() public {

    // }

    function getPrice() public view returns (uint256) {
        // address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // abi
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer) * 1e10;
    }

    function getConversionRate() public {}

    function getVersion() public view returns (uint256) {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}
