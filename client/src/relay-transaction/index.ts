// @NOTICE
// THIS IS STILL A WORK IN PROGRESS
// DO NOT USE WITH ANY FUNDS

// @version 2022.04.16
// @filename relay-transaction.ts

/**
 * Returns a Promise that resolves when the RelayTxID is detected in the Relay.sol contract.
 * @param relayTxId Relay Transaction ID
 * @param wallet Signer
 * @param provider SecureRPC Provider
 */
export async function watchRelayTx(
  relayTx: RelayTransaction,
  wallet: Wallet,
  provider: Provider
) {
  const blockNo = await provider.getBlockNumber();
  const topics = LayerZeroClient.getRelayExecutedEventTopics(relayTx);

  const filter = {
    address: LAYERZERO_RELAY_CONTRACT,
    fromBlock: blockNo - 10,
    toBlock: blockNo + 10000,
    topics: topics,
  };

  return new Promise(async (resolve) => {
    let found = false;
    const relay = new RelayFactory(wallet).attach(LAYERZERO_RELAY_CONTRACT);
    const relayTxId = LayerZeroClient.relayTxId(relayTx);

    console.log("Checking for relayed transaction...");
    while (!found) {
      await wait(5000); // Try again every 5 seconds.
      console.log("...");
      await provider.getLogs(filter).then((result) => {
        const length = lookupLog(relayTxId, blockNo, result, relay);

        if (length > 0) {
          found = true;
          resolve(length);
        }
      });
    }
  });
}

/**
 * Go through log to find relay transaction id
 * @param relayTxId Relay Transaction ID
 * @param blockNo Starting block number
 * @param result Logs
 * @param relay Relay contract
 */
function lookupLog(
  relayTxId: string,
  blockNo: number,
  result: Log[],
  relay: ethers.Contract
) {
  for (let i = 0; i < result.length; i++) {
    const recordedRelayTxId = relay.interface.events.RelayExecuted.decode(
      result[i].data,
      result[i].topics
    ).relayTxId;

    if (NETWORK_NAME !== "mainnet") {
    }

    // Did we find it?
    if (relayTxId == recordedRelayTxId) {
      etherscanLink(result[i]["transactionHash"] as string);

      const confirmedBlockNumber = result[i]["blockNumber"] as number;
      const length = confirmedBlockNumber - blockNo;
      return length;
    }
  }

  return 0;
}
/**
 * Simple function to wait
 * @param ms Milliseconds
 */
async function wait(ms: number) {
  return new Promise(function(resolve, reject) {
    setTimeout(() => {
      resolve();
    }, ms);
  });
}
Terms
