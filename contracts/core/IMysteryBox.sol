pragma solidity ^0.5.2;

/**
 * @dev Interface of the MysteryBox.
 */
interface IMysteryBox {
    function changeOwner(address _newOwner) external;
    function getAuthor() external view returns(address);
    function getQuantity() external view returns(uint256);
    function generate(address _to, uint256 _counts, string calldata _title, uint8 _class_id, uint8 _size) external;
    function unBox(uint256[] calldata _boxes) external;
    function withdrawCash(uint256 _index) external;
    function getAttributes(uint256 _index) external view returns(uint256 block_number, uint256 types, uint256 level, uint256 price, string memory name);
    function changeName(uint256 _index, string calldata _name) external;
}