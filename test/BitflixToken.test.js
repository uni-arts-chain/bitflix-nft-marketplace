/* eslint-env node, mocha */
/* global artifacts, contract, it, assert */

/* A few tests to see if everything is working as expected */

const BitflixToken = artifacts.require('BitflixToken');

contract('BitflixToken', async accounts => {
  it('basic', async() => {
  	let instance = await BitflixToken.new(accounts[0]);
  	let symbol = await instance.symbol()
  	let name = await instance.name()
  	let totalSupply = await instance.totalSupply()
  	assert.equal(symbol, 'BTFLX');
  	assert.equal(name, 'BitflixToken');
  	assert.equal(totalSupply.toString(), '21000000000000000000000000');
  });
});
