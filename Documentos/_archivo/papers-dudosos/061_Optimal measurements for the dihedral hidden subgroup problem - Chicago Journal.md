# Optimal measurements for the dihedral hidden subgroup problem - Chicago Journal of Theoretical Computer Science

- **ID**: `f0aac748-a50d-4558-9746-23ccedfe6d34`
- **Tipo de Fuente**: `SOURCE_TYPE_PDF`
- **URL**: [http://cjtcs.cs.uchicago.edu/articles/2006/2/cj06-02.pdf](http://cjtcs.cs.uchicago.edu/articles/2006/2/cj06-02.pdf)

---

## Contenido Extraído / Texto Completo

OPTIMAL MEASUREMENTS FOR THE DIHEDRAL HIDDEN SUBGROUP PROBLEM 
DAVE BACON, ANDREW M. CHILDS, AND WIM VAN DAM 
Abstract. We consider the dihedral hidden subgroup problem as the problem of distinguishing hidden subgroup states. We show that the optimal measurement for solving this problem is the so-called pretty good measurement. We then prove that the success probability of this measurement exhibits a sharp threshold as a function of the density ν = k/ log2 N , where k is the number of copies of the hidden subgroup state and 2N is the order of the dihedral group. In particular, for ν < 1 the optimal measurement (and hence any measurement) identifies the hidden subgroup with a probability that is exponentially small in log N , while for ν > 1 the optimal measurement identifies the hidden subgroup with a probability of order unity. Thus the dihedral group provides an example of a group G for which Ω(log |G|) hidden subgroup states are necessary to solve the hidden subgroup problem. We also consider the optimal measurement for determining a single bit of the answer, and show that it exhibits the same threshold. Finally, we consider implementing the optimal measurement by a quantum circuit, and thereby establish further connections between the dihedral hidden subgroup problem and average case subset sum problems. In particular, we show that an efficient quantum algorithm for a restricted version of the optimal measurement would imply an efficient quantum algorithm for the subset sum problem, and conversely, that the ability to quantum sample from subset sum solutions allows one to implement the optimal measurement. 
1. Introduction 
Quantum computers promise to solve certain problems asymptotically faster than their classical counterparts. In particular, Shor’s discovery of an efficient quantum algorithm for factoring [49]—a cryptographically significant task for which no efficient classical algorithm is known—has motivated considerable investigation into the potential algorithmic uses of quantum computers. Along with its predecessors [3, 8, 9, 50], Shor’s algorithm can be viewed as a solution to one of a large class of problems known as hidden subgroup problems [4, 30], several of which also have applications to interesting computational problems for which no efficient classical algorithm is known. Thus the broader question arises: under what circumstances can the hidden subgroup problem (hsp) be solved efficiently by a quantum computer? 
2000 Mathematics Subject Classification. 81P68, 68Q17, 81P15. Key words and phrases. quantum algorithms, optimal measurements, combinatorics.
2 DAVE BACON, ANDREW M. CHILDS, AND WIM VAN DAM 
Encouragingly, the quantum query complexity of the general hsp is polynomial: for any group G, only poly(log |G|) quantum queries of the function that hides a subgroup are sufficient to solve the problem [12–15, 30]. Thus lower bounds showing that the hsp is intractable are unlikely to be forthcoming. However, the processing of the queries could take exponential time, so it remains a challenge to find algorithms that are efficient in terms of the number of elementary operations. 
Following Shor’s discovery, there has been considerable progress in showing that quantum computers can efficiently solve the hsp for particular groups and particular kinds of subgroups [4, 17, 20–24, 31, 33, 35, 39, 47] (although there is also evidence that some hidden subgroup problems may be hard even for quantum computers [34, 40, 41]). However, for many hidden subgroup problems, the speedup offered by quantum computers (if any) remains unknown. In particular, no efficient quantum algorithm is known for two cases whose applications are of particular interest, the symmetric group and the dihedral group. For the former, an efficient quantum algorithm could be used to efficiently solve the graph isomorphism problem [2,4,12,29], while for the latter, an efficient quantum algorithm could be used to efficiently solve certain cryptographically significant lattice problems [45]. Recent progress on the dihedral hsp has been particularly encouraging: Ku-perberg gave an algorithm using subexponential (but superpolynomial) time and space [37], and Regev improved this algorithm to use a similar amount of time but only polynomial space [44]. 
In this paper we concentrate on the dihedral hidden subgroup problem. In particular, we study the optimal measurement for solving this problem given samples of certain quantum states we call hidden subgroup states. By an optimal measurement we mean one that maximizes the probability of correctly identifying the hidden subgroup given a fixed number of hidden subgroup states. If the optimal success probability is too small, then there can be no quantum algorithm that reliably determines the hidden subgroup from the hidden subgroup states, whereas a high optimal success probability indicates that such an algorithm is in principle possible. By analyzing how the optimal success probability depends on the number of copies of the hidden subgroup states, we gain insight into potential quantum algorithms for the hidden subgroup problem. 
For the dihedral hidden subgroup problem, we find that the success probability of the optimal measurement exhibits a sharp threshold as a function of k, the number of copies of the hidden subgroup state. For the dihedral group of order 2N , let k = ν logN , where ν is the density. (The logarithms in this article are always base 2.) For any fixed density ν > 1, the optimal measurement identifies the hidden subgroup with constant probability, and therefore an efficient quantum circuit for implementing this measurement would solve the dihedral hidden subgroup problem. (This can be compared to previous results showing that a success probability of 1 − 1/2N can be achieved with ν > 89 [15], and that a success probability of 1/poly(logN)
OPTIMAL MEASUREMENTS FOR THE DIHEDRAL HSP 3 
can be achieved with ν > 1 [45].) However, for any fixed ν < 1, the success probability of the optimal measurement (and hence of any measurement) is exponentially small in logN . This bound shows that Ω(log |G|) hidden subgroup states are in fact necessary to solve the dihedral hsp. 
In addition to studying the success probability of the optimal measurement, we also establish further connections between the dihedral hidden subgroup problem and average-case subset sum problems of density ν. Regev showed that the dihedral hsp can be solved efficiently if one can efficiently solve average case subset sum problems with ν > 1 [45]. We show that the optimal measurement for k = ν logN copies can be implemented if one can quantum sample from subset sum solutions at density ν, and conversely, that an implementation of the optimal measurement (of a certain restricted form) by a quantum circuit can be used to solve the average case subset sum problem. 
Our results can be compared to those of Ip showing that Shor’s algorithm implements the optimal measurement for the abelian hidden subgroup problem [32]. In light of this result, it is natural to consider the optimal measurement for other hidden subgroup problems as an approach to finding efficient algorithms. However, our results suggest that this approach may not be very promising for the dihedral HSP. To solve the dihedral HSP by implementing the optimal measurement, one must solve the (apparently difficult) average case subset sum problem with ν > 1 (unless the measurement can be implemented by a quantum circuit not of the restricted form that could be used to solve subset sum). 
Independently of this article, a paper appeared that studies the query complexity of the hsp for the abelian group Zn 
2 [36]. That paper shows that one must query the subgroup hiding function at least n/8 = (log |Zn 
2 |)/8 times to get a reliable answer to the hsp. Besides dealing with a different group, this result differs from ours in that it considers the necessary number of queries, rather than the required number of hidden subgroup states. Each hidden subgroup state can be constructed using one query, but the query complexity setting is more general. On the other hand, our lower bound of log |G| hidden subgroup states has the best possible constant factor, whereas the constant factor of 1/8 for the query complexity of the hsp in Zn 
2 is not known to be tight. 
This paper is organized as follows. In Section 2, we review the hidden subgroup problem in general, and in Section 3, we review the dihedral hidden subgroup problem in particular. We present the optimal measurement for the dihedral hsp in Section 4 and establish bounds on its success probability in Section 5. In Section 6, we show that the bounds of Sec-tion 5 are significantly stronger than those one obtains from straightforward information-theoretic arguments. Then, in Section 7, we show that the problem of determining just the least significant bit of the answer requires essentially as many copies of the hidden subgroup state as are required to obtain the entire answer. In Section 8, we establish connections between
4 DAVE BACON, ANDREW M. CHILDS, AND WIM VAN DAM 
the optimal measurement for the dihedral hsp and the subset sum problem. Finally, we conclude in Section 9 with a discussion of the results and some open problems. 
2. The hidden subgroup problem 
We begin by reviewing the hidden subgroup problem. Let G be a finite group of order |G|. We assume that the elements of this group can be efficiently represented as strings of poly(log |G|) bits. Consider a function f : G → S where S is some finite set whose elements can also be efficiently represented as strings of poly(log |G|) bits. In the hsp, we are given such a function and promised that it is constant and distinct on left cosets of some subgroup H ≤ G. In other words, f(g1) = f(g2) if and only if g1 and g2 are in the same left coset of H. The hidden subgroup problem is, given the ability to query the function f , to produce a generating set for the subgroup H. 
In the quantum version of the hsp we are given a unitary operator Uf 
that computes the function f . Explicitly, this quantum oracle acts as 
(1) Uf : |g, y〉 7→ |g, y ⊕ f(g)〉 for all g ∈ G and y ∈ S, where ⊕ is the bitwise exclusive or operation. If we input the basis state |g, 0〉 into this oracle, it simply evaluates the function: Uf |g, 0〉 = |g, f(g)〉. Our goal is to use this black box to find generators of the hidden subgroup in a time polynomial in log |G|. 
In the standard approach to solving the hidden subgroup problem with a quantum computer (used by all known quantum algorithms for the hsp), one inputs a superposition over all group elements into the first register and |0〉 into the second register, giving 
(2) Uf : 1√ |G| 
∑ g∈G 
|g, 0〉 7→ 1√ |G| 
∑ g∈G 
|g, f(g)〉 . 
Suppose we now discard the second register. Due to the promise on f , the state of the first register is then a mixed state whose form depends on the hidden subgroup H, 
ρH := |H| |G| 
∑ g∈K 
|gH〉〈gH|(3) 
where K ⊂ G is a complete set of left coset representatives of H in G (of size |K| = |G|/|H|), and where we have defined the coset states 
|gH〉 := 1√ |H| 
∑ h∈H 
|gh〉 .(4) 
We will call ρH the hidden subgroup state corresponding to the subgroup H. Early quantum algorithms, including Deutsch’s algorithm [9], the Deutsch-
Jozsa algorithm [8], the Bernstein-Vazirani algorithm [3], Simon’s algorithm
OPTIMAL MEASUREMENTS FOR THE DIHEDRAL HSP 5 
[50], and Shor’s algorithm [49], all solve examples of the abelian hsp but were not originally described in this language. The formulation in terms of a hidden subgroup was presented by Boneh and Lipton [4], who also noted the connection between the hsp over the symmetric group and the graph isomorphism problem. 
The hsp over arbitrary finite abelian groups has an efficient quantum algorithm [4, 23, 35, 49, 50]. Hallgren, Russell, and Ta-Shma proved that the hsp has an efficient quantum algorithm whenever the subgroup H is promised to be normal and there is an efficient quantum Fourier transform over the group G [24]. Grigni, Schulman, Vazirani, and Vazirani showed that the hsp over “almost abelian” groups has an efficient quantum solution [21], and this result was extended by Gavinsky to “near-Hamiltonian” groups [20]. Püschel, Rötteler, and Beth gave an efficient quantum algorithm for the hsp over the wreath product Zn 
2 o Z2 [47], and Friedl et al. showed how to solve the hsp over a semidirect product Zn 
pk o Z2 for a fixed prime power pk [17]. Moore, Rockmore, Russell, and Schulman gave an efficient quantum algorithm for the hsp over certain semidirect product groups, the q-hedral groups [39], and Inui and Le Gall gave a solution for semidirect product groups of the form Zpk o Zp with p an odd prime [31]. 
Finally, as mentioned in the introduction, there is also a body of knowledge about the query complexity of the hsp. In particular, Ettinger, Høyer, and Knill have shown that O(log |G|) quantum queries of the function f are sufficient to determine the hidden subgroup [13]. Unfortunately, the quantum algorithm they present requires time O(|G|). 
3. The dihedral hidden subgroup problem 
The dihedral group of order 2N , denoted DN , is the group of symmetries of a regular N -sided polygon. This group is generated by two elements r and s satisfying the relations r2 = e, sN = e, and rsr = s−1, where e is the identity element. Here s corresponds to a rotation of the polygon and r corresponds to a reflection. A generic element of the dihedral group can be written as rtsk where t ∈ Z2 and s ∈ ZN , and group multiplication is given by rt′sk′ 
rtsk = rt+t′sk+(−1)tk′ . (Throughout this article we write ZN 
to denote Z/NZ.) The dihedral hidden subgroup problem (dhsp) was first considered by 
Ettinger and Høyer [15]. They showed that given O(logN) queries to the hidden subgroup oracle for the dihedral group, there exists a quantum algorithm whose output contains enough classical information to solve the dhsp, and therefore that the query complexity of the dhsp is O(logN). Unfor-tunately, they were not able to find an efficient algorithm to process the output, so this approach has not yet led to an efficient algorithm for the dhsp. 
A major motivation for attempting to solve the dhsp is a connection to lattice problems discovered by Regev [45]. A d-dimensional lattice is
6 DAVE BACON, ANDREW M. CHILDS, AND WIM VAN DAM 
the set of all integer linear combinations of d linearly independent vectors in Rd that form a basis for the lattice. In the shortest vector problem, one attempts to find the shortest (nonzero) vector in the lattice given a basis. In particular, in the g(d) unique shortest vector problem, we are promised that the shortest vector is unique and shorter than all other non-parallel vector by a factor g(d). The presumed hardness of certain g(d) unique shortest vector problems is the basis for a cryptosystem proposed by Ajtai and Dwork (in which g(d) = O(d8)) [1], and a subsequent improvement proposed by Regev (in which g(d) = O(d1.5)) [46]. Regev showed that an efficient quantum algorithm for the dhsp that works by sampling hidden subgroup states can be used to solve the poly(d) unique shortest vector problem [45], thereby breaking the proposed lattice cryptosystems. 
Regev also gave a promising path toward solving the dhsp in the form of a connection to the subset sum problem. In the subset sum problem, one is given k numbers between 0 and N − 1, denoted x ∈ Zk 
N , and a target t ∈ ZN , and the goal is to find a subset of the k numbers, specified by a binary vector b ∈ Zk 
2, such that b ·x = t, where b ·x := ∑k 
j=1 bjxj mod N . If such a subset exists, then we call (x, t) a legal subset sum input. Regev has shown that if one can efficiently solve 1/poly(logN) of the legal subset sum inputs (with k > logN +4) then there is an efficient quantum algorithm for the dhsp [45]. While the general subset sum problem is NP-hard, note that an algorithm for average-case inputs with k > logN + 4 a fixed function of N would be sufficient to solve the dhsp. 
The first subexponential time quantum algorithm for the dhsp was given by Kuperberg, who showed how to solve it in 2O( 
√ log N) time, space, and 
queries [37]. Regev reduced the space requirement to poly(logN) at the expense of only slightly greater time and queries [44]. Regev’s approach also shows a connection to the average case subset sum problem. 
In trying to solve the dhsp, it is convenient to focus on a simplified version that is in fact equivalent in difficulty to the full problem. Specifically, we will focus on the case in which the subgroup H has order two. In general, there are two types of subgroups of DN , cyclic subgroups and dihedral subgroups. The cyclic subgroups consist only of rotations; they are of the form 
(5) CN/j := {e, sj , . . . , s−j} , 
where j ∈ ZN is a divisor of N . Note that C1 is simply the trivial subgroup. The dihedral subgroups consist of rotations and reflections, and are of the form 
(6) DN/j,d := {e, sj , . . . , s−j , rsd, rsj+d, . . . , rs−j+d} , 
where j ∈ ZN is a divisor of N and d ∈ ZN . Note that DN,d = DN for any d. Furthermore, note that D1,d = {e, rsd} is an order two subgroup for any d. The cyclic subgroups CN/j are all normal in DN (that is, ghg−1 ∈ CN/j for all h ∈ CN/j and g ∈ DN ) while none of the dihedral subgroups are normal except for the full dihedral group, DN .
OPTIMAL MEASUREMENTS FOR THE DIHEDRAL HSP 7 
Ettinger and Høyer have shown that an efficient quantum algorithm for the dhsp exists if one can solve the dhsp with the promise that the hidden subgroup is either the trivial subgroup, C1 = {e}, or is some subgroup of order two, D1,d = {e, rsd} for some (unknown) d ∈ ZN [15]. We will further restrict the problem by determining the optimal measurement only for the order two subgroups. In fact, it will turn out that when this restricted measurement succeeds with high probability, it also identifies the trivial subgroup with high probability, and therefore can be used to solve the dhsp in general. 
We will represent a dihedral group element rtsk using two quantum registers, |t, k〉, where the first register is a single qubit and the second register consists of dlogNe qubits. When the subgroup is an order two subgroup D1,d, then the standard approach produces the random coset state 
(7) |φk,d〉 = 1√ 2 (|0, k〉+ |1,−k + d〉) 
where k is uniformly sampled from ZN and addition is done in ZN , i.e., modulo N . In other words, the hidden subgroup state corresponding to the subgroup H = D1,d is 
(8) ρd = 1 N 
∑ k∈ZN 
|φk,d〉〈φk,d| . 
It will be convenient to change the basis by Fourier transforming the second register (over ZN ) conditional on the first register being |1〉 and inverse Fourier transforming the second register conditional on the first register being |0〉. In this new basis, the hidden subgroup state is 
ρd = 1 N 
∑ x∈ZN 
|φ̃x,d〉〈φ̃x,d|(9) 
where 
|φ̃x,d〉 := 1√ 2 (|0〉+ ωxd|1〉)|x〉(10) 
with ω := exp(2πi/N). When the subgroup is the trivial group, the standard approach produces a random state |t, x〉 with t uniformly sampled from Z2 
and x uniformly sampled from ZN . Thus the hidden subgroup state when the hidden subgroup is H = C1 is simply the maximally mixed state 
(11) ρ{e} = 1 N 
∑ t∈Z2 
∑ x∈ZN 
|t, x〉〈t, x| = I2N 
2N 
where I2N is the 2N -dimensional identity matrix. Our goal is to determine d given k copies of the state ρd. It will be helpful 
to write the state in a way that begins to reveal the connection to the subset
8 DAVE BACON, ANDREW M. CHILDS, AND WIM VAN DAM 
sum problem. Note that we can write 
(12) ρd = 1 
2N 
∑ b,c∈Z2 
∑ x∈ZN 
ω(b−c)xd|b, x〉〈c, x| . 
Therefore 
ρ⊗k d = 
1 (2N)k 
∑ b,c∈Zk 
2 
∑ x∈Zk 
N 
ω[(b−c)·x]d|b, x〉〈c, x|(13) 
= 1 
(2N)k 
∑ x∈Zk 
N 
∑ p,q∈ZN 
ωd(p−q)√ηx pη 
x q |Sx 
p , x〉〈Sx q , x|(14) 
where |Sx r 〉 is the (normalized) uniform superposition over subsets of x ∈ Zk 
N that sum to r ∈ ZN , 
|Sx r 〉 := 
1√ ηx 
r 
∑ b∈Sx 
r 
|b〉(15) 
with Sx r := {b ∈ Zk 
2 : b · x = r} denoting the set of bit strings corresponding to subsets of x that sum to r, and ηx 
r := |Sx r | denoting the number of 
such subsets. If ηx r = 0, then no such state can be defined, and we use 
the convention |Sx r 〉 = 0. When the subgroup is trivial, k copies of the 
hidden subgroup state are simply k copies of the maximally mixed state, ρ⊗k {e} = I(2N)k/(2N)k. 
4. The optimal measurement 
In this section, we present the optimal measurement for distinguishing the hidden subgroup states ρ⊗k 
d . The measurement will have N outcomes, one for each possible value of d, and will be optimal in the sense that the probability of obtaining the correct outcome will be as large as possible. Recall that a general quantum measurement, a positive operator-valued measure (povm), is specified by a set of positive operators {Ej}, Ej > 0, that sum to the identity, i.e., 
∑ j Ej = I. Given a density matrix ρ, the probability 
of obtaining the outcome j is trEjρ. Ip was the first to consider optimal measurements for hidden subgroup 
problems [32]. In particular, he found the optimal measurement for the abelian hidden subgroup problem when the hidden subgroups are all given with equal a priori probabilities, thereby showing that the methods developed to solve the factoring problem are optimal. Ip also derived the optimal measurement for the dihedral hidden subgroup problem given a single copy of the hidden subgroup state. As we shall see, this measurement fails to efficiently identify the order two subgroups. Since we know that there exists a measurement for solving the dhsp using O(logN) copies of the hidden subgroup states, it is of interest to understand the optimal measurement given k  1 copies.
OPTIMAL MEASUREMENTS FOR THE DIHEDRAL HSP 9 
The optimal measurement turns out to be the pretty good measurement (pgm) [25] (also known as the square root measurement or least squares measurement [11]). 
To prove that the pgm is optimal, we will use the following theorem: 
Theorem 1 (Holevo [28], Yuen-Kennedy-Lax [52]). Given an ensemble of quantum states ρi with a priori probabilities pi, the measurement with povm elements Ej maximizes the probability of successfully identifying the state if and only if ∑ 
i 
piρiEi = ∑ 
i 
piEiρi(16) 
and ∑ 
i 
piρiEi ≥ pjρj ∀j .(17) 
This condition follows most easily from noting that the maximization problem is a semidefinite program [10, 32, 52]. While Theorem 1 provides necessary and sufficient conditions for a measurement to be optimal, it is nontrivial in general to construct measurements that satisfy these conditions. 
Given ρ⊗k d with equal a priori probabilities for each d ∈ ZN , we wish to 
find the measurements {Ej}j∈ZN that maximize the probabilities of correctly 
identifying these states, where we identify the measurement outcome j with our guess for the hidden subgroup label d. The pgm is given by 
Ej = G−1/2ρ⊗k j G−1/2(18) 
where the inverse is taken over the support of G, and where 
G := ∑ 
j∈ZN 
ρ⊗k j(19) 
= 1 
(2N)k 
∑ x∈Zk 
N 
∑ p,q∈ZN 
∑ j∈ZN 
ωj(p−q)√ηx pη 
x q |Sx 
p , x〉〈Sx q , x|(20) 
= N 
(2N)k 
∑ x∈Zk 
N 
∑ r∈ZN 
ηx r |Sx 
r , x〉〈Sx r , x| .(21) 
Inserting (14) and (21) into (18), we find that the pretty good measurement for the dihedral hidden subgroup states has the measurement operators 
(22) Ej = 1 N 
∑ x∈Zk 
N 
∑ p,q∈ZN 
ωj(p−q)|Sx p , x〉〈Sx 
q , x| . 
That this measurement is optimal can be seen by substitution into (16) and (17). We have (replacing the ρi in Theorem 1 by our ρ⊗k 
i ): 
(23) ∑ i∈ZN 
ρ⊗k i Ei = 
1 (2N)k 
∑ x∈Zk 
N 
∑ p,q∈ZN 
√ ηx 
pη x q |Sx 
p , x〉〈Sx p , x| = 
∑ i∈ZN 
Eiρ ⊗k i
10 DAVE BACON, ANDREW M. CHILDS, AND WIM VAN DAM 
which verifies (16). Now ρ⊗k j is block diagonal with rank one blocks: ρ⊗k 
j =∑ x∈Zk 
N |ρx 
j , x〉〈ρx j , x| where 
(24) |ρx j 〉 = 
1 (2N)k/2 
∑ p 
ωjp√ηx p |Sx 
p 〉 . 
For any j ∈ ZN and for any block x ∈ Zk N , we find 
〈ρx j , x| 
∑ i∈ZN 
ρiEi|ρx j , x〉 = 
1 (2N)k 
∑ p,q∈ZN 
ηx p 
√ ηx 
pη x q(25) 
≥ 1 (2N)k 
∑ p∈ZN 
ηx p = 〈ρx 
j |ρx j 〉 ,(26) 
which verifies (17). Notice that since G is not supported on the entire (2N)k-dimensional 
space, the operators {Ej}j∈ZN do not form a complete partition of the iden-
tity. (The dimension of the support of G, rankG = |{(x, p) : x ∈ Zk N , p ∈ 
ZN , η x p > 0}|, is given by Sloane’s integer sequence A098966 [51].) To com-
plete the measurement we can add an additional measurement operator, E{e} := I − 
∑ j∈ZN 
Ej . We associate this measurement outcome with the trivial subgroup. We emphasize that the measurement is only optimized for determining the order two subgroups. However, we will see that the optimal measurement with the additional measurement operator E{e} also efficiently identifies the trivial subgroup. Of course, the optimal measurement for the full dihedral group is never any better than the optimal measurement for distinguishing the order two subgroups. 
5. Success probability of the optimal measurement 
In this section we study the success probability of the optimal measurement for distinguishing the dihedral hidden subgroup states. Using the expressions (14) and (22), a simple calculation shows that the probability of successfully identifying an order two subgroup is independent of the hidden shift d and is given by 
(27) p := trEdρ ⊗k d = 
1 2kNk+1 
∑ x∈Zk 
N 
( ∑ r∈ZN 
√ ηx 
r 
)2 
. 
We now show that the success probability has a sharp threshold as a function of the density ν = k/ logN . More precisely, we find 
Theorem 2. If ν ≥ 1+ 4 log N , then the probability of successfully determining 
the order two subgroup is at least 1/8. Furthermore, for any N and k, the probability of successfully determining the order two subgroup is less than 2k/N (which in particular is exponentially small in logN for any fixed ν < 1).
OPTIMAL MEASUREMENTS FOR THE DIHEDRAL HSP 11 
We will need the following lemma to prove the first statement of the theorem. 
Lemma 3 (Cf. proof of Lemma 4.1 of [45]). For fixed r ∈ ZN and uniformly random x ∈ Zk 
N , 
(28) Pr ( ηx 
r ≥ 2k − 1 2N 
) ≥ 1− 4N 
2k − 1 . 
With this fact in hand, we can establish our main result. 
Proof of Theorem 2. For the lower bound on the success probability, we have 
(29) p ≥ 1 2kN 
( 1 Nk 
∑ x∈Zk 
N 
∑ r∈ZN 
√ ηx 
r 
)2 
by Cauchy’s inequality applied to (27). Now by Lemma 3, 
1 Nk 
∑ x∈Zk 
N 
√ ηx 
r ≥ √ 
2k − 1 2N 
Pr ( ηx 
r ≥ 2k − 1 2N 
) (30) 
≥ √ 
2k − 1 2N 
− √ 
8N 2k − 1 
(31) 
for any r, which implies 
p ≥ N 
2k 
(√ 2k − 1 2N 
− √ 
8N 2k − 1 
)2 
(32) 
≥ 2k − 1 2k+1 
− 4N 2k 
(33) 
≥ 1 4 − 1 
2k (34) 
≥ 1 8 
(35) 
where we have assumed k ≥ logN +4 (and also, in particular, we have used k ≥ 3). 
For the upper bound on the success probability, we have 
p ≤ 1 2kNk+1 
∑ x∈Zk 
N 
( ∑ r∈ZN 
ηx r 
)2 
(36) 
= 2k 
N (37) 
where in the first line we have used the fact that the η’s are all integers to remove the square root in (27), and in the second line we have used the fact that 
∑ r∈ZN 
ηx r = 2k for any x. This completes the proof. 
12 DAVE BACON, ANDREW M. CHILDS, AND WIM VAN DAM 
We claimed earlier that when the measurement identifies the order two subgroups with reasonable probability, it will also identify the trivial subgroup. This follows from a simple calculation: supposing ν ≥ 1 + 4 
log N , 
p{e} := trE{e}ρ ⊗k {e}(38) 
= 1− rankG (2N)k 
(39) 
≥ 1− N 
2k (40) 
≥ 15 16 .(41) 
6. Bounds by information-theoretic arguments 
The proof of the above threshold theorem used specific properties of the dihedral hidden subgroup problem. It is reasonable to ask if this is necessary, or if one could instead obtain the same bounds using the powerful techniques of quantum information theory. This appears not to be the case. Here we derive the information-theoretic lower bound ν = k/ logN ≥ p, which is weaker than the ν ≥ 1 bound of Theorem 2 for probabilistic, non-exact algorithms. 
Given k copies of the hidden subgroup state ρd, we want to determine d with success probability at least p. Viewed in a data transmission setting, we can imagine a sender encoding logN bits of information (the value d ∈ ZN ) in the quantum state ρ⊗k 
d , after which a receiver decodes the logN bits by solving the dhsp using the k copies of ρd. The number of copies k required for this approach to work can be analyzed with the tools of quantum information theory, thereby giving a lower bound on k. Because the amount of information received depends on the success probability p, the lower bound on k will also depend on p. Roughly speaking, the amount of information that can be transmitted with k copies is upper bounded by k bits, while the received amount of information is lower bounded by p logN , leading to the lower bound k ≥ p logN . The details are as follows. 
Given N , we define a source Sk that draws from the uniform ensemble {(1/N, ρ⊗k 
d )}d∈ZN where each d occurs with equal probability 1/N . Holevo’s 
χ quantity, defined by 
(42) χ(Sk) := S ( 1 N 
∑ d 
ρ⊗k d 
) − 1 N 
∑ d 
S(ρ⊗k d ) 
where S(·) denotes the Von Neumann entropy of a mixed quantum state [42], gives an upper bound on the accessible information of the ensemble. The state ρd is defined in a 2N -dimensional Hilbert space, and its spectrum consists of the eigenvalues 1/N and 0, each with multiplicity N , while the spectrum of the mixture 1 
N 
∑ d ρd consists of the eigenvalues 1/N and 0, 
each with multiplicity 1, and the eigenvalue 1/2N with multiplicity 2N − 2.
OPTIMAL MEASUREMENTS FOR THE DIHEDRAL HSP 13 
Hence, for the k = 1 case, we have χ(S1) = 1− 1/N . For general k, we have S(ρ⊗k 
d ) = k logN since the entropy is additive under tensor products. For the mixture 1 
N 
∑ ρ⊗k 
d we note that the reduced density matrices of each copy are equal to 1 
N 
∑ ρd. Hence, by subadditivity of the Von Neumann entropy, 
the entropy of this mixture is bounded from above by k S( 1 N 
∑ d ρd). Overall, 
this implies an upper bound of k(1− 1/N) on the accessible information of Sk. 
Now, on the receiver’s end, if the message can be decoded without error, then Sk has a capacity of logN bits per message. However, we should take into account that we are satisfied with a constant success probability p, which can be smaller than 1. In this more general case, the information transmitted by the source will be bounded from below by Ip ≥ logN − H(p, 1−p 
N−1 , . . . , 1−p N−1), where H(·) is the Shannon entropy of a probability 
distribution. Since χ(Sk) ≥ Ip, we find 
k 
( 1− 1 
N 
) ≥ logN −H 
( p, 
1− p 
N − 1 , . . . , 
1− p 
N − 1 
) (43) 
= logN − (1− p) log(N − 1)−H(p, 1− p) .(44) 
For constant p and large N , this converges to the lower bound k ≥ p log(N− 1) − H(p, 1 − p), which is significantly weaker than the bound k ≥ logN from our earlier Theorem 2. 
7. Determining the least significant bit 
Although the determination of the entire shift d requires at least logN copies of the hidden subgroup state, one might hope to acquire partial information about the shift using fewer copies. For example, suppose one could determine the least significant bit of the shift using only a single hidden subgroup state. An iterative determination of the entire shift using such a measurement as a subroutine would still require logN hidden subgroup states, but the basic measurement for determining a single bit would be much simpler. However, here we rule out such a possibility: the optimal measurement for determining even just a single bit of the shift still requires logN hidden subgroup states. More precisely, we prove the following: 
Theorem 4. With k = ν logN copies of the dihedral hidden subgroup state ρd, the probability of successfully identifying the least significant bit of d is exponentially close to 1 
2 for any fixed ν < 1. 
Note that since there is a measurement to determine the entire shift with constant probability for any fixed ν > 1, in particular there is a measurement to determine the least significant bit with probability bounded away from 1/2 in this regime. Thus Theorem 4 shows that the threshold for success remains essentially the same, at ν ∼ 1, for the problem of determining just the least significant bit. Note also that
14 DAVE BACON, ANDREW M. CHILDS, AND WIM VAN DAM 
To establish this result, we proceed as before: we first identify the optimal measurement, then derive an expression for its success probability, and finally place bounds on this expression. Our goal is to determine the least significant bit of d, i.e., whether d is even or odd. In other words, we would like to distinguish the two density matrices 
(45) ρ (k) ± := 
2 N 
∑ d even,odd 
ρ⊗k d . 
Since ρ(k) + + ρ 
(k) − = 2 
NG (with G given in (21)), the pgm for these states has the two povm operators 
E± := N 
2 G−1/2ρ 
(k) ± G−1/2(46) 
= ∑ 
d even,odd 
Ed .(47) 
Now for simplicity we assume N is even such that we have the identities∑ d even 
ωd(p−q) = 
{ N 2 p = q or p = q +N/2 0 otherwise 
(48) 
and 
∑ d odd 
ωd(p−q) = 
 N 2 p = q 
−N 2 p = q +N/2 
0 otherwise (49) 
which can then be used to obtain 
ρ (k) ± = 
1 (2N)k 
∑ x∈Zk 
N 
∑ r∈ZN 
(ηx r |Sx 
r , x〉〈Sx r , x| ± 
√ ηx 
r η x r+N/2|S 
x r , x〉〈Sx 
r+N/2, x|) 
(50) 
E± = 1 2 
∑ x∈Zk 
N 
∑ r∈ZN 
(|Sx r , x〉〈Sx 
r , x| ± |Sx r , x〉〈Sx 
r+N/2, x|) . 
(51) 
We claim that this pgm is the optimal measurement for determining the least significant bit of the shift. To see this, check the conditions of Theo-rem 1. We have∑ 
i∈ZN 
ρ⊗k i Ei = ρ 
(k) + E+ + ρ 
(k) − E−(52) 
= 1 
(2N)k 
∑ x∈Zk 
N 
∑ r∈ZN 
( ηx 
r + √ ηx 
r η x r+N/2 
) |Sx 
r , x〉〈Sx r , x|(53)
OPTIMAL MEASUREMENTS FOR THE DIHEDRAL HSP 15 
since the cross terms cancel. A similar calculation verifies (16). Then 
(54) ∑ i∈ZN 
ρ⊗k i Ei − ρ 
(k) ± = 
1 (2N)k 
∑ x∈Zk 
N 
∑ r∈ZN 
√ ηx 
r η x r+N/2(|S 
x r , x〉〈Sx 
r , x| ∓ |Sx r , x〉〈Sx 
r+N/2, x|) , 
which is clearly a positive matrix, verifying (17). The success probability of this optimal measurement is independent of 
whether d is even or odd, and is given by 
p̃ := trE+ρ (k) +(55) 
= 1 
2(2N)k 
[ ∑ x∈Zk 
N 
∑ r∈ZN 
ηx r tr(|Sx 
r , x〉〈Sx r , x|+ |Sx 
r , x〉〈Sx r+N/2, x|)(56) 
+ ∑ 
x∈Zk N 
∑ r∈ZN 
√ ηx 
r η x r+N/2 tr(|Sx 
r , x〉〈Sx r , x|+ |Sx 
r , x〉〈Sx r+N/2, x|) 
] = 
1 2 
[ 1 + 
1 (2N)k 
( ∑ x∈Zk 
N 
∑ r∈ZN 
√ ηx 
r η x r+N/2 
)] (57) 
where we have used the fact that ∑ 
x∈Zk N 
∑ r∈ZN 
ηx r = (2N)k. 
With these expressions in hand, we are ready to prove Theorem 4: 
Proof. We bound the expression (57) for the success probability of the optimal measurement. Because the η’s are integers we have for all r∑ 
x∈Zk N 
√ ηx 
r η x r+N/2 ≤ 
∑ x∈Zk 
N 
ηx r η 
x r+N/2 .(58) 
For the N − 2 cases r 6= 0, N/2 it holds that∑ x∈Zk 
N 
ηx r η 
x r+N/2 = (2k − 1)(2k − 2)Nk−2 ,(59) 
while for the remaining r = 0 or r = N/2 we have∑ x∈Zk 
N 
ηx 0η 
x N/2 = (2k − 1)(2k − 2)Nk−2 + (2k − 1)Nk−1 .(60) 
In both equalities the (2k−1)(2k−2)Nk−2 term was obtained by considering a non-empty subset S (of which there are 2k − 1) and a distinct non-empty subset T (of which there are 2k − 2) and two elements i, j such that either i ∈ S−T and j ∈ T , or i ∈ T −S and j ∈ S (such a choice is always possible because S and T are non-empty and distinct). Then for any values of the remaining k − 2 elements, there is exactly one choice for elements i and j such that the elements in S sum to r and the elements in T sum to r+N/2. For the case r = 0, N/2 we have to add the possibility that S is the empty
16 DAVE BACON, ANDREW M. CHILDS, AND WIM VAN DAM 
subset and T is a non-empty subset with element i such that for any values of the remaining k − 1 elements there is again one choice for the element i such that the elements in T sum up to N/2. 
Using these expressions in (57), we find 
p̃ ≤ 1 2 
( 1 + 
2k 
N + 
2 N 
) .(61) 
Thus we see that with k = ν logN , the success probability is exponentially close to 1/2 for any fixed ν < 1.  
8. Relation to the subset sum problem 
Given that the optimal measurement solves the dhsp if (and only if) ν > 1, we would like to understand whether this measurement can be implemented efficiently. In this section we consider how to implement the measurement by a quantum circuit, and we find that its implementation is closely related to the subset sum problem. 
Recall the definition of the subset sum problem: given x ∈ Zk N and t ∈ ZN , 
find a subset b ∈ Zk 2 such that b · x = t. If such a b exists, we call (x, t) a 
legal instance. In the decision version of the subset sum problem, we wish to determine only whether a given instance is legal or not. This problem is NP-complete. We might also want to return one or more of the subsets b in the case where the instance is legal. Regev has shown that if there exists an efficient algorithm for finding one such subset for a large fraction of the legal instances, then one could solve the dihedral hidden subgroup problem efficiently [45]. More precisely, 
Theorem 5 (Regev [45]). If there exists an efficient algorithm that finds a subset b such that b·x = t for a fraction 1/poly(logN) of the legal subset sum instances (x, t) when k > logN + 4, then there exists an efficient quantum algorithm for the dihedral hidden subgroup problem. 
Here we show a similar result for the implementation of the optimal measurement for the dihedral hidden subgroup states. Namely, if one can efficiently quantum sample from subset sum solutions at density ν = k/ logN , then one can efficiently implement the optimal measurement for the dhsp with k copies. (The term “quantum sampling” is used in analogy with the classical term “random sampling”; here it refers to the creation of a uniform superposition over the set of solutions.) 
We also show a weak converse to this result: if one can efficiently implement the optimal measurement by a quantum circuit (under a certain restriction), then one can in turn solve the average case subset sum problem of corresponding density (and indeed, can quantum sample from subset sum solutions).
OPTIMAL MEASUREMENTS FOR THE DIHEDRAL HSP 17 
Recall from (22) that the povm operators for the dhsp can be expressed as 
Ej = 1 N 
∑ x∈Zk 
N 
∑ p,q∈ZN 
ωj(p−q)|Sx p , x〉〈Sx 
q , x|(62) 
= ∑ 
x∈Zk N 
Ex j ⊗ |x〉〈x|(63) 
where 
Ex j := 
1 N 
∑ p,q∈ZN 
ωj(p−q)|Sx p 〉〈Sx 
q | .(64) 
In other words, each Ej is block diagonal, with blocks labeled by some x ∈ Zk 
N . Because each Ej has high rank, there is considerable freedom in how one implements the measurement by a quantum circuit. However, since x has a natural interpretation as the label of an irreducible representation of the dihedral group obtained by weak Fourier sampling (see the Appendix), it is natural to perform this measurement in a particular way, first measuring the label x and then performing the povm {Ex 
j }j∈ZN conditioned on that 
label. Note that each Ex j is rank one, so that the povm {Ex 
j }j∈ZN for fixed 
x ∈ Zk N is refined into one-dimensional subspaces, removing much of the 
freedom in the implementation of the original povm {Ej}. For any given x ∈ Zk 
N , we consider the implementation of the povm {Ex 
j }j∈ZN by an x-dependent quantum circuit followed by a measurement 
in the computational basis to give the outcome j. In general, this circuit and measurement will act on a larger Hilbert space than is required to hold the original input. The quantum circuit will then correspond to some unitary operation Ux on the larger space. Without loss of generality, we can assume that the final measurement is in a basis {|j〉} such that the values j ∈ {0, 1, . . . , N − 1} indicate the measurement outcome Ej . According to Neumark’s theorem [43, Chap. 9.6], the unitary operator Ux has the block form 
Ux = ( V x Ax 
Bx Cx 
) (65) 
where 
V x := 1√ N 
∑ j,q∈ZN 
ω−jq|j〉〈Sx q |(66) 
is a fixed (N × 2k)-dimensional matrix whose columns are the (subnormalized) vectors corresponding to the rank one povm elements {Ex 
j }, and Ax, Bx, Cx are arbitrary up to the requirement that Ux is unitary. It is convenient to perform a Fourier transform on the left, i.e., on the index j
18 DAVE BACON, ANDREW M. CHILDS, AND WIM VAN DAM 
(over ZN , for the relevant values j ∈ {0, 1, . . . , N − 1}), giving a unitary operator 
Ũx = ( Ṽ x Ax 
B̃x Cx 
) (67) 
with 
Ṽ x := 1 N 
∑ j,p,q∈ZN 
ωj(p−q)|p〉〈Sx q |(68) 
= ∑ 
p∈ZN 
|p〉〈Sx p | .(69) 
Clearly, Ux can be implemented efficiently if and only if Ũx can be implemented efficiently. Therefore, if we have an efficient quantum circuit for the transformation 
(70) |p, x〉 7→ 
{ |Sx 
p , x〉 ηx p > 0 
|ψx p 〉 ηx 
p = 0 
where |ψx p 〉 is any state allowed by the unitarity of Ũx (i.e., if we can effi-
ciently quantum sample from subset sum solutions for legal inputs), then by running this circuit in reverse, we can efficiently implement Ũx, and hence the measurement. 
Conversely, given the ability to implement the optimal povm by the measurement of x followed by an efficient implementation of Ux, we can solve the subset sum problem. By running the quantum circuit for Ũx in the reverse direction, we can efficiently implement the transformation (70). Suppose we are trying to solve the subset sum problem for a legal instance (x, t). Using (70), we can produce the state |Sx 
t 〉, which upon measurement gives a uniformly random subset of x summing to t. On the other hand, if the instance is not legal, then we can easily check that the output does not correspond to a subset of x summing to t. 
If we could efficiently implement the unitary operation Ũx for any k = poly(logN), then we could solve the subset sum problem efficiently even in the worst case. Since the subset sum decision problem is NP-complete, such an implementation seems unlikely. However, for the purpose of solving the dhsp, it is sufficient for each N to consider a specific k = ν logN (with ν > 1, according to Theorem 2) and implement the measurement approximately. In this case, an implementation of the measurement only implies a solution to the average case subset sum problem at density ν, which may be considerably easier. Conversely, to implement the measurement at density ν, it is sufficient to approximately quantum sample subset sum solutions at that density. 
The critical density ν ∼ 1 for the success of the optimal measurement coincides with the critical density above which almost all subset sum instances are legal and below which almost all subsets have a distinct sum.
OPTIMAL MEASUREMENTS FOR THE DIHEDRAL HSP 19 
No efficient algorithms are known for the subset sum problem at this critical density. But for sufficiently low or high density, the problem becomes tractable. For densities ν < 0.941, there is an efficient algorithm assuming the ability to find short vectors in lattices [5, 7, 18, 38], but this lattice problem seems to be difficult. However, using known basis reduction algorithms, this approach can be used to efficiently solve subset sum problems with no computational assumptions for very low density, k < c 
√ logN for 
some constant c [18, 38]. Since we require ν > 1 for a solution to the dhsp, the high density regime 
is more interesting for our purposes. Until recently, the best known result was a poly(k)-time algorithm for the case k > cN for some constant c [6,19]. These results are not helpful since they yield algorithms whose running times are exponential in logN . Flaxman and Przydatek recently showed how to produce subset sum solutions in poly(k) time with k = 2O( 
√ log N), using sim-
ilar ideas as in Kuperberg’s quantum algorithm for the dhsp [16]. However, it is not immediately clear whether the Flaxman-Przydatek algorithm can be used to quantum sample (or even to randomly sample) from subset sum solutions, so it does not directly provide an implementation of the optimal measurement. 
It is not inconceivable that one could find a quantum algorithm (or even a classical one) for the subset sum problem at still lower density, and thus find an improved algorithm for the dhsp. Furthermore, we remark that our restriction of first measuring x and then implementing the appropriate measurement conditional on x, while natural from a representation-theoretic viewpoint, is not necessarily the best way to implement the optimal measurement. A direct implementation of the measurement without first measuring x could in principle produce a quantum algorithm for the dhsp without solving the subset sum problem. 
9. Discussion 
In this paper we have studied the optimal measurement for distinguishing dihedral hidden subgroup states for order two subgroups. Using a result of Holevo and Yuen, Kennedy, and Lax, we proved that the pretty good measurement is optimal for this problem. We showed that the success probability of this measurement has a threshold around the critical density ν ∼ 1, and in particular, that Ω(logN) hidden subgroup states are necessary for the measurement to succeed with more than an exponentially small success probability. We also demonstrated that the problem of determining just the least significant bit of the answer requires the same number of hidden subgroup states. Finally, we considered the implementation of the measurement by a quantum circuit and found that it is closely related to the subset sum problem. We considered the special (but well-motivated) case in which the measurement first determines the block x, and then performs the optimal povm within that block. For a given number of copies of the hidden
20 DAVE BACON, ANDREW M. CHILDS, AND WIM VAN DAM 
subgroup state, we showed that this measurement can be implemented efficiently if and only if one can quantum sample from subset sum solutions at the corresponding density. 
Many open questions remain. First, given Kuperberg’s subexponential time algorithm for the dhsp using k = 2O( 
√ log N) copies of the hidden sub-
group state, as well as the Flaxman-Przydatek algorithm for finding a subset sum solution at the corresponding density, it seems promising to look for an implementation of the optimal measurement by quantum sampling from subset sum solutions at this density. As an intermediate step, it would be interesting simply to find an algorithm for producing a subset sum solution uniformly at random. 
Of course, implementing the optimal measurement at the Kuperberg density would not yield an improvement over previous algorithms, so it would be more interesting to find an implementation of the optimal measurement at still lower density. If one pursues the natural strategy of first measuring the block x, then our results show that this approach is at least as hard as solving the subset sum problem, in which case one could simply apply Regev’s Theorem 5. However, as discussed above, one could consider implementing the optimal measurement without first measuring x, which might give an improved algorithm for the dhsp without yielding an algorithm for subset sum. 
Finally, it would interesting to consider optimal measurements for other non-abelian hidden subgroup problems. Can such measurements be implemented efficiently in any of the cases where efficient algorithms are already known? Or more ambitiously, can any new quantum speedups be found in this way? Presumably the subset sum problem has some analog for other groups, and such a problem might be interesting in its own right. 
acknowledgments 
We thank Carlos Mochon and Frank Verstraete for helpful discussions of Theorem 1, and Abie Flaxman for correspondence regarding the algorithm in [16] and an earlier version thereof. 
DB acknowledges support from NSF grant No. EIA-0086038 and the Santa Fe Institute. AMC received support from the National Science Foun-dation under Grant No. EIA-0086038, and was also supported in part by the Fannie and John Hertz Foundation, by the Department of Energy under cooperative research agreement DE-FC02-94ER40818, and by the National Security Agency and Advanced Research and Development Activity under Army Research Office contract DAAD19-01-1-0656. WvD was supported in part by the Cambridge-MIT Institute, the Department of Energy under cooperative research agreement DE-FC02-94ER40818, and the Disrup-tive Technology Office (DTO) under Army Research Office (ARO) contract number W911NF-04-R-0009.
OPTIMAL MEASUREMENTS FOR THE DIHEDRAL HSP 21 
References 
[1] M. Ajtai and C. Dwork, A public-key cryptosystem with worst-case/average-case equivalence, Proceedings of the 29th Annual ACM Symposium on Theory of Com-puting, 1997, pp. 284–293. 
[2] R. Beals, Quantum computation of Fourier transforms over symmetric groups, Pro-ceedings of the 29th Annual ACM Symposium on Theory of Computing, 1997, pp. 48– 53. 
[3] E. Bernstein and U. Vazirani, Quantum complexity theory, SIAM Journal on Com-puting 26 (1997), no. 5, 1411–1473. 
[4] R. Boneh and R. Lipton, Quantum cryptoanalysis of hidden linear functions, Ad-vances in Cryptology – Crypto’95, 1995, pp. 424–437. 
[5] E. F. Brickell, Solving low density knapsacks, Advances in Cryptology – Crypto’83, 1984, pp. 25–37. 
[6] M. Chaimovich, G. Freiman, and Z. Galil, Solving dense subset-sum problems by using analytical number theory, Journal of Complexity 5 (1989), no. 3, 271–282. 
[7] M. J. Coster, A. Joux, B. A. LaMacchia, A. M. Odlyzko, C.-P. Schnorr, and J. Stern, Improved low-density subset sum algorithms, Computational Complexity 2 (1992), no. 2, 111–128. 
[8] D. Deutsch and R. Jozsa, Rapid solution of problems by quantum computation, Pro-ceedings of the Royal Society of London A 439 (1992), 553–558. 
[9] D. Deutsch, Quantum theory, the Church-Turing principle and the universal quantum computer, Proceedings of the Royal Society of London A 400 (1985), 97–117. 
[10] Y. C. Eldar, A. Megretski, and G. C. Verghese, Designing optimal quantum detectors via semidefinite programming, IEEE Transactions on Information Theory 49 (2003), no. 4, 1007–1012. 
[11] , Optimal detection of symmetric mixed quantum states, IEEE Transactions on Information Theory 50 (2004), no. 6, 1198–1207. 
[12] M. Ettinger and P. Høyer, A quantum observable for the graph isomorphism problem. arXiv:quant-ph/9901029. 
[13] M. Ettinger, P. Høyer, and E. Knill, Hidden subgroup states are almost orthogonal. arXiv:quant-ph/9901034. 
[14] , The quantum query complexity of the hidden subgroup problem is polynomial, Information Processing Letters 91 (2004), no. 1, 43–48. 
[15] M. Ettinger and P. Høyer, On quantum algorithms for noncommutative hidden subgroups, Advances in Applied Mathematics 25 (2000), no. 3, 239–251. 
[16] A. Flaxman and B. Przydatek, Solving medium-density subset sum problems in expected polynomial time, Proceedings of the 22nd Annual Symposium on Theoretical Aspects of Computer Science, 2005, pp. 305–314. 
[17] K. Friedl, G. Ivanyos, F. Magniez, M. Santha, and P. Sen, Hidden translation and orbit coset in quantum computing, Proceedings of the 35th Annual ACM Symposium on Theory of Computing, 2003, pp. 1–9. 
[18] A. Frieze, On the Lagarias-Odlyzko algorithm for the subset sum problem, SIAM Journal on Computing 15 (1986), no. 2, 536–539. 
[19] Z. Galil and O. Margalit, An almost linear-time algorithm for the dense subset-sum problem, SIAM Journal on Computing 20 (1991), no. 6, 1157–1189. 
[20] D. Gavinsky, Quantum solution to the hidden subgroup problem for Poly-Near-Hamiltonian groups, Quantum Information and Computation 4 (2004), no. 3, 229– 235. 
[21] M. Grigni, L. Schulman, M. Vazirani, and U. Vazirani, Quantum mechanical algorithms for the nonabelian hidden subgroup problem, Combinatorica 24 (2004), no. 1, 137–154.
22 DAVE BACON, ANDREW M. CHILDS, AND WIM VAN DAM 
[22] L. Hales and S. Hallgren, Quantum Fourier sampling simplified, Proceedings of the 31st Annual ACM Symposium on Theory of Computing, 1999, pp. 330–338. 
[23] , An improved quantum Fourier transform algorithm and applications, Pro-ceedings of the 41st Annual Symposium on Foundations of Computer Science, 2000, pp. 515–525. 
[24] S. Hallgren, A. Russell, and A. Ta-Shma, The hidden subgroup problem and quantum computation using group representations, SIAM Journal on Computing 32 (2003), no. 4, 916–934. 
[25] P. Hausladen and W. K. Wootters, A ‘pretty good’ measurement for distinguishing quantum states, Journal of Modern Optics 41 (1994), no. 12, 2385–2390. 
[26] C. W. Helstrom, Quantum Detection and Estimation Theory, Academic Press, New York, 1976. 
[27] A. S. Kholevo (Holevo), On asymptotically optimal hypothesis testing in quantum statistics, Theory of Probability and its Applications 23 (1979), no. 2, 411–415. English translation of Teoriya Veroyatnostĕı i ee Primeneniya 23 (1978), no. 2, 429–432. 
[28] A. S. Holevo, Statistical decisions in quantum theory, Journal of Multivariate Analysis 3 (1973), no. 4, 337–394. 
[29] P. Høyer, Efficient quantum transforms. arXiv:quant-ph/9702028. [30] , Conjugated operators in quantum algorithms, Physical Review A 59 (1999), 
no. 5, 3280–3289. [31] Y. Inui and F. Le Gall, An efficient algorithm for the hidden subgroup problem over 
a class of semi-direct product groups. arXiv:quant-ph/0412033. [32] L. Ip, Shor’s algorithm is optimal, 2003. [33] G. Ivanyos, F. Magniez, and M. Santha, Efficient quantum algorithms for some in-
stances of the non-abelian hidden subgroup problem, International Journal of Founda-tions of Computer Science 14 (2003), no. 5, 723–739. 
[34] J. Kempe and A. Shalev, The hidden subgroup problem and permutation group theory, Proceedings of the 16th Annual ACM-SIAM Symposium on Discrete Algorithms, 2005, pp. 1118–1125. 
[35] A. Kitaev, Quantum measurements and the abelian stabilizer problem. arXiv:quant-ph/9511026. 
[36] P. Koiran, V. Nesme, and N. Porties, A quantum lower bound for the query complexity of Simon’s problem, Proceedings of the 32nd International Colloquium on Automata, Languages and Programming, 2005, pp. 1287–1298. 
[37] G. Kuperberg, A subexponential-time quantum algorithm for the dihedral hidden subgroup problem, SIAM Journal on Computing 35 (2005), no. 1, 170–188. 
[38] J. C. Lagarias and A. M. Odlyzko, Solving low-density subset sum problems, Journal of the ACM 32 (1985), no. 1, 229–246. 
[39] C. Moore, D. N. Rockmore, A. Russell, and L. J. Schulman, The power of basis selection in Fourier sampling: Hidden subgroup problems in affine groups, Proceedings of the 15th Annual ACM-SIAM Symposium on Discrete Algorithms, 2004, pp. 1113– 1122. 
[40] C. Moore and A. Russell, The symmetric group defies strong Fourier sampling: Part II. arXiv:quant-ph/0501066. 
[41] C. Moore, A. Russell, and L. J. Schulman, The symmetric group defies strong Fourier sampling, Proceedings of the 46th Annual Symposium on Foundations of Computer Science, 2005, pp. 479–490. 
[42] M. A. Nielsen and I. C. Chuang, Quantum computation and quantum information, Cambridge University Press, Cambridge, 2000. 
[43] A. Peres, Quantum theory: concepts and methods, Fundamental theories in physics, vol. 72, Kluwer Academic Publishers, 1993. 
[44] O. Regev, A subexponential time algorithm for the dihedral hidden subgroup problem with polynomial space. arXiv:quant-ph/0406151.
OPTIMAL MEASUREMENTS FOR THE DIHEDRAL HSP 23 
[45] , Quantum computation and lattice problems, SIAM Journal on Computing 33 (2004), no. 3, 738–760. 
[46] , New lattice based cryptographic constructions, Journal of the ACM 51 (2004), no. 6, 899–942. 
[47] M. Rötteler and T. Beth, Polynomial-time solution to the hidden subgroup problem for a class of non-abelian groups. arXiv:quant-ph/9812070. 
[48] J. Serre, Linear representations of finite groups, Graduate Texts in Mathematics, vol. 42, Springer, New York, 1977. 
[49] P. W. Shor, Polynomial-time algorithms for prime factorization and discrete logarithms on a quantum computer, SIAM Journal on Computing 26 (1997), no. 5, 1484– 1509. 
[50] D. R. Simon, On the power of quantum computation, SIAM Journal on Computing 26 (1997), no. 5, 1474–1483. 
[51] N. J. A. Sloane, The on-line encyclopedia of integer sequences, 2004. http://www. research.att.com/~njas/sequences. 
[52] H. Yuen, R. Kennedy, and M. Lax, Optimum testing of multiple hypotheses in quantum detection theory, IEEE Transactions on Information Theory 21 (1975), no. 2, 125–134. 
Appendix: Representation theory and the optimal measurement 
Many features of the hidden subgroup problem can be understood using simple group representation-theoretic arguments. Here we present such arguments and demonstrate their application to the dhsp. 
Two important representations of a group G for the hsp over that group are the left and right regular representations of G. These representations act on a Hilbert space spanned by vectors {|g〉}g∈G as 
DL(g1)|g2〉 = |g1g2〉 DR(g1)|g2〉 = |g2g−1 1 〉 .(71) 
Viewed as representations of the group algebra, these two representations are commutants of each other, i.e., DL(g1)DR(g2) = DR(g2)DL(g1). The hidden subgroup states ρH defined in (3) commute with the left regular representation: DL(g)ρH = ρHDL(g) for all g ∈ G. Hence, via Schur’s lemma and the fact that the left and right regular representations are commutants, it is easy to show that a general hidden subgroup state can be expressed as 
(72) ρH = 1 |G| ∑ h∈H 
DR(h) . 
The regular representations are reducible. Let Ĝ be a set of labels for a complete set of irreducible representations of G, and for any x ∈ Ĝ, let Γx(g) be the xth irreducible representation (irrep) matrix for the group element g ∈ G. Let dx denote the dimension of the xth irrep. Then there exists a basis of the Hilbert space {|g〉}g∈G , labeled by |x, `,m〉 with x ∈ Ĝ and `,m ∈ Zdx , such that DL and DR act as 
DL(g) = ⊕ x∈Ĝ 
Γx(g)⊗ Idx DR(g) = ⊕ x∈Ĝ 
Idx ⊗ Γx(g)(73)
24 DAVE BACON, ANDREW M. CHILDS, AND WIM VAN DAM 
where Id is the d-dimensional identity matrix. The unitary transformation that transforms between the bases {|g〉}g∈G and {|x, `,m〉}x∈Ĝ,`,m∈Zdx 
is nothing but the Fourier transform over G, 
(74) QG := 1√ |G| 
∑ g∈G 
∑ x∈Ĝ 
∑ `,m∈Zdx 
√ dx[Γx(g)]`,m|x, `,m〉〈g| . 
Here [Γx(g)]`,m is the matrix element in the `th row and mth column of the xth irrep at the group element g. 
If we perform the quantum Fourier transform over G on the state ρH, we find in the new basis 
ρH = 1 |G| ⊕ x∈Ĝ 
Idx ⊗ 
(∑ h∈H 
Γx(h) 
) (75) 
= ∑ x∈Ĝ 
p(x) Idx 
dx ⊗ ρH,x ⊗ |x〉〈x| ,(76) 
a classical mixture over the irrep label x ∈ Ĝ with probabilities 
p(x) := dx 
|G| ∑ h∈H 
χx(h)(77) 
(where χx := tr Γx denotes the character of the xth irrep) of a maximally mixed row state Idx/dx and the column state 
ρH,x := 1∑ 
h∈H χx(h) 
∑ h∈H 
Γx(h) .(78) 
Since the row state is maximally mixed, it is clear that one learns nothing by measuring the row index [21]. Thus, it is natural to work in this basis and to discard the row state, focusing on the column state ρH,x. This procedure corresponds exactly to the particular form of the optimal povm considered in Section 8. 
To see this correspondence in detail for the dhsp, consider the irreducible representations of the dihedral group [48]. These irreps are all either one- or two-dimensional. The two-dimensional irreps may be conveniently labeled by an integer 1 ≤ x ≤ dN/2e − 1, and are given by 
(79) Γx(sk) = ( ωxk 0 0 ω−xk 
) and Γx(rsk) = 
( 0 ω−xk 
ωxk 0 
) where ω := exp(2πi/N). Notice that the irreps satisfy Γ−x(g) = XΓx(g)X where X is the Pauli matrix 
(80) X := ( 
0 1 1 0 
) .
OPTIMAL MEASUREMENTS FOR THE DIHEDRAL HSP 25 
When N is odd, there are two one-dimensional irreps, the trivial irrep 
Γτ (sk) = Γτ (rsk) = 1(81) 
and the alternating irrep 
Γσ(sk) = 1 and Γσ(rsk) = −1 .(82) 
When N is even, there are two additional one-dimensional irreps, the even irrep 
Γe(sk) = Γe(rsk) = (−1)k(83) 
and the odd irrep 
Γo(sk) = (−1)k and Γo(rsk) = −(−1)k .(84) 
Now consider the approach to the dhsp of first performing a quantum Fourier transform over G = DN and then measuring the irrep index. If the result obtained corresponds to a two-dimensional irrep, then we can measure the row index and will randomly obtain one of two outcomes. We associate one of these outcomes with the irrep label x and the other with the irrep label −x, performing the X operation on the column in the latter case. Furthermore, we group the trivial irrep and the alternating irrep together into a two-dimensional space, and similarly for the even and odd irreps. Labeling these two spaces 0 and N/2, respectively, it is now easy to see that this procedure is equivalent to the measurement procedure outlined in Section 8, where the irrep label x corresponds to the measurement of x ∈ ZN . 
Department of Computer Science and Engineering, University of Washing-ton, Seattle, WA 98195, USA 
E-mail address: dabacon@cs.washington.edu 
Institute for Quantum Information, California Institute of Technology, Pasadena, CA 91125, USA 
E-mail address: amchilds@caltech.edu 
Departments of Computer Science and Physics, University of California, Santa Barbara, Santa Barbara, CA 93106, USA 
E-mail address: vandam@cs.ucsb.edu