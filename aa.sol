// File: openzeppelin-solidity/contracts/GSN/Context.sol

pragma solidity ^0.5.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/core/BitflixNFTInterface.sol

pragma solidity ^0.5.2;


/**
 * @title Interface for our ERC721 token
 */
interface BitflixNFTInterface {
  /* Our custom functions go here */

  /**
   * @dev Creates a new NFT
   */
  function createNFT(
    address user_address,
    string calldata title,
    uint8 class_id,
    uint8 size
    ) external;

  /**
   * @dev Gets a NFT info
   */
  function getNFT(
    uint tokenId
  ) external view returns (
    string memory title,
    uint8 class_id,
    uint8 size
  );

  /* Standard functions */

  /// @dev This emits when ownership of any NFT changes by any mechanism.
  ///  This event emits when NFTs are created (`from` == 0) and destroyed
  ///  (`to` == 0). Exception: during contract creation, any number of NFTs
  ///  may be created and assigned without emitting Transfer. At the time of
  ///  any transfer, the approved address for that NFT (if any) is reset to none.
  event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

  /// @dev This emits when the approved address for an NFT is changed or
  ///  reaffirmed. The zero address indicates there is no approved address.
  ///  When a Transfer event emits, this also indicates that the approved
  ///  address for that NFT (if any) is reset to none.
  event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

  /// @dev This emits when an operator is enabled or disabled for an owner.
  ///  The operator can manage all NFTs of the owner.
  event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

  /// @notice Count all NFTs assigned to an owner
  /// @dev NFTs assigned to the zero address are considered invalid, and this
  ///  function throws for queries about the zero address.
  /// @param _owner An address for whom to query the balance
  /// @return The number of NFTs owned by `_owner`, possibly zero
  function balanceOf(address _owner) external view returns (uint256);

  /// @notice Find the owner of an NFT
  /// @dev NFTs assigned to zero address are considered invalid, and queries
  ///  about them do throw.
  /// @param _tokenId The identifier for an NFT
  /// @return The address of the owner of the NFT
  function ownerOf(uint256 _tokenId) external view returns (address);

  /// @notice Transfers the ownership of an NFT from one address to another address
  /// @dev Throws unless `msg.sender` is the current owner, an authorized
  ///  operator, or the approved address for this NFT. Throws if `_from` is
  ///  not the current owner. Throws if `_to` is the zero address. Throws if
  ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
  ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
  ///  `onERC721Received` on `_to` and throws if the return value is not
  ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
  /// @param _from The current owner of the NFT
  /// @param _to The new owner
  /// @param _tokenId The NFT to transfer
  /// @param data Additional data with no specified format, sent in call to `_to`
  function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;

  /// @notice Transfers the ownership of an NFT from one address to another address
  /// @dev This works identically to the other function with an extra data parameter,
  ///  except this function just sets data to "".
  /// @param _from The current owner of the NFT
  /// @param _to The new owner
  /// @param _tokenId The NFT to transfer
  function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;

  /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
  ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
  ///  THEY MAY BE PERMANENTLY LOST
  /// @dev Throws unless `msg.sender` is the current owner, an authorized
  ///  operator, or the approved address for this NFT. Throws if `_from` is
  ///  not the current owner. Throws if `_to` is the zero address. Throws if
  ///  `_tokenId` is not a valid NFT.
  /// @param _from The current owner of the NFT
  /// @param _to The new owner
  /// @param _tokenId The NFT to transfer
  function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

  /// @notice Change or reaffirm the approved address for an NFT
  /// @dev The zero address indicates there is no approved address.
  ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
  ///  operator of the current owner.
  /// @param _approved The new approved NFT controller
  /// @param _tokenId The NFT to approve
  function approve(address _approved, uint256 _tokenId) external payable;

  /// @notice Enable or disable approval for a third party ("operator") to manage
  ///  all of `msg.sender`'s assets
  /// @dev Emits the ApprovalForAll event. The contract MUST allow
  ///  multiple operators per owner.
  /// @param _operator Address to add to the set of authorized operators
  /// @param _approved True if the operator is approved, false to revoke approval
  function setApprovalForAll(address _operator, bool _approved) external;

  /// @notice Get the approved address for a single NFT
  /// @dev Throws if `_tokenId` is not a valid NFT.
  /// @param _tokenId The NFT to find the approved address for
  /// @return The approved address for this NFT, or the zero address if there is none
  function getApproved(uint256 _tokenId) external view returns (address);

