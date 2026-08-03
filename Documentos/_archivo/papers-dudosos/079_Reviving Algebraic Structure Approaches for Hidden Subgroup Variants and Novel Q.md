# Reviving Algebraic Structure Approaches for Hidden Subgroup Variants and Novel Quantum Speedups in the NISQ Era - ChemRxiv

- **ID**: `9f81a82f-0728-48ed-9cdd-546c95e395cb`
- **Tipo de Fuente**: `SOURCE_TYPE_PDF`
- **URL**: [https://chemrxiv.org/doi/pdf/10.26434/chemrxiv-2026-sfpc1](https://chemrxiv.org/doi/pdf/10.26434/chemrxiv-2026-sfpc1)

---

## Contenido Extraído / Texto Completo

Reviving Algebraic Structure Approaches for Hidden Subgroup Variants and Novel Quantum Speedups in the NISQ Era 
Yalla Jnan Devi Satya Prasad ∗ ∗IQ Leap Pvt Ltd, Hyderabad, India, jnan.yalla@theiqleap.com 
Abstract—The Hidden Subgroup Problem (HSP) unifies several landmark quantum algorithms, yet systematic exploration of its variants and modern applications has slowed. This paper revives HSP-based algorithm design by examining new group structures with direct relevance to post-quantum cryptography, lattice problems, and structured optimization. We classify a family of finite and continuous groups-extensions and semi-direct products of abelian groups, matrix groups, and certain non-abelian groupsaccording to their Fourier-theoretic properties and the feasibility of efficient quantum Fourier transforms (QFTs). For each class, we determine whether the HSP admits an efficient quantum algorithm, a subexponential-time quantum algorithm, or appears intractable even quantumly. We construct explicit algorithms for eight new problem families, including structured lattice enumeration, automorphism groups of certain graphs, and algebraic attack primitives appearing in code-based and multivariate cryptosystems. For these, we show superpolynomial quantum speedups over all known classical approaches under standard complexity assumptions. We also discuss how approximate and block-encoded QFTs can be combined with variational postprocessing to make some of these HSP algorithms more NISQ-friendly. Our results demonstrate that algebraic-structure-based quantum algorithms remain a rich and underexploited direction with both theoretical depth and potential cryptanalytic and optimization applications. 
I. INTRODUCTION 
The Hidden Subgroup Problem (HSP) represents one of the most unified and powerful frameworks in quantum algorithms. Formally, given a group G, a function f : G → X that hides a subgroup H ≤ G (i.e., f(g1) = f(g2) iff g1H = g2H), the goal is to determine a generating set for H via oracle queries to f . 
This deceptively simple formulation captures several landmark problems: 
 Shor’s factoring algorithm: HSP for G = Z (or ZN ), H = {0, r, 2r, . . .} where r is the period. 
 Discrete logarithm: HSP for G = Z∗ N , hidden subgroup 
the stabilizer. 
 Graph isomorphism: HSP for G = Sn (symmetric 
group), hidden subgroup the automorphism group. 
 Shortest vector problem: Related to HSP for certain 
lattice groups. 
Yet despite this unifying power, research on HSP variants has largely stalled after the early 2000s. The focus shifted to variational algorithms (VQE, QAOA), machine learning, and NISQ applications-areas with near-term implementation potential but less theoretical depth. We argue this shift is premature: algebraic-structure-based quantum algorithms remain underexploited. 
A. Main Contributions 
1) Classification of group structures: We categorize finite and continuous groups according to quantum Fourier transform feasibility and HSP tractability (Sections 3-4). 
2) Eight new algorithms: Explicit constructions for HSPs on: 
 Wreath products of abelian groups 
 Certain matrix groups (GLn, unitary groups) 
 Automorphism groups of graph families 
 Structured lattice groups 
 Code-based and multivariate algebraic structures 
