pragma solidity >=0.8.0;

contract devNull {
    mapping(address => uint256) public registry;

    // @notice Send calldata to /dev/null 
    fallback(bytes calldata input) external returns (bytes memory) {
        (address sender, uint256 amount) = abi.decode(input, (address, uint256));
        registry[sender] = amount;
    }
}