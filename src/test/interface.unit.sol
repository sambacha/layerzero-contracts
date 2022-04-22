/// SPDX-License-Identifier: MPL-2.0
pragma solidity >=0.8.0 <0.9.0;

/// @dev interface for unit testing contract functionality.

interface FacadeInterface {
  function methodA() external;
	function methodB() external;

    function acceptAdressUintReturnBool(address recipient, uint amount) external returns (bool);
    function acceptUintReturnString(uint) external returns (string memory);
    function acceptUintReturnBool(uint) external returns (bool);
    function acceptUintReturnUint(uint) external returns (uint);
    function acceptUintReturnAddress(uint) external returns (address);
    function acceptUintReturnUintView(uint) external view returns (uint);
    
}
