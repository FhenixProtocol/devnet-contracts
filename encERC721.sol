// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity >=0.8.13 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/access/AccessControlEnumerable.sol";

import "fhevm/lib/TFHE.sol";

contract SecretNft is
    ERC721
     {

    string private _baseTokenURI;

    mapping(uint => euint32[4]) internal keys;

    constructor(
        string memory name,
        string memory symbol,
        string memory baseTokenURI
    ) ERC721(name, symbol) {
        _baseTokenURI = baseTokenURI;
    }


    function _baseURI()
        internal
        view
        virtual
        override(ERC721)
        returns (string memory)
    {
        return _baseTokenURI;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721)

        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function mintNft(address to, uint tokenId, bytes calldata k1, bytes calldata k2, bytes calldata k3, bytes calldata k4)
    external
    returns (uint256) {

        keys[tokenId] = [TFHE.asEuint32(k1), TFHE.asEuint32(k2), TFHE.asEuint32(k3), TFHE.asEuint32(k4)];

        _mint(to, tokenId);

        return tokenId;
    }

    function getKey(uint tokenId, bytes32 publicKey) public view returns (bytes[4] memory) {
        return [TFHE.reencrypt(keys[tokenId][0], publicKey), TFHE.reencrypt(keys[tokenId][1], publicKey), TFHE.reencrypt(keys[tokenId][2], publicKey), TFHE.reencrypt(keys[tokenId][3], publicKey)];
    }

}
