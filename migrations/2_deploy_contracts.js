/* eslint-env node */
/* global artifacts */

const Marketplace = artifacts.require('core/Marketplace');
const BitflixNFT = artifacts.require('ERC721/BitflixNFT');

function deployContracts(deployer) {
  deployer.deploy(Marketplace);
  deployer.deploy(BitflixNFT);
}

module.exports = deployContracts;
