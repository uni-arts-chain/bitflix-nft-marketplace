/* eslint-env node */
/* global artifacts */

const Marketplace = artifacts.require('core/Marketplace');
const BitfilxNFT = artifacts.require('ERC721/BitfilxNFT');

function deployContracts(deployer) {
  deployer.deploy(Marketplace);
  deployer.deploy(BitfilxNFT);
}

module.exports = deployContracts;
