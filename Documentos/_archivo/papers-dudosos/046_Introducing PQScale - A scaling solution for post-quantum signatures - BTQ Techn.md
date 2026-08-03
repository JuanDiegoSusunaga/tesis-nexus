# Introducing PQScale - A scaling solution for post-quantum signatures - BTQ Technologies

- **ID**: `403cf5bf-3e1d-4b5e-8bf5-d8634bf279c4`
- **Tipo de Fuente**: `SOURCE_TYPE_WEB_PAGE`
- **URL**: [https://www.btq.com/blog/introducing-pqscale-a-scaling-solution-for-post-quantum-signatures](https://www.btq.com/blog/introducing-pqscale-a-scaling-solution-for-post-quantum-signatures)

---

## Contenido Extraído / Texto Completo

Introducing PQScale - A scaling solution for post-quantum signatures 
Products
Company
Resources
Investor Relations
Contact
Explore Products
Back to research
Apr 27, 2023
Introducing PQScale - A scaling solution for post-quantum signatures
Hello, PQScale We are thrilled to announce PQScale, an efficient scaling mechanism for lattice-based post-quantum signatures. PQScale is a scaling solution that achieves unprecedented transaction speed and cost savings by leveraging zero-knowledge proofs for transaction processing. It is an infrastructure suitable for... 
Hello, PQScale
We are thrilled to announce PQScale, an efficient scaling mechanism for lattice-based post-quantum signatures. PQScale is a scaling solution that achieves unprecedented transaction speed and cost savings by leveraging zero-knowledge proofs for transaction processing. It is an infrastructure suitable for layer 1 and layer 2 blockchain networks that aim to adopt NIST-approved secure digital signature standards. PQScale's post-quantum signature compression technology enables NIST compliance with an easy-to-implement rollup solution.
Quantum threat to asymmetric cryptography and blockchains
Many modern asymmetric cryptosystems rely on the discrete logarithm problem, which is considered to be computationally intractable for modern computers. Under the current computing paradigm, private keys are assumed to be computationally secure, allowing users to freely distribute their public keys. Unfortunately, the one-way function protecting a private key given a public key is no longer secure against quantum computers with a sufficient number of qubits to break 2048-bit ECDSA. In fact there is a known quantum algorithm that reduces the time complexity of prime factorization from exponential to polynomial in the number of security bits used. This has prompted the National Institute of Standards and Technology (NIST) to investigate a new class of post-quantum digital signature algorithms, leading to the first international post-quantum cryptography standards announced on July 5, 2022.
Blockchain security is especially threatened by quantum computing, and chains will need to transition to post-quantum cryptographic standards to remain viable in the long term. The Elliptic Curve Digital Signature Algorithm (ECDSA) is the most widely used cryptographic algorithm implemented by blockchains today and has a severe weakness to a quantum attack. The security of ECDSA relies on the difficulty of the discrete logarithm problem, which is made computationally feasible by quantum computers running Shor's algorithm. For blockchains to remain secure and viable in the next era of computing, they will have no choice but to upgrade their security using post-quantum cryptography.
Implementing post-quantum cryptography in blockchains has several downstream consequences, however. Signature sizes associated with the standardized post-quantum digital signature algorithms are much larger than those used in blockchains today. A recent review showed that the smallest post-quantum digital signatures are at least 21x and 24x larger than the signatures used in Bitcoin and Ethereum, respectively. Since every blockchain transaction needs to be signed with a digital signature, each transaction will occupy more space within a blockchain block. This means that there will be fewer transactions per block, which results in slower transaction speeds for users and higher gas fees to include their transactions into the highly competitive block. By implementing post-quantum cryptography in blockchains, we are effectively unscaling our blockchains. 
The smallest post-quantum digital signatures are at least 21x and 24x larger than the signatures used in Bitcoin and Ethereum.
How PQScale solves the problem
The general principle of PQScale is to aggregate the post-quantum digital signatures associated with multiple transactions in a block. This allows the blockchain to reduce the overhead cost of storing one digital signature per transaction, thereby significantly reducing the size of each block. This technique preserves the structure of all existing transaction data and simply replaces the digital signatures associated with each transaction with a single aggregate signature. 
With PQScale, transaction data is stored in the blockchain along with an aggregate signature instead of multiple individual signatures.
How does PQScale work?
PQScale develops a construction for post-quantum lattice-based digital signature algorithms by leveraging the zk-SNARKs. These algorithms are intended to be secure against attacks by both quantum and classical computers. Our aggregate signature is generated using the mathematical properties of a lattice-based digital signature algorithm consisting of a signature scheme with these three stages: key generation, signing function, and verify function. Falcon signature is one of the NIST-approved quantum-resistant lattice-based signature schemes in this form, and we have optimized the algorithm for it. The algorithm uses the Falcon signature scheme and involves checking the range of the signatures and verifying that the sum of the aggregate signature components is equal to the sum of the products of the transaction data and corresponding public keys. This work may be generalized to other lattice-based signature schemes.
To understand how we construct the algorithms in PQScale, please consult the PQScale research paper.
Results of signature size compression
In practice, the size of the aggregate signature for 1722 Falcon signatures is about 94 KB, which is less than 9% of the original size of all 1722 signatures. Moreover, the factor of reduction improves as the number of signatures aggregated increases. This means that more space is saved with more signatures included in an aggregate signature. For example, when aggregating 4096 signatures, the aggregate signature is only 5% of the unaggregated signatures.
If we try to analyze the Bitcoin ledger size with different post-quantum signature schemes, we can find that PQScale enables post-quantum security and avoids the explosions in signatures and ledger sizes. 
PQScale enables post-quantum security and avoids the explosions in signatures and blockchain ledger sizes.
A block explorer demonstrating PQScale
As quantum computing continues to advance, the need for post-quantum cryptography to secure blockchain networks becomes increasingly important. Here we have a demo website of the latest post-quantum blockchain explorer that showcases the integration of PQScale into blockchain to display the potential of post-quantum tech in enhancing blockchain security.
This blockchain explorer demonstrates the innovative technique of aggregate signature in post-quantum signature schemes, which provides a unique way to visualize the aggregate signature of multiple transactions at once. By exploring this demo website, users can gain a deeper understanding of how PQScale can enhance the security and efficiency of a post-quantum blockchain and its potential to transform the blockchain landscape. 
To access the demo block explorer, please visit: https://pqscale.btq.com/
Aggregate Signature Service
PQScale can assist in even more scenarios with the APIs, which are integrated as Aggregate Signature Service. Any blockchain network, dApp, bridging protocol, stablecoin architecture or other software system can get access to the quantum-resistant digital signature compression technology within their own datacenter or via cloud services. We're extremely excited to partner with teams interested in switching to post-quantum systems with PQScale to achieve scaling and security. Please feel free to reach out to us at desk@btq.com if you'd like to get involved early! 
🇨🇦 CBOE CA: BTQ
🇺🇸 NASDAQ: BTQ
🇩🇪 FRA: NG3
Subscribe for monthly quantum, cryptography, and BTQ news delivered straight to your inbox.
Products
OSS
QPoW
QRiNG
QCIM
QSSN
Company
About
Team
Careers
Contact
Investor Relations
Resources
Company Blog
Research Insights
Podcast
Media Kit
Quantum 101
BTQ Technologies Corp.
Privacy Policy | All rights reserved.