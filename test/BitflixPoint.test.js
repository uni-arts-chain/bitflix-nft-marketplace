const { toBN } = require('web3-utils');
const BitflixPoint = artifacts.require('BitflixPoint');
const BitflixToken = artifacts.require('BitflixToken');

const BASE = toBN(10 ** 18)
const MAX = toBN('ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff')

contract('BitflixPoint', async accounts => {
	beforeEach(async () => {
    this.token = await BitflixToken.new(accounts[0])
  	this.instance = await BitflixPoint.new(this.token.address);
  	await this.instance.initialize(1000, 30 * 24 * 3600, accounts[1])
  });


  it('initialize', async() => {
  	let isInitialized = await this.instance.initialized.call()
  	assert.equal(isInitialized, true);
  });

  it("lock", async() => {
  	let amount = toBN(1000).mul(BASE)
  	this.token.approve(this.instance.address, MAX, { from: accounts[0] })
  	await this.instance.lock(amount, {  from: accounts[0] })

  	let lockLen = await this.instance.lockLength.call()
  	assert.equal(lockLen, 1)

  	let lock = await this.instance.locks(0)
  	assert.equal(lock.id, 0)
  	assert.equal(lock.user, accounts[0])

  	let point = await this.instance.points(accounts[0])

  	assert.equal(point.toString(), toBN(1000).mul(toBN(1000)).div(toBN(10000)).toString())
  })

  it("redeem", async() => {
  	let amount = toBN(1000).mul(BASE)
  	this.token.approve(this.instance.address, MAX, { from: accounts[0] })
  	await this.instance.lock(amount, {  from: accounts[0] })
  	let lockLen = await this.instance.lockLength.call()
  	assert.equal(lockLen, 1)
  	try {
  		await this.instance.redeem(0)
  	} catch(err) {
  		assert.match(err, /Locking/)
  	}
  })

  it("consume", async() => {
  	let amount = toBN(1000).mul(BASE)
  	this.token.approve(this.instance.address, MAX, { from: accounts[0] })
  	await this.instance.lock(amount, {  from: accounts[0] })

  	await this.instance.consume(accounts[0], 50, {  from: accounts[1] })
  	let point = await this.instance.points(accounts[0])

  	assert.equal(point.toString(), toBN(50).toString())
  })

  it("pointOf", async() => {
  	let amount = toBN(1000).mul(BASE)
  	this.token.approve(this.instance.address, MAX, { from: accounts[0] })
  	await this.instance.lock(amount, {  from: accounts[0] })

  	let pointVal = await this.instance.pointOf(accounts[0])
  	assert.equal(pointVal.toString(), '100')
  })

});
