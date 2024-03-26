// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import  "../interfaces/IERC20.sol";
import {AggregatorV3Interface} from "..\lib\chainlink-brownie-contracts\contracts\src\v0.8\interfaces\AggregatorV3Interface.sol";

contract TokenSwap {
    address public owner;
    IERC20 public linkToken;
    IERC20 public daiToken;
    AggregatorV3Interface internal ethUsdPriceFeed;
    AggregatorV3Interface internal linkUsdPriceFeed;
    AggregatorV3Interface internal daiUsdPriceFeed;

    constructor(address _linkTokenAddress, address _daiTokenAddress, address _ethUsdPriceFeed, address _linkUsdPriceFeed, address _daiUsdPriceFeed) {
        owner = msg.sender;
        linkToken = IERC20(_linkTokenAddress);
        daiToken = IERC20(_daiTokenAddress);
        ethUsdPriceFeed = AggregatorV3Interface(_ethUsdPriceFeed);
        linkUsdPriceFeed = AggregatorV3Interface(_linkUsdPriceFeed);
        daiUsdPriceFeed = AggregatorV3Interface(_daiUsdPriceFeed);
    }

    receive() external payable {}

    function getLatestPrice(AggregatorV3Interface priceFeed) public view returns (int) {
        (, int price,,,) = priceFeed.latestRoundData();
        return price;
    }

    function swapEthToLink(uint linkAmount) external payable {
        require(msg.value > 0, "ETH required to swap");
        uint ethAmountInUsd = uint(getLatestPrice(ethUsdPriceFeed)) * msg.value;
        uint linkAmountInUsd = linkAmount * uint(getLatestPrice(linkUsdPriceFeed));
        require(ethAmountInUsd >= linkAmountInUsd, "Insufficient ETH sent");
        require(linkToken.transfer(msg.sender, linkAmount), "LINK transfer failed");
    }

    function swapEthToDai(uint daiAmount) external payable {
        require(msg.value > 0, "ETH required to swap");
        uint ethAmountInUsd = uint(getLatestPrice(ethUsdPriceFeed)) * msg.value;
        uint daiAmountInUsd = daiAmount * uint(getLatestPrice(daiUsdPriceFeed));
        require(ethAmountInUsd >= daiAmountInUsd, "Insufficient ETH sent");
        require(daiToken.transfer(msg.sender, daiAmount), "DAI transfer failed");
    }

    // Additional swap functions (LINK to DAI, LINK to ETH, DAI to ETH, DAI to LINK) would follow a similar pattern

    // Allow the owner to withdraw tokens from the contract
    function withdrawToken(IERC20 token, uint256 amount) external {
        require(msg.sender == owner, "Only the owner can withdraw");
        require(token.transfer(msg.sender, amount), "Transfer failed");
    }

    // Allow the owner to withdraw ETH
    function withdrawETH(uint256 amount) external {
        require(msg.sender == owner, "Only the owner can withdraw");
        payable(msg.sender).transfer(amount);
    }
}
