# LitYield Protocol 🌾

![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Network](https://img.shields.io/badge/Network-LitVM_Testnet-orange.svg)
![Status](https://img.shields.io/badge/Status-Development-green.svg)

**LitYield** is a decentralized, non-custodial liquidity protocol built natively for **LitVM**. It enables users to supply assets to earn passive income (yield) while leveraging the security of Litecoin and the high-throughput capabilities of the Arbitrum Orbit stack.

## 🚀 Features

- **Lending & Borrowing:** Over-collateralized lending markets for wLTC, stablecoins, and bridged assets.
- **Yield Farming:** Earn **$LYD** governance tokens by providing liquidity to the protocol.
- **LitVM Optimized:** Specifically engineered to handle L2 sequencer latency and utilize `ArbSys` precompiles for accurate block tracking.
- **Gas Efficient:** Optimized for LitVM's low-fee environment.

## 🛠 Architecture & Technical Highlights

LitYield is built using standard **OpenZeppelin** implementations for security, with custom adapters for the LitVM execution environment.

### ⚠️ Important: EVM Compatibility Note
Due to the architectural differences between Ethereum L1 and the Arbitrum Orbit L2 stack (which LitVM is based on), standard `block.number` calls return the approximate L1 block number, not the L2 block height.

**LitYield Solution:**
Our `LitVault` contracts utilize the **ArbSys Precompile (address 0x0000000000000000000000000000000000000064)** to retrieve the actual L2 block number via `arbBlockNumber()`. This ensures accurate interest rate calculations and reward distribution timing.

## 📦 Installation & Setup

To run this project locally or deploy to LitVM testnet:

```bash
# 1. Install dependencies
npm install

# 2. Compile contracts
npx hardhat compile

# 3. Run tests
npx hardhat test
```

## 📜 Contract Overview

| Contract | Description |
|----------|-------------|
| `LitYieldToken (LYD)` | The native governance token (ERC-20) used for liquidity mining rewards. |
| `LitVault` | The core vault logic handling user deposits, withdrawals, and interaction with the ArbSys precompile. |
| `YieldController` | Manages interest rate models and reward distribution parameters. |

## 🗺️ Roadmap

- [x] Protocol Design & Architecture
- [x] LitVM Compatibility Analysis (ArbSys integration)
- [ ] **Phase 1:** Deploy to LitVM Incentivized Testnet (Current)
- [ ] **Phase 2:** Community Testing & Bug Bounty
- [ ] **Phase 3:** Mainnet Launch on Litecoin

## 🤝 Contributing

We welcome contributions from the community! Please feel free to submit a Pull Request or open an issue.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
