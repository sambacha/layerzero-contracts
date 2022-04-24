# LayerZero Contracts

> LayerZero Relayer Service Framework

## Overview

> LayerZero Contracts

These contracts are sourced from Etherscan and reproduced here in buildable form. The current LayerZero repo does not have some of these contracts published for whatever reason.


## Background

[LayerZero](https://layerzero.network/)

> Trustless Omnichain Interoperability Protocol

> a.k.a generic calldata messaging framework
> 

Bridges like ThorChain, AnySwap, etc, are DEXes and require an intermediary token (RUNE, ANY, etc) to be minted and burned, and swapped for desired token at destination, requiring another transaction

With LayerZero, chain A can notify application on Chain B to grant user a token, using a single transaction without intermediary tokens. The exchange is handled by contracts on both sides, with 

LayerZero delivering messages between the two

- Valid Delivery: -every message m sent over the network is coupled with a transaction t on the sender chain.

A message m is delivered to the receiver if and only if the associated transaction t is valid and has been committed on the sender chain
Centralized exchanges gurantee valid delivery
DEXes are not ideal because it requires converting sender token to intermediary token in one transaction, and then converting intermediary token to real token on destination in another transaction. 

Trust is also required in the intermediate consensus layer that confirmation transactions and mints token at the destination.

#### LayerZero Endpoints
user-facing interface to LayerZero. These are contracts implemented on each chain.


Uses Chainlink for Oracle to read block header from one chain and send it to another chain.
Relayer is an off-chain service like Oracle, but instead it fetches the proof for a specified transaction.

The oracle and Relayer must be independent of each other, so then don't collude.

layerzero message contains:
- `t`: the unique transaction identifier for T
- `dst`: a global identifier pointing to a smart contract on chain B
- `payload`: any data that app A wishes to send to app B
- `relayer_args`: arguments describing payments in formation in the event app A wishes to use the reference Relayer.

Validation will succeed if and only if the block header and transaction proof match
the EVM library handles merkle-patricia tree validation for transactions on an evm block, using open-source implementation by Golden Gate


### LayerZero Summary

Trustless interchain transactions
combines two independent entities:
an Oracle that provides the block header
a Relayer that provides proof associated with the aforementioned transaction
"valid delivery"
every message sent over the network is coupled with a transaction on the sender chain
a message is delivered to the received only if the associated transaction is valid and has been committed on the sender chain
"endpoints"
allow user to send a message

**LayerZero Endpoint** is split into four modules:
- Communicator, 
- Validator, 
- Network,
-  Libraries

A valid delivery can only happen if there's no collusion between `Oracle` and `Relayer`

## Specification

- Nonce
- RegistryQuery

### Nonces 

Create a list of bitmaps

- All endpoint-destined transactions MUST reserve a single bit in a map. 
- 
- When a transaction is processed, it will `flip` a bit for the on-chain bitmap. 
 
 Because the **bit is flipped, it can never be processed again.**


 The contract stores a list of bitmaps;

```solidity 
mapping(uint256 => uint256) bitmaps; 

bitmaps[_nonce1] = 0000000......0000000000;
```

To reserve a bit for the lz.transaction:

```
nonce1 - Index for destined on-chain bitmap
nonce2 - A bitmap with the flipped bit
```

```solidity
uint256 bitmap = bitmaps[_nonce1];
uint256 toFlip = _nonce2;
require(bitmap & toFlip != toFlip);
```

### Registry Query

> NOTE: Ref. source from Yearn Strategy Filter

**Filter a registry value using a reverse polish notation (RPM) query language**

Each instruction is a tuple of either two or three strings.

> Registry Values can be: Vault Stratagies, Endpoint Registry entires, etc etc. *so long as it matches the format*.

#### Argument 0 - Operand type

* KEY      - Denotes a value should be fetched using a function sighash derived from argument 1
* VALUE    - A value to be added directly to the stack
* OPERATOR - The name of the instruction to execute

#### Argument 1 - Key/Value or operator

* Data     - If KEY or VALUE are specified in argument 0, argument 1 represents either the key
            to fetch data with or the value to be added to the stack
* Operator - If OPERATOR is specified in argument 0, argument 1 represents the operator to execute.
            Valid operators are: EQ, GT, GTE, LT, LTE, OR, AND, NE and LIKE

#### Argument 2 - Value type

For key/value operands argument 2 describes how to parse a value to be placed on the stack.
Valid options are: STRING, HEX, DECIMAL

> Note: The stack size is 32 bytes. Any values beyond this will be truncated.

####  Example Filter

Description: Find all strategies whose `apiVersion` is like 0.3.5 or 0.3.3 (no v+ prefix!)
            where relay endpoint address is cFa7Eae32032bF431aEd95532142A9c2B35715D4
```js
filter = [
    ["KEY",        "apiVersion", "STRING"],
    ["VALUE",      "0.3.5", "STRING"],
    ["OPERATOR",   "LIKE"],
    ["KEY",        "apiVersion", "STRING"],
    ["VALUE",      "0.3.3", "STRING"],
    ["OPERATOR",   "LIKE"],
    ["OPERATOR",   "OR"],
    ["KEY",        "relay", "HEX"],
    ["VALUE",      "cFa7Eae32032bF431aEd95532142A9c2B35715D4", "HEX"],
    ["OPERATOR",   "EQ"],
    ["OPERATOR",   "AND"]
];
```

```solidity
    function strategyPassesFilter(
        address strategyAddress,
        string[][] memory instructions
    ) public view returns (bool) {
        bytes32[] memory stack = new bytes32[](instructions.length * 3);
        uint256 stackLength;
        for (
            uint256 instructionsIdx;
            instructionsIdx < instructions.length;
            instructionsIdx++
        ) {
            string[] memory instruction = instructions[instructionsIdx];
            string memory instructionPart1 = instruction[1];
            bool operandIsOperator = String.equal(instruction[0], "OPERATOR");
            if (operandIsOperator) {
                bool result;
                bytes32 operandTwo = stack[stackLength - 1];
                bytes32 operandOne = stack[stackLength - 2];
                if (String.equal(instruction[1], "EQ")) {
                    result = uint256(operandTwo) == uint256(operandOne);
                }
                if (String.equal(instruction[1], "NE")) {
                    result = uint256(operandTwo) != uint256(operandOne);
                }
                if (String.equal(instruction[1], "GT")) {
                    result = uint256(operandTwo) > uint256(operandOne);
                }
                if (String.equal(instruction[1], "GTE")) {
                    result = uint256(operandTwo) >= uint256(operandOne);
                }
                if (String.equal(instruction[1], "LT")) {
                    result = uint256(operandTwo) < uint256(operandOne);
                }
                if (String.equal(instruction[1], "LTE")) {
                    result = uint256(operandTwo) <= uint256(operandOne);
                }
                if (String.equal(instruction[1], "AND")) {
                    result = uint256(operandTwo & operandOne) == 1;
                }
                if (String.equal(instruction[1], "OR")) {
                    result = uint256(operandTwo | operandOne) == 1;
                }
                if (String.equal(instruction[1], "LIKE")) {
                    string memory haystack = String.bytes32ToString(operandOne);
                    string memory needle = String.bytes32ToString(operandTwo);
                    result = String.contains(haystack, needle);
                }
                if (result) {
                    stack[stackLength - 2] = bytes32(uint256(1));
                } else {
                    stack[stackLength - 2] = bytes32(uint256(0));
                }
                stackLength--;
            } else {
                bytes32 stackItem;
                bool operandIsKey = String.equal(instruction[0], "KEY");
                bytes memory data;
                if (operandIsKey) {
                    (, bytes memory matchBytes) = address(strategyAddress)
                        .staticcall(
                            abi.encodeWithSignature(
                                string(abi.encodePacked(instruction[1], "()"))
                            )
                        );
                    data = matchBytes;
                }
                if (String.equal(instruction[2], "HEX")) {
                    if (operandIsKey == true) {
                        assembly {
                            stackItem := mload(add(data, 0x20))
                        }
                    } else {
                        stackItem = bytes32(
                            String.atoi(String.uppercase(instruction[1]), 16)
                        );
                    }
                } else if (String.equal(instruction[2], "STRING")) {
                    if (operandIsKey == true) {
                        assembly {
                            stackItem := mload(add(data, 0x60))
                        }
                    } else {
                        assembly {
                            stackItem := mload(add(instructionPart1, 0x20))
                        }
                    }
                } else if (String.equal(instruction[2], "DECIMAL")) {
                    if (operandIsKey == true) {
                        assembly {
                            stackItem := mload(add(data, 0x20))
                        }
                    } else {
                        stackItem = bytes32(String.atoi(instruction[1], 10));
                    }
                }
                stack[stackLength] = stackItem;
                stackLength++;
            }
        }
        if (uint256(stack[0]) == 1) {
            return true;
        }
        return false;
    }

    /**
     * Allow storage slots to be manually updated
     */
    function updateSlot(bytes32 slot, bytes32 value) external {
        require(msg.sender == ownerAddress, "Caller is not the owner");
        assembly {
            sstore(slot, value)
        }
    }
}
```

## License

SEE LICENSE IN SPDX HEADERS
