// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {OwnableUpgradeable} from "@upgradeable/contracts/access/OwnableUpgradeable.sol";
import {jAssetsOracle} from "src/jAssetsOracle.sol";

contract OracleAggregator is OwnableUpgradeable {
    mapping(address => jAssetsOracle) public oracles;

    function initialize() external initializer {
        __Ownable_init();
    }

    function getUsdPrice(address _asset) external view returns (uint256) {
        jAssetsOracle oracle = oracles[_asset];

        return uint256(oracle.getLatestPrice());
    }

    function addOracle(address _oracle) external onlyOwner {
        if (_oracle == address(0)) {
            revert Invalid();
        }

        jAssetsOracle oracle = jAssetsOracle(_oracle);
        oracles[oracle.asset()] = oracle;

        emit NewOracle(_oracle, oracle.asset());
    }

    function getOracle(address _asset) external view returns (jAssetsOracle) {
        return oracles[_asset];
    }

    error Invalid();

    event NewOracle(address indexed _oracle, address indexed _asset);
}
