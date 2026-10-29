# The Security Performance Analysis of Blockchain System Based on Post-Quantum Cryptography – A Case of Cryptocurrency Exchanges - World Scientific Publishing

- **ID**: `8318b502-f97d-4e6a-917f-e3a93d8f8098`
- **Tipo de Fuente**: `SOURCE_TYPE_PDF`
- **URL**: [https://www.worldscientific.com/doi/pdf/10.1142/S2196888825500204](https://www.worldscientific.com/doi/pdf/10.1142/S2196888825500204)

---

## Contenido Extraído / Texto Completo

The Security Performance Analysis of Blockchain System 
Based on Post-Quantum Cryptography | A Case of 
Cryptocurrency Exchanges 
Abel C. H. Chen 
Information & Communications Security Laboratory, 
Chunghwa Telecom Laboratories 
No. 99, Dianyan Road, Yangmei District, Taoyuan 326, Taiwan chchen.scholar@gmail.com 
Accepted 6 September 2025 
Published 26 September 2025 
The current blockchain system for cryptocurrency exchanges primarily employs elliptic curve cryptography (ECC) for generating key pairs in wallets, and elliptic curve digital signature 
algorithms (ECDSA) for generating signatures in transactions. Consequently, with the matu-
ration of quantum computing technology, the current blockchain system faces the risk of 
quantum computing attacks. Quantum computers may potentially counterfeit signatures produced by ECDSA. Therefore, this study analyzes the vulnerabilities of the current blockchain 
system to quantum computing attacks and proposes a post-quantum cryptography (PQC)-
based blockchain system to enhance security by addressing and improving each identi¯ed weakness. Furthermore, this study proposes PQC-based wallets and PQC-based transactions, 
utilizing PQC digital signature algorithms to generate PQC-based signatures for the inputs in 
PQC-based transactions, thereby preventing signatures from being counterfeited by quantum 
computing. Experimental results demonstrate that the e±ciency of the Module-Lattice-Based Digital Signature Algorithm (ML-DSA), a PQC digital signature algorithm, in producing 
wallets, generating signatures, and verifying signatures surpasses that of ECDSA in the current 
blockchain system. Furthermore, the ML-DSA also exhibits a higher security level. 
Keywords: Blockchain; post-quantum cryptography; performance analysis. 
1. Introduction 
In recent years, with the widespread adoption of blockchain systems and technolo-
gies, they have been extensively applied in various ¯elds. The Institute of Electrical 
and Electronics Engineers (IEEE) has furthered this integration by establishing 
multiple standards post-2020. These standards encompass diverse domains, includ-
ing E-commerce transaction evidence collecting (IEEE Standard 3802-2022),1 
This is an Open Access article published by World Scienti¯c Publishing Company. It is distributed under 
the terms of the Creative Commons Attribution 4.0 (CC BY) License, which permits use, distribution and 
reproduction in any medium, provided the original work is properly cited. 
OPEN ACCESS 
Vietnam Journal of Computer Science 
(2025) 1–30 #.c The Author(s) 
DOI: 10.1142/S2196888825500204 
1
electronic contracts (IEEE Standard 3801-2022),2 supply chain ¯nance (IEEE 
Standard 2418.7-2021),3 digital asset management (IEEE Standard 2418.10-2022),4 
E-invoice business (IEEE Standard 2142.1-2021),5 carbon trading applications (IEEE 
Standard 3218-2022),6 cryptocurrency exchanges (IEEE Standard 2140.1-2020),7 
among others. 
While blockchain systems o®er a decentralized architecture and ensure the 
undeniable authenticity and integrity of transactions through cryptographic tech-
niques, the digital signature algorithms (DSAs) in most blockchain systems are still 
based on elliptic curve cryptography (ECC).8 However, with the maturation of 
quantum computing technology, ECC faces the risk of being compromised,9 enabling 
attackers with quantum computing capabilities to get ECC private keys and coun-
terfeit legitimate signatures. Consequently, some blockchain systems have begun 
adopting post-quantum cryptography (PQC) methods to enhance security, including 
blockchain systems based on lattice-based cryptography10 and hash-based cryp-
tography.11 Additionally, the National Institute of Standards and Technology 
(NIST) in the United States has been soliciting PQC since 2016 and has formulated 
several PQC algorithms, including a key encapsulation mechanism (KEM) algorithm 
(i.e. CRYSTALS-Kyber) and DSAs (e.g. CRYSTALS-Dilithium, Falcon, and 
SPHINCS+).12 
In light of enhancing the resistance of blockchain systems against quantum 
computing attacks, this study aims to analyze the cryptographic methods currently 
employed within existing blockchain systems and assess their capability to withstand 
quantum computing attacks. Furthermore, this study endeavors to integrate PQC 
methods, which have been endorsed as standards by the NIST of the United States, 
into blockchain systems, followed by a comparative analysis of system performance. 
The main contributions of this study include: 
. Designing and implementing a blockchain system based on PQC; 
. Verifying and comparing the performance of various PQC standards within 
blockchain systems; 
. Validating and comparing the performance of multiple Proof of Work (PoW) 
parameters within blockchain systems. 
This paper is divided into ¯ve sections. Section 2 discusses the current state of 
blockchain systems and the data structures within blockchain systems, and Sec. 3 
discusses standardization processes of PQC in detail. Section 4 proposes a block-
chain system based on PQC, elaborating on the data structures and providing 
case illustrations. Section 5 experimentally compares the proposed solutions, 
discussing aspects such as e±ciency in wallet generation, e±ciency in signature 
generating, e±ciency in signature veri¯cation, and security analysis of PoW. 
Finally, Sec. 6 concludes the contributions of this study and explores future 
research directions. 
2 A. C. H. Chen
2. The Related Work of Blockchain Systems 
This study primarily draws upon the implementation of a blockchain system by 
Kuznetsov,13 building upon and enhancing its foundational aspects. Section 2.1 
initially elucidates the current state of blockchain systems, delineating the data 
structures of wallets, transactions, blocks, and blockchains, along with the crypto-
graphic techniques employed. Furthermore, Sec. 2.2 discusses the existing PoW 
methods and their security considerations. 
2.1. The data structure of blockchain system 
This subsection introduces the data structures and operational principles of wallets, 
transactions, blocks, and blockchains. 
2.1.1. Wallet 
When generating a wallet, a key pair based on ECC is primarily generated, com-
prising an ECC-based private key and an ECC-based public key, as depicted in 
Fig. 1. Subsequently, during transactions, the ECC-based private key is utilized to 
generate a signature for the transaction content. When other users wish to verify the 
validity of the transaction, they can utilize the ECC-based public key to verify 
the signature. Speci¯cally, the wallet address will be derived from the hash value of 
the ECC-based public key. 
2.1.2. Transaction 
The contents of a transaction mainly comprise the transaction ID, the inputs of the 
transaction, the outputs of the transaction, and the generation time of the trans-
action, as illustrated in Fig. 2. 
The inputs of the transaction refer to the source of the cryptocurrency owned by 
the cryptocurrency holder, which is obtained from previous transactions and may 
stem from multiple past transactions. Therefore, the inputs of the transaction con-
tain multiple inputs, and when transferring cryptocurrency to another user, 
the cryptocurrency holder must use their ECC-based private key to generate an 
ECC-based signature for each input. Each input includes the transaction ID, the 
ECC-based signature, and the ECC-based public key. 
The outputs of the transaction refer to the status of the cryptocurrency for both 
parties after the transfer from one cryptocurrency holder to another. For instance, 
Fig. 1. Wallet. 
The Security Performance Analysis of Blockchain System Based on Post-Quantum Cryptography 3
the outputs of the transaction include the cryptocurrency holder before the trans-
action and the cryptocurrency holder after the transaction, resulting in multiple 
outputs. Each output contains the value and the hash value of the ECC-based public 
key corresponding to the cryptocurrency holder (i.e. the wallet address). 
2.1.3. Block 
In a blockchain system, when conducting transactions, it is necessary to place the 
transactions into a block and generate the blockchain. In this subsection (Sec. 2.1.1), 
we introduce the data structure of a block. Furthermore, in the subsequent 
Fig. 2. Transaction. 
4 A. C. H. Chen
subsection (Sec. 2.1.4), we discuss the blockchain. A block comprises a block hash, 
the previous block hash, a set of transactions, the generation time of the block, and a 
nonce, as depicted in Fig. 3. 
When a transaction occurs, it is added to the \Transactions" ¯eld of a new block, 
and the timestamp of block generation is set. The \Previous Block Hash" ¯eld of this 
new block is then set to the hash value of the preceding block, thus forming the 
blockchain. After setting the values of the aforementioned ¯elds, for the sake of 
integrity veri¯cation, the hash value of the block content is computed. To enhance 
security, a PoW is performed by setting a target di±culty level, denoted as L. The 
hash value obtained after computing the hash of the block content r times is used as 
the block hash. The detailed calculation of the PoW is explained in Sec. 2.2. 
2.1.4. Blockchain 
In a blockchain system, each block stores a block hash and a previous block hash, 
forming the blockchain by pointing to the hash of the previous block. Thus, con-
sidering the ith block as an example, the \Block Hash" ¯eld stores the hash value of 
the ith block, and the \Previous Block Hash" ¯eld stores the hash value of the 
ði 1Þth block, as illustrated in Fig. 4. 
When a user wants to verify the integrity of any block on the blockchain, they can 
obtain the block content and compare the hash value obtained after computing the 
hash of the block content r times with the value in the \Block Hash" ¯eld. If they 
match, it indicates that the content has not been tampered with. Therefore, through 
the blockchain, the integrity of each block on the chain can be con¯rmed, thereby 
establishing the authenticity of the transactions within the block. 
2.2. Proof of work 
To establish block integrity, the process primarily relies on the computation of PoW, 
commonly known as mining, as illustrated in Fig. 5. Assuming the block content is 
Fig. 3. Block. 
The Security Performance Analysis of Blockchain System Based on Post-Quantum Cryptography 5
denoted as b, the hash function is represented by HashðbÞ, and executing the hash 
function r times is denoted as HashrðbÞ, with a target di±culty level denoted as L. 
Initially, the block content b is obtained, and then the hash value HashðbÞ of the 
block content is computed. It is checked whether the ¯rst L bits of the hash value are 
all zeros. If not, the hash value is hashed again until the ¯rst L bits are all zeros. Upon 
termination, the value of r, representing the number of hash function executions, is 
determined, such that HashrðbÞ satis¯es the condition where the ¯rst L bits are all 
zeros. This value of r is then set in the \Nonce" ¯eld. 
2.3. Security issues 
As Shor's quantum algorithm has been proven to factor large integers and solve 
discrete logarithm problems in polynomial time,9 the advancement of quantum 
computing hardware14 is expected to enable cryptanalysis of cryptographic methods 
based on these problems. These methods, collectively referred to as quantum 
vulnerable cryptography (QVC), include RSA and ECC. Consequently, it is neces-
sary to identify and evaluate the use of QVC methods within current blockchain 
systems and to replace them with post-quantum cryptographic (PQC) alternatives. 
Fig. 4. Blockchain. 
Fig. 5. Proof of work. 
6 A. C. H. Chen
In blockchain systems, cryptographic applications primarily involve digital 
signatures and hash functions. Since widely adopted platforms such as Bitcoin and 
Ethereum currently rely on the Elliptic Curve Digital Signature Algorithm 
(ECDSA),15 which is classi¯ed as a QVC method, they lack resistance to quantum 
attacks.16 Therefore, it is essential to replace ECDSA with quantum-resistant digital 
signature schemes, such as the Module-Lattice-Based Digital Signature Algorithm 
(ML-DSA)17 or the Stateless Hash-Based Digital Signature Algorithm (SLH-DSA).18 
Regarding hash functions, Bitcoin utilizes Secure Hash Algorithms-2 (SHA-2),19 
while Ethereum uses SHA-3.20 Both SHA-2 and SHA-3 are recognized by NIST as 
secure against quantum cryptanalysis and resistant to collision attacks.21 As such, 
the hash functions employed in these systems are considered to provide su±cient 
security. 
In light of the above, the following sections examine the components within 
blockchain systems that require modi¯cation, speci¯cally addressing the resilience 
against quantum computing attacks with respect to wallets, transactions, blocks, 
and the associated proof-of-work mechanisms in existing blockchain architectures. 
(1) Wallets: Existing blockchain system wallets primarily rely on ECC-based 
private and ECC-based public keys, thus potentially susceptible to quantum 
computing attacks. Consequently, the current blockchain system wallets possess 
quantum-vulnerable weaknesses. 
(2) Transactions: As transactions in existing blockchain systems predominantly 
utilize ECC-based signatures, they too may face vulnerability to quantum 
computing attacks, making them susceptible to counterfeit ECC-based sig-
natures. Thus, transactions in current blockchain systems exhibit weaknesses 
against quantum computing. 
(3) Blocks, Blockchain, Proof of Work: In current blockchain systems, blocks 
and their PoW are constructed based on hash functions (e.g. SHA-256). As 
quantum computing attacks are currently unable to break secure hash algo-
rithms,12 these systems demonstrate resilience against quantum computing. 
Consequently, the primary consideration for PoW lies in the di±culty target 
length, where shorter lengths imply lower security and higher susceptibility 
to successful attacks, while longer lengths entail longer computation times (i.e. 
mining time) and require more computational resources. 
3. The Related Work of Post-Quantum Cryptography 
This section presents a review of related work concerning the standardization process 
and migration timeline of post-quantum cryptography. 
3.1. The standardization process of post-quantum cryptography 
In the third-round report released in September 2022, the NIST has led the evalu-
ation and selection of PQC algorithms for standardization. The evaluation process 
The Security Performance Analysis of Blockchain System Based on Post-Quantum Cryptography 7
has focused on the following three criteria for selecting algorithms as PQC 
standards12: 
(1) Security: The primary and most critical criterion is the ability of an algorithm 
to resist both quantum and classical cryptographic attacks. Algorithms found to 
have security vulnerabilities are eliminated from consideration. 
(3) Cost and Performance: This includes evaluation of computational e±ci-
ency— such as the time required for key pair generation, encryption/decryption, 
and signing/verifying — as well as data size, including key length, ciphertext 
length, and signature size. In particular, for KEMs, which may require ephemeral 
key pair generation in transport layer security protocols and similar applications, 
performance related to key generation and encryption/decryption is emphasized. 
For DSAs, which typically use static key pairs in practical applications, the focus 
is placed on signature generation and veri¯cation times. 
(3) Algorithmic and Implementation Characteristics: This includes °exibi-
lity, simplicity, and ease of integration into existing systems and applications. 
Based on evaluations across the three criteria, lattice-based cryptographic approa-
ches have demonstrated strong security and relatively superior overall e±ciency 
compared to other PQC methods. As a result, lattice-based cryptography has 
emerged as one of the primary directions for post-quantum cryptographic 
standardization. The NIST announced the selection of one KEM algorithm, 
CRYSTALS-Kyber, and three digital signature algorithms  CRYSTALS-
Dilithium, Falcon, and SPHINCS+  as candidates for standardization.12 Subse-
quently, in August 2024, NIST published three Federal Information Processing 
Standards (FIPS) documents: 
(1) FIPS 203 for the KEM standard, titled Module-Lattice-Based Key Encapsu-
lation Mechanism (ML-KEM), based on CRYSTALS-Kyber22; 
(2) FIPS 204 for the digital signature standard, titled Module-Lattice-Based 
Digital Signature Algorithm (ML-DSA), based on CRYSTALS-Dilithium17; 
(3) FIPS 205 for the digital signature standard, titled Stateless Hash-Based Digital 
Signature Algorithm (SLH-DSA), based on SPHINCS+.18 
For KEMs, ML-KEM is lattice-based. To diversify the underlying cryptographic 
foundations, NIST indicated in its fourth-round report (published in March 2025) 
the selection of an additional KEM candidate, HQC (Hamming Quasi-Cyclic), which 
is based on code-based cryptography, for standardization.23 For DSAs, both ML-
DSA and Falcon are lattice-based. However, NIST had already selected the hash-
based SPHINCS+ algorithm during the third round and ¯nalized it as the SLH-DSA 
standard, ensuring variety in the cryptographic bases of standardized digital sig-
nature schemes. Table 1 summarizes the current standardized and candidate PQC 
algorithms, categorized by their core cryptographic primitives. The algorithm of 
Falcon, upon standardization, is expected to be o±cially named FN-DSA, short for 
8 A. C. H. Chen
FFT (Fast-Fourier Transform) over NTRU (Nth-degree Truncated polynomial Ring 
Unit)-Lattice-Based DSA. 
Although the Classic McEliece algorithm24 o®ers advantages such as fast 
encryption and decryption speeds25 as well as relatively short ciphertext lengths, it 
su®ers from a relatively long key pair generation time.26 This limitation makes it less 
suitable for applications requiring dynamic generation of ephemeral key pairs.23 As a 
result, in the fourth-round PQC report, the NIST did not select Classic McEliece as a 
candidate for standardization. However, due to its favorable performance char-
acteristics in other aspects, Classic McEliece remains a viable candidate and may be 
considered for standardization by the International Organization for Standardization 
(ISO).23 
3.1.1. The standardization process of additional digital signature schemes 
The currently selected digital signature algorithm standards (i.e. ML-DSA, SLH-
DSA, and FN-DSA) tend to produce relatively large signature sizes, which limits 
their applicability in scenarios requiring short signature lengths. To address this 
limitation, the NIST initiated the evaluation of additional digital signature schemes 
starting in 2023. Following the ¯rst round of evaluation, NIST identi¯ed 14 candi-
date algorithms for advancement to the second round, as outlined in the ¯rst-round 
report of additional digital signature schemes. It is anticipated that this process may 
ultimately lead to the selection of an additional digital signature standard featuring 
shorter signature lengths and faster signing performance.27 
3.2. The migration timeline of post-quantum cryptography 
In response to the ongoing advancements in quantum computing hardware and 
quantum algorithm technologies, the NIST released a draft roadmap in November 
2024 outlining the transition to PQC standards. This draft explicitly speci¯es the 
planned deprecation and eventual prohibition timelines for cryptographic schemes 
based on RSA and ECC.28 
The proposed timelines for the deprecation and disallowance of existing key 
establishment standards are summarized in Table 2,28 while those for digital sig-
nature standards are presented in Table 3.28 According to the draft, RSA-2048 
corresponds to a security strength of 112 bits, and RSA-3072 to 128 bits. Among 
elliptic curve schemes, Curve P-224 corresponds to 112-bit security, and Curve P-256 
to 128-bit security.29 
Table 1. Standardized algorithms and selected algorithms of PQC. 
Category KEM DSA 
Lattice-based ML-KEM (FIPS 203) ML-DSA (FIPS 204) and Falcon (to be standardized) 
Hash-based SLH-DSA (FIPS 205) 
Code-based HQC (to be standardized) 
The Security Performance Analysis of Blockchain System Based on Post-Quantum Cryptography 9
The NIST recommends initiating the migration toward the currently established 
PQC standards. These include the KEM standard (i.e. ML-KEM), as well as 
the DSA standards (i.e. ML-DSA and SLH-DSA). The associated parameters and 
corresponding security strengths are summarized in Table 4.28 
It is anticipated that, upon completion of the standardization process for FN-DSA 
and HQC, additional algorithms will be incorporated into the suite of PQC 
standards. 
3.3. Discussions 
As NIST has conducted a global call for PQC algorithm submissions and selected 
those with strong security and high performance for standardization as U.S. federal 
government standards, it is anticipated that future global development and imple-
mentation e®orts will align with these selected algorithms. While other high-quality 
Table 2. The deprecation and disallowance of existing key establishment standards. 
Algorithm and parameter Security strength Timeline 
RSA-2048 112 bits deprecation from 2030 and disallowance from 2035 
RSA-3072 (and longer key lengths)  128 bits disallowance from 2035 
ECDH P-224 112 bits deprecation from 2030 and disallowance from 2035 
ECDH P-256 (and longer key lengths)  128 bits disallowance from 2035 
Table 3. The deprecation and disallowance of existing digital signature standards. 
Algorithm and parameter Security strength Timeline 
RSA-2048 112 bits deprecation from 2030 and disallowance from 2035 
RSA-3072 (and longer key lengths)  128 bits disallowance from 2035 
ECDSA P-224 112 bits deprecation from 2030 and disallowance from 2035 
ECDSA P-256 (and longer key lengths)  128 bits disallowance from 2035 
Table 4. The recommended PQC algorithms. 
Algorithm Parameter Security strength 
ML-KEM ML-KEM-512 128 bits 
ML-KEM ML-KEM-768 192 bits ML-KEM ML-KEM-1024 256 bits 
ML-DSA ML-DSA-44 128 bits 
ML-DSA ML-DSA-65 192 bits 
ML-DSA ML-DSA-87 256 bits SLH-DSA SHA2-128 128 bits 
SLH-DSA SHAKE-128 128 bits 
SLH-DSA SHA2-192 192 bits SLH-DSA SHAKE-192 192 bits 
SLH-DSA SHA2-256 256 bits 
SLH-DSA SHAKE-256 256 bits 
10 A. C. H. Chen
algorithms may not be included in the standardized list, this study focuses solely on 
those chosen as U.S. federal standards, taking into account anticipated industry 
adoption trends. 
Furthermore, in blockchain system applications, the primary cryptographic 
functions involve DSAs and hash functions, with limited use of KEMs. More 
speci¯cally, KEMs are typically associated with protocols like Transport Layer 
Security (TLS) protocol,30 whereas blockchain systems are expected to rely more 
heavily on digital signatures and hashing. In light of this, this study concentrates on 
DSAs and hash functions, without an in-depth discussion of KEMs. Additionally, it 
is noted that in blockchain wallet generation, the computation time for key pair gen-
eration is typically a one-time cost. The ongoing computational focus lies in the signing 
and veri¯cation processes. Therefore, the computation times of signature generation 
and signature veri¯cation are of greater relevance for performance evaluation in such 
applications. 
4. The Proposed Blockchain System Based on Post-Quantum 
Cryptography 
To enhance the resistance of blockchain systems against quantum computing 
attacks, this study proposes a blockchain system based on PQC, aiming to improve 
security by incorporating PQC methods into the aspects identi¯ed as vulnerable to 
quantum computing attacks in Sec. 2.3. Section 4.1 describes the data structure of 
the proposed blockchain system, while Sec. 4.2 provides case illustrations. 
4.1. The proposed data structure of blockchain system 
This subsection primarily o®ers PQC solutions for wallets and transactions, elabo-
rated in Secs. 4.1.1 and 4.1.2, respectively. Section 4.1.3 describes security con-
siderations and improvement methods for blocks, blockchains, and PoW. To clearly 
illustrate the modi¯cations proposed in this study to the blockchain system, the 
changes are highlighted in red within the architectural diagram, thereby enabling 
readers to better understand the contributions of this work. 
4.1.1. Post-quantum cryptography-based wallet 
The proposed PQC-based wallet mainly consists of a PQC-based private key and a 
PQC-based public key, as illustrated in Fig. 6. When generating a PQC-based wallet, 
a key pair based on PQC is generated, comprising a PQC-based private key and a 
PQC-based public key. Subsequently, during transactions, the PQC-based private 
key can be used to generate a signature for the transaction content. When other users 
wish to verify the validity of the transaction, they can utilize the PQC-based public 
key to verify the signature. Speci¯cally, the wallet address will be derived from the 
hash value of the PQC-based public key. 
The Security Performance Analysis of Blockchain System Based on Post-Quantum Cryptography 11
4.1.2. Post-quantum cryptography-based transaction 
Figure 7 depicts the data structure of PQC-based transactions proposed in this 
study. It primarily comprises a PQC-based signature and a PQC-based public key, 
detailed as follows. 
Fig. 6. PQC-based wallet. 
Fig. 7. PQC-based transaction. 
12 A. C. H. Chen
To prevent signature counterfeiting by quantum computing, the signatures used 
in transactions must be based on PQC. Each transaction input is signed using a 
PQC-based signature generated by the PQC-based private key in the PQC-based 
wallet. Furthermore, the corresponding PQC-based public key is stored alongside 
each transaction input. In the transaction outputs, the modi¯cation is made 
accordingly, as the wallet address in the PQC-based wallet is already the hash value 
of the PQC-based public key. 
4.1.3. Block, blockchain, and proof of work 
As the blocks, blockchains, and PoW in current blockchain systems possess resilience 
against quantum computing, there is currently no need to modify cryptographic 
algorithms. However, the di±culty target length, denoted as L, will be a primary 
factor to consider. Therefore, in Sec. 5, this study compares the e±ciency of di®erent 
di±culty target lengths. 
Furthermore, considering that the PoW primarily involves computing the hash 
value when the ¯rst L bits are all zeros, this study also explores the probabilities of 
achieving \all zeros" and \all ones" for the ¯rst L bits. While the probabilities of each 
bit being 0 or 1 in the hash value generated by the hash function should ideally follow 
a uniform distribution, in practical computations, these probabilities may not be 
perfectly uniform. Therefore, in Sec. 5.5, this study explores secure PoW algorithms. 
4.2. Case study 
This subsection provides a case study illustrating the blockchain system proposed in 
this study, demonstrating the operation process of PQC-based wallets, PQC-based 
transactions, blocks, and blockchains. 
4.2.1. Scenario 
In the scenario, suppose there are four users (namely Alice, Bob, Cara, and David) 
conducting cryptocurrency exchanges. The initial state assumptions and transaction 
scenarios are outlined as follows, with the details of the transactions and their 
relation to blocks and blockchains explained in Sec. 4.2.2. 
Initial State Assumptions: 
(1) Alice has acquired 5 units of cryptocurrency in the transaction with Transaction 
ID ta, and Alice's balance is only 5 units. 
(2) Cara has acquired 7 units of cryptocurrency in the transaction with Transaction 
ID tc, and Cara's balance is only 7 units. 
(3) Both Bob and David have a balance of 0 units of cryptocurrency. 
Transaction Scenarios: 
(1) Transaction ID tj: Alice transfers 5 units of cryptocurrency to Bob. 
The Security Performance Analysis of Blockchain System Based on Post-Quantum Cryptography 13
(2) Transaction ID tjþ1: Cara transfers 7 units of cryptocurrency to Bob. 
(3) Transaction ID tjþ2: Bob transfers 12 units of cryptocurrency to David. 
4.2.2. Illustration of the proposed blockchain system 
Based on the scenario described in Sec. 4.2.1, PQC-based transactions depicted in 
Fig. 8 and the proposed blockchain depicted in Fig. 9 will be sequentially generated, 
as elaborated below. 
The PQC-based transactions generated in the transaction scenarios of the case 
study are explained as follows: 
(1) Transaction ID tj (Alice transfers 5 units of cryptocurrency to Bob): 
Since Alice has acquired 5 units of cryptocurrency in the transaction with Trans-
action ID ta, she can transfer the 5 units to Bob using the cryptocurrency obtained in 
Transaction ta. Therefore, to create the transaction with Transaction ID tj, a single 
input is set in the transaction input ¯eld, where the \Transaction ID" ¯eld is ta. In 
the \PQC-based Signature" ¯eld of this input, Alice's signature signed by her PQC-
based private key is stored to con¯rm that the transaction is indeed conducted by 
Fig. 8. The PQC-based transactions in the case study. 
14 A. C. H. Chen
Alice. Furthermore, Alice's PQC-based public key is stored in the \PQC-based 
Public Key" ¯eld for subsequent signature veri¯cation. 
Regarding the outputs, as it primarily a®ects Alice's and Bob's wallets, the 
transaction outputs include 2 entries. In the ¯rst output entry, the \PQC-based 
Public Key Hash" ¯eld represents Alice's wallet address, and the \Amount" ¯eld is 0, 
indicating that Alice's wallet balance is 0 units after this transaction. In the second 
output entry, the \PQC-based Public Key Hash" ¯eld represents Bob's wallet 
address, and the \Amount" ¯eld is 5, indicating that Bob receives 5 units in his 
wallet after this transaction. 
(2) Transaction ID tjþ1 (Cara transfers 7 units of cryptocurrency to Bob): 
Since Cara has acquired 7 units of cryptocurrency in the transaction with 
Transaction ID tc, she can transfer the 7 units to Bob using the cryptocurrency 
obtained in Transaction tc. Therefore, to create the transaction with Transaction 
tjþ1, a single input is set in the transaction input ¯eld, where the \Transaction ID" 
¯eld is tc. In the \PQC-based Signature" ¯eld of this input, Cara's signature signed 
by her PQC-based private key is stored to con¯rm that the transaction is indeed 
conducted by Cara. Furthermore, Cara's PQC-based public key is stored in the 
\PQC-based Public Key" ¯eld for subsequent signature veri¯cation. 
Regarding the outputs, as it primarily a®ects Cara's and Bob's wallets, the 
transaction outputs include 2 entries. In the ¯rst output entry, the \PQC-based 
Public Key Hash" ¯eld represents Cara's wallet address, and the \Amount" ¯eld is 0, 
indicating that Cara's wallet balance is 0 units after this transaction. In the second 
output entry, the \PQC-based Public Key Hash" ¯eld represents Bob's wallet 
address, and the \Amount" ¯eld is 7, indicating that Bob receives 7 units in his 
wallet after this transaction. 
(3)Transaction ID tjþ2 (Bob transfers 12 units of cryptocurrency toDavid): 
As Bob transfers 12 units of cryptocurrency to David, and Bob does not have a 
single transaction record of receiving more than 12 units, Bob needs to combine 
multiple transactions (i.e. Transaction tj and Transaction tjþ1) to have 12 units 
available for transfer to David. To create the transaction with Transaction tjþ2, 
multiple inputs are included in the transaction input. In the ¯rst input, the 
\Transaction ID" ¯eld is tj, and Bob's signature signed by his PQC-based private 
Fig. 9. The proposed blockchain system in the case study. 
The Security Performance Analysis of Blockchain System Based on Post-Quantum Cryptography 15
key is stored in the \PQC-based Signature" ¯eld to con¯rm that the transaction is 
indeed conducted by Bob. Furthermore, Bob's PQC-based public key is stored in the 
\PQC-based Public Key" ¯eld for subsequent signature veri¯cation. In the second 
input, the \Transaction ID" ¯eld is tjþ1, and similar to the ¯rst input, another 
Bob's signature signed by his PQC-based private key is generated, and respective 
PQC-based signatures and public keys are stored. 
Regarding the outputs, as it primarily a®ects Bob's and David's wallets, the 
transaction outputs include 2 entries. In the ¯rst output entry, the \PQC-based 
Public Key Hash" ¯eld represents Bob's wallet address, and the \Amount" ¯eld is 0, 
indicating that Bob's wallet balance is 0 units after this transaction. In the second 
output entry, the \PQC-based Public Key Hash" ¯eld represents David's wallet 
address, and the \Amount" ¯eld is 12, indicating that David receives 12 units in his 
wallet after this transaction. 
Explanation of the quantum-based blockchain generated from the transaction 
scenarios in the case study is as follows: 
(1) Block i (Alice transfers 5 units of cryptocurrency to Bob): 
When the transaction with Transaction ID tj occurs, Block i is generated to verify 
the integrity of Transaction tj. In the \Previous Block Hash" ¯eld of Block i, the 
hash of Block ði 1Þ is stored, pointing to the previous block and forming the 
blockchain. In the \Transactions" ¯eld, Transaction tj is stored, and the 
\Generation Time" ¯eld is set to the time when the block was produced. Subse-
quently, based on the PoW algorithm, the block hash and nonce ri are generated 
from the block content. 
(2) Block ðiþ 1Þ (Cara transfers 7 units of cryptocurrency to Bob): 
When the transaction with Transaction ID tjþ1 occurs, Block ðiþ 1Þ is generated to 
verify the integrity of Transaction tjþ1. Similar to the previous procedure, in the 
\Previous Block Hash" ¯eld of Block ðiþ 1Þ, the hash of Block i is stored. In the 
\Transactions" ¯eld, Transaction tjþ1 is stored, and the \Generation Time" ¯eld is 
set to the time when the block was produced. Subsequently, appropriate values for 
the \Block Hash" and \Nonce" ¯elds are generated according to the PoW algorithm. 
(3) Block ðiþ 2Þ (Bob transfers 12 units of cryptocurrency to David): 
When the transaction with Transaction ID tjþ2 occurs, Block ðiþ 2Þ is generated to 
verify the integrity of Transaction tjþ2. Similar to the previous procedure, in the 
\Previous Block Hash" ¯eld of Block ðiþ 2Þ, the hash of Block ðiþ 1Þ is stored. In the \Transactions" ¯eld, Transaction tjþ2 is stored, and the \Generation Time" ¯eld 
is set to the time when the block was produced. Subsequently, appropriate values for 
the \Block Hash" and \Nonce" ¯elds are generated according to the PoW algorithm. 
5. Performance Evaluation and Experimental Result Discussions 
This section conducts a security and performance evaluation of the proposed PQC-
based blockchain system. Section 5.1 introduces the experimental environment, 
16 A. C. H. Chen
while Secs. 5.2, 5.3, and 5.4, respectively, compare the e±ciency of wallet generation, 
signature generation, and signature veri¯cation. Furthermore, Sec. 5.5 analyzes the 
security of relevant parameters in the PoW algorithm. Finally, Sec. 5.6 summarizes 
the experimental results and ¯ndings. 
5.1. Experimental environment 
In the experimental setup, the blockchain system implemented by Ref. 13 was 
rewritten in Java programming language as part of this research. The development of 
the proposed blockchain system based on post-quantum cryptography was carried 
out on a notebook (i.e. local environment) and an instance of Amazon EC2 r5.xlarge 
(i.e. cloud environment).31 The detailed speci¯cations of the notebook are as follows: 
CPU Intel(R) Core(TM) i7-10510U, 16 GB memory, OpenJDK 18.0.2.1, and 
Bouncy Castle Release 1.72 library. Furthermore, the detailed speci¯cations of the 
Amazon EC2 r5.xlarge are as follows: CPU Intel(R) Xeon(R) Platinum 8259CL, 32 
GB memory, OpenJDK 17.0.1, and Bouncy Castle Release 1.72 library. 
This study primarily compares the current blockchain system using the ECDSA32 
with PQC digital signature algorithms recognized as standards by the NIST, 
including ML-DSA.17 Falcon, and SLH-DSA.12 As of August 2024, CRYSTALS-
Dilithium has been standardized as the ML-DSA,17 and SPHINCS+ has been 
standardized as the SLH-DSA.18 Accordingly, this study adopts the ¯nal versions by 
removing the original implementations of CRYSTALS-Dilithium and SPHINCS+, 
and instead implements the ¯nal versions of ML-DSA and SLH-DSA. In addition, a 
comparison is conducted with MAYO, one of the candidate algorithms from the 
additional signature schemes.27 
To compare the computational e±ciency of various algorithms under di®erent 
security levels, this research adopts the security level standards speci¯ed by the 
NIST,33 which consist of ¯ve levels. Security levels are primarily used to measure the 
resistance of PQC algorithms to quantum computing attacks, di®ering from tradi-
tional security strength metrics.29 Therefore, cryptographic algorithms such as RSA 
and ECC, which lack resistance against quantum computing attacks, are directly 
labeled as \Insecure" in terms of security level classi¯cation. 
5.2. Wallet generation e±ciency comparison 
During the process of wallet generation, cryptographic key pairs are primarily 
produced, consisting of a private key and a corresponding public key. The compu-
tational time for wallet generation using various algorithms and their corresponding 
parameters is presented in Tables 5, 6, Figs. 10 and 11. From the experimental 
median results of wallet generation time, it is observed that although the ECDSA 
utilized in current blockchain systems can generate a wallet in the range of 0.444 
milliseconds to 1.409 milliseconds for the notebook and in the range of 0.510 milli-
seconds to 1.479 milliseconds for the Amazon EC2 r5.xlarge, it lacks resistance 
against quantum computing attacks, rendering its security level as \Insecure." 
The Security Performance Analysis of Blockchain System Based on Post-Quantum Cryptography 17
The ML-DSA algorithm o®ers parameter combinations with Security Levels 2, 3, 
and 5 (i.e. ML-DSA-44, ML-DSA-65, and ML-DSA-87), with wallet generation times 
ranging from 0.201 milliseconds to 0.676 milliseconds for the notebook and ranging 
from 0.159 milliseconds to 0.437 milliseconds for the Amazon EC2 r5.xlarge. This 
Table 5. Wallet generation time comparison on the notebook 
(unit: milliseconds). 
Algorithm Parameters Security level Mean Median 
ECDSA P-224 Insecure 0.491 0.444 
ECDSA32 P-256 Insecure 0.570 0.530 
ECDSA32 P-384 Insecure 1.186 1.093 ECDSA32 P-521 Insecure 1.550 1.409 
ML-DSA ML-DSA-44 2 0.207 0.201 
ML-DSA ML-DSA-65 3 0.443 0.473 ML-DSA ML-DSA-87 5 0.666 0.676 
SLH-DSA sha2-128f 1 4.445 4.505 
SLH-DSA sha2-192f 3 6.651 6.786 
SLH-DSA sha2-256f 5 14.028 12.395 SLH-DSA shake-128f 1 5.529 5.170 
SLH-DSA shake-192f 3 4.546 4.065 
SLH-DSA shake-256f 5 11.620 10.066 
Falcon Falcon 512 1 19.850 18.569 Falcon Falcon 1024 5 55.039 51.542 
MAYO 1 1 4.179 4.382 
MAYO 3 3 11.851 11.975 MAYO 5 5 26.967 28.449 
Table 6. Wallet generation time comparison on the Amazon 
EC2 r5.xlarge (unit: milliseconds). 
Algorithm Parameters Security level Mean Median 
ECDSA P-224 Insecure 0.538 0.510 
ECDSA32 P-256 Insecure 0.702 0.676 
ECDSA32 P-384 Insecure 1.085 1.064 
ECDSA32 P-521 Insecure 1.503 1.479 ML-DSA ML-DSA-44 2 0.166 0.159 
ML-DSA ML-DSA-65 3 0.297 0.290 
ML-DSA ML-DSA-87 5 0.443 0.437 
SLH-DSA sha2-128f 1 2.433 2.406 SLH-DSA sha2-192f 3 4.110 4.078 
SLH-DSA sha2-256f 5 10.794 10.711 
SLH-DSA shake-128f 1 3.539 3.512 SLH-DSA shake-192f 3 5.195 5.172 
SLH-DSA shake-256f 5 13.660 13.592 
Falcon Falcon 512 1 13.598 12.198 
Falcon Falcon 1024 5 35.998 32.492 MAYO 1 1 2.234 2.205 
MAYO 3 3 6.170 6.115 
MAYO 5 5 14.388 14.298 
18 A. C. H. Chen
algorithm provides higher security levels compared to the ECDSA used in current 
blockchain systems, with shorter wallet generation times. Furthermore, comparisons 
were made with the Falcon algorithm (i.e. parameter combinations Falcon 512 and 
Falcon 1024) the SLH-DSA (i.e. parameter combinations sha2-128f, sha2-192f, sha2-
256f, shake-128f, shake-192f, and shake-256f), and MAYO (i.e. parameter combi-
nations 1, 3, and 5). Although the Falcon and SLH-DSA o®er resistance against 
quantum computing attacks, their wallet generation times are signi¯cantly higher 
than those of the ECC-based algorithm and the ML-DSA algorithm. 
Fig. 10. Wallet generation time comparison on the notebook for Security Level 5 (unit: milliseconds). 
Fig. 11. Wallet generation time comparison on the Amazon EC2 r5.xlarge for Security Level 5 (unit: 
milliseconds). 
The Security Performance Analysis of Blockchain System Based on Post-Quantum Cryptography 19
5.3. Signature generation e±ciency comparison 
In the process of generating transactions, the main task is to generate signatures for 
transaction inputs using the private keys of the cryptocurrency owners. The com-
putation time for signature generation for each algorithm and its corresponding 
parameters is shown in Tables 7, 8, Figs. 12 and 13. From the experimental results, it 
Table 7. Signature generation time comparison on the notebook 
(unit: milliseconds). 
Algorithm Parameters Security level Mean Median 
ECDSA P-224 Insecure 0.472 0.432 ECDSA 
32 P-256 Insecure 0.562 0.524 
ECDSA 32 
P-384 Insecure 1.171 1.082 ECDSA 
32 P-521 Insecure 1.537 1.405 
ML-DSA ML-DSA-44 2 0.799 0.609 ML-DSA ML-DSA-65 3 1.612 1.255 ML-DSA ML-DSA-87 5 1.947 1.603 SLH-DSA sha2-128f 1 106.915 109.145 SLH-DSA sha2-192f 3 182.250 185.200 SLH-DSA sha2-256f 5 304.375 284.140 SLH-DSA shake-128f 1 133.708 128.785 SLH-DSA shake-192f 3 121.706 109.339 SLH-DSA shake-256f 5 245.355 213.836 Falcon Falcon 512 1 1.161 1.162 Falcon Falcon 1024 5 2.290 2.295 MAYO 1 1 8.367 8.774 MAYO 3 3 23.327 23.632 MAYO 5 5 52.304 55.161 
Table 8. Signature generation time comparison on the Amazon 
EC2 r5.xlarge (unit: milliseconds). 
Algorithm Parameters Security level Mean Median 
ECDSA P-224 Insecure 0.531 0.505 ECDSA 
32 P-256 Insecure 0.684 0.673 
ECDSA 32 
P-384 Insecure 1.077 1.065 ECDSA 
32 P-521 Insecure 1.499 1.483 
ML-DSA ML-DSA-44 2 0.622 0.493 ML-DSA ML-DSA-65 3 0.997 0.811 ML-DSA ML-DSA-87 5 1.207 1.026 SLH-DSA sha2-128f 1 58.786 58.482 SLH-DSA sha2-192f 3 112.298 111.524 SLH-DSA sha2-256f 5 233.097 231.647 SLH-DSA shake-128f 1 84.906 84.522 SLH-DSA shake-192f 3 137.952 137.110 SLH-DSA shake-256f 5 287.689 286.224 Falcon Falcon 512 1 0.824 0.796 Falcon Falcon 1024 5 1.626 1.619 MAYO 1 1 4.399 4.359 MAYO 3 3 12.099 12.026 MAYO 5 5 27.855 27.677 
20 A. C. H. Chen
is evident that although the ECDSA currently employed in blockchain systems yields 
signature generation times ranging from 0.432 milliseconds to 1.405 milliseconds for 
the notebook and ranging from 0.505 milliseconds to 1.483 milliseconds for the 
Amazon EC2 r5.xlarge, its security level is labeled as \Insecure." As each PQC 
algorithm possesses resistance against quantum computing attacks, a fair compari-
son among them can be observed at Security Level 5. The experimental outcomes 
reveal that ML-DSA, with the parameter set ML-DSA-87, has a signature generation 
time of 1.603 milliseconds for the notebook and 1.026 milliseconds for the Amazon 
EC2 r5.xlarge, Falcon, with the parameter set Falcon 1024, has a signature 
Fig. 12. Signature generation time comparison on the notebook for Security Level 5 (unit: milliseconds). 
Fig. 13. Signature generation time comparison on the Amazon EC2 r5.xlarge for Security Level 5 (unit: 
milliseconds). 
The Security Performance Analysis of Blockchain System Based on Post-Quantum Cryptography 21
generation time of 2.295 milliseconds for the notebook and 1.619 milliseconds for the 
Amazon EC2 r5.xlarge, and SLH-DSA, with the parameter set sha2-256f and shake-
256f, has a signature generation time of 284.140 milliseconds and 213.836 milli-
seconds for the notebook and 231.647 milliseconds and 286.224 milliseconds for the 
Amazon EC2 r5.xlarge. The signature generation time of MAYO-5 is 55.161 milli-
seconds for the notebook and 27.677 milliseconds for the Amazon EC2 r5.xlarge. 
Thus, it is evident that ML-DSA o®ers the fastest signature generation e±ciency at 
the same security level. Furthermore, it is noteworthy that ML-DSA with the pa-
rameter set ML-DSA-44 has a signature production time of 0.493 milliseconds on the 
Amazon EC2 r5.xlarge, which is shorter than that of the ECDSA (with parameter 
set P-256) and Falcon algorithm (with parameter set Falcon 512). In other words, 
ML-DSA (with parameter set ML-DSA-44) provides faster and more secure per-
formance compared to the ECDSA (with parameter set P-256) and Falcon algorithm 
(with parameter set Falcon 512). 
5.4. Signature veri¯cation e±ciency comparison 
During the process of verifying transactions, the main task is to validate the 
signature of each transaction input using the attached public key. The computation 
time for signature veri¯cation for each algorithm and its corresponding parameters is 
shown in Tables 9, 10, Figs. 14 and 15. From the experimental results, it can be 
observed that Falcon algorithm exhibits the shortest veri¯cation time for signatures, 
ranging from 0.116 milliseconds to 0.233 milliseconds for the notebook and ranging 
from 0.089 milliseconds to 0.180 milliseconds for the Amazon EC2 r5.xlarge. 
Table 9. Signature veri¯cation time comparison on the notebook (unit: milliseconds). 
Algorithm Parameters Security level Mean Median 
ECDSA P-224 Insecure 1.276 1.163 ECDSA32 P-256 Insecure 1.644 1.532 
ECDSA32 P-384 Insecure 3.283 3.041 
ECDSA32 P-521 Insecure 3.735 3.411 ML-DSA ML-DSA-44 2 0.213 0.204 
ML-DSA ML-DSA-65 3 0.414 0.446 
ML-DSA ML-DSA-87 5 0.678 0.688 
SLH-DSA sha2-128f 1 6.208 6.341 SLH-DSA sha2-192f 3 9.418 9.593 
SLH-DSA sha2-256f 5 7.746 6.882 
SLH-DSA shake-128f 1 7.668 7.268 
SLH-DSA shake-192f 3 6.316 5.682 SLH-DSA shake-256f 5 6.219 5.417 
Falcon Falcon 512 1 0.119 0.116 
Falcon Falcon 1024 5 0.234 0.233 MAYO 1 1 3.658 3.784 
MAYO 3 3 9.474 9.540 
MAYO 5 5 19.992 21.002 
22 A. C. H. Chen
Following closely, ML-DSA demonstrates the second shortest veri¯cation time for 
signatures, ranging from 0.204 milliseconds to 0.688 milliseconds for the notebook 
and ranging from 0.170 milliseconds to 0.446 milliseconds for the Amazon EC2 r5. 
xlarge. Both Falcon and ML-DSA o®er a more secure and shorter veri¯cation time 
for signatures compared to the ECDSA currently employed in blockchain systems, 
which ranges from 1.163 milliseconds to 3.411 milliseconds for the notebook and 
ranging from 1.326 milliseconds to 3.426 milliseconds for the Amazon EC2 r5.xlarge. 
Table 10. Signature veri¯cation time comparison on the 
Amazon EC2 r5.xlarge (unit: milliseconds). 
Algorithm Parameters Security level Mean Median 
ECDSA P-224 Insecure 1.386 1.326 
ECDSA32 P-256 Insecure 1.967 1.945 
ECDSA32 P-384 Insecure 2.863 2.834 ECDSA32 P-521 Insecure 3.463 3.426 
ML-DSA ML-DSA-44 2 0.177 0.170 
ML-DSA ML-DSA-65 3 0.280 0.272 ML-DSA ML-DSA-87 5 0.453 0.446 
SLH-DSA sha2-128f 1 3.536 3.516 
SLH-DSA sha2-192f 3 5.840 5.804 
SLH-DSA sha2-256f 5 6.044 6.007 SLH-DSA shake-128f 1 4.976 4.953 
SLH-DSA shake-192f 3 7.257 7.209 
SLH-DSA shake-256f 5 7.403 7.364 
Falcon Falcon 512 1 0.095 0.089 Falcon Falcon 1024 5 0.183 0.180 
MAYO 1 1 2.244 2.199 
MAYO 3 3 5.871 5.777 MAYO 5 5 13.246 13.038 
Fig. 14. Signature veri¯cation time comparison on the notebook for Security Level 5 (unit: milliseconds). 
The Security Performance Analysis of Blockchain System Based on Post-Quantum Cryptography 23
For a fair comparison of the veri¯cation time for signatures among each PQC 
algorithm on the Amazon EC2 r5.xlarge, the performance at Security Level 5 can be 
observed. The experimental results reveal that ML-DSA with the parameter set 
ML-DSA-44 has a veri¯cation time for signatures of 0.446 milliseconds, Falcon with 
the parameter set Falcon 1024 has a veri¯cation time of 0.180 milliseconds, and SLH-
DSA with the parameter set sha2-256f has a veri¯cation time of 6.007 milliseconds. 
Therefore, it can be inferred that under the same security level, Falcon algorithm 
o®ers the fastest e±ciency in producing signatures. Therefore, Falcon algorithm may 
be more suitable for blockchain systems requiring frequent signature veri¯cation. 
5.5. Security analysis of PoW 
As PoW primarily involves setting a di±culty target length L and iterating over the 
block content until the hash function produces a hash value with the ¯rst L bits all 
being zeros, it is crucial to assess its security. If the hash values produced by the hash 
function follow a uniform distribution, then the probability of having all zeros in the 
¯rst L bits is not signi¯cantly di®erent from the probability of having all ones, and it 
approaches 1 2L . Therefore, the security analysis of PoW in this study is primarily 
divided into two experiments: (1) computation time of PoW for di®erent di±culty 
target lengths, and (2) uniformity test of the ¯rst L bits of hash values. The 
experimental results are discussed as follows. 
5.5.1. Experiment (1): Computation time of PoW for di®erent di±culty target 
lengths 
To assess the computation time of PoW for di®erent di±culty target lengths, di±-
culty target lengths of 4, 8, 12, 16, and 20 were considered. The average computation 
Fig. 15. Signature veri¯cation time comparison on the Amazon EC2 r5.xlarge for Security Level 5 (unit: 
milliseconds). 
24 A. C. H. Chen
time of PoW for 100 transactions was recorded for each di±culty target length. From 
the experimental results in Tables 11–14, it is observed that as the multiple of the 
di±culty target length increases, the average computation time of PoW exponen-
tially increases. Speci¯cally, when the di±culty target length is 4, the average 
computation time of SHA-256 is only 0.005 milliseconds on the Amazon EC2 
Table 11. Computation time of PoW for di®erent di±culty 
target lengths on the notebook (All L bits of hash values are 
zeros) (unit: milliseconds). 
Algorithm L ¼ 4 L ¼ 8 L ¼ 12 L ¼ 16 L ¼ 20 
SHA-224 0.302 0.111 1.667 29.408 675.378 
SHA-256 0.008 0.089 1.879 24.400 571.512 
SHA-384 0.109 0.457 2.825 43.595 543.858 SHA-512 0.195 0.157 4.369 44.554 770.211 
SHA3-224 0.111 0.357 6.559 77.144 1182.918 
SHA3-256 0.416 0.297 4.921 66.694 1261.022 
SHA3-384 0.020 0.335 4.955 76.859 1153.388 SHA3-512 0.016 0.241 6.825 111.920 1580.554 
Table 12. Computation time of PoW for di®erent di±culty 
target lengths on the notebook (All L bits of hash values are 
ones) (unit: milliseconds). 
Algorithm L ¼ 4 L ¼ 8 L ¼ 12 L ¼ 16 L ¼ 20 
SHA-224 0.018 0.201 1.453 36.866 585.249 
SHA-256 0.013 0.180 1.632 33.727 608.122 
SHA-384 0.025 0.302 4.836 53.950 773.705 SHA-512 0.015 0.205 3.048 45.374 690.160 
SHA3-224 0.026 0.409 5.161 94.606 1194.622 
SHA3-256 0.016 0.299 6.310 93.054 1284.837 
SHA3-384 0.024 0.333 6.032 98.444 1515.562 SHA3-512 0.025 0.326 5.813 93.019 1101.032 
Table 13. Computation time of PoW for di®erent di±culty 
target lengths on the Amazon EC2 r5.xlarge (All L bits of hash 
values are zeros) (unit: milliseconds). 
Algorithm L ¼ 4 L ¼ 8 L ¼ 12 L ¼ 16 L ¼ 20 
SHA-224 0.226 0.078 0.983 20.154 515.866 
SHA-256 0.005 0.057 1.287 16.296 385.982 SHA-384 0.074 0.173 1.865 27.708 366.709 
SHA-512 0.118 0.122 2.800 22.972 511.619 
SHA3-224 0.082 0.180 4.482 48.313 851.053 SHA3-256 0.049 0.188 3.072 45.884 736.823 
SHA3-384 0.013 0.216 3.250 56.924 968.319 
SHA3-512 0.012 0.164 3.551 80.055 1118.567 
The Security Performance Analysis of Blockchain System Based on Post-Quantum Cryptography 25
r5.xlarge for all L bits of hash values are zeros, indicating a quick computation; 
however, this also implies that attackers could more easily and rapidly succeed in 
attacks. Conversely, when the di±culty target length is 20, the average computation 
time of SHA-512 rises to 511.619 milliseconds on the Amazon EC2 r5.xlarge for all L 
bits of hash values are zeros, exhibiting an exponential increase in computation time 
for both traditional and quantum computers as the di±culty target length increases. 
Given these ¯ndings, deploying a blockchain system should involve adopting longer 
di±culty target lengths to enhance security. 
5.5.2. Experiment (2): Uniformity test of the ¯rst L bits of hash values 
To verify whether the ¯rst L bits of hash values follow a uniform distribution, this 
study set the di±culty target length L to 8 and observed the ¯rst L bits of hash 
values after executing 10,000 transactions for statistical testing. In this statistical 
test, if the hash values are represented in hexadecimal, there are 256 possible com-
binations for the ¯rst two hexadecimal digits, ranging from `00' to `FF'. Under a 
uniform distribution, the probability of each combination occurring is 1 28 ¼ 1 
256. 
Comparing the observed frequencies of each combination with the expected 
frequencies, the chi-square value was calculated to be 0.004 with a p-value of 1, 
indicating no signi¯cant di®erence between the observed and expected probabilities 
for each combination, thus approximating a uniform distribution. 
Although there was no signi¯cant di®erence found in the statistical test, this 
study still examined the probabilities of \all L bits of hash values are zeros" and \all 
L bits of hash values are ones" based on di±culty target lengths of 4 and 8, as shown 
in Tables 15 and 16. The experimental data indicated that the probability of \all L 
bits of hash values are ones" is slightly lower than the probability of \all L bits of 
hash values are zeros". Therefore, if determining the di±culty by judging the oc-
currence of \all L bits of hash values are ones" during PoW computation, the di±-
culty level and security would be higher. 
Table 14. Computation time of PoW for di®erent di±culty 
target lengths on the Amazon EC2 r5.xlarge (All L bits of hash 
values are ones) (unit: milliseconds). 
Algorithm L ¼ 4 L ¼ 8 L ¼ 12 L ¼ 16 L ¼ 20 
SHA-224 0.014 0.138 0.708 19.208 356.648 
SHA-256 0.010 0.133 0.838 20.336 406.339 SHA-384 0.021 0.211 3.308 35.849 623.598 
SHA-512 0.012 0.135 1.784 28.760 447.751 
SHA3-224 0.020 0.322 3.089 62.918 898.181 SHA3-256 0.012 0.176 4.457 63.896 825.429 
SHA3-384 0.016 0.189 5.217 75.123 1376.835 
SHA3-512 0.019 0.233 4.089 63.545 735.091 
26 A. C. H. Chen
5.6. Summary and discussion 
In summary, the experiments conducted in this study provide valuable insights for 
the future deployment of blockchain systems based on PQC. 
(1) The ¯ndings suggest that ML-DSA is a favorable choice for PQC digital signa-
ture. ML-DSA demonstrates superior e±ciency in wallet generation, signature 
generation, and signature veri¯cation compared to the ECDSA currently utilized 
in blockchain systems. Furthermore, ML-DSA exhibits resilience against quan-
tum computing attacks, thereby o®ering a higher level of security compared to 
the ECDSA. 
(2) Falcon algorithm stands out for its e±ciency in signature veri¯cation. Theref-
more, for blockchain systems requiring frequent signature veri¯cation, Falcon 
algorithm is recommended. 
(3) The experiments indicate that the probability of \all L bits of hash values are 
ones" is slightly lower than that of \all L bits of hash values are zeros". There-
fore, it is suggested to enhance security by considering the calculation of \all L 
bits of hash values are ones" in the PoW algorithm. 
Table 15. Computation time of PoW 
for di®erent di±culty target lengths 
(All L bits of hash values are zeros). 
Algorithm L ¼ 4 L ¼ 8 
SHA-224 6.302% 0.393% 
SHA-256 6.269% 0.393% SHA-384 6.255% 0.414% 
SHA-512 6.293% 0.386% 
SHA3-224 6.229% 0.398% SHA3-256 6.255% 0.406% 
SHA3-384 6.306% 0.398% 
SHA3-512 6.217% 0.395% 
Expected Value 6.25% 0.391% 
Table 16. Computation time of PoW 
for di®erent di±culty target lengths 
(All L bits of hash values are ones). 
Algorithm L ¼ 4 L ¼ 8 
SHA-224 6.228% 0.374% 
SHA-256 6.240% 0.395% 
SHA-384 6.230% 0.396% SHA-512 6.316% 0.409% 
SHA3-224 6.203% 0.376% 
SHA3-256 6.230% 0.381% 
SHA3-384 6.229% 0.387% SHA3-512 6.274% 0.392% 
Expected Value 6.25% 0.391% 
The Security Performance Analysis of Blockchain System Based on Post-Quantum Cryptography 27
These ¯ndings contribute valuable insights for the development and deployment 
of blockchain systems based on PQC, paving the way for enhanced security and 
e±ciency in future blockchain applications. 
6. Conclusions and Future Work 
This study analyzes the vulnerabilities of existing blockchain systems to quantum 
computing attacks and proposes a blockchain system based on PQC to address and 
enhance the security of each weakness in current blockchain systems. Speci¯cally, 
this study proposes PQC-based wallets, establishing key pairs based on PQC within 
these wallets. Furthermore, PQC-based transactions are introduced, incorporating 
PQC digital signature algorithms to generate signatures for transaction inputs, thus 
mitigating the risk of signature counterfeiting by quantum computers. Finally, this 
study explores the security of PoW and analyzes the probability distribution of hash 
values, with recommendations and improvements proposed in Sec. 5.6. 
Future research directions may involve the practical deployment of the proposed 
blockchain system based on PQC in commercial cryptocurrency exchange applica-
tions, aiming to enhance the security of existing commercial systems. 
Acknowledgments 
I would like to thank editors and reviewers for their great e®ort. Additionally, I 
would like to acknowledge Chun-Feng Lin Lin for assisting in verifying the execution 
e±ciency on Amazon EC2 r5.xlarge. 
ORCID 
Abel C. H. Chen https://orcid.org/0000-0003-3628-3033 
References 
1. IEEE standard for application technical speci¯cation of blockchain-based e-commerce transaction evidence collecting, IEEE Std 3802-2022 (2022), pp. 1–24, doi:10.1109/ IEEESTD.2022.9745865. 
2. IEEE standard for blockchain-based electronic contracts, IEEE Std 3801-2022 (2022), pp. 1–26, doi:10.1109/IEEESTD.2022.9745868. 
3. IEEE standard for the use of blockchain in supply chain ¯nance, IEEE Std 2418.7-2021 (2021), pp. 1–25, doi:10.1109/IEEESTD.2021.9599622. 
4. IEEE standard for blockchain based digital asset management, IEEE Std 2418.10-2022 (2022), pp. 1–19, doi:10.1109/IEEESTD.2022.9810177. 
5. IEEE recommended practice for e-invoice business using blockchain technology, IEEE Std 2142.1-2021 (2021), pp. 1–18, doi:10.1109/IEEESTD.2021.9381780. 
6. IEEE standard for using blockchain for carbon trading applications, IEEE Std 3218-2022 (2023), pp. 1–31, doi:10.1109/IEEESTD.2023.10057186. 
7. IEEE standard for general requirements for cryptocurrency exchanges, IEEE Std 2140.1-2020 (2020), pp. 1–18, doi:10.1109/IEEESTD.2020.9248667. 
28 A. C. H. Chen
8. M. A. El-Zawawy, A. Brighente and M. Conti, Authenticating drone-assisted internet of vehicles using elliptic curve cryptography and blockchain, IEEE Trans. Netw. Serv. Manag. 20(2) (2023) 1775–1789, doi: 10.1109/TNSM.2022.3217320. 
9. P. W. Shor, Polynomial-time algorithms for prime factorization and discrete logarithms on a quantum computer, SIAM J. Comput. 26(5) (1997) 1484–1509, doi: 10.1137/S0097 539795293172. 
10. R. Saha et al., A blockchain framework in post-quantum decentralization, IEEE Trans. Serv. Comput. 16(1) (2023) 1–12, doi: 10.1109/TSC.2021.3116896. 
11. H. Yi, Secure social internet of things based on post-quantum blockchain, IEEE Trans. Netw. Sci. Eng. 9(3) (2022) 950–957, doi: 10.1109/TNSE.2021.3095192. 
12. G. Alagic et al., Status report on the third round of the NIST post-quantum cryptography standardization process, NIST Interagency/Internal Report (NIST IR), NIST IR 8413-upd1 (2022), pp. 1–93, doi:10.6028/NIST.IR.8413-upd1. 
13. I. Kuznetsov, Blockchain in Go, GitHub (2021). Retrieved on 7 Feb. 2024, url:https:// github.com/Jeiwan/blockchain go. 
14. Google Quantum AI and Collaborators, Quantum error correction below the surface code threshold, Nature 638 (2024) 920–926, doi: 10.1038/s41586-024-08449-y. 
15. M. E. Baraka and E. Siham, Quantum-resistant modi¯cations to ECDSA for blockchain security, J. Cyber Secur. Technol. (2025) 1–19, doi: 10.1080/23742917.2025.2458320. 
16. A. C. H. Chen, Post-quantum cryptography X.509 certi¯cate, in Proc. 2024 Int. Conf. Smart Systems for applications in Electrical Sciences (ICSSES) (IEEE, 2024), pp. 1–6, doi: 10.1109/ICSSES62373.2024.10561274. 
17. Module-lattice-based digital signature standard, FIPS 204 (2024), pp. 1–55, doi:10.6028/ NIST.FIPS.204. 
18. Stateless hash-based digital signature standard, FIPS 205 (2024), pp. 1–51, doi:10.6028/ NIST.FIPS.205. 
19. Secure hash standard (SHS), FIPS 180-4 (2015), pp. 1–31, doi:10.6028/NIST.FIPS.180-4. 20. SHA-3 standard: Permutation-based hash and extendable-output functions, FIPS 202 
(2015), pp. 1–29, doi:10.6028/NIST.FIPS.202. 21. A. C. H. Chen, Report on hash algorithm performance – A case study of cryptocurrency 
exchanges based on blockchain system, in Proc. 2024 5th Int. Conf. Data Intelligence and Cognitive Informatics (ICDICI) (IEEE, 2024), pp. 30–35, doi: 10.1109/ICDICI62993. 2024.10810832. 
22. Module-lattice-based key-encapsulation mechanism standard, FIPS 203 (2024), pp. 1–47, doi:10.6028/NIST.FIPS.203. 
23. G. Alagic et al., Status report on the fourth round of the NIST post-quantum cryptography standardization process, NIST Interagency/Internal Report, NIST IR 8545 (2025), pp. 1–27, doi:10.6028/NIST.IR.8545. 
24. R. J. McEliece, A public-key cryptosystem based on algebraic coding theory, JPL Deep Space Network Progress Report, Vol. 42–44 (1978) 114–116. 
25. H. Zhang, X. Qiao, J. Tian, S. Song and Z. Wang, Fast hardware architecture with e±cient matrix computations for the key generation of Classic McEliece, IEEE Trans. Circuits Syst. I 72(3) (2025) 1321–1331, doi: 10.1109/TCSI.2025.3528119. 
26. A. C. H. Chen, Code-based butter°y key expansion for pseudonymous certi¯cates, IEICE Commun. Express 14(7) (2025) 296–299, doi: 10.23919/comex.2025XBL0066. 
27. G. Alagic et al, Status report on the ¯rst round of the additional digital signature schemes for the NIST post-quantum cryptography standardization process, NIST Interagency/ Internal Report, NIST IR 8528 (2024), pp. 1–22, doi:10.6028/NIST.IR.8528. 
28. G. Alagic et al, Transition to post-quantum cryptography standards, NIST Interagency/ Internal Report, NIST IR 8547 (2024), pp. 1–22, doi:10.6028/NIST.IR.8547. 
The Security Performance Analysis of Blockchain System Based on Post-Quantum Cryptography 29
29. E. Barker, Recommendation for key management: Part 1  General, NIST Special Pub-lication (NIST SP), NIST SP 800-57 Part 1 Revision 5 (2020), pp. 1–158, doi:10.6028/ NIST.SP.800-57pt1r5. 
30. R. Rios, J. A. Montenegro, A. Muñoz and D. Ferraris, Towards the quantum-safe web: Benchmarking post-quantum TLS, IEEE Netw. 39(5) (2025) 247–253, doi: 10.1109/ MNET.2025. 3531116. 
31. A. C. H. Chen, Comments on \Exploring secure V2X communication networks for human-centric security and privacy in smart cities"  Privacy-preserving certi¯cate in V2X communications, IEEE Access 13 (2025) 76923–76933, doi: 10.1109/ACCESS. 2025.3563461. 
32. C. Baliker, M. Baza, A. Alourani, A. Alshehri, H. Alshahrani and K.-K. R. Choo, On the applications of blockchain in FinTech: Advancements and opportunities, IEEE Trans. Eng. Manag. 71 (2024) 6338–6355, doi: 10.1109/TEM.2022.3231057. 
33. S. Xu et al., Post-quantum anonymous, traceable and linkable authentication scheme based on blockchain for intelligent vehicular transportation systems, IEEE Trans. Intell. Transp. Syst. 25(9) (2024) 12108–12119, doi: 10.1109/TITS.2024.3383668. 
30 A. C. H. Chen