# NIST Selects 9 Third-Round PQC Signature Candidates - PostQuantum.com

- **ID**: `6e1b1025-9c47-49d1-a55d-ba4aaee5051f`
- **Tipo de Fuente**: `SOURCE_TYPE_WEB_PAGE`
- **URL**: [https://postquantum.com/security-pqc/nist-third-round-pqc-signatures/](https://postquantum.com/security-pqc/nist-third-round-pqc-signatures/)

---

## Contenido Extraído / Texto Completo

NIST Selects 9 Third-Round PQC Signature Candidates
Menu
Search for
Home
|
Industry News
All
Quantum Industry & Ecosystem News
Quantum Research & Methods News
Quantum Security, PQC, Post-Quantum News
Quantum Systems & Engineering News
Quantum Policy, Sovereignty & Standards News
|
My Articles:
By Topic
Post-Quantum, PQC, Quantum Security
Q-Day, Y2Q
Quantum Computing (QC)
Quantum Networks
Quantum AI (QAI)
Quantum Sensing
Quantum Policy & Sovereignty
Quantum Commercialization
AI Security & Safety
Cyber-Kinetic Security
5G & mIoT Security
Blockchain & Crypto Security
Society 5.0
Leadership
By Country
ASEAN
Australia
Canada
China
Europe
India
Middle East
Russia
South Korea
Switzerland
United Kingdom
United States
By Industry
Aerospace & Automotive
Energy & Utilities
Finance & Banking
Government & Defense
Healthcare & Medical Research
Materials Science & Chemical Engineering
Pharmaceuticals & Biotechnology
Supply Chain & Logistics
Telecommunications
|
Deep Dives
Quantum Computing for Cyber Professionals
How to Build a Quantum Computer
What It Takes to Build a Quantum Computer
Quantum Systems Integration & QOA
Quantum Computing Modalities
CRQC Quantum Capability Framework
Predicting Q-Day
Getting Started With Quantum Security & PQC
Quantum Security Reference
PQC Governance
Global PQC Migration Timelines
CNSA 2.0: NSA's Post-Quantum Requirements
The Quantum Threat to Cryptocurrencies
Quantum Sovereignty
The Quantum Utility Map
China's Quantum Ambition
Quantum Computing Companies & Roadmaps
Quantum Snake Oil Dictionary
|
Tools
Global PQC Migration Timeline
CRQC Readiness Benchmark (Q-Day Estimator)
PQC Readiness Self-Assessment Scorecard
PQC Migration Advisor
Database of Quantum Computing Modalities
Database of Quantum Hardware Companies
PostQuantum.com AI Explainer
Quantum Physics Paper Analysis
Quantum Technobabble Generator
About Me
About Me
Appearances & Contributions
My Books
Previous Book Reviews
Quantum Sovereignty Book
Quantum Ready Book
PQC Migration Framework
Quantum Systems Integration Book
Quantum Computing for Cybersecurity Professionals Book
Future of Leadership in the Age of AI
Blockchain and Crypto Security
Cyber-Kinetic Security
Contact Me
X
LinkedIn
Telegram
WhatsApp
RSS
Email
Search for
Home/ Quantum Security & PQC/ NIST Narrows the Field: Nine Post-Quantum Signature Candidates Advance to the Third Round
Quantum Security & PQC Post-Quantum, PQC, Quantum Security
NIST Narrows the Field: Nine Post-Quantum Signature Candidates Advance to the Third Round
Marin Ivezic Follow on X Send an email May 15, 2026
16 minutes read 
Table of Contents
Why NIST Needs More Signatures
The Nine Survivors: Four Mathematical Families
MPC-in-the-Head: FAEST, MQOM, and SDitH
Multivariate: UOV, MAYO, QR-UOV, and SNOVA
Isogeny-Based: SQIsign
Lattice-Based: HAWK
The Five That Fell
Reading NIST's Strategy
What This Means for PQC Migration
What to Watch in the Third Round
14 May 2026 – On May 14, 2026, NIST released NIST IR 8610, announcing that nine candidate algorithms have advanced to the third round of its Additional Digital Signatures standardization process. Five candidates were eliminated. The survivors span four distinct mathematical families. Only one of them (HAWK) is lattice-based, and even HAWK rests on different assumptions than ML-DSA (CRYSTALS-Dilithium) and FN-DSA (Falcon), the two lattice-based schemes NIST has selected for its post-quantum signature portfolio.
The bottom line: NIST is building cryptographic insurance. If a breakthrough compromises the standard lattice problems underlying ML-DSA and FN-DSA, most of the algorithms in this pipeline would provide alternatives built on entirely different foundations.
Why NIST Needs More Signatures
Before diving into the candidates, it's worth understanding why NIST launched this process in the first place. The motivation comes from two directions: insurance against cryptanalytic surprise, and a real performance problem in the existing standards.
NIST has finalized two post-quantum signature standards so far: ML-DSA (FIPS 204) and SLH-DSA (FIPS 205). A third, FN-DSA (FIPS 206), has been selected for standardization, with a draft FIPS expected in late 2026 and finalization likely in 2027. Two of the three (ML-DSA and FN-DSA) are lattice-based.
That concentration is the first problem. Lattice cryptography rests on the assumed hardness of problems like Module-LWE and Module-SIS. Those assumptions have held up well, but they represent a single mathematical family. If someone found a way to solve structured lattice problems efficiently, whether classically or with a quantum computer, two of NIST's three signature choices would fall simultaneously. SLH-DSA (the hash-based backup) would survive, but its performance profile, with large signatures and slower operations, makes it a poor fit as the sole remaining option for many applications.
History gives this concern weight. Rainbow, a multivariate scheme that reached the third round of the original NIST PQC process as a signature finalist, was broken in 2022 by a cryptanalytic advance after years of confident security claims. SIKE, an isogeny-based KEM that survived three rounds of NIST scrutiny, was broken over a weekend by Castryck and Decru in mid-2022. Lattice cryptography has been studied longer and harder than either of those, but the lesson is clear: when a portfolio rests on assumptions that only a few hundred specialists deeply understand, prudence demands alternatives.
The second problem is signature size. ML-DSA and FN-DSA, however secure, produce signatures that are too large for some of the deployment scenarios where post-quantum cryptography is most needed. An ML-DSA-44 signature (NIST security category 2) is 2,420 bytes. FN-DSA-512 signatures are 666 bytes. SLH-DSA-128 signatures range from 7,856 bytes for the “small” variant up to 17,088 bytes for the “fast” variant. Compare these to classical ECDSA P-256 at 64 bytes or RSA-2048 at 256 bytes, and the magnitude of the migration tax becomes clear.
For many applications such as TLS connections over high-bandwidth links, or code signing on general-purpose computers, these sizes are an annoyance rather than a deal-breaker. For others, they are a deal-breaker.
Industrial systems and IoT face the worst of it. In my earlier analysis of OT PQC challenges, I detailed the constraints that make ML-DSA difficult to deploy in operational environments: legacy fieldbus protocols with fixed message sizes, microcontrollers with 8-bit CPUs and 256 KB of RAM, devices designed for ten-to-twenty-year operational lifetimes with rare patch windows. A signature that multiplies the size of a SCADA control message can break timing assumptions baked into safety-critical control loops. For these environments, a compact post-quantum signature is not a nice-to-have. It is the difference between deployment being possible and deployment being impossible.
DNSSEC is another case where signature size matters. A DNSSEC validation chain typically involves multiple signatures stacking up through root, TLD, second-level domain, and individual records, and the resulting responses have historically been engineered around 512-byte UDP packets. Modern DNS over TLS, HTTPS, or QUIC eases the MTU constraint, but signature size still affects zone size, resolver caching, and the cost of validating chains of trust. ML-DSA's 2,420-byte signatures would force most DNSSEC responses out of UDP entirely, particularly for end-user devices that increasingly maintain long-lived connections to public recursive resolvers. SQIsign's 148-byte signatures, by contrast, are smaller than RSA-2048 at category 1 and smaller than RSA-4096 at category 5.
Then there is Roughtime, a recent IETF specification for secure time synchronization that bootstraps devices without trusted real-time clocks. The protocol is designed to be small: it transmits roughly 64 bits of actual time data, requires all servers in the ecosystem to use the same signature algorithm for compatibility, and uses Merkle tree batching to amortize signature cost across many requests. In recent pqc-forum discussions on the third-round candidates, Watson Ladd pointed out that using ML-DSA in Roughtime would force such enormous packet expansion that the protocol would likely have to abandon UDP and switch to TCP just to authenticate those 64 bits. SQIsign would let Roughtime stay where it belongs, on a small connectionless transport.
These are not edge cases. Constrained-bandwidth applications including satellite communications, time-sensitive industrial networking, code signing for deeply embedded devices, smart card authentication, and certificate chains in TLS all run into the same fundamental tradeoff. Compact post-quantum signatures unlock deployments that lattice-based signatures cannot reach.
This is what NIST is solving for. The third-round candidates collectively cover the security-and-size design space far more completely than ML-DSA, FN-DSA, and SLH-DSA can on their own. SQIsign at 148 bytes targets bandwidth-starved applications. UOV's 96-byte signatures at category 1 (paying for it with very large public keys) suit verification-heavy workloads where the public key can be cached once and signatures fly past it cheaply. HAWK's integer-only arithmetic makes it deployable on microcontrollers that struggle with FN-DSA's floating-point requirements. FAEST's reliance on AES means it can run on essentially any device that already does symmetric crypto, which is essentially every device.
NIST's Call for Proposals, issued in September 2022, was explicit about both motivations. Non-lattice submissions needed to demonstrate at least one significant performance advantage over SLH-DSA. Lattice-based submissions needed to beat both ML-DSA and FN-DSA on at least one performance metric. The bar was high because NIST wasn't looking for more of the same.
Fifty submission packages arrived by June 2023. Forty survived initial screening. Fourteen made it to the second round. Now nine remain.
The Nine Survivors: Four Mathematical Families
The nine third-round candidates break down into four categories by underlying mathematical assumption. This diversity is the entire point of the exercise.
MPC-in-the-Head: FAEST, MQOM, and SDitH
Three of the nine survivors use a technique called Multi-Party Computation in the Head (MPCitH). The core idea is elegant: to prove you know a secret key, you simulate a multi-party computation inside a cryptographic proof. You split your secret into shares, simulate what multiple parties would compute with those shares, commit to the intermediate values, and reveal just enough for a verifier to check consistency. Through the Fiat-Shamir transform, this interactive proof becomes a non-interactive digital signature.
What makes MPCitH attractive as a class is that the security can rest on well-understood symmetric primitives — hash functions, block ciphers — rather than novel number-theoretic assumptions. The tradeoff is complexity: these schemes have intricate designs and security proofs that require careful community scrutiny. The second round saw rapid evolution as techniques like Threshold Computation in the Head (TCitH) and Vector Oblivious Linear Evaluation in the Head (VOLEitH) dramatically improved performance across the category.
FAEST is the most conservative of the three. Its security relies primarily on AES, arguably the most studied and trusted symmetric cipher in existence. A FAEST signing key is an AES key, and the verification key is an input-output pair under that key. The signature proves, in zero knowledge, that you know the key that maps the input to the output. During the second round, the FAEST team incorporated optimizations including a technique for sharing GGM tree computations and refined proofs in the Quantum Random Oracle Model. NIST selected FAEST specifically because its AES-based security assumptions are considered the most established among the MPCitH candidates.
The drawback is signature size. MPCitH signatures are inherently larger than those of algebraic schemes because they encode the transcript of a simulated computation. FAEST's signatures are competitive within the MPCitH category but still measured in kilobytes rather than bytes.
MQOM earned its spot by having the best performance numbers among the six MPCitH candidates in the second round. At all three NIST security levels, MQOM offers the smallest combined public-key-plus-signature sizes in the MPCitH category, with competitive signing and verification speeds. Its security rests on the hardness of solving random multivariate quadratic systems over finite fields, a different assumption than FAEST's symmetric-primitive foundation but one with a substantial body of study. The caveat, flagged explicitly by NIST: MQOM's security proofs in both the Random Oracle Model and the Quantum Random Oracle Model need further maturation.
SDitH (Syndrome Decoding in the Head) was selected for the conservatism of its underlying hardness assumption. The scheme is built on the syndrome decoding problem for random linear codes over finite fields, a problem that has been studied extensively since the 1970s. Among the MPCitH candidates, only FAEST (with AES) can claim a comparably well-analyzed security foundation. SDitH's tradeoff is computational cost: it is typically slower than its MPCitH peers, though its key and signature sizes are competitive when properly tuned.
NIST's strategy with MPCitH is clear: keep three candidates that collectively cover the strongest security arguments (FAEST for symmetric-primitive trust, SDitH for coding-theory trust, MQOM for performance), and let the third round determine which, if any, mature enough for standardization.
Multivariate: UOV, MAYO, QR-UOV, and SNOVA
Four of the nine survivors belong to the Unbalanced Oil and Vinegar (UOV) family, making multivariate cryptography the most heavily represented category. This is surprising given that the second round inflicted serious damage on several multivariate parameter sets — and it tells you something about the potential NIST sees in these schemes if the security questions can be resolved.
The UOV construction, introduced in 1999, is one of the oldest ideas in post-quantum cryptography. The core concept: construct a system of multivariate quadratic polynomials with a hidden structure (the “oil and vinegar” partition) that lets the signer efficiently invert the system while an attacker faces a computationally hard problem. UOV's signature-size advantage is as small as 96 bytes at NIST security category 1, with verification running in tens of thousands of CPU cycles. The cost is public keys that run to hundreds of kilobytes in expanded form.
MAYO, QR-UOV, and SNOVA are all variants that attempt to solve UOV's public-key problem through different structural tricks. MAYO uses a “whipping” algorithm to expand a small seed key into a full UOV instance. QR-UOV uses quotient ring mathematics to reduce the representation size. SNOVA takes the most aggressive approach, combining a MAYO-like whipping structure with a block-ring structure to achieve the smallest public keys in the family.
The trouble arrived during the second round in the form of the “wedge attack,” published by Ran in early 2025. This attack uses exterior products to expose the hidden oil subspace in characteristic-2 UOV instances. The impact was significant: three of UOV's four parameter sets fell below their security targets, and a separate attack by Furue and Ikematsu exploited small-field characteristics in UOV to push the same three parameter sets (uov-Ip, uov-III, and uov-V) even further below their security strengths. MAYO's category 1 parameter set (MAYO2) lost roughly 30 bits of security to the wedge attack. SNOVA was hit hardest of all — a targeted variant of the wedge attack broke most of its proposed parameter sets, sometimes by a wide margin.
QR-UOV emerged unscathed. Its use of odd-characteristic fields made it immune to the original wedge attack, and subsequent extensions to odd characteristics did not reduce its security below existing attack complexities.
So why did NIST keep all four multivariate candidates? Three reasons, stated explicitly in the report.
First, no attack has broken the underlying UOV construction itself. The wedge attack exploits specific parameter choices, particularly those using characteristic-2 fields. Reparameterization with odd-characteristic fields appears to restore security, and each scheme retains unbroken parameter sets.
Second, the performance potential is unique. If any of these schemes can be securely parameterized, they would offer signature sizes that no other candidate family can match, approaching or even beating the sizes of classical ECDSA signatures. After the wedge attack, the SNOVA team proposed modified parameters using odd-characteristic fields; NIST notes that the resulting category 1 parameter set achieves public-key and signature sizes both smaller than those of FN-DSA (Falcon). That kind of compactness would make post-quantum signatures viable in highly constrained environments.
Third, algorithmic diversity demands it. If lattice assumptions fall and MPCitH schemes prove too slow for certain applications, multivariate signatures might be the only option left with a competitive performance profile.
NIST's language around the multivariate candidates is cautious. The report flags a longer expected timeline for any potential standardization of these schemes and signals that NIST is unlikely to standardize any of them without a further round of evaluation. SNOVA in particular is described as not having “reached a stable form.” The multivariate candidates are in the tournament, but they are on a shorter leash than the others.
Isogeny-Based: SQIsign
SQIsign is unlike anything else in the competition, and it has the numbers to prove it. At NIST security category 1, its signatures are 148 bytes — small enough that a SQIsign signature fits in a single Ethernet frame with room to spare. Its combined public-key-plus-signature size is the smallest of any post-quantum signature candidate by a wide margin, smaller even than many classical signature schemes.
The scheme is built on the mathematics of supersingular elliptic curve isogenies, specifically the hardness of computing isogenies between supersingular curves and determining their endomorphism rings. If that sounds exotic, it is. Isogeny-based cryptography is among the newest areas in post-quantum research, and the mathematical theory involved is deep enough that relatively few cryptographers worldwide can fully analyze it.
SQIsign's second-round submission represented a major architectural overhaul. The original design used a KLPT-based path-finding algorithm; the updated version switches to higher-dimensional isogenies, which simplifies the security analysis and dramatically improves performance. Signing speed increased by roughly 20x and verification by 6x compared to the first-round version. Signature sizes also decreased.
There is an important caveat: SQIsign's cousin, SIKE, was spectacularly broken in 2022 by an attack that exploited auxiliary torsion-point information. SQIsign avoids the structural vulnerability that enabled that attack — it does not expose the auxiliary torsion points that SIKE's key exchange relied on — but the SIKE episode serves as a reminder that isogeny-based constructions can harbor unexpected weaknesses. NIST acknowledges this, calling for continued study of SQIsign's security properties.
The other concern is side-channel resistance. SQIsign's signing procedure involves mathematically complex operations that are difficult to implement in constant time. Partial side-channel leakage during signing has been shown to enable attacks, and achieving fully constant-time signing remains an open engineering challenge.
Despite these concerns, the compactness advantage is so significant that NIST advanced SQIsign. For bandwidth-constrained applications like digital certificates, firmware updates, and IoT authentication, a 148-byte post-quantum signature would be transformative.
Lattice-Based: HAWK
HAWK is the odd one out in this competition. It is lattice-based, which means it shares a mathematical family with ML-DSA and the forthcoming FN-DSA. Normally, that would be a handicap in a process explicitly seeking diversity. HAWK survived because it brings something specific that neither ML-DSA nor FN-DSA offers.
FN-DSA (Falcon), the compact-signature lattice option selected for FIPS 206, requires floating-point arithmetic for its Gaussian sampling during signing. That makes implementation on constrained hardware platforms (devices without dedicated floating-point units) difficult and error-prone. Constant-time floating-point arithmetic is also notoriously hard to get right, creating a persistent side-channel risk.
HAWK eliminates this problem entirely by using integer-only arithmetic. Its signatures at security category 1 are 555 bytes — smaller than both FN-DSA and ML-DSA. The mathematical trade is different: instead of Falcon's NTRU lattice and Gaussian sampling, HAWK uses a rank-2 module lattice with a Gram matrix as the public key, and signing involves sampling short vectors from a coset of the integer lattice using only integer operations.
HAWK's security rests on two assumptions that are newer than the standard lattice problems: the Search Module Lattice Isomorphism Problem (smLIP) and the One-More-Shortest-Vector Problem (omSVP). During the second round, cryptanalytic work explored both of these assumptions. Researchers found a discrepancy in the original omSVP definition that the HAWK team addressed with a refined formulation. Advances in solving smLIP variants were made, but these techniques do not currently apply to the cyclotomic number fields HAWK uses. NIST flagged this area as needing further community analysis.
The Five That Fell
Understanding why candidates were eliminated is often as instructive as understanding why others advanced.
CROSS (code-based) had small public keys but very large signatures, a profile similar to SLH-DSA. The problem: SLH-DSA's security rests on hash function assumptions with decades of study, while CROSS relies on the Restricted Syndrome Decoding problem, which has a much shorter analytical history. CROSS also suffered a second-round attack that forced parameter changes. With comparable performance but weaker security confidence, NIST saw no compelling reason to continue.
LESS (code-based) had the inverse problem — small signatures but very large public keys, plus slow operations. A second-round attack reduced the concrete security of its parameter sets by 12 to 24 bits. The underlying Linear Code Equivalence problem has less study than the foundations of the advancing candidates, and the performance disadvantages were too significant to overcome.
Mirath (MPCitH, based on the MinRank problem) saw impressive second-round performance improvements, up to 10x faster operations, but lost out in a competitive field. NIST chose to narrow the MPCitH category to three candidates with either more established security foundations or stronger performance profiles. Mirath's security assumption (MinRank) is well-studied, but the overall package was not differentiated enough.
PERK (MPCitH, based on the Permuted Kernel Problem) offered slightly smaller signatures than FAEST but was significantly slower, and its underlying PKP assumption has only about 30 years of study with relatively sparse cryptanalytic literature. FAEST's speed advantage and AES-based security made the comparison unfavorable.
RYDE (MPCitH, based on the Rank Syndrome Decoding problem) was the closest competitor to MQOM in performance, with similar signature sizes. But MQOM was consistently faster in head-to-head benchmarks, and NIST chose to consolidate rather than carry forward two schemes with nearly identical operational profiles.
Reading NIST's Strategy
Several patterns emerge from the selection decisions.
Security trumps performance, but performance matters. NIST explicitly states that security is the most important criterion, followed by cost and performance. But among the MPCitH candidates, where security profiles were broadly similar, performance differences drove the selection. MQOM advanced over Mirath and RYDE largely on speed.
Diversity is the point, not a bonus. The nine candidates span six distinct mathematical assumptions: AES/symmetric primitives (FAEST), multivariate quadratic systems (MQOM), syndrome decoding for random codes (SDitH), UOV/multivariate polynomials (the four MV candidates), supersingular isogenies (SQIsign), and module lattice problems (HAWK). If any single mathematical family falls, alternatives exist in the pipeline.
NIST is willing to carry risk where the payoff is high. The multivariate candidates have endured serious attacks. SNOVA has a “concerning history of cryptanalysis,” in NIST's own words. But the potential for compact, fast signatures keeps all four alive. Similarly, SQIsign's exotic mathematics and limited analyst pool are risks, but 148-byte signatures are too compelling to abandon prematurely.
Not all survivors are on equal footing. NIST explicitly signals a longer timeline for multivariate standardization and flags SNOVA as needing to reach a stable form. The MPCitH candidates need their complex security proofs verified. SQIsign needs constant-time signing and broader security analysis. HAWK needs its novel assumptions studied further. Some of these candidates may not survive the third round.
What This Means for PQC Migration
For CISOs and security leaders planning their post-quantum migration, this announcement reinforces several points.
The existing standards are your immediate priority. ML-DSA and SLH-DSA are finalized. FN-DSA is selected for standardization, with FIPS 206 expected to be published as a draft in late 2026 and finalized in 2027. They are what you should be migrating to now. The additional signature candidates are years away from standardization. NIST is hosting another conference in the first half of 2027, and even optimistic timelines put final standards for any of these schemes in the 2028–2030 range.
But crypto-agility becomes more important, not less. The very existence of this process, with NIST actively seeking alternatives to its own recently published standards, tells you that the post-quantum cryptographic field is still evolving. Systems designed today need the flexibility to swap algorithms without architectural overhaul. The PQC Migration Framework at PQCFramework.com treats crypto-agility as a foundational requirement for exactly this reason.
The signature-size challenge is real but solvable. As I covered in the section on why these alternatives matter, ML-DSA and FN-DSA signatures are simply too large for some deployment scenarios, creating friction in protocols like TLS, DNSSEC, Roughtime, and the constrained industrial systems I analyzed in OT PQC challenges. If SQIsign, HAWK, or any of the multivariate candidates reach standardization, they would provide compact signature options that ease these deployment challenges. But “if” is doing heavy lifting in that sentence. Migration planning should assume current standard sizes and treat future compact options as a welcome bonus, not a dependency.
The Harvest Now, Decrypt Later threat does not apply to signatures in the same way it does to encryption — you cannot “harvest” a signature and retroactively forge one once quantum computers arrive. But its analog, Trust Now, Forge Later, does apply. Long-lived digital signatures on documents, firmware, and code that must remain trustworthy for decades are vulnerable to future forgery by a CRQC. The urgency of migrating signature schemes is lower than for encryption, but it is not zero — and regulators, insurers, and investors are setting their own deadlines regardless of when Q-Day arrives.
What to Watch in the Third Round
The third round formally begins now and is expected to last approximately two years, with a NIST PQC Standardization Conference planned for the first half of 2027. Submission teams can submit updated specifications and implementations by August 14, 2026. NIST expects modifications to be relatively minor — significant changes would signal that an algorithm is too immature for standardization.
Several technical storylines are worth tracking.
Can the multivariate candidates stabilize? NIST has given them latitude that it wouldn't normally extend — allowing “more significant tweaks” for SNOVA, for instance — but this comes with the explicit caveat that standardization will take longer. Watch for new parameter sets targeting odd-characteristic fields, which appear resistant to the wedge attack and its extensions.
Will SQIsign's signing become constant-time? The compact signature sizes are extraordinary, but side-channel resistance during signing is a prerequisite for deployment in real-world systems. If the SQIsign team solves this, the scheme becomes a strong contender for bandwidth-constrained applications.
How will the MPCitH security proofs hold up? FAEST, MQOM, and SDitH all underwent substantial redesigns during the second round as new MPCitH techniques emerged. Their security proofs are correspondingly fresh and complex. NIST has flagged proof verification as a critical task for the community during the third round.
Will HAWK's lattice assumptions survive scrutiny? The smLIP and omSVP problems are newer than the Module-LWE and Module-SIS problems underpinning ML-DSA. If they hold, HAWK would provide a compelling integer-arithmetic alternative to FN-DSA. If they don't, HAWK is the one candidate whose elimination would not reduce the diversity of the portfolio, since it shares a lattice-based foundation with existing standards.
NIST's additional signature process has been running since 2022 and won't produce final standards for several more years. The timeline can feel glacial relative to the pace of quantum hardware development. But the methodical approach — test, attack, eliminate, refine, repeat — is exactly how cryptographic standards should be built. The nine candidates that survived represent the best available options for diversifying the post-quantum signature portfolio. The third round will determine which of them are ready for the real world.
I will be tracking each of these candidates through the third round and will update my analysis as new cryptanalytic results and performance data emerge.
Marin Ivezic Follow on X Send an email May 15, 2026
16 minutes read
Share
X LinkedIn Reddit Flipboard WhatsApp Telegram Viber Line Share via Email Print
Marin Ivezic
I am the Founder of Applied Quantum (AppliedQuantum.com), a research-driven consulting firm empowering organizations to seize quantum opportunities and proactively defend against quantum threats. A former quantum entrepreneur, I've previously served as a Fortune Global 500 CISO, CTO, Big 4 partner, and leader at Accenture and IBM. Throughout my career, I've specialized in managing emerging tech risks, building and leading innovation labs focused on quantum security, AI security, and cyber-kinetic risks for global corporations, governments, and defense agencies. I regularly share insights on quantum technologies and emerging-tech cybersecurity at PostQuantum.com.
Website
X
LinkedIn
Related Articles
Qubits: A Brief Introduction for Cybersecurity Professionals
September 2, 2016
The Anatomy of Quantum Denial: What Bitcoin's Response to the Quantum Threat Teaches Every CISO
May 4, 2026
Cryptographically Relevant Quantum Computers (CRQCs)
January 10, 2023
The Quantum Computing Threat
November 4, 2019
PostQuantum.com is my personal website where I explore the intersections of quantum computing and cybersecurity, focusing on building Quantum Resistance and achieving Crypto-Agility. I track advancements toward Cryptographically Relevant Quantum Computers (CRQC) and significant milestones like Q-Day/Y2Q. Additionally, I look into topics surrounding Post Quantum Cryptography (PQC), discussing the challenges and developments in this evolving field.
X
LinkedIn
Telegram
WhatsApp
RSS
Email
© Copyright 2026 Marin Ivezic, All Rights Reserved
X
LinkedIn
Telegram
WhatsApp
RSS
Email
Close
Search for: Search
X
LinkedIn
Telegram
WhatsApp
RSS
Email
Close
Search for