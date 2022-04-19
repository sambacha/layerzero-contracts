/// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.8.13;

// @title RelayTx

// @notice Relay tx data structure
contract RelayTxStruct {
    // @dev The Relay Transaction
    struct RelayTx {
        address to; // Address for external contract
        address payable from; // Address for the originator who hired the relayer
        bytes data; // Call data to send. Includes function call name, etc.
        uint256 deadline; // Expiry block_number
        uint256 compensation; // Operator compensation by originator
        uint256 gasLimit; // Gas amount allocated to this function call (origin native currency)
        uint256 chainId; // ChainID
        address relay; // Relay contract
    }

    // @return Relay tx hash (bytes32)
    // @dev Pack the encoding when computing the ID.
    function computeRelayTxId(RelayTx memory self) public pure returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    self.to,
                    self.from,
                    self.data,
                    self.deadline,
                    self.compensation,
                    self.gasLimit,
                    self.chainId,
                    self.relay
                )
            );
    }
}
