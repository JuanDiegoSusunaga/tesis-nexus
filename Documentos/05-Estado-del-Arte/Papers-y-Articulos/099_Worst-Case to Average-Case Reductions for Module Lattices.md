# Worst-Case to Average-Case Reductions for Module Lattices

- **ID**: `76503c9b-74a6-4ae2-ac28-be241c7666d8`
- **Tipo de Fuente**: `SOURCE_TYPE_PDF`
- **URL**: [https://perso.ens-lyon.fr/damien.stehle/downloads/MSIS.pdf](https://perso.ens-lyon.fr/damien.stehle/downloads/MSIS.pdf)

---

## Contenido Extraído / Texto Completo

Worst-Case to Average-Case Reductions for Module Lattices 
Adeline Langlois and Damien Stehlé 
Laboratoire LIP (U. Lyon, CNRS, ENS Lyon, INRIA, UCBL), 46 Allée d’Italie, 69364 Lyon Cedex 07, France 
Abstract. Most lattice-based cryptographic schemes are built upon the assumed hardness of the Short Integer Solution (SIS) and Learning With Errors (LWE) problems. Their efficiencies can be drastically improved by switching the hardness assumptions to the more compact Ring-SIS and Ring-LWE problems. However, this change of hardness assumptions comes along with a possible security weakening: SIS and LWE are known to be at least as hard as standard (worst-case) problems on euclidean lattices, whereas Ring-SIS and Ring-LWE are only known to be as hard as their restrictions to special classes of ideal lattices, corresponding to ideals of some polynomial rings. In this work, we define the Module-SIS and Module-LWE problems, which bridge SIS with Ring-SIS, and LWE with Ring-LWE, respectively. We prove that these average-case problems are at least as hard as standard lattice problems restricted to module lattices (which themselves bridge arbitrary and ideal lattices). As these new problems enlarge the toolbox of the lattice-based cryptographer, they could prove useful for designing new schemes. Importantly, the worst-case to average-case reductions for the module problems are (qualitatively) sharp, in the sense that there exist converse reductions. This property is not known to hold in the context of Ring-SIS/Ring-LWE: Ideal lattice problems could reveal easy without impacting the hardness of Ring-SIS/Ring-LWE. 
1 Introduction 
A euclidean lattice is the set of all integer linear combinations of some n linearly independent vectors belonging to a euclidean space. There are many algorithmic problems related to lattices. In this work, we will consider the Shortest Independent Vectors problems (SIVP): The goal is to find n linearly independent vectors s1, . . . , sn in a given n-dimensional lattice, that minimize maxi ‖si‖. (The dimension of a lattice is the dimension of the vector space spanned by its vectors.) A standard relaxation of this optimization problem, parametrized by γ(n) ≥ 1, consists in requesting that maxi ‖si‖ is within a factor γ of the optimal value. This variant is referred to as SIVPγ and γ is called the approximation factor. SIVPγ is known to be NP-hard for any approximation factor γ ≤ O(1) (see [4]). A standard and well accepted conjecture is to assume that there is no polynomial time algorithm that achieves an approximation factor that is polynomial in n, even using quantum computing [25]. 
Lattice-based cryptography is a branch of cryptography exploiting the presumed hardness of lattice problems such as SIVPγ . Its main advantages are its simplicity, efficiency, and apparent security against quantum computers. But perhaps the most appealing aspect is that lattice-based cryptographic protocols often enjoy very strong security proofs based on the hardness of worst-case problems. Typically, an average-case problem (solvers of which correspond to a protocol attacker) is shown to be at least as hard as the arbitrary instances of another problem (the worst-case problem) which is presumed difficult. Note here that a worst-case problem needs every instance to be solved (e.g., with non-negligible probability), as an average-case problem only requires some instances (a non-negligible proportion) to be solved. We refer to [25] for a recent survey on lattice-based cryptography. 
Two main problems serve as the foundation of numerous lattice-based cryptographic protocols. The first one, introduced by Ajtai in 1996 [1], is the Short Integer Solution problem (SIS): For parameters n, m and q positive integers, the problem is to find a short nonzero solution z ∈ Zm to the homogeneous linear system Az = 0 mod q for uniformly random A ∈ Zn×mq (the notation Zq denotes the ring of integers modulo q). The second one, introduced by Regev in 2005 [35], is the Learning With Errors problem (LWE). The search version of LWE is as follows: For parameters n and q positive integers and χ a probability density function
on T = R/Z ' [0, 1), the problem is to find s, given arbitrarily many independent pairs (a, 1 q 〈a, s〉 + e) 
for a vector a ∈ Znq chosen uniformly at random, and e ∈ T sampled from χ. It is possible to interpret LWE in terms of linear algebra: If m independent samples (ai, 1 
q 〈ai, s〉 + ei) are considered, the goal is to find s from (A, 1 
qAs + e), where the rows of A correspond to the ai’s and e = (e1, . . . , em)T . The decision counterpart of LWE consists in distinguishing between arbitrarily many independent pairs (a, 1 
q 〈a, s〉 + e) sampled as in the search version and the same number of uniformly random and independent pairs. 
Ajtai [1] proposed the first worst-case to average-case reduction for a lattice problem, by providing a reduction from SIVPγ to SIS. Later, Regev [35,36] showed the hardness of the LWE problem by describing a (quantum) reduction from SIVPγ to LWE. Cryptographic protocols relying on SIS or LWE therefore enjoy the property of being provably as secure as a worst-case problem which is strongly suspected of being extremely hard. However, on the other hand, the cryptographic applications of SIS and LWE are inherently inefficient due to the size of the associated key (or public data), which typically consists of the matrix A. 
To circumvent this inherent inefficiency, Micciancio [18,20] — inspired from the efficient NTRU encryption scheme [13] that can itself be interpreted in terms of lattices — initiated an approach that consists in changing the SIS and LWE problems to variants involving structured matrices. In these variants, the random matrix A is replaced by one with a specific block-Toeplitz structure, thus allowing for more compact keys and more efficient algorithms. The problem considered by Micciancio in [20] was later replaced by a more powerful variant [15,31], now commonly referred to as Short Integer Solution problem over Rings, or R-SIS (it was initially called Ideal-SIS). A similar adaptation for LWE, called R-LWE, was introduced by Lyubashevsky et al. [16] (see also [39]). Similarly to SIS and LWE, these problems admit reductions from worst-case lattice problems [15,31,16], but, however, the corresponding worst-case problem is now SIVPγ restricted to ideal lattices (which correspond to ideals of the ring of integers of a number field corresponding to the specific matrix structure). The latter problem is called Id-SIVPγ . 
Main results. In this paper, we bridge the reductions from SIVP to SIS and Id-SIVP to R-SIS on the first hand, and from SIVP to LWE and Id-SIVP to R-LWE on the second hand. We consider two problems M-SIS and M-LWE, where the letter M stands for module. A module is an algebraic structure generalizing rings and vector spaces, whereas module lattices (corresponding to finitely generated modules over the ring of integers of a number field) generalize both arbitrary lattices and ideal lattices. Note that M-LWE has recently been introduced (although not studied) in [7], where it is called Generalized-LWE. We describe two new worst-case to average-case reductions: A reduction from Mod-SIVP (i.e., SIVP restricted to module lattices) to M-SIS in the proof of Theorem 3.6, and a (quantum) reduction from Mod-SIVP to M-LWE in both its search and decision versions in the proofs of Theorems 4.7 and 4.8. 
The Mod-SIVP to M-SIS and Mod-SIVP to M-LWE reductions are smooth generalizations of the existing reductions: By setting the module dimension and the field degree appropriately, we recover the former reductions. When doing so, the conditions on the approximation factor γ and the modulus q required for the results to hold match with the conditions of the existing reductions, up to a factor that is logarithmic in the lattice dimension. These parameters quantify the quality of the reductions: The hardness of the SIVP problem is given by the approximation factor γ, whereas the bit-size of the average-case instances is proportional to log q. 
To achieve these results, we carefully combine and adapt the existing reductions and their proofs of correctness ([11] and [15] for M-SIS, and [36] and [16] for M-LWE). At a high level, the module structure can be seen as a “tensor” between the lattice and ideal algebraic structures, leading to reductions and proof that can heuristically be seen as “tensors” of the former reductions and proofs. 
On the way, we improve the state-of-the-art results on the hardness of R-SIS and R-LWE. Concerning R-SIS: We improve the reduction from Id-SIVPγ by allowing for smaller values of q; this improvement is obtained by adapting a technique based on the Chinese Remainder Theorem and developed by Lyubashesvky et al. in [16] in the context of R-LWE; its application to R-SIS was suggested in [16] but left open. Concerning R-LWE: We show that R-LWE is hard for all sufficiently large q, independently of the arithmetic properties of q with respect to the ring dimension n; this improvement is obtained by adapting the modulus-switching technique developed by Brakerski et al. in [8] in the context of LWE. 
2
A larger toolbox for cryptographic design. The hardness results for M-SIS and M-LWE possibly enlarge the toolbox for devising lattice-based cryptosystems. Let us consider small examples. The following is an instance of M-SIS for which we can prove hardness for specific values of the parameters n, q and β. Given ai,j ’s sampled uniformly and independently from the uniform distribution over Zq[x]/(xn+1), the goal is to find zi’s in Z[x]/(xn + 1) not all zero, with coefficients smaller than a prescribed bound β and such that: 
[ a11 a12 a13 a21 a22 a23 
] · 
 z1 z2 z3 
 = 0 mod q. 
Similarly, our results on M-LWE imply that for specific values of n, q and for a specific error distribution ψ taking small values in Z[x]/(xn+1) (or, actually, a specific distribution over such distributions), the following pair is computationally indistinguishable from uniform over its range:a11 a12 
a21 a22 a31 a32 
 , a11 a12 a21 a22 a31 a32 
 · [s1 s2 
] + 
 e1 e2 e3 
 mod q 
 , 
where the aij ’s and si’s are sampled uniformly in Zq[x]/(xn + 1), and the ei’s are sampled from ψ. Note that the existing results on R-LWE and R-SIS already imply that these problems are no easier than 
some SIVP instances: For example, one can embed an R-SIS instance into the first row of an M-SIS instance, and generate the other row(s) independently. However, with this approach, the hardness of the corresponding worst-case instances is related to n-dimensional instances of SIVP. With our new approach, we can show that the M-SIS instance above is no easier than solving SIVP for a (2n)-dimensional lattice (or, more generally, a (dn)-dimensional lattice, if the number of rows of the M-SIS matrix is d). If SIVP is exponentially hard to solve (with respect to the lattice dimension), the module approach provides a complexity lower bound for solving this simple M-SIS instance that is the square (resp. dth power) of the lower bound provided by relying on R-SIS. This assertion relies on the reasonable conjecture that the module structure is harder to exploit in SIVP solvers than the ideal structure (because an ideal lattice can be embedded in a module lattice of any dimension). 
From the cryptographic construction viewpoint, we expect that most constructions based on R-SIS and R-LWE can be adapted to M-SIS and M-LWE, with an efficiency slowdown (in terms of memory requirements, communication costs and algorithm run-times) bounded by a constant factor when d = O(1). 
Hedging against a possible non-hardness of Id-SIVP. Our results lead to cryptographic primitives whose efficiencies are within a constant factor of those based on R-SIS/R-LWE, but for which the security relies on Mod-SIVP instead of Id-SIVP. We argue here that Mod-SIVP is possibly a harder problem than Id-SIVP. 
First, the SIVP to SIS and SIVP to LWE reductions are qualitatively sharp in the sense that they allow for converse reductions: Both LWE and SIS can be solved using an SIVP solver. Such a result is not known to hold for Id-SIVP and R-SIS/R-LWE, hinting that Id-SIVP is possibly easier to solve than R-SIS/R-LWE. We show (in Section 5) that the Mod-SIVP to M-SIS/M-LWE reductions admit converse reductions. Further, M-LWE and M-SIS are obviously no easier than R-LWE and R-SIS. Similarly, Mod-SIVP can trivially be shown to be no easier than Id-SIVP (as any Id-SIVP instance can be embedded into a Mod-SIVP instance of higher dimension). As a result, the existing reductions hint that Mod-SIVP, M-LWE and M-SIS are possibly harder than R-LWE and R-SIS, which are themselves possibly harder than Id-SIVP. 
Second, Id-SIVP has been much less studied than SIVP, and attacks on SIVP working only in the case of ideal lattices cannot be fully ruled out. Such attacks could, for example, exploit the multiplicative structure of the ideals, and fail to hold as soon as the rank d of the module is greater than 1 (i.e., a phase transition between d = 1 and d > 1). Such weaknesses due to the multiplicative structure actually exist for some lattice problems. Consider for example the task of estimating, within a factor γ, the euclidean norm of the shortest nonzero vector in the lattice (known as GapSVPγ). This problem is suspected to be extremely hard in the worst case for values of γ that are polynomial in the lattice dimension. But it is easy for ideal lattices, as Minkowski’s bound on the lattice minimum is known to be essentially sharp in that case (see, e.g., [32, Se. 6]). 
3
Further, we suspect that this problem is hard in the worst case for module lattices with module rank greater than 1, as it would allow one to efficiently solve R-LWE. We briefly describe that reduction. With the same notations as above, R-LWE with two sample pairs consists in deciding whether a1, b1, a2, b2 are uniformly and independently sampled in Zq[x]/(xn + 1) × Zq[x]/(xn + 1), or whether there exists s ∈ Zq[x]/(xn + 1) such that both b1 − a1 · s and b2 − a2s have small coefficients. In the first case, the shortest nonzero vectors of the module lattice (a1, a2) ·Zq[x]/(xn+ 1) + (b1, b2) ·Zq[x]/(xn+ 1) + (qZ[x]/(xn+ 1))2 are expected to be of norms that are close to Minkowski’s bound (i.e., around 
√ nq1/2, up to a constant factor). In the second 
case, there is an unexpectedly short nonzero vector in it. We note that no such phase transition is known for Id-SIVP, but it cannot be ruled out given our current knowledge. 
Related works. Most SIVP to SIS reductions (including ours) consider the euclidean norm. Peikert [28] described an SIVP to SIS reduction that handles all `p norms. Independently, many variants of LWE have been shown as hard as Regev’s original LWE: These variants may consist in sampling the secret vector s from the same distribution as the errors [3], in sampling the error vectors from other distributions [29,12] and in relaxing the conditions on the factorisation of the modulus [22, Se. 3] (see also the references therein). Other cryptographically useful variants of SIS and LWE proven as secure as SIVP include k-SIS [5], ISIS [11], subspace-LWE [14,33] and extended-LWE [27,2,8]. 
In [29,8], Peikert and Brakerski et al. partially dequantized Regev’s proof of hardness of LWE [36], by proposing a reduction from the decisional GapSVPγ problem to LWE. Peikert’s classical reduction is restricted to large LWE moduli q (that are additionally required to be products of many small primes in the case of the decisional variant of LWE), unless one considers a variant of GapSVP that is somewhat unusual. Peikert’s dequantization carries over to the module case, by giving a reduction from GapSVP restricted to module lattices to M-LWE (using Lemma 4.14 from Section 4). Note that it also carries over to ideal/R-LWE setting but is meaningless in this situation as GapSVP is easy for ideal lattices and the involved approximation factors γ (as a good approximation to the minimum known). The reduction of Brakerski et al. consists of several steps, the first one being Peikert’s reduction. It is thus equally useless in the case of ideal lattices. 
Some computational aspects of module lattices have been investigated in [6,10] (see also [9, Ch. 1]). These results show that the additional algebraic structure may be exploited to obtain compact representations of modules (namely, pseudo-bases) similar to lattice bases in Hermite Normal Form and LLL-reduced lattice bases. None hints that SIVP would be any easier when restricted to module lattices. 
Peikert and Rosen [32] observed that solving R-SIS exactly consists in finding a short nonzero vector in a module lattice. 
Open problems. The assumption that standard lattice problems remain hard for ideal lattices is extensively used in modern cryptographic constructions, via the R-SIS and R-LWE problems. However, ideal lattices are very structured objects, and the existence of algorithms exploiting their specific properties should not be discarded too quickly. The fact that GapSVP is easy for these lattices should be seen as a warning of potential risk. The hardness of lattice problems restricted on ideal lattices remains to be assessed. Another approach would be to base the hardness of R-SIS and R-LWE on the worst-case hardness of standard lattice problems for more general classes of lattices. Note that a result in that direction is obtained in [8], but only in the case of an exponential modulus q, which is of limited practical interest. 
No weakness is currently known for module lattices of module rank greater than 1. Designing algorithms that exploit this structure is a very exciting research problem, as it may also impact the hardness of R-SIS and R-LWE, as explained above. 
Finally, it could be of interest to adapt the main result of [8] to the M-LWE/R-LWE setting. Brakerski et al. present a self-reduction for LWE that trades modulus bitsize for dimension: LWE with modulus q and dimension n is (essentially) as hard as LWE with modulus ≈ qk and dimension n/k. 
Road-map. We first give reminders on euclidean lattices, elementary algebraic number theory and Gaussian measures. In Section 3 we give a reduction from Mod-SIVP to M-SIS. Then, in Section 4, we describe 
4
a (quantum) reduction from Mod-SIVP to both the computational and the decisional variants of M-LWE. Finally, we give converse reductions in Section 5, i.e., reductions from both M-SIS and M-LWE to Mod-SIVP. 
2 Preliminaries 
Notation. Vectors will be denoted in bold, and if x is a vector, then its ith coordinate will be denoted by xi and its euclidean norm will be denoted by ‖x‖. For a tuple of vectors X = (xi)i, we let ‖X‖ = maxi ‖xi‖. The vector ei denotes the vector with 1 in its ith coordinate and 0 in all its other coordinates. Let B ∈ Rn be a basis. We let B̃ be the Gram-Schmidt orthogonalisation of B. 
We use standard Landau notations. Furthermore, we say that a function f(n) is poly(n) if it is bounded by a polynomial in n. The notation ω(f(n)) refers to the set of functions (or an arbitrary function in that set) growing faster than c ·f(n) for any constant c > 0. A function ε(n) is said negligible if it decreases faster than the inverse of any polynomial function, i.e., if it is n−ω(1). Finally, a function is exponentially small in n if it is 2−Ω(n). 
The statistical distance between two distributions X and Y on a countable set D is defined as follows: ∆(X,Y ) = 1 
2 ∑ d∈D |X(d) − Y (d)|. We say that two sequences (Xn)n, (Yn)n of distributions indexed by 
a variable n are negligibly close if ∆(Xn, Yn) is negligible in n. Finally, we let U(S) denote the uniform distribution over any finite measure set S. 
Remark on the reductions. The worst-case lattice problem SIVPγ is suspected to be exponentially hard to solve with respect to the lattice dimension n for any function γ(n) ∈ poly(n). This gap between the costs of the algorithms involved in the cryptographic primitives and the cost of the best known attacks is a very attractive feature. For this reason, it is interesting to consider two regimes when analyzing worst-case to average-case reductions from SIVP: In the first regime, we assume we are given a polynomial time algorithm for solving the considered average-case problem with non-negligible probability; In the second (somewhat less standard) regime, we assume we are given a subexponential-time algorithm for solving the considered average-case problem with non-exponentially small probability. The precise parameters of the problems at both ends of the reductions sometimes have to be set differently, so that the reductions essentially preserve the success probabilities and distinguishing advantages. We concentrate here on the first regime, but give the parameter adjustments for the main results to hold in the second setting. 
Polynomial representation versus canonical embedding. We propose a unified analysis of R-SIS/M-SIS and R-LWE/M-LWE by only considering the complex canonical embeddings of the ring elements. Note that all prior works on R-SIS except [32] used the polynomial embedding. However, the canonical embedding representation is mathematically sounder, and the unification leads to a more natural connection between R-SIS and R-LWE. 
2.1 Some algebraic number theory 
In the following, we recall a few facts on elementary algebraic theory in this special case. We refer the reader to [26] and [16,17] for thorough introductions to the topics covered in this subsection. 
Number field and cyclotomic field. Every complex root of a polynomial g(X) ∈ Q[X] is an algebraic number. The minimal polynomial of an algebraic number ξ is the unique irreducible monic polynomial f of minimal degree such that ξ is one of its roots. An algebraic integer is an algebraic number whose minimal polynomial belongs to Z[X]. Let ξ be an algebraic number, the number field K = Q(ξ) is a finite extension of the rational number field Q. It is also an n-dimensional vector space over Q with basis {1, ξ, . . . , ξn−1}, where n is the degree of f . We call n the degree ofK. Let R be the set of the algebraic integers belonging toK. This is a ring, called the ring of integers (or maximal order) of K. If ξ is an algebraic integer, then Z[ξ] = 
∑n j=1 Z · ξj ⊆ R. 
In general, this inclusion can be strict. 
5
A cyclotomic field is a field K = Q(ξ) where ξ is a root of unity. If ξ is a primitive ν-th root of unity, then it is a root of the ν-th cyclotomic polynomial Φν . The degree n = φ(ν) of Φν is the degree of K (here φ(·) denotes Euler’s totient function). In the case of cyclotomic fields, we have R = Z[ξ]. 
In this work, all number fields will be cyclotomic fields. 
Complex embeddings. The canonical embeddings are the n ring homomorphisms σj : K → C that fix every element of Q. In our particular case of cyclotomic fields, all n embeddings are complex: They are defined by σj : ξ 7→ ξj for any j ∈ Z×ν . Note that if j is invertible modulo ν, then so is ν − j, and σν−j = σj . For notational simplicity, we let J denote [ν/2] ∩ Z×ν . We call canonical embedding vector the ring homomorphism σC : K → Cn defined as: σC(y) = (σj(y))j∈Z×ν , where addition and multiplication in Cn are component-wise. Indeed, for any x, y ∈ K, we have that σC(x · y) is the component wise product of σC(x) and σC(y). By elementary linear algebra, we observe that an element of K is fully specified by its canonical embedding vector. 
The trace Tr : K → Q and the (algebraic) norm N : K → Q are defined as follows: Tr(x) = ∑ j∈Z×ν σj(x) 
and N(x) = ∏ j∈Z×ν σj(x). For any x, y ∈ K we have Tr(x · y) = 
∑ j∈Z×ν σj(x) · σj(y) = 〈σC(x), σC(y)〉 where 
〈·, ·〉 is the canonical Hermitian product on Cn. 
Space H. We use the following subspace of Cn, as in [16]: 
H = {(xj)j∈Z×ν ∈ Cn : ∀j ∈ J, xν−j = xj}. 
Let hj = 1√ 2 (ej + eν−j) and hν−j = i√ 
2 (ej − eν−j) for j ∈ J. The hj ’s form a basis of H as a real vector space. An element x ∈ K can be represented according to the basis (hj)j : For x ∈ K, we define σH(x) by σH(x) = (xj)j ∈ Rn such that σC(x) = 
∑ j xj · hj . As σC(x) = (σj(x))j , we have, for j ∈ J:[ 
xj xν−j 
] = 1 
2 
[ 1 1 −i i 
] [ σj(x) σν−j(x) 
] and 
[ σj(x) σν−j(x) 
] = [ 1 i 1 −i 
] [ xj xν−j 
] . 
The addition in H is component wise. Let σH(x) = (xj)j and σH(y) = (yj)j , we define the multiplication by σH(x · y) = (zj)j where, for j ∈ J:[ 
zj zν−j 
] = [ xj −xν−j xν−j xj 
] [ yj yν−j 
] or [ zj zν−j 
] = [ yj −yν−j yν−j yj 
] [ xj xν−j 
] . 
To ease the presentation, we identify elements of K with their σH embeddings. 
Ideals. An (integral) ideal I of R is an additive subgroup of R that is closed under multiplication by every element of R. The smallest ideal of R containing the set S is denoted by (S). The quotient R/I is the set of the equivalence classes g + I of R modulo I. For any nonzero ideal, the norm N (I) of the ideal is the number of elements of the quotient ring R/I. We have N ((x)) = N (x), for all x ∈ K. 
Let I and J be ideals of R. We define the product of two ideals by IJ = { ∑ i αiβi : αi ∈ I, βi ∈ J} and 
their sum by I + J = {α + β : α ∈ I, β ∈ J}. An ideal I ( R is prime if for any ab ∈ I then a ∈ I or b ∈ I. Every ideal of R can be represented as a unique product of prime ideals, and for a prime ideal I, the quotient ring R/I is the finite field of order N (I). A fractional ideal I ⊆ K is a set such that dI ⊆ R is an (integral) ideal for a nonzero d ∈ R. The inverse of a fractional I is defined by I−1 = {α ∈ K : αI ⊆ R} and is itself a fractional ideal. We have II−1 = R. The dual of an ideal is defined as I∨ = {x ∈ K : Tr(xI) ⊆ Z}. We have I∨ = I−1 ·R∨. 
In our setup of cyclotomic fields, if q is a prime integer, the prime ideal factorization of (q) ⊆ R can be computed efficiently. In particular, if q = 1 mod ν, then (q) = 
∏ j∈Z×ν qj where each qj if a prime ideal with 
norm N (qj) = q. The field K has n automorphisms τj : K → K defined by τj(ξ) = ξj (for j ∈ Z×ν ). As noted in [16, Le. 2.16], the automorphism group of the {τj} acts transitively on the set {qj}j . 
6
An isomorphism of quotient rings. Lyubashevsky et al. [16, Se. 2.3.9] used the Chinese Remainder Theorem to make explicit an isomorphism between I/qI and R/qR for an arbitrary positive integer q, which we recall now. Let Rq and R∨q respectively denote R/qR and R∨/qR∨. 
Let t ∈ I be such that (t) + qI = I (such a t exists and can be found efficiently given I and the prime ideal factorization of (q), see [16, Le. 2.14]). The function θI : K → K defined as θI(x) = t · x induces an isomorphism from Rq to I/qI. Moreover, this isomorphism may be efficiently inverted using θ−1 I : I/qI → Rq defined by θ−1 
I (y) = t−1 · y′ mod qR where y′ = y mod qI and y′ ∈ (t). The function θI also induces an isomorphism from I∨/qI∨ to R∨q that may be efficiently inverted using θ−1 
I : R∨q → I∨/qI∨ 
with θ−1 I (y) = t−1 · y′ mod qR where y′ = y mod qI∨ and y′ ∈ (t). 
Modules. A subsetM ⊆ Kd is an R-module if it is closed under addition and multiplication by elements of R. It is a finitely generated module if there exists a finite family (bk)k of vectors in Kd such thatM = 
∑ k R ·bk. 
In general, if the ring R is arbitrary, an R-module may not have a basis. But here K is a number field, so R is a Dedekind domain, and we have the existence of so-called pseudo-bases (see, e.g., [9, Ch. 1]): For every module M , there exist Ik nonzero ideals of R and (bk)k linearly independent vectors of Kd such that M = 
∑d k=1 Ik · bk. We say that [(Ik)k, (bk)k] is a pseudo-basis of M . The terminology pseudo-basis is used 
as the coefficient ideals Ik can be non-principal. The representation of the elements of M with respect to a pseudo-basis is unique. Two pseudo-bases can generate the same module and then, they have the same cardinality. The latter is called rank of the module. 
We define the dual of a module byM∨ = {x ∈ Kd,∀y ∈M : Tr(〈x,y〉) ∈ Z}, where 〈·, ·〉 is the Hermitian product on Kd. We have the following property: 
Lemma 2.1. If M = ∑d k=1 Ik · bk, then M∨ = 
∑d k=1 I 
∨ k · b∨k , where the b∨` ’s are defined by 〈bk, b∨` 〉 = 1 if 
k = ` and 〈bk, b∨` 〉 = 0 otherwise. 
Proof. We first show that ∑d k=1 I 
∨ k ·b∨k ⊆M∨. Let x ∈ 
∑d k=1 I 
∨ k ·b∨k . Then for each i there exists xk ∈ I∨k such 
that x = ∑d k=1 xk ·b∨k . Let y = 
∑d k=1 yk ·bk ∈M . Then by linearity, we have Tr(〈x,y〉) = 
∑d k=1 Tr(xkyk). For 
all i, we have xk ∈ I∨k and yk ∈ Ik, and thus Tr(xkyk) ∈ Z. Therefore, we have Tr(〈x,y〉) ∈ Z and x ∈M∨. We now show thatM∨ ⊆ 
∑d k=1 I 
∨ k ·b∨k . Let x ∈M∨ ⊆ Kd. We can write x = 
∑d k=1 xk ·b∨k , for some xk’s 
in K. It suffices to show that xk ∈ I∨k . Let yk ∈ Ik be arbitrary. By linearity, we have Tr(〈x, ykbk〉) = Tr(xkyk) ∈ Z. This implies that xk ∈ I∨k . ut 
We generalize the isomorphism θI defined above to modules. Let M = ∑d k=1 Ik · bk, f : I1/qI1 × . . . × 
Id/qId → M/qM be such that f(x1, . . . , xn) = ∑d k=1 xk · bk and g : M/qM → I1/qI1 × . . . × Id/qId be 
such that g( ∑d k=1 xk · bk) = (x1, . . . , xn). The functions f and g are ring isomorphisms and g = f−1. 
Let θI1 , . . . , θId be as described above. We define the functions Θ and Θ−1 as follows: Θ = f 
 (θI1× . . .×θId) and Θ−1 = (θ−1 
I1 ×. . .×θ−1 
Id )◦g. The function Θ induces an isomorphism from Rdq toM/qM with inverse Θ−1. 
2.2 Lattices 
We refer to [21,34] for introductions to lattices and their computational aspects. A euclidean lattice Λ ⊆ Rn is the set of all integer linear combinations 
∑p i=1 xibi of some linearly independent vectors (bi)1≤i≤p ∈ Rn. 
We write L(B) for the lattice spanned by the basis B = (bi)i≤p. We call p the dimension of the lattice. In this work, we will restrict ourselves to full-rank lattices, i.e., with p = n. 
The minimum λ1(Λ) of a lattice Λ is the norm of any of its shortest nonzero vectors. More generally, the ith successive minimum λi(Λ) is the smallest radius r such that Λ contains i linearly independent vectors of norm at most r. The dual lattice of Λ ⊆ Rn is Λ∗ = {x ∈ Rn : ∀y ∈ Λ, 〈x,y〉 ∈ Z}. If Λ = L(B) then Λ∗ = L(B∗) with B∗ = B−T . 
We consider the following generalization of SIVP. Let φ denote an arbitrary real-valued function of a lattice (e.g., taking φ = λn allows one to recover SIVPγ). Let γ ≥ 1 be a function of the dimension n. The Generalized Independent Vectors Problem GIVPφγ is as follows: Given a lattice basis B, find n = dim(L(B)) linearly independent vectors s1, . . . , sn ∈ L(B) such that maxi ‖si‖ ≤ γ · φ(L(B)). 
7
For φ = λn, this problem is NP-hard for any approximation factor γ ≤ O(1) (see [4]). The best known algorithms (even quantum) for an exact solution and an approximation to within any polynomial factor γ all have exponential complexities [25]. This motivates the following conjecture: There is no polynomial time (quantum) algorithm that approximates lattice problems to within a polynomial factor. The following stronger conjecture also seems to hold: There is no sub-exponential time (quantum) algorithm that approximates lattice problems to within a polynomial factor. 
Ideal and module lattices. As σH is an embedding from K to Rn and I an ideal of R, the set σH(I) is a lattice. We call it ideal lattice with respect to K. To ease the presentation, we often identify I and σH(I). We let Id-GIVP denote the restriction of GIVP to ideal lattices. 
We define module lattices similarly. The map (σH , . . . , σH) is an embedding fromKd to RN , with N = nd, and M ⊆ Kd a module of R. By abuse of notation, we also call it σH . The set σH(M) is a module lattice. Similarly to ideal lattices, we let Mod-GIVP denote the restriction of GIVP to module lattices. Note that ifM is a rank d module and if K has degree n, then the corresponding module lattice has dimension N = nd. For any x ∈ Kd, we define ‖x‖ = ( 
∑ k∈[d] 
∑ j∈Z×ν |σj(xk)|2)1/2. We also define ‖x‖∞ = maxj,k |σj(xk)|, 
‖x‖2,∞ = maxj( ∑ k |σj(xk)|2)1/2 and ‖x‖∞,2 = maxk( 
∑ j |σj(xk)|2)1/2. 
When a module is given as input of a problem, we consider that we give a lattice basis of the corresponding module lattice. Note that it is equivalent to give a basis of the module lattice and a pseudo-basis of the module because from the first representation, the second representation is computable in polynomial time [6,9]. All asymptotic statements involving modules (including hardness results) will be given for N growing to infinity. 
2.3 Gaussian measures 
For a vector c ∈ Rn and a real s > 0, the Gaussian function is defined by ρs,c(x) = e−π‖ x−c s ‖ 
2 , for all x ∈ Rn. This function is extended to any countable set A ⊆ Rn in the usual way: ρs,c(A) = 
∑ x∈A ρs,c(x). 
By normalizing the Gaussian function, we obtain the continuous Gaussian probability distribution: Ds(x) = ρs(x)/sn. For r = (r1, . . . , rn)T ∈ (R+)n, a sample from Dr over Rn is given by (Dri)i. 
In the following of the paper, we use the elliptical Gaussian distributions in the basis {hj}j∈Z×ν , as in [16]. For (rj)j∈Z×ν ∈ Rn such that rj = rν−j for all j ∈ J, a sample x from Dr is given by σC(x) = 
∑ j xj · hj , 
where each xj is independently chosen from the Gaussian distribution Drj over R. We define Ψ[α,α′] for 0 ≤ α < α′, as the set of Gaussian distributions Dr with α < ri ≤ α′, for all i. We 
write Ψ≤α′ when α = 0. We also recall the distribution Υα used in [16]. The gamma distribution Γ (2, 1) with shape parameter 2 and scale parameter 1 has density t exp(−t) for t ≥ 0 and zero for t < 0. For α > 0, a distribution sampled from Υα is an elliptical Gaussian distribution Dr whose parameters are rj = rν−j = α √ 
1 + √ nxj , where the xj ’s for j ∈ J are chosen independently from Γ (2, 1). We will use the following 
result on Γ (2, 1). 
Lemma 2.2 ([16, Claim 5.10]). Let P be the distribution Γ (2, 1)n and Q be the distribution (Γ (2, 1) − z1) × . . . × (Γ (2, 1) − zn) for some 0 ≤ z1, . . . , zn ≤ 1/ 
√ n. Then for any measurable set A ⊆ Rn, we have∫ 
A Q ≥ 1 
poly(n) · ( ∫ A P )2. 
For all c ∈ Rn, s > 0 and lattice Λ, the discrete Gaussian probability distribution with support Λ, center c and standard deviation s is defined by: 
∀x ∈ Λ, DΛ,s,c(x) = ρs,c(x) ρs,c(Λ) . 
The following theorem ensures that for s large enough, it is possible to efficiently sample according to a discrete Gaussian distribution. 
Theorem 2.3 ([11, Th. 4.1] and [8, Se. 5]). There is a probabilistic polynomial time algorithm that, given a basis B of an n-dimensional lattice Λ = L(B), a standard deviation s ≥ ‖B̃‖ · 
√ logn, and a center 
c ∈ Rn, outputs a sample whose distribution is DΛ,s,c. 
8
The smoothing parameter of a lattice was introduced by [24]. For an n-dimensional lattice Λ and a positive real ε > 0, the smoothing parameter ηε(Λ) is the smallest s such that ρ1/s(Λ∗\{0}) ≤ ε. This parameter gives a threshold above which many properties for continuous Gaussians also carry over to discrete Gaussians. We recall a few standard properties on discrete Gaussians that we will need in our reductions. 
Lemma 2.4 ([24, Le. 3.3]). Let Λ be an n-dimensional lattice and ε > 0. Then ηε(Λ) ≤ √ 
ln(2n(1+1/ε)) π · 
λn(Λ). 
This lemma implies a (trivial) reduction from SIVPγ to GIVPηεγ′ , with γ′ = γ/ √ 
ln(2n(1+1/ε)) π . We will 
describe worst-case to average-case reductions involving GIVPηε instead of SIVP. In our reductions, we will consider two choices for ε: For the reduction with a polynomial time oracle, we will use ε = n−ω(1), and for the sub-exponential time oracle we will take ε = 2−Ω(n). 
Lemma 2.5 ([28, Le. 3.5]). Let Λ be an n-dimensional lattice and ε > 0. Then ηε(Λ) ≤ √ 
ln(2n(1+1/ε)) π /λ∞1 (Λ∗), 
where λ∞1 refers to the lattice minimum with respect to the infinity norm. 
Lemma 2.6 ([11, Cor. 2.8]). Let Λ′ ⊆ Λ be n-dimensional lattices. Then for any ε ∈ (0, 1), any s ≥ ηε(Λ′), and any c ∈ Rn, the distribution (DΛ,s,c mod Λ′) is within statistical distance at most 2ε of the uniform distribution over Λ/Λ′. 
Lemma 2.7 ([23, Le. 4.4]). Let Λ be an n-dimensional lattice, s > 2ηε(Λ) for ε ≤ 1/100, and c ∈ Rn. Then for any (n − 1)-dimensional hyperplane H, the probability that x /∈ H where x is chosen from DΛ,s,c 
is ≥ 1/100. 
2.4 Linear combinations of Gaussians The sum of two continuous Gaussians with parameters s and r is a continuous Gaussian with parameter√ s2 + r2. We have the following similar result for the sum of a continuous Gaussian and a discrete one. 
Lemma 2.8 (Adapted from [36, Claim 3.9]). Let Λ be an n-dimensional lattice, u ∈ Rn, r ∈ (R+)n, σ > 0 and ti = 
√ r2 i + σ2 for all i. Assume that mini riσ/ti ≥ ηε(Λ) for some ε ∈ (0, 1/2). Consider the 
discrete distribution Y on Rn obtained by sampling from DΛ+u,r and then adding a vector taken from Dσ. Then we have ∆(Y,Dt) ≤ 4ε. 
Proof. This proof follows the same principle as the one of [36, Claim 3.9], the only difference being that [36, Claim 3.9] considers the case where all ri’s are equal. Using the Poisson summation formula, one obtains that the probability density function Y can be written as: 
∀x ∈ Rn : Y (x) = ρt(x)∏ i ti · 
(∏ i ti σri 
) · ̂ρt′,x′−u(Λ∗)(∏ 
i 1 ri 
) · ρ̂r,−u(Λ∗) 
, 
where t′i = riσ/ti and x′i = r2 i xi/t 
2 i for all i, and where f̂ denotes the Fourier transform of f . Then, we have:∣∣∣∣∣1− 
(∏ i 
ti σri 
) ̂ρt′,x′−u(Λ∗) 
∣∣∣∣∣ ≤ ρt′′(Λ∗ \ {0}), with t′′i = 1/t′i for all i,∣∣∣∣∣1− (∏ 
i 
1 ri 
) ρ̂r,−u(Λ∗) 
∣∣∣∣∣ ≤ ρr′′(Λ∗ \ {0}), with r′′i = 1/ri for all i. 
Let s′ and σ′ > 0 be such that s′i ≥ σ′ for all i. We have that for any vector x: 
ρ1/σ′(x) ρ(1/s′ 
i )i(x) = exp 
( −π ∑ i 
((σ′)2x2 i − (s′i)2x2 
i ) ) ≥ 1. 
This implies that ρt′′(Λ∗ \ {0}) ≤ ε and ρr′′(Λ∗ \ {0}) ≤ ε, which completes the proof. ut 
9
We will also use the following lemmata. 
Lemma 2.9 (Adapted from [28, Cor. 5.3]). For any n-dimensional lattice Λ ⊆ Rn, c ∈ Rn, ε ∈ (0, 1), t ≥ √ 
2π, unit vector u ∈ Rn and s ≥ ηε(Λ), we have: 
Pr b←↩DΛ,s,c 
[|〈b− c,u〉| ≥ st] ≤ 1 + ε 
1− εt √ 
2πe · e−πt 2 . 
Lemma 2.10 (Adapted from [28, Cor. 5.3]). Let Λ be a n-dimensional lattice, ε ∈ (0, 1) and r ∈ Rn with ri ≥ ηε(Λ) for all i ≤ n. Then we have Prx←↩DΛ,r [‖x‖∞ ≥ (maxi ri) · t] ≤ 2en · exp(−πt2) for all t > 0. In particular, for t = ω( 
√ logn) (resp. t = Ω( 
√ n)) the above probability is at most n−ω(1) (resp. 2−Ω(n)). 
We now generalize [28, Cor. 5.3] and [37, Le. 2.9] to the case of module lattices (over the ring of integers of a cyclotomic number field). 
Lemma 2.11. Let ε ∈ (0, 1 2m+1 ) and z1, . . . , zm ∈ R. Let M ⊆ Kd be a rank d module on R, s ≥ ηε(M) 
and c1, . . . , cm ∈ Rd. If the y`’s are independently sampled from the DM,s,c` ’s, then, for all t ≥ 0: 
Pr [ ‖ ∑ `∈[m] 
z` · (y` − c`) ‖∞≥ st‖z‖ ] ≤ 21 + ε 
1− εtN √ 
2πe · e−πt 2 . 
In particular, for t = ω( √ 
logN) the above probability is negligible with respect to N . 
Proof. The proof builds upon that of [28, Cor. 5.3]. The principle is to interpret the m Gaussian samples from the N -dimensional lattice M as one Gaussian sample from the (Nm)-dimensional lattice L and then apply Lemma 2.9, where L = M × · · · ×M (i.e., the Cartesian product of m copies of M). We also define −→c = (c1, . . . , cm)T ∈ (Rd)m and −→y = (y1, . . . ,ym)T ∈ (Rd)m. We have ρs,−→c (L) = 
∏ `∈[m] ρs,c`(M). The 
vector −→y has distribution DL,s,−→c . We have: 
σC ( ∑ `∈[m] 
z` · (y` − c`) ) 
= 
 ∑m `=1 σC(z` · (y(1) 
` − c (1) ` )) 
...∑m `=1 σC(z` · (y(d) 
` − c (d) ` )) 
 = 
 ( 〈σj(−→z ), σj(−→y (1) −−→c (1))〉 
) j∈Z×ν 
...( 〈σj(−→z ), σj(−→y (d) −−→c (d))〉 
) j∈Z×ν 
 with −→z = (z1, . . . , zm)T ∈ Rm, −→y (k) − −→c (k) = (y(k) 
1 − c(k) 1 , . . . , y 
(k) m − c(k) 
m )T ∈ Rm for k ∈ [d], and, for any j ∈ Z×ν and −→x ∈ Rm, σj(−→x ) = (σj(x`))`∈[m]. 
By applying the union bound over all j ∈ Z×ν and all k ∈ [d], it suffices to obtain a probabilistic upper bound on the Hermitian product between σj(−→z ) and σj(−→y (k) −−→c (k)) for any fixed j and k. For the rest of the proof, we fix j ∈ Z×ν and k ∈ [d]. Wlog (by complex conjugation), we take j ∈ J. 
For ` ∈ [m], let u` = (u(1) ` , . . . , u 
(d) ` )T ∈ Cnd with u(k′) 
` = (0, . . . , 0)T for k′ 6= k, and: 
u (k) ` = (0, . . . , 0, σj(z`), 0, . . . , 0,−i · σj(z`), 0, . . . , 0)T , 
i.e., the coordinate of index j is equal to σj(z`), the coordinate of index ν−j is equal to −i ·σj(z`), and all the others are 0. We now define −→u ∈ Cndm as the concatenation of the u`’s (for ` ∈ [m]), and σH(−→y −−→c ) ∈ Rndm as the concatenation of the σH(y` − c`)’s. We have: 
〈σj(−→z ), σj(−→y (k) −−→c (k))〉 = ∑ ` 
σj(z`)σj(y(k) ` − c 
(k) ` ) = 〈−→u , σH(−→y −−→c )〉. 
Now, we define −→v = −→u /‖−→u ‖ ∈ Cndm. By Lemma 2.9, we have: 
Pr−→y←↩DL,s,−→c 
[ |〈σH(−→y −−→c ),<(−→v )〉| ≥ st 
] ≤ 1 + ε 
1− εt √ 
2πe · e−πt 2 , 
Pr−→y←↩DL,s,−→c 
[ |〈σH(−→y −−→c ),=(−→v )〉| ≥ st 
] ≤ 1 + ε 
1− εt √ 
2πe · e−πt 2 , 
10
where < and = respectively denote the real and imaginary parts of a complex number. By using the union bound and scaling by ‖−→u ‖ ≤ ‖z‖, we obtain that: 
Pr [ |〈−→u , σH(−→y ′ −−→c ′)〉| ≥ st‖z‖ 
] ≤ 21 + ε 
1− εt √ 
2πe · e−πt 2 . 
This leads to the claimed result. ut 
The product of a continuous Gaussian on R with parameter s and a scalar x ∈ R is a continuous Gaussian with parameter xs. This can be generalized to the ring and module settings. The following result is given in [16], but without proof. 
Lemma 2.12. Let r ∈ (R+)n with rj = rν−j for all j ∈ Z×ν , x ∈ K sampled from Dr and e ∈ K fixed. Then x · e is distributed from Dr′ with r′j = rj |σj(e)| for all j. 
Proof. Let us write σC(x) = ∑ j xj ·hj where each xj is sampled from Drj . By definition of the hj ’s, we have 
σj(x) = (xj+ ixν−j) and σν−j(x) = (xj− ixν−j), for j ∈ J. Let σC(e) = ∑ j ej ·hj and σC(e ·x) = 
∑ j yj ·hj . 
We have, for j ∈ J [ yj yν−j 
] = [ ej −eν−j eν−j ej 
] [ xj xν−j 
] The vector (yj , yν−j)T is an orthogonal transformation of the vector (xj , xν−j), and thus yj and yν−j are statistically independent. Further, the reals yj and yν−j are samples of Dr′ 
j and Dr′ 
ν−j respectively, with 
r′j = r′ν−j = (e2 jr 
2 j + e2 
ν−jr 2 ν−j)1/2 = rj |σj(e)|. ut 
The following lemma generalizes the previous result to the module setting. 
Lemma 2.13. Let r ∈ (R+)n with rj = rν−j for all j ∈ Z×ν , x ∈ Kd sampled from Ds,...,s and e ∈ Kd 
fixed. Then ∑ k xkek is distributed from Dr′ with r′j = rj · ( 
∑ k∈[d] |σj(ek)|2)1/2 for all j. 
Proof. By Lemma 2.12, we have that xk · ek has distribution Dr′ k with r′k,j = r′k,ν−j = rj |σj(ek)| for all j. 
The quantity under scope is the sum of independent Gaussians. ut 
3 The Short Integer Solution Problem 
In this section, we describe a reduction from Mod-GIVP to M-SIS. 
3.1 Variants of SIS 
We first recall the SIS and R-SIS problems, and introduce M-SIS. 
The Short Integer Solution Problem. The SIS problem was first introduced by Ajtai [1]. 
Definition 3.1. The Small Integer Solution problem SISq,m,β is as follows: Given A ∈ Zn×mq chosen from the uniform distribution, find z ∈ Zm such that Az = 0 mod q and 0 < ‖z‖ ≤ β. 
As observed in [24, Le. 5.2], for any q, A ∈ Zn×mq and β ≥ √ mqn/m, the SIS instance (q,A, β) admits a 
solution. There are several reductions from GIVP to SIS (see, e.g., [1,23,11]). The strongest known result is the following. 
Theorem 3.2 (Adapted from [11, Th. 9.2]). For ε(n) = n−ω(1), there is a probabilistic polynomial time reduction from solving GIVPηεγ in polynomial time (in the worst case, with high probability) to solving SISq,m,β in polynomial time with non-negligible probability, for any m(n), q(n), β(n) and γ(n) such that γ ≥ β 
√ n · ω( 
√ logn), q ≥ β 
√ n · ω(logn) and m, log q ≤ poly(n). 
11
SIS over rings. The R-SIS problem was concurrently introduced in [31] and [15]. 
Definition 3.3. The problem R-SISq,m,β is as follows: Given a1, . . . , am ∈ Rq chosen independently from the uniform distribution, find z1, . . . , zm ∈ R such that 
∑m i=1 ai · zi = 0 mod q and 0 < ‖z‖ ≤ β, where 
z = (z1, . . . , zm)T ∈ Rm. 
This problem over rings can be interpreted in terms of structured integer matrices. For example, when n is a power of 2, then R and Rq are isomorphic to Z[x]/(xn + 1) and Zq[x]/(xn + 1) respectively, and the ring multiplication ai ·zi can be written as the multiplication of the vector of Zn whose entries are the coefficients of zi and, with a nega-circulant matrix whose entries are derived from the coefficients of ai. In this setup, R-SIS is a variant of SIS where A is restricted to being block negacirculant: A = [Rot(a1)| . . . |Rot(am)], with: 
Rot(b) := 
 b0 −bn−1 · · · −b1 b1 b0 · · · −b2 ... 
... . . . 
... bn−1 bn−2 · · · b0 
 , for b = n−1∑ i=0 
bix i ∈ R. 
By using a technique from [16] (namely, the isomorphism between I/qI and Rq described in Subsection 2.1) into the proof of [15], one obtains the following result. 
Theorem 3.4. For ε(n) = n−ω(1), there is a probabilistic polynomial time reduction from solving Id-GIVPηεγ in polynomial time (in the worst case, with high probability) to solving R-SISq,m,β in polynomial time with non-negligible probability, for any m(n), q(n), β(n) and γ(n) such that γ ≥ β 
√ n·ω( √ 
logn), q ≥ β √ n·ω(logn) 
and m, log q ≤ poly(n). 
SIS over modules. The problem M-SIS generalizes both SIS and R-SIS. We use the following notations: the variable n denotes the dimension of the ring R and the variable d corresponds to the rank of the module M ⊆ Rd; we let N = nd denote the dimension of the corresponding module lattice, and give the complexity statements for N growing to infinity. 
Definition 3.5. The problem M-SISq,m,β is as follows: Given a1, . . . ,am ∈ Rdq chosen independently from the uniform distribution, find z1, . . . , zm ∈ R such that 
∑m i=1 ai · zi = 0 mod q and 0 < ‖z‖ ≤ β, where 
z = (z1, . . . , zm)T ∈ Rm. 
Like R-SIS, M-SIS can be interpreted in terms of matrices. In the same setting as above for R-SIS, it consists in taking a SIS matrix A of the form: 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
Rot(a1,1) Rot(a1,m) 
Rot(ad,1) Rot(ad,m) 
Rot(a1,2) Rot(a1,m−1) 
Rot(ad,2) Rot(ad,m−1) 
d blocks 
n = N/d 
m blocks 
In the rest of this section, we will prove the following result. 
Theorem 3.6. For any d ≥ 1 and ε(N) = N−ω(1), there is a probabilistic polynomial time reduction from solving Mod-GIVPηεγ in polynomial time (in the worst case, with high probability) to solving M-SISq,m,β in polynomial time with non-negligible probability, for any m(N), q(N), β(N) and γ(N) such that γ ≥ β 
√ N · 
ω( √ 
logN), q ≥ β √ N · ω(logN) and m, log q ≤ poly(N). 
12
In the case of a sub-exponential oracle (and with ε(N) = 2−Ω(N)), the result still holds and the conditions on the parameters become γ ≥ βΩ(N) and q ≥ βΩ(N3/2). 
Taking n = N and d = 1 in Theorem 3.6 allows us to recover Theorem 3.4. Also, by taking n = 1 and d = N in Theorem 3.6, we obtain a hardness result for SIS that is as good as that of Theorem 3.2. 
3.2 A reduction from Mod-GIVP to M-SIS 
In order to prove that the new problem M-SIS is as hard as GIVP restricted to module lattices, we use the following intermediate problem, introduced in [23]. 
Definition 3.7 ([23, Def. 5.3]). The Incremental Independent Vectors Problem IncGIVPηεγ , is as follows: Given a tuple (B,S,H) where B is a basis of an n-dimensional lattice, S ⊆ L(B) is a full-rank set of vectors such that ‖S‖ ≥ γ · ηε(L(B)) and H is a hyperplane, find h ∈ L(B) \ H such that ‖h‖ ≤ ‖S‖/2. 
Theorem 3.8 ([19, Th. 6.3]). For any function ε and γ, there is a probabilistic polynomial time reduction from solving GIVPηεγ (in the worst case, with high probability) to solving IncGIVPηεγ (in the worst case, with high probability). 
As the latter reduction preserves the lattice, it induces a reduction from Mod-GIVPηεγ to Mod-IncGIVPηεγ , i.e., IncGIVPηεγ restricted to module lattices. To prove Theorem 3.6, we provide a reduction from Mod-IncGIVPηεγ to M-SISq,m,β . 
Suppose that an oracle O solves M-SISq,m,β in polynomial time with probability N−O(1). The algorithm for Mod-IncGIVP proceeds as follows on input (B,S,H). We write M = L(B). Let s be such that 
max ( 
2q γ , √ 
logN ) ‖S‖ ≤ s ≤ q‖S‖ 
2β √ N · ω( 
√ logN) 
 For all ` ≤ m, 
 Get a fresh y` distributed as DL(B),s,0 (using Theorem 2.3), 
 Let a` = Θ−1(y` mod qM) (see the definition of Θ in Section 2.1). 
 Invoke the oracle O on input (a1, . . . ,am). If O succeeds, it returns z = (z1, . . . , zm)T ∈ Rm such that∑ `∈[m] a` · z` = 0 mod q and 0 < ‖z‖ ≤ β. 
 Output h = 1 q 
∑ `∈[m] z` · y`. 
This algorithm runs in polynomial time. Also, thanks to the parameter constraints, the interval to which the standard deviation s must belong is nonempty. Moreover, the standard deviation s is sufficiently large for the assumptions of Theorem 2.3 to hold. Indeed, by [21, Le. 7.1] and given M and S, it is possible to compute (in polynomial time) a basis T of M such that ‖T̃‖ ≤ ‖S̃‖ ≤ ‖S‖. We use this basis and we have that s ≥ ‖T̃‖ · 
√ logN . 
Lemma 3.9. The statistical distance between the distribution of (a1, . . . ,am) and the uniform distribution over Rdq is at most 2mε. 
Proof. We have s ≥ 2q γ · ‖S‖ and ‖S‖ ≥ γ · ηε(M). This implies that s ≥ q · ηε(M) = ηε(qM). By Lemma 2.6 
applied to the lattices M and qM , the statistical distance between the distribution of (y` mod qM) and the uniform distribution on M/qM is at most 2ε. As Θ−1 is an isomorphism from M/qM to (R/qR)d, the statistical distance between the distribution of the a` = Θ−1(y`) and the uniform distribution on (R/qR)d is also at most 2ε. The result follows. ut 
As a consequence, the oracle O succeeds with probability N−O(1). In the following, we assume we are in that situation. 
Lemma 3.10. For any hyperplane H, the probability that the output vector h does not belong to H is ≥ 1/100. 
13
Proof. As O succeeded, the vector z is nonzero. By definition of h, for every y′1 we have: 
h ∈ H ⇔ m∑ `=1 
z` · y` ∈ H ⇔ z1 · y1 ∈ − m∑ i=2 
z` · y` +H 
⇔ (y1 − y′1) ∈ −y′1 + 1 z1 
(H− m∑ i=2 
z` · y`) = H′. 
Assume that we fix y′1 = y1 mod qM , then y1 = y′1 + y′′1 , with y′1 fixed and the vector y′′1 statistically independent of all the a`’s, z`’s and y`’s for ` > 1. The conditional distribution of y′′1 = (y1 − y′1) is DqM,s,−y′1 . Therefore: 
Pr [(y1 − y′1) /∈ H′|y′1, (a1, . . . ,am), (z1, . . . , zm)] = Pr y′′1∼DqM,s,−y′1 
[y′′1 /∈ H′]. 
As s ≥ 2q · ηε(M) = 2ηε(qM), Lemma 2.7 gives that this probability is ≥ 1/100. ut 
The following completes the proof of Theorem 3.6. 
Lemma 3.11. We have h ∈M and, with probability close to 1, we have that ‖h‖ ≤ ‖S‖/2. 
Proof. Let us first show that h ∈M . We have, modulo qM : m∑ `=1 
z` · y` = m∑ `=1 
z` ·Θ(a`) = Θ( m∑ `=1 
z`a`) = 0. 
This implies that h = ( ∑m `=1 z` · y`)/q belongs to M . 
We now show that ‖h‖ ≤ ‖S‖/2. We have ‖h‖ = ‖ ∑m `=1 z` · y`‖/q. As in the previous proof, we define 
y′` = y` mod qM . Then, we have y` = y′′` +y′` with y′′` statistically independent from the z`’s and distributed as DqM,s,−y′ 
` . By Lemma 2.11, for s ≥ ηε(qM) and t = ω( 
√ logN), we know that: 
Pr ∀`:y′′ 
` ∼DqM,s,−y′ 
` 
[∥∥∥∥∥ m∑ `=1 
z` · (y′′` + y′`) 
∥∥∥∥∥ ≥ st√N · ‖z‖ ] ≤ N−ω(1). 
So, with probability close to 1, we have ‖ ∑m `=1 z` · y`‖ ≤ st 
√ N · ‖z‖. As 0 < ‖z‖ ≤ β, we obtain: 
‖h‖ = 1 q 
∥∥∥∥∥ m∑ `=1 
z` · y` 
∥∥∥∥∥ ≤ stβ √ N 
q . 
Finally, since s ≤ q·‖S‖ 2βt √ N , we obtain ‖h‖ ≤ ‖S‖2 . ut 
4 Learning with Errors over modules 
In this section, we describe a reduction from Mod-GIVP to M-LWE (Learning With Errors over Modules). 
4.1 Variants of LWE 
The Learning with Errors Problem. We let T = R/Z denote the segment [0, 1) with addition modulo 1. Let us recall the following definitions from [36]. For a probability density function χ on T and a vector s ∈ Znq , we let As,χ denote the distribution on Znq × T obtained by choosing a vector a ∈ Znq uniformly at random, choosing e ∈ T according to χ, and returning (a, 1 
q 〈a, s〉+ e). 
14
Definition 4.1. The search version of the Learning With Error problem SLWEq,χ is as follows: Let s ∈ Znq be secret; Given arbitrarily many samples from As,χ, the goal is to find s. 
The decision version of the Learning With Error problem LWEq,χ is as follows: Let s ∈ Znq be uniformly random; The goal is to distinguish between arbitrarily many independent samples from As,χ and the same number of independent samples from U(Znq × T). 
It is also possible to interpret LWE in terms of linear algebra: Suppose the number of requested samples (ai, 1 
q 〈ai, s〉 + ei) from As,χ is m, then we consider the matrix A ∈ Zm×nq whose rows are the ai’s, and we create the vector e = (e1, . . . , em)T . Then SLWE is as follows: 
1 q ·, find s 
A A 
s1 
sn 
+ 
e1 
em 
m 
n 
Theorem 4.2 ([36]). Let ε(n) = n−ω(1), α ∈ (0, 1) and q ≥ 2 such that αq > 2 √ n. There exists a quantum 
reduction from solving GIVPηε√8n/α in polynomial time (in the worst case, with high probability) to solving SLWEq,Dα in polynomial time with non-negligible probability. 
Assume that q is prime, q ≤ poly(n), and that χ is a probability density function on T. Then there exists a polynomial-time reduction from SLWEq,χ to LWEq,χ. 
The following result from [8] allows to remove the assumption that q is prime. 
Theorem 4.3 (Adapted from [8, Cor. 3.2 and 3.3]). Let α > 0, ε ∈ (0, 1/2), m ≥ n ≥ 1, p ≥ 25 and q ∈ [p, 2p). There exists a polynomial time reduction from LWEq,α to LWEp,Ψ≤β where 
β = Cα √ n √ 
log(n/ε) log(nm/ε) 
for some absolute constant C, and that loses at most ε in the advantage. 
LWE over rings. The R-LWE problem was introduced by Lyubashevsky et al. in [16]. Let ψ be a distribution on TR∨ = KR/R 
∨ and s ∈ R∨q . We let A(R) s,ψ denote the distribution on Rq × TR∨ obtained by choosing 
a ∈ Rq uniformly at random and e ∈ TR∨ according to ψ, and returning (a, (a · s)/q + e). 
Definition 4.4. Let q ≥ 2 and Ψ be a family of distributions on TR∨ . The search version of the Ring Learning With Error problem R-SLWEq,Ψ is as follows: Let s ∈ R∨q be secret and ψ ∈ Ψ ; Given arbitrarily many samples from A 
(R) s,ψ , the goal is to find s. 
Let Υ be a distribution over a family of noise distributions over KR. The decision version of the Ring Learning With Error problem R-LWEq,Υ is as follows: Let s ∈ R∨q be uniformly random and ψ be sampled from Υ ; The goal is to distinguish between arbitrarily many independent samples from A 
(R) s,ψ and the same 
number of independent samples from U(Rq,TR∨). 
As for R-SIS, this problem can be interpreted in terms of linear algebra. In the same example setting as in the case of R-SIS (i.e., the parameter ν is set to a power of 2, implying that R ' Z[x]/(xn+1)), R-SIS is a variant of LWE where the matrix A is restricted to being block-negacirculant: A = [Rot(a1)| . . . |Rot(am)]T . The two main results from [16] are a reduction from Id-GIVP to R-SLWE and a reduction from the search version R-SLWE to the decision version R-LWE. 
15
Theorem 4.5 ([16, Th. 4.1 and Th. 5.1]). Let ε(n) = n−ω(1), α ∈ (0, 1) and q ≥ 2 of known factorization such that αq > ω( 
√ logn). There exists a quantum reduction from solving Id-GIVPηεγ in polynomial time 
(in the worst case, with high probability) to solving R-SLWEq,Ψ≤α in polynomial time with non-negligible probability with γ = 
√ n · ω( 
√ logn)/α. 
Assume that q is prime, q ≤ poly(n), and that q = 1 mod ν. Then there exists a polynomial time reduction from R-SLWEq,Ψ≤α to R-LWEq,Υα . 
LWE over modules. The M-LWE problem generalizes both LWE and R-LWE, and was recently introduced in [7]. As in Section 3, the variable n and d respectively denote the dimension of R and the rank of the module M ⊆ Rd; We still let N = nd denote the dimension of the corresponding module lattice. 
Let ψ be some probability distribution on TR∨ and s ∈ (R∨q )d be a vector. We define A(M) q,s,ψ as the 
distribution on (Rq)d × TR∨ obtained by choosing a vector a ∈ (Rq)d uniformly at random, and e ∈ TR∨ according to ψ, and returning (a, 1 
q 〈a, s〉+ e). 
Definition 4.6. Let q ≥ 2 and Ψ be a family of distributions on TR∨ . The search version of the Module Learning With Error problem M-SLWEq,Ψ is as follows: Let s ∈ (R∨q )d be secret and ψ ∈ Ψ ; Given arbitrarily many samples from A 
(M) q,s,ψ, the goal is to find s. 
For an integer q ≥ 2 and a distribution Υ over a family of distributions over KR. The decision version of the Module Learning With Error problem M-LWEq,Υ is as follows: Let s ∈ (R∨q )d be uniformly random and ψ be sampled from Υ ; The goal is to distinguish between arbitrarily many independent samples from A 
(M) q,s,ψ 
and the same number of independent samples from U(Rdq ,TR∨). 
As for LWE and R-LWE, the problem M-LWE can be interpreted in terms of linear algebra. Still in the same example setting, it consists in taking the LWE matrix A of the form: 
 
 
 
 
 
 
 
 
Rot(a1,d) 
Rot(am,d) 
Rot(a1,1) 
Rot(am,1) 
m blocks 
d blocks 
n = N/d 
We now give our two main results concerning the hardness of M-LWE, in the following two theorems. 
Theorem 4.7. Let ε(N) = N−ω(1), α ∈ (0, 1) and q ≥ 2 of known factorization such that αq > 2 √ d · 
ω( √ 
logn). There is a quantum reduction from solving Mod-GIVPηεγ in polynomial time (in the worst case, with high probability) to solving M-SLWEq,Ψ≤α in polynomial time with non-negligible advantage with γ =√ 
8Nd · ω( √ 
logn)/α. Assume that q is prime, q ≤ poly(N) and that q = 1 mod ν. Then there exists a polynomial time reduction 
from M-SLWEq,Ψ≤α to M-LWEq,Υα . 
In the case of a sub-exponential oracle (and with ε(N) = 2−Ω(N)), the result still holds and the conditions on the parameters become αq > 2 
√ d ·Ω( 
√ n) and γ = d ·Ω(n)/α. 
When n = N and d = 1, our theorem is identical to Theorem 4.5 [16, Th. 3.1]. When n = 1 and d = N , it is identical to Theorem 4.2 [36, Th. 4.1 and 5.1] (apart from a minor detail with the error distribution which can easily be handled: we use Υα rather than Dα). 
16
Theorem 4.8. Let p, q ∈ [2, 2NO(1) ] and α, β ∈ (0, 1) such that β ≥ α · max(1, qp ) · n1/4N1/2 · ω(log2 N) and αq ≥ ω( 
√ log(N)/n). There exists a polynomial time reduction from M-LWEq,Υα to M-LWEp,Υβ . 
In the case of a sub-exponential oracle (and with ε(N) = 2−Ω(N)), the result still holds and the conditions on the parameters become β ≥ α ·max(1, qp ) ·Ω(n1/4N5/2) and αq ≥ Ω( 
√ d). 
Note that the condition on αq from Theorem 4.8 is always weaker than the one from Theorem 4.7. Combined with Theorem 4.7 by using a q prime close to p with q = 1 mod ν, Theorem 4.8 provides a reduction from Mod-SIVP to M-LWE with a modulus p of arbitrary arithmetic form. As M-LWE is a generalization of both LWE and R-LWE, this theorem also provides a reduction from Id-SIVPγ to RLWEp,Υβ , for a modulus p of arbitrary arithmetic shape. Note the in the case of LWE, this theorem is almost identical to Theorem 4.3. 
The remainder of this section is devoted to proving Theorems 4.7 (Subsection 4.2 and 4.3) and 4.8 (Subsection 4.4). 
4.2 A reduction from Mod-GIVP to M-SLWE. 
The reduction from Mod-GIVP to M-SLWE follows the same design principle as Regev’s reduction from GIVP to SLWE. It makes use of the following intermediate problems, where φ denotes an arbitrary realvalued function on lattices and where γ is a function of the dimension, called Module Discrete Gaussian Sampling problem (M-DGSφγ): Given an N -dimensional module lattice M and a number r > γ · φ(M), the goal is to output a sample from DM,r. The reduction proceeds in two steps: 
Mod-GIVPηε√ 8Nd·ω( 
√ logn)/α 
Lemma 4.9 M-DGSηε√ 2d·ω( √ 
logn)/α Lemma 4.10 M-SLWEq,Ψ≤α 
The first reduction comes directly from the reduction from GIVP to DGS given by [36, Le. 3.17]: It is lattice-preserving and thus also works when we consider the problems restricted to any family of lattices. 
Lemma 4.9 (Adapted from [36, Le. 3.17]). For any ε = ε(N) ≤ 1/10 and any γ and φ such that γ · φ(M) ≤ 
√ 2ηε(M), there is a polynomial time reduction from Mod-GIVPφ2√N ·γ to M-DGSφγ . 
In contrast, the second one needs to be adapted. 
Lemma 4.10. Let ε(N) = N−ω(1), α ∈ (0, 1) and q be some integer such that αq ≥ 2 √ d ·ω( 
√ logn). Assume 
that we have access to an oracle that solves M-SLWEq,ψ≤α given a polynomial number of samples. Then there exists a polynomial time quantum algorithm for M-DGSηε√ 
2d·ω( √ 
logn)/α . 
Proof. We use the same principle as Regev’s reduction [36, Th. 3.1]. We consider a module lattice M and a number r ≥ 
√ 2d·ω( 
√ logn)·ηε(M)/α. The idea is to produce samples forDM,r′ with r′ large enough, and then 
to use Lemma 4.11 several times to progressively decrease the value of r′. Take ri = r · (αq/ √ d ·ω( 
√ logn))i. 
The first iteration starts with r3N > 23N > 22NλN (M) (using a LLL-reduction algorithm beforehand). Then it obtains poly(N) samples of DM,r3N using the algorithm of Theorem 2.3, and finishes with poly(N) samples of DM,r3N−1 (the reduction repeats poly(N) times the same iteration with the same samples in input to obtain sufficiently many different samples in output). It iterates until having poly(N) samples of DM,r1 
with r1 = r ·αq/( √ d ·ω( 
√ logn)) > 
√ 2q · ηε(M) then it iterates a last time to obtain samples of DM,r0 with 
r0 = r > √ d · ω( 
√ logn) · ηε(M)/α. These samples are solutions to M-DGS√2d·ω( 
√ logn)·ηε(M)/α. ut 
We now describe the iterative step: 
Lemma 4.11. Let ε(N) = N−ω(1), α ∈ (0, 1) and q ≥ 2. Assume that we have access to an oracle that solves M-SLWEq,Ψ≤α in polynomial time with non-negligible probability. Then there exists a polynomial time quantum algorithm that, given an N -dimensional module lattice M , a number r > 
√ 2q · ηε(M) and poly(N) 
samples from DM,r, produces a sample from D M, 
r √ d·ω( √ 
logn) αq 
with non-negligible probability. 
17
To prove Lemma 4.11, we use the intermediate problem Mod-BDDδ: Given a module lattice M , δ < λ1(M)/2 and any point y ∈ Rn of the form y = x + e for some x ∈ M and ‖e‖2,∞ ≤ δ, find x. Note that we use the `2,∞ rather than the euclidean norm, as it is more convenient in Lemma 4.14. 
As in [36], we use another intermediate problem called q-Mod-BDDδ: Given a module lattice M and a point y ∈ Rn within distance (with respect to `2,∞ norm) δ of M , output the coset in M/qM of the closest 
vector to y. The proof of Lemma 4.11 consists of a sequence of reductions (note that δ is set to αq·ω( √ 
logn)√ 2nr ). 
Samples from D M, 
r √ d·ω( √ 
logn) αq 
Lemma 4.12 (quantum) 
Mod-BDDM∨,δ Lemma 4.13 q-Mod-BDDM∨,δ Lemma 4.14 M-SLWEq,Dα 
+ Samples from DM,r 
The first reduction of Regev’s proof is quantum and also lattice-preserving. It is adapted to the `2,∞ norm rather than the euclidean norm (note that λ1(M∨) is still with respect to the euclidean norm). For the adaptation, we used the fact that an N -dimensional vector sampled from Ds has `2,∞ norm at most s √ dω( √ 
logn), except with negligible probability. 
Lemma 4.12 (Adapted from [36, Le. 3.14]). There exists an efficient quantum algorithm that, given any N -dimensional module lattice M , a number δ < λ1(M∨)ω( 
√ logn)/(2 
√ n), and an oracle that solves 
Mod-BDDδ on M∨, outputs samples from D M, √ dω( √ 
logn)/( √ 
2δ). 
Note that by Lemma 2.5, as r > √ 
2q·ηε(M), we have that δ = αq·ω( √ 
logn)√ 2nr < 
ω( √ 
logn)√ n·ηε(M) < 
λ1(M∨)ω( √ 
logn) 2 √ n 
. 
The second reduction is a special case of [36, Le. 3.5], which is lattice-preserving (and hence also applies to module lattices). 
Lemma 4.13 ([36, Le. 3.5]). For any q ≥ 2, there is a polynomial time reduction from Mod-BDDδ to q-Mod-BDDδ. 
We will modify the last reduction, by proving the following adaptation of [36, Le. 3.4]. The following lemma is the main modification of the proof of the first part of Theorem 4.7. 
Lemma 4.14. Let ε(N) = N−ω(1), α ∈ (0, 1) and q ≥ 2. Let M ⊆ Rd be an R-module, and r > √ 
2q ·ηε(M). Given access to an oracle sampling from the distribution DM,r, there exists a probabilistic reduction from q-Mod-BDD 
M∨, αq·ω( 
√ logn) 
√ 2nr 
to M-SLWEq,Ψ≤α . 
The principle of the reduction is to construct from y, the input of q-Mod-BDD, and from some discrete and continuous Gaussian samples, the pairs (a, b) distributed as A(M) 
q,s,ψ, where s will directly depend on the closest vector x to y. To produce such samples (a, b) with the desired distribution, we combine the corresponding proofs for LWE and R-LWE (those of Lemmata [36, Le. 3.4] and [16, Le. 4.5]). Then a call to the oracle of M-SLWE returns s and lets us recover information on x. 
Proof of Lemma 4.14. Let O be the oracle which, given m ≤ poly(N) samples (a, b) from A (M) q,s,ψ for ψ ∈ Ψ≤α, 
outputs s in polynomial time with probability N−O(1). GivenM = ∑d k=1 Ik ·bk, the input of the reduction is 
y = x + e such that x ∈M∨ and ‖e‖2,∞ ≤ δ = αq·ω( √ 
logn)√ 2nr . The goal is to find x mod qM∨. The reduction 
is as follows: 
 For all ` ≤ m: 
 Get a fresh z` distributed as DM,r and a fresh e′` distributed as Dα/ 
√ 2, 
 Let a` = Θ−1(z` mod qM) and b` = 1 q 〈z`,y〉+ e′` mod R∨ (see the definition of Θ in Section 2.1). 
 Invoke the oracle O on input {(a`, b`)}`≤m. If O succeeds, it returns some s ∈ (R∨q )d. 
18
 Output Θ−1(s) ∈M∨/qM∨. 
We show that the oracle O is used properly, i.e., that its input follows the distribution A(M) q,s,ψ. 
Lemma 4.15. Let ε > 0 and s = Θ(x mod qM∨). There exists ψ ∈ Ψ≤α such that the statistical distance between A(M) 
q,s,ψ and the distribution of (a, b) is at most 6ε. 
Proof. We first show that the statistical distance between a, the first component of each sample, and the uniform distribution on Rdq is at most 2ε. By Lemma 2.6, the statistical distance between the distribution of z and the uniform distribution on Mq is at most 2ε, because r ≥ q · ηε(M) = ηε(qM). Then, as Θ−1 
induces a bijection from Mq to Rdq , the statistical distance between the distribution of a = Θ−1(z mod qM) and the uniform distribution on (Rq)d is at most 2ε. 
Now, we show that b is of the shape b = 1 q 〈a, s〉+ f , where f distributed from Dr′ with r′i ≤ α for all i. 
We have: b = 1 
q 〈z,y〉+ e′ = 1 
q 〈z,x + e〉+ e′ = 1 
q 〈z,x〉+ 〈1 
q z, e〉+ e′. 
By definition, we have z = Θ(a) = ∑d k=1(tk · ak) · bk mod qM with tk ∈ Ik and ak ∈ Rq. By Lemma 2.1, 
we have M∨ = ∑d k=1 I 
∨ k · b∨k . Let x = 
∑d k=1 xk · b 
∨ k . We have that xk ∈ I∨k = I−1 
k · R∨ for all k. We also have 〈bk, b∨k′〉 = 1 if k = k′ and 〈bk, b∨k′〉 = 0 otherwise. Then, modulo qR∨: 
〈z,x〉 = d∑ 
k,k′=1 (tk · ak) · xk′ · 〈bk, b∨k′〉 = 
d∑ k=1 
(tk · ak) · xk = d∑ k=1 
ak · (tk · xk). 
Because s = Θ(x mod qM∨) = (t1 · x1 mod qR∨, . . . , td · xd mod qR∨)T , we have: 
〈a, s〉 = d∑ k=1 
ak · (tk · xk) = 〈z,x〉 mod qR∨. 
As a consequence, we obtain that 1 q 〈z,x〉 = 1 
q 〈a, s〉 mod R∨. 
We now show that, conditioned on a, the quantity 〈 1 qz, e〉+ e′ has distribution Dr′ with r′i ≤ α for all i. 
First, let us analyse the distribution of z′ = 1 qz knowing a. We know that z has distribution DM,r and 
that a = Θ−1(z mod qM). Let u = Θ(a) mod qM , then the residual distribution of z′ = 1 qz knowing a is 
DM+u/q,r/q (with r/q ≥ √ 
2ηε(M)). We then show that e′ is following the same distribution as 〈e′′, e〉 with e′′ ∼ Ds,...,s, s = (si)i and 
si = sν−i = α/ √ 
2 ∑d k=1 |σi(ek)|2 for i ∈ J. By Lemma 2.13, as the vector e′′ is distributed from Ds,...,s 
and e ∈ Kd is fixed, we have that 〈e′′, e〉 has distribution Ds′ with s′i = s′ν−i = si 
√∑d k=1 |σi(ek)|2 = α/ 
√ 2. 
We are now led to considering the distribution of 〈z′+ e′′, e〉. We write e′′ = e′′1 + e′′2 with e′′1 ∼ Dα/( √ 
2δ) and e′′2 ∼ Ds′′ with (s′′i )2 = s2 
i − α2/(2δ2) (which is positive, by the assumption on ‖e‖2,∞). As we have α/( √ 
2δ) = r/q and r/q ≥ √ 
2ηε(M), Lemma 2.8 gives us that the statistical distance between the distribution of z′ + e′′1 and Dα/δ is at most 4ε. As a consequence, the statistical distance between the distribution of z′ + e′′1 + e′′2 and Dr′′,...,r′′ is at most 4ε, with 
(r′′i )2 = α2 
δ2 + (s′′i )2 = α2 
δ2 + s2 i − 
α2 
2δ2 = α2 
2 ∑d k=1 |σi(ek)|2 
+ α2 
2δ2 . 
By using Lemma 2.13 again with the fixed vector e, we obtain that the statistical distance between the distribution of 〈z + e′′, e〉 and Dr′ is at most 4ε, where 
r′i = 
√ α2 
2 + α2∑d 
k=1 |σi(ek)|2 2δ2 . 
19
Since δ ≥ √∑d 
k=1 |σi(ek)|2, we have r′i ≤ α, as desired. ut 
As the input of O is within negligible statistical distance from A (M) q,s,ψ for a distribution ψ ∈ Ψ≤α and s = 
Θ(x mod qM∨), oracle O succeeds with non-negligible probability. If it does succeed, then the output of our reduction is x mod qM∨, which completes the proof of Lemma 4.14. ut 
This conclude the proof of the first part of Theorem 4.7. 
4.3 A reduction from M-SLWE to M-LWE. 
We now describe a reduction from the search version M-SLWE to the decision version M-LWE. The reduction of Regev from SLWE to LWE in [36] does not carry over to the structured variants of LWE. We instead use the line of proof of Lyubashevsky et al. in [16]. Let q = 1 mod ν be prime. Then (q) = 
∏ i∈Z×ν qi where any qi 
is a prime ideal with norm N (qi) = q. For i ∈ Z×ν , we let i− denote the largest element in Z×ν less than i (and we define 1− as 0). We define the following intermediate problems: 
 qi-MLWEq,Ψ , with parameters Ψ a family of distributions over TR∨ and i ∈ Z×ν : Given access to an oracle sampling from A 
(M) q,s,ψ for some arbitrary s ∈ (R∨q )d and ψ ∈ Ψ , find s mod qiR 
∨ q . 
 Hybrid distribution A (M,i) q,s,ψ , with parameters ψ a distribution over TR∨ , s ∈ (R∨q )d and i ∈ Z×ν : 
The distribution A (M,i) q,s,ψ over (Rq)d × TR∨ is defined as follows: Choose (a, b) from A 
(M) q,s,ψ and return 
(a, b + r/q) where r ∈ R∨q is uniformly random and independent in R∨q /qjR ∨ for all j ≤ i, and is 0 
modulo the remaining qjR ∨’s. 
 DecMLWEiq,Ψ , with parameters Ψ a family of distributions on TR∨ and i ∈ Z×ν : Given access to an oracle sampling from A 
(M,j) q,s,ψ for arbitrary s ∈ (R∨q )d, ψ ∈ Ψ and j ∈ {i−, i}, find j. 
 M-DLWEiq,Υ , with parameters a distribution Υ over errors distributions and i ∈ Z×ν : Given access to an oracle sampling from A 
(M,j) q,s,ψ for s uniform in (R∨q )d, ψ sampled from Υ and arbitrary j ∈ {i−, i}, find j. 
We consider the following sequence of reductions: 
M-SLWEq,Ψ Lemma 4.16 qi-MLWEq,Ψ Lemma 4.18 DecMLWEiq,Ψ Lemma 4.19 M-DLWEiq,Υ 
Lemma 4.21 M-LWEq,Υ 
We explain the first two reductions. The following result is adapted from [16]. 
Lemma 4.16. For any i ∈ Z×ν , there is a polynomial time reduction from M-SLWEq,Ψ≤α to qi-MLWEq,Ψ≤α . 
Proof. We aim at using an oracle solving qi-MLWE for finding the values of s mod qjR ∨ for every j ∈ Z×ν . 
Then, by the Chinese Reminder Theorem, this allows us to construct s mod R∨ and to solve M-SLWE. We use the K-automorphisms, defined by τj(ξ) = ξj for all j ∈ Z×ν . We choose ji ∈ Z×ν such that 
τji(qj) = qi. The reduction is as follows: 
 For every sample (a, b), create the sample (a′, b′) with a′ = (τji(a1), . . . , τji(ad))T and b′ = τji(b). 
 Use the oracle of qi-MLWE with these samples, and get t ∈ (R∨/qiR∨)d. 
 Return (τ−1 
ji (t1), . . . , τ−1 
ji (td)) ∈ (R∨/qjR∨)d. 
We show that τ−1 ji 
(tk) = sk mod qjR ∨ for all k ∈ [d]. By definition, we have b = 1 
q 〈a, s〉+ e mod R∨ with 〈a, s〉 = 
∑d k=1 ak · sk. As a consequence, we have: 
b′ = τji(b) = 1 q 
d∑ k=1 
τji(ak) · τji(sk) + τji(e) = 1 q 〈a′, s′〉+ τji(e) mod R∨, 
with s′ = (τji(s1), . . . , τji(sd))T . As τji is an automorphism, the vector a′ is uniformly distributed in Rdq . Also, as Ψ≤α is closed under the automorphisms of K (see Lemma 4.17), we have ψ′ := τji(ψ) ∈ Ψ≤α. 
20
Overall, the pairs (a′, b′) are distributed as A(M) q,s′,ψ′ . If successful, the qi-MLWE oracle outputs t = s′ mod 
qiR ∨ = (τji(s1) mod qiR 
∨, . . . , τji(sd) mod qiR ∨). Then our reduction returns (τ−1 
ji (t1), . . . , τ−1 
ji (td))T ∈ 
(R∨/qjR∨)d, which is equal to s mod qjR ∨. ut 
By [16, Le. 5.6], we know that Ψ≤α satisfies the property required by Lemma 4.16. 
Lemma 4.17 ([16, Le. 5.6]). For any α > 0, the family Ψ≤α is closed under every automorphism τ of K, i.e., ψ ∈ Ψ≤α ⇒ τ(ψ) ∈ Ψ≤α. 
We now describe the next reduction. 
Lemma 4.18. For any i ∈ Z×ν , there is a polynomial time reduction from qi-MLWEq,Ψ to DecMLWEiq,Ψ . 
Proof. We want to find s mod qiR ∨ from samples fromA 
(M) q,s,ψ, by using an oracle that solves the DecMLWEiq,Ψ 
problem. The principle of the proof is to find, one by one, each one of the d coordinates of s mod qiR ∨ by 
using the oracle of DecMLWEiq,Ψ . For each coordinate, there are N (qi) = q ≤ poly(n) possibilities. Therefore, it is possible to try them all in order to find the correct one. To check that a guess is correct, we use the same approach as in [36, Le. 4.2] and randomize a coordinate of a. 
To find s1 mod qiR ∨, we proceed as follows. Let (a, b) be distributed as A(M) 
q,s,ψ and let x ∈ R∨q ; we want to know if x = s1 mod qiR 
∨. We construct the following pair: 
(a′, b′) := ( 
a + (y, 0, . . . , 0), b+ 1 q 
(r + xy) ) , 
where y ∈ Rq is sampled uniformly modulo qi, and is 0 modulo all the remaining qj ’s, and where r ∈ R∨q is uniformly random and independent modulo qjR 
∨ for all j < i, and 0 modulo all the remaining qjR ∨’s. 
Now, we show that if x = s1 mod qiR ∨, then the pair (a′, b′) is distributed from A 
(M,i−) q,s,ψ and if x 6= 
s1 mod qiR ∨, it is distributed from A 
(M,i) q,s,ψ . First, notice that the vector a′ is uniformly distributed in (Rq)d. 
Now, we write b′ as follows: 
b′ = b+ 1 q 
(r + xy) = 1 q 
( d∑ k=1 
ak · sk + r + xy 
) + e = 
( 1 q 〈a′, s〉+ e 
) + 1 q 
(r + y(x− s1)) . 
We have two cases: 
 If x = s1 mod qiR ∨, then by the Chinese Reminder Theorem we have y(x− s1) = 0 ∈ R∨q . As r is chosen 
uniformly random and independent modulo qjR ∨ for all j < i, and is 0 modulo all the remaining qjR 
∨’s, we obtain that the pair (a′, b′) has distribution A(M,i−) 
q,s,ψ . 
 If x 6= s1 mod qiR 
∨, then y(x − s1) is uniformly distributed modulo qiR ∨, because R∨/qiR∨ is a field 
(the ideal qi is prime). Also, the quantity y(x − s1) is 0 modulo the other qjR ∨’s. As a consequence, 
we have that (r + y(x− s1)) is uniformly random and independent modulo qjR ∨ for all j ≤ i and is 0 
modulo all the remaining qjR ∨’s. We obtain that the pair (a′, b′) is distributed as A(M,i) 
q,s,ψ . 
We repeat this process d times (once for each coordinate of s), to obtain s mod qiR ∨. ut 
The last reductions carry over directly from the ring setting [16, Le. 5.12 and 5.14] to the module setting (the proof randomizes the noise distribution Ψ , which is the same in the ring and module settings). 
Lemma 4.19 (Adapted from [16, Le. 5.12]). For any α > 0 and every i ∈ Z×ν , there is a polynomial time reduction from Dec-MLWEiq,Ψ≤α to M-DLWEiq,Υα . 
Lemma 4.20 (Adapted from [16, Le. 5.13]). Let α > (1/q)ηε(R∨)d for some ε. Then for any ψ in the support of Υα and s ∈ (R∨)d, the distribution A(M,ν−1) 
q,s,ψ is within statistical distance ε/2 of the uniform distribution over ((Rq)d,TR∨). 
21
Lemma 4.21 (Adapted from [16, Le. 5.14]). Let Υ be a distribution over noise distributions satisfying that for any ψ in the support of Υ and any s ∈ (R∨q )d, the distribution A(M,ν−1) 
q,s,ψ is within negligible statistical distance from uniform. Then for any oracle solving the M-LWEq,Υ problem, there exists an i ∈ Z×ν and an efficient algorithm that solves the M-DLWEiq,Υ using the oracle. 
This completes the proof of Theorem 4.7. 
4.4 A modulus-switching self-reduction for M-LWE 
The aim of the present section is to give the proof of Theorem 4.8: For any p, q ≥ 2, and under some conditions on α and β, M-LWEp,Υβ is no easier than M-LWEq,Υα . We proceed by a sequence of reductions: 
M-LWEq,Υα Lemmata 
4.22 and 4.24 HNF-MLWEq,D 1 
q R∨,[α,α′] 
Lemma 4.26 M-LWEp,Ψ≤β Lemma 4.29 M-LWEp,Υβ 
In Lemmata 4.22 and 4.24, we first reduce M-LWEq,Υα to the HNF version of M-LWEq,D(1/q)R∨,[α,α′] 
(i.e., with a secret s of small euclidean norm), where α′ ≈ αn1/4. Then, in Lemma 4.26 we reduce HNF-MLWEq,D(1/q)R∨,[α,α′] to M-LWEp,Ψ≤β , by switching the modulus and handling the right hand sides of the M-LWE samples so that the distribution of the error term belongs to Ψ≤β . Finally, in Lemma 4.29, we re-randomize the noise distribution, thus providing a reduction from M-LWEp,Ψ≤β to M-LWEp,Υβ . 
Reducing M-LWEq,Υα to HNF-MLWEq,D(1/q)R∨,[α,α′] . We first reduce M-LWEq,Υα to M-LWEq,Ψ[α,α′] . We consider a sample φ from Υα: we have φ = Dr with ri = rν−i = α 
√ 1 + √ nxi and xi sampled from 
Γ (2, 1), for all i ∈ J. By definition of Γ (2, 1), we have Prx←↩Γ (2,1)[x ≤ t] = 1 − (1 + t)e−t, from which We derive that x ≤ ω(logN) with probability negligibly close to 1. As a consequence, with the same probability we have that α < ri ≤ α′ = α ·n1/4ω(logN) for all i. Therefore, M-LWEq,Ψ[α,α′] is no easier than M-LWEq,Υα . 
Now, for any distribution Dr arbitrarily chosen in Ψ[α,α′], we discretize the noise distribution by proving that M-LWEq,D(1/q)R∨, 
√ 2r 
is no easier than M-LWEq,Dr . Here, by abuse of notation, M-LWEq,D(1/q)R∨, √ 
2r 
denotes the M-LWE problem where the distribution ψ = D(1/q)R∨, √ 
2r is a discrete distribution on (1/q)R∨ 
and where the goal is to distinguish between arbitrarily many independent samples from A (M) q,s,ψ and the same 
number of independent samples from U(Rdq × Tq,R∨), with Tq,R∨ = ((1/q)R∨)/R∨. 
Lemma 4.22 (Adapted from [12, Le. 2]). For any q ≥ 2, ε ∈ (0, 1), r ∈ (R+)n with rν−i = ri for all i, and α ∈ [ηε(R∨)/q,mini ri], there is a polynomial time reduction from M-LWEq,Dr to M-LWEq,D(1/q)R∨, 
√ 2r . 
The proof is following the same design as the proof of [12, Le. 2]. 
Proof. We consider the following transformation: Given (a, b) ∈ Rdq × TR∨ , sample f ←↩ D(1/q)R∨−b,r and returns (a, b+ f mod R∨). 
If the sample (a, b) is uniform over Rdq × TR∨ , then (b + f mod R∨) is uniform in Tq,R∨ . Now, assume that (a, b) is distributed according to A(M) 
q,s,Dr : We have b = 1 
q 〈a, s〉+ e, where e ∼ Dr. Since 1 q 〈a, s〉 belongs 
to 1 qR ∨, we have D(1/q)R∨−b,r = D(1/q)R∨−e,r. By [30, Th. 3.1], as e is sampled from Dr and e′ = e+ f with 
f sampled from D(1/q)R∨−e,r, the distribution of e′ is statistically close to D(1/q)R∨, √ 
2r. We conclude that, in this case, the transformation returns a sample of A(M) 
q,s,D(1/q)R∨, √ 
2r . ut 
Finally, Lemma 4.24 allows us to reduce the M-LWEq,D(1/q)R∨, √ 
2r problem to a variant in which the secret 
is chosen from D(R∨)d, √ 
2qr. We call this new problem the Hermite Normal Form (HNF) of M-LWE. 
Definition 4.23. Let q ≥ 2, and Υ be a set of distributions over (1/q)R∨. The Hermite Normal Form of the decision version of the Module Learning With Error problem HNF-MLWEq,Υ is as follows: Let ψ be arbitrarily chosen from Υ and s ∈ (R∨q )d be sampled from (q·ψ)d. The goal is to distinguish between arbitrarily many independent samples from A 
(M) q,s,ψ and the same number of independent samples from U(Rdq × Tq,R∨). 
22
We have the following result: 
Lemma 4.24 (Adapted from [3, Le. 2]). There is a polynomial time transformation that, for arbitrary s ∈ (R∨q )d and error distribution D(1/q)R∨,r, maps A(M) 
q,s,D(1/q)R∨,r to A(M) 
q,x,D(1/q)R∨,r with x←↩ D(R∨)d,qr, and 
maps U(Rdq × Tq,R∨) to itself. 
The proof is following the same principle as the proof of [3, Le. 2]. 
Proof. We are given samples from a distributionD that is either the uniform overRdq×Tq,R∨ , orA (M) q,s,D(1/q)R∨,r 
. In a first stage, we take several samples (a, b) from D and construct a set of d pairs {(ak, bk)} such that 
the ak’s are linearly independent over Rq and generate Rdq (recall that Rq is not a field). A polynomial number of samples suffices to obtain such ak’s. This can be observed by considering the CRT components of Rq ' (Fq`)n/` independently: An equivalent condition is that the n/` matrices corresponding to each component are invertible over the corresponding finite field. We define A = (aT1 , . . . ,aTd ) and b = (b1, . . . , bd)T . By construction, the map y 7→ Ay is a bijection of Rdq , and if D = A 
(M) q,s,D(1/q)R∨,r 
then we have b = 1 q 
( As + x 
) , 
where x is sampled from D(R∨)d,qr. In a second stage, we map the fresh samples (a, b) from D, to samples (a′, b′) with a′ = −(A)−T ·a ∈ Rdq 
and b′ = b+ 〈a′, b〉. As the map y 7→ Ay is a bijection of Rdq and as a is uniform in Rdq , we have that a′ is uniform in Rdq . For the right hand side b′, we consider two cases: 
 If D is the uniform distribution on Rdq × Tq,R∨ , then (a′, b′) is also uniform on (Rq)d × Tq,R∨ . 
 If D is A(M) 
q,s,D(1/q)R∨,r , then b′ = 1 
q 〈a, s〉+e− 1 q 〈(A)−Ta,As〉+ 1 
q 〈a ′,x〉 = 1 
q 〈a ′,x〉+e. As a consequence, 
the pair (a′, b′) is distributed as A(q) x,D(1/q)R∨,r 
, with x sampled from D(R∨)d,qr. ut 
This completes the reduction from M-LWEq,Υα to HNF-MLWEq,D(1/q)R∨,[α,α′] . 
Reducing HNF-MLWEq,D(1/q)R∨,[α,α′] to M-LWEp,Ψ≤β . This is the main component of the proof of Theorem 4.8. In Lemma 4.25, we first give a bound on ‖s‖2,∞. 
Lemma 4.25. Let ε = N−ω(1), α′ > α > 0 and q an integer such that αq ≥ ηε(R∨). Let r ∈ (R+)n with ri ∈ [α, α′] for all i. If s is sampled from D(1/q)R∨,r, then ‖s‖2,∞ ≤ α′q· 
√ d·ω( √ 
logN) with probability ≥ 1−ε. 
Proof. First, we know that ‖s‖2,∞ ≤ √ d‖s‖∞. Let ε = N−ω(1), by assumption, we have that αq ≥ ηε(R∨). 
By Lemma 2.10 we know that ‖s‖∞ ≤ α′q · ω( √ 
logN) with probability ≥ 1− ε. The result follows. ut 
In the following lemma, we transform a sample from A (M) q,s,D(1/q)R∨,[α,α′] 
to a sample of A(M) p,s,Ψ≤β 
, assuming that ‖s‖2,∞ is bounded. 
Lemma 4.26 (Adapted from [8, Le. 3.5]). Let ε = N−ω(1), p, q > 2, α, α′ ∈ (0, 1), and smax > 0. There is an efficient mapping from Rdq × Tq,R∨ to Rdp × Tp,R∨ which has the following properties: 
 If the input is uniformly random, then the output is within negligible statistical distance from the uniform distribution. 
 If the input is distributed from A (M) q,s,D(1/q)R∨,[α,α′] 
, where s ∈ (R∨)d with ‖s‖2,∞ ≤ smax, then the output 
distribution is within negligible statistical distance from A (M) p,s′,Ψ≤β 
, where s′ is uniform in (R∨p )d and 
β2 ≥ 2 ( α′ + ω(p+ q 
pq smax · ηε(Rd)) 
) . 
23
Proof. The principle of this reduction is to first map a ∈ Rdq to a′ ∈ Rdp by scaling it by p/q, and then randomly rounding it (using a discrete Gaussian distribution). Note that simply multiplying by p/q cannot work as, for example, the caridnality of Rdp may not divide the cardinality of Rdq . Then, we study the new error term, modified with the Gaussian rounding, and show that it is still a Gaussian error. 
We sample s1 uniformly in (R∨p )d. On input (a, b) ∈ Rdq × Tq,R∨ , the mapping is as follows: 
 Set σ = ω ( (1 + p/q)ηε(Rd) 
) , 
 Sample d from DRd− pqa,σ and compute a′ = p qa + d, 
 Sample ed from Dσ·smax and e′ from Dα′ , 
 Compute b′ = b+ 1 
p 〈a ′, s1〉+ 1 
ped + e′, 
 Return the new sample (a′, b′). 
The choice of σ is derived from the proof of correctness of the reduction (see Lemmata 4.27 and 4.28 below). 
We first show that the second step of the mapping transforms the uniform distribution in Rdq to the uniform distribution in Rdp, by considering the joint distribution of the pair (a′,d). The following result can be interpreted as a simple particular case of [30, Se. 3]. 
Lemma 4.27. Let ε = N−ω(1) and assume that σ ≥ ω((1 + p q )ηε(Rd)). Then the residual distribution of a′ 
is within negligible statistical distance to U(Rdp), and, for any a′ ∈ Rdp, the distribution of d conditioned on a′ = a′ is within negligible statistical distance to D p 
qR d+a′,σ. 
Proof. Let a′ ∈ Rdp. Since d = a′ − p qa + pk for some k ∈ Rd and a ∈ Rdq , we have that d − a′ ∈ p 
qR d. 
Let d ∈ p qR 
d + a′. By construction, we have: 
Pr [ a′ = a′ ∧ d = d 
] = Pr 
[ a = q 
p (a′ − d) ∧ d = d 
] = ρσ(d) qn · ρσ(Rd − a′ + d) 
. 
In the latter, the denominator is within a factor 1± ε from qn · ρσ(Rd), because σ ≥ ηε(Rd). We now consider the residual distribution of a′. 
Pr [ a′ = a′ 
] = 
∑ d∈ pqRd+a′ 
Pr [ a′ = a′ ∧ d = d 
] 
∈ ρσ(pqR 
d + a′) qn · ρσ(Rd) · [1− ε, 1 + ε] 
⊆ 1 pn · [1− ε, 1 + ε] , 
because σ ≥ ηε(pqR d). 
Finally, we obtain that Pr[d = d|a′ = a′] is within a factor 1 ± ε from a quantity that is proportional to ρσ(d). This completes the proof of the claim. ut 
We now study the right hand size of the LWE sample. Assume that b ∈ Tq,R∨ is of the form 1 q 〈a, s〉+ eq 
with eq ←↩ D(1/q)R∨,[α,α′]. Then we can write: 
(a′, b′) = ( 
a′, 1 p 〈a′, s + s′〉+ 1 
p (〈d, s〉+ ed) + eq + e′ 
) . (1) 
The new error ep is equal to 1 p (〈d, s〉+ ed) + eq + e′. To study this new error, we first study the distribution 
of 〈d, s〉+ ed conditioned on a′ in Lemma 4.28 (which generalizes [35, Co. 3.10] to the module case). 
24
Lemma 4.28. Let smax > 0 and s ∈ Kd with ‖s‖2,∞ < smax. Let d be distributed as D(p/q)Rd−a,σ for some arbitrary a and σ ≥ 
√ 2(p/q)ηε(Rd) and e be distributed as Dτ for some τ ≥ σ · smax. Then the distribution 
of 〈d, s〉+ e is within negligible statistical distance of the elliptical Gaussian distribution Dt over K, where t2i = t2ν−i = σ2∑d 
k=1 |σi(sk)|2 + τ2 for all i. Proof. By Lemma 2.13, we have that e is following the same distribution as 〈es, s〉 with es distributed from Dr′,...,r′ and r′i = r′ν−i = τ/ 
√∑d k=1 |σi(sk)|2 for i. 
As a consequence, we have that 〈d, s〉 + e is following the same distribution as 〈d + es, s〉. We write es = e1 + e2 with e1 distributed from Dτ/S and e2 distributed from D( 
√ (r′ i )2−(τ/smax)2)i . We now use 
Lemma 2.8: As σ ≥ √ 
2(p/q)ηε(Rd) and τ ≥ smax · σ, we have that d + e1 is within statistical distance 4ε from D√ 
σ2+(τ/smax)2 . The quantity d + es can be interpreted as the sum of two continuous Gaussians: It is within statistical distance 4ε from D( 
√ σ2+(r′ 
i )2)i . 
We use Lemma 2.13 once more. We obtain that 〈d, s〉+ e is within statistical distance 4ε from Dt with t2i = t2ν−i = σ2∑d 
k=1 |σi(sk)|2 + τ2, for all i. ut 
Let (a, b) be sampled from A (M) q,s,D(1/q)R∨,[α,α′] 
and let (a′, b′) be the image of (a, b) by the mapping. To 
conclude the proof, we show that (a′, b′) is sampled from A (M) p,s′,Ψ≤β 
: 
 We recall that b′ = 1 p 〈a ′, s + s1〉+ ep. 
 We showed that a′ is within negligible statistical distance from the uniform distribution in Rdp. 
 We have that s′ = s + s1, where s1 is uniform in (R∨p )d and independent from s. This ensures that 
s′ mod p is uniform in (R∨p )d. 
 We now consider ep = 1 
p (〈d, s〉+ ed) + e+ e′, where: 
 The component 1 
p (〈d, s〉 + ed) it is within negligible statistical distance from Dt with t2i = t2ν−i = 1 pσ 
2 (∑d 
k=1 |σi(sk)|2 + s2 max 
) by applying Lemma 4.28. 
 The component e+e′ is within negligible statistical distance fromDt′ with (t′i)2 = (t′ν−i)2 = r2 i +(α′)2 
by Lemma 2.8 and as, for all i, α′q ≥ riq > αq ≥ √ 
2ηε(R∨). Then, the error component ep is within negligible statistical distance from Dt′′ with (t′′i )2 = (t′′ν−i)2 = r2 i + (α′)2 + σ2 
p2 ( ∑d k=1 |σi(sk)|2 + s2 
max). As ri ≤ α′ holds for all i, and as ‖s‖2,∞ ≤ smax, we have: 
t′′i = t′′ν−i ≤ √ 
2 · 
√ (α′)2 + σ2 
p2 s 2 max ≤ β, for all i. 
ut 
Reducing M-LWEp,Ψ≤β to M-LWEp,Υβ . This is the last component of the proof of Theorem 4.8. The goal is to re-randomize the error distribution of M-LWE. The proof is adapted from [16, Le. 5.11]. Lemma 4.29. Let p ≥ 2 and β ∈ (0, 1). There is a polynomial time reduction from M-LWEp,Ψ≤β to M-LWEp,Υβ . 
Proof. Let (a, b = 1 p 〈a, s〉 + e) be a sample from A 
(M) p,s,Dt 
with 0 < ti ≤ β and tν−i = ti for all i, and s ←↩ U((R∨q )d). Let (x′i)i ∈ J be independent samples from Γ (2, 1). We perform the following transformation: 
(a′, b′) := (a, b+ e′), 
where e′ is sampled from Dr, with r defined by r2 i = r2 
ν−i = β2√nx′i for all i. This transformation maps the uniform distribution over Rdp × TR∨ to itself. On the other hand, it maps 
A (M) p,s,Dt 
to A(M) p,s,Dr′ 
, with r′i = r′ν−i = √ t2i + β2√nx′i, for all i ∈ J. 
Let S denote the set of ψ’s for which the oracle distinguishes with non-negligible probability between the uniform distribution over Rdp×Tp,R∨ and the distribution A(M) 
p,s,ψ. By assumption, the measure of S under Υβ is non-negligible. Lemma 2.2 implies that Dr′ ∈ S with non-negligible probability. The result follows. ut 
25
5 Converse reductions 
In this section, we reduce both M-SIS and M-LWE to Mod-GIVP. This provides converse results to Theo-rems 3.6 and 4.7. We restrict the analysis to cyclotomic polynomials of the form xn + 1 with n a power of 2, for the sake of simplicity. We expect the result to carry over to all cyclotomic polynomials, but this would add technical complications in the proof of Lemma 5.1. Choosing xn + 1 implies that R∨ = 1 
nR. 
Reducing M-SIS to Mod-GIVP. Let a1, . . . ,am be sampled uniformly and independently in Rdq . Find-ing z = (z1, . . . , zm)T ∈ Rm \ {0} such that 
∑ i ziai = 0 mod q and ‖z‖ ≤ β corresponds to finding a short 
vector in the lattice: A⊥ = 
{ y ∈ Rm : ATy = 0 mod q 
} , 
where A ∈ Rd×mq is the matrix whose rows are the ai’s. As this lattice is a module lattice, if we solve Mod-GIVPηεγ given as input an arbitrary basis of A⊥ (which can be computed efficiently given A), then we obtain a solution to the M-SIS instance, for β = γ ·ηε(A⊥). To assess the effectiveness of this reduction from M-SIS to Mod-GIVP, we are thus led to estimating ηε(A⊥) for A sampled uniformly in Rm×dq . For this task, 
it is classical to study the dual lattice, as we have ηε(Λ) ≤ √ 
ln(2N(1+1/ε)) π /λ∞1 (Λ∗) for any N -dimensional 
lattice Λ (see Lemma 2.5). The dual of the lattice A⊥ is 1 qLq(A) where 
Lq(A) = { 
y ∈ (R∨)m : ∃s ∈ (R∨q )d,Bs = y mod q } . 
Hence, it suffices to obtain a probabilistic lower bound on λ∞1 (Lq(A)), for A uniform in Rm×dq . Similarly, for reducing M-SIS to M-SIVP, one is led to bounding λmn(A)⊥. As λN (Λ) ≤ N/λ1(Λ) ≤ 
N3/2/λ∞1 (Λ∗) for any N -dimensional Λ, it is also sufficient to obtain an lower bound for λ∞1 (Λ∗). 
Lemma 5.1. Let n,m, d, q be positive integers with d ≤ m and n a power of 2. We have: 
Pr A←↩U(Rm×dq ) 
[ λ∞,21 (Lq(A)) ≥ 1 
8 √ n q1− d 
m 
] ≥ 1− 2−n, 
where λ∞,21 (·) refers to the lattice minimum with respect to ‖ · ‖∞,2. 
Proof. We generalize and adapt the proof of [37, Le. 8] (see also [38, Le. 3.2]. By the union bound, the probability that Lq(A) contains a nonzero vector of infinity norm ≤ B := 1 
8 √ n q1− d 
m is bounded from above by: ∑ 
t ∈ (R∨q )m 0 < ‖t‖∞,2 ≤ B 
∑ s∈(R∨q )d 
Pr A←↩U(Rm×dq ) 
[As = t] = ∑ 
t ∈ (R∨q )m 0 < ‖t‖∞,2 ≤ B 
∑ s∈(R∨q )d 
∏ i≤m 
Pr a←↩U(Rdq ) 
[aTs = ti]. 
We now consider the probability (over the randomness of a) that aTs = ti. For this purpose, we consider the decomposition of Rq as a Cartesian product of finite fields. By the Chinese Remainder Theorem, we know that Rq ' R∨q ' Fqδ × . . . × Fqδ for some integer δ dividing n (there are n/δ copies of the finite field of qδ elements). Now, the equality aTs = ti holds if and only if it holds over all n/δ CRT components. Wlog we consider the first one. If ti and all the coordinates of s are zero, then the probability is 1. Otherwise, if ti or some coordinate of s is nonzero on that first CRT component, then the probability is ≤ q−δ. As a consequence, the probability under scope is bounded from above by:∑ 
S⊆[n/δ] 
∑ s ∈ (R∨q )d 
∀i, si is 0 on S 
∑ t ∈ (R∨q )m 
0 < ‖t‖∞,2 ≤ B ∀i, ti is 0 on S 
qm(|S|δ−n) ≤ ∑ 
S⊆[n/δ] 
∑ t ∈ (R∨q )m 
0 < ‖t‖∞,2 ≤ B ∀i, ti is 0 on S 
q(m−d)(|S|δ−n). 
26
We now attempt to bound the number of t’s in R∨ such that 0 < ‖t‖ ≤ B and t is 0 on all CRT components corresponding to S. As R∨ = 1 
nR, it suffices to bound the number of t’s in R such that 0 < ‖t‖ ≤ nB and t is 0 on all CRT components corresponding to S. 
The latter condition implies that t is a nonzero element of an ideal I of R of algebraic norm q|S|δ. Let x ∈ I reaching λ1(I). By the arithmetic-geometric inequality, we have: 
λ1(I) = ‖x‖ ≥ √ nN (x)1/n = 
√ nN ((x))1/n ≥ 
√ nN (I)1/n = 
√ nq|S|δ/n. 
As a result, there is no such t when |S| ≥ (1 − d/m)n/δ. If |S| ≤ (1 − d/m)n/δ, then we are looking for the number of points of the (ideal) lattice I in the hyperball of radius nB and center 0. All such points are away from one another by at least λ1(I). Therefore, by the pigeon-hole principle, there are at most (2nB/λ1(I))n ≤ 4−nqn−ndm −|S|δ such points. 
Now, the probability under scope can be bounded from above as 
4−n · ∑ 
S⊆[(1−d/m)n/δ] 
q(m−d)(|S|δ−n) · qmn−nd−m|S|δ ≤ 2−n. 
This completes the proof of the lemma. ut 
As a consequence of the result above and the preceding discussion, we obtain the following converse to Theorem 3.6. Note that even for d = 1 (i.e., for an R-SIS instance), the resulting Mod-GIVP instance has module rank m: This result does not provide a reduction from R-SIS to Id-GIVP (the module rank in Mod-GIVP is m, which is possibly much larger than d). 
Theorem 5.2. For any d ≥ 1 and ε(N) = N−ω(1), there is a polynomial time reduction from solving M-SISq,m,β to solving Mod-GIVPηεγ (with module rank m), for any m(N), q(N), β(N) and γ(N) such that β ≥ γ 
√ Nω 
(√ log(N/ε) 
) · q dm and m, log q ≤ poly(N). 
Reducing M-LWE to Mod-GIVP. One of the classical ways for solving LWE consists in solving an associated SIS instance [25]. We propose an adaptation of this approach to module lattices: We reduce M-LWE to M-SIS and then combine this reduction with Theorem 5.2. 
Let us sample s uniformly in (R∨q )d, and ψ from Υα. More precisely, we sample xi from Γ (2, 1) for i ∈ J, define ri = rν−i = α 
√ 1 + √ nxi, and let ψ = Dr. Assume that we have access to arbitrarily many 
samples (ai, bi) ∈ Rdq × TR∨ with ai uniform in Rdq and all the bi’s uniform and independent in TR∨ , or all the bi’s of the form bi = 1 
q 〈ai, s〉 + ei with the ei’s are sampled from ψ. Our goal is to determine with noticeable advantage which situation we are in. 
We consider m such samples (with m to be optimized later). Let A ∈ Rm×dq be the matrix whose rows are the ai’s. By solving M-SISq,m,β for AT , we obtain a nonzero vector z ∈ Rm such that ‖z‖ ≤ β and zt ·A = 0 mod q. Now, we compute 〈z, b〉, where b ∈ TmR∨ is the vector made of the bi’s. If the bi’s are uniform independent of the ai’s, then the inner product 〈z, b〉 is uniformly distributed in TR∨ . Otherwise, we have 〈z, b〉 = 〈z, e〉 (modulo R∨), where e is the vector made of the ei’s. By Lemma 2.13, we have that 〈z, e〉 is distributed as Dr′ with r′j = rj · 
√∑ k≤m |σj(zk)|2 for all j ∈ Z×ν . As a consequence, we have 
‖〈z, b〉‖ ≤ t √ n ·max 
j |r′j | 
≤ t √ n · ‖z‖ ·max 
j |rj | ≤ 2tn3/4αβ ·max 
j |xj |, 
with probability ≥ 1 − 2−Ω(nt2) over the randomness of the ei’s. Furthermore, as we have |xj | ≤ t with probability ≥ 1− (2 + t)e−t for all j, we obtain that the bound above is itself smaller than 2t2n3/4αβ with probability ≥ 1 − nt2−Ω(t). As R∨ = 1 
nR, if the latter upper bound is smaller than 1 4n , then 〈z, b〉 will be 
unexpectedly small. 
27
Overall, we have proved that if β is such that n7/4ω(log(N)) · αβ < 1, then we can distinguish between the two challenge distributions with non-negligible advantage. By Theorem 5.2, we thus obtain a reduction from Mod-GIVPηεγ with module rank m to M-LWEq,Υα , if γ is such that αγn7/4 
√ Nω( 
√ log(N/ε))q dm < 1. 
Taking m = d log q leads to the following result. 
Theorem 5.3. For any d ≥ 1 and ε(N) = N−ω(1), there is a probabilistic polynomial time reduction from solving M-LWEq,Υα to solving Mod-GIVPηεγ (with module rank d log q), for any α(N) and γ(N) such that 1 α ≥ γN 
3/2ω( √ 
log(N/ε)) and log q ≤ poly(N). 
Acknowledgements. We thank Guillaume Hanrot, Oded Regev and Ron Steinfeld for helpful discussions. Significant parts of the writing of this article were undergone while the authors were visiting Macquarie and Monash Universities, whose hospitalities are gratefully acknowledged. The authors were partly supported by the Australian Research Council under Discovery Grant DP0987734. 
References 
1. M. Ajtai. Generating hard instances of lattice problems (extended abstract). In Proc. of STOC, pages 99–108. ACM, 1996. 
2. J. Alperin-Sheriff and C. Peikert. Circular and KDM security for identity-based encryption. In Proc. of PKC, volume 7293 of LNCS, pages 334–352. Springer, 2012. 
3. B. Applebaum, D. Cash, C. Peikert, and A. Sahai. Fast cryptographic primitives and circular-secure encryption based on hard learning problems. In Proc. of CRYPTO, volume 5677 of LNCS, pages 595–618. Springer, 2009. 
4. J. Blömer and J.-P. Seifert. On the complexity of computing short linearly independent vectors and short bases in a lattice. In Proc. of STOC. ACM, 1999. 
5. D. Boneh and D. M. Freeman. Linearly homomorphic signatures over binary fields and new tools for lattice-based signatures. In Proc. of PKC, volume 6571 of LNCS, pages 1–16. Springer, 2011. 
6. W. Bosma and M. Pohst. Computations with finitely generated modules over Dedekind rings. In Proc. of ISSAC, pages 151–156, 1991. 
7. Z. Brakerski, C. Gentry, and V. Vaikuntanathan. Fully homomorphic encryption without bootstrapping. Cryp-tology ePrint Archive, Report 2011/277, 2011. 
8. Z. Brakerski, A. Langlois, C. Peikert, O. Regev, and D. Stehlé. Classical hardness of learning with errors. In Proc. of STOC, pages 575–584. ACM, 2013. 
9. H. Cohen. Advanced topics in computational number theory. Springer, 2000. 10. C. Fieker and D. Stehlé. Short bases of lattices over number fields. In Proc. of ANTS-IX, volume 6197 of LNCS, 
pages 157–173. Springer, 2010. 11. C. Gentry, C. Peikert, and V. Vaikuntanathan. Trapdoors for hard lattices and new cryptographic constructions. 
In Proc. of STOC, pages 197–206. ACM, 2008. 12. S. D. Gordon, J. Katz, and V. Vaikuntanathan. A group signature scheme from lattice assumptions. In Proc. of 
ASIACRYPT, volume 6477 of LNCS, pages 395–412. Springer, 2010. 13. J. Hoffstein, J. Pipher, and J. H. Silverman. NTRU: A ring-based public key cryptosystem. In Proc. of ANTS-III, 
pages 267–288, 1998. 14. E. Kiltz, K. Pietrzak, D. Cash, A. Jain, and D. Venturi. Efficient authentication from hard learning problems. 
In Proc. of EUROCRYPT, volume 6632 of LNCS. Springer, 2011. 15. V. Lyubashevsky and D. Micciancio. Generalized compact knapsacks are collision resistant. In Proc. of 
ICALP (2), volume 4052 of LNCS, pages 144–155. Springer, 2006. 16. V. Lyubashevsky, C. Peikert, and O. Regev. On ideal lattices and learning with errors over rings. In Proc. of 
EUROCRYPT, LNCS, pages 1–23. Springer, 2010. All result numberings used in the present article correspond to those of the draft of the full version, available at http://eprint.iacr.org/2012/230.pdf. 
17. V. Lyubashevsky, C. Peikert, and O. Regev. A toolkit for Ring-LWE cryptography. In Proc. of EUROCRYPT, volume 7881 of LNCS, pages 35–54. Springer, 2013. 
18. D. Micciancio. Generalized compact knapsacks, cyclic lattices, and efficient one-way functions from worst-case complexity assumptions. In Proc. of FOCS, pages 356–365. IEEE Computer Society Press, 2002. Conference version of [20]. 
28
19. D. Micciancio. Almost perfect lattices, the covering radius problem, and applications to Ajtai’s connection factor. SIAM Journal on Computing, 34(1):118–169, 2004. Preliminary version in STOC 2002. 
20. D. Micciancio. Generalized compact knapsacks, cyclic lattices, and efficient one-way functions. Comput. Com-plexity, 16(4):365–411, 2007. Full version of [18]. 
21. D. Micciancio and S. Goldwasser. Complexity of lattice problems: a cryptographic perspective. Kluwer Academic Press, 2002. 
22. D. Micciancio and C. Peikert. Trapdoors for lattices: Simpler, tighter, faster, smaller, 2011. IACR Cryptology ePrint Archive, report 2011/501. 
23. D. Micciancio and O. Regev. Worst-case to average-case reductions based on Gaussian measure. In Proc. of FOCS, pages 371–381. IEEE, 2004. Conference version of [24]. 
24. D. Micciancio and O. Regev. Worst-case to average-case reductions based on Gaussian measures. SIAM J. Comput, 37(1):267–302, 2007. Full version of [23]. 
25. D. Micciancio and O. Regev. Lattice-based cryptography. In D.J. Bernstein, J. Buchmann, and E. Dahmen, editors, Post Quantum Cryptography, pages 147–191. Springer, 2009. 
26. R. A. Mollin. Algebraic Number Theory. Chapman and Hall/CRC Press, 1999. 27. A. O’Neill, C. Peikert, and B. Waters. Bi-deniable public-key encryption. In Proc. of CRYPTO, volume 6841 of 
LNCS, pages 525–542. Springer, 2011. 28. C. Peikert. Limits on the hardness of lattice problems in `p norms. Comput. Complexity, 2(17):300–351, 2008. 29. C. Peikert. Public-key cryptosystems from the worst-case shortest vector problem. In Proc. of STOC, pages 
333–342. ACM, 2009. 30. C. Peikert. An efficient and parallel gaussian sampler for lattices. In Proc. of CRYPTO, volume 6223 of LNCS, 
pages 80–97. Springer, 2010. 31. C. Peikert and A. Rosen. Efficient collision-resistant hashing from worst-case assumptions on cyclic lattices. In 
Proc. of TCC, volume 3876 of LNCS, pages 145–166. Springer, 2006. 32. C. Peikert and A. Rosen. Lattices that admit logarithmic worst-case to average-case connection factors. In Proc. 
of STOC, pages 478–487. ACM, 2007. 33. K. Pietrzak. Subspace LWE, 2011. Available at http://homepages.cwi.nl/~pietrzak/publications/SLWE.pdf. 34. O. Regev. Lecture notes of lattices in computer science, taught at the Computer Science Tel Aviv University. 
Available at http://www.cims.nyu.edu/~regev/teaching/lattices_fall_2009/index.html. 35. O. Regev. On lattices, learning with errors, random linear codes, and cryptography. In Proc. of STOC, pages 
84–93, 2005. 36. O. Regev. On lattices, learning with errors, random linear codes, and cryptography. J. ACM, 56(6), 2009. Full 
version of [35]. 37. D. Stehlé and R. Steinfeld. Making NTRU as secure as worst-case problems over ideal. lattices. In Proc. of 
EUROCRYPT, volume 6632 of LNCS, pages 27–47. Springer, 2011. 38. D. Stehlé and R. Steinfeld. Making NTRUEncrypt and NTRUSign as secure as standard worst-case problems 
over ideal lattices. Cryptology ePrint Archive, Report 2013/004, 2013. Full version of [37]. 39. D. Stehlé, R. Steinfeld, K. Tanaka, and K. Xagawa. Efficient public key encryption based on ideal lattices. In 
Proc. of ASIACRYPT, volume 5912 of LNCS, pages 617–635. Springer, 2009. 
29