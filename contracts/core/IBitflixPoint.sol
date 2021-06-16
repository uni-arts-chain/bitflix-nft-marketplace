pragma solidity ^0.5.2;

interface IBitflixPoint {
	function redeem(uint256 id) external;
	function lock(uint256 amount) external;
	function consume(address user, uint256 val) external;
	function pointOf(address user) external view returns(uint256);
}
