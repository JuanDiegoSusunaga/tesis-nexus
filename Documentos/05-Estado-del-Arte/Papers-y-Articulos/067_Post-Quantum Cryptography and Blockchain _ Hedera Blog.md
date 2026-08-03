# Post-Quantum Cryptography and Blockchain | Hedera Blog

- **ID**: `fd54a67b-88cf-4d6e-a9fe-309fac246cce`
- **Tipo de Fuente**: `SOURCE_TYPE_WEB_PAGE`
- **URL**: [https://hedera.com/blog/post-quantum-cryptography-and-blockchain/](https://hedera.com/blog/post-quantum-cryptography-and-blockchain/)

---

## Contenido Extraído / Texto Completo

Post-Quantum Cryptography and Blockchain | Hedera Blog
Skip to content
HederaH
Solutions Services & Products Token Service Consensus Service Smart Contract Service Asset Tokenization Studio Stablecoin Studio AI Studio Sustainability Studio (Guardian) HashSphere Support Use Cases Asset Tokenization Artificial Intelligence (AI) Sustainability Payments Decentralized Identity Decentralized Finance (DeFi) Consumer Engagement dApp Directory
Developers Get Started Start Building Documentation Developer Portal Developer Tooling GitHub Funding Community Hackathons Community Hub Ambassador Program Builders Program Moderator Program Bug Bounty
Network Governance Ecosystem Network Activity Network Status Roadmap Open Source / Hiero Partner Program
Resources Blog Case Studies Events Fee Calculator Journey Knowledge Center Public Policy Videos
Start Building Contact
Solutions Services & Products Token Service Consensus Service Smart Contract Service Asset Tokenization Studio Stablecoin Studio AI Studio Sustainability Studio (Guardian) HashSphere Support Use Cases Asset Tokenization Artificial Intelligence (AI) Sustainability Payments Decentralized Identity Decentralized Finance (DeFi) Consumer Engagement dApp Directory
Developers Get Started Start Building Documentation Developer Portal Developer Tooling GitHub Funding Community Hackathons Community Hub Ambassador Program Builders Program Moderator Program Bug Bounty
Network Governance Ecosystem Network Activity Network Status Roadmap Open Source / Hiero Partner Program
Resources Blog Case Studies Events Fee Calculator Journey Knowledge Center Public Policy Videos
Start Building Contact
blog
Post-Quantum Cryptography and Blockchain: Where the Industry Stands
April 10, 2026 
Ed Marquez
Head of Developer Relations 
Leemon Baird
Co-Founder of Hedera 
Rohit Sinha
Head of Cryptography
Today's distributed ledgers, including Hedera, rely on elliptic-curve signatures (ECDSA, Ed25519) that a future quantum computer could break. The threat is not imminent. But the migration is already underway: The National Institute of Standards and Technology (NIST) finalized three post-quantum cryptography (PQC) standards in August 2024, browsers and messaging apps are shipping PQC key exchange, and Hedera has a concrete path to full post-quantum operation.
Why Quantum Computers Threaten Distributed Ledgers
Public-key cryptography secures almost every blockchain and Distributed Ledger Technology (DLT) in production. When a user signs a transaction with Ed25519 or ECDSA, the security rests on, among other things, the hardness of the elliptic curve discrete logarithm problem (ECDLP), which classical computers cannot solve quickly.
A sufficiently powerful quantum computer breaks that assumption. Shor's algorithm solves ECDLP in polynomial time. An attacker with a cryptographically relevant quantum computer (CRQC) could derive a private key from a public key and forge signatures. This applies to every chain using elliptic-curve or RSA-based signatures: Bitcoin, Ethereum, Hedera, and the rest.
The timeline is uncertain but narrowing. Expert surveys put the odds of a cryptographically relevant quantum computer (CRQC) existing by the late 2030s at over 50%, with a meaningful probability as early as the mid-2030s ( Mosca & Piani, 2024). Progress towards a CRQC continues, such as in this recent Google paper.
The NIST Standards
Before getting into how specific cryptographic primitives are affected, it's worth understanding the replacement algorithms and where they stand.
Three standards were finalized in August 2024:
FIPS 203, ML-KEM (from CRYSTALS-Kyber): Key encapsulation for establishing shared secrets
FIPS 204, ML-DSA (from CRYSTALS-Dilithium): Digital signatures.
FIPS 205, SLH-DSA (from SPHINCS+): Hash-based digital signatures with different security assumptions, intended as a conservative backup
Two more are in progress:
FIPS 206, FN-DSA (from Falcon): Digital signatures with compact output, which matters for bandwidth-constrained applications like blockchains. NIST has said the initial public draft will be released soon, and the final standard is anticipated around early 2027 based on the typical review cycle.
FIPS 207, HQC-KEM (from HQC): Key encapsulation for establishing shared secrets. NIST has said the draft will be released soon, with the final version in 2027.
This wraps up an eight-year effort. NIST received 82 submissions in 2017, narrowed them to 69 in Round 1, 26 in Round 2, selected four algorithms in July 2022, and then HQC in a later round. Separately, the IETF is progressing hybrid key exchange for TLS 1.3, and the NSA's CNSA 2.0 guidance sets deadlines for federal systems to finish PQC migration by 2030 to 2035.
What “Post-Quantum” Actually Means
“Post-quantum” does not mean flipping one switch. Distributed ledgers use multiple kinds of cryptography, and quantum risk is different for each:
Where Hedera's Cryptography Stands Today
The short version: hashes and symmetric crypto are already strong against quantum attacks with current key sizes. Signatures and key agreement are not. That means parts of Hedera's cryptographic stack are already post-quantum, while other parts need deliberate migration.
When a transaction is submitted to the Hedera network, it is sent to a node, which forwards it to the consensus network. The hashgraph consensus algorithm then establishes a consensus timestamp and ordering for the transaction through virtual voting among the network's nodes. Once consensus is reached, the transaction is applied to the network state, whether that's transferring HBAR, executing a smart contract, or updating a file. Let us consider the cryptographic primitives involved in a transaction's lifecycle.
Hashes: SHA-384
Hedera uses SHA-384 to link hashgraph history and verify data integrity. The Brassard-Høyer-Tapp quantum algorithm would reduce its effective security to around 128 bits, which is well beyond any foreseeable attack and is considered secure by experts. SHA-384 appears in high-assurance post-quantum guidance alongside AES-256. SHA-384 is required by the CNSA standard. Many other networks use SHA-256, which may be sufficient.
Symmetric Encryption: AES-256
Hedera uses AES-256 within TLS for encrypted transport. Grover's quantum algorithm would reduce the effective security to around 128 bits, which experts consider secure.
Key Agreement: TLS
Hedera uses TLS for node-to-node and client-to-node communication. The network's security does not depend on TLS. Hashgraph consensus provides its own integrity guarantees independent of the transport layer.
The broader internet is already deploying post-quantum and hybrid TLS. Chrome has shipped hybrid key exchange (X25519 + ML-KEM-768) by default since April 2024. Cloudflare, Apple (iMessage PQ3), and Signal (PQXDH) have all deployed PQC key encapsulation in production. As TLS libraries add PQC and hybrid key exchange support, Hedera will enable it for the network. This is a configuration-level change, not a protocol redesign.
Signatures: the Key Piece to Upgrade
Today, Hedera accounts and transactions use ECDSA (secp256k1) and Ed25519. Both are strong against classical attacks. Neither is quantum-resistant. This is the area that needs migration, both for the network (node-level event signing) and for users (account keys, smart contract authorization).
Hedera has post-quantum primitives in place (SHA-384, AES-256). However, the network does not yet have post-quantum signatures, which are required for full end-to-end post-quantum security. This is not unique to Hedera. No major DLT network with traditional signatures has completed a full migration to post-quantum signatures.
Network Security and User Security
Not all signature upgrades need to happen at once. The migration covers separate concerns:
Network signing: Nodes sign events during live consensus. These signatures matter in real time to establish agreement. Upgrading them to post-quantum algorithms protects the integrity of the consensus process. This is an infrastructure change and can happen without requiring action from end users. Once consensus is reached, signed blocks and state become part of the permanent record. Protecting those signatures ensures the ledger's history stays verifiable long term, even if a CRQC eventually exists. The approach and timeline can differ from event signing.
User keys: Users and applications hold keys that authorize transfers, smart contract calls, and token operations. Post-quantum account key types let users and wallet providers migrate on their own schedule. This requires coordination with wallets, custodians, SDK maintainers, and users across the ecosystem.
The concerns are linked but can proceed independently. In practice, hardening network operations first and supporting user key migration later is a logical sequence, partly because post-quantum signatures are much larger and affect transaction costs and tooling.
The Size Problem
Post-quantum signature algorithms produce much larger keys and signatures than today's elliptic-curve schemes. This is the biggest practical obstacle for any blockchain considering PQC.
The table below compares each algorithm family at NIST Level 5:
FN-DSA-1024, the most compact lattice-based option at Level 5, produces signatures roughly 20x larger than Ed25519. ML-DSA-87 is over 70x larger. That increase hits transaction size and cost, network bandwidth, ledger storage growth, maximum transaction size limits, and multi-signature complexity.
FN-DSA gets the most attention in blockchain circles. The tradeoff is that it relies on floating-point arithmetic for the signing process, which creates implementation complexity and side-channel risk. ML-DSA is simpler to implement but its signatures are about 3.6x the size of FN-DSA's.
How the Industry Is Approaching PQC
While some networks have begun experimenting with migrating to post-quantum signatures for specific use cases, no major network has completed a full migration. The industry is early, and approaches differ. Some networks have pointed toward ML-DSA (Dilithium). Others are watching FIPS 206 (FN-DSA) for its more compact output.The challenge is universal: post-quantum signatures are 10 to 50x larger than current schemes, and there will be a real cost for any ecosystem to become quantum resistant.
Hedera's Path to Post-Quantum
Hedera's transition follows a deliberate sequence, starting with the simplest changes and progressing toward the ones that require the most ecosystem coordination:
Post-quantum TLS for nodes. When Hedera's TLS libraries add PQC/hybrid support, the network can enable post-quantum key exchange for node-to-node communication. This doesn't affect consensus security, which doesn't depend on TLS.
Post-quantum TLS for client connections. Same upgrade, applied to client-facing endpoints.
Post-quantum event signing. Consensus nodes sign events and blocks. When the Falcon draft is available, the event signing will be updated to a hybrid signature (classical Ed25519 + FN-DSA together), which provides quantum resistance while keeping classical security as a fallback. Once the final version of Falcon is available, it will become pure FN-DSA, without the hybrid.
Post-quantum key type for users (HAPI). Once FIPS 206 (FN-DSA) is finalized, a new post-quantum key type can be added to the Hedera API. Users, contracts, and applications can opt in and rotate keys at their own pace. Transactions will get bigger (a single FN-DSA signature is 1,280 bytes, compared to 64 bytes for Ed25519), and the maximum transaction size limit will be increased. The FIPS 206 draft is expected soon. A new post-quantum key type for users is targeted for 2027. If FIPS 206 is delayed, Dilithium (ML-DSA) will be used instead of Falcon, which means larger signatures and keys but the same post-quantum protection.
What This Means for Developers
Existing Ed25519 and ECDSA keys will keep working throughout the transition. No one needs to change anything right now.
For developers building applications with long-lived assets or keys, there are a few things worth doing early. Keep an eye on FIPS 206 (FN-DSA), since that standard determines when post-quantum user keys become available on Hedera; the NIST PQC project page tracks the latest status. If key rotation in your application is clunky today, that's worth fixing regardless of PQC, but it will matter more when users need to switch key types. Applications that batch transactions, sit near size limits, or optimize for minimal payload should start thinking about what 10x larger signatures do to those assumptions. And for anyone who wants to get hands-on, the Open Quantum Safe project has reference implementations of ML-KEM, ML-DSA, and other PQC algorithms worth experimenting with.
For questions or discussion about Hedera's post-quantum roadmap, join the conversation on the Hedera Discord server.
FAQ
Is Hedera “quantum secure” today?
Hedera uses post-quantum hashing (SHA-384) and symmetric encryption (AES-256). Full post-quantum security also requires post-quantum digital signatures for both network operations and user keys. That migration is underway.
Are Ed25519 and ECDSA quantum-resistant?
No. Both rely on elliptic-curve math that Shor's algorithm can break. They remain strong against all known classical attacks.
Why SHA-384 instead of SHA-256?
The quantum Brassard-Høyer-Tapp algorithm gives a cubic speedup for breaking hashes, so 384 bits are needed to achieve the desired 384/3=128 bits of security. This may be why the US government requires SHA-384 for protecting its own Top Secret information, according to the CNSA standard. More recently, there have been discussions about that algorithm requiring too much memory, and suggestions that maybe SHA-256 might be secure enough. SHA-384 is definitely secure.
Will post-quantum signatures make transactions more expensive?
FN-DSA-1024 signatures are 1,280 bytes vs. 64 bytes for Ed25519. ML-DSA signatures are bigger still (2,420+ bytes). This affects transaction size and storage on any blockchain, and potentially cost.
When can users start using post-quantum keys on Hedera?
The new key type will be deployed when FIPS-206 (Falcon) is finalized, or in 2027 if it is delayed. Once it has been added, wallet software will need to be updated to allow users to rotate their keys. Wallet software developers should start preparing to be able to add that support quickly. And they might consider adding periodic pop-up reminders to the user to upgrade to the new keys, and make it easy for the user to do so.
Why not wait until quantum computers are closer?
Cryptographic migrations across networks, wallets, custodians, and developer tooling can take a long time. Starting now, while standards are fresh and timelines are comfortable, beats a rushed migration under pressure. That said, PQC implementations are still maturing, and the cryptographic community continues to actively analyze the security assumptions behind FN-DSA and ML-DSA. A phased approach accounts for both the urgency and the ongoing scrutiny.
Resources
Inside Hashgraph Cryptography + Post-Quantum Fireside with Dr. Leemon Baird | Hedera DevDay 2026
Are Ed25519 Keys Quantum Resistant? Exploring the Future of Cryptography
Post-Quantum Crypto
NIST Post-Quantum Cryptography FAQs
NIST Announces Approval of Three Federal Information Processing Standards (FIPS)
NIST Post-Quantum Cryptography Standardization
Post-Quantum Cryptography – Security (Evaluation Criteria)
NSA CNSA 2.0 Algorithm Guidance
CISA Post-Quantum Cryptography Initiative
Quantum Threat Timeline Report 2024
NIST Selects HQC as Fifth Algorithm for Post-Quantum Encryption
https://falcon-sign.info/
Securing Elliptic Curve Cryptocurrencies against Quantum Vulnerabilities: Resource Estimates and Mitigations, Ryan Babbush et. al., March 30, 2026, https://quantumai.google/static/site-assets/downloads/cryptocurrency-whitepaper.pdf
Back to Blog
discover
See more articles
View All 
July 17, 2026
Deploy Multichain Dapps on Hedera in 60 Seconds with scaffold-hbar
Deploying multichain dapps on Hedera has never been easier! With just one command, you can spin up a fully functional dapp using Next.js, Hardhat or Foundry, and AI agent context…
Read More 
July 13, 2026
Regulation is finding its form in summer 2026
Halfway through 2026, the regulatory picture is coming into focus. Hedera Chief Policy Officer Nilmini Rubin and VP Global Policy Isadora Arredondo break down what moved in June across the
Read More 
July 8, 2026
Hiero CLI: Practical Workflows for Hedera Developers
Hiero CLI is a command-line tool for developers working with the Hedera and Hiero ecosystems. Its purpose is not only to expose individual commands, but also make common Hedera workflows
Read More
Ready to get started?
Discover why Hedera is the trusted institutional-grade network powering the new digital economy.
Start Building
Contact
hedera highlights
Subscribe to get the latest Hedera news, updates, and insights delivered right to your inbox. Unsubscribe anytime.    
funding
governance
brand book
careers
faqs
support
terms & conditions
privacy policy
© 2018-2026 Hedera Hashgraph, LLC. All trademarks and company names are the property of their respective owners.
All rights in Hedera Council member, Deutsche Telekom mark, are protected by Deutsche Telekom AG. All rights reserved. Hedera uses the third party marks with permission.
We use cookies to deliver the best experience on our website and to analyze traffic. By continuing to use this site, you consent to our cookie policy.
Review our Privacy Policy to understand how Hedera collects and uses information.
Accept All Cookies Accept Necessary Cookies