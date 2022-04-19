/// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.13;
interface IFilter {
    function isValid(address _wallet, address _spender, address _to, bytes calldata _data) external view returns (bool);
}