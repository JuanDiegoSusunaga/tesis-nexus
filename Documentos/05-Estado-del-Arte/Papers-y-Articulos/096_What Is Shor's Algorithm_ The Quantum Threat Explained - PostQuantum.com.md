# What Is Shor's Algorithm? The Quantum Threat Explained - PostQuantum.com

- **ID**: `411065c3-0dcd-41b5-a982-ce64793ae8bc`
- **Tipo de Fuente**: `SOURCE_TYPE_WEB_PAGE`
- **URL**: [https://postquantum.com/quantum-security-reference/what-is-shors-algorithm/](https://postquantum.com/quantum-security-reference/what-is-shors-algorithm/)

---

## Contenido Extraído / Texto Completo

What Is Shor's Algorithm? The Quantum Threat Explained
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
Home/ Quantum Security Reference/ What Is Shor's Algorithm?
Quantum Security Reference
What Is Shor's Algorithm?
Marin Ivezic Follow on X Send an email May 4, 2026
4 minutes read 
Table of Contents
Introduction
What It Does
What It Needs
What It Has Actually Achieved
What It Does Not Threaten
What This Means for Your Organization
Go Deeper
This is part of the Quantum Security Reference Deep Dive series. For the full landscape overview, see the capstone article on quantum security.
Introduction
Shor's algorithm is a quantum algorithm that efficiently factors large integers and computes discrete logarithms, the two mathematical problems that underpin RSA, Elliptic Curve Cryptography (ECC), and Diffie-Hellman key exchange. Published by mathematician Peter Shor in 1994, it proved that a quantum computer could break the public-key cryptography protecting virtually all digital communications. Shor's algorithm is the reason post-quantum cryptography (PQC) exists.
What It Does
Classical computers struggle with certain mathematical problems that grow exponentially harder as the numbers get larger. Factoring the product of two large prime numbers is one of them. RSA encryption depends on this difficulty: multiplying two 1,024-bit primes together is trivial, but recovering those primes from the product is computationally infeasible for any classical machine. The best classical factoring algorithms would take longer than the age of the universe to break RSA-2048.
Shor's algorithm changes the complexity class of this problem. On a quantum computer, it reduces integer factorization from exponential time to polynomial time, meaning the problem becomes tractable rather than impossible. The same applies to the discrete logarithm problem, which protects ECC and Diffie-Hellman.
The implications for cybersecurity are total. RSA key exchange, ECDH key agreement, RSA signatures, ECDSA signatures, Diffie-Hellman negotiation in VPNs and TLS: all of it falls to a single algorithm. I cover the specific impact on each cryptographic family in my analysis of how ECC became the easiest quantum target.
What It Needs
Shor's algorithm cannot run on today's quantum hardware. It requires a fault-tolerant quantum computer with enough error-corrected logical qubits to sustain a computation over millions of operations without accumulating fatal errors. The machine that meets this threshold is called a Cryptographically Relevant Quantum Computer (CRQC).
The resource estimates for building a CRQC have been a moving target, and they have moved consistently in one direction.
In 2021, the best published estimate (Gidney and Ekerå) concluded that breaking RSA-2048 would require approximately 20 million physical qubits and roughly eight hours of computation. In May 2025, Gidney published an updated analysis that brought the requirement below one million physical qubits with a runtime of under one week. That 20× reduction came entirely from algorithmic and error correction improvements, not from any change in hardware assumptions. The physical error rates, qubit connectivity, and gate speeds were the same; the algorithm simply uses the machine more efficiently.
ECC may fall with even fewer resources. The Chevignard, Fouque, and Schrottenloher paper presented at EUROCRYPT 2026 estimated that breaking the P-256 curve (the most widely deployed ECC standard) requires only 1,193 logical qubits. In March 2026, Google's quantum team published research suggesting that fewer than 500,000 superconducting physical qubits could break ECC-256 in under nine minutes.
For context, the largest gate-based quantum computers today operate with a few thousand physical qubits, and their error rates are orders of magnitude above what Shor's algorithm requires. The gap is real. But five years ago, the gap was 20× larger.
What It Has Actually Achieved
Shor's algorithm has been demonstrated on real quantum hardware, but only for trivially small numbers. The largest integers factored using Shor's on a genuine quantum computer are 15 and 21. I maintain a detailed analysis of why “they've only factored 15” is the wrong way to judge quantum computing progress, and a companion piece examining the enormous gap between factoring a 48-bit number and cracking RSA-2048.
The point is not that these demonstrations are impressive. They are not, in isolation. The point is that the theoretical algorithm is proven, the resource estimates are being refined and reduced with every new paper, and the engineering trajectory of quantum hardware is pointed at eventually closing the gap. The question for security planners is not whether Shor's algorithm works (it does, mathematically). The question is how quickly the hardware will catch up.
What It Does Not Threaten
Shor's algorithm is specific. It breaks mathematical problems with a particular algebraic structure: integer factorization and discrete logarithms over finite groups. It does not threaten symmetric cryptography (AES), hash functions (SHA-256, SHA-3), or the new PQC algorithms standardized by NIST, which are built on different mathematical foundations (lattice problems, hash-based constructions, error-correcting codes).
Grover's algorithm is the quantum threat to symmetric cryptography, and its impact is far less severe: it halves effective key lengths, meaning AES-256 retains roughly AES-128 equivalent security. The existential threat to modern cryptography comes from Shor's, not Grover's.
What This Means for Your Organization
If your systems use RSA, ECC, or Diffie-Hellman (and they almost certainly do), Shor's algorithm is the reason you need to migrate to post-quantum cryptography. The HNDL threat means that data encrypted with these algorithms today is already at risk of future decryption. The TNFL threat means that digital signatures made today could be forged retroactively.
My CRQC Quantum Capability Framework tracks the engineering progress toward the machine that will run Shor's at scale. The PQC Migration Framework provides the methodology for defending against it.
Go Deeper
Breaking RSA-2048 with 20M Qubits — the 2021 baseline for comparison
How Shor's Algorithm Actually Works, Explained from Scratch — step-by-step mechanism walkthrough with no math prerequisites
Shor's Algorithm: A Quantum Threat to Modern Cryptography — full technical deep dive
How ECC Became the Easiest Quantum Target — Shor's impact across RSA, ECC, and Diffie-Hellman
Quantum Breakthrough for RSA-2048 (Gidney 2025) — the latest resource estimate
Algorithm-Level Quantum Threat to ECC (EUROCRYPT 2026) — P-256 at 1,193 logical qubits
Google Quantum vs. Bitcoin ECDLP — ECC-256 under 500K qubits
What Is a CRQC? — the machine Shor's algorithm needs
Marin Ivezic Follow on X Send an email May 4, 2026
4 minutes read
Share
X LinkedIn Reddit Flipboard WhatsApp Telegram Viber Line Share via Email Print
Marin Ivezic
I am the Founder of Applied Quantum (AppliedQuantum.com), a research-driven consulting firm empowering organizations to seize quantum opportunities and proactively defend against quantum threats. A former quantum entrepreneur, I've previously served as a Fortune Global 500 CISO, CTO, Big 4 partner, and leader at Accenture and IBM. Throughout my career, I've specialized in managing emerging tech risks, building and leading innovation labs focused on quantum security, AI security, and cyber-kinetic risks for global corporations, governments, and defense agencies. I regularly share insights on quantum technologies and emerging-tech cybersecurity at PostQuantum.com.
Website
X
LinkedIn
Related Articles
What Is Quantum Key Distribution (QKD)?
May 5, 2026
What Is a Logical Qubit?
May 4, 2026
What Is Q-Day?
May 4, 2026
What Is PQC Migration?
May 5, 2026
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