// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {Governable} from "src/common/Governable.sol";
import {IViewer} from "src/interfaces/IViewer.sol";

contract Oracle is Governable {
    IViewer private viewer;
    uint128 private constant MIN = 30 minutes;
    uint64 private lastUpdatedAt;
    uint64 private DEN = 4;

    // 2 ** 64 -> 18446744073709551616
    struct Price {
        uint64 p0; 
        uint64 p1; 
        uint64 p2; 
        uint64 p3; 
    }

    Price private price;

    constructor(uint64[] memory initial) Governable(msg.sender) {
        price.p0 = initial[0];
        price.p1 = initial[1];
        price.p2 = initial[2];
        price.p3 = initial[3];
    }

    function supplyPrice() external {
        uint64 now = uint64(block.timestamp);

        if (now < lastUpdatedAt + MIN) {
            revert Delay();
        }
        
        _shiftStruct(_jGlpToUSDC());

        lastUpdatedAt = now;
    }

    function _jGlpToUSDC() public view returns (uint64) {
        uint256 glp = viewer.getGlpRatioWithoutFees(1e18); // 18 ecimalss
        uint256 priceGlp = viewer.getGlpPriceUsd(); // 6 decimals

        return uint64((glp * priceGlp) / 1e18);
    }

    function _shiftStruct(uint64 _p) private {
        price.p0 = price.p1;
        price.p1 = price.p2;
        price.p2 = price.p3;
        price.p3 = _p;
    }

    function getLastPrice() public view returns (uint64) {
        return (price.p0 + price.p1 + price.p2 + price.p3) / DEN;
    }

    function updateViewer(address _viewer) external onlyGovernor {
        if (_viewer == address(0)) {
            revert AddressZero();
        }
        
        viewer = IViewer(_viewer);
    }

    error Delay();
    error AddressZero();
}
