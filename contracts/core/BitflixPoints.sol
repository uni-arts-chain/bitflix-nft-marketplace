pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";


contract BitflixPoints {
	using SafeMath for uint256;
	mapping (address => uint256) public points;

	struct UserLock {
		uint256 id;
		address user;
		uint256 amount;
		uint256 duration;
		uint256 startTime;
		bool redeemed;
	}

	UserLock[] public locks;

	mapping (address => uint256[]) public userLockIds;

	
	bool public initialized = false;
	uint256 public lockRate;
	uint256 public lockDuration;
	uint256 public lockRateMax = 10000;
	address public marketplace;

	IERC20 public btflx;

	event Lock(address user, uint256 amount, uint256 at, uint256 id);
	event Redeem(address user, uint256 amount, uint256 at, uint256 id);
	event Consume(address user, uint256 amount, uint256 at);

	modifier onlyMarketplace() { 
		require (msg.sender == marketplace, "Forbidden"); 
		_; 
	}
	

	constructor(address btflx_) public {
		btflx = IERC20(btflx_);
	}

	function initialize(uint256 lockRate_, uint256 lockDuration_, address marketplace_) public {
		require(!initialized, "Initialized");
		lockRate = lockRate_;
		lockDuration = lockDuration_;
		marketplace = marketplace_;
		initialized = true;
	}

	function lock(uint256 amount) public {
		require(amount > 0, "Lock amount cannot be 0");
		btflx.transferFrom(msg.sender, address(this), amount);
		locks.push(UserLock({
			id: locks.length,
			user: msg.sender,
			amount: amount,
			duration: lockDuration,
			startTime: now,
			redeemed: false
		}));
		userLockIds[msg.sender].push(locks.length - 1);

		uint256 point = amount.mul(lockRate).div(lockRateMax).div(1e18);
		points[msg.sender] = points[msg.sender].add(point);

		emit Lock(msg.sender, amount, now, locks.length - 1);
	}

	function lockLength() public view returns(uint256) {
		return locks.length;
	}

	function redeem(uint256 id) public {
		UserLock storage ulock = locks[id];
		require(!ulock.redeemed, "Redeemed");
		require(ulock.duration.add(ulock.startTime) <= now, "Locking");
		btflx.transfer(ulock.user, ulock.amount);
		ulock.redeemed = true;
		emit Redeem(ulock.user, ulock.amount, now, ulock.id);
	}

	function consume(address user, uint256 val) public onlyMarketplace {
		require(val > 0, "Cannot be 0");
		points[user] = points[user].sub(val);
		emit Consume(user, val, now);
	}

	function getUserLockIds(address user) public view returns(uint256[] memory) {
		return userLockIds[user];
	}
}