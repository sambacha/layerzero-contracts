pragma solidity ^0.8.13;

/// @title DomainSeperator
contract DomainSeparator {
    // @title LayerZero Relay Broadcast Service
    string public constant name  = "LayerZero Relay Broadcast Service";
    // @dev The version of the LayerZero Relay Broadcast Service
    // version: {major}.{minor}.{patch}.{chainId}
    string public constant version = "0.1.0+1";
    
    
 // @NOTICE
 // ChainId Impl. needs validation on LZ requirements, this is just placeholder
    uint256 public constant chainId = 1;

  // TODO: cleanup ChainId
	function chainId() external view returns (uint256) {
		return block.chainid;
	}
  // TODO: cleanup ChainId
 function getChainId() pure external returns (uint256) {
        uint256 id;
        assembly {
        id := chainid()
        }
        return id;
    }

/// @notice getDomainSeparator returns the domain separator for the current chain
 function getDomainSeparator() public view returns(bytes32) {
        return keccak256(abi.encode(
        // TODO: cleanup ChainId
        keccak256(bytes("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")),
        keccak256(bytes(name)),
        keccak256(bytes(version)),
        // TODO: cleanup ChainId
        chainId,
        address(this)));
    }

    /// @notice getDigest returns the digest of the given message
    function getDigest(bytes memory encoded) public view returns(bytes32) {

        return keccak256(abi.encodePacked(
                "\x19\x01",
                getDomainSeparator(),
                keccak256(encoded)
        ));
    }
}
