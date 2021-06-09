/* eslint-env node, mocha */
/* global artifacts, contract, it, assert */

/* A few tests to see if everything is working as expected */

const BitfilxNFT = artifacts.require('BitfilxNFT');

let instance;

contract('BitfilxNFT', (accounts) => {
  it('Should deploy an instance of the BitfilxNFT contract', () => BitfilxNFT.deployed()
    .then((contractInstance) => {
      instance = contractInstance;
    }));

  it('Should get the name of the ERC721 token', () => instance.name()
    .then((name) => {
      assert.equal(name, 'BitfilxNFT', 'Token name is wrong!');
    }));

  it('Should get the symbol of the ERC721 token', () => instance.symbol()
    .then((symbol) => {
      assert.equal(symbol, 'BNFT', 'Token name is wrong!');
    }));

  it('Should get the symbol of the ERC721 token', () => instance.symbol()
    .then((symbol) => {
      assert.equal(symbol, 'BNFT', 'Token name is wrong!');
    }));

  it('Should create a NFT and give it to account 1', () => instance.createNFT(accounts[1], 'mp4', 1, 1));

  it('Should check balance of account 1', () => instance.balanceOf(accounts[1])
    .then((balance) => {
      assert.equal(balance.toNumber(), 1, 'Balance of account 1 is wrong');
    }));

  it('Should check if account 1 owns NFT 0', () => instance.ownerOf(0)
    .then((owner) => {
      assert.equal(owner, accounts[1], 'Owner of NFT 0 is wrong');
    }));
});
