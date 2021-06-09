pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";


/**
 * @title BitfilxNFT: a ERC721 token
 */
contract BitfilxNFT is ERC721Full, Ownable {

  struct TokenInfo {
    string title;
    uint8 class;
    uint8 size;
  }

  /* Our tokeninfo are stored here */
  TokenInfo[] public token_infos;

  constructor() public ERC721Full("BitfilxNFT", "BNFT") {
  }

  /**
   * @dev Creates a new NFT
   */
  function createNFT(
    address user_address,
    string calldata title,
    uint8 class,
    uint8 size
    ) external onlyOwner() {
    uint tokenId = token_infos.push(
      TokenInfo({
        title: title,
        class: class,
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
    uint8 class,
    uint8 size
  ) {
    return (
      token_infos[tokenId].title,
      token_infos[tokenId].class,
      token_infos[tokenId].size
    );
  }
}
