//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IJonesOracle {
    function getLatestPrice() external view returns (uint256);
}