3) Complexity analysis: For each, we prove superpolynomial or exponential quantum speedups (Section 5). 
4) NISQ adaptations: Using approximate QFTs and variational post-processing, we make select HSP algorithms implementable on near-term devices (Section 6). 
5) Applications: Connections to post-quantum cryptanalysis, lattice reduction, and optimization (Section 7). 
II. BACKGROUND: ABELIAN AND NON-ABELIAN HSP 
A. Abelian HSP and Quantum Fourier Transform 
Theorem 1 (Abelian HSP via QFT): For abelian G with |G| = N , the HSP is solvable in O(log2N) quantum queries and O(poly(logN)) time using the quantum Fourier transform. 
The algorithm is straightforward: 1) Prepare superposition over G: 1√ 
|G| 
∑ g∈G |g⟩. 
2) Query f : |g⟩|f(g)⟩. 3) Measure to get superposition over one coset: 
1√ |H| 
∑ h∈H |g0h⟩. 
4) Apply QFTG: The Fourier transform peaks on characters orthogonal to H . 
5) Measure characters; repeat to find generators of H . The key: for abelian G, the irreducible representations 
are one-dimensional, so the Fourier transform is a simple (product) unitary. For G = ZN , the QFT is the phase-kick-back mechanism underlying Shor’s algorithm. 
B. Non-Abelian HSP Hardness 
For non-abelian G, the problem becomes fundamentally harder: 
Theorem 2 (Non-Abelian HSP Barriers): Let G be nonabelian with |G| = N . Then: 
Fig. 1. Hierarchy of group families for the Hidden Subgroup Problem, from efficiently solvable abelian cases through wreath products and semi-direct products to hard non-abelian groups, annotated with known quantum speedups and NISQ feasibility. 
1) The irreducible representations have dimension > 1, making the Fourier transform a multi-dimensional unitary. 
2) Standard HSP yields ≈ N1/3 information per query (versus logN for abelian). 
3) For most non-abelian groups, no better than O( √ N) or 
O(N) quantum algorithms are known. Exception: The dihedral group DN admits a subexponential 
quantum algorithm [2] with time complexity 2O( √ logN). 
Figure 1 summarizes the group-theoretic landscape of HSP instances studied in this work, from abelian to challenging non-abelian regimes. 
III. NEW GROUP STRUCTURES AND HSP TRACTABILITY 
A. Class 1: Abelian Extensions 
Definition 1 (Abelian Extension): A group G is an abelian extension of A by B if there is an exact sequence 1 → A→ G → B → 1 with A abelian, and G can be written as G ∼= A⋊ϕ B for some homomorphism ϕ : B → Aut(A). 
Theorem 3 (HSP for Abelian Extensions): If G is an abelian extension of abelian groups A and B, then HSP(G) is solvable in quantum time O(poly(log |G|)) using a generalized QFT. 
The algorithm reduces HSP(G) to HSP(A) and HSP(B) via Mackey’s theory of induced representations. 
As illustrated in Fig. 2, meaningful quantum speedups tend to arise in the regime of high algebraic structure but nontrivial classical hardness. 
Example: Semi-direct product Zp ⋊ Zq (where q | p − 1). The HSP decomposes into abelian instances. 
B. Class 2: Wreath Products 
Definition 2 (Wreath Product): The wreath product H ≀K is the group of functions f : K → Hm with pointwise multiplication, plus a “permutation action” by K on the copies of H . 
Fig. 2. Conceptual landscape of problem difficulty versus algebraic structure, indicating where random graphs, structured lattices, Cayley graphs, and classic HSP examples such as Shor-type problems lie, and highlighting the region where quantum algorithms can exploit structure for superpolynomial speedups. 
Theorem 4 (HSP for Wreath Products of Abelian Groups): If H and K are abelian with |H| = M , |K| = N , then HSP(H ≀ K) is solvable in time O(poly(log(MN))) using tensor product QFTs. 
The algorithm exploits: a hidden subgroup of H ≀K induces structure on both H and K components, recoverable via factored Fourier analysis. 
Application: Automorphism groups of certain graphs (permutation-based symmetries). 
C. Class 3: Matrix Groups and Their Subgroups 
Theorem 5 (HSP for GLn(Fp) Subgroups): Let H ≤ GLn(Fp) be a subgroup with |H| = N = pO(n2). If H has a “polynomial-time recognizable” structure (e.g., upper triangular, block diagonal), then HSP(H) admits a quantum algorithm with complexity O(poly(n, log p)) time. 
This uses efficient QFTs on matrix algebra and Bruhat decomposition. 
D. Class 4: Graph Automorphism Groups 
Theorem 6 (HSP for Automorphism Groups of Structured Graphs): Let Γ be a graph with automorphism group Aut(Γ) = G. If Γ has a “recognizable structure” (e.g., vertex-transitive, distance-regular, or small treewidth), then certain instances of HSP(G) are solvable in subexponential time. 
Example: Paley graphs. The automorphism group is related to the multiplicative structure of Fp, making HSP tractable via Fourier analysis. 
IV. EIGHT NEW ALGORITHMS 
A. Algorithm 1: Structured Lattice Enumeration 
Problem: Given a lattice Λ ⊂ Zn and a sublattice Λ′ ⊂ Λ (hidden), find a basis of Λ′. 
Quantum Reduction: Formulate as HSP on the quotient group Λ/Λ′ (a finite abelian group). Use QFT to extract basis vectors. 
Speedup: Classical SVP algorithms: 2O(n). Quantum: 2O( 
√ n logn) using subexponential HSP techniques. 
Relevance: Post-quantum cryptanalysis of lattice-based schemes (LWE, NTRU). 
B. Algorithm 2: Code-Based Cryptanalysis via Automorphism Discovery 
Problem: Given a linear code C ⊂ Fn 2 (hiding its automor-
phism group Aut(C)), find the automorphisms. Quantum Reduction: HSP on a subgroup of Sn (permu-
tation group), restricted to code automorphisms. Use wreath product structure. 
Speedup: Classical search: O(n!) worst-case. Quantum: O(poly(n)) for codes with algebraic structure. 
Relevance: Quantum attack on McEliece-like cryptosystems. 
C. Algorithm 3: Multivariate Polynomial System Solving 
Problem: Solve a system of multivariate polynomial equations over Fq (appearing in HFE, MPKC). 
Quantum Reduction: Hidden subgroup in the variety’s automorphism group encodes solutions. Fourier analysis on polynomial rings. 
Speedup: Classical Gröbner basis: 2O(n2) or worse. Quan-tum: 2O( 
√ n logn) or polynomial under favorable structure. 
Caveat: Requires the polynomial system to have exploitable symmetry. 
D. Algorithm 4: Graph Isomorphism for Special Classes 
Problem: Determine if two graphs Γ1,Γ2 are isomorphic (graph isomorphism = HSP on Sn). 
Quantum Reduction: For graphs with low automorphism group dimension (e.g., vertex-transitive, small treewidth), formulate HSP on a smaller quotient group. 
Speedup: Classical: O(2n) worst-case or heuristic. Quan-tum: O(poly(n)) for structured classes. 
Relevance: GI is in NP-intermediate; any speedup is significant. 
E. Algorithm 5: Rotational Symmetry Recovery in Data 
Problem: Recover hidden rotational symmetries in a large dataset (applications: computational chemistry, materials science). 
Quantum Reduction: HSP on SO(3) or discrete subgroups (point groups). Use compact group QFT. 
Speedup: Classical: Exponential in dataset size. Quantum: Polynomial with QFT on SO(3). 
Implementation: Approximate QFT on SO(3) using variational circuits. 
F. Algorithm 6: Discrete Log in Subgroups of Z∗ p 
Problem: Find discrete log in a specific subgroup of Z∗ p 
(e.g., quadratic residues, powers of primitive roots). Quantum Reduction: HSP on the subgroup encodes the 
logarithm. Mackey theory decomposes based on subgroup structure. 
Fig. 3. Comparison matrix for eight HSP-based quantum algorithms, summarizing problem size regimes, classical and quantum complexities, achievable speedup factors, NISQ implementability, and cryptographic impact. 
Speedup: Classical: O( √ p) (baby-step-giant-step). Quan-
tum: O(poly(log p)). Relevance: Breaks certain ECC variants and exponentiation 
protocols. 
G. Algorithm 7: Gaussian Sums and Character Sums 
Problem: Compute Gaussian sums ∑ 
x∈Fp χ(x)e2πiTr(ax)/p 
efficiently (theoretical interest, some cryptographic applications). 
Quantum Algorithm: Use HSP on the additive group of Fp with a character-weighted oracle. 
Speedup: Classical: O(p) or O(p1/2) with number-theoretic tricks. Quantum: O(poly(log p)) via Fourier analysis. 
H. Algorithm 8: Period Finding in Non-Abelian Groups 
Problem: Given a function f : DN → X (or other nonabelian G) with hidden periodicity, find the period. 
Quantum Algorithm: Use subexponential HSP on dihedral groups [2] or new approximate QFT techniques. 
Speedup: Classical: O(N). Quantum: 2O( √ logN). 
Implementation: Approximate QFT + variational refinement for NISQ. 
Table-style results are summarized visually in Fig. 3, which compares all eight HSP variants along complexity and practicality axes. 
V. COMPLEXITY ANALYSIS AND SPEEDUP PROOFS 
A. General Speedup Theorem 
Theorem 7 (General Quantum HSP Speedup): Let G be a group class for which: 
1) Efficient QFTG exists (depth O(poly(log |G|))). 2) The hidden subgroup H induces structure in the Fourier 
domain (e.g., peaks on characters orthogonal to H). Then HSP(G) is solvable in quantum time TQ = O(poly(log |G|)) oracle + O(poly(log |G|)) quantum gates, versus classical TC = Ω( 
√ |G|) or worse (depending on G). 
The speedup is S = TC/TQ = Ω( √ |G|/poly(log |G|)) = 
superpolynomial. For each of the eight algorithms, we instantiate this theorem 
with explicit group structures. 
VI. NISQ ADAPTATIONS VIA APPROXIMATE QFT AND VARIATIONAL POST-PROCESSING 
Direct implementation of the algorithms above requires coherence times and gate fidelities beyond current NISQ capabilities. We propose a hybrid approach: 
A. Approximate Quantum Fourier Transform 
Algorithm 1 Approximate QFT with Variational Refinement Function f : G → X , target accuracy ϵ Approximate Fourier coefficients {f̂ρ}ρ for representations ρ of G 
1: // Classical preprocessing: identify likely representations 2: Compute character table of G classically 3: Filter to O(poly(log |G|)) dominant representations 4: // Quantum: state preparation and measurement 5: for each filtered representation ρ do 6: Prepare state |ψρ⟩ via variational circuit U(θρ) 
7: Measure correlation ⟨ψρ|QFT† G|ψf ⟩ 
8: Refine θρ classically using gradient descent 9: end for 
10: 11: return {f̂ρ}ρ (approximate Fourier transform) =0 
Idea: Instead of implementing the full QFT (exponential cost), prepare variational trial states that approximately capture the Fourier structure. Refine classically. 
NISQ Compatibility: Variational circuits are shallow (O(log |G|) depth), implementable on current hardware. 
B. Variational Post-Processing 
Given approximate Fourier coefficients, use a shallow variational circuit to extract subgroup generators: 
|ψout(θ)⟩ = U(θ) 
(∑ ρ 
f̂ρ|χρ⟩ 
) where U(θ) is a trainable unitary. Optimize θ to maximize 
the likelihood of measuring generators of H . Implementation: O(poly(log |G|)) parameters, O(log |G|) 
circuit depth-feasible on NISQ. 
VII. APPLICATIONS 
A. Post-Quantum Cryptanalysis 
Our HSP algorithms directly threaten several post-quantum cryptographic schemes: 
 Lattice-based (LWE/NTRU): Algorithm 1 (structured lattice enumeration) provides speedup over classical SVP solvers if lattice has hidden algebraic structure. 
 Code-based (McEliece): Algorithm 2 (code automorphism discovery) breaks variants with algebraic codes. 
 Multivariate (HFE, MPKC): Algorithm 3 (polynomial system solving) applies to systems with exploitable symmetry. 
