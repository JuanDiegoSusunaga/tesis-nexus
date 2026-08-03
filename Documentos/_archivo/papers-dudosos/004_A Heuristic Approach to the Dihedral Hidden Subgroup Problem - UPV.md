# A Heuristic Approach to the Dihedral Hidden Subgroup Problem - UPV

- **ID**: `2a8b1e1e-3a35-40e4-80aa-e671dda190d9`
- **Tipo de Fuente**: `SOURCE_TYPE_PDF`
- **URL**: [https://personales.upv.es/thinkmind/dl/conferences/futurecomputing/future_computing_2022/future_computing_2022_1_10_30012.pdf](https://personales.upv.es/thinkmind/dl/conferences/futurecomputing/future_computing_2022/future_computing_2022_1_10_30012.pdf)

---

## Contenido Extraído / Texto Completo

A Heuristic Approach to the Dihedral Hidden Subgroup Problem 
Hachiro Fujita Department of Computer Science Tokyo Metropolitan University Hino, Tokyo 191-0065, Japan 
Email: hfujita@tmu.ac.jp 
Abstract—The Dihedral Hidden Subgroup Problem (DHSP) is a long-standing open problem in quantum computation. The best known quantum algorithm for the DHSP is Kuperberg’s sieve algorithm which runs in subexponential time. Regev showed that the DHSP is related to a lattice problem on which the security of some public-key cryptosystems is based, and that an efficient solution to the DHSP would lead to breaking such cryptosystems. In this extended abstract, we present a simple quantum algorithm for the hidden subgroup problem over the dihedral group of order a power of two, which runs in polynomial time under some heuristic assumptions. We have implemented our algorithm in MATLAB and tested it with a small example. The simulation result shows evidence of the correctness of our algorithm. 
Index Terms—dihedral group; hidden subgroup problem; quantum algorithm; statistical test. 
I. I NTRODUCTION 
Since Shor’s seminal work [1] on quantum algorithms for integer factorization and discrete logarithms, the Hidden Subgroup Problem (HSP) has been a hot research topic in the field of quantum information and computation. See, e.g., [2], for a survey on this topic. The HSP is classified into two categories: abelian and nonabelian. Many abelian HSPs have been well understood and a quantum computer can solve many abelian HSPs exponentially faster than a classical computer. On the other hand, nonabelian HSPs in general are difficult to solve and for some nonabelian groups (e.g., the symmetric group) negative results have been reported. 
The Dihedral HSP (DHSP for short) stated in the next section is the first step towards understanding nonabelian HSPs. Ettinger and Høyer [3] were the first to consider the DHSP and showed that polynomial-time quantum computation provides enough information to solve the problem, but classical postprocessing may take exponential time. At the time of writing, the best quantum algorithm known to date is due to Kuperberg [4] who shows a subexponential-time quantum algorithm for the DHSP (see also [5][6] for its improvements). 
The DHSP is related to a lattice problem. Regev [7] shows that if an efficient algorithm exists for the DHSP then one can efficiently solve the unique Shortest Vector Problem (uSVP). Some lattice-based cryptosystems assume the hardness of the uSVP. In fact, no classical polynomial-time algorithm for the uSVP is known. However, since the periodic structure of a lattice is suited to quantum computation, many researchers have tried to solve lattice problems with a quantum computer, 
but no polynomial-time quantum algorithm for the uSVP is known to date. 
A. Problem Statement and Our Main Result 
In this paper, we restrict ourselves to dihedral groups of order a power of two. For a positive integern, letD2n denote a dihedral group of order2n+1 (see the next section for the definition of the dihedral groupD2n ). Let f be a function on D2n andH a subgroup ofD2n . We say that the functionf hides the subgroupH if the following holds: for allg, g′ ∈ D2n , f(g) = f(g′) if and only if Hg = Hg′ for the right cosets ofH. The DHSP is stated as follows. 
Problem 1 (DHSP). Given an efficiently computable function f onD2n that hides a subgroupH of D2n , find the generators of H by evaluating the functionf . 
In our paper [8], we present a simple quantum algorithm for the DHSP. Our approach to the DHSP is essentially the same as the one taken by Ettinger and Høyer [3]. Using the quantum Fourier transform, we reduce the DHSP to a problem of distinguishing (discrete) probability distributions. To solve the latter problem we propose a simple statistical test, which can be performed in polynomial time on a classical computer 
nder some heuristic assumptions stated in Section 4.2 of [8], and so the DHSP can be solved in polynomial time on classical and quantum computers. The description and analysis of our quantum algorithm are given in Sections 3 and 4 of [8]. Our main result is summarized in the following (informal) theorem: 
Theorem 2. There exists a quantum algorithm for the DHSP over D2n , whose runtime is polynomial in under some heuristic assumptions. 
See [8] for aheuristicproof. 
B. Related Work 
The related work includes [3]–[6], among others, as mentioned above. For a survey on the DHSP see [9]. We have to mention the work of Baconet al. [10]. They show the optimal measurement for the DHSP using a Pretty Good Measurement (PGM) and a result about quantum hypothesis testing, which has a better query complexity than [3]. They al o show the equivalence between the implementation of the optimal measurement in a restricted form and the solution of 
 
the average-case subset sum problem. Since the average-case subset sum problem appears to be hard, the PGM approach seems unlikely to yield an efficient quantum algorithm for the DHSP. Chia and Hallgren [11] also consider a decision problem related to the DHSP and show its relation to the subset sum problem. 
II. OUTLINE OF OUR SOLUTION TO THE DHSP 
We will outline our quantum algorithm for the DHSP below. 
A. Notation 
For a positive integerN , let ZN = {0, 1, . . . , N − 1}. We denote moduloN addition and subtraction onZN by “+” and “−”, respectively. Although we use the same notation as used in the field of real numbers, the meaning is clear from the context. Note thatZN with respect to addition is a cyclic group of orderN . 
B. Reducing the DHSP to a Distribution Testing Problem 
We first recall the definition of the dihedral groupD2n 
of order 2n+1, where n is a positive integer. The dihedral groupD2n is defined byZ2⋉Z2n , a semidirect product ofZ2 
andZ2n both of which are considered as cyclic groups with respect to addition. The product operation onD2n = Z2⋉Z2n , denoted by “◦”, is defined by 
(a, x) ◦ (b, y) = (a+ b, (−1)bx+ y) (1) 
for (a, x), (b, y) ∈ D2n . For simplicity we omit the notation “◦”. 
We may assume that the hidden subgroupH is of order 2 (see [3]). Using the so-called standard method (see, e.g., [2] [9]), the DHSP for the aboveH is reduced to the following Dihedral Coset Problem (DCP)which is equivalent to the hidden shift problem over the cyclic groupZ2n (see, e.g., [2]). 
Problem 3 (DCP). For s ∈ Z2n \ {0} andx ∈ Z2n , let 
|ψs,x⟩ = 1√ 2 (|0⟩1|x⟩2 + |1⟩1|x+ s⟩2). (2) 
The state above is called acoset state. Given a (polynomial size) sample of coset states in Eq. (2) with fixeds and varying x both of which are unknown, the problem is to find the shift s (or equivalently, its binary representation(s1, . . . , sn) with s = 
∑n i=1 si2 
i−1). 
If we determine the least significant bits1 of the hidden shift s, then the DCP overD2n reduces to a smaller one overD2n−1 . By using such a reduction we can solve the DCP iteratively. See [8] for more details. 
To determine thes1 we use the Quantum Fourier Transform (QFT). Using the QFT, we reduce the problem of determining s1 to that of distinguishing between the discrete probability distributionsP andQ onZN defined below, whereN = 2n−1. For y ∈ ZN , 
P (y) = 1 
N and Q(y) = 
2 
N cos2 
( π s′y 
N 
) , (3) 
wheres′ is a nonzero element ofZN . See [8] for more details. 
C. Distinguishing the DistributionsP andQ 
To solve the above distribution testing problem we propose the following statistical test: 
1) (a) From coset states we obtainYj , j = 1, . . . ,M , samples from unknown distribution (P or Q). 
(b) ComputeSM = ∑M 
j=1 g(Yj) where g is the test function defined onZN : 
g(y) = ( − ln 
( 1− y 
N 
))K 
, y ∈ ZN , (4) 
whereM = poly(n) andK = poly(n). (c) Continue the above steps to obtain manySM ’s. 
2) (a) GenerateY ′ j , j = 1, . . . ,M , by sampling from the 
uniform distributionP . (b) ComputeSP 
M = ∑M 
j=1 g(Y ′ j ). 
(c) Continue the above steps to obtain manySP M ’s. 
3) Compute(SM )1/K ’s and (SP M )1/K ’s, and construct the 
histograms of these data. 4) Conclude that the distribution in question isP if two 
histograms are close inℓ1 metric, andQ otherwise. 
We implemented the above statistical test in MATLAB and performed a Monte Carlo simulation. The simulation result can be found in [8]. 
III. C ONCLUSION 
In this extended abstract, we outlined our solution to the DHSP for the caseD2n . For lack of space we omitted a heuristic analysis of the statistical test given in the previous section, which can be found in [8]. It remains open to give a rigorous proof of correctness of our quantum algorithm. 
REFERENCES 
[1] P. W. Shor, “Polynomial-time algorithms for prime factorization and discrete logarithms on a quantum computer,”SIAM Journal on Computing, vol. 26, no. 5, pp. 1484–1509, 1997. 
[2] A. M. Childs and W. van Dam, “Quantum algorithms for algebraic problems,”Reviews of Modern Physics, vol. 82, 2010. 
[3] M. Ettinger and P. Høyer, “On quantum algorithms for noncommutative hidden subgroups,”Advances in Applied Mathematics, vol. 25, no. 3, pp. 239–251, 2000. 
[4] G. Kuperberg, “A subexponential-time quantum algorithm for the dihedral hidden subgroup problem,”SIAM Journal on Computing, vol. 35, no. 1, pp. 170–188, 2005. 
[5] G. Kuperberg, “Another subexponential-time quantum algorithm for the dihedral hidden subgroup problem,”Proc. 8th Conference on the Theory of Quantum Computation, Communication and Cryptography, pp. 20– 34, 2013. 
[6] O. Regev, “A subexponential time algorithm for the dihedral hidden subgroup problem with polynomial space,” arXiv:quant-ph/0406151, 2004. 
[7] O. Regev, “Quantum computation and lattice problems,”SIAM Journal on Computing, vol. 33, no. 3, pp. 738–760, 2004. 
[8] H. Fujita, “A heuristic approach to the dihedral hidden subgroup problem,” EasyChair-Preprint-3475, version 2, 2022. 
[9] H. Kobayashi and F. Le Gall, “Dihedral hidden subgroup problem: A survey,” IPSJ Journal, vol. 46, no. 10, pp. 2409–2416, 2005. 
[10] D. Bacon, A. M. Childs, and W. van Dam, “Optimal measurements for the dihedral hidden subgroup problem,”Chicago Journal of Theoretical Computer Science, 2006. 
[11] N.-H. Chia and S. Hallgren, “How hard is deciding trivial versus nontrivial in the dihedral coset problem?”Proc. 11th Conference on the Theory of Quantum Computation, Communication and Cryptography, pp. 6:1–6:16, 2016. 
 