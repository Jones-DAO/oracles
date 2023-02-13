// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {Governable} from "src/common/Governable.sol";
import {jAssetsOracle} from "src/jAssetsOracle.sol";
import {IGlpManager} from "src/interfaces/IGlpManager.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract jGlpOracle is Governable, jAssetsOracle {
    IGlpManager manager = IGlpManager(0x3963FfC9dff443c2A94f21b129D429891E32ec18);
    IERC20 glp = IERC20(0x5402B5F40310bDED796c7D0F3FF6683f5C0cFfdf);
    uint256 private constant BASIS = 1e6;
    uint256 private constant DECIMALS = 1e18;

    constructor() Governable(msg.sender) {}

    function _supplyPrice() internal view override returns (uint64) {
        uint256 avgAum = (manager.getAum(false) + manager.getAum(true)) / 2; // 30 decimals
        uint256 glpPrice = (avgAum * BASIS) / glp.totalSupply(); // 18 decimals

        uint256 jGlpRatio = viewer.getGlpRatioWithoutFees(1e18);
        uint256 jGlpPriceUsd = (jGlpRatio * glpPrice) / DECIMALS;

        return uint64(jGlpPriceUsd); // 18 decimals
    }
}
