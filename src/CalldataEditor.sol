// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./utility/BytesLib.sol";

abstract contract CalldataEditor {
    using BytesLib for bytes;

    /// @notice Returns uint from chunk of the bytecode
    /// @param data the compiled bytecode for the series of function calls
    /// @param location the current 'cursor' location within the bytecode
    /// @return result uint
    function uint256At(bytes memory data, uint256 location) internal pure returns (uint256 result) {
        assembly {
            result := mload(add(data, add(0x20, location)))
        }
    }

    /// @notice Returns address from chunk of the bytecode
    /// @param data the compiled bytecode for the series of function calls
    /// @param location the current 'cursor' location within the bytecode
    /// @return result address
    function addressAt(bytes memory data, uint256 location) internal pure returns (address result) {
        uint256 word = uint256At(data, location);
        assembly {
            result := div(
                and(word, 0xffffffffffffffffffffffffffffffffffffffff000000000000000000000000),
                0x1000000000000000000000000
            )
        }
    }

    /// @notice Returns the start of the calldata within a chunk of the bytecode
    /// @param data the compiled bytecode for the series of function calls
    /// @param location the current 'cursor' location within the bytecode
    /// @return result pointer to start of calldata
    function locationOf(bytes memory data, uint256 location)
        internal
        pure
        returns (uint256 result)
    {
        assembly {
            result := add(data, add(0x20, location))
        }
    }

    /// @notice Replace the bytes at the index location in original with new bytes
    /// @param original original bytes
    /// @param newBytes new bytes to replace in original
    /// @param location the index within the original bytes where to make the replacement
    function replaceDataAt(
        bytes memory original,
        bytes memory newBytes,
        uint256 location
    ) internal pure {
        assembly {
            mstore(add(add(original, location), 0x20), mload(add(newBytes, 0x20)))
        }
    }

    /// @dev Get the revert message from a call
    /// @notice This is needed in order to get the human-readable revert message from a call
    /// @param res Response of the call
    /// @return Revert message string
    function getRevertMsg(bytes memory res) internal pure returns (string memory) {
        // If the res length is less than 68, then the transaction failed silently (without a revert message)
        if (res.length < 68) return "Call failed for unknown reason";
        bytes memory revertData = res.slice(4, res.length - 4); // Remove the selector which is the first 4 bytes
        return abi.decode(revertData, (string)); // All that remains is the revert string
    }
}