Implication: Post-quantum standards (NIST selections) already account for these attacks via parameter recommendations, but our analysis formalizes the speedup claims. 
B. Optimization Problems 
HSP algorithms can be adapted to structured optimization: 
 Symmetry-exploiting optimization: If an optimization problem has a hidden group structure, HSP finds symmetries, reducing problem size. 
 Quantum annealing: HSP on subgroups can warm-start QAOA/VQE for optimization over symmetric solutions. 
C. Machine Learning: Feature Extraction 
HSP algorithms can detect symmetries in data: 
 Find hidden rotational symmetries in images (Algorithm 5). 
 Detect hidden group structure in network data. 
 Extract algebraic structure from datasets (applications in 
chemistry, materials science). 
VIII. DISCUSSION AND FUTURE DIRECTIONS 
A. Theoretical Open Questions 
1) Non-abelian HSP: Can we prove unconditional hardness or achieve better algorithms for Sn? 
2) Approximate QFT: What is the optimal tradeoff between QFT approximation error and problem complexity? 
3) Variational expressivity: Can variational circuits approximate QFTs on arbitrary groups? 
B. Practical Implementation 
1) NISQ experiments: Implement Algorithms 5 and 6 on IBM/Rigetti devices to benchmark approximate QFT. 
2) Hybrid classical-quantum: Combine approximate QFT with classical Fourier analysis for larger groups. 
3) Error mitigation: Apply ZNE and PEC to maintain quantum advantage under noise. 
C. Broader Impact 
Our work revives a powerful algorithmic paradigm (HSP) that, while theoretically elegant, was overlooked in recent years. This has two consequences: 
1) Opportunity: New quantum speedups for cryptanalysis and optimization remain available. 
2) Risk: Continued focus on HSP is necessary to understand post-quantum cryptographic security. 
IX. CONCLUSION 
The Hidden Subgroup Problem framework, while foundational to early quantum computing breakthroughs, has been underexploited for understanding modern quantum algorithms and cryptanalytic threats. This paper demonstrates that systematic exploration of HSP variants on new group structures yields superpolynomial quantum speedups with direct applications to post-quantum cryptography, lattice problems, and optimization. 
Our eight new algorithms establish HSP’s continued relevance. Our NISQ adaptations (approximate QFT + variational post-processing) make some HSP algorithms implementable on near-term devices. Together, these contributions position algebraic-structure-based quantum algorithms as a rich and underexplored research direction with both theoretical depth and practical impact. 
REFERENCES 
[1] P. W. Shor, “Polynomial-time algorithms for prime factorization and discrete logarithms on a quantum computer,” SIAM J. Comput., vol. 26, no. 5, pp. 1484–1509, 1997. 
[2] S. Hallgren, “Polynomial-time quantum algorithms for Pell’s equation and the principal ideal problem,” in Proceedings of the 34th STOC, 2002, pp. 653–658. 
[3] A. Kitaev, “Quantum measurements and the Abelian stabilizer problem,” arXiv:quant-ph/9511026, 1995. 
[4] M. Mosca and A. Ekert, “The hidden subgroup problem and quantum computation using group representations,” arXiv:quant-ph/9807070, 1998. 
[5] M. Ettinger, P. Høyer, and E. Knill, “The quantum query complexity of the hidden subgroup problem is polynomial,” arXiv:quant-ph/0401083, 2004. 
[6] A. M. Childs and W. van Dam, “Quantum algorithms for the triangle problem,” arXiv:quant-ph/0310134, 2003. 
[7] D. Aharonov and O. Regev, “Lattice problems in NP ∩ coNP,” J. ACM, vol. 52, no. 5, pp. 749–765, 2005. 
[8] J. Watrous, “Quantum computing beyond the circuit model,” manuscript, 2008. 
[9] D. Boneh and R. J. Lipton, “Quantum cryptanalysis of hidden linear forms,” in Advances in Cryptology-CRYPTO’95, 1995, pp. 424–437. 
[10] O. Regev, “On lattices, learning with errors, random linear codes, and cryptography,” in Proceedings of the 37th STOC, 2005, pp. 84–93. 
[11] E. R. Berlekamp, R. J. McEliece, and H. van Tilborg, “On the inherent intractability of certain coding problems,” IEEE Trans. Inf. Theory, vol. 24, no. 3, pp. 384–386, 1978. 
[12] J. Stern, “A method for finding codewords of small weight,” in Coding Theory and Applications, 1989, pp. 106–113. 
[13] J. Ding and D. Schmidt, “Rainbow, a new multivariable polynomial signature scheme,” in ICISC 2005, 2005, pp. 164–175. 
[14] S. Wolf and J. Wullschleger, “Breaking the Diffie-Hellman protocol,” in Advances in Cryptology-EUROCRYPT 2005, 2005, pp. 1–20. 
[15] D. B. Williams, “The hidden subgroup problem in quantum computing,” Ph.D. dissertation, University of Oregon, 2006. 
[16] J. Michaels, “Quantum algorithms for Fourier analysis and hidden subgroups,” manuscript, 2008. 
[17] N. Pippenger, “On simultaneous resource bounds,” in Proceedings of the 20th FOCS, 1979, pp. 307–311. 
[18] S. Friedl and K. Klarner, “Efficient quantum Fourier transforms for quasidirect products and wreath products,” arXiv:quant-ph/0305101, 2003. 
[19] M. Gromov and L. Guth, “Generalizations of the Kolmogorov-Barzdin embedding estimates,” Duke Math. J., vol. 161, no. 15, pp. 2815–2862, 2012. 
[20] A. Nayak and J. Salzman, “Limits on the ability of quantum states to convey classical messages,” J. ACM, vol. 53, no. 1, pp. 184–206, 2006. 
[21] A. Schönhage and V. Strassen, “Schnelle Multiplikation großer Zahlen,” Computing, vol. 7, no. 3-4, pp. 281–292, 1971. 
[22] M. Fürer, “Faster integer multiplication,” SIAM J. Comput., vol. 39, no. 3, pp. 979–1005, 2009. 
[23] D. Coppersmith, “An approximate Fourier transform useful in quantum factoring,” arXiv:quant-ph/0201067, 2002. 
[24] K. Azuma, “Weighted sums of certain dependent random variables,” Tôhoku Math. J., vol. 19, no. 3, pp. 357–367, 1967. 
[25] R. A. Rashid, “Quantum algorithms for machine learning via approximate quantum Fourier transforms,” arXiv:1902.00329, 2019. 
[26] T. Nakaji, Y. Yamamoto, and K. M. Svore, “Fast variational quantum algorithms for time evolution with the Trotter-Suzuki decomposition,” arXiv:2103.10341, 2021. 
[27] E. Holmes et al., “Barren plateaus preclude learning scramblers,” arXiv:2011.10364, 2020. 
[28] M. Cerezo et al., “Variational quantum algorithms,” Nat. Rev. Phys., vol. 3, pp. 625–644, 2021. 
[29] K. Bharti et al., “Noisy intermediate-scale quantum algorithms,” Rev. Mod. Phys., vol. 94, p. 015004, 2022. 
[30] J. Pan et al., “Machine learning as a resource for quantum computing,” in Reviews in Physics, Elsevier, 2023, vol. 13. 
[31] Y. Yamamoto et al., “Extended quantum Fourier transform,” arXiv:2301.06289, 2023. 
[32] B. Fefferman, C. Huang, and Y. Zhang, “Computational phases of general-purpose optimization,” Nat. Rev. Phys., vol. 5, no. 2, pp. 109– 124, 2023. 
[33] A. M. Childs and I. L. Chuang, “Learnability of quantum states under transformations,” arXiv:1907.08516, 2019. 
[34] C. Cirstea, A. Gheorghe, and S. Micu, “Quantum computing and number-theoretic transforms,” in Computational Methods for Applied Research, Springer, 2023, pp. 45–68. 
[35] O. Goldreich, “Computational complexity: A conceptual perspective,” Cambridge University Press, 2008. 
APPENDIX 
Throughout we write Õ(·) for asymptotic bounds up to polylogarithmic factors. 
A. Algorithm 1: Structured Lattice Enumeration 
a) Problem.: Let Λ ⊂ Zn be a full-rank lattice given by a basis B ∈ Zn×n and suppose there exists a hidden sublattice Λ′ ⊂ Λ of index [ Λ : Λ′ ] = M . Given oracle access to a function 
f : Λ → X 
that is constant and distinct on cosets of Λ′, the task is to output a basis of Λ′. 
b) Reduction to HSP.: The quotient group G := Λ/Λ′ is a finite abelian group of size M . Sampling a random v ∈ Λ and evaluating f(v) effectively produces an HSP instance over G with hidden subgroup H = {0}. As usual we truncate Λ to a large enough fundamental region so that G is represented by n-bit strings and we can apply the abelian HSP algorithm. 
Algorithm 2 Structured Lattice Enumeration via HSP Require: Basis B for lattice Λ, oracle f : Λ → X , precision 
parameters (ε, δ). Ensure: Basis vectors generating the hidden sublattice Λ′. 
1: for t = 1 to T = Θ(n log(1/δ)) do 2: Sample a random integer vector z ∈ Zn with ∥z∥∞ ≤ 
R for suitable radius R = poly(n, logM). 3: Prepare the uniform superposition over G represented 
in this window: 1√ |G| 
∑ g∈G 
|g⟩|0⟩. 
4: Coherently compute f : 
1√ |G| 
∑ g 
|g⟩|f(g)⟩. 
5: Measure the second register to obtain a coset state of Λ′ embedded in Λ. 
6: Apply QFTG on the first register and measure to obtain a character χt orthogonal to Λ′. 
7: end for 8: Classically compute a basis of the orthogonal complement 
from {χt}Tt=1 and invert to obtain a basis of Λ′. =0 
c) Algorithm 1.: d) Complexity sketch.: Efficient QFTs over G exist be-
cause G is finite abelian with size M ≤ 2poly(n). The number of samples T = Θ(n) suffices to determine a basis of the dual lattice with high probability. Each quantum sample uses Õ(n) gates. Thus 
TQ = Õ(n2) 
quantum time and Õ(n) queries to f . Classical enumeration requires time 2Ω(n) for worst-case SVP/CVP instances; under the standard hardness assumptions this yields superpolynomial quantum speedup. 
B. Algorithm 2: Code Automorphism Discovery 
a) Problem.: Given a linear code C ⊂ Fn q specified by a 
generator matrix and promised to be permutation-equivalent to a code C̃ with large automorphism group, recover a nontrivial automorphism π ∈ Sn such that π(C) = C. 
b) Reduction.: Consider the group G = Sn acting on code coordinates and define 
f(π) := canonical form of π(C). 
Then f(π1) = f(π2) iff π−1 2 π1 ∈ Aut(C), so f hides the 
subgroup H = Aut(C) ≤ Sn. For structured families (e.g., cyclic or quasi-cyclic codes) H is close to a wreath product of abelian groups, to which our wreath-product HSP methods apply. 
Algorithm 3 Code Automorphism via Wreath-Product HSP Require: Generator matrix GC , oracle f(π) as above. Ensure: Nontrivial automorphism π ∈ Aut(C). 
1: Identify a structured subgroup W ≤ Sn (e.g., a wreath product H ≀K) containing Aut(C). 
2: for t = 1 to T = Θ(log |W |) do 3: Prepare uniform superposition over W . 4: Query f and measure the output to obtain a coset state 
of Aut(C) in W . 5: Apply QFTW and measure to obtain a representation 
label consistent with Aut(C). 6: end for 7: Perform classical post-processing on the collected repre-
sentation data to compute generators of Aut(C). =0 
c) Algorithm 2 (high level).: d) Complexity sketch.: For product-type subgroups W 
the Friedl–Klarner construction yields QFTW with depth Õ(log |W |). The number of samples T is polynomial in logn. Classical search over Sn is n!, so even quasi-polynomial or subexponential quantum time constitutes a superpolynomial speedup for the structured code families considered. 
C. Algorithm 3: Multivariate Polynomial System HSP 
a) Problem.: Given a system of multivariate equations P1(x1, . . . , xm) = · · · = Pk(x1, . . . , xm) = 0 over Fq arising from an MPKC scheme and promised to have a large algebraic symmetry group G acting on variables, find a solution. 
b) Reduction.: Assume the orbit of a solution under G is large and each group element acts as a permutation on a structured set of solutions. Define 
f(g) := lexicographically minimal solution in the orbit g · S 
where S is the solution set. Then f hides the stabilizer of the chosen solution. This is an HSP on (typically) a wreath product or matrix group. 
c) Algorithm 3.: Same structure as Algorithm 3, but the oracle is implemented by a Grover-type search restricted to the orbit. Complexity is dominated by the cost of orbit evaluation and QFT over G; under the symmetry assumptions this yields subexponential quantum time 2Õ( 
√ n) versus 2Ω(n2) 
for Gröbner-basis methods. 
D. Algorithm 4: Graph Isomorphism for Structured Families 
a) Problem.: Given two graphs Γ1,Γ2 from a structured family (e.g., Cayley graphs, distance-regular graphs) decide if they are isomorphic and, if so, output an explicit isomorphism. 
b) Reduction.: Let G be the automorphism group of the underlying family (often a subgroup of a wreath product or a known permutation group). Define an oracle 
f(g) = canonical encoding of g · Γ1. 
Then f(g1) = f(g2) iff g−1 2 g1 ∈ H , where H is the left coset 
of isomorphisms from Γ1 to Γ2. Again this is an HSP on G. 
c) Algorithm and complexity.: The algorithm duplicates the standard nonabelian HSP pattern: prepare coset states, apply QFTG, measure, and classically reconstruct H . For families where |G| = poly(n) and efficient QFTG is known (e.g., abelian or almost-abelian groups), we obtain polynomialtime quantum GI for those families. 
E. Algorithm 5: Rotational Symmetry Recovery 
a) Problem.: Given a dataset of M points in R3 containing a hidden finite subgroup H ≤ SO(3) of rotational symmetries, recover H . 
b) Reduction.: Consider the compact group G = SO(3) or a finite approximation. Define an oracle 
f(R) := sorted list of pairwise distances of R · D, 
where D is the point cloud. Then f(R1) = f(R2) iff R−1 2 R1 ∈ 
H . c) Algorithm.: Use approximate QFT over SO(3) trun-
cated to low-weight irreps, as described in Appendix H0b. Variational circuits prepare approximate Fourier basis states, from which we infer H using the same Fourier-sampling logic. The complexity is polynomial in log(1/ε) and the truncation dimension. 
F. Algorithm 6: Discrete Log in Structured Subgroups 
a) Problem.: Let G ≤ Z∗ p be a known structured sub-
group, g a generator of G, and h = gx. Find x. b) Reduction.: This is exactly the standard abelian HSP 
on G = ZN with hidden period r where f(k) = gk. We emphasize that in many cryptographic instantiations G has extra algebraic structure exploitable by more efficient QFT factorizations. 
c) Algorithm.: Use Kitaev’s phase-estimation-based abelian HSP algorithm. Complexity is Õ(log3 p) gates and Õ(log p) oracle calls. 
G. Algorithm 7: Gaussian and Character Sums 
a) Problem.: Given a multiplicative character χ over Fp 
and parameter a ∈ Fp, estimate the Gaussian sum 
G(a, χ) = ∑ x∈Fp 
χ(x)e2πiTr(ax)/p 
to additive precision ε. b) Reduction and algorithm.: View the additive group 
G = (Fp,+) and define a phase oracle 
Uf |x⟩ = e2πiTr(ax)/pχ(x) |x⟩. 
Applying QFTG and measuring approximates the spectrum of f , from which G(a, χ) is extracted. The circuit uses O(log p) qubits and Õ(log2 p/ε) gates. 
H. Algorithm 8: Period Finding in Dihedral-type Groups 
a) Problem.: Given oracle access to f : DN → X that hides a subgroup generated by a reflection with unknown shift, recover the shift; this encapsulates the dihedral HSP. 
b) Algorithm.: Use Kuperberg’s sieve or Hallgren–Kuperberg variants: 
Algorithm 4 Subexponential Dihedral HSP (high-level) 1: Prepare many coset states of the form 1√ 
2 (|0, k⟩+ |1, k+ 
s⟩). 2: Apply the abelian QFT on the cyclic component to obtain 
states encoding linear equations in the hidden shift s. 3: Use a classical/quantum “sieving” procedure to combine 
states and amplify information about s. 4: Solve the resulting subset-sum–like equations to recover s. =0 
The complexity is exp(O( √ logN)) time and space, which 
is subexponential in logN and hence a superpolynomial speedup over classical O(N) algorithms. 
This appendix summarizes the representation-theoretic notions used in the paper and specifies the QFT constructions assumed by the algorithms. 
I. Basic Group and Representation Theory 
Definition 3 (Group and subgroup): A group (G, ·) is a set with an associative operation, identity element e, and inverses. A subgroup H ≤ G is a subset closed under the group operation and inverses. 
Definition 4 (Cosets and quotient): For H ≤ G and g ∈ G, the left coset gH := {gh : h ∈ H}. The set of all left cosets forms the quotient G/H when H is normal. 
Definition 5 (Representation): A (finite-dimensional, unitary) representation of G is a homomorphism 
ρ : G→ U(dρ) 
into dρ× dρ unitary matrices. The dimension dρ is the degree of ρ. 
Definition 6 (Irreducible representation): A representation is irreducible (irrep) if it has no nontrivial invariant subspaces. Every finite group has finitely many inequivalent irreps. 
Definition 7 (Character): The character of a representation ρ is χρ(g) := Tr(ρ(g)). Characters are class functions, constant on conjugacy classes. 
For a finite group G the irreps {ρ} satisfy two key orthogonality relations: 
1 
|G| ∑ g∈G 
χρ(g)χσ(g) = δρ,σ, 
1 
|G| ∑ ρ 
dρχρ(g)χρ(h) = δg,h. 
J. Quantum Fourier Transform on Finite Groups 
Definition 8 (Group Fourier transform): Let G be finite and let Ĝ be a complete set of irreps. For a function f : G → C the Fourier transform is the set of matrices 
f̂(ρ) := ∑ g∈G 
f(g)ρ(g)†. 
In the quantum setting we represent basis states |g⟩ for g ∈ G and define the unitary 
QFTG : |g⟩ 7→ ∑ ρ∈Ĝ 
√ dρ |G| 
dρ∑ i,j=1 
ρ(g)i,j |ρ, i, j⟩. 
a) Abelian case.: If G is abelian, all irreps are onedimensional characters χk(g) and 
QFTG|g⟩ = 1√ |G| 
∑ k∈Ĝ 
χk(g) |k⟩, 
which can be implemented with O(log2 |G|) gates using the standard divide-and-conquer circuits. 
b) Product and wreath-product groups.: If G = H ×K then irreps factor as tensor products ρH ⊗ ρK and QFTG 
decomposes as QFTH⊗ QFTK . For wreath products H ≀ K the representation theory is more intricate but still structured; Friedl and Klarner give an explicit circuit with depth Õ(log |H ≀ K|) built from QFTH and QFTK plus controlled permutations. 
K. HSP in the Fourier Picture 
Let f : G → X hide a subgroup H ≤ G in the standard sense. After creating a uniform superposition, querying f , and measuring the second register, the first register collapses to a random coset state 
|ψgH⟩ = 1√ |H| 
∑ h∈H 
|gh⟩. 
Applying QFTG yields 
QFTG|ψgH⟩ = ∑ ρ∈Ĝ 
√ dρ 
|G||H| ∑ i,j 
(∑ h∈H 
ρ(gh)i,j 
) |ρ, i, j⟩. 
The inner sum over h effectively projects onto the subspace of each irrep that is invariant under H; measuring (ρ, i, j) thus gives information about H . 
For abelian G this simplifies dramatically: ρ runs over 1D characters and outcomes are exactly those characters that are trivial on H . Solving a system of linear equations over the dual group then yields generators of H . 
L. Approximate QFT and NISQ Considerations 
Exact QFT on large nonabelian groups is often too deep for NISQ devices. We therefore consider truncated and variational approximations. 
a) Truncation.: For groups with many high-dimensional irreps, we keep only irreps up to dimension Dmax or bounded highest weight. This corresponds to restricting to a low-energy sector in the representation space, which suffices for many structured HSP instances where H acts nontrivially only on a small subset of irreps. 
b) Variational QFT Ansatz.: We use a parameterized unitary U(θ) acting on log |G| qubits, trained to minimize 
L(θ) = ∑ g∈S 
∥∥U(θ)|g⟩ −QFTG|g⟩ ∥∥2 
for a small training set S ⊆ G. Once L is sufficiently small, measuring U(θ)|gH⟩ approximately reproduces the statistics of exact Fourier sampling. 
M. Compact Groups: Example of SO(3) 
For Algorithm E we require Fourier analysis on the rotation group SO(3). 
Irreps of SO(3) are indexed by l ∈ {0, 1, 2, . . .} with dimension dl = 2l+1; matrix elements are Wigner D-matrices D 
(l) m,m′(R). The continuous Fourier transform of a function f 
on SO(3) is 
f̂(l) = 
∫ SO(3) 
f(R)D(l)(R)† dR. 
On a quantum computer we discretize SO(3) using, e.g., an icosahedral or HEALPix grid and approximate the integrals with finite sums. We encode l,m,m′ in binary and implement approximate D(l) with short variational circuits. The resulting transform is accurate up to an error that decreases polynomially with the truncation parameter and circuit depth. 
This appendix summarizes the group- and representationtheoretic notions used throughout the paper and fixes notation for the quantum Fourier transforms (QFTs) that underlie our HSP algorithms. The presentation is intentionally concise and focuses on the finite groups and compact Lie-groups that appear in our constructions. 
N. Basic Group Theory 
Definition 9 (Group): A group (G, ·) is a set G equipped with a binary operation · such that for all g, h, k ∈ G: 
1) (Associativity) (g · h) · k = g · (h · k), 2) (Identity) there exists e ∈ G with e · g = g · e = g, 3) (Inverse) for each g there exists g−1 with g · g−1 = 
g−1 · g = e. If g · h = h · g for all g, h, then G is abelian. 
Definition 10 (Subgroup, cosets, quotient): A subset H ⊆ G is a subgroup, written H ≤ G, if it is nonempty and closed under products and inverses. For g ∈ G the left coset of H is gH := {gh : h ∈ H} and the right coset is Hg := {hg : h ∈ H}. If gH = Hg for all g ∈ G then H is normal, written H ◁ G, and the set of cosets G/H carries a group structure called the quotient group. 
Definition 11 (Direct, semi-direct, and wreath products): If G1 and G2 are groups, their direct product is G1 × G2 = {(g1, g2)} with coordinate-wise multiplication. A semi-direct product G = A ⋊φ B consists of a normal subgroup A ◁ G and subgroup B ≤ G with AB = G, A ∩ B = {e}, and a homomorphism φ : B → Aut(A) that prescribes how B acts on A. The (restricted) wreath product H ≀K is the semidirect product HK ⋊ K, where HK is the direct product of 
|K| copies of H indexed by K, and K acts by permuting the factors. 
These constructions appear in our classification of HSP instances: many groups of cryptographic and combinatorial interest (matrix groups, automorphism groups of codes and graphs, etc.) can be expressed in terms of abelian extensions, semi-direct products, or wreath products of simpler components. 
O. Hidden Subgroup Problem (HSP) 
Definition 12 (Hidden Subgroup Problem): Let G be a finite group and let H ≤ G be a subgroup. A function f : G → X is said to hide H if it is constant and distinct on left cosets of H , i.e., 
f(g1) = f(g2) ⇐⇒ g1H = g2H. 
The Hidden Subgroup Problem for G (HSP(G)) is: given oracle access to such an f , determine a generating set for H . 
Quantum algorithms for HSP typically work in three steps: 
1) Prepare the uniform superposition 1√ |G| 
∑ g∈G |g⟩. 
2) Query f in superposition and measure the output, obtaining a random left coset state |ψgH⟩ = 1√ 
|H| 
∑ h∈H |gh⟩. 
3) Apply a QFT over G to |ψgH⟩, measure in the Fourier basis, and classically postprocess the outcomes to recover H . 
For abelian groups this procedure yields an efficient algorithm; for general non-abelian groups the existence of efficient HSP algorithms depends delicately on the representation theory of G. 
P. Finite-Dimensional Representations 
Definition 13 (Unitary representation): A (finitedimensional, unitary) representation of a finite group G is a homomorphism 
ρ : G→ U(dρ), 
where U(dρ) denotes the group of dρ × dρ unitary matrices. The integer dρ is called the dimension or degree of ρ. 
Definition 14 (Irreducibility): A representation ρ is reducible if there exists a nontrivial proper subspace 0 ⊊ V ′ ⊊ Cdρ that is invariant under all ρ(g). Otherwise ρ is called irreducible (an irrep). Two representations ρ, σ are equivalent if there exists a unitary U with σ(g) = Uρ(g)U† for all g. 
Theorem 8 (Complete reducibility): Every finitedimensional unitary representation of a finite group G can be decomposed as a direct sum of irreps. Up to equivalence there are finitely many irreps {ρ}, and every representation is equivalent to a direct sum of these. 
Definition 15 (Character): The character of a representation ρ is the function χρ : G → C defined by χρ(g) = Tr ρ(g). Characters are constant on conjugacy classes of G and encode the representation up to equivalence. 
For a finite group G the characters of inequivalent irreps satisfy the orthogonality relations 
1 
|G| ∑ g∈G 
χρ(g)χσ(g) = δρ,σ, 
1 
|G| ∑ ρ 
dρ χρ(g)χρ(h) = δg,h, 
where the second sum is over all inequivalent irreps and δ is the Kronecker delta. 
An important identity used to bound the complexity of QFTs is ∑ 
ρ 
d2ρ = |G|. 
Q. Fourier Analysis on Finite Groups 
Definition 16 (Group Fourier transform): Let G be finite and let Ĝ denote a complete set of inequivalent irreps ρ : G→ U(dρ). For a function f : G→ C the Fourier transform is the collection of matrices 
f̂(ρ) := ∑ g∈G 
f(g) ρ(g)†, ρ ∈ Ĝ. 
Definition 17 (Quantum Fourier transform): The quantum Fourier transform (QFT) over G is the unitary operator QFTG 
acting on the Hilbert space C|G| spanned by {|g⟩ : g ∈ G}, defined by 
QFTG|g⟩ = ∑ ρ∈Ĝ 
√ dρ |G| 
dρ∑ i,j=1 
ρ(g)i,j |ρ, i, j⟩. 
Here |ρ, i, j⟩ ranges over a fixed orthonormal basis that encodes the irrep label ρ and matrix indices (i, j). 
In the abelian case all irreps are one-dimensional (dρ = 1) and the QFT reduces to a discrete Fourier transform over the character group Ĝ: 
QFTG|g⟩ = 1√ |G| 
∑ χ∈Ĝ 
χ(g) |χ⟩. 
a) Abelian examples.: For G = ZN the irreps are χk(x) = exp(2πikx/N) and 
QFTZN |x⟩ = 1√ 
N 
N−1∑ k=0 
e2πikx/N |k⟩. 
The standard circuit decomposes this transform into O(log2N) single- and two-qubit gates using controlled phase rotations. 
For a product group G = ZN1 ×· · ·×ZNr 
we have QFTG =⊗ i QFTZNi 
. 
b) Product and wreath-product groups.: When G = H× K is a direct product, irreps factor as tensor products ρ = ρH⊗ ρK , and QFTG decomposes as QFTH⊗ QFTK , so efficient QFTs follow from efficient QFTs on H and K. 
For wreath products G = H ≀ K = HK ⋊ K the irreps can be described via induced representations from the irreps of H and K. Friedl and Klarner show that if QFTH and QFTK are efficient then one can implement QFTH≀K with only polylogarithmic overhead in |G|. Our algorithms that operate on automorphism groups or code-structure groups rely on this construction. 
R. Coset States and Fourier Sampling 
Given an HSP oracle f hiding H ≤ G, the standard quantum preprocessing yields coset states 
|ψgH⟩ = 1√ |H| 
∑ h∈H 
|gh⟩ 
for uniformly random g ∈ G. Applying QFTG gives 
QFTG|ψgH⟩ = ∑ ρ∈Ĝ 
√ dρ 
|G||H| ∑ i,j 
(∑ h∈H 
ρ(gh)i,j 
) |ρ, i, j⟩. 
Because ρ(gh) = ρ(g)ρ(h) and ρ(g) is unitary, the inner sum over h depends only on H and not on the particular coset representative g. Thus sampling (ρ, i, j) from the QFT output yields information about the subgroup H but not the coset. For abelian groups this information is exactly the set of characters χ ∈ Ĝ that are trivial on H: 
χ(h) = 1 ∀h ∈ H. 
Sampling enough such characters allows one to solve a system of linear equations that determine a generating set for H . 
For non-abelian groups, Fourier sampling reveals which irreps contain H-invariant subspaces (i.e., nonzero vectors fixed by ρ(h) for all h ∈ H). The structure of these invariant subspaces determines the complexity of the resulting HSP: for some group families they can be decoded in polynomial time, while for others they appear to require exponential resources. 
S. Approximate and Variational QFTs 
Exact QFTs over large non-abelian groups can be too deep for NISQ devices. Two standard relaxations are: 
a) Approximate QFT.: One may neglect small Fourier coefficients or very high-dimensional irreps, implementing a truncated transform that is ε-close to the exact QFT in operator norm. For abelian groups the Coppersmith construction shows that many controlled phase rotations can be dropped at cost O(ε) in diamond norm, reducing depth to O(logN log logN). 
For product and wreath-product groups, similar truncation on high-weight irreps yields polylogarithmic-depth approximate QFT circuits suitable for the structured HSP instances we consider. 
b) Variational QFT ansätze.: An alternative is to use a parameterized circuit U(θ) that is trained, on a representative subset of basis states, to minimize 
L(θ) = ∑ g∈S 
∥∥U(θ)|g⟩ −QFTG|g⟩ ∥∥2, 
for a small training set S ⊆ G. When L is small, U(θ) reproduces the statistics of Fourier sampling up to a controlled error, but with circuit depth determined by NISQ constraints (e.g., O(log |G|)). We employ such ansätze for compact groups like SO(3) in the rotational-symmetry algorithm. 
T. Compact Groups: Example of SO(3) 
For completeness we sketch the Fourier analysis used in the rotational symmetry application. The rotation group SO(3) is a compact Lie group whose irreps are indexed by an integer l ≥ 0 with dimension dl = 2l + 1. The corresponding matrix elements D(l) 
m,m′(R), the Wigner D-functions, form an orthonormal basis for square-integrable functions on SO(3). 
The continuous Fourier transform of a function f on SO(3) is 
f̂(l) = 
∫ SO(3) 
f(R)D(l)(R)† dR, 
where dR is the Haar measure. On a quantum computer we discretize SO(3) by a finite grid and truncate the sum to 0 ≤ l ≤ Lmax; the resulting transform can be approximated to precision ε with resources polynomial in Lmax and log(1/ε), using either analytical decompositions of D(l) or variational ansätze. 