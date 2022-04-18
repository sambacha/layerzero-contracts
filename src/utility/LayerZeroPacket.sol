// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;

import "../vendor/SafeMath.sol";

library LayerZeroPacket {
    struct Packet {
        uint16 srcChainId;
        uint16 dstChainId;
        uint64 nonce;
        address dstAddress;
        bytes srcAddress;
        bytes32 ulnAddress;
        bytes payload;
    }
}
