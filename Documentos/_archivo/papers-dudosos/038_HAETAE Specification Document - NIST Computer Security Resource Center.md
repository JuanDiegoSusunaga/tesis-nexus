# HAETAE Specification Document - NIST Computer Security Resource Center

- **ID**: `c85a5745-30a8-469b-bc6e-b7595829ad72`
- **Tipo de Fuente**: `SOURCE_TYPE_PDF`
- **URL**: [https://csrc.nist.gov/csrc/media/Projects/pqc-dig-sig/documents/round-1/spec-files/haetae-spec-web.pdf](https://csrc.nist.gov/csrc/media/Projects/pqc-dig-sig/documents/round-1/spec-files/haetae-spec-web.pdf)

---

## Contenido Extraído / Texto Completo

HAETAE 
Algorithm Specifications and Supporting Documentation 
Jung Hee Cheon, Hyeongmin Choe, Julien Devevey, Tim Güneysu, Dongyeon Hong, Markus Krausz, Georg Land, Junbum Shin, Damien Stehlé, MinJune Yi. 
May 31, 2023.
1 Introduction 
We introduce HAETAE1, a new post-quantum digital signature scheme, whose security is based on the hardness of the module versions of the lattice problems LWE and SIS [BGV12, LS15]. The scheme design follows the “Fiat-Shamir with Aborts” paradigm [Lyu09, Lyu12], which relies on rejection sampling: rejection sampling is used to transform a signature trial whose distribution depends on sensitive information, into a signature whose distribution can be publicly simulated. Our scheme is in part inspired from CRYSTALS-Dilithium [DKL+18], a post-quantum “Fiat-Shamir with Aborts” signature scheme which was selected for standardization by the American National Institute of Standards and Technology (NIST). HAETAE differs from Dilithium in two major aspects: (i) we use a bimodal distribution for the rejection sampling, like in the BLISS signature scheme [DDLL13], instead of a “unimodal” distribution like Dilithium, (ii) we sample from and reject to hyperball uniform distributions, instead of discrete hypercube uniform distributions. This last aspect also departs from BLISS, which relies on discrete Gaussian distributions, and follows a suggestion from [DFPS22], which studied rejection sampling in lattice-based signatures following the “Fiat-Shamir with Aborts” paradigm. 
1.1 Design rationale 
A brief recap on Fiat-Shamir with Aborts. The Fiat-Shamir with Aborts paradigm was introduced in lattice-based cryptography in [Lyu09, Lyu12]. The verification key is a pair of matrices (A,T = AS mod q), where A is a uniform matrix modulo some integer q and S is a small-magnitude matrix that makes up the secret key. A signature for a message M is comprised of an integer vector z of the form y + Sc, for some random small-magnitude y and some small-magnitude challenge c = H(Ay mod q,M). Rejection sampling is then used to ensure that the distribution of the signature becomes independent from the secret key. Finally, the verification algorithm checks that the vector z is short and that c = H(Az−Tc mod q,M). 
Improving compactness. As analyzed in [DFPS22], The choice of the distributions to sample from and reject to has a major impact on the signature size. Dilithium relies on discrete uniform distributions in hypercubes, which makes the scheme easier to implement. However, such distributions are far from optimal in terms of resulting signature sizes. We choose a different trade-off: by losing a little on ease of implementation, we obtain more compact signatures. 
Uniform distributions in hyperballs. A possibility would be to consider Gaussian distributions, which are superior to uniform distributions in hypercubes, in terms of resulting signature compactness (see, e.g., [DFPS22]). However, this choice has two downsides. First, the rejection step involves the computation of a transcendental function on an input that depends on the secret key. This is cumbersome to implement and sensitive to side-channel attacks [EFGT17]. Second, since the final signature follows a Gaussian distribution there is a nonzero probability that the final signature is too large and does not pass the verification. The signer must realise that and reject the signature, making the expected number of rejects slightly grow in practice. Uniform distributions over hyperballs have been put forward in [DFPS22] as an alternative choice of distributions leading to signatures with compactness between those obtained with Gaussians and those obtained with hypercube uniforms. Compared to Gaussians, they do not suffer from the afore-mentioned downsides: the rejection step is simply checking whether Euclidean norms are sufficiently small; and as there is no tail, there is no need for an extra rejection step to ensure that verification will pass. HAETAE showcases that this provides an interesting simplicity/compactness compromise. 
Bimodal distributions. A modification of Lyubashevsky’s signatures [Lyu09, Lyu12] was introduced in [DDLL13]. It allows for the use of bimodal distributions in the signature generation. The signature is now of the form y+(−1)bSc, where y is sampled from a fixed distribution and b ∈ {0, 1} is sampled uniformly. The 
1 The haetae is a mythical Korean lion-like creature with the innate ability to distinguish right from wrong. 
2
signature is then rejected to a given secret-independent target distribution. To make sure that the verification test passes, computations are performed modulo 2q and key generation forces the equality AS = qId. It turns out that this modification can lead to more compact signatures than the unimodal setup. In [DDLL13], the authors relied on discrete Gaussian distributions. We instead use uniform distributions over hyperballs: like for Gaussians, switching from unimodal to bimodal for hyperball-uniforms leads to more compact signatures. 
Flexible design by working with modules. The original design for BLISS [DDLL13] relies on Ring-LWE and Ring-SIS, and a variant of the key generation algorithm relied on ratios of polynomials, à la NTRU. This setup forces to choose a working polynomial ring for any desired security level. In order to offer more flexibility without losing in terms of implementation efficiency, we choose to rely on module lattices, like Dilithium, with a fixed working polynomial ring R = Z[x]/(x256 + 1) across all security levels. In our instantiations, we target the NIST PQC security levels 2, 3 and 5. Varying the security and updating the parameters is easily achievable and we provide a security estimator that is able to help one reach a given target security. 
A compact verification key. The flexibility provided by modules allows us to reduce the verification key size. Instead of taking the challenge c as a vector over R, we choose it in R: the main condition on the challenge is that it has high min-entropy, which is already the case for binary vectors over R. As a result, the secret S can be chosen as a vector over R rather than a matrix. The key-pair equation AS = qId then becomes As = qj, where j is the vector starting with 1 and then continuing with 0’s. To further compress the verification key, we use verification key truncation adopted from Dilithium by taking into account the residue modulo 2. Our key generation algorithm just creates an MLWE sample (Agen,b−a = Agensgen+egen) modulo q, where a is uniform random over Rk 
q . By truncating b as b = b1+b0, we define a k×(k+ℓ) matrix A as A = (−2(a−b1)+qj| 2Agen| 2Idk) mod 2q. The key-pair equation is satisfied for s = (1| sgen| egen−b0). The verification key consists of (Agen,a,b1). As (a| Agen) is uniformly distributed, we can generate it from a seed using an extendable output function, and the verification key is reduced to the seed and the vector b1. If we had kept the original key-pair equation AS = qId, then the appropriately modified variant of our key-generation algorithm would have led to a verification key that is a matrix (with a seed) rather than a vector (with a seed). 
Compression techniques to lower the signature size. We use two techniques to compress the signatures. First, as the verification key A is in (almost)-HNF, we can use the Bai-Galbraith technique [BG14]. Namely, the second part of the signature, which is multiplied by 2Id in the challenge computation and verification algorithm, can be aggressively compressed by cutting its low bits. This requires in turn modifying the computation of the challenge c and the verification algorithm, in order to account for this precision loss. Usually, this is done by keeping only the high bits of Ay in the computation of the challenge. However, as we multiply everything by 2, we do not keep the lowest bit of those high bits and keep the (overall) least significant bit instead. As in Dilithium, our decomposition of bits technique is a Euclidean division with a centered remainder, and we choose a representative range for modular integers that starts slightly below zero to further reduce the support of the high bits. The second compression technique, suggested in [ETWY22] in the context of lattice-based hash-and-sign signatures, concerns the choice of the binary representation of the signature. As the largest part of it consists in a vector that is far from being uniform, we can choose some entropic coding to obtain a signature size close to its entropy. In particular, as in [ETWY22], we choose the efficient range Asymmetric Numeral System to encode our signature, as it allows us to encode the whole signature and not lose a fraction of a bit per vector coordinate, like with Huffman coding. We can further apply the two techniques to the hint vector h, which is also a part of the signature, to reduce the signature sizes. 
Efficient choice of modulus. We choose the prime q to be a good prime in the sense that the ring operations can be implemented efficiently and that the decomposition of bits algorithms, are correctly operated. For 
3
ring operations, we use the Number Theoretic Transform (NTT) with a fully splitting polynomial ring. The polynomial ring R fully splits modulo q when the multiplicative group Z×q has an element of order 512, or equivalently when q = 1 mod 512. We choose q = 64513, which indeed satisfies this property. Interestingly, it fits in 16 bits, which allows dense storing on embedded devices. Furthermore, it is close to the next power of two, which is convenient for the sampling of uniform integers modulo q. 
Fixed-point algorithm for hyperball sampling. Unlike uniform Gaussian sampling or uniform hypercube sampling, uniform hyperball sampling has not been considered in the cryptographic protocols before the suggestion of [DFPS22]. To narrow the gap between the hyperball uniforms sampled in the real and the ideal world, we discretize the hyperball and bound the numerical error and their effect by analyzing their propagation. This leads to a fixed-point hyperball sampling algorithm and, therefore, the fixed-point implementation of the whole signing process. 
Deterministic and randomized version. HAETAE can be set in a deterministic or randomized mode. We focus on the deterministic version, but we also give the randomized version. Note that in the randomized version, a significant part of the signing algorithm can be executed off-line as it does not depend on the message. 
We give estimated security as well as sizes for our parameter sets in Table 1. The full parameters sets can be found in Section 3.5. The security of our signature is stated in terms of Core-SVP hardness, as introduced in [ADPS16]. We target the core-SVP classical hardness of the known attacks against the three proposed instantiations of HAETAE to be at least 120, 180 and 260, respectively. The numbers between parentheses refer to the strong unforgeability in the case of the randomized version of the signature scheme (for the deterministic version, strong and weak unforgeability are the same). The parameter M refers to the number of average rejections during signing. The KeyRate is the key rejection rate in the key generation algorithm. The parameter η refers to the infinity norm of the secret key sgen. The parameter τ refers to the Hamming weight of the binary challenge c ∈ R. The parameter d refers to the bit truncated from the verification key. The sizes are given in bytes. For the signature sizes, we give the average signature sizes when using rANS coding. 
1.2 Advantages and limitations 
Advantages 
– Our scheme relies on the difficulty of hard lattice problems, which have been well-studied for a long time. – Signature sizes are 30% to 40% smaller than those of Dilithium at comparable security levels, and 
verification keys are 20% to 25% smaller. – Implementation-wise, while our design rationale departs from Dilithium’s, the scheme remains implemen-
tation-friendly. In particular, 
 the rejection step only involves computations of Euclidean norms, 
 the whole signing process can be implemented with fixed-point arithmetic 
 a significant message-independent part of signing can be performed “off-line”, for the randomized version of the scheme. 
Comparison with hash-and-sign lattice signatures. In terms of ease of implementation, our scheme favorably compares to lattice signatures based on the hash and sign paradigm such as Falcon [FHK+17] and Mitaka [EFG+22a]. HAETAE, Falcon and Mitaka all three rely on some form of Gaussian sampling, which are typically difficult to implement and protect against side-channel attacks. Falcon makes sequential calls to a Gaussian sampler over Z with arbitrary centers. Mitaka also relies on an integer Gaussian sampler with arbitrary centers, but the calls to it can be massively parallelized. It also uses a continuous Gaussian sampler, which is arguably simpler. HAETAE, however, only relies on a (zero-centered) continuous Gaussian 
4
Parameter set HAETAE-120 HAETAE-180 HAETAE-260 NIST Security level 2 3 5 
q 64513 64513 64513 M 6.0 5.0 6.0 
Key Rate 0.1 0.25 0.1 (k, ℓ) (2,4) (3,6) (4,7) η 1 1 1 τ 58 80 128 αh 512 512 256 d 1 1 0 
Forgery BKZ block-size b 409 (333) 617 (512) 878 (735) Classical hardness 119 (97) 180 (149) 256 (214) Quantum hardness 105 (85) 158 (131) 225 (188) 
Key-Recovery BKZ block-size b 428 810 988 Classical hardness 125 236 288 Quantum hardness 109 208 253 
Signature size 1463 2337 2908 Public key size 992 1472 2080 
Sum 2455 3809 4988 Private key size 1376 2080 2720 
Table 1: HAETAE parameters sets. Hardness is measured with the Core-SVP methodology. 
sampler, used to sample uniformly in hyperballs. The calls to it can also be massively parallelized. This difference makes HAETAE possible to have a fixed-point signing algorithm and easier maskings. Further, in the randomized version of the signature scheme, these samples can be computed off-line as they are independent from the message to be signed. The on-line tasks are far simpler than those of Falcon and Mitaka. Finally, we note that key-generation is much simpler for HAETAE than in Falcon and Mitaka. 
Limitations 
– The key generation algorithm restarts if the secret key does not satisfy the key rejection condition. This makes the key generation algorithm of HAETAE slower than Dilithium’s. 
– While HAETAE is simpler from an implementation perspective, its verification key and signature sizes are larger than Falcon’s and Mitaka’s. 
5
2 Preliminaries 
2.1 Notations 
Matrices are denoted in bold font and upper case letters (e.g., A), while vectors are denoted in bold font and lowercase letters (e.g., y or z1). The i-th component of a vector is denoted with subscript i (e.g., yi for the i-th component of y). 
Every vector is a column vector. We denote concatenation between vectors by putting the rows below as (u,v) and the columns on the right as (u|v). We naturally extend the latter notation to concatenations between matrices and vectors (e.g., (A|b) or (A|B)). 
We let R = Z[x]/(xn + 1) be a polynomial ring where n is a power of 2 integer and for any positive integer q the quotient ring Rq = Z[x]/(q, xn+1) = Zq[x]/(x 
n+1). We abuse notations and identify R2 with the set of elements in R with binary coefficients. We also let RR = R[x]/(xn + 1) be a polynomial ring over real numbers. For an integer η, we let Sη denote the set of polynomials of degree less than n with coefficients in [−η, η] ∩ Z. Given y = ( 
∑ 0≤i<n yi x 
i, · · · , ∑ 
0≤i<n ynk−n+i x i)⊤ ∈ Rk (or Rk 
R), we define its ℓ2-norm as 
the ℓ2-norm of the corresponding “flattened” vector ∥y∥2 = ∥(y0, · · · , ynk−1)⊤∥2. Let BR,m(r, c) = {x ∈ Rm 
R |∥x − c∥2 ≤ r} denote the continuous hyperball with center c ∈ Rm and radius r > 0 in dimension m > 0. When c = 0, we omit it. Let B(1/N)R,m(r, c) = (1/N)Rm ∩ BR,m(r, c) denote the discretized hyperball with radius r > 0 and center c ∈ Rm in dimension m > 0 with respect to a positive integer N . When c = 0, we omit it. Given a measurable set X ⊆ Rm of finite volume, we let U(X) denote the continuous uniform distribution over X. It admits x 7→ χX(x)/Vol(X) as a probability density, where χX is the indicator function of X and Vol(X) is the volume of the set X. For the normal distribution over R centered at µ with standard deviation σ, we use the notation N (µ, σ). 
For a positive integer α, we define r mod± α as the unique integer r′ in the range [−α/2, α/2) satisfying the relation r = r′ mod α. We also define r mod+ α as the unique integer r′ in the range [0, α) that satisfies r = r′ mod α. We denote the least significant bit of an integer r with LSB(r). We naturally extend this to integer polynomials and vectors of integer polynomials, by applying it component-wise. 
2.2 Lattice assumptions 
We first recall the well-known lattice assumptions MLWE and MSIS on algebraic lattices. 
Definition 1 (Decision-MLWEn,q,k,ℓ,η). For positive integers q, k, ℓ, η and the dimension n of R, we say that the advantage of an adversary A solving the decision-MLWEn,q,k,ℓ,η problem is 
AdvMLWE n,q,k,ℓ,η(A) = 
∣∣Pr [b = 1 | A← Rk×ℓ q ;b← Rk 
q ; b← A(A,b) ] 
− Pr [ b = 1 | A← Rk×ℓ 
q ; (s1, s2)← Sℓ η × Sk 
η ; b← A(A,As1 + s2) ] ∣∣. 
Definition 2 (Search-MSISn,q,k,ℓ,β). For positive integers q, k, ℓ, a positive real number β and the dimension n of R, we say that the advantage of an adversary A solving the search-MSISn,q,k,ℓ,β problem is 
AdvMSIS n,q,k,ℓ,β(A) = Pr 
[ 0 < ∥y∥2 < β ∧ 
(A | Idk) · y = 0 mod q A← Rk×ℓ 
q ;y← A(A) 
] . 
2.3 Bimodal hyperball rejection sampling 
Recently, Devevey et al. [DFPS22] conducted a study of rejection sampling in the context of lattice-based Fiat-Shamir with Aborts signatures. They observe that (continuous) uniform distributions over hyperballs can be used to obtain compact signatures, with a relatively simple rejection procedure. To make masking easier, HAETAE uses (discretized) uniform distributions over hyperballs, in the bimodal context. The proof of the following lemma is available in Appendix B. 
6
Lemma 1 (Bimodal Hyperball Rejection Sampling). Let n be the degree of R, c > 1, r, t,m > 0, and r′ ≥ 
√ r2 + t2. Define M = 2(r′/r)mn and set 
N ≥ 1 
c1/(mn) − 1 
√ mn 
2 
( c1/(mn) 
r + 
1 
r′ 
) . 
Let v ∈ Rm ∩ B(1/N)R,m(t). Let p : Rm → {0, 1/2, 1} be defined as follows 
p(z) = 
 0 if ∥z∥ ≥ r, 
1/2 else if ∥z− v∥ < r′ ∧ ∥z+ v∥ < r′, 
1 otherwise. 
Then there exists M ′ ≤ cM such that the output distributions of the two algorithms from Figure 2 are identical. 
−v v 
Fig. 1: The HAETAE eyes 
Figure 1 illustrates (the continuous version) of the rejection sampling that we consider. The black circles have radii equal to r′ and the pink circle has radius r. We sample a vector z uniformly inside one of the black circles (with probability 1/2 for each) and keep z with p(z) = 1/2 if z lies in the blue zone, with probability p(z) = 1 if it lies inside the pink circle but not in the blue zone, and with probability p(z) = 0 everywhere else. 
A(v) : 1: y← U(B(1/N)R,m(r′)) 2: b← U({0, 1}) 3: z← y + (−1)bv 4: return z with probability p(z) 5: else return ⊥ 
B : 
1: z← U(B(1/N)R,m(r)) 2: return z with probability 1/M ′ 
3: else return ⊥ 
Fig. 2: Bimodal hyperball rejection sampling 
2.4 Sampling in a continuous hyperball-uniform 
We explain how to sample from a uniform continuous hyperballl distribution. Multiple strategies exist, and the one we choose is such that a k-dimensional module sample is obtained using only kn+2 one-dimensional continuous Gaussian samples: 
7
y← U(BR,k(r ′′)) 
1: yi ← N (0, 1) for i = 0, · · · , nk + 1 2: L← ∥(y0, · · · , ynk+1) 
⊤∥2 3: y← r′′/L · ( 
∑n−1 i=0 yi x 
i, · · · , ∑n−1 
i=0 ynk−n+i x i)⊤ ∈ Rk 
R 
4: return y 
Fig. 3: Continuous hyperball uniform sampling 
Lemma 2 ([VGS17]). The distribution of the output of the algorithm in Figure 3 is U(BR,k(r ′′)). 
2.5 Challenge sampling 
The challenges we use are polynomials c ∈ R with binary coefficients and some of them are nonzero. The challenge space has size 
( n τ 
) if exactly τ coefficients are nonzero. To sample such challenges we rely on the 
(binary version of) SampleInBall algorithm from Dilithium, which we recall in Fig. 4. 
SampleInBall(ρ, τ) 
1: initialize c = c0c1 . . . c255 = 00 . . . 0 2: For i = 256− τ to 255 3: j ← {0, . . . , i} 4: ci = cj 5: cj = 1 6: return c 
Fig. 4: Challenge sampling algorithm 
For the highest security, however, we require 255 bits of entropy for the challenge, which cannot be reached with 
( 256 τ 
) . To achieve it, we replace the challenge sampling for the parameter set with the following. 
Given a 256-bits hash w0 . . . w255 with Hamming weight w, do the following. If w < 128, return ∑255 
i=0 wix i. 
If w = 128, return ∑255 
i=0 wi ⊗w0x i. Otherwise, return 
∑255 i=0 wi ⊗ 1xi. Exactly half of all binary polynomials 
are reachable this way, which means that the challenge set has size 2255 as desired. 
2.6 High and low bits 
In our scheme, the signature is comprised of a vector z, which we split in two, and a polynomial c. The upper part of z is split between its high and low bits, and the high bits are compressed. The lower part of z is not sent, and we instead send a so-called hint. Our technique may be reminiscent of the one from Dilithium [DKL+18], which shares the high-level idea. We first recall the Euclidean division with a centered remainder. 
Lemma 3. Let a ≥ 0 and b > 0. It holds that 
a = 
⌊ a+ b/2 
b 
⌋ · b+ (a mod± b), 
and this writing as a = bq + r with r ∈ [−b/2, b/2) is unique. 
We define our base decomposition function. 
8
Definition 3 (High and low bits). Let r ∈ Z and α be a power of two. Successively define r1 = ⌊(r + α/2)/α⌋ and r0 = r mod± α. Finally, define the tuple: 
(LowBits(r, α),HighBits(r, α)) = (r0, r1). 
We extend these definitions to vectors by applying them component-wise. We state that this decomposition lets us recover the original element and bound the components of the decomposition. 
Lemma 4. Let α be a power of two. Let q > 2 be a prime with α|2(q − 1) and r ∈ Z. Then it holds that 
r = α · HighBits(r, α) + LowBits(r, α), 
LowBits(r, α) ∈ [−α/2, α/2), r ∈ [0, 2q − 1] =⇒ HighBits(r, α) ∈ [0, (2q − 1)/α] . 
Proof. By Lemma 3, there exists a unique representation 
r = ⌊(r + α/2)/α⌋α+ (r mod± α). 
By identifying HighBits(r, α) and LowBits(r, α) in the above equation, we obtain the first result. 
Next, by definition of mod ±, we have that r′ ∈ [−α/2, α/2). For the second range, since r 7→ ⌊(r + α/2)/α⌋ is a non-decreasing function, it is sufficient to show 
that ⌊(2q−1+α/2)/α⌋ ≤ ⌊(2q − 1)/α⌋. By assumption on q, we have (2q−1+α/2) ≤ ⌊(2q−1)/α⌋α+α−1. Dividing by α and taking the floor yields the result. 
⊓⊔ 
We define HighBitsz1(r) = HighBits(r, 256) and LowBitsz1(r) = LowBits(r, 256). 
High and low bits for hint In order to produce the hint that we send instead of the lower part of z, we could use the previous bit decomposition. However, as noted in [DKL+18, Appendix B] in a preliminary version, a slight modification allows to further reduce the entropy of the hint. 
The idea is to pack the high bits in the range [0, 2(q−1)/αh). This is possible if we use the range [−αh/2− 2, 0) to represent the integers that are close to 2q − 1. 
Definition 4 (High and low bits for hint). Let r ∈ Z. Let q be a prime and αh|2(q − 1) be a power of two. Let m = 2(q − 1)/αh and 
r1 = HighBits(r mod+ 2q, αh) and r0 = LowBits(r mod+ 2q, αh). 
If r1 = m, let (r′0, r ′ 1) = (r0 − 2, 0). 
Else, (r′0, r ′ 1) = (r0, r1). We define: 
(LowBitsh(r),HighBitsh(r)) = (r′0, r ′ 1). 
As before, we extend these definitions to vectors by applying them component-wise. We state that this decomposition lets us recover the original element and bound the decomposition components. 
Lemma 5. Let r ∈ Z. Let q be a prime, αh|2(q− 1) be a power of two and define m = 2(q− 1)/αh. It holds that 
r = αh · HighBitsh(r) + LowBitsh(r) mod 2q, 
LowBitsh(r) ∈ [−αh/2− 2, αh/2), 
HighBitsh(r) ∈ [0,m− 1] . 
9
Proof. Let r ∈ [0, 2q − 1]. Let r0, r1, r ′ 0, and r′1 defined as in Definition 4. If r′0 = r0 and r′1 = r1, the 
equality r′0 + r′1 · αh = r0 + r1 · αh mod 2q holds vacuously. 
If not, then r′0 = r0 − 2 and r′1 = r1 − 2(q − 1)/αh and r′0 + r′1αh = r0 + r1αh − 2q. By Lemma 4, we get the first equality. 
The second property stems from the second property in Lemma 4. The modifications to r0 make r′0 lie in the range [−αh/2− 2, αh/2). 
The last property stems from the third property in Lemma 4 and the fact that if r1 = m, then we have r′1 = 0. 
⊓⊔ 
10
3 Specification 
3.1 Key generation 
When using bimodal rejection sampling, the verification step relies on a key pair (A, s) ∈ Rk×(k+ℓ) p ×Rk+ℓ 
p 
such that As = −As mod p. To generate such a pair, following [DDLL13], we choose p = 2q and aim at As = qj mod 2q for j = (1, 0, . . . , 0)⊤. 
Key generation and encoding To build a key pair (A, s) satisfying the above, we start by generating an 
MLWE sample b−a = A0s0+e0 mod q, where A0 ← U(Rk×(ℓ−1) q ), a← U(Rk 
q ) and (s0, e0)← U(Sℓ−1 η ×Sk 
η ). For any b = b1 + b0, we define A = (2(a − b1) + qj|2A0|2Ik) as well as s = (1|s0|(e0 − b0)). One sees that As = qj mod 2q. In practice, the verification key is then comprised of b1 and the seed that allows generating A0 and a. The secret key is the seed used to generate s and (A0,a). 
It remains to choose the decomposition of b, that we see as an nk-dimensional vector with coordinates in [0, q − 1]. We choose b0 with coordinates in {−1, 0, 1} such that if a coordinate of b is odd, then it is rounded to the nearest multiple of 4. We can then write b = b0+2b1, where b1 is encoded using ⌈log2(q)− 1⌉ bits per coordinate. This is computed coordinate-wise with b0 = (−1)⌊b/2⌋ mod 2b mod 2, i.e. one less bit than b. In all of the following, we let (LowBitsvk(b),HighBitsvk(b)) denote (b0,b1). When b is uniform, we notice that the coordinates of b0 roughly follow a (centered) binomial law with parameters (2, 1/2), which experimentally leads to smaller choices for β, which we discuss and introduce now. 
Rejection sampling on the key A critical step of our scheme is bounding ∥sc∥2, where s is generated as before and c ∈ R is a polynomial with coefficients in {0, 1} and has less than or equal to τ nonzero coefficients. The lower this bound is, the smaller the signature is, which in turn leads to harder forging. In the key generation algorithm, we apply the following rejection condition for some heuristic value β: 
τ · m∑ i=1 
i-th max 
j ∥s(ωj)∥22 + r · 
(m+1)-th max 
j ∥s(ωj)∥22 ≤ 
nβ2 
τ , 
where m = ⌊n/τ⌋ and r = n mod τ . We argue that the left hand side is a bound on n τ · ∥sc∥ 
2 2 and that this 
condition leads to asserting ∥sc∥2 ≤ β. 
Lemma 6. For any c ∈ {0, 1}n with hamming weight τ and a secret s ∈ Sk+ℓ η , n∥cs∥22 is bounded by 
τ2 · m∑ i=1 
i-th max 
j ∥s(ωj)∥22 + r · τ · 
(m+1)-th max 
j ∥s(ωj)∥22, 
where m = ⌊n/τ⌋ and r = n mod τ . 
Proof. We first rewrite ∥sc∥2 as: 
∥sc∥22 = 
∑ i |c(ωj)|2 · ∥s(ωj)∥22 
n , 
where s(ωj) = (s1(ωj), · · · , sk+ℓ(ωj)), and ωj ’s are the primitive 2n-th roots of unity. Let m = ⌊n/τ⌋ and r = n mod τ . Since 
∑n j=1 |c(ωj)|2 = nτ and 
|c(ωj)|2 = | ωj,1 + · · ·+ ωj,τ |2 ≤ τ2, 
we can bound ∑n 
j=1 |c(ωj)|2 ·∥s(ωj)∥22 by rearrangement: let m = ⌊n/τ⌋ be the maximum number of |c(ωj)|2’s that can be τ2. By sorting ∥s(ωj)∥2 in a decreasing order, 
∥s(ωσ(1))∥2 ≥ ∥s(ωσ(2))∥2 ≥ · · · ≥ ∥s(ωσ(n))∥2, 
11
where σ is a permutation for the indices, we have 
n∑ j=1 
|c(ωj)|2 · ∥s(ωj)∥22 ≤ m∑ j=1 
|c(ωσ(j))|2 · ∥s(ωσ(j))∥22 + n∑ 
j=m+1 
|c(ωσ(j))|2 · ∥s(ωσ(m+1))∥22. 
Then it reaches the maximum when the m largest ∥s(ωj)∥22’s are multiplied with τ2’s, i.e., 
n∑ j=1 
|c(ωj)|2 · ∥s(ωj)∥22 ≤ m∑ j=1 
τ2 · ∥s(ωσ(j))∥22 + ( n∑ 
j=1 
|c(ωj)|2 −mτ2 ) · ∥s(ωσ(j))∥22 
= τ2 · m∑ j=1 
∥s(ωσ(j))∥22 + r · τ · ∥s(ωσ(j))∥22. 
⊓⊔ 
3.2 Discrete hyperball sampling 
In orger to generate y from Figure 2 using the continuous hyperball uniform sampling from Figure 3, we apply a rounding-and-reject strategy which allows to generate rightly distributed samples. 
y← U(B(1/N)R,m(r′)) 
1: y← U(BR,m(Nr′ + √ mn/2)) 
2: if ∥⌊y⌉∥2 ≤ Nr′, return ⌊y⌉/N 3: else, restart 
Fig. 5: Discrete hyperball uniform sampling 
Lemma 7. Let n be the degree of R, M0 ≥ 1, r′,mi,N > 0. At each iteration, the algorithm from Figure 5 succeeds with probability ≥ 1/M0 and the distribution of the output is U(B(1/N)R,m(r′)) if we set 
N ≥ √ mn 
2r′ · M 
1/(mn) 0 + 1 
M 1/(mn) 0 − 1 
. 
We note that with this rounding step, we do not need to handle the exact values of y, we just need enough precision to make sure the rounding is correct. The proof of this lemma can also be found in Appendix B. 
We now have all necessary ingredients in Figures 1, 2, 3, and 5 to make sure the resulting distribution of z is indeed uniform over the discretized hyperball. Thanks to Lemma 7 and Lemma 1, we already know the level of precision required for y to maintain the provable security of HAETAE. We analyze in Appendix C the required precision from a fix-point Gaussian sampler to obtain a y with such precision. 
3.3 Signature encoding 
To encode a signature, we will split some of its components into low and high bits. If we correctly choose the number of low bits, they will be distributed almost uniformly. The high bits on the other hand, will then follow a distribution with a very small variance and can be considerably compressed with a suitable encoding. While Huffman coding would be applied on each coordinate at a time, an arithmetic coding encodes the entire coordinates in a single number. In contrast to Huffman coding, arithmetic coding gets close to entropy also for alphabets, where the probabilities of the symbols are not powers of two. We recall a recent type 
12
of entropy coding, named range Asymmetric Numeral systems (rANS) [Dud13], that encodes the state in a natural number and thus allows faster implementations. As a stream variant, rANS can be implemented with finite precision integer arithmetic by using renormalization. Furthermore, it is possible to avoid arithmetic operations altogether and realize high-speed implementations using lookup tables (tANS). 
Definition 5 (Range Asymmetric Numeral System (rANS) Coding). Let n > 0 and S ⊆ [0, 2n−1]. Let g : [0, 2n−1]→ Z∩(0, 2n] such that 
∑ x∈S g(x) ≤ 2n and g(x) = 0 for all x /∈ S. We define the following: 
 CDF : S → Z, defined as CDF(s) = ∑s−1 
y=0 g(y). 
 symbol : Z→ S, where symbol(y) is defined as s ∈ S satisfying CDF(s) ≤ y < CDF(s+ 1). 
 C : Z× S → Z, defined as 
C(x, s) = 
⌊ x 
g(s) 
⌋ · 2n + (x mod+ g(s)) + CDF(s). 
Then, we define the rANS encoding/decoding for the set S and frequency g/2n as in Figure 6. 
Encode((s1, · · · , sm) ∈ Sm) 
1: x0 = 0 2: for i = 0, · · · ,m− 1 do 3: xi+1 = C(xi, si+1) 4: Return xm 
Decode(x ∈ Z) 1: y0 = x 2: i = 0 3: while yi > 0 do 4: ti+1 = symbol(yi mod+ 2n) 5: yi+1 = ⌊yi/2n⌋ ·g(ti+1)+(yi mod+ 2n)−CDF(ti+1) 6: i← i+ 1 7: m = i− 1 8: return (tm, · · · , t1) ∈ Sm 
Fig. 6: rANS encoding and decoding procedures 
Lemma 8 (Adapted from [Dud13]). The rANS coding is correct, and the size of the rANS code is asymptotically equal to Shannon entropy of the symbols. That is, for any choice of s = (s1, · · · , sm) ∈ Sm, Decode(Encode(s)) = s. Moreover, for any positive x and any probability distribution p over S, it holds that∑ 
s∈S p(s) log(C(x, s)) ≤ log(x) + 
∑ s∈S 
p(s) log 
( g(s) 
2n 
) + 
2n 
x . 
Finally, the cost of encoding the first symbol is ≤ n, i.e., for any x ∈ S, we have log(C(0, s)) ≤ n. 
We determine the frequency of the symbols experimentally, by executing the signature computation and collecting several million samples. Finally, we apply some rounding strategy in order to heuristically minimize the empirical entropy 
∑ s∈S p(s) log(g(s)/2n). 
3.4 Specification of HAETAE 
Readers who are not familiar with the Fiat-Shamir with Aborts line of work may first check the uncompressed version of the scheme in Appendix A. We give the description of the signature scheme HAETAE in Figure 7 with the following building blocks: 
 Hash function Hgen for generating the seeds and hashing the messages, 
 Hash function H for signing, returning ρ, a seed for challenge sampling, 
 Extendable output function expandA for deriving a and Agen from seedA, 
13
 Extendable output function expandS for deriving sgen and egen from seedsk and countersk, 
 Extendable output function expandYbb for deriving y, b and b′ from seedybb and counter, 
The above building blocks can be implemented with symmetric primitives. Specifically, we use SHAKE256 for the hash functions and Extendable output functions, except for expandA. In all of the following sections, we let j = (1, 0, . . . , 0) ∈ Rk. The parameters ρ0 and αh refer to the size of the seed and the compression factor, respectively. The parameter β is the bound for ∥cs∥, which will be checked by bounding 
f(s) := τ · m∑ i=1 
i-th max 
j ∥s(ωj)∥22 + r · 
(m+1)-th max 
j ∥s(ωj)∥22 
by nβ2/τ . The parameters B, B′, and B′′ refer to the radii of hyperballs. At Step 2 of the Sign algorithm, the variable y0 ∈ RR refers to the first component of the vector y ∈ Rk+ℓ 
R . At Step 3 of the Sign algorithm, the 
vector z ∈ Rk+ℓ R is decomposed as z = (z1, z2) with z1 ∈ Rℓ 
R and z2 ∈ Rk R. At Step 4 of the Verify algorithm, 
the variable z̃0 ∈ R refers to the first component of the vector z̃ ∈ Rk+ℓ. We assume that q and αh satisfy the assumptions from Lemma 5. 
Note that at Step 6 of the Verify algorithm, the division by 2 is well-defined as the operand is even. 
We also give a randomized signing of HAETAE in Figure 8. We observe that in the randomized version signing process, significant part of signing including the hyperball sampling algorithms for y can be performed “off-line”, i.e., before receiving a message M to be signed. It holds for computations such as w = A ⌊y⌉ and HighBitsh(w). In the “on-line” phase of signing, we can use y and the corresponging pre-computed components by choosing them randomly among the pre-sampled list. 
Lemma 9. We borrow the notations from Figure 7. If we run Verify(vk,M, σ) on the signature σ returned by Sign(sk,M) for an arbitrary message M and an arbitrary key-pair (sk, vk) returned by KeyGen(1λ), then the following relations hold: 
1) w1 = HighBitsh(w), 2) w′j = LSB(⌊y0⌉) · j = LSB(w) = LSB(w − 2 ⌊z2⌉). 3) 2⌊z2⌉ − 2z̃2 = LowBitsh(w)− LSB(w) assuming it holds that B′ + αh/4 + 1 ≤ B′′ < q/2, 
Proof. Let m = 2(q − 1)/αh. Let us prove the first statement. By definition of h, it holds that w1 = HighBitsh(w) mod m. However, the latter part of the equality already lies in [0,m − 1] by Lemma 5. The first part lies in the same range as we reduce mod+ m. Hence, the equality stands over Z too. 
We move on to the second statement. By considering only the first component of z = y + (−1)bc · s, we obtain, modulo 2: 
z̃0 = ⌊z0⌉ = ⌊y0⌉+ (−1)bc = ⌊y0⌉+ c. 
This yields the result. Moreover, considering everywhere a 2 appears in the definition of A, we obtain that 
w = A1⌊z1⌉ − qcj = (⌊z0⌉ − c)j mod 2. 
For the last statement, let us use the two preceding results. In particular, we note the identity 
w1 · αh + w′j = w − LowBitsh(w) + LSB(w). 
We note that the last two elements have same parity, as the former one has the same parity as LowBits(w, αh). By Lemma 5 their sum has infinite norm ≤ αh/2 + 2. Hence from its definition, it holds that 
2z̃2 = 2⌊z2⌉ − LowBitsh(w) + LSB(w) mod ±2q. 
Finally, this holds over the integers as the right-hand side has infinite norm at most 2B′+αh/2+ 2 < q. ⊓⊔ 
Theorem 1 (Completeness). Assume that B′′ = B′ + √ 
n(k + ℓ)/2 + √ nk · (αh/4 + 1) < q/2. Then the 
signature schemes of Figures 7 and 8 are complete, i.e., for every message M and every key-pair (sk, vk) returned by KeyGen(1λ), we have Verify(vk,M, Sign(sk,M)) = 1. 
14
KeyGen(1λ) 
1: seed← {0, 1}ρ0 2: (seedA, seedsk,K) = Hgen(seed) 3: (a| Agen) ∈ Rk×ℓ 
q := expandA(seedA) 4: countersk = 0 5: (sgen, egen) := expandS(seedsk, countersk) 6: b = a+Agen · sgen + egen mod q // b ∈ Rk 
q 
7: (b0,b1) = (LowBitsvk(b),HighBitsvk(b)) 
8: A = (2(a− b1) + qj| 2Agen| 2Idk) mod 2q // A ∈ Rk×(k+ℓ) 2q 
9: s = (1, sgen, egen − b0) // s ∈ Sk+ℓ η 
10: if f(s) > nβ2/τ then go to 5 11: return sk = (s,K), vk = (seedA,b1) 
Sign(sk,M) 
1: µ = Hgen(seedA,b1,M) 2: seedybb = Hgen(K,µ) 3: counter = 0 4: (y, b, b′) := expandYbb(seedybb, counter) 5: w = A ⌊y⌉ 6: ρ = H(HighBitsh(w), LSB(⌊y0⌉), µ) 7: c = SampleInBall(ρ, τ) 8: z = (z1, z2) = y + (−1)bc · s 9: h = HighBitsh(w)− HighBitsh(w − 2 ⌊z2⌉) mod+ 2(q−1) 
αh 
10: if ∥z∥2 ≥ B′, then counter++ and go to 4 11: else if ∥2z− y∥2 < B and b′ = 0, then counter++ and go to 4 12: else return σ = (Encode(HighBitsz1(⌊z1⌉)), LowBitsz1(⌊z1⌉),Encode(h), c) 
Verify(vk,M, σ = (x,v, h, c)) 
1: z̃1 ← Decode(x) · a+ v and h̃ = Decode(h) 2: (a| Agen) = expandA(seedA) 3: A1 = (2(a− 2b1) + qj| 2Agen) 
4: w1 = h̃+ HighBitsh(A1z̃1 − qcj) mod+ 2(q−1) αh 
5: w′ = LSB(z̃0 − c) 6: z̃2 = [w1 · αh + w′j− (A1z̃1 − qcj)]/2 mod± q 7: z̃ = (z̃1, z̃2) 8: µ̃ = Hgen(seedA,b1,M) 9: Return (c = SampleInBall(H(w1, w 
′, µ̃), τ)) ∧ (∥z̃∥ < B′′) 
Fig. 7: Deterministic version of HAETAE 
Proof. We use the notations of the algorithms. We will focus on the deterministic version in Fig. 7, since Fig. 8 also has almost the same proof. The first and second equations from Lemma 9 state that ρ = ρ̃ and thus c = SampleInBall(ρ, τ). 
On the other hand, we use the last equation from the same lemma to bound the size of z̃. We have: 
∥z̃∥ ≤ ∥z∥+ ∥z− ⌊z⌉∥+ ∥⌊z⌉ − z̃∥ 
≤ B′ + √ n(k + ℓ) · ∥z− ⌊z⌉∥∞ + ∥⌊z2⌉ − z̃2∥ 
≤ B′ + 
√ n(k + ℓ) 
2 + √ nk · ∥LowBitsh(w)∥∞ 
≤ B′ + 
√ n(k + ℓ) 
2 + √ nk · 
(αh 
4 + 1 
) . 
The definition of B′′ implies that the scheme is correct. ⊓⊔ 
15
Sign(sk,M) 
// can be done off-line: using vk, make a list L of (y,w,w1) 1: y← U(B(1/N)R,(k+ℓ)(B)) 2: w = A ⌊y⌉ 3: w1 = HighBitsh(w) 
// can be done on-line: using sk, M and pre-computed (y,w,w1) sampled // from L 4: µ = Hgen(seedA,b1,M) 5: b, b′ ← {0, 1} 6: c = SampleInBall(H(w1, LSB(⌊y0⌉), µ), τ) 7: z = (z1, z2) = y + (−1)bc · s 8: h = w1 − HighBitsh(w − 2 ⌊z2⌉) mod+ 2(q−1) 
αh 
9: if ∥z∥2 ≥ B′, then 10: go to 5 with resampled (y,w,w1) // resample (y,w,w1)← L 11: else if (∥2z− y∥2 < B) ∧ (b′ = 0), then 12: go to 5 with resampled (y,w,w1) // resample (y,w,w1)← L 13: else return σ = (Encode(HighBitsz1(⌊z1⌉)), LowBitsz1(⌊z1⌉),Encode(h), c) 
Fig. 8: Randomized signing of HAETAE. On/offline signing can accelerate the signing process. Note that the signing can also be accelerated even if y is sampled offline alone. 
3.5 Parameter sets and signature sizes 
We propose three different parameter sets with varying security levels, where we prioritize low signature and verification key sizes over faster execution time. The parameter choices are versatile, adaptable and allow size vs. speed trade-offs at consistent security levels. For example at cost of larger signatures, a smaller repetition rate M is possible and thus a faster signing process. This versatility is a notable advantage over FALCON and MITAKA. 
Like in DILITHIUM, our modulus q is constant over the parameter sets and allows an optimized NTT implementation shared for all sets. With only 16-bit in size, our modulus also allows storing coefficients memory-efficiently without compression. 
The rANS encoded values h and high bits of z1 lead to a varying signature size. In our current implementation we opted for a fixed signature size as reported in Table 3. We evaluated the distribution empirically and determined a threshold that requires a rejection in less than 0.1% of the cases. A field of two bytes indicates the length of the encoded values, the padding can be done with arbitrary data. 
A dynamic signature size would allow an individual implementation to reject and recompute signatures until a desired size threshold is reached and still be compatible with implementations without this rejection. Due to the small variance in the distribution of the signature size, however, this would result in a distinct performance overhead, if the threshold is more than a few bytes below to the average size. Figure 9 displays the signature size distribution of 1000 executions. 
In Table 3 we compare the signature and key sizes of HAETAE, DILITHIUM, and FALCON. The verification keys in HAETAE are 20% (HAETAE-260) to 25% (HAETAE-120 and HAETAE-180) smaller, than their counterparts in DILITHIUM. The advantage of the hyperball sampling manifests itself in the signature sizes, HAETAE has 30% to 40% smaller signatures than DILITHIUM. Less relevant are the secret key sizes, that are almost half the size in HAETAE compared to DILITHIUM. A direct comparison to FALCON for the same claimed security level is only possible for the highest parameter set, FALCON-1024 has a signature of less than half the size compared to HAETAE-260, and its verification key is about 14% smaller. 
16
Security 120 180 260 
q 64513 64513 64513 M 6.0 5.0 6.0 
Key Rate 0.1 0.25 0.1 β 354.82 500.88 623.72 B 9388.97 17773.21 22343.66 B′ 9382.26 17766.15 22334.95 B′′ 12320.79 21365.10 24441.49 (k, ℓ) (2,4) (3,6) (4,7) η 1 1 1 τ 58 80 128 αh 512 512 256 d 1 1 0 
Forgery BKZ block-size b 409 (333) 617 (512) 878 (735) Classical hardness 119 (97) 180 (149) 256 (214) Quantum hardness 105 (85) 158 (131) 225 (188) 
Key-Recovery BKZ block-size b 428 810 988 Classical hardness 125 236 288 Quantum hardness 109 208 253 
Table 2: HAETAE parameters sets. Hardness is measured with the Core-SVP methodology. 
Scheme Lvl. vk Signature Sum Secret key 
HAETAE-120 2 992 1,463 2,455 1,376 HAETAE-180 3 1,472 2,337 3,809 2,080 HAETAE-260 5 2,080 2,908 4,988 2,720 
DILITHIUM-2 2 1,312 2,420 3,732 2,528 DILITHIUM-3 3 1,952 3,293 5,245 4,000 DILITHIUM-5 5 2,592 4,595 7,187 4,864 
FALCON-512 1 897 666 1,563 1,281 FALCON-1024 5 1,792 1,280 3,072 2,305 
Table 3: NIST security level, signature and key sizes (bytes) of HAETAE, DILITHIUM, and FALCON. 
17
1,450 1,452 1,454 1,456 1,458 1,460 1,462 1,464 1,466 
0.05 
0.1 
0.15 
Signature size (bytes) 
F re q u en 
cy 
(a) HAETAE-120 
2,328 2,329 2,330 2,331 2,332 2,333 2,334 2,335 2,336 2,337 2,338 2,339 2,340 
0.05 0.1 
0.15 0.2 
Signature size (bytes) 
F re q u en 
cy 
(b) HAETAE-180 
2,899 2,900 2,901 2,902 2,903 2,904 2,905 2,906 2,907 2,908 2,909 2,910 
0.1 
0.2 
Signature size (bytes) 
F re q u en 
cy 
(c) HAETAE-260 
Fig. 9: Signature size distribution over 1000 executions. 
18
4 Implementation 
In this section, we give the implementation details of HAETAE. The constant-time reference implementation and the supporting scripts can be found on the team HAETAE website: https://kpqc.cryptolab.co.kr. 
4.1 Performance 
We developed a unoptimized, portable and constant-time implementation in C for HAETAE and report median and average cycle counts of one thousand executions for each parameter set in Table 4. Due to the key and signature rejection steps, the median and average values for key generation and signing respectively differ clearly, whereas the two values are much closer for the verification. 
For a fair comparison, we also performed measurements on the same system with identical settings of the reference implementation of DILITHIUM2 and the implementation with emulated floating-point operations, and thus also fully portable, of FALCON3, as given in Table 4. The performance of the signature verification for HAETAE is very close to DILITHIUM throughout the parameter sets. HAETAE-180 verification is about 23% slower than its’ counter-part, HAETAE-260 on the other hand, is even 6% faster than the respective DILITHIUM parameter set. For key generation and signature computation, our current implementation of HAETAE is clearly slower than DILITHIUM. We measure a slowdown of factors two to five. In comparison to FALCON, however, HAETAE reports 30-90 times faster key generation and 2-4 times faster signing speed. For the verification, FALCON outperforms both DILITHIUM and HAETAE by a factor of four. 
A closer look at the key generation reveals that the complex Fast Fourier Transformation that is required for the rejection step, is with 53% by far the most expensive operation and a sensible target for optimized implementations. 
Profiling the signature computation reveals that the slowdown compared to DILITHIUM is mainly caused by the sampling from a hyperball, where about 80% of the computation time is spent. The hyperball sampling itself is dominated by the generation of randomness, which we derive from the extendable output function SHAKE256 [Dwo15], which is also used in the DILITHIUM implementation. Almost 60% of the signature computation time is spend in SHAKE256. 
Based on the profiling and benchmarking of subcomponents, we estimate the performance of a randomized HAETAE implementation with pre-computation. The generic version, that is independent of the key, would already achieve a speedup of a factor five for its online signing, because the expensive hyperball sampling can be done offline. For the pre-computation variant with a designated signing key, additionally a lot of matrix-vector multiplications and therefore most of the transformations from and to the Number-Theoretic Transform (NTT) domain, can be precomputed. We estimate about 12% of the full deterministic signing running time, for the online signing in this case. 
While the smallest parameter set HAETAE-120 yields the fastest implementation, our parameter selection leads to the unusual situation, that the most secure HAETAE-260 is very close or even faster in key generation and signing than HAETAE-180. HAETAE-180 is nevertheless a viable option, due to the smaller signature and key sizes compared to HAETAE-260. 
Our rANS encoding is based on an implementation by Fabian Giesen [Gie14]. 
4.2 Optimized and Embedded Implementation 
We provide an optimized implementation using AVX2 featuring 
– vectorized NTT and inverse NTT, – vectorized addition, subtraction, and point-wise multiplication, and – four-way parallel hashing. 
2 https://github.com/pq-crystals/dilithium/tree/master/ref 3 https://falcon-sign.info/falcon-round3.zip 
19
Scheme KeyGen Sign Verify 
HAETAE-120 med 1,403,720 6,336,104 394,132 ave 1,862,874 9,017,863 394,954 
HAETAE-180 med 2,383,130 9,604,732 722,602 ave 3,538,029 11,917,124 724,663 
HAETAE-260 med 1,710,610 9,165,754 929,354 ave 2,147,863 12,075,035 930,946 
DILITHIUM-2 med 339,334 1,140,794 367,264 ave 339,569 1,446,174 367,399 
DILITHIUM-3 med 609,696 1,955,296 585,536 ave 610,114 2,359,859 585,755 
DILITHIUM-5 med 935,830 2,473,582 975,802 ave 936,202 2,904,138 976,350 
FALCON-512 med 53,778,476 17,332,716 103,056 ave 60,301,272 17,335,484 103,184 
FALCON-1024 med 154,298,384 38,014,050 224,378 ave 178,516,059 38,009,559 224,840 
Table 4: Median and average cycle counts of 1000 executions for HAETAE, DILITHIUM, and FALCON. Cycle counts were obtained on one core of an Intel Core i7-10700k, with TurboBoost and hyperthreading disabled. 
Parameter Set KeyGen Sign Verify 
HAETAE-120 med 885,978 2,290,490 153,024 ave 1,197,131 3,386,322 153,851 
HAETAE-180 med 1,398,640 3,317,768 236,170 ave 2,141,589 4,088,249 236,918 
HAETAE-260 med 1,023,946 3,027,608 291,468 ave 1,404,192 3,970,666 294,646 
Table 5: Median and average cycle counts of 1000 executions for an optimized implementation of HAETAE. 
20
Notably, the sampling algorithms (except for hashing) and the FFT are yet subject to optimization. For this implementation, we obtain the performance figures as shown in Table 5. Moreover, we are working on an embedded implementation targeting Cortex-M4. Preliminary results show that the average execution time of signing outperforms FALCON implementations from pqm4. 
4.3 Security against physical attacks 
Implementation security is a crucial aspect of making cryptosystems feasible in real-world applications. A significant advantage of HAETAE is that it can be protected against power side-channel attacks efficiently and with reasonable overhead. In this context, we emphasize the similarity of HAETAE to DILITHIUM. Hence, past works analyzing concrete attacks [BP18, MUTS22], but also countermeasures [MGTF19, ABC+22], mainly apply to HAETAE as well. 
Here, we briefly sketch the feasibility of a side-channel secure implementation. During signing, the most critical operation is multiplying the (public) challenge polynomial c with s and subsequently adding the result to y. Since this operation may leak information about the secret key statistically over many executions, implementers must protect it accordingly. As countermeasures against these so-called Differential Power Analysis (DPA) attacks, masking has been proven effective. 
This operation is straightforward to mask at arbitrary order by splitting the secret key polynomials into multiple additive shares in Rq. A masked implementation then stores the NTT of each share of s and multiplies them to c, obtaining a shared cs. Following this, the inverse NTT is applied share-wise. Since y is a polynomial vector in (1/N)R, it is not trivially possible to add our shares of cs ∈ Rk+ℓ 
q . 
On the other hand, y is not a secret-key-dependent value. Therefore, it is not required to be protected against DPA but only against the much stronger attacker model of an Simple Power Analysis (SPA). In fact, coefficient-wise shuffling of the addition is sufficient at this point (cf. [ABC+22]). This might involve a masking conversion from Zq to Z232 , but no multiplication of masked fix-point values, which would be costly. Subsequently, the computation of 2z − y and the bound checks can be shuffled without applying costly masking. 
The same idea applies to the whole hyperball sampling procedure. Since the order of the Gaussian samples is, in principle, irrelevant, they can be generated in random order. This is particularly an advantage for randomized HAETAE. 
It is noteworthy that hashing the challenge seed is only required to be protected against SPA as well. Since the input order into the hash function cannot be randomized, the preceding values must still be protected by masking. Therefore, we propose to perform a shuffled point-wise multiplication of A and y, directly followed by freshly masking the resulting coefficients. Then, a share-wise inverse NTT and a masking conversion to the Boolean domain will be performed, which enables a secure HighBits operation. For the LSBs of y0, generating a fresh Boolean masking during the shuffled generation of the hyperball sample’s coefficients is sufficient. 
Comparison to FALCON and MITAKA While there is no known method to efficiently mask FALCON, MITAKA [EFG+22b] was designed to be easy to protect against implementation attacks, while still having the advantage of similarly small signatures as FALCON. For MITAKA, the crux regarding side-channel security is sampling Gaussian-distributed values. Together with MITAKA, an efficient, masked algorithm for discrete Gaussian sampling was presented. However, Prest broke its security proof recently [Pre23]. In this respect, HAETAE has the strong advantage, that Gaussian sampling only needs to be secured against the much stronger SPA attacker model, which allows for simpler countermeasures, while MITAKA’s side-channel security will always depend on a masked sampler. 
4.4 Hardware implementations 
Hashing and generation of randomness are the most time-consuming operations of HAETAE. Therefore, we assume that hardware implementations will bring significant speedup and can be competitive to 
21
DILITHIUM, particularly through efficient KECCAK cores. Furthermore, hardware implementations will benefit significantly from applying the offline approach. Naturally, a module generating hyperball samples can be instantiated and run parallel to the online phase, thus, hiding its latency behind the online phase. Moreover, high-speed applications could adopt the offline approach with designated signing key, including the multiplication of A and y, to further reduce the latency of the online phase. 
22
5 Security 
Unforgeability under Chosen Message Attacks (UF-CMA) is regarded as a standard security notion for digital signature schemes. The adversary is given the verification key and has access to a signing oracle to call on (adaptively) chosen messages. The adversary wins if it forges a valid signature of a new, non-queried message. Strong Unforgeability under Chosen Message Attacks (SUF-CMA) is a slightly stronger security notion than UF-CMA: the adversary wins if it forges a valid signature-message pair that it did not already see. 
The concrete SUF-CMA security of HAETAE can be proven in the classical Random Oracle Model (ROM) under the standard MLWE and MSIS assumptions. However, since the proof is based on the forking lemma, the reduction is not tight, and it is not applicable in the Quantum Random Oracle Model (QROM) setting. First, using the zero-knowledge property of the underlying identification scheme, Unforgeability under No Message Attacks (UF-NMA) reduces to (S)UF-CMA security, both in the ROM and the QROM. 
As pointed out in [DFPS23] and [BBD+23], the security proofs in [AFLT16, KLS18] contain flaws. However, these works also introduce fixes. We therefore base our security proof on the fixed analyses of both [DFPS23] and [BBD+23]. 
UF-NMA is directly related to a problem that can be viewed as a “convolution” of lattice and hash function problems. We call this problem BimodalSelfTargetMSIS. Similar to the SelfTargetMSIS described in [DKL+18, KLS18], we can analyze the UF-CMA security based on the MLWE and BimodalSelfTargetMSIS assumptions. Note that in the ROM, MSIS reduces to BimodalSelfTargetMSIS, but the reduction is not tight and does not readily extend to quantum adversaries (it relies on the forking lemma). This said, this non-tightness and limitation to classical adversaries is not known to reflect any weakness. 
For setting parameters, we consider the hardness of MSIS and MLWE for relevant parameters. Intuitively, the MLWE assumption is used for security against key-recovery attacks, and the BimodalSelfTargetMSIS used for security against forgeries is identified to the MSIS assumption. 
5.1 Security definition 
We introduce the BimodalSelfTargetMSIS assumption and give a classical reduction from the standard MSIS assumption. BimodalSelfTargetMSIS is a variant of the SelfTargetMSIS assumption adapted to the bimodal setup. 
Definition 6 (BimodalSelfTargetMSISH,n,q,k,ℓ,β). Suppose that H : {0, 1}∗ × M → R2 is a cryptographic hash function. For positive integers q, k, ℓ, a positive real number β and the dimension n of R, we say that the advantage of an adversary A solving the search-BimodalSelfTargetMSISH,n,q,k,ℓ,β problem with respect to 
j ∈ Rk 2 \ {0} is 
AdvBimodalSelfTargetMSIS H,n,q,k,ℓ,β (A) = 
Pr 
 0 < ∥y∥2 < β ∧ H(Ay − qcj mod 2q,M) = c 
