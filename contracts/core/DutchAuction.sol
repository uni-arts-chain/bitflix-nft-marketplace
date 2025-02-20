pragma solidity ^0.5.2;
pragma experimental ABIEncoderV2;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC721/IERC721.sol";
import "openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol";
import "openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol";

contract DutchAuction is ReentrancyGuard, IERC721Receiver {

    // using safeErc20 for ierc20 based contract
    using SafeERC20 for IERC20;

    // constants
    address constant ADDRESS_NULL = address(0);
    
    // max item allow per auction, should not be more than 2^32-1
    uint    constant MAX_ITEM_PER_AUCTION = 32;

    bytes4  constant ERC721_ONRECEIVED_RESULT = bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));

    // base erc20 token
    address public USDT_ADDRESS;

    address public STORAGE_ADDESS;

    // structs
    struct NFT {
        address contractAddress;
        uint    tokenId;
        uint    startingPrice;
        uint    decrementPerEpoch;
        uint    reservePrice;
    }
    
    struct AuctionResult {
        address bidder;
        uint bidAmount;
    }

    struct Match {
        address creatorAddress;
        uint openBlock;
        uint expiryBlock;
        uint blockPerEpoch;
        uint nftCount;
    }

    // state
    // matchId => Match
    mapping(string => Match) public  matches;

    // matchId => index => NFT
    mapping(string => mapping(uint => NFT)) public  matchNFTs;
    
    // matchId => Result
    mapping(string => mapping(uint => AuctionResult)) public  matchResults;

    // address to balance
    mapping(address => uint) private creatorBalance;

    // events
    event CreateAuctionEvent(
        address creatorAddress, 
        string matchId, 
        uint openBlock, 
        uint expiryBlock, 
        uint blockPerEpoch,
        NFT[] nft
    );
    event PlayerBidEvent(string matchId, address playerAddress, uint tokenIndex, uint bid);
    event RewardEvent   (string matchId, uint tokenIndex, address winnerAddress);

    // modifier 
    modifier validTokenIndex(string memory matchId, uint tokenIndex) {
        require(matches[matchId].creatorAddress != ADDRESS_NULL, "invalid match"); 
        require(tokenIndex < matches[matchId].nftCount, "invalid token");
        _;
    }

    modifier creatorOnly(string memory matchId) {
         require(matches[matchId].creatorAddress == msg.sender, "creator only function"); 
        _;
    }
    
    // match finished should be used with checking valid match
    modifier matchFinished(string memory matchId) {
        // require(matches[matchId].creatorAddress != ADDRESS_NULL, "invalid match");
        require(matches[matchId].expiryBlock < block.number, "match is not finished");
        _;
    }

    constructor(address usdcContractAddress) public {
        USDT_ADDRESS = usdcContractAddress;
    }

    function createAuction(
        string calldata matchId, 
        uint openBlock, 
        uint expiryBlock,
        uint blockPerEpoch,
        NFT[] calldata nfts) external nonReentrant {

        // check if matchId is occupied
        require(matches[matchId].creatorAddress == ADDRESS_NULL, "matchId is occupied");
        
        // check valid openBlock, expiryBlock, expiryExtensionOnBidUpdate
        require(expiryBlock > openBlock && openBlock > block.number, "condition expiryBlock > openBlock > current block count not satisfied");

        // check item count
        require(nfts.length > 0 && nfts.length <= MAX_ITEM_PER_AUCTION, "number of nft must be greater than 0 and less than MAX_ITEM_PER_AUCTION");

        // deposit item to contract
        for(uint i = 0; i < nfts.length; ++i) {

            // check valid token
            require(nfts[i].decrementPerEpoch <= nfts[i].startingPrice, "decrement should not exceed starting price");

            // if meet requirements then send tokens to contract
            IERC721(nfts[i].contractAddress).safeTransferFrom(msg.sender, address(this), nfts[i].tokenId);
            
            // create slots for items
            matchResults[matchId][i]    = AuctionResult(ADDRESS_NULL, nfts[i].startingPrice);
            matchNFTs[matchId][i]       = nfts[i];
        }

        // create match
        matches[matchId] = Match(
            msg.sender,
            openBlock,
            expiryBlock,
            blockPerEpoch,
            nfts.length
        );

        // emit events
        emit CreateAuctionEvent(msg.sender, matchId, openBlock, expiryBlock, blockPerEpoch, nfts);
    }

    function get_current_price(string memory matchId, uint tokenIndex) public view returns(uint) {
        uint blockPerEpoch = matches[matchId].blockPerEpoch;
        // check some prerequisite before get price
        require(blockPerEpoch > 0, "block per epoch must be greater than 0");
        require(block.number > matches[matchId].openBlock, "current block should greater than open block");

        // compute current price
        uint epochCount = (block.number - matches[matchId].openBlock) / blockPerEpoch;
        uint startingPrice = matchNFTs[matchId][tokenIndex].startingPrice;
        uint decrementPerEpoch = matchNFTs[matchId][tokenIndex].decrementPerEpoch;
        uint lostValue = epochCount * decrementPerEpoch;

        require(lostValue <= startingPrice, "token price reaches bottom");
        return startingPrice - lostValue;
    }

    function player_bid(string calldata matchId, uint tokenIndex) external nonReentrant validTokenIndex(matchId, tokenIndex) {
        Match memory amatch = matches[matchId];
        address playerAddress = msg.sender;
        // check if match is opened 
        require(amatch.openBlock < block.number && block.number <= amatch.expiryBlock, "match is not opened for bidding");
        // check if token has not get any bids
        require(matchResults[matchId][tokenIndex].bidder == ADDRESS_NULL, "some one agreed with higher price for this token");
        uint amount = get_current_price(matchId, tokenIndex);
        // update the winner for that token
        matchResults[matchId][tokenIndex] = AuctionResult(playerAddress, amount);
        // emit event
        emit PlayerBidEvent(
            matchId, 
            playerAddress,
            tokenIndex,
            amount
        );
        IERC20(USDT_ADDRESS).safeTransferFrom(playerAddress, address(this), amount);
    }

    // anyone can call reward, top bidder and creator are incentivized to call this function to send rewards/profit
    function reward(string calldata matchId, uint tokenIndex) external validTokenIndex(matchId, tokenIndex) matchFinished(matchId) {
        
        address winnerAddress  = matchResults[matchId][tokenIndex].bidder;
        require(winnerAddress != ADDRESS_NULL, "winner is not valid");

        // set result to null
        matchResults[matchId][tokenIndex] = AuctionResult(ADDRESS_NULL, 0);

        // increase creator's balance
        uint standingBid = matchResults[matchId][tokenIndex].bidAmount;
        creatorBalance[matches[matchId].creatorAddress] += standingBid;
        
        NFT memory nft = matchNFTs[matchId][tokenIndex];
        // send nft to “address”
        IERC721(nft.contractAddress).safeTransferFrom(address(this), winnerAddress, nft.tokenId);
        emit RewardEvent(matchId, tokenIndex, winnerAddress);
    }

    function process_withdraw_nft(string memory matchId, uint tokenIndex) private {
        // set standingBid to 0 to prevent withdraw again
        matchResults[matchId][tokenIndex].bidAmount = 0;
        // transfer asset
        NFT memory nft = matchNFTs[matchId][tokenIndex];
        IERC721(nft.contractAddress).safeTransferFrom(address(this), msg.sender, nft.tokenId);
    }

    // creator withdraws unused nft
    function creator_withdraw_nft_batch(string calldata matchId) external creatorOnly(matchId) matchFinished(matchId) { 
        // check valid matchId, match finished
        uint _len = matches[matchId].nftCount;
        for(uint i = 0; i < _len; ++i) {
            
            // consider result
            AuctionResult memory result = matchResults[matchId][i];
            
            // if no one wins the token then withdraw (result is at initial state)
            if (result.bidder == ADDRESS_NULL && result.bidAmount > 0) {
                process_withdraw_nft(matchId, i);
            }
        }
    }
    
    function creator_withdraw_nft(string calldata matchId, uint tokenIndex) external validTokenIndex(matchId, tokenIndex) creatorOnly(matchId) matchFinished(matchId) {
        AuctionResult memory result = matchResults[matchId][tokenIndex];
        require (result.bidder == ADDRESS_NULL && result.bidAmount > 0, "token is not available to withdraw");
        
        process_withdraw_nft(matchId, tokenIndex);
    }

    function creator_withdraw_profit() external {
        uint balance = creatorBalance[msg.sender];
        require(balance > 0, "creator balance must be greater than 0");
        
        // reset balance 
        creatorBalance[msg.sender] = 0;
        
        // send money
        IERC20(USDT_ADDRESS).safeTransfer(msg.sender, balance);
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4) {
        // return ERC721_ONRECEIVED_RESULT to conform the interface
        return ERC721_ONRECEIVED_RESULT;
    }

    function get_match(string calldata matchId) external view returns(address, uint, uint, uint, uint) {
        Match memory amatch = matches[matchId];
        return (
            amatch.creatorAddress,
            amatch.openBlock,
            amatch.expiryBlock,
            amatch.blockPerEpoch,
            amatch.nftCount
        );
    }

    function get_current_result(string calldata matchId, uint tokenIndex) external view returns (address, uint) {
        return (matchResults[matchId][tokenIndex].bidder, matchResults[matchId][tokenIndex].bidAmount);
    }

    function get_creator_balance(address creatorAddress) external view returns(uint) {
        return creatorBalance[creatorAddress];
    }
}