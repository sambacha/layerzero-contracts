/// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.13;

import "./IFilter.sol";

abstract contract BaseFilter is IFilter {
    function getMethod(bytes memory _data) internal pure returns (bytes4 method) {
        // solhint-disable-next-line no-inline-assembly
        assembly {
            method := mload(add(_data, 0x20))
        }
    }
}
