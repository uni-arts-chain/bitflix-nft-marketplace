pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";

contract BitflixToken is ERC20, ERC20Detailed("BitflixToken", "BTFLX", 18) {
	constructor(address to) public {
		_mint(to, 21000000 * 1e18);
	}
}
