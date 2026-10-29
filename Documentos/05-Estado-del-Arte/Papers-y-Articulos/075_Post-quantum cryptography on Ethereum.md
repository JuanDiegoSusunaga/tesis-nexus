# Post-quantum cryptography on Ethereum

- **ID**: `e36f970e-3416-45d1-a84f-f8f2af254f79`
- **Tipo de Fuente**: `SOURCE_TYPE_WEB_PAGE`
- **URL**: [https://ethereum.org/roadmap/security/quantum-resistance](https://ethereum.org/roadmap/security/quantum-resistance)

---

## Contenido Extraído / Texto Completo

Post-quantum cryptography on Ethereum | ethereum.org
Skip to main content 
Search K
Overview
What is Ethereum?
What is the Ethereum network?
What is ether (ETH)?
Ethereum's core principles
What is Web3?
How people use Ethereum
Smart contracts
Ethereum wallets
Gas fees
What are layer 2 networks?
Staking
Ethereum vs Bitcoin
Privacy on Ethereum
Ethereum security and scam prevention
Support
Test your knowledge
Videos
Start here
Choose your wallet
Get ETH
Explore apps
See all guides
Payments
Stablecoins
Prediction markets
See all use cases
Solo staking
Run a node
Pooled staking
Staking as a service
Layer 2 networks
Find an L2 network
Blockchain bridges
Builder's home
Builder tools & apps
Learn Ethereum development
Tutorials
Learn by coding
Overview
Foundational topics
Ethereum stack
UX/UI design fundamentals
Founders
Institution & enterprise
Privacy for institutions and technical solutions
Community hub
Events calendar
Online communities
Devcon
Where to start
Grants
About ethereum.org
Contributing to ethereum.org
Translation Program
ethereum.org collectibles
Brand assets
Ethereum Whitepaper
Reports
Governance
Overview
Improved security
Cheaper transactions
Better user experience
Privacy
EIPs - Ethereum improvement proposals
ERCs
Bug bounty
Trillion-dollar security
Energy consumption
History & founders
Technical history
Open research
Data & analytics tools
Ethereum Foundation
Ethereum roadmap
/
Security
/
Quantum resistance
Post-quantum cryptography on Ethereum
Quantum computers will eventually threaten the cryptography Ethereum uses today
The Ethereum Foundation has a dedicated post-quantum research team, and a structured "Lean Ethereum" roadmap targeting 2029 for full post-quantum protection
Your funds are safe today and wallet software will guide you through future migration 
See contributors
Copy .md Copy .md
Edit page (opens in a new tab)
Quantum computers will eventually be able to break the cryptographic methods that secure Ethereum and most other digital systems today. This page explains what that means, how the network is proactively developing improvements to mitigate this risk, and what you need to know.
Why post-quantum cryptography matters
Ethereum relies on several forms of cryptography to keep the network secure and protect user funds. The most important are:
Elliptic curve digital signature algorithm (ECDSA): The cryptography used to sign transactions. Your Ethereum account's security depends on this.
BLS signatures: Used by validators to reach consensus on the state of the network.
KZG polynomial commitments: Used for data availability in Ethereum's scaling roadmap.
ZK-proof systems: Used by rollups and other applications to verify computations offchain.
All of these rely on mathematical structures, such as Abelian groups, that are hard for classical computers but can be solved efficiently by a quantum computer using Shor's algorithm (opens in a new tab) .
When will quantum computers threaten Ethereum?
In March 2026, Google Quantum AI published research estimating that breaking 256-bit elliptic curve cryptography (the type Ethereum uses for account signatures) could require roughly 1,200 logical qubits. Previous estimates put this number much higher. Google has set a 2029 internal deadline for migrating its own systems to post-quantum cryptography.
Current quantum hardware is far from this scale, operating with a few thousand noisy physical qubits. Logical qubits (which correct for errors and perform reliable computation) require many physical qubits each. The gap between current hardware and what is needed to break Ethereum's cryptography remains significant, but it is narrowing faster than many expected. Notably, the U.S. National Institute of Standards and Technology (NIST) anticipates deprecating ECDSA by 2030 and disallowing it by 2035.
This is not an imminent threat. But cryptographic transitions take years, and Ethereum's security model is designed to last centuries. Ethereum's response is the Lean Ethereum roadmap, a deliberate, multi-year mission to rebuild Ethereum around primitives that will survive any cryptographic threat.
Four areas vulnerable to quantum attack
In February 2026, Vitalik Buterin published a roadmap (opens in a new tab) identifying four distinct areas of Ethereum's cryptography that need post-quantum upgrades. Each has different challenges and different solution paths.
1. Consensus-layer BLS signatures
What it does: Ethereum's proof-of-stake protocol uses BLS signatures to aggregate votes from hundreds of thousands of validators. BLS allows many signatures to be combined into one, keeping the network efficient.
Why it is vulnerable: BLS signatures rely on elliptic curve pairings, which a quantum computer could break.
The approach: The Lean Consensus roadmap includes developing two complementary tools:
leanXMSS: Ethereum will replace BLS signatures with leanXMSS, a hash-based signature scheme for validators. Hash-based signatures are considered quantum-safe because they rely only on the security of hash functions, which quantum computers weaken but do not break.
leanVM: A minimal zkVM (zero-knowledge virtual machine) for SNARK-based signature aggregation. Because hash-based signatures are significantly larger (roughly 3,000 bytes compared to 96 bytes for BLS), switching to leanXMSS would produce significantly more data per slot. To solve this, leanVM acts as an aggregation engine, compressing the data by 250x. This preserves the efficiency benefits of combining many signatures into one, even after switching to quantum-safe schemes.
Why can't Ethereum just replace BLS with a quantum-safe scheme?
More
The aggregation property that makes BLS efficient (combining hundreds of thousands of signatures into one) does not have an obvious quantum-safe equivalent. Post-quantum signatures are also much larger than BLS signatures. Simply swapping one for the other would make Ethereum's consensus layer significantly slower and more expensive. That is why the team is building leanVM, a tool that uses zero-knowledge proofs to aggregate quantum-safe signatures efficiently.
2. Data availability: KZG commitments
What it does: KZG polynomial commitments ensure that data (particularly blob data from rollups) is available on the network without requiring every node to download all of it.
Why it is vulnerable: KZG commitments rely on elliptic curve pairings, the same mathematical structure that quantum computers can attack.
Current mitigation: KZG commitments use a "trusted setup" where many participants contributed randomness. As long as at least one participant was honest and discarded their secret, the setup is secure, even against quantum computers attempting to reverse-engineer it after the fact.
Long-term solution: Replace KZG with a quantum-safe commitment scheme. The two leading candidates are:
STARK-based commitments: Rely on hash functions rather than elliptic curves. Already used in some ZK-rollups.
Lattice-based commitments: Rely on the hardness of lattice problems, which are believed to be quantum-resistant.
Both approaches are still being researched for efficiency and practicality at Ethereum's scale.
3. Account signatures: ECDSA
What it does: Every standard Ethereum account (externally owned account, or EOA ) uses ECDSA on the secp256k1 curve to sign transactions. This is what protects your funds.
Why it is vulnerable: For any account that has sent a transaction, the public key is exposed onchain. A quantum computer could derive the private key from this exposed public key data.
Important nuance: Accounts that have only received ether and never sent a transaction have not exposed their public key. Only the address (a hash of the public key) is visible, which provides some additional protection.
The approach: Rather than a single protocol-wide migration, Ethereum plans to use account abstraction (specifically EIP-8141, being considered for Hegotá in second half of 2026) to give users signature agility. Individual accounts could switch to a post-quantum signature scheme without waiting for the entire protocol to change.
This is a pragmatic approach. Users and wallets that want post-quantum protection early can adopt it voluntarily, while the broader migration happens over time.
4. Application-layer ZK-proofs
What it does: Zero-knowledge proof systems are used by L2 rollups and other applications to verify computations without revealing underlying data.
Why it is vulnerable: Many popular ZK-proof systems (SNARKs using elliptic curve pairings) rely on quantum-vulnerable assumptions.
The approach: STARKs, which rely on hash functions rather than elliptic curves, are already quantum-resistant and are used by several rollups. Natural ecosystem adoption of STARK-based systems is already providing post-quantum security at the application layer.
NIST standards
In August 2024, the U.S. National Institute of Standards and Technology (NIST) finalized three post-quantum cryptography standards (opens in a new tab) . These matter because they give the entire technology industry, including Ethereum, a shared set of vetted algorithms to build on rather than each project inventing its own.
These standards provide a foundation for the broader industry's post-quantum transition. Ethereum's work builds on and extends these, with particular focus on the unique challenges of a decentralized network where efficiency and aggregation matter.
The Ethereum Foundation's approach
The Ethereum Foundation formed a dedicated Post-Quantum Security team in January 2026, led by Thomas Coratger. The team's work is tracked publicly at pq.ethereum.org (opens in a new tab) .
Current activity (as of April 2026)
Weekly interop devnets: More than 10 client teams participate in regular post-quantum interoperability testing, including Lighthouse, Grandine, Zeam, Ream Labs, and PierTwo.
Poseidon Prize: A $1 million research prize targeting improvements in hash-based cryptographic primitives.
Open-source implementations: leanXMSS, leanVM, leanSpec (Python), leanSig (Rust), and leanMultisig are all available under the leanEthereum GitHub organization (opens in a new tab) .
2nd Annual PQ Research Retreat: Planned for 9-Oct-2026 to 12-Oct-2026 in Cambridge, UK.
NIST Alignment: Ethereum's work builds upon the post-quantum cryptography standards finalized by NIST in August 2024 (such as ML-KEM, ML-DSA, and SLH-DSA).
Migration milestones
The team has outlined a series of protocol upgrades to incrementally introduce post-quantum cryptography into Ethereum. These are planning milestones, not guaranteed commitments. Names and ordering may change.
Target: The structured fork milestones target the completion of core post-quantum infrastructure by approximately 2029. Full execution-layer and ecosystem migration extends beyond that.
What do users need to do?
Right now: nothing. Your funds are safe. No quantum computer today can threaten Ethereum's cryptography.
In the future: Once post-quantum signature schemes are widely supported on Ethereum (expected following the Hegotá hard fork and implementation of EIP-8141), you will want to migrate your account to quantum-safe signatures. Wallet software will guide you through this transition.
If your account has never sent a transaction (meaning your public key has not been exposed onchain), it has an additional layer of protection. But all accounts should eventually migrate.
The question of how to handle dormant wallets (accounts whose owners may not be aware of the need to migrate) is an open governance topic. The Ethereum community has not yet reached consensus on this.
Frequently asked questions
Can quantum computers steal my ETH today?
More
No. No quantum computer today can break Ethereum's cryptography. Current quantum hardware is far from the scale needed. The work described on this page is preparation for the future, not a response to an active threat.
When could quantum computers become a threat?
More
Estimates vary. Google's March 2026 research suggests the hardware needed to break 256-bit elliptic curve cryptography could arrive sometime around the end of this decade at the earliest, but significant engineering challenges remain. Most researchers consider a realistic threat to be several years away at minimum. The honest answer is that no one knows the exact timeline, which is precisely why preparing now is important.
Will I need to do anything to protect my wallet?
More
Eventually, yes. Once post-quantum signature schemes are available on Ethereum, users will want to migrate their accounts. Wallet software will likely handle this transition for you. For now, there is nothing you need to do. When action is needed, the Ethereum community and wallet developers will provide clear guidance and tools.
What about my tokens, NFTs, and DeFi positions?
More
Assets on Ethereum are controlled by account signatures. Once your account is migrated to a quantum-safe signature scheme, everything in that account is protected. You do not need to migrate each asset individually. Smart contracts that hold funds (like DeFi protocols) may need their own upgrades depending on what cryptographic primitives they use internally.
Is Ethereum behind other blockchains on this?
More
No. Ethereum has one of the most structured post-quantum programs of any blockchain: a dedicated team, funded research, weekly devnets, and a published migration roadmap, treating quantum computing as a first-class design constraint. No blockchain has completed a full post-quantum transition yet. According to Ethereum Foundation estimates, Ethereum's quantum-vulnerable dormant fund exposure is approximately 0.1%, drastically lower than other major blockchain networks.
What is 'harvest now, decrypt later'?
More
"Harvest now, decrypt later" is an attack where someone records encrypted data or exposed public keys today, then breaks the encryption later once a powerful enough quantum computer exists. For Ethereum, this is most relevant to accounts whose public keys are already exposed onchain (any account that has sent a transaction). This is one reason the community treats post-quantum migration as time-sensitive even though the quantum threat is not yet immediate.
Further reading
pq.ethereum.org (opens in a new tab) - Ethereum Foundation
Post-Quantum Cryptography Project (opens in a new tab) - Privacy Stewards of Ethereum (PSE)
NIST Post-Quantum Cryptography standards (opens in a new tab) - NIST
Safeguarding cryptocurrency by disclosing quantum vulnerabilities responsibly (opens in a new tab) - Google Quantum AI
Quantum frontiers may be closer than they appear (opens in a new tab) - Google
KZG and trusted setups
Lean Week Cambridge (2025) leanVM + PQ workshop resources (opens in a new tab) - Lean Ethereum
PQ Transaction Signatures ACD Breakout Calls (opens in a new tab) - Ethereum Foundation
PQ Interop ACD Breakout Calls (opens in a new tab) - Ethereum Foundation
Lean Ethereum & Post-Quantum Security YouTube Playlist (opens in a new tab) - Ethereum Foundation
Panel interview post-quantum resistance (opens in a new tab) - Bankless Podcast
Account abstraction on Ethereum
strawmap.org (opens in a new tab) - EF Architecture
Superpositioned: Analysis of the Quantum Computing Industry (opens in a new tab) - Saneel Sreeni
On this page
Roadmap Options
On this page
Why post-quantum cryptography matters
Four areas vulnerable to quantum attack
NIST standards
The Ethereum Foundation's approach
What do users need to do?
Frequently asked questions
Further reading
Was this page helpful?
Yes No
Roadmap Options
Website last updated: July 30, 2026
Go to top
ethereum.org
Learn
Learn Hub
What is Ethereum?
What is ether (ETH)?
Ethereum wallets
What is Web3?
Smart contracts
Gas fees
Run a node
Ethereum security and scam prevention
Quiz Hub
How people use Ethereum
Ethereum glossary
Use
Guides
Choose your wallet
Get ETH
Application explorer
Stablecoins
NFTs - Non-fungible tokens
DeFi - Decentralized finance
DAOs - Decentralized autonomous organizations
Decentralized identity
Stake ETH
Layer 2
Build
Builder's home
Tutorials
Documentation
Start building
Learn Ethereum development
Grants
Foundational topics
UX/UI design fundamentals
Enterprise - Mainnet Ethereum (opens in a new tab)
Founders
Participate
Community hub
Online communities
Ethereum events
Contributing to ethereum.org
Translation Program
Ethereum bug bounty program
Ethereum Foundation
Ethereum Foundation Blog (opens in a new tab)
Ecosystem Support Program (opens in a new tab)
Devcon (opens in a new tab)
Research
Ethereum Whitepaper
Ethereum roadmap
Improved security
Technical history of Ethereum
Open research
Ethereum Improvement Proposals
Ethereum governance
Reports
Trillion dollar security project
GitHub (opens in a new tab) Farcaster (opens in a new tab) X (opens in a new tab) Discord (opens in a new tab)
About us
Ethereum brand assets
Code of conduct
Jobs
Privacy policy
Terms of use
Cookie policy
Press Contact (opens email client)
Is this page helpful?