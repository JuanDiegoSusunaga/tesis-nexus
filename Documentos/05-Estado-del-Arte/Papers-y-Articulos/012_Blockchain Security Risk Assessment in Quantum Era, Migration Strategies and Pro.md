# Blockchain Security Risk Assessment in Quantum Era, Migration Strategies and Proactive Defense - arXiv

- **ID**: `c1c5be9a-9989-4285-9b73-6c8e9c851016`
- **Tipo de Fuente**: `SOURCE_TYPE_WEB_PAGE`
- **URL**: [https://arxiv.org/html/2501.11798v2](https://arxiv.org/html/2501.11798v2)

---

## Contenido Extraído / Texto Completo

Blockchain Security Risk Assessment in Quantum Era, Migration Strategies and Proactive Defense
logo Back to arXiv  
logo Back to arXiv
This is experimental HTML to improve accessibility. We invite you to report rendering errors. Use Alt+Y to toggle on accessible reporting links and Alt+Shift+Y to toggle off. Learn more about this project and help improve conversions.
Why HTML? Report Issue Back to Abstract Download PDF 
Table of Contents
Abstract
I Introduction
I-A Contributions
I-B Related Works
I-C Survey Methodology and Literature Sourcing
I-D Organization
II Quantum-Safe Migration Risk Assessment Approach
II-A Risk Scoping and Preparation
II-B Conducting Risk Assessment
III Cryptographic Standards and Quantum Computing: Cyber Impact and Risk Assessment
III-A Classic Cryptographic Standards and Quantum Computing: Cyber Impact and Risk Assessment
III-B Selected Quantum-Resistant Cryptographic Standards: Cyber Impact and Risk Assessment
IV Quantum Impact on BC Technology Components
IV-A BC Network and Quantum Computing Threats
IV-B Mining Pool and Quantum Computing Threats
IV-C Transaction Verification Mechanism and Quantum Computing Threats
IV-D Smart Contract Attacks and Quantum Computing Threats
IV-E User Wallet Attacks and Quantum Computing Threats
V Roles and Responsibilities in Mitigating QC Impacts on BC
VI Challenges and Strategies After Transitioning to Quantum-Resistant BC Systems
VI-A BC Network
VI-B Mining Pool
VI-C Transaction Verification Mechanism
VI-D Smart Contract
VI-E User Wallet
VII Hybrid BC Architectures
VII-A Hybrid Strategies for Cryptographic Primitives
VII-B Architectural Design Approaches
VII-C Risk Assessment and Security Posture
VII-D Hybrid BC Architectures: Comparative Analysis, Design Challenges, and Strategic Pathways
VIII Security Evaluation of Major BC Platforms
VIII-A Security Evaluation of Major BC Platforms: Lessons Learned and Strategic Roadmap
IX Post-Quantum BCs: Current Availability and Their Roles
IX-A Post-Quantum BCs: Lessons Learned and Strategic Roadmap
X Challenges and Future Research Directions
X-A Quantum-Enhanced AI and BC Integration
X-B Web3, Quantum Security and Interoperability
X-C Advanced Privacy-Preserving Cryptographic Systems
X-D Federated Learning, Edge Computing, and IoT Integration
X-E Interdisciplinary Technical and Standardization Challenges
XI Conclusion
References
HTML conversions sometimes display errors due to content that did not convert correctly from the source. This paper uses the following packages that are not yet supported by the HTML conversion tool. Feedback on these issues are not necessary; they are known and are being worked on.
failed: kantlipsum.sty
failed: ltxtable.sty
failed: pmboxdraw.sty
failed: cuted.sty
failed: mdframed.sty
failed: smartdiagram.sty
failed: smartdiagram.sty
failed: fontawesome5.sty
Authors: achieve the best HTML results from your LaTeX submissions by following these best practices.
License: CC BY-NC-ND 4.0
arXiv:2501.11798v2 [cs.CR] null
Blockchain Security Risk Assessment in Quantum Era, Migration Strategies and Proactive Defense
Report issue for preceding element
Yaser Baseri, Abdelhakim Hafid, Yahya Shahsavari, Dimitrios Makrakis and Hassan Khodaiemehr Yaser Baseri, Abdelhakim Hafid, and Yahya Shahsavari are with the Montreal Blockchain Lab, Université de Montréal, Canada. Emails: {yaser.baseri, ahafid, yahya.shahsavari}@umontreal.ca. Dimitrios Makrakis is with the School of Electrical Engineering and Computer Science, University of Ottawa, Canada. Email: dmakraki@uottawa.ca. Hassan Khodaiemehr is with the School of Engineering, The University of British Columbia, Canada. Email: hassan.khodaiemehr@ubc.ca.
Report issue for preceding element
Abstract
Report issue for preceding element
The advent of Quantum Computing (QC) poses significant threats to the cryptographic foundations of Blockchain (BC) systems, as quantum algorithms like Shor's and Grover's undermine the security of public-key cryptography and hash functions. This research conducts a comprehensive risk assessment of quantum vulnerabilities across critical BC components, including consensus mechanisms, smart contracts, and digital wallets. Leveraging the STRIDE threat modeling framework, we analyze threat vectors specific to QC, identifying key areas most susceptible to quantum-enabled attacks, such as private key compromise, consensus disruptions, and smart contract integrity risks. Our contributions provide actionable mitigation strategies, including a detailed security blueprint for quantum resilience, encompassing the integration of Post-Quantum Cryptography (PQC) and the adoption of quantum-resistant hash functions. We offer implementation best practices, focusing on key management, secure coding, and network security to strengthen BC components against quantum threats. To mitigate the risk of QC during transition from classical to quantum-resistant BCs, we present two hybrid BC architectures. As part of a comprehensive quantum resilience strategy, these architectures facilitate a secure and scalable migration by integrating platform-specific adaptations that balance security, adaptability, and operational efficiency. Our analysis extends to major BC platforms, including Bitcoin, Ethereum, Ripple, Litecoin, and Zcash, providing platform-specific vulnerability assessments and highlighting unique weaknesses in the quantum era. By identifying vulnerabilities, developing proactive defense strategies, and adopting a structured hybrid migration approach, this research equips BC stakeholders with a robust framework to achieve long-term quantum resilience. Finally, we explore challenges and research directions for integrating emerging technologies, including quantum machine learning, Artificial Intelligence (AI), and Web3, with BC systems, and discuss new threats that may arise from this convergence in the QC era.
Report issue for preceding element
Index Terms:
Report issue for preceding element Quantum-Secure Blockchain, Risk Assessment, Migration Strategies, Hybrid Blockchain, Composite Approach, Non-Composite Approach, Proactive Defense, Post-Quantum Cryptography, Quantum Computing Threats.
I Introduction
Report issue for preceding element
The advent of QC represents a paradigm shift that fundamentally challenges the cryptographic foundations of BC security. Quantum algorithms exploit the computational hardness assumptions underlying contemporary cryptographic schemes—integer factorization, discrete logarithms, unstructured search, and collision resistance—thereby compromising the digital signatures, encryption protocols, and hash functions that guarantee transaction authenticity, data confidentiality, and BC immutability [ 1, 2] . Shor's algorithm [ 3] efficiently solves both integer factorization and discrete logarithm problems, rendering public-key cryptosystems such as RSA, Elliptic Curve Digital Signature Algorithm (ECDSA), and Elliptic-curve Diffie–Hellman (ECDH) vulnerable and jeopardizing transaction verification mechanisms in platforms including Bitcoin and Ethereum. While symmetric cryptography demonstrates greater resilience, Grover's quantum search algorithm [ 4] reduces effective key strength from 2 n 2^{n} to 2 n / 2 2^{n/2} operations, necessitating doubled key lengths to preserve security equivalence. Hash function security faces similar degradation through the Brassard et al. quantum collision search algorithm [ 5] , which reduces collision resistance from 𝒪  ( 2 n ) \mathcal{O}(2^{n}) to 𝒪  ( 2 n / 3 ) \mathcal{O}(2^{n/3}) , amplifying risks of block manipulation and consensus disruption. These quantum advances collectively create a systemic vulnerability across existing BC infrastructures, making the transition to post-quantum cryptographic standards not merely advisable but imperative for preserving the integrity and trustworthiness of distributed ledger ecosystems.
Report issue for preceding element
This study investigates risks associated with transitioning from non-quantum-safe to quantum-resistant cryptographic methods across BC components. It assesses vulnerabilities posed by quantum attacks on key components—networks, mining pools, transaction verification, smart contracts, and user wallets. Such vulnerabilities can compromise BC integrity and security, posing risks of unauthorized access, data manipulation, and financial loss. To counter these evolving threats during transition, organizations must adopt a holistic security approach integrating quantum-resistant cryptography with system design and continuous monitoring [ 6, 7, 8] . A hybrid migration strategy, gradually transitioning from classical to quantum-resistant cryptography, is essential to reduce transition risks [ 9, 10] . This approach is critical for ensuring robust security, as organizations may encounter challenges such as increased key sizes requiring network traffic handling adjustments, and implementation complexities throughout the transition [ 11, 12] .
Report issue for preceding element
While transitioning to quantum-resistant cryptography is essential, it does not fully address all potential threats, as BC systems remain vulnerable to sophisticated attack vectors beyond encryption weaknesses [ 13, 14] . In the post-transition stage, organizations face multifaceted challenges across system architecture, network infrastructure, and operational processes [ 15, 16] . Quantum-resistant algorithms introduce challenges such as larger key sizes, increased payloads, and higher computational overhead, resulting in latency, bandwidth strain, and fragmented network traffic. These performance bottlenecks can delay block propagation, thereby increasing fork probability and destabilizing consensus. Adversaries may exploit such instability to reorder transactions, trigger chain reorganizations, or manipulate protocol execution. Moreover, integrating quantum-resistant cryptography with existing BC infrastructure creates novel attack vectors that can compromise smart contracts and transaction workflows. Additionally, the coexistence of legacy and quantum-resistant protocols in hybrid architectures may create security gaps, while side-channel attacks could exploit hardware-level details in cryptographic operations. These risks underscore the need for continuous refinement and vigilant monitoring of BC ecosystems well beyond cryptographic upgrades.
Report issue for preceding element
This paper addresses these challenges by leveraging the STRIDE (Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, and Elevation of Privilege) framework [ 17, 18] to identify and prioritize threats. We analyze vulnerabilities before, during, and after transitioning to quantum-safe algorithms, providing insights for effective countermeasures. As quantum threats escalate, especially during transition to quantum-resistant BCs, proactive risk assessment and defense strategies become imperative. By advocating early vulnerability identification and integrating quantum-resistant solutions into system design, this study aims to safeguard BC network integrity and ensure long-term resilience in the quantum era.
Report issue for preceding element
TABLE I: List of Abbreviations
Report issue for preceding element
I-A Contributions
Report issue for preceding element
This survey offers substantial advancements in the field of BC security within the context of emerging QC technologies. The key contributions are as follows:
Report issue for preceding element
Comprehensive Risk Assessment: We evaluate BC vulnerabilities and potential hazards posed by QC, identify critical attack vectors, and assess risk severity through a structured, NIST-aligned methodology, enabling risk prioritization and supporting the design of proactive defense strategies. Report issue for preceding element
Platform-Specific Vulnerability Analysis: We perform a dual analysis of vulnerabilities in leading legacy platforms (Bitcoin, Ethereum, Ripple, Litecoin, Zcash) and examine the architectural and security properties of emerging post-quantum BC platforms, highlighting migration challenges and resilience factors not comprehensively addressed in prior surveys. Report issue for preceding element
Hybrid BC Approach for Secure Migration: We introduce innovative hybrid BC architectures designed to facilitate a seamless transition from legacy systems to quantum-resistant cryptography, balancing security, adaptability, and migration efficiency to ensure long-term BC resilience. Report issue for preceding element
Actionable Mitigation Strategies: We provide practical guidance for secure migration planning and proactive measures to strengthen BC components against emerging quantum-era risks, emphasizing the adoption of quantum-resistant solutions and robust defense mechanisms. Report issue for preceding element
These contributions collectively advance the understanding of quantum threats to BC security, offering actionable guidance for stakeholders to fortify their systems against emerging quantum-induced cyber threats.
Report issue for preceding element
I-B Related Works
Report issue for preceding element
Recent literature on BC security in the quantum era generally falls into six main categories: (1) threat modeling and vulnerability assessment [ 19, 20, 1, 21] ; (2) cryptographic migration strategies, which involve either NIST-standardized PQC [ 22, 23, 2, 24, 20] or quantum cryptography like Quantum Key Distribution (QKD) [ 25, 26, 27, 28] ; (3) platform-specific security analyses focusing on classical BCs [ 1] or post-quantum Distributed Ledger Technologies (DLTs) [ 22] ; (4) hybrid BC architectures that integrate classical systems with quantum or PQC-based layers [ 25, 26, 28] ; (5) post-migration security analysis [ 22, 25, 2] ; and (6) actionable migration guidance and transition planning [ 2, 21, 25] . While these studies offer valuable insights into specific areas, they often examine individual aspects in isolation. There's a notable absence of an integrated framework that unifies risk modeling, hybrid system design, cryptographic migration, and post-transition readiness. Our work aims to fill this gap by providing a comprehensive and systematic framework.
Report issue for preceding element
Our research distinguishes itself by offering a holistic approach to BC quantum-security. First, we provide a comprehensive risk assessment framework that systematically evaluates threats across all fundamental BC components, including consensus mechanisms, cryptographic algorithms, smart contracts, and network protocols. This approach goes beyond previous studies that focus primarily on specific vulnerabilities [ 19, 20, 1] . Second, we conduct a detailed vulnerability analysis of the major BC platforms, including Bitcoin, Ethereum, Ripple, Litecoin, and Zcash. Unlike previous works that provide general security discussions [ 1] , our analysis offers in-depth platform-specific insights, including vulnerability analysis, threat modeling, and risk assessment, enabling a deeper understanding of quantum threats and their potential impact on specific cryptographic algorithms, consensus mechanisms, and smart contract vulnerabilities. Third, we introduce novel hybrid BC architectures that leverage PQC to ensure a secure and efficient quantum-resistant future. Unlike other hybrid approaches that rely on quantum cryptography [ 28, 26, 25] , our focus on PQC, standardized by National Institute of Standards and Technology (NIST), provides a practical and sustainable solution. Our hybrid architectures combine the strengths of classical and quantum-resistant cryptographic primitives, offering a robust and flexible framework for securing BC systems [ 6, 29] . Finally, we provide actionable guidance for stakeholders, empowering them to navigate the quantum era effectively. Unlike existing works that may focus on specific environments or pre-transition stages [ 2, 20] , our research offers a comprehensive roadmap that covers all phases of the quantum transition, including risk assessment, vulnerability analysis, migration strategies, and post-migration security considerations.
Report issue for preceding element
TABLE II: Comparison of Our Survey With Prior Work on BC Security in the Quantum Era
✓= addressed; × \times = not addressed or not a primary focus; ✓ PQC= addressed post-quantum platform only; ✓ C= addressed classic platform only; ✓ QC= addressed using quantum cryptography (e.g., QKD, QPoS)
Report issue for preceding element
Report issue for preceding element
As shown in Table II, our study is distinct in offering an integrated strategy for BC security in the quantum era. It combines BC vulnerability analysis, STRIDE-based threat modeling, platform-specific evaluations, and NIST-standardized PQC integration. It further addresses post-migration security, proposes practical hybrid BC architectures, and offers actionable migration guidance for stakeholders, thereby providing a comprehensive and forward-looking strategy for quantum-resilient BC infrastructures.
Report issue for preceding element
I-C Survey Methodology and Literature Sourcing
Report issue for preceding element
We adopted a systematic methodology to ensure comprehensive and unbiased coverage of quantum-resilient BC technologies, combining structured database searches with targeted reviews of leading cryptography and AI research venues. Searches were conducted across IEEE Xplore, ACM Digital Library, SpringerLink, Scopus, and arXiv, covering publications from 2014–2025 to include both early conceptual proposals and the latest developments following NIST's post-quantum standardization. Search queries combined the term “blockchain” with terms such as “post-quantum cryptography,” “quantum-resistant,” and domain-specific keywords for consensus mechanisms, digital signatures, key exchange, and cryptographic protocols. Targeted reviews of PQCrypto, CRYPTO, EUROCRYPT, and the Journal of Cryptology captured state-of-the-art post-quantum primitives and their BC integration. AI-related research from AAAI, IJCAI, ICLR, ICML, NeurIPS, and KDD was examined for quantum-resilient machine learning models, BC-specific risk assessment frameworks, and adaptive security mechanisms. Inclusion criteria required direct relevance to quantum threats in BC systems, post-quantum ledger implementations, hybrid architectures, or AI-enhanced quantum-resistant protocols. Quality assessment considered venue prestige, citation impact, and methodological rigor. Screening was conducted independently by multiple researchers, with disagreements resolved by consensus. This process yielded 187 papers from cryptography venues (38 shortlisted, 13 retained) and 51 from AI venues (17 retained). Table III summarizes the search queries and results.
Report issue for preceding element
TABLE III: Summary of Search Phrases and Results
Report issue for preceding element
I-D Organization
Report issue for preceding element
Figure 1 presents the structure of this survey, which addresses the quantum-safe transition of BC systems across eleven sections. Section II presents a comprehensive methodology for assessing quantum-specific threats and vulnerabilities during BC system migration. Section III reviews cryptographic standards and evaluates the cyber impact of QC on classical and post-quantum algorithms. Section IV examines quantum threats to key BC components, including the network layer, mining pools, transaction verification, smart contracts, and user wallets. Section V analyzes evolving security responsibilities across the BC ecosystem and proposes strategies for quantum-safe migration. Section VI discusses challenges in mitigating QC threats and transitioning to quantum-secure BC infrastructures. Section VII introduces hybrid BC architectures for seamless migration to quantum-resistant cryptographic primitives. Section VIII evaluates the quantum-era security posture of major BC platforms, including Bitcoin, Ethereum, Ripple, Litecoin, and Zcash. Section IX surveys emerging post-quantum BCs, analyzing cryptographic foundations, security considerations, and interoperability challenges. Section X presents future research directions on QC-driven challenges, migration strategies, and systemic preparedness for BC ecosystems. Finally, Section XI summarizes the key findings, highlights proactive defense strategies, and underscores the need for sustained collaboration to secure BC systems in the quantum era.
Report issue for preceding element
Blockchain Security Risk Assessment in the Quantum Era: Migration Strategies and Proactive Defense Section I. Introduction Section II. Quantum-Safe Risk Assessment Section III. Cryptographic Standards & Quantum Risk Section IV. Quantum Impact on BC Components Section V. Roles & Responsibilities in Mitigating QC Impacts on BC Section VI. Post-Transition Challenges & Strategies Section VII. Hybrid Blockchain Approaches Section VIII. Blockchain Platform Evaluation Section IX. Post-Quantum Blockchain Landscape Section X. Future Research Directions Section XI. Conclusion XI I-A. Contributions I-B. Related Works I-C. Methodology and Literature Sourcing I-D. Organization II-A. Risk Scoping and Preparation II-B. Conducting Risk Assessment III-A. Classical Standards & Quantum Risk Assessment III-B. PQC Standards & Cyber Risk Assessment IV-A. BC Network and QC Threats IV-B. Mining Pool and QC Threats IV-C. Transaction Verification Mechanism and QC Threats IV-D. Smart Contract and QC Threats IV-E. User Wallet and QC Threats VI-A. BC Network: Challenges & Strategies VI-B. Mining Pool: Challenges & Strategies VI-C. Verification Mechanism: Challenges & Strategies VI-D. Smart Contract: Challenges & Strategies VI-E. User Wallet: Challenges & Strategies VII-A. Hybrid Strategies for Cryptographic Primitives VII-B. Architectural Design Approaches VII-C. Risk Assessment and Security Posture VII-D. Comparative Analysis and Strategic Insights VIII-A. Lessons Learned and Strategic Roadmap IX-A. Lessons Learned and Strategic Roadmap X-A. Quantum-Enhanced AI and BC Integration X-B. Quantum Security and Interoperability for Web3 X-C. Advanced Privacy-Preserving Cryptographic Systems X-D. FL, Edge Computing, and IoT Integration X-E. Cross-Cutting Technical and Standardization Report issue for preceding element
Report issue for preceding element
Figure 1: Organizational Structure of This Survey Report issue for preceding element
II Quantum-Safe Migration Risk Assessment Approach
Report issue for preceding element
This study presents a systematic framework for evaluating the security risks of BC migration to quantum-safe systems. Aligned with the four-step process defined in NIST SP 800-30 [ 30] —preparation, conduct, communication, and maintenance—the methodology incorporates STRIDE-based threat categorization to address quantum-specific vulnerabilities. Our analysis emphasizes the conduct stage, where threats, vulnerabilities, likelihood, and impact are examined to prioritize risks across BC components. Figure 2 summarizes the overall approach.
Report issue for preceding element
NIST Cybersecurity Framework Detect Anomalies and Events Security Continuous Monitoring Detection Processes Protect Identity Management and Access Control Awareness and Training Data Security Info. Protection Processes and Procedures Maintenance Protective Technology Identify Asset Management Business Environment Governance Risk Assessment Risk Management Strategy Supply Chain Risk Management Respond Response Planning Communications Analysis Mitigation Improvements Recover Recovery Planning Improvements Communications Identify Threat Sources and Events Identify Vulnerabilities and Predisposing Conditions Determine Likelihood of Occurrence Determine Magnitude of Impact Assess Risk Risk Assessment Process Phases According to NIST Likelihood { \ \left{\rule{0.0pt}{36.0pt}\right. Low Medium High
Low Medium High Low Low Medium Low Medium High Medium High High ⏞ Impact \overbrace{\ \begin{tabular}[]{p{1.5cm}p{1.5cm}p{1.5cm}}Low&Medium&High\ \hline\cr\vrule\lx@intercol\pagecolor{green!60}Low\hfil\lx@intercol\vrule\lx@intercol &\lx@intercol\pagecolor{green!60}Low\hfil\lx@intercol\vrule\lx@intercol &\lx@intercol\pagecolor{lemon!80}Medium\hfil\lx@intercol\vrule\lx@intercol \ \hline\cr\vrule\lx@intercol\pagecolor{green!60}Low\hfil\lx@intercol\vrule\lx@intercol &\lx@intercol\pagecolor{lemon!80}Medium\hfil\lx@intercol\vrule\lx@intercol &\lx@intercol\pagecolor{red!80}High\hfil\lx@intercol\vrule\lx@intercol \ \hline\cr\vrule\lx@intercol\pagecolor{lemon!80}Medium\hfil\lx@intercol\vrule\lx@intercol &\lx@intercol\pagecolor{red!80}High\hfil\lx@intercol\vrule\lx@intercol &\lx@intercol\pagecolor{red!80}High\hfil\lx@intercol\vrule\lx@intercol \ \hline\cr\end{tabular}}^{\mbox{Impact}} Risk = Likelihood × \times Impact Report issue for preceding element
(a) Report issue for preceding element
Figure 2: Quantum-Safe Migration Risk Assessment Approach Report issue for preceding element
II-A Risk Scoping and Preparation
Report issue for preceding element
Aligned with NIST guidelines [ 30] , this risk assessment framework defines the purpose, scope, assumptions, and risk model for prioritizing quantum-related threats across BC components, including network infrastructure, mining pools, transaction verification, smart contracts, and wallets. It assumes the emergence of quantum threats within the migration timeframe and the availability of PQC solutions, while recognizing current efficiency and interoperability limitations. A qualitative STRIDE-based model [ 17, 18] classifies threats from literature and industry reports, applying High/Medium/Low likelihood and impact ratings to enable systematic prioritization and targeted mitigation strategies.
Report issue for preceding element
II-B Conducting Risk Assessment
Report issue for preceding element
The risk assessment process involves five key tasks: (1) identifying potential threat sources and events; (2) identifying vulnerabilities within the system; (3) determining the likelihood of each identified vulnerability; (4) determining the impact of each vulnerability; and (5) assessing the risk level based on the evaluated likelihood and impact. Figure 2 summarizes the assessment process.
Report issue for preceding element
Task 1. Identify Threat Sources and Events: To identify potential threats, we consider quantum-specific risks such as quantum algorithm attacks (e.g., Shor's and Grover's algorithms), quantum side-channel attacks (exploiting timing or power differences), and quantum hardware attacks (malicious quantum devices). These threats can compromise BC systems at various levels, including cryptographic algorithms, consensus mechanisms, and smart contracts. By understanding these risks, we can develop effective mitigation strategies to protect BC systems in the quantum era. Report issue for preceding element
Task 2. Identify Vulnerabilities and Predisposing Conditions: We conduct a comprehensive review of BC components to identify vulnerabilities that could be exploited by quantum attacks. Key focus areas include quantum-resistant cryptographic algorithms (lattice-based, code-based, and hash-based), BC protocols (consensus mechanisms, smart contracts, and network protocols), and quantum-safe key management (key generation, distribution, and storage). Report issue for preceding element
Task 3. Determine Likelihood of Occurrence: Using a qualitative likelihood assessment approach, we evaluate the likelihood of vulnerabilities being exploited by a quantum attacker. We apply qualitative criteria—derived from NIST-SP 800-30 Appendix G [ 30] —to categorize likelihood into three levels: Low (L), Medium (M), and High (H), as detailed in Table IV. The assessment considers factors such as exploitability, attack complexity, attacker motivation, availability of countermeasures, and their effectiveness. Report issue for preceding element TABLE IV: Evaluation Criteria for Likelihood Levels Likelihood High • High likelihood of exploitation due to critical vulnerabilities or weak cryptographic protections. • Broad network exposure, making exploitation accessible to adversaries with quantum capabilities. • High probability of intent and capability from quantum threat actors. Medium • Known vulnerabilities, but partial mitigations limit ease of exploitation. • Moderate network exposure; some access restrictions, but feasible for a skilled quantum adversary. • Exploitation possible with moderate quantum resources and expertise. Low • No significant vulnerabilities for quantum exploitation; strong quantum-resistant cryptography in place. • Minimal network exposure; attacks require highly specialized access and resources. • Unlikely exploitation due to high barriers and limited feasibility. Report issue for preceding element TABLE V: Evaluation Criteria for Impact Levels Impact High • Severe compromise, including exposure of critical data or loss of cryptographic integrity. • Extensive operational downtime or significant disruptions to BC consensus mechanisms. • High financial, regulatory, and reputational risks with long-term effects. Medium • Partial compromise of data integrity or limited operational impact. • Moderate data or service disruption with manageable recovery time. • Moderate financial or reputational consequences; potential regulatory concerns. Low • Minimal operational disruption or data exposure; negligible security implications. • Temporary disruptions without lasting effects on BC integrity or user trust. • Limited financial or reputational risk. Report issue for preceding element
Task 4. Determine Magnitude of Impact: The impact levels, defined as Low (L), Medium (M), and High (H), reflect the potential severity of a quantum threat event (see Table V for evaluation criteria). These criteria, based on NIST-SP 800-30 Appendix H [ 30] , consider the possible harm to BC assets, system stability, user satisfaction, data confidentiality, and organizational reputation. Report issue for preceding element
Task 5. Assess Risk: Risk is determined by combining likelihood and impact levels, visualized in a risk matrix (see Figure 3). Risk levels—High, Medium, and Low—help prioritize vulnerabilities and guide mitigation strategies. Report issue for preceding element (a) Report issue for preceding element Likelihood { \ \left{\rule{0.0pt}{36.0pt}\right. Low Medium High Low Medium High Low Low Medium Low Medium High Medium High High ⏞ Impact \overbrace{\ \begin{tabular}[]{p{1cm}p{1cm}p{1cm}}Low&Medium&High\ \hline\cr\vrule\lx@intercol\pagecolor{green!60}Low\hfil\lx@intercol\vrule\lx@intercol &\lx@intercol\pagecolor{green!60}Low\hfil\lx@intercol\vrule\lx@intercol &\lx@intercol\pagecolor{lemon!80}Medium\hfil\lx@intercol\vrule\lx@intercol \ \hline\cr\vrule\lx@intercol\pagecolor{green!60}Low\hfil\lx@intercol\vrule\lx@intercol &\lx@intercol\pagecolor{lemon!80}Medium\hfil\lx@intercol\vrule\lx@intercol &\lx@intercol\pagecolor{red!80}High\hfil\lx@intercol\vrule\lx@intercol \ \hline\cr\vrule\lx@intercol\pagecolor{lemon!80}Medium\hfil\lx@intercol\vrule\lx@intercol &\lx@intercol\pagecolor{red!80}High\hfil\lx@intercol\vrule\lx@intercol &\lx@intercol\pagecolor{red!80}High\hfil\lx@intercol\vrule\lx@intercol \ \hline\cr\end{tabular}}^{\mbox{Impact}} Report issue for preceding element Figure 3: Qualitative Risk Assessment based on Likelihood and Impact Report issue for preceding element
III Cryptographic Standards and Quantum Computing: Cyber Impact and Risk Assessment
Report issue for preceding element
This paper presents a security framework to protect BC technology from QC threats by securing cryptographic components essential to BC integrity. Mitigating these threats requires understanding the risks QC poses to classical cryptographic algorithms—the foundation of BC security—and evaluating the readiness and vulnerabilities of NIST-standardized PQC schemes. We prioritize threats by exploitability and potential impact, considering both current vulnerabilities and the defensive capabilities of NIST-standardized PQC schemes as quantum-resistant alternatives.
Report issue for preceding element
III-A Classic Cryptographic Standards and Quantum Computing: Cyber Impact and Risk Assessment
Report issue for preceding element TABLE VI: Classic Cryptographic Standards and Quantum Computing: Cyber Impact and Risk Assessment
Crypto Type
Algorithms
Variants
Key Length (bits)
Strengths (bits)
Vulnerabilities
STRIDE threats
L
I
R
QC-Resistant Alternatives
Classic
Quantum
Asymetric
ECC [ 31, 32]
ECC 256
256
128
0
Broken by Shor's Algorithm [ 3] .
M
H
H
Algorithms presented in Table VII.
ECC 384
384
256
0
For digital signature:
• Spoofing: Shor's Algorithm allows forging of digital signatures.
• Tampering: Integrity checks can be bypassed due to signature forgery.
• Repudiation: Valid signatures can be forged, denying the origin of the message. For Key Encapsulation Mechanism/Encryption (KEM/ENC):
• Info. Disclosure: KEM/ENC algorithms can be broken, revealing encrypted data.
M
H
H
ECC 521
521
256
0
M
H
H
FFDHE [ 33]
DHE 2048
2048
112
0
M
H
H
DHE 3072
3072
128
0
M
H
H
RSA [ 34]
RSA 1024
1024
80
0
M
H
H
RSA 2048
2048
112
0
M
H
H
RSA 3072
3072
128
0
M
H
H
Symmetric
AES [ 35]
AES 128
128
128
64
Weakened by Grover's Algorithm [ 4] .
•
Info. Disclosure: Grover's algorithm reduces the effective key length, making brute-force attacks feasible.
M
M
M
Larger key sizes are needed.
AES 192
192
192
96
M
M
M
AES 256
256
256
128
M
L
L
SHA2 [ 36]
SHA 256
128
85
Weakened by Brassard et al.'s Algorithm [ 5] .
•
Spoofing: Fake hash values can be created.
• Tampering: Data integrity can be compromised by finding collisions.
M
M
M
Larger hash values are needed.
SHA 384
192
128
M
L
L
SHA 512
256
170
M
L
L
SHA3 [ 36]
SHA3 256
128
85
M
M
M
SHA3 384
192
128
M
L
L
SHA3 512
256
170
M
L
L
Report issue for preceding element
Widely used classical cryptographic algorithms, both symmetric and asymmetric, are increasingly vulnerable to QC. Quantum algorithms such as Shor's, Grover's and Brassard et al.'s algorithm [ 5] can compromise the hard problems underlying modern cryptography, threatening the security of diverse applications and communications. This section analyzes the vulnerabilities of existing cryptographic systems to motivate the need for quantum-resistant alternatives.
Report issue for preceding element
A.1. Risk Assessment: Understanding the risks posed by QC to classical cryptosystems requires anticipating the emergence of large-scale quantum computers and their cryptanalytic impact. This study examines the projected 5–30 year timeline for such systems and evaluates the cumulative likelihood of significant quantum threats to classical cryptosystems over this period. Figure 4 synthesizes expert assessments of the “quantum threat” timeline [ 37] , defined as the capability to break RSA-2048 encryption within 24 hours using a quantum computer. These assessments can be extended to evaluate the likelihood of breaking other cryptographic algorithms based on their quantum security level. A comprehensive risk assessment therefore requires evaluating each algorithm's “quantum strength” relative to the RSA-2048 benchmark, considering susceptibility to Shor's, Grover's, and Brassard et al.'s algorithms. Report issue for preceding element Figure 4: Cumulative Expert Opinions Related to Quantum Threat to Classic Cryptography Report issue for preceding element
A.1.1. Expected Likelihood of Quantum Threat: To assess the expected likelihood of a quantum threat to classical cryptosystems over time horizons of 5, 10, 15, 20, and 30 years, we analyze aggregated expert predictions from Figure 4. For each period j j , the expected likelihood is computed as: Report issue for preceding element E period j  [ likelihood ] = ∑ ω i ⊆ [ 0 , 1 ] likelihood period j  ( ω i ) × Pr period j  ( ω i ) , E_{\text{period}{j}}[\text{likelihood}]=\hskip-5.69046pt\sum{\omega_{i}\subseteq[0,1]}\hskip-5.69046pt\text{likelihood}{\text{period}{j}}(\omega_{i})\times\text{Pr}{\text{period}{j}}(\omega_{i}), where ω i \omega_{i} denotes a subset of the likelihood range [ 0 , 1 ] [0,1] , and Pr period j  ( ω i ) \text{Pr}{\text{period}{j}}(\omega_{i}) is the proportion of expert opinions assigning that likelihood to period j j . For qualitative risk assessment, the computed likelihoods are classified into three categories: Low, Medium, and High. As depicted in Figure 5, the results show a low threat within 10 years, medium within 15 years, and high beyond 20 years. Report issue for preceding element Figure 5: Expected Likelihood of Quantum Threat for Classic Cryptography Within 30 Years Report issue for preceding element
A.1.2. Quantum Impact Assessment: To assess the impact of quantum threats on classical cryptographic algorithms, we evaluate their quantum security strength, which measures resilience against quantum attacks [ 38, 39] . This metric is critical for identifying vulnerabilities and prioritizing mitigation efforts. The impact is classified as High if quantum strength is < 64 <64 bits, Low if ≥ 128 \geq 128 bits, and Medium for values in between, as shown in Figure 6. Report issue for preceding element Figure 6: Expected Impact of Quantum Threat for Classic Cryptography Report issue for preceding element
A.1.3. Evaluating Risk: The overall Risk (R) of a cryptographic algorithm combines exploitation Likelihood (L) and potential Impact (I) as illustrated in the risk matrix (see Figure 3), providing a systematic framework for evaluating current security posture and directing quantum-resistant migration strategies. Table VI provides detailed analysis of pre-migration classical algorithms, including their classical and quantum security strengths, vulnerabilities, quantum threats, associated risks, and potential quantum-resistant alternatives. Our analysis assumes a 15-year timeline with Medium quantum threat likelihood (see Figure 5), though this parameter can be adjusted for other periods. Report issue for preceding element
III-B Selected Quantum-Resistant Cryptographic Standards: Cyber Impact and Risk Assessment
Report issue for preceding element TABLE VII: NIST-Standardized Quantum-Resistant Cryptographic Algorithms: Cyber Impact and Risk Assessment
Algorithms
Description
FIPS Compliance
Attacks
Possible Countermeasures
STRIDE Threats
L
I
R
Kyber [ 40]
Key encapsulation mechanism based on the Module Learning with Errors (M-LWE) problem, in conjunction with cyclotomic rings
Pending FIPS certification (FIPS 203 [ 41] )
Fault Attacks [ 42, 43, 44]
•
Masking decryption process by splitting secret key [ 43, 44] ,
• Checking the secret and error components of the LWE instances for known trivial weaknesses [ 42] .
•
Info. Disclosure (by recovery of message and key [ 42, 43, 44] ).
M
M
M
Simple Power Analysis [ 45]
•
Masking of input [ 45] ,
• Randomizing the order of executed operations within an NTT computation or by inserting random dummy operations inside the NTT [ 45] .
•
Info. Disclosure (by recovery of key [ 45] ).
M
M
M
Advanced Power Analysis [ 46, 47, 48]
•
Masking the Number Theoretic Transform (NTT), which is an integral part of efficient implementations of many lattice-based schemes [ 46] .
• No countermeasures for the attack mentioned in [ 48] .
•
Info. Disclosure (recovery of the transmitted symmetric key [ 46] ).
H
M
H
Electromagnetic Attacks [ 49, 50, 44]
•
Masking the ECC procedures, including masking the decryption/decapsulation operations [ 49, 43] , masking to protect the FO transform operations in the CCA setting [ 49] , masking to protect the secret key [ 50] .
• Discarding ciphertexts with a special structure or low entropy [ 50] .
• Splitting the secret into random shares and thereafter randomizing the entire decryption or decapsulation [ 50] .
•
Info. Disclosure (by full key extraction [ 50, 49] or by disclosing bits of the secret message [ 44] ).
L
M
L
Template Attacks [ 51]
•
No countermeasures for the attack mentioned in [ 51] .
•
Info. Disclosure (by message recovery [ 51] ).
M
M
M
Cold-Boot Attacks [ 52]
•
Storing the secret in the time domain instead of the frequency domain [ 52] .
•
Info. Disclosure (recovery of the secret key [ 52] ).
L
M
L
Dilithium [ 53]
Lattice-based digital signature scheme that uses Lyubashevsky's Fiat-Shamir with Aborts technique and rejection sampling to ensure compactness and relies on the hardness of module lattice problems
Pending FIPS certification (FIPS 204 [ 54] )
Fault Attacks [ 42, 55]
•
Checking the secret and error components of the LWE instances for known trivial weaknesses [ 42] .
• Generic countermeasures including Double computation, Verification-after-sign, and Additional randomness [ 55] .
•
Spoofing and Tampering (by recovery of key [ 42, 55] ),
• Tampering and Repudiation (by forging a signature on any given message [ 55] ),
• Elevation of Privilege (by elevating the privileges and gaining access to restricted systems or data via forged signatures [ 55] ).
M
M
M
Advanced Power Analysis [ 56, 57]
•
Masking using linear secret sharing scheme [ 56] ,
• Boolean and arithmetic masking by leveraging splitting and sharing sensitive variable [ 57] .
•
Spoofing, Tampering, and Repudiation (by forging signature [ 57] ),
• Elevation of Privilege (by elevating the privileges and gaining access to restricted systems or data via forged signature [ 57] ).
• Spoofing, Tampering, Repudiation and Elevation of Privilege (by disclosing secret variables [ 56] ).
M
M
M
Electromagnetic Attacks [ 58, 59]
•
Re-ordering of operations within the signing procedure and embedding the vulnerable addition operation deep enough inside the signing procedure [ 58] ,
• Bit-slicing design for NTT, the most critical sub-block, to provide a spatial intra-instruction redundancy [ 59] .
•
Spoofing, and Tampering (by disclosing some info. about secret key [ 59] ),
• Tampering, Repudiation and Elevation of Privilege (by forging a signature on any given message [ 58] ).
L
M
L
Template Attacks [ 60, 61]
•
Shuffling and Secret sharing [ 61, 60] .
•
Spoofing and Tampering (by revealing information on the signer's secret key [ 61, 60] ).
• Repudiation and Elevation of Privilege (by forging signature via revealed signer's secret key [ 61, 60] ).
M
M
M
SPHINCS+ [ 62]
Stateless hash-based signature scheme relying on the hardness of finding collisions in hash functions
Pending FIPS certification (FIPS 205 [ 63] )
Fault Attacks [ 64, 65]
•
Making the signature computation redundant [ 64] ,
• Computing the index of the few-time signatures (FTS) from public values instead of secret ones [ 64] ,
• Linking the different layers of the hyper-tree to detect faults in the computation of the tree, which results in a non-valid signature [ 64] ,
• Detecting faults by recomputing of sub-trees with swapped nodes, as well as an enhanced hash function that inherently protects against faults [ 65] ,
• Computing and storing one-time signatures to reuse the results whenever needed [ 65] ,
• Recomputing the vulnerable instructions on different hardware modules to detect mismatches [ 65] .
•
Spoofing and Tampering (by recovering parts of the secret key [ 64] or universal signature forgery [ 65] ),
• Tampering and Repudiation (by forging any message signature [ 64] or by creating a universal forgery with a voltage glitch injection on the targeted platform and collecting faulty signatures to create [ 65] ).
M
M
M
Advanced Power Analysis [ 66]
•
Hiding the order of the Mix procedures [ 66] .
•
Spoofing and Tampering (by recovering secret key [ 66] ),
• Tampering, Repudiation and Elevation of Privilege (by generating signature on arbitrary messages [ 66] ).
M
M
M
Falcon [ 67]
Lattice-based digital signature algorithm based on the hardness of the shortest vector problem in structured NTRU lattices
Pending FIPS certification
Fault Attacks [ 68]
•
Double computation of signature [ 68] ,
• Immediate verification after signing [ 68] ,
• Zero checking of the sampled vector [ 68] .
•
Spoofing and Tampering (by retrieving the private-key [ 68] ),
• Repudiation and Elevation of Privilege (by forging signature via retrieved private key [ 68] ).
M
M
M
Timing Attacks [ 68]
•
Blind-Vector algorithm extended the use of the Fisher-Yates shuffling procedure to enhance random shuffles for side-channel protection [ 68] ,
• Sample discard performing extra cache read from random addresses to distort statistics [ 68] .
•
Spoofing and Tampering (by retrieving the private-key [ 68] ),
• Repudiation and Elevation of Privilege (by forging signature via retrieved private key [ 68] ).
M
M
M
Simple Power Analysis [ 69]
•
Practically lower the Hamming weight gap [ 69] .
•
Spoofing, Tampering, Repudiation and Elevation of Privilege (by complete recovery of the secret keys [ 69] ).
M
M
M
Electromagnetic Attacks [ 70]
•
Hiding by making power consumption constant, [ 70] ),
• Masking using randomizing the intermediates values [ 70] ).
•
Spoofing and Tampering (by extracting the secret signing keys [ 70] ),
• Tampering, Repudiation and Elevation of Privilege(by forging signatures on arbitrary messages [ 70] ).
L
M
L
HQC [ 71]
Code-based KEM/ENC relying on the hardness of decoding random linear codes in the Hamming metric.
Pending FIPS certification (FIPS 207) [ 72]
Fault Attacks [ 73, 74]
•
Constant-time error handling to avoid secret overwrites [ 74] ,
• Instruction duplication and random delays to disrupt fault injection [ 74] .
• No known countermeasures reported in [ 73] .
•
Info. Disclosure: via message recovery and key leakage [ 73, 74] .
M
M
M
Timing Attacks [ 75, 76, 77]
•
Constant-time decoding, field operations, and RNG [ 77, 76] .
• No mitigation suggested in [ 75] .
•
Info. Disclosure: via key recovery through timing side-channels [ 75, 76] .
M
M
M
Simple Power Analysis [ 78]
•
No effective mitigation reported [ 78] .
•
Info. Disclosure: via partial key recovery from Hamming weight leakage [ 78] .
H
M
H
Electromagnetic Attacks [ 79, 80]
•
Linear secret sharing to mask sensitive values [ 79] .
• No effective mitigation for the attack mentioned in [ 80] .
•
Info. Disclosure: via full key recovery from EM leakage [ 79, 80] .
M
M
M ∗
We perform risk evaluation with the presumption of considering the countermeasures mentioned in the table.
Report issue for preceding element
Report issue for preceding element
The threat of QC necessitates a transition to Post-Quantum Cryptography (PQC). NIST has led a standardization effort and PQC algorithms are designed to safeguard public-key cryptography (key encapsulation/encryption and digital signatures) against quantum attacks. Several promising PQC categories have emerged, including lattice-based [ 40, 53, 67] , code-based [ 71] , and hash-based [ 62] approaches. However, ongoing research remains vital to ensure their long-term security. NIST announced the first four PQC candidates for standardization in 2022, along with candidates for a fourth round of analysis [ 81] . Additionally, NIST has solicited comments on the initial public drafts of three Federal Information Processing Standards: FIPS 203 [ 41] , FIPS 204 [ 54] , and FIPS 205 [ 63] . These drafts outline quantum-resistant key establishment and digital signature schemes to safeguard against future quantum attacks [ 82] . NIST further solidified its commitment to PQC by selecting HQC in 2025, a code-based KEM/ENC, for standardization, with a draft FIPS expected in 2026 [ 72] .
Report issue for preceding element
B.1. Security Evaluation and Vulnerability Analysis: Recent discoveries of side-channel vulnerabilities in NIST-standardized PQC algorithms underscore the importance of sustained and systematic security evaluation (see Figure 7). This subsection reviews identified attack vectors, corresponding mitigation strategies, and associated risk profiles. Quantum-capable adversaries may exploit information leakage from cryptographic implementations—arising from power consumption, electromagnetic emanations, or timing variations—to recover secret keys or forge digital signatures. Table VII systematically analyzes known vulnerabilities across PQC algorithms, detailing attack vectors, countermeasures, STRIDE threat classifications, and corresponding risk assessments. This structured analysis contributes to ongoing NIST standardization efforts and informs the design of resilient countermeasures for post-quantum deployment. Report issue for preceding element Side-channel Attacks Active Attacks Fault Attacks Passive Attacks Electromagnetic Attacks Template Attacks Cold-Boot Attacks Advanced Power Analysis Attacks Simple Power Analysis Attacks Timing Attacks Report issue for preceding element Figure 7: Taxonomy of Attacks for NIST-Standardized Quantum-Resistant Cryptographic Algorithms Report issue for preceding element
B.2. Risk Assessment: To assess security risks associated with PQC algorithms, we evaluate likelihood using the criteria in Table IV, derived from NIST-SP 800-30 Appendix G [ 30] . Key factors include exploitability, attack complexity, attacker motivation, and the effectiveness of countermeasures (see Table VII). Likelihood is categorized into three levels: (a) High, referring to remotely exploitable vulnerabilities without effective countermeasures, or vulnerabilities requiring minimal attacker sophistication or resources; (b) Medium, referring to vulnerabilities that require physical access or specific conditions, or that lack robust countermeasures when exploited remotely, often involving moderate attack complexity or skill level; and (c) Low, referring to scenarios with no known vulnerabilities, or only highly complex attacks requiring administrative or physical privileges, mitigated by effective countermeasures and limited attacker motivation. Report issue for preceding element The impact assessment, grounded in NIST-SP 800-30 Appendix H [ 30] , evaluates the consequences of quantum attacks on user satisfaction, data confidentiality, and organizational reputation. According to the criteria in Table V, PQC attacks have a Medium impact. This assessment indicates that such attacks could lead to partial data compromise, limited operational disruption, and manageable recovery times, with moderate financial and reputational consequences. Risk evaluation combines likelihood and impact using the risk matrix (see Figure 3). Table VII provides algorithm-specific insights essential for developing robust PQC transition strategies to mitigate quantum threats and strengthen cybersecurity resilience. Report issue for preceding element
IV Quantum Impact on BC Technology Components
Report issue for preceding element
Quantum attacks pose a significant threat to various components of BC technology, including (a) BC network, (b) mining pools, (c) transaction verification mechanisms, (d) smart contracts, and (e) user wallets. These attacks can compromise the trust and immutability that BC technology aims to provide. Understanding these vulnerabilities and implementing effective mitigation strategies is crucial for safeguarding the integrity and security of BC ecosystems. This section will delve deeper into each of these components and explore potential solutions to safeguard their integrity and security in the quantum age.
Report issue for preceding element
IV-A BC Network and Quantum Computing Threats
Report issue for preceding element
QC poses a significant threat to BC networks by potentially exploiting weaknesses in core functionalities. Here is a breakdown of some key vulnerabilities along with mitigation strategies.
Report issue for preceding element
A.1. Cryptographic Hashing Vulnerabilities: BC networks rely heavily on cryptographic hashing functions to ensure data integrity and immutability. However, advancements in QC present a potential challenge to the security of widely used hash functions like SHA-256. As highlighted in Table VI, these vulnerabilities can weaken the security strength of hash functions and introduce risks such as transaction forgery or alteration of ledger history [ 1, 83] . Report issue for preceding element Effective mitigation strategies to address these vulnerabilities include: (i) promoting the standardization of quantum-resistant hash functions that meet BC-specific security requirements, as emphasized in NIST's PQC transition guidelines [ 11] ; (ii) increasing hash output length, which raises the quantum resource threshold for collision and preimage attacks under Grover's algorithm; and (iii) implementing migration plans that facilitate a seamless transition to quantum-resistant alternatives with minimal network disruption [ 18, 84] . Report issue for preceding element
A.2. False Message Attacks: Quantum algorithms can compromise the security of digital signatures and hash functions, enabling attackers to forge signatures or manipulate data within the network. This could allow the injection of false information or the spread of misinformation, undermining the integrity of the BC system [ 18, 85] . Additionally, quantum computational power, including quantum parallelism and exponential speedup (via algorithms like Shor's and Grover's), could facilitate Sybil attacks, where attackers deploy numerous fake nodes to manipulate identities or votes. This threat is particularly concerning for BCs utilizing Proof of Work (PoW) consensus mechanisms, where quantum acceleration could make it easier to create and manage fake nodes, potentially disrupting network operations [ 1] . However, the risks are not exclusive to PoW-based systems, as QC could also affect cryptographic vulnerabilities in Proof of Stake (PoS) or Byzantine Fault Tolerance (BFT) systems, potentially undermining consensus or enabling false message injection by compromising digital signatures or private keys. Report issue for preceding element Effective mitigation strategies for these quantum threats include: (i) deploying PQC algorithms, such as the NIST-Standardized PQC approaches outlined in Table VII, to secure digital signatures and other cryptographic primitives [ 86, 72] ; (ii) developing and enhancing reputation-based filtering systems that help nodes identify and filter messages from unreliable sources, with adaptations to address quantum-specific vulnerabilities and ensure post-quantum resilience [ 87] ; and (iii) designing quantum-aware incentive mechanisms that reward nodes for verifying information validity and penalize those spreading false data, adapting current effective systems to account for QC vulnerabilities and ensure future effectiveness [ 88] . Report issue for preceding element
A.3. 51% Attacks: A significant concern for PoW-based BCs is the possibility of a 51% attack. In this scenario, a malicious actor or group could control more than half of the network's mining hash rate, allowing them to manipulate transaction confirmations, potentially double-spend cryptocurrency, and ultimately compromise the network's integrity. While achieving a 51% attack with traditional computers is already computationally expensive, quantum computers could significantly reduce the resources needed, making it a more realistic threat for some BCs [ 89, 90] . Report issue for preceding element Mitigation strategies to proactively defend against 51% attacks on BC networks include: (i) transitioning to alternative consensus mechanisms, such as PoS, which rely on coin ownership for validation rather than raw computational power and are less susceptible to 51% attacks [ 91] ; quantum-resistant consensus mechanisms beyond those discussed above include QRL's PoS (QPoS) [ 92] and quantum PoW (QPoW) [ 93] algorithms; (ii) implementing enhanced difficulty adjustment algorithms that dynamically adjust mining difficulty based on network hash rate to make it more expensive for attackers to acquire a controlling stake, thereby enhancing the network's resilience against 51% attacks [ 94] ; and (iii) employing merged mining, which may strengthen smaller BCs by sharing computational resources with larger networks. However, this introduces additional complexities: if a malicious actor gains control over a significant portion of the hash rate in a merged mining setup, they could potentially launch 51% attacks on multiple BCs simultaneously. Careful consideration is therefore required to manage these risks and ensure that the security of all participating networks is maintained [ 95] . Report issue for preceding element TABLE VIII: Analysis of BC Network Component: Quantum Threats, Vulnerabilities, Mitigations, and Risk Assessment
A.4. DoS Attacks: QC significantly amplifies the threat of DoS attacks on BC networks. By leveraging their immense computational power, quantum attackers could overwhelm nodes or critical network infrastructure with a deluge of traffic, disrupting transaction processing, delaying block confirmations, and potentially centralizing control. Quantum-accelerated attacks can exploit network vulnerabilities more efficiently, leading to more severe and prolonged disruptions. Report issue for preceding element Mitigation strategies for quantum-enhanced DoS attacks on BC networks include: (i) implementing resource reservation and rate-limiting mechanisms to prevent malicious actors from monopolizing bandwidth or computational resources [ 96] ; (ii) maintaining a distributed network architecture to reduce the impact of localized failures and prevent cascading disruptions [ 97] ; (iii) designing systems with redundancy and fault-tolerant components to ensure operational continuity during DoS events [ 98, 99] ; (iv) deploying network optimization techniques (e.g., traffic filtering, data compression, congestion control, and sharding) to reduce processing bottlenecks and enhance resilience [ 100] ; and (v) transitioning to quantum-resistant cryptographic protocols and consensus mechanisms to mitigate vulnerabilities that quantum attackers may exploit in classical systems [ 86] . Report issue for preceding element
A.5. Data Privacy and Obfuscation Vulnerabilities: The transparency and anonymity inherent in BC transactions can be compromised by quantum attacks. Quantum computers could potentially intercept and manipulate transaction data, exposing sensitive information such as transaction amounts and participant identities. Additionally, quantum attacks could compromise the pseudonymity of BC addresses, linking them to real-world identities and undermining privacy [ 101] . Report issue for preceding element Privacy-centric BCs like Monero and Zcash employ advanced cryptographic protocols such as Bulletproofs and zk-SNARKs to protect transaction details. However, both of these protocols rely on ECC, which is vulnerable to Shor's algorithm. Additionally, the cryptographic hash functions used in these BCs (such as Keccak in Monero and BLAKE2b in Zcash) could be affected by Grover's algorithm, potentially reducing their security strength. These quantum threats could expose sensitive transaction metadata, including amounts and participant identities [ 1, 102, 103] . To mitigate the risk of data privacy and obfuscation vulnerabilities, several strategies can be adopted: (i) implementing quantum-resistant cryptographic algorithms to secure transaction data [ 86, 72] ; (ii) adopting post-quantum zero-knowledge proof systems (e.g., lattice-based ZKPs) to enable private verification without revealing transaction contents [ 104] ; (iii) combining ring signatures (which obfuscate transaction initiators) with quantum-resistant ZKPs such as zk-STARKs (which validate amounts without revealing details) to enhance sender anonymity [ 105] ; (iv) transitioning privacy-focused BCs like Monero and Zcash to quantum-resistant obfuscation protocols based on lattice cryptography and Dilithium [ 102, 106] ; and (v) using off-chain decentralized storage for non-critical metadata while ensuring robust security evaluation to avoid introducing new vulnerabilities [ 107] . Report issue for preceding element
A.6. Risk Assessment for Quantum Threat to BC Network Component: To assess the risks posed by QC to BC network components, we evaluate both the likelihood of exploitation and the potential impact using the qualitative criteria in Tables IV and V. Likelihood reflects both the probability of occurrence and the feasibility of an attack, determined by QC availability 1 1 1 Likelihood evaluations across all BC components assume the availability of large-scale quantum computers capable of breaking current cryptographic primitives. Projected QC timelines may shift these assessments (see Figure 5)., the nature of the vulnerability, the existence of effective mitigation strategies, and the resources required for exploitation. Based on these factors, likelihood is classified as High, Medium, or Low: Report issue for preceding element
(a) High: DoS attacks are highly likely because they rely on computational power to overwhelm network resources rather than cryptographic weaknesses. These attacks could exploit quantum parallelism to amplify their scale, leading to network destabilization and significant disruption of operations. Similarly, false message attacks pose a high risk, as quantum systems can break digital signature schemes (e.g., ECDSA) using Shor's algorithm. This enables attackers to forge signatures, inject false messages, and compromise consensus. Furthermore, data privacy and obfuscation vulnerabilities are also highly likely, given that quantum computers could exploit weaknesses in zk-SNARKs or elliptic curve cryptography to expose sensitive transaction data. Report issue for preceding element
(b) Medium: 51% attacks present a medium likelihood due to the potential of quantum acceleration to reduce the computational resources required to control the majority of network hash power. While such an attack would still demand substantial quantum hardware, ongoing developments elevate the feasibility of this threat. Achieving quantum dominance sufficient to compromise PoW consensus mechanisms remains a concern as quantum technologies progress. Report issue for preceding element
(c) Low: Cryptographic hashing vulnerabilities remain unlikely in the near term. Breaking robust hash functions like SHA-256 using Grover's algorithm provides only a quadratic speedup, which is insufficient to pose a significant threat to adequately designed systems with sufficiently long hash outputs. Additionally, the requirement for large-scale, fault-tolerant quantum computers to execute such attacks remains speculative, keeping this threat at a low likelihood. Report issue for preceding element Impact captures the severity of a successful attack, including privacy loss, service disruption, data manipulation, financial damage, and erosion of user trust. Given the critical nature of the BC network component, all vulnerabilities in this component are categorized as High impact due to their potential to cause significant and potentially irreversible consequences to network operations, user trust, and financial integrity. Overall risk combines likelihood and impact using the risk matrix in Figure 3. Table VIII details vulnerabilities, likelihood, impact, and mitigation strategies for addressing quantum-era threats. Adopting these strategies enables the BC network component to enhance resilience against cryptographic weaknesses, network disruptions, and privacy compromises, safeguarding transaction security and integrity in the post-quantum era. Report issue for preceding element
IV-B Mining Pool and Quantum Computing Threats
Report issue for preceding element
Mining pools are pivotal in upholding the security of PoW BCs by dedicating computational resources to solve cryptographic puzzles and validate transactions. However, QC introduces unique threats to mining pools, potentially undermining the decentralized nature of these networks. Here is a breakdown of some key concerns:
Report issue for preceding element
B.1. Disruption of Consensus Mechanisms via Malicious Nodes: QC introduces significant risks to mining pools by enhancing attackers' ability to infiltrate with malicious nodes masquerading as legitimate participants. These attacks disrupt the consensus process through methods such as Pool Flooding and Selfish Mining. In pool flooding, attackers leverage QC 's immense computational power and parallelism to overwhelm the pool's infrastructure. By rapidly generating and injecting a large number of malicious nodes (Sybil nodes), attackers hinder transaction processing and disrupt consensus procedures [ 108] . In selfish mining, using quantum-enhanced computational efficiency, attackers exploit vulnerabilities in reward distribution algorithms. They strategically withhold computational power or selectively participate in block validation to maximize personal rewards, disrupting fair reward distribution and reducing pool security [ 109, 110] . These disruptions can result in delayed block confirmations, inconsistent transactions, or even forks in the BC [ 1, 110] . Report issue for preceding element QC amplifies the scale and efficiency of these attacks, necessitating tailored mitigation strategies: (i) adopting voting-based consensus protocols (e.g., BFT) that tolerate a threshold of Byzantine nodes without compromising network integrity, ensuring consensus even under large-scale quantum-facilitated attacks [ 111, 112] ; (ii) enforcing stake-based admission policies requiring participants to deposit cryptocurrency, thereby increasing the economic cost of Sybil attacks even for quantum-enabled adversaries [ 113] ; and (iii) deploying decentralized reputation systems that detect and exclude nodes exhibiting suspicious behavior, limiting the influence of malicious quantum-generated participants [ 114] . Report issue for preceding element
B.2. Disruption of Consensus Mechanisms via Reward Distribution Manipulation: By leveraging QC's computational power, attackers can manipulate reward distribution mechanisms to gain an unfair advantage in receiving block rewards. Quantum-enhanced optimization and parallel processing enable them to exploit vulnerabilities in deterministic reward algorithms more efficiently, centralizing mining power and compromising network security [ 115, 1] . Report issue for preceding element To protect mining pools from consensus disruptions caused by reward distribution manipulation, several mitigation strategies can be employed: (i) implementing transparent, verifiable, and publicly auditable reward distribution mechanisms to deter manipulation attempts [ 116, 117] ; (ii) employing Verifiable Random Functions (VRFs) to introduce cryptographic randomness in block selection and reward assignment, preventing outcome prediction and adversarial manipulation [ 118] ; and (iii) promoting mining pool diversification to reduce the risk of centralization and limit the impact of a single compromised pool [ 119] . Report issue for preceding element
B.3. Disruption of Consensus Mechanisms via PoW: QC poses significant threats to PoW systems by exploiting vulnerabilities in public-key cryptography and hashing functions, which are critical to maintaining BC integrity and trust. While classical PoW systems use public-key cryptography to secure communications and validate transactions, quantum attackers, leveraging Shor's algorithm, could potentially forge digital signatures, manipulate transactions, perform double-spending, disrupt consensus, and launch Sybil attacks. Although current systems remain secure today, future quantum advancements threaten to compromise these foundational cryptographic protocols. In addition to cryptographic signatures, PoW relies on hashing functions like SHA 256 to secure mining operations. Quantum computers, using Grover's algorithm, could significantly reduce the computational effort required to solve these cryptographic puzzles, enabling attackers to generate blocks faster than legitimate miners. While this does not directly affect digital signatures, it exposes mining pools that rely on outdated hashing algorithms to quantum-enabled disruptions, jeopardizing the fairness and security of the BC [ 110, 89] . Report issue for preceding element Mitigation strategies to proactively defend against disruption of consensus mechanisms via PoW include: (i) adopting essential PQC algorithms to secure digital signatures and transaction data from quantum manipulation. These algorithms align with NIST's ongoing post-quantum standardization efforts [ 86, 72] ; (ii) exploring hybrid consensus models that combine PoW with PoS. Since PoS relies on coin ownership for validation, it is less vulnerable to manipulation based on computational power. This makes it more resilient to quantum-enabled attacks targeting PoW systems [ 120] ; and (iii) deploying quantum-safe communication protocols throughout the broader BC ecosystem. This includes securing wallets, exchanges, and supporting infrastructure. Although not part of the mining process, these components are also exposed to quantum risks such as eavesdropping and message tampering [ 121, 2] . Report issue for preceding element TABLE IX: Analysis of Mining Pool Component: Quantum Threats, Vulnerabilities, Mitigations, and Risk Assessment
B.4. Risk Assessment for Quantum Threats to Mining Pool Component: QC advancements pose significant risks to mining pools, potentially impacting both BC users and overall network stability. These risks are evaluated based on their likelihood and impact, following the criteria outlined in Tables IV and V. Here is the categorization of the likelihood of QC threats to mining pools: Report issue for preceding element
(a) High: Disruption of consensus mechanisms due to malicious nodes and reward distribution manipulation is highly probable with the emergence of QC. Quantum computers, leveraging their immense computational power, can facilitate Sybil attacks by rapidly generating numerous malicious nodes or exploiting selfish mining tactics. These actions disrupt consensus, delay block confirmations, and threaten mining pool stability. Additionally, quantum algorithms enable efficient exploitation of deterministic reward systems, centralizing mining power and undermining fair reward distribution. These vulnerabilities underscore the critical need for mitigation strategies such as BFT protocols, stake-based admission, VRFs, and pool diversification to ensure mining pool security. Report issue for preceding element
(b) Medium: The disruption of consensus mechanisms via PoW is moderately likely. QC using Grover's algorithm can accelerate the solving of cryptographic puzzles, enabling attackers to potentially generate blocks faster than legitimate miners. However, the high computational resources currently required for such attacks limit their immediate feasibility. As quantum technology progresses, this risk could increase, emphasizing the need to adopt hybrid consensus models or transition to alternative mechanisms such as PoS to reduce long-term vulnerability. Report issue for preceding element As with the BC network component, successful attacks on mining pools would have a High impact, causing disruptions like loss of network integrity, DoS attacks, double-spending vulnerabilities, reduced miner participation, and centralization of mining power. These issues can significantly harm the security and stability of the entire network. Overall risk combines likelihood and impact via the risk matrix presented in Figure 3. Table IX details vulnerabilities, likelihood, impact, and mitigation strategies for addressing quantum-era threats. Implementing these strategies enables the mining pool component to strengthen resilience against malicious node infiltration, reward manipulation, and PoW weaknesses, safeguarding BC network security and stability. Report issue for preceding element
IV-C Transaction Verification Mechanism and Quantum Computing Threats
Report issue for preceding element
The process of verifying transactions on a BC ensures the integrity of the network and prevents fraudulent activities. However, QC poses a significant threat to these verification mechanisms, which can lead to manipulated transactions and compromised network security. Here is a detailed breakdown of potential vulnerabilities:
Report issue for preceding element
C.1. Double-Spending Vulnerabilities: QC threatens BC security by accelerating attacks such as double-spending. Grover's algorithm [ 4] can expedite the search for valid transaction signatures, enabling attackers to manipulate the BC and fraudulently spend the same digital currency multiple times [ 1] . Consequently, existing double-spending attacks, such as race conditions (exploiting the confirmation time gap for multiple transactions [ 122] ) and Finney attacks (pre-mining a conflicting transaction [ 123] ), could become more efficient in the future. Report issue for preceding element Mitigation strategies to proactively defend against double-spending vulnerabilities include: (i) transitioning to NIST-recommended quantum-resistant signature schemes to replace current digital signatures vulnerable to quantum attacks [ 124] ; (ii) adopting enhanced consensus mechanisms like PoS or BFT, which rely on economic incentives or fault tolerance rather than on computational power that is vulnerable to quantum-accelerated hash computations [ 125] ; (iii) employing sharding and Directed Acyclic Graphs (DAGs) to reduce transaction confirmation times, limiting the attack window for quantum-accelerated double-spending [ 126, 127] ; (iv) integrating Verifiable Delay Functions (VDFs) to enforce provable delays in transaction processing, extending validation time and limiting rapid quantum attack effectiveness [ 128] ; and (v) deploying quantum-resistant sidechains for high-value transactions, confining critical operations to quantum-secure environments while maintaining main chain interoperability [ 2, 129] . Report issue for preceding element
C.2. Transaction Malleability: The potential to exploit transaction malleability is one of the significant threats posed by QC to the security of BC. This vulnerability allows attackers to manipulate weaknesses in transaction formatting to alter specific details (e.g., transaction fees or recipient addresses) without invalidating the signature [ 130, 131] . By accelerating the identification of cryptographic vulnerabilities, quantum computers could enable attackers to modify transaction details, potentially leading to double-spending, altered transaction amounts, or other fraudulent activities [ 132] . Report issue for preceding element To address transaction malleability in the quantum era, the following mitigation strategies are recommended: (i) transitioning to quantum-resistant digital signature schemes to reduce the exploitability of malleability flaws under quantum attacks [ 86, 72] ; (ii) enforcing strict transaction formatting rules to eliminate inconsistencies and reduce the risk of field manipulation [ 130] ; (iii) adopting standardized canonical transaction format protocols to ensure consistency across all nodes, preventing exploitability due to format variability [ 131] ; and (iv) deploying protocol upgrades such as Segregated Witness (SegWit), which separate signature data from the transaction ID calculation. By decoupling these elements, SegWit directly addresses transaction malleability and enhances the overall robustness of legacy BC systems [ 133] . Report issue for preceding element
C.3. Transaction Reordering Attacks: Transaction reordering attacks pose a significant threat to the security and integrity of BC networks, especially those reliant on precise transaction order, such as Decentralized Finance (DeFi) protocols or auction-based systems. QC, with its exponential computational power, can exacerbate these threats by breaking cryptographic primitives (e.g., RSA, ECC) and accelerating the identification of vulnerabilities in consensus mechanisms. By exploiting compromised digital signatures or manipulating consensus processes, quantum attackers could reorder transactions within blocks, leading to malicious activities such as double-spending, front-running, and smart contract manipulation [ 14] . Report issue for preceding element To mitigate these threats, BC systems must adopt a layered and quantum-resistant approach that addresses both the computational and structural aspects of transaction reordering: (i) introducing cryptographically secured sequence numbers or timestamps to enforce tamper-proof transaction order and preserve consistency [ 134] ; (ii) embedding unspendable inputs to prevent the reuse of transaction outputs, thereby obstructing attempts to manipulate transaction flow or perform order-dependent double-spending [ 135] ; (iii) implementing Partially Ordered Sets (POSets) within consensus protocols to define flexible but verifiable transaction orderings that maintain consistency in distributed and asynchronous environments [ 136, 137] ; (iv) deploying VDFs to introduce time-bound computational barriers, ensuring transaction ordering is validated through provable delays that are resistant to quantum speedup [ 128] ; and (v) adopt quantum-resistant consensus protocols (e.g., voting or staking-based), which reduce reliance on quantum-vulnerable computations and enhance validation integrity via economic or fault-tolerant guarantees [ 125] . Report issue for preceding element
C.4. Transaction Timestamp Manipulation: Quantum attacks can exploit vulnerabilities in BC timestamp generation, leading to inconsistencies in transaction history and potential disruptions in the consensus process. Quantum computers can undermine the cryptographic algorithms that secure timestamp data, allowing attackers to alter transaction times and sequences. This manipulation can result in out-of-order transactions, enabling malicious activities such as double-spending and hindering the network's ability to reach consensus [ 26] . Report issue for preceding element To counter these timestamp manipulation vulnerabilities, several mitigation strategies can be employed: (i) using VRFs to generate unpredictable and verifiable timestamps through cryptographic randomness, thereby enhancing security, preserving transaction order integrity, and preventing timestamp manipulation [ 118, 128] ; (ii) synchronizing clocks across validator nodes to ensure consistent timestamp generation, preventing timing discrepancies and maintaining accurate transaction sequencing [ 138] ; and (iii) deploying BFT consensus protocols that preserve agreement among honest nodes even in the presence of timestamp manipulation attempts, ensuring network robustness against adversarial behaviors [ 112] . Report issue for preceding element
C.5. Transaction ID Collisions: Transaction IDs, critical for ensuring the uniqueness and integrity of BC transactions, may become vulnerable to quantum attacks. These identifiers are fundamental to maintaining consensus and preventing fraud within the network. Quantum algorithms like Grover's can significantly reduce the computational complexity of finding hash collisions, potentially enabling malicious actors to create multiple transactions with the same ID. Such collisions can lead to network confusion, disruption of consensus mechanisms, and exploitation scenarios, including double-spending or interference with smart contract execution [ 139] . Report issue for preceding element To address these vulnerabilities, several mitigation strategies are proposed: (i) migrating to quantum-resistant hashing algorithms, while actively contributing to the development of dedicated standards—particularly since NIST has standardized post-quantum public-key cryptography but not yet hash functions [ 140, 141] ; and (ii) extending transaction ID lengths to increase resistance against collision attacks. While this approach statistically lowers the probability of hash collisions under Grover's algorithm, it may introduce trade-offs in terms of storage and processing overhead [ 140, 141] . Report issue for preceding element
C.6. Classic Signature Vulnerabilities: Classic digital signature algorithms, such as the ECDSA and RSA, are foundational to BC transaction verification and are widely used for signing transactions and ensuring authenticity. However, these algorithms are vulnerable to Shor's Algorithm [ 3] . A successful quantum attack would allow adversaries to forge digital signatures, inject unauthorized transactions, and compromise the integrity and trust of the BC network [ 1] . This vulnerability is especially critical for major BC platforms like Bitcoin and Ethereum, which rely on ECDSA for transaction security. Report issue for preceding element To mitigate these risks, the following strategy is essential: (i) migration to quantum-resistant signature algorithms mentioned in Table VI. These algorithms are designed to withstand attacks from quantum computers and are being standardized through initiatives like NIST PQC [ 86] . Report issue for preceding element
C.7. Quantum-Resistant Oracles: In the world of BC, smart contracts rely on oracles to bridge the gap between their internal logic and external data sources. These oracles fetch crucial information from the outside world, feeding it into the smart contract for transaction verification. However, traditional oracles pose a significant vulnerability to quantum attacks, as quantum computers could potentially manipulate the data they provide, compromising transaction verification integrity. Report issue for preceding element Key strategies to mitigate this challenge and proactively enhance security include: (i) adopting decentralized oracles to distribute data retrieval across independent nodes, creating redundancy that makes it considerably more difficult for attackers to manipulate data streams and disrupt transaction verification [ 142, 143] ; (ii) collaborating with quantum-secure data providers that use post-quantum protections for data transmission and storage, ensuring data integrity for smart contracts and strengthening overall network resilience against quantum threats [ 144] ; and (iii) implementing essential on-chain data validation mechanisms that thoroughly authenticate and verify oracle inputs before contract execution, significantly mitigating risks of data tampering and transaction outcome manipulation [ 145] . Report issue for preceding element TABLE X: Analysis of Transaction Verification Component: Quantum Threats, Vulnerabilities, Mitigations, and Risk Assessment
C.8. Risk Assessment for Quantum Threats to Transaction Verification Component: To assess the risks posed by QC threats to BC transaction verification mechanisms, we evaluate their likelihood and impact based on the criteria established in Tables IV and V. Here is a breakdown of likelihood categories for transaction verification vulnerabilities: Report issue for preceding element
(a) High: This category includes double-spending, transaction malleability, transaction reordering, classic signature vulnerabilities, and quantum-resistant oracles. Double-spending represents one of the most critical threats, as Grover's algorithm enables attackers to expedite the search for valid transaction signatures, especially affecting BCs with slow confirmation times. Transaction malleability and reordering attacks are highly susceptible to quantum systems, which can exploit cryptographic weaknesses or formatting inconsistencies to alter transaction data or sequence. Classic signature vulnerabilities are particularly pressing, with Shor's algorithm capable of breaking elliptic curve cryptography, exposing digital signatures to forgery and manipulation. Similarly, oracles, which serve as external data providers for BC systems, are vulnerable to quantum-enabled manipulation, further amplifying these risks. Report issue for preceding element
(b) Medium: This category covers transaction ID collisions, where Grover's algorithm reduces the effort required to find hash collisions. While these attacks are not yet practical under current conditions, employing quantum-resistant hashing algorithms and sufficiently long hash functions can effectively mitigate this risk. Nonetheless, proactive adoption of quantum-resistant measures is necessary to safeguard against future exploitation as QC evolves. Report issue for preceding element
(c) Low: This category includes transaction timestamp manipulation. Advanced defenses such as VRFs, synchronized clocks across nodes, and BFT protocols significantly mitigate this threat. These measures ensure accuracy and consistency in transaction timestamps, making such attacks highly infeasible, even as quantum technologies mature. Report issue for preceding element All transaction verification vulnerabilities carry a High impact rating, mirroring the assessments for BC networks and mining pools. This reflects the critical role transaction verification plays in safeguarding BC transactions. A successful attack could wreak havoc, causing financial losses from double-spending or compromised integrity, network instability due to disrupted consensus mechanisms or manipulated transaction ordering, and even a complete compromise of the BC's security, shattering user trust and confidence. Overall risk levels are derived by combining likelihood and impact (Figure 3). Table X provides detailed analysis of vulnerabilities, likelihood, impact, risk ratings, and mitigation strategies. Adopting these countermeasures is essential for maintaining the security and stability of the transaction verification mechanism component in the quantum era. Report issue for preceding element
IV-D Smart Contract Attacks and Quantum Computing Threats
Report issue for preceding element
Smart contracts, self-executing programs stored on the BC, offer immense potential for automating agreements and facilitating trustless interactions. However, the emergence of QC introduces significant vulnerabilities that could compromise the security of these crucial components. Here is a deeper look at the potential threats posed by quantum computers to smart contracts:
Report issue for preceding element
D.1. Cryptographic Algorithm Vulnerabilities: Cryptographic algorithms like ECDSA and RSA, vital for smart contract security, are vulnerable to QC. Shor's algorithm allows attackers to forge signatures, steal funds, alter contract logic, and introduce malicious code, jeopardizing the integrity and trust of BC systems [ 83, 2] . These vulnerabilities not only threaten financial stability by enabling fund theft but also compromise the functionality of BC systems by allowing tampering with contract logic, leading to unintended behavior, malicious code execution, and disrupted contract execution. Report issue for preceding element To mitigate these vulnerabilities and secure smart contracts in the quantum era, the following strategies are recommended: (i) conducting quantum-aware code audits to identify cryptographic weaknesses within smart contracts and prioritize remediation of components susceptible to quantum attacks [ 146, 147] ; (ii) applying formal verification techniques under quantum-safe assumptions to mathematically prove the correctness and resilience of contract logic against cryptographic compromise [ 148, 149, 150] ; and (iii) initiating phased migration plans that progressively transition smart contracts from quantum-vulnerable algorithms to standardized quantum-resistant alternatives as they mature and gain adoption [ 151, 12] . Report issue for preceding element
D.2. Integer Overflow and Underflow Vulnerabilities: Integer overflow and underflow vulnerabilities are common programming errors that can lead to unexpected behavior in smart contracts. These occur when arithmetic operations exceed the maximum or minimum storage capacity of a variable, causing unpredictable outcomes. Quantum computers, with their ability to perform calculations significantly faster, could accelerate the identification and exploitation of such vulnerabilities, making traditional detection methods less effective [ 152, 153] . For instance, a poorly designed smart contract may allow a large number to overflow the intended variable size, resulting in unintended behavior or even enabling malicious actors to manipulate funds. Exploitation of such vulnerabilities could destabilize not only individual smart contracts but also broader BC ecosystems, leading to cascading failures across interconnected decentralized applications. Report issue for preceding element Addressing these vulnerabilities and strengthening defenses against quantum-accelerated exploitation requires the following strategies: (i) utilizing advanced static code analysis tools to proactively identify potential integer overflow and underflow vulnerabilities during the development phase [ 154, 155] ; (ii) integrating safe math libraries into smart contract development that enforce strict runtime checks, to provide secure arithmetic operations that prevent overflows and underflows even when handling large numbers [ 156, 157] ; (iii) employing formal verification techniques with bounded arithmetic to mathematically prove the absence of these vulnerabilities, thereby ensuring robust security guarantees [ 150] ; and (iv) promoting proactive development practices, such as testing boundary conditions and adhering to strict validation rules, to minimize the risk of introducing arithmetic vulnerabilities from the outset [ 158] . Report issue for preceding element
D.3. DoS Attacks on Smart Contracts: DoS attacks target smart contracts by overwhelming them with a high volume of requests, far exceeding normal traffic, and impeding legitimate user access. While QC does not directly enable DoS attacks, its immense computational power could accelerate aspects such as attack generation and execution, enabling attackers to overwhelm smart contracts more rapidly and efficiently [ 159] . This surge in malicious traffic disrupts contract operations, causing delays in transactions or even preventing their processing entirely. Report issue for preceding element To enhance smart contract security against DoS attacks and improve the overall resilience of the BC ecosystem, the following mitigation strategies are recommended: (i) enforcing resource limits to cap the number of interactions or computational operations per user over a given period, preventing abuse, resource exhaustion, and overload while maintaining overall system integrity [ 96] ; (ii) applying circuit breaker patterns that automatically halt contract execution during traffic surges to prevent system overload, allowing recovery after predefined downtime and minimizing DoS attack impact [ 160] ; (iii) implementing rate-limiting mechanisms that throttle excessive requests, ensure fair access for all users, and integrate transaction or gas fee mechanisms that help regulate network load and provide additional deterrents to malicious actors [ 161, 97] ; (iv) employing network optimization techniques such as off-chain computation, batching, and caching to reduce on-chain load, minimize delays, and alleviate congestion during high-traffic periods while mitigating DoS attack effects [ 162, 163] ; and (v) optimizing gas usage by grouping multiple operations into a single transaction and offloading non-critical computations, reducing overall BC load and enhancing system resilience during attacks [ 164, 107, 165] . Report issue for preceding element TABLE XI: Analysis of Smart Contract Component: Quantum Threats, Vulnerabilities, Mitigations, and Risk Assessment
D.4. Inter-Contract Communication Vulnerabilities: In the intricate network of smart contracts, the pathways facilitating communication between these digital entities serve as critical conduits for data exchange and the execution of complex workflows. However, these channels are susceptible to vulnerabilities, offering potential entry points for exploitation by quantum attackers. These vulnerabilities may manifest in various forms, including the interception of sensitive data transmitted between contracts, the injection of malicious data into communication streams, or the disruption of interaction flows among contracts. Such actions could lead to severe consequences, ranging from the exposure of confidential information to the manipulation of data flows and the disruption of essential contract [ 115, 166] . Consequently, implementing robust mitigation strategies becomes paramount to safeguarding against these risks. Report issue for preceding element Mitigation strategies and proactive measures to immunize against inter-contract communication vulnerabilities include: (i) developing and adopting standardized communication protocols that enforce security and support built-in data integrity verification [ 18, 153] ; (ii) enforcing access control mechanisms that restrict unauthorized access to data and functionality during contract interactions [ 167] ; and (iii) integrating quantum-resistant serialization schemes to protect the integrity of exchanged data, even if intercepted by quantum-enabled adversaries [ 168] . Report issue for preceding element
D.5. Front-Running Attacks: In some BC networks, transaction fees are used to prioritize transaction processing. Quantum computers could potentially exploit this mechanism by analyzing pending transactions and strategically placing their own transactions before others (front-running). This could give attackers an unfair advantage in scenarios where transaction order is crucial. Report issue for preceding element To effectively mitigate front-running attacks, especially in the context of potential quantum threats, the following mitigation strategies can be implemented: (i) employing post-quantum encryption to conceal transaction contents prior to confirmation, preventing premature access even under quantum decryption capabilities and preserving transactional confidentiality [ 124] ; (ii) adopting commit-reveal schemes enhanced with quantum-resistant cryptography, where transaction data is committed in encrypted form and revealed only after block inclusion, reducing early disclosure risks [ 90] ; (iii) applying threshold cryptography, which requires multiple nodes to jointly decrypt transaction data, preventing unilateral access and mitigating front-running opportunities [ 169, 170] ; (iv) enforcing fair transaction ordering protocols—such as First In, First Out (FIFO) queues—secured with quantum-resistant verification to ensure submission-order processing regardless of fee manipulation [ 169] ; and (v) implementing delayed execution mechanisms that defer transaction visibility until validation is complete, limiting real-time exploitability by quantum-equipped attackers [ 171, 128] . Report issue for preceding element
D.6. Risk Assessment for Quantum Threats to Smart Contract Component: To assess the risks posed by QC advancements to smart contracts, we evaluate their likelihood and impact using the criteria outlined in Tables IV and V. The likelihood of these smart contract vulnerabilities is classified as follows: Report issue for preceding element
(a) High: Vulnerabilities include cryptographic algorithm weaknesses, inter-contract communication vulnerabilities, and front-running attacks. Cryptographic algorithm vulnerabilities are the most critical due to the susceptibility of widely used schemes like ECDSA and RSA to Shor's algorithm. If compromised, these algorithms would allow attackers to forge digital signatures, alter contract logic, or steal funds. Inter-contract communication vulnerabilities also pose a significant risk, as QC could intercept or manipulate sensitive data exchanged between contracts, leading to unauthorized access or disruption of workflows. Similarly, front-running attacks gain feasibility as quantum systems can analyze pending transactions more quickly, enabling attackers to exploit priority mechanisms and gain unfair advantages in financial or auction-based systems. Report issue for preceding element
(b) Medium: Vulnerabilities include integer overflow and underflow issues and DoS attacks on smart contracts. Integer overflow and underflow vulnerabilities depend on specific coding flaws within the smart contract, which QC could exploit more efficiently by accelerating vulnerability detection. However, these are less likely than cryptographic issues due to the specific conditions required for exploitation. DoS attacks, while potentially amplified by quantum computational power, are application-layer threats reliant on specific design flaws in contract execution or resource management rather than systemic cryptographic weaknesses. Report issue for preceding element A successful attack on any smart contract vulnerability carries a High impact rating across the board. This highlights the potential for catastrophic consequences. Exploiting these vulnerabilities could lead to financial ruin for users and businesses through stolen funds, disrupted transactions, or manipulated contract logic. Furthermore, attackers could gain access to sensitive data or inject malicious content through inter-contract communication breaches. Additionally, DoS attacks and communication vulnerabilities can cripple smart contract functionality, disrupting workflows and causing widespread disruptions. Even seemingly less severe attacks like front-running can manipulate markets by giving attackers an unfair advantage. This High impact rating reflects the critical role smart contracts play in BC ecosystems. A compromised smart contract can destroy trust and security, posing significant risks to all participants. The overall risk rating is obtained by combining likelihood and impact using the risk matrix (Figure 3). Table XI details vulnerabilities, likelihood, impact, overall risk, and mitigation strategies. Proactive deployment of quantum-resistant cryptography, secure contract design practices, and runtime verification are essential to preserve trust in the smart contract component under emerging quantum threats. Report issue for preceding element
IV-E User Wallet Attacks and Quantum Computing Threats
Report issue for preceding element
The security of user wallets is paramount for ensuring trust and confidence in BC technology. However, the emergence of QC poses a significant threat to user wallets, potentially leading to stolen cryptocurrency and compromised financial security [ 172, 2] . Here is a breakdown of the vulnerabilities user wallets face in the quantum era:
Report issue for preceding element
E.1. Private Key Exposure: User wallets rely on robust cryptographic algorithms to protect private keys, which grant access to the funds within the wallet. Popular algorithms like ECDSA are currently used for key generation and signing transactions. However, vulnerability of these schemes to Shor's Algorithm could potentially render the wallet susceptible to theft, allowing attackers to gain unauthorized access, derive the private key from the public key, and siphon off associated funds. Furthermore, it could facilitate the forging of seemingly legitimate transactions without the user's knowledge or consent, resulting in unauthorized transfers. Report issue for preceding element To mitigate private key exposure in the quantum era, the following strategies are recommended: (i) adopting quantum-resistant algorithms for private key generation in wallets—research on these algorithms is ongoing with promising options emerging—ensuring that keys remain secure even under quantum adversaries [ 173] ; and (ii) deploying Multi-Party Computation (MPC)-based wallets integrated with post-quantum cryptographic primitives, which enables distributed key generation and signing without revealing private key material, thereby combining the benefits of decentralized trust with quantum-resistant security guarantees [ 170] . Report issue for preceding element
E.2. Random Number Generators Manipulation: Many wallets rely on Random Number Generators (RNGs) to create strong cryptographic keys. While traditional RNGs might suffice currently, they could be vulnerable to manipulation by quantum computers [ 174, 175] . Attackers could exploit weaknesses in RNGs to generate predictable keys, compromising the security of user wallets. Report issue for preceding element To mitigate quantum-specific attacks on RNGs, the following strategies can be employed: (i) deploying Device-Independent Quantum Random Number Generators (DI-QRNGs) that leverage quantum nonlocality to certify randomness independent of device trust assumptions, ensuring unpredictability even under quantum adversaries [ 176] ; (ii) applying post-processing with quantum-proof randomness extractors to eliminate statistical biases in raw entropy and produce uniformly random outputs resilient to quantum inference [ 177] ; (iii) adopting entropy sources grounded in quantum physical processes—such as photon measurements or nuclear decay—which offer intrinsic resistance to quantum tampering and enhance randomness integrity [ 178] ; and (iv) implementing continuous entropy monitoring systems capable of detecting anomalies or manipulation patterns, thereby preserving the robustness of key generation under potential quantum interference [ 179] . Report issue for preceding element
E.3. Password Hashing Vulnerabilities: User accounts are typically protected with passwords, which are hashed (one-way encrypted) for secure storage. Popular hashing algorithms like SHA 256 are currently used in password storage. However, some quantum algorithms could potentially accelerate brute-force attacks, making it easier for attackers to guess passwords by trying a large number of combinations [ 180, 181] . Report issue for preceding element To mitigate password hashing vulnerabilities in user wallets under quantum threats, the following strategies are recommended: (i) transitioning to cryptographic hash functions with larger output sizes—such as SHA-3 or SHA-512—that provide sufficient bit security against Grover's algorithm [ 11] ; (ii) adopting memory-hard hashing algorithms like Argon2, which increase resource requirements through computational and memory constraints, limiting large-scale brute-force feasibility for both classical and quantum adversaries [ 182] ; (iii) configuring adaptive password hashing algorithms with elevated iteration counts, ensuring that computational cost scales with attacker capabilities, including quantum speedups [ 181] ; and (iv) enforcing strong password policies that mandate longer, more complex passwords to increase entropy and expand the effective search space, aligning with both classical and quantum-era security practices [ 152] . Report issue for preceding element TABLE XII: Analysis of User Wallet Component: Quantum Threats, Vulnerabilities, Mitigations, and Risk Assessment Layer Exploited Vulnerabilities Attack Vector Potential Impacts STRIDE Threats with Reasoning Mitigation Strategies Actionable Parties L I R User Wallet Private Key Exposure Deriving private keys from public keys using Shor's algorithm • Loss of Funds • Identity Theft • Compromised Transactions • Spoofing: Impersonation of legitimate users by deriving private keys and signing unauthorized transactions. • Tampering: Forging transactions using compromised private keys allows attackers to manipulate the ledger. • Quantum-Resistant Key Generation • MPC Wallets with Post- Quantum Cryptography [ 170] • Developers • Service Providers • End Users • Auditors H H H RNGs Manipulation Manipulation of RNGs to generate predictable keys • Compromised Security • Unauthorized Access • Tampering: Alter or manipulation of RNGs process to produce predictable keys, compromising wallet security. • Information Disclosure: Weak RNGs could reveal key generation patterns, exposing cryptographic material to attackers. • DI-QRNGs • Post-Processing with Quantum-Proof Extractors • Adoption of Entropy Sources Resistant to Quantum Tampering • Continuous Entropy Monitoring • Developers • Service Providers • Auditors • Regulators M H H Password Hashing Vulnerabilities Accelerated brute-force attacks on hashed passwords • Data Breach • Unauthorized Transactions • Repudiation: Attackers or users could deny responsibility for compromised accounts, especially in cases of weak password policies. • Information Disclosure: Quantum-powered brute-force attacks could reveal hashed passwords, granting unauthorized access. • Cryptographic Hash Functions with Adequate Bit Security, • Memory-Hard Functions, • Increased Hash Iterations with Adaptive Difficulty, • Password Policies with Enhanced Complexity. • Developers • Service Providers • End Users • Auditors M H H Transaction Interception Altering transaction data leading to theft or redirection of funds • Financial Loss • Data Manipulation • Tampering: Quantum attackers could alter transaction data in transit, redirecting funds or changing transaction details. • Information Disclosure: Intercepted transactions could expose sensitive data, such as recipient addresses and transaction amounts. • Quantum-Resistant Encryption Protocols • Enhanced Transaction Security • BC Integrity Measures • Quantum-Resistant Transaction Verification • Secure Transmission Channels • Developers • Service Providers • Auditors • Node Operators • Regulators H H H Report issue for preceding element
E.4. Transaction Interception: Quantum attackers leveraging advanced quantum computational capabilities could exploit vulnerabilities in traditional cryptographic protocols to intercept or tamper with transaction data during transmission. This poses significant risks, including theft or redirection of funds, unauthorized modifications, and exposure of sensitive transactional details. Quantum-specific attacks focus on breaking encryption or exploiting flaws in transaction validation mechanisms. Report issue for preceding element Mitigation strategies against transaction interception vulnerabilities in quantum-capable threat environments include: (i) integrating quantum-resistant encryption protocols to secure data in transit, ensuring intercepted transaction content remains indecipherable and tamper-proof even under quantum computation [ 183] ; (ii) reinforcing BC integrity using cryptographic constructs such as Merkle trees, threshold cryptography, and secure multiparty computation, which safeguard transaction authenticity and integrity and make it computationally infeasible for quantum adversaries to tamper with BC data [ 184] ; (iii) deploying robust quantum-safe verification mechanisms—such as hash-based digital signatures and quantum-resistant ZKPs —to maintain transaction validity and ensure they remain untampered under quantum adversarial conditions [ 2] ; and (iv) establishing secure transmission channels with post-quantum TLS protocols between users and BC nodes, preventing eavesdropping and mitigating interception and injection threats during transaction propagation [ 185] . Report issue for preceding element
E.5. Risk Assessment for Quantum Threats to User Wallet Component: To assess the risks posed by QC advancements to user wallets, we evaluate the likelihood and impact of potential attacks using criteria established in Tables IV and V. The following breakdown summarizes the likelihood categories for user wallet vulnerabilities: Report issue for preceding element
(a) High: Private key exposure represents a critical vulnerability with a high likelihood of exploitation as QC advancements progress. Shor's algorithm makes it feasible to derive private keys from public keys, posing a severe threat to wallet security. Additionally, transaction interception could also fall into the high-likelihood category. Advanced quantum systems might compromise encryption protocols, allowing attackers to intercept or alter transaction data. While current secure communication protocols mitigate this risk, insufficiently updated encryption methods will be vulnerable to future quantum threats. Report issue for preceding element
(b) Medium: RNGs manipulation is a potential threat, with quantum systems capable of exploiting weaknesses in traditional RNGs to generate predictable keys. Although robust quantum-resistant random number generation techniques significantly reduce this risk, poorly implemented RNGs remain vulnerable. Password hashing vulnerabilities are also categorized as medium likelihood, as Grover's algorithm could accelerate brute-force attacks, making it easier for attackers to exploit weak password hashing implementations. However, the adoption of strong password policies, memory-hard hashing algorithms, and cryptographic schemes with higher security margins can help mitigate this threat. Report issue for preceding element A successful attack on a user wallet vulnerability carries a High impact rating. Exploiting these vulnerabilities could lead to catastrophic consequences for users. This includes loss of funds, identity theft, and compromised transactions. Attackers could gain unauthorized access to user accounts, steal funds, or manipulate transaction data for personal gain. Overall risk is determined by combining likelihood and impact using the matrix in Figure 3. Table XII details vulnerabilities, likelihood, impact, overall risk, and mitigation strategies. Ensuring resilience of the user wallet component in the quantum era requires migration to PQC primitives, robust key management, and the adoption of secure entropy sources. Report issue for preceding element
V Roles and Responsibilities in Mitigating QC Impacts on BC
Report issue for preceding element TABLE XIII: Roles and Responsibilities in Mitigating QC Impacts on BC
Role
Attack Vector
STRIDE Threats
Quantum Implications
Possible Vulnerabilities
Quantum-Resistance Measures
Miners
Quantum Accelerated Mining
•
Spoofing: Quantum speed allows impersonation within mining pools.
• Tampering: Quantum-accelerated hashing enables modification of blocks or mining history.
Quantum computers may significantly speed up mining processes, especially in PoW, potentially disrupting consensus by enabling faster hash solving [ 186, 187] .
Higher vulnerability to 51% attacks if mining power is concentrated among quantum-equipped miners [ 90, 89] .
Adopting longer hash outputs, quantum-resistant hashing algorithms, and hybrid cryptographic techniques can help mitigate mining centralization [ 188, 20] .
Threat to Consensus Mechanisms
•
Spoofing: Quantum power enables impersonation of network nodes.
• Tampering: Quantum attacks allow altering transaction data.
• Repudiation: Attackers may deny responsibility for malicious transactions.
• Info. Disclosure: Decryption powered by quantum technology could expose private transaction data.
• DoS: High-speed processing enables flooding of network nodes.
• Elevation of Privilege: Quantum power could give attackers control over nodes.
QC's ability to break cryptographic primitives could undermine PoW and PoS security and affect scalability in BFT systems [ 90, 189] .
Cryptographic vulnerabilities in consensus algorithms and scalability issues in BFT protocols [ 190, 191] .
Development of quantum-resistant cryptographic algorithms, hybrid cryptographic systems, and restructuring BFT protocols for quantum resilience [ 18, 20] .
Energy Consumption
•
Elevation of Privilege: Quantum efficiency enables unauthorized operations at lower energy costs.
QC may improve mining efficiency, potentially reducing energy consumption, though security implications remain critical [ 20, 191] .
Trade-offs between energy efficiency and security as quantum capabilities increase [ 186] .
Design of low-energy quantum-resistant protocols for sustainable BC mining [ 187] .
Service Providers
Quantum Cryptanalysis
•
Spoofing: Quantum attacks could enable impersonation of legitimate service providers.
• Tampering: Decryption allows unauthorized data modifications.
• Info. Disclosure: Breaking encryption exposes sensitive data.
Quantum attacks on encryption expose sensitive data and allow unauthorized access [ 3, 4] .
Encryption vulnerabilities compromise data confidentiality and integrity [ 3, 4] .
Implementation of quantum-resistant and hybrid cryptographic approaches [ 3, 4] .
Smart Contract Vulnerabilities
•
Tampering: Quantum attacks enable unauthorized changes to contract states.
• Repudiation: Attackers may deny malicious actions within contracts.
• Info. Disclosure: Quantum attacks could expose confidential contract data.
• Elevation of Privilege: Quantum bypasses enable unauthorized access to contract functions.
Quantum threats could compromise contract integrity, allowing unauthorized control or data manipulation [ 192, 22] .
Increased risk of smart contract exploitation due to compromised cryptographic primitives [ 192, 22] .
Adoption of quantum-resistant cryptographic protocols, formal verification [ 148, 149, 150] , and regular auditing [ 192, 22] .
Data Confidentiality
•
Spoofing: Quantum attacks enable impersonation of authorized data handlers.
• Tampering: Unauthorized modifications to stored data due to broken encryption.
• Info. Disclosure: Quantum decryption reveals sensitive stored data.
Quantum attacks threaten data confidentiality by breaking encryption [ 193] .
Risk of sensitive data exposure and data manipulation [ 193] .
Post-quantum cryptographic algorithms for data protection [ 193] .
Access Control Compromise
•
Spoofing: Quantum-assisted impersonation bypasses access controls.
• Elevation of Privilege: Breaking cryptography grants unauthorized access.
Quantum attacks could undermine role-based access and multi-signature wallets [ 194, 195] .
Unauthorized access to sensitive functions or data [ 194, 195] .
Quantum-resistant multi-signature schemes and hybrid authentication protocols [ 194, 195] .
End Users
Quantum Key Extraction (Wallet Security Compromise)
•
Spoofing: Quantum decryption enables impersonation of wallets.
• Tampering: Unauthorized transactions using compromised private keys.
• Info. Disclosure: Quantum attacks reveal private keys.
Quantum attacks on ECC can expose private keys, compromising wallet security [ 196] .
Private keys and wallet data are vulnerable, risking asset security [ 196] .
Quantum-resistant wallets with advanced cryptography and hardware wallets [ 196] .
Transaction Verification
•
Tampering: Quantum attacks enable unauthorized transaction modifications.
• Repudiation: Attackers may deny responsibility for fraudulent transactions.
• Elevation of Privilege: Unauthorized transaction approvals via compromised signatures.
Quantum threats may compromise digital signatures, affecting transaction integrity [ 189] .
Risk of fraud and financial loss due to compromised transaction verification [ 189] .
Quantum-resistant digital signatures, multi-signature protocols, and threshold cryptography [ 189] .
Phishing Attacks
•
Spoofing: Quantum attacks enable impersonation of trusted sources.
• Info. Disclosure: Quantum attacks expose credentials by breaking secure channels.
Quantum threats to secure channels increase phishing risks and exposure of credentials [ 197, 198] .
Higher risk of credential theft and unauthorized access [ 197] .
Quantum-resistant communication protocols and user education on phishing risks [ 197] .
Privacy Breaches
•
Info. Disclosure: Quantum decryption reveals user identities and transaction history.
• Spoofing: Quantum-assisted impersonation could lead to data leaks.
Quantum decryption could reveal user identities and transaction history, risking privacy [ 90, 199] .
Compromised anonymity and data confidentiality [ 200] .
Quantum-resistant privacy technologies like ZKPs and data anonymization [ 90] .
Developers
Quantum Cryptanalysis
•
Spoofing: Impersonation of smart contract owners or developers to deploy malicious updates.
• Tampering: Unauthorized modifications to cryptographic protocols or contract logic using quantum-powered attacks.
QC undermines cryptographic primitives (e.g., RSA, ECC) used in BC protocols and smart contracts [ 3] .
Risk of protocol compromise, unauthorized updates, and systemic security failures if cryptographic primitives are not updated.
Adoption of lattice-based and hash-based cryptography, hybrid cryptographic schemes, and integration of post-quantum cryptographic libraries [ 201] .
Digital Signature Vulnerabilities
•
Spoofing: Impersonation of valid signers in multi-signature schemes.
• Repudiation: Attackers deny responsibility for signed malicious transactions.
• Info. Disclosure: Exposure of private keys due to quantum decryption.
Digital signatures, critical for authentication and authorization, are rendered insecure by quantum attacks [ 90, 202] .
Compromised transaction authenticity, multi-signature wallets, and node authorization in consensus protocols.
Adoption of quantum-resistant digital signatures, such as lattice-based schemes, and regular validation of security mechanisms [ 202] .
Transition to Quantum-Resistant Solutions
•
Tampering: Exploitation of legacy cryptographic systems during the transition phase.
• Elevation of Privilege: Attackers exploit unpatched vulnerabilities in transitioning protocols.
Updating smart contracts and protocols to quantum-resistant algorithms is necessary but may introduce temporary security gaps [ 201] .
Outdated cryptographic primitives, compatibility issues, and risks of incomplete migration.
Phased updates to quantum-resistant solutions, fallback mechanisms, testing in simulated environments, and collaboration with standardization bodies [ 201] .
Testing and Validation
•
Info. Disclosure: Weaknesses in quantum-resistant algorithms could expose vulnerabilities.
• Tampering: Exploitation of untested or improperly validated quantum-resistant cryptographic schemes.
Quantum-resistant algorithms require rigorous testing to ensure practicality, resilience, and scalability in BC environments.
Vulnerabilities due to improperly tested algorithms and reduced system performance during integration.
Rigorous testing in controlled environments, performance benchmarking, and phased deployment [ 201] .
Node Operators
Quantum Hashing Attacks
•
Tampering: Breaking traditional hashes enables modification of transaction history.
• Spoofing: Impersonation of valid nodes or miners using quantum-assisted hash manipulation.
Grover's algorithm halves the effective security of hashing algorithms (e.g., SHA 256), reducing resistance to brute-force attacks [ 1] .
Vulnerability to tampering with BC data, weakening of PoW consensus mechanisms, and potential double-spending risks.
Adoption of quantum-resistant hashing algorithms, such as sponge constructions and hash-based designs, and updates to PoW systems [ 27] .
Data Integrity Risks
•
Info. Disclosure: Breaking encryption exposes sensitive data, including private keys.
• Tampering: Quantum attacks enable unauthorized modifications to BC or node data.
Quantum attacks on encryption (e.g., RSA, ECC) can compromise stored and transmitted BC data, risking confidentiality and integrity [ 173] .
Risks to private key security, data confidentiality, and historical transaction accuracy.
Adoption of lattice-based and hash-based cryptography for encryption, secure key management, and data storage protections [ 173] .
DoS Attacks
•
DoS: Quantum-assisted attacks enable large-scale traffic flooding or resource exhaustion.
• Spoofing: Exploitation of compromised authentication to launch coordinated attacks.
QC enhances the scalability and sophistication of DoS attacks by accelerating resource exhaustion techniques [ 203] .
Disruption of node operations, reduced service availability, and potential node isolation.
Adoption of decentralized DoS mitigation systems, quantum-resistant authentication protocols, and enhanced network-layer protections [ 203] .
Unauthorized Access
•
Elevation of Privilege: Breaking cryptographic protections to gain unauthorized access to nodes.
• Tampering: Compromised nodes enable manipulation of network data and configurations.
Quantum decryption of private keys or authentication data may allow attackers to bypass security measures and gain control of node infrastructure [ 204] .
Risks of unauthorized access, data breaches, manipulation of network state, and disruption of node operations.
Implementation of quantum-resistant authentication protocols, multi-factor authentication, regular security audits, and proactive infrastructure monitoring [ 204] .
Report issue for preceding element TABLE XIII: (Cont.) Roles and Responsibilities in Mitigating QC Impacts on BC
Role
Attack Vector
STRIDE Threats
Quantum Implications
Possible Vulnerabilities
Quantum-Resistance Measures
Regulators & Compliance Authorities
Encryption Vulnerabilities
•
Info. Disclosure: Quantum attacks expose encrypted communications between regulators and stakeholders.
• Tampering: Compromised encryption allows alteration of regulatory data or directives.
• Repudiation: Attackers deny responsibility for breaches or altered communications.
Quantum computers can break cryptographic standards like RSA and ECC, requiring regulators to transition to quantum-resistant encryption [ 205] .
Risks to secure communications, data integrity, and enforcement of cryptographic compliance standards.
Adoption of post-quantum encryption standards, collaboration with global standardization bodies, and secure cryptographic audits [ 205] .
Data Security Risks
•
Info. Disclosure: Breaking encryption exposes sensitive regulatory and compliance data, including Know Your Customer (KYC) records.
• Tampering: Quantum attacks enable unauthorized modification of stored or transmitted data.
• Spoofing: Impersonation of regulatory authorities to issue fraudulent compliance directives.
Quantum attacks compromise encryption, creating vulnerabilities in regulatory systems and sensitive data [ 173] .
Breaches of KYC records, manipulation of compliance records, and impersonation of regulatory entities, leading to compliance failures.
Implementation of quantum-resistant encryption, secure storage mechanisms, and periodic audits of regulatory systems [ 173] .
Legal Framework Updates
•
Spoofing: Impersonation of regulators to issue fraudulent directives or policies.
• Tampering: Unauthorized changes to compliance or legal frameworks using quantum-enhanced tools.
• Elevation of Privilege: Exploiting outdated regulatory frameworks to bypass enforcement mechanisms.
Quantum threats necessitate updates to cybersecurity and data protection laws to address cryptographic obsolescence and emerging quantum vulnerabilities [ 206] .
Outdated legal frameworks that fail to mandate quantum-resistant systems and enforce compliance standards.
Regular updates to legal frameworks, phased mandates for quantum-resistant cryptographic systems, and post-quantum readiness audits [ 206] .
Privacy Mechanism Vulnerabilities
•
Info. Disclosure: Quantum attacks expose anonymized or privacy-protected data.
• Spoofing: Impersonation of entities to exploit privacy-preserving tools.
• Repudiation: Attackers deny responsibility for breaches of privacy-preserving systems.
Quantum capabilities weaken privacy-preserving mechanisms, such as ZKPs and mixers, potentially undermining Anti-Money Laundering (AML) and KYC compliance [ 207] .
Non-compliance of privacy tools with regulatory standards, exposure of sensitive user data, and challenges balancing privacy and AML requirements.
Enhanced oversight of privacy mechanisms, integration of quantum-resistant privacy tools, and regular technical audits to ensure compliance [ 207] .
Auditors
Quantum-Accelerated Cryptanalysis
•
Tampering: Manipulation of BC protocols or audit processes using quantum decryption.
• Info. Disclosure: Exposure of cryptographic weaknesses and sensitive audit findings.
Quantum computers can break cryptographic primitives (e.g., RSA, ECC), requiring auditors to assess quantum-resistant solutions [ 208] .
Ineffective detection of cryptographic vulnerabilities and outdated audit practices that fail to address quantum risks.
Development of quantum-aware audit frameworks, adoption of NIST post-quantum standards, and regular audits for cryptographic resilience [ 209] .
Transition Planning
•
Spoofing: Impersonation of auditors to exploit migration vulnerabilities.
• Info. Disclosure: Quantum decryption exposes sensitive transition strategies.
• Tampering: Exploitation of unpatched or legacy systems during migration phases.
Auditors guide BC projects through transitions to quantum-resistant cryptography, mitigating migration-specific risks [ 210] .
Flawed migration plans, incomplete updates, and temporary compatibility issues during transitions.
Comprehensive evaluation of transition strategies, phased migration plans, and adoption of hybrid cryptographic systems to ensure smooth transitions [ 209] .
Post-Quantum Readiness Assessments
•
Tampering: Exploitation of improperly deployed quantum-resistant implementations.
• Spoofing: Impersonation of auditors during readiness testing or compliance audits.
• Info. Disclosure: Exposure of vulnerabilities during assessments or simulated attacks.
Auditors test quantum-resistant solutions for effectiveness and compliance with evolving standards [ 209] .
Improperly deployed quantum-resistant systems and inadequate alignment with post-quantum standards.
Simulating quantum-based attacks, validating system alignment with regulatory frameworks, and conducting ongoing compliance audits [ 208] .
Collaborative Security Reviews
•
Tampering: Misaligned collaboration leaves vulnerabilities unaddressed.
• Info. Disclosure: Exposure of sensitive findings during collaborative processes.
• Repudiation: Stakeholders deny responsibility for implementing quantum-resistant solutions.
Collaboration ensures robust quantum-resistant designs and alignment with technical and regulatory standards [ 209] .
Miscommunication, unaligned standards, or incomplete reviews can weaken system resilience.
Joint reviews with developers, cryptographers, and regulators to validate quantum-resistant designs and enforce global standards [ 209] .
Skill Development and Training
•
Inadequate training leads to ineffective audits and overlooked vulnerabilities.
• Exploitation of outdated tools and methodologies by attackers.
Auditors must acquire expertise in PQC, quantum-specific auditing tools, and advanced security frameworks [ 209] .
Insufficient expertise compromises audits and weakens assessments of post-quantum readiness.
Continuous skill development through workshops, certifications, and training in quantum-resistant practices [ 209] .
Governance Participants
Quantum-Supported Manipulation
•
Spoofing: Forgery of governance participant identities to disrupt decision-making.
• Tampering: Manipulation of governance decisions or proposals.
QC undermines cryptographic protections, enabling identity forgery and manipulation of decision-making processes [ 211] .
Risk of unauthorized governance decisions, identity spoofing, and governance manipulation affecting system trust.
Adoption of quantum-resistant identity verification, secure quorum mechanisms, and tamper-proof governance protocols [ 211] .
Decentralized Governance Systems
•
Spoofing: Quantum attackers forge participant identities to influence decision-making.
• Tampering: Alteration of governance-related data, outcomes, or rules.
• Repudiation: Denial of responsibility for fraudulent governance actions.
Quantum threats could compromise decentralized governance systems, disrupting transparency, accountability, and trust [ 212] .
Risk of governance manipulation, unauthorized access, and reduced confidence in decentralized systems.
Implementation of quantum-resistant cryptographic protocols, tamper-proof governance mechanisms, and enhanced audit trails [ 212] .
Voting Mechanisms
•
Info. Disclosure: Quantum attacks expose confidential votes or voter identities.
• Tampering: Unauthorized alteration of cast votes or voting outcomes.
• Spoofing: Impersonation of voters to skew results or manipulate governance.
QC compromises vote confidentiality and integrity, enabling manipulation of governance outcomes [ 213] .
Privacy breaches, vote manipulation, vote-buying, coercion, and loss of confidence in governance outcomes.
Adoption of quantum-resistant cryptographic techniques and advanced privacy-preserving mechanisms like quantum-resistant ZKPs [ 213] .
Smart Contract Execution
•
Tampering: Quantum attackers disrupt governance-related transactions or smart contract execution.
• Elevation of Privilege: Unauthorized execution of governance-related actions.
Quantum threats compromise governance-related smart contracts, enabling transaction manipulation, unauthorized actions, or financial tampering [ 214] .
Risk of disrupted decision-making processes, treasury manipulation, and governance system failures.
Implementation of quantum-resistant smart contracts, formal verification practices, and secure governance transaction frameworks [ 214] .
Quorum Formation and Proposal Verification
•
Spoofing: Forged identities disrupt quorum formation, enabling Sybil attacks.
• Tampering: Quantum attacks alter governance proposals or their verification.
QC enables identity forgery and tampering, undermining quorum legitimacy and proposal verification [ 215] .
Loss of governance integrity, fraudulent proposals, and weakened trust in decision-making structures.
Adoption of quantum-resistant identity verification systems, tamper-proof proposal mechanisms, and decentralized governance frameworks [ 215] .
Oracles
Quantum Tampering
•
Tampering: Manipulation of external data feeds from multiple sources.
• Info. Disclosure: Interception of sensitive oracle communications.
• Spoofing: Impersonation of legitimate oracles to deliver fraudulent data.
Quantum attacks compromise cryptographic protections, enabling manipulation or interception of oracle data, undermining trust in smart contract operations [ 14, 211] .
Risk of corrupted or falsified data feeds, compromised multi-oracle systems, and disrupted decision-making in oracle-driven applications.
Adoption of quantum-resistant cryptographic protocols, tamper-proof data verification mechanisms, and secure multi-source aggregation to prevent single-point failures [ 16, 180] .
Quantum Eavesdropping
•
Info. Disclosure: Quantum-enabled interception of data during transmission.
Secure communication channels between oracles and BC systems are vulnerable to quantum interception, exposing sensitive data or disrupting workflows [ 16] .
Exposure of confidential data, leading to breaches of contract logic and manipulation of BC processes reliant on oracle inputs.
Transition to quantum-safe communication protocols and continuous monitoring of data flow integrity [ 180] .
Quantum-Compromised Smart Contracts
•
Tampering: Manipulation of oracle-driven smart contract executions.
• Elevation of Privilege: Unauthorized execution of high-priority actions through compromised inputs.
Quantum attacks undermine the cryptographic foundations of smart contracts that depend on oracle inputs, disrupting contract execution and financial operations [ 202, 90] .
Disruption of contract reliability, unauthorized fund transfers, and manipulation of automated workflows in oracle-driven systems.
Implementing quantum-resistant smart contracts, regularly auditing oracle integrations, incorporating fail-safe mechanisms for data integrity, and fostering collaborative development with BC stakeholders [ 202] .
Community Participants
Cryptographic Breaks
•
Tampering: Manipulation of transactions or digital signatures.
• Spoofing: Forgery of participant identities.
Quantum attacks on cryptography could enable identity forgery and transaction manipulation [ 22] .
Loss of trust in BC systems, compromised digital signatures, and stolen participant identities or private keys.
Advocacy for the adoption of quantum-resistant cryptography by developers, active participation in governance discussions, and promotion of secure digital identity systems [ 20] .
Privacy Breaches
•
Info. Disclosure: Exposure of transaction data and identities.
• Spoofing: Impersonation of users or community members.
Quantum-enabled decryption threatens confidentiality of BC transactions [ 199] .
Loss of user anonymity, exposure of sensitive data, and reduced trust in public BCs.
Promotion of privacy-preserving technologies like ZKPs, secure MPCs, and community-driven awareness campaigns on privacy risks [ 216] .
Misinformation
•
Tampering: Manipulation of educational materials or BC narratives.
• Spoofing: Creation of false sources to spread quantum-related misinformation.
Misinformation about quantum vulnerabilities can cause panic and distrust in BC ecosystems [ 217] .
Erosion of trust, spread of incorrect security measures, and delayed adoption of quantum-safe technologies.
Transparent communication, fact-checking initiatives, collaboration with trusted experts, and leveraging social media to dispel myths [ 217] .
Educational Gaps
•
Info. Disclosure: Lack of knowledge delays the adoption of protective measures.
• Repudiation: Failure to provide accurate and accessible educational resources.
Limited awareness of quantum risks leaves the community unprepared for emerging threats [ 218] .
Vulnerabilities due to delayed adoption of quantum-safe practices, especially among non-technical participants.
Community-led educational initiatives like webinars, forums, outreach programs, and collaborative workshops to spread awareness [ 217] .
Report issue for preceding element
BC technology relies on cryptographic techniques to ensure security and integrity. Each role within the ecosystem—miners, service providers, end users, developers, regulators, auditors, and community participants—faces unique quantum-related challenges, necessitating tailored strategies to address potential vulnerabilities and ensure resilience.
Report issue for preceding element
Miners need to adapt their mining algorithms to incorporate quantum-resistant designs, effectively addressing the risks posed by quantum-accelerated mining and the potential for centralization. Service providers play a critical role in implementing quantum-resistant cryptography, securing smart contracts, and ensuring data confidentiality and integrity. End users should enhance wallet security, rigorously verify transactions, and adopt measures to mitigate quantum-assisted phishing attacks. Developers bear the responsibility of transitioning BC protocols and smart contracts to quantum-resistant cryptographic algorithms. They must conduct rigorous testing of these solutions and collaborate with cryptographic experts to ensure scalability, security, and resilience. Regulators need to update legal frameworks to address the implications of QC, enforce quantum-resistant standards, and monitor BC ecosystems for emerging vulnerabilities. Auditors play a vital role in assessing BC systems for quantum readiness. By evolving audit methodologies, conducting quantum readiness assessments, and guiding the transition to secure solutions, auditors help maintain system integrity. Community participants contribute by raising awareness, advocating for quantum-resistant practices, educating users, and supporting open-source development, conducting security audits, and promoting the adoption of best practices.
Report issue for preceding element
Table XIII details the challenges and mitigation strategies associated with each role, emphasizing the necessity of quantum-resistant cryptography, advanced security protocols, and proactive risk management. By addressing these challenges and collaborating with standardization bodies such as NIST, the BC ecosystem can maintain its security and resilience in the face of QC advancements.
Report issue for preceding element
VI Challenges and Strategies After Transitioning to Quantum-Resistant BC Systems
Report issue for preceding element
While the integration of quantum-resistant algorithms seems like a natural solution, the transition itself introduces a new wave of challenges [ 219] . This section delves into the complexities organizations face after transitioning their BC systems to a quantum-resistant future. We will explore the multifaceted attack vectors that extend beyond just encryption vulnerabilities, and the strategic considerations required to navigate this critical shift. By examining key components like the BC network, mining pools, and user wallets, we will identify the challenges associated with adapting each element to quantum-resistant cryptography. We will also explore potential solutions that organizations can implement to ensure a smooth and secure transition, safeguarding the long-term viability of their BC deployments in the face of this evolving technological landscape.
Report issue for preceding element
VI-A BC Network
Report issue for preceding element
The emergence of QC necessitates a paradigm shift in securing BC networks. While the integration of quantum-resistant algorithms offers a solution, it demands a comprehensive re-evaluation of the underlying network architecture. Unlike a straightforward cryptographic substitution, these new algorithms often necessitate larger key sizes and impose significantly higher computational workloads. Consequently, adjustments to existing protocols, data structures, and even the fundamental infrastructure of the network become paramount [ 19] . Additionally, these changes can affect network latency and transaction throughput, further complicating the transition. This section explores the multifaceted challenges associated with this crucial transition, including potential incompatibilities with current systems, the need to accommodate larger keys and increased workloads, the imperative for network infrastructure upgrades, and the critical task of maintaining seamless interoperability during the migration process. By addressing these challenges and implementing effective solutions, organizations can ensure a smooth migration to a quantum-resistant BC network, safeguarding its long-term security and scalability within this evolving technological landscape. Here is a breakdown of the key challenges and potential solutions for BC networks in this context:
Report issue for preceding element
A.1. Compatibility with Existing Protocols and Data Structures: New cryptographic algorithms might not be readily compatible with existing BC protocols and data structures [ 220] . This could lead to issues with data validation, consensus mechanisms, and overall network functionality. Potential solutions to address these compatibility challenges include: (i) developing adaptations to existing protocols that accommodate the specific requirements and constraints of PQC, ensuring seamless integration while preserving network functionality; (ii) exploring alternative data structures inherently compatible with PQC, with redesigns focused on optimizing both performance and security; and (iii) implementing a phased migration approach—initially transitioning critical functionalities, followed by gradual adoption across remaining network components—to minimize disruption and maintain system stability. Report issue for preceding element
A.2. Accommodating Larger Key Sizes and Increased Computational Demands: PQC algorithms typically require significantly larger key sizes than classical cryptographic schemes [ 221, 153, 18] . This leads to increased storage needs and computational overhead for tasks such as transaction verification and block validation, potentially impacting network latency and throughput. To address these challenges, the following strategies are recommended: (i) analyzing trade-offs between security levels and key sizes to adopt optimal configurations that balance robustness and efficiency; (ii) upgrading BC node infrastructure—including processing power, memory, and storage—to support increased computational demands; and (iii) exploring alternative consensus mechanisms with lower computational complexity that remain secure in a QC environment. Report issue for preceding element
A.3. Network Infrastructure Upgrades: Upgrading the underlying infrastructure of the BC network is essential to ensure seamless integration with PQC. This encompasses software updates, hardware replacements, and maintaining compatibility with existing development and deployment tools [ 222, 223] . To address these infrastructure challenges, the following strategies are recommended: (i) developing clear and well-documented upgrade paths for BC nodes, including compatibility testing tools and step-by-step migration guidelines; (ii) fostering ecosystem-wide collaboration to coordinate adoption of new software versions and maintain operational consistency across diverse network participants; and (iii) incorporating backward compatibility features during the transition phase to reduce disruption for users and applications that depend on legacy infrastructure. Report issue for preceding element
A.4. Maintaining Interoperability: During the transition to quantum-resistant cryptography, some nodes may still operate under legacy algorithms while others adopt PQC [ 25, 28, 26] . This coexistence can lead to network fragmentation or disruptions if interoperability is not properly ensured. To overcome this challenge, the following strategies are recommended: (i) deploying robust hybrid BC architectures—such as composite designs, which streamline integration through unified ledgers, and non-composite designs, which use independent dual-network strategies, as detailed in Section VII—to ensure seamless interoperability between classical and post-quantum cryptographic BC systems; (ii) designing a staged migration process with defined milestones and rollback mechanisms to address failures and compatibility issues; and (iii) fostering collaboration and transparency within the BC community to ensure a smooth and coordinated transition. Report issue for preceding element
VI-B Mining Pool
Report issue for preceding element
Mining pools face significant challenges during the transition to quantum-secure cryptography. Increased computational overheads associated with post-quantum algorithms can strain resources and potentially exacerbate centralization risks. Furthermore, new attack vectors, such as quantum-based DoS attacks or cryptanalysis of quantum-secure primitives, may emerge. To ensure continued success, mining pools must implement robust security measures, optimize resource utilization, and actively mitigate centralization risks [ 224] . The following explores these challenges and proposes strategies for successful operation in a quantum-secure environment.
Report issue for preceding element
B.1. Enhanced Security Measures: The transition to quantum-resistant algorithms introduces new attack vectors—including quantum cryptanalysis and side-channel vulnerabilities—that can compromise mining operations. To mitigate these evolving threats, the following defense strategies are recommended: (i) designing and implementing key management systems capable of operating with both classical and quantum-resistant cryptographic keys for critical infrastructure components [ 29] ; (ii) deploying intrusion detection and prevention systems (IDS/IPS) to monitor and block anomalous activities within the mining pool infrastructure [ 160] ; (iii) conducting regular security audits to identify and remediate vulnerabilities in mining pool software, configurations, and exposed network interfaces [ 208, 209] ; and (iv) enforcing stricter access controls and multi-factor authentication to secure administrative interfaces, mining resources, and user accounts [ 225] . Report issue for preceding element
B.2. Resource Optimization: Quantum-resistant algorithms often require larger key sizes and greater computational effort, leading to increased energy consumption and hardware demands [ 25, 28, 26] . To address these resource-intensive requirements, the following optimization strategies are recommended: (i) utilizing specialized hardware accelerators—such as GPUs, FPGAs, or ASICs—designed to efficiently execute quantum-resistant cryptographic operations; (ii) deploying dynamic resource allocation systems through cloud computing to elastically manage fluctuating mining workloads; (iii) developing energy-efficient mining algorithms tailored to post-quantum cryptography and integrating renewable energy sources to minimize environmental impact; and (iv) quantifying resource overheads—such as the percentage increase in energy consumption per transaction due to larger key sizes—and addressing thermal challenges with advanced cooling solutions. Report issue for preceding element
B.3. Maintaining Competitiveness and Fairness: Increased hardware and operational costs may exacerbate centralization risks, as only well-funded mining pools can afford the necessary infrastructure [ 2, 18, 153] . To promote fairness and competitiveness, the following strategies are recommended: (i) encouraging collaboration among mining pools to share computational resources and collectively strengthen network security; (ii) advocating for the development of resource-efficient quantum-resistant algorithms to lower entry barriers for smaller participants; (iii) fostering transparency and fair competition within the mining ecosystem to ensure equitable access to advanced technologies and software; and (iv) engaging with policymakers to incentivize equitable mining practices and renewable energy adoption through subsidies, tax credits, or grants. Report issue for preceding element
B.4. Phased Transition and Continuous Adaptation: A phased roadmap ensures smooth transition to quantum-resistant operations while maintaining security, trust, and efficiency [ 151, 18] . Key considerations include: (i) Short-term: assess infrastructure, upgrade hardware/networking, implement baseline quantum-resistant algorithms for registration/communications, and pilot test for vulnerabilities; (ii) Medium-term: deploy advanced quantum-resistant algorithms for rewards/verification, optimize mining software for post-quantum efficiency, implement quantum-secure consensus, optimize energy consumption, and establish quantum-resistant/legacy interoperability; (iii) Long-term: achieve complete quantum resistance via standardized post-quantum cryptography, align with quantum-resistant consensus, implement secure inter-pool communication, and establish continuous adaptation; (iv) Continuous monitoring: deploy predictive analytics for hash rate, difficulty, computational, and energy changes, enabling proactive allocation and threat positioning. Report issue for preceding element
B.5. Governance and Economic Considerations: The transition to quantum-secure BC systems requires coordination and financial support to prevent smaller mining pools from being marginalized [ 226, 227] . To promote fairness and long-term competitiveness, the following strategies are recommended: (i) establishing a decentralized governance structure to coordinate upgrades across mining pools and enforce compliance with quantum-resistant standards; (ii) implementing shared resource models—such as pooled access to quantum-resistant hardware, secure cloud infrastructure, or open-source platforms—to reduce entry costs for smaller participants; and (iii) engaging with policymakers to provide financial incentives, including grants, tax credits, or subsidies, to accelerate the adoption of quantum-resistant technologies and renewable energy sources. Report issue for preceding element
VI-C Transaction Verification Mechanism
Report issue for preceding element
The transition to quantum-resistant algorithms presents significant challenges for verifying transactions within BC networks. Careful consideration and adaptation are crucial to maintain network integrity and security. By proactively addressing these challenges, organizations can ensure a smooth transition and safeguard the enduring security and efficiency of their BC networks.
Report issue for preceding element
C.1. Consensus Protocol Adaptation: Existing consensus mechanisms, which ensure network integrity by verifying transactions and reaching agreement on the BC state, might require adjustments to mitigate the risk of unauthorized control after the switch to quantum-resistant cryptography [ 189] . Quantum-resistant algorithms can alter the computational power dynamics within the network (e.g., some algorithms might be more efficient for specific hardware), potentially creating vulnerabilities for malicious actors [ 228, 190] . To address these challenges, the following proactive strategies are recommended: (i) analyzing existing consensus mechanisms to identify vulnerabilities introduced by the adoption of quantum-resistant algorithms; (ii) modifying consensus parameters, such as block validation rules, voting weights, and dispute resolution processes, to preserve balanced participation and network security; and (iii) exploring or designing alternative consensus protocols specifically tailored for quantum-resistant environments, including post-quantum voting-based variants that inherently resist unauthorized control. Report issue for preceding element
C.2. Increased Computational and Communication Overheads: Report issue for preceding element TABLE XIV: Comparison of NIST-Standardized Post-Quantum Cryptographic Algorithms
C.3. Implementation Complexity: PQC integration introduces substantial complexity to existing BC systems, particularly in transaction verification, consensus protocols, and key operations [ 6, 219] . Such complexity can introduce new security vulnerabilities, performance bottlenecks, and integration challenges, which may further compound scalability and interoperability issues as network adoption grows. To mitigate these risks, the following proactive strategies are recommended: (i) conducting comprehensive analysis and testing of PQC integration workflows, including component-level validation, interface compatibility checks, targeted vulnerability assessments, and the use of abstraction layers to isolate algorithmic intricacies from core BC operations; (ii) adopting secure coding practices and adhering to established cryptographic standards to reduce the risk of misconfiguration or flawed implementation; (iii) providing specialized training and development tools to help engineers manage the intricacies of PQC integration, particularly within verification mechanisms; and (iv) collaborating with quantum cryptography experts to audit and validate PQC components across the BC stack, ensuring correctness, resilience, and long-term maintainability. Report issue for preceding element
C.4. Maintaining Decentralization: The increased computational demands of quantum-resistant algorithms may inadvertently drive centralization, as only entities with access to powerful hardware can efficiently participate in transaction verification [ 27] . To preserve decentralization, the following strategies are recommended: (i) promoting the development of resource-efficient quantum-resistant algorithms compatible with a broad range of hardware; (ii) exploring consensus mechanisms that enable equitable participation despite high computational costs; and (iii) designing incentive structures that reward verification efficiency independently of hardware capabilities. Report issue for preceding element
VI-D Smart Contract
Report issue for preceding element
The shift to quantum-resistant algorithms within BC networks introduces a unique set of challenges for smart contracts. These challenges include potential security vulnerabilities arising from interactions with new algorithms, compatibility issues with existing smart contracts, and the need for user education regarding the transition. Addressing these challenges is crucial for ensuring the seamless integration and continued functionality of smart contracts in a quantum-secure environment.
Report issue for preceding element
D.1. Compatibility with Existing Smart Contracts: Upgrading existing smart contracts to utilize quantum-resistant algorithms might not be straightforward. This could lead to a situation where some contracts operate with the old cryptography while others adopt the new, potentially hindering interoperability and causing disruptions. To mitigate this, the following strategies are recommended: (i) developing migration tools and frameworks to enable seamless transitions [ 7] ; (ii) designing standardized wrappers or compatibility layers to facilitate interaction between legacy and quantum-resistant contracts, while managing potential performance overhead [ 8] ; and (iii) promoting modular and future-proof contract design to ease adaptation to evolving cryptographic standards [ 90] . Report issue for preceding element
D.2. User Education and Awareness: Users interacting with smart contracts must be aware of the transition to quantum-resistant algorithms and the potential risks of engaging with outdated, vulnerable contracts. To promote secure participation, the following strategies are recommended: (i) developing educational materials and awareness campaigns to encourage users to upgrade their wallets and tools for compatibility with quantum-resistant contracts [ 237] ; (ii) integrating warnings and notifications within applications to alert users about the risks of engaging with legacy contracts [ 237] ; and (iii) promoting best practices for secure interaction, including key management and contract verification prior to execution [ 238] . Report issue for preceding element
D.3. Zero-Day and Emergent Security Vulnerabilities: The integration of PQC primitives into smart contract code introduces a new class of risks: zero-day vulnerabilities (previously unknown exploitable flaws) [ 239, 240] and emergent issues arising from fundamental shifts in cryptographic assumptions. Unlike conventional smart contract vulnerabilities, these stem from the novel challenges of integrating PQC with existing BC infrastructure. These risks are amplified by the distinct computational and structural characteristics of post-quantum algorithms, the complexity of maintaining backward compatibility during migration, and the limited adversarial testing to date. While specific vulnerabilities cannot be anticipated, the integration process creates conditions conducive to unforeseen attack vectors, particularly in hybrid environments. To mitigate these risks, the following proactive measures are recommended: (i) conducting thorough audits and validation processes to identify vulnerabilities emerging from the interaction between smart contracts and quantum-resistant primitives [ 209, 208] ; (ii) developing and applying formal verification techniques to mathematically guarantee contract correctness and security in post-quantum environments [ 148, 149, 150] ; and (iii) establishing best practices for secure smart contract development, with an emphasis on minimizing attack surfaces during PQC integration. Report issue for preceding element
D.4. Performance Implications: Integrating quantum-resistant algorithms may degrade smart contract performance due to increased computational demands, potentially resulting in higher execution costs and longer processing times [ 241] . To mitigate these issues, the following strategies are recommended: (i) optimizing smart contract code by reducing complexity, minimizing redundant computations, and improving data structures; (ii) batching multiple transactions into single operations to reduce on-chain activity and alleviate congestion [ 165] ; (iii) refining quantum-resistant algorithms to reduce computational overhead and enhance runtime efficiency; (iv) offloading computations off-chain where feasible to minimize on-chain processing [ 164, 107] ; (v) enabling modular and asynchronous execution of smart contracts to allow independent task processing and increase throughput; and (vi) benchmarking and monitoring smart contract performance regularly to identify and resolve bottlenecks. Report issue for preceding element
D.5. Regulatory Considerations Report issue for preceding element The transition to quantum-resistant cryptography introduces regulatory challenges that require proactive compliance. Organizations must align with evolving legal standards to mitigate operational and reputational risks [ 242, 8] . Recommended actions include: (i) staying informed about regulatory developments in quantum-resistant cryptography and BC technologies; (ii) engaging with policymakers and industry groups to help shape practical, forward-looking regulations; and (iii) implementing compliance frameworks that anticipate and align with emerging regulatory standards. Report issue for preceding element
VI-E User Wallet
Report issue for preceding element
The transition to quantum-resistant BC presents specific challenges for user wallets, which are critical interfaces for users to access and manage their digital assets. Ensuring a seamless and secure transition is paramount to maintain user trust and the integrity of the BC ecosystem. In the following, we examine the primary challenges and propose solutions to facilitate this transition.
Report issue for preceding element
E.1. Wallet Compatibility and Security Upgrades: Existing user wallets might not be compatible with the new quantum-resistant cryptography. This leaves users vulnerable to potential attacks that exploit weaknesses in older cryptographic algorithms [ 2, 1, 190] . To ensure secure and seamless transitions, the following strategies are recommended: (i) developing clear upgrade paths and detailed guidance to support users migrating to quantum-resistant wallets; (ii) implementing backward-compatible solutions where feasible to maintain continuity during migration; (iii) promoting adoption of standardized quantum-resistant protocols among wallet developers to preserve interoperability; and (iv) enhancing security through multi-signature wallet configurations that require multiple keys to authorize transactions. Report issue for preceding element
E.2. User Education and Awareness: In the context of user adoption [ 243] , individuals might be hesitant or unaware of the need to upgrade their wallets, potentially leaving them vulnerable even after the transition to quantum-resistant algorithms. To promote informed adoption, the following strategies are recommended: (i) launching educational campaigns to highlight the importance of transitioning to quantum-resistant wallets and their security benefits; (ii) integrating intuitive prompts and automated update mechanisms into wallet applications to support seamless user migration; and (iii) providing accessible resources, such as tutorials and FAQs, to assist users throughout the upgrade process. Report issue for preceding element
E.3. Maintaining User Experience: Upgrading wallets and potentially adopting new functionalities related to quantum-resistant cryptography might introduce complexities that could hinder user experience [ 244] . To maintain a seamless user experience, the following strategies are recommended: (i) designing wallet interfaces that integrate enhanced security features while maintaining simplicity and user-friendliness; (ii) conducting usability testing to identify and resolve issues stemming from the integration of quantum-resistant elements; and (iii) implementing security enhancements in a transparent manner to minimize disruptions to users' typical interactions with the wallet. Report issue for preceding element
VII Hybrid BC Architectures
Report issue for preceding element TABLE XV: Hybrid Signature Strategies
Combiners
Mathematical Definition
Pros
Cons
Concatenation [ 245]
S  i  g  n h  y  b  r  i  d = σ 1 ∥ σ 2 Sign_{hybrid}=\sigma_{1}|\sigma_{2} , where
• σ i = Sign i  ( s  k i , m ) \sigma_{i}=\text{Sign}{i}(sk{i},m)
•
Supports lightweight operations, simple logic, and easy implementation.
• Retains unforgeability when both signature algorithms are unforgeable.
•
Does not support non-separability property for both signature algorithms.
Weak Nesting [ 245]
S  i  g  n h  y  b  r  i  d = Sign 2  ( s  k 2 , σ 1 ) Sign_{hybrid}=\text{Sign}{2}(sk{2},\sigma_{1}) , where
• σ 1 = Sign 1  ( s  k 1 , m ) \sigma_{1}=\text{Sign}{1}(sk{1},m)
•
Preserves unforgeability when the first signature algorithm is unforgeable.
• Supports non-separability property for the second signature algorithm.
•
Unforgeability of weak nesting depends crucially on the unforgeability of the first signature scheme.
Strong Nesting [ 245, 10]
S  i  g  n h  y  b  r  i  d = ( σ 1 , σ 2 ) Sign_{hybrid}=(\sigma_{1},\sigma_{2}) , where
• σ 1 = \sigma_{1}= Sign 1  ( s  k 1 , m ) \text{Sign}{1}(sk{1},m) and
• σ 2 = \sigma_{2}= Sign 2  ( s  k 2 , m ∥ σ 1 ) \text{Sign}{2}(sk{2},m\mathbin{|}\sigma_{1})
•
Retains unforgeability when both signature algorithms are unforgeable.
• Preserves non-separability property for the second signature algorithm.
•
Caution needed with Strong Nesting due to potential signature leaks from one of its underlying schemes.
Dual Nesting [ 245]
S  i  g  n h  y  b  r  i  d = ( σ 1 , σ o  u  t  e  r ) Sign_{hybrid}=(\sigma_{1},\sigma_{outer}) , where
• σ 1 = Sign 1  ( s  k 1 , m 1 ) \sigma_{1}=\text{Sign}{1}(sk{1},m_{1}) and
• σ o  u  t  e  r = Sign 1  ( s  k 1 , Sign 2  ( s  k 2 , m 2 ) ) \sigma_{outer}=\text{Sign}{1}(sk{1},\text{Sign}{2}(sk{2},m_{2}))
•
Preserves unforgeability of each message under its corresponding signature scheme.
• Retains unforgeability of both messages when the outer signature scheme is unforgeable.
•
Not designed to provide the unforgeability of both messages under either signature scheme.
Report issue for preceding element
The transition to PQC poses a fundamental dilemma for BC networks. An immediate and comprehensive migration is technically demanding and financially costly, with the potential to degrade the performance of high-throughput financial BCs that process millions of transactions per day. Conversely, postponing migration exposes networks to Harvest-Now, Decrypt-Later (HNDL) attacks [ 246] , whereby adversaries intercept and archive encrypted data with the objective of future decryption once large-scale QC becomes viable. Hybrid BC architectures have emerged as a pragmatic solution to this challenge [ 245, 29] , combining classical and PQC primitives such that the compromise of one cryptographic scheme does not immediately undermine overall system security. By selectively integrating PQC into critical BC components, hybrid approaches preserve operational performance and ecosystem compatibility while incrementally strengthening resilience throughout the quantum transition [ 6, 2, 247] .
Report issue for preceding element
This section develops a comprehensive framework for hybrid BC architectures, systematically categorizing them into composite and non-composite paradigms based on their cryptographic integration strategies. We analyze their respective trade-offs, implementation complexity, and scalability implications, with emphasis on cryptographic combiners, selective verification, interoperability, and consensus integrity. The analysis examines practical deployment factors including performance overhead, migration pathways, and backward compatibility requirements. By synthesizing theoretical foundations with implementation challenges, this framework provides a structured reference for researchers and practitioners navigating BC security decisions in the quantum era.
Report issue for preceding element
VII-A Hybrid Strategies for Cryptographic Primitives
Report issue for preceding element
Hybrid cryptographic strategies facilitate secure BC migration by combining classical and PQC schemes through mathematically rigorous combiners, providing both crypto-agility [ 248, 84] and defense-in-depth [ 29] . Hybrid strategies for digital signatures, the most critical primitives in the BC ecosystem, integrate multiple independent signatures via structured combiners to preserve unforgeability against adaptive chosen-message attacks [ 9, 10] . The principal approaches (Table XV) include: Concatenation, a direct combination with simple implementation, which preserves security as long as at least one scheme remains secure; Weak Nesting [ 245] , a sequential composition that reduces implementation cost but inherits dependence on the inner scheme; Strong Nesting [ 245, 10] , which dual-signs each message to ensure unforgeability and non-separability as long as one scheme remains quantum-resistant; and Dual Nesting [ 245] , which extends nesting to multi-message and heterogeneous BC architectures at the expense of added complexity. Combiner selection must balance security guarantees, computational overhead, and deployment feasibility. Strong Nesting delivers the strongest resilience but increases verification costs. Concatenation provides implementation simplicity and robustness as long as one scheme remains secure, though at the cost of signature size. Weak Nesting simplifies deployment yet inherits vulnerabilities from the inner scheme. Dual Nesting offers flexibility for heterogeneous or multi-message contexts, though with greater complexity. These trade-offs highlight the importance of aligning combiner selection with BC-specific requirements for performance, scalability, and interoperability.
Report issue for preceding element
VII-B Architectural Design Approaches
Report issue for preceding element
Building on the hybrid cryptographic strategies outlined above, two principal hybrid BC paradigms have emerged: composite and non-composite. These paradigms differ in how classical and post-quantum primitives are integrated, either within unified structures or across distinct operational domains, each offering trade-offs tailored to specific migration strategies, performance constraints, and security models.
Report issue for preceding element
B.1. Non-Composite Architecture: The non-composite or dual BC architecture employs a dual-network strategy, maintaining two independent BC networks with distinct cryptographic implementations and optimized consensus mechanisms. This approach provides clear security boundaries, enables specialized optimization for different cryptographic paradigms, and facilitates a structured migration path to quantum resistance while preserving complete decentralization. The architecture addresses the fundamental trade-off between performance and quantum security by allowing users to choose between networks based on their security requirements and risk tolerance. Report issue for preceding element
B.1.1. Architecture Components and Design Principles: The non-composite architecture comprises two independent BC networks: (a) a classical BC network and (b) a post-quantum BC network. These networks are bridged through a dedicated cross-chain interoperability framework that enables secure coordination and asset transfers between the classical and post-quantum environments. Report issue for preceding element Quantum-Safe Cross-Chain Coordination Layer Tier 1: PQ-HTLCs Tier 2: Commitment Protocols Tier 3: Decentralized PQ Oracles Cross-Ledger Operations SECURITY ASSURANCE CLASSICAL SECURITY ASSURANCE QUANTUM-SAFE Classical Cryptography Blockchain Ledger Node • ECDSA Signatures • SHA-256 Hashing • 3,000 TPS Post-Quantum Cryptography Blockchain Ledger Node • Dilithium Signatures • SHA-3 Hashing • 10–16 TPS Report issue for preceding element Figure 8: Non-Composite BC Architecture: A Dual-Public Ledger Design with Quantum-Safe Cross-Chain Interoperability. Report issue for preceding element The classical BC network handles existing applications, high-frequency transactions, and users prioritizing performance and compatibility. It utilizes established classical cryptographic standards such as ECDSA for digital signatures, SHA-256 for hashing, and proven consensus mechanisms like PoW or PoS. This network maintains full compatibility with existing tooling, wallets, and applications while providing optimal throughput and minimal computational overhead. However, its reliance on classical cryptography makes it increasingly vulnerable to quantum attacks as QC technology advances. The post-quantum BC network serves security-conscious users, high-value transactions, and long-term asset storage requiring quantum resistance. It leverages PQC algorithms such as CRYSTALS-Dilithium for digital signatures, quantum-resistant hash functions like SHA-3 with extended output lengths, as suggested by NIST [ 11] , and consensus mechanisms adapted for PQC. This network implements quantum-resistant address generation, transaction formats, and state management optimized for long-term security against quantum adversaries. Report issue for preceding element The cross-chain interoperability framework enables seamless asset and data transfer between networks through quantum-resistant bridge protocols [ 232] . The interoperability layer can be implemented through three core mechanisms: (1) Quantum-Resistant Atomic Swaps utilizing post-quantum Hash Time-Locked Contracts (HTLCs), which retain the structure of classical HTLC [ 249] but replace standard hash functions with longer variants resistant to quantum (e.g. SHA-3 with 512 bit, as suggested in [ 11] ) to withstand Grover's algorithm [ 250] . (2) Cross-Chain Bridge Validators operating quantum-resistant multi-signature schemes where validator sets can verify transactions from both classical ECDSA and post-quantum signature schemes, ensuring atomic execution across networks [ 251, 252] ; (3) Hybrid Oracle Networks providing cross-chain state verification through decentralized oracle networks using post-quantum digital signatures and threshold cryptography to prevent single points of cryptographic failure. Report issue for preceding element In the above approach, both networks maintain complete decentralization, and there's no performance degradation from hybrid cryptography integration. Users can migrate between networks based on their evolving security needs, as each network is optimized specifically for its cryptographic approach. This also facilitates market-driven adoption without mandatory transitions and provides effective risk isolation between classical and quantum-resistant operations. Report issue for preceding element Bridge security is paramount, as the interoperability layer represents the primary attack surface. Cross-chain transactions inherit the security properties of both underlying networks and the bridge protocol, necessitating careful design of atomic swap mechanisms, validator incentives, and dispute resolution protocols. This architecture supports gradual migration as quantum threats emerge, all while preserving full backward compatibility and user choice throughout the transition period. Figure 8 illustrates this dual-network architecture, detailing the cross-chain transaction flow and interoperability mechanisms between the classical and post-quantum BC networks. Report issue for preceding element
B.1.2. Case Study - Dual- BC CBDC Architecture for Quantum Transition: To demonstrate the viability of non-composite BC architectures in quantum-safe financial infrastructures, we present a conceptual case study, EuroChain, inspired by the coexistence and migration strategies analyzed by Weinberg et al. [ 253] . While their work does not propose a specific implementation, it outlines essential cryptographic primitives (e.g., MPC, OT) and architectural requirements for parallel classical and post-quantum digital currencies. Building on this foundation, EuroChain models a dual-ledger CBDC architecture comprising two fully decentralized public BCs: EuroChain-Classical, optimized for high-throughput retail payments (3,000–5,000 TPS) using ECDSA and SHA-256; and EuroChain-PQC, a quantum-resilient ledger secured with CRYSTALS-Dilithium-3 and SHA3-384, tailored for high-security use cases such as interbank settlements and long-term digital asset custody (50–100 TPS with 128-bit security). This architecture reflects the non-composite paradigm, where classical and post-quantum operations are handled by separate chains, preserving cryptographic isolation and enabling performance-security optimization without hybridization. Users can dynamically select the appropriate ledger based on risk, latency, or compliance needs, supporting market-driven migration without centralized enforcement. A quantum-safe coordination layer ensures secure interoperability between chains via three mechanisms: (1) quantum-safe HTLCs for atomic swaps with calibrated timeouts, utilizing NIST-recommended quantum-safe hash functions, such as SHA3-512, as suggested in [ 11] ; (2) hybrid bridge validators supporting both ECDSA and Dilithium with slashing/staking guarantees; and (3) decentralized oracle networks leveraging BLS aggregation and verifiable delay functions for state synchronization. While EuroChain introduces implementation-level assumptions beyond those in [ 253] , it operationalizes their proposed principles into a dual-chain, non-composite framework suitable for gradual, decentralized quantum transition in digital currency ecosystems. Report issue for preceding element
B.2. Composite Architecture: The composite BC integrates classical and PQC functionalities within a single, unified ledger. This approach prioritizes simplicity and seamless integration, offering robust security through cryptographic redundancy, facilitating gradual migration, and maintaining a consolidated ledger structure. Report issue for preceding element
B.2.1. Architecture Design and Implementation: This unified ledger strategy employs three key design principles: (a) integrated block structure, (b) dual cryptographic operations within each block, and (c) a unified consensus mechanism. Each block incorporates integrated sections dedicated to both classical and post-quantum cryptography. This structure enables simultaneous support for multiple cryptographic schemes, allowing transactions to select appropriate security levels based on their requirements, thereby eliminating the need for separate ledgers. Report issue for preceding element To ensure robustness against both classical and quantum adversaries, the architecture applies dual cryptographic operations. Following the hybrid strategies outlined in Subsection VII-A, both classical and post-quantum cryptographic methods are applied in parallel within each transaction block and combined using the cryptographic combiners described therein. Composite architectures may, for instance, employ co-signing techniques where each transaction includes both a classical (e.g., ECDSA) and a post-quantum (e.g., Dilithium) signature, validated in parallel. This ensures resilience against both threat models and facilitates a seamless transition to quantum-safe infrastructures without compromising interoperability or performance predictability. During the transition period, a relaxed hybrid verification policy may be adopted, accepting a transaction if either the classical or post-quantum signature is valid. This facilitates backward compatibility with legacy systems and enables incremental adoption of PQC. However, such a strategy inherently limits security to the weaker of the two schemes. If classical signatures are rendered forgeable (e.g., by quantum adversaries), the hybrid signature becomes insecure unless post-quantum verification is mandated and classical-only acceptance is gradually deprecated. Report issue for preceding element Block N-1 Block N Block N+1 \faHashtag \faHashtag SECURITY ASSURANCE QUANTUM-SAFE SECURITY ASSURANCE CLASSICAL Combiner SECURITY ASSURANCE QUANTUM-SAFE SECURITY ASSURANCE CLASSICAL Combiner SECURITY ASSURANCE QUANTUM-SAFE SECURITY ASSURANCE CLASSICAL Combiner Overall System Security Transaction-Level Block Header Tx 1 : ( msg 1 , Sig 1 PQC ∘ Sig 1 Classic ) \text{Tx}{1}:(\text{msg}{1},\text{Sig}{1}^{\text{PQC}}\circ\text{Sig}{1}^{\text{Classic}}) Tx 2 : ( msg 2 , Sig 2 PQC ∘ Sig 2 Classic ) \text{Tx}{2}:(\text{msg}{2},\text{Sig}{2}^{\text{PQC}}\circ\text{Sig}{2}^{\text{Classic}}) Tx 3 : ( msg 3 , Sig 3 PQC ∘ Sig 3 Classic ) \text{Tx}{3}:(\text{msg}{3},\text{Sig}{3}^{\text{PQC}}\circ\text{Sig}{3}^{\text{Classic}}) Block Footer ∘ \circ : Hybrid Combiner Detail of Block N+1 Report issue for preceding element (a) Report issue for preceding element A B C D Composite Cryptographic System • Hybrid Signatures • Quantum-safe Hashing • Integrated Security Layer Composite Cryptographic System • Hybrid Signatures • Quantum-safe Hashing • Integrated Security Layer Composite Cryptographic System • Hybrid Signatures • Quantum-safe Hashing • Integrated Security Layer Composite Cryptographic System • Hybrid Signatures • Quantum-safe Hashing • Integrated Security Layer Unified Consensus Mechanism Validates, Orders & Commits Creates Proposed/Validated Blocks for BC BC Ledger (Output of Consensus) Block N Tx1: A→B Hybrid: RSA+Dilithium Hash: SHA-3 Tx2: C→D Hybrid: ECDSA+Falcon Hash: BLAKE3 Block N+1 Tx3: B→C Hybrid: Ed25519+SPHINCS+ Hash: SHA-3 Tx4: D→A Hybrid: P-256+Dilithium Hash: BLAKE3 Block N+2 Tx5: A→C Hybrid: RSA+Dilithium Hash: SHA-3 Tx6: B→D Hybrid: P-384+Falcon Hash: BLAKE3 Composite Channels (Data + Hybrid Signatures) Consensus Process (Input → \rightarrow Validation → \rightarrow Output) Blockchain (Immutable Ledger) Hybrid Sig Transaction Block Report issue for preceding element (b) Report issue for preceding element Figure 9: Composite BC Architectures. (a) Block Structure: Each transaction incorporates both post-quantum and classical signatures, combined through cryptographic combiners for unified security assurance. (b) System Workflow: Participants submit hybrid-signed transactions through a unified consensus mechanism that validates and records them on the ledger. Report issue for preceding element To accommodate smart contract platforms (e.g., Ethereum), composite ledgers must extend virtual machine capabilities to support dual-signature verification, cryptographic combiners, and runtime selection based on transaction-level security policies. For backward compatibility during transition, composite blocks can define optional PQC segments interpretable only by upgraded nodes, allowing classical-only participants to process legacy transactions without disruption. Cryptographic agility should also be supported via per-transaction algorithm negotiation, enabling future upgrades without hard forks or complete protocol redesign [ 25] . While enabling robust security, the protocol-layer complexity introduced by signature verification redundancy and consensus logic must be managed through modular design and formal verification to prevent new attack surfaces. Unlike the non-composite approach, the composite architecture maintains a single unified consensus pipeline that validates both classical and post-quantum transactions. This simplification streamlines network operations and eliminates synchronization issues inherent in multi-ledger systems. Figure 9 illustrates two complementary perspectives: (a) a structural view of block-level hybrid cryptographic segmentation and combiners; (b) a system-wide workflow of transaction flow, composite signature generation, consensus processing, and ledger formation. This dual-view highlights how hybrid strategies support post-quantum migration while ensuring backward compatibility and operational continuity. Report issue for preceding element
B.2.2. Supply Chain Case Study: Consider a hypothetical global supply chain consortium adopting the composite architecture to track products from manufacturing to retail. The system secures routine tracking updates with classical cryptography for efficiency, while critical events such as customs clearance or ownership transfers employ PQC for enhanced protection. The unified ledger simplifies integration with existing enterprise systems and seamlessly adapts for security-sensitive operations. Manufacturers can retain existing interfaces with minimal modifications, while customs authorities and financial institutions benefit from quantum-resistant safeguards for high-value transactions. A key advantage of the composite design is its transparency. Unlike the non-composite approach, users interact with a single ledger, and cryptographic mechanisms are applied automatically based on predefined policies and transaction attributes. This abstraction reduces user complexity while maintaining strong, context-aware security guarantees. Report issue for preceding element
VII-C Risk Assessment and Security Posture
Report issue for preceding element
Hybrid BC architectures enhance resilience during the transition to post-quantum security by leveraging cryptographic diversity. These architectures require transaction-level risk assessments based on the specific cryptographic primitives used for signing and verification. In composite architectures, each transaction is simultaneously protected by both classical and post-quantum cryptographic primitives, typically through dual signatures or dual-layer encryption. This design provides a defense-in-depth security posture: as long as at least one primitive remains secure, the transaction maintains its integrity. Accordingly, the effective transaction-level risk is determined by the stronger (i.e., lower-risk) of the two primitives:
Report issue for preceding element
Risk = min  ( Risk Classic , Risk PQC ) . \displaystyle\text{Risk}=\min(\text{Risk}{\text{Classic}},\text{Risk}{\text{PQC}}).
In non-composite architecture, risk evaluation must account for three distinct transaction types, each with different security properties and attack surfaces. The effective risk depends on the specific transaction type and cryptographic domains involved:
Report issue for preceding element
Risk = { Risk Classic , if t  x ∈ classic ledger only, Risk PQC , if t  x ∈ PQC ledger only, max  ( Risk Classic , Risk PQC ) + Risk Coord , if t  x spans both ledgers, \text{Risk}=\hskip-2.84544pt\begin{cases*}\text{Risk}{\text{Classic}},&if $tx\in$ classic ledger only,\ \text{Risk}{\text{PQC}},&if $tx\in$ PQC ledger only,\ \begin{aligned} \max(\text{Risk}{\text{Classic}},\text{Risk}{\text{PQC}})\ +,\text{Risk}_{\text{Coord}},\end{aligned}\hskip-5.69046pt&if $tx$ spans both ledgers,\end{cases*}
where Risk Coord \text{Risk}_{\text{Coord}} captures additional risk arising from cross-ledger coordination, including quantum-safe HTLCs, oracle dependencies, atomic swap mechanisms, and synchronization constraints. Formally, this coordination risk can be expressed as a function of its key contributing factors:
Report issue for preceding element
Risk Coord = f  ( Risk Oracle , Risk HTLC , Risk Sync , Risk Timeout ) . \text{Risk}{\text{Coord}}=f(\text{Risk}{\text{Oracle}},\text{Risk}{\text{HTLC}},\text{Risk}{\text{Sync}},\text{Risk}_{\text{Timeout}}).
This architecture supports risk segregation, enabling gradual migration and tiered security based on sensitivity and risk tolerance. However, it does not ensure system-wide minimum risk. Cross-ledger operations are particularly vulnerable to coordination failures, oracle compromise, and downgrade attacks that may force reliance on weaker cryptographic paths. Additional failure modes include partial transaction execution, timeout exposures, and architectural complexity that expands the attack surface.
Report issue for preceding element
VII-D Hybrid BC Architectures: Comparative Analysis, Design Challenges, and Strategic Pathways
Report issue for preceding element
Both non-composite and composite hybrid BC architectures offer quantum-resistant pathways with distinct trade-offs. Non-composite architectures achieve resilience through cryptographic isolation but face significant coordination complexity. Key challenges include dual ledger synchronization requiring complex middleware for transactional atomicity [ 254] , interoperability mismatches in signature schemes and data models [ 232] , and performance gaps causing finality delays where assets remain visible across chains [ 185] . Additional barriers include smart contract execution across heterogeneous domains [ 255, 256] , amplified computational, networking, and storage demands due to dual ledger maintenance—particularly under PQC key and signature workloads—and persistent cross-ledger synchronization challenges in non-composite chains. Strategic solutions include optimistic execution with PQC auditing, enabling rapid classical processing with provisional finality while PQC chains act as asynchronous verifiers. Dual-layer finality mechanisms [ 257] provide fast provisional confirmation for routine transactions and rigorous PQC verification for critical ones, with ML models dynamically setting thresholds [ 258, 259, 260, 261] . Selective PQC verification mirrors only high-risk transactions to PQC chains, supported by state checkpointing, cross-chain locking [ 250] , and unified ledger anchoring. Migration protocols [ 164, 107] ensure continuity during quantum threats through immediate fallback and secure state-preserving transitions.
Report issue for preceding element
Composite architectures streamline integration through unified ledgers but incur scalability challenges. Block sizes increase 60–80% from dual cryptographic operations, with ML-DSA signatures 38–52 × \times larger than ECDSA (2,420–3,309 vs. 64 bytes) [ 54] and ML-KEM keys 12.5–24.5 × \times larger than ECDH (800–1,568 vs. 64 bytes) [ 41] . These designs also depend on evolving PQC standards [ 11, 39] and require real-time performance optimization. Mitigation strategies include layered verification, where PQC validation is applied to high-value transactions while routine operations use classical cryptography, guided by ML-based risk assessment [ 262] . Robust auditing uses tamper-proof logs with adaptive criteria adjustment. Off-chain computation [ 164, 107] with recursive ZKPs [ 263, 264] mitigates the computational overhead of PQC verification, while time-lock mechanisms [ 249] ensure secure synchronization between off-chain computation and on-chain verification, and sidechain–mainchain coordination [ 233] preserves ledger consistency. Backward-compatible blocks [ 84, 248] embed PQC sections for upgraded nodes, validated by unified consensus across legacy and PQC schemes, with per-transaction algorithm negotiation enabling crypto-agility and upgrades without hard forks. Figure 10 summarizes the key comparative findings, maps design challenges to strategic pathways for both composite and non-composite hybrid BC architectures, and provides a roadmap for future research priorities.
Report issue for preceding element
Comparative Analysis Design Challenges Strategic Pathways Performance:
• PQC: 10-16 TPS [ 265]
• Classical: 1000+ TPS
• Cross-ledger sync latency [ 266] Block Size:
• 60-80% increase [ 54, 41]
• ML-DSA: 38-52 × \times larger [ 54]
• ML-KEM: 12.5-24.5 × \times larger [ 41] Security Strength:
• Composite:
• max \max (Classical,PQC)
• Non-composite:
• min \min (Public,Private) Trade-offs:
• Implementation complexity
• Operational flexibility
• Risk management approaches
• Cost structures
• Future adaptability Non-Composite Dual Ledger Coordination: Complex middleware for atomicity across divergent crypto primitives [ 254]
• State checkpointing with crypto summaries
• Cross-chain transaction locking [ 250]
• Unified ledger anchoring Cross-ledger interoperability: Signature schemes, key formats, data models, fee structure mismatches [ 232]
• Advanced coordination logic with rollback/ compensation/ timeout [ 255, 256]
• Asynchronous state updates with reconciliation Performance gaps: Classical vs PQC finality delays, state discrepancies [ 185]
• Optimistic execution + PQC auditing
• Automated rollback with fork resolution
• Fraud-proof mechanisms with incentives Synchronization issues: Smart contract execution across heterogeneous domains
• Dual-layer finality: fast provisional + rigorous PQC [ 257]
• ML-based dynamic thresholds using risk profiles [ 258, 259, 260, 261] Resource overhead: Computational/networking/storage affecting resource-constrained participants
• Selective PQC verification (critical transactions only)
• Off-chain computation with Merkle anchoring [ 164, 107] Migration complexity: Quantum compromise scenarios requiring system continuity
• Dual-chain fallback to PQC ledger
• State snapshot preservation
• Comprehensive migration protocols Composite Block size inflation: 60-80% increase; ML-DSA 38-52 × \times larger (2,420-3,309 vs 64 bytes); ML-KEM 12.5-24.5 × \times larger (800-1,568 vs 64 bytes) [ 54, 41]
• Layered verification: PQC for high-value, classical for routine
• ML-based classifiers for dynamic assignment
• Backward-compatible blocks with PQC sections PQC standards dependence: Evolving standards volatility, protocol modification security risks
• Per-transaction algorithm negotiation [ 84, 248]
• Tamper-proof auditing with accountability
• Threat-adaptive algorithms Dynamic performance optimization: Real-time throughput-latency-security balancing for varying crypto demands [ 267]
• Off-chain recursive ZKPs with on-chain attestations [ 164, 263, 264]
• Time-lock synchronization [ 249]
• Cross-environment consensus protocols Performance degradation: PQC 10-16 TPS vs 1000+ classical; cross-ledger sync latency [ 265, 266]
• Sidechain-mainchain coordination: classical routine, hybrid critical [ 233]
• Merkle proof validation with periodic state submissions
• Efficient communication for rapid discrepancy detection Migration complexity: Quantum threats without transaction history loss
• Freeze-and-migrate protocols for compromised sidechains
• Atomic migration ensuring secure transitions [ 251]
• Unified consensus validating both crypto types Report issue for preceding element
Figure 10: Hybrid BC Architectures: Design Challenges, and Strategic Pathways Report issue for preceding element TABLE XVI: Strategic Comparison of Composite and Non-Composite Hybrid BC Architectures: A Decision Framework
Report issue for preceding element
The selection between composite and non-composite hybrid BC architectures hinges on cryptographic strategy, operational constraints, security posture, and adaptability throughout the quantum transition. Table XVI provides a structured decision framework to align architectural choices with performance, scalability, and compliance objectives. Composite architectures are suited to ecosystems prioritizing interoperability, gradual PQC adoption, and unified auditing with cryptographic agility. They offer broad compatibility and per-transaction flexibility but face scalability limits from enlarged block sizes and dual-cryptographic processing. Non-composite architectures ensure strong security isolation and per-ledger performance optimization, but at the cost of higher complexity, cross-ledger latency, and operational overhead.
Report issue for preceding element
VIII Security Evaluation of Major BC Platforms
Report issue for preceding element
This section presents a detailed analysis of the potential impact of QC on major BC platforms, including Bitcoin [ 268] , Ethereum [ 269] , Ripple [ 270] , Litecoin [ 271] , and Zcash [ 272] , a privacy-focused cryptocurrency. The analysis examines their vulnerable components, assesses potential impacts, analyzes associated STRIDE threats, and provides an evaluation of likelihood, impact, and overall risk levels under the assumption of a sufficiently advanced QC environment. Table XVII offers a consolidated reference for understanding these implications.
Report issue for preceding element
TABLE XVII: Impact of Quantum Computing on Major BC Platforms
Platform
Vulnerable Components
Potential Impacts
STRIDE Threats
L
I
R
Mitigation Strategies
Bitcoin
•
ECDSA: Used for digital signatures.
• SHA-256: Used for hashing blocks.
•
Forgery of digital signatures, enabling unauthorized spending.
• Breaking collision resistance of SHA-256, disrupting mining and block verification.
•
Spoofing: Impersonation through compromised signatures
• Tampering: Alteration of transaction data or blocks
• Repudiation: Disputes arising from forged transactions
• DoS: Mining and consensus disruption
• Elevation of Privilege: Unauthorized network control through compromised keys
H
H
H
•
Transition to quantum-resistant signature schemes
• Transition to a stronger hash function
• Develop quantum-resistant PoW or use alternative approaches such as proof-of-space or memory-hard PoW to mitigate quantum mining advantages.
Ethereum
•
ECDSA: Used for digital signatures.
• Keccak-256: Used for hashing transactions and blocks.
• Elliptic Curve Integrated Encryption Scheme (ECIES): Encrypts communication (less common).
•
Signature forgery and potential disruption of consensus mechanism.
• Breach of encrypted communication.
• Tampering with smart contract states or inputs.
•
Spoofing: Identity impersonation via ECDSA compromise
• Tampering: Block manipulation by breaking Keccak-256
• Repudiation: Disputes from forged or altered transactions
• Information Disclosure: Leaked data through broken ECIES encryption
• DoS: Quantum attacks degrading network operations
• Elevation of Privilege: Unauthorized access to smart contracts
H
H
H
•
Migration to quantum-resistant signature schemes
• Replace ECIES with a post-quantum KEM
• Use a higher-security hash function in block hashing
• Formal verification of smart contracts to eliminate vulnerabilities
• Develop quantum-resistant smart contract libraries and frameworks
Ripple
•
ECDSA: Used for digital signatures.
• SHA-256: Used for hashing transactions.
•
Unauthorized manipulation of transactions and account balances.
• Limited relevance for Information Disclosure due to Ripple's simpler metadata structure.
•
Spoofing: Forged transactions through signature compromise
• Tampering: Manipulation of transaction data
• Repudiation: Disputes arising from altered balances
• DoS: Attacks exploiting consensus mechanisms
• Elevation of Privilege: Misuse of validator roles via key compromise
H
H
H
•
Similar mitigation strategies as Bitcoin and Ethereum
• Explore alternative consensus mechanisms less vulnerable to quantum attacks (e.g., voting-based consensus algorithms)
• Strengthen validator key management to prevent privilege escalation.
Litecoin
•
Scrypt: Memory-intensive PoW hashing algorithm (more ASIC-resistant than SHA-256).
• ECDSA: Used for digital signatures.
•
Scrypt provides some resistance, but QC can break it.
• ECDSA is vulnerable to signature forgery.
• Enhanced quantum mining could enable 51% attacks.
• Mining disruptions may cause DoS on the network.
•
Spoofing: Identity theft through signature compromise
• Tampering: Block alterations exploiting quantum vulnerabilities
• Repudiation: Forged transactions leading to disputes
• DoS: Mining disruption due to compromised algorithms
• Elevation of Privilege: Unauthorized control of mining resources
H
H
H
•
Research on memory-hard hashing functions secure against classical and quantum attacks
• Adopt quantum-resistant signature schemes to replace ECDSA.
• Explore quantum resistant alternative for PoW mechanisms such as proof-of-space or memory-hard PoW models to enhance resistance.
• Evaluate Scrypt's quantum resilience and improve hashing where necessary.
Zcash (Privacy Coin)
•
Standard Transactions:
• ECDSA/SHA-256: Used for signatures and hashing, similar to Bitcoin.
•
Vulnerable to signature forgery and block tampering.
•
Spoofing: Signature forgery enabling identity theft
• Tampering: Modification of transaction data
• Repudiation: Disputes from altered or forged transactions
• DoS: Disruption of standard transaction processing
H
H
H
•
Transition from ECDSA to post-quantum signature schemes (e.g., lattice-based cryptography)
• Replace SHA-256 with SHA-512 or alternatives such as SHA-3 [ 11]
•
Shielded Transactions:
• Groth16 zk-SNARKs ∗ (Elliptic curve and pairing-based cryptography): Used for private transactions.
• ECC-based key generation: Supports Groth16 and transaction privacy.
•
Loss of anonymity if Groth16 is broken by quantum attacks.
• Potential manipulation of shielded transactions if proofs or keys are compromised.
• Disruption of shielded transaction validation due to computational overload.
•
Information Disclosure: Loss of privacy due to ZKP compromise
• Tampering: Unauthorized modification of shielded transactions
• Repudiation: Disputes from forged proofs
• DoS: Disruption of shielded transaction processing
• Elevation of Privilege: Exploiting ZKP weaknesses to gain unauthorized control
H
H
H
•
Research and implement post-quantum zk-SNARKs (e.g., Virgo [ 273] , Ligero [ 274] and Aurora [ 275] ) and post-quantum signatures.
• Develop fallback mechanisms to handle computational overload or proof failures
• Enhance network-wide transition plans to quantum-resistant cryptography ∗
In May 2022, Zcash introduced the Orchard shielded payment protocol with Network Upgrade 5 (NU5), using the Halo 2 zero-knowledge proving system. Halo 2 removes the trusted setup and supports scalable private payments. While it improves efficiency over previous zk-SNARKs like Groth16, its security depends on assumptions not proven secure against quantum attacks.
Report issue for preceding element
Report issue for preceding element
It is important to emphasize that the likelihood ratings assigned in the Table represent a scenario in which large-scale quantum computers are available and capable of breaking or weakening current cryptographic primitives. Our earlier analysis (Figure 5) indicates that the expected likelihood of such powerful quantum threats remains relatively low in the short term (within the next 10 years), increases to a medium level by around 15 years, and becomes high beyond a 20-year horizon. Thus, the High likelihood ratings in Table XVII should be interpreted as long-term projections rather than immediate certainties. In the near term, due to the limited maturity of QC, these threats are far less likely to materialize.
Report issue for preceding element
VIII-A Security Evaluation of Major BC Platforms: Lessons Learned and Strategic Roadmap
Report issue for preceding element
Comparative evaluation shows that major BC platforms share fundamental quantum vulnerabilities despite architectural differences. All analyzed platforms (Bitcoin, Ethereum, Ripple, Litecoin, Zcash) critically depend on ECDSA digital signatures, which Shor's algorithm could break, enabling signature forgery and unauthorized transactions. Their underlying hash functions also face quantum-accelerated attacks via Grover's algorithm: Bitcoin and Ripple rely on SHA-256, Ethereum uses Keccak-256, and Litecoin employs Scrypt for mining, offering only partial resistance.
Report issue for preceding element
Platform-specific risk profiles require tailored mitigation. Bitcoin has unique exposure with about 30% of total supply in public-key-revealed addresses, combined with mining centralization risks if SHA-256 is broken. Ethereum adds complexity through its smart contract ecosystem, gas-constrained environments affecting post-quantum signature verification efficiency, and DeFi applications requiring quantum-resistant privacy mechanisms. Ripple's semi-centralized validator model creates governance-based risks if validator keys are compromised. Litecoin benefits from Scrypt's partial quantum resistance but remains vulnerable to signature-based attacks and potential quantum mining acceleration. Zcash combines standard transaction vulnerabilities with privacy-specific threats, as Groth16 zk-SNARK or Halo 2 breaks could compromise anonymity and shielded transaction integrity.
Report issue for preceding element
Strategic roadmap priorities by platform: (i) Bitcoin: develop migration protocols for exposed public-key addresses (~30% of total supply), transition from SHA-256 to quantum-resistant alternatives (e.g., SHA-512 or lattice-based PoW), and deploy backward-compatible post-quantum signature schemes preserving operational continuity; (ii) Ethereum: implement gas-efficient lattice-based signature verification [ 276] , develop quantum-secure smart contract infrastructures, and integrate post-quantum ZKPs for privacy-preserving DeFi applications operating within gas-constrained environments [ 277] ; (iii) Ripple: establish quantum-resistant validator selection mechanisms and consensus protocols resilient to quantum adversaries while ensuring performance [ 278] ; (iv) Litecoin: assess and enhance Scrypt's quantum resistance while exploring ASIC-resistant, memory-hard PoW alternatives; (v) Zcash: develop and integrate advanced post-quantum ZKPs (Virgo, Ligero, Aurora), implement privacy-preserving lattice-based commitments [ 279] , and deploy quantum-resistant ring signatures [ 280] to uphold transactional anonymity.
Report issue for preceding element
Cross-platform strategies should include cryptographic agility frameworks for modular algorithm replacement, standardized migration protocols for ecosystem-wide adoption, quantum-secure interoperability enabling safe cross-chain communication, and emergency response mechanisms for rapid cryptographic updates in the face of quantum breakthroughs. These coordinated measures are essential to maintain BC integrity, trust, and availability in the quantum era.
Report issue for preceding element
IX Post-Quantum BCs: Current Availability and Their Roles
Report issue for preceding element TABLE XVIII: Post-Quantum BC Platforms: Features, Applications, and STRIDE Threats with Corrected Risk Assessment
Permissioned Public: Publicly accessible for reading/interacting, but validator roles require authorization by a governing body. ∗∗
In April 2021, they transitioned to using EdDSA as their digital signature, replacing W-OTS.
Report issue for preceding element
Report issue for preceding element
As the threat of QC intensifies, BC projects are increasingly integrating PQC to future-proof their systems. This evolution addresses critical challenges such as integrating quantum-safe cryptography, managing performance trade-offs, and ensuring interoperability with existing BC platforms, all central to the themes discussed in this section. The evolutionary milestones of post-quantum BC platforms are depicted in Figure 11.
Report issue for preceding element
2014 2016 2018 2020 2022 2023 2024 2025 Komodo Atomic Swap Dev Begins QRL Development Begins Komodo Genesis Block Komodo Mainnet, dPoW & Atomic Swaps QRL PoW Mainnet QRL PoS Migration Tidecoin Falcon-512 Integration HCASH BLISS & DAG /PoW/PoS Komodo dPoW to Litecoin Abelian Privacy-focused PQC Coin QAN Hybrid PoR with Dilithium LACChain Falcon-512 Smart Contracts IOTA EdDSA Transition Nexus Layer 1 & Testnet III Report issue for preceding element
Figure 11: Timeline of Key Developments in Post-Quantum BC platforms Report issue for preceding element
Post-quantum BC platforms employ cryptographic algorithms designed to withstand quantum attacks, primarily leveraging lattice-based and hash-based schemes. Representative implementations include QRL [ 281] , Komodo [ 282] , Nexus [ 283] , Tidecoin [ 284] , Abelian [ 265] , LACChain [ 285] , QAN [ 286] , HCASH [ 287] , and IOTA [ 288] , with shared objectives of quantum-safe cryptographic integration, performance optimization, and interoperability assurance. Table XVIII comprehensively summarizes each platform's architecture, cryptographic primitives, applications, and risk assessments.
Report issue for preceding element
QRL adopts XMSS hash-based signatures for digital asset security, providing forward secrecy at the cost of larger signatures ( ∼ 2 \sim 2 KB versus 64 bytes for ECDSA). Komodo employs Dilithium lattice-based signatures for multi-chain smart contracts, balancing efficiency with post-quantum robustness. Nexus integrates FALCON signatures for decentralized routing, benefiting from compact signatures (666 bytes for FALCON-512) while demanding robust key management. Tidecoin combines FALCON-512 with CPU-efficient PoW consensus, maintaining hardware compatibility while mitigating quantum threats. Abelian leverages Dilithium to enhance cryptocurrency transaction privacy. LACChain incorporates post-quantum X.509 certificates and quantum-secure Transport Layer Security (TLS) protocols within a permissioned-public architecture, enabling public read access while restricting validator roles to authorized participants. QAN, a hybrid platform, combines Dilithium signatures with PoR consensus for smart contracts and DApps, offering operational flexibility but introducing cryptographic transition risks. HCASH merges BC and DAG structures using BLISS lattice-based signatures for secure cross-ecosystem data exchange. IOTA initially implemented probabilistic DAG-based consensus with W-OTS hash-based signatures optimized for IoT micro-transactions, but transitioned to EdDSA in April 2021, trading quantum resistance for operational efficiency, a decision that reintroduces elliptic curve vulnerabilities against future quantum attacks.
Report issue for preceding element
Post-quantum BC adoption faces significant implementation challenges. Performance overheads from larger cryptographic primitives (e.g., XMSS signatures exceeding 2 KB) increase computational demands, affecting transaction throughput and straining resource-constrained devices. Interoperability complexity emerges as hybrid systems combining classical and quantum-resistant methods introduce vulnerabilities during cryptographic transitions, requiring robust synchronization mechanisms as demonstrated by QAN's hybrid approach. Regulatory uncertainty compounds these challenges, as formal PQC integration guidelines for BC applications remain underdeveloped despite ongoing NIST standardization efforts for CRYSTALS-Dilithium and FALCON.
Report issue for preceding element
The likelihood and impact of security threats vary significantly across post-quantum BC platforms. For the post-quantum platforms analyzed in Table XVIII, QRL, Komodo, Nexus, Tidecoin, Abelian, LACChain, QAN, and HCASH exhibit Medium attack likelihood due to partial vulnerabilities: resource-intensive algorithms (XMSS, FALCON-512) enable DoS attacks but benefit from rate-limiting and limited user bases; multi-layer consensus architectures provide partial resilience despite complexity; mature codebases and network segmentation contain transition risks; privacy implementations may expose metadata if mishandled; permissioned models reduce external threats while remaining vulnerable to insider attacks; hybrid approaches face tampering during transitions but benefit from niche adoption; integrated architectures complicate data flow yet benefit from ecosystem isolation. IOTA faces High likelihood due to EdDSA's quantum vulnerability combined with extensive IoT deployment exposure.
Report issue for preceding element
Impact assessment shows Komodo and LACChain experience Medium disruption levels due to multi-chain design and controlled environments enabling effective breach containment and recovery. Other platforms (QRL, Tidecoin, Nexus, Abelian, QAN, HCASH, IOTA) face High impact from successful exploits, encompassing severe operational downtime, compromised cryptographic integrity, and significant reputational damage. These risk profiles underscore the critical importance of continuous security audits, robust governance frameworks, and proactive threat mitigation for quantum-safe BC ecosystems.
Report issue for preceding element
IX-A Post-Quantum BCs: Lessons Learned and Strategic Roadmap
Report issue for preceding element
Comparative evaluation demonstrates that algorithm choice, architectural design, and migration strategy jointly determine quantum resilience and operational viability. Hash-based signatures (XMSS [ 289] in QRL) provide strong forward security but incur bandwidth and storage penalties from large signatures ( > 2 >2 KB). Lattice-based deployments using Dilithium and FALCON (Komodo, Abelian, QAN, Nexus, Tidecoin) achieve compact signatures (666 bytes for FALCON-512) with superior performance yet require robust side-channel protections. Platforms using non-NIST primitives (BLISS in HCASH, quantum-vulnerable EdDSA in IOTA) face regulatory uncertainty and heightened exposure, underscoring migration urgency to standardized schemes.
Report issue for preceding element
Architectural choices strongly shape attack surfaces. Permissioned-public models (LACChain) reduce external threats but remain vulnerable to insider compromise, necessitating stronger governance. Multi-chain systems (Komodo) and DAG-based frameworks [ 126] (HCASH, IOTA) improve throughput but risk cross-chain spoofing, synchronization faults, and data tampering, requiring robust verification safeguards. Hybrid migration designs (QAN) offer flexibility but must harden defenses against rollback and privilege escalation during transitions. Early adopters (QRL, Komodo) gain operational maturity but risk cryptographic lock-in without crypto-agility mechanisms [ 248, 84] .
Report issue for preceding element
Strategic roadmap priorities by platform: (i) HCASH and IOTA: migrate from BLISS and EdDSA to NIST-approved schemes for compliance and quantum resistance; (ii) QRL: reduce XMSS overhead via signature compression and efficient state handling; (iii) Komodo, Abelian, QAN, Nexus, and Tidecoin: integrate hardware- and software-level side-channel protections without performance degradation [ 59, 80] ; (iv) QRL and Komodo: implement cryptographic agility mechanisms [ 248, 84] to prevent lock-in and facilitate future migrations; (v) Komodo, HCASH, IOTA, and QAN: strengthen cross-chain verification and synchronization safeguards [ 259, 126] to mitigate inter-network attack surfaces. These measures confirm that robust post-quantum BC security requires coordinated alignment of cryptographic primitives, architectural design, and migration strategy within a cohesive operational framework.
Report issue for preceding element
X Challenges and Future Research Directions
Report issue for preceding element
The convergence of BC with emerging technologies such as Web3 [ 290, 258] , quantum-enhanced AI [ 291, 292] , and advanced privacy-preserving cryptographic protocols [ 293] represents a fundamental transformation in decentralized computing. As QC capabilities mature, this convergence introduces novel security vulnerabilities requiring interdisciplinary research spanning cryptography, AI, and distributed systems design. Building upon the risk modeling framework in Section III, hybrid architectural designs in Section VII, and platform-specific evaluations in Sections VIII and IX, this section identifies critical challenges and priority research directions for quantum-resilient BC ecosystems.
Report issue for preceding element
X-A Quantum-Enhanced AI and BC Integration
Report issue for preceding element
The convergence of QC and AI presents both unprecedented security threats and transformative defensive opportunities for post-quantum BC systems [ 291] . Quantum Machine Learning (QML) enhances cryptanalysis by combining classical Machine Learning (ML) pattern recognition with quantum computational advantages, enabling adversaries to exploit statistical biases, solve large algebraic systems, and explore key spaces with greater efficiency. Quantum Deep Neural Networks (DNNs) uncover complex non-linear relationships between plaintext bits and side-channel leakages, amplifying differential and linear cryptanalysis. These capabilities are further reinforced through quantum algorithms such as the HHL algorithm [ 294, 295] for exponential speedups in sparse linear systems and the Quantum Approximate Optimization Algorithm (QAOA) [ 296] for combinatorial key recovery.
Report issue for preceding element
Quantum-enhanced cryptanalytic techniques pose distinct, scheme-specific challenges requiring tailored defenses across PQC families. Lattice-based schemes face accelerated basis reduction via quantum random walk-aided sieving, necessitating increased lattice dimensions and quantum-augmented proofs [ 297] . Code-based schemes are threatened by Grover-enhanced error pattern searches combined with deep learning side-channel analysis, requiring longer code lengths and obfuscation techniques [ 298, 299] . Hash-based cryptography is vulnerable to quantum-accelerated collision finding via amplitude amplification, mandating extended hash outputs and strict domain separation [ 300] .
Report issue for preceding element
Beyond cryptography, advanced AI introduces additional attack vectors against BC infrastructures [ 301] . These include automated smart contract vulnerability discovery, analysis of transaction patterns, identification of optimal conditions for consensus manipulation (e.g., 51% attacks in PoW or one-third threshold violations in BFT/ PoS), and orchestration of coordinated Sybil or Distributed Denial of Service (DDoS) attacks with adaptive real-time strategies [ 302, 303, 304] . Conversely, AI provides significant defensive capabilities [ 305, 306, 307, 260, 308] , including cryptographic parameter optimization, real-time anomaly detection, network intrusion prevention, and automated quantum-safe key lifecycle management [ 309] .
Report issue for preceding element
Several critical research areas require immediate attention to address the evolving quantum-AI threat landscape. These priorities include developing quantum-resistant adversarial training frameworks against adaptive quantum-classical attacks like SALSA on LWE schemes [ 310] , creating BC-specific AI auditing tools for decentralized validation, and designing AI-resistant cryptographic primitives. Furthermore, it is essential to implement zero-knowledge ML proof systems (i.e., ZKP protocols attesting to ML inference correctness and model integrity [ 311, 312] ) built on quantum-resistant lattice-based cryptography for zero-trust validation environments [ 263, 236] and establish ethical frameworks addressing data privacy and algorithmic bias as AI integrates with Web3 infrastructure.
Report issue for preceding element
X-B Web3, Quantum Security and Interoperability
Report issue for preceding element
Web3 technologies [ 290, 258] , including DeFi [ 157] , Non-Fungible Token (NFT) [ 313] , and metaverse platforms, face increasing threats from QC advancements that compromise cryptographic primitives. The "Harvest Now, Decrypt Later" attacks endanger long-term encrypted data, while adoption is hindered by high implementation costs, limited asset visibility, and deployment challenges. Decentralized governance complicates consensus on quantum-safe upgrades, and NIST standards require multi-stakeholder coordination amid a shortage of post-quantum expertise.
Report issue for preceding element
Vulnerabilities persist across core components: DID:Web standards [ 314] depend on quantum-vulnerable elliptic curves and SHA-256; oracles like Chainlink present centralized signing points of failure; and cross-chain bridges jeopardize Web3 composability. Mitigation strategies include hybrid cryptographic stacks, cryptographic agility for rapid PQC transitions, quantum-resistant signatures, and secure key exchange via quantum key distribution. Platforms such as Ethereum 3.0 and Hyperledger Ursa are already exploring PQC integration. Future research should prioritize the standardization of PQC-based decentralized identity protocols with cross-chain interoperability [ 232, 252] . Additionally, developing threshold PQC oracles utilizing MPC techniques can eliminate single points of failure [ 315] . Equally important is the formal verification of bridge protocols' security under quantum threat models [ 148, 149, 150] to ensure the stability of DeFi ecosystems and facilitate robust Web3 interoperability.
Report issue for preceding element
X-C Advanced Privacy-Preserving Cryptographic Systems
Report issue for preceding element
QC fundamentally undermines cryptographic privacy mechanisms crucial for BC applications. The majority of the current ZKPs, such as Groth16 zk-SNARK, depend on elliptic curve cryptography, which is vulnerable to quantum algorithms. Moreover, privacy-preserving computation requires homomorphic encryption schemes that are secure against quantum adversaries [ 316] , particularly for sensitive applications such as medical BC platforms. Future research in this domain should prioritize two key areas. Firstly, a comprehensive evaluation of quantum-secure ZKPs [ 263, 277] , particularly lattice-based constructions such as the LaZer Library implementations [ 236] , is essential. This evaluation should encompass an analysis of proof size scalability, computational complexity, and the trade-offs associated with their BC integration. Secondly, developing quantum-secure Homomorphic Encryption (HE) solutions [ 316] optimized for smart contract runtimes is critical [ 317] . HE enables privacy-preserving smart contracts through computations on encrypted data without exposure, though current schemes remain inefficient for production-scale deployment, necessitating research into practical quantum-resistant implementations.
Report issue for preceding element
X-D Federated Learning, Edge Computing, and IoT Integration
Report issue for preceding element
Federated Learning (FL) represents a decentralized paradigm that keeps sensitive data localized, reducing privacy risks [ 318] . When combined with BC and quantum cryptographic protocols, FL can significantly enhance data protection, especially in Internet of Things (IoT) ecosystems [ 217, 255, 319] . QC can optimize FL training through quantum-enhanced algorithms, strengthen encryption via quantum cryptography, enable efficient distributed data aggregation, and protect against inference-based attacks by disrupting adversarial pattern recognition [ 292] . BC provides decentralized, auditable coordination for FL networks [ 320, 318] , addressing malicious participant detection, data integrity verification, and single point of failure elimination. On the other hand, edge computing proliferation creates distributed attack surfaces requiring quantum-resistant cryptographic operations at edge nodes, including secure key management, authenticated firmware updates, and protected communication channels [ 23] . IoT deployments create vast attack surfaces with resource-constrained devices traditionally using lightweight cryptographic protocols [ 16] . The quantum threat amplifies IoT security challenges due to cryptographic update difficulties across large device populations, requiring novel approaches balancing security with practical deployment constraints [ 321] .
Report issue for preceding element
Research priorities include quantum-resistant protocols for secure FL aggregation, BC-based incentive mechanisms deterring adversarial behavior, privacy-preserving techniques protecting participant data against quantum adversaries, lightweight PQC implementations for resource-constrained edge devices [ 319] , distributed key management systems for edge networks, quantum-resistant IoT communication protocols, BC-based IoT identity management, and secure update mechanisms enabling PQC migration across IoT populations [ 16] .
Report issue for preceding element
X-E Interdisciplinary Technical and Standardization Challenges
Report issue for preceding element
Integrating PQC, ZKP, and AI into BC systems introduces considerable performance overhead, affecting throughput and transaction finality. These issues are magnified in quantum- AI and Web3 contexts, where latency-sensitive operations, such as ZKP generation, are especially impacted [ 258, 305, 320, 322] . Although NIST has standardized several quantum-resistant algorithms, notable gaps remain in BC-specific implementations, particularly those involving Web3 and AI. A critical barrier to adoption is the lack of interdisciplinary expertise across cryptography, distributed systems, and AI. Key research directions include hardware acceleration for PQC- ZKP stacks using GPUs and TPUs, quantum-aware BC sharding, and standardized performance benchmarks for Decentralized Application (DApp) environments. Coordinating across various standards including NIST, IEEE, ISO, IETF, and ETSI is essential to ensure interoperability. To address the skills gap, targeted educational programs, certification tracks, and collaborative academic-industry initiatives are needed. These directions are pivotal to preserving BC security as QC transitions from theory to deployment.
Report issue for preceding element
XI Conclusion
Report issue for preceding element
The convergence of BC technology and QC presents both formidable challenges and transformative opportunities. While quantum algorithms such as Shor's and Grover's pose systemic threats to cryptographic foundations, proactive defense and structured risk assessment can ensure the continued resilience of BC systems in the quantum era. Our analysis highlights that vulnerabilities extend across all components of the BC ecosystem, including networks, mining pools, transaction verification mechanisms, smart contracts, and user wallets. Leading platforms such as Bitcoin, Ethereum, Ripple, Litecoin, and Zcash must adopt multifaceted mitigation strategies. These include transitioning to NIST-standardized PQC algorithms, reinforcing consensus protocols to withstand quantum-enabled disruptions, and strengthening smart contract security through advanced analysis and verification techniques. Safeguarding BC infrastructures demands collective effort from developers, researchers, wallet providers, and governance bodies. Continuous monitoring of quantum advancements, combined with proactive migration to quantum-resistant cryptography, is essential for preserving trust and long-term viability. Hybrid migration strategies, balancing classical and post-quantum primitives, further enable secure adaptation while minimizing operational risks during transition. In summary, although QC poses a profound challenge, it also catalyzes innovation, collaboration, and standardization. Continued research in post-quantum cryptography, hybrid blockchain design, and quantum-aware security frameworks is critical for navigating this transition. By combining structured risk assessment, proactive defense, and cross-stakeholder collaboration, the BC ecosystem can achieve quantum resilience and sustain its role as a cornerstone of secure, decentralized digital infrastructure in the quantum era.
Report issue for preceding element
References
Report issue for preceding element
[1] ↑ J. J. Kearney and C. A. Perez-Delgado, “Vulnerability of blockchain technologies to quantum attacks,” Array, vol. 10, p. 100065, 2021.
[2] ↑ M. Allende, D. L. León, S. Cerón, A. Pareja, E. Pacheco, A. Leal, M. Da Silva, A. Pardo, D. Jones, D. J. Worrall et al., “Quantum-resistance in blockchain networks,” Scientific Reports, vol. 13, no. 1, p. 5664, 2023.
[3] ↑ P.. W. Shor, “Polynomial-time algorithms for prime factorization and discrete logarithms on a quantum computer,” SIAM Review, vol. 41, no. 2, pp. 303–332, 1999.
[4] ↑ L. K. Grover, “A fast quantum mechanical algorithm for database search,” in Proceedings of the twenty-eighth annual ACM symposium on Theory of computing, 1996, pp. 212–219.
[5] ↑ G. Brassard, P. Hoyer, and A. Tapp, “Quantum algorithm for the collision problem,” arXiv preprint quant-ph/9705002, 1997.
[6] ↑ D. Joseph, R. Misoczki, M. Manzano, J. Tricot, F. D. Pinuaga, O. Lacombe, S. Leichenauer, J. Hidary, P. Venables, and R. Hansen, “Transitioning organizations to post-quantum cryptography,” Nature, vol. 605, no. 7909, pp. 237–243, 2022.
[7] ↑ Cybersecurity, I. S. Agency, N. S. Agency, N. I. of Standards, and Technology, “Quantum-readiness: Migration to post-quantum cryptography,” August 2023.
[8] ↑ National Institute of Standards and Technology, “Migration to post-quantum cryptography quantum readiness: Testing draft standards,” Tech. Rep. SP 1800-38C (Preliminary Draft), December 2023.
[9] ↑ H.-Y. Kwon, I. Bajuna, and M.-K. Lee, “Compact hybrid signature for secure transition to post-quantum era,” IEEE Access, vol. 12, pp. 39 417–39 429, 2024.
[10] ↑ D. Ghinea, F. Kaczmarczyck, J. Pullman, J. Cretin, R. Misoczki, S. Kölbl, L. Invernizzi, E. Bursztein, and J.-M. Picod, “Hybrid post-quantum signatures in hardware security keys,” pp. 480–499, 2023.
[11] ↑ National Institute of Standards and Technology, “Transition to post-quantum cryptography standards,” https://csrc.nist.gov/pubs/ir/8547/ipd, Interagency Report NIST IR 8547 IPD, November 2024.
[12] ↑ C. Näther, D. Herzinger, S.-L. Gazdag, J.-P. Steghöfer, S. Daum, and D. Loebenberger, “Migrating software systems toward post-quantum cryptography-a systematic literature review,” IEEE Access, vol. 12, pp. 132 107–132 126, 2024.
[13] ↑ America's Cyber Defence Agency, “Post-quantum cryptography initiative,” https://www.cisa.gov/quantum, 2023.
[14] ↑ J. Leng, M. Zhou, J. L. Zhao, Y. Huang, and Y. Bian, “Blockchain security: A survey of techniques and research directions,” IEEE Transactions on Services Computing, vol. 15, no. 4, pp. 2490–2510, 2020.
[15] ↑ H. W. Lim and N. J. Buselli, “Managing risks and opportunities for quantum safe development,” NCS. Pte. Ltd and IBM Quantum, Tech. Rep., 2024.
[16] ↑ D. Chawla and P. S. Mehra, “A roadmap from classical cryptography to post-quantum resistant cryptography for 5G-enabled IoT: Challenges, opportunities and solutions,” Internet of Things, p. 100950, 2023.
[17] ↑ D. Van Landuyt and W. Joosen, “A descriptive study of assumptions in STRIDE security threat modeling,” Software and Systems Modeling, pp. 1–18, 2021.
[18] ↑ Y. Baseri, V. Chouhan, A. Ghorbani, and A. Chow, “Evaluation framework for quantum security risk assessment: A comprehensive strategy for quantum-safe transition,” Computers & Security, vol. 150, p. 104272, 2025.
[19] ↑ A. Wicaksana, “A survey on quantum-safe blockchain security infrastructure,” Computer Science Review, vol. 57, p. 100752, 2025.
[20] ↑ H. Khodaiemehr, K. Bagheri, and C. Feng, “Navigating the quantum computing threat landscape for blockchains: A comprehensive survey,” http://dx.doi.org/10.36227/techrxiv.24136440.v1, 2023.
[21] ↑ K. Kaushik and A. Kumar, “Demystifying quantum blockchain for healthcare,” Security and Privacy, vol. 6, no. 3, p. e284, 2023.
[22] ↑ H. Gharavi, J. Granjal, and E. Monteiro, “Post-quantum blockchain security for the internet of things: Survey and research directions,” IEEE Communications Surveys & Tutorials, 2024.
[23] ↑ A. Karakaya and A. Ulu, “A survey on post-quantum based approaches for edge computing security,” Wiley Interdisciplinary Reviews: Computational Statistics, vol. 16, no. 1, p. e1644, 2024.
[24] ↑ A. Kumar, S. Bhatia, K. Kaushik, S. M. Gandhi, S. G. Devi, A. D. J. Diego, and A. Mashat, “Survey of promising technologies for quantum drones and networks,” IEEE Access, vol. 9, pp. 125 868–125 911, 2021.
[25] ↑ Z. Yang, H. Alfauri, B. Farkiani, R. Jain, R. D. Pietro, and A. Erbad, “A survey and comparison of post-quantum and quantum blockchains,” IEEE Communications Surveys & Tutorials, vol. 26, no. 2, pp. 967–1002, 2024.
[26] ↑ A. Liu, X.-B. Chen, S. Xu, Z. Wang, Z. Li, L. Xu, Y. Zhang, and Y. Chen, “A secure scheme based on a hybrid of classical-quantum communications protocols for managing classical blockchains,” Entropy, vol. 25, no. 5, p. 811, 2023.
[27] ↑ Z. Yang, T. Salman, R. Jain, and R. Di Pietro, “Decentralization using quantum blockchain: A theoretical analysis,” IEEE Transactions on Quantum Engineering, vol. 3, pp. 1–16, 2022.
[28] ↑ M. Edwards, A. Mashatan, and S. Ghose, “A review of quantum and hybrid quantum/classical blockchain protocols,” Quantum Information Processing, vol. 19, pp. 1–22, 2020.
[29] ↑ A. A. Giron, R. Custódio, and F. Rodríguez-Henríquez, “Post-quantum hybrid key exchange: a systematic mapping study,” Journal of Cryptographic Engineering, vol. 13, no. 1, pp. 71–88, 2023.
[30] ↑ National Institute of Standards and Technology, “Guide for conducting risk assessments,” https://doi.org/10.6028/NIST.SP.800-30r1, Tech. Rep. NIST Special Publication 800-30 Revision 1, September 2012.
[31] ↑ T. Ito and S. Turner, “Clarifications for Elliptic Curve Cryptography Subject Public Key Information,” https://www.rfc-editor.org/info/rfc8813, 2020.
[32] ↑ A. Langley, M. Hamburg, and S. Turner, “Elliptic Curves for Security,” https://www.rfc-editor.org/info/rfc7748, 2016.
[33] ↑ D. Gillmor, “Negotiated Finite Field Diffie-Hellman Ephemeral Parameters for Transport Layer Security (TLS),” https://www.rfc-editor.org/info/rfc7919, 2016.
[34] ↑ K. Moriarty, B. Kaliski, J. Jonsson, and A. Rusch, “PKCS# 1: RSA cryptography specifications version 2.2,” 2016.
[35] ↑ National Institute of Standards and Technology, “Advanced encryption standard (AES),” https://csrc.nist.gov/publications/detail/fips/197/final, U.S. Department of Commerce, FIPS Publication 197, November 2001.
[36] ↑ D. Eastlake 3rd and T. Hansen, “Us secure hash algorithms (SHA and SHA-based HMAC and HKDF),” 2011.
[37] ↑ M. Mosca and M. Piani, “2022 quantum threat timeline report,” https://globalriskinstitute.org/publication/2022-quantum-threat-timeline-report/, Tech. Rep., 2022.
[38] ↑ National Institute of Standards and Technology (NIST), “Post-Quantum Cryptography Standardization,” https://csrc.nist.gov/projects/post-quantum-cryptography/post-quantum-cryptography-standardization/evaluation-criteria/security-(evaluation-criteria), 2024.
[39] ↑ G. Alagic, et al., “Status report on the fourth round of the NIST post-quantum cryptography standardization process,” https://nvlpubs.nist.gov/nistpubs/ir/2025/NIST.IR.8545.pdf, National Institute of Standards and Technology, Tech. Rep. NIST IR 8545, March 2025.
[40] ↑ J. Bos, L. Ducas, E. Kiltz, T. Lepoint, V. Lyubashevsky, J. M. Schanck, P. Schwabe, G. Seiler, and D. Stehlé, “CRYSTALS-Kyber: a CCA-secure module-lattice-based KEM,” in 2018 IEEE European Symposium on Security and Privacy (EuroS&P). IEEE, 2018, pp. 353–367.
[41] ↑ National Institute of Standards and Technology, “Module-lattice-based key-encapsulation mechanism standard,” https://nvlpubs.nist.gov/nistpubs/FIPS/{NIST}.FIPS.203.ipd.pdf, 2023.
[42] ↑ P. Ravi, D. B. Roy, S. Bhasin, A. Chattopadhyay, and D. Mukhopadhyay, “Number “not used” once-practical fault attack on pqm4 implementations of NIST candidates,” in International Workshop on Constructive Side-Channel Analysis and Secure Design. Springer, 2019, pp. 232–250.
[43] ↑ T. Oder, T. Schneider, T. Pöppelmann, and T. Güneysu, “Practical CCA2-secure and masked ring-LWE implementation,” Cryptology ePrint Archive, 2016.
[44] ↑ P. Ravi, S. Bhasin, S. S. Roy, and A. Chattopadhyay, “Drop by drop you break the rock-exploiting generic vulnerabilities in lattice-based PKE/KEMs using EM-based physical attacks,” Cryptology ePrint Archive, 2020.
[45] ↑ M. Hamburg, J. Hermelink, R. Primas, S. Samardjiska, T. Schamberger, S. Streit, E. Strieder, and C. van Vredendaal, “Chosen ciphertext k-trace attacks on masked CCA2 secure Kyber,” IACR Transactions on Cryptographic Hardware and Embedded Systems, pp. 88–113, 2021.
[46] ↑ P. Pessl and R. Primas, “More practical single-trace attacks on the number theoretic transform,” in International Conference on Cryptology and Information Security in Latin America. Springer, 2019, pp. 130–149.
[47] ↑ T. Kamucheka, M. Fahr, T. Teague, A. Nelson, D. Andrews, and M. Huang, “Power-based side channel attack analysis on PQC algorithms,” Cryptology ePrint Archive, 2021.
[48] ↑ E. Dubrova, K. Ngo, J. Gärtner, and R. Wang, “Breaking a fifth-order masked implementation of CRYSTALS-Kyber by copy-paste,” in Proceedings of the 10th ACM Asia Public-Key Cryptography Workshop, ser. APKC '23. ACM, 2023, p. 10–20.
[49] ↑ P. Ravi, S. S. Roy, A. Chattopadhyay, and S. Bhasin, “Generic side-channel attacks on CCA-secure lattice-based PKE and KEMs.” IACR Transactions on Cryptographic Hardware and Embedded Systems, vol. 2020, no. 3, pp. 307–335, 2020.
[50] ↑ Z. Xu, O. Pemberton, S. S. Roy, D. Oswald, W. Yao, and Z. Zheng, “Magnifying side-channel leakage of lattice-based cryptosystems with chosen ciphertexts: the case study of Kyber,” IEEE Transactions on Computers, vol. 71, no. 9, pp. 2163–2176, 2021.
[51] ↑ P. Ravi, S. Bhasin, S. S. Roy, and A. Chattopadhyay, “On exploiting message leakage in (few) NIST PQC candidates for practical message recovery attacks,” IEEE Transactions on Information Forensics and Security, vol. 17, pp. 684–699, 2021.
[52] ↑ M. R. Albrecht, A. Deo, and K. G. Paterson, “Cold boot attacks on ring and module LWE keys under the NTT,” Cryptology ePrint Archive, 2018.
[53] ↑ L. Ducas, E. Kiltz, T. Lepoint, V. Lyubashevsky, P. Schwabe, G. Seiler, and D. Stehlé, “CRYSTALS-Dilithium: A lattice-based digital signature scheme,” IACR Transactions on Cryptographic Hardware and Embedded Systems, pp. 238–268, 2018.
[54] ↑ National Institute of Standards and Technology (NIST), “Module-Lattice-Based Digital Signature Standard,” https://nvlpubs.nist.gov/nistpubs/FIPS/{NIST}.FIPS.204.ipd.pdf, 2023.
[55] ↑ L. G. Bruinderink and P. Pessl, “Differential fault attacks on deterministic lattice signatures,” IACR Transactions on Cryptographic Hardware and Embedded Systems, pp. 21–43, 2018.
[56] ↑ V. Migliore, B. Gérard, M. Tibouchi, and P.-A. Fouque, “Masking Dilithium,” in International Conference on Applied Cryptography and Network Security. Springer, 2019, pp. 344–362.
[57] ↑ V. Q. Ulitzsch, S. Marzougui, M. Tibouchi, and J.-P. Seifert, “Profiling side-channel attacks on Dilithium: A small bit-fiddling leak breaks it all,” in International Conference on Selected Areas in Cryptography. Springer, 2022, pp. 3–32.
[58] ↑ P. Ravi, M. P. Jhanwar, J. Howe, A. Chattopadhyay, and S. Bhasin, “Exploiting determinism in lattice-based signatures: practical fault attacks on pqm4 implementations of NIST candidates,” in Proceedings of the 2019 ACM Asia Conference on Computer and Communications Security, 2019, pp. 427–440.
[59] ↑ R. Singh, S. Islam, B. Sunar, and P. Schaumont, “Analysis of EM fault injection on bit-sliced number theoretic transform software in Dilithium,” ACM Transactions on Embedded Computing Systems, vol. 23, no. 2, pp. 1–27, March 2024.
[60] ↑ A. Berzati, A. C. Viera, M. Chartouny, S. Madec, D. Vergnaud, and D. Vigilant, “Exploiting intermediate value leakage in Dilithium: a template-based approach,” IACR Transactions on Cryptographic Hardware and Embedded Systems, vol. 2023, no. 4, pp. 188–210, 2023.
[61] ↑ A. Berzati, A. C. Viera, M. Chartouni, S. Madec, D. Vergnaud, and D. Vigilant, “A practical template attack on CRYSTALS-Dilithium,” 2023.
[62] ↑ D. J. Bernstein, A. Hülsing, S. Kölbl, R. Niederhagen, J. Rijneveld, and P. Schwabe, “The SPHINCS+ signature framework,” in Proceedings of the 2019 ACM SIGSAC conference on computer and communications security, 2019, pp. 2129–2146.
[63] ↑ National Institute of Standards and Technology, “Secure hash standard (SHS),” https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.205.ipd.pdf, 2002.
[64] ↑ L. Castelnovi, A. Martinelli, and T. Prest, “Grafting trees: a fault attack against the SPHINCS framework,” in International Conference on Post-Quantum Cryptography. Springer, 2018, pp. 165–184.
[65] ↑ A. Genêt, M. J. Kannwischer, H. Pelletier, and A. McLauchlan, “Practical fault injection attacks on SPHINCS,” Cryptology ePrint Archive, 2018.
[66] ↑ M. J. Kannwischer, A. Genêt, D. Butin, J. Krämer, and J. Buchmann, “Differential power analysis of XMSS and SPHINCS,” in International Workshop on Constructive Side-Channel Analysis and Secure Design. Springer, 2018, pp. 168–188.
[67] ↑ P.-A. Fouque, J. Hoffstein, P. Kirchner, V. Lyubashevsky, T. Pornin, T. Prest, T. Ricosset, G. Seiler, W. Whyte, Z. Zhang et al., “Falcon: Fast-fourier lattice-based compact signatures over NTRU,” Submission to the NIST's post-quantum cryptography standardization process, vol. 36, no. 5, pp. 1–75, 2018.
[68] ↑ S. McCarthy, J. Howe, N. Smyth, S. Brannigan, and M. O'Neill, “BEARZ attack Falcon: implementation attacks with countermeasures on the FALCON signature scheme,” Cryptology ePrint Archive, 2019.
[69] ↑ M. Guerreau, A. Martinelli, T. Ricosset, and M. Rossi, “The hidden parallelepiped is back again: Power analysis attacks on Falcon,” IACR Transactions on Cryptographic Hardware and Embedded Systems, pp. 141–164, 2022.
[70] ↑ E. Karabulut and A. Aysu, “Falcon down: Breaking Falcon post-quantum signature scheme through side-channel attacks,” in 2021 58th ACM/IEEE Design Automation Conference (DAC). IEEE, 2021, pp. 691–696.
[71] ↑ C. A. Melchor, N. Aragon, S. Bettaieb, L. Bidoux, O. Blazy, J.-C. Deneuville, P. Gaborit, E. Persichetti, G. Zémor, and I. Bourges, “Hamming quasi-cyclic (HQC),” NIST PQC Round, vol. 2, pp. 4–13, 2018.
[72] ↑ G. Alagic et al., “Status report on the fourth round of the nist post-quantum cryptography standardization process,” https://nvlpubs.nist.gov/nistpubs/ir/2025/NIST.IR.8545.pdf, Tech. Rep., March 2025.
[73] ↑ P.-L. Cayrel, B. Colombier, V.-F. Dragoi, A. Menu, and L. Bossuet, “Message-recovery laser fault injection attack on code-based cryptosystems.” IACR Cryptol. ePrint Arch., vol. 2020, p. 900, 2020.
[74] ↑ K. Xagawa, A. Ito, R. Ueno, J. Takahashi, and N. Homma, “Fault-injection attacks against NIST's post-quantum cryptography round 3 KEM candidates,” in International Conference on the Theory and Application of Cryptology and Information Security. Springer, 2021, pp. 33–61.
[75] ↑ Q. Guo, T. Johansson, and A. Nilsson, “A key-recovery timing attack on post-quantum primitives using the fujisaki-okamoto transformation and its application on FrodoKEM,” in Annual International Cryptology Conference. Springer, 2020, pp. 359–386.
[76] ↑ Q. Guo, C. Hlauschek, T. Johansson, N. Lahr, A. Nilsson, and R. L. Schröder, “Don't reject this: Key-recovery timing attacks due to rejection-sampling in HQC and BIKE,” IACR Transactions on Cryptographic Hardware and Embedded Systems, pp. 223–263, 2022.
[77] ↑ G. Wafo-Tapa, S. Bettaieb, L. Bidoux, P. Gaborit, and E. Marcatel, “A practicable timing attack against HQC and its countermeasure,” Advances in Mathematics of Communications, 2020.
[78] ↑ T. Schamberger, J. Renner, G. Sigl, and A. Wachter-Zeh, “A power side-channel attack on the CCA2-secure HQC KEM,” in International Conference on Smart Card Research and Advanced Applications. Springer, 2020, pp. 119–134.
[79] ↑ G. Goy, A. Loiseau, and P. Gaborit, “A new key recovery side-channel attack on HQC with chosen ciphertext,” in International Conference on Post-Quantum Cryptography. Springer, 2022, pp. 353–371.
[80] ↑ T. B. Paiva, P. Ravi, D. Jap, S. Bhasin, S. Das, and A. Chattopadhyay, “Et tu, brute? side-channel assisted chosen ciphertext attacks using valid ciphertexts on HQC KEM,” in International Conference on Post-Quantum Cryptography. Springer, 2025, pp. 294–321.
[81] ↑ National Institute of Standards and Technology (NIST), “NIST Post-Quantum Cryptographic Candidates to Be Standardized: Round 4,” https://csrc.nist.gov/News/2022/PQC-candidates-to-be-standardized-and-round-4, 2022.
[82] ↑ National Institute of Standards and Technology, “Post-quantum cryptography FIPS approved,” https://csrc.nist.gov/News/2024/postquantum-cryptography-fips-approved, August 2024.
[83] ↑ D. Dasgupta, J. M. Shrein, and K. D. Gupta, “A survey of blockchain from security perspective,” Journal of Banking and Financial Technology, vol. 3, pp. 1–17, 2019.
[84] ↑ K. Petrenko, A. Mashatan, and F. Shirazi, “Assessing the quantum-resistant cryptographic agility of routing and switching IT network infrastructure in a large-size financial organization,” Journal of Information Security and Applications, vol. 46, pp. 151–163, 2019.
[85] ↑ M. A. Khan, S. Javaid, S. A. H. Mohsan, M. Tanveer, and I. Ullah, “Future-proofing security for UAVs with post-quantum cryptography: A review,” IEEE Open Journal of the Communications Society, vol. 5, pp. 6849–6871, 2024.
[86] ↑ National Institute of Standards and Technology, “Post-quantum cryptography,” https://csrc.nist.gov/projects/post-quantum-cryptography, 2023.
[87] ↑ A. Feraudo, N. Romandini, C. Mazzocca, R. Montanari, and P. Bellavista, “DIVA: A DID-based reputation system for secure transmission in VANETs using IOTA,” Computer Networks, p. 110332, 2024.
[88] ↑ A. Smahi, H. Li, W. Han, A. A. Fateh, and C. C. Chan, “VFL-Chain: Bulletproofing federated learning in the V2X environments,” Future Generation Computer Systems, vol. 155, pp. 419–436, 2024.
[89] ↑ S. Sayeed and H. Marco-Gisbert, “Assessing blockchain consensus and security mechanisms against the 51% attack,” Applied sciences, vol. 9, no. 9, p. 1788, 2019.
[90] ↑ T. M. Fernandez-Carames and P. Fraga-Lamas, “Towards post-quantum blockchain: A review on blockchain cryptography resistant to quantum computing attacks,” IEEE access, vol. 8, pp. 21 091–21 116, 2020.
[91] ↑ M. S. Ferdous, M. J. M. Chowdhury, and M. A. Hoque, “A survey of consensus algorithms in public blockchain systems for crypto-currencies,” Journal of Network and Computer Applications, vol. 182, p. 103035, 2021.
[92] ↑ Quantum Resistant Ledger (QRL), “QRL proof-of-stake algorithm,” https://github.com/theQRL/PoS/blob/master/pos-qrl.pdf, Tech. Rep., July 2017.
[93] ↑ D. Singh, G. Muraleedharan, B. Fu, C.-M. Cheng, N. R. Newton, P. P. Rohde, and G. K. Brennen, “Proof-of-work consensus by quantum sampling,” Quantum Science and Technology, vol. 10, no. 2, p. 025020, 2025.
[94] ↑ D. Kraft, “Difficulty control for blockchain-based consensus systems,” Peer-to-peer Networking and Applications, vol. 9, pp. 397–413, 2016.
[95] ↑ A. Judmayer, A. Zamyatin, N. Stifter, A. G. Voyiatzis, and E. Weippl, “Merged mining: Curse or cure?” in Data Privacy Management, Cryptocurrencies and Blockchain Technology: ESORICS 2017, DPM 2017 and CBT 2017, Proceedings. Springer, 2017, pp. 316–333.
[96] ↑ T. Alladi, V. Chamola, N. Sahu, V. Venkatesh, A. Goyal, and M. Guizani, “A comprehensive survey on the applications of blockchain for securing vehicular networks,” IEEE Communications Surveys & Tutorials, vol. 24, no. 2, pp. 1212–1239, 2022.
[97] ↑ B. Riskhan, H. A. J. Safuan, K. Hussain, A. A. H. Elnour, A. Abdelmaboud, F. Khan, and M. Kundi, “An adaptive distributed denial of service attack prevention technique in a distributed environment,” Sensors, vol. 23, no. 14, p. 6574, 2023.
[98] ↑ C. Deng and C. Wen, “Distributed resilient observer-based fault-tolerant control for heterogeneous multiagent systems under actuator faults and DoS attacks,” IEEE Transactions on Control of Network Systems, vol. 7, no. 3, pp. 1308–1318, 2020.
[99] ↑ P. Kumari and P. Kaur, “A survey of fault tolerance in cloud computing,” Journal of King Saud University-Computer and Information Sciences, vol. 33, no. 10, pp. 1159–1176, 2021.
[100] ↑ A. I. Sanka and R. C. Cheung, “A systematic review of blockchain scalability: Issues, solutions, analysis and future research,” Journal of Network and Computer Applications, vol. 195, p. 103232, 2021.
[101] ↑ M. Conklin, B. Elzweig, and L. J. Trautman, “Legal recourse for victims of blockchain and cyber breach attacks,” UC Davis Bus. LJ, vol. 23, p. 135, 2023.
[102] ↑ U. S. Aditya, R. Singh, P. K. Singh, and A. Kalla, “A survey on blockchain in robotics: Issues, opportunities, challenges and future directions,” Journal of Network and Computer Applications, vol. 196, p. 103245, 2021.
[103] ↑ G. Fuchsbauer, M. Orrù, and Y. Seurin, “Aggregate cash systems: A cryptographic investigation of mimblewimble,” in Advances in Cryptology–EUROCRYPT 2019: 38th Annual International Conference on the Theory and Applications of Cryptographic Techniques, Darmstadt, Germany, May 19–23, 2019, Proceedings, Part I 38. Springer, 2019, pp. 657–689.
[104] ↑ L. Zhou, A. Diro, A. Saini, S. Kaisar, and P. C. Hiep, “Leveraging zero knowledge proofs for blockchain-based identity sharing: A survey of advancements, challenges and opportunities,” Journal of Information Security and Applications, vol. 80, p. 103678, 2024.
[105] ↑ H. Xu, Y. Zhou, J. Ming, and M. Lyu, “Layered obfuscation: a taxonomy of software obfuscation techniques for layered security,” Cybersecurity, vol. 3, pp. 1–18, 2020.
[106] ↑ W. Liang, Y. Liu, C. Yang, S. Xie, K. Li, and W. Susilo, “On identity, transaction, and smart contract privacy on permissioned and permissionless blockchain: A comprehensive survey,” ACM Computing Surveys, vol. 56, no. 12, pp. 1–35, 2024.
[107] ↑ C. Liu, H. Guo, M. Xu, S. Wang, D. Yu, J. Yu, and X. Cheng, “Extending on-chain trust to off-chain – trustworthy blockchain data collection using trusted execution environment (TEE),” IEEE Transactions on Computers, vol. 71, no. 12, pp. 3268–3280, 2022.
[108] ↑ N. Z. Aitzhan and D. Svetinovic, “Security and privacy in decentralized energy trading through multi-signatures, blockchain and anonymous messaging streams,” IEEE Transactions on Dependable and Secure Computing, vol. 15, no. 5, pp. 840–852, 2016.
[109] ↑ M. Conti, E. S. Kumar, C. Lal, and S. Ruj, “A survey on security and privacy issues of Bitcoin,” IEEE communications surveys & tutorials, vol. 20, no. 4, pp. 3416–3452, 2018.
[110] ↑ Strivemindz, “Quantum threat: How will blockchain adapt to quantum computing?” https://www.linkedin.com/pulse/quantum-threat-how-blockchain-adapt-computing-strivemindz/, Tech. Rep., 2023.
[111] ↑ D. Malkhi, K. Nayak, and L. Ren, “Flexible Byzantine fault tolerance,” in Proceedings of the 2019 ACM SIGSAC conference on computer and communications security, 2019, pp. 1041–1053.
[112] ↑ W. Zhong, C. Yang, W. Liang, J. Cai, L. Chen, J. Liao, and N. Xiong, “Byzantine fault-tolerant consensus algorithms: a survey,” Electronics, vol. 12, no. 18, p. 3801, 2023.
[113] ↑ Z. Liu, N. C. Luong, W. Wang, D. Niyato, P. Wang, Y.-C. Liang, and D. I. Kim, “A survey on applications of game theory in blockchain,” arXiv preprint arXiv:1902.10865, 2019.
[114] ↑ Z. Noorian and M. Ulieru, “The state of the art in trust and reputation systems: a framework for comparison,” Journal of theoretical and applied electronic commerce research, vol. 5, no. 2, pp. 97–117, 2010.
[115] ↑ N. K. Parida, C. Jatoth, V. D. Reddy, M. M. Hussain, and J. Faizi, “Post-quantum distributed ledger technology: a systematic survey,” Scientific Reports, vol. 13, no. 1, p. 20729, 2023.
[116] ↑ B. Rodrigues, M. Franco, C. Killer, E. J. Scheid, and B. Stiller, “On trust, blockchain, and reputation systems,” in Handbook on blockchain. Springer, 2022, pp. 299–337.
[117] ↑ T. Weingärtner, D. Batista, S. Köchli, and G. Voutat, “Prototyping a smart contract based public procurement to fight corruption,” Computers, vol. 10, no. 7, p. 85, 2021.
[118] ↑ Y. Gilad, R. Hemo, S. Micali, G. Vlachos, and N. Zeldovich, “Algorand: Scaling Byzantine agreements for cryptocurrencies,” in Proceedings of the 26th symposium on operating systems principles, 2017, pp. 51–68.
[119] ↑ V. Gandotra, F.-É. Racicot, and A. Rahimzadeh, “Cryptocurrency mining,” in Cryptofinance and Mechanisms of Exchange: The Making of Virtual Currency. Springer, 2020, pp. 51–67.
[120] ↑ R. Pass and E. Shi, “Hybrid consensus: Efficient consensus in the permissionless model,” Cryptology ePrint Archive, 2016.
[121] ↑ C. R. García, S. Rommel, S. Takarabt, J. J. V. Olmos, S. Guilley, P. Nguyen, and I. T. Monroy, “Quantum-resistant transport layer security,” Computer Communications, vol. 213, pp. 345–358, 2024.
[122] ↑ K. M. Khan, J. Arshad, and M. M. Khan, “Empirical analysis of transaction malleability within blockchain-based e-voting,” Computers & Security, vol. 100, p. 102081, 2021.
[123] ↑ K. Nicolas, Y. Wang, G. C. Giakos, B. Wei, and H. Shen, “Blockchain system defensive overview for double-spend and selfish mining attacks: A systematic approach,” IEEE Access, vol. 9, pp. 3838–3857, 2020.
[124] ↑ National Institute of Standards and Technology, “NIST to standardize encryption algorithms that can resist attack by quantum computers,” https://www.nist.gov, 2023.
[125] ↑ B. Bünz, J. Campen, and O. Günther, “Improving the privacy, scalability, and ecological impact of blockchains,” Ph.D. dissertation, 2018.
[126] ↑ I. Keidar, E. Kokoris-Kogias, O. Naor, and A. Spiegelman, “All you need is DAG,” in Proceedings of the 2021 ACM Symposium on Principles of Distributed Computing, ser. PODC'21. ACM, 2021, p. 165–175.
[127] ↑ H. Dang, T. T. A. Dinh, D. Loghin, E.-C. Chang, Q. Lin, and B. C. Ooi, “Towards scaling blockchain systems via sharding,” in Proceedings of the 2019 international conference on management of data, 2019, pp. 123–140.
[128] ↑ D. Boneh, J. Bonneau, B. Bünz, and B. Fisch, “Verifiable delay functions,” in Annual international cryptology conference. Springer, 2018, pp. 757–788.
[129] ↑ S. Chauhan, V. P. Ojha, S. Yarahmadian, and D. Carvalho, “Towards building quantum resistant blockchain,” in 2023 International Conference on Electrical, Computer and Energy Technologies (ICECET). IEEE, 2023, pp. 1–9.
[130] ↑ T. Ramananandro, A. Delignat-Lavaud, C. Fournet, N. Swamy, T. Chajed, N. Kobeissi, and J. Protzenko, “ { { EverParse } } : Verified secure { { Zero-Copy } } parsers for authenticated message formats,” in 28th USENIX Security Symposium (USENIX Security 19), 2019, pp. 1465–1482.
[131] ↑ C. Decker and R. Wattenhofer, “Bitcoin transaction malleability and MtGox,” in Computer Security-ESORICS 2014: 19th European Symposium on Research in Computer Security, Wroclaw, Poland, September 7-11, 2014. Proceedings, Part II 19. Springer, 2014, pp. 313–326.
[132] ↑ P. Porambage, G. Gür, D. P. M. Osorio, M. Liyanage, A. Gurtov, and M. Ylianttila, “The roadmap to 6G security and privacy,” IEEE Open Journal of the Communications Society, vol. 2, pp. 1094–1122, 2021.
[133] ↑ A. Singh, R. M. Parizi, M. Han, A. Dehghantanha, H. Karimipour, and K.-K. R. Choo, “Public blockchains scalability: An examination of sharding and segregated witness,” Blockchain cybersecurity, trust and privacy, pp. 203–232, 2020.
[134] ↑ P. Ruan, D. Loghin, Q.-T. Ta, M. Zhang, G. Chen, and B. C. Ooi, “A transactional perspective on execute-order-validate blockchains,” in Proceedings of the 2020 ACM SIGMOD International Conference on Management of Data, 2020, pp. 543–557.
[135] ↑ E. Zaghloul, T. Li, M. W. Mutka, and J. Ren, “Bitcoin and blockchain: Security and privacy,” IEEE Internet of Things Journal, vol. 7, no. 10, pp. 10 288–10 313, 2020.
[136] ↑ T. Yanagita, S. Chakraborty, K. Sadakane, and S. R. Satti, “Space-efficient data structure for posets with applications,” in 18th Scandinavian Symposium and Workshops on Algorithm Theory (SWAT 2022). Schloss Dagstuhl-Leibniz-Zentrum für Informatik, 2022.
[137] ↑ R. Belchior, A. Vasconcelos, S. Guerreiro, and M. Correia, “A survey on blockchain interoperability: Past, present, and future trends,” ACM Computing Surveys (CSUR), vol. 54, no. 8, pp. 1–41, 2021.
[138] ↑ D. Chefrour, “Evolution of network time synchronization towards nanoseconds accuracy: A survey,” Computer Communications, vol. 191, pp. 26–35, 2022.
[139] ↑ S. Aggarwal, N. Kumar, M. Alhussein, and G. Muhammad, “Blockchain-based UAV path planning for healthcare 4.0: Current challenges and the way ahead,” IEEE Network, vol. 35, no. 1, pp. 20–29, 2021.
[140] ↑ C. Wu, L. Ke, and Y. Du, “Quantum resistant key-exposure free chameleon hash and applications in redactable blockchain,” Information Sciences, vol. 548, pp. 438–449, 2021.
[141] ↑ P. Ananth, Z. Hu, and H. Yuen, “On the (im) plausibility of public-key quantum money from collision-resistant hash functions,” in International Conference on the Theory and Application of Cryptology and Information Security. Springer, 2023, pp. 39–72.
[142] ↑ D. Basile, V. Goretti, C. Di Ciccio, and S. Kirrane, “Enhancing blockchain-based processes with decentralized oracles,” in International Conference on Business Process Management. Springer, 2021, pp. 102–118.
[143] ↑ J. Dong, C. Song, Y. Sun, and T. Zhang, “DAON: A decentralized autonomous oracle network to provide secure data for smart contracts,” IEEE Transactions on Information Forensics and Security, 2023.
[144] ↑ A. M. Lewis, M. Travagnin et al., “A secure quantum communications infrastructure for europe: Technical background for a policy vision,” Publications Office of the European Union: Luxembourg, 2022.
[145] ↑ Y. Zhao, X. Kang, T. Li, C.-K. Chu, and H. Wang, “Toward trustworthy DeFi oracles: past, present, and future,” IEEE Access, vol. 10, pp. 60 914–60 928, 2022.
[146] ↑ D. He, Z. Deng, Y. Zhang, S. Chan, Y. Cheng, and N. Guizani, “Smart contract vulnerability analysis and security audit,” IEEE Network, vol. 34, no. 5, pp. 276–282, 2020.
[147] ↑ Y. Chen, C. Xu, J. S. He, and S. Xiao, “A cross language code security audit framework based on normalized representation.” Journal of Quantum Computing, vol. 4, no. 2, 2022.
[148] ↑ E. Foundation, “Formal verification of smart contracts,” https://ethereum.org/en/developers/docs/smart-contracts/formal-verification/.
[149] ↑ M. Lewis, S. Soudjani, and P. Zuliani, “Formal verification of quantum programs: Theory, tools, and challenges,” ACM Transactions on Quantum Computing, vol. 5, no. 1, 2023.
[150] ↑ P. Tolmach, “Securing smart contracts with formal verification and automated program repair,” 2023.
[151] ↑ A. Aydeger, E. Zeydan, A. K. Yadav, K. T. Hemachandra, and M. Liyanage, “Towards a quantum-resilient future: Strategies for transitioning to post-quantum cryptography,” in 2024 15th International Conference on Network of the Future (NoF). IEEE, 2024, pp. 195–203.
[152] ↑ Y. Baseri, V. Chouhan, and A. Ghorbani, “Cybersecurity in the quantum era: Assessing the impact of quantum computing on infrastructure,” arXiv preprint arXiv:2404.10659, 2024.
[153] ↑ Y. Baseri, V. Chouhan, and A. Hafid, “Navigating quantum security risks in networked environments: A comprehensive study of quantum-safe network protocols,” Computers & Security, vol. 142, p. 103883, 2024.
[154] ↑ A. Ghaleb and K. Pattabiraman, “How effective are smart contract analysis tools? evaluating smart contract static analysis tools using bug injection,” in Proceedings of the 29th ACM SIGSOFT International Symposium on Software Testing and Analysis, 2020, pp. 415–427.
[155] ↑ R. Fontein, “Comparison of static analysis tooling for smart contracts on the EVM,” in 28th Twente Student conference on IT, 2018.
[156] ↑ J. Khor, M. A. Masama, M. Sidorov, W. Leong, and J. Lim, “An improved gas efficient library for securing iot smart contracts against arithmetic vulnerabilities,” in Proceedings of the 2020 9th International Conference on Software and Computer Applications, 2020, pp. 326–330.
[157] ↑ K. Al Harthy and A. Agarwal, “Defi cybersecurity technical and nontechnical risks,” in Decentralized Finance: The Impact of Blockchain-Based Financial Innovations on Entrepreneurship. Springer, 2024, pp. 133–149.
[158] ↑ Z. Wan, X. Xia, D. Lo, J. Chen, X. Luo, and X. Yang, “Smart contract security: A practitioners' perspective,” in 2021 IEEE/ACM 43rd International Conference on Software Engineering (ICSE), 2021, pp. 1410–1422.
[159] ↑ K. Hameed, M. Barika, S. Garg, M. B. Amin, and B. Kang, “A taxonomy study on securing blockchain-based industrial applications: An overview, application perspectives, requirements, attacks, countermeasures, and open issues,” Journal of Industrial Information Integration, vol. 26, p. 100312, 2022.
[160] ↑ S. E. Quincozes, C. Albuquerque, D. Passos, and D. Mossé, “A survey on intrusion detection and prevention systems in digital substations,” Computer Networks, vol. 184, p. 107679, 2021.
[161] ↑ R. Chaganti, R. V. Boppana, V. Ravi, K. Munir, M. Almutairi, F. Rustam, E. Lee, and I. Ashraf, “A comprehensive review of denial of service attacks in blockchain ecosystem and open challenges,” IEEE Access, vol. 10, pp. 96 538–96 555, 2022.
[162] ↑ W. Zou, D. Lo, P. S. Kochhar, X.-B. D. Le, X. Xia, Y. Feng, Z. Chen, and B. Xu, “Smart contract development: Challenges and opportunities,” IEEE transactions on software engineering, vol. 47, no. 10, pp. 2084–2106, 2019.
[163] ↑ P. Das, L. Eckey, T. Frassetto, D. Gens, K. Hostáková, P. Jauernig, S. Faust, and A.-R. Sadeghi, “FastKitten: Practical smart contracts on Bitcoin,” in 28th USENIX Security Symposium (USENIX Security 19), 2019, pp. 801–818.
[164] ↑ Y. Ding, Z. Wu, Y. Miao, L. Xie, and M. Ding, “Genuine on-chain and off-chain collaboration: Achieving secure and non-repudiable file sharing in blockchain applications,” IEEE Transactions on Network and Service Management, vol. 21, no. 2, pp. 1802–1816, 2024.
[165] ↑ Y. Wang, K. Li, Y. Tang, J. Chen, Q. Zhang, X. Luo, and T. Chen, “Towards saving blockchain fees via secure and cost-effective batching of smart-contract invocations,” IEEE Transactions on Software Engineering, vol. 49, no. 4, pp. 2980–2995, 2023.
[166] ↑ X. Ren, M. Xu, D. Niyato, J. Kang, Z. Xiong, C. Qiu, and X. Wang, “Building resilient web 3.0 with quantum information technologies and blockchain: An ambilateral view,” arXiv preprint arXiv:2303.13050, 2023.
[167] ↑ B. Bellaj, A. Ouaddah, N. Crespi, A. Mezrioui, and E. Bertin, “A transpilation-based approach to writing secure access control smart contracts,” in 2023 5th Conference on Blockchain Research & Applications for Innovative Networks and Services (BRAINS). IEEE, 2023, pp. 1–7.
[168] ↑ C. Joshi, C. Bhole, and N. Vaswani, “A scrutiny review of CPS 4.0-based blockchain with quantum resistance,” in Advancements in quantum blockchain with real-time applications. IGI Global, 2022, pp. 131–157.
[169] ↑ H. Zhang, L.-H. Merino, Z. Qu, M. Bastankhah, V. Estrada-Galiñanes, and B. Ford, “F3B: A low-overhead blockchain architecture with per-transaction front-running protection,” arXiv preprint arXiv:2205.08529, 2022.
[170] ↑ A. Agarwal, J. Bartusek, V. Goyal, D. Khurana, and G. Malavolta, “Post-quantum multi-party computation,” in Advances in Cryptology – EUROCRYPT 2021: 40th Annual International Conference on the Theory and Applications of Cryptographic Techniques. Springer, 2021, pp. 435–464.
[171] ↑ J. Burdges and L. De Feo, “Delay encryption,” in Annual International Conference on the Theory and Applications of Cryptographic Techniques. Springer, 2021, pp. 302–326.
[172] ↑ P. Thanalakshmi, A. Rishikhesh, J. Marion Marceline, G. P. Joshi, and W. Cho, “A quantum-resistant blockchain system: A comparative analysis,” Mathematics, vol. 11, no. 18, p. 3947, 2023.
[173] ↑ D. R. Sahu, H. Tiwari, D. S. Tomar, and R. Pateriya, “Quantum-resistant cryptography to prevent from phishing attack exploiting blockchain wallet,” in Sustainable Security Practices Using Blockchain, Quantum and Post-Quantum Technologies for Real Time Applications. Springer, 2024, pp. 171–191.
[174] ↑ V. Mannalatha, S. Mishra, and A. Pathak, “A comprehensive review of quantum random number generators: Concepts, classification and the origin of randomness,” Quantum Information Processing, vol. 22, no. 12, p. 439, 2023.
[175] ↑ M. M. Jacak, P. Jóźwiak, J. Niemczuk, and J. E. Jacak, “Quantum generators of random numbers,” Scientific Reports, vol. 11, no. 1, p. 16108, 2021.
[176] ↑ Y. Liu, Q. Zhao, M.-H. Li, J.-Y. Guan, Y. Zhang, B. Bai, W. Zhang, W.-Z. Liu, C. Wu, X. Yuan et al., “Device-independent quantum random-number generation,” Nature, vol. 562, no. 7728, pp. 548–551, 2018.
[177] ↑ M. Berta, O. Fawzi, and V. B. Scholz, “Quantum-proof randomness extractors via operator space theory,” IEEE Transactions on Information Theory, vol. 63, no. 4, pp. 2480–2503, 2017.
[178] ↑ D. G. Marangon, G. Vallone, and P. Villoresi, “Source-device-independent ultrafast quantum random number generation,” Physical Review Letters, vol. 118, no. 6, p. 060503, 2017.
[179] ↑ X. Ma, F. Xu, H. Xu, X. Tan, B. Qi, and H.-K. Lo, “Postprocessing for quantum random-number generators: Entropy evaluation and randomness extraction,” Physical Review A—Atomic, Molecular, and Optical Physics, vol. 87, no. 6, p. 062327, 2013.
[180] ↑ Z. Li, D. Wang, and E. Morais, “Quantum-safe round-optimal password authentication for mobile devices,” IEEE transactions on dependable and secure computing, vol. 19, no. 3, pp. 1885–1899, 2020.
[181] ↑ M. Dürmuth, M. Golla, P. Markert, A. May, and L. Schlieper, “Towards quantum large-scale password guessing on real-world distributions,” in International Conference on Cryptology and Network Security. Springer, 2021, pp. 412–431.
[182] ↑ A. Biryukov, D. Dinu, D. Khovratovich, and S. Josefsson, “RFC 9106: Argon2 memory-hard function for password hashing and proof-of-work applications,” 2021.
[183] ↑ L. Chen, S. Jordan, Y.-K. Liu, D. Moody, R. Peralta, R. Perlner, and D. Smith-Tone, “Report on post-quantum cryptography,” US Department of Commerce, National Institute of Standards and Technology, 2016.
[184] ↑ N. B. Truong, T.-W. Um, B. Zhou, and G. M. Lee, “Strengthening the blockchain-based internet of value with trust,” in 2018 IEEE international conference on communications (ICC). IEEE, 2018, pp. 1–7.
[185] ↑ P. Schwabe, D. Stebila, and T. Wiggers, “More efficient post-quantum KEMTLS with pre-distributed public keys,” in Computer Security – ESORICS 2021. Cham: Springer, 2021, pp. 3–22.
[186] ↑ D. A. Bard, J. J. Kearney, and C. A. Perez-Delgado, “Quantum advantage on proof of work,” Array, vol. 15, p. 100225, 2022.
[187] ↑ K. Schärer and M. Comuzzi, “The quantum threat to blockchain: summary and timeline analysis,” Quantum Machine Intelligence, vol. 5, no. 1, p. 19, 2023.
[188] ↑ H. Shekhawat and D. S. Gupta, “Quantum-resistance blockchain-assisted certificateless data authentication and key exchange scheme for the smart grid metering infrastructure,” Pervasive and Mobile Computing, vol. 100, p. 101919, 2024.
[189] ↑ J. Gomes, S. Khan, and D. Svetinovic, “Fortifying the blockchain: A systematic review and classification of post-quantum consensus solutions for enhanced security and resilience,” IEEE Access, vol. 11, pp. 74 088–74 100, 2023.
[190] ↑ N. K. Sinai and H. P. In, “Performance evaluation of a quantum-resistant blockchain: a comparative study with secp256k1 and schnorr,” Quantum Information Processing, vol. 23, no. 3, p. 99, 2024.
[191] ↑ J. Chen, W. Gan, M. Hu, and C.-M. Chen, “On the construction of a post-quantum blockchain for smart city,” Journal of information security and applications, vol. 58, p. 102780, 2021.
[192] ↑ S. Akhai and V. Kumar, “Quantum resilience and distributed trust: The promise of blockchain and quantum computing in defense,” in Sustainable Security Practices Using Blockchain, Quantum and Post-Quantum Technologies for Real Time Applications. Springer, 2024, pp. 125–153.
[193] ↑ M. Shuaib, N. H. Hassan, S. Usman, S. Alam, S. M. Sam, and G. A. N. Samy, “Effect of quantum computing on blockchain-based electronic health record systems,” in 2022 4th International Conference on Smart Sensors and Application (ICSSA). IEEE, 2022, pp. 179–184.
[194] ↑ S. Siddiqui, S. Hameed, S. A. Shah, A. K. Khan, and A. Aneiba, “Smart contract-based security architecture for collaborative services in municipal smart cities,” Journal of Systems Architecture, vol. 135, p. 102802, 2023.
[195] ↑ S. Wang, L. Ouyang, Y. Yuan, X. Ni, X. Han, and F.-Y. Wang, “Blockchain-enabled smart contracts: architecture, applications, and future trends,” IEEE Transactions on Systems, Man, and Cybernetics: Systems, vol. 49, no. 11, pp. 2266–2277, 2019.
[196] ↑ Y. Kethepalli, R. Joseph, S. R. Vajrala, J. Vemula, and N. S. Naik, “Reinforcing security and usability of crypto-wallet with post-quantum cryptography and zero-knowledge proof,” arXiv preprint arXiv:2308.07309, 2023.
[197] ↑ S. Mohanty, S. Sharma, P. K. Pattnaik, and A. Hol, “A comprehensive review on cyber security and online banking security frameworks,” Risk Detection and Cyber Security for the Success of Contemporary Computing, pp. 1–22, 2023.
[198] ↑ F. A. Fahim et al., “Comparative analysis between security models for enhancement of network security in 6G technology,” Ph.D. dissertation, Department of Electronic and Telecommunication Engineering, 2022.
[199] ↑ L. Malina, P. Dzurenda, S. Ricci, J. Hajny, G. Srivastava, R. Matulevičius, A.-A. O. Affia, M. Laurent, N. H. Sultan, and Q. Tang, “Post-quantum era privacy protection for intelligent infrastructures,” IEEE Access, vol. 9, pp. 36 038–36 077, 2021.
[200] ↑ R. Zhang, R. Xue, and L. Liu, “Security and privacy on blockchain,” ACM Computing Surveys (CSUR), vol. 52, no. 3, pp. 1–34, 2019.
[201] ↑ V. Vasani, K. Prateek, R. Amin, S. Maity, and A. D. Dwivedi, “Embracing the quantum frontier: Investigating quantum communication, cryptography, applications and future directions,” Journal of Industrial Information Integration, p. 100594, 2024.
[202] ↑ A. H. Karbasi and S. Shahpasand, “A post-quantum end-to-end encryption over smart contract-based blockchain for defeating man-in-the-middle and interception attacks,” Peer-to-peer networking and applications, vol. 13, pp. 1423–1441, 2020.
[203] ↑ C. Mangla, S. Rani, N. M. F. Qureshi, and A. Singh, “Mitigating 5G security challenges for next-gen industry using quantum computing,” Journal of King Saud University-Computer and Information Sciences, vol. 35, no. 6, p. 101334, 2023.
[204] ↑ B. Putz, F. Menges, and G. Pernul, “A secure and auditable logging infrastructure based on a permissioned blockchain,” Computers & Security, vol. 87, p. 101602, 2019.
[205] ↑ Y. Li, W. Susilo, G. Yang, Y. Yu, X. Du, D. Liu, and N. Guizani, “Toward privacy and regulation in blockchain-based cryptocurrencies,” IEEE Network, vol. 33, no. 5, pp. 111–117, 2019.
[206] ↑ I. Kong, M. Janssen, and N. Bharosa, “Realizing quantum-safe information sharing: Implementation and adoption challenges and policy recommendations for quantum-safe transitions,” Government Information Quarterly, vol. 41, no. 1, p. 101884, 2024.
[207] ↑ K. DeRose, “Establishing the legal framework to regulate quantum computing technology,” Cath. UJL & Tech, vol. 31, p. 145, 2022.
[208] ↑ B. S. White, C. G. King, and J. Holladay, “Blockchain security risk assessment and the auditor,” Journal of Corporate Accounting & Finance, vol. 31, no. 2, pp. 47–53, 2020.
[209] ↑ S. B. Kahyaoğlu, “An evaluation of accounting and auditing framework within the quantum perspective,” Southern African Journal of Accountability and Auditing Research, vol. 25, no. 1, pp. 1–5, 2023.
[210] ↑ A.-T. Ciulei, M.-C. Cre\textcommabelow tu, and E. Simion, “Preparation for post-quantum era: a survey about blockchain schemes from a post-quantum perspective,” Cryptology ePrint Archive, 2022.
[211] ↑ W. G. Johnson, “Governance tools for the second quantum revolution,” Jurimetrics, vol. 59, no. 4, pp. 487–522, 2019.
[212] ↑ V. Malik, R. Mittal, D. Mavaluru, B. R. Narapureddy, S. B. Goyal, R. J. Martin, K. Srinivasan, and A. Mittal, “Building a secure platform for digital governance interoperability and data exchange using blockchain and deep learning-based frameworks,” IEEE Access, vol. 11, pp. 70 110–70 131, 2023.
[213] ↑ M. Aurangzeb, Y. Wang, S. Iqbal, A. Naveed, Z. Ahmed, M. Alenezi, and M. Shouran, “Enhancing cybersecurity in smart grids: Deep black box adversarial attacks and quantum voting ensemble models for blockchain privacy-preserving storage,” Energy Reports, vol. 11, pp. 2493–2515, 2024.
[214] ↑ Y. Ma, S. Goyal, A. S. Rajawat, P. Bedi, and S. Yasmeen, “Blockchain-based human intelligent systems for smart city safety,” Transactions on Emerging Telecommunications Technologies, vol. 35, no. 2, p. e4939, 2024.
[215] ↑ M. Kassen, “Blockchain and digital governance: Decentralization of decision making policy,” Review of Policy Research, vol. 42, no. 1, pp. 95–121, 2025.
[216] ↑ K. Ikeda, “Chapter seven - security and privacy of blockchain and quantum computation,” in Blockchain Technology: Platforms, Tools and Use Cases, ser. Advances in Computers. Elsevier, 2018, vol. 111, pp. 199–228.
[217] ↑ P. Radanliev, “Cyber diplomacy: defining the opportunities for cybersecurity and risks from artificial intelligence, IoT, blockchains, and quantum computing,” Journal of Cyber Security Technology, pp. 1–51, 2024.
[218] ↑ K. R. Ku-Mahamud, M. Omar, N. A. A. Bakar, and I. D. Muraina, “Awareness, trust, and adoption of blockchain technology and cryptocurrency among blockchain communities in malaysia,” International Journal on Advanced Science, Engineering & Information Technology, vol. 9, no. 4, pp. 1217–1222, 2019.
[219] ↑ A. Mashatan and D. Heintzman, “The complex path to quantum resistance,” Communications of the ACM, vol. 64, no. 9, pp. 46–53, 2021.
[220] ↑ S. Banaeian Far and M. Rajabzadeh Asaar, “A blockchain-based quantum-secure reporting protocol,” Peer-to-Peer Networking and Applications, vol. 14, no. 5, pp. 2992–3011, 2021.
[221] ↑ Open Quantum Safe, “OQS algorithm performance visualizations,” https://openquantumsafe.org/benchmarking/, Open Quantum Safe Project.
[222] ↑ J. Allen, R. Alley, A. Seira, and C. Watsky, “Governance of permissionless blockchain networks,” Board of Governors of the Federal Reserve System (US), Tech. Rep., 2024.
[223] ↑ D. Marchsreiter, “Towards quantum-safe blockchain: Exploration of PQC and public-key recovery on embedded systems,” Cryptology ePrint Archive, 2024.
[224] ↑ H. Chen, M. Pendleton, L. Njilla, and S. Xu, “A survey on Ethereum systems security: Vulnerabilities, attacks, and defenses,” ACM Computing Surveys (CSUR), vol. 53, no. 3, pp. 1–43, 2020.
[225] ↑ F. Sinigaglia, R. Carbone, G. Costa, and N. Zannone, “A survey on multi-factor authentication for online banking in the wild,” Computers & Security, vol. 95, p. 101745, 2020.
[226] ↑ Z. Chen, X. Sun, X. Shan, and J. Zhang, “Decentralized mining pool games in blockchain,” in 2020 IEEE International Conference on Knowledge Graph (ICKG), 2020, pp. 426–432.
[227] ↑ R. Tyler, “Battle begins to stop quantum computers smashing cyber defences,” The Times, 2023.
[228] ↑ G. Zhang, F. Pan, Y. Mao, S. Tijanic, M. Dang'ana, S. Motepalli, S. Zhang, and H.-A. Jacobsen, “Reaching consensus in the Byzantine empire: A comprehensive review of BFT consensus algorithms,” ACM Computing Surveys, vol. 56, no. 5, pp. 1–41, 2024.
[229] ↑ Linux-Foundation's-PQC-Alliance, “Open quantum safe LibOQS,” https://openquantumsafe.org/liboqs/, accessed: 2025-08-05.
[230] ↑ PQClean Contributors, “PQClean: Clean, portable, tested implementations of post-quantum cryptography,” https://github.com/PQClean/PQClean, 2024.
[231] ↑ The FALCON Developers, “FALCON: Fast-Fourier Lattice-based Compact Signatures over NTRU,” https://falcon-sign.info/, accessed: 18 June 2025.
[232] ↑ W. Li, Z. Liu, J. Chen, Z. Liu, and Q. He, “Towards blockchain interoperability: A comprehensive survey on cross-chain solutions,” Blockchain: Research and Applications, p. 100286, 2025.
[233] ↑ Z. Deng, C. Tang, T. Li, Z. Zeng, P. Abla, and D. He, “SFPoW: Constructing secure and flexible proof-of-work sidechains for cross-chain interoperability with wrapped assets,” IEEE Transactions on Computers, vol. 74, no. 7, pp. 2278–2292, 2025.
[234] ↑ L. D. Negka and G. P. Spathoulas, “Blockchain state channels: A state of the art,” IEEE Access, vol. 9, pp. 160 277–160 298, 2021.
[235] ↑ Ethereum Foundation, “Zero-knowledge rollups,” https://ethereum.org/en/developers/docs/scaling/zk-rollups/, 2024, accessed: June 2025.
[236] ↑ V. Lyubashevsky, G. Seiler, and P. Steuer, “The LaZer library: Lattice-based zero knowledge and succinct proofs for quantum-safe privacy,” in Proceedings of the 2024 on ACM SIGSAC Conference on Computer and Communications Security, ser. CCS '24. ACM, 2024, p. 3125–3137.
[237] ↑ R. Naz and D. A. Kumar, “Surveying quantum-proof blockchain security: The era of exotic signatures,” in Proceedings of the 25th International Conference on Distributed Computing and Networking, 2024, pp. 412–417.
[238] ↑ P. Tsankov, A. Dan, D. Drachsler-Cohen, A. Gervais, F. Buenzli, and M. Vechev, “Securify: Practical security analysis of smart contracts,” in Proceedings of the 2018 ACM SIGSAC conference on computer and communications security, 2018, pp. 67–82.
[239] ↑ K. Nilgün Karaca and A. Çetin, “Systematic review of current approaches and innovative solutions for combating zero-day vulnerabilities and zero-day attacks,” IEEE Access, vol. 13, pp. 102 071–102 091, 2025.
[240] ↑ R. Ahmad, I. Alsmadi, W. Alhamdani, and L. Tawalbeh, “Zero-day attack detection: a systematic literature review,” Artificial Intelligence Review, vol. 56, no. 10, pp. 10 733–10 811, 2023.
[241] ↑ K. Schierbauer, “Performance measurement of quantum-resistant algorithms in blockchain networks,” Ph.D. dissertation, University of Applied Sciences, 2024.
[242] ↑ U.S. Government Accountability Office, “Blockchain in finance: Legislative and regulatory actions are needed to ensure comprehensive oversight of crypto assets,” https://www.gao.gov/assets/gao-23-105346.pdf, 2023.
[243] ↑ N. Alnahawi, A. Wiesmaier, T. Grasmeyer, J. Geißler, A. Zeier, P. Bauspieß, and A. Heinemann, “On the state of post-quantum cryptography migration,” in INFORMATIK 2021. Gesellschaft für Informatik, Bonn, 2021, pp. 907–941.
[244] ↑ M. De Stefano, F. Pecorelli, D. Di Nucci, F. Palomba, and A. De Lucia, “Software engineering for quantum programming: How far are we?” Journal of Systems and Software, vol. 190, p. 111326, 2022.
[245] ↑ N. Bindel, U. Herath, M. McKague, and D. Stebila, “Transitioning to a quantum-resistant public key infrastructure,” in International Workshop on Post-Quantum Cryptography. Springer, 2017, pp. 384–405.
[246] ↑ M. Barenkamp, “"steal now, decrypt later" post-quantum-kryptografie & ki,” Informatik Spektrum, vol. 45, no. 6, pp. 349–355, 2022.
[247] ↑ F. D, “Terminology for Post-Quantum Traditional Hybrid Schemes,” https://www.ietf.org/archive/id/draft-ietf-pquip-pqt-hybrid-terminology-04.html, 2024, work in Progress.
[248] ↑ N. Alnahawi, N. Schmitt, A. Wiesmaier, A. Heinemann, and T. Grasmeyer, “On the state of crypto-agility,” Cryptology ePrint Archive, 2023.
[249] ↑ T. Nolan, “Bip 199: Hashed time-locked contract transactions,” https://github.com/bitcoin/bips/blob/master/bip-0199.mediawiki, 2013, accessed: 2025-06-20.
[250] ↑ X. Hu, W. Cheng, S. Bai, C. Ma, and Y. Liu, “Quantum-safe hash time-locked cross-chain transaction mechanism,” in Big Data and Data Science Engineering. Springer, 2025, pp. 79–92.
[251] ↑ M. Herlihy, “Atomic cross-chain swaps,” in Proceedings of the 2018 ACM Symposium on Principles of Distributed Computing, ser. PODC '18. ACM, 2018, p. 245–254.
[252] ↑ X. Jia, Z. Yu, J. Shao, R. Lu, G. Wei, and Z. Liu, “Cross-chain virtual payment channels,” IEEE Transactions on Information Forensics and Security, vol. 18, pp. 3401–3413, 2023.
[253] ↑ A. I. Weinberg, P. Petratos, and A. Faccia, “Will central bank digital currencies (CBDC) and blockchain cryptocurrencies coexist in the post quantum era?” Discover Analytics, vol. 3, no. 1, p. 8, 2025.
[254] ↑ Y.-X. Wang and Y.-L. Hsueh, “A low-storage synchronization framework for blockchain systems,” Journal of Network and Computer Applications, vol. 231, p. 103977, 2024.
[255] ↑ Y. Wang, Z. Su, J. Ni, N. Zhang, and X. Shen, “Blockchain-empowered space-air-ground integrated networks: Opportunities, challenges, and solutions,” IEEE Communications Surveys & Tutorials, vol. 24, no. 1, pp. 160–209, 2022.
[256] ↑ R. R. Irshad, S. Hussain, I. Hussain, J. A. Nasir, A. Zeb, K. M. Alalayah, A. A. Alattab, A. Yousif, and I. M. Alwayle, “IoT-enabled secure and scalable cloud architecture for multi-user systems: A hybrid post-quantum cryptographic and blockchain-based approach toward a trustworthy cloud computing,” IEEE Access, vol. 11, pp. 105 479–105 498, 2023.
[257] ↑ H. Abusalah, C. Kamath, K. Klein, K. Pietrzak, and M. Walter, “Reversible proofs of sequential work,” in Advances in Cryptology – EUROCRYPT 2019. Cham: Springer, 2019, pp. 277–291.
[258] ↑ W. Zuo, R. J. Mondragon, A. Raman, and G. Tyson, “Understanding and improving content moderation in Web3 platforms,” in Proceedings of the International AAAI Conference on Web and Social Media (ICWSM), vol. 18, no. 1, 2024, pp. 1859–1870.
[259] ↑ B. Luo, Z. Zhang, Q. Wang, and B. He, “Multi-chain graphs of graphs: A new approach to analyzing blockchain datasets,” in Proceedings of the 38th Conference on Neural Information Processing Systems (NeurIPS), Datasets and Benchmarks Track, 2024.
[260] ↑ N. Kumar, A. Singh, A. Handa, and S. K. Shukla, “Detecting malicious accounts on the Ethereum blockchain with supervised learning,” in Cyber Security Cryptography and Machine Learning. Cham: Springer, 2020, pp. 94–109.
[261] ↑ X. Xu, C. Pautasso, L. Zhu, Q. Lu, and I. Weber, “A pattern collection for blockchain-based applications,” in Proceedings of the 23rd European Conference on Pattern Languages of Programs, ser. EuroPLoP '18. ACM, 2018.
[262] ↑ X. Zhang, H. Zhu, and J. Zhou, “Shoreline: Data-driven threshold estimation of online reserves of cryptocurrency trading platforms,” in Proceedings of the AAAI Conference on Artificial Intelligence, vol. 34, no. 01, 2020, pp. 1194–1201.
[263] ↑ M. R. Albrecht, V. Cini, R. W. F. Lai, G. Malavolta, and S. A. Thyagarajan, “Lattice-based SNARKs: Publicly verifiable, preprocessing, and recursively composable,” in Advances in Cryptology – CRYPTO 2022. Cham: Springer, 2022, pp. 102–132.
[264] ↑ B. Bünz, B. Fisch, and A. Szepieniec, “Transparent SNARKs from DARK compilers,” in Advances in Cryptology – EUROCRYPT 2020. Cham: Springer, 2020, pp. 677–706.
[265] ↑ “Abelian: Quantum resistant blockchain,” https://www.abelian.info/home/.
[266] ↑ J. O. Chervinski, D. Kreutz, X. Xu, and J. Yu, “Analyzing the performance of the inter-blockchain communication protocol,” in 2023 53rd Annual IEEE/IFIP International Conference on Dependable Systems and Networks (DSN), 2023, pp. 151–164.
[267] ↑ J. Li, D. Guo, and L. Ren, “Close latency-security trade-off for the nakamoto consensus,” in Proceedings of the 3rd ACM Conference on Advances in Financial Technologies, 2021, pp. 100–113.
[268] ↑ S. Nakamoto, “Bitcoin: A peer-to-peer electronic cash system,” 2008.
[269] ↑ V. Buterin et al., “Ethereum white paper,” GitHub repository, vol. 1, pp. 22–23, 2013.
[270] ↑ F. Armknecht, G. O. Karame, A. Mandal, F. Youssef, and E. Zenner, “Ripple: Overview and outlook,” in Trust and Trustworthy Computing: 8th International Conference, TRUST 2015, Heraklion, Greece, August 24-26, 2015, Proceedings 8. Springer, 2015, pp. 163–180.
[271] ↑ M. L. F. Jumaili and S. M. Karim, “Comparison of tow cryptocurrencies: Bitcoin and Litecoin,” in Journal of Physics: Conference Series, vol. 1963, no. 1. IOP Publishing, 2021, p. 012143.
[272] ↑ D. Hopwood, S. Bowe, T. Hornby, N. Wilcox et al., “Zcash protocol specification,” GitHub: San Francisco, CA, USA, vol. 4, no. 220, p. 32, 2016.
[273] ↑ J. Zhang, T. Xie, Y. Zhang, and D. Song, “Transparent polynomial delegation and its applications to zero knowledge proof,” in 2020 IEEE Symposium on Security and Privacy (SP). IEEE, 2020, pp. 859–876.
[274] ↑ S. Ames, C. Hazay, Y. Ishai, and M. Venkitasubramaniam, “Ligero,” in Proceedings of the 2017 ACM SIGSAC Conference on Computer and Communications Security (CCS '17). ACM, October 2017, pp. 2087–2104.
[275] ↑ E. Ben-Sasson, A. Chiesa, M. Riabzev, N. Spooner, M. Virza, and N. P. Ward, “Aurora: Transparent succinct arguments for R1CS,” in Advances in Cryptology – EUROCRYPT 2019, ser. Lecture Notes in Computer Science. Springer, 2019, vol. 11476, pp. 103–128.
[276] ↑ W. Beullens and G. Seiler, “LaBRADOR: Compact proofs for R1CS from module-SIS,” in Advances in Cryptology – CRYPTO 2023. Cham: Springer, 2023, pp. 518–548.
[277] ↑ E. Ben-Sasson, I. Bentov, Y. Horesh, and M. Riabzev, “Scalable zero knowledge with no trusted setup,” in Advances in Cryptology – CRYPTO 2019. Cham: Springer, 2019, pp. 701–732.
[278] ↑ A. R. Ağırtaş, A. B. Özer, Z. Saygı, and O. Yayla, “Distributed verifiable random function with compact proof.” Springer-Verlag, 2024, p. 119–134.
[279] ↑ H. Wee and D. J. Wu, “Succinct vector, polynomial, and functional commitments from lattices,” in Advances in Cryptology – EUROCRYPT 2023. Cham: Springer, 2023, pp. 385–416.
[280] ↑ V. Lyubashevsky, N. K. Nguyen, and G. Seiler, “SMILE: Set membership from ideal lattices with applications to ring signatures and confidential transactions,” in Advances in Cryptology – CRYPTO 2021. Cham: Springer, 2021.
[281] ↑ QRL, “The quantum resistant ledger (QRL),” https://www.theqrl.org/.
[282] ↑ Komodo Platform, “Dilithium: A Quantum-Secure Blockchain Solution,” https://komodoplatform.com/en/blog/dilithium-quantum-secure-blockchain/.
[283] ↑ Nexus, “Nexus: Connecting a decentralized world,” https://nexus.io.
[284] ↑ “Tidecoin: Quantum resistant cryptocurrency,” https://tidecoin.co/.
[285] ↑ “Quantum resistance overview: Lacnet,” https://lacnet.lacchain.net/quantum-resistance-overview/.
[286] ↑ “Qanplatform: Quantum-resistant hybrid blockchain,” https://www.qanplatform.com/en.
[287] ↑ “Hcash: Quantum-resistant cryptocurrency,” https://h.cash/.
[288] ↑ IOTA, “IOTA Foundation,” https://www.iota.org/.
[289] ↑ D. A. McGrew, M. Sala, and S. Fluhrer, “Recommendation for Stateful Hash-Based Signature Schemes,” https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-208.pdf, National Institute of Standards and Technology, Tech. Rep. NIST SP 800-208, October 2020.
[290] ↑ P. P. Ray, “Web3: A comprehensive review on background, technologies, applications, zero-trust architectures, challenges and future directions,” Internet of Things and Cyber-Physical Systems, vol. 3, pp. 213–248, 2023.
[291] ↑ V.-L. Nguyen, L.-H. Nguyen, R.-H. Hwang, B. Canberk, and T. Q. Duong, “Quantum machine learning for 6G network intelligence and adversarial threats,” IEEE Communications Standards Magazine, pp. 1–1, 2025.
[292] ↑ C. Ren, R. Yan, H. Zhu, H. Yu, M. Xu, Y. Shen, Y. Xu, M. Xiao, Z. Y. Dong, M. Skoglund, D. Niyato, and L. C. Kwek, “Toward quantum federated learning,” IEEE Transactions on Neural Networks and Learning Systems, pp. 1–22, 2025.
[293] ↑ V.-L. Nguyen, P.-C. Lin, B.-C. Cheng, R.-H. Hwang, and Y.-D. Lin, “Security and privacy for 6g: A survey on prospective technologies and challenges,” IEEE Communications Surveys & Tutorials, vol. 23, no. 4, pp. 2384–2428, 2021.
[294] ↑ A. W. Harrow, A. Hassidim, and S. Lloyd, “Quantum algorithm for linear systems of equations,” Physical Review Letters, vol. 103, no. 15, p. 150502, 2009.
[295] ↑ Y.-A. Chen and X.-S. Gao, “Quantum algorithm for boolean equation solving and quantum algebraic attack on cryptosystems,” Journal of Systems Science and Complexity, vol. 35, no. 1, pp. 373–412, 2022.
[296] ↑ K. Blekos, D. Brand, A. Ceschini, C.-H. Chou, R.-H. Li, K. Pandya, and A. Summer, “A review on quantum approximate optimization algorithm and its variants,” Physics Reports, vol. 1068, pp. 1–66, 2024, a review on Quantum Approximate Optimization Algorithm and its variants.
[297] ↑ A. Chailloux and J. Loyer, “Lattice sieving via quantum random walks,” in Advances in Cryptology – ASIACRYPT 2021. Cham: Springer, 2021, pp. 63–91.
[298] ↑ D. J. Bernstein, “Post-quantum cryptography,” in Encyclopedia of Cryptography, Security and Privacy. Cham: Springer, 2025, pp. 1846–1847.
[299] ↑ L. Masure, C. Dumas, and E. Prouff, “A comprehensive study of deep learning for side-channel analysis,” IACR Transactions on Cryptographic Hardware and Embedded Systems, vol. 2020, no. 1, pp. 348–375, November 2019.
[300] ↑ G. Brassard, P. Høyer, and A. Tapp, “Quantum amplitude amplification and estimation,” Contemporary Mathematics, vol. 305, pp. 53–74, 2002.
[301] ↑ S. Sharma and R. Sharma, “Forecasting transactional amount in Bitcoin network using temporal GNN approach,” in Proceedings of the 2020 IEEE/ACM International Conference on Advances in Social Networks Analysis and Mining (ASONAM). IEEE, 2020, pp. 478–485.
[302] ↑ U. Arshad, A. Tubaishat, A. Ullah, Z. Halim, and S. Anwar, “Blockchain-enhanced machine learning for dynamic routing and secure communications in autonomous vehicle networks,” in Proceedings of the AAAI 2025 Summer Symposium Series, 2025.
[303] ↑ C. G. Akcora, M. Kantarcioglu, and Y. R. Gel, “Data science on blockchains,” in Proceedings of the 27th ACM SIGKDD Conference on Knowledge Discovery & Data Mining, ser. KDD '21. ACM, 2021, p. 4025–4026.
[304] ↑ T. Kim, H. Shin, H. J. Hwang, and S. Jeong, “Posting bot detection on blockchain-based social media platform using machine learning techniques,” in Proceedings of the International AAAI Conference on Web and Social Media (ICWSM), vol. 15, no. 1, 2021, pp. 303–314.
[305] ↑ M.-Y. Day, “Artificial intelligence for knowledge graphs of cryptocurrency anti-money laundering in fintech,” in Proceedings of the 2021 IEEE/ACM International Conference on Advances in Social Networks Analysis and Mining, ser. ASONAM '21. ACM, 2022, p. 439–446.
[306] ↑ C. G. Akcora, Y. Li, Y. R. Gel, and M. Kantarcioglu, “BitcoinHeist: Topological data analysis for ransomware prediction on the Bitcoin blockchain,” in Proceedings of the Twenty-Ninth International Joint Conference on Artificial Intelligence, IJCAI-20, July 2020, pp. 4439–4445, special Track on AI in FinTech.
[307] ↑ Y. Elmougy and L. Liu, “Demystifying fraudulent transactions and illicit nodes in the Bitcoin network for financial forensics,” in Proceedings of the 29th ACM SIGKDD Conference on Knowledge Discovery and Data Mining, ser. KDD '23. ACM, 2023, p. 3979–3990.
[308] ↑ L. Cheng, F. Zhu, Y. Wang, R. Liang, and H. Liu, “Evolve path tracer: Early detection of malicious addresses in cryptocurrency,” in Proceedings of the 29th ACM SIGKDD Conference on Knowledge Discovery and Data Mining, ser. KDD '23. ACM, 2023, p. 3889–3900.
[309] ↑ W. Chen, X. Guo, Z. Chen, Z. Zheng, and Y. Lu, “Phishing scam detection on Ethereum: Towards financial security for blockchain ecosystem,” in Proceedings of the Twenty-Ninth International Joint Conference on Artificial Intelligence (IJCAI), 2020, pp. 4506–4512.
[310] ↑ E. Wenger, M. Chen, F. Charton, and K. E. Lauter, “SALSA: Attacking lattice cryptography with transformers,” in Advances in Neural Information Processing Systems, vol. 35. Curran Associates, Inc., 2022, pp. 34 981–34 994.
[311] ↑ H. Wang, R. Bie, and T. Hoang, “An efficient and zero-knowledge classical machine learning inference pipeline,” IEEE Transactions on Dependable and Secure Computing, vol. 22, no. 2, pp. 1347–1364, 2025.
[312] ↑ B.-J. Chen, S. Waiwitlikhit, I. Stoica, and D. Kang, “ZKML: An optimizing system for ML inference in zero-knowledge proofs,” in Proceedings of the Nineteenth European Conference on Computer Systems, ser. EuroSys '24. ACM, 2024, p. 560–574.
[313] ↑ S. Ranjbar Alvar, M. Akbari, D. M. X. Yue, and Y. Zhang, “NFT-based data marketplace with digital watermarking,” in Proceedings of the 29th ACM SIGKDD Conference on Knowledge Discovery and Data Mining, ser. KDD '23. ACM, 2023, p. 4756–4767.
[314] ↑ M. Sporny, D. Longley, M. Sabadello, D. Reed, O. Steele, and C. Allen, “Decentralized Identifiers (DIDs) v1.1,” https://www.w3.org/TR/did-1.1/, 2025.
[315] ↑ I. Damgård, C. Orlandi, A. Takahashi, and M. Tibouchi, “Two-round n n -out-of- n n and multi-signatures and trapdoor commitment from lattices,” Journal of Cryptology, vol. 35, no. 14, 2022.
[316] ↑ H. Corrigan-Gibbs, A. Henzinger, Y. Tauman Kalai, and V. Vaikuntanathan, “Somewhat homomorphic encryption from linear homomorphism and sparse LPN,” in Advances in Cryptology – EUROCRYPT 2025, S. Fehr and P.-A. Fouque, Eds. Cham: Springer, 2025, pp. 3–33.
[317] ↑ P.-C. Chen, T.-H. Kuo, and J.-L. Wu, “A study of the applicability of ideal lattice-based fully homomorphic encryption scheme to Ethereum blockchain,” IEEE Systems Journal, vol. 15, no. 2, pp. 1528–1539, 2021.
[318] ↑ Z. Hao, B. Zhang, and H. Li, “DCHM: Dynamic collaboration of heterogeneous models through isomerism learning in a blockchain-powered federated learning framework,” in Proceedings of the AAAI Conference on Artificial Intelligence, vol. 39, no. 16, 2025, pp. 17 077–17 084.
[319] ↑ A. Castiglione, J. G. Esposito, V. Loia, M. Nappi, C. Pero, and M. Polsinelli, “Integrating post-quantum cryptography and blockchain to secure low-cost IoT devices,” IEEE Transactions on Industrial Informatics, vol. 21, no. 2, pp. 1674–1683, 2025.
[320] ↑ S. B. Balija, A. Nanda, and D. Sahoo, “Building communication efficient asynchronous peer-to-peer federated LLMs with blockchain,” in Proceedings of the AAAI Symposium Series, vol. 3, no. 1, 2024, pp. 288–292.
[321] ↑ K. Mansoor, M. Afzal, W. Iqbal, and Y. Abbas, “Securing the future: exploring post-quantum cryptography for authentication and user privacy in IoT devices,” Cluster Computing, vol. 28, no. 2, p. 93, 2025.
[322] ↑ T. Wang, L. Deng, C. Wang, J. Lian, Y. Yan, N. J. Yuan, Q. Zhang, and H. Xiong, “COMET: NFT price prediction with wallet profiling,” in Proceedings of the 30th ACM SIGKDD Conference on Knowledge Discovery and Data Mining, ser. KDD '24. ACM, 2024, p. 5893–5904.
Report Issue
Report GitHub Issue
Title:
Content selection saved. Describe the issue below:
Description:
Submit without GitHub Submit in GitHub
Report Issue for Selection
Generated by L A T E xml[LOGO]
Instructions for reporting errors
We are continuing to improve HTML versions of papers, and your feedback helps enhance accessibility and mobile support. To report errors in the HTML that will help us improve conversion and rendering, choose any of the methods listed below:
Click the "Report Issue" button.
Open a report feedback form via keyboard, use " Ctrl + ?".
Make a text selection and click the "Report Issue for Selection" button near your cursor.
You can use Alt+Y to toggle on and Alt+Shift+Y to toggle off accessible reporting links at each section.
Our team has already identified the following issues. We appreciate your time reviewing and reporting rendering errors we may not have found yet. Your efforts will help us improve the HTML versions for all readers, because disability should not be a barrier to accessing research. Thank you for your continued support in championing open access for all.
Have a free development cycle? Help support accessibility at arXiv! Our collaborators at LaTeXML maintain a list of packages that need conversion, and welcome developer contributions.