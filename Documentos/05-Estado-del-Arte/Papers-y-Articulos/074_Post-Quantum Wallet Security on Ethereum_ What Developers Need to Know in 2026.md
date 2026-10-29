# Post-Quantum Wallet Security on Ethereum: What Developers Need to Know in 2026

- **ID**: `284b513d-a9f4-433d-9e60-b52d8a522cb9`
- **Tipo de Fuente**: `SOURCE_TYPE_WEB_PAGE`
- **URL**: [https://blog.thirdweb.com/post-quantum-wallet-security-on-ethereum-what-developers-need-to-know-in-2026/](https://blog.thirdweb.com/post-quantum-wallet-security-on-ethereum-what-developers-need-to-know-in-2026/)

---

## Contenido Extraído / Texto Completo

Post-Quantum Wallet Security on Ethereum | Developer Guide 2026
Homepage ↗
Guides
Case Studies
Changelog
Docs ↗
YouTube ↗
post-quantum cryptography
Post-Quantum Wallet Security on Ethereum: What Developers Need to Know in 2026
Quantum computers threaten every Ethereum wallet that has ever transacted. The Ethereum Foundation, Vitalik Buterin, and a wave of new research are building the defenses. Here is what developers need to know about post-quantum wallet security in 2026.
Firekeeper
16 Jun 2026
• 5 min read
Share 
Quantum computers are no longer a distant thought experiment. With Google, IBM, and Microsoft each pushing past 1,000-qubit thresholds in 2025 and NIST finalizing its post-quantum cryptography standards, the clock is ticking for every system that relies on elliptic-curve cryptography — including Ethereum. Every EOA that has ever sent a transaction has its secp256k1 public key permanently on-chain, readable by anyone, and eventually breakable by a sufficiently powerful quantum computer running Shor's algorithm.
The Ethereum community is not waiting around. From a dedicated Post-Quantum Security team at the Ethereum Foundation to Vitalik Buterin's own EIP proposals and a wave of new research on hash-based signature verification, 2026 has become the year Ethereum started building its quantum-resistant future in earnest. Here is everything developers need to know.
Why Quantum Threatens Ethereum Wallets Today
Ethereum's transaction signing relies on ECDSA over the secp256k1 curve. When you send a transaction, your public key is derived and stored on-chain forever. A cryptographically relevant quantum computer (CRQC) running Shor's algorithm could reverse-engineer the private key from that public key, gaining full control of the wallet.
This is not a hypothetical risk that sits decades away. NIST has already proposed deprecating 112-bit classical security after 2030 and disallowing it entirely after 2035. That timeline overlaps directly with Ethereum's own fork roadmap. The wallets holding the most value — long-lived EOAs belonging to whales, DAOs, and protocol treasuries — are the most exposed, because their public keys have been on-chain the longest.
The Ethereum Foundation's Post-Quantum Security Team
In January 2026, the Ethereum Foundation formed a dedicated Post-Quantum Security team led by Thomas Coratger. The team's work is tracked publicly at pq.ethereum.org and focuses on three pillars: researching viable post-quantum signature schemes for the EVM, coordinating with NIST standards bodies, and developing migration tooling that wallet providers can adopt.
The official Ethereum roadmap now includes a dedicated quantum resistance page under Future Proofing, acknowledging that the Hegota hard fork (the upgrade after Glamsterdam) is expected to implement EIP-8141 — the consensus-level change that enables native post-quantum signature support on Ethereum.
SPHINCS-: Hash-Based Signatures on the EVM
One of the most promising research breakthroughs came on June 12, 2026, when researchers published SPHINCS- (SPHINCS minus) on ethresear.ch — a post-quantum signature verification scheme optimized specifically for Ethereum's EVM. Unlike lattice-based schemes, SPHINCS- uses hash-based cryptography, which relies only on the security of hash functions rather than mathematical hardness assumptions that a quantum computer might eventually break.
The numbers are compelling. The lightest SPHINCS- variant (C11) achieves on-chain verification at roughly 159,000 gas — comparable to a complex DeFi swap. Even more impressively, when used with EIP-8141 frame transactions, the gas cost drops to around 230,000 gas total (including transaction overhead), compared to 301,000 gas for the ERC-4337 hybrid approach. The Keccak-based variant trades NIST compliance for approximately 34% cheaper on-chain verification.
Hardware wallet compatibility is also addressed: the C11 and C12 variants are light enough to run on a Ledger Nano S+ secure element, with signature times of 390 seconds and 47.5 seconds respectively. That is slow by today's standards, but it means post-quantum signing is already physically possible on existing consumer hardware.
EIP-8141 and Vitalik's Frame Transaction Proposal
On June 5, 2026, Vitalik Buterin opened a pull request on the Ethereum EIPs repository for a new frame transaction type designed for post-quantum signatures and STARK aggregation. The EIP introduces a mechanism where transactions can declare post-quantum signatures as dependencies, allowing the mempool and block builders to batch-verify them using recursive STARK proofs.
This is architecturally significant because it means post-quantum transactions do not need to carry their full (large) signatures inside each transaction's calldata. Instead, a single STARK proof can attest to the validity of many post-quantum signatures at once, amortizing the on-chain cost across an entire block. The approach works for both privacy-preserving transactions and L2 batch submissions.
Frame transactions represent a clean path to native post-quantum support without requiring every existing contract or wallet to change simultaneously. EOAs can opt in by upgrading to frame-based signing, while the rest of the network continues to operate normally.
Upgrading Existing Wallets: The ZK + EIP-7702 Approach
Researchers have also proposed a way to retrofit existing EOAs to post-quantum security without changing the wallet address, migrating assets, or requiring any consensus change. The approach, published on ethresear.ch in April 2026, uses EIP-7702 (the code delegation mechanism from the Pectra upgrade) to delegate an EOA's execution to a GatedWallet contract.
The GatedWallet only accepts ZK proofs of ECDSA knowledge under a hidden public key — one that never appears on-chain. This means a quantum attacker who extracts the original secp256k1 public key from historical transactions gains nothing, because the wallet's authorization now depends on a key the attacker cannot see. The entire upgrade happens in a single transaction.
A complementary approach from RivaLabs uses ephemeral key pairs with account abstraction: the authorizing signer commitment rotates after every transaction, eliminating long-term public key exposure entirely. Both approaches are usable today on testnets and are compatible with ERC-4337 smart accounts.
What This Means for Developers Building on Ethereum
The post-quantum transition will not be a flag-day event. It will roll out gradually, and developers who build with account abstraction, modular wallet architectures, and upgradeable signing logic will be best positioned. Here is what to do now:
Design for signature agility. If you are building wallet infrastructure, smart accounts, or authentication flows, abstract the signature verification layer. ERC-4337 smart accounts can already swap their validation logic without changing the account address — this is exactly the upgrade path that post-quantum migration will use.
Watch EIP-7932 and EIP-8141. EIP-7932 introduces secondary signature support, and EIP-8141 defines the frame transaction type for post-quantum signatures. Both are on the Hegota fork roadmap. Understanding these proposals now gives you a head start on integration when they ship.
Test with SPHINCS- on testnets. The open-source SPHINCS- implementation supports both ERC-4337 hybrid accounts (ECDSA + SPHINCS+) and native EIP-8141 frame transaction accounts. Deploying on a testnet today helps you understand the gas economics and UX tradeoffs before mainnet support lands.
If you are building wallet or account infrastructure and want to move fast, thirdweb's developer plans scale with your project and give you the SDKs and infrastructure to build modular smart accounts that are ready for whatever signing standard comes next.
The Road Ahead: Hegota and Beyond
Ethereum's post-quantum roadmap has a clear sequence. Glamsterdam, targeting late August 2026, focuses on ePBS and execution improvements. Hegota, the following fork, is where EIP-8141 and native post-quantum signature support are expected to land. The Ethereum Foundation's PQ Security team is coordinating with wallet providers, hardware manufacturers, and L2 teams to ensure migration tooling is ready before the fork ships.
The NIST timeline adds external pressure. With 112-bit classical security deprecation proposed for 2030, Ethereum's emphasis on hash-based signatures (SPHINCS+/SLH-DSA) and potential lattice-based options (ML-DSA) maps directly onto the federal standards. This alignment is intentional — it means Ethereum's post-quantum transition will be compatible with the same cryptographic primitives that governments and financial institutions adopt.
For developers, the message is straightforward: the quantum threat is real, the solutions are taking shape, and the migration will reward those who built flexibly. Account abstraction is not just a UX improvement — it is Ethereum's quantum escape hatch.
[
Banco Santander Joins the Bitcoin ETF Rush: Spain's Largest Bank Discloses $4.3M Position
Spain's largest bank Banco Santander disclosed a $4.3 million Bitcoin position via BlackRock's IBIT ETF in an SEC filing — the latest milestone in institutional crypto adoption that signals traditional finance is accelerating its embrace of digital assets.](https://blog.thirdweb.com/banco-santander-joins-the-bitcoin-etf-rush-spains-largest-bank-discloses-4-3m-position/)
30 Jul 2026 3 min read
[
Crypto's Bloodiest Half-Year: 212 Exploits Stole $1.1B as AI-Powered Attacks Go Mainstream
Blockaid's H1 2026 report reveals 212 onchain exploits draining $1.1B from Web3 protocols. North Korea's Lazarus Group drove over $600M in losses, and AI prompt injection attacks are emerging as the next major threat vector. Here's what every builder needs to know.](https://blog.thirdweb.com/cryptos-bloodiest-half-year-212-exploits-stole-1-1b-as-ai-powered-attacks-go-mainstream/)
30 Jul 2026 3 min read
[
AI Agents Can Now Pay on Your Behalf: Moonpay PayBox Explained
Moonpay's PayBox lets ChatGPT and Claude execute real crypto transactions from a conversation — no terminal, no developer tools, no handing over private keys. Here is how the infrastructure works and what it means for web3 developers building for the AI agent economy.](https://blog.thirdweb.com/ai-agents-can-now-pay-on-your-behalf-moonpay-paybox-explained/)
30 Jul 2026 5 min read
thirdweb © 2026 
Powered by Ghost