(A0,b)← Rk×(ℓ−1) q ×Rk 
q ; A = (−2b+ qj| 2A0| 2Idk) mod 2q; 
(y, c,M)← A|H(·)⟩(A) 
 . 
In the ROM (resp. QROM), the adversary is given classical (resp. quantum) access to H. 
Theorem 2 (Classical Reduction from MSIS to BimodalSelfTargetMSIS). Assume that q is odd, H : {0, 1}∗ ×M→ R2 is a cryptographic hash function modeled as a random oracle and that every polynomialtime classical algorithm has a negligible advantage against MSISn,q,k,ℓ,β. Then every polynomial-time classical algorithm has negligible advantage against BimodalSelfTargetMSISn,q,k,ℓ,β/2. 
Proof (sketch). Consider a BimodalSelfTargetMSISn,q,k,ℓ,β/2 classical algorithm A that is polynomial-time 
and has classical access to H. If A|H(·)⟩(A) makes Q hash queries H(wi,Mi) for i = 1, · · · , Q and outputs a solution (y, c,Mj) for some j ∈ [Q], then we can construct an adversary A′ for MSISn,q,k,ℓ,β as follows. 
23
The adversary A′ can first rewind A to the point at which the i-th query was made and reprogram the hash as H(wj ,Mj) = c′(̸= c). Then, with probability approximately 1/Q, algorithm A will produce another solution (y′, c′,Mj). We then have 
Ay − qcj = zj = Ay′ − qc′j mod 2q and ∥y∥2, ∥y∥2 < β/2. 
As q is odd, we have A(y − y′) = (c − c′)j mod 2. The fact that c′ ̸= c implies that the latter is non-zero modulo 2, and hence so is y − y′ over the integers. As it also satisfies (−b| A0| Idk) · (y − y′) = 0 mod q and ∥y − y′∥ < β, it provides a MSISn,q,k,ℓ,β solution for the matrix (−b| A0| Idk), where the submatrix (−b| A0) ∈ Rk×ℓ 
q is uniform. ⊓⊔ 
The above classical reduction from MSIS to BimodalSelfTargetMSIS is very similar to the reduction from MSIS to SelfTargetMSIS introduced in [DKL+18] and is similarly non-tight. Moreover, since the reduction relies on the forking lemma; it cannot be directly extended to a quantum reduction in the QROM. 
Security definitions. We recall the definitions of the above security notions for digital signatures. 
Definition 7 (Unforgeability under No Message Attacks (UF-NMA)). For a signature scheme S = (KeyGen, Sign, Verify), the advantage of a UF-NMA adversary A is defined as: 
AdvUF-NMA S (A) = Pr [Verify(vk,M, σ) = 1| (sk, vk)← KeyGen; (M,σ)← A(vk)] . 
Definition 8 (Unforgeability under Chosen Message Attacks (UF-CMA)). Let S = (KeyGen, Sign, Verify) be a signature scheme. A UF-CMA adversary A has access to the verification key and a signing oracle to make adaptive queries. Let the queried messages and the received signatures be (Mi, σi) for i = 1, · · · , Q. At the end of the experiment, it outputs a message-signature pair (M∗, σ∗). Then the advantage of A is defined as: 
AdvUF-CMA S (A) = Pr 
[ M∗ /∈ {Mi}i∈[Q] ∧ (sk, vk)← KeyGen; 
Verify(vk,M∗, σ∗) = 1 (M∗, σ∗)← ASign(sk,·) 
] . 
Definition 9 (Strong Unforgeability under Chosen Message Attacks (SUF-CMA)). Let S = (KeyGen, Sign, Verify) be a signature scheme. An SUF-CMA adversary A has access to the verification key and a signing oracle to make adaptive queries. Let the queried messages and the received signatures be (Mi, σi) for i = 1, · · · , Q. At the end of the experiment, it outputs a message-signature pair (M∗, σ∗). Then the advantage of A is defined as: 
AdvSUF-CMA S (A) = Pr 
[ (M∗, σ∗) /∈ {(Mi, σi)}i∈[Q] (sk, vk)← KeyGen; ∧ Verify(vk,M∗, σ∗) = 1 (M∗, σ∗)← ASign(sk,·) 
] . 
HAETAE achieves UF-CMA security in (Q)ROM, assuming MLWE and BimodalSelfTargetMSIS are hard. 
Theorem 3 (UF-CMA Security of HAETAE in the QROM). HAETAE in Figure 7 is UF-CMA secure in the QROM. 
Proof (sketch). The proof relies on the analysis of [DFPS23], which reduces UF-CMA security to UF-NMA security, where an adversary is not allowed to make signing queries. This analysis requires that the commitment min-entropy is high and the underlying Σ-protocol is Honest-Verifier Zero-Knowledge (HVZK). The latter is proved by providing a simulator for non-aborting transcripts and proving that the distribution of ⌊y⌉ has sufficiently large min-entropy. 
24
Commitment min-entropy. We first claim that the underlying Σ-protocol has large commitment minentropy. The underlying identification protocol has ε bits of min-entropy if 
∀(w, x),Pr y 
[ (HighBitsh(A⌊y⌉), LSB(⌊y0⌉)) = (w, x) 
] ≤ 2−ε, 
for any (pk, sk) ← KeyGen and y ← U(B(1/N)R,(k+ℓ)(B)). We note that LSB(⌊y0⌉) is a binary vector of length n and is statistically close to uniform. Thus, the inner probability is (very loosely) bounded by 2−n 
regardless of the choice of (pk, sk). Hence we obtain at least 256 bits of min-entropy in all of our parameter sets. 
HVZK. Next, we show that the underlying Σ-protocol satisfies the HVKZ property. To do so, we follow the strategy from [DFPS23, Section 4.2], which studies the simulation of non-aborting transcripts and switch to computational mode for aborting ones. We propose the following simulator in Figure 10. On input a challenge c, it runs A(0) as defined in Figure 2 (note that we are prevented from using B as the exact rejection probability is unknown), and if it fails, it samples a uniform commitment and no answer. Here, p(z) is 1/2 if ∥z∥ ≤ r and 0 everywhere else. 
Sim(A, c) : 
1: y← U(B(1/N)R,m(r′)) 2: w← (HighBitsh(A⌊y⌉), LSB(y0)) 3: z← y 4: u← U(Rk 
q ) 5: u0 ← U(R2) 6: w̃← (HighBitsh(2u+ qju0), u0) 7: return (w, c, z) with probability p(z), else (w̃, c,⊥) 
Fig. 10: HAETAE transcript simulator 
(i) Simulating non-aborting transcripts. When a sample is accepted, Lemma 1 states that the simulator follows exactly the same distribution as the real aglorithm. 
(ii) Simulating aborting transcripts. As argued in [DFPS23, Section 4.2], in this context, we can use a a computational notion of HVZK rather than the usual statistical definition. We introduce an LWE-like assumption which states that it is hard to distinguish w = A⌊y⌉ mod q from a uniform element modq. This LWE assumption is unusual only in its choice of distribution for the noise and the secret. 
These two properties allow us to apply [DFPS23, Theorem 4] to reduce the SUF-CMA security to UF-NMA security. 
If one wants to avoid this assumption, it is possible to use the reduction from [BBD+23] by using A(0) as a simulator. The non-aborting transcripts produced by this simulator have statistical distance 0 with real ones. 
Proving UF-NMA security. Finally, we note that the UF-NMA security game is exactly the problem defined in Definition 6, up to replacing the verification key by an uniform matrix (still in HNF form), which is done under the MLWE assumption. 
5.2 Cost of known attacks 
For the concrete security analysis, we list the best known lattice attacks and consider their costs for attacking HAETAE. 
All the best known attacks rely on the Block–Korkine–Zolotarev (BKZ) lattice reduction algorithm [SE94, CN11, HPS11]. The BKZ algorithm is a lattice basis reduction algorithm that repeatedly uses a Shortest Vector Problem (SVP) solver in small-dimensional projected sublattices. The dimension b of these projected 
25
sublattices is called the block-size. BKZ with block-size b hence relies on an SVP solver in dimension b. The block-size drives the cost of BKZ and determines the resulting basis’s quality. It provides a quality/time trade-off: If b gets larger, better quality will be guaranteed, but the time complexity for the SVP solver will exponentially increase. The time complexity of the b-BKZ algorithm is the same as the SVP solver for dimension b, up to polynomial factors. Hence the time complexity differs depending on the SVP solver used. The most efficient SVP algorithm uses the sieving method proposed by Becker et al. [BDGL16] which takes time ≈ 20.292b+o(b). The fastest known quantum variant is proposed by Chailloux and Loyer in [CL21] and takes time ≈ 20.257b+o(b). 
Based on the BKZ algorithm, we will follow the core-SVP methodology from [ADPS16] and as in the subsequent lattice-based schemes [ABB+19, DKL+18, FHK+17, DKSRV18, BDK+18]. It is regarded as a conservative way to set security parameters. We ignore the polynomial factors and the o(b) terms in the exponents of the run-time bounds above for the time complexity of the BKZ algorithm. 
We consider the primal attack and the dual attack for MLWE, and the plain BKZ attack for MSIS and BimodalSelfTargetMSIS problems. We remark that any MLWEn,q,k,ℓ,η instance can be viewed as an LWEq,nk,nℓ,η instance, and also any MSISn,q,k,ℓ,β can be viewed as an SISq,nk,nℓ,β instance. Even though the MLWE and MSIS problems have some extra algebraic structure compared to the LWE and SIS problems, we do not currently know how to exploit it to improve the best known attacks. For this reason, we estime the concrete hardness of the MLWE and MSIS problems over the structured lattices as the concrete hardness of the corresponding LWE and SIS problems over the unstructured lattices. 
We summarize the costs of the known attacks in Table 6. In the table, the required block-sizes for BKZ and the costs of the attacks in core-SVP hardness are given, estimated by the python script we submitted to the KpqC competition with this document. It is a modification of the security estimator of Dilithium [DS20]. The parameters forMLWE andMSIS problems are chosen based on Theorems 2 and 3. The numbers in parentheses are for the SUF-CMA security of randomized HAETAE (in the case of the deterministic signature, strong and weak unforgeability are the same). All costs are rounded downwards. 
Parameter sets HAETAE120 HAETAE180 HAETAE260 
Target security 120 180 260 
BKZ block-size b to break SIS 409 (333) 617 (512) 878 (735) Classical hardness 119 (97) 180 (149) 256 (214) Quantum hardness 105 (85) 158 (131) 225 (188) 
BKZ block-size b for primal attack 431 820 1001 Classical hardness 126 239 292 Quantum hardness 110 210 257 
BKZ block-size b for dual attack 428 810 988 Classical hardness 125 236 288 Quantum hardness 109 208 253 
Table 6: Core-SVP hardness for the best known attacks 
Primal attack. Given an LWE instance (A,b) ∈ Zk×ℓ q × Zk 
q , we first define the lattices Λm = {v ∈ Zℓ+m+1 : Bv = 0 mod q} for all m ≤ k, where B = 
( A[m]| Idm| b[m] 
) ∈ Zm×(ℓ+m+1) 
q , A[m] is the uppermost m × ℓ sub-matrix of A and b[m] is the uppermost m-dimensional sub-vector of b. As (A,b) ∈ Zk×ℓ q ×Zk 
q is an LWE instance, there exist s and e short such that b = As+ e. This implies that (s| e| − 1) is a short vector of Λm. The primal attack consists in running BKZ on Λm to find short vectors in Λm. The variable m is optimized to minimize the cost of the attack. 
26
Dual attack. Given an LWE instance (A,b) ∈ Zk×ℓ q × Zk 
q , we first define the lattices Λ′m = {(u,v) ∈ Zm × Zℓ : A⊤[m]u + v = 0 mod q} for all m ≤ k, where A[m] is the uppermost m × ℓ sub-matrix of A. 
If (u,v) is a short vector in Λ′m, then u⊤b = v⊤s + u⊤e[m] is short if b = As + e for short vectors s and e, and is uniformly distributed modulo q if b is uniform and independent from A (here e[m] refers to the uppermost m-dimensional sub-vector of e). This provides a distinguishing attack. The dual attack consists in finding a short non-zero vector in the lattice Λ′m using BKZ. The variable m is optimized to minimize the cost of the attack. 
SIS attack. To analyze the hardness of BimodalSelfTargetMSIS, we analyze the hardness of the corresponding MSIS. Intuitively, if we assume that H is a cryptographic hash, then the input structure will not help find the preimage. So we can assume that M is fixed. Then the problem turns into finding the preimage x of c with respect to H(·,M) and then finding y satisfying x = Ay− qcj mod 2q. Apart from the first step, if we have the preimage c, then the second step will be turned into finding y′ satisfying (2b| A0| Idk) · y′ = t mod q, for a known vector t over Rq. Here, y′ is defined as y′ = ((y0 − x′0)/2, y1, · · · , yk+ℓ−1) 
⊤ and t = 2−1 ·x+x′0b mod q, where x′0 = (x0 + c mod 2) which actually decides the LSB of y0. Also, ∥y′∥2 is bounded by the same bound used for ∥y∥2. This implies that solving BimodalSelfTargetMSIS is at least as hard as solving MSIS with the same norm bound or finding the preimage of a hash as an attack perspective. However, for the hardness of BimodalSelfTargetMSIS problem, we will analyze it more conservatively, as the hardness of MSIS problem with a twice larger norm bound, taking into account the classical reduction from MSIS to BimodalSelfTargetMSIS in Theorem 2. We analyze the best known attacks for SIS problem, for both MSIS and BimodalSelfTargetMSIS problems that the unforgeability of our signature scheme relies on. 
Given an SIS instance A ∈ Zk×ℓ q with a bound β, we define the lattices Λ′′m = {u ∈ Zm : Bu = 0 mod q} 
for all m ≤ k + ℓ, where B is the k ×m leftmost sub-matrix of (A| Idk). Then a short non-zero vector in the lattice Λ′′m is a solution to the SIS problem. Once more, we use BKZ and optimize the choice of m. 
Note that if β > q, then there are some trivial non-zero solutions to SIS problem such as (q, 0, · · · , 0) with ℓ2-norm< β. Depending on the parameters, the security could be affected by some existing attacks [DKL+18]. We choose the prime q larger than the MSIS bound β to avoid such weaknesses. 
27
References 
ABB+19. Erdem Alkim, Paulo S. L. M. Barreto, Nina Bindel, Juliane Kramer, Patrick Longa, and Jefferson E. Ricardini. The lattice-based digital signature scheme qTESLA. Cryptology ePrint Archive, Number 2019/085, 2019. https://eprint.iacr.org/2019/085. 
ABC+22. Melissa Azouaoui, Olivier Bronchain, Gaëtan Cassiers, Clément Hoffmann, Yulia Kuzovkova, Joost Renes, Markus Schönauer, Tobias Schneider, François-Xavier Standaert, and Christine van Vredendaal. Leveling Dilithium against leakage: Revisited sensitivity analysis and improved implementations. Cryptology ePrint Archive, Report 2022/1406, 2022. https://eprint.iacr.org/2022/1406. 
ADPS16. Erdem Alkim, Léo Ducas, Thomas Pöppelmann, and Peter Schwabe. Post-quantum key Exchange—A New Hope. In 25th USENIX Security Symposium, pages 327–343. USENIX Association, 2016. 
AFLT16. Michel Abdalla, Pierre-Alain Fouque, Vadim Lyubashevsky, and Mehdi Tibouchi. Tightly secure signatures from lossy identification schemes. J. Cryptol., 29(3):597–631, 2016. 
BBD+23. Manuel Barbosa, Gilles Barthe, Christian Doczkal, Jelle Don, Serge Fehr, Benjamin Grégoire, Yu-Hsuan Huang, Andreas Hülsing, Yi Lee, and Xiaodi Wu. Fixing and mechanizing the security proof of Fiat-Shamir with aborts and Dilithium. Cryptology ePrint Archive, Paper 2023/246, 2023. https://eprint. iacr.org/2023/246. 
BBE+19. Gilles Barthe, Sonia Beläıd, Thomas Espitau, Pierre-Alain Fouque, Mélissa Rossi, and Mehdi Tibouchi. GALACTICS: gaussian sampling for lattice-based constant- time implementation of cryptographic signatures, revisited. In Lorenzo Cavallaro, Johannes Kinder, XiaoFeng Wang, and Jonathan Katz, editors, Proceedings of CCS, pages 2147–2164. ACM, 2019. 
BDGL16. Anja Becker, Léo Ducas, Nicolas Gama, and Thijs Laarhoven. New directions in nearest neighbor searching with applications to lattice sieving. In Annual ACM-SIAM Symposium on Discrete Algorithms (SODA), pages 10–24, 2016. 
BDK+18. Joppe Bos, Léo Ducas, Eike Kiltz, Tancrède Lepoint, Vadim Lyubashevsky, John M Schanck, Peter Schwabe, Gregor Seiler, and Damien Stehlé. CRYSTALS-Kyber: a CCA-secure module-lattice-based KEM. In IEEE European Symposium on Security and Privacy (EuroS&P), pages 353–367, 2018. 
BG14. Shi Bai and Steven D. Galbraith. An improved compression technique for signatures based on learning with errors. In Josh Benaloh, editor, Topics in Cryptology – CT-RSA 2014, pages 28–47, 2014. 
BGV12. Zvika Brakerski, Craig Gentry, and Vinod Vaikuntanathan. (Leveled) fully homomorphic encryption without bootstrapping. In Shafi Goldwasser, editor, Innovations in Theoretical Computer Science (ITCS), pages 309–325. ACM, 2012. 
BP18. Leon Groot Bruinderink and Peter Pessl. Differential fault attacks on deterministic lattice signatures. IACR TCHES, 2018(3):21–43, 2018. https://tches.iacr.org/index.php/TCHES/article/view/7267. 
CL21. André Chailloux and Johanna Loyer. Lattice sieving via quantum random walks. In Mehdi Tibouchi and Huaxiong Wang, editors, Advances in Cryptology - ASIACRYPT, pages 63–91. Springer, 2021. 
CN11. Yuanmi Chen and Phong Q. Nguyen. BKZ 2.0: Better lattice security estimates. In Dong Hoon Lee and Xiaoyun Wang, editors, Advances in Cryptology – ASIACRYPT, pages 1–20. Springer, 2011. 
DDLL13. Léo Ducas, Alain Durmus, Tancrède Lepoint, and Vadim Lyubashevsky. Lattice signatures and bimodal gaussians. In Ran Canetti and Juan A. Garay, editors, Advances in Cryptology – CRYPTO, pages 40–56. Springer, 2013. 
DFPS22. Julien Devevey, Omar Fawzi, Alain Passelègue, and Damien Stehlé. On rejection sampling in lyubashevsky’s signature scheme. In Asiacrypt. Springer, 2022. 
DFPS23. Julien Devevey, Pouria Fallahpour, Alain Passelègue, and Damien Stehlé. A detailed analysis of Fiat-Shamir with aborts. Cryptology ePrint Archive, Paper 2023/245, 2023. https://eprint.iacr.org/ 
2023/245. DKL+18. Léo Ducas, Eike Kiltz, Tancrède Lepoint, Vadim Lyubashevsky, Peter Schwabe, Gregor Seiler, and 
Damien Stehlé. CRYSTALS-Dilithium: A lattice-based digital signature scheme. IACR Transactions on Cryptographic Hardware and Embedded Systems, 2018(1):238–268, 2018. 
DKSRV18. Jan-Pieter D’Anvers, Angshuman Karmakar, Sujoy Sinha Roy, and Frederik Vercauteren. Saber: Module-LWR based key exchange, CPA-secure encryption and CCA-secure KEM. In Africacrypt, pages 282–305. Springer, 2018. 
DS20. Léo Ducas and John Schanck. Security estimation scripts for kyber and dilithium, 2020. GitHub repository, available at https://github.com/pq-crystals/security-estimates. 
Dud13. Jarek Duda. Asymmetric numeral systems: entropy coding combining speed of huffman coding with compression rate of arithmetic coding, 2013. ArXiv preprint, available at https://arxiv.org/abs/ 
1311.2540. 
28
Dwo15. Morris J Dworkin. Sha-3 standard: Permutation-based hash and extendable-output functions. 2015. EFG+22a. Thomas Espitau, Pierre-Alain Fouque, François Gérard, Mélissa Rossi, Akira Takahashi, Mehdi Tibouchi, 
Alexandre Wallet, and Yang Yu. Mitaka: A simpler, parallelizable, maskable variant of Falcon. In Orr Dunkelman and Stefan Dziembowski, editors, Advances in Cryptology – EUROCRYPT, pages 222–253. Springer, 2022. 
EFG+22b. Thomas Espitau, Pierre-Alain Fouque, François Gérard, Mélissa Rossi, Akira Takahashi, Mehdi Tibouchi, Alexandre Wallet, and Yang Yu. Mitaka: A simpler, parallelizable, maskable variant of falcon. In Orr Dunkelman and Stefan Dziembowski, editors, EUROCRYPT 2022, Part III, volume 13277 of LNCS, pages 222–253. Springer, Heidelberg, May / June 2022. 
EFGT17. Thomas Espitau, Pierre-Alain Fouque, Benôıt Gérard, and Mehdi Tibouchi. Side-channel attacks on BLISS lattice-based signatures: Exploiting branch tracing against strongswan and electromagnetic emanations in microcontrollers. In Bhavani Thuraisingham, David Evans, Tal Malkin, and Dongyan Xu, editors, ACM SIGSAC Conference on Computer and Communications Security (CCS), pages 1857–1874, 2017. 
ETWY22. Thomas Espitau, Mehdi Tibouchi, Alexandre Wallet, and Yang Yu. Shorter hash-and-sign lattice-based signatures. In Yevgeniy Dodis and Thomas Shrimpton, editors, Advances in Cryptology – CRYPTO, pages 245–275. Springer, 2022. 
FHK+17. Pierre-Alain Fouque, Jeffrey Hoffstein, Paul Kirchner, Vadim Lyubashevsky, Thomas Pornin, Thomas Prest, Thomas Ricosset, Gregor Seiler, William Whyte, and Zhenfei Zhang. Falcon: Fast-Fourier lattice-based compact signatures over NTRU, 2017. Submission to the NIST post-quantum cryptography standardization process. 
Gie14. Fabian Giesen. Interleaved entropy coders. arXiv preprint arXiv:1402.3392, 2014. HPS11. Guillaume Hanrot, Xavier Pujol, and Damien Stehlé. Algorithms for the shortest and closest lattice vector 
problems. In Yeow Meng Chee, Zhenbo Guo, San Ling, Fengjing Shao, Yuansheng Tang, Huaxiong Wang, and Chaoping Xing, editors, Coding and Cryptology, pages 159–190. Springer, 2011. 
KLS18. Eike Kiltz, Vadim Lyubashevsky, and Christian Schaffner. A concrete treatment of Fiat-Shamir signatures in the quantum random-oracle model. In Advances in Cryptology – EUROCRYPT, pages 552–586. Springer, 2018. 
LS15. Adeline Langlois and Damien Stehlé. Worst-case to average-case reductions for module lattices. Des. Codes Cryptogr., 75(3):565–599, 2015. 
Lyu09. Vadim Lyubashevsky. Fiat-Shamir with aborts: Applications to lattice and factoring-based signatures. In Mitsuru Matsui, editor, Advances in Cryptology – ASIACRYPT, pages 598–616. Springer, 2009. 
Lyu12. Vadim Lyubashevsky. Lattice signatures without trapdoors. In David Pointcheval and Thomas Johansson, editors, Advances in Cryptology – EUROCRYPT, pages 738–755. Springer, 2012. 
MGTF19. Vincent Migliore, Benôıt Gérard, Mehdi Tibouchi, and Pierre-Alain Fouque. Masking Dilithium - efficient implementation and side-channel evaluation. In Robert H. Deng, Valérie Gauthier-Umaña, Mart́ın Ochoa, and Moti Yung, editors, ACNS 19, volume 11464 of LNCS, pages 344–362. Springer, Heidelberg, June 2019. 
MUTS22. Soundes Marzougui, Vincent Ulitzsch, Mehdi Tibouchi, and Jean-Pierre Seifert. Profiling side-channel attacks on Dilithium: A small bit-fiddling leak breaks it all. Cryptology ePrint Archive, Report 2022/106, 2022. https://eprint.iacr.org/2022/106. 
Pre17. Thomas Prest. Sharper bounds in lattice-based cryptography using the Rényi divergence. In Tsuyoshi Takagi and Thomas Peyrin, editors, Advances in Cryptology - ASIACRYPT, pages 347–374. Springer, 2017. 
Pre23. Thomas Prest. A key-recovery attack against mitaka in the t-probing model. Cryptology ePrint Archive, Report 2023/157, 2023. https://eprint.iacr.org/2023/157. 
SE94. Claus-Peter Schnorr and Martin Euchner. Lattice basis reduction: Improved practical algorithms and solving subset sum problems. Mathematical programming, 66(1):181–199, 1994. 
VGS17. Aaron R Voelker, Jan Gosmann, and Terrence C Stewart. Efficiently sampling vectors and coordinates from the n-sphere and n-ball. Centre for Theoretical Neuroscience-Technical Report, 01 2017. 
29
A Uncompressed HAETAE 
In this appendix, we present HAETAE without its compression step. Readers who are not familiar with the Fiat-Shamir with Aborts line of work may find it easier to read this version first. It highlights the use of bimodal rejection sampling applied to the Fiat-Shamir with Aborts paradigm. 
The key generation algorithms ensures that As = qj mod 2q, while also putting A in a “close to Hermite Normal Form”. Namely, instead of the right part of A being Idk, it is 2Idk. This subtlety impacts the compression design, in the uncompressed version of HAETAE. 
The signature for a message M consists of c = H(A⌊y⌉ mod 2q,M) and z = ⌊y⌉ ± cs. Sometimes, the vector z is rejected and the signing procedure is restarted. Note that Az = A⌊y⌉+qcj mod 2q, independently of the sign that was chosen for cs. The verification step then checks the consistency of the pair (z, c) and the smallness of z. 
KeyGen(1λ) 
1: Agen ← Rk×(ℓ−1) q and (sgen, egen)← Sℓ−1 
η × Sk η 
2: b = Agen · sgen + egen ∈ Rk q 
3: A = (−2b+ qj |2Agen |2 Idk) 4: s = (1, s⊤gen, e 
⊤ gen) 
⊤ 
5: if f(s) > nβ2/τ then restart 6: return sk = (A, s) and vk = A 
Sign(sk,M) 
1: y← U(B(1/N)R,(k+ℓ)(B)) 2: w← A ⌊y⌉ 3: c = H(w,M) ∈ R2 
4: z = y + (−1)bc · s for b← U({0, 1}) 5: if ∥z∥2 > B′, then restart 6: else if ∥2z− y∥2 < B, then restart with probability 1/2 7: return σ = (⌊z⌉, c) 
Verify(vk,M, σ = (z̃, c)) 
1: w̃ = Az− qcj mod 2q 
2: return ( c = H(w̃,M) ) ∧ ( ∥z̃∥ < B + 
√ n(k+ℓ) 
2 
) 
Fig. 11: High-level description of uncompressed HAETAE 
B Discretizing Hyperballs 
B.1 Useful Lemma 
We will rely on the following claim. 
Lemma 10. Let n be the degree of R. Let m,N, r > 0 and v ∈ Rm. Then the following statements hold: 
1. |(1/N)Rm ∩ BR,m(r)| = |Rm ∩ BR,m(Nr)|, 2. |Rm ∩ BR,m(r,v)| = |Rm ∩ BR,m(r)|, 3. Vol(BR,m(r − 
√ mn/2)) ≤ |Rm ∩ BR,m(r)| ≤ Vol(BR,m(r + 
√ mn/2)). 
Proof. For the first statement, note that we only scaled (1/N)Rm and BR,m(r) by a factor N . For the second statement, note that the translation x 7→ x− v maps Rm to Rm. 
30
We now prove the third statement. For x ∈ Rm, we define Tx as the hypercube of Rm R centered in x with 
side-length 1. Observe that the Tx’s tile the whole space when x ranges over Rm (the way bounderies are handled does not matter for the proof). Also, each of those tiles has volume 1. As any element in Tx is at Euclidean distance at most 
√ mn/2 from x, the following inclusions hold: 
BR,m(r − √ mn/2) ⊆ ∪x∈Rm∩BR,m(r)Tx ⊆ BR,m(r + 
√ mn/2). 
Taking the volumes gives the result. ⊓⊔ 
B.2 Proof of Lemma 1 
Proof. Figure 2 is the bimodal rejection sampling algorithm applied to the source distribution U((1/N)Rm∩ BR,m(r′)) and target distribution U((1/N)Rm ∩ BR,m(r)) (see, e.g., [DFPS22]). For the result to hold, it suffices that the support of the shift of the source distribution by v is contained in the support of the target distribution. This is implied by r′ ≥ 
√ r2 + t2. 
We now consider the number of expected iterations, i.e., the maximum ratio between the two distributions. To guide the intuition, note that if we were to use continuous distributions, the acceptance probability 1/M ′ 
would be bounded by 1/M . In our case, the acceptance probability can be bounded as follows (using Lemma 10): 
1 
M ′ = |(1/N)Rm ∩ BR,m(r)| 2|(1/N)Rm ∩ BR,m(r′)| 
= |Rm ∩ BR,m(Nr)| 2|Rm ∩ BR,m(Nr′)| 
≥ Vol(BR,m(Nr − √ mn/2)) 
2Vol(BR,m(Nr′ + √ mn/2)) 
= 1 
2 
( Nr − 
√ mn/2 
Nr′ + √ mn/2 
)mn 
. 
It now suffices to bound the latter term from below by 1/(cM) = 1/(2c(r′/r)mn). This inequality is equivalent to: 
c ≥ 1 
2 · ( 
r 
r − √ mn/(2N) 
)mn 
· ( r′ + √ mn/(2N) 
r′ 
)mn 
, 
and to: 
N ≥ 1 
c1/(mn) − 1 · √ mn 
2 
( c1/(mn) 
r + 
1 
r′ 
) , 
which allows to complete the proof. ⊓⊔ 
B.3 Proof of Lemma 7 
Proof. Let y ∈ BR,m(Nr′ + √ mn/2) and set z = ⌊y⌉. Note that z is sampled (before the rejection step) 
with probability Vol(Tz ∩ BR,m(Nr′ + 
√ mn/2)) 
Vol(BR,m(Nr′)) , 
where Tz is the hypercube of Rm R centered in z with side-length 1. By the triangle inequality, this probability 
is equal to 1/Vol(BR,m(Nr′ + √ mn/2) when z ∈ BR,m(Nr′). Hence the distribution of the output is 
exactly U(Rm ∩BR,m(Nr′)), as each element is sampled with equal probability and as the algorithm almost surely terminates (its runtime follows a geometric law of parameter the rejection probability). 
It remains to consider the acceptance probability, which is:∑ y∈Rm∩BR,m(Nr′) Vol(Ty ∩ BR,m(Nr′ + 
√ mn/2)) 
Vol(BR,m(Nr′ + √ mn/2)) 
. 
31
By the triangle inequality and Lemma 10, it is 
|Rm ∩ BR,m(Nr′)| Vol(BR,m(Nr′ + 
√ mn/2)) 
≥ ( Nr′ − 
√ mn/2 
Nr′ + √ mn/2 
)mn 
. 
Note that by our choice of N , this is ≥ 1/M0. ⊓⊔ 
C Fixed-Point Sampling 
In this appendix, we explain how to sample from the discretized hyperball distribution using fixed-point arithmetic. 
We first describe the representation of numbers and operations. A fixed-point number in precision p will consist in a p-bit signed integer k ∈ Z ∩ [−2p−1, 2p−1) along with an implicit scaling exponent e: the represented number is x = k · 2e−p ∈ [−2e−1, 2e−1). The data can for example be stored in a p-bit integer in two’s complement representation. The scaling exponent e is not stored, it only exists on paper. For convenience, a precision p fixed-point number x with implicit exponent e will be referred to as a (p, e)-number. 
When performing arithmetic operations on fixed-point numbers, particular care must be taken with overflows: in the analysis, we make sure that during the algorithm execution, any (p, e)-number x will satisfy |x| < 2e−1. The following assumes no overflow occurs. We can add, subtract and negate (p, e)-numbers exactly (note that we only consider the situation where the operands of those operations share the same exponent). We assume that we can multiply (p, e0)-number x0 with a (p, e1)-number x1 into a (p, e×)-number x× as if the multiplication was exact and then rounded to a nearest representable number. Finally, we assume that we can compute an inverse square-root of a (p, e)-number x into a (p, e′)-number y with possibly slightly more error than that. This is summarized as follows: 
x0 ⊕ x1 = x0 + x1; x0 ⊖ x1 = x0 − x1; ⊖x = −x; |(x0 ⊗e× 
e0,e1 x1)− (x0 · x1)| ≤ 2e×−p−1; |(1/ √ ·)ete − 1/ 
√ x| ≤ 2et−p. 
For the sake of simplicity, we fix the precision p to 128 once and for all and never perform operations with numbers of different precisions. 
C.1 Gaussian samples 
Our hyperball-uniform sampler relies on an algorithm that samples from the continuous Gaussian distribution. In our fixed-point sampling, we will make do with fixed-point approximations to samples from the continuous Gaussian distribution. Instead of sampling from the continuous Gaussian distribution and rounding, we sample from the discrete Gaussian distribution. For the discrete Gaussian sampler, we can for example rely on [BBE+19]. 
Lemma 11. Let σ > 0. Let DZ,σ (resp. Dσ) be the distribution D over Z (resp. R) such that D(k) ∼ exp(−k2/(2σ2)) for all k ∈ Z (resp. k ∈ R). Then we have: 
Pr k←DZ,σ 
[|k| ≥ 14 · σ] ≤ 2−140 and max |k|≤14·σ 
DZ,σ(k) 
⌊Dσ⌉(k) ≤ 1 
1− 8/σ . 
Note that the statement could be rephrased using the smooth Rényi divergence introduced in [DFPS22]. 
Proof. Using the discrete Gaussian tail bound from [Lyu12, Lemma 4.4], the weight of DZ,σ out of the interval [−14 · σ, 14 · σ] is ≤ 2−140. Using the Poisson Summation Formula, we have that: 
∀k ∈ Z, DZ,σ(k) ≤ exp(−k2/(2σ2)) 
σ √ 2π 
. 
32
Further, for k ∈ Z ∩ [−14 · σ, 14 · σ], the following inequalities hold: 
⌊Dσ⌉(k) = 1 
σ √ 2π 
∫ k+1/2 
k−1/2 exp(−x2/(2σ2))dx 
≥ exp(−k2/(2σ2)) 
σ √ 2π 
· exp(−(|k|+ 1/4)/(2σ2)) 
≥ exp(−k2/(2σ2)) 
σ √ 2π 
· ( 1− |k|+ 1/4 
2σ2 
) ≥ exp(−k2/(2σ2)) 
σ √ 2π 
· ( 1− 8 
σ 
) . 
This completes the proof. ⊓⊔ 
We will take σ = 2124 and view the sample from DZ,σ as a (128, 6)-number obtained as the rounding of a perfect continuous Gaussian sample. Lemma 11 implies that a signature forger for the imperfect Gaussian sampler succeeds with essentially the same probability with the ideal Gaussian sampler. 
C.2 From Gaussian samples to approximate hyperball-uniforms 
In the following, we assume that we have access to arbitrarily many statistically independent (p, e)-numbers yi that approximate (perfect) samples yi from D1 = N (0, 1). We first consider the algorithm of Figure 3 with radius 1. We apply it using such yi’s and fixed-point arithmetic, with appropriately chosen implicit exponents for each step. We show that the vector y output by the approximate algorithm is close to the vector y output by the exact algorithm. As y is uniformly distributed in a hyperball, the computed vector y is an approximation to such a sample. 
We first bound the quantities involved during the computations. These bounds are for the exact quantities. To avoid overflows, we actually need them for the corresponding computed quantities. We will see later that as the numerical errors are low, the bounds still essentially hold. The bounds are probabilistic, and hold with probability extremely close to 1. 
Lemma 12. Let dmin = 6 ·256+2 and dmax = 11 ·256+2. The following bounds hold for all d ∈ [dmin, dmax]: 
Pr y←D1 
[|y| ≥ 24] < 2−188, 
Pr yi←D1 
∀i∈[d] 
[∥y∥2 ≥ 212] < 2−144, Pr yi←D1 
∀i∈[d] 
[∥y∥2 ≤ 29] < 2−144. 
Pr z←U(Bd−2(1)) 
[|z1| ≥ 2−2] < 2−150. 
Proof. The first probability is 1− erf(24/ √ 2). The two others can be bounded the Laurent-Massart bounds 
for the chi-squared distribution, i.e., for all d, t: 
Pr yi←D1 
∀i∈[d] 
[∥y∥2 ≥ d+ 2 √ dt+ 2t] ≤ exp(−t), 
Pr yi←D1 
∀i∈[d] 
[∥y∥2 ≤ d− 2 √ dt] ≤ exp(−t). 
For the last bound, we use [DFPS22, Lemma A.13]. The probability is exactly I1−1/η2((d + 1)/2, 1/2) where I refers to the regularized incomplete Beta function and 1/η is probabilistic magnitude upper bound. The results follow from numerical computations. ⊓⊔ 
33
Throughout the execution of the approximate version of the algorithm of Figure 3, we fix the precision to p ≥ 64. The implicit exponents vary depending on the algorithm step: the yi’s are represented by (p, 5)-numbers, their squares by (p, 13)-numbers, the squared-norm ∥y∥2 by a (p, 13)-number, the inversenorm 1/∥y∥ by a (p,−3)-number and the output coordinates on (p,−1)-numbers. 
Assume that we have |yi − yi| ≤ ϵ0 for all i, for some ϵ0 ≥ 2−p+5/2 = 2−p+4. To avoid overflows of yi’s, it suffices that |yi| ≤ 24 − 2−p+5 − ϵ0. The first bound from Lemma 12 still holds for any ϵ0 ≤ 2−5. 
We now consider the computations of the approximations y2i ’s to the y2i ’s. We have:∣∣∣y2i − y2i 
∣∣∣ ≤ |(yi ⊗13 5,5 yi)− yi 
2|+ |yi − yi| · |yi + yi| 
≤ 2−p+12 + |yi − yi| · [|yi − yi|+ 2|yi|] ≤ 2−p+12 + 26 · ϵ0. 
As addition is exact, we obtain:∣∣∣∥y∥2 − ∥y∥2∣∣∣ ≤ dmax · (2−p+12 + 26 · ϵ0) =: ϵ1. 
To avoid overflow of ∥y∥2 and hence of the y2i ’s, it suffices that ∥y∥2 ≤ 212− 2−p−13− ϵ1. The second bound from Lemma 12 still holds for any ϵ0 ≤ 2−5. 
We continue with the inverse square root computation. The following holds:∣∣∣∣1/∥y∥ − 1 
∥y∥ 
∣∣∣∣ ≤ ∣∣∣∣∣(1/√·)−313 (∥y∥2)− 
1 
∥y∥ 
∣∣∣∣∣+ ∣∣∣∣∣ 1 
∥y∥ − 1 
∥y∥ 
∣∣∣∣∣ ≤ 2−p−3 + 
|∥y∥2 − ∥y∥2| 2[∥y∥2 − |∥y∥2 − ∥y∥2|]3/2 
≤ 2−p−3 + ϵ1 
2[29 − ϵ1]3/2 
≤ 2−p−3 + 2−15(1 + 2−1)ϵ1 =: ϵ2, 
where the last inequality holds for any ϵ0 ≤ 2−15. To avoid overflow of 1/∥y∥, it suffices that 1/∥y∥ ≤ 2−4 − 2−p−3 − ϵ2. The third bound from Lemma 12 still holds for any ϵ0 ≤ 2−15. 
We finally evaluate the accuracy of the output vector z with respect to z := (y1, . . . , yd) ⊤/∥y∥2. We have, 
for all i: ∣∣∣zi − zi 
∣∣∣ ≤ ∣∣∣yi ⊗−15,−3 1/∥y∥ − yi · 1/∥y∥ ∣∣∣+ ∣∣∣yi · 1/∥y∥ − yi/∥y∥ 
∣∣∣ ≤ 2−p−2 + 
∣∣∣1/∥y∥ − 1/∥y∥ ∣∣∣ · |yi|+ |yi − yi|/∥y∥ 
≤ 2−p−2 + 25 · ϵ2 + 2−4 · ϵ0 =: ϵ3. 
To avoid overflow of zi, it suffices that |zi| ≤ 2−2− 2−p−3− ϵ3. The fourth bound from Lemma 12 still holds for any ϵ0 ≤ 2−20. 
Note that ϵ3 is of the order of 2142−p. This is a crude upper bound, as it assumes that errors are always in the same direction. 
C.3 Using Approximate Hyperball-Uniforms 
We consider the algorithm from Figure 5. Step 2 is performed exactly. For Step 1, we use a sample z obtained as described in the previous subsection, and multiply it by a radius r′′ that we assume to be given as a 64-bit fixed-point arithmetic number. Given z, this induces a change of the implicit exponent, and an additional tiny error term. As zi belongs to (−1/4, 1/4) and is within ϵ4 from its corresponding zi, we can prove that r′′ · zi belongs to (−r/4, r/4) and is within r′′ · (ϵ4 + 2−63) from its corresponding r′′ · zi. 
34
Let t denote the rounded vector at Step 2. When rounded as in Step 2, both r′′ · zi and r′′ ·zi result in the same vector t when the distance from r′′ · zi to Z ·N is < N/2− (ϵ4+2−63). Let Dideal 
contained be the distribution over Zmn ∩ B(r′) of the rounded vector t at Step 2, when the whole rounding hypercube is contained in the initial hyperball. Let Dreal 
contained be the analogous distribution for the approximate version of the algorithm. From the discussion above, we have, for all t ∈ Zmn : 
Dreal contained(x) 
Dideal contained(x) 
≥ ( 1− 2r′′(ϵ4 + 2−63) 
N 
)mn 
. 
Here we want to use [Pre17, Lemma 3]. We also need an upper bound counterpart to the above. For usability for up to 267 samples via Rényi divergence arguments, it suffices that the relative error δ satisfies ≈ 2−37. In practice, we will be using Nr′ ∈ [225, 228) as the sampling radius: if the sample is larger than that, we will not keep it. 
C.4 Rejection Sampling with Approximate Distribution 
In this subsection, we discuss what happens when we replace the ideal distribution used as a source for the rejection sampling by the real distribution. 
Lemma 13. Let v a vector, M > 0 and P i, Qi, Qr be three probability distributions such that: 
R∞(Qi∥Qr) < +∞ and R∞(Qr∥Qi) < +∞ and R∞(P i∥Qi ±v) ≤M. 
Then if we use the bimodal rejection sampling strategy for Qi and P i with Qr as a source, the resulting final distribution P r is such that 
R∞(P r∥P i) ≤ R∞(Qi∥Qr)R∞(Qr∥Qi). 
Proof. Let pi and pr denote the acceptance probability of a single step of rejection sampling in the ideal and real setup, respectively. As each is related to a single random variable following either Qi or Qr and then follows the same process, it holds that 
pi 
pr ≤ R∞(Qi∥Qr). 
Moreover, note that pi = 1/M . Hence, we have 
P r : x 7→ Qr(x− v) +Qr(x+ v) 
Qi(x− v) +Qi(x+ v) · P 
i(x) 
M · pr . 
The first fraction is the ratio of the probability of the event “Get a y such that y ± v = x” in the real (numerator) and ideal (denominator) setup. Hence, this ratio is bounded from above byR∞(Qr∥Qi). Plugging the uppder bound for each fraction yields the result. ⊓⊔ 
35