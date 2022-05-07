pragma solidity ^0.6.12 || ^0.7.0;
pragma experimental ABIEncoderV2;

/// @title Call Tester
contract CallTester  {

    // Call Destination
    struct CallDesc {
        address to;
        bytes data;
        uint256 value;
    }
    
    // make call to dest.
    function makeCalls(CallDesc[] memory calls) external payable returns (bytes memory ret) {
        for (uint i = 0; i < calls.length; i++) {
            CallDesc memory c = calls[i];
            (bool ok, bytes memory data) = c.to.call{value: c.value}(c.data);
            require(ok, "ERR");
            ret = data;
        }
    }

}
