# Post-Quantum Cryptographic Algorithms - Simple search

- **ID**: `14dcf63a-dbf4-44d9-a207-5e118e9323ac`
- **Tipo de Fuente**: `SOURCE_TYPE_PDF`
- **URL**: [https://his.diva-portal.org/smash/get/diva2:2084621/FULLTEXT01.pdf](https://his.diva-portal.org/smash/get/diva2:2084621/FULLTEXT01.pdf)

---

## Contenido Extraído / Texto Completo

B a ch 
e lo r T h e si s 
Performance Evaluation of Post-Quantum Cryptographic Algorithms: A Comparative Study of ML-DSA, SLH-DSA, and Ed25519 
Bachelor Degree Project in Informatics Basic level 30 ECTS Spring 2026 
Axel Herre, Alex Ranhög 
Supervisor: András Márki Examiner: Richard Senington
Summary 
Post-Quantum Cryptography (PQC) has emerged as a means to protect encryption from Quantum Computing (QC). Quantum Computing poses a threat towards classical cryptography because of its enhanced capability to solve complex mathematical problems quickly. To combat this, NIST has developed three standards for PQC: FIPS 203, FIPS 204, and FIPS 205. This study compares how the algorithms defined in FIPS 204 and FIPS 205, ML-DSA and SLH-DSA, compare to a baseline classical algorithm, Ed25519. 
Findings show that both ML-DSA and SLH-DSA offer slower signing times and verifying times compared to Ed25519. The algorithms also consume different amounts memory which can have an impact on future implementations. Future directions include the addition of future algorithms to improve the generability, a closer look at the ecological impacts as well as examining the component bottleneck in order to get a better understanding of how a switch towards these algorithms may impact the future. 
keywords: Post-Quantum Cryptography, Encryption, Cybersecurity, Network-Security, ML-DSA, SLH-DSA
Contents 
1 Introduction 1 
2 Background 2 2.1 Quantum computing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 2 
2.1.1 Harvest Now Decrypt Later . . . . . . . . . . . . . . . . . . . . . . . . . . 2 2.2 Encryption . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 2 
2.2.1 Digital Signatures . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 3 2.2.2 Ed25519 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 3 
2.3 Post Quantum Cryptography . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 3 2.3.1 Hash-based Cryptography . . . . . . . . . . . . . . . . . . . . . . . . . . . 3 2.3.2 Stateless Hash-Based Digital Signature Algorithm (SLH-DSA) . . . . . . 4 2.3.3 Lattice-based Cryptography . . . . . . . . . . . . . . . . . . . . . . . . . . 12 2.3.4 Module-Lattice-Based-Digital-Signature-Algorithm (ML-DSA) . . . . . . 13 
3 Problem and Related Research 19 3.1 Aim . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 20 3.2 Research Questions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 20 3.3 Hypotheses . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 20 3.4 Objectives . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 21 3.5 Related Research . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 21 
4 Method 22 4.1 Choice of Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 22 4.2 Method Description . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 22 4.3 Alternative Methods . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 23 4.4 Approach . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 24 
5 Results 27 5.1 Ed25519 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 28 
5.1.1 Payload effect on signing time . . . . . . . . . . . . . . . . . . . . . . . . 28 5.1.2 Payload effect on verifying time . . . . . . . . . . . . . . . . . . . . . . . . 30 
5.2 ML-DSA . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 33 5.2.1 Payload effect on signing time . . . . . . . . . . . . . . . . . . . . . . . . . 33 5.2.2 Payload effect on verifying time . . . . . . . . . . . . . . . . . . . . . . . . 35 
5.3 SLH-DSA . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 38 5.3.1 Payload effect on signing time . . . . . . . . . . . . . . . . . . . . . . . . 38
5.3.2 Payload effect on verifying time . . . . . . . . . . . . . . . . . . . . . . . . 40 5.4 ML-DSA vs Ed25519 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 43 5.5 SLH-DSA vs Ed25519 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 45 5.6 Memory usage . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 46 5.7 Scalability . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 49 5.8 Hypothesis Testing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 50 
5.8.1 H1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 50 5.8.2 H2 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 51 5.8.3 H3 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 51 5.8.4 H4 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 51 
6 Discussion 52 6.1 Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 52 
6.1.1 ML-DSA vs Ed25519 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 52 6.1.2 SLH-DSA vs Ed25519 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 54 
6.2 Reflections . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 56 6.3 Similarities and Differences to Related Research . . . . . . . . . . . . . . . . . . . 57 6.4 Internal Validity . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 58 6.5 External Validity . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 59 6.6 Conclusion Validity . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 60 6.7 Construct Validity . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 61 6.8 Sustainability . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 61 
6.8.1 Economical . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 61 6.8.2 Sociological . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 62 6.8.3 Ecological . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 63 
6.9 Future Work . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 63 
7 Conclusion 65 
A Appendix - Tukey tests 69 
0
1 Introduction 
Quantum computers can become powerful enough to break the cryptographic system used today, RSA (Rivest shamir adleman), ECC (Elliptic curve cryptography) and AES (Advanced Encryption standard), are especially threatened by quantum computing, stated by Sijjad et al. (2025). Quantum computers possess unparalleled processing capabilities that can solve extremely complex mathematical problems, which are integral to many encryption systems today, such as RSA and ECC. The threat exists due to the fact that quantum computing can solve several mathematical problems in parallel, thanks to the use of qubits, which can exist in a superposition of 0 and 1 (Maqousi, Basu, Pelayo, and Gómez, 2025). Many systems relying on digital security will become unsafe in the future. For example, Sijjad et al. (2025) presents a threat created by quantum computing, known as “harvest now, decrypt later”, Ali explains that attackers can store encrypted data today and decrypt it when quantum computers improve in the future (Sijjad et al., 2025). Despite the large number of digital signature schemes created over the past decades, only a small set of them are used, primarily RSA, DSA and ECDSA. These signature schemes are widely deployed in practice (Butin, 2017). Internet authentication rely on a limited set of security assumptions and can later on be broken using Shor’s or Grover’s algorithm with the help of quantum computing (Butin, 2017). 
The study performs a quantative experiment in which two recently standardised quantumresistant digital signature algorithms, ML-DSA and SLH-DSA and a baseline classical digital signature algorithm, Ed25519 are compared and analysed. The algorithms were benchmarked on signing speed, verifying speed and memory usage. These metrics allowed us to compare the performance of each algorithm and assess the current situation of Post-Quantum Cryptography (PQC). To present a fair comparison, a benchmarking tool was created where each algorithm was used to send a message over a virtual network. Using the benchmarking tool the size of the payload could be changed which allowed for an evaluation of each algorithms scaleability. 
When researching PQC, we are under the assumption that a malicious attacker has access to a quantum computer. What this means is that all public key cryptographic systems, such as RSA and ECC, are no longer safe to use (D’Anvers et al., 2021). 
1
2 Background 
2.1 Quantum computing 
Quantum computing uses quantum bits, often called qubits. This is where quantum computers differ from classical computers. Classical computers use bits, which can have a value of either 0 or 1, yes or no. Qubits, on the other hand, can simultaneously be both 0 and 1; to achieve this, quantum computing makes use of superposition and entanglement (Mascelli and Rodden, 2025). Due to the fact that quantum computers uses qubits instead of bits, it allows for quantum computers to solve mathematical problems such as the ones used for encryption algorithms much faster compared to classical computers (Maqousi et al., 2025). The fact that qubits can exist as 0 and 1 simultaneously is explained by the theory of superposition. Until a qubit is measured or observed, it can exist in multiple states at once (Mascelli and Rodden, 2025). As mentioned earlier, qubits can become entangled. This means that they share one single quantum state; a change in one qubit will change the other linked qubit, no matter the distance between them (Mascelli and Rodden, 2025). 
2.1.1 Harvest Now Decrypt Later 
Often described as a ”Cyberweapon”, one of the largest threats we face today from quantum computing is known as Harvest Now Decrypt Later (HNDL). HNDL describes the threat of attackers collecting encrypted data today in the hopes of being able to decrypt it in the future when greater computational or quantum technologies emerge. The threat of HNDL means that encryption can no longer ensure secrecy and integrity, and organisations must focus on the longevity of sensitive data (Kagai et al., 2025). 
2.2 Encryption 
There exists two primary types of encryption today, symmetric and asymmetric encryption. Symmetric encryption works by using one key to encrypt and decrypt data at rest. This type of encryption is said to be more resistant towards quantum attacks compared to asymmetric encryption because of the fact that the key sizes can be increased in order to add protection (Mascelli and Rodden, 2025). Asymmetric encryption utilises two separate keys for encryption and decryption. Keys are generated using, for example, the Rivest-Shamir-Adleman (RSA) method. This method is currently the standard for sending information across the internet and works by using a high-strength key of 2048 bits. The key generated by RSA is the product of the 
2
multiplication of two large prime numbers. Finding the prime numbers from just the product is incredibly difficult and is what makes RSA so effective. Classical computers cannot factor or would require decades of factoring to compute the integer. However, for quantum computers, qubits would allow for factoring in hours or minutes using, for example, Shor’s algorithm (Mascelli and Rodden, 2025). 
2.2.1 Digital Signatures 
Digital signatures are used to verify that the message has not been altered during transmission and that the sender cannot deny having sent the message. A digital signature in a public-key cryptosystem works by the signer encrypting the message with the private key, giving (m, sig), sig = Sk(m). When the verifier then receives the message, they can decrypt sig using the signer’s public key. If m = Sk(m) then the message has not been altered and the verifier knows that the signer sent it because of the private key encryption (Van Steen and Tanenbaum, 2023). 
2.2.2 Ed25519 
The digital signature scheme Ed25519, according to Bernstein, Duif, Lange, Schwabe, and Yang (2012), is based on elliptic curve cryptography. It was introduced by Bernstein and is built on a twisted Edwards curve over the prime field 2255 − 19. The scheme was designed to help provide high security and also high performance. 
When looking at Ed25519 public keys, they are 32 bytes, and signatures are 64 bytes long. The scheme aims for a security level of 2128. To create a signature, the signer first derives a secret value from the private key. A value r is then computed using a cryptographic hash function and the message. From that value, a curve point R = rB is calculated. The final signature also includes a second value S, which is computed with the help of r, the public key and also the message hash (Bernstein et al., 2012). 
To verify a signature, the verifier checks that a specific equation on the elliptic curve holds. If the equation is satisfied, the signature is valid. Ed25519 also uses deterministic signing, which means that it does not require a new random number for each signature. This results in a reduced risk of security problems that can be caused by weak randomness (Bernstein et al., 2012). 
2.3 Post Quantum Cryptography 
There are four families of PQC algorithms: code-based, hash-based, isogeny-based, lattice-based and multivariate-system based (D’Anvers et al., 2021). This report will focus on hash-based and lattice-based PQC algorithms because of the standards that have been finished for these two families (FIPS 204 and FIPS 205). 
2.3.1 Hash-based Cryptography 
Hash-based digital signature schemes make up one of the earliest and most well-studied approaches to post-quantum digital signatures. Hash-based schemes were originally introduced by Ralph Merkle in 1979 and have been refined over several decades (Butin, 2017). 
The idea behind hash-based digital signature schemes is to combine a large number of 
3
one-time signature key pairs into a single structure using a hash tree. A hash tree is a hierarchical data structure where each node is computed by repeatedly applying a cryptographic hash function and combining values to compute tree nodes. Hash-based signatures are used for two main reasons (Butin, 2017). 
The first one is that hash-based signatures rely on minimal security assumptions. Hash-based digital signature schemes rely only on the security of the underlying cryptographic hash function. This means that their security does not depend on additional mathematical assumptions, resulting in hash-based signature schemes having minimal security requirements (Butin, 2017). 
The second one is generic nature. Hash-based signature schemes can be used with different cryptographic functions, but only if the basic security requirements are met. This leads to the fact that the schemes are flexible, since the hash function can be replaced without changing the overall structure (Butin, 2017). 
In a hash-based signature, there always exists one basic building block and its one-time signature schemes. A one-time signature can be seen as a simple digital signature that is used to sign only one message with a given key pair. One-time signature schemes are very flexible and are good for use in the future. If the chosen hash function meets the required criteria, the overall structure of the one-time signature schemes can remain unchanged. When looking at one-time signature schemes, there exist several variants. A key characteristic of all schemes is that parts of the private key are revealed during the signing; this will then limit each key pair to signing a single message. Some of the variants offer greater flexibility by trading off between signature size and performance, like smaller signatures can be achieved at the cost of slower signing and verification (Butin, 2017). 
Hash-based digital signature schemes also have some challenges that need to be considered. One big challenge is state management because some schemes require the system to keep track of internal state, this can affect usability and reliability. Another challenge with hash-based signature schemes is that they offer many configuration options, which makes them more complex to set up compared to traditional signature schemes (Butin, 2017). 
One key aspect of state management within hash-based signature schemes is that onetime signing keys should never be reused. The result of using a one-time key more than once will result in the security of the scheme breaking down completely. To avoid this problem, the system requires tracking which keys have already been used and always updating the information after each signature. This highlights the importance of reliable state management when doing practical deployments of hash-based signatures (Butin, 2017). 
2.3.2 Stateless Hash-Based Digital Signature Algorithm (SLH-DSA) 
According to NIST (2024b), stateless hash-based digital Signature Algorithm (SLH-DSA) is a standardised post-quantum digital signature scheme that is designed to ensure data integrity, authentication of the signer and non-repudiation. SLH-DSA allows the receiver to verify that the data has not been altered and to confirm the identity of the signer. SLH-DSA is based on SPHINCS+ and was later standardised during the NIST Post-quantum cryptography standardisation process (NIST, 2024b). 
4
According to NIST, conceptually, SLH-DSA is not a single, standalone signature algorithm, but is a combination of multiple hash-based signature schemes arranged in a hierarchical structure. It combines a few-times signature scheme with Forest of Random subsets (FORS) and a multi-time signature scheme extended Merkle Signature Scheme (XMSS). XMSS is constructed using Winternitz One-time Signature Plus (WOTS+) as its building block (NIST, 2024b). 
A SLH-DSA key pair consists of a large number of FORS key pairs that are derived from a single secret value. The FORS scheme allows each key pair to securely sign a small number of messages. SLH-DSA support this limitation with signatures over many different FORS keys. This makes it possible to generate many signatures while also keeping each separate FORS key within safe usage limits (NIST, 2024b). 
Authentication of the FORS public keys in SLH-DSA is performed using XMSS signatures. XMSS is a multi-time signature scheme that is built from WOTS+ one-time signature combined with Merkle hash trees. XMSS works by having each key contain a large number of WOTS+ keys and therefore can be used to sign many messages. WOTS+ generate public keys which then are arranged in a Merkle hash tree, where the root of the tree represents the XMSS public key. The XMSS signature consists of a WOTS+ signature together with a path in the Merkle tree, allowing the verifier to confirm the authenticity of the public key (NIST, 2024b). 
To authenticate the large number of FORS public keys, SLH-DSA use a hypertree structure, which is then a hierarchy of multiple XMSS trees that are organised in several layers. The structures created, XMSS public keys in the lower levels, are authenticated by XMSS signatures from the layer above. Where the top layers consist of a single XMSS tree, and the root of this tree is the main public key of the whole SLH-DSA scheme. The SLH-DSA signature consists of a FORS signature together with a hypertree signature that proves the authenticity of the corresponding FORS public key (NIST, 2024b). 
The SLH-DSA public key consists of two fixed-size components PK.root and PK.seed . PK.root represents the root of the top level of the XMSS Merkle tree and works as the public verification value; PK.seed is used for domain separation to ensure uniqueness between different key pairs. The SLH-DSA private key includes a seed SK.seed and is used to derive a single secret value for WOTS+ and FORS schemes. SLH-DSA also have a secret key SK.prf and is used when computing the randomised hash message during the signature generation. The private key also contains copies of PK.root and PK.seed and these values are required for both signature generation and verification (NIST, 2024b). 
Internal Structure and Signature Process of SLH-DSA 
According to NIST (2024b), SLH-DSA creates a signature by first hashing the message into a fixed-length digest. Later, the digest is divided into different parts, where some parts are used to select a FORS key and other bits are used to select the XMSS subtree and also the WOTS+ key (NIST, 2024b). 
The selected FORS key signs part of the digest. This results in the FORS public key being authenticated using the hypertree structure, and the XMSS signatures are generated layer 
5
by layer until the top-level root is reached. 
SLH-DSA uses one additional parameter m, which defines the length (in bytes) of the message digest. It is computed as 
m = 
⌈ h− h′ 
8 
⌉ + 
⌈ h′ 
8 
⌉ + 
⌈ k · a 8 
⌉ The first term corresponds to the bits used to select the XMSS tree, and the second term selects the WOTS+ key in the tree, and the third term represents the k · a bits that are used to sign the selected FORS key (NIST, 2024b). 
A SLH-DSA signature consists of three parts: a randomisation value R, a FORS signature and a hypertree signature. The signature size and computational cost depend on the chosen parameter set (NIST, 2024b). 
SLH-DSA Signature Verification 
According to FIPS 205 (NIST, 2024b), SLH-DSA verification works by first parsing the signature into its components. The verifier then recomputes the message digest using the received randomisation value and the public key. Then the FORS public key is reconstructed from the FORS signature and also the extracted digest bits. Then, the last part of the hypertree signature is verified against the root value in the public key, so if the computed root matches PK.root, the signature is accepted (NIST, 2024b). 
Approved SLH-DSA Parameter Sets 
In FIPS 205 (NIST, 2024b), NIST defines twelve approved parameter sets that can be used for SLH-DSA. Each parameter set specifies values for WOTS+ (n, lgw), the hypertree structure (h, d) and for FORS (k, a). The parameter set name indicates the hash function family (SHA2 or SHAKE), NIST also discuss the security parameter n. Whether the set is optimised for small signatures (s) or faster signature generation (f). 
The security parameter n determines the claimed security category, where parameter sets with n = 16 belong to security category 1, n = 24 category 3 and n = 32 to category 5. A key pair can sign up to 2h messages, where h represents the total hypertree height. 
Table 2.1: Approved SLH-DSA parameter sets (adapted from NIST (2024b)) 
Parameter Set n h d h′ a k lgw m Sec. Cat. pk (bytes) sig (bytes) 
SLH-DSA-SHA2-128s 16 63 7 9 12 14 4 30 1 32 7856 SLH-DSA-SHAKE-128s 16 63 7 9 12 14 4 30 1 32 7856 SLH-DSA-SHA2-128f 16 66 22 3 6 33 4 34 1 32 17088 SLH-DSA-SHAKE-128f 16 66 22 3 6 33 4 34 1 32 17088 SLH-DSA-SHA2-192s 24 63 7 9 14 17 4 39 3 48 16224 SLH-DSA-SHAKE-192s 24 63 7 9 14 17 4 39 3 48 16224 SLH-DSA-SHA2-192f 24 66 22 3 8 33 4 42 3 48 35664 SLH-DSA-SHAKE-192f 24 66 22 3 8 33 4 42 3 48 35664 SLH-DSA-SHA2-256s 32 64 8 8 14 22 4 47 5 64 29792 SLH-DSA-SHAKE-256s 32 64 8 8 14 22 4 47 5 64 29792 SLH-DSA-SHA2-256f 32 68 17 4 9 35 4 49 5 64 49856 SLH-DSA-SHAKE-256f 32 68 17 4 9 35 4 49 5 64 49856 
6
Address Structure (ADRS) 
According to FIPS 205 (NIST, 2024b), SLH-DSA has several cryptographic functions that take a 32-byte address structure representing ADRS as input. ADRS consist of public values that identify the position of the value that is being computed within the scheme, and an address is used for each function call. The ADRS structure is divided into fields that can identify the layer and the tree within the SLH-DSA hypertree, and also the type field that specifies how the address is used. NIST also brings up that, depending on the address type, the remaining fields describe elements such as key pairs, hash chains or nodes within the tree. If the address type changes, the unused fields are reset as defined in the standard. 
When looking at the addresses on different parts of SLH-DSA, like WOTS+, XMSS and FORS, different address types are used. This structure ensures that hash computations that are performed in different parts of the scheme can remain separated and will not affect or interfere with each other (NIST, 2024b). 
Winternitz One-Time Signature Plus (WOTS+) 
According to FIPS 205 (NIST, 2024b), the Winternitz One-time Signature Plus Scheme (WOTS+) is a hash-based one-time signature scheme that is a fundamental building block of SLH-DSA. Like every other one-time signature scheme, each WOTS+ key pair is designed to securely sign only a single message. Reusing a WOTS+ key for multiple signatures would compromise security, which is why WOTS+ is not used directly for repeated signing; but instead combined with higher-level constructions such as XMSS. 
WOTS+ uses two parameters, the first parameter n, which determines the length of hash outputs and also key elements and the second parameter, Winternitz parameter w this parameter expressed in the standard as, 
w = 2ℓgw 
len1 = 
⌈ 8n 
lgw 
⌉ len2 = 
⌊ log2(len1 · (w − 1)) 
lgw 
⌋ + 1 
len = len1 + len2 
The parameter w determines the length of the hash chains used in the scheme, and will also influence the trade-off between signature size and the computational cost. Larger values reduce signature size but at the cost of increased computation during signing and verification (NIST, 2024b). 
According to NIST (2024b), the WOTS+ private key consists of len secret values, each of length n, where len indicates the total number of hash chains in the WOTS+ construction. In SLH-DSA, these values are inevitably generated from a single n byte seed SK.seed using a cryptographically secure function. Each secret value forms the starting point of a hash chain with length w, the final values of these chains are used to derive the WOTS+ public key. 
7
WOTS+ Public key Generation 
WOTS+ public keys are generated using a WOTS+ pkGen function. The function use SK.seed and PK.seed from the SLH-DSA private key together with an address(ADRS) as input. Each of the len public values corresponds to the secret values generated, and the chaining function is later on applied to help compute the end value of a hash chain of length w. After all the len public values have been computed, they get compressed into a single value of length n bytes, which then results in the creation of the WOTS+ public key (NIST, 2024b). 
WOTS+ Signature Generation 
The WOTS+ signature consists of an array of len byte strings, each of length n. Signature generation is performed by first converting the n byte message into an array of len with base w integers. After that, a checksum is computed over the message representation and is later converted into a byte string and transformed into an array of len2 with base w integers. The integers representing the checksum are appended to those representing the message. For each len base w integers, the corresponding value is then selected from the appropriate hash chain. These nodes are then joined to form the WOTS+ signature (NIST, 2024b). 
WOTS+, Computing public key from signature 
When the WOTS+ signature is verified, it is by computing a public key value from the message and the signature. The value is then used to compute a candidate PK.root which is used to compare the PK.root that is contained in the SLH-DSA public key (NIST, 2024b). 
The computation uses the message WOTS+ signature, PK.seed and an address to identify the WOTS+ key. The values from the signature are then used as a starting point of hash chains, and the message can determine how many hash steps are applied, and then the final chain values are compressed to form a candidate WOTS+ public key (NIST, 2024b). 
Merkle Hash Tree 
According to Jakobsson, Leighton, Micali, and Szydlo (2003), who writes about Merkle trees in the article Fractal Merkle Tree Representation and Traversal 2023, a Merkle tree is a structure where the value of each node is computed as a one-way function of the values of the child nodes. Merkle trees have a simple design and flexibility, resulting in their wide use within cryptography. 
Looking at many applications, leaves are provided together with their authentication paths. The authentication path consists of the sibling nodes along the path from the leaf to the root. With the help of using the leaf and its authentication path, a verifier can then recompute the root value and later on compare it with the publicly known root (Jakobsson et al., 2003). 
eXtended Merkle Signature Scheme (XMSS) 
NIST explains that XMSS extends the WOTS+ signature scheme so that more than one message can be signed. This is done with the help of a Merkle tree with height h′. The tree contains 2h 
′ WOTS+ public key; every public key is authenticated by a single XMSS public key. 
This XMSS public key is the root of the Merkle tree and has a length of n bytes. NIST also 
8
brings up that since the WOTS+ key may only be used to sign one message, then the XMSS key can be used to sign up to 2h 
′ messages (NIST, 2024b). 
NIST brings up that when looking at an XMSS signature size, it consists of (h′ + len) · n bytes. The message consists of two main parts, a WOTS+ signature and an authentication path. The authentication path is a list of nodes from the Merkle tree, one node from each level except the root node. With the help of the WOTS+ public key that can be computed from the WOTS+ signature, the node will allow the verifier to reconstruct the root of the Merkle tree and verify the signature (NIST, 2024b). 
Component Size SIGWOTS+ len · n bytes AUTH[0] n bytes 
... ... 
AUTH[h′ − 1] n bytes 
Table 2.2: XMSS signature data format NIST (2024b) 
As seen in the Table 2.2, an XMSS signature has total size of (h′+ len) ·n bytes and it consists of a WOTS+ signature and the authentication path. 
Generating a Merkle Hash tree for XMSS 
For XMSS, the nodes of the Merkle tree are computed using the xmss node function that is defined in FIPS 205 under section 6.1 in Algorithm 9. The function takes SK.seed and PK.seed as input from the SLH-DSA private key. Then a target node i, a target node height z and an address structure ADRS. When looking at the address, it must have its layer and tree address set to the XMSS tree to know which node is being computed. The parameter must satisfy the conditions z ≤ h′ and i < 2(h 
′−z) (NIST, 2024b). 
NIST also brings up that each node in the XMSS tree represents the root of a subtree and is computed repeatedly. If the subtree consists of a single leaf node, the function returns the corresponding WOTS+ public key. Otherwise, the roots of the left and right subtrees are computed and hashed together create the parent node (NIST, 2024b). 
XMSS Signature generation 
XMSS generates a signature using function xmss sign under Section 6.1 in algorithm 10 in NIST (2024b). xmss sign can create an XMSS signature on an n-byte message M . In SLH-DSA, the message signed using XMSS is either in two ways, XMSS public key or a FORS public key. 
The function xmss sign generates an authentication path and then signs the message using the appropriate WOTS+ key. In addition to the message M , the function also takes SK.seed, PK.seed , address ADRS and the index idx as input. The address must have its layer address and the tree address set to the XMSS key that is used for signing and also the index identifies which WOTS+ key within the XMSS tree is used (NIST, 2024b). 
NIST also explains that the authentication path consists of the sibling nodes that are 
9
along the path from the selected WOTS+ key to the root of the XMSS tree. These nodes allow the verifier to recompute the root value during the verification (NIST, 2024b). 
n3,0 
n2,0 
n1,0 
K0 K1 
n1,1 
K2 K3 
n2,1 
n1,2 
K4 K5 
n1,3 
K6 K7 
Figure 2.1: Example of a Merkle hash tree. Each internal node is computed as H(left ∥ right) (NIST, 2024b). 
Looking at Figure 2.1, which is an example of a Merkle hash tree, it shows that the authentication path consists of the sibling nodes of each node along the path from the selected WOTS+ key to the root of the Merkle tree. 
For example, if the message is signed using K2, the nodes on the path to the root are K2, n1,1 and n2,0. The authentication path will then consist of their corresponding sibling nodes as K3,n1,0 and n2,0. This will then allow the verifier to recompute the root value of the tree during verification with the help of the authentication path nodes that are included in the signature (NIST, 2024b). 
Forest of Random Subsets (FORS) 
When looking at Forest of Random Subsets (FORS), NIST explains that it is a few-time signature scheme that is used to sign the message digest (the hash of the message). When comparing to WOTS+, where security can be compromised if the same key is reused twice, the security for the FORS key does not work the same and does not fail immediately when it is reused. If the same key in FORS is reused twice, the security will gradually decrease as more signatures are produced with the same key (NIST, 2024b). 
NIST explains that FORS is defined using two parameters, k and t = 2a. When looking at the private key in FORS, it consists of k different sets, where each set contains t strings of length n bytes. The strings are generated from the seed SK.seed in a predictable process, but they will appear random as long as the internal process remains hidden. Every k sets is later used to build a separate Merkle tree. When the construction of the tree is completed, its root nodes are hashed together; this combined hash value then forms the FORS public key (NIST, 2024b). 
Figure (2.2) illustrates the structure of a FORS signature computed from a message digest of length k ∗ a bits, the FORS signature consists of k selected private key elements together with their corresponding authentication paths (NIST, 2024b). 
Generating a Merkle Hash tree for FORS 
When generating a Merkle hash tree for FORS, the function fors node is used to compute the nodes of the tree, as defined in FIPS 205 Chapter 8.2 algorithm 15. The function works the 
10
private key value (tree 0) n bytes 
AUTH (tree 0) a · n bytes 
... 
private key value (tree k − 1) n bytes 
AUTH (tree k − 1) a · n bytes 
Figure 2.2: Structure of a FORS signature. For each of the k trees, the signature contains one selected private key value of length n bytes and its corresponding authentication path of length a · n bytes NIST (2024b) 
same way as xmss node, the only difference is that the leaf nodes are created from hashes of the FORS secret values instead of the WOTS+ public key (NIST, 2024b). 
The function takes the secret seed SK.seed and the public seed PK.seed , together with a node index i, height z and an address. Index i shows which node is being computed, and height z shows the level of that node in the tree. It must be correctly set in order to refer to the XMSS tree that signs the FORS key, and the type must also be set to FORS TREE (NIST, 2024b). 
When looking at each node in the Merkle tree, every node is the root of a smaller subtree. The function fors node computes this root step by step. If the subtree only contains one leaf, the function returns the hash of the leaf’s n-byte secret value. Otherwise, it computes the leaf and right child nodes and hashes them together to create the parent node (NIST, 2024b). 
FORS Signature generation 
When generating a signature using FORS, NIST brings up the function fors sign that can be found in Chapter 8.3 under algorithm 16. The fors sign function generates a FORS signature from a message digest of length k · a bits. The digest is split into k parts, where each contains a bits. Each of these parts is treated as a number between 0 and t−1 where t = 2a. With the help of this number, it can choose one secret value from one of the k FORS sets. For every chosen secret value, the matching authentication path in the Merkle tree is calculated and then added to the signature (NIST, 2024b). 
FORS Signature verification 
When looking at verifying a FORS signature, NIST brings up that a candidate FORS public key is recomputed from the message digest and the signature. The verification will only succeed if the correct public key value is obtained, which is then validated as part of the SLH-DSA hypertree verification process (NIST, 2024b). 
NIST brings up the function fors pkFromSig under chapter 8.4 algorithm 17 (NIST, 2024b). The function uses a message digest md and a FORS signature of size k · (a+1) ·n bytes. 
11
The digest contains k · a bits, which are divided into k segments of a bits each in the same way as during signing (NIST, 2024b). 
For each tree, the secret value included in the signature is first hashed. Then the corresponding authentication path is used to help reconstruct the root of that Merkle tree. When all k tree roots have been computed, they are later hashed together to produce the FORS public key. Last step, if the computed FORS public key matches the expected value within the SLH-DSA verification process, the signature is considered valid (NIST, 2024b). 
2.3.3 Lattice-based Cryptography 
Lattice-based cryptography is a public key encryption scheme that builds on using lattices in matrices. A lattice is the set of each integer linear combinations of basis vectors (Sahu, Srinivasa, and Vollala, 2025). The PQC algorithm described in NIST’s standard FIPS 204 makes use of two mathematical problems regarding lattices: Module Learning With Errors and Module Short Integer Solution. Both these problems are not considered as solvable by quantum computers (NIST, 2024a). There are different kinds of lattice problems, but generally the goal is to find the shortest path (Regev, 2006). 
LWE and M-LWE 
Module LWE is a structured variant of LWE, and as stated by Boudgoust, Jeudy, Roux-Langlois, and Wen (2023). The formulation of modular learning with errors (M-LWE) is similar to the original LWE. LWE works by having a set of integers d and q and the secret vector s ∈ Zdq and a LWEn,d,q,ψ sample is given by ( 
a, q−1⟨a, s⟩+ e mod R ) 
(2.1) 
A is sampled from the uniform distribution ψ over R. There are two different versions of LWE. The search version of LWE asks us to find s given arbitrary many samples of the LWE distribution. The decision version of LWE asks us to distinguish LWE samples from uniformly random ones over Rdq × T where the torus is T = KR/R (Boudgoust et al., 2023). 
The Module-LWE is similar to that of the ordinary LWE but it replaces the integer arithmetic over Zq with arithmetic over a ring of algebraic integers Rq. This introduces a new parameter n which represents the degree of the number field, the overall problem structure is kept the same (Boudgoust et al., 2023). 
SIS and M-SIS 
The Short Integer Solution (SIS) is described as follows by Langlois and Stehlé (2015): given A ∈ Zn×mq chosen from the uniform distribution, find z ∈ Zm such that Az ≡ 0 (mod q) and 0 < ∥z∥ ≤ β (Langlois and Stehlé, 2015). 
The problem Module Short Integer Solution (M-SIS) is described by Langlois and Stehlé (2015): given a1, ...,am ∈ Rdq chosen independently from the uniform distribution find 
z1, ..., zm ∈ R such that ∑m i=1 ai ·zi ≡ 0 (mod q) and 0 < ∥z∥ ≤ β where z = (z1, ..., zm)T ∈ Rm. 
12
2.3.4 Module-Lattice-Based-Digital-Signature-Algorithm (ML-DSA) 
Module-Lattice-Based Digital Signature Algorithm(ML-DSA) is a PQC scheme based on the Module-LWE and Module-SIS problem. ML-DSA is believed to be strongly unforgeable, which means it can be used to detect modifications made to data in motion (NIST, 2024a). ML-DSA is based on another PQC scheme called CRYSTALS-DILITHIUM and contains three main algorithms: ML-DSA.KeyGen, ML-DSA.Sign and ML-DSA.Verify. The security of ML-DSA is based on the M-LWE problem over Rq and a non-standard variant of M-SIS called SelfTargetM-SIS (NIST, 2024a). ML-DSA comes in three different configurations: ML-DSA 8 7, ML-DSA 6 5 and ML-DSA 4 4. ML-DSA 8 7 provides the highest security with a strength category 5, whilst ML-DSA 4 4 provides the lowest with a strength category 2 (NIST, 2024a). As the security becomes higher, so does the key and signature size (See table 2.3). 
ML-DSA 4 4 ML-DSA 6 5 ML-DSA 8 7 Public-Key Size 1312 1952 2592 Private-Key Size 2560 4032 4896 Signature Size 2420 3309 4627 
Table 2.3: Key and Signature sizes of ML-DSA (bytes), adapted from NIST (2024a) 
ML-DSA contains both internal and external functions. During this study we will focus on the internal functions. for key-generation, signing and verifying. 
Key-Generation Algorithm 
The internal key generation algorithm called ”ML-DSA.KeyGen internal” works by using a 32-byte random seed and outputs one public key and one private key, both of which are encoded as byte strings (NIST, 2024a). The seed ξ is expanded as needed using an extendable output function which is a byte-variant of SHAKE256. This is denoted by H to produce other random values. Some of these other values include: A public 32-byte seed ρ. Using this seed a polynomial matrix A ∈ Rk×lq is pseudorandomly 
sampled from Rk×lq (NIST, 2024a). 
A 64-byte private random seed ρ. By using this seed, the polynomial vectors s1 ∈ Rlq and 
s2 ∈ Rkq are pseudorandomly sampled from the subset of polynomial vectors whose coordinate polynomials have short coefficients in the range [−η, η] (NIST, 2024a). A 32 byte private random seed K used during signing. 
The core cryptographic operation, which computes the public value, is (NIST, 2024a) 
t = As1 + s2 (2.2) 
The vector t combined with the matrix A can be seen as an expanded form of the public key. It is compressed in the public key by dropping the d least significant bits from each coefficient, which produces the polynomial vector t1. The reasoning behind compressing t is not related to security, but instead related to performance. The low-order bits of t can be reconstructed from a small number of signatures and do therefore not have to be regarded as a secret. 
The ML-DSA public key pk is a byte encoding of the public random seed ρ and the compressed polynomial vector t1 (NIST, 2024a). 
The ML-DSA private key sk is a byte encoding of: The public random seed ρ and a private random seed K for usage during signing 
13
A 64-byte hash tr of the public key for usage during signing The secret polynomial vectors s1 and s2 A polynomial vector t0 which encodes the least significant bits of each coefficient of the 
uncompressed public-key polynomial t (NIST, 2024a). 
Algorithm 1 ML-DSA.KeyGen internal(ξ) 
Generates a public-private key pair from a seed. Input: Seed ξ ∈ B32 
Output: Public key pk ∈ B32+32k(bitlen(q−1)−d) 
and private key sk ∈ B32+32+64+32·((l+k)·bitlen(2η)+dk) 
1: (ρ, ρ′,K) ∈ B32 × B64 × B32 ← H(ξ∥IntegerToBytes(k, 1)∥IntegerToBytes(l, 1), 128) ▷ expand seed 
2: Â← ExpandA(ρ) ▷ A is generated and stored in NTT representation as Â 3: (s1, s2)← ExpandS(ρ′) 4: t← NTT−1(Ā ◦NTT(s1)) + s2 ▷ compute t = As1 + s2 5: (t1, t0)← Power2Round(t) ▷ compress t 6: ▷ PowerTwoRound is applied componentwise 7: pk ← pkEncode(ρ, t1) 8: tr ← H(pk, 64) 9: sk ← skEncode(ρ,K, tr, s1, s2, t0) ▷ K and tr are for use in signing 
10: return (pk, sk) 
(NIST, 2024a) 
Signing Algorithm 
The internal signing algorithm for ML-DSA is called ML-DSA.Sign Internal. This algorithm outputs a signature encoded as a byte string. It takes the private key sk encoded as a byte string, a formatted message M encoded as a bit string, and a 32-byte string rnd as input. The signing algorithm can be used in two different ways: hedged or deterministic. The two differ in how rnd is assigned. For the default, hedged, rnd is assigned a fresh random value. For the optional deterministic, they use the constant byte string {0}32. Both different ways start off with the signer extracting the following private key: The public random seed ρ, The 32-byte private random seed K, The 64-byte hash of public key tr, The secret polynomial vectors s1 and s2, The polynomial vector t0 which encodes the d least significant bits of each coefficient of the uncompressed public-key polynomial t. 
ρ is then expanded to the same matrix A as in the key generation algorithm (NIST, 2024a). Before message M is signed, it is concatenated with the public-key hash tr and hashed down 
to a 64-byte message representative µ using the following function (NIST, 2024a): 
H(str, l) = SHAKE256(str, 8l) (2.3) 
The signer produces one more 64-byte seed ρ′′ with the purpose of private randomness during each signing operation. ρ′′ is computed by ρ′′ = H(K||rnd||µ, 64) (NIST, 2024a). In the default 
14
hedged variant, rnd is the output of RBG. In the deterministic variant, rnd is a 32-byte string which consists of only zeros (NIST, 2024a). 
The main part of the signing algorithm is a rejection sampling loop in which each iteration of the loop creates a signature. It can be either valid or invalid; the invalid ones would leak sensitive information regarding the private key. This iteration continues until a valid signature is created; this signature is encoded as a byte string and output (NIST, 2024a). The iteration follows the Fiat-Shamir with Aborts Paradigm, and its structure is similar to that of a Schnorr signature. The signer first produces a ”commitment” w1 and then pseudorandomly derives a ”challenge” c from w1 and the message representative µ. The last step is for the signer to compute a response z (NIST, 2024a). 
15
Algorithm 2 ML-DSA.Sign Internal(sk,M ′, rnd) 
Input: Private key sk ∈ B32+32+64+32·((ℓ+k)·bitlen(2η)+dk), formatted message M ′ ∈ {0, 1}∗, per-message randomness rnd ∈ B32 
Output: Signature σ ∈ Bλ/4+ℓ·32·(1+bitlen(γ1−1))+ω+k 
1: (ρ,K, tr, s1, s2, t0)← skDecode(sk) 2: ŝ1 ← NTT(s1) 3: ŝ2 ← NTT(s2) 4: t̂0 ← NTT(t0) 5: Â← ExpandA(ρ) 6: µ← H(BytesToBits(tr) ∥M ′, 64) 7: ρ′′ ← H(K ∥ rnd ∥ µ, 64) 8: κ← 0 9: (z, h)← ⊥ 
10: while (z, h) = ⊥ do 11: y ∈ Rℓq ← ExpandMask(ρ′′, κ) 
12: w ← NTT−1(Â ◦ NTT(y)) 13: w1 ← HighBits(w) 14: c̃← H(µ ∥ w1Encode(w1), λ/4) 15: c ∈ Rq ← SampleInBall(c̃) 16: ĉ← NTT(c) 17: ⟨cs1⟩ ← NTT−1(ĉ ◦ ŝ1) 18: ⟨cs2⟩ ← NTT−1(ĉ ◦ ŝ2) 19: z ← y + ⟨cs1⟩ 20: r0 ← LowBits(w − ⟨cs2⟩) 21: if ∥z∥∞ ≥ γ1 − β or ∥r0∥∞ ≥ γ2 − β then 22: (z, h)← ⊥ 23: else 24: ⟨ct0⟩ ← NTT−1(ĉ ◦ t̂0) 25: h← MakeHint(−⟨ct0⟩, w − ⟨cs2⟩+ ⟨ct0⟩) 26: if ∥⟨ct0⟩∥∞ ≥ γ2 or the number of 1’s in h is greater than ω then 27: (z, h)← ⊥ 28: end if 29: end if 30: κ← κ+ ℓ 31: end while 32: σ ← sigEncode(c̃, z mod ±q, h) 33: return σ 
(NIST, 2024a) 
Verifying 
The algorithm for verifying is called ML-DSA.Verify internal. The algorithm takes: public-key pk encoded as a byte string, message M encoded as a byte string, signature σ encoded as a byte string as an input (NIST, 2024a). 
16
The algorithm does not use any form of randomness but instead outputs a boolean value. The boolean value represents whether the signature is valid or not (true if valid, false if invalid). The algorithm sets the length of the signature σ and public-key pk. If an implementation can accept any input lengths other than those specified, the algorithm will return false if any of these parameters differ from the specified (NIST, 2024a). 
The verifier first extracts the public random seed ρ along with the compressed polynomial vector t1 from the public-key pk. After the previous step, the verifier extracts the signer’s commitment hash c̃, response z and hint h from signature σ (NIST, 2024a). 
If the hint is not properly byte encoded (denoted by ⊥), then the algorithm will return false, indicating that the signature is invalid. If the signature is valid and successfully extracted from its byte encoding, the verifier pseudorandomly derives A from ρ and creates a message representation µ by hashing the concatenation of tr and the messageM (NIST, 2024a). 
The verifier will then try to reconstruct the signer’s commitment (which is the polynomial vector w1) from the public key and the signature. In the signing algorithm, w1 is computed by rounding w = Ay . In the verifying algorithm, the reconstructed value of w1 is called w′ 
1; the reason behind this is that it might be calculated in different ways depending on if the signature is valid or invalid. The process to calculate w′ 
1 is as follows: Derive and challenge polynomial c from the signer’s commitment hash c̃, just as it is done in the signing algorithm. The signer’s response is then used to calculate the following equation: 
w′ Approx = Az − ct1 × 2d (2.4) 
If we assume that the signature was computed correctly, then it follows: 
w = Ay = Az− ct+ cs2 ≈ w′ Approx = Az − ct1 × 2d (2.5) 
Because c and s2 have small coefficients and t1 × 2d ≈ t . 
The signers hint h is used to calculate w′ 1 from w′ 
Approx (NIST, 2024a). 
After w′ 1 has been calculated, the verifier checks that the signer’s response and hint are valid 
and that the reconstructed w′ 1 matches the signer’s commitment hash c̃. If these checks succeed, 
then the algorithm will return true (NIST, 2024a). 
17
Algorithm 3 ML-DSA.Verify Internal(pk,M ′, σ) 
Input: Public key pk ∈ B32+32k(bitlen(q−1)−d), formatted message M ′ ∈ {0, 1}∗, signature σ ∈ Bλ/4+ℓ·32·(1+bitlen(γ1−1))+ω+k 
Output: Boolean 
1: (ρ, t1)← pkDecode(pk) 2: (c̃, z, h)← sigDecode(σ) 3: if h = ⊥ then 4: return false 5: end if 6: Â← ExpandA(ρ) 7: tr ← H(pk, 64) 8: µ← H(BytesToBits(tr) ∥M ′, 64) 9: c ∈ Rq ← SampleInBall(c̃) 
10: w′ Approx ← NTT−1 
( Â ◦ NTT(z)− NTT(c) ◦ NTT(t1 · 2d) 
) 11: w′ 
1 ← UseHint(h,w′ Approx) 
12: c̃′ ← H(µ ∥ w1Encode(w′ 1), λ/4) 
13: return ( ∥z∥∞ < γ1 − β 
) ∧ 
( c̃ = c̃′ 
) (NIST, 2024a) 
18
3 Problem and Re-lated Research 
Quantum computers are estimated to be able to break the cryptographic algorithms used today. This means post-quantum cryptography will become increasingly important as access to quantum computers becomes more widespread. However, because of attacks such as harvest now decrypt later(HNDL), we already face severe risks of sensitive data leaking in the future (Sijjad et al., 2025). During a multi-year process, the National Institute of Standards and Technology(NIST) has constructed three standards: FIPS 203, FIPS 204 and FIPS 205 and is in the process of creating its fourth one called FIPS 206 (Perlner, 2025). The three quantum-vulnerable digital signature algorithms, which are approved today, ECDSA, EdDSA and RSA, are all planned to be disallowed by 2035, with the 112-bit security strength variants being deprecated by 2030 (Moody et al., 2024). NIST is now calling on organisations to migrate to quantum-safe algorithms for digital signatures and key-encapsulation mechanisms, as described by Moody et al. (2024). The problem is that even though the technology is described as ready, many organisations lack plans to move to quantum-safe technology, something which is discussed by Zimmermann, Ra-jsingh, De La Cruz, Jorge De Queiroz, Rana, and Nadella (2025). In their article, they have interviewed experts from different organisations active in different sectors. What they find is that even though many organisations are conscious of the risks of quantum computing to cybersecurity and threats such as HNDL, they have no plan to migrate to quantum-safe tech. Zimmermann et al discovered that the barriers to wider adoption were mostly non-technical. Only 35 % of respondents had begun overseeing the current systems. The authors argue that bridging the gap between urgency and preparedness requires not only reducing the costs and complexity of early adoption but also implementing targeted awareness campaigns and industry-specific guidelines. 
The research area is active even though the access to quantum-computers is scarce since no quantum-computers are needed to use PQC algorithms. We are not interested in the quantum-computers themselves, but rather the technology which allows us to protect us from them in the future. The scaleability of currently available algorithms is relevant since even small changes in signing speed and verifying speed could heavily affect certain areas such as banking. Information which today is encrypted using classical encryption such as opening and closing positions on the market relies on quick speed of the encryption algorithms used to protect sensitive information. 
For this study, we will compare two standardised post-quantum cryptographic digital sig-
19
nature algorithms and will compare them with regard to important measurements for internet communication. The motivation behind this research comes from Zimmermann et al. (2025) and Singh, Sood, and Bhatia (2025). Both these articles argue in the future work section that looking at omptimising PQC algorithms in limited contexts such as IoT devices and edge devices is an important future direction. Comparing PQC algorithms to a baseline classical algorithm increases the understanding of performance differences between algorithms and may provide a foundation for future research in constrained communication environments. 
3.1 Aim 
The aim of this research is to evaluate the performance and scaleability limitations of existing post-quantum cryptographic algorithms in existing systems. We focus on comparing ML-DSA, SLH-DSA and the classical encryption algorithm Ed25519. The comparison will allow us to highlight how post-quantum cryptographic algorithms affect performance in existing systems and how they differ from each other and a classical encryption algorithm, which is widely used today. 
3.2 Research Questions 
1. How do ML-DSA differ from Ed25519 in signing speed when sending data locally? 
2. How do ML-DSA differ from Ed25519 in verifying speed when receiving data locally? 
3. How do SLH-DSA differ from Ed25519 in signing speed when sending data locally? 
4. How do SLH-DSA differ from Ed25519 in verifying speed when receiving data locally? 
3.3 Hypotheses 
 H1.1: There is a statistically significant difference between ML-DSA and Ed25519 in signing speed when sending data locally 
 H1.0: There is no statistically significant difference between algorithms 
 H2.1: There is a statistically significant difference between ML-DSA and Ed25519 in verifying speed when receiving data locally 
 H2.0: There is no statistically significant difference between algorithms 
 H3.1: There is a statistically significant difference between SLH-DSA and Ed25519 in signing speed when sending data locally 
 H3.0: There is no statistically significant difference between algorithms 
 H4.1: There is a statistically significant difference between SLH-DSA and Ed25519 in verifying speed when sending data locally 
 H4.0: There is no statistically significant difference between algorithms 
20
3.4 Objectives 
1. Develop an understanding of selected PQC algorithms 
2. Identify performance limitations of selected algorithms 
3. Compare chosen algorithms to evaluate performance scaleability 
3.5 Related Research 
There has been a significant amount of similar research due to the multi-year standardisation processes completed worldwide. One such study is the Korean Post Quantum Cryptography Standardisation (KpqC), which is discussed in the conference paper ”Evaluating KpqC Al-gorithm Submissions: Balanced and Clean Benchmarking Approach” by Kwon et al. (2024). They benchmarked both lattice-based and hash-based PQC algorithms. The algorithms were benchmarked on key-generation, encapsulation and decapsulation. Insights we can take from this study are how the experiment was conducted, how different environments were presented in the text, and how the benchmark results were presented in text and table. 
As previously stated, several documents that were produced during the process of standardisation by NIST contain similar elements to our study. One example of such a document is ”Status Report on the Third Round of the NIST Post-Quantum Cryptography Standardisation Process” by Alagic et al. (2022). This paper compares and advocates for several PQC algorithms. The chapter ”cost and performance” contained several related tables and explanations of what could be measured and how it should be represented in the study. 
A similar bachelor’s thesis was conducted by Sjögren and Reutmer (2025). They compared different encryption algorithms based on execution time, packet size, block size, and key size. The algorithms they used were AES, DES, 3DES, Blowfish, and Twofish. This study resembles what we did by measuring roughly the same parameters, even though the algorithms are different. Since we conducted our experiment in a similar way to what Sjögren et al did, we can gain insights into how to best analyse the results. 
Abbasi et al. (2025) researched a similar question where non-standardised algorithms were tested on different machines. One such machine, titled Laptop E2, can be compared with the use-case configurations used in this study. Laptop E2 resembled a typical end-user device with moderate performance capabilities. One algorithm which was benchmarked was CRYSTALS-DILITHIUM, the predecessor to ML-DSA. The benchmarks, however, did not focus on the scalability of the algorithms but rather on the performance across the different security levels. Bernstein et al. (2019) introduced SHPINCS+, a stateless hash-based digital signature scheme, and benchmarked its performance in terms of signing speed, verification speed, and signature size. This article is relevant to this study because SLH-DSA is the NIST-standardized version of SPHINCS+. However, the benchmarks focused on comparing SPHINCS+ with earlier hash-based signature schemes rather than evaluating its performance in a messaging system. 
21
4 Method 
The choice of method contributed to the study’s effectiveness regarding the results. The choice of method reflected and supported the research questions and promoted a study with the correct focus. 
4.1 Choice of Method 
This study used a quasi-experimental design to effectively answer the research questions. The method used for this study is explained in 4.2 , after which a section containing information about alternative methods will come at 4.3. 
4.2 Method Description 
According to Wohlin et al. (2012), an experiment in software engineering can be described as an empirical enquiry which manipulates one variable of the studied setting. Different treatments are applied to subjects while keeping other variables constant, allowing us to measure the effect caused by the change. By conducting an experiment, we were able to, in a semi-controlled environment, adjust the independent variables (explanation Section 4.4) to different treatment levels. We then studied the change in the dependent variables (verifying speed, signing speed and memory usage). We studied this relationship between effect and change to test the hypotheses defined in Chapter 3. This ultimately allowed us to answer the research questions which this study set out to investigate. Quasi-experiment is as follows: an empirical enquiry similar to an experiment, where the assignment of treatments to subjects cannot be based on randomisation, but emerges from the characteristics of the subjects or objects themselves (Wohlin et al., 2012). The experiment we conducted was a quasi-experiment because the experiment was conducted in environments where we could not control all relevant variables, such as hardware limitations and background processes. Furthermore, we classified it as a quasi-experiment because of the fact that there is no randomisation involved in the benchmarking of algorithms. 
The experiment featured a quantitative data analysis. A quantitative data analysis typically features elements such as analysis of descriptive statistics, correlation analysis, development of predictive models and hypothesis testing (Wohlin et al., 2012). During our analysis, we conducted an analysis of descriptive statistics sing the statistical analysis tool Minitab of results. 
22
Hypothesis testing was used to show the independent variables effect on the dependent variables (Wohlin et al., 2012). One important thing regarding a quantitative data analysis is that it requires a fixed research design. If a research question which expects a quantitative answer is changed throughout the study, then the values that were computed previously will no longer be relevant (Wohlin et al., 2012). 
4.3 Alternative Methods 
One alternative method which was discussed for this study, was a Systematic Literature Review(SLR). SLR employs a structured and transparent process to identify and select articles, adhering to clear limitations while minimising the risk of bias. The database or register from which the articles have been chosen is also specified when using an SLR. Main themes are then identified, and the results are presented. A general interpretation is then provided where important implications are discussed (Page et al., 2021). To identify and analyse the content of the articles, an analytical technique is used. One clear takeaway is that SLR focuses on using existing research and evidence to give a clear and comprehensive picture of the research question. This is the reason it was not chosen as the research method for this study. As it would not have allowed us to tailor the experiment to our research questions, but instead find appropriate existing research to answer the research questions. The process of finding research and applying it to our study would, compared to the chosen research method, be more and time-consuming and difficult because of the need to find appropriate sources, which is the main reason why an SLR was not chosen as our research method. Two examples of SLR´s which has been conducted within the field of post-quantum cryptography are ”Migrating Software Systems Toward Post-Quantum Cryptography-A Systematic Literature Review” by Näther et al. (2024) and ”Post-quantum Cryptography: A Review on Cryptographic Solutions for the Era of Quantum Computing” by Singh et al. (2025). Näther et al. (2024) discusses different migration strategies and attempts to give a clear overview of the current state of migration to PQC algorithms. Singh et al. (2025) aims to provide a comprehensive overview of the current state of post-quantum cryptography by analysing roughly 3800 articles connected to PQC found in the scopus database. Another reason to why a structured literature review was not selected as our research method was because articles like these already exist and another one would not contribute in anyway. 
Another research method, which was briefly discussed, was to perform a survey. A survey can be used when the use of a technique or tool has already taken place or before it is introduced (Wohlin et al., 2012). When performing a survey, we select a sample from a population. Using the samples, we can perform interviews or create questionnaires which will help us gather qualitative data which can be analysed and used to draw conclusions (Wohlin et al., 2012). For example, a survey using interviews of experts within the field of quantum-computing was discussed. This would allow us to get well-educated views on how the PQC algorithms compare to each other and the classical algorithm. This would result in qualitative data analysis since we would not get any numbers or statistics to work with. We did not opt for a survey because of the difficulty of finding experts in the area willing to be interviewed. It seemed more appropriate to receive our results from a quantitative experiment instead. 
Different algorithms were considered for this experiment. At first thought CRYSTALS-
23
DILITHIUM and Falcon were considered. Since both of these are lattice-based cryptographic algorithms falcon was deselected. Thoughts were kept at CRYSTALS-DILITHIUM and other hash-based algorithms which had been selected in the final round were looked at, this lead us to SPHINCS+. When looking closer at these algorithms we found that they had both been standardised and resconstructed into ML-DSA(CRYSTALS-DILITHIUM) and SLH-DSA(SPHINCS+). The difference between the draft versions and final versions are described in each standardisation document. FIPS 204 (NIST, 2024a) for ML-DSA and FIPS 205 (NIST, 2024b) for SLH-DSA. 
4.4 Approach 
The approach applies an experimental method in a semi-controlled environment. The purpose is to measure which effects replacing a classical digital signature algorithm Ed25519 with post-quantum algorithm would have. We measure the PQC algorithms SLH-DSA and ML-DSA and see how they affect the systems performance in a messaging application. 
The independent variables in the experiment were the selected signature algorithm, the payload sizes and the specific hardware configurations. The dependent variables were signing time, verification time and memory usage. The reason why the experiment measured these metrics is because of their frequent use in the related works. All related works containing benchmarks, such as the ones by Alagic et al. (2022), Kwon et al. (2024), Sjögren and Reutmer (2025) and Abbasi et al. (2025), measured the algorithms on either signing speed and verifying speed or encapsulation and decapsulation, which are synonyms for the previously mentioned signing speed and verifying speed. 
The experiment were executed on three different hardware configurations to observe how the algorithms perform under different system environments. This decision was made after early testing showed noticeable differences in signing and verification performance between the use case 1 and the use case 2 configurations. To get a better understanding how hardware affects the performance of the algorithm, the experiments were therefore repeated on multiple machines as displayed in table 4.1. Additionally, another motivation for using multiple hardware configurations was to represent different real world use cases. This allows the study to reflect better how the algorithms would perform on everyday user devices and make the result more relevant for every day users. 
Use case System Type OS CPU CPU-Speed Chip Architecture 
Use case 1 Laptop Ubuntu 24.04 LTS Intel i7-1355U 3.7 GHz x86-64 
Use case 2 MacBook macOS 14.6.1 Apple M2 3.5 GHz ARM64 
Use case 3 Desktop Windows 11 Intel i5-12600KF 3.7 GHz x86-64 
Table 4.1: Summary of systems used in the experiment (same procedure applied to all). 
The work began by searching and reviewing suitable open-source chat applications on GitHub. The chat application chosen was the real-time chat API application created by Altrawan (altrawan, 2024). The system is a Telegram inspired chat application. It is built using Node.js and Express.js providing REST APIs for message transmission. The system uses Socket.IO for instant real-time messages and PostgreSQL for managing users. The original application used a database to store messages and user information, this was not needed in our tool which lead to these features were removed. This simplified the system and made it 
24
easier to integrate and test the three digital-signature algorithms. Later on, a decision was made to run both the server and the client locally. The client was implemented using the Socket.io library, which works with the server to communicate directly with a local Socket.io client. Both the server and the client were implemented in JavaScript using Node.js version 22.0.0 
The first step in the implementation of the algorithms was to integrate the classical digital signature algorithm Ed25519 into the chat application. We chose to use Ed25519 as the baseline algorithm because it represents a widely used and well-established classical signature scheme. The implementation was done with the help of the Node.js built-in crypto module library (Node.js Foundation, 2026), which gave support for Ed25519 key generation, signing and verification. With the help of the crypto library, a key pair was generated for each user, and messages were signed before they were sent through the chat system. When a message was received, the signature was then verified to ensure authenticity and message integrity. The Ed25519 implementation was used as a reference point and provided a performance baseline for later comparisons with the post-quantum algorithms SLH-DSA and ML-DSA. 
When Ed25519 was implemented, the implementation to allow switching between different signature algorithms was implemented with the help of a factory script. The factory was responsible for selecting which algorithm should be active during execution. With the help of factory, it was possible to choose between Ed25519, SLH-DSA or ML-DSA without the need to modify the main chat application logic. This ensured that all algorithms were tested within the same system environment and ensured that only the signature algorithm itself was changed during the experiments. Only the signature algorithm, payload size and machine configuration was changed between experiments. All other parts of the system, including the application logic, remained identical in every benchmark run. 
The post-quantum algorithms SLH-DSA and ML-DSA were integrated with the help of the open-source library liboqs.js (Open Quantum Safe, 2024). This library is based on an open quantum-safe projector and provides JavaScript implementations of standardised post-quantum algorithms. 
Liboqs was important for the project because it supported the latest standardised version of SLH-DSA (FIPS 205) and ML-DSA (FIPS 204). The official specifications that were published by NIST reference the implementations of the algorithms in the programming language C. However, since the chat application was implemented in JavaScript, the signature algorithms was easier to implement and also resulted in more accurate test results. With the help of liboqs, it allowed the post-quantum algorithms to be integrated directly into the existing JavaScript chat system. 
After the library was selected, SLH-DSA-SHA-192s and ML-DSA-65 variants were integrated into the chat application using the factory functions provided by the library. During testing, the algorithm instance was created once and then reused during the execution. This allowed it to run 10 000 times, and also ensured that the result reflected the actual signing and verification performance of the algorithms and avoided measuring initialisation time during benchmarks. Both algorithm variants were chosen because they represent mid-level security parameters among all the different variants. Different security levels exist within the algorithms, lower security levels (level 1) were not selected because they provide reduced security strength. A higher security level (level 5) was not selected either, since they produce too large a signature, resulting in higher computational cost. So level 3 was therefore chosen as a balanced middle 
25
ground within a realistic security level and balanced computational cost. SLH-DSA-SHA2-192 and ML-DSA-65 both correspond to a similar standardised security level 3. Both these variants were selected to help provide a balanced comparison between security strength and signature size. 
Along with signing speed and verifying speed, a third variable is also measured, memory usage. The benchmarking tool measures the total amount of memory used by the node process when signing, transmitting and verifying the message. The memory usage is stored along the other values. To measure the amount of memory used we implemented the tool memory-monitor created by user alexvcasillas (2025) and published on GitHub. 
To execute the benchmarks, a separate client script sendMessage.js was created. This script is connected to the local server and automatically sends messages for testing. In sendMessage.js, both the number of iterations and the message size are defined and can be easily changed before execution. For the final experiment configuration, each algorithm was executed for 10 000 iterations. Four different payload sizes were used during the experiment, 100 bytes, 1 000 bytes, 10 000 bytes and 100 000 bytes. sendMessage.js file allowed full control over how many times each algorithm was tested and how large the message payload was. The same predefined message size and iteration counts were used for all algorithms. This ensured that each algorithm was tested with identical input conditions to reach fairness with every test run. 
During each iteration, the message is signed, transmitted and then verified and in the meantime the memory is logged. The signing time and verification time are recorded for every execution. Later on, the collected data was stored in two files, one json file and one csv file. Each file is created uniquely for the parameters used to run the benchmark. This will also ensure that each test run produces a new clean dataset without mixing the results from earlier executions. 
After each benchmark run, the collected data were processed in the program Minitab. Minitab automatically calculated statistical values like mean, median, minimum and maximum. The results were then used to compare the algorithms. 
The experiment can be reproduced by running the benchmark tool again and selecting the desired signature algorithm, defining the number of iterations the algorithm should run and also the message size in the test script. This ensures that the experiment is reproducible under the same system conditions. 
26
5 Results 
Results were gathered by running the benchmarking program (Ranhög and Herre, 2026) following the instructions in README.md. The benchmarks were run as described in the approach, and the program saved the results as CSV files. These files were then opened in Minitab. The CSV files for each algorithm and each system were stacked and analysed by creating boxplot graphs and bar charts. Minitab was also used to gain descriptive statistics of the data, which allowed for the creation of different tables showcasing mean values and several line plots. When there was no visible difference between groups, ANOVA tests were run to confirm that a statistical significance existed. The statistical signifiant difference was needed in order to test our hypothesis by either proving or denying a statistically significant difference. On some occasions, additional Tukey tests were run to see where the statistical significance was located. 
27
5.1 Ed25519 
5.1.1 Payload effect on signing time 
Figure 5.1: Box Plot of signing time (ms) vs payloadSize (bytes) for Ed25519 on use case 1 
Figure 5.2: Box Plot of signing time (ms) vs payloadSize (bytes) for Ed25519 on use case 2 
28
Figure 5.3: Box Plot of signing time (ms) vs payloadSize (bytes) for Ed25519 on use case 3 
100 1000 10000 100000 0 
0,1 
0,2 
0,3 
0,4 
Payload size (bytes) 
T im 
e (m 
s) 
Mean Sign Time (Ed25519) 
Use case 1 Use case 2 Use case 3 
Figure 5.4: Mean Sign time for Ed25519 on Use case 1, Use case 2 and Use case 3. 
29
Use case 100 Bytes 1000 Bytes 10000 Bytes 100000 Bytes Use case 1 0,030531 0,034496 0,068013 0,402793 Use case 2 0,031376 0,034570 0,054868 0,253256 Use case 3 0,029105 0,034128 0,06307 0,33776 
Table 5.1: Mean signing times using Ed25519 across all use case configurations 
Use case configuration P-value Use case 1 < 0,01 Use case 2 < 0,01 Use case 3 < 0,01 
Table 5.2: ANOVA tests for signing time using Ed25519 across all use case configurations 
From above figures and tables it is visible that signing times increase as payload increases when signing using Ed25519. The signing was quickest on use case 2 followed by use case 3. The signing process was the slowest on use case 1. To asses if a statistical significance existed, an ANOVA test was performed. The ANOVA test showed that there existed a statistical significance. 
5.1.2 Payload effect on verifying time 
Figure 5.5: Box Plot of verifying time (ms) vs payloadSize (bytes) for Ed25519 on Use case 1 
30
Figure 5.6: Box Plot of verifying time (ms) vs payloadSize (bytes) for Ed25519 on Use case 2 
Figure 5.7: Box Plot of verifying time (ms) vs payloadSize (bytes) for Ed25519 on Use case 3 
31
100 1000 10000 100000 0 
0,1 
0,2 
0,3 
Payload size (bytes) 
T im 
e (m 
s) 
Mean Verify Time (Ed25519) 
Use case 1 Use case 2 Use case 3 
Figure 5.8: Mean Sign time for Ed25519 on Use case 1, Use case 2 and Use case 3 
Use case configuration 100 Bytes 1000 Bytes 10000 Bytes 100000 Bytes Use case 1 0,087463 0,089104 0,107268 0,288459 Use case 2 0,080974 0,084041 0,095262 0,215854 Use case 3 0,075923 0,082622 0,097961 0,243883 
Table 5.3: Mean verifying times using Ed25519 across all use case configurations 
Use case configuration P-value Use case 1 < 0,01 Use case 2 < 0,01 Use case 3 < 0,01 
Table 5.4: ANOVA tests for verification time using Ed25519 across all use case configurations 
The figures and tables show that the verifying speeds follow a similar pattern to those of the signing speed. The verifying times increased as the payload size was increased. The verifying speeds differed depending on the hardware configuration. For 100 bytes, use case 2 was the quickest. For 1000 bytes, use case 3 was the quickest. For the remaining payload sizes, use case 2 was the quickest. Just as for the signing speeds, use case 1 was the slowest across all payload sizes. An ANOVA test was run to asses if a statistical significance existed, the results from the ANOVA test confirmed it existed since p < 0,01. 
32
5.2 ML-DSA 
5.2.1 Payload effect on signing time 
Figure 5.9: Box Plot of signing time (ms) vs payloadSize (bytes) for ML-DSA on Use case 1 
Figure 5.10: Box Plot of signing time (ms) vs payloadSize (bytes) for ML-DSA on Use case 2 
33
Figure 5.11: Box Plot of signing time (ms) vs payloadSize (bytes) for ML-DSA on Use case 3 
100 1000 10000 100000 0 
0,2 
0,4 
0,6 
0,8 
Payload size (bytes) 
T im 
e (m 
s) 
Mean Sign Time (ML-DSA) 
Use case 1 Use case 2 Use case 3 
Figure 5.12: Mean Sign time for ML-DSA on use case 1, use case 2 and use case 3 
34
use case configuration 100 Bytes 1000 Bytes 10000 Bytes 100000 Bytes Use case 1 0,33909 0,34502 0,39313 0,84633 Use case 2 0,27392 0,27660 0,32469 0,75340 Use case 3 0,27926 0,28154 0,32711 0,66815 
Table 5.5: Mean signing times using ML-DSA across all use case configurations 
Use case configuration P-value Use case 1 < 0,01 Use case 2 < 0,01 Use case 3 < 0,01 
Table 5.6: ANOVA tests for signing time using ML-DSA across all use case configurations 
The ML-DSA signing benchmarks show that the signing times increase as the payload size increases. This is true for all use case configurations. Just as before, use case 1 is the slowest, followed by use case 3. Use case 2 performed the signing the quickest. To show a statistical significance existed, an ANOVA test was performed. The test indicated statistical significance since p < 0,01. 
5.2.2 Payload effect on verifying time 
Figure 5.13: Box Plot of verifying time (ms) vs payloadSize (bytes) for ML-DSA on Use case 1 
35
Figure 5.14: Box Plot of verifying time (ms) vs payloadSize (bytes) for ML-DSA on Use case 2 
Figure 5.15: Box Plot of verifying time (ms) vs payloadSize (bytes) for ML-DSA on Use case 3 
36
100 1000 10000 100000 0 
0,2 
0,4 
0,6 
Payload size (bytes) 
T im 
e (m 
s) 
Mean Verify Time (ML-DSA) 
Use case 1 Use case 2 Use case 3 
Figure 5.16: Mean Sign time for ML-DSA on Use case 1, Use case 2 and Use case 3. 
Use case configuration 100 Bytes 1000 Bytes 10000 Bytes 100000 Bytes Use case 1 0,098435 0,103117 0,145276 0,59363 Use case 2 0,075123 0,080547 0,122493 0,57164 Use case 3 0,081246 0,083828 0,120865 0,44021 
Table 5.7: Mean verification times using ML-DSA across all use case configurations 
Use case configuration P-value Use case 1 < 0,01 Use case 2 < 0,01 Use case 3 < 0,01 
Table 5.8: ANOVA tests for verification time using ML-DSA across all use case configurations 
The results for the benchmarks on verifying time on ML-DSA show that just as for the signing times, performance worsens when the payload size is increased. The performance is worse on use case 1. Use case 3 and use case 1 perform similarly until the payload size is increased to 100,000 bytes. Then Use case 2 instead performs similarly to use case 1. To assess whether a statistical significance exists, ANOVA tests were run. The test shows that a statistically significant differences between payload sizes. 
37
5.3 SLH-DSA 
5.3.1 Payload effect on signing time 
Figure 5.17: Box Plot of signing time (ms) vs payloadSize (bytes) for SLH-DSA on Use case 1 
Figure 5.18: Box Plot of signing time (ms) vs payloadSize (bytes) for SLH-DSA on Use case 2 
38
Figure 5.19: Box Plot of signing time (ms) vs payloadSize (bytes) for SLH-DSA on Use case 3 
100 1000 10000 100000 0 
200 
400 
600 
800 
Payload size (bytes) 
T im 
e (m 
s) 
Mean Sign Time (SLH-DSA) 
Use case 1 Use case 2 Use case 3 
Figure 5.20: Mean signing time for SLH-DSA on Use case 1, Use case 2 and Use case 3. 
39
Use case configuration 100 Bytes 1000 Bytes 10000 Bytes 100000 Bytes Use case 1 840,488 840,251 840,956 840,165 Use case 2 782,170 772,724 773,376 773,034 Use case 3 667,520 665,610 667,852 667,230 
Table 5.9: Mean signing times using SLH-DSA across all use case configurations 
Use case configuration P-value Use case 1 < 0,01 Use case 2 < 0,01 Use case 3 < 0,01 
Table 5.10: ANOVA tests for signing time using SLH-DSA across all use case configurations 
The results from the benchmark measuring signing times for SLH-DSA show that signing speed does not follow the same increasing trend as seen earlier. There are no clear indications that increasing the payload size will affect the performance. Use case 1 has the worst performance, followed by use case 2. Use case 3 has the best performance. ANOVA tests were run to find a statistical significance, since p < 0,01 it suggests that a statistical significance exists. Tukey post-hoc tests were conducted for SLH-DSA. What this tells us is that not all relations between groups were statistically significant. All Tukey test result are presented in Appendix A(A.1 A.2 A.3 A.4 A.5 A.6) 
5.3.2 Payload effect on verifying time 
Figure 5.21: Box Plot of verifying time (ms) vs payloadSize (bytes) for SLH-DSA on Use case 1 
40
Figure 5.22: Box Plot of verifying time (ms) vs payloadSize (bytes) for SLH-DSA on Use case 2 
Figure 5.23: Box Plot of verifying time (ms) vs payloadSize (bytes) for SLH-DSA on Use case 3 
41
100 1000 10000 100000 0 
0,2 
0,4 
0,6 
0,8 
1 
Payload size (bytes) 
T im 
e (m 
s) 
Mean verify Time (SLH-DSA) 
Use case 1 Use case 2 Use case 3 
Figure 5.24: Mean verifying times for SLH-DSA on Use case 1, Use case 2 and Use case 3. 
Use case configuration 100 Bytes 1000 Bytes 10000 Bytes 100000 Bytes Use case 1 0,716090 0,708850 0,749460 1,06026 Use case 2 0,656202 0,651054 0,680892 0,982234 Use case 3 0,580376 0,580742 0,609643 0,87960 
Table 5.11: Mean verification times using SLH-DSA across all use case configurations 
Use case configuration P-value Use case 1 < 0,01 Use case 2 < 0,01 Use case 3 < 0,01 
Table 5.12: ANOVA tests for verification time using SLH-DSA across all use case configurations 
The benchmarks which shows the verifying times for SLH-DSA show that, unlike the signing speeds, verifying speeds are affected by the increase in payload size. The performance is relatively stable in the range from 100 bytes to 10 000 bytes. But when increased to 100 000 bytes, the performance takes a large drop, this suggesting that SLH-DSA scales relatively well for smaller and medium payload sizes, but becomes more affected at larger payload sizes. One possbile reason is that the large fixed signature size of SLH-DSA dominates the total message size at smaller payloads, making the payload increases less noticeable. Use case 1 performed the worst, followed by use case 2. Use case 3 performed the best. An ANOVA test indicated a statistical significance between groups. 
42
5.4 ML-DSA vs Ed25519 
Figure 5.25: Bar chart comparing ML-DSA to baseline Ed25519 on signing speed 
Algorithm Mean StDev T-value P-value Ed25519 0,114 0,153 -332,45 < 0,01 ML-DSA 0,426 0,286 
Table 5.13: T-test for Ed25519 vs ML-DSA on signing speed 
43
Figure 5.26: Bar chart comparing ML-DSA to baseline Ed25519 on verifying speed 
Algorithm Mean StDev T-value P-value Ed25519 0,1291 0,0754 -128,32 < 0,01 ML-DSA 0,210 0,204 
Table 5.14: T-test for Ed25519 vs ML-DSA on verification speed 
The barcharts show a difference between the performance of Ed25519 and ML-DSA. The barchart represents the mean performance of all use case configurations combined. The graphs visualise the differences in performance between ML-DSA and Ed25519 on both signing and verifying operations. 
44
5.5 SLH-DSA vs Ed25519 
Figure 5.27: Bar chart comparing SLH-DSA to baseline Ed25519 on signing speed 
Algorithm Mean StDev T-value P-value Ed25519 0,114 0,153 -3672,65 < 0,01 SLH-DSA 760,9 71,8 
Table 5.15: T-test for Ed25519 vs SLH-DSA on signing speed 
45
Figure 5.28: Bar chart comparing SLH-DSA to baseline Ed25519 on verifying speed 
Algorithm Mean StDev T-value P-value Ed25519 0,1291 0,0754 -1212,09 < 0,01 SLH-DSA 0,738 0,157 
Table 5.16: T-test for Ed25519 vs SLH-DSA on verification speed 
Just as for ML-DSA vs Ed25519, the barcharts combines the data from all use case configurations and calculates the mean performance. The chart of mean sign Figure 5.27 shows that SLH-DSA performs much worse on signing operations. The verifying chart Figure 5.28 does not show a difference as large, but SLH-DSA still performs the signing operations slower compared to Ed25519. 
5.6 Memory usage 
The memory usage on each use case configuration was also measured to evaluate the memory usage by the algorithms. The memory usage was measured by implementing the module for memory logging found on github (alexvcasillas, 2025). The memory which was logged was the total amount of memory usage in megabytes, which was used by the node process during each benchmark. 
46
Figure 5.29: Memory usage between different algoritms on the use case 1 configuration 
Figure 5.30: Memory usage between different algoritms on the use case 2 configuration 
47
Figure 5.31: Memory usage between different algoritms on the use case 3 configuration 
The line plots showcasing the memory use of the algorithms show that SLH-DSA uses the least amount of memory. ML-DSA and Ed25519 are more comparable on use case 3 and use case 1. We can see that although they follow each other closely, for the most part, ML-DSA consumes more memory compared to Ed25519. 
48
5.7 Scalability 
Use Case 1 Use Case 2 Use Case 3 
0 
200 
400 
600 
800 
1.000 
1.200 1.219,29 
707,16 
1.060,49 
149,59 175,04 139,26 
−4 · 10−2 −1,17 −4 · 10−2 
P er ce n ta g e in cr ea se 
(% ) 
Ed25519 ML-DSA SLH-DSA 
Figure 5.32: Percentage increase in signing time for Ed25519 and ML-DSA when scaling payload size from 100 to 100,000 bytes 
49
Use Case 1 Use Case 2 Use Case 3 
0 
100 
200 
300 
400 
500 
600 
700 
229,81 
166,57 
221,22 
503,07 
660,94 
441,82 
48,06 49,68 51,56 
P er ce n ta g e in cr ea se 
(% ) 
Ed25519 ML-DSA SLH-DSA 
Figure 5.33: Percentage increase in verification time for Ed25519 and ML-DSA when scaling payload size from 100 to 100,000 bytes 
In the figures above, the percentage increase in signing and verifying times from 100 bytes to 100,000 bytes is shown. It is visible that for the signing times, Ed25519 had the largest percentage increase. SLH-DSA, however, performed better when the payload size was set at 100,000 bytes. For the verifying times, ML-DSA showed the largest percentage increase. SLH-DSA remained the least affected by the change in payload size. 
5.8 Hypothesis Testing 
5.8.1 H1 
A T-test was performed to confirm a statistical difference in signing speed between ML-DSA and Ed25519. The results presented in Table 5.13 allow hypothesis 1 to be tested. Since the significance level is p < 0,01 the null hypothesis H0 can be rejected and confirm H1.1 instead. H1.1 is supported by the graph in 5.25 showing that Ed25519 performs the signing process significantly quicker compared to ML-DSA. 
50
5.8.2 H2 
Another T-test was performed to confirm a statistical difference in verifying speed between ML-DSA and Ed25519 on signing speed. The results from the T-test are presented in table 5.14. Since p < 0,01 the null hypothesis H0 can be rejected and confirm the alternative hypothesis H2.1 instead. As shown in 5.26, Ed25519 performs the verifying process much quicker compared to ML-DSA. 
5.8.3 H3 
When looking at how SLH-DSA differs from Ed25519 in signing speed when data locally, a two sample t-test was condcuted as shown in table 5.15. The results show that Ed25519 achieved a lower mean signing time compared to SLH-DSA. The analysis showed a significant difference between the two algorithms with a p < 0,01. The p-value supports the alternative hypothesis H3.1 and the null hypothesis H3.0 can be rejected. 
5.8.4 H4 
When looking at how SLH-DSA differs from Ed25519 in verification speed when sending data locally, a two sample t-test was conducted as shown in the table 5.16. The result show that Ed25519 achieved a lower mean in verification time when compared to SLH-DSA. The analysis showed a significant difference between the algorthims p < 0,01. The p-value supports the alternative hypothesis H4.1 and the null hypothesis H4.0 can be rejected. 
51
6 Discussion 
6.1 Analysis 
6.1.1 ML-DSA vs Ed25519 
These results answer the research questions 1 and 2. For research question 1 regarding the signing speed. Our experiment showed that ML-DSA is slower compared to Ed25519. For research question 2 regarding verifying time. Our experiment shows that ML-DSA is slower than Ed25519 when receiving data. Our experiment shows that there exists a difference in performance between the algorithms Ed25519 and ML-DSA. 
Having proved our alternative hypotheses H1.1 and H2.1 and showing that ML-DSA performs on average slower than the classical algorithm Ed25519, we have to consider the implications of this. What we saw was that ML-DSA and Ed25519 were comparable, but ML-DSA performed slower for both signing and verifying, as seen in figures 5.25 and 5.26. This will ultimately limit the use cases for ML-DSA. An increase of roughly 0,3ms may be acceptable in applications such as messaging applications where users would rather see their messages being transmitted in a safe manner over faster speeds; however, in other applications, this might not be the case. For example, in real-time systems. An example of such system is a live trading platform that allows users to trade on the market. Such platforms needs to be secure because of the transmission of private information. However, live trading relies on the fact that a message can be sent quickly in order to open a position in a specific market, and a millisecond latency can result in financial loss for the user. This tradeoff highlights the barriers to adopting PQC algorithms. 
Further examining the differences between these two algorithms, it can be observed in Figures 5.29, 5.30, and 5.31 how these algorithms differ in the use of memory. We can see the lines representing ML-DSA and Ed25519 follow each other closely throughout the three use case configurations. However, except for two measurements, the node process that benchmarked ML-DSA consumed more memory compared to Ed25519. This shows that ML-DSA not only performs signing and verifying operations slower than Ed25519, but is also more resource-intensive at the same time. This will limit the possibilities to use ML-DSA in resource-constrained environments such as embedded systems and IoT devices. Although not being a very large increase in memory consumption, this still might cause consequences when ML-DSA is implemented in larger-scale deployments such as cloud-based systems or high throughput servers. Even small increases in memory consumption can lead to higher operational costs and increased hardware demands. This might prompt actors to upgrade or 
52
replace hardware sooner than expected, something that is discussed later in subsection 6.8.3. The difference between the algorithms can be explained by the difference in complexity of the mathematical operations being performed by the two algorithms. The difference between the algorithms is that, as explained in subsection 2.3.4, ML-DSA is built using M-SIS and M-LWE. ML-DSA also makes use polynomial arithmetic such as NTT and rejection sampling. This means that key generation, signing, and verifying is more computationally heavy compared to Ed25519 since elliptic curve operations avoid these operations. This adds more overhead to ML-DSA. The signature and key sizes used by ML-DSA can be found in table 2.3 and are much larger compared to those of Ed25519 presented in subsection 2.2.2. This is another explanation for why ML-DSA is slower than Ed25519. The difference can also be explained by looking at the age of the algorithms. Ed25519 has existed and been in use for a long time. ML-DSA is newer and currently still being optimised; it is to be expected that the gap between algorithms should decrease with time as ML-DSA becomes more efficient because of future hardware optimisations and algorithm refinements. When examining the scalability of the algorithms, both ML-DSA and Ed25519 scale differently. In figure 5.32 and figure 5.33, we can see the percentage differences between signing and verifying times between 100 and 100,000 payload size bytes. The table shows that the signing operation of ML-DSA offers much better scalability compared to that of Ed25519. On the other hand, the verifying process of ML-DSA offers worse scalability compared to Ed25519. The difference in scalability is likely due to the fact that the two algorithms are based on different mathematical problems, leading to one scaling better for signing while the other scales better for the verification process. If an algorithm does not scale well, this may impact its use cases. Low scalability may affect systems such as high-throughput systems or systems in resource-constrained environments. It is also especially important for PQC algorithms to offer good scalability, as this is crucial for future-proofing. As data sizes increase, algorithms which scale poorly may become bottlenecks in future systems. 
The security perspective is also one that must be borne in mind. ML-DSA offers protection against both quantum computers and regular attacks. This makes it the obvious choice for actors wanting protection from these kinds of attacks. However, it becomes clear that the technology is not ready for widespread adoption in all areas, as ML-DSA still lacks performance compared to Ed25519 as seen in 5.25 and 5.26. Ed25519 still protects against regular attacks while retaining full performance. ML-DSA still shows promise when its age is taken into consideration; with future optimisations and upgrades, ML-DSA may be more comparable to Ed25519. However, actors must consider whether or not the increased security is worth the decrease in performance. 
In short, the difference between ML-DSA becomes clearly visualised in the Chapter 5. This will make it hard for actors to migrate towards ML-DSA. In some cases, it might be hard because, as stated earlier, the restricted resources in IoT systems and embedded systems might not allow for the increased memory usage. Some systems, such as trading platforms, might not want to risk the increased transmission time, which could lead to losses for both the customer and service provider. Some companies might not see the increase in security as a rightful reason to invest in hardware replacements and upgrades to retain efficiency and security. 
53
6.1.2 SLH-DSA vs Ed25519 
These results answer the research questions about SLH-DSA. For signing speed, SLH-DSA is much slower than Ed25519 when sending data locally. For verifcation speed, SLH-DSA is much slower than Ed25519 when receiving data locally. Therefore, both research questions confirm that SLH-DSA shows a clear performance difference compared to ED25519 in both signing and verification. 
When looking at the performance difference between the algorithms, a very clear pattern can be seen in both the signing and verification results. The boxplots for signing and verifying speed compared to Ed25519 in the figures 5.27 and 5.28 shows a consistent differences across all measurements. These results support the alternative hypotheses H3.1 and H.1; these results prove that there is a significant difference between SLH-DSA and Ed25519 in both signing and verification speed. It also proves that the null hypotheses H3.0 and H4.0 can be rejected. SLH-DSA has higher signing and verification times in all cases and clearly shows a high performance gap compared to Ed25519, meaning that signing and verification are much slower. 
The Tukey post-hoc test provided additional information on the differences, unlike the other algorithms, SLH-DSA showed cases where confidence intervals overlapped the zero line in the figure in Appendix A(A.1 A.2 A.3 A.4 A.5 A.6). This shows that not all the pairwise comparisons were statistically significant. T-tests confirmed the overall difference, but even though they indicate that the performance of SLH-DSA may vary depending on specific conditions. This can also be further observed in the mean comparison graphs that include different use case configurations in figures 5.20 and 5.24. While SLH-DSA consistently performs slower than Ed25519, the results show that performance varies between systems. This then proves that hardware plays a role in how large the performance difference becomes, even though the overall trend with payload size affects the time. For example, use case 1 shows higher signing and verification times compared to both use case 2 and use case 3 in both signing and verification, while use case 3 shows the lowest values. The difference becomes more noticeable as the payload size increases, mostly when looking at verification results. When compared to ML-DSA, where the difference was smaller, the gap between SLH-DSA and Ed25519 is much larger. This shows that the choice of what algorithm to use has a bigger impact on performance when SLH-DSA is used. 
The large performance difference between SLH-DSA and Ed25519 can be explained by how the two algorithms are built. As described in Section 2.2.2, Ed25519 is based on elliptic curve cryptography and is designed to provide both high security and high performance. Ed25519 uses a compact signing and verification process with the help of a small key and signature size. The Ed25519 public key is 32 bytes, and the signature is 64 bytes. This can explain why Ed25519 performed much faster in the experiments. 
When looking at SLH-DSA, it is more complex by design. As explained in section 2.3.2, SLH-DSA is not a single standalone signature algorithm but is a combination of several hash-based components, like FORS, XMSS, and WOTS+, and is organised in a hypertree structure. Because of this structure, signing in SLH-DSA requires several steps instead of one compact operation like Ed25519 has. 
Looking more deeply into how the SLH-DSA internal signature process works as described in section 2.3.2, SLH-DSA first hashes the message into a digest, then uses part of that digest to 
54
help create a FORS signature, and after that, authenticates the result through the hypertree. This shows that the algorithm must perform a more detailed explanation for why signing was much slower for SLH-DSA in the results. 
The same explanation applies to verification. As explained in section 2.2.2, Ed25519 verification is based on checking a specific equation on the elliptic curve. But when looking at SLH-DSA as explained in section 2.3.2, it explains that SLH-DSA verification includes several steps. First, the verifier must parse the signature, then recompute the message digest, reconstruct the FORS public key, and then verify the hypertree until the final root value can be compared with the public key. Because SLH-DSA verification depends on several layers and values, it takes much more time than verification for Ed25519. 
One more important reason is the signature size. As explained in the section 2.3.2 and table 2.1, the parameter set SLH-DSA-SHA2-192s in the table shows that it produces a signature of 16224 bytes. This is roughly 254 times larger than Ed25519’s 64-byte signature size, described in section 2.2.2. The large signature size of SLH-DSA can be explained by the internal structure of SLH-DSA. As shown in section 2.3.2, a signature is not only. single value, but it consists of multiple parts, such as the FORS signature and a hypertree signature. These parts include the authentication paths and multiple hash-based components, which, then together, increase the total signature size. 
Also, the internal structure of SLH-DSA explains the computational cost. Section 2.3.2 shows that WOTS+ is based on hash chains, where the parameter choice can affect the trade-off between computation and size. Section 2.3.2 explains that XMSS signatures include both a WOTS+ signature and an authentication path in a Merkle tree. Also, section 2.3.2 shows that FORS signatures include multiple selected values and authentication paths. All these parts make SLH-DSA extremely more complex than Ed25519 in both signing and verification. 
This information explains why SLH-DSA caused a much larger increase in transmitted payload size. But the results also show that increasing the payload size from 100 to 10000 bytes does not significantly change the signing and verififcation time This can be explained by the fact that the SLH-DSA signature size (16224 bytes) is much larger than the payload itself. Because of the large signature size, the total message size is dominated by the signature size and not the payload size. This dominance of signature size results in a relatively small impact until it reaches 100 000 bytes, which is when a more noticeable increase can be seen. This is most visible in the verification results seen in the figure 5.28, where the verification time increases more clearly compared to smaller payload sizes. While the signing time remains relatively stable, as shown in figure 5.27. 
One more important observation from the results is the memory usage when using SLH-DSA. When looking at figures 5.29, 5.30, and 5.31, SLH-DSA uses less memory when compared to both Ed25519 and ML-DSA across all platforms. This shows that even though SLH-DSA is more complex and slower, it has a smaller memory usage during execution. This can be explained by how SLH-DSA works; it is based on hash functions and mainly only uses repeated hash operations and some temp values. Instead of storing large structures in memory, comparing this to Ed25519 and ML-DSA rely on more complex internal representations, which can require more memory during execution. 
Looking deeper into the graphs, we can see that the memory usage of SLH-DSA follows 
55
an increasing trend, which increases with the payload size. The increase can be seen across all different use case configurations, proving a relation between payload size and memory usage. Comparing this to that of ML-DSA and Ed25519, we can see that memory usage sustains a greater variation depending on the use case configuration. It is very likely that the memory usage benchmarks performed on use case 1 and use case 3 was affected more by the confounding variable garbage collection in node.js. This is discussed more in Section 6.7. 
The results can be explained by how both algorithms are designed differently. Ed25519 is designed to be fast and efficient in a system. SLH-DSA was designed to provide post-quantum security with the help of a more complex hash-based structure. These results clearly show that the increased security comes at the cost of lower performance. 
When comparing performance between SLH-DSA and Ed25519, it has important implications for real-world systems. Because SLH-DSA shows significantly higher signing and verification time in both, this can then introduce noticeable delays in systems where low latency is important. When looking at applications such as real-time communication systems, the increased delay may affect user experience and system responsiveness. This furthermore shows in the results, the difference becomes more noticeable as the payload size increases, which then limits the usability of SLH-DSA in system handling larger amounts of data. 
However, this trade-off can be considered when evaluating security. SLH-DSA is designed to be secure against quantum attacks; this gives it an advantage over classical algorithms like Ed25519. In a system where long-term security is more important than performance, such as a government system or important archival storage, the increased signing time and verification time may be acceptable to have a more secure system. These trade-offs show one of the biggest challenges in adopting post-quantum cryptographic algorithms, where the trade-off with increased security often comes at the cost of reduced performance. 
When looking at the memory results, it shows that SLH-DSA has lower memory usage compared to the other algorithms, which can be beneficial in systems with limited resources. This makes SLH-DSA more suitable for environments where memory efficiency is important, such as embedded systems or large-scale systems that handle many users. Lower memory usage can also reduce hardware requirements and operational costs, especially when evaluating a cloud-based system where memory usage is affected by pricing. With more efficient memory usage, it can result in reduced waste and can improve system scalability. 
However, the result also shows that memory usage does increase as the payload size grows. This increase in memory usage means that is handling large amounts of data, the memory advantage may become less significant when the payload size becomes too large. 
6.2 Reflections 
One thing that was discovered was that implementing PQC algorithms was not as difficult as anticipated. The amount of resources and literature surrounding the area made the implementation of external libraries easier. This finding forced a shift in our research aim, as the study initially aimed to examine the difficulty of implementing PQC algorithms. Another thing that was discovered during the study was how sensitive the benchmarking process was towards confounding variables such as background processes. To address this issue, network access was 
56
disabled along with background applications, which was thought to might have an impact on the results. It is suspected that the outliers seen in the boxplots presented in chapter 5 can be explained by this effect. A background process would only need to be run for a short amount of time to have any impact. One background process could even impact several benchmarks, which could explain the different layers of outliers present in figure 5.6. Another confounding variable is garbage collection in the Node.js runtime environment. Because benchmarking tool was implemented using Node.js, V8 enginge in Node.js may automatically trigger garabage collection during a execution. This can then temporaily interrupt and affect memory usage measurements, as seen in figure 5.31. During the experiment, it was discussed whether or not the payload size was to be increased to 1 000 000 bytes to further analyse the scalability of algorithms. This proposal was rejected because of the fact that, according to the TCP/IP protocol, packets that large are rarely sent. According to the IP protocol, larger packets are fragmented into smaller ones when transmitting and then reassembled when received (contributors, 2025). It is important to realise that, just as stated in the readme.md of liboqs-js (Open Quantum Safe, 2024), this technology is still in a very rapid development phase. Which is one of the reasons this study has focused on new libraries and the algorithms that are currently being worked on. It is also noteworthy that some early adopters, such as Apple and Signal have already implemented hybrid solutions. Apple’s version, called PQ3 (2024) (SEAR), utilises a hybrid solution in which the keys are encrypted using PQC algorithms in order to protect from quantum attacks. The same type of technology is utilised in the Signals PQXDH protocol (Kret and Schmidt, 2023). A hybrid solution is used for quantum-resistant key distribution, which protects the private keys from quantum attacks. It should be noted that although these protocols do not protect from attacks such as HNDL, it is a major leap towards a migration to quantum-resistant cryptography. 
As we discuss further in this chapter 6, although the technology exists, many systems and companies are not ready for a full migration. Therefore, hybrid solutions, as seen in the aforementioned PQ3 and PQXDH, are a good step forward. This is also reported as one of the main future initiatives by Singh et al. (2025). Hybrid solutions allow for a middle ground between no protection and full protection as we move forward and wait for future optimisations and research. 
All results presented in chapter 5 are our own. All graphs and tables are made using data collected from our benchmarking tool. The only tools used to process the data were Minitab and LaTeX, where the data was visualised. Since we have produced every result ourselves, there exists a small risk of human error, which is not left in with intent. 
6.3 Similarities and Differences to Related Research 
When comparing our results to what is said in related works, several similarities can be observed. Kwon et al. (2024) examined different algorithms to compared to this study, leading to difficulties directly comparing results. The most similar aspect of of the study by Kwon et al. (2024) is their benchmarking environments. Their environment 2 is very similar to our use case 1. In their study, they mention that the equipment used to benchmark may perform other calculations, similarly we experienced several outliers which we assess to be caused by background processes. 
In the NIST third round standardisation Alagic et al. (2022), we can see that the algo-
57
rithms were benchmarked on encapsulation and decapsulation using clock cycles. We did the same, but with milliseconds. Even though this means our results are not directly comparable, we can still see that they recorded a similar difference between SLH-DSA and ML-DSA as we did. It was also shown that the signing/encapsulation process of SLH-DSA took a lot longer time than the verifying/decapsulation operation. Something both Alagic et al. (2022) and we concluded. 
The findings of this study are consistent with Alagic et al. Alagic et al. (2022), who describe SPHINCS+ as a relatively large and slow digital signature scheme. Similar trends were observed in this study, in which SLH-DSA exhibited longer signing times and larger signature sizes. In both studies, the impact of the signing performance was greater than that of the verification performance. These observations are further supported by Bernstein et al. (2019), who also benchmarked SPHINCS+ and reported that signing operations took considerably longer than verification operations. A similar result was observed in this study, where SLH-DSA consistently showed higher signing times than verification times across all tested message sizes. Since SLH-DSA is the standardized version of SPHINCS+, similar results were expected. 
Comparing our results for ML-DSA to those presented by Abbasi et al. (2025) for security level 3 of CRYSTALS-DILITHIUM. They used a payload size of 2701 bytes, which refers only the signature. The results presented in their study shows a similar pattern to those presented in ours. The signing times for ML-DSA were roughly double the verifying times, a pattern also present in the study by Abbasi et al. (2025) aswell. However, we can see that the performance of the algorithm has increased with time, our benchmarks performed for 10 000 bytes achieved a faster sign and verify time compared to those presented in the related work. This suggests historical progress. ML-DSA is likely to gain performance with time as more optimisations are developed and implementations slowly progresses out of the experimental phase. However, the largest factor contributing to the performance increase is likely the fact that ML-DSA is a standardised algorithm while CRYSTALS-DILITHIUM was a submission for standardisation. 
6.4 Internal Validity 
Internal validity refers to whether a study is conducted correctly and whether the measured traits truly reflect the intended variables. This study focuses on whether the observed difference in signing and verification performance is caused by the selected signature algorithms and hardware platforms, and not other uncontrolled factors. 
To ensure high internal validity, each benchmark was conducted using the same dependent variables. All algorithms were tested using the same application and measurement methods. This ensured the only variables affecting the results were the signature algorithms and the hardware configurations. The experiments were also performed locally on each machine, and the machines were disconnected from the internet to reduce external interference. The laptops, use case 1 and use case 2, were connected to a power source during the duration of the experiment to ensure that no power saving measures were enabled. 
Each algorithm was implemented according to its documentation, which ensures each algorithm works the way it should. Each benchmark was run 10000 times to help reduce random variation and obtain stable average values. However, since we modified and developed new 
58
modules in the benchmarking tool, including the algorithm implementations, we are aware of the human factor. There exists a risk that the benchmarking tool has some flaws, such as bad optimisation and/or bad smells which have not been detected by us; in this case, it should be noted that any such issues were not intentional. It is simply the risk of human error. 
Despite all these precautions, there are still some threats to the internal validity of our study. Factors such as background processes on the machines have to be taken into consideration. Some factors include CPU scheduling and memory usage. Another important issue is that it is not possible to control all background processes. Even if we tried to reduce them, an operating system like Windows for use case 3, Ubuntu for use case 1, and MacOS for use case 2 still runs built-in services that cannot be turned off. These may use system resources and can then influence the results. However, it may not be in our interest since we wanted to study how these algorithms performed in a system where it is not isolated, which in turn led to an increase in our external validity as results are more applicable to real use cases. 
Different libraries are optimised in different ways. The Ed25519 implementation comes from node.js cryptolibrary (Node.js Foundation, 2026) while the PQC algorithms come from liboqs JavaScript library, liboqs-js (Open Quantum Safe, 2024). The usage of different libraries for the implementation of different algorithms may have had some effect on the results. This is because libraries may differ in the handling of memory, caching, and dependencies. 
Another aspect of internal validity is the quality of sources used. As quantum computing is a rapidly advancing field, we have focused on choosing sources that have been published within the last year or two. This choice was a necessity in order for us to continue our current research. The choice has allowed us to reflect on the current situation of post-quantum cryptography and the migration towards quantum-resistant technology. However, the choice may introduce some limitations. Recent sources that have been published shortly after large documents, such as FIPS 204 (NIST, 2024a) and FIPS 205 (NIST, 2024b), may not have undergone thorough peer reviews or independent validation. For example, although we bore this thought in mind throughout the whole study, some sources may include preliminary or untested conclusions. Some tools may also be rushed or unfinished, for example, when implementing liboqs-js (Open Quantum Safe, 2024), it had been published just 2 days before. This means the version used may include flaws that have not yet been found and could affect our results. 
Overall, even if some threats remain, the use of controlled conditions like the same implementation structure and repeated testing helps to ensure that the results mainly show the impact of the signature algorithms and the hardware. 
6.5 External Validity 
External validity refers to whether the results of a study can be applied outside the specific experiment setup. This study focuses on whether the results can be applied to other systems, environments, and real-world applications. 
One limitation is that the experiments were performed in a local environment. This means that real-world factors such as network latency, concurrent users, and system load were not present. This limitation can lead to the results differing in a real application where more variables are present. 
59
Another limitation is related to hardware. The experiments were conducted on a limited number of systems, and performance may vary on other hardware configurations. Changes in hardware, such as a different CPU, memory, and operating system, may affect the performance of the algorithms. As seen in, for example, figure 5.12, hardware configuration and hardware configuration had a significant impact on the performance of the selected algorithms, proving what has been stated above. 
When looking at the implementation, it is based on a specific system using Node.js and Socket.io. Other implementations, programming languages, or system architectures can also lead to different performance. Additionally, the selected payload size used in the experiments may also not fully represent all real-world use cases. 
Overall, this study provides valuable insight into performance for the selected algorithms. The results should, however, be interpreted with a bit of caution when applied to other environments or other systems. 
To make this study reproducible, the tool used to benchmark the algorithms is publicly available on GitHub with instructions. The license used also allows for further development of the tool in order to continue our research in one of the proposed future directions. 
6.6 Conclusion Validity 
As described by Wohlin et al. (2012), conclusion validity regards the ability to draw conclusions about the treatment’s effect on the outcome of an experiment. A large portion of threats to our conclusion validity have already been discussed throughout the threats to our internal and external validity. However, some threats can be discussed further. One threat to this study’s conclusion validity is the heterogeneity of the algorithms used. The three algorithms all differ in either security, complexity or their mathematical operations. This means that the algorithms may differ in performance because they are different. This would ultimately limit our ability to draw conclusions regarding the performance difference between the algorithms. However, as described by Wohlin et al. (2012), choosing more homogeneous algorithms would affect external validity by limiting our ability to generalise the results. 
Another threat towards our conclusion validity, which has already been discussed in section 6.4, is the confounding variables such as background processes. These fall into the category of random irrelevancies in experimental settings, which is discussed by Wohlin et al. (2012). To fight this threat, we attempted to minimise the number of background processes during the experiment, thereby minimising outside noise. 
Although these threats exist, we believe our study has a high conclusion validity because of; we have performed ANOVA tests to confirm that a statistical significance exists, which allows us to draw our conclusions. Tukey tests were also performed when needed in order to visualise the difference between groups, these to contribute to high statistical power. One threat, which is presented by Wohlin et al. (2012), is fishing for certain conclusions based on the results and previous bias. We have not ”fished” for any type of results, but instead reflected the current situation and presented our results. The treatment was applied exactly the same way on each 
60
independent variable. These reasons allow us to be sure that our conclusions are valid. 
6.7 Construct Validity 
Construct validity, as described by Wohlin et al. (2012), is about whether an experiment really measures the concept it is supposed to measure. One threat towards this studys construct validity are unclear definitions, especially when the concept of performance is not clearly defined before being measured, and also other problems include a limited number of measurement types. This can lead to a limited view of the concept. 
The construct validity in this study is about whether our measurements represent performance in digital signature algorithms. This study measures performance using signing time, verification time and memory usage. These measurements act as a representation of performance rather than capturing the full concept. But, performance can also include more aspects, such as energy consumption and network-related performance factors, which are not included. This means the study does not fully capture the complete concept of performance as described by Wohlin et al. (2012). 
Another threat is only using one type of measurement approach, which can introduce bias in how performance is evaluated. The performance is measured through signing time, verification time, and memory usage, since these measurements can be influenced by implementation details rather than only the algorithms themselves and can then affect the results. This means the results may not accurately represent the true performance of the algorithms. 
Another threat is related to the memory usage measurements. Memory usage was measured using Rssmb values from the Node.js process. These values can be affected by garbage collection, memory caching, and runtime behaviour in the V8 engine used by Node.js. This means that the measured values may not only represent the memory usage of the algorithms themselves, but also the behaviour of the runtime environment. Therefore, this should be taken into consideration when interpreting the memory usage results. To reduce these threats, the same implementation and measurement approach was used for all the algorithms, ensuring that the comparison between algorithms remains consistent. But these limitations should still be considered when looking at the results, especially when interpreting absolute performance values rather than relative differences. 
6.8 Sustainability 
6.8.1 Economical 
The economic impacts of the threat of quantum computing are large. As discussed in the ENISA report ”Post-Quantum Cryptography Current state and quantum mitigation” (D’Anvers et al., 2021), replacing the current cryptographic systems would take a lot of time and effort. In some cases, just replacing the cryptographic system being used is not possible. This means that entire systems need to be replaced, resulting in significant economic investments and costs. One such example, discussed by D’Anvers et al. (2021), is satellites. If current satellites cannot be modified remotely, sending new ones to upgrade only the cryptographic systems being used would be a significant cost. 
61
As our experiment suggested, algorithms such as ML-DSA are more resource-heavy compared to current algorithms such as Ed25519. This means that a migration towards quantum-resistant cryptography would require more powerful hardware configurations. This is another economic impact of the quantum threat. This cost would not only affect companies, as they would need to comply with new regulations. It would also affect end users who want to protect their privacy. The largest impact from upgrading hardware would be the resource-constraint environments. 
There exists a risk where one company is able to commercialise a quantum-safe product before anyone else, thus creating a monopoly. Since encryption is widely used, the threat of quantum computing is so dangerous. A monopoly on quantum-resistant technology implies a threat to the free market. In this potential case, security could be extremely expensive in the quantum age. 
6.8.2 Sociological 
The development of quantum computing not only creates economical challenges, but can also sociological effects. According to D’Anvers et al. (2021), not all progress in quantum computing and technology is public, and it is possible that a working quantum computer could be developed without being announced. This lack of information can create uncertainty and reduce trust in the digital system. 
Further expanding on the monopoly situation discussed earlier, it can then affect people’s privacy and increase the risk of misuse of personal information. This may also have an impact on personal privacy in everyday life. If private communication is no longer secure, users may feel that their messages can be accessed at any time. This can create a feeling of being constantly watched and can then affect how people express themselves and interact online. 
If the quantum threat is realised and there are no protection mechanisms in place, the consequenses would be disastrous. Since encryption is so widely used for so many different purposes, this would impact all aspects of our digital life. For example, dependable systems would be severely affected. As explained by Van Steen and Tanenbaum (2023) dependable systems are required to provide security, especially confidentiallity and integrity. As explained, QC is a threat to both of these terms, which makes dependable systems vulnarable. One example of a dependable system which would be affected by a quantum attacker is digital banking. If a digital banking system was attacked by a quantum attacker, they would no longer be able provide secure and confidential services. The physical impacts of this would for example be difficulty using different payment systems stores, leaving people with only cash as an option. This would have a immense negative effect on a country such as Sweden where cash is rarely used. Many digital communications channels would no longer be secure, leaving people to rethink what information is shared digitally. This might potentially hurt globalisation since it is reliant of fast, secure and reliable communication worldwide. 
Another important issue is future decryption. Data which is secure today could be decrypted in the future. As a result, communication that is currently considered private may later become exposed, this raises serious concerns about long-term privacy. If sensitive information becomes accessible, it could increase the risk of missuse. Leaked information could be used to influence or put pressure on individuals including in certain political situations, thus threatening 
62
democracy. Because of this it is important to prepare post quantum cryptography. Not only from a technical perspectvie but also from a societal point of view. 
One positive consequense of PQC algorithms are that they provide the security which is needed in the quantum era. PQC algorithms will allow us to keep confidential and sensitive information secret, even in the quantum age. If it were not for PQC algorithms, the social effect of PQC algorithms roots in why encryption is important in the first place. Encryption transforms data in to something which an attacker cannot understand (Van Steen and Tanenbaum, 2023), something which is fundamental in computer security. 
6.8.3 Ecological 
Since PQC algorithms run on classical computers and not quantum computers, the environmental impact may not be as large as might initially be assumed. PQC algorithms have a carbon footprint similar to that of traditional encryption, with electricity consumption as the primary factor. However, because we did not measure energy usage during our experiment, the difference in power consumption between PQC and traditional algorithms remains unknown. Based on measured operation times, we can estimate the impact: the selected PQC algorithms performed signing and verifying operations more slowly, on average, than the classical algorithm Ed25519. This slower performance could indicate increased energy use due to longer operations, but without measured data, this remains speculative. Some ecological effects have already been discussed. Due to larger hardware requirements, replacing classical cryptographic algorithms with quantum-resistant ones may increase e-waste, as upgrading components can result in an abundance of older, non-disposable parts. For systems which are not upgradeable and must be replaced, such as satellites, non-generative resources will have to be spent creating new systems. But upgrading current systems will also require new components, created using non-generative resources. Upgrading and enhancing our digital security will come at the cost of the environment. 
6.9 Future Work 
While this study provides insight into the field of post-quantum cryptography, several aspects remain to be examined, which leaves room for future research to advance the field. It became clear that the hardware configuration used for benchmarking had a large impact, as seen across the figures presented in Chapter 5. The machines used for this study were low to mid-end personal computers, because the aim was to evaluate how these algorithms could affect end users. To further improve our study, high-end machine configurations could be used to assess the impact on test results. This would allow for examining the parameter of how dependent each algorithm is on hardware. The reason why this was not examined in our study was that it was out of scope for the time allocated to this project. This would also allow for studying which hardware component is the bottleneck of running PQC algorithms. 
A similar study could be performed, but with one more algorithm, FN-DSA. FN-DSA is another digital signature algorithm currently in the final stages of standardisation, as documented in FIPS 206 (Perlner, 2025). FN-DSA is a lattice-based cryptographic scheme just as ML-DSA. This opens up the possibility to compare two more similar PQC algorithms, ML-DSA and FN-DSA. That said, a similar study using a new algorithm could allow for new perspectives and insights into how PQC algorithms perform compared to classical algorithms. Eventually, this would lead to more information regarding the differences between PQC algorithms, 
63
which would increase the probability of organisations adopting PQC algorithms and becoming quantum-resistant. FN-DSA was not selected as an algorithm to be benchmarked for this study because it has not been officially released. 
Another aspect which could be further studied is how signing and verifying times are affected when messages are sent over an actual network instead of a virtual one. This would make the study more applicable to real-life scenarios, as communication over networks often needs to be encrypted for security. This would add more confounding variables as network speed can vary. In our experience, having network access enabled on the machine during benchmarking has a negative effect on signing and verifying speed. Therefore, we find that there exists potential in evaluating the effect that network access and speed have on signing speed and verifying speed in a study similar to this one. 
Another valuable experiment which would further examine the current state of migration towards quantum-resistant systems is a case study of a company that is currently migrating technologies. Performing a case study with this focus would shift focus from theoretical speculations towards practical implementation. This would serve as a roadmap for other companies looking to move towards quantum-resistant technologies and encourage wider adoption of quantum-resistant technologies. 
To further research the ecological and economic impacts of using PQC algorithms, power usage could be added to a similar study. This would allow for measurements of how much the algorithms differ in power usage. This information would be significantly beneficial for companies managing high-throughput servers, as higher power consumption will directly lead to higher operational costs as well as a higher carbon footprint. 
We could have looked closer at hybrid solutions, as suggested by Singh et al. (2025). This would have been relevant because implementing post-quantum cryptography in existing systems requires major changes in both software and hardware, as stated by (Singh et al., 2025). Also, PQC algorithms often use larger key sizes and higher computational overhead, which can then lead to a negative effect on performance and increase storage and network requirements (Singh et al., 2025). Because of these problems, a hybrid solution can be a good transition strategy,where both classical and post-quantum algorithms are used together, as stated by Singh et al. (2025). Therefore, future work could focus on studying such solutions to gain a better understanding of how post-quantum cryptography can be applied in a real system. This would allow us to evaluate whether hybrid approaches can help reduce the performance impact that was observed in this study, while also helping provide increased security. It could also help us better understand how these algorithms perform when combined and provide us with a more realistic view of how post-quantum cryptography can be implemented in real existing systems. 
Kwon et al. (2024) mentioned that heat generation may have had an impact on their performance. To further improve our experiment, we may want to monitor the heat generation for the machines used to benchmark. The reason behind this is just to exclude heat generation as a confounding variable. 
By pursuing these directions of research, we can accelerate the shift towards quantum-safe adoption and a safer future. 
64
7 Conclusion 
There are notable differences between how each algorithm performs. Ed25519 performs signing and verifying operations more quickly than its quantum-resistant counterparts. However, SLH-DSA uses less memory than both other algorithms. Several underlying reasons have been discussed as to why these algorithms differ the way they do. Although the implementations of the PQC algorithms are highly experimental, this study has provided us with an understanding of the current state of the technology and its comparison to a widely used classical algorithm. We have used this understanding to analyse which implications a switch towards PQC algorithms would lead to if done today. We found that systems such as embedded systems and IoT, where limited resource usage is crucial, would be most affected by the increased memory usage seen with ML-DSA. Dependable systems such as banking and financial services would be affected by the increased signing and verifying times, where live trading, for example, requires quick transmissions to ensure trades go through. Different aspects of internal validity, external validity, conclusion validity and construct validity have also been discussed. As previously stated, several measures were taken to ensure high internal validity, such as reducing confounding variables by disabling network access and reducing the number of applications running in the background. Sources used were also a large aspect of this study’s internal validity. The recent publication of several of the sources used can lead to errors and/or mistakes that have not yet been detected by others still existing in the article. However, in order to stay up to date with current research and for this study not to use outdated information, these sources have still been used. These sources include both literature and libraries. External validity was also discussed. To ensure this study’s reproducibility, the tool used to benchmark is available publicly on GitHub along with instructions on how to use it. Several limitations were also discussed, such as the fact that the algorithms were only tested in a local environment. This eliminated variables such as network bandwidth and the effect it might have had. The tool is also programmed in JavaScript; how the benchmarks would have looked if the tool were implemented in another language is unknown, and it is not certain that there would be an effect at all. The future work section focuses on future directions that were either out of scope for this study or reliant on technology which did not exist yet. For example analysing the ecological impact might give more insight into how resource contraint environments such as embedded systems or IoT devices might be affected by a shift towards PQC algorithms. Extending the study by adding the PQC algorithm FN-DSA might bring a wider perspective on how PQC algorithms compare to classical algorithms. For this direction to be possible, FIPS 206 has to be released first. 
65
Bibliography 
M. Abbasi, F. Cardoso, P. Váz, J. Silva, and P. Martins. A practical performance benchmark of post-quantum cryptography across heterogeneous computing environments. Cryptography, 9(2), 2025. doi: 10.3390/cryptography9020032. URL https://www.mdpi.com/2410-387X/9/ 
2/32. 
G. Alagic, D. Apon, D. Cooper, Q. Dang, T. Dang, J. Kelsey, J. Lichtinger, Y-K. Liu, C. Miller, D. Moody, R. Peralta, R. Perlner, A. Robinson, and D. Smith-Tone. Status report on the third round of the NIST post-quantum cryptography standardization process. Technical report, National Institute of Standards and Technology, 2022. 
alexvcasillas. Memory-monitor, 2025. URL https://github.com/alexvcasillas/ 
memory-monitor. 
altrawan. Realtime-chat-api, 2024. URL https://github.com/altrawan/realtime-chat-api. 
D. J. Bernstein, N. Duif, T. Lange, P. Schwabe, and B-Y Yang. High-speed high-security signatures. Journal of cryptographic engineering, 2(2):77–89, 2012. doi: 10.1007/s13389-012-0027-1. 
D. J. Bernstein, A. Hülsing, S. Köbl, R. Niederhagen, J. Rijneveld, and P. Schwabe. The sphincs+ signature framework. In Proceedings of the 2019 ACM SIGSAC Conference on Computer and Communications Security, pages 2129–2146, 2019. doi: 10.1145/3319535.3363229. 
K. Boudgoust, C. Jeudy, A. Roux-Langlois, and W. Wen. On the hardness of module learning with errors with short distributions. Journal of Cryptology, 36(1):1–70, 2023. doi: 10.1007/ s00145-022-09441-3. 
D. Butin. Hash-based signatures: state of play. IEEE Security & Privacy, 15(4):37–43, 2017. doi: 10.1109/MSP.2017.3151334. 
Wikipedia contributors. IP fragmentation, 2025. URL https://en.wikipedia.org/wiki/IP_ 
fragmentation. [Online; accessed 7-April-2026]. 
J-P. D’Anvers, A. Hülsing, T. Lange, L. Panny, C. D. Saint Guilhem, and P. N. Smart. Post-quantum cryptography: current state and quantum mitigation. Technical report, European Union Agency for Cybersecurity (ENISA), 2021. 
Apple Security Engineering and Architecture (SEAR). iMessage with PQ3: the new state of the art in quantum-secure messaging at scale, 2024. URL https://security.apple.com/blog/ 
imessage-pq3/. 
66
M. Jakobsson, T. Leighton, S. Micali, and M. Szydlo. Fractal merkle tree representation and traversal. In Cryptographers’ Track at the RSA Conference, pages 314–326. Springer, 2003. 
F. Kagai, P. Branch, J. But, and R. Allen. Harvest-now, decrypt-later: a temporal cybersecurity risk in the quantum transition. Telecom, 6(4), 2025. doi: 10.3390/telecom6040100. 
E. Kret and R. Schmidt. The pqxdh key agreement protocol, 2023. URL https://signal.org/ 
docs/specifications/pqxdh/. 
H. Kwon, M. Sim, G. Song, M. Lee, and H. Seo. Evaluating kpqc algorithm submissions: balanced and clean benchmarking approach. In Howon Kim and Jonghee Youn, editors, Information Security Applications, pages 338–348. Springer Nature Singapore, 2024. ISBN 978-981-99-8024-6. doi: 10.1007/978-981-99-8024-6 26. 
A. Langlois and D. Stehlé. Worst-case to average-case reductions for module lattices. Designs, Codes and Cryptography, 2015. doi: 10.1007/s10623-014-9938-4. 
A. A. Maqousi, K. Basu, F. L. Pelayo, and F. C. Gómez. Quantum computing and cryptography in cybersecurity: a disruptive synergy. In 2025 1st International Conference on Computational Intelligence Approaches and Applications (ICCIAA), pages 1–6, 2025. doi: 10.1109/ICCIAA65327.2025.11013234. 
J. Mascelli and M Rodden. “harvest now decrypt later”: examining post-quantum cryptography and the data privacy risks for distributed ledger networks. Board of Governors of the Federal Reserve System, 2025. doi: 10.17016/FEDS.2025.093. 
D. Moody, R. Perlner, A. Regenscheid, A. Robinson, and D. Cooper. Transition to post-quantum cryptography standards. Technical report, National Institute of Standards and Technology, 2024. 
NIST. Digital signature standard (ML-DSA). Technical report, National Institute of Standards and Technology, 2024a. 
NIST. Digital signature standard (SLH-DSA). Technical report, National Institute of Standards and Technology, 2024b. 
Node.js Foundation. Node.js crypto module documentation, 2026. URL https://nodejs.org/ 
api/crypto.html. 
C. Näther, D. Herzinger, S-L. Gazdag, J-P. Steghöfer, S. Daum, and D. Loebenberger. Migrating software systems toward post-quantum cryptography-a systematic literature review. IEEE Access, 12:132107–132126, 2024. doi: 10.1109/ACCESS.2024.3450306. 
Open Quantum Safe. Liboqs-js, 2024. URL https://github.com/open-quantum-safe/ 
liboqs-js. 
M. J. Page, D. Moher, P. M. Bossuyt, I. Boutron, T. C. Hoffmann, C. D. Mulrow, L. Sham-seer, J. M. Tetzlaff, E. A. Akl, S. E. Brennan, R. Chou, J. Glanville, J. M. Grimshaw, A. Hróbjartsson, M. M. Lalu, T. Li, E. W. Loder, E. Mayo-Wilson, S. McDonald, L. A. McGuinness, L. A. Stewart, J. Thomas, A. C. Tricco, V. A. Welch, P. Whiting, and J. E. McKenzie. Prisma 2020 explanation and elaboration: updated guidance and exemplars for reporting systematic reviews. BMJ, 372, 2021. doi: 10.1136/bmj.n160. URL https://www.bmj.com/content/372/bmj.n160. 
67
R. Perlner. FIPS 206 status update, 2025. URL https://csrc.nist.gov/csrc/media/ 
presentations/2025/fips-206-fn-dsa-(falcon)/images-media/fips_206-perlner_2. 
1.pdf. 
A. Ranhög and A. Herre. Pqc-messaging-system, 2026. URL https://github.com/a23alera/ 
PQC-Messaging-system. 
O. Regev. Lattice-based cryptography. In Annual International Cryptology Conference, pages 131–141. Springer, 2006. doi: 10.1007/11818175 8. 
K. Sahu, K. G. Srinivasa, and S. Vollala. Lattice-based cryptography: a systematic literature and bibliometric review. In 2025 IEEE 6th India Council International Subsections Conference (INDISCON), pages 1–6, 2025. doi: 10.1109/INDISCON66021.2025.11252169. 
A. Sijjad, A. W. Shuaib, K. R. Talpur, B. A. Talpur, K. S. Alshudukhi, M. Humayun, S. R. Talpur, M. A. Al Mamun, M. Naseem, A. Abro, D. B. Talpur, and A. Shah. Next-generation guantum security: the impact of quantum computing on cybersecurity—threats, mitigations, and solutions. Computers and Electrical Engineering, 128:110649, 2025. doi: doi.org/10.1016/ j.compeleceng.2025.110649. 
M. Singh, S. K. Sood, and M. Bhatia. Post-quantum cryptography: a review on cryptographic solutions for the era of quantum computing. Archives of Computational Methods in Engineering, 2025. doi: 10.1007/s11831-025-10412-7. 
A. Sjögren and W. Reutmer. Krypteringsalgoritmers p̊averkan p̊a paketstorlek och exekveringstid, 2025. URL http://www.diva-portal.org/smash/record.jsf?pid=diva2:1953531. 
M. Van Steen and A. S. Tanenbaum. Distributed systems. Maarten van Steen, fourth edition, version 4.03x (january 2023) edition, 2023. ISBN 9789081540643. 
C. Wohlin, P. Runeson, M. Höst, M. C. Ohlsson, B. Regnell, and A. Wesslén. Experimentation in software engineering. Springer Berlin Heidelberg, 2012. ISBN 9783642290435. doi: 10.1007/ 978-3-642-29044-2. 
D. Zimmermann, P. V. Rajsingh, E. De La Cruz, H. Jorge De Queiroz, S. Rana, and G. S. Nadella. Organizational adoption of post-quantum cryptography: drivers, barriers, and strategic implications. In 2025 Cyber Awareness and Research Symposium (CARS), pages 1–6, 2025. doi: 10.1109/CARS67163.2025.11337269. 
68
A Appendix - Tukey tests 
Figure A.1: Tukey test signing time use case 2 
69
Figure A.2: Tukey test signing time use case 1 
Figure A.3: Tukey test signing time use case 3 
70
Figure A.4: Tukey test verify time use case 2 
Figure A.5: Tukey test verify time use case 1 
71
Figure A.6: Tukey test verify time use case 3 
I