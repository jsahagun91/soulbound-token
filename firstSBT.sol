// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract supremeSBT is ERC721URIStorage {

    address owner;

    using Counters for Counters.Counter;
    Counters.Counter private _tokendIds;

    constructor() ERC721("First Soulbound Token", "Token") {
        owner = msg.sender;
    }

    mapping(address => bool) public issuedSoulboundTokens;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function issueSoulboundToken(address to) onlyOwner external {
        issuedSoulboundTokens[to] = true;
    }

    function claimSoulboundToken(string memory tokenURI) public returns(uint256) {
        require(issuedSoulboundTokens[msg.sender], "SBT is not issued");

        _tokendIds.increment();
        uint256 newItemId = _tokendIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        personToSoulboundToken[msg.sender] = tokenURI;
        issuedSoulboundTokens[msg.sender] = false;

        return newItemId;
    }

    mapping(address => string) public personToSoulboundToken;
}

