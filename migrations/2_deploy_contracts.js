/* eslint-env node */
/* global artifacts */

const Marketplace = artifacts.require('core/Marketplace');
const OtcMarketplace = artifacts.require('core/OtcMarketplace');
const BitflixNFT = artifacts.require('ERC721/BitflixNFT');
const USDT = artifacts.require('ERC20/USDT');

function deployContracts(deployer) {
  deployer.deploy(Marketplace);
  deployer.deploy(OtcMarketplace);
  deployer.deploy(BitflixNFT);
  deployer.deploy(USDT);
}

module.exports = deployContracts;
