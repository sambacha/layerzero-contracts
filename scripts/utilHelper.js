 const Ethers = require('ethers');

 const blankFunctionSig = '0x00000000';
 const blankFunctionDepositerOffset = 0;
 const AbiCoder = new Ethers.utils.AbiCoder;

 const toHex = (covertThis, padding) => {
    return Ethers.utils.hexZeroPad(Ethers.utils.hexlify(covertThis), padding);
 };

 const abiEncode = (valueTypes, values) => {
    return AbiCoder.encode(valueTypes, values)
 };

 const getFunctionSignature = (contractInstance, functionName) => {
    return contractInstance.abi.filter(abiProperty => abiProperty.name === functionName)[0].signature;
 };

 const createCallData = (contractInstance, functionName, valueTypes, values) => {
    let signature = getFunctionSignature(contractInstance, functionName);
    let encodedABI = abiEncode(valueTypes, values);
    return signature + encodedABI.substr(2);
 };


const createResourceID = (contractAddress, domainID) => {
    return toHex(contractAddress + toHex(domainID, 1).substr(2), 32)
};

const assertObjectsMatch = (expectedObj, actualObj) => {
    for (const expectedProperty of Object.keys(expectedObj)) {
        assert.property(actualObj, expectedProperty, `actualObj does not have property: ${expectedProperty}`);

        let expectedValue = expectedObj[expectedProperty];
        let actualValue = actualObj[expectedProperty];

        // If expectedValue is not null, we can expected actualValue to not be null as well
        if (expectedValue !== null) {
            // Handling mixed case ETH addresses
            // If expectedValue is a string, we can expected actualValue to be a string as well
            if (expectedValue.toLowerCase !== undefined) {
                expectedValue = expectedValue.toLowerCase();
                actualValue = actualValue.toLowerCase();
            }

            // Handling BigNumber.js instances
            if (actualValue.toNumber !== undefined) {
                actualValue = actualValue.toNumber();
            }

            // Truffle seems to return uint/ints as strings
            // Also handles when Truffle returns hex number when expecting uint/int
            if (typeof expectedValue === 'number' && typeof actualValue === 'string' ||
                Ethers.utils.isHexString(actualValue) && typeof expectedValue === 'number') {
                actualValue = parseInt(actualValue);
            }
        }
        
        assert.deepEqual(expectedValue, actualValue, `expectedValue: ${expectedValue} does not match actualValue: ${actualValue}`);    
    }
};
//uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(domainID);
const nonceAndId = (nonce, id) => {
    return Ethers.utils.hexZeroPad(Ethers.utils.hexlify(nonce), 8) + Ethers.utils.hexZeroPad(Ethers.utils.hexlify(id), 1).substr(2)
}

module.exports = {
    advanceBlock,
    blankFunctionSig,
    blankFunctionDepositerOffset,
    toHex,
    abiEncode,
    getFunctionSignature,
    createCallData,
    createResourceID,
    assertObjectsMatch,
    nonceAndId
};