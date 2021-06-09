/* eslint-env node, mocha */
/* global artifacts, contract, it, assert, web3 */

const Marketplace = artifacts.require('Marketplace');
const BitfilxNFT = artifacts.require('BitfilxNFT');

let instance;
let bitfilxNFTInstance;

contract('Marketplace', (accounts) => {
  it('Should deploy an instance of the BitfilxNFT contract', () => BitfilxNFT.deployed()
    .then((contractInstance) => {
      bitfilxNFTInstance = contractInstance;
    }));

  it('Should deploy an instance of the Marketplace contract', () => Marketplace.deployed()
    .then((contractInstance) => {
      instance = contractInstance;
    }));

  it('Should set the address of the BitfilxNFT contract', () => instance.setBitfilxNFTContractAddress(bitfilxNFTInstance.address));

  it('Should open the marketplace', () => instance.openMarketplace());

  it('Should create a NFT and give it to account 1', () => bitfilxNFTInstance.createNFT(accounts[1], 'mp4', 1, 1,));

  it('Should give approval to the marketplace to manage NFT 0', () => bitfilxNFTInstance.approve(instance.address, 0, {
    from: accounts[1],
  }));

  it('Should create an offer for NFT 0 on the marketplace', () => instance.createOffer(0, web3.toWei(1), {
    from: accounts[1],
  }));

  it('Should buy NFT 0 from offer 0', () => instance.buyItem(0, {
    from: accounts[2],
    value: web3.toWei(1),
  }));

  it('Should check if account 2 owns NFT 0', () => bitfilxNFTInstance.ownerOf(0)
    .then((owner) => {
      assert.equal(owner, accounts[2], 'Owner of NFT 0 is wrong');
    }));

  it('Should check the total number of offers', () => instance.getOffersTotal()
    .then((offers) => {
      assert.equal(offers, 1, 'Total number of offers is wrong');
    }));

  it('Should get the informations about offer 0', () => instance.getOffer(0)
    .then((offer) => {
      assert.equal(offer[0], 0, 'Offer 0 itemId is wrong');
      assert.equal(offer[1], web3.toWei(1), 'Offer 0 price is wrong');
      assert.equal(offer[2], accounts[1], 'Offer 0 seller is wrong');
      assert.equal(offer[3], accounts[2], 'Offer 0 buyer is wrong');
      assert.equal(offer[4], false, 'Offer 0 state is wrong');
    }));

  it('Should withdraw funds from the contract', () => instance.withdrawFunds());
});
