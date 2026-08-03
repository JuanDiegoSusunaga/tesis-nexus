# TRUST-Court: Tamper-Resistant Records for Universal Secure Transparency in Digital Judiciary Systems - Preprints.org

- **ID**: `88c06de0-4dde-44a7-aa81-d4322ef76042`
- **Tipo de Fuente**: `SOURCE_TYPE_WEB_PAGE`
- **URL**: [https://www.preprints.org/manuscript/202603.0442](https://www.preprints.org/manuscript/202603.0442)

---

## Contenido Extraído / Texto Completo

TRUST-Court: Tamper-Resistant Records for Universal Secure Transparency in Digital Judiciary Systems[v1] | Preprints.org
Processing math: 100%
Instructions for Authors
About
Help Center
Blog
10th Anniversary
Author Services
Log In
Submit
Celebrate 10 Years of Open Sharing Explore All Events
Home
Computer Science and Mathematics
Applied Mathematics
DOI:10.20944/preprints202603.0442.v1
Cite
Add to My List
Share Comments
Download PDF
Version 1
Submitted:
04 March 2026
Posted:
06 March 2026
You are already at the latest version
Subscription
Notify me about updates to this article or when a peer-reviewed version is published.
Subscribe
1. Introduction
2. The Quantum Threat to Judicial Records
3. Related Work
4. Post-Quantum Cryptographic Primitives
5. System Architecture
6. Enrollment Protocol
7. Court Session Recording and Signing Protocol
8. Verdict Issuance and Public Publication
9. Blockchain Architecture
10. Case Study 1: US Patent Litigation — Smith v. TechCorp
11. Case Study 2: India Criminal Case — State of Maharashtra v. Rajesh Kumar
12. Case Study 3: Traffic Offence in Ireland — DPP v. Seán O'Brien
13. Comparative Analysis: USA, India, and Ireland
14. Precedent Discovery and Open Legal Transparency
15. Post-Quantum Security Analysis
16. Storage Optimization for Post-Quantum Cryptographic Data
17. Performance Analysis
18. Phased Transition Roadmap
19. Complete Technology Stack
20. Formal Cryptographic Research Roadmap for Constitution-Grade Digital Judiciary Systems
21. Conclusions
Disclaimer on Names and Case Scenarios
References
Preprint
Article
This version is not peer-reviewed.
TRUST-Court: Tamper-Resistant Records for Universal Secure Transparency in Digital Judiciary Systems
Basker Palaniswamy * 
Basker Palaniswamy * 
Show more
Version 1
Submitted:
04 March 2026
Posted:
06 March 2026
You are already at the latest version
Abstract
What if a court verdict could never be altered---not today, not tomorrow, and not even in the age of quantum computers? This paper introduces \textbf{TRUST-Court}, a next-generation digital judiciary framework that makes court records \textbf{tamper-proof, transparent, and quantum-secure}. Every participant in a case---plaintiff, defendant, lawyer, and judge---receives a verified digital identity and signs court proceedings using \textbf{post-quantum cryptographic algorithms standardized by NIST in 2024}. Hearings are transcribed in real time, digitally signed by all parties, and permanently sealed using multi-layer cryptographic protection before being anchored to a blockchain for public verification.The system integrates permissioned blockchain infrastructure (Hyperledger Fabric), public verification anchoring (Polygon), and post-quantum cryptographic primitives including \textbf{ML-DSA, ML-KEM, SLH-DSA, SHA-3, and AES-256}. To address the large data sizes of post-quantum signatures, we introduce practical storage optimization techniques such as Merkle-tree batching, signature aggregation, and archival compression, achieving \textbf{60--80% storage reduction} while preserving security guarantees. Through case studies from the United States, India, and Ireland, TRUST-Court demonstrates how judicial records can become mathematically verifiable public artifacts. By preventing document tampering, eliminating transcript disputes, and enabling citizen-level verification of verdicts, the framework offers a pathway toward a judiciary where \textbf{truth, once recorded, becomes permanently unalterable}.
Keywords:
blockchain
;
digital signatures
;
post-quantum cryptography
;
ML-DSA
;
ML-KEM
;
SLH-DSA
;
storage optimization
;
e-judiciary
Subject:
Computer Science and Mathematics - Applied Mathematics
1. Introduction
The judiciary is the cornerstone of democratic governance, yet it remains one of the least digitized institutions globally. In the United States, federal and state courts process over 80 million cases annually, with an average civil case lifecycle exceeding 25 months. India faces an even more acute crisis, with over 50 million pending cases across its three-tier court hierarchy. Document tampering, transcript disputes, and delayed publication of verdicts erode public trust and undermine the rule of law.
To understand the problem in everyday terms, consider what happens today when a court verdict is delivered. A judge writes or dictates a judgment. That document is typed, printed, filed in a registry, and sometimes uploaded to a government website. At any point in this chain, the document can be altered—intentionally or accidentally—and there is no simple, mathematical way for a citizen to verify whether the published verdict is exactly what the judge signed. In high-profile cases, allegations of “missing pages” or “altered paragraphs” are not uncommon, and they can take months or years to resolve. For ordinary citizens, this means that the very institution meant to deliver justice cannot always prove that its own records are authentic.
Recent advances in cryptographic engineering and distributed ledger technology present a transformative opportunity. Digital signatures provide mathematical guarantees of authenticity and non-repudiation—meaning that if a judge signs a document digitally, it becomes mathematically impossible to alter even a single character without detection. Blockchain networks offer immutable, auditable records without reliance on any single trusted authority. Together, these technologies can give every citizen the ability to independently verify that a court record is genuine, complete, and unchanged.
Critically, the emergence of cryptographically relevant quantum computers (CRQCs) poses an existential threat to classical public-key cryptography: RSA, ECDSA, and EdDSA will all be broken by Shor's algorithm. The implication for judicial systems is severe—an adversary could, in the future, forge digital signatures on court records that were signed with today's classical algorithms. Intelligence agencies are already believed to be stockpiling encrypted communications and signed documents in anticipation of quantum decryption capabilities, a strategy known as “harvest now, decrypt later.” Judicial records—which must remain verifiable for decades—demand post-quantum security from day one.
In August 2024, NIST finalized three post-quantum standards: ML-DSA (FIPS 204, lattice-based signatures), ML-KEM (FIPS 203, lattice-based key encapsulation), and SLH-DSA (FIPS 205, hash-based signatures). These represent the culmination of an eight-year international effort and form the cryptographic foundation of TRUST-Court.
However, post-quantum cryptographic algorithms introduce a practical challenge: significantly larger key and signature sizes. For example, a single ML-DSA-65 signature is 3,293 bytes (compared to 64 bytes for Ed25519), and an SLH-DSA-192f signature is 35,664 bytes. When a judiciary system processes millions of cases per year, each with multiple signed transcripts and verdicts, the cumulative storage burden becomes substantial. This paper addresses this challenge head-on, proposing storage optimization strategies that reduce the footprint by 60–80% without compromising security.
Our contributions include:
A post-quantum enrollment protocol linking verified identities to ML-DSA/SLH-DSA signing keys and ML-KEM encapsulation keys.
A multi-party hybrid PQ signature scheme for court transcript signing with formal security analysis.
A hybrid blockchain architecture combining Hyperledger Fabric with Polygon PoS for national-scale deployment.
Storage optimization techniques for post-quantum cryptographic data, achieving 60–80% reduction in storage requirements.
Case studies for the USA, India, and Ireland, including a detailed Irish traffic offence courtroom walkthrough.
A formal cryptographic research roadmap identifying eleven open problems and attractive directions for the cryptographic community.
A phased national transition roadmap with formal post-quantum security proofs.
2. The Quantum Threat to Judicial Records
This section explains why quantum computers threaten the security of court records and why action must be taken now, even though large-scale quantum computers may still be years away.
2.1. What Is a Quantum Computer?
A classical computer stores information as bits—each bit is either 0 or 1. A quantum computer uses qubits, which can exist in a combination (superposition) of 0 and 1 simultaneously. This allows quantum computers to explore many possible solutions in parallel for certain mathematical problems. While quantum computers are not faster for everyday tasks like word processing, they are dramatically faster at specific mathematical problems that underpin modern cryptography.
2.2. Shor's Algorithm and Public-Key Cryptography
In 1994, mathematician Peter Shor discovered a quantum algorithm that can efficiently solve two problems considered extremely hard for classical computers: factoring large numbers and computing discrete logarithms. These are precisely the foundations of the most widely deployed public-key cryptographic systems. RSA relies on the difficulty of factoring large numbers. ECDSA and EdDSA rely on the elliptic curve discrete logarithm problem. Diffie-Hellman and ECDH key exchanges also rely on discrete logarithm assumptions. A sufficiently powerful quantum computer running Shor's algorithm would break all of these systems, regardless of key size.
2.3. The “Harvest Now, Decrypt Later” Threat
For judicial systems, the threat timeline is particularly concerning because court records must remain verifiable for decades:
Today: An adversary records classically-signed judicial records.
Future (2030–2040): With CRQCs, the adversary forges new signatures under classical schemes.
Impact: Retroactive falsification of verdicts, evidence, and judicial reasoning.
The U.S. government has explicitly recognized this threat: National Security Memorandum 10 (NSM-10, May 2022) mandates federal agencies transition to PQ cryptography. CNSA 2.0 requires PQ algorithms by 2025 and exclusive use by 2033. Judicial records demand at least equivalent protection. 
2.4. Grover's Algorithm and Symmetric/Hash Security
Grover's algorithm (1996) provides a quadratic speedup for searching, effectively halving symmetric key strength. TRUST-Court mandates AES-256 (128-bit PQ security) and SHA-3-256 (128-bit PQ pre-image resistance) to maintain comfortable security margins.
3. Related Work
Several countries have taken steps toward digitizing their judicial systems, though none has yet implemented a comprehensive post-quantum secure framework.
Estonia pioneered with its e-Court system (2006), enabling electronic filing and case tracking, but relies on classical cryptographic signatures vulnerable to future quantum attacks. Singapore's eLitigation platform provides modern web-based court management with digital signature support, also without post-quantum primitives. China introduced blockchain-based evidence preservation in its Internet Courts starting in 2017, a significant step, but the underlying blockchain uses classical cryptography. The European Union's e-CODEX project enables cross-border judicial communication, and the eIDAS Regulation provides a legal framework for electronic signatures, but does not mandate post-quantum algorithms.
In the United States, PACER provides electronic access to federal court documents but lacks any cryptographic integrity—documents are simply PDF files on a server, with no way for citizens to verify authenticity mathematically. In India, the eCourts Mission Mode Project (Phase III, 2023) has digitized case filing and tracking across district courts, but does not provide tamper-evident records. Decentralized justice platforms such as Kleros and OpenLaw explore blockchain-based dispute resolution for private arbitration, but none employs post-quantum security.
Legally, the eIDAS Regulation (EU), India's IT Act 2000 (Section 3A), and the US E-SIGN Act (2000) provide statutory foundations for digital signatures in judicial contexts. In Ireland, the Courts Service provides online case tracking and the courts.ie portal publishes selected judgments, but lacks cryptographic integrity guarantees. The Legal Aid Board and FLAC (Free Legal Advice Centres) assist citizens but operate with limited access to comprehensive precedent databases. Ireland benefits from the EU's eIDAS framework for electronic signatures and the Electronic Commerce Act 2000, providing a strong statutory foundation for digital court records.
None of the existing systems employ post-quantum cryptographic primitives, representing a critical gap that TRUST-Court is designed to fill.
4. Post-Quantum Cryptographic Primitives
This section introduces the cryptographic building blocks of TRUST-Court. For readers unfamiliar with cryptography, we provide plain-language explanations alongside technical specifications. The central idea is simple: every important action in the court system relies on mathematical operations that are believed to be impossible to reverse, even with a quantum computer.
Table 1 summarizes all cryptographic primitives. 
Table 1. Complete Cryptographic Primitive Suite for TRUST-Court
4.1. ML-DSA-65: Primary Signature Scheme
What it does (plain language): ML-DSA is the primary digital signature algorithm. When a judge, lawyer, or party signs a court document, they create a mathematical “seal” that proves they approved it. If anyone changes even a single character after signing, the seal breaks and the tampering is detected.
Technical specification: ML-DSA (FIPS 204) is based on Module-LWE and Module-SIS over polynomial rings. ML-DSA-65 provides NIST Level 3 security with 1,952-byte public keys, 3,293-byte signatures, signing in 0.5 ms, and verification in 0.3 ms.
4.2. SLH-DSA-SHA2-192f: Archival Hash-Based Signatures
What it does (plain language): SLH-DSA is a backup signature used specifically for final verdicts. While ML-DSA relies on lattice mathematics, SLH-DSA relies solely on hash function security—the most battle-tested and conservative assumption in cryptography. Even if a breakthrough someday weakens lattice-based schemes, hash-based signatures would remain secure.
Technical specification: SLH-DSA (FIPS 205, based on SPHINCS+) relies solely on hash function security. Public keys are 48 bytes (remarkably small), but signatures are 35,664 bytes (large, yet acceptable for one-time verdict sealing). Signing takes approximately 15 ms and verification 1.5 ms.
4.3. ML-KEM-768: Post-Quantum Key Encapsulation
What it does (plain language): ML-KEM enables two parties to establish a shared secret key over an insecure network, used in TRUST-Court to create encrypted communication channels for sensitive case information.
Technical specification: ML-KEM (FIPS 203) provides quantum-resistant key exchange with 1,184-byte public keys and 1,088-byte ciphertexts at NIST Level 3, achieving IND-CCA2 security under Module-LWE.
4.4. Hybrid Signature Construction
During the transition period, TRUST-Court employs hybrid signatures combining classical and post-quantum algorithms for defense in depth:
σ hybrid = σ Ed 25519 ∥ σ ML - DSA - 65
(1)
Verification requires both to be valid. For final verdicts, a triple hybrid adds SLH-DSA:
σ verdict = σ Ed 25519 ∥ σ ML - DSA - 65 ∥ σ SLH - DSA - 192 f
(2)
What this means for citizens: A verdict protected by a triple hybrid signature is secured by three completely independent mathematical assumptions. For it to be forged, an attacker would need to simultaneously break elliptic curve mathematics, lattice mathematics, and hash function security—a scenario cryptographers consider essentially impossible. 
5. System Architecture
TRUST-Court is organized into five layers, each responsible for a specific aspect. Think of these layers like the floors of a building: each builds upon the one below it. Figure 1 presents the architecture. 
Figure 1. Five-layer architecture of TRUST-Court. Post-quantum cryptographic services (Layer 3) underpin all operations.
5.1. Layer 1: Identity and Enrollment
Plain language: Before anyone can participate, they must prove who they are and receive digital credentials—similar to showing ID before entering a secure building, except the “ID” here is a set of cryptographic keys for signing documents securely.
Technical: Each participant registers via a government portal, undergoes identity verification (Login.gov IAL2 for USA; Aadhaar eKYC for India), and receives PQ key pairs generated in a FIPS 140-3 Level 3 HSM: ML-DSA-65 signing keys, Ed25519 hybrid keys, ML-KEM-768 encapsulation keys, and (for judges) SLH-DSA-SHA2-192f archival keys. An X.509v3 certificate with PQ extensions is issued.
5.2. Layer 2: Court Session Management
Plain language: During a hearing, everything said is captured by AI speech recognition, verified by a human operator, and assembled into a structured digital transcript. Every piece of evidence is “fingerprinted” using a hash function so any future tampering is detected instantly.
Technical: Real-time AI transcription with human verification, structured JSON document assembly with NTP-synchronized timestamps and speaker attribution, and SHA-3-256 evidence hashing.
5.3. Layer 3: PQ Cryptographic Services
Plain language: This is the security engine—every signature, encryption, and hash computation is performed here using post-quantum algorithms running inside tamper-proof hardware modules (HSMs).
Technical: HSM-backed ML-DSA-65 + Ed25519 hybrid signatures for sessions; triple hybrid (+ SLH-DSA) for verdicts; ML-KEM-768 hybrid key exchange for TLS channels; AES-256-GCM encryption; SHA-3-256/384 hashing.
5.4. Layer 4: Hyperledger Fabric
Plain language: Once a court record is signed, it is stored on a private blockchain operated by authorized judicial institutions. A blockchain is a distributed database where records are linked using cryptographic hashes, making it effectively impossible to alter a past record without detection.
Technical: Permissioned blockchain with PQ-enabled MSP, Raft consensus, chaincode for PQ signature verification, and private data collections for sealed records.
5.5. Layer 5: Public Transparency and Precedent Discovery
Plain language: A cryptographic hash of each published verdict is written to a public blockchain (Polygon), where anyone in the world can verify it. Citizens visit a transparency portal, enter a case number, and receive mathematical confirmation. Critically, this layer also provides a Precedent Search API that allows any person—lawyers, judges, citizens, researchers, and journalists—to search the entire corpus of published verdicts by legal issue, statute, keyword, or outcome. Every returned result can be cryptographically verified, and every citation carries a mathematical proof of authenticity (see Section 14 for full details).
Technical: SHA-3-256 verdict hashes anchored to Polygon PoS. Citizen verification portal, Open Data API, and Precedent Search API (full-text + structured metadata) for published records. Elasticsearch-based indexing of verdict text, legal provisions, precedent citations, and outcome classifications.
6. Enrollment Protocol
The enrollment process ensures that every participant has been properly identified and received the cryptographic keys necessary to participate. Figure 2 shows the flow. 
Figure 2. Enrollment protocol: email verification, government ID proofing, PQ key generation in HSM, and X.509v3 certificate issuance.
7. Court Session Recording and Signing Protocol
The court session protocol defines how a hearing is recorded, verified, and signed. It has four phases ( Figure 3). 
Figure 3. Four-phase court session protocol with post-quantum cryptography at every stage.
At session end, each participant i signs:
σ i = Ed 25519. Sign ( s k i , Ed , h T ) ∥ ML - DSA - 65. Sign ( s k i , ML , h T )
(3)
where h T = SHA - 3 - 256 ( T ) . The record R = { T , metadata , h T , { σ i } , { Cert i } } is stored on IPFS and committed to Fabric after chaincode verifies all signatures.
Algorithm 1: Post-Quantum Court Session Signing Protocol
Require:
Transcript T, Participants P = { P 1 , … , P n } with ( s k i , Ed , s k i , ML )
Ensure:
Signed record R on blockchain
1:
h T ← SHA - 3 - 256 ( T )
2:
for each P i ∈ P in parallel do
3:
σ i ← Ed 25519. Sign ( s k i , Ed , h T ) ∥ ML - DSA . Sign ( s k i , ML , h T )
4:
end for
5:
CID T ← IPFS . Store ( T )
6:
R ← { SID , h T , CID T , { ( p k i , σ i ) } i = 1 n }
7:
Fabric.SubmitTransaction( R) chaincode verifies all PQ sigs
8. Verdict Issuance and Public Publication
The verdict document V receives the highest cryptographic protection: a triple hybrid PQ signature (Eq. 2). Figure 4 shows the publication flow. 
Figure 4. Verdict publication protocol with triple hybrid post-quantum signatures.
9. Blockchain Architecture
TRUST-Court uses a dual-chain architecture combining two blockchain types ( Figure 5). 
Figure 5. Dual-chain architecture: Hyperledger Fabric (permissioned, PQ signatures) with Polygon PoS (public anchoring).
US topology: 13 circuit organizations + SCOTUS, 94 district court peers, 5-node Raft orderer. India: Supreme Court + 25 High Courts + NIC, ∼700 district peers (phased), 7-node Raft.
10. Case Study 1: US Patent Litigation — Smith v. TechCorp
This section presents a detailed walkthrough of a multi-session patent infringement proceeding in a U.S. federal court, demonstrating how TRUST-Court handles complex civil litigation—from party enrollment through twelve hearing sessions to a final, publicly verifiable verdict. 
10.1. Step 1: Party Enrollment
Before the case can proceed in TRUST-Court, all participants must be enrolled with verified digital identities and post-quantum cryptographic keys.
Plaintiff — John Smith ( jsmith@email.com): Mr. Smith registers on the federal judiciary's TRUST-Court portal. He verifies his email via a 128-bit cryptographic nonce, then completes identity proofing through Login.gov at Identity Assurance Level 2 (IAL2), which requires document verification and a selfie match. His PQ key suite is generated in an HSM: ML-DSA-65 + Ed25519 signing keys, ML-KEM-768 encapsulation keys. An X.509v3 PQ certificate is issued with role: Plaintiff.
Plaintiff's Attorney — Sarah Johnson ( sjohnson@lawfirm.com): Ms. Johnson is already enrolled as an active member of the California Bar with a TRUST-Court PQ certificate (role: Attorney). Her keys were generated during her initial enrollment and are stored in her law firm's FIPS 140-3 Level 3 HSM.
Defense Counsel — Mark Davis ( mdavis@techcorplegal.com): Mr. Davis, representing TechCorp, completes the same enrollment process. His certificate includes his California Bar number and role: Attorney.
Presiding Judge — Hon. Patricia Chen: Judge Chen is enrolled with the full judicial PQ key suite, which includes the standard ML-DSA-65 + Ed25519 + ML-KEM-768 keys plus an SLH-DSA-SHA2-192f archival key. This additional key is reserved for judges and is used exclusively for verdict sealing, providing the most conservative cryptographic protection for final judicial orders.
Why enrollment matters here: Every person who participates in the trial receives unique cryptographic keys tied to their verified real-world identity. This means every digital signature can be traced to a specific, verified individual. No one can later claim “I didn't sign that” or “someone else signed on my behalf”—the mathematics make impersonation impossible.
10.2. Step 2: Case Filing and Evidence Submission
Ms. Johnson files the complaint digitally via the TRUST-Court e-filing system: NDCA-SJ-2027-CV-01847. The filing is digitally signed with her hybrid PQ keys: σ filing = Ed 25519. Sign ( s k Johnson , Ed , h f ) ∥ ML - DSA . Sign ( s k Johnson , ML , h f ) (4) where h f = SHA - 3 - 256 ( complaint_document ) .
Patent documents (Exhibit P-1), source code comparison reports (Exhibit P-2), licensing history records (Exhibit P-3), and expert analysis (Exhibit P-4) are each hashed with SHA-3-256 and stored on IPFS with their Content Identifiers (CIDs) linked to the case record.
TechCorp's answer and counterclaims are similarly filed and PQ-signed by Mr. Davis. Prior art references (Exhibit D-1 through D-6) are hashed and linked.
All filings are committed to the Hyperledger Fabric blockchain (Northern District of California channel), creating an immutable, timestamped record of every document submitted.
10.3. Step 3: Court Sessions 1–12
The trial spans twelve court sessions over four months. Each session follows the four-phase protocol (Open, Record, Sign, Commit).
10.3.1. 3a. Representative Session: Expert Testimony (Session 7)
Judge Chen opens Session SID-007 via the TRUST-Court court terminal.
All 4 participants authenticate via PQ TLS (X25519 + ML-KEM-768 hybrid handshake).
AI transcription captures all testimony in real time with speaker attribution and NTP-synchronized timestamps. 
10.3.2. 3b. Multi-Party PQ Signing of Each Session
At the conclusion of each session, the transcript signing proceeds identically:
The complete transcript T is displayed for all 4 participants to review on courtroom terminals.
Any corrections are proposed, reviewed, and appended as amendments.
Final hash: h T = SHA - 3 - 256 ( T ) .
Each participant signs with hybrid PQ keys: σ i = Ed 25519. Sign ( s k i , Ed , h T ) ∥ ML - DSA - 65. Sign ( s k i , ML , h T ) ( 3 , 357 bytes each ) (5)
Total signature data per session: 4 × 3 , 357 = 13 , 428 bytes (≈13.1 KB).
Transcript stored on IPFS; record committed to Fabric after chaincode verifies all 4 PQ signatures.
Over 12 sessions, the case accumulates 12 × 13 , 428 = 161 , 136 bytes (≈157 KB) of signature data—efficiently batched using Merkle-tree signature batching ( Section 16) into a single 32-byte on-chain root.
10.4. Step 4: Verdict
After closing arguments in Session 12, Judge Chen delivers the verdict. 
10.5. Step 5: PQ Cryptographic Sealing of Verdict
Judge Chen's verdict document V is finalized in the TRUST-Court system.
Hash computed: h V = SHA - 3 - 256 ( V ) — 32 bytes.
Triple hybrid archival signature: σ verdict = Ed 25519. Sign ( s k Chen , Ed , h V ) ( 64 bytes ) ∥ ML - DSA - 65. Sign ( s k Chen , ML , h V ) ( 3 , 293 bytes ) ∥ SLH - DSA . Sign ( s k Chen , SLH , h V ) ( 35 , 664 bytes ) (6) Total signature: 39,021 bytes (≈38 KB).
Verdict stored on IPFS: CID V = bafybei ....
Committed to Fabric (Northern District of California channel).
SHA-3-256 hash anchored to Polygon PoS: transaction hash 0x3e8b....
Published on the federal judiciary's transparency portal.
10.6. Step 6: Public Verification and Appeal Implications
Any person can verify this verdict:
Visit the federal transparency portal at transparency.uscourts.gov/verify.
Enter case number NDCA-SJ-2027-CV-01847 or scan the QR code on the verdict document.
The portal retrieves the verdict from IPFS, recomputes SHA-3-256, and verifies the on-chain Polygon anchor.
All three components of Judge Chen's triple PQ signature are verified against her published X.509v3 certificate.
A green checkmark confirms: “Verdict integrity verified. All post-quantum signatures valid.”
Appeal implications: If TechCorp appeals to the Federal Circuit, the appellate court can independently verify the complete trial record—all twelve session transcripts and the verdict—using the same cryptographic verification process. Because every transcript was PQ-signed by all four participants, there is no possibility of transcript disputes on appeal. The mathematical record is definitive.
How others discover this verdict: Beyond the parties themselves, the general public learns about this verdict through multiple channels (see Section 14): it appears automatically on the public verdict feed at transparency.uscourts.gov/feed, is discoverable via keyword searches such as “data compression patent infringement Northern District California,” is reported by legal news outlets with embedded verification widgets, and is indexed in the Precedent Search API for any future litigant to cite. A patent attorney in Texas preparing a similar infringement case can find this ruling without knowing its case number—a simple search for “software patent + doctrine of equivalents + permanent injunction” returns it alongside all comparable verdicts.
11. Case Study 2: India Criminal Case — State of Maharashtra v. Rajesh Kumar
This section presents a detailed walkthrough of a cybercrime prosecution in India, demonstrating how TRUST-Court handles criminal proceedings with Aadhaar-based enrollment, bilingual Hindi/Marathi transcription, digital forensic evidence, and the full PQ signature lifecycle from first hearing to sentencing. 
11.1. Step 1: Party Enrollment via Aadhaar eKYC
All participants enroll in TRUST-Court using India's Aadhaar identity system, which provides biometric verification for over 1.3 billion citizens.
Public Prosecutor — Anita Desai: Ms. Desai registers on ecourts.gov.in and completes Aadhaar eKYC verification (fingerprint + OTP). Her PQ key suite is generated: ML-DSA-65 + Ed25519 + ML-KEM-768. An X.509v3 PQ certificate is issued with role: Public Prosecutor, linked to her Maharashtra Bar Council registration number.
Accused — Rajesh Kumar: Mr. Kumar enrolls at a court kiosk located in the Sessions Court lobby. Because he is in judicial custody, a court officer supervises the enrollment. Aadhaar eKYC verification is completed via iris scan (as his fingerprints are already on file with the police). His PQ key suite is generated and stored in the court kiosk's HSM. His certificate role is Accused.
Defense Advocate — Suresh Patel: Mr. Patel is already enrolled with an active PQ certificate through his prior participation in other TRUST-Court proceedings. His keys reside in his law office's HSM.
Presiding Judge — Hon. Meera Rao: Judge Rao holds the full judicial PQ key suite including SLH-DSA-SHA2-192f archival keys. Her certificate is issued by the Supreme Court of India's PQ Root Certificate Authority (ML-DSA-87).
Aadhaar enrollment advantage: India's Aadhaar system provides a unique advantage for TRUST-Court deployment. Unlike the US, where identity proofing requires document verification through Login.gov, Aadhaar enables biometric identity verification in seconds—even at a court kiosk. This makes enrollment accessible even in rural district courts.
11.2. Step 2: Case Filing and Digital Evidence Linking
The First Information Report (FIR) from the Cyber Crime Cell, Mumbai Police, is digitally signed by the investigating officer and committed to the Hyperledger Fabric blockchain (Maharashtra Police channel). Its IPFS CID is linked to the case.
Case filed digitally: SC-Mumbai-2026-Crim-04291.
Digital forensic evidence is submitted and hash-linked:
Exhibit P-1: Server logs from the phishing domain (SHA-3-256 hashed, 32 bytes fingerprint)
Exhibit P-2: Email headers showing phishing campaign distribution
Exhibit P-3: Bank transaction records showing unauthorized transfers from 47 accounts
Exhibit P-4: IP address trace report linking activity to the accused's residence
Exhibit P-5: Forensic image of the accused's laptop (hash of disk image stored; full image on IPFS)
Each exhibit is PQ-signed by the investigating officer and the forensic examiner, then committed to Fabric. This creates an unbreakable chain of custody—no one can later allege that evidence was tampered with after seizure.
11.3. Step 3: Court Sessions — Trial Proceedings
The trial spans six sessions over two months, conducted bilingually in Hindi and Marathi.
11.3.1. 3a. Session Initialization
Judge Rao opens Session SID-001 via the TRUST-Court terminal at Sessions Court, Mumbai.
All participants authenticate via PQ TLS using X.509v3 PQ certificates.
The AI transcription system is configured for bilingual Hindi/Marathi mode, with each utterance tagged with the language detected.
11.3.2. 3b. Representative Session: Digital Forensic Evidence (Session 3)
11.3.3. 3c. Multi-Party PQ Signing of Each Session
After each session, the bilingual transcript T is displayed on courtroom terminals for all 4 participants.
Language tags are verified—participants confirm that Hindi and Marathi portions are accurately attributed.
Final hash: h T = SHA - 3 - 256 ( T ) .
Each participant signs: σ i = Ed 25519. Sign ( s k i , Ed , h T ) ∥ ML - DSA - 65. Sign ( s k i , ML , h T ) ( 3 , 357 bytes each ) (7)
Total per session: 4 × 3 , 357 = 13 , 428 bytes. Over 6 sessions: ≈78.6 KB of signature data.
All transcripts stored on IPFS and committed to Fabric (Maharashtra Judiciary channel).
11.4. Step 4: Verdict
After hearing all evidence and arguments across six sessions, Judge Rao delivers the verdict. 
11.5. Step 5: PQ Cryptographic Sealing of Verdict
Judge Rao's verdict document V is finalized in TRUST-Court.
Hash computed: h V = SHA - 3 - 256 ( V ) — 32 bytes.
Triple hybrid archival signature: σ verdict = Ed 25519. Sign ( s k Rao , Ed , h V ) ( 64 bytes ) ∥ ML - DSA - 65. Sign ( s k Rao , ML , h V ) ( 3 , 293 bytes ) ∥ SLH - DSA . Sign ( s k Rao , SLH , h V ) ( 35 , 664 bytes ) (8) Total signature: 39,021 bytes (≈38 KB).
Verdict stored on IPFS: CID V = bafybei ....
Committed to Fabric (Maharashtra Judiciary channel).
SHA-3-256 hash anchored to Polygon PoS.
Published bilingually on transparency.ecourts.gov.in in both English and Hindi.
11.6. Step 6: Public Verification and Victim Notification
Any citizen can verify the verdict on transparency.ecourts.gov.in/verify by entering case number SC-Mumbai-2026-Crim-04291.
The 47 victims are automatically notified via the TRUST-Court system that the verdict has been published and can be independently verified.
Victims eligible for compensation (INR 1,50,000 from the fine) can verify the order's authenticity before approaching the court for disbursement.
Multilingual significance: India has 22 scheduled languages. This case demonstrates TRUST-Court's ability to handle bilingual proceedings (Hindi/Marathi testimony with English legal citations), publish verdicts in multiple languages, and maintain a single cryptographically unified record. The underlying hash and signatures cover the complete multilingual document, ensuring that translations cannot diverge from the original without detection.
How others discover this verdict: The 47 victims are notified directly (Channel 3), but the broader public discovers this verdict through the real-time verdict feed filtered by “Sessions Court Mumbai + IT Act” (Channel 1), keyword searches such as “phishing identity theft bank conviction Mumbai” (Channel 2), news media reports with embedded verification widgets (Channel 6), and legal aid clinics advising cybercrime victims (Channel 7). A prosecutor in Delhi preparing a similar case can search “Section 66C + phishing + conviction + sentencing” and find this ruling with its complete reasoning, outcome, and one-click verification link—all without knowing the case number in advance (see Section 14 for the full discovery framework).
12. Case Study 3: Traffic Offence in Ireland — DPP v. Seán O'Brien
This section presents a detailed, step-by-step walkthrough of a common traffic offence case in Ireland, demonstrating how TRUST-Court handles everyday judicial proceedings within the Irish legal framework—from the moment a Garda issues a Fixed Charge Notice through to the final digitally-signed District Court verdict. 
12.1. Step 1: Incident and Digital Fixed Charge Notice Issuance
Garda Sergeant Aoife Brennan uses the TRUST-Court-integrated Garda enforcement app on her government-issued mobile device.
She authenticates using her enrolled PQ digital identity (MyGovID-verified, ML-DSA-65 certificate issued by the Courts Service of Ireland PQ Certificate Authority).
The app captures: date/time (NTP-synchronized), GPS location (South Link Road, Cork, 51.8891°N, 8.4756°W), vehicle registration number (211-C-4567), and the offence (driving without valid licence, Section 38, Road Traffic Act 1961).
Garda Brennan digitally signs the electronic Fixed Charge Notice (e-FCN): σ FCN = Ed 25519. Sign ( s k Brennan , Ed , h f ) ∥ ML - DSA . Sign ( s k Brennan , ML , h f ) (9) where h f = SHA - 3 - 256 ( FCN_data ) .
The signed e-FCN is committed to the Hyperledger Fabric network (An Garda Síochána — Courts Service channel).
Mr. O'Brien receives the e-FCN via post and email with a QR code linking to the blockchain record. Under the Road Traffic Act 2002 (as amended), he has 28 days to pay 80 (increasing to 120 after 28 days), or allow the matter to proceed to District Court.
12.2. Step 2: Contestation and Case Filing
Mr. O'Brien believes his licence was valid at the time of the stop. He had applied to renew his driving licence through the NDLS (National Driver Licence Service) online portal at ndls.ie on 20 December 2026, but the renewed licence card had not yet arrived by post. His old licence card showed an expiry date of 31 December 2026.
He does not pay the Fixed Charge Notice within the 56-day period. A summons is issued to appear at Cork District Court.
Mr. O'Brien registers on the TRUST-Court portal at courts.ie/trust-court, verifies his identity via MyGovID (the Irish government's digital identity service, backed by the Public Services Card), and receives his PQ key suite (ML-DSA-65 + Ed25519 + ML-KEM-768).
His solicitor, Ms. Ciara Fitzpatrick, is already enrolled with an active PQ certificate (role: Solicitor, Law Society of Ireland registration number linked).
A case is filed digitally: DC-Cork-2027-Traffic-01193. The e-FCN's IPFS CID and blockchain transaction ID are linked as the primary prosecution evidence.
Judge Brendan McCarthy is assigned to hear the case at Cork District Court. He is enrolled with the full judicial PQ key suite including SLH-DSA archival keys, issued by the Courts Service of Ireland PQ Root Certificate Authority.
12.3. Step 3: Court Session — Hearing
The hearing is conducted at Cork District Court, Washington Street, Cork, on 12 March 2027.
12.3.1. 3a. Session Initialization
Judge McCarthy opens Session SID-001 via the TRUST-Court court terminal.
All participants authenticate via PQ TLS (X25519 + ML-KEM-768 hybrid handshake) using their X.509v3 PQ certificates.
Participants: Judge McCarthy (Judge), Garda Sgt. Brennan (Prosecution Witness), Mr. O'Brien (Defendant), Ms. Fitzpatrick (Defense Solicitor), and the State Solicitor Mr. Declan Murphy representing the Director of Public Prosecutions.
12.3.2. 3b. Court Proceedings — Transcribed in Real Time
The following is a summary of the digitally transcribed proceedings (each utterance is timestamped and speaker-attributed): 
12.3.3. 3c. Multi-Party PQ Signing of Session Transcript
The complete transcript T is displayed on the courtroom signing terminals for all 5 participants to review.
A minor correction is proposed by Sol. Fitzpatrick (the spelling of “Síochána” is corrected); the amendment is appended.
Final hash: h T = SHA - 3 - 256 ( T ) .
Each of the 5 participants signs using their hybrid PQ keys: σ i = Ed 25519. Sign ( s k i , Ed , h T ) ∥ ML - DSA - 65. Sign ( s k i , ML , h T ) ( 3 , 357 bytes each ) (10)
Total signature data for session: 5 × 3 , 357 = 16 , 785 bytes.
Transcript stored on IPFS ( CID T ); on-chain record submitted to Fabric; all 5 PQ signatures verified by chaincode before commit.
12.4. Step 4: Verdict
Judge McCarthy delivers the verdict in the same session. 
12.5. Step 5: PQ Cryptographic Sealing of Verdict
Judge McCarthy's verdict document V is finalized in the TRUST-Court system.
Hash computed: h V = SHA - 3 - 256 ( V ) — 32 bytes.
Triple hybrid archival signature: σ verdict = Ed 25519. Sign ( s k McC , Ed , h V ) ( 64 bytes ) ∥ ML - DSA - 65. Sign ( s k McC , ML , h V ) ( 3 , 293 bytes ) ∥ SLH - DSA . Sign ( s k McC , SLH , h V ) ( 35 , 664 bytes ) (11) Total signature: 39,021 bytes (≈38 KB).
Verdict stored on IPFS: CID V = bafybei ....
Committed to Fabric (Courts Service of Ireland channel).
SHA-3-256 hash anchored to Polygon PoS: transaction hash 0x7f9a....
Published on transparency.courts.ie in English and Irish.
12.6. Step 6: Public Verification
Any citizen can now verify this verdict:
Visit transparency.courts.ie/verify.
Enter case number DC-Cork-2027-Traffic-01193 or scan the QR code on the verdict document.
The portal retrieves the verdict from IPFS, recomputes SHA-3-256, and compares with the on-chain Polygon anchor.
The portal verifies all three components of Judge McCarthy's triple PQ signature against his published X.509v3 certificate.
A green checkmark confirms: “Verdict integrity verified. All post-quantum signatures valid.”
But how does the public know this case exists? Mr. O'Brien knows his own case number, but what about a different driver in Galway facing the same problem next month? She does not need to know this specific case number. She can search the Precedent Search API for “expired licence NDLS online renewal charge dismissed Road Traffic Act” and discover this verdict instantly (Channel 2). Alternatively, she may see it on the public verdict feed filtered by “District Court Cork + traffic” (Channel 1), read about it in a news article on rte.ie or thejournal.ie with an embedded verification link (Channel 6), or learn about it from a Citizens Information Centre or FLAC (Free Legal Advice Centres) clinic (Channel 7). The QR code printed on the court order (Channel 4) can also be shared. A complete description of all seven discovery channels is provided in Section 14. 
Figure 6. Complete lifecycle of the Irish traffic offence case through TRUST-Court: from Garda Fixed Charge Notice to citizen-verifiable, post-quantum sealed public verdict.
Figure 6. Complete lifecycle of the Irish traffic offence case through TRUST-Court: from Garda Fixed Charge Notice to citizen-verifiable, post-quantum sealed public verdict. 
13. Comparative Analysis: USA, India, and Ireland
Table 2. Deployment Comparison: United States, India, and Ireland
Table 2. Deployment Comparison: United States, India, and Ireland
14. Precedent Discovery and Open Legal Transparency
One of the most powerful yet underexplored benefits of TRUST-Court is its potential to transform how legal precedents are discovered, cited, and verified. In most judicial systems today, finding relevant past judgments is difficult, expensive, and often incomplete. Lawyers must search through fragmented databases, pay for access to proprietary legal repositories, and rely on manual citation chains that may miss important rulings. Ordinary citizens—who have every right to understand the law that governs them—are often entirely shut out of this process. TRUST-Court changes this fundamentally by making every published verdict, its underlying problem statement, and its legal reasoning openly searchable, freely accessible, and cryptographically verifiable by anyone.
14.1. The Problem: Opaque Judicial Records
To understand why this matters, consider the current state of affairs in the two jurisdictions studied in this paper:
In the United States, the PACER system charges $ 0.10 per page to access federal court documents. While this fee seems small, it generates over $ 150 million per year and creates a meaningful barrier for independent researchers, small law firms, public interest organizations, and individual citizens. Many state court records are even less accessible, scattered across county-level websites with inconsistent formats and no search capability. A lawyer preparing a defense in a routine traffic case cannot easily discover that a judge in a neighboring district ruled favorably on an identical issue six months ago.
In India, the situation is more acute. While the eCourts portal provides basic case status information, the full text of most lower court judgments is not published online at all. High Court and Supreme Court judgments are available on individual court websites, but there is no unified, searchable database covering all courts. A defense advocate in a district court in Pune has no practical way to discover that a magistrate in Chennai ruled on an identical legal question the previous month. This information asymmetry disadvantages litigants, creates inconsistent outcomes, and undermines the principle that like cases should be decided alike.
14.2. TRUST-Court's Precedent Transparency Architecture
TRUST-Court addresses this problem through a dedicated Precedent Discovery Layer integrated into the Layer 5 Public Transparency Portal. Every published verdict is not merely stored—it is structured, indexed, and made searchable so that any person, whether a Supreme Court advocate or an ordinary citizen, can discover relevant past rulings.
14.2.1. Structured Verdict Metadata
When a judge issues a verdict through TRUST-Court, the system automatically extracts and indexes the following structured metadata alongside the full verdict text:
Problem Statement (Case Summary): A concise description of the legal dispute—what happened, who is involved, and what legal question the court was asked to decide. For example: “Whether a driving licence renewed online through the NDLS but not yet reflected in the physical card constitutes a valid licence under Section 38 of the Road Traffic Act 1961 (Ireland).”
Legal Provisions Invoked: All statutes, sections, and regulations cited by the parties and the court (e.g., “Road Traffic Act 1961, Section 38 (Ireland)”; “IT Act 2000, Section 66C (India)”; “35 U.S.C. §284 (USA)”).
Precedents Cited: All prior judgments cited in the ruling, linked to their own TRUST-Court records where available (e.g., “ State of Kerala v. Unni (2019)”; “ Phillips v. AWH Corp., 415 F.3d 1303 (Fed. Cir. 2005)”).
Legal Reasoning Tags: Machine-readable tags categorizing the legal reasoning applied (e.g., “doctrine of equivalents,” “digital evidence admissibility,” “online renewal validity”).
Outcome Classification: Whether the case resulted in acquittal, conviction, damages awarded, injunction granted, fine set aside, etc., with the specific order.
Court and Jurisdiction: The court level, geographic jurisdiction, and presiding judge.
Cryptographic Verification Link: The Polygon anchor hash and IPFS CID, enabling anyone to verify the verdict's authenticity directly from the search results.
All of this metadata is itself included in the SHA-3-256 hash that is PQ-signed by the judge, ensuring that the metadata cannot be altered or misrepresented after publication.
14.2.2. Open Precedent Search API
TRUST-Court exposes a public, free-of-charge Precedent Search API that enables any person or software application to search the entire corpus of published verdicts. The API supports the following query types: 
Table 3. Precedent Search API — Query Types and Use Cases
Table 3. Precedent Search API — Query Types and Use Cases
14.2.3. Precedent Verification and Citation
A critical feature of TRUST-Court's precedent system is that every cited precedent can be cryptographically verified. When a lawyer cites a past judgment in a new case, the citation includes the TRUST-Court verification hash. The court (or opposing counsel, or any member of the public) can instantly verify that the cited judgment is authentic, complete, and has not been altered or selectively quoted.
This eliminates a class of problems that currently plague judicial systems: misquoted judgments, fabricated citations, and selective excerpting that misrepresents a court's reasoning. In TRUST-Court, a citation is not just a reference to a document—it is a cryptographic commitment to the exact content of the referenced verdict.
The citation format is:
Citation = { CaseID , CourtID , Date , h V , CID V , PolygonTxHash }
(12)
where h V = SHA - 3 - 256 ( V ) is the verdict hash, CID V is the IPFS content identifier, and the Polygon transaction hash provides a public, immutable anchor. Any recipient of this citation can independently verify the full verdict in seconds.
14.3. How This Changes Legal Practice
14.3.1. For Lawyers
Consider Ms. Ciara Fitzpatrick, the defence solicitor from Case Study 3 ( Section 12). Before arguing that an online-renewed licence is valid despite the physical card not yet being delivered, she needs to find precedents supporting her position. In the current system, she would need to search multiple legal databases (BAILII, the Courts Service website, and commercial services such as Justis or Westlaw IE), each with different coverage, different search interfaces, and subscription fees.
With TRUST-Court's Precedent Search API, Ms. Fitzpatrick can issue a single query—“online renewal valid expired licence Road Traffic Act”—and instantly receive a list of all published verdicts across every TRUST-Court-connected court in Ireland (and indeed across jurisdictions) that have addressed this issue. Each result includes the problem statement, the court's reasoning, the outcome, and a cryptographic verification link. She can cite these precedents in her argument with the confidence that the court can verify them instantly.
14.3.2. For Judges
Judges benefit equally. When Judge McCarthy hears the traffic case, he can search the precedent database to see how other District Court judges have ruled on identical facts. This promotes judicial consistency—the principle that similar cases should produce similar outcomes regardless of which court hears them. Currently, a judge in Cork may be completely unaware that a judge in Dublin ruled on the same legal question last month. TRUST-Court eliminates this information gap.
14.3.3. For Citizens
Perhaps most importantly, TRUST-Court's open precedent system empowers ordinary citizens. A person facing a traffic fine, a tenant disputing an eviction, or a small business owner challenging a regulatory penalty can search the precedent database to understand how courts have ruled on similar issues. This does not replace the need for legal counsel, but it dramatically reduces the information asymmetry between citizens and the legal system.
For example, Mr. Seán O'Brien, before even engaging a solicitor, could search “expired licence NDLS online renewal charge dismissed” and discover that multiple courts have ruled in favour of defendants in similar situations. Armed with this knowledge, he can make an informed decision about whether to contest the charge and can provide his solicitor with relevant precedents from the outset.
14.3.4. For Legal Researchers and Journalists
Law students, academic researchers, policy analysts, and investigative journalists gain access to the complete corpus of published judicial decisions with full-text search, structured metadata, and cryptographic authenticity guarantees. This enables large-scale empirical legal research that is currently impossible in most jurisdictions—for example, analyzing sentencing patterns across different courts, tracking the adoption of new legal doctrines, or identifying systematic inconsistencies in judicial outcomes.
14.4. Precedent Discovery Flow
Figure 7 illustrates the complete precedent discovery and citation verification workflow. 
Figure 7. Precedent discovery and cryptographically verified citation workflow. Every cited precedent can be independently verified by any party.
14.5. How Does the General Public Discover Cases?
A natural question arises: if public verification requires a case number or QR code, how does a member of the general public—someone who is not a party to the case—come to know that a particular verdict exists and learn its case number? In today's systems this is a genuine barrier; in TRUST-Court, it is addressed through seven complementary discovery channels, ensuring that no one needs to already know a case number to find relevant judicial decisions.
14.5.1. Channel 1: Proactive Public Notification Feed
TRUST-Court's transparency portal maintains a real-time public verdict feed—similar to a news feed or government gazette—where every newly published, non-sealed verdict appears automatically upon publication. This feed is:
Accessible at transparency.ecourts.gov.in/feed (India) or transparency.uscourts.gov/feed (USA).
Filterable by court, jurisdiction, date range, case type (civil, criminal, traffic, family, etc.), and legal topic.
Available as an RSS/Atom feed, a JSON API, and a human-readable web page, so that news organizations, legal blogs, research institutions, and individual citizens can subscribe.
A journalist covering cybercrime in Mumbai, for example, can subscribe to the feed filtered by “Sessions Court Mumbai + IT Act” and automatically receive notification whenever a new cybercrime verdict is published—complete with the case number, problem summary, outcome, and verification link.
14.5.2. Channel 2: Full-Text and Topic Search (No Case Number Required)
The Precedent Search API described in Section 14 does not require a case number. Any person can search by:
Keywords: “phishing bank identity theft Mumbai” returns all published verdicts matching those terms.
Legal provision: “Section 66C IT Act” returns every case decided under that statute.
Outcome type: “dismissed + Section 38 Road Traffic Act” finds all cases where a driving charge was dismissed.
Natural language: “Can I be fined if I renewed my driving license online but the physical card wasn't updated?” (the system uses semantic search to find verdicts with matching fact patterns).
This means that a citizen who has never heard of case DC-Cork-2027-Traffic-01193 can still discover it by searching for the legal issue they care about. Every search result includes the case number, a one-paragraph problem summary, the outcome, and a one-click verification link.
14.5.3. Channel 3: Automatic Party and Stakeholder Notifications
When a verdict is published, TRUST-Court automatically notifies all directly interested parties via the contact information in their enrollment profiles:
Parties to the case (plaintiff, defendant, accused) receive SMS, email, and in-app notification with the case number, outcome summary, QR code, and verification link.
Enrolled lawyers in the case receive the same notification plus a link to the full signed verdict on IPFS.
Victims (in criminal cases with identified victims, as in Case Study 2) receive notification that a verdict has been issued and can verify it.
Concerned government agencies (e.g., the Regional Transport Office in a traffic case, the bank's fraud department in a cybercrime case) receive structured notifications via the Open Data API.
14.5.4. Channel 4: QR Codes on Physical Documents
Every verdict document—whether displayed on screen, printed, or communicated to parties—includes a prominently placed QR code that encodes the verification URL. This QR code can be:
Printed on official court orders served to parties.
Displayed on courtroom screens when the verdict is announced.
Included in SMS/email notifications to parties.
Published alongside the verdict on government websites.
Printed in newspapers or shown in news broadcasts when media outlets report on cases.
Anyone who sees the QR code—whether on a physical court order, a newspaper article, or a television broadcast—can scan it with any smartphone to instantly verify the verdict's authenticity. No prior knowledge of the case number is required.
14.5.5. Channel 5: Court Daily Cause Lists and Gazette Publication
Courts already publish daily cause lists (the schedule of cases to be heard on a given day) and periodic gazettes (official publications of court orders). In TRUST-Court, these are enhanced:
Daily cause lists include hyperlinks to the TRUST-Court records for each listed case.
When a verdict is delivered, the cause list entry is updated with the outcome and verification link.
Official gazettes (the Gazette of India or the Federal Register) include TRUST-Court verification hashes for all published judicial orders.
14.5.6. Channel 6: News Media and Public Interest Integration
TRUST-Court provides a dedicated Media API endpoint that news organizations can integrate into their reporting workflows. When a journalist writes about a court case, they can embed the TRUST-Court verification widget directly in their article. Readers of the news article can click the widget to verify the cited verdict themselves, rather than relying solely on the journalist's account. This creates a new standard of accountability in legal journalism: every claimed court ruling can be independently checked by the reader.
14.5.7. Channel 7: Legal Aid Clinics and Community Outreach
For citizens who lack internet access or digital literacy, TRUST-Court supports integration with legal aid clinics, Common Service Centres (CSCs) in India, and public library terminals. Legal aid workers can search the precedent database on behalf of citizens, print verification-linked summaries, and explain how the verification process works. In India, the network of over 400,000 CSCs can serve as access points, ensuring that even rural citizens without smartphones can discover and verify court decisions relevant to their situation. 
14.6. Privacy-Preserving Transparency
An important consideration is that not all case details should be publicly searchable. TRUST-Court implements a nuanced privacy framework:
Fully public: Verdict text, legal reasoning, outcome, statutes cited, and precedents cited. These are always searchable.
Redacted public: Cases involving minors, sexual offenses, national security, or other sensitive matters are published with personal identifiers redacted. The legal reasoning and outcome remain searchable, but identifying details are removed. The PQ signature covers the redacted version (using redactable signatures where available—see Section 20, Direction 5).
Sealed: Certain records (e.g., ongoing investigations, sealed juvenile records) are not published to the precedent database at all. They remain on the permissioned Fabric chain and are accessible only to authorized parties.
This graduated approach ensures that precedent transparency does not come at the cost of legitimate privacy interests, while maximizing the volume of searchable legal knowledge.
14.7. Impact on Justice System Efficiency
Open precedent discovery is expected to have a significant positive impact on judicial efficiency:
Reduced re-litigation: When parties can easily discover that courts have consistently ruled a certain way on a legal question, frivolous or hopeless cases are less likely to be filed.
Faster case preparation: Lawyers spend less time searching for precedents and more time on substantive legal analysis.
Judicial consistency: Judges can quickly determine how peers have ruled on similar issues, reducing inconsistent outcomes across jurisdictions.
Early settlement: When both parties can see how courts have ruled on comparable facts, out-of-court settlements become more likely, reducing the burden on the court system.
Legal aid empowerment: Public defenders and legal aid organizations, which often lack the budgets for premium legal databases, gain equal access to the full precedent corpus. 
15. Post-Quantum Security Analysis
15.1. Threat Model
We consider: (1) classical adversaries, (2) quantum adversaries with CRQCs, (3) insider threats, and (4) multi-party collusion.
15.2. Security Guarantees
ML-DSA-65 is EU-CMA secure under Module-LWE/SIS in the QROM. SLH-DSA security relies only on hash function pre-image resistance. SHA-3-256 retains 128-bit PQ security under Grover. ML-KEM-768 provides IND-CCA2 security under Module-LWE. 
All three failure modes would need to occur simultaneously for forgery. □
15.3. PQ Threat-Defense Mapping
Figure 8. Post-quantum threat-defense mapping.
Figure 8. Post-quantum threat-defense mapping. 
16. Storage Optimization for Post-Quantum Cryptographic Data
One of the most significant practical challenges of post-quantum cryptography is the dramatically larger sizes of keys and signatures. Table 4 illustrates the scale of this problem. 
Table 4. Size Comparison: Classical vs. Post-Quantum Cryptographic Objects
Scale of the problem: India processes approximately 30 million new cases per year. With an average of 5 sessions plus a verdict per case, annual signature data alone would be approximately 3.7 TB. Over a 20-year archival period, this grows to ∼74 TB—a substantial burden requiring efficient management.
16.1. Technique 1: Merkle-Tree Signature Batching
Instead of storing individual session signatures on-chain, we batch multiple sessions into a Merkle tree and store only the 32-byte root hash on-chain. Full signatures reside off-chain (IPFS) with Merkle inclusion proofs for individual verification:
MerkleRoot = MT . Root ( SHA - 3 - 256 ( σ 1 ) , … , SHA - 3 - 256 ( σ B ) )
(15)
For B = 256 sessions, on-chain storage drops from 4.3 MB to 32 bytes—a 99.8% reduction.
16.2. Technique 2: SLH-DSA Signature Compression
SLH-DSA signatures have internal structure (WOTS+ signatures and hypertree authentication paths) exploitable by compression. Applying zlib/DEFLATE reduces signatures from 35,664 to ∼28,000–30,000 bytes ( 16–22% reduction). Furthermore, signature deduplication across verdicts from the same judge within an epoch—sharing hypertree authentication paths—yields an additional 25–35% reduction.
16.3. Technique 3: Delta Encoding for Public Key Certificates
The same participants (judges, prosecutors, frequent advocates) appear across many cases. A certificate registry stores each certificate once, indexed by a 16-byte CertID. Court records reference CertIDs rather than embedding full certificates. With 5 participants per record, this saves ∼10,000 bytes per record, or approximately 300 GB per year across 30 million cases.
16.4. Technique 4: Tiered Archival Storage
Not all records are accessed equally. We implement three tiers with progressive compression:
Tier 1 (Hot, 0–6 months): Full uncompressed records on SSD. Raw signatures for fast verification.
Tier 2 (Warm, 6 months–5 years): LZ4 compression. SLH-DSA signatures compressed. Certificate deduplication. HDD arrays. Achieves 40–55% compression.
Tier 3 (Cold, 5+ years): Zstandard at high compression. Epoch archives. Tape/cloud cold storage. Precomputed Merkle proofs. Achieves 65–80% compression.
16.5. Technique 5: On-Chain Storage Minimization
The blockchain stores only the minimum for verification. Per record on-chain: Case ID (32 B), hash (32 B), IPFS CID (36 B), Merkle batch root (32 B), metadata (64 B)—total ≈196 bytes. All bulk data (transcripts, signatures, certificates, evidence) resides off-chain. This achieves a 99.6% reduction versus storing full signatures on-chain.
16.6. Combined Storage Impact
Table 5. Combined Storage Optimization Impact (India, 30M cases/year)
Table 5. Combined Storage Optimization Impact (India, 30M cases/year)
These optimizations make TRUST-Court's post-quantum storage requirements comparable to a classical system, removing storage as a practical barrier to adoption.
17. Performance Analysis
Figure 9. Latency of all cryptographic and blockchain operations (log scale). SLH-DSA signing at 15 ms is the slowest PQ operation—still fast for verdict signing.
Figure 9. Latency of all cryptographic and blockchain operations (log scale). SLH-DSA signing at 15 ms is the slowest PQ operation—still fast for verdict signing. 
Total end-to-end session signing: <10 seconds (excluding human review). Verdict with SLH-DSA: <11 seconds. PQ overhead is negligible.
18. Phased Transition Roadmap
Figure 10. Four-phase transition roadmap with progressive PQ migration.
Figure 10. Four-phase transition roadmap with progressive PQ migration. 
19. Complete Technology Stack
Figure 11. Complete technology stack with PQ cryptography at every layer.
Figure 11. Complete technology stack with PQ cryptography at every layer.  
20. Formal Cryptographic Research Roadmap for Constitution-Grade Digital Judiciary Systems
This section serves a dual purpose: it establishes a formal security model for the TRUST-Court protocol suite, and it identifies eleven open research problems representing attractive directions for the cryptographic community. Each problem includes a formal definition, a security game, a target theorem, and a discussion of why this problem matters for judiciary applications and what makes it an attractive research direction.
The judiciary domain presents unique constraints: extremely long archival periods (50–100+ years), public verifiability alongside selective privacy, non-technical users, and “constitution-grade” security requirements where cryptographic failure could undermine an entire branch of government.
20.1. System Model and Adversarial Setting
Let λ denote the security parameter. Let Π = ( Π ID , Π TR , Π EV , Π LOG , Π AR ) be a judiciary protocol suite consisting of: Π ID (identity and credential lifecycle), Π TR (transcript authentication), Π EV (confidential evidence storage), Π LOG (public transparency infrastructure), and Π AR (long-term archival verification).
Adversaries are PPT algorithms A including external adversaries, insider adversaries (compromised judges, log operators), adaptive adversaries with key compromise capability, and quantum adversaries with polynomial-time quantum computation. Security must hold with negligible probability in λ .
20.2. Direction 1: Post-Quantum Transparency Log Security
Why this matters: Transparency logs underpin public accountability in TRUST-Court. A split-view attack—where an adversary presents different log views to different observers—would collapse the system's trustworthiness. While classical Merkle-tree logs are well-studied, their security under quantum adversaries requires new analysis.
Why it is attractive: Designing logs provably secure in the QROM requires revisiting standard collision-resistance arguments when adversaries query hash functions in quantum superposition, connecting to fundamental open questions in post-quantum hash security.
Definition 1
(Append-Only Transparency). A log L is append-only if no PPT adversary can produce two distinct log views L 1 ≠ L 2 such that both verify under public consistency proofs while diverging on any committed entry. 
Theorem 1
(Transparency Security Objective). If H is collision-resistant against quantum adversaries, then any Merkle-based log achieves negligible split-view advantage.
Open problem: Construct a transparency log with a tight security reduction in the QROM.
20.3. Direction 2: Post-Quantum Key Transparency and Identity Continuity
Why this matters: Participants' keys must be rotated and may be revoked. Key transparency ensures all observers agree on current and historical keys. Without this, an adversary could register a fraudulent key for a judge and sign fake verdicts.
Why it is attractive: The migration from classical to PQ keys must itself be quantum-secure, creating windows of vulnerability that require novel composable security models. This connects to verifiable data structures, consensus, and identity management.
Definition 2
(Non-Equivocating Identity Mapping). A key transparency system guarantees that for any identity id , all observers see a unique, globally consistent public key history.
Open problem: Design a key transparency scheme where classical-to-PQ key rotation is provably secure under a composable security model with no vulnerability window.
20.4. Direction 3: Threshold Post-Quantum Signatures
Why this matters: High-stakes operations (constitutional court rulings, apex court orders) may require multiple judges to jointly sign. Threshold signatures prevent any single compromised judge from issuing fraudulent orders.
Why it is attractive: Threshold ML-DSA is one of the most active and challenging open problems in post-quantum cryptography. Unlike classical ECDSA, lattice algebraic structure makes threshold signing significantly harder. NIST and IACR conferences have highlighted this as a priority.
Let TSig be a ( t , n ) -threshold signature scheme.
Definition 3
(Threshold Unforgeability). No adversary controlling fewer than t signing shares can produce a valid signature.
Open problem: Construct an efficient ( t , n ) -threshold ML-DSA with O ( 1 ) rounds and signature size independent of n, proven secure in the QROM.
20.5. Direction 4: Forward-Secure Post-Quantum Signatures
Why this matters: Compromise of a current signing key should not allow forging signatures on past documents. This is critical for judiciary archives spanning decades.
Why it is attractive: Forward-secure signatures from lattices are largely unexplored. Key evolution must be efficient and compose with hybrid signatures, connecting to fundamental questions about key management and tree-based constructions.
Definition 4
(Forward Security). Compromise of secret key at epoch i does not enable forgery for epochs < i .
Open problem: Design a forward-secure ML-DSA variant with O ( 1 ) key update time and at most logarithmic key material growth.
20.6. Direction 5: Post-Quantum Redactable Signatures
Why this matters: Courts often publish verdicts while redacting sensitive information (minors' identities, classified evidence). Redactable signatures allow authorized field removal without invalidating the signature on remaining content—providing mathematical guarantees beyond simple text blacking.
Why it is attractive: Redactable signatures from lattice or hash assumptions are almost completely unexplored, connecting to commitment schemes, chameleon hashes, and sanitizable signatures.
Definition 5
(Sanitizable Authenticity). A redactable signature permits authorized removal of fields without enabling insertion or modification of non-redacted content.
Open problem: Construct a post-quantum redactable signature based on Module-LWE or hash functions with formal proof of non-expansion.
20.7. Direction 6: Post-Quantum Attribute-Based Encryption
Why this matters: Court evidence has complex access control—a medical report accessible to the judge and attorneys but not the public; sealed juvenile records accessible only to the presiding judge. ABE enables cryptographic, fine-grained access control.
Why it is attractive: Post-quantum ABE is emerging with limited expressiveness and efficiency. Judiciary provides concrete, well-defined access policies driving practical scheme design.
Definition 6
(Policy Confidentiality). Ciphertext encrypted under access policy P reveals no information about plaintext to unauthorized parties.
Open problem: Construct practical lattice-based ABE supporting conjunctive policies over judicial roles, with ciphertext size sublinear in the number of attributes.
20.8. Direction 7: Post-Quantum Searchable Encryption
Why this matters: Authorized users need to search encrypted databases of millions of records (judges researching precedents, prosecutors finding related cases) without decrypting everything.
Why it is attractive: Post-quantum SSE with forward privacy (new documents don't leak past query information) and backward privacy (deleted documents don't leak future query information) is rare. Judiciary demands unusually strong guarantees since search patterns could reveal investigative information.
Definition 7
(Forward Privacy). Search queries do not reveal information about past document insertions.
Open problem: Design post-quantum SSE with forward and backward privacy supporting conjunctive keyword queries with sublinear search time.
20.9. Direction 8: Post-Quantum Zero-Knowledge Public Verification
Why this matters: ZK proofs enable proving a verdict was properly signed without revealing the judge's identity (witness protection), or that evidence satisfies criteria without revealing the evidence itself.
Why it is attractive: Post-quantum ZK systems (SNARKs, STARKs) are frontier research. Judiciary motivates specific optimizations: proofs small enough for QR codes, verification on consumer devices. This connects to lattice-based SNARKs, hash-based proof systems, and recursive composition.
Definition 8
(Succinct Verifiability). A verifier checks validity of judicial claim using proof π of size polylogarithmic in transcript size.
Open problem: Construct a post-quantum SNARK with proof sizes under 1 KB suitable for judicial verdict verification, with verification time under 50 ms on a smartphone.
20.10. Direction 9: Post-Quantum Accumulators and Vector Commitments
Why this matters: The court system must efficiently prove that a case record is (or is not) part of the official judicial record set. Accumulators and vector commitments enable compact membership proofs for large sets.
Why it is attractive: Lattice-based accumulators with efficient batch updates and compact membership witnesses are an open problem, with applications extending far beyond judiciary systems.
Definition 9
(Dynamic Membership). Given commitment C to set S, prover can show x ∈ S with witness w.
Open problem: Construct a dynamic post-quantum accumulator with O ( log n ) witness size and O ( 1 ) update time, secure under standard lattice assumptions.
20.11. Direction 10: Adversarial Timestamping
Why this matters: If a record is anchored at time t, no adversary should be able to claim it was anchored earlier. This prevents backdating of court documents.
Why it is attractive: Combining post-quantum hash functions with distributed timestamping protocols creates novel security models where anchor-chain integrity must be analyzed under quantum adversaries.
Definition 10
(Temporal Immutability). If record r is anchored at time t, no adversary can produce valid anchor at earlier time t ′ < t .
Open problem: Prove that linked-timestamping with SHA-3 achieves temporal immutability against quantum adversaries under standard assumptions.
20.12. Direction 11: Post-Quantum Verifiable Delay Functions
Why this matters: VDFs ensure that certain operations take a minimum amount of real time, preventing adversaries from rushing processes (e.g., ensuring minimum deliberation periods before verdict sealing). They can also provide fair randomness for judge assignment.
Why it is attractive: Existing VDF constructions rely on classical assumptions (groups of unknown order, isogenies). Post-quantum VDFs from lattice or hash assumptions are essentially an open field, with high impact across blockchain, cryptography, and distributed systems.
Definition 11
(Sequential Hardness). Computing f ( x ) requires T sequential steps, while verification requires polylog ( T ) .
Open problem: Construct a VDF from post-quantum assumptions with efficient verification and provable sequential hardness against quantum parallel adversaries.
20.13. Unified Composability Objective
Definition 12
(Constitution-Grade Security). Protocol suite Π achieves constitution-grade security if:
1.
All subprotocols satisfy their respective security games.
2.
Security composes under concurrent execution.
3.
Security holds against adaptive quantum adversaries.
4.
Long-term archival verification remains valid for T ≫ 20 years. 
20.14. Research Deliverables (Formal Targets)
The following represent concrete, publishable research targets for the community:
Formal security proofs for threshold ML-DSA variants with practical round complexity.
Composable hybrid-to-PQ migration framework with reduction proofs and zero-downtime guarantees.
Leakage-bounded searchable encryption tailored to judiciary threat models with quantified leakage profiles.
Post-quantum ZK verification circuits for transcript validity optimized for on-chain verification.
Long-term cryptographic agility model with provable safety margins across algorithm generations.
Storage-efficient PQ signature aggregation schemes with formal security under batch verification.
Practical post-quantum redactable signatures supporting hierarchical redaction policies.
21. Conclusions
Courts exist to protect truth, yet judicial records in many systems remain vulnerable to delay, dispute, or manipulation. This paper introduced TRUST-Court ( Tamper-Resistant Records for Universal Secure Transparency), a practical framework for a digital judiciary in which every hearing, document, and verdict becomes a verifiable fact. By combining post-quantum cryptography, real-time transcript authentication, and blockchain-based anchoring, TRUST-Court ensures that once a judicial record is created, it cannot be altered without detection.
In the proposed system, court proceedings are captured in real time and digitally signed by all participants, creating a mathematically verifiable record of what occurred in the courtroom. Final verdicts are sealed using multiple layers of modern cryptographic protection and anchored to a distributed ledger, allowing any citizen to independently confirm the authenticity and integrity of judicial documents. The framework is designed to remain secure even in a future where quantum computers threaten today's classical cryptographic systems.
Beyond technological modernization, TRUST-Court strengthens transparency and public confidence. Citizens can verify judgments, lawyers can discover reliable precedents, and researchers can analyze judicial outcomes with cryptographic assurance that records are genuine. By transforming court archives into openly searchable and verifiable legal knowledge, TRUST-Court moves judicial systems from opaque record keeping toward accountable and transparent justice.
With phased deployment and careful integration into existing legal infrastructures, TRUST-Court offers a realistic path for governments to safeguard judicial integrity for decades to come. In the digital era, trust in justice should not rely solely on institutions—it should be reinforced by mathematics.
Disclaimer on Names and Case Scenarios
The names of individuals, organizations, and case scenarios used in this paper are purely illustrative and are included solely for explanatory and educational purposes. Any resemblance to real persons, institutions, companies, or legal cases is entirely coincidental.
The case studies presented (including examples from the United States, India, and Ireland) are hypothetical demonstrations designed to illustrate how the proposed TRUST-Court framework could operate in practical judicial environments. They do not represent actual legal proceedings, real litigants, or real court decisions.
These fictional scenarios are intended only to clarify the technical workflow, cryptographic processes, and system architecture described in this work.
References
NIST. FIPS 204: Module-Lattice-Based Digital Signature Standard (ML-DSA). 2024. [ Google Scholar]
NIST. FIPS 203: Module-Lattice-Based Key-Encapsulation Mechanism Standard (ML-KEM). 2024. [ Google Scholar]
NIST. FIPS 205: Stateless Hash-Based Digital Signature Standard (SLH-DSA). 2024. [ Google Scholar]
NIST, FIPS 202: SHA-3 Standard. Aug 2015.
Bernstein, D.J. EdDSA: High-speed signatures. J. Crypt. Eng. 2012, 2(2), 77–89. [ Google Scholar] [ CrossRef]
Shor, P.W. Algorithms for quantum computation. Proc. 35th FOCS, 1994. [ Google Scholar]
Grover, L.K. A fast quantum algorithm for database search. Proc. 28th STOC, 1996. [ Google Scholar]
Hyperledger Foundation. Fabric v2.5 Documentation. 2024. [ Google Scholar]
Polygon Labs. Polygon PoS Documentation. 2024. [ Google Scholar]
NIST, SP 800-63-4: Digital Identity Guidelines; Dec 2024.
Govt. of India. eCourts Mission Mode Project Phase III. 2023. [ Google Scholar]
Admin. Office of the US Courts, PACER. 2024.
UIDAI, Aadhaar Authentication API v2.5. 2024.
European Parliament. “eIDAS Regulation (EU) 910/2014,” 2014.
US Congress. E-SIGN Act. 2000. [ Google Scholar]
Benet, J. IPFS — Content Addressed P2P File System. arXiv 2014, arXiv:1407.3561. [ Google Scholar]
IETF, draft-ounsworth-pq-composite-sigs. 2024.
The White House, NSM-10: Quantum Computing and Cryptographic Systems. May 2022.
NSA. CNSA 2.0 Advisory. 2022. [ Google Scholar]
Open Quantum Safe Project, liboqs. 2024. Available online: https://openquantumsafe.org/.
Ducas, L. “CRYSTALS-Dilithium,”. TCHES 2018. [ Google Scholar]
Avanzi, R. “CRYSTALS-Kyber,”. Euro S&P 2019. [ Google Scholar]
Bernstein, D.J. “SPHINCS+,” NIST PQ submission. 2022. [ Google Scholar]
Road Traffic Act 1961, Government of Ireland (as amended by Road Traffic Act 2006), Section 38.
Electronic Commerce Act 2000, Government of Ireland, Section 5.
Supreme Court of India. Report of the e-Committee on Digitization. 2023. [ Google Scholar]
Figure 1. Five-layer architecture of TRUST-Court. Post-quantum cryptographic services (Layer 3) underpin all operations. 
Figure 2. Enrollment protocol: email verification, government ID proofing, PQ key generation in HSM, and X.509v3 certificate issuance. 
Figure 3. Four-phase court session protocol with post-quantum cryptography at every stage. 
Figure 4. Verdict publication protocol with triple hybrid post-quantum signatures. 
Figure 5. Dual-chain architecture: Hyperledger Fabric (permissioned, PQ signatures) with Polygon PoS (public anchoring). 
Figure 7. Precedent discovery and cryptographically verified citation workflow. Every cited precedent can be independently verified by any party. 
Table 1. Complete Cryptographic Primitive Suite for TRUST-Court
Table 4. Size Comparison: Classical vs. Post-Quantum Cryptographic Objects
Disclaimer/Publisher's Note: The statements, opinions and data contained in all publications are solely those of the individual author(s) and contributor(s) and not of MDPI and/or the editor(s). MDPI and/or the editor(s) disclaim responsibility for any injury to people or property resulting from any ideas, methods, instructions or products referred to in the content.
© 2026 by the authors. Licensee MDPI, Basel, Switzerland. This article is an open access article distributed under the terms and conditions of the Creative Commons Attribution (CC BY) license ( http://creativecommons.org/licenses/by/4.0/).
Copyright: This open access article is published under a Creative Commons CC BY 4.0 license, which permit the free download, distribution, and reuse, provided that the author and preprint are cited in any reuse.
Downloads
292
Views
195
Comments
0
Subscription
Notify me about updates to this article or when a peer-reviewed version is published.
Subscribe
Recommended Preprints
Financial Document Authentication and Verification Using Hierarchical Tokenization on Permissioned Blockchains
Chialuka Ilechukwu
et al.
,
2026
Accelerating the Deployment of China's National Standard and Industrialisation of Quantum Resistant Cryptography (PQC) Proposal for Building National Security "Double Insurance" in Quantum Era
Wei Meng
,
2025
A Secure and Privacy-Preserving Blockchain-based XAI-Justice System
Konstantinos Demertzis
et al.
,
2023
Recommended Articles
Toward Secure and Scalable Digital Evidence Preservation: A Blockchain-Driven Framework
Areej Dweib
et al.
Blockchains,
2026
Financial Document Authentication and Verification Using Hierarchical Tokenization on Permissioned Blockchains
Chialuka Ilechukwu
et al.
JRFM,
2026
A Secure and Efficient Sharing Framework for Student Electronic Academic Records: Integrating Zero-Knowledge Proof and Proxy Re-Encryption
Xin Li
et al.
Future Internet,
2026
Preprints.org is a free preprint server supported by MDPI in Basel, Switzerland.
   
Contact Us RSS
MDPI Initiatives
SciProfiles
Sciforum
Encyclopedia
MDPI Books
Scilit
Proceedings
JAMS
Important Links
Activities
Advisory Board
Collections
How It Works
Preprints Friendly Journals
Reading List
News
Statistics
Subscribe
Choose an area of interest and we will send you notifications of new preprints at your preferred frequency.
Subscribe
© 2026 MDPI (Basel, Switzerland) unless otherwise stated
Accessibility
Disclaimer
Disclaimer
Terms of Use
Privacy Policy
Privacy Settings
All MDPI websites use third-party website tracking technologies to provide and continually improve our services. I agree and may revoke or change my consent at any time with effect for the future.
You can change your mind at any time by clicking "Privacy Settings" at the bottom of the pages.  
Accept All
Deny
More Information
Powered by Usercentrics Consent Management
Feedback
4