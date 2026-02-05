const hre = require("hardhat");

async function main() {
  console.log("🚀 Starting deployment to LitVM...");

  // 1. Deploy the Governance Token
  const LitYieldToken = await hre.ethers.getContractFactory("LitYieldToken");
  const token = await LitYieldToken.deploy();
  await token.waitForDeployment();
  const tokenAddress = await token.getAddress();
  console.log(`✅ LitYieldToken deployed to: ${tokenAddress}`);

  // 2. Deploy the Vault (Injecting the token address)
  const LitVault = await hre.ethers.getContractFactory("LitVault");
  const vault = await LitVault.deploy(tokenAddress);
  await vault.waitForDeployment();
  const vaultAddress = await vault.getAddress();
  console.log(`✅ LitVault deployed to: ${vaultAddress}`);

  console.log("\nDeployment complete! Don't forget to verify on Blockscout.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
