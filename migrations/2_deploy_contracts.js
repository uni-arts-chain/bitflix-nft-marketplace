/* eslint-env node */
/* global artifacts */

const Marketplace = artifacts.require('core/Marketplace');
const OtcMarketplace = artifacts.require('core/OtcMarketplace');
const BitflixNFT = artifacts.require('ERC721/BitflixNFT');

function deployContracts(deployer) {
  deployer.deploy(Marketplace);
  deployer.deploy(OtcMarketplace);
  deployer.deploy(BitflixNFT);
}

module.exports = deployContracts;
