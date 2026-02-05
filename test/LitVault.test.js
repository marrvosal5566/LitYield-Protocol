const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("LitVault Protocol", function () {
  let LitYieldToken, token;
  let LitVault, vault;
  let owner, addr1, addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();

    // Deploy Token
    LitYieldToken = await ethers.getContractFactory("LitYieldToken");
    token = await LitYieldToken.deploy();

    // Deploy Vault
    LitVault = await ethers.getContractFactory("LitVault");
    vault = await LitVault.deploy(await token.getAddress());

    // Mint some tokens to addr1 for testing
    await token.transfer(addr1.address, ethers.parseEther("1000"));
  });

  it("Should set the right owner", async function () {
    expect(await token.owner()).to.equal(owner.address);
  });

  it("Should allow deposits", async function () {
    const depositAmount = ethers.parseEther("100");
    
    // Approve vault to spend tokens
    await token.connect(addr1).approve(await vault.getAddress(), depositAmount);
    
    // Deposit
    await vault.connect(addr1).deposit(depositAmount);
    
    // Check balance in vault
    expect(await vault.balances(addr1.address)).to.equal(depositAmount);
  });

  // Note: We skip L2 block number tests in local Hardhat env 
  // because address(100) precompile doesn't exist locally.
});
