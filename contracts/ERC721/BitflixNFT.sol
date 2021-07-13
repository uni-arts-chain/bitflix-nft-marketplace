pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
import "openzeppelin-solidity/contracts/access/roles/WhitelistedRole.sol";


/**
 * @title BitflixNFT: a ERC721 token
 */
contract BitflixNFT is ERC721Full, WhitelistedRole {

  struct TokenInfo {
    string title;
    uint8 class_id;
    uint8 size;
  }

  /* Our tokeninfo are stored here */
  TokenInfo[] public token_infos;

  constructor() public ERC721Full("BitflixNFT", "BNFT") {
  }

  /**
   * @dev Creates a new NFT
   */
  function createNFT(
    address user_address,
    string calldata title,
    uint8 class_id,
    uint8 size
    ) external onlyWhitelisted() {
    uint tokenId = token_infos.push(
      TokenInfo({
        title: title,
        class_id: class_id,
        size: size
      })
    ) - 1;
    _mint(user_address, tokenId);
  }

  /**
   * @dev Gets a NFT
   * @return The title and the size of the NFT
   */
  function getNFT(
    uint tokenId
  ) external view returns (
    string memory title,
    uint8 class_id,
    uint8 size
  ) {
    return (
      token_infos[tokenId].title,
      token_infos[tokenId].class_id,
      token_infos[tokenId].size
    );
  }
}
