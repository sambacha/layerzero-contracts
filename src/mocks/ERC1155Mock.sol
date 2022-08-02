// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

// for mock purposes only, no limit on minting functionality
contract ERC1155Mock is ERC1155 {
    constructor(string memory uri_) ERC1155(uri_) {}

    function mint(
        address _to,
        uint256 _tokenId,
        uint256 _amount
    ) public {
        _mint(_to, _tokenId, _amount, "");
    }

    function mintBatch(
        address _to,
        uint256[] memory _tokenIds,
        uint256[] memory _amounts
    ) public {
        _mintBatch(_to, _tokenIds, _amounts, "");
    }

    function transfer(
        address _to,
        uint256 _tokenId,
        uint256 _amount
    ) public {
        _safeTransferFrom(msg.sender, _to, _tokenId, _amount, "");
    }
}
