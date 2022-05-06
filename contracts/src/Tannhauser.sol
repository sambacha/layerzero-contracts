/// SPDX-License-Information: SSPL-1.0

pragma solidity ^0.8.4;

// ENS
interface ENS {
    function resolver(bytes32 nodehash) external view returns (address);
}

// RESOLVER
interface Resolver {
    function addr(bytes32 nodehash) external view returns (address);
}

// LAYERZERO
interface Lz {
    function execute() external;
    function die(address owner) external;
}

// CONTRACT
// Tannhauser Launch Gateway for LayerZero
contract Tannhauser {
    event Deployed(address addr);

    struct LzTransaction {
        bytes code;

        address addr;
        bytes32 nodehash;

        bool namedLz;
    }

    struct Signature {
        bytes32 r;
        bytes32 vs;
    }

    ENS _ens;

    bool _mutex;
    bytes _bootstrap;

    bytes _pendingRuntimeCode;

    constructor(address ens, bytes memory bootstrap) public {
        _ens = ENS(ens);
        _bootstrap = bootstrap;
    }

    function getBootstrap() public view returns (bytes memory bootstrap) {
        return bootstrap;
    }

    function _getAddress(bytes32 salt) internal view returns (address addr) {
        uint8 preamble = 0xff;
        bytes32 initCodeHash = keccak256(abi.encodePacked(_bootstrap));
        bytes32 hash = keccak256(abi.encodePacked(preamble, address(this), salt, initCodeHash));
        return address(uint160(uint256(hash)));
    }

    function getLzAddress(address addr) public view returns (address lzAddress) {
        return _getAddress(keccak256(abi.encodePacked(addr)));
    }

    function getLzNamedAddress(bytes32 nodehash) public view returns (address lzAddress) {
        return _getAddress(nodehash);
    }

    function _execute(bytes memory runtimeCode, bytes32 salt) internal {
        require(!_mutex);
        _mutex = true;

        _pendingRuntimeCode = runtimeCode;

        bytes memory bootstrap = _bootstrap;

        uint256 value = msg.value;

        address lz;
        assembly {
            lz := create2(value, add(bootstrap, 0x20), mload(bootstrap), salt)
        }

        Lz(lz).execute();

        Lz(lz).die(msg.sender);

        _mutex = false;

        emit Deployed(lz);
    }

    function execute(bytes memory runtimeCode) public payable {
        _execute(runtimeCode, keccak256(abi.encodePacked(msg.sender)));
    }

    function executeNamed(bytes32 nodehash, bytes memory runtimeCode) public payable {
        Resolver resolver = Resolver(_ens.resolver(nodehash));
        address owner = resolver.addr(nodehash);

        require(owner == msg.sender);

        _execute(runtimeCode, nodehash);
    }

    //function executeMany(Transaction transaction[], Signature signature[]) public payable {
    //}

    function getPendingRuntimeCode() public view returns (bytes memory runtimeCode) {
        return _pendingRuntimeCode;
    }

}
