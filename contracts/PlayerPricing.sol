// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract PlayerPricing {

    // Function to calculate price based on input
    function calculatePrice(uint256 input) public pure returns (uint256) {
        // Example formula: Price = input * 100 wei
        return input * 100;
    }
}