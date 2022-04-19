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


## License

SEE LICENSE IN SPDX HEADERS
