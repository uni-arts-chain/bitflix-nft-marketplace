pragma solidity ^0.5.2;

interface IBitflixPoints {
	function redeem(uint256 id) external;
	function lock(uint256 amount) external;
	function consume(uint256 val) external;
}
