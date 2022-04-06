// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.7.6;
pragma abicoder v2;

import "./MPTValidatorStgV3.sol";

contract EVMValidatorStgV3 is MPTValidatorStgV3 {
    constructor (address _stargateBridgeAddress, address _stgTokenAddress, uint16 _localChainId) MPTValidatorStgV3(_stargateBridgeAddress, _stgTokenAddress, _localChainId) {}
}
