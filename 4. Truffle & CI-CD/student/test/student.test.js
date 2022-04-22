// erc20.test.js 
const { BN, ether } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const Voting = artifacts.require('Student');
contract('Student', function (accounts) {
  const _decimals = new BN(18);
  const owner = accounts[0];
  const voter_1 = accounts[1];
  const voter_2 = accounts[2];
  const voter_3 = accounts[2];

 beforeEach(async function () {
  this.StudentInstance = await Voting.new(_initialsupply,{from: owner});
 });
 
it('a un nom', async function () {
  expect(await this.StudentInstance.name()).to.equal(_name);
});
it('a un symbole', async function () {
  expect(await this.StudentInstance.symbol()).to.equal(_symbol);
});
it('a une valeur décimal', async function () {
  expect(await this.StudentInstance.decimals()).to.be.bignumber.equal(_decimals);
});
it('vérifie la balance du propriétaire du contrat', async function (){
  let balanceOwner = await this.StudentInstance.balanceOf(owner);
  let totalSupply = await this.StudentInstance.totalSupply();
  expect(balanceOwner).to.be.bignumber.equal(totalSupply);
});
it('vérifie si un transfer est bien effectué', async function (){
  let balanceOwnerBeforeTransfer = await this.StudentInstance.balanceOf(owner);
  let balanceRecipientBeforeTransfer = await this.StudentInstance.balanceOf(recipient);
  let amount = new BN(10);
 
  await this.StudentInstance.transfer(recipient, amount, {from: owner});
  let balanceOwnerAfterTransfer = await this.StudentInstance.balanceOf(owner);
  let balanceRecipientAfterTransfer = await this.StudentInstance.balanceOf(recipient);
 
  expect(balanceOwnerAfterTransfer).to.be.bignumber.equal(balanceOwnerBeforeTransfer.sub(amount));
  expect(balanceRecipientAfterTransfer).to.be.bignumber.equal(balanceRecipientBeforeTransfer.add(amount));
});
});
