// Get funds from user
// Withdraw funds 
// Set minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;

    // constant 
    // non - constant will be more expensive on the more expensive chains 

    // 

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner; 
    // 2574 gas - non-immutable 
    // 439 gas - immutable (very efficient!)

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        // msg.value.getConversionRate()
        require(msg.value.getConversionRate() >= MINIMUM_USD, "You didn't send enough ETH!");
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
        // require(msg.sender == i_owner, NotOwner());
        if (msg.sender != i_owner) { revert NotOwner();}
        _;
    }

    // What happens when someone sends this contract eth without calling the fund me function?

    // recieve special function
    receive() external payable { 
        fund();
    }

    // fallback special function
    fallback() external payable { 
        fund();
    }

}
