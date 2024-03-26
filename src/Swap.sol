// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IERC20.sol";

contract TokenSwap {
    address public owner;
    IERC20 public linkToken;
    IERC20 public daiToken;

    // Constructor to set the contract owner and token addresses
    constructor(address _linkTokenAddress, address _daiTokenAddress) {
        owner = msg.sender;
        linkToken = IERC20(_linkTokenAddress);
        daiToken = IERC20(_daiTokenAddress);
    }

    // Function to deposit ETH into the contract
    receive() external payable {}

    // Swap functions and logic
    function swapEthToLink() external payable {
        require(msg.value > 0, "You need to send some Ether");
        uint256 linkAmount = getLinkAmount(msg.value);
        require(linkToken.transfer(msg.sender, linkAmount), "Failed to transfer LINK");
    }

    function getLinkAmount(uint256 ethAmount) public view returns (uint256) {
        // Implement your conversion logic here, possibly using a fixed rate or an oracle
        // For simplicity, let's assume 1 ETH = 100 LINK
        return ethAmount * 100;
    }


    // Ensure to add a modifier to restrict certain actions to the contract owner
}
