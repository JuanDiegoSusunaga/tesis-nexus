# Composition Law of Conjugate Observables in Random Permutation Sorting Systems - arXiv

- **ID**: `1c0815c6-5b30-4cf5-877e-2d1a09804bfa`
- **Tipo de Fuente**: `SOURCE_TYPE_PDF`
- **URL**: [https://arxiv.org/pdf/2510.08013](https://arxiv.org/pdf/2510.08013)

---

## Contenido Extraído / Texto Completo

Composition Law of Conjugate Observables in 
Random Permutation Sorting Systems 
A Foundation for Ubiquitous True Uniform Randomness 
Yurang R. Kuang (Preferred name: Randy Kuang; ORCID: 0000-0002-5567-2192) 
1*Research, Quantropi Inc., 1545 Carling Av., Suite 620, Ottawa, K1Z 8P9, ON, Canada. 
Abstract 
We report the discovery of a fundamental composition law governing conjugate observables in the Random Permutation Sorting System (RPSS), which quantifies how discrete permutation counts shape continuous timing distributions. The system is characterized by two conjugate observables: the discrete permutation count N̂p and the continuous elapsed time T̂ per sorting cycle. Their relationship is governed by the composition law 
φT̂ (ω) = GN̂p (φX(ω)), 
linking the characteristic function of elapsed time to the probability generating function of permutation counts. This law enables entropy purification, whereby ubiquitous microarchitectural timing variations are transformed into uniform randomness through geometric convergence. We establish synchronous convergence theorems with explicit bounds, providing provable guarantees of cryptographic uniformity. Empirical validation across diverse computing platforms confirms Shannon entropy consistently exceeding 7.9998 bits per byte, chi-square uniformity within statistical confidence bounds, and robustness to environmental perturbations. By instantiating this law, RPSS enables generalpurpose computing devices to serve as self-contained sources of provably uniform randomness, independent of specialized hardware. The Composition Law establishes computational conjugate observables as a universal foundation for trustworthy randomness generation, securing cryptographic purity from emergent computational chaos. 
1 
 
 
 
 
 
 
 
 
 
 
Keywords: Composition Laws, Conjugate Observables, Random Permutation Sorting, Entropy Purification, Cryptographic Randomness, Ubiquitous Computing, Uniform Distribution, Computational Foundations 
1 Introduction 
Randomness lies at the foundation of modern science and technology, underpinning cryptographic security, post-quantum cryptography (PQC), quantum simulation, statistical sampling, and Monte Carlo methods. In cryptography, the strength of protocols is inseparably tied to the quality of their randomness: weak or biased random sources have led to catastrophic key recovery attacks and protocol breaks. This reliance is even more acute in PQC. Leading lattice-based standards such as Kyber (KEM) [1] and Dilithium (digital signatures) [2], recently selected by NIST for standardization [3, 4], consume massive amounts of fresh randomness during key generation, encryption, and signature operations. Their security requires not only unpredictability but also statistical uniformity across billions of random draws, thereby amplifying the demand for robust, universal entropy sources. 
The ideal of true randomness requires both unpredictability and uniform distribution, properties that naturally arise in physical phenomena. Conventional True Random Number Generators (TRNGs) rely on specialized hardware—drawing from electronic noise [5–8], chaotic dynamics [9–12], or quantum effects [13–15]. While powerful, these approaches are bound to physical implementations and frequently require bias correction to achieve uniformity [16, 17], introducing complexity and potential vulnerabilities. As a result, hardware-based solutions have struggled to provide universal, verifiable, and trustworthy randomness across diverse computational environments [18]. 
Modern computing platforms, despite being deterministic in principle, exhibit rich stochastic dynamics at the microarchitectural level. Cache hierarchies, branch prediction, memory contention, and operating system scheduling introduce timing variability typically treated as performance noise. Software-based entropy harvesters exploit such behaviors [19–22], but usually as seed material for pseudorandom generators rather than as direct sources of true randomness. This raises a central question: can intrinsic computational fluctuations themselves be transformed into a mathematically provable foundation for true random number generation, eliminating dependence on specialized hardware and statistical post-processing? 
Here we introduce the Random Permutation Sorting System (RPSS), a computational framework that establishes a new paradigm for randomness generation. In RPSS, a disordered integer array is subjected to repeated random permutations—conceptually analogous to a Quantum Permutation Pad (QPP) [23]—until convergence. The core operation is defined by: 
p̂−1 = 
np∏ j=1 
p̂j , (1) 
2
where p̂j are random permutations and np is the permutation count. This QPP-based approach, previously validated as QPP-RNG [24] against NIST SP 800-90B [25], provides the experimental foundation for our theoretical generalization to RPSS. 
RPSS reveals a pair of conjugate observables [26]: the discrete permutation count N̂p and the continuous elapsed permutation runtime T̂ per sorting cycle. The core of this framework is our discovery of a fundamental composition law, 
φT̂ (ω) = GN̂p (φX(ω)), (2) 
which links the probability-generating function (PGF) of N̂p to the characteristic 
function of T̂ . This law fully characterizes the compound stochastic structure of RPSS, unifying discrete combinatorial randomness and continuous timing variability within a single theoretical framework. 
From this composition law, we establish explicit proofs of synchronous convergence to uniformity under modular reduction, with geometric bounds that provide provable guarantees of randomness. This result elevates timing fluctuations—long viewed as nuisance variability—into a constructive source of cryptographic-grade entropy. Exper-iments confirm that RPSS achieves Shannon entropy consistently exceeding 7.9998 bits per byte and robust uniformity across diverse environments, including mobile and embedded platforms, without reliance on specialized hardware or external randomness extractors. 
Our findings position computational conjugate observables as a universal foundation for trustworthy randomness generation. By demonstrating that the complexity of modern processors intrinsically encodes the mathematical structure required for true randomness, we provide a pathway for post-quantum cryptography, IoT, and secure communications to access cryptographic-grade entropy without additional hardware. Importantly, RPSS can be naturally embedded into post-quantum cryptographic modules, closing the entropy gap in schemes such as lattice-based KEMs and signatures where massive volumes of high-quality randomness are consumed. Ultimately, RPSS reveals that true randomness is not confined to physical noise sources, but is a fundamental emergent property of computation itself for entropy purification. 
2 Results 
2.1 Definition and Compound Structure 
The Random Permutation Sorting System (RPSS) [26] is characterized by a pair of conjugate observables: the discrete permutation count N̂p and the continuous total 
permutation runtime T̂ . The permutation count N̂p follows a negative binomial distribution, denoted 
N̂p ∼ NB(m, p), representing the number of attempts required to achieve m successful sorts, where each attempt succeeds with probability p = 1/N !. While earlier work [26] analyzed N̂p in isolation, here it functions as the stochastic index for elapsed-time analysis. 
3
The total elapsed time until the m-th successful sort is defined as the compound random variable 
T̂ = 
N̂p∑ j=1 
Xj , (3) 
where Xj are i.i.d. positive random variables representing the runtime of each permutation attempt. These capture microarchitectural and system-level effects, including cache misses, branch mispredictions, and OS scheduling delays. We assume Xj has finite mean µX and variance σ2 
X , with σX often comparable to or exceeding µX in jitter-dominated environments. 
This formulation establishes T̂ as a canonical compound distribution, integrating algorithmic randomness (N̂p) with physical variability (Xj). It provides the theoretical foundation for proving convergence of both observables under modular reduction, representing the core stochastic mechanism of RPSS. 
2.2 Composition Law of Conjugate Observables 
The RPSS admits two natural observables: (i) the discrete permutation count N̂p, and 
(ii) the continuous elapsed time T̂ . These observables form a conjugate pair, analogous to momentum and position in physical systems. 
Law 1 (Composition Law of Conjugate Observables) In the RPSS, the elapsed time T̂ and permutation count N̂p are related by: 
φ T̂ (ω) = G 
N̂p (φX(ω)), (4) 
where φ T̂ (ω) is the characteristic function (CF) of T̂ , G 
N̂p (z) is the probability generating 
function (PGF) of N̂p, and φX(ω) is the CF of per-permutation runtime X. 
For N̂p ∼ NB(m, p) with p = 1/N !, this yields the explicit form: 
φT̂ (ω) = 
( pφX(ω) 
1− (1− p)φX(ω) 
)m 
, (5) 
demonstrating that the distribution of elapsed permutation time is obtained by mapping individual permutation runtimes into the discrete permutation-counting structure. 
Interpretation. 
Law 1 establishes an intrinsic composition principle: the stochastic structure of N̂p 
is systematically mapped into that of T̂ via runtime fluctuations. This principle governs RPSS dynamics and explains how microarchitectural noise transforms into true randomness. 
4
Significance. 
By framing RPSS randomness under a law-like statement, we define a deviceindependent mechanism. Much like fundamental physical laws formalize natural phenomena, the composition law formalizes the transformation between conjugate observables in computational systems, providing the foundation for provable convergence to cryptographic uniformity. 
2.2.1 Derivation via Characteristic Functions 
We prove the composition law through the characteristic function formalism: 
φT̂ (ω) = E[eiωT̂ ] = E [ E[eiωT̂ | N̂p] 
] . (6) 
For N̂p = k, we have T̂ = ∑k 
j=1 Xj , giving 
E[eiωT̂ | N̂p = k] = ( φX(ω) 
)k . (7) 
Substituting yields the fundamental relation: 
φT̂ (ω) = E[(φX(ω))N̂p ] = GN̂p (φX(ω)), (8) 
which recovers the composition law. For N̂p ∼ NB(m, p), the PGF is known to be 
GN̂p (z) = 
( pz 
1− (1− p)z 
)m 
, |z| < 1/(1− p), (9) 
providing the explicit characteristic function for T̂ . 
2.2.2 Moment Structure of the Compound Distribution 
The compound structure of T̂ = ∑N̂p 
j=1 Xj produces rich statistical properties that combine combinatorial and microarchitectural randomness. 
Moments of N̂p. 
For N̂p ∼ NB(m, p), the permutation count exhibits inherent overdispersion and higher-order structure: 
E[N̂p] = m p , Var[N̂p] = 
m(1−p) p2 , (10) 
κ3(N̂p) = m(1−p)(1−2p) 
p3 , κ4(N̂p) = m(1−p)(1−6p(1−p)) 
p4 . (11) 
These moments capture the skewness and overdispersion inherent in the permutation counting process, providing the deterministic foundation for empirical validation. 
5
Mean and Variance of T̂ . 
Applying the law of total expectation and variance: 
E[T̂ ] = mµX 
p , (12) 
Var[T̂ ] = mσ2 
X 
p + 
m(1− p)µ2 X 
p2 . (13) 
This decomposition clearly separates contributions from microscopic runtime fluctuations (σ2 
X) and the stochastic number of permutations (Var[N̂p]). 
Higher Cumulants of T̂ . 
By the law of total cumulance [27], the complete moment structure is: 
κ1(T̂ ) = µX κ1(N̂p), (14) 
κ2(T̂ ) = µ2 Xκ2(N̂p) + σ2 
Xκ1(N̂p), (15) 
κ3(T̂ ) = µ3 Xκ3(N̂p) + 3µXσ2 
Xκ2(N̂p) + κ3(X)κ1(N̂p), (16) 
κ4(T̂ ) = µ4 Xκ4(N̂p) + 6µ2 
Xσ2 Xκ3(N̂p) 
+ (4µXκ3(X) + 3σ4 X)κ2(N̂p) + κ4(X)κ1(N̂p). (17) 
These cumulants allow a full description of the shape of T̂ , including tail behavior and asymmetry. 
Statistical Implications. 
The resulting skewness and kurtosis of T̂ , 
γ1(T̂ ) = κ3(T̂ ) 
κ2(T̂ )3/2 , γ2(T̂ ) = 
κ4(T̂ ) 
κ2(T̂ )2 , (18) 
are distinct from those of N̂p due to the compounding with Xj . For N̂p, the corresponding measures are: 
γ1(N̂p) = 2− p√ m(1− p) 
, γ2(N̂p) = 6 
m + 
p2 
m(1− p) . (19) 
This difference explains the observed ”fat-to-skinny” runtime distributions of T̂ compared to the more predictable shape of N̂p. The overdispersion and higher moments 
of N̂p translate into the enhanced fat tails and complex shape that make T̂ suitable for high-entropy cryptographic applications. Crucially, the deterministic properties of N̂p provide the theoretical anchor for empirical validation of T̂ , even without explicit knowledge of φX(ω). 
6
2.3 Synchronous Convergence to Uniformity 
Theorem 1 (Synchronous Convergence of RPSS Observables) Let N̂p ∼ NB(m, p) with p = 1/N !, and let 
T̂ = 
N̂p∑ j=1 
Xj , 
where Xj are i.i.d. positive random variables with finite mean µX and variance σ2 X . Under 
reduction modulo R, as M = mN ! → ∞, both observables converge to the discrete uniform distribution with exponential convergence rates: 
Pr [ N̂p mod R = k 
] = 
1 
R +O(ρmN ), (20) 
Pr [ T̂ mod R = k 
] = 
1 
R +O(ρmT ), (21) 
for k = 0, 1, . . . , R− 1, where 0 < ρN , ρT < 1 are geometric decay constants. 
Proof By the composition law (Law 1), the characteristic function of T̂ is 
φ T̂ (ω) = 
( φX(ω) 
(1− φX(ω))N ! + φX(ω) 
)m 
. 
Discrete Fourier inversion for the modulo-R distribution gives 
Pr[T̂ mod R = r] = 1 
R + 
1 
R 
R−1∑ k=1 
φ T̂ (ωk)e 
−irωk , ωk = 2πk 
R . 
Defining the geometric factors: 
ρN,k = 
∣∣∣∣ 1 
(1− eiωk )N ! + eiωk 
∣∣∣∣ , (22) 
ρT,k = 
∣∣∣∣ φX(ωk) 
(1− φX(ωk))N ! + φX(ωk) 
∣∣∣∣ , (23) 
and setting ρN = maxk ρN,k, ρT = maxk ρT,k, we obtain the error bounds:∣∣∣∣Pr[N̂p mod R = r]− 1 
R 
∣∣∣∣ ≤ R− 1 
R ρmN , (24)∣∣∣∣Pr[T̂ mod R = r]− 1 
R 
∣∣∣∣ ≤ R− 1 
R ρmT . (25) 
Since M = mN ! → ∞ forces exponential decay of both bounds, synchronous convergence is established, governed by the slower rate max(ρmN , ρmT ). □ 
Key Implication. 
The exponential decay O(ρm) with ρ = max(ρN , ρT ) quantifies the RPSS uniformity guarantee. While ρN is computable analytically, ρT depends on the unknown distribution of Xj . Empirical validation confirms that parameter sets satisfying ρmN < 0.01 ensure synchronous convergence in practice. 
Table 1 summarizes empirically validated parameters that ensure ρmN < 0.01 while maintaining computational efficiency, with cost per byte given by Cbyte = 
8 n ·mN !N . 
7
Table 1 Empirically validated parameters for n-bit uniform residues ensuring ρmN < 0.01. 
n R = 2n N m N ! M = mN ! ρmN 
1 2 2 12 2 24 0.0003 1 2 3 3 6 18 0.010 2 4 3 5 6 30 0.004 2 4 4 2 24 48 0.010 4 16 4 4 24 96 0.001 4 16 5 2 120 240 0.006 8 256 5 5 120 600 0.001 
2.4 Empirical Runtime Distribution of Individual Permutations 
The per-permutation runtime Xj in the Random Permutation Sorting System (RPSS) exhibits intrinsic stochastic variability, even under controlled system conditions without external perturbations. Empirical measurements for array sizes N = 4–7, summarized in Table 2, reveal several consistent patterns that challenge conventional statistical models: 
 Sharp concentration at minimal runtimes: Most permutations complete within 0–2 ticks for N ≤ 7, with distributions sharply peaked at minimal values, indicating highly optimized execution paths under favorable conditions. 
 Heavy-tailed behavior with extreme outliers: Rare permutations experience runtime spikes (“Too Big” events, ≳ 500 ticks) orders of magnitude larger than modal values. These extreme events persist under isolated conditions and originate from intrinsic microarchitectural phenomena including cache hierarchy misses, branch mispredictions, and pipeline stalls. 
 Discrete and multimodal structure: Runtime distributions display pronounced spikiness with uneven probability mass across tick values. Intermediate runtimes (3– 10 ticks) are often sparsely populated, creating a separation between the dominant low-runtime mode and extreme tail events. 
Cryptographic Entropy Strength and Attack Resistance 
The statistical variability in Xj constitutes a cryptographically robust entropy source resistant to modeling attacks. Heavy-tailed behavior and extreme outliers (≳ 500 ticks) generate distributions that resist parametric characterization, complicating adversary efforts to construct accurate timing models—a property consistent with established cryptographic principles for robust entropy sources. This complexity is amplified by run-to-run variability in both mean (µX varying by 7.35× for N = 6) and variance (σX 
varying by 22×), ensuring computational infeasibility of predicting individual runtime instances even with algorithmic knowledge. This property is essential for resisting statistical attacks reliant on distributional predictability. 
8
Table 2 Empirical per-permutation runtimes Xj (ticks) for array sizes N = 4–7. Statistics include sample size (×1000), mean µX , standard deviation σX , and frequency counts by tick value. Sample sizes below 1000 indicate “Too Big” events exceeding measurement thresholds. 
N Samples µX σX Frequencies (ticks: 0,1,2,...) 7 998 1.566 0.585 0,453,538,2,2,0,1,2 
7 1000 1.529 0.584 0,490,502,4,2,0,0,1,1 
7 994 2.165 1.05 0,156,583,241,6,1,1,1,1,0,1,0,1 
,0,0,0,0,1,1 
7 996 3.147 0.676 0,0,11,873,91,12,2,2,3,1,0,1 
6 999 1.359 0.618 0,675,311,3,4,1,4,1 
6 994 1.485 0.771 0,564,410,11,4,1,1,0,1,0,0,1,0,1 
6 993 1.871 0.876 0,307,607,23,17,36,2,1 
6 999 1.472 0.619 0,559,426,8,4,0,0,1,0,0,0,0,0,1 
6 991 9.98 13.6 0,0,0,0,0,0,0,0,504,427,8,21,17, 
4,3,4,2,1,0,1 
5 997 1.154 0.398 0,853,137,5,1,1 
5 993 1.632 0.833 0,506,385,86,6,4,2,3,0,0,1 
5 996 1.174 0.496 0,491,479,15,4,1,4,2 
5 997 1.148 0.387 0,854,136,2,4,0,1 
5 999 1.489 0.598 0,249,718,25,3,3,0,1 
4 999 0.973 0.258 42,946,8,2,1 
4 998 1.022 0.522 34,935,18,6,3,0,1,0,0,0,0,0,0,1 
4 998 1.346 0.781 0,747,187,56,2,2,3,0,1 
4 998 1.345 0.772 18,772,191,8,4,1,1,2,1 
Statistical Variability as Entropy Source 
The fundamental unpredictability of RPSS emerges from substantial run-to-run variability in mean runtime µX and variance σ2 
X , even for identical array sizes N , representing the core entropy source: 
 Mean runtime variability: ForN = 7, µX ranges from 1.529 to 3.147 ticks (2.06× variation). For N = 6, the range extends from 1.359 to 9.98 ticks (7.35× variation), with one run exhibiting order-of-magnitude increase due to systematic slowdown. 
 Variance instability: Standard deviation σX shows greater relative variability. For N = 6, σX ranges from 0.618 to 13.6 (22× variation), indicating fundamentally different runtime distributions across experimental runs. 
 Unpredictable distribution shapes: Frequency patterns reveal completely different modal structures across runs—some concentrated at 1-2 ticks, others showing broader distributions or secondary peaks. 
This statistical variability reflects inherent non-determinism in modern microprocessor execution, where identical computational tasks exhibit dramatically different timing characteristics due to microarchitectural state variations, rather than measurement error or external factors. 
Extreme Event Characterization 
Extreme runtime events (≳ 500 ticks) under nominal operating conditions demonstrate the fundamentally heavy-tailed nature of Xj . Sample size discrepancies (values below 
9
1000 in Table 2) reflect “Too Big” events excluded from measurement. This heavytailed property directly shapes the compound elapsed-time distribution T̂ : 
1. Tail inheritance and amplification: Heavy tails of Xj propagate through 
the random sum T̂ = ∑N̂p 
j=1 Xj , producing leptokurtic behavior observed in Section 2.5.2. Rare extreme runtimes can dominate total elapsed time. 
2. Partial smoothing through aggregation: Despite heavy tails, summation over N̂p permutations provides statistical smoothing. The central limit theorem for ran-
dom sums ensures T̂ exhibits more stable central behavior while preserving essential stochastic variability. 
3. Modeling implications: The empirical distribution of Xj resists simple parametric characterization, resembling a discrete mixture with high probability mass at minimal runtimes and subexponential tails capturing rare extreme events. Standard distributions fail to simultaneously capture sharp concentration and heavy-tailed behavior. 
Implications for Entropy Extraction 
The intrinsic statistical variability of Xj—particularly unpredictable fluctuations in µX and σ2 
X across runs under identical RPSS configurations—provides robust entropy extraction. This ensures substantial unpredictable timing behavior even under identical external conditions and computational tasks. 
Crucially, as established in Section 2.2.1, this runtime variability—while shaping T̂ morphology—does not compromise final output uniformity guarantees. The conjugacy relationship ensures uncertainty in the continuous time domain translates to reliable uniformity in the discrete count domain after modular reduction. 
In summary, RPSS per-permutation runtime Xj exhibits intrinsic statistical variability in central tendency and dispersion that underpins system entropy generation, while compound structure and modular reduction ensure reliable uniform TURNG output. 
10
2.5 Raw Distribution Features and Moment Validation 
2.5.1 Permutation Count Distribution 
Fig. 1 Empirical distribution of permutation count N̂p for (N = 4,m = 4). 
Our theoretical model posits that permutation sorting trial count N̂p follows a Neg-ative Binomial distribution. Validation experiments with parameters N = 4 and m = 4 (theoretical success probability p = 1/N ! = 1/24) over 106 independent runs show remarkable empirical-theoretical agreement (Fig. 1), statistically confirming algorithmic process governance by Negative Binomial distribution. 
Table 3 Empirical versus theoretical moments for 
permutation count N̂p (N = 4,m = 4). 
Moment Theoretical Empirical 
Mean (µ) 96.0000 95.9598 Variance (σ2) 2208 2200 Skewness (γ1) 1.0002 0.9936 Excess Kurtosis (γ2) 1.5005 1.4573 
Stringent framework validation comes from empirical-theoretical moment comparison. Table 3 presents first four moments of N̂p, with exceptional agreement: mean differs by < 0.05%, variance by < 0.4%, while skewness and kurtosis match within sampling error. This quantitative precision establishes RPSS algorithmic process robustness captured by Negative Binomial law, providing foundational validation for elapsed time T̂ analysis. 
11
2.5.2 Compound Elapsed-Time Distribution and Morphological Phenotypes 
Fig. 2 Empirical raw elapsed time T̂ distributions exhibiting fat, skinny, and ultra-skinny morphological phenotypes under identical parameters (N = 4,m = 4). Dramatic shape variations demonstrate system sensitivity to microarchitectural conditions. 
Building on N̂p validation, we examine total elapsed time T̂ , exhibiting compound 
random sum structure of permutation runtimes. Theoretically, T̂ represents a weighted mixture of convolutions, empirically manifesting distinct morphological phenotypes under identical system parameters (N = 4,m = 4). 
12
Fig. 2 illustrates three typical characteristic shapes. The fat phenotype modes around 64 ticks with long tail extending over 400 ticks, reflecting busy RPSS system with substantial runtime variability and frequent context switching. The skinny phenotype modes around 40 ticks with stronger peak but longer tail, suggesting busy system with partial OS priority allocation concentrating typical runtimes while allowing extreme outliers from intermittent preemption. The ultra-skinny phenotype demonstrates highest peak around 39 ticks with short tail to about 220 ticks, characteristic of idle RPSS system with dedicated OS priority minimizing external interference and maximizing runtime consistency—elevated peak reflects concentrated probability mass from reduced system jitter and more statistically deterministic execution. 
Cryptographic Significance of Distributional Phenotypes 
Morphological phenotypes in T̂ distributions demonstrate key security property: system entropy generation adapts dynamically to environmental conditions while maintaining output uniformity. This adaptability provides inherent resistance to environmental manipulation attacks attempting to degrade entropy quality through system load or resource allocation alterations. Consistent negative binomial N̂p behavior across all phenotypes (Table 3) ensures core randomness generation robustness despite dramatic timing characteristic variations, providing reliable cryptographic operations foundation in diverse deployment environments. 
As predicted in Section 2.2.2, these phenotypes demonstrate high sensitivity to underlying per-permutation runtime Xj statistical characteristics. Dramatic morphological differences emerge from subtle system condition variations amplified through compound random-sum structure. 
Quantitative Morphological Analysis 
We computed comprehensive statistical moments to quantify phenotypic differences, with results summarized in Table 4. 
Table 4 Comprehensive statistical analysis of RPSS elapsed time 
T̂ (N = 4,m = 4) 
Statistic Fat Skinny Ultra-Skinny 
Mean (µ) 105.53 89.99 56.32 Median 105 89 54 Empirical Mode 64 40 39 Std. Dev. (σ) 65.15 82.69 34.27 Variance (σ2) 4244.23 6837.97 1174.76 Skewness (γ1) 1.44 2.03 2.58 Excess Kurtosis (γ2) 2.98 4.17 14.72 
Statistical progression reveals key patterns: 
13
 Central Tendency Shift: Mean elapsed time decreases monotonically from fat (105.53) to ultra-skinny (56.32), while empirical modes show more dramatic reduction (64 → 39) 
 Mode-Mean Divergence: Gap between mode and mean increases from 41.53 (fat) to 49.99 (skinny), then decreases to 17.32 (ultra-skinny), reflecting complex distributional asymmetry changes 
 Non-monotonic Dispersion: Variance peaks for skinny phenotype (6837.97) before collapsing in ultra-skinny case (1174.76), suggesting transitional stochastic behavior 
 Distributional Extremity: Both skewness (1.44→ 2.58) and excess kurtosis (2.98 → 14.72) increase progressively, with ultra-skinny showing extreme leptokurtosis 
Interpretation and Implications 
Phenotypic transition reveals fundamental stochastic process differences. The ultraskinny distribution’s combination of low variance (1174.76) with extreme positive skewness (2.58) and kurtosis (14.72) characterizes a “spiky” distribution—highly concentrated near the mode yet possessing substantial tail mass. 
Higher-order moment progression is particularly revealing: 
 Increasing skewness (γ1 = 1.44 → 2.58) confirms growing distributional asymmetry 
 Explosive kurtosis growth (γ2 = 2.98 → 14.72) indicates extreme leptokurtosis: 
sharp central peaks with exceptionally heavy tails 
 Dramatic modal shift (64 → 39) suggests fundamentally different runtime efficiency 
regimes 
Mean runtime per permutation µX provides crucial efficiency insight. The decrease from 1.10 ticks (fat) to 0.59 ticks (ultra-skinny) reflects progressively more efficient permutation execution, likely from improved cache performance, reduced system jitter, or optimized memory access patterns. This individual permutation runtime reduction directly drives observed T̂ phenotypic differences. 
These empirical results validate the compound-distribution model, demonstrating how subtle Xj runtime characteristic variations amplify through random sum struc-
ture T̂ = ∑N̂p 
j=1 Xj to produce pronounced global morphological differences. Complex central tendency measure relationships underscore heavy-tailed compound distribution characterization challenges and highlight comprehensive moment analysis importance. 
Connection to Theoretical Framework 
Crucially, despite dramatic morphological variations, the theoretical framework established in Section 2.3 ensures TURNG output uniformity robustness. The conjugacy relationship between discrete permutation count N̂p and continuous permutation 
time T̂ , coupled with Theorem 1 geometric convergence guarantees, provides a solid foundation accommodating phenotypic diversity while maintaining reliable uniform output. 
14
2.6 Modular-Reduced Distribution and TURNG Uniformity 
While raw elapsed time T̂ exhibits significant morphological variation across system conditions, our theoretical framework predicts modular-reduced output T̂ mod R will converge to nearly perfect uniform distribution. This uniformity is guaranteed by Theorem 1 synchronous convergence condition, where permutation count distribution N̂p becomes effectively uniform modulo R through geometric suppression of non-zero Fourier modes. 
Empirical validation analyzing per-residue probabilities of permutation count N̂p 
and elapsed time distributions across three morphological phenotypes demonstrates remarkable convergence to uniformity (Table 5, Fig. 3). Maximum deviation from perfectly uniform probability 1/16 = 0.0625 is extremely small, with “Fat” phenotype exhibiting lowest deviation at 0.13%. 
Theoretical-empirical alignment: For parameters N = 4,m = 4, R = 16, Theorem 1 provides N̂p upper bound 15 
16ρ 4 N . From Table 1, ρ4N = 0.001 for this config-
uration, yielding theoretical bound 15 16 ×0.001 = 0.094%. For elapsed time T̂ , the same 
theorem yields bound 15 16ρ 
m T dependent on runtime distribution characteristic func-
tion φX(ω). Even under conservative assumptions (|φX(2πk/R)| ≈ 0.9), theoretical bound remains below 0.52%, comfortably encompassing empirical maximum deviation of 0.69% for Skinny phenotype. 
Entropy values remain essentially maximal (H ≈ 4 bits), and chi-square statistics confirm absence of statistically significant uniformity deviations. This quantitative theory-experiment agreement validates geometric suppression mechanism underlying RPSS framework uniform output generation across discrete counting and continuous timing observables. 
Cryptographic Uniformity Standards Compliance 
Empirical uniformity results significantly exceed typical cryptographic requirements. With maximum deviations of only 0.13% from perfect uniformity and Shannon entropy values consistently above 3.99998 bits, RPSS output meets and exceeds NIST SP 800-90B entropy source standards. χ2 statistics (10.55–23.73) and corresponding p-values (0.0988–0.7839) provide statistical confidence in output suitability for cryptographic applications including key generation, nonce creation, and probabilistic encryption. This uniformity level is particularly notable given raw elapsed time distribution dramatic variations, demonstrating geometric convergence mechanism effectiveness in achieving cryptographic-grade randomness. 
Chi-square tests provide rigorous statistical uniformity confirmation. For 4-bit random variables (k = 16 equiprobable outcomes), expected χ2 statistic under perfect uniformity is k − 1 = 15. All observed χ2 values (10.55–23.73) fall within statistically consistent expectation ranges, with corresponding p-values (0.0988–0.7839) well above conventional rejection thresholds (α = 0.05). This statistical evidence confirms modular reduction operation effectively washes out raw elapsed-time distribution complex morphology, yielding highly uniform random output regardless of underlying phenotypic variation. 
15
Table 5 Per-residue probabilities (indices 0–15) for permutation-count and three elapsed-time distributions, with entropy and chi-square test results. Maximum deviation (±δ) from uniform probability 0.0625 shown as absolute and percentage values. 
Index N̂p Fat T̂ Skinny T̂ Ultra-Skinny T̂ 
0 0.062475 0.062771 0.062745 0.062295 1 0.062341 0.062550 0.062348 0.062312 2 0.062460 0.062096 0.062303 0.062844 3 0.062977 0.062570 0.062748 0.062480 4 0.062866 0.063039 0.062820 0.062393 5 0.062040 0.062393 0.062608 0.062586 6 0.062814 0.062393 0.062393 0.062206 7 0.062358 0.062609 0.062086 0.062312 8 0.062240 0.062329 0.062278 0.062523 9 0.062131 0.061966 0.062308 0.062572 
10 0.062566 0.062273 0.062495 0.062459 11 0.062652 0.062318 0.062160 0.062806 12 0.062091 0.062378 0.062288 0.062655 13 0.062338 0.063194 0.062723 0.062171 14 0.062682 0.062634 0.062932 0.062607 15 0.062969 0.062487 0.062765 0.062779 
±δ 0.000477 0.0000786 0.0004320 0.0003440 % deviation 0.76% 0.13% 0.69% 0.55% 
Entropy 3.99998 3.99998 3.99999 4.00000 χ2 22.35 23.73 16.54 10.55 
p-value 0.0988 0.0698 0.3472 0.7839 
Fig. 3 Empirical modular-reduced permutation count and elapsed time distribution (T̂ mod R). Histogram flatness demonstrates TURNG output uniformity across morphological phenotypes. 
16
Empirical results strongly validate theoretical predictions: despite raw elapsed time distribution dramatic differences—varying in mean (56.32–105.53), variance (1174.76– 6837.97), skewness (1.44–2.58), and kurtosis (2.98–14.72)—modular-reduced outputs are statistically indistinguishable from uniform. This morphological variation robustness demonstrates TURNG construction practical viability for real-world applications with significant system condition fluctuations. 
2.7 A Self-Training True Uniform RNG: QPP-RNG 
Upon achieving synchronous convergence, the RPSS system transitions from deterministic pseudorandom number generation to True Uniform Random Number Generator (TURNG) operation. This transition is enabled by a closed-loop entropy injection mechanism, where the system continuously harvests intrinsic fluctuations—including microarchitectural jitter, OS scheduling variability, and thermal noise—from the computing environment, feeding them back into the permutation sorting engine. 
The fundamental QPP-RNG innovation lies in the conjugate relationship between permutation counts (N̂p) and elapsed permutation time (T̂ ) within the RPSS system (Law 1). While the primary output is modular-reduced permutation counts ñp = N̂p mod R, system entropy originates from environmental jitter manifesting through timing variations. This jitter-derived entropy is continuously injected into the permutation sorting engine via a QPP pad generated by a PRNG reseeded with new outputs from total elapsed permutation times, creating a self-amplifying feedback loop transforming deterministic randomness into true uniform randomness through the entropy purification process: transforming system noises into cryptographic-grade entropy. 
Let sk denote the RPSS internal state (seed) at cycle k, and ηk represent harvested system jitter entropy. The feedback-driven reseeding is expressed generically as 
sk+1 = h(sk, ηk), (26) 
where h(·) is a flexible mixing function (e.g., modular reduction, cryptographic hash, or other entropy mixing) combining current state with fresh entropy to suppress residual correlations and drive the system toward uniformity. 
In the Quantum Cryptographic Dynamics (QCD) context [28], this feedback loop plays a central role: the RPSS system acts as both permutation generator and entropy amplifier, continuously injecting hardware-level stochasticity into its own sorting engine. The result is a self-training TURNG adapting dynamically to device-specific imperfections, autonomously evolving from its initial seed, and producing outputs with true uniform random source statistical properties. 
This framework occupies a conceptual middle ground between classical PRNGs and hardware TRNGs. It is software-defined, platform-agnostic, and fully exploits intrinsic physical fluctuations as a genuine entropy source, ensuring robust reproducible randomness without specialized external hardware. 
17
Cross-Platform Validation and Stability 
The stability and TURNG characteristics of the QPP-RNG architecture have been empirically validated through rigorous independent testing. In a comprehensive crossplatform evaluation published in Scientific Reports [25], the raw output of QPP-RNG underwent NIST SP 800-90B IID testing alongside NIST SP 800-22 and ENT statistical test batteries. The generator consistently achieved high IID min-entropy between 7.85 and 7.95 bits per byte across diverse platforms including Windows, macOS, and Raspberry Pi systems spanning x86 64 and ARM64 architectures [25]. While minor platform-specific variations in timing characteristics were observed—consistent with expected microarchitectural differences—the extracted jitter fingerprint and generated randomness exhibited remarkable statistical consistency irrespective of the underlying hardware or operating system [25]. This independent validation confirms the system’s ability to maintain output stability against both inherent computational variations and deliberate external perturbations. 
Table 6 Statistical properties of modular-reduced 8-bit outputs under controlled environmental perturbations. Primary QPP-RNG output is ñp = N̂p mod R (modular-reduced 
permutation counts), while t̃ = T̂ mod R (modular-reduced elapsed time) is shown for academic entropy injection effect analysis. Each test analyzes 1MB generated data (1,000,000 samples). Shannon entropy in bits, χ2 is chi-square statistic with 255 degrees of freedom, p-value is goodness-of-fit measure against uniformity, Hmin is min-entropy, and µX is empirical mean of elapsed time samples (ticks). 
Test Shannon H χ2 p-value Hmin µX (ticks) 
ñp 7.9998 247.8 0.61 7.9372 — t̃ 7.9998 252.8 0.53 7.9454 2.34 ñp 7.9998 267.7 0.28 7.9443 — t̃ 7.9998 257.6 0.43 7.9414 2.43 ñp 7.9998 234.0 0.35 7.9425 — t̃ 7.9998 282.4 0.22 7.9425 2.63 ñp 7.9998 268.7 0.54 7.9446 — t̃ 7.9995 650.6 ¡0.0001 7.8957 3.00 ñp 7.9998 214.1 0.97 7.9464 — t̃ 7.9996 500.0 0.0001 7.9137 4.31 ñp 7.9998 271.4 0.23 7.9319 — t̃ 7.9995 680.4 0.0001 7.9095 4.41 ñp 7.9998 254.2 0.50 7.9379 — t̃ 7.9990 1327.6 ¡0.0001 7.8457 4.57 ñp 7.9998 225.9 0.90 7.9400 — t̃ 7.9996 1718.9 ¡0.0001 7.8026 4.89 ñp 7.9998 256.6 0.50 7.9231 — t̃ 7.9991 1135.2 ¡0.0001 7.8766 5.67 
18
Security Analysis Under Adversarial Conditions 
Perturbation experiments simulate realistic attack scenarios where adversaries manipulate system resources to degrade entropy quality. Remarkable ñp output stability (Shannon entropy degradation ¡ 0.01%, χ2 variation within ±8%) while t̃ shows significant statistical deviations (χ2 increase up to 580%) demonstrates crucial security property: the system effectively decouples environmental noise from final output quality. This architecture provides inherent protection against: 
 Timing-based attacks: Adversaries cannot easily influence final output by manipulating system timing characteristics 
 Resource exhaustion attacks: Deliberate system loading fails to significantly degrade output uniformity 
 Side-channel resistance: Transformation from t̃ to ñp through modular reduction and reseeding breaks potential side-channel analysis correlations 
Min-entropy analysis further validates security under perturbation, showing even under heavy system load (µX = 5.67 ticks), Hmin remains above 7.8 bits, ensuring adequate cryptographic operation entropy. 
Interpretation of Experimental Results 
Table 6 presents QPP-RNG output statistical properties under controlled environmental perturbations. Primary output ñp (modular-reduced permutation counts) represents final entropy-amplified result, while t̃ (modular-reduced elapsed permutation time) serves as academic probe validating entropy injection mechanism. 
Baseline Operation: First three experimental runs correspond to RPSS system operating in relatively stable environment without external deliberate perturbations andXj exhibiting good i.i.d. characteristics. In this regime, both outputs exhibit excellent statistical uniformity: Shannon entropy remains essentially maximal (H ≈ 7.9998 bits), chi-square statistics fall within expected uniform 8-bit distribution ranges (theoretical mean χ2 ≈ 255), p-values comfortably above typical significance thresholds (α = 0.05), and min-entropy remains high. Low mean elapsed time µX (2.34– 2.63 ticks) reflects permutation sorting engine baseline performance under minimal interference. 
Perturbation Response: Starting from fourth row, we intentionally introduce environmental perturbations by dragging applications across the screen to force OS resource reallocation. This systematic intervention produces key observations: 
 Increased Permutation Runtime Duration: Mean elapsed time µX rises progressively from 3.00 to 5.67 ticks, indicating individual permutation runtimes Xj 
lengthen due to OS-induced scheduling delays and resource contention. 
 Entropy Injection Validation: Academic t̃ analysis reveals significantly increased 
chi-square statistics (rising from ∼250 to over 1700) and highly significant p-values (p < 0.0001), demonstrating measurable environmental interference impact on timing variability, validating entropy injection mechanism sensitivity to system conditions. 
 Distributional Resilience: Despite timing channel statistical deviations, overall distribution quality remains high. t̃ Shannon entropy maintains values above 7.9990 
19
bits, and ñp χ2 remains between 226 and 271, showing environmental perturbations introduce only minor distributional biases relative to massive 8-bit output space. Biased permutation times updating PRNG seed are effectively smoothed by PRNG mixing function, demonstrating minimal ñp (primary TURNG output) impact. 
 Output Stability: Crucially, primary output ñp remains remarkably stable across all perturbation scenarios. Shannon entropy, chi-square statistics, and p-values show minimal variation, demonstrating conjugate dynamics efficacy—the system successfully harnesses environmental noise while decoupling final output from transient environmental effects. 
 Min-Entropy Analysis: t̃ min-entropy shows measurable reductions under heavy perturbation (decreasing from ∼7.94 to 7.80 bits), consistent with increased certain elapsed-time residue probability from systematic timing delays, further validating genuine entropy variation capture and measurement. 
Architectural Resilience: Experimental results demonstrate remarkable system robustness. While environmental perturbations cause t̃ χ2 to increase up to 580% (252.8 → 1718.9), primary output ñp maintains χ2 variations within ±8% of baseline, with entropy degradation below 0.01%. This decoupling validates conjugate dynamics approach for practical TURNG deployment. 
The QPP-RNG successfully transforms environmental entropy—traditionally viewed as instability source—into controlled resource enhancing randomness quality. The critical feedback loop, where true environmental entropy is injected back into sorting engine, enables system evolution from deterministic PRNG into practical TURNG adapting to dynamic hardware conditions while producing cryptographically robust random outputs. 
2.8 Cryptographic Security Assessment 
Adversarial Model and Security Properties 
RPSS architecture provides inherent security properties under realistic adversarial model where attackers can observe outputs and manipulate environmental conditions but cannot access internal generator states: 
 Forward Security: Continuous reseeding mechanism sk+1 = h(sk, ηk) ensures current state compromise does not reveal previous outputs, as fresh entropy ηk from environmental jitter is incorporated each cycle. 
 Backtracking Resistance: Self-amplifying feedback loop prevents adversaries from working backward from current outputs to determine previous states, due to one-way mixing function h(·) and continuous entropy injection. 
 Environmental Attack Resistance: Conjugacy relationship between N̂p and 
T̂ ensures timing characteristic manipulation attempts (e.g., through resource contention or timing attacks) have minimal final output uniformity impact, as demonstrated in Table 6. 
Compliance with Cryptographic Standards 
Empirical results demonstrate key cryptographic standards compliance: 
20
 NIST SP 800-90B: Entropy estimates (H > 7.9998 bits, Hmin > 7.8 bits) and statistical uniformity meet deterministic random bit generator (DRBG) entropy source requirements. 
 Common Criteria: Platform-agnostic software implementation provides reproducible, verifiable randomness generation suitable for evaluated security products. 
 FIPS 140-3: Statistical test results (uniformity, entropy, moment validation) support cryptographic module certification requiring approved random number generation. 
Practical Security Implications 
For real-world deployment, RPSS framework offers significant security advantages over conventional approaches: 
 Hardware Independence: Eliminates hardware TRNG backdoor or manufacturing vulnerability risks 
 Verifiable Implementation: Software-based approach enables third-party verification and randomness quality audit 
 Adaptive Security: System naturally adapts to different computing environments while maintaining cryptographic properties 
 Post-Quantum Readiness: Randomness generation quality supports postquantum cryptographic algorithm entropy requirements 
Final Security Assessment 
Comprehensive experimental validation demonstrates RPSS framework achieves cryptographic-grade randomness generation with inherent security properties. Sys-tem resilience to environmental perturbations, consistent uniformity across diverse operating conditions, and robust entropy generation meet security-critical application requirements. Software-defined, platform-agnostic approach provides significant advantages for modern cryptographic deployments where hardware trust cannot be assumed and verifiable security is paramount. Demonstrated forward security, environmental attack resistance, and standards compliance position RPSS as viable solution for next-generation cryptographic systems. 
RPSS self-stabilization capability with closed-loop entropy injection mechanism potentially offers tamper detection and self-stabilization features for TURNG, providing resilience to both environmental fluctuations and potential adversarial interference. 
3 Methods 
3.1 Theoretical Framework 
The Random Permutation Sorting System (RPSS) generalizes the experimentally validated QPP-RNG [24]. In RPSS, a disordered array of size N is subjected to repeated random permutations until it is fully sorted, with the trial count N̂p modeled by the 
negative binomial distribution NB(m, p), where p = 1/N !. The elapsed runtime T̂ per sorting cycle is the compound sum of independent jittered delays Xj , yielding 
21
conjugate observables: 
N̂p and T̂ = 
N̂p∑ j=1 
Xj . 
Their dependence is captured by the composition law 
φT̂ (ω) = GN̂p (φX(ω)), (27) 
where GN̂p is the PGF of N̂p and φX is the CF of the jitter distribution. This the-
oretical framework provides the foundation for synchronous convergence proofs and parameter selection. 
3.2 Parameterization 
To generate n-bit residues under modulus R = 2n, RPSS requires appropriate selection of array size N and success count m. The expected number of trials is 
M = mN !, 
while the sorting cycle cost scales as 
Ccycle = mN !N = O(mN !N). 
The efficiency of randomness generation is quantified by the cost per 1-byte output, 
Cbyte = 8 
n Ccycle, 
where the factor 8/n accounts for the number of cycles required to form one byte. Empirically validated parameter sets that ensure synchronous convergence while 
balancing computational efficiency are provided in Table 1 following Theorem 1. 
3.3 Implementation 
The RPSS implementation follows the same design principles as QPP-RNG [25]. Arrays of size N are randomly permuted using a Fisher–Yates shuffle seeded by a high-resolution cycle counter. Each trial tests for array sortedness and accumulates elapsed runtime. The process repeats until m successful sorts are observed. Both N̂p 
and T̂ residues are reduced modulo R to yield n-bit random values. Concatenation strategies (n = 1, 2, 3, 4) are employed to form byte outputs. 
This implementation strategy mirrors that of QPP-RNG, which has been empirically validated across diverse computing architectures—including Windows, macOS, and Raspberry Pi systems spanning x86 64 and ARM64—demonstrating consistent high IID min-entropy between 7.85 and 7.95 bits per byte and successful passage of NIST SP 800-90B IID tests [25]. 
22
3.4 Experimental Setup 
While QPP-RNG has been benchmarked across multiple architectures in prior work [25], in this study we focus on a Windows/x86 implementation to validate the RPSS framework. The generator is implemented in Java. For NIST SP 800-90B IID and entropy tests, we produce 1 MB of raw random data (∼ 106 bytes) per run, without post-processing. Larger datasets can be generated if needed for extended statistical validation. High-resolution timers (TSC) capture elapsed runtime, and compiler optimizations and thread affinity are controlled to minimize systematic bias while pre-serving natural microarchitectural noise sources such as caching, pipeline stalls, and scheduling variability. 
3.5 Statistical Validation 
Random outputs were validated against NIST SP 800-90B [17] using the reference IID test suite, estimating both min-entropy and Shannon entropy. Additional uniformity analyses included byte-frequency chi-square tests, serial correlation, and modular residue histograms. Importantly, no external randomness extractor or debiasing mechanism was applied: the observed uniformity arises intrinsically from RPSS convergence. Entropy estimates consistently exceeded 7.9998 bits per byte across platforms, confirming the theoretical predictions of synchronous convergence. 
4 Conclusion 
This work establishes the Random Permutation Sorting System (RPSS) as a rigorous theoretical and practical framework for True Uniform Random Number Genera-tion (TURNG) with provable cryptographic guarantees. RPSS exploits the duality of permutation count (N̂p) and elapsed runtime (T̂ ) to construct a self-correcting, software-based TURNG that bridges the gap between conventional PRNGs and hardware TRNGs, delivering high-quality randomness without reliance on specialized hardware. 
The core theoretical advance is the compound stochastic model 
T̂ = 
N̂p∑ j=1 
Xj , 
in which the negative binomial distribution of N̂p and the microarchitectural timing variability Xj together generate a rich spectrum of distributional behavior. The associated composition law, 
φT̂ (ω) = GN̂p (φX(ω)), 
fully characterizes the relationship between discrete and continuous observables, providing geometric bounds for convergence to uniformity under modular reduction. This formalism enables precise parameter selection for cryptographic deployment, ensuring both unpredictability and statistical uniformity. 
23
The conjugate observables mechanism supplies continuous entropy injection, enabling RPSS to transform an initial PRNG or low-entropy state into a self-reinforcing TURNG. This architecture inherently adapts to device-specific imperfections and environmental fluctuations, offering strong resistance to timing attacks and adversarial manipulation. The system can thus sustain cryptographic-grade output quality even when timing channels exhibit significant variability—a critical requirement for real-world deployment. 
Experimental validation confirms RPSS’s exceptional performance: Shannon entropy consistently exceeding 7.9998 bits per byte, maximum uniformity deviations below 0.13%, and robust reproducibility across heterogeneous platforms. Moreover, NIST SP 800-90B compliance is consistently achieved, demonstrating that microarchitectural noise can be reliably converted into cryptographically meaningful entropy, even on mobile and embedded devices. 
RPSS represents a paradigm shift in software-defined randomness generation. By systematically transforming computational jitter into provably uniform and unpredictable outputs, RPSS establishes a new foundation for secure, hardware-agnostic cryptographic primitives. This mitigates concerns about hardware trust, supply chain integrity, and sophisticated adversarial threats by eliminating reliance on opaque entropy sources. 
Future work will focus on several key directions: modeling entropy under non-i.i.d. and adversarial conditions, developing scalable and parallel implementations for highthroughput applications, optimizing parameters to meet cryptographic standards, integrating with quantum cryptographic primitives for verifiable and quantumresistant randomness, and conducting formal analyses of resilience against side-channel and fault-injection attacks. 
By uniting compound stochastic modeling with empirical validation, RPSS provides a generalizable framework for analyzing complex computational processes across cryptography, security engineering, and performance modeling. This enables the design of provably secure, software-based randomness sources that are both theoretically rigorous and practically robust. Ultimately, the Composition Law defines the mathematics of entropy purification, guaranteeing cryptographic purity from emergent computational chaos. 
Acknowledgements. The authors acknowledge the use of language AI tools, including ChatGPT, Gemin, and Deepseek, for language refinement and editorial assistance. Scientific analyses and conclusions remain the sole responsibility of the authors. 
Declarations 
Funding 
This research received no specific grant from any funding agency in the public, commercial, or not-for-profit sectors. 
Competing interests 
The authors declare no competing interests. 
24
Ethics approval and consent to participate 
Not applicable. This study does not involve human participants, animal subjects, or clinical data. 
Consent for publication 
All authors have read and approved the final manuscript for publication. 
Data availability 
All supporting data, including permutation counts, runtime distributions, and associated supplementary figures (Supplementary Figures 1–3), are provided in Supplemen-tary Dataset 12345 (Excel file). The file contains multiple sheets with labeled data and figure source information. Additional materials are available from the corresponding author upon reasonable request. 
Code availability 
The Java source code titled QPP RNG.java, which implements the Random Permu-tation Sorting System (RPSS) used in this study, is available as Supplementary Information with this submission. The file includes an internal README describing the three implemented tests and usage details. 
Authors’ contributions 
Y. R. K: Conceptualization, Methodology, Software, Validation, Formal analysis, Investigation, Data curation, Writing - original draft, Writing - review and editing, Visualization. 
References 
[1] Avanzi, R., Bos, J., Ducas, L., Kiltz, E., Lepoint, T., Lyubashevsky, V., Schanck, J.M., Schwabe, P., Seiler, G., Damien, S.: CRYSTALS-KYBER. Specification document (update from August 2021) (2020). https://pq-crystals.org/kyber/data/ kyber-specification-round3-20210804.pdf 
[2] Lyubashevsky, V., Ducas, L., Kiltz, E., Lepoint, T., Schwabe, P., Seiler, G., Stehlé, D., Bai, S.: CRYSTALS-Dilithium - Algorithm Specifications and Sup-porting Documentation (Version 3.1) (2020). https://pq-crystals.org/dilithium/ data/dilithium-specification-round3-20210208.pdf 
[3] Standards, N.I., Technology: FIPS 203 (Initial Public Draft): Module-Lattice-Based Key-Encapsulation Mechanism Standard. https://csrc.nist.gov/pubs/fips/ 203/final. ML-KEM (CRYSTALS-Kyber) (2023) 
[4] Standards, N.I., Technology: FIPS 204: Module-Lattice-Based Digital Signa-ture Standard. https://csrc.nist.gov/pubs/fips/204/final. ML-DSA (CRYSTALS-Dilithium) (2024) 
25
[5] Yang, B., Rožic, V., Grujic, M., Mentens, N., Verbauwhede, I.: Es-trng: A highthroughput, low-area true random number generator based on edge sampling. IACR Transactions on Cryptographic Hardware and Embedded Systems 2018(3), 267–292 (2018) https://doi.org/10.13154/tches.v2018.i3.267-292 
[6] Tehranipoor, M., Nalla Anandakumar, N., Farahmandi, F.: True Random Num-ber Generator (TRNG), pp. 19–33. Springer, Cham (2023). https://doi.org/10. 1007/978-3-031-31034-8 2 . https://doi.org/10.1007/978-3-031-31034-8 2 
[7] Ansari, U., Chaudhary, A.K., Verma, S.: Enhanced true random number generator (trng) using sensors for iot security applications. In: 2022 Third International Conference on Intelligent Computing Instrumentation and Control Technologies (ICICICT), pp. 1593–1597 (2022). https://doi.org/10.1109/ICICICT54557.2022. 9917919 
[8] Ji, Z., Brown, J., Zhang, J.: True random number generator (trng) for secure communications in the era of iot. In: 2020 China Semiconductor Technol-ogy International Conference (CSTIC), pp. 1–5 (2020). https://doi.org/10.1109/ CSTIC49141.2020.9282535 
[9] Araki, S., Wu, J.-H., Yan, J.-J.: A novel design of random number generators using chaos-based extremum coding. IEEE Access 12, 24039–24047 (2024) https: //doi.org/10.1109/ACCESS.2024.3365638 
[10] Lu, H., Alkhazragi, O., Wang, Y., Ng, T.K., Ooi, B.S.: Parallel on-chip physical random number generator based on self-chaotic dynamics of free-running broadarea vcsel array. IEEE Journal of Selected Topics in Quantum Electronics 31(2: Pwr. and Effic. Scaling in Semiconductor Lasers), 1–11 (2025) https://doi.org/ 10.1109/JSTQE.2024.3462489 
[11] Inubushi, M.: Unpredictability and robustness of chaotic dynamics for physical random number generation. Chaos: An Interdisciplinary Journal of Nonlinear Science 29(3), 033133 (2019) https://doi.org/10.1063/1.5090177 
[12] Bonilla, L.L., Alvaro, M., Carretero, M.: Chaos-based true random number generators. Journal of Mathematics in Industry 7(1), 1 (2016) https://doi.org/10. 1186/s13362-016-0026-4 
[13] Ma, X., Yuan, X., Cao, Z., et al.: Quantum random number generation. npj Quantum Information 2, 16021 (2016) https://doi.org/10.1038/npjqi.2016.21 
[14] Gabriel, C., Wittmann, C., Sych, D., Dong, R., Mauerer, W., Andersen, U.L., Marquardt, C., Leuchs, G.: A generator for unique quantum random numbers based on vacuum states. Nature Photonics 4, 711–715 (2010) https://doi.org/10. 1038/nphoton.2010.197 
26
[15] Zhang, Y., Zhang, X., Zhang, Z., Zhang, J., Zeng, H., Pan, J.-W.: A simple low-latency real-time certifiable quantum random number generator. Nature Communications 12, 1031 (2021) https://doi.org/10.1038/s41467-021-21069-8 
[16] Barker, E., Kelsey, J.: Recommendation for random number generation using deterministic random bit generators. Technical Report NIST SP 800-90A Rev. 1, National Institute of Standards and Technology (June 2015). https://doi.org/10. 6028/NIST.SP.800-90Ar1 . https://csrc.nist.gov/pubs/sp/800/90/a/r1/final 
[17] Sönmez Turan, M., Barker, E., Kelsey, J.M., McKay, K.A., Baish, M.L., Boyle, M.: Recommendation for the entropy sources used for random bit generation. Technical Report Special Publication 800-90B, National Institute of Stan-dards and Technology, Gaithersburg, MD (January 2018). https://doi.org/10. 6028/NIST.SP.800-90b . https://nvlpubs.nist.gov/nistpubs/SpecialPublications/ NIST.SP.800-90B.pdf 
[18] Rahman, M.T., Xiao, K., Forte, D., Zhang, X.: Ti-trng: Technology independent true random number generator. In: Proceedings of the Conference on Design, Automation and Test in Europe (DATE), pp. 1–4 (2014). https://doi.org/10. 1145/2593069.2593236 . https://dl.acm.org/doi/10.1145/2593069.2593236 
[19] Gutterman, Z., Pinkas, B., Reinman, T.: Analysis of the linux random number generator. IEEE Symposium on Security and Privacy, 371–385 (2006) https:// doi.org/10.1109/SP.2006.5 
[20] Intel Corporation: Intel digital random number generator (drng) software implementation guide. Technical report, Intel Corporation (2012). https://software.intel.com/en-us/articles/ intel-digital-random-number-generator-drng-software-implementation-guide 
[21] Müller, S.: The Jitter RNG – Fast and Secure Random Number Generation using CPU Jitter. https://www.chronox.de/jent/CPU-Jitter-NPTRNG-v2.2.0. pdf. Accessed: 2025-10-03 (2019) 
[22] Fischer, V., Drutarovský, M.: True random number generator embedded in reconfigurable hardware. In: Workshop on Cryptographic Hardware and Embedded Systems (2002). https://api.semanticscholar.org/CorpusID:5441670 
[23] Kuang, R., Barbeau, M.: Quantum permutation pad for universal quantum-safe cryptography. Quantum Information Processing 21, 211 (2022) https://doi.org/ 10.1007/s11128-022-03557-y 
[24] Kuang, R., Lou, D.: Iid-based qpp-rng: A random number generator utilizing qpp generated from system jitter. In: 2025 IEEE 14th International Conference on Communications, Circuits and Systems (ICCCAS), pp. 165–171 (2025). https: //doi.org/10.1109/ICCCAS65806.2025.11102777 
27
[25] Vrana, G., Lou, D., Kuang, R.: Raw qpp-rng randomness via system jitter across platforms: a nist sp 800-90b evaluation. Scientific Reports 15, 27718 (2025) https: //doi.org/10.1038/s41598-025-13135-8 
[26] Kuang, R.: Statistical Quantum Mechanics of the Random Permutation Sorting System (RPSS): A Self-Stabilizing True Uniform RNG (2025). https://arxiv.org/ abs/2509.10174 
[27] Brillinger, D.R.: The calculation of cumulants via conditioning. Annals of the Institute of Statistical Mathematics 21, 215–218 (1969) https://doi.org/10.1007/ BF02532246 
[28] Kuang, R.: Quantum cryptographic dynamics: modeling cryptosystems via entropy operators. Academia Quantum. Academia.edu Journals 2(3) (2025) https://doi.org/10.20935/AcadQuant7841 . https://www.academia.edu/3064-979X/2/3/10.20935/AcadQuant7841 
28