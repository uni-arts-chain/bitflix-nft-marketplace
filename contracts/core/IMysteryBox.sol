pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

/**
 * @dev Interface of the MysteryBox.
 */
interface IMysteryBox is ERC721 {
    function changeOwner(address _newOwner) external;
    function getAuthor() external view returns(address);
    function getQuantity() external view returns(uint256);
    function generate(address _to, uint256 _counts) external;
    function unBox(uint256[] memory _boxes) external;
    function withdrawCash(uint256 _index) external;
    function getAttributes(uint256 _index) external returns(uint256 block_number, uint256 types, uint256 level, uint256 price, string memory name);
    function changeName(uint256 _index, string memory _name) external;
}