# CRYSTALS-Dilithium-April2018.pdf - NIST Computer Security Resource Center

- **ID**: `b243a1e4-087b-493e-ae97-33f32bc3cc9c`
- **Tipo de Fuente**: `SOURCE_TYPE_PDF`
- **URL**: [https://csrc.nist.gov/CSRC/media/Presentations/Crystals-Dilithium/images-media/CRYSTALS-Dilithium-April2018.pdf](https://csrc.nist.gov/CSRC/media/Presentations/Crystals-Dilithium/images-media/CRYSTALS-Dilithium-April2018.pdf)

---

## Contenido Extraído / Texto Completo

CRYSTALS 
(Cryptographic Suite for Algebraic Lattices) 
CCA KEM: Kyber Digital Signature: Dilithium 
www.pq-crystals.org 
Roberto Avanzi – ARM Joppe Bos – NXP  Leo Ducas – CWI Eike Kiltz – RUB  Tancrede Lepoint – SRI  
Vadim Lyubashevsky – IBM Research John Schanck – U. Waterloo Peter Schwabe – U. Radboud Gregor Seiler – IBM Research Damien Stehle – ENS Lyon
Lattice Cryptography
Easy Problem 
 
A y z 
Given (A,z), find y 
Easy! Just invert A and multiply by z 
mod p
Hard Problem 
 
A ey z 
Small coefficients to enforce uniqueness 
Given (A,z), find (y,e) 
Seems hard (would have many positive noncryptographic applications if it were easy).  
mod p
Hard Problem 
 
Given (A,z), find (y,e) 
Seems hard.  
mod p
Why is this “Lattice” Crypto? 
All solutions 𝒚𝒚𝒆𝒆 to Ay+e=z mod p form a “shifted” lattice. 
We want to find the point closest to the origin  (BDD Problem).
Brief History 
 Lattices studied algorithmically at least since 1982 (LLL) 
 Algebraic lattices since at least 1996 (NTRU) 
 Lattices over Zp[X]/(Xn+1) since at least 2008 (SWIFFT) 
 Last 10 years – one of the hottest area in cryptography. Lots of attention and some interesting algorithms discovered 
But … 0 attacks against lattice crypto based on (Module-) SIS / LWE 
 Parameters were increased (around 50%) due to conservative considerations of “sieving” attacks requiring exponential space
CRYSTALS Math
Operations 
Only two main operations needed (and both are very fast): 
1. Evaluations of SHAKE256 (can use another XOF too) 2. Operations in the polynomial ring  R = Zp[X]/(X256+1) 
prime p = 213 – 29 + 1  (for Kyber) prime p = 223 – 213 + 1 (for Dilithium) 
Very easy to adjust security because the same hardware/software can be reused
Ring Choice Rationale 
 256-dimensional rings are “just right” 
Large enough to efficiently encrypt 256-bit keys Allow for a large enough challenge space for signatures Allow for enough “granularity” to get the security we 
want 
 Zp[X]/(Xn+1), for a prime p, has been the most widely-used ring in the literature 
Very easy to use and the most efficient one Has a lot of properties that are useful in more advanced 
constructions
Basic Computational Domain: Polynomial ring Zp[x]/(x256+1) 
Operations used in the schemes: 
small coefficients 
Operations
Modular Security 
768-dim 
1024-dim 
to increase the security margin 
CRYSTALS-Dilithium 
Leo Ducas – CWI Eike Kiltz – RUB  Tancrede Lepoint – SRI  
Vadim Lyubashevsky – IBM Research Peter Schwabe – U. Radboud Gregor Seiler – IBM Research Damien Stehle – ENS Lyon
[Lyu ‘09] “Fiat-Shamir with Aborts” 
Digital Signature 
[GLP ‘12] [BG ‘14] 
Signature Compression 
Dilithium Public Key + Signature 
Compression 
[HHPSW ‘03] Use NTRU trapdoor for 
Signatures 
[GPV ‘08] Made it Secure via Gaussian Sampling 
FALCON BLISS [DDLL ‘13] 
Bimodal Gaussian Sampling 
[Lyu ‘12] Gaussian Rejection 
Sampling SIS + LWE Based 
Based on NTRU Uses Discrete Gaussian Sampling 
Based on (Module-) LWE / SIS Uses Uniform Sampling 
Additionally useful for IBE Additionally useful for ZK-Proofs 
 
Digital Signatures Overview
Signatures with Uniform Sampling  [Lyu ‘09]  …  [BG ‘14] 
Public key A:=XOF(seed) 
uniform mod p 
Public key t:=As1+s2 
Secret key s1, s2 with 
coefficients in {-5,…,5}
As1+s2=t 
Sign(μ) 
y Coefficients in [-γ, γ] c := H(high(Ay), μ) z := y + cs1 If |z| > γ – β or |low(Ay - cs2)|> γ – β 
restart Signature = (z, c) 
Verify(z, c, μ) 
Check that |z| ≤ γ – β and 
c=H(high(Az - ct) , μ) 
Ay - cs2 
Signatures with Uniform Sampling  [Lyu ‘09]  …  [BG ‘14] 
Needed for security
As1+s2=t 
Sign(μ) 
y Coefficients in [-γ, γ] c := H(high(Ay), μ) z := y + cs1 If |z| > γ – β or |low(Ay - cs2)|> γ – β 
restart Signature = (z, c) 
Verify(z, c, μ) 
Check that |z| ≤ γ – β and 
c=H(high(Az - ct) , μ) 
Ay - cs2 
 
Signatures with Uniform Sampling  [Lyu ‘09]  …  [BG ‘14] 
Needed for correctness 
max(|cs2|)
As1+s2=t0+bt1 
Sign(μ) 
y Coefficients in [-γ, γ] c := H(high(Ay), μ) z := y + cs1 If |z| > γ – β or |low(Ay - cs2)|> γ – β 
restart Signature = (z, c) 
Verify(z, c, μ) 
Check that |z| ≤ γ – β and 
c=H(high(Az - cbt1) , μ) 
Ay - cs2 + ct0 
Want high(Ay - cs2) = high(Ay - cs2 + ct0) 
Chopping off Low-Order PK bits
The Carry Hint Vector 
Want high(Ay - cs2) = high(Ay - cs2 + ct0) 
The signer knows   Ay - cs2 + ct0   and   ct0 
The verifier knows Ay - cs2 + ct0 
Ay - cs2 + ct0 
- ct0 
Ay - cs2 
 
Carry bit 
Each 23-bit coefficient
Dilithium (high-level overview) 
As1+s2=t0+bt1Sign(μ) 
y Coefficients in [-γ, γ] c := H(high(Ay), μ) z := y + cs1 If |z| > γ – β or |low(Ay - cs2)|> γ – β 
restart Create carry bit hint vector h Signature = (z, h, c) 
Verify(z, c, μ) 
Check that |z| ≤ γ – β and 
c=H(high(h “+” Az - cbt1) , μ) 
high(Ay - cs2) 
Hint h 
 adds 100 – 200 bytes to the signature 
Parameters for CRYSTALS-Dilithium 
( > 128-bit quantum security) 
5 x 4 matrices 6 x 5 matrices 
Public Key ≈ 1.5 KB ≈ 1.8 KB 
Signature ≈ 2.7 KB ≈ 3.4 KB Public key generation / verification:  > 10,000 per second Signing :  > 3,000 per second
Security Reductions
Signature Scheme Security 
(Proof framework for Fiat-Shamir Schemes in the ROM) 
Real Signature Scheme 
1. A1 gets the public key and access to hash H 
2. A1 asks signature queries 
3. A1 forges a signature 
Hybrid 1 
1. A2 gets the public key and access to hash H 
2. A2 forges a signature 
≤ 
 Reduction in the QROM [Unr ‘17] 
 Tight reduction in the QROM if the 
signing is deterministic [KLS ‘18] 
InteractiveNon-Interactive 
Math Problem ≤ 
Non-Interactive and no hash H 
1. A3 gets math problem 2. A3 solves math problem
Dilithium Security 
Input:  random A, t, and an XOF H Output: short s1, s2, c and μ such that 
H(As1 + s2 - tc, μ) = c 
Input: random A, t Output: short s1, s2 and c such that 
As1 + s2 - tc =0 ≤ 
Non-tight reduction in the ROM using rewinding 
(Module)-SIS + (Module)-LWE Hybrid 1 (Self-Target SIS) 
Tight in the QROMNon-tight in the ROM
The Same as Schnorr Signatures 
Input:  random A, t, and an XOF H Output: short s1, s2, c and μ such that 
H(As1 + s2 - tc, μ) = c 
Input: random A, t Output: short s1, s2 and c such that 
As1 + s2 - tc =0 ≤ 
(Module)-SIS + (Module)-LWE Hybrid 1 (Self-Target SIS) 
Tight in the QROMNon-tight in the ROM 
Input:  random g, h, and an XOF H Output: x, c and μ such that 
H(gx hc, μ) = c 
Input: random g,h Output:  x, c such that 
gxhc = 1 ≤ 
Discrete Log “Self-Target Discrete Log”
Is the “Self-Target” Assumption Worrisome in the QROM? 
 We believe not 
 No example where using “rewinding” in the proof left the scheme vulnerable to a quantum attacker 
 Analogous to computationally-binding classical commitments not having a proof in the QROM 
(and there is no NIST competition for post-quantum commitments)  
Base on (Module-)LWE in the QROM? 
recommended high 
Public Key ≈ 1.5 KB ≈ 1.8 KB 
Signature ≈ 2.7 KB ≈ 3.4 KB 
recommended high 
Public Key                    5X larger ≈ 7.7 KB ≈ 9.6 KB 
Signature                     2X larger ≈ 5.7 KB ≈ 7.1 KB 
 
Dilithium 
“Katz-Wang” Tight Dilithium [AFLT ‘12, ABB+ ‘15, Unr ‘17, KLS ‘18] 
Basis for Our Parameter Settings 
LWE parameters (i.e. secret key recovery) used the recently en vogue sieving analysis 
SIS parameters (i.e. message forgery) – the same analysis + improved (potential) algorithm for  l∞ - SIS
Possible Trade-Offs (open to community suggestions) 
 Smaller secret key coefficients e.g. {-5,…,5}  {-1,0,1} 
 Signatures will be smaller 
 Makes combinatorial hybrid attacks more likely and gets further away from 
WC-AC parameters 
 Module-LWE Module-LWR 
 (Maybe) a slight reduction in the key size 
 Probably nothing goes wrong with security if sk coefficients are large enough 
 Increase the rejection probability 
 Slower, but smaller signatures