/// SPDX-License-Identifier: MPL-2.0
pragma solidity >=0.8.0 <0.9.0;

/// @dev interface for unit testing contract functionality.

interface FacadeInterface {
    function methodA() external;

    function methodB() external;

    function acceptAdressUintReturnBool(address recipient, uint256 amount) external returns (bool);

    function acceptUintReturnString(uint256) external returns (string memory);

    function acceptUintReturnBool(uint256) external returns (bool);

    function acceptUintReturnUint(uint256) external returns (uint256);

    function acceptUintReturnAddress(uint256) external returns (address);

    function acceptUintReturnUintView(uint256) external view returns (uint256);
}
