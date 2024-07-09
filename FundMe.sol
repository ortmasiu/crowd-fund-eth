// Get funds from user
// Withdraw funds 
// Set minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUsd = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public owner; 

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        // msg.value.getConversionRate()
        require(msg.value.getConversionRate() >= minimumUsd, "You didn't send enough ETH!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }
    
    function withdraw() public onlyOwner {
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset funders array
        funders = new address[](0);

        // withdraw funds 

        // transfer funds to whoever calls function
        // payable(msg.sender).transfer(address(this).balance);

        // // send returns a boolean value
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "send failed!");

        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "call failed!");
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Sender is not the owner!");
        _;
    }

}