  /// @notice Query if an address is an authorized operator for another address
  /// @param _owner The address that owns the NFTs
  /// @param _operator The address that acts on behalf of the owner
  /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
  function isApprovedForAll(address _owner, address _operator) external view returns (bool);

  /// @notice Query if a contract implements an interface
  /// @param interfaceID The interface identifier, as specified in ERC-165
  /// @dev Interface identification is specified in ERC-165. This function
  ///  uses less than 30,000 gas.
  /// @return `true` if the contract implements `interfaceID` and
  ///  `interfaceID` is not 0xffffffff, `false` otherwise
  function supportsInterface(bytes4 interfaceID) external view returns (bool);

  /// @notice Count NFTs tracked by this contract
  /// @return A count of valid NFTs tracked by this contract, where each one of
  ///  them has an assigned and queryable owner not equal to the zero address
  function totalSupply() external view returns (uint256);

  /// @notice Enumerate valid NFTs
  /// @dev Throws if `_index` >= `totalSupply()`.
  /// @param _index A counter less than `totalSupply()`
  /// @return The token identifier for the `_index`th NFT,
  ///  (sort order not specified)
  function tokenByIndex(uint256 _index) external view returns (uint256);

  /// @notice Enumerate NFTs assigned to an owner
  /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
  ///  `_owner` is the zero address, representing invalid NFTs.
  /// @param _owner An address where we are interested in NFTs owned by them
  /// @param _index A counter less than `balanceOf(_owner)`
  /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
  ///   (sort order not specified)
  function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
}

// File: contracts/core/OtcMarketplace.sol

pragma solidity ^0.5.2;







/**
 * @title A small marketplace allowing users to buy and sell a specific ERC721 token
 * @dev For this example, we are using a fictional token called BitflixNFT
 * @author Pickle Solutions https://github.com/picklesolutions
 */
contract OtcMarketplace is Ownable {
  /* Our events */
  event NewOffer(uint offerId);
  event CloseOffer(uint offerId);
  event ItemBought(uint offerId);

  /* The address of our ERC721 token contract */
  address public bitfilxNFTContractAddress = address(0);

  /* The address of Pay erc20 token contract */
  string public payCoinSymbol;
  address public payCoinContractAddress = address(0);

  /* If we need to freeze the marketplace for any reason */
  bool public isMarketPlaceOpen = false;

  /* Our fee (the value is divided by 100, so 100 is 10%) */
  uint public marketplaceFee = 1000;

  /* The minimum sale price (in Wei) */
  uint public minPrice = 10000;

  /* The structure of our offers */
  struct Offer {
    uint itemId;
    uint price;
    address payable seller;
    address payable buyer;
    bool isOpen;
  }

  /* All the offers are stored here */
  Offer[] public offers;

  /* We keep track of every offers for every users */
  mapping (address => uint[]) public usersToOffersId;

  /**
   * @dev Puts an item on the marketplace
   * @param itemId The id of the item
   * @param price The price expected by the seller
   */
  function createOffer(
    uint itemId,
    uint price
  ) external whenMarketIsOpen() {
    /* Let's talk to our token contract */
    BitflixNFTInterface bitfilxNFT = BitflixNFTInterface(bitfilxNFTContractAddress);

    /* We need to be sure that the sender is the actual owner of the token */
    require(
      bitfilxNFT.ownerOf(itemId) == msg.sender,
      "Sender does not own this item"
    );

    /* Are we approved to manage this item? */
    require(
      bitfilxNFT.getApproved(itemId) == address(this),
      "We do not have approval to manage this item"
    );

    /* Is the selling price abovee the minimum price? */
    require(price >= minPrice, "Price is too low");

    /* We push the offer into our array */
    uint offerId = offers.push(
      Offer({
        itemId: itemId,
        price: price,
        seller: msg.sender,
        buyer: address(0),
        isOpen: true
      })
    ) - 1;

    /* We keep track of offers from users */
    usersToOffersId[msg.sender].push(offerId);

    /* We tell the world there is a new offer */
    emit NewOffer(offerId);
  }

  /**
   * @dev close an Offer
   * @param offerId The id of the offer
   */
  function closeOffer(
    uint offerId
  ) external onlyOwner() {
    /* Is the offer still open? */
    require(offers[offerId].isOpen, "Offer is closed");

    /* We close the offer and register the buyer */
    offers[offerId].isOpen = false;

    /* We tell the world there is a cancel offer */
    emit CloseOffer(offerId);
  }

  /**
   * @dev Buys an item
   * @param offerId The id of the offer
   */
  function buyItem(
    uint offerId
  ) external whenMarketIsOpen() {
    /* Let's talk to our token contract */
    BitflixNFTInterface bitfilxNFT = BitflixNFTInterface(bitfilxNFTContractAddress);

    IERC20 payCoin = IERC20(payCoinContractAddress);

    /* Are we still able to manage this item? */
    require(
      bitfilxNFT.getApproved(offers[offerId].itemId) == address(this),
      "We do not have approval to manage this item"
    );

    /* Did the buyer send enough funds? */
    uint256 allowance = payCoin.allowance(msg.sender, address(this));
    require(allowance >= offers[offerId].price, "Check the token allowance");

    uint256 coin_balance = payCoin.balanceOf(msg.sender);
    require(coin_balance >= offers[offerId].price, "Check the token balanceOf");

    /* Is the offer still open? */
    require(offers[offerId].isOpen, "Offer is closed");

    /* We close the offer and register the buyer */
    offers[offerId].isOpen = false;
    offers[offerId].buyer = msg.sender;

    /* We transfer the item from the seller to the buyer */
    bitfilxNFT.safeTransferFrom(
      offers[offerId].seller,
      offers[offerId].buyer,
      offers[offerId].itemId
    );

    /* This is our fee */
    uint txFee = SafeMath.mul(
      offers[offerId].price,
      marketplaceFee
    ) / 100 / 100;

    /* This is the profit made by the seller */
    uint profit = SafeMath.sub(
      offers[offerId].price,
      txFee
    );

    /* buyer pay coin */
    payCoin.transferFrom(offers[offerId].buyer, address(this), txFee);
    
    /* We give the seller his money */
    payCoin.transferFrom(offers[offerId].buyer, offers[offerId].seller, profit);
  }

  /**
   * @dev Sets the address of our ERC721 token contract
   * @param newBitflixNFTContractAddress The address of the contract
   */
  function setBitflixNFTContractAddress(
    address newBitflixNFTContractAddress
  ) external onlyOwner() {
    /* The address cannot be null */
    require(newBitflixNFTContractAddress != address(0), "Contract address cannot be null");

    /* We set the address */
    bitfilxNFTContractAddress = newBitflixNFTContractAddress;
  }

  /**
   * @dev Sets the address of Pay erc20 token contract
   * @param newPayCoinContractAddress The address of the contract
   */
  function setPayCoinContractAddress(
    string calldata newpayCoinSymbol,
    address newPayCoinContractAddress
  ) external onlyOwner() {
    /* The address cannot be null */
    require(newPayCoinContractAddress != address(0), "Contract address cannot be null");

    /* We set the address */
    payCoinContractAddress = newPayCoinContractAddress;
    payCoinSymbol = newpayCoinSymbol;
  }

  /**
   * @dev Opens the market if the contract address is correct
   */
  function openMarketplace() external onlyOwner() {
    require(bitfilxNFTContractAddress != address(0), "Contract address is not set");
    require(payCoinContractAddress != address(0), "Pay Coin Contract address is not set");

    isMarketPlaceOpen = true;
  }

  /**
   * @dev Closes the market
   */
  function closeMarketplace() external onlyOwner() {
    isMarketPlaceOpen = false;
  }

  /**
   * @dev Lets the owner withdraw his funds
   */
  function withdrawFunds() external onlyOwner() {
    address(uint160(owner())).transfer(address(this).balance);
  }

  /**
   * @dev Lets the owner withdraw his coins
   */
  function withdrawCoins() external onlyOwner() {
    IERC20 payCoin = IERC20(payCoinContractAddress);
    uint256 coin_balance = payCoin.balanceOf(address(this));
    payCoin.transfer(address(uint160(owner())), coin_balance);
  }

  /**
   * @dev Returns the offers
   */
  function getOffersTotal() external view returns (uint) {
    return offers.length;
  }

  /**
   * @dev Gets an offer
   * @param offerId The id of the offer
   * @return All the infos about the offer
   */
  function getOffer(uint offerId) external view returns (
    uint itemId,
    uint price,
    address seller,
    address buyer,
    bool isOpen
  ) {
    return (
      offers[offerId].itemId,
      offers[offerId].price,
      offers[offerId].seller,
      offers[offerId].buyer,
      offers[offerId].isOpen
    );
  }

  /**
   * @dev Some functions can only be called when the market is open
   */
  modifier whenMarketIsOpen() {
    require(isMarketPlaceOpen == true, "Marketplace is closed");
    _;
  }
}
