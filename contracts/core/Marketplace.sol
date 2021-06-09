pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./BitfilxNFTInterface.sol";


/**
 * @title A small marketplace allowing users to buy and sell a specific ERC721 token
 * @dev For this example, we are using a fictional token called BitfilxNFT
 * @author Pickle Solutions https://github.com/picklesolutions
 */
contract Marketplace is Ownable {
  /* Our events */
  event NewOffer(uint offerId);
  event ItemBought(uint offerId);

  /* The address of our ERC721 token contract */
  address public bitfilxNFTContractAddress = address(0);

  /* If we need to freeze the marketplace for any reason */
  bool public isMarketPlaceOpen = false;

  /* Our fee (the value is divided by 100, so 250 is 2.50%) */
  uint public marketplaceFee = 250;

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
    BitfilxNFTInterface bitfilxNFT = BitfilxNFTInterface(bitfilxNFTContractAddress);

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
   * @dev Buys an item
   * @param offerId The id of the offer
   */
  function buyItem(
    uint offerId
  ) external payable whenMarketIsOpen() {
    /* Let's talk to our token contract */
    BitfilxNFTInterface bitfilxNFT = BitfilxNFTInterface(bitfilxNFTContractAddress);

    /* Are we still able to manage this item? */
    require(
      bitfilxNFT.getApproved(offers[offerId].itemId) == address(this),
      "We do not have approval to manage this item"
    );

    /* Did the buyer send enough funds? */
    require(msg.value == offers[offerId].price, "The sent amount is too low");

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

    /* We give the seller his money */
    offers[offerId].seller.transfer(profit);
  }

  /**
   * @dev Sets the address of our ERC721 token contract
   * @param newBitfilxNFTContractAddress The address of the contract
   */
  function setBitfilxNFTContractAddress(
    address newBitfilxNFTContractAddress
  ) external onlyOwner() {
    /* The address cannot be null */
    require(newBitfilxNFTContractAddress != address(0), "Contract address cannot be null");

    /* We set the address */
    bitfilxNFTContractAddress = newBitfilxNFTContractAddress;
  }

  /**
   * @dev Opens the market if the contract address is correct
   */
  function openMarketplace() external onlyOwner() {
    require(bitfilxNFTContractAddress != address(0), "Contract address is not set");

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
