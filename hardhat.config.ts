
import '@typechain/hardhat';
import 'dotenv/config';
import 'hardhat-abi-exporter';

import { HardhatUserConfig } from 'hardhat/types';

const test_mnemonic = 'test test test test test test test test test test test junk';

/** @type import('hardhat/config').HardhatUserConfig */
const config: HardhatUserConfig = {
/**
* @note
* Before version 0.8.6 omitting the 'enabled' key was not equivalent to setting
* it to false and would actually disable all the optimizations.
* @see: {@link https://docs.soliditylang.org/en/latest/using-the-compiler.html#compiler-input-and-output-json-description}
*
*/
solidity: {
    version: '0.8.13',
    settings: {
      metadata: {
        bytecodeHash: 'none',
      },
      optimizer: {
        enabled: true,
        runs: 1_000,
        details: {
          yul: false,
        },
      },
      outputSelection: {
        '*': {
          '*': [
            'abi',
            'evm.bytecode',
            'evm.deployedBytecode',
            'evm.methodIdentifiers',
            'metadata',
          ],
          '': ['ast'],
        },
      },
    },
  },
  networks: {
    hardhat: {
      allowUnlimitedContractSize: false,
    },
    mainnet: {
      url: `https://mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`,
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${process.env.INFURA_API_KEY}`,
    },
    goerli: {
      url: `https://goerli.infura.io/v3/${process.env.GOERLI_RPC}`,
    },
  },
  paths: {
    sources: './src',
    tests: './test',
    cache: './cache',
    artifacts: './artifacts',
  },
  typechain: {
    outDir: 'types/',
    target: 'ethers-v5',
  },
};

/** @note Compiler output configuration for verifying on Sourceify */
export const defaultSolcOutputSelection = {
  '*': {
    '*': [
      'abi',
      'evm.bytecode',
      'evm.deployedBytecode',
      'evm.methodIdentifiers',
      'metadata',
    ],
    '': ['ast'],
  },
};

export default config;