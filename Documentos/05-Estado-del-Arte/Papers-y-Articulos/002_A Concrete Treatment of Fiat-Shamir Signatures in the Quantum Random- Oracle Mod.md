# A Concrete Treatment of Fiat-Shamir Signatures in the Quantum Random- Oracle Model - UvA-DARE (Digital Academic Repository)

- **ID**: `d32bebdc-97a2-4f47-ba9a-316519c0b3cf`
- **Tipo de Fuente**: `SOURCE_TYPE_PDF`
- **URL**: [https://pure.uva.nl/ws/files/45974858/916.pdf](https://pure.uva.nl/ws/files/45974858/916.pdf)

---

## Contenido Extraído / Texto Completo

UvA-DARE is a service provided by the library of the University of Amsterdam (https://dare.uva.nl) 
UvA-DARE (Digital Academic Repository) 
A Concrete Treatment of Fiat-Shamir Signatures in the Quantum Random-Oracle Model 
Kiltz, E.; Lyubashevsky, V.; Schaffner, C. DOI 10.1007/978-3-319-78372-7_18 Publication date 2018 Document Version Author accepted manuscript Published in Advances in Cryptology – EUROCRYPT 2018 
Link to publication 
Citation for published version (APA): Kiltz, E., Lyubashevsky, V., & Schaffner, C. (2018). A Concrete Treatment of Fiat-Shamir Signatures in the Quantum Random-Oracle Model. In J. B. Nielsen, & V. Rijmen (Eds.), Advances in Cryptology – EUROCRYPT 2018: 37th Annual International Conference on the Theory and Applications of Cryptographic Techniques, Tel Aviv, Israel, April 29-May 3, 2018 : proceedings (Vol. 3, pp. 552-586). (Lecture Notes in Computer Science; Vol. 10822). Springer. https://doi.org/10.1007/978-3-319-78372-7_18 
General rights It is not permitted to download or to forward/distribute the text or part of it without the consent of the author(s) and/or copyright holder(s), other than for strictly personal, individual use, unless the work is under an open content license (like Creative Commons). 
Disclaimer/Complaints regulations If you believe that digital publication of certain material infringes any of your rights or (privacy) interests, please let the Library know, stating your reasons. In case of a legitimate complaint, the Library will make the material inaccessible and/or remove it from the website. Please Ask the Library: https://uba.uva.nl/en/contact, or a letter to: Library of the University of Amsterdam, Secretariat, P.O. Box 19185, 1000 GD Amsterdam, The Netherlands. You will be contacted as soon as possible. 
A Concrete Treatment of Fiat-Shamir Signatures in the Quantum Random-Oracle Model 
Eike Kiltz 1 Vadim Lyubashevsky 2 Christian Schaffner 3 
February 20, 2018 
1 Ruhr Universität Bochum eike.kiltz@rub.de 
2 IBM Research – Zurich vad@zurich.ibm.com 
3 QuSoft and ILLC, University of Amsterdam c.schaffner@uva.nl 
Abstract 
The Fiat-Shamir transform is a technique for combining a hash function and an identification scheme to produce a digital signature scheme. The resulting scheme is known to be secure in the random oracle model (ROM), which does not, however, imply security in the scenario where the adversary also has quantum access to the oracle. The goal of this current paper is to create a generic framework for constructing tight reductions in the QROM from underlying hard problems to Fiat-Shamir signatures. 
Our generic reduction is composed of two results whose proofs, we believe, are simple and natural. We first consider a security notion (UF-NMA) in which the adversary obtains the public key and attempts to create a valid signature without accessing a signing oracle. We give a tight reduction showing that deterministic signatures (i.e., ones in which the randomness is derived from the message and the secret key) that are UF-NMA secure are also secure under the standard chosen message attack (UF-CMA) security definition. Our second result is showing that if the identification scheme is “lossy”, as defined in (Abdalla et al. Eurocrypt 2012), then the security of the UF-NMA scheme is tightly based on the hardness of distinguishing regular and lossy public keys of the identification scheme. This latter distinguishing problem is normally exactly the definition of some presumably-hard mathematical problem. The combination of these components gives our main result. 
As a concrete instantiation of our framework, we modify the recent lattice-based Dilithium digital signature scheme (Ducas et al., TCHES 2018) so that its underlying identification scheme admits lossy public keys. The original Dilithium scheme, which is proven secure in the classical ROM based on standard lattice assumptions, has 1.5KB public keys and 2.7KB signatures. The new scheme, which is tightly based on the hardness of the Module-LWE problem in the QROM using our generic reductions, has 7.7KB public keys and 5.7KB signatures for the same security level. Furthermore, due to our proof of equivalence between the UF-NMA and UF-CMA security notions of deterministic signature schemes, we can formulate a new non-interactive assumption under which the original Dilithium signature scheme is also tightly secure in the QROM. 
1 Introduction 
Fiat-Shamir Signatures from Identification Protocols. A canonical identification scheme [AABN02] is a three-move authentication protocol ID of a specific form. The prover (holding the secretkey) sends a commitment W to the verifier. The verifier (holding the public-key) returns a random challenge c. The prover sends a response Z . Finally, using the verification algorithm, the verifier accepts if the transcript (W , c,Z ) is correct. The Fiat-Shamir transformation [FS87, AABN02] combines a canonical identification scheme ID and a hash function H to obtain a digital signature scheme FS = FS[ID,H]. The signing algorithm first iteratively generates a transcript (W , c,Z ), where the challenge c is derived via
ID SS 
FS UF-NMA FS UF-CMA 
ID LOSSY 
Rewinding HVZK 
Figure 1: Known security results of Fiat-Shamir signatures FS = FS[ID,H] in the ROM. Solid arrows denote tight reductions, dashed arrows non-tight reductions. 
c := H(W ‖ M ). Signature σ = (W ,Z) is valid if the transcript (W , c := H(W ‖ M ),Z) makes the verification algorithm accept. Lyubashevsky [Lyu09] further generalized this to the “Fiat-Shamir with aborts” transformation to account for aborting provers. Security of Fiat-Shamir Signatures in the ROM. Security of FS[ID,H] in the ROM can be proved in two steps. Firstly, if the underlying identification scheme has statistical Honest-Verifier Zero-Knowledge (HVZK), then UnForgeability against Chosen Message Attack (UF-CMA) and UnForgeability against No Message Attack (UF-NMA) are tightly equivalent (UF-NMA security means that the adversary is not allowed to make any signing queries). Secondly, the Forking Lemma [PS00, BN06] (based on a technique called “rewinding”) is used to prove UF-NMA security in the random-oracle model (ROM) [BR93] from computational Special Soundness (SS). The latter part of the security reduction is non-tight and the loss in tightness is known to be inherent (e.g., [PV05, KMP16]). Lossy Identification schemes. With the goal of constructing signature schemes with a tight security reduction and generalizing a signature scheme by Katz and Wang [KW03], AFLT [AFLT12] introduced the new concept of lossy identification schemes and proved that Fiat-Shamir transformed signatures have a tight security reduction in the ROM. A lossy identification scheme comes with an additional lossy key generator that produces a lossy public key, computationally indistinguishable from a honestly generated public key. Further, relative to a lossy public key the identification scheme has statistical soundness, i.e., not even an unbounded adversary can successfully impersonate a prover. Figure 1 summarizes the known security results of Fiat-Shamir signatures in the ROM. Quantum Random-Oracle Model. Recently, NIST announced a competition with the goal to standardize new asymmetric encryption and signature schemes [NIS13] with security against quantum adversaries, i.e., adversaries equipped with a quantum computer. There exists a number of (sometimes only implicitly defined) canonical identification schemes (e.g., [Ste94, MV03, Lyu08, KTX08, Lyu09, AFLT12, GLP12, Lyu12, DDLL13, DLP14, BG14, Lyu16, ABB+17, DLL+17]) whose security relies on the hardness of certain problems over lattices and codes, which are generally believed to resist quantum adversaries. Quantum computers may execute all “offline primitives” such as the hash function on arbitrary superpositions, which motivated the introduction of the quantum (accessible) random-oracle model (QROM) [BDF+11]. That is, in the UF-CMA security experiment for signatures in the QROM, an adversary has quantum access to a perfect hash function H and classical access to the signing oracle. Aiding in the construction of UF-CMA secure signatures with provable (post-quantum) security in the QROM is the main motivation of this paper. Security of Fiat-Shamir signatures in the QROM. A number of recent works considered the security of Fiat-Shamir transformed signatures in the QROM. [BDF+11] proved a general result showing that if a reduction in the classical ROM is history-free, then it can also be carried out in the QROM. History-free reductions basically determine random oracle answers independently of the history of previous queries. For reductions that are not history-free, adaptive re-programming of the quantum random oracle is required which is problematic in the QROM: with one single quantum query to all inputs in superposition, an adversary might learn a superposition of all possible random oracle values which essentially means the reduction has to provide plausible values for the whole random oracle at this point. Hence, adaptive reprogramming in the QROM is difficult (but not impossible e.g., [BBBV97, ES15, Unr15]). 
Unfortunately, the known random-oracle proofs of Fiat-Shamir signatures [PS00, AFLT12, KMP16] are not history-free. Beyond the general problem of adaptive re-programming, the classical proof [PS00] uses rewinding and the Forking Lemma, a technique that we currently do not know how to extend to the 
2
quantum setting. Even worse, Ambanis et al. [ARU14] proved that Fiat-Shamir signatures cannot be proven secure in a black-box way by just assuming computational special soundness and HVZK (these two conditions are, on the other hand, sufficient for a proof in the classical ROM.) 
To circumvent the above negative result, Unruh [Unr15] proposed an alternative Fiat-Shamir transformation with provable QROM security but the resulting signatures are considerably less efficient as they require multiple executions of the underlying identification scheme. 
Alkim et. al [ABB+17] gave a concrete tight security reduction for a signature scheme, TESLA, in the QROM. TESLA is a concrete lattice-based digital signature scheme implicitly derived via the Fiat-Shamir transformation. Their QROM proof from the learning with errors (LWE) assumption adaptively re-programs the quantum random oracle using a technique from [BBBV97] and seems tailored to their particular identification protocol. As described in [ABB+17], the intuition behind the QROM security proof for TESLA comes from the fact that the underlying identification scheme is lossy. They leave it as an open problem to prove Fiat-Shamir signatures generically secure from lossy identification schemes. 
Unruh [Unr17a] could prove (among other things) that identification schemes with HVZK and statistical soundness yield UF-CMA secure Fiat-Shamir signatures in the QROM when additionally assuming a “dual-mode hard instance generator” for generating key pairs of the identification scheme. The latter dual mode hard instance generator is very similar to lossy identification schemes. Whereas the original publication [Unr17a] only contains asymptotic proofs, a recently updated version of the full version [Unr17b] also provides concrete security bounds. Below, in Section 1.2, we will compare them with our bounds. 
1.1 Our Results This work contains a simple and modular security analysis in the QROM of signatures FS[ID,H] obtained via the Fiat-Shamir transform with aborts [Lyu09] from any lossy identification scheme ID. We also consider the security of a deterministic variant DFS[ID,H,PRF] with better tightness. DFS derives the randomness for signing deterministically using a pseudo-random function PRF. Our main security statements are summarized in Figure 2. Most importantly, if ID is a lossy identification scheme and has HVZK, then DFS[ID,H,PRF] is tightly UF-CMA secure and FS[ID,H] is (non-tightly) UF-CMA secure in the QROM. Our results suggest to prefer DFS[ID,H,PRF] over FS[ID,H]. 
The main component of our proof is a tweak to the AFLT Fiat-Shamir proof [AFLT12] that makes it history-free. Together with the general result of [BDF+11], one can immediately obtain asymptotic (i.e., non-concrete) versions of our QROM proof as a simple corollary. In this work, we instead give direct proofs with concrete, tight security bounds. 
To demonstrate the efficacy of our generic framework, we construct a lattice-based signature scheme. The most compact lattice-based schemes, in terms of public key and signature sizes, crucially require sampling from a discrete Gaussian distribution [DDLL13, DLP14]. Such schemes, however, have been shown to be particularly vulnerable to side-channel attacks (c.f. [BHLY16, EFGT17]), and it therefore seems prudent to consider schemes that only require simple uniform sampling over the integers. Of those, the most currently efficient one is the Dilithium signature scheme [DLL+17]. This signature scheme is proved secure based on the MSIS (Module-SIS) and the MLWE (Module-LWE) assumptions in the ROM implicitly using the framework from Figure 1. 
In this paper, we provide a practical instantiation of a lossy identification scheme to obtain a new digital signature scheme, Dilithium-QROM, with a tight security reduction in the QROM from the MLWE problem, derived using our new framework from Figure 2. Dilithium-QROM is essentially a less compact variant (≈ 3X larger) of Dilithium with modified parameters to allow the underlying identification scheme to admit a lossy mode. We additionally prove the security of the original Dilithium scheme in the QROM based on MLWE and another non-interactive assumption. 
1.1.1 Security of Fiat-Shamir Signatures 
Security of deterministic Fiat-Shamir signatures DFS[ID,H,PRF] in the QROM is proved in two independent steps, see Figure 2. Step 1: LOSSY =⇒ UF-NMA. We sketch an adaptation of the standard history-free proof implicitly contained in [AFLT12]. By the security properties of the lossy identification scheme, the public key can be set in lossy mode which remains unnoticed by a computationally bounded quantum adversary. 
3
FS UF-CMA1 DFS UF-CMA 
ID LOSSY FS UF-NMA 
FS UF-CMA 
Th. 3.4 
HVZK 
Th. 3.2 
HVZKTh. 3.3 
PRF [BPS16] 
Figure 2: Security of standard Fiat-Shamir signatures FS = FS[ID,H] and deterministic Fiat-Shamir signatures DFS = DFS[ID,H,PRF] in the QROM. Solid arrows denote tight reductions, dashed arrows nontight reductions. The considered security notions are: UF-CMA (unforgeability against chosen-message attack), UF-CMA1 (unforgeability against one-query-per-message chosen-message attack), and UF-NMA (unforgeability against no-message attack). 
Further, breaking the signature scheme in lossy mode with at most QH queries to the quantum random oracle essentially requires to solve the generic quantum search problem, whose complexity is Θ(Q2 
H · εls) [HRS16, Zha12a], where εls is the statistical soundness parameter of ID in lossy mode. A similar argument is implicitly contained in [Unr17a, ABB+17]. Step 2: UF-NMA =⇒ UF-CMA. We will now sketch a history-free proof of UF-NMA⇒ UF-CMA1, where (compared to UF-CMA security) UF-CMA1 security limits the number of queried signatures per message M to one. We then apply a standard (history-free, tight) reduction to show that UF-CMA1 secure signatures de-randomized with a PRF yield UF-CMA secure signatures with deterministic signing [BPS16]. 
The standard ROM proof of UF-NMA⇒ UF-CMA (implicitly contained in [AFLT12]) works as follows: one uses the HVZK property of ID to show that the signing oracle can be efficiently simulated only knowing the public-key. Concretely, the HVZK simulator generates a transcript (W , c,Z ) and later “patches” the random oracle by defining H(W ‖ M ) := c to make (W ,Z) a valid signature. The problem is that the random oracle patching (i.e., defining H(W ‖ M ) := c) can only be done after the signing query on M because only then W and c are known. This renders the AFLT standard reduction non history-free. In our history-free UF-NMA ⇒ UF-CMA1 proof, we resolve this problem as follows. We use the HVZK property to generate the transcript (WM , cM ,ZM ) deterministically using message-dependent randomness. Hence, for each message M , the transcript (WM , cM ,ZM) is unique and can be computed at any time. This uniqueness allows us to patch the random oracle H(W ‖ M ) to cM at any time of the proof (i.e., iff W = WM), even before the adversary has established a signing query on message M . This trick makes the proof history-free, see Theorem 3.2. Clearly, this only works if the adversary receives at most one signature for each messages M , which is guaranteed by the UF-CMA1 experiment. 
In order to deal with (full) UF-CMA security of probabilistic Fiat-Shamir signatures FS[ID,H], the above trick can be adapted to also obtain a history-free reduction, see Theorem 3.3. However, the proof is less tight as the reduction suffers from a quadratic blow-up in its running time. 
Our results furthermore prove strong unforgeability if the identification scheme satisfies an additional property called computational unique response (CUR). CUR essentially says that it is hard to come up with two accepting transcripts with the same commitment and challenge but different responses. 
1.1.2 Dilithium-QROM: A signature scheme with provable security in the QROM 
The digital signature scheme Dilithium [DLL+17] is constructed from a canonical identification scheme using the Fiat-Shamir with aborts approach [Lyu09]. In the ROM, its security is based (via non-tight reductions) on the hardness of the MSIS and MLWE problems. We show that by increasing the size of the modulus and the dimension of the public key matrix, the resulting identification scheme admits a lossy mode such that distinguishing real from lossy keys is based on the hardness of MLWE. We can then apply our main reduction to conclude that the resulting digital signature scheme is based on the hardness of the MLWE problem. 
In order to construct an identification scheme with a lossy mode, in addition to increasing the size of the modulus and the overall dimension, we also choose our prime modulus q so that the underlying ring Zq[X ]/(Xn + 1) has the property that all elements with coefficients less than 
√ q/2 have an inverse 
4
[LN17] – having all small elements be invertible is crucial to having lossiness.1 For the same security levels as Dilithium, the total size of the public key and signature is increased by a factor of a little over 3. 
1.1.3 Revisiting the Security of Dilithium 
Due to the way the parameters are set, the underlying identification scheme of the original Dilithium scheme does not have a lossy mode, and so we cannot apply Theorem 3.4 in the reduction sequence in Figure 2. Nevertheless, the reduction from Theorem 3.2 is still applicable. In the classical ROM, one then obtains a reduction from MSIS to the UF-NMA scheme via the forking lemma (see Figure 1). 
The main downside of this last step is that the reduction is inherently non-tight. In practice, however, parameters are set based on the hardness of the underlying MSIS problem and the non-tightness of the reduction is ignored. This is not just the case in lattice-based schemes, but is the prevalent practice for every signature scheme built via the Fiat-Shamir transform. The implicit assumption is, therefore, that the UF-NMA scheme is exactly as secure as MSIS (assuming that H is secure). We point out that the assumption that the UF-NMA scheme is secure is a non-interactive assumption that is reasonably simple to state, and so the fact that several decades of cryptanalysis haven’t produced any improved attacks against schemes whose parameters ignore the non-tightness of the reduction, gives us confidence that equating the hardness of the UF-NMA scheme with the hardness of the underlying problem is very reasonable. 
In Section 4.5, we formulate the security of the UF-NMA scheme as a “convolution” of a lattice/hash function problem, which we call SelfTargetMSIS, and then show that based on the hardness of MLWE and SelfTargetMSIS, the deterministic version of the Dilithium scheme is (tightly) UF-CMA secure in the QROM. In other words, we show that the security of the tight version of the signature scheme is based on exactly the same assumptions in the ROM and the QROM. 
1.1.4 Other Instantiations 
Our framework can be applied to obtain a security proof in the QROM for a number of existing Fiat-Shamir signature schemes that are similar to Dilithium (e.g., [Lyu09, AFLT12, GLP12, Lyu12, BG14, Lyu16, ABB+17]) and those that have a somewhat different structure and possibly based on different assumptions (e.g., [KTX08, SSH11, DDLL13]). Our rationale for setting the parameters in Dilithium-QROM was to minimize the total sum of the public key and the signature. If one, on the other hand, wished to only minimize the signature size, one could create a public key whose “height” is larger than its “width” (e.g., as in [ABB+17]). For optimal efficiency, this may possibly require working over polynomial rings Zq[X ]/(f (x)) which are finite fields. 
1.2 Concrete Bounds and Comparison with Unruh [Unr17a, Unr17b] Ignoring all constants and the computational term accounting for the pseudo-random function, our concrete bound for the UF-CMA security of deterministic Fiat-Shamir signatures DFS in the QROM is 
AdvUF-CMA DFS (A) ≤ AdvLOSS 
ID (B) + Q2 H · εls + QS · εzk + 2−α, Time(B) ≈ Time(A) (1) 
where AdvLOSS ID (B) is the lossyness advantage of ID, εls is the statistical soundness parameter of ID in 
lossy mode, α is the min-entropy of ID’s commitments, and εzk is the HVZK parameter of ID. From Unruh [Unr17b] one can derive the following concrete bound which even holds for (standard) 
probabilistic Fiat-Shamir signatures FS. 
AdvUF-CMA FS (A) ≤ AdvLOSS 
ID (B) + Q2 H · εls + QS · εzk + QSQ1/2 
H · 2−α/4, 
Time(B) ≈ Time(A) + QHQS . (2) 
Compared to (1), bound (2) has two sources of non-tightness. The first source of non-tightness in (2) is the term QSQ1/2 
H · 2−α/4 which stems from a generic re-programming technique from [Unr15]. In most practical lattice-based schemes the commitment’s min-entropy α is large enough not to make a big impact on the worse bounds. However, this term puts a 
1There do not exist q for which Zq [X ]/(Xn + 1) is a field. 
5
lower bound on the min-entropy of commitments which translates to an unnatural lower bound on the size of quantum-resistant Fiat-Shamir signatures. Furthermore, it is sometimes not that easy to exactly compute the min-entropy α. Further, simple techniques to get a“good-enough” bound (as we did for regular Dilithium when we obtained α = 255) would no longer result in something meaningful when used with (2). 
The second and more important sources of non-tightness in (2) is the quadratic (in the number of queries) blow-up in the running time Time(B) ≈ Time(A) + QHQS which renders the reduction non-tight in all practical aspects. Interestingly, our proof for the security of probabilistic Fiat-Shamir signatures (Theorem 3.3) introduces the same source of non-tightness. However, under the assumption that superposition queries to classical data can be performed in a single time step (denoted by QRAM in [Unr17b]), the running time in (2) drops to Time(B) ≈ Time(A) and hence the reduction is tight again. We leave it as an open problem to come up with a tight reduction for probabilistic Fiat-Shamir signatures in the QROM without using QRAM. 
2 Preliminaries For n ∈ N, let [n] := {1, . . . , n}. For a set S , |S | denotes the cardinality of S. For a finite set S , we denote the sampling of a uniform random element x by x ← S , while we denote the sampling according to some distribution D by x ← D. By JBK we denote the bit that is 1 if the Boolean Statement B is true, and 0 otherwise. Algorithms. Let A be an algorithm. Unless stated otherwise, we assume all our algorithms to be probabilistic. We denote by y ← A(x) the probabilistic computation of algorithm A on input x. If A is deterministic, we write y := A(x). The notation y ∈ A(x) is used to indicate all possible outcomes y of the probabilistic algorithm A on input x. We can make any probabilistic A deterministic by running it with fixed randomness. We write y := A(x; r) to indicate that A is run on input x with randomness r . Finally, the notation A(x)⇒ y denotes the event that A on input x returns y. Games. Following [Sho04, BR06], we use code-based games. We implicitly assume boolean flags to be initialized to false, numerical types to 0, sets to ∅, and strings to the empty string ε. We make the convention that a procedure terminates once it has returned an output. 
2.1 Quantum Computation 
Quantum States. The state of a qubit |φ〉 is described by a two-dimensional complex vector |φ〉 = α|0〉+ β|1〉 where {|0〉, |1〉} form an orthonormal basis of C2 and α, β ∈ C with |α|2 + |β|2 = 1 are called the complex amplitudes of |φ〉. The qbit |φ〉 is said to be in superposition if 0 < |α| < 1. A classical bit b ∈ {0, 1} is naturally encoded as state |b〉 of a qubit. 
The state |ψ〉 of n qubits can be expressed as |ψ〉 = ∑ 
x∈{0,1}n αx |x〉 ∈ C2n where {αx}x∈{0,1}n 
is a set of 2n complex amplitudes such that ∑ 
x∈{0,1}n |αx |2 = 1. As for one qubit, the standard orthonormal or computational basis is given by {|x〉}x∈{0,1}n . When the quantum state |ψ〉 is measured in the computational basis, the outcome is the classical string x ∈ {0, 1}n with probability |αx |2 and the quantum state collapses to what is observed, namely |x〉. 
The evolution of a quantum system in state |ψ〉 can be described by a linear length-preserving transformation U : C2n → C2n . Such transformations correspond to unitary matrices U of size 2n by 2n, i.e. U has the property that UU † = 1, where U † is the complex-conjugate transpose of U . 
For further details about basic concepts and notation of quantum computing, we refer to the standard text book by Nielsen and Chuang [NC00]. Quantum oracles and quantum Adversaries. For a classical oracle function O : {0, 1}n → {0, 1}m , we follow the standard approach as in [BBC+98, BDF+11] to make the execution of the classical function O a reversible unitary transformation. We model quantum access to O by 
UO : |x〉|y〉 7→ |x〉|y ⊕O(x)〉 , 
where x ∈ {0, 1}n and y ∈ {0, 1}m. Note that due to the XOR function in the second register, UO is 
6
its own inverse, i.e. executing UO twice results in the identity for any function O.2 Quantum oracle adversaries A|O〉 can access O in superposition by applying UO. The quantum time it takes to apply UO is linear in the time it takes to evaluate O classically. We write A|O〉 to indicate that an oracle is quantum-accessible, contrary to oracles which can only be accessed classically which are denoted by AO. We also abuse notation and use |O〉 to denote the oracle that is quantumly accessible. Quantum random-oracle model. We consider security games in the quantum random-oracle model (QROM) [BDF+11] like their counterparts in the classical random-oracle model [BR93], with the difference that we consider quantum adversaries that are given quantum access to the random oracles involved, and classical access to all other oracles (e.g., the signing oracle). Zhandry [Zha12b] proved that no quantum algorithm A|H〉, issuing at most Q quantum queries to |H〉, can distinguish between a random function H : {0, 1}m → {0, 1}n and a 2Q-wise independent function f2Q. For concreteness, we view f2Q : {0, 1}m → {0, 1}n as a random polynomial of degree 2Q over the finite field F2n . The running time to evaluate f2Q is linear in Q. 
In this article, we will use this observation in the context of security reductions, where quantum adversary B simulates quantum adversary A|H〉 which makes at most Q queries to |H〉. Hence, the running time of B is Time(B) = Time(A) + q ·Time(H), where Time(H) is the time it takes to simulate |H〉. Using the observation above, B can use a 2Q-wise independent function in order to (information-theoretically) simulate |H〉 and we obtain that the running time of B is Time(B) = Time(A) + Q · Time(f2Q), and the time Time(f2Q) to evaluate f2Q is linear in Q. The second term of this running time (quadratic in Q) can be further reduced to linear in Q in the quantum random-oracle model where B can simply use another random oracle to simulate |H〉. Assuming evaluating the random oracle takes one time unit, we write Time(B) = Time(A) + Q which is approximately Time(A). Generic Quantum Search. For λ ∈ [0, 1] let Bλ be the Bernoulli distribution, i.e., Pr[b = 1] = λ for the bit b ← Bλ. Let X be some finite set. The generic quantum search problem GSP [HRS16, Zha12a] is to find an x ∈ X satisfying g(x) = 1 given quantum access to an oracle g : X → {0, 1}, such that for each x ∈ X , g(x) is distributed according to Bλ. We will need the following slight variation of GSP. The Generic quantum Search Problem with Bounded probabilities GSPB is like the quantum search problem with the difference that the Bernoulli parameter λ(x) may (adversarially) depend on x but it is upper bounded by a global λ. 
Lemma 2.1 (Generic Search Problem with Bounded Probabilities) Let λ ∈ [0, 1]. For any (unbounded, quantum) algorithm A issuing at most Q quantum queries to |g〉, Pr[GSPBA 
λ ⇒ 1] ≤ 8 · λ · (Q + 1)2, where Game GSPBλ is defined in Figure 3. 
GAME GSPBλ 01 (λ(x))x∈X ← A1 02 If ∃x ∈ X s.t. λ(x) > λ then return 0 03 For all x ∈ X : g(x)← Bλ(x) 
04 x ← A|g〉2 05 return g(x) 
Figure 3: The generic search game GSPBλ with bounded maximal Bernoulli parameter λ ∈ [0, 1]. 
The bound on GSPB can be reduced to the known bound on GSP [HRS16, Zha12a] by artificially increasing the Bernoulli parameter to obtain the dependence on each x ∈ X . Proof details are given in Appendix A.1. 
2.2 Pseudorandom Functions A pseudorandom function PRF is a mapping PRF : K × {0, 1}n → {0, 1}k , where K is a finite key space and n, k are integers. To a quantum adversary A and PRF we associate the advantage function 
AdvPR PRF(A) := 
∣∣Pr[APRF(K,·) ⇒ 1 | K ← K]− Pr[ARF(·) ⇒ 1] ∣∣, 
2Together with the observation that taking the conjugate-complex and transposing UO do not change UO, we obtain U†O = UO, and hence, UOU†O = U2 
O = 1, showing that UO is indeed a unitary transformation. 
7
Prover P(sk) Verifier V(pk) (W ,St)← P1(sk) 
c ← ChSet Z ← P2(sk,W , c,St) 
d = V(pk,W , c,Z ) ∈ {0, 1} 
W c Z 
Figure 4: A canonical identification scheme and its transcript (W , c,Z ). 
where RF : {0, 1}n → {0, 1}k is a perfect random function. We note that while adversary A is quantum, it only gets classical access to the oracles PRF(K , ·) and RF(·). 
2.3 Canonical Identification Schemes A canonical identification scheme ID is a three-move protocol of the form depicted in Figure 4. The prover’s first message W is called commitment, the verifier selects a uniform challenge c from set ChSet, and, upon receiving a response Z from the prover, makes a deterministic decision. 
Definition 2.2 (Canonical Identification Scheme). A canonical identification scheme ID is defined as a tuple of algorithms ID := (IGen,P,ChSet,V). 
 The key generation algorithm IGen takes system parameters par as input and returns public and secret key (pk, sk). We assume that pk defines ChSet (the set of challenges), WSet (the set of commitments), and ZSet (the set of responses). 
 The prover algorithm P = (P1,P2) is split into two algorithms. P1 takes as input the secret key sk and returns a commitment W ∈ WSet and a state St; P2 takes as input the secret key sk, a commitment W , a challenge c, and a state St and returns a response Z ∈ ZSet ∪ {⊥}, where ⊥ 6∈ ZSet is a special symbol indicating failure. 
 The verifier algorithm V takes the public key pk and the conversation transcript as input and outputs a deterministic decision, 1 (acceptance) or 0 (rejection). 
We make a couple of useful definitions. A transcript is a three-tuple (W , c,Z) ∈ WSet × ChSet × ZSet ∪ {⊥,⊥,⊥}. It is called valid (with respect to public-key pk) if V(pk,W , c,Z) = 1. In Figure 5 we also define a transcript oracle Trans that returns a real interaction (W , c,Z) between prover and verifier as depicted in Figure 4, with the important convention that the transcript is defined as (⊥,⊥,⊥) if Z = ⊥. 
Algorithm Trans(sk): 01 (W ,St)← P1(sk) 02 c ← ChSet 03 Z ← P2(sk,W , c,St) 04 if Z = ⊥ then return (⊥,⊥,⊥) 05 return (W , c,Z) 
Figure 5: An honestly generated transcript (W , c,Z ) output by the transcript oracle Trans(sk). 
Definition 2.3 (Correctness Error). Identification scheme ID has correctness error δ if for all (pk, sk) ∈ IGen(par) the following holds: 
 All possible transcripts (W , c,Z) satisfying Z 6= ⊥ are valid, i.e., for all (W ,St) ∈ P1(sk), all c ∈ ChSet and all Z ∈ P2(sk,W , c,St) with Z 6= ⊥, we have V(pk,W , c,Z ) = 1. 
 The probability that an honestly generated transcript (W , c,Z ) contains Z = ⊥ is bounded by δ, i.e., Pr[Z = ⊥ | (W , c,Z )← Trans(sk)] ≤ δ. 
8
Definition 2.4 We call ID commitment-recoverable, if for any (pk, sk) ∈ IGen(par), c ∈ ChSet, and Z ∈ ZSet, there exists a unique W ∈WSet such that V(pk,W , c,Z ) = 1. This unique W can be publicly computed using a commitment recovery algorithm as W := Rec(pk, c,Z ). 
We define no-abort honest-verifier zero-knowledge, a weak variant of honest-verifier zero-knowledge that requires the transcript (as generated by Trans(sk)) to be publicly simulatable, conditioned on Z 6= ⊥. 
Definition 2.5 (No-Abort Honest-verifier Zero-knowledge). A canonical identification scheme ID is said to be εzk-perfect naHVZK (no-abort honest-verifier zero-knowledge) if there exists an algorithm Sim that, given only the public key pk, outputs (W , c,Z ) such that the following conditions hold: 
 The distribution of (W , c,Z) ← Sim(pk) has statistical distance at most εzk from (W ′, c′,Z ′) ← 
Trans(sk), where Trans is defined in Figure 5. 
 The distribution of c from (W , c,Z )← Sim(pk) conditioned on c 6= ⊥ is uniform random in ChSet. 
Note that if ID is commitment-recoverable, then we can abandon the W in the output of Trans and Sim since W can be publicly computed from (c,Z ). 
Definition 2.6 (Min-Entropy). If the most likely value of a random variable W that is chosen from a discrete distribution D occurs with probability 2−α, then we say that min-entropy(W |W ← D) = α. We will say that a canonical identification scheme ID has α bits of min-entropy, if 
Pr (pk,sk)←IGen(par) 
[min-entropy(W | (W ,St)← P1(sk)) ≥ α] ≥ 1− 2−α. 
In other words, except with probability 2−α over the choice of (pk, sk), the min-entropy of W will be at least α. 
An identification scheme has unique responses if for all W and c there exists at most one Z to make the verifier accept, i.e., V(pk,W , c,Z) = 1. We relax this property to computational unique response (CUR) for which we require it to be computationally difficult to come up with (W , c,Z ,Z ′) with V(pk,W , c,Z ) = V(pk,W , c,Z ′) = 1 and Z ′ 6= Z . 
Definition 2.7 (Computational Unique Response). To an adversary A we associate the advantage function 
AdvCUR ID (A) := Pr 
[ V(pk,W , c,Z ) = 1 V(pk,W , c,Z ′) = 1 ∧ Z 6= Z ′ 
∣∣∣∣(pk, sk)← IGen(par); (W , c,Z ,Z ′)← A(pk) 
] . 
Lossy Identification schemes. We now recall lossy identification schemes [AFLT12]. 
Definition 2.8 An identification scheme ID = (IGen,P,ChSet,V) is lossy if there exists a lossy key generation algorithm LossyIGen that takes system parameters par as input and returns public key pk ls (and no secret key sk). 
We refer to LID = (IGen, LossyIGen,P,ChSet,V) as a lossy identification scheme. We now define two security properties of a lossy identification scheme LID. The first property says 
that public keys generated with the real key generator IGen are indistinguishable from ones generated by the lossy key generator LossyIGen. Concretely, we define the LOSS advantage function of a quantum adversary A against ID as 
AdvLOSS LID (A) := 
∣∣Pr[A(pk ls)⇒ 1 | pk ls ← LossyIGen(par)]− Pr[A(pk)⇒ 1 | (pk, sk)← IGen(par)] ∣∣. 
The second security property is statistical and says that relative to a lossy key pk ls, not even an unbounded quantum adversary can impersonate the prover. We say that ID has εls-lossy soundness if for every (possibly unbounded, quantum) adversary C, Pr[LOSSY-IMPC ⇒ 1] ≤ εls, where game LOSSY-IMP is defined in Figure 6. 
Since C is unbounded, we can upper bound Pr[LOSSY-IMPC ⇒ 1] as 
Pr[LOSSY-IMPC ⇒ 1] ≤ E [ 
max W∈WSet 
( Pr 
c←ChSet [∃Z ∈ ZSet : V(pk ls,W , c,Z ) = 1] 
)] , (3) 
where the expectation is taken over pk ls ← LossyIGen(par). Note that equality in Equation (3) is achieved for the “optimal” adversary C which on the “easiest” commitment W ∈WSet and a random challenge c ← ChSet finds a response Z ∈ ZSet that the verifier accepts. 
9
GAME LOSSY-IMP: 01 pk ls ← LossyIGen(par) 02 (W ∗,St)← C(pk ls) 03 c∗ ← ChSet 04 Z∗ ← C(St, c∗) 05 return JV(pk ls,W ∗, c∗,Z∗)K 
Figure 6: The lossy impersonation game LOSSY-IMP. 
2.4 Digital Signatures We now define syntax and security of a digital signature scheme. Let par be common system parameters shared among all participants. 
Definition 2.9 (Digital Signature). A digital signature scheme SIG is defined as a triple of algorithms SIG = (Gen,Sign,Ver). 
 The key generation algorithm Gen(par) returns the public and secret keys (pk, sk). We assume that 
pk defines the message space MSet. 
 The signing algorithm Sign(sk,M ) returns a signature σ. 
 The deterministic verification algorithm Ver(pk,M , σ) returns 1 (accept) or 0 (reject). 
Signature scheme SIG has correctness error γ if for all (pk, sk) ∈ Gen(par), all messages M ∈ MSet, we have Pr[Ver(pk,M ,Sign(sk,M )) = 0] ≤ γ. Security. We define the UF-CMA (unforgeability against chosen-message attack), UF-CMA1 (unforgeability against one-per-message chosen-message attack), and UF-NMA (unforgeability against no-message attack) advantage functions of a quantum adversary A against SIG as AdvUF-CMA 
SIG (A) := Pr[UF-CMAA ⇒ 1], AdvUF-CMA1 
SIG (A) := Pr[UF-CMA1 A ⇒ 1], and AdvUF-NMA 
SIG (A) := Pr[UF-NMAA ⇒ 1], where the games UF-CMA, UF-CMA1, and UF-NMA are given in Figure 7. We also consider strong unforgeability where the adversary may return a forgery on a message previously queried to the signing oracle, but with a different signature. In the corresponding experiments sUF-CMA and sUF-CMA1, the setM contains tuples (M , σ) and for the winning condition it is checked that (M ∗, σ∗) 6∈ M. 
GAMES UF-CMA/UF-CMA1/UF-NMA: 01 (pk, sk)← Gen(par) 02 (M∗, σ∗)← ASign(pk) UF-CMA 03 (M∗, σ∗)← ASign1 (pk) UF-CMA1 04 (M∗, σ∗)← A(pk) UF-NMA 05 return JM∗ 6∈ MK ∧ Ver(pk,M∗, σ∗) 
Sign(M ) 06 M =M∪ {M} 07 σ ← Sign(sk,M ) 08 return σ 
Sign1(M ) 09 if M ∈M then return ⊥ 10 M =M∪ {M} 11 σ ← Sign(sk,M ) 12 return σ 
Figure 7: Games UF-CMA, UF-CMA1, and UF-NMA. 
Any UF-CMA1 (sUF-CMA1) secure signature scheme can be combined with a pseudo-random function PRF to obtain an UF-CMA (sUF-CMA) secure signature scheme by defining Sign′((sk,K),M ) := Sign(sk,M ; PRFK (M )), where K is a secret PRF key which is part of the secret key. This construction is well known in the classical setting [BPS16], and the same proof works in the quantum setting. Here PRF only has to provide security against quantum adversaries where the access to PRF is classical. 
3 Fiat-Shamir in the Quantum Random-Oracle Model 3.1 Signatures from Identification Schemes Let ID := (IGen,P,ChSet,V) be a canonical identification scheme, let κm be a positive integer, and let H : {0, 1}∗ → ChSet be a hash function. The following signature scheme SIG := (Gen = IGen,Sign,Ver) is obtained by the Fiat-Shamir transformation with aborts FS[ID,H, κm] [Lyu09]. 
10
Sign(sk,M ) 01 κ := 0 02 while Z = ⊥ and κ ≤ κm do 03 κ := κ+ 1 04 (W ,St)← P1(sk) 05 c = H (W ‖ M ) 06 Z ← P2(sk,W , c,St) 07 if Z = ⊥ return σ = ⊥ 08 return σ = (W ,Z) 
Ver(pk,M , σ) 09 Parse σ = (W ,Z) ∈WSet× ZSet 10 c = H(W ‖ M ) 11 return V(pk,W , c,Z) ∈ {0, 1} 
We make the convention that if σ = (W ,Z ) is not in WSet× ZSet, then Ver(pk,M , σ) returns 0 (reject). Clearly, if ID has correctness error δ, then SIG has correctness error γ = δκm . Fiat-Shamir for Commitment-Recoverable Identification. For commitment-recoverable ID (see Definition 2.4), we can define an alternative Fiat-Shamir transformation SIG′ = FS′[ID,H, κm] := (Gen = IGen,Sign′,Ver′). Algorithm Sign′(sk,M ) is defined as Sign(sk,M ) with the modified output σ′ = (c,Z). Algorithm Ver′(pk,M , σ′) first parses σ′ = (c,Z), then recomputes the commitment as W ′ := Rec(pk, c,Z ), and finally returns 1 iff H(W ′ ‖ M ) = c. 
Sign′(sk,M ) 01 κ := 0 02 while Z = ⊥ and κ ≤ κm do 03 κ := κ+ 1 04 (W ,St)← P1(sk) 05 c = H(W ‖ M ) 06 Z ← P2(sk,W , c,St) 07 if Z = ⊥ return σ′ = ⊥ 08 return σ′ = (c,Z) 
Ver′(pk,M , σ′) 09 Parse σ′ = (c,Z) ∈ ChSet× ZSet 10 W ′ := Rec(pk, c,Z) 11 return JH(W ′ ‖ M ) = cK 
Since σ = (W ,Z ) can be publicly transformed into σ′ = (c,Z ) and vice versa, SIG and SIG′ are equivalent in terms of security. The alternative Fiat-Shamir transform yields shorter signatures if c ∈ ChSet has a smaller representation size than the commitment W ∈WSet. Main Security Statement. The following is our main security statement for SIG := FS[ID,H, κm] in the QROM. Theorem 3.1 Assume the identification scheme ID is lossy, εzk-perfect naHVZK, has α bits of min entropy, and is εls-lossy sound. For any quantum adversary A against UF-CMA1 (sUF-CMA1) security that issues at most QH queries to the quantum random oracle |H〉 and QS classical queries to the signing oracle Sign1, there exists a quantum adversary B (and a quantum adversary C against CUR) such that 
AdvUF-CMA1 SIG (A) ≤ AdvLOSS 
ID (B) + 8(QH + 1)2 · εls + κmQS · εzk + 2−α+1 , 
AdvsUF-CMA1 SIG (A) ≤ AdvLOSS 
ID (B) + 8(QH + 1)2 · εls + κmQS · εzk + 2−α+1 + AdvCUR ID (C) , 
and Time(B) = Time(C) = Time(A) + κmQH ≈ Time(A). Note that with this observation the bound of Theorem 3.1 is tight, i.e., the computational advantages 
appear with a constant factor (one). In the classical ROM setting, the only difference is that the bound depends linearly on QH, instead of quadratic. Deterministic Fiat-Shamir. Let PRF be a pseudo-random function. Consider a deterministic variant DSIG := DFS[ID,H,PRF, κm] = (Gen,DSign,Ver) of FS where lines 04 and 06 of Sign is derandomized using the PRF, where the random key K is part of the secret key. 
DSign((sk,K),M ) 01 κ := 0 02 while Z = ⊥ and κ ≤ κm do 03 κ := κ+ 1 04 (W ,St) := P1(sk; PRFK (0 ‖ m ‖ κ)) 05 c = H(W ‖ M ) 06 Z := P2(sk,W , c,St; PRFK (1 ‖ m ‖ κ)) 07 if Z = ⊥ return σ = ⊥ 08 return σ = (W ,Z) 
11
As discussed at the end of Section 2.4, the UF-CMA (sUF-CMA) security of DSIG is implied by the UF-CMA1 (sUF-CMA1) security of FS. Concretely the advantages are upper bounded by the same terms as in Theorem 3.1 plus an additional term AdvPR 
PRF(D) accounting for the quantum security of the PRF. 
AdvUF-CMA DSIG (A) ≤ AdvLOSS 
ID (B) + 8 · (QH + 1)2 · εls + AdvPR PRF(D) + κmQS · εzk + 2−α+1 
AdvsUF-CMA DSIG (A) ≤ AdvLOSS 
ID (B) + 8 · (QH + 1)2 · εls + AdvPR PRF(D) + κmQS · εzk + 2−α+1 + AdvCUR 
ID (C) 
3.2 Security proof The proof of Theorem 3.1 is modular. First, in Theorem 3.2 we prove that UF-NMA security plus naHVZK implies UF-CMA1 security. Second, in Theorem 3.4 we prove that a lossy identification scheme is always UF-NMA secure. 
3.2.1 From UF-NMA to UF-CMA1 
Theorem 3.2 Assume the identification scheme ID is εzk-perfect naHVZK and has α bits of min entropy. For any UF-CMA1 (sUF-CMA1) quantum adversary A that issues at most QH queries to the quantum random oracle |H〉 and QS (classical) queries to the signing oracle Sign1, there exists a quantum adversary B against UF-NMA security making QH queries to its own quantum random oracle (and a quantum adversary C against CUR) such that 
AdvUF-CMA1 SIG (A) ≤ AdvUF-NMA 
SIG (B) + 2−α+1 + κmQS · εzk 
AdvsUF-CMA1 SIG (A) ≤ AdvUF-NMA 
SIG (B) + 2−α+1 + AdvCUR ID (C) + κmQS · εzk , 
and Time(B) = Time(C) = Time(A) + κm(QH + QS) ≈ Time(A). 
Proof of Theorem 3.2. We first prove standard unforgeability (UF-CMA1 security) and then show how the proof can be modified to obtain strong unforgeability (sUF-CMA1 security). Let A be a quantum adversary against the UF-CMA1 security of SIG, issuing at most QH queries to |H〉 and at most QS queries to Sign1. Consider the games given in Figure 8. Recall that A has classical access to the signing oracle Sign1 and quantum access to the random oracle H. The quantum random oracle H is called with |W ‖ M 〉 and returns |H(|W ‖ M 〉)〉. The games in Figure 8 describe the computation that is performed for any W ‖ M that has a non-zero amplitude in |W ‖ M 〉. 
GAME G0-G2 01 (pk, sk)← IGen(par) 02 (M∗, σ∗)← A|H〉,Sign1 (pk) 03 Parse σ∗ = (W ∗,Z∗) 04 c∗ := H(W ∗ ‖ M∗) 05 if c∗ 6= H′(W ∗ ‖ M∗) then return 0 G2 06 return JM∗ 6∈ MK ∧ V(pk,W ∗, c∗,Z∗) 
GetTrans(M ) G0 07 κ := 0 08 while ZM = ⊥ and κ ≤ κm do 09 κ := κ+ 1 10 (WM ,St) := P1(sk; RF(0 ‖ M ‖ κ)) 11 cM := H(WM ‖ M ) 12 ZM := P2(sk,WM , cM ,St; RF(1 ‖ M ‖ κ)) 13 if ZM = ⊥ then (WM , cM ,ZM ) = (⊥,⊥,⊥) 14 return (WM , cM ,ZM ) 
Sign1(M ) 15 if M ∈M then return ⊥ 16 M =M∪ {M} 17 (WM , cM ,ZM ) := GetTrans(M ) 18 return σM := (WM ,ZM ) 
H(W ‖ M ) quantum access 19 (WM , cM ,ZM ) := GetTrans(M ) G1-G2 20 if W = WM then return c := cM G1-G2 21 return c := H′(W ‖ M ) 
GetTrans(M ) G1-G2 22 κ := 0 23 while ZM = ⊥ and κ ≤ κm do 24 κ := κ+ 1 25 (WM , cM ,ZM ) := Sim(pk; RF(M ‖ κ)) 26 if ZM = ⊥ then (WM , cM ,ZM ) = (⊥,⊥,⊥) 27 return (WM , cM ,ZM ) 
Figure 8: Games G0,G1,G2 for the proof of Theorem 3.2. Here RF and H′ are perfect random function that cannot be accessed by A. Deterministic algorithm GetTrans(M ) is only used internally and cannot be accessed by A. 
12
Game G0. Note that game G0 is the original UF-CMA1 game. The signing oracle Sign1 produces a signature using internal deterministic algorithm GetTrans which, in lines 10 and 12, derives the randomness of P1 and P2 using a perfect random function RF that cannot be accessed by A. Since in the UF-CMA1 game only one single signing query is allowed per message, 
Pr[GA 0 ⇒ 1] = AdvUF-CMA1 
SIG (A) . 
Game G1. This game computes the signatures on M using the naHVZK simulation algorithm Sim and patches the quantum random oracle H accordingly. 
Concretely, consider a classical query Sign1(M ) and let κM be the smallest integer 1 ≤ κ ≤ κm satisfying (W , c,Z ) := Sim(pk; RF(M ‖ κ)) and Z 6= ⊥. If no such integer exists, then we define κM := ⊥. It deterministically computes 
(WM , cM ,ZM ) := GetTrans(M ) = { 
Sim(pk; RF(M ‖ κM )) 1 ≤ κM ≤ κm 
(⊥,⊥,⊥) κM = ⊥ (4) 
The signature on M is returned as σM := (WM ,ZM ). 
By the naHVZK property and the union bound, the distribution of each σM has statistical distance at most κmεzk from one computed in game G0. To ensure that σM is a valid signature on M , in line 20 the random oracle is patched such that H(WM ‖ M ) = cM holds. Concretely, a query W ‖ M to quantum random oracle H with non-zero amplitude is patched with H(W ‖ M ) := cM iff W = WM , where cM and WM are computed by GetTrans(M ), see Equation (4). Note that the output distribution of the random oracle H in this game remains unchanged since cM generated by the naHVZK simulator Sim is required to be uniformly distributed. 
Overall, by a union bound we obtain 
|Pr[GA 1 ⇒ 1]− Pr[GA 
0 ⇒ 1]| ≤ κmQS · εzk . 
Game G2. This game returns 0 in line 05 if c∗ 6= H′(W ∗ ‖ M ∗). Games G1 and G2 can only differ if WM∗ = W ∗ and M ∗ 6∈ M. (In that case G2 returns 0 and G1 returns 1.) Since M ∗ 6∈ M, the random variable WM∗ was not yet revealed as part of an established signature and is completely hidden from the view of the adversary. It has α bits of min-entropy, meaning we have Pr[WM∗ = W ∗] ≤ 2−α. We obtain 
|Pr[GA 2 ⇒ 1]− Pr[GA 
1 ⇒ 1]| ≤ 2−α+1 . 
Consider adversary B against the UF-NMA game from Figure 9 having quantum access to random oracle H′. It perfectly simulates A’s view in game G2, using its own random oracle H′ to simulate H′ and perfectly simulating the random function RF with a 2κmQH-wise independent hash function. Assume A’s forgery (M ∗, σ∗) is valid in game G2, i.e., M ∗ 6∈ M and V(pk,W ∗, c∗,Z∗) = 1, where c∗ = H(W ∗ ‖ M ∗). If H(W ∗ ‖ M ∗) = H′(W ∗ ‖ M ∗), then (M ∗, σ∗) is also a valid forgery in the UF-NMA game, i.e., V(pk,W ∗, c∗,Z∗) = 1, where c∗ = H′(W ∗ ‖ M ∗). Hence, 
Pr[GA 2 ⇒ 1] = AdvUF-NMA 
SIG (B) . 
The proof of UF-CMA1 security follows by collecting the probabilities. The running time Time(B) of adversary B is given by the time Time(A) to run A as a blackbox in game G2 where in every of the QH oracle- and QS signature-queries, at most O(κm) computations need to be performed. Strong unforgeability. For sUF-CMA1 security we consider exactly the same games with the difference that in all games the winning condition in line 06 is changed to J(M ∗, σ∗) 6∈ MK ∧ V(pk,W ∗, c∗,Z∗) to account for strong unforgerability, whereM now records all tuples (M , σM) of previously established messages/signature pairs. 
The difference between games G1 and G2 is that game G2 returns 0 in line 05 if c∗ 6= H′(W ∗ ‖ M ∗), i.e., if H(W ∗ ‖ M ∗) was previously patched in line 20 with H(W ∗ ‖ M ∗) := cM∗ . Games G1 and G2 can only differ if WM∗ = W ∗, (M ∗, σ∗) 6∈ M, and V(pk,W ∗, c∗,Z∗) = 1. (In that case G2 returns 0 and G1 returns 1.) 
13
Adversary B|H ′〉(pk) 
01 (M∗, σ∗)← A|H〉,Sign1 (pk) 02 Parse σ∗ = (W ∗,Z∗) 03 c∗ := H(W ∗ ‖ M∗) 04 if c∗ 6= H′(W ∗ ‖ M∗) then abort 05 if JM∗ 6∈ MK ∧ V(pk,W ∗, c∗,Z∗) then return (M∗, σ∗) 06 abort 
Figure 9: Adversary B against UF-NMA security of SIG with quantum access to random oracle H′. The oracles Sign1 and H simulated by B are defined as in game G2 of Figure 8. 
We distinguish two cases. If (M ∗, ·) 6∈ M then we are in the situation that the adversary did not query a signature on M ∗ and we can use the same argument as in standard unforgeability to argue |Pr[GA 
2 ⇒ 1] − Pr[GA 1 ⇒ 1]| ≤ 2−α+1. It leaves to handle the case (M ∗, ·) ∈ M, i.e., the adversary 
obtained a signatures σM∗ = (WM∗ ,ZM∗) on message M ∗ and submits a correct forgery σ∗ = (W ∗,Z∗) satisfying W ∗ = WM∗ and Z∗ 6= ZM∗ . The problem of finding values (W ∗, c∗,ZM∗ ,Z∗) with two accepting transcripts (W ∗, c∗,Z∗) and (W ∗, c∗,ZM∗) is exactly bounded by the advantage of an adversary C against the CUR experiment, i.e., |Pr[GA 
2 ⇒ 1]− Pr[GA 1 ⇒ 1]| ≤ AdvCUR 
ID (C). In combination this proves 
|Pr[GA 2 ⇒ 1]− Pr[GA 
1 ⇒ 1]| ≤ 2−α+1 + AdvCUR ID (C). 
Finally, a straightforward modification of adversary B against UF-NMA security to account for the strong unforgerability check proves 
Pr[GA 2 ⇒ 1] = AdvUF-NMA 
SIG (B) 
and completes proof of sUF-CMA1 security. The running times Time(B) and Time(C) can be derived as above. 
The following theorem shows that we can also prove directly UF-CMA security of SIG, but (in terms of the running time) the reduction is less tight than the one of Theorem 3.2. 
Theorem 3.3 Assume the identification scheme ID is εzk-perfect naHVZK and has α bits of min entropy. For any UF-CMA (sUF-CMA) quantum adversary A that issues at most QH queries to the quantum random oracle |H〉 and QS classical queries to the signing oracle Sign, there exists a quantum adversary B against UF-NMA security making QH queries to its own quantum random oracle (and a quantum adversary C against CUR) such that 
AdvUF-CMA SIG (A) ≤ AdvUF-NMA 
SIG (B) + QS · 2−α+1 + κmQS · εzk, 
AdvsUF-CMA SIG (A) ≤ AdvUF-NMA 
SIG (B) + QS · 2−α+1 + κmQS · εzk + AdvCUR ID (C) , 
and Time(B) = Time(C) = Time(A) + κmQHQS . 
The proof of Theorem 3.3 is similar to the one of Theorem 3.2 and postponed to Appendix A.2. 
3.2.2 From Lossiness to UF-NMA 
Theorem 3.4 Assume the identification scheme is lossy and εls-lossy sound. For any UF-NMA quantum adversary A that issues at most QH queries to the quantum random oracle |H〉, there exists a quantum adversary B against LOSS such that 
AdvUF-NMA SIG (A) ≤ AdvLOSS 
ID (B) + 8(QH + 1)2 · εls , 
and Time(B) = Time(A) + QH ≈ Time(A). 
Proof. Let A be an adversary against the UF-NMA security of SIG, issuing at most QH quantum queries to |H〉. Consider the games given in Figure 10. 
14
GAME G0-G1 01 (pk, sk)← IGen(par) G0 02 pk ← LossyIGen(par) G1 03 (M∗, σ∗)← A|H〉(pk) 04 Parse σ∗ = (W ∗,Z∗) 05 c∗ := H(W ∗ ‖ M∗) 06 return V(pk,W ∗, c∗,Z∗) 
Figure 10: Games G0-G1 for the proof of Theorem 3.4. 
Game G0. Since game G0 is the original UF-NMA game, 
Pr[GA 0 ⇒ 1] = AdvUF-NMA 
SIG (A) . 
Game G1. In this game, the public key pk is changed to lossy mode. Clearly, there exists an adversary B simulating H by a 2QH-wise independent hash function such that 
|Pr[GA 1 ⇒ 1]− Pr[GA 
0 ⇒ 1]| ≤ AdvLOSS ID (B) . 
Adversary C1 01 pk ← LossyIGen(par) 02 Pick 2QH-wise independent f2QH 03 for each W ∈WSet do 04 compute set ChGOODpk(W ) ⊆ ChSet 05 λpk(W ) := |ChGOODpk(W )|/|ChSet| 06 for each M ∈ MSet set λpk(W ‖ M ) := λpk(W ) 07 return (λpk(W ‖ M ))W∈WSet,M∈MSet 
Adversary C|g)〉 2 
08 (M∗, σ∗)← A|H〉(pk) 09 Parse σ∗ = (W ∗,Z∗) 10 c∗ := H(W ∗ ‖ M∗) 11 if V(pk,W ∗, c∗,Z∗) = 1 return (W ∗ ‖ M∗) 12 else return ⊥ 
H(W ‖ M ) quantum access 13 y := g(W ‖ M ) 14 if y = 1: c := Uni(ChGOODpk(W ); f2QH (W ‖ M )) 15 if y = 0: c := Uni(ChSet \ ChGOODpk(W ); f2QH (W ‖ M )) 16 return c 
Figure 11: Adversary C = (C1,C2) in game GSPB for the proof of Theorem 3.4. The set of good challenges ChGOODpk(W ) is defined in Equation (6). 
Finally, we will reduce a successful A in game G1 to the generic search problem GSPB to show 
Pr[GA 1 ⇒ 1] ≤ 8(QH + 1)2εls. (5) 
For a finite set S , let Uni(S) be a probabilistic algorithm that returns uniform x ← S and recall that x := Uni(S ; r) denotes the deterministic execution of Uni(S) using explicitly given random tape r . To prove Equation (5), consider the unbounded adversary C = (C1,C2) defined in Figure 11 that is executed in the generic search game GSPB, making at most QH quantum queries to the oracle |g(·)〉. First note that computing the probabilities λpk(W ‖ M ) = λpk(W ) in line 05 for all W ∈WSet and M ∈ MSet may take exponential time but since C is computationally unbounded it does not matter. 
To analyze C’s success probability in game GSPB, we first fix a public-key pk. Now consider some W ‖ M with non-zero amplitude as part of a query to quantum random oracle H. Set ChGOODpk(W ) of “good challenges” is defined as 
ChGOODpk(W ) := {c ∈ ChSet | ∃Z ∈ ZSet : V(pk,W , c,Z ) = 1}. (6) 
That is, the set ChGOODpk(W ) contains all challenges c for which there exists a possible response Z to make (W , c,Z) a valid transcript (with respect to pk). By definition of GSPB, each query to oracle g(W ‖ M ) returns y = 1 with probability λpk(W ‖ M ) = |ChGOODpk(W )|/|ChSet|. Hence, the output distribution of H(W ‖ M ) sampled in lines 14 and 15 is uniform over ChSet, as in game G1. Consistency 
15
of H is assured by deriving the randomness to sample c in case y = 0 (lines 14 and 15) using fixed random coins f2QH(W ‖ M ), derived by a 2QH-wise independent hash function f2QH (which looks like a perfectly random function to A). 
Now consider A’s forgery σ∗ = (W ∗,Z∗) on message M ∗ and define c∗ := H(W ∗ ‖ M ∗). If the signature is valid (i.e., V(pk,W ∗, c∗,Z∗) = 1), then clearly c∗ is a good challenge from set ChGOODpk(W ∗) which implies g(W ∗ ‖ M ∗) = 1. This proves 
Pr[G1 ⇒ 1 | pk] = Pr[GSPBC λpk ⇒ 1 | pk] ≤ 8(QH + 1)2λpk , (7) 
where λpk = max 
W∈WSet,M∈MSet λpk(W ‖ M ) 
Averaging Equation (7) over pk ← LossyIGen we finally obtain 
Pr[G1 ⇒ 1] ≤ 8(QH + 1)2 ·Epk [λpk ] ≤ 8(QH + 1)2εls, 
where the last inequality uses Equation (3) for the optimal adversary. 
4 Dilithium-QROM In this section, we present a modification of the Dilithium digital signature scheme [DLL+17] whose security is based on MLWE in the QROM. We also present a new security proof of the original Dilithium that shows it to be tightly-secure in the QROM based on a different non-interactive assumption. Since Dilithium is a highly-optimized version of a scheme constructed via the “Fiat-Shamir with Aborts” framework [Lyu09], its details may be somewhat overwhelming to readers who are not already comfortable with such constructions. For this reason, we present a much simpler version of the signature scheme without any optimizations in Appendix B. The reader who wishes to get a feel for how the techniques of the previous section apply to lattice-based schemes is thus encouraged to read this section after familiarizing oneself with the notation in Section 4.1.1. 
4.1 Preliminaries 4.1.1 Rings and Distributions 
We let R and Rq respectively denote the rings Z[X ]/(Xn + 1) and Zq[X ]/(Xn + 1), for an integer q. We will assume that q ≡ 5(mod 8), as such a choice of q ensures that all polynomials in Rq with coefficients less than 
√ q/2 have an inverse in the ring [LN17, Lemma 2.2]. This property is crucial to our security 
proof. Regular font letters denote elements in R or Rq (which includes elements in Z and Zq) and bold lower-case letters represent column vectors with coefficients in R or Rq. By default, all vectors will be column vectors. Bold upper-case letters are matrices. Modular reductions. For an even (resp. odd) positive integer α, we define r ′ = r mod± α to be the unique element r ′ in the range −α2 < r ′ ≤ α 
2 (resp. −α−1 2 ≤ r ′ ≤ α−1 
2 ) such that r ′ = r mod α. We will sometimes refer to this as a centered reduction modulo q. For any positive integer α, we define r ′ = r mod+α to be the unique element r ′ in the range 0 ≤ r ′ < α such that r ′ = r mod α. When the exact representation is not important, we simply write r mod α. Sizes of elements. For an element w ∈ Zq, we write ‖w‖∞ to mean |w mod± q|. We now define the `∞ and `2 norms for w = w0 + w1X + . . .+ wn−1Xn−1 ∈ R: 
‖w‖∞ = max i ‖wi‖∞, ‖w‖ = 
√ ‖w0‖2 
∞ + . . .+ ‖wn−1‖2 ∞. 
Similarly, for w = (w1, . . . ,wk) ∈ Rk , we define 
‖w‖∞ = max i ‖wi‖∞, ‖w‖ = 
√ ‖w1‖2 + . . .+ ‖wk‖2. 
We will write Sη to denote all elements w ∈ R such that ‖w‖∞ ≤ η. 
16
Extendable output function. Suppose that Sam is an extendable output function, that is a function on bit strings in which the output can be extended to any desired length. If we would like Sam to take as input x and then produce a value y that is distributed according to distribution S (or uniformly over a set S), we write y ∼ S := Sam(x). It is important to note that this procedure is completely deterministic: a given x will always produce the same y. For simplicity we assume that the output distribution of Sam is perfect, whereas in practice Sam will be implemented using random oracles and produce an output that is statistically close to the perfect distribution. If K is a secret key, then Sam(K‖x) is a pseudo-random function from {0, 1}∗ → {0, 1}∗. The Challenge Space. The challenge space in our identification and signature schemes needs to be a subset of the ring R, have size a little larger than 2256, and consist of polynomials with small norms. In this paper, the dimension n of the ring R will be taken to be 512,3 and so we will define the challenge space accordingly as 
ChSet := {c ∈ R | ‖c‖∞ = 1 and ‖c‖ = √ 
46}. (8) 
In other words, ChSet consists of elements in R with −1/0/1 coefficients that have exactly 46 non-zero coefficients. The size of this set is 
( n 46 ) · 246, which for n = 512 is greater than 2265. 
The MLWE Assumption. For integers m, k, and a probability distribution D : Rq → [0, 1], we say that the advantage of algorithm A in solving the decisional MLWEm,k,D problem over the ring Rq is 
AdvMLWE m,k,D := 
∣∣Pr[A(A, t)⇒ 1 | A← Rm×k q ; t← Rm 
q ] − Pr[A(A,As1 + s2)⇒ 1 | A← Rm×k 
q ; s1 ← Dk ; s2 ← Dm] ∣∣ . 
The MLWE assumption states that the above advantage is negligible for all polynomial-time algorithms A. This assumption was introduced in [LS15], and is generalization of the LWE assumption from [Reg05]. The Ring-LWE assumption [LPR10] is a special case of MLWE where k = 1. Analogously to LWE and Ring-LWE, it was shown in [LS15] that solving the MLWE problem for certain parameters is as hard as solving certain worst-case problems in certain algebraic lattices. 
4.1.2 Summary of Supporting Algorithms 
To reduce the size of the public key, we will need some simple algorithms that extract “higher-order” and “lower-order” bits of elements in Zq. The goal is that when given an arbitrary element r ∈ Zq and another small element z ∈ Zq, we would like to be able to recover the higher order bits of r + z without needing to store z. We therefore define algorithms that take r , z and produce a 1-bit hint h that allows one to compute the higher order bits of r + z just using r and h. This hint is essentially the “carry” caused by z in the addition. The algorithms are exactly as in [DLL+17], and we repeat them for convenience in Figure 12. The algorithms are described as working on integers modulo q, but are extended to polynomials in Rq by simply being applied individually to each coefficient. 
The below Lemmas recall the crucial properties of these supporting algorithms that are necessary for the correctness and security of our scheme. 
Lemma 4.1 Suppose that q and α are positive integers satisfying q > 2α, q ≡ 1 (mod α) and α even. Let r and z be vectors of elements in Rq where ‖z‖∞ ≤ α/2, and let h,h′ be vectors of bits. Then the HighBitsq, MakeHintq, and UseHintq algorithms satisfy the following properties: 
1. UseHintq(MakeHintq(z, r, α), r, α) = HighBitsq(r + z, α). 
2. Let v1 = UseHintq(h, r, α). Then ‖r− v1 · α‖∞ ≤ α+ 1. 
3. For any h,h′, if UseHintq(h, r, α) = UseHintq(h′, r, α), then h = h′. 
Lemma 4.2 If ‖s‖∞ ≤ β and ‖LowBitsq(r, α)‖∞ < α/2− β, then 
HighBitsq(r, α) = HighBitsq(r + s, α). 
17
Power2Roundq(r , d) 01 r := r mod+ q 02 r0 := r mod± 2d 
03 return (r − r0)/2d 
UseHintq(h, r , α) 04 m := (q − 1)/α 05 (r1, r0) := Decomposeq(r , α) 06 if h = 1 and r0 > 0 return (r1 + 1) mod+ m 07 if h = 1 and r0 ≤ 0 return (r1 − 1) mod+ m 08 return r1 
MakeHintq(z, r , α) 09 r1 := HighBitsq(r , α) 10 v1 := HighBitsq(r + z, α) 11 return Jr1 6= v1K 
Decomposeq(r , α) 12 r := r mod+ q 13 r0 := r mod± α 14 if r − r0 = q − 1 15 then r1 := 0; r0 := r0 − 1 16 else r1 := (r − r0)/α 17 return (r1, r0) 
HighBitsq(r , α) 18 (r1, r0) := Decomposeq(r , α) 19 return r1 
LowBitsq(r , α) 20 (r1, r0) := Decomposeq(r , α) 21 return r0 
Figure 12: Supporting algorithms for Dilithium and Dilithium-QROM. 
4.2 The Identification Protocol The constituting algorithms of our identification protocol ID = (IGen,P1,P2,V) are described in Figure 13 with the concrete parameters par = (q,n, k, `, d, γ, γ′, η, β) given later in Table 1. Key Generation. The key generation proceeds by choosing a random 256-bit seed ρ and expanding into a matrix A ∈ Rk×` 
q by an extendable output function Sam modeled as a random oracle. The secret keys (s1, s2) ∈ S`η × Sk 
η have uniformly random coefficients between −η and η (inclusively). The value t = As1 + s2 is then computed. The public key that is needed for verification is (ρ, t1) with t1 output by the Power2Roundq(t, d) algorithm in Figure 12 (we have t = t1 · 2d + t0 for some small t0), while the secret key is (ρ, s1, s2, t0). 
While the verifier never needs the value t0 (and thus it does not need to be included in the public key of the actual scheme), we do need this value in order to simulate transcripts (see Section 4.3.1). Thus the security of our scheme is based on the fact that the adversary gets t1 and t0, whereas in reality he only gets t1. 
The set ChSet is defined as in Equation (8), and ZSet = S`γ′−β−1 × {0, 1}k . The set of commitments WSet is defined as WSet = {w1 : ∃y ∈ S`γ′−1 s.t. w1 = HighBitsq(Ay, 2γ)}. Protocol Execution. The prover starts the identification protocol by reconstructing A from the random seed ρ. The next step has the prover sample y ← S`γ′−1 and then compute w = Ay. He then writes w = 2γ · w1 + w0, with w0 between −γ and γ (inclusively), and then sends w1 to the verifier. The verifier generates a random challenge c ← ChSet and sends it to the prover. The prover computes z = y + cs. If z /∈ S`γ′−β−1, then the prover sets his response to ⊥. He also replies with ⊥ if LowBitsq(w− cs2, 2γ) /∈ Sk 
γ−β−1. This part of the protocol is necessary for security – it makes sure that z does not leak anything about the secret key s1, s2. 
If the checks pass and a ⊥ is not sent, then it can be shown (see Section 4.3.2) that HighBitsq(Az− ct, 2γ) = w1. At this point, if the verifier knew the entire element t and (z, c), he could have recovered w1 and checked that ‖z‖∞ < γ′ − β and that the high-order bits of Az− ct are indeed w1. However, since we want to compress the size of the public key, the verifier only knows t1. Hence, the signer needs to provide a “hint” h which will allow the verifier to compute HighBitsq(Az− ct, 2γ). 
The verifier checks whether ‖z‖∞ < γ′ − β and that Az− ct1 · 2d together with the hint h allow him to reconstruct w1. We should point out that in the identification scheme it is actually not necessary for the verifier to be able to recover exactly w1. He could have simply checked that Az− ct1 · 2d ≈ w1 and this would be good enough for security. The reason that we want the verifier to be able to exactly recover w1 is to make the ID scheme commitment-recoverable and be able to reduce the communication size in the Fiat-Shamir transform (see Section 3.1). 
3In Section 4.5, we will also discuss a scheme where n = 256. For that scheme the challenge space consists of 60 ±1’s. 
18
IGen(par) 01 ρ← {0, 1}256 
02 A← Rk×` q := Sam(ρ) 
03 (s1, s2)← S`η × Sk η 
04 t := As1 + s2 05 t1 := Power2Roundq(t, d) 06 t0 := t− t1 · 2d 
07 pk = (ρ, t1, t0 ) 08 sk = (ρ, s1, s2, t0) 09 return (pk, sk) 
P1(sk) 10 A← Rk×` 
q := Sam(ρ) 11 y← S`γ′−1 12 w := Ay 13 w1 := HighBitsq(w, 2γ) 14 return (W = w1,St = (w,y)) 
P2(sk,W = w1, c,St = (w,y)) 15 z := y + cs1 16 if ‖z‖∞ ≥ γ′−β or ‖LowBitsq(w− cs2, 2γ)‖∞ ≥ γ−β 17 then (z,h) := ⊥ 18 else h := MakeHintq(−ct0,w− cs2 + ct0, 2γ) 19 return Z = (z,h) 
V(pk,W = w1, c,Z = (z,h)) 20 return J‖z‖∞ < γ′ − βK and Jw1 = UseHintq(h,Az− ct1 · 2d , 2γ)K 
Figure 13: Our ID scheme – a concrete instantiation based on the hardness of the MLWE problem of the commitment-recoverable (Definition 2.4) canonical identification scheme in Figure 4. The t0 part of the public key is assumed to be known by the adversary in the security proofs, but is not needed by the verifier for verification. Thus in the real scheme, t0 would not be included as part of the public key. 
4.3 Security Properties 4.3.1 Non Abort Honest Verifier Zero-Knowledge 
In this section, we will show that ID is perfectly naHVZK, i..e., the distribution of the output of the Trans algorithm (Figure 14, left) that uses the secret key as input is exactly that of the Sim algorithm (Figure 14, right) that uses only the public key as input. 
Algorithm Trans(sk): 01 A← Rk×` 
q := Sam(ρ) 02 y← S`γ′−1 03 w := Ay 04 w1 := HighBitsq(w, 2γ) 05 c ← ChSet 06 z := y + cs1 07 if ‖z‖∞ ≥ γ′ − β then return ⊥ 08 if ‖LowBitsq(w− cs2, 2γ)‖∞ ≥ γ − β then return ⊥ 09 h := MakeHintq(−ct0,w− cs2 + ct0, 2γ) 10 return (c, (z,h)) 
Algorithm Sim(pk): 11 A← Rk×` 
q := Sam(ρ) 
12 with probability 1− |S` γ′−β−1| 
|S` γ′−1 
| , return ⊥ 
13 z← S`γ′−β−1 14 c ← ChSet 15 if ‖LowBitsq(Az− ct, 2γ)‖∞ ≥ γ − β 16 then return ⊥ 17 h := MakeHintq(−ct0,Az− ct + ct0, 2γ) 18 return (c, (z,h)) 
Figure 14: Left: a real transcript output by the transcript algorithm Trans(sk); Right: a simulated transcript output by the Sim(pk) algorithm. 
Lemma 4.3 If β ≥ maxs∈Sη,c∈ChSet ‖cs‖∞, then ID is perfectly naHVZK. 
Proof. Let (s1, s2) ∈ S`η × Sk η be any polynomials satisfying As1 + s2 = t. We will show that the output 
distributions of Trans and Sim from Figure 14 are identical. For any z ∈ Sk 
γ′−β−1, let us compute the probability of it being generated in line 06 of Trans. For any c ∈ ChSet, we have 
Pr y←S` 
γ′−1 
[y + cs1 = z] = Pr y←S` 
γ′−1 
[y = z− cs1]. 
Notice that because ‖cs1‖∞ ≤ β, we know that z− cs1 ∈ S`γ′−1. Thus 
Pr y←S` 
γ′−1 
[y = z− cs1] = 1/|S`γ′−1|. (9) 
19
Therefore every z ∈ S`γ′−β−1 has an equal probability of being generated. Furthermore, the probability of 
producing a z ∈ S`γ′−β−1, and thus not returning ⊥ in Line 07 of Trans, is exactly |S ` γ′−β−1| |S` γ′−1| 
. Thus after 
the completion of Line 07, either ⊥ has been returned (with probability 1− |S` γ′−β−1| |S` γ′−1| 
), or the distribution 
of (c, z) is uniform in ChSet× S`γ′−β−1. This is exactly the same distribution as after Line 14 of Sim. To complete the proof, we note that 
w− cs2 = Ay− cs2 = A(z− cs1)− cs2 = Az− ct, (10) 
and therefore all the steps in Trans after Line 07 are identical to those after Line 14 of Sim. 
4.3.2 Correctness 
In this section, we compute the probability that the Prover does not send ⊥ and then show that the verification procedure will always accept a transcript when the Prover does not send ⊥. 
Lemma 4.4 If β ≥ maxs∈Sη,c∈ChSet ‖cs‖∞ then ID has correctness error δ ≈ 1−exp (−βn · (k/γ + `/γ′)). 
Proof. Let s1, s2 ∈ Sk η be any polynomials satisfying As1 + s2 = t. We first show 
Pr y←S` 
γ′−1, c←ChSet [(z,h) 6= ⊥] ≈ exp (−βn · (k/γ + `/γ′)). (11) 
Since we showed in Lemma 4.3 that Sim outputs ⊥ with the same probability as Trans (and therefore with the same probability as in the identification scheme), we can simply compute the probability that Sim does not output ⊥. 
The probability that ⊥ is not output in Line 12 of Sim (Figure 14) is 
|S`γ′−β−1| |S`γ′−1| 
= ( 
2(γ′ − β)− 1 2γ′ − 1 
)n` > 
( 1− β 
γ′ 
)n` ≈ e−βn`/γ′ , (12) 
where the approximate equality is due to the fact that β  γ. If we then heuristically assume that for a uniformly-random z ∈ Sk 
γ′−β−1, the distribution of Az− ct mod 2γ is approximately uniform, then we also have that the probability that ⊥ is not output in Line 16 is 
Pr z←S` 
γ′−β−1 
[‖LowBitsq(Az− ct, 2γ)‖∞ < γ − β] ≈ |Sk γ−β−1| |Sk γ−1| 
≈ e−βnk/γ . (13) 
Multiplying the bounds in Equation (12) and Equation (13) proves Equation (11). To complete the proof of the lemma, it remains to show that if (z,h) 6= ⊥, then the verification 
procedure will always accept. Assume (z,h) 6= ⊥. It’s clear that the verifier’s check ‖z‖∞ < γ′ − β will always pass. We will now show that the second check will pass as well. Because 
w− cs2 = Ay− cs2 = A(z− cs1)− cs2 = Az− ct = Az− ct0 − ct1 · 2d , 
we can rewrite the MakeHint call of the prover as 
h := MakeHintq(−ct0,w− cs2 + ct0, 2γ) = MakeHintq(−ct0,Az− ct1 · 2d , 2γ). 
Since ‖ct0‖∞ < γ, by Lemma 4.1 we know that the verifier computes 
UseHintq(h,Az− ct1 · 2d , 2γ) = HighBitsq(Az− ct1 · 2d , 2γ) (14) = HighBitsq(w− cs2, 2γ) . 
Since ‖LowBitsq(w− cs2, 2γ)‖∞ < γ − β, we know from Lemma 4.2 that 
HighBitsq(w− cs2, 2γ) = HighBitsq(w, 2γ) = w1. 
Therefore the verifier will correctly compute w1 := UseHintq(h,Az− ct1 · 2d , 2γ) and will accept a valid prover. 
20
4.3.3 Lossyness 
In this section, we analyze the scheme in which the public key is generated uniformly at random, as in algorithm LossyIGen of Figure 15, rather than as in IGen of Figure 13. Our goal is to show that even if the prover is computationally unbounded, he only has approximately a 1/|ChSet| probability of making the verifier accept during each run of the identification scheme. This will show that the probability in Equation (3) is upper-bounded by approximately 1/|ChSet|. 
LossyIGen(par) 01 ρ← {0, 1}256; A← Rk×` 
q := Sam(ρ) 02 t← Rk 
q 03 t1 := Power2Roundq(t, d) 04 t0 := t− t1 · 2d 
05 return pk = (ρ, t1, t0) 
Figure 15: The lossy instance generator LossyIGen. 
By observing that the output of LossyIGen is uniformly random over Rk×` q × Rk 
q and the output of IGen in Figure 13 is (A,As1 + s2) where A← Rk×` 
q and (s1, s2)← S`η × Sk η , we have that 
AdvLOSS ID (A) = AdvMLWE 
k,`,D (A), 
where D is the uniform distribution over Sη. 
Lemma 4.5 If 4γ + 2, 2γ′ < √ q/2 and γ′ < γβ, and ` ≤ k, then ID has εls-lossy soundness for 
εls ≤ 1 
|ChSet| + 2 · |ChSet|2 · ( 
32γγ′ 
q 
)nk . 
Our proof follows the framework from [KW03, AFLT12]– first, in Lemma 4.6 we show that if A, t are chosen at random, then a particular linear equation is unlikely to have any solutions. Then to prove Lemma 4.5, we show that if C, who outputs the first message (w1,St) in the LOSSY-IMP game (see Figure 16) is able to correctly respond to more than one random challenge c, then the previously mentioned linear equation will have a solution, which with high probability is not possible. Therefore we conclude that for virtually all A, t output by LossyIGen, there exists (at most) only one challenge for which the prover can respond to, and therefore his success probability is at most 1/|ChSet|. 
Lemma 4.6 Let α1, α2 be positive integers less than √ q/2 and D be a set of elements in R \ {0} with 
coefficients less than √ q/2. Also, let d be such that 2d < 2α1. Then 
Pr A←Rk×` 
q ,t←Rk q 
[∃ (z1, z2, c) ∈ S`α1 × Sk 
α2 ×D s.t. Az1 + z2 = ct1 · 2d ] 
≤ 2 · |D| · ( 
(2α1 + 1)` · (2α2 + 1)k 
qk 
)n 
. (15) 
where t1 := Power2Roundq(t, d). 
Proof. Case 1: We will first handle the case where z1 = 0. In this case Equation (15) becomes 
Pr t←Rk 
q 
[∃ (z2, c) ∈ Sk α2 ×D such that z2 = ct1 · 2d ]. 
Because 0 < ‖c‖∞ < √ q/2 and q = 5 mod 8, we know that c is invertible in Rq ([LN17, Lemma 2.2]). 
The above probability therefore becomes 
Pr t←Rk 
q 
[∃ (z2, c) ∈ Sk α2 ×D such that z2 · (2dc)−1 = t1] 
≤ ∑ 
z2∈Sk α2 ,c∈D 
Pr t←Rk 
q 
[t1 = z2 · (2dc)−1]. 
21
For t ∈ Rk q , the most frequent value of each coefficient of t1 occurs at most 2d times. Thus 
∑ z2∈Sk 
α2 ,c∈D 
Pr t←Rk 
q 
[t1 = z2 · (2dc)−1] ≤ ∑ 
z2∈Sk α2 ,c∈D 
( 2d 
q 
)nk 
= ( 
(2α2 + 1) · 2d 
q 
)nk 
· |D|. (16) 
Case 2: We now move to the case where z1 6= 0. Let (z1 6= 0, z2, c) be any triple and assume without loss of generality that the first polynomial in z1 is non-zero. We can then write 
Pr A←Rk×` 
q ,t←Rk q 
[Az1 + z2 = ct1 · 2d ] 
= Pr a←Rk 
q ,A′←Rk×(k−1) q ,t←Rk 
q 
[az + A′z′1 + z2 = ct1 · 2d ] 
= Pr a←Rk 
q 
[az = −A′z′1 − z2 + ct1 · 2d ], 
where z1 := [ z z′1 
] . Since ‖z‖∞ < 
√ q/2 and q = 5 mod 8, we again know that z is invertible in Rq. 
The above probability therefore becomes 
Pr a←Rk 
q 
[a = z−1 · (−A′z′1 − z2 + ct1 · 2d)] = q−nk . 
Thus by the union bound, we can upper-bound Equation (15) when z1 6= 0 by∑ z1∈S`α1\{0}, z2∈Sk 
α2 , c∈D 
q−nk < 
( (2α1 + 1)` · (2α2 + 1)k 
qk 
)n 
· |D|. 
Combining the above with Equation (16) and using the assumption that 2d < 2α, we get the statement in the claim of the Lemma. 
Proof of Lemma 4.5. Consider an unbounded adversary C that is executed in game LOSSY-IMP of Figure 16. 
GAME LOSSY-IMP: 01 pk ls := (ρ, t1, t0)← LossyIGen(par) 02 (w1,St)← C(pk ls) 03 c ← ChSet 04 (z,h)← C(St, c) 05 return Jw1 = UseHintq(h,Az− ct1 · 2d , 2γ)K and J‖z‖∞ < γ′ − βK 
Figure 16: The lossy impersonation game LOSSY-IMP. 
Suppose that for some w1, there exist two c 6= c′ ∈ ChSet and two (z,h), (z′,h′) that lead to C winning. In other words, ‖z‖∞, ‖z′‖∞ < γ′ − β and 
w1 = UseHintq(h,Az− t1c · 2d , 2γ), w1 = UseHintq(h′,Az′ − t1c′ · 2d , 2γ). 
By Lemma 4.1, we know that the above implies 
‖Az− t1c · 2d −w1 · 2γ‖∞ ≤ 2γ + 1, ‖Az′ − t1c′ · 2d −w1 · 2γ‖∞ ≤ 2γ + 1. 
By the triangular inequality, this implies that 
‖A(z− z′)− t1 · 2d · (c − c′)‖∞ ≤ 4γ + 2 , 
22
which can be rewritten as A(z− z′) + u = t1 · 2d · (c − c′) (17) 
for some u such that ‖u‖∞ ≤ 4γ + 2 (and ‖z− z′‖∞ ≤ 2(γ′ − β − 1)). If A← Rk×` 
q and t← Rk q , then Lemma 4.6 tells us that Equation (17) is satisfied with probability 
less than 
2 · |ChSet|2 · (4(γ′ − β))n` · (8γ + 5)nk 
qnk < 2 · |ChSet|2 · ( 
32γγ′ 
q 
)nk . 
Thus, except with the above probability, for every w1, there is at most one possible c that allows C to win. Therefore, except with the above probability, C has at most a 1/|ChSet| chance of winning. 
4.3.4 Min Entropy 
In Lemma 4.7 we will prove (using exactly the same technique as in Lemma 4.6) that the w1 sent by the honest prover in the first step is extremely likely to be distinct for every run of the protocol. 
Lemma 4.7 If 2γ, 2γ′ < √ q/2 and ` ≤ k, then the identification scheme ID in Figure 13 has 
α > n` · log ( 
min { 
q (4γ + 1)(4γ′ + 1) , 2γ 
′ − 1 }) 
bits of min-entropy (as in Definition 2.6). 
Proof. We first claim that 
Pr A←Rk×` 
q 
[∃y 6= y′ ∈ S`γ′−1 s.t. HighBitsq(Ay, 2γ) = HighBitsq(Ay′, 2γ)] 
< 
( (4γ + 1)(4γ′ + 1) 
q 
)nk . (18) 
From Equation (18), we know that with probability at least 1 − ( 
(4γ+1)(4γ′+1) q 
)nk over the choice of 
A← Rk×` q , each W = HighBitsq(Ay, 2γ) has exactly a 1∣∣S` 
γ′−1 
∣∣ = (2γ′ − 1)−n` probability of being output. 
The claim in the lemma follows directly from Definition 2.6 and the assumption that k ≥ ` It remains to prove Equation (18). If we define 
Decomposeq(Ay, 2γ) = (w1,w0) 
and Decomposeq(Ay′, 2γ) = (w′1,w′0), 
then HighBitsq(Ay, 2γ) = HighBitsq(Ay′, 2γ) implies that Ay = w1 · 2γ + w0 and Ay′ = w′1 · 2γ + w′0 with w1 = w′1 and ‖w0‖∞, ‖w′0‖∞ ≤ γ. Therefore we have 
A(y− y′)− (w0 −w′0) = 0 (19) 
with ‖y− y′‖∞ < 2γ′, ‖w0 −w′0‖∞ ≤ 2γ. 
Since 2γ, 2γ′ < √ q/2, the same argument as in Case 2 of the proof of Lemma 4.6 shows that the 
probability over the choice of A← Rk×` q , that there exist two non-zero elements of norm less than 2γ 
and 2γ′, respectively, that satisfy Equation (19) is at most( (4γ + 1)`(4γ′ + 1)k 
qk 
)n 
≤ ( 
(4γ + 1)(4γ′ + 1) q 
)nk . 
This proves Equation (18). 
23
4.3.5 Computational Unique Response 
In this section we prove that our scheme satisfies the Computational Unique Response (CUR) property required for strong-unforgeability of the signature scheme. 
Lemma 4.8 If 4γ + 2, 2γ′ < √ q/2 and γ′ < γβ, and ` ≤ k (i.e. the same conditions as in Lemma 4.5), 
then AdvCUR ID (A) < 
( 32γγ′ 
q 
)nk for every (even unbounded) adversary A. 
Proof. Let (W , c,Z) = (w1, c, (z,h)) be any valid transcript. If A is able to generate a valid Z ′ = (h′, z′) 6= Z such that V(pk = (A, t1),w1, c, (z′,h′)) = 1, then Lemma 4.9 implies that there exist v,u with ‖v‖∞ < 2(γ′ − β), ‖u‖∞ ≤ 4γ + 2 such that Av + u = 0. Since 2(γ′ − β), 4γ + 2 < 
√ q/2, the same 
argument as in Case 2 of the proof of Lemma 4.6 shows that the probability over the choice of A← Rk×` q , 
that there exist such v,u is at most 
(4(γ′ − β))n` · (8γ + 5)nk 
qnk < 
( 32γγ′ 
q 
)nk . 
Lemma 4.9 If (w1, c, (z,h)) and (w1, c, (z′,h′)) are such that V(pk,w1, c, (z,h)) = V(pk,w1, c, (z′,h′)) = 1 and (z,h) 6= (z′,h′), then there exist v,u such that ‖v‖∞ < 2(γ′ − β), ‖u‖∞ ≤ 4γ + 2 such that Av + u = 0. 
Proof. The two conditions of the Lemma imply that 
w1 = UseHintq(h,Az− ct1 · 2d , 2γ), 
w1 = UseHintq(h′,Az′ − ct1 · 2d , 2γ). 
We first point out that it must be that z 6= z′. This is because Lemma 4.1 implies that if z = z′ then necessarily h = h′ (and then Z = Z ′). The above two equations imply (again by Lemma 4.1) that 
‖Az− ct1 · 2d −w1 · 2γ‖∞ ≤ 2γ + 1, 
‖Az′ − ct1 · 2d −w1 · 2γ‖∞ ≤ 2γ + 1. 
By the triangular inequality, this can be rewritten as 
A(z− z′) + u = 0 
for some u such that ‖u‖ ≤ 4γ2 + 2 and ‖z− z′‖ < 2(γ′ − β). 
4.4 The Dilithium-QROM Signature Scheme and Concrete Parameters In this section, we describe the signature scheme Dilithium-QROM (Figure 17) which is obtained via the Fiat-Shamir transform from the scheme ID of Figure 13 and using Sam(K ‖ ·) as a pseudorandom function. We then instantiate it with concrete parameters (Table 1) and compare them for the same security level with those in [DLL+17]. 
The parameters for our scheme are dictated by the requirements for the scheme to be stronglyunforgeable in Theorem 3.1 which gives an upper bound on AdvsUF-CMA 
Dilithium-QROM(A). Following [KMP16], for “κ bits of quantum security” for Dilithium-QROM we require that for all quantum adversaries A running in time at most 2κ, 
AdvUF-CMA Dilithium-QROM(A)/Time(A) ≤ 2−κ. (20) 
To this end, we need to put bounds on the parameters εls, εzk, and α. Lemma 4.3 tells us that 
εzk = 0. 
To lower-bound α, note that in the parameters, we always have 2γ = 2γ′ < √ q/2, and therefore we can 
apply Lemma 4.7 and obtain thatα is greater than 2900. Thus the 2−α term has absolutely no practical effect in Theorem 3.1 for the parameters in Section 4.4. 
24
Sign((sk,K),M ) 01 κ := 0 02 A← Rk×` 
q := Sam(ρ) 03 while (z,h) = ⊥ and κ ≤ 200/(1− δ) do 04 κ := κ+ 1 05 y← S`γ′−1 := Sam(K ‖ M ‖ κ) 06 w := Ay 07 w1 := HighBitsq(w, 2γ) 08 c := H(w1 ‖ M ) 09 z := y + cs1 10 if ‖z‖∞ ≥ γ′ − β or ‖LowBitsq(w− cs2, 2γ)‖∞ ≥ γ − β then (z,h) := ⊥ 11 else h := MakeHintq(−ct0,w− cs2 + ct0, 2γ) 12 return σ = (z,h, c) 
Ver(pk,M , σ = (z,h, c)) 13 A← Rk×` 
q := Sam(ρ) 14 w′1 := UseHintq(h,Az− ct1 · 2d , 2γ) 15 return J‖z‖∞ < γ′ − βK and Jc = H (w′1 ‖ M )K 
Figure 17: Our signature scheme Dilithium-QROM := DFS[ID]. The key generation algorithm is IGen from Figure 13, where the secret key also contains a random key K for the pseudorandom function Sam(K ‖ ·). The bound 200/(1− δ) on κ can be ignored as there is only a δ200/(1−δ) < exp(−200) chance that it will be reached in any call to the signing procedure. Its presence is for consistency with the generic signing algorithm in Section 3.1. 
Lemma 4.8 states that as long as 4γ + 2 and 2γ′ < √ q/2, we will have AdvCUR 
ID (C) < ( 
32γγ′ q 
)nk . The 
parameters in Table 1 indeed satisfy the preconditions, and so AdvCUR ID (C) < 
( 32γγ′ 
q 
)nk < 2−865. 
We finally turn to bounding εls. Notice that Lemma 4.5 directly implies that 
εls ≤ 1 
|ChSet| + 2 · |ChSet|2 · ( 
32γγ′ 
q 
)nk . 
The size of the challenge set ChSet defined in Equation (8) is larger than 2265, and so the above is at most 
εls ≤ 2−265 + 2−334 ≤ 2−264. 
Plugging everything into the equation at the end of Section 3.1, we obtain 
AdvUF-CMA Dilithium-QROM(A) ≤ AdvLOSS 
ID (B) + AdvCUR ID (C) + 8 · (QH + 1)2 · εls 
+ AdvPR Sam(D) + 200 
(1− δ) ·QS · εzk + 2−α 
< AdvMLWE ID (B) + Q2 
H · 2−261 + AdvPR Sam(D). 
Table 1 also shows that the parameters of the MLWE problem are chosen such that it provides 128 bits of quantum security (using the same metric as was used in the original Dilithium scheme [DLL+17].) Assuming Sam provides 128 bits security when used as a pseudorandom function, we conclude that for all quantum adversaries running in time at most 2128 and making 1 ≤ QH ≤ 2128 (quantum) queries to H, and we have 
AdvUF-CMA Dilithium-QROM(A) 
Time(A) ≤ AdvMLWE ID (B) 
Time(B) + AdvPR Sam(D) 
Time(D) + QH · 2−261 ≤ 2−128 
25
Dilithium-QROM Dilithium [DLL+17] recomm. very high recomm. very high 
q (ring modulus) 245 − 21283 245 − 21283 223 − 8191 223 − 8191 n (ring dimension) 512 512 256 256 
(k, `) (dimension of matrix A) (4, 4) (5, 5) (5, 4) (6, 5) d (dropped bits from t) 15 15 144 14 # of ±1′s in c ∈ ChSet 46 46 60 60 
γ s.t 2γ | q − 1 905679 905679 261888 261888 γ′ (≈ max. sig. coefficient) 905679 905679 523776 523776 
η (maximum coefficient of s1, s2) 7 3 5 3 β (= η·(# of ±1′s in c)) 322 138 2755 175 
pk size (bytes) 7712 9632 1472 1760 sig size (bytes) 5690 7098 2701 3366 
Exp. Repeats (1/(1− δ) from Lemma 4.4) 4.3 2.2 6.6 4.3 
BKZ block-size to break LWE 480 600 485 595 Best Known Classical bit-cost 140 175 141 174 Best Known Quantum bit-cost 127 159 128 158 BKZ block-size to break SIS NA NA 475 605 Best Known Classical bit-cost NA NA 138 176 Best Known Quantum bit-cost NA NA 125 160 
Table 1: Parameters for Dilithium-QROM and Dilithium. The security analysis for the MLWE and MSIS problems is as described in [DLL+17]. 
The signature size in Dilithium-QROM is (n · ` · (dlog(2γ)e) + nk + 46 · (log(n) + 1))/8 bytes, while the public key is (n · k · (dlog(q)e − d) + 256)/8 bytes. 
In Table 1, we compare the parameters from the current scheme, which can be proved secure based on the hardness of MLWE in the QROM, to those of the original Dilithium scheme from [DLL+17], which only has a classical security reduction from the combination of MLWE and MSIS (we introduce this latter problem in the next section). One can see that the sum of the public key and signature sizes are approximately 3.2 times larger in Dilithium-QROM than in Dilithium. 
4.5 Security Assumptions for Non-Lossy Schemes The reduction from the MLWE problem to the hardness of the Dilithium-QROM scheme was a direct consequence of Theorem 3.1, which is itself a combination of Theorem 3.2 and Theorem 3.4. In this section, we consider the security of schemes for which Theorem 3.4 is inapplicable. In particular, in these schemes it is no longer true that a computationally-unbounded adversary cannot win the LOSSY-IMP game. The reason that one would like to use schemes constructed in such a manner is because they turn out to be more efficient. In particular, the original Dilithium scheme6 [DLL+17], which is virtually identical to the Dilithium-QROM presented in this paper except for the parameter sizes, has outputs (of the public key plus signature) that are smaller by a factor of a little over 3 (see Table 1). 
But while the Dilithium scheme has a security reduction from standard lattice problems in the classical random-oracle model, there is no such reduction in the quantum random-oracle model. Nevertheless, it is 
5For added compactness of the public key, the size of d (i.e. the amount of bits that one can drop from t) can be such that the necessary condition ‖ct0‖∞ < γ is not always satisfied. This would invalidate the correctness of the scheme – in particular Equation (14). Nevertheless, if this condition is satisfied most of the time and the signer simply checks whether ‖ct0‖∞ < γ before sending the signature (and aborts the signing attempt otherwise), then the scheme retains its correctness property. Since for security, we assumed that t0 is known to the adversary, this check does not affect security. In the Dilithium scheme, this check is performed at the end of the while loop of the signing algorithm. 
5The β values for Dilithium were chosen such that Prs←Sη,c←ChSet[‖sc‖∞ > β] is very close to 0. Increasing / decreasing the value of β changes the value δ, which has an effect on the run-time of the scheme. 
6We refer to the deterministic version of the scheme. 
26
unclear whether this lack of reduction implies any weakness against quantum attacks. It would therefore be useful to understand exactly what assumptions the more efficient scheme is relying on in the quantum random-oracle model. 
Let us suppose that the parameters for the Dilithium scheme are set such that Theorem 3.2 is still applicable. That is, suppose that εzk = 0, α is very large, and the scheme is commitment-recoverable. In this case, ignoring the 2−α+1 term, Theorem 3.2 states that the security of the full signature scheme is exactly the security of the UF-NMA signature scheme in the quantum random-oracle model. Since the adversary does not obtain any valid signatures in the UF-NMA security game, the security assumption of such signatures is non-interactive. 
Below, we recall the standard MSIS assumption and then define a new assumption, SelfTargetMSIS, upon which the security of Dilithium is based. We also point out that in the classical random-oracle model, there is a (non-tight) reduction from the MSIS to the SelfTargetMSIS problem. Then we show that the Dilithium scheme for which Theorem 3.4 is not necessarily applicable, still has a security reduction from the combination of MLWE and SelfTargetMSIS problems. 
4.5.1 The MSIS and SelfTargetMSIS Problems 
The MSIS problem [LS15] is a generalization of the SIS [Ajt96] and Ring-SIS [PR06, LM06] problems in the same way that MLWE is a generalization of LWE and Ring-LWE. To an algorithm A we associate the advantage function AdvMSIS 
m,k,γ(A) to solve the (Hermite Normal Form) MSISm,k,γ problem over the ring Rq as 
AdvMSIS m,k,γ(A) := Pr 
[ 0 < ‖y‖∞ ≤ γ ∧ [ I | A ] · y = 0 | A← Rm×k 
q ; y← A(A) ] . 
As for SIS and Ring-SIS, it was shown that solving MSIS for certain parameters is as hard as worst-case instances of lattice problems over algebraic lattices of a certain form [LS15]. 
Suppose that H : {0, 1}∗ → ChSet is a cryptographic hash function. To an algorithm A we associate the advantage function AdvSelfTargetMSIS 
H,m,k,γ (A) to solve the SelfTargetMSISH,m,k,γ problem over the ring Rq as 
AdvSelfTargetMSIS H,m,k,γ (A) := 
Pr [ ‖y‖∞ ≤ γ ∧ H([ I | A ] · y ‖ M ) = c 
∣∣∣∣A← Rm×k q ; 
( y := 
[ r c 
] ,M ) ← A|H〉(A) 
] . 
If A only has classical access to H, then there is a reduction, using the forking lemma [PS00, BN06], to prove that AdvSelfTargetMSIS 
H,m,k,γ (B) ≈ √ 
AdvMSIS m,k,2γ(A)/QH, where QH is the number of classical queries to 
H.7 This reduction is standard and is implicit in the (classical) security proofs of digital signatures based on the hardness of the SIS problem (cf. [Lyu12, DLL+17]).For completeness, we give its sketch below. 
If A is a solver for the SelfTargetMSISH,m,k,γ problem, then B passes the A from his MSISm,k,2γ instance to A and replies to A’s queries H(W ‖ M ) with uniformly random c ∈ ChSet. If A returns 
a solution ( 
y = [ r c 
] ,M ) 
to SelfTargetMSISH,m,k,γ , then B reruns A with the same randomness, but 
reprograms the “winning” query H([ I | A ] · y ‖ M ) to a different random element c′. (We’re assuming that in order to “win” with (y,M ), A must have queried H([ I | A ] · y ‖ M ) – if not then he is able to break the second-preimage resistance of H.) The forking lemma states that then A has a 1/QH probability 
of succeeding using the same query (see, e.g., [BN06]). If A then outputs a solution ( 
y′ = [ r′ c′ ] ,M ) 
such that H([ I | A ] · y′ ‖ M ) = c′ with [ I | A ] · y = [ I | A ] · y′, then [ I | A ] · (y − y′) = 0 with ‖y‖∞, ‖y′‖∞ ≤ γ. Since c 6= c′, we know that 0 < ‖y− y′‖∞ ≤ 2γ, and B has a solution to MSISm,k,2γ . 
Note that the reduction loses a factor of QH in the success probability and also the size of the coefficients in the solution to MSIS is larger than that in SelfTargetMSIS, which could lead one to conclude that SelfTargetMSIS is an easier problem. But this is the standard “tightness loss” in the Fiat-Shamir transform protocol that is not constructed from lossy identification schemes. Since its first use over three decades ago, however, there have been no attacks that break the Fiat-Shamir signature with more success than the underlying problem upon which the scheme is based. 
7This can be improved to QHAdvSelfTargetMSIS H,m,k,γ (B)/Time(B) ≈ AdvMSIS 
m,k,2γ(A)/Time(A). 
27
It is therefore very reasonable to assume that unless there is some algebraic relationship between H and A, then the the SelfTargetMSISH,m,k,γ problem is as hard as MSISm,k,2γ problem.8 If A has quantum access to H, then one can no longer use the forking lemma (which is essentially rewinding) in order to get a non-tight equivalence between the MSIS and SelfTargetMSIS problems. Nevertheless, as long as H is second-preimage resistant against quantum attackers, it would again appear that some relationship between A and H needs to be exploited by the quantum attacker in order to solve the SelfTargetMSIS problem more efficiently than the MSIS one. 
4.5.2 Security based on MLWE, MSIS, and SelfTargetMSIS in the QROM 
The QROM security of (deterministic) Dilithium can be expressed as 
AdvsUF-CMA Dilithium (A) ≤ AdvMLWE 
k,`,D (B) + AdvSelfTargetMSIS H,k,`+1,ζ (C) + AdvPR 
Sam(D) + AdvMSIS k,`,ζ′(E) + 2−α+1 , (21) 
for D a uniform distribution over Sη, 
ζ = max{γ′ − β, 2γ + 1 + 2d−1 · ρ}, (22) 
where ρ is the number of ±1’s in the challenge set ChSet, and 
ζ ′ = max{2(γ′ − β), 4γ + 2}. (23) 
For a proof that the min-entropy α is greater than 255 for both parameter sets, see Appendix C. For strong unforgeability, Lemma 4.9 directly implies that AdvCUR 
ID (A) ≤ AdvMSIS k,`,ζ′(E). The bound in 
Equation (21) is then obtained by combining Theorem 3.2 with the computations from Section 4.3 and Lemma 4.10. 
Lemma 4.10 For any quantum adversary A against UF-NMA security that issues at most QH queries to the quantum random oracle |H〉, there exist quantum adversaries B and C such that 
AdvUF-NMA SIG (A) ≤ AdvMLWE 
k,`,D (B) + AdvSelfTargetMSIS H,k,`+1,ζ (C) , (24) 
and Time(B) = Time(C) = Time(A) + QH. D is the uniform distribution over Sη and ζ, ρ are as in Equation (22). 
Proof. Given an A′ = [ I | A′′ ] for A′′ ∈ Rk×(`+1) q , C writes A′′ = [ A | t ] and sets (A, t) as the public 
key of the signature scheme and sends it to A. If the pk generated by IGen is indistinguishable from uniform over Rk×` 
q ×Rk q (i.e. if the MLWEk,`,D problem is hard), then with probability AdvSelfTargetMSIS 
H,k,`+1,γ (A), A will return a signature (c, (z,h)) of some message M such that ‖z‖∞ < γ′−β satisfying the verification equation 
c = H ( UseHintq(h,Az− ct1 · 2d , 2γ) ‖ M 
) . 
From Lemma 4.1, we know that the above equality can be rewritten as 
c = H ( Az− ct1 · 2d + u ‖ M 
) , 
where ‖u‖∞ ≤ 2γ + 1. Using the fact that t = t1 · 2d + t0 where ‖t0‖∞ ≤ 2d−1, the above can be again re-written as 
c = H(Az− ct + (ct0 + u) ‖ M ) = H(Az− ct + u′ ‖ M ), (25) 
where ‖u′‖∞ ≤ ‖u‖∞ + ‖ct0‖∞ ≤ 2γ + 1 + 2d−1 · ρ. Equation (25), gives us a y ∈ Rk×(k+`+1) q such that 
H(A′y ‖ M ) = c where y = [ r c 
] and ‖y‖∞ = ‖r‖∞ = max{γ′ − β, 2γ + 1 + 2d−1 · ρ}. 
8It’s also not clear whether the γ in the SelfTargetMSIS problem actually becomes 2γ in the MSIS problem, or if that’s also an artifact of the reduction. 
28
Acknowledgments Eike Kiltz was supported in part by ERC Project ERCC (FP7/615074) and by DFG SPP 1736 Big Data. Vadim Lyubashevsky was supported by the SNSF ERC Transfer Starting Grant CRETP2-166734-FELICITY and the H2020 Project SAFEcrypto. Christian Schaffner was supported by a NWO VIDI grant (639.022.519). The authors are grateful to Dominique Unruh and the anonymous reviewers for comments and discussions. 
References [AABN02] Michel Abdalla, Jee Hea An, Mihir Bellare, and Chanathip Namprempre. From identification 
to signatures via the Fiat-Shamir transform: Minimizing assumptions for security and forwardsecurity. In Lars R. Knudsen, editor, EUROCRYPT 2002, volume 2332 of LNCS, pages 418–433. Springer, Heidelberg, April / May 2002. (Cited on page 1.) 
[ABB+17] Erdem Alkim, Nina Bindel, Johannes A. Buchmann, Özgür Dagdelen, Edward Eaton, Gus Gutoski, Juliane Krämer, and Filip Pawlega. Revisiting TESLA in the quantum random oracle model. In Post-Quantum Cryptography - 8th International Workshop, PQCrypto 2017, Utrecht, The Netherlands, June 26-28, 2017, Proceedings, pages 143–162, 2017. (Cited on page 2, 3, 4, 5.) 
[AFLT12] Michel Abdalla, Pierre-Alain Fouque, Vadim Lyubashevsky, and Mehdi Tibouchi. Tightly-secure signatures from lossy identification schemes. In David Pointcheval and Thomas Johansson, editors, EUROCRYPT 2012, volume 7237 of LNCS, pages 572–590. Springer, Heidelberg, April 2012. (Cited on page 2, 3, 4, 5, 9, 21, 36.) 
[Ajt96] Miklós Ajtai. Generating hard instances of lattice problems (extended abstract). In 28th ACM STOC, pages 99–108. ACM Press, May 1996. (Cited on page 27.) 
[ARU14] Andris Ambainis, Ansis Rosmanis, and Dominique Unruh. Quantum attacks on classical proof systems: The hardness of quantum rewinding. In 55th FOCS, pages 474–483. IEEE Computer Society Press, October 2014. (Cited on page 3.) 
[BBBV97] Charles H. Bennett, Ethan Bernstein, Gilles Brassard, and Umesh V. Vazirani. Strengths and weaknesses of quantum computing. SIAM J. Comput., 26(5):1510–1523, 1997. (Cited on page 2, 3.) 
[BBC+98] Robert Beals, Harry Buhrman, Richard Cleve, Michele Mosca, and Ronald de Wolf. Quantum lower bounds by polynomials. In 39th FOCS, pages 352–361. IEEE Computer Society Press, November 1998. (Cited on page 6.) 
[BDF+11] Dan Boneh, Özgür Dagdelen, Marc Fischlin, Anja Lehmann, Christian Schaffner, and Mark Zhandry. Random oracles in a quantum world. In Dong Hoon Lee and Xiaoyun Wang, editors, ASIACRYPT 2011, volume 7073 of LNCS, pages 41–69. Springer, Heidelberg, December 2011. (Cited on page 2, 3, 6, 7.) 
[BG14] Shi Bai and Steven D. Galbraith. An improved compression technique for signatures based on learning with errors. In Josh Benaloh, editor, CT-RSA 2014, volume 8366 of LNCS, pages 28–47. Springer, Heidelberg, February 2014. (Cited on page 2, 5.) 
[BHLY16] Leon Groot Bruinderink, Andreas Hülsing, Tanja Lange, and Yuval Yarom. Flush, gauss, and reload - A cache attack on the BLISS lattice-based signature scheme. In Benedikt Gierlichs and Axel Y. Poschmann, editors, CHES 2016, volume 9813 of LNCS, pages 323–345. Springer, Heidelberg, August 2016. (Cited on page 3.) 
[BN06] Mihir Bellare and Gregory Neven. Multi-signatures in the plain public-key model and a general forking lemma. In Ari Juels, Rebecca N. Wright, and Sabrina De Capitani di Vimercati, editors, ACM CCS 06, pages 390–399. ACM Press, October / November 2006. (Cited on page 2, 27.) 
29
[BPS16] Mihir Bellare, Bertram Poettering, and Douglas Stebila. From identification to signatures, tightly: A framework and generic transforms. In Jung Hee Cheon and Tsuyoshi Takagi, editors, ASIACRYPT 2016, Part II, volume 10032 of LNCS, pages 435–464. Springer, Heidelberg, December 2016. (Cited on page 4, 10.) 
[BR93] Mihir Bellare and Phillip Rogaway. Random oracles are practical: A paradigm for designing efficient protocols. In V. Ashby, editor, ACM CCS 93, pages 62–73. ACM Press, November 1993. (Cited on page 2, 7.) 
[BR06] Mihir Bellare and Phillip Rogaway. The security of triple encryption and a framework for code-based game-playing proofs. In Serge Vaudenay, editor, EUROCRYPT 2006, volume 4004 of LNCS, pages 409–426. Springer, Heidelberg, May / June 2006. (Cited on page 6.) 
[DDLL13] Léo Ducas, Alain Durmus, Tancrède Lepoint, and Vadim Lyubashevsky. Lattice signatures and bimodal Gaussians. In Ran Canetti and Juan A. Garay, editors, CRYPTO 2013, Part I, volume 8042 of LNCS, pages 40–56. Springer, Heidelberg, August 2013. (Cited on page 2, 3, 5.) 
[DLL+17] Léo Ducas, Tancrède Lepoint, Vadim Lyubashevsky, Peter Schwabe, Gregor Seiler, and Damien Stehlé. CRYSTALS - Dilithium: Digital signatures from module lattices. IACR Cryptology ePrint Archive, 2017:633, 2017. To appear in TCHES 2018. (Cited on page 2, 3, 4, 16, 17, 24, 25, 26, 27.) 
[DLP14] Léo Ducas, Vadim Lyubashevsky, and Thomas Prest. Efficient identity-based encryption over NTRU lattices. In Palash Sarkar and Tetsu Iwata, editors, ASIACRYPT 2014, Part II, volume 8874 of LNCS, pages 22–41. Springer, Heidelberg, December 2014. (Cited on page 2, 3.) 
[EFGT17] Thomas Espitau, Pierre-Alain Fouque, Benoît Gérard, and Mehdi Tibouchi. Side-channel attacks on BLISS lattice-based signatures - exploiting branch tracing against strongswan and electromagnetic emanations in microcontrollers. IACR Cryptology ePrint Archive, 2017:505, 2017. (Cited on page 3.) 
[ES15] Edward Eaton and Fang Song. Making existential-unforgeable signatures strongly unforgeable in the quantum random-oracle model. In 10th Conference on the Theory of Quantum Computation, Communication and Cryptography, TQC 2015, May 20-22, 2015, Brussels, Belgium, pages 147–162, 2015. (Cited on page 2.) 
[FS87] Amos Fiat and Adi Shamir. How to prove yourself: Practical solutions to identification and signature problems. In Andrew M. Odlyzko, editor, CRYPTO’86, volume 263 of LNCS, pages 186–194. Springer, Heidelberg, August 1987. (Cited on page 1.) 
[GLP12] Tim Güneysu, Vadim Lyubashevsky, and Thomas Pöppelmann. Practical lattice-based cryptography: A signature scheme for embedded systems. In Emmanuel Prouff and Patrick Schaumont, editors, CHES 2012, volume 7428 of LNCS, pages 530–547. Springer, Heidelberg, September 2012. (Cited on page 2, 5.) 
[HRS16] Andreas Hülsing, Joost Rijneveld, and Fang Song. Mitigating multi-target attacks in hash-based signatures. In Chen-Mou Cheng, Kai-Min Chung, Giuseppe Persiano, and Bo-Yin Yang, editors, PKC 2016, Part I, volume 9614 of LNCS, pages 387–416. Springer, Heidelberg, March 2016. (Cited on page 4, 7, 32.) 
[KMP16] Eike Kiltz, Daniel Masny, and Jiaxin Pan. Optimal security proofs for signatures from identification schemes. In Matthew Robshaw and Jonathan Katz, editors, CRYPTO 2016, Part II, volume 9815 of LNCS, pages 33–61. Springer, Heidelberg, August 2016. (Cited on page 2, 24.) 
[KTX08] Akinori Kawachi, Keisuke Tanaka, and Keita Xagawa. Concurrently secure identification schemes based on the worst-case hardness of lattice problems. In Josef Pieprzyk, editor, ASIACRYPT 2008, volume 5350 of LNCS, pages 372–389. Springer, Heidelberg, December 2008. (Cited on page 2, 5.) 
30
[KW03] Jonathan Katz and Nan Wang. Efficiency improvements for signature schemes with tight security reductions. In Sushil Jajodia, Vijayalakshmi Atluri, and Trent Jaeger, editors, ACM CCS 03, pages 155–164. ACM Press, October 2003. (Cited on page 2, 21, 36.) 
[LM06] Vadim Lyubashevsky and Daniele Micciancio. Generalized compact Knapsacks are collision resistant. In Michele Bugliesi, Bart Preneel, Vladimiro Sassone, and Ingo Wegener, editors, ICALP 2006, Part II, volume 4052 of LNCS, pages 144–155. Springer, Heidelberg, July 2006. (Cited on page 27.) 
[LN17] Vadim Lyubashevsky and Gregory Neven. One-shot verifiable encryption from lattices. In Jean-Sébastien Coron and Jesper Buus Nielsen, editors, EUROCRYPT 2017, Part I, volume 10210 of LNCS, pages 293–323. Springer, Heidelberg, May 2017. (Cited on page 5, 16, 21.) 
[LPR10] Vadim Lyubashevsky, Chris Peikert, and Oded Regev. On ideal lattices and learning with errors over rings. In Henri Gilbert, editor, EUROCRYPT 2010, volume 6110 of LNCS, pages 1–23. Springer, Heidelberg, May 2010. (Cited on page 17.) 
[LS15] Adeline Langlois and Damien Stehlé. Worst-case to average-case reductions for module lattices. Des. Codes Cryptography, 75(3):565–599, 2015. (Cited on page 17, 27.) 
[Lyu08] Vadim Lyubashevsky. Lattice-based identification schemes secure under active attacks. In Ronald Cramer, editor, PKC 2008, volume 4939 of LNCS, pages 162–179. Springer, Heidelberg, March 2008. (Cited on page 2.) 
[Lyu09] Vadim Lyubashevsky. Fiat-Shamir with aborts: Applications to lattice and factoring-based signatures. In Mitsuru Matsui, editor, ASIACRYPT 2009, volume 5912 of LNCS, pages 598–616. Springer, Heidelberg, December 2009. (Cited on page 2, 3, 4, 5, 10, 16.) 
[Lyu12] Vadim Lyubashevsky. Lattice signatures without trapdoors. In David Pointcheval and Thomas Johansson, editors, EUROCRYPT 2012, volume 7237 of LNCS, pages 738–755. Springer, Heidelberg, April 2012. (Cited on page 2, 5, 27.) 
[Lyu16] Vadim Lyubashevsky. Digital signatures based on the hardness of ideal lattice problems in all rings. In Jung Hee Cheon and Tsuyoshi Takagi, editors, ASIACRYPT 2016, Part II, volume 10032 of LNCS, pages 196–214. Springer, Heidelberg, December 2016. (Cited on page 2, 5.) 
[MV03] Daniele Micciancio and Salil P. Vadhan. Statistical zero-knowledge proofs with efficient provers: Lattice problems and more. In Dan Boneh, editor, CRYPTO 2003, volume 2729 of LNCS, pages 282–298. Springer, Heidelberg, August 2003. (Cited on page 2.) 
[NC00] Michael A. Nielsen and Issac L. Chuang. Quantum Computation and Quantum Information. Cambridge University Press, 2000. (Cited on page 6.) 
[NIS13] NIST Special Publication 800-165 Computer Security Division 2012 Annual Re-port, June 2013. http://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP. 800-165.pdf (page 39); accessed 30-January-2014. (Cited on page 2.) 
[PR06] Chris Peikert and Alon Rosen. Efficient collision-resistant hashing from worst-case assumptions on cyclic lattices. In Shai Halevi and Tal Rabin, editors, TCC 2006, volume 3876 of LNCS, pages 145–166. Springer, Heidelberg, March 2006. (Cited on page 27.) 
[PS00] David Pointcheval and Jacques Stern. Security arguments for digital signatures and blind signatures. Journal of Cryptology, 13(3):361–396, 2000. (Cited on page 2, 27.) 
[PV05] Pascal Paillier and Damien Vergnaud. Discrete-log-based signatures may not be equivalent to discrete log. In Bimal K. Roy, editor, ASIACRYPT 2005, volume 3788 of LNCS, pages 1–20. Springer, Heidelberg, December 2005. (Cited on page 2.) 
[Reg05] Oded Regev. On lattices, learning with errors, random linear codes, and cryptography. In Harold N. Gabow and Ronald Fagin, editors, 37th ACM STOC, pages 84–93. ACM Press, May 2005. (Cited on page 17.) 
31
[Sho04] Victor Shoup. Sequences of games: a tool for taming complexity in security proofs. Cryptology ePrint Archive, Report 2004/332, 2004. http://eprint.iacr.org/2004/332. (Cited on page 6.) 
[SSH11] Koichi Sakumoto, Taizo Shirai, and Harunaga Hiwatari. Public-key identification schemes based on multivariate quadratic polynomials. In Phillip Rogaway, editor, CRYPTO 2011, volume 6841 of LNCS, pages 706–723. Springer, Heidelberg, August 2011. (Cited on page 5.) 
[Ste94] Jacques Stern. A new identification scheme based on syndrome decoding. In Douglas R. Stinson, editor, CRYPTO’93, volume 773 of LNCS, pages 13–21. Springer, Heidelberg, August 1994. (Cited on page 2.) 
[Unr15] Dominique Unruh. Non-interactive zero-knowledge proofs in the quantum random oracle model. In Elisabeth Oswald and Marc Fischlin, editors, EUROCRYPT 2015, Part II, volume 9057 of LNCS, pages 755–784. Springer, Heidelberg, April 2015. (Cited on page 2, 3, 5.) 
[Unr17a] Dominique Unruh. Post-quantum security of fiat-shamir. In Tsuyoshi Takagi and Thomas Peyrin, editors, ASIACRYPT 2017, Part I, volume 10624 of LNCS, pages 65–95. Springer, Heidelberg, December 2017. (Cited on page 3, 4, 5.) 
[Unr17b] Dominique Unruh. Post-quantum security of fiat-shamir. Cryptology ePrint Archive, Report 2017/398, 2017. http://eprint.iacr.org/2017/398. (Cited on page 3, 5, 6.) 
[Zha12a] Mark Zhandry. How to construct quantum random functions. In 53rd FOCS, pages 679–687. IEEE Computer Society Press, October 2012. (Cited on page 4, 7, 32.) 
[Zha12b] Mark Zhandry. Secure identity-based encryption in the quantum random oracle model. In Reihaneh Safavi-Naini and Ran Canetti, editors, CRYPTO 2012, volume 7417 of LNCS, pages 758–775. Springer, Heidelberg, August 2012. (Cited on page 7.) 
A Omitted Proofs A.1 Proof of Lemma 2.1 The following lemma gives a lower bound on the number of quantum oracle queries to an oracle g : X → {0, 1}, such that for each x ∈ X , g(x) is distributed according to Bλ, to find an x satisfying g(x) = 1. It is a reformulation of [HRS16, Theorem 1] whose proof is based on [Zha12a]. 
Lemma A.1 (Generic Search Problem) Let λ ∈ [0, 1]. Then, for any (unbounded, quantum) algorithm A issuing at most Q quantum queries to |g〉, Pr[GSPA 
λ ⇒ 1] ≤ 8 · λ · (Q + 1)2, where Game GSPλ is defined in Figure 18. 
GAME GSPλ 01 for all x ∈ X : g(x)← Bλ 02 x ← A|g〉 03 return g(x) 
Figure 18: The generic quantum search game GSPλ with Bernoulli parameter λ ∈ [0, 1]. 
Proof of Lemma 2.1. We reduce GSPB to GSP as follows. Let A = (A1,A2) be an adversary against GSPBλ making Q quantum queries to oracle gA. Let Berλ be a probabilistic algorithm that returns x ← Berλ, distributed according to the Bernoulli distribution Bλ. Recall that x := Berλ(r) denotes the deterministic execution of Berλ using explicitly given random tape r . In Figure 19 we define an adversary B against GSPλ, also making Q quantum queries to oracle gB. It is easy to verify that for each x ∈ X , the output distribution of gA is Bλ(x). Consistency of oracle gA is assured by deriving the randomness to sample yA in case yB = 1 (line 08) using fixed random coins f (x), derived by a 2Q-wise independent hash 
32
Adversary B|gB〉 
01 Pick 2Q-wise independent hash f2Q 02 (λ(x))x∈X ← A1 03 If ∃x ∈ X s.t. λ(x) > λ then return 0 04 x ← A|gA〉 
2 05 return x 
gA(x) quantum access 06 yB := gB(x) 07 if yB = 0 then yA := 0 08 if yB = 1 then yA := Berλ(x)/λ(f2Q(x)) 09 return yA 
Figure 19: Adversary A = (A1,A2) in game GSPBλ for the proof of Lemma 2.1. 
function f (which looks like a perfectly random function to A). Consider the output x of the second part A2. Since gA(x) = 1 implies gB(x) = 1, we have 
Pr[GSPBA λ ⇒ 1] ≤ Pr[GSPB 
λ ⇒ 1] ≤ 8(Q + 1)2λ. 
This completes the proof. 
A.2 Proof of Theorem 3.3 Proof. Let A be a quantum adversary against the UF-CMA security of SIG, issuing at most QH queries to |H〉. and at most QS queries to Sign1. Consider the games given in Figure 20. 
GAME G0-G2 01 (pk, sk′)← IGen(par) 02 K ← {0, 1}n 
03 sk = (sk′,K) 04 (M∗, σ∗)← A|H〉,Sign(pk) 05 Parse σ∗ = (W ∗,Z∗) 06 c∗ := H(W ∗ ‖ M∗) 07 if c∗ 6= H′(W ∗ ‖ M∗) then return 0 G2 08 return JM∗ 6∈ MK ∧ V(pk,W ∗, c∗,Z∗) 
GetTrans(M , ctr) G0 09 κ := 0 10 while ZM,ctr = ⊥ and κ ≤ κm do 11 κ := κ+ 1 12 (WM,ctr ,St) := P1(sk; RF(0 ‖ M ‖ κ ‖ ctr)) 13 cM,ctr := H(WM,ctr ‖ M ) 14 ZM,ctr := P2(sk,WM,ctr , cM,ctr ,St; RF(1 ‖ M ‖ κ ‖ ctr)) 15 if ZM,ctr = ⊥ then (WM,ctr , cM,ctr) = (⊥,⊥) 16 return (WM,ctr , cM,ctr ,ZM,ctr) 
Sign(M ) 17 ctrM := ctrM + 1 18 M =M∪ {M} 19 (WM,ctrM , cM,ctrM ,ZM,ctrM ) := GetTrans(M , ctrM ) 20 return σM,ctrM := (WM,ctrM ,ZM,ctrM ) 
H(W ‖ M ) quantum access 21 for ctr = 1 to QS do G1-G2 22 (WM,ctr , cM,ctr ,ZM,ctr) := GetTrans(M , ctr) G1-G2 23 if W = WM,ctr then return cM,ctr G1-G2 24 return H′(W ‖ M ) 
GetTrans(M , ctr) G1-G2 25 κ := 0 26 while ZM,ctr = ⊥ and κ ≤ κm do 27 κ := κ+ 1 28 (WM,ctr , cM,ctr ,ZM,ctr) := Sim(pk; RF(M ‖ κ ‖ ctr)) 29 if ZM,ctr = ⊥ then (WM,ctr , cM,ctr) = (⊥,⊥) 30 return (WM,ctr , cM,ctr ,ZM,ctr) 
Figure 20: Games G0-G2 for the proof of Theorem 3.3. Here RF and H′ are perfect random function that cannot be accessed by A. 
Game G0. Note that game G0 is the original UF-CMA game, where in lines 12 and 14 the randomness of P1 and P2 is derived using a perfect random function RF as follows. For each message M , the counter 1 ≤ ctrM ≤ QS counts the number of classical signing queries made so far with respect to M . Counter ctrM is then fed into RF in lines 12 and 14 to generate fresh randomness for each invocation of Sign(M ). This shows 
Pr[GA 0 ⇒ 1] = AdvUF-CMA 
SIG (A) . 
Game G1. This game computes the signatures on M using the naHVZK simulation algorithm Sim and patches the quantum random oracle H accordingly. 
Concretely, consider the ctrM ’s classical query to Sign(·) on message M and let κM be the smallest integer 1 ≤ κ ≤ κm satisfying (W , c,Z) := Sim(pk; RF(M ‖ κ ‖ ctrM)) and Z 6= ⊥. If no such integer 
33
exists, then we define κM := ⊥. It deterministically computes 
(WM,ctrM , cM,ctrM ,ZM,ctrM ) := 
GetTrans(M , ctrM ) = { 
Sim(pk; RF(M ‖ κM ‖ ctrM )) 1 ≤ κM ≤ κm 
(⊥,⊥,⊥) κM = ⊥ (26) 
The signature on M is returned as 
σM,ctrM := (WM,ctrM ,ZM,ctrM ). 
By the naHVZK property and the union bound, the distribution of σM,ctrM has statistical distance at most κmεzk from one computed in game G0. To ensure that σM,ctrM is a valid signature on M , in line 23 the random oracle is patched such that H(WM,ctrM ‖ M ) = cM,ctrM holds. Concretely, a query W ‖ M to quantum random oracle H with non-zero amplitude is patched with H(W ‖ M ) := cM,ctrM iff there exists 1 ≤ ctr ≤ QS such that W = WM,ctrM , where cM,ctrM and WM,ctrM are computed by GetTrans(M , ctr). Note that the out distribution of the random oracle H in this game remains unchanged since cM,ctrM 
generated by the naHVZK simulator Sim is required to be uniformly distributed. Overall, by a union bound we obtain 
|Pr[GA 1 ⇒ 1]− Pr[GA 
0 ⇒ 1]| ≤ κmQS · εzk . 
Game G2. This game additional defined it output as 0 in line 07 if H(W ∗ ‖ M ∗) 6= H′(W ∗ ‖ M ∗), i.e., if H(W ∗ ‖ M ∗) was patched before in line 23. Games G1 and G2 can only differ if there exists 1 ≤ ctr ≤ QS such that WM∗,ctr = W ∗ and M ∗ 6∈ M. Since M ∗ 6∈ M, the random variables WM∗,ctr (1 ≤ ctr ≤ QS) were not yet revealed as part of an established signature and are completely hidden from the view of the adversary. It has α bits of min-entropy, meaning with probability at least 1− 2−α over the keys, we have Pr[WM∗,ctr = W ∗] ≤ 2−α for all 1 ≤ ctr ≤ QS . By a union bound we obtain 
|Pr[GA 2 ⇒ 1]− Pr[GA 
1 ⇒ 1]| ≤ QS2−α+1 . 
To bound |Pr[GA 2 ⇒ 1], consider adversary B against the UF-NMA game from Figure 21 having 
quantum access to random oracle H′. It perfectly simulates A’s view in game G2, using its own random oracle H′ to simulate H and perfectly simulating the random function RF with a 2κmQHQS -wise independent hash function. Assume A’s forgery (M ∗, σ∗) is valid in game G2, i.e., M ∗ 6∈ M and V(pk,W ∗, c∗,Z∗), where c∗ = H(W ∗ ‖ M ∗). If H(W ∗ ‖ M ∗) = H′[W ∗ ‖ M ∗] then (M ∗, σ∗) is also a valid forgery in B’s UF-NMA game. Hence, 
Pr[GA 2 ⇒ 1] = AdvUF-NMA 
SIG (B) . 
The running time Time(B) of adversary B is given by the time Time(A) to run A as a blackbox in game 
Adversary B|H ′〉(pk) 
01 (M∗, σ∗)← A|H〉,Sign(pk) 02 Parse σ∗ = (W ∗,Z∗) 03 c∗ := H(W ∗ ‖ M∗) 04 if WM∗ = W ∗ then abort 05 if JM∗ 6∈ MK ∧ V(pk,W ∗, c∗,Z∗) then return (M∗, σ∗) 06 abort 
Figure 21: Adversary B against UF-NMA security of SIG with quantum access to random oracle H′. The oracles Sign and H simulated by B are defined as in game G2 of Figure 20. 
G2 where in every of the QH oracle queries, at most O(κmQS) computations need to be performed. The proof follows by collecting the probabilities. Strong unforgeability. For sUF-CMA security we consider exactly the same games with the difference that in all games the winning condition in line 08 is changed to J(M ∗, σ∗) 6∈ MK ∧ V(pk,W ∗, c∗,Z∗) to account for strong unforgerability, whereM now records all tuples (M , σM) of previously established messages/signature pairs. 
34
The difference between games G1 and G2 is that game G2 returns 0 in line 07 if c∗ 6= H′(W ∗ ‖ M ∗), i.e., if H(W ∗ ‖ M ∗) was previously patched in line 23 with H(W ∗ ‖ M ∗) := cM∗ . Games G1 and G2 can only differ if there exists 1 ≤ ctr∗ ≤ QS such that WM∗,ctr∗ = W ∗, M ∗ 6∈ M, and V(pk,W ∗, c∗,Z∗) = 1. (In that case G2 returns 0 and G1 returns 1.) 
We distinguish two cases. If (M ∗, ·) 6∈ M then we are in the situation that the adversary did not query a signature on M ∗ and we can use the same argument as in standard unforgeability to argue |Pr[GA 
2 ⇒ 1]− Pr[GA 1 ⇒ 1]| ≤ QS · 2−α+1. It leaves to handle the case (M ∗, ·) ∈M, i.e., the adversary 
obtained a signatures σM∗ = (WM∗ ,ZM∗) on message M ∗ and submits a correct forgery σ∗ = (W ∗,Z∗) satisfying W ∗ = WM∗,ctr∗ and Z∗ 6= ZM∗,ctr∗ for some 1 ≤ ctr∗ ≤ QS . The problem of finding values (W ∗, c∗,ZM∗,ctr∗ ,Z∗) with two accepting transcripts (W ∗, c∗,Z∗) and (W ∗, c∗,ZM∗,ctr∗) is exactly bounded by the advantage of an adversary C against the CUR experiment, i.e., |Pr[GA 
2 ⇒ 1]− Pr[GA 1 ⇒ 
1]| ≤ AdvCUR ID (C). 
In combination this proves 
|Pr[GA 2 ⇒ 1]− Pr[GA 
1 ⇒ 1]| ≤ QS · 2−α+1 + AdvCUR ID (C). 
Finally, a straightforward modification of adversary B against UF-NMA security to account for the strong unforgerability check proves 
Pr[GA 2 ⇒ 1] = AdvUF-NMA 
SIG (B) 
and completes proof of sUF-CMA security. 
B A Simple ID / Signature Scheme and a Security Proof Sketch The identification scheme which we will be converting into a signature scheme is presented in Figure 22. We do not set concrete parameters, since we will only provide a high-level sketch of the proof of its security, but the reader can look at the Dilithium-QROM column of Table 1. Other than the sizes of the keys and signatures (which will be larger for our simple scheme), the other parameters remain virtually the same. 
IGen(par) 01 ρ← {0, 1}256 
02 A← Rk×k q := Sam(ρ) 
03 s1, s2 ← Sk η 
04 t := As1 + s2 05 pk = (ρ, t) 06 sk = (ρ, s1, s2) 07 return (pk, sk) 
P1(sk) 08 A← Rk×k 
q := Sam(ρ) 09 y1,y2 ← Sk 
γ 
10 w := Ay1 + y2 11 return (W = w,St = (w,y1,y2)) 
P2(sk,W = w, c,St = (w,y1,y2)) 12 z1 := y1 + cs1, z2 := y2 + cs2 13 if ‖z1‖∞ ≥ γ − β or ‖z2‖∞ ≥ γ − β 14 then (z1, z2) := ⊥ 15 return Z = (z1, z2) 
V(pk,W = w, c,Z = (z1, z2)) 16 return Jw = Az1 + z2 − ctK and J‖z1‖∞ < γ − βK and J‖z2‖∞ < γ − βK 
Figure 22: A simple, unoptimized version of our ID scheme – a concrete instantiation based on the hardness of the MLWE problem of the commitment-recoverable (Definition 2.4) canonical identification scheme in Figure 4. 
It is not hard to verify that the protocol is correct in the case that the Prover doesn’t send ⊥. One can also compute the probability that ⊥ is sent using Equation (12) in Lemma 4.4 for z1 and z2. 
We will now sketch the proofs of the properties that are needed for the protocol in 22 to be converted to a quantum-secure digital signature scheme. We first need to prove the identification scheme is perfectly naHVZK, i..e., the distribution of the output of the Trans algorithm (Figure 23, left) that uses the secret key as input is exactly that of the Sim algorithm (Figure 23, right) that uses only the public key as input. This involves showing that the distribution of z1, z2 is independent of the exact sk. This proof is fairly standard, and we give it for an analogous statement for our optimized scheme in Lemma 4.3. The proof 
35
of what we need for the non-optimized scheme comes from applying Equation (9) twice. This will prove that the εzk in the statement of Theorem 3.1 is 0. 
Algorithm Trans(sk): 01 A← Rk×k 
q := Sam(ρ) 02 y1,y2 ← Sk 
γ−1 03 w := Ay1 + y2 04 c ← ChSet 05 z1 := y1 + cs1, z2 := y2 + cs2 06 if ‖z1‖∞ ≥ γ − β or ‖z2‖∞ ≥ γ − β, then return ⊥ 07 return (c, (z1, z2)) 
Algorithm Sim(pk): 08 A← Rk×k 
q := Sam(ρ) 
09 with probability 1− ( 
1− |Sk γ−β−1| |Sk γ−1| 
)2 
, 
return ⊥ 10 z1, z2 ← Sk 
γ−β−1 11 c ← ChSet 12 return (c, (z1, z2)) 
Figure 23: Left: a real transcript of our simple scheme output by the transcript algorithm Trans(sk); Right: a simulated transcript output by the Sim(pk) algorithm. 
We next have to show lossyness. In particular, we need to show that if the public key generated as in Figure 24, then no (unbounded) Adverasry C can win the LOSSY-IMP game from Figure 6, which is adapted to our scheme in Figure 25, with noticeable probability. 
LossyIGen(par) 01 ρ← {0, 1}256; A← Rk×k 
q := Sam(ρ) 02 t← Rk 
q 03 return pk = (ρ, t) 
Figure 24: The lossy instance generator LossyIGen for the simple scheme. 
GAME LOSSY-IMP: 01 pk ls := (ρ, t)← LossyIGen(par) 02 (w,St)← C(pk ls) 03 c ← ChSet 04 (z1, z2)← C(St, c) 05 return Jw = Az1 + z2− ctK and J‖z1‖∞ < γ−βK and J‖z2‖∞ < γ−βK 
Figure 25: The lossy impersonation game LOSSY-IMP for the simple scheme. 
The intuition for proving this follows the framework from [KW03, AFLT12]. We want to set the parameters such that for all but a negligible fraction of (A, t), for all w, there is only one c for which we can find z1, z2 that satisfy the verification equation. The proof uses a counting argument. If for some A, t, there is a w such that Az1 + z2 − ct = w = Az′1 + z′2 − c′t, then this implies that 
A(z1 − z′1) + (z2 − z′2) = (c − c′)t, 
where zi , z′i and c, c′ have small coefficients. For convenience, this can be rewritten as 
Ar1 + r2 = dt, (27) 
where d 6= 0. If the parameters are set such that all polynomials with small coefficients are invertible (and so r1 is invertible), then one can show that for each fixed r1, r2, d, the probability over the choice of A, t that Equation (27) is satisfied is at most q−kn. Thus if the total number of possible r1, r2, d is significantly less than that, then using the union bound concludes the proof. This proves that the εls term in Theorem 3.1 is very close to 1/|ChSet|. 
Lower bounding the min entropy of w (i.e. showing that the α term in Theorem 3.1 is negligible) and showing that the scheme has the Computational Unique Response (CUR) property is done using 
36
virtually the same counting argument as above. Therefore any adversary who can provide a forgery to the signature scheme in Figure 26 can also be used to produce a forgery in the identification scheme with virtually the same advantage and time. Forgery of the identification scheme is, in turn, as hard as solving the MLWE problem. 
Sign((sk,K),M ) 01 κ := 0 02 A← Rk×k 
q := Sam(ρ) 03 while (z1, z2) = ⊥ and κ ≤ 200/(1− δ) do 04 κ := κ+ 1 05 y1,y2 ← Sk 
γ−1 := Sam(K ‖ M ‖ κ) 06 w := Ay1 + y2 07 c := H(w ‖ M ) 08 z1 := y1 + cs1, z2 := y2 + cs2 09 if ‖z1‖∞ ≥ γ − β or ‖z2‖∞ ≥ γ − β then (z1, z2) := ⊥ 10 return σ = (z1, z2, c) 
Ver(pk,M , σ = (z,h, c)) 11 A← Rk×k 
q := Sam(ρ) 12 w := Az1 + z2 − ct 13 return J‖z1‖∞ < γ − βK and J‖z2‖∞ < γ − βK and Jc = H (w1 ‖ M )K 
Figure 26: The simple signature scheme. The key generation algorithm is IGen from Figure 22, where the secret key also contains a random key K for the pseudorandom function Sam(K ‖ ·). 
C Lower-bounding the min-entropy α of Dilithium In Dilithium-QROM, we were able to lower-bound α, the min-entropy of the identification scheme, by using Lemma 4.7. In Dilithium, the conditions of the Lemma are no longer satisfied, and below we give an alternate proof for bounding α. 
Lemma C.1 
Pr A←Rk×` 
q 
[ ∀w1 : Pr 
y←S` γ′−1 
[HighBitsq(Ay, 2γ) = w1] ≤ ( 
2γ + 1 2γ′ − 1 
)n ] > 1− (n/q)k`. 
Proof. The probability that a random polynomial a ← Rq is invertible in Rq = Zq[X ]/(Xn + 1) when the polynomial Xn + 1 splits into n linear factors is (1− 1/q)n > 1− n/q. Thus the probability that at least one of k` polynomials in A← Rk×` 
q is invertible is greater than 1− (n/q)k`. We will now prove that for all A that contain at least one invertible polynomial, we will have that for all w1, 
Pr y←S` 
γ′−1 
[HighBitsq(Ay, 2γ) = w1] ≤ ( 
2γ + 1 2γ′ − 1 
)n , 
which will prove the Lemma. Let us only consider the row of A which contains the invertible polynomial. Call the elements in this row [a1, . . . , a`] and without loss of generality assume that a1 is invertible. We will want to prove that for all w1, 
Pr y←S` 
γ′−1 
[ HighBitsq 
(∑ aiyi , 2γ 
) = w1 
] ≤ ( 
2γ + 1 2γ′ − 1 
)n . 
Define T to be the set containing all the elements w such that HighBits(w, 2γ) = w1. By the definition of the Decomposeq routine in Figure 12, the size of T is at most (2γ + 1)n. We can then rewrite the above probability as 
Pr y←S` 
γ′−1 
[∑ aiyi ∈ T 
] = Pr 
y1←Sγ′−1 
[ y1 ∈ a−1 
1 
( T − 
∑ aiyi 
)] ≤ ( 
2γ + 1 2γ′ − 1 
)n , 
37
where the last inequality follows due to the fact that the size of the set 
a−1 1 
( T − 
∑ aiyi 
) is the same as that of T , which is at most (2γ+ 1)n ; and the size of the set Sγ′−1 is exactly (2γ′−1)n . 
For the values in Table 1, we have that ( 
2γ+1 2γ′−1 
)n < 2−255 and (n/q)k` < 2−299. Thus, by Definition 2.6, 
the min-entropy of the Dilithium scheme for the two sets of parameters is greater than 255. We would like to point out that the real min-entropy should be a lot higher since the HighBitsq 
function maps onto a set of size larger than 25000 and is heuristically close to uniform over this set. To get a formal proof would be significantly more involved than the proof above which took advantage of the fact that γ′ = 2γ, and gave us a sufficiently high min-entropy bound for practical purposes. 
38