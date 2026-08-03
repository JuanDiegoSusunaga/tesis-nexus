# Distributed quantum algorithm for the dihedral hidden subgroup problem - arXiv

- **ID**: `f3223d35-d0c6-46a1-b330-7fe2a7966982`
- **Tipo de Fuente**: `SOURCE_TYPE_PDF`
- **URL**: [https://arxiv.org/pdf/2503.06478](https://arxiv.org/pdf/2503.06478)

---

## Contenido Extraído / Texto Completo

Distributed quantum algorithm for the dihedral 
hidden subgroup problem 
Pengyu Yang1, Xin Zhang2, Song Lin1* 
1*College of Computer and Cyber Security, Fujian Normal University, Fujian, 350117, China. 
2School of Mathematics and Statistics, Fujian Normal University, Fujian, 350117, China. 
*Corresponding author(s). E-mail(s): lins95@gmail.com; 
Abstract 
To address the issue of excessive quantum resource requirements in Kuperberg’s algorithm for the dihedral hidden subgroup problem, this paper proposes a distributed algorithm based on the function decomposition. By splitting the original function into multiple subfunctions and distributing them to multiple quantum nodes for parallel processing, the algorithm significantly reduces the quantum circuit depth and qubit requirements for individual nodes. Theoretical analysis shows that when n ≫ t (t is the number of quantum nodes), the time complexity of the distributed version is optimized from 2O( 
√ n) (the traditional algorithm’s 
complexity) to 2o( √ 
n−t). Furthermore, we carried out the simulation on the Qiskit platform, and the accuracy of the algorithm is verified. Compared to the original algorithm, the distributed version not only reduces the influence of circuit depth and noise, but also improves the probability of measurement success. 
Keywords: Distributed quantum computing, Dihedral hidden subgroup problem, Hidden shift problem, Function resolution 
1 Introduction 
Quantum computing is widely considered a key technology to break through the limits of classical computing due to its exponential acceleration potential in specific problems, such as Shor’s algorithm[1], Grover’s algorithm[2], and so on[3, 4]. However, the 
1 
 
 
 
 
 
 
 
 
 
 
 
current mainstream noisy intermediate-scale quantum (NISQ) devices [5, 6] are limited by the number of qubits, connectivity and noise interference, which means that it is difficult to support the large-scale quantum algorithms. In order to solve these problems, distributed quantum computing [7] comes into being. It is a new architecture that combines distributed computing and quantum computing, allowing different quantum processor nodes to communicate and cooperate to complete computing tasks. This ”divide and conquer” strategy is able to make full use of existing NISQ devices to achieve quantum speedup while maintaining the overall efficiency of the algorithm. 
In 2021, J.Avron et al. [8] proposed a specific distributed computing scheme, which decomposed the calculated Boolean function into multiple sub-functions and ran these on different quantum devices. Specifically, J.Avron et al. split the Boolean functions calculated in Grover’s algorithm, Simon’s algorithm and Deutsch-Jozsa algorithm to design the corresponding distributed quantum computing scheme. In addition, related experiments show that they not only reduce the depth of circuits, but also reduce the noise significantly. In 2022, Tan et al. [9] improved the distributed Simon’s algorithm, which reduced the complexity to O(n) and solved the problem that the above distributed Simon algorithm could not expand the nodes to more than 2. Compared with the original Simon’s algorithm, the circuit depth is reduced from O(n) to O(n− t) (2t is the number of nodes). Subsequently, the team improved the distributed Grover’s algorithm [10], which required a smaller number of qubits and had a linear advantage in time complexity. Based on the exact Grover algorithm and the distributed scheme of splitting the original function, Zhou et al. [11] proposed the exact distributed Grover algorithm, which, like the exact Grover algorithm, can theoretically find the target state with 100%. It is worth noting that the actual circuit depth of the algorithm is 8(n mod 2)+9, which is smaller than the circuit depth of the original and modified Grover algorithm, respectively. In addition, due to the shallow depth of the circuit, it is more resistant to depolarizing channel noise than several other Grover’s algorithms. The above algorithms all reflect that when the original function is easy to split or satisfies a certain paradigm, the corresponding distributed algorithm can be naturally developed, which provides a good idea for designing distributed quantum algorithms. However, current research mainly focuses on Boolean function problems, and its adaptability to problems with complex algebraic structures remains to be explored. 
The dihedral hidden subgroup problem (DHSP) is one of the key challenges in the field of quantum computing, and its efficient solution is of great significance for cracking lattice-based cryptosystems [12]. Its goal is to find the generator of a subgroup from a black box function that hides the subgroup of a dihedral group. In 1998, Mark Ettinger and Peter Høyer pointed out that the query complexity required to solve this problem on classical computers is exponential [13], and then proposed a quantum algorithm. Although the complexity of the quantum algorithm is polynomial, it has to call o(2n) times to solve such problems, so the total complexity is o(2n). In 2005, Kuperberg [14] proposed an algorithm to solve DHSP with 2O( 
√ n) time and 
space complexity. The hidden shift problem is another computing problem, whose aim is to solve it efficiently by using the parallelism of quantum algorithm through the periodicity or displacement property of the function. It is worth mentioning that under certain conditions, DHSP can be reduced to hidden shift problem. In addition, 
2
Kuperberg has also mentioned that his algorithm can solve the hidden shift problem. But as the scale of the problem increases, the complexity still requires much more qubits and circuit depth than the NISQ device can carry. However, existing distributed quantum algorithms have not systematically solved the parallelization requirements of such complex algebraic problems. 
To solve the above problems, we propose a distributed Kuperberg algorithm based on function decomposition. By splitting the original function into multiple subfunctions and assigning them to independent quantum nodes, the algorithm realizes task parallelism and resource decentralization. At the same time, it combines the quantum sorting network to optimize the efficiency of cross-node communication. The-oretical analysis shows that when n≫ t, the time complexity of the distributed version is optimized to 2O( 
√ n) (t is the number of nodes). Moreover, the circuit depth of sin-
gle node is significantly reduced. In addition, the experimental results on the Qiskit platform also verify the feasibility of the algorithm. 
The rest of this article is organized as follows. In Sect.2, we review the Kuper-berg’s algorithm and mainly describes the algorithm flow. In Sect. 3, the distributed Kuperberg algorithm is proposed and the related mathematical proofs are given. Fur-thermore, we have disigned the related quantum circuit implementations and the experimental simulation is completed in Sect. 4. Finally, a summary of this paper is given. 
2 Preliminaries 
2.1 Dihedral hidden subgroup problem 
Definition 1 (Dihedral group[15]) The dihedral group DN is a symmetric group of a regular polygon, with 2N elements. 
DN contains all the symmetry transformations of the positive N -edge, including rotational symmetry and reflection symmetry, where the rotation angle 2π/N . DN 
can be defined as the semi- direct product of the second-order group consisting of the Nth-order cyclic group ZN with the self-isomorphic reflection s : x 7→ x−1 on ZN . The generating element of the Nth-order cyclic group ZN is r, and DN can be generated by r and s, i.e. DN 
∼= ZN × {e, s}. the elements of DN can be uniquely represented as rxsh , 0 ≤ x ≤ N − 1, h = 0, 1, with the relational equation: rN = s2 = srsr = e, with e being the unit element. 
Proposition 1 The dihedral group DN ∼= ZN×{e, s} is isomorphic to the semi-direct product 
of two cyclic groups ZN and Z2, i.e. DN ∼= ZN × Z2. 
By proposition 1 one can denote the elements of dihedral groupDN by (b, d), where b ∈{0,1}, d ∈ {0, 1, 2, · · · , N − 1}. When b = 0, call (b, d) a rotation of the dihedral group, and when b = 1, call (b, d) a reflection of the dihedral group. 
3
Proposition 2 If N is even, two subgroups {(0, 2x), (1, 2x)|x ∈ ZN/2} and {(0, 2x), (1, 2x+ 1)|x ∈ ZN/2} about the dihedral group DN are isomorphic to DN/2. 
The dihedral hidden subgroup problem is described as follows: given a function h : DN → R, where R is any set. This function h is invariant on the set of chaperones of the subgroup H ⊆ DN and has different values on different chaperones, i.e. ∀c1, c2 ∈ DN , h (c1) = h (c2) ⇔ c1H = c2H. Then DHSP is to find the subgroup H about this functionh. In 1999, Ettinger and Hoyer [12] showed that when the subgroups H = {(0, 0), (1, d)}, H are generated by reflections (1, d), DHSP can be reduced to the problem of finding the slope of reflectionsd of the generating elements of the implied subgroup H of the dihedral group, 0 ≤ d ≤ N − 1. Therefore, designing an efficient algorithm to obtain the slope becomes the key to the solution of DHSP. 
2.2 Consistency of the hidden shift problem with the dihedral hidden subgroup problem 
Definition 2 (Hidden Shift Problem) Given a group (G,+), an output set A, and two oneshot functionsf, g : G → A. Suppose there exists an unknown a ∈ G such that f(x) = g(x+a) is satisfied for all x ∈ G. The goal of the hidden shift problem is to find the shift a. 
In 2005, Childs et al.[16] investigated the general case of the above problem and showed that when the finite group G is ZN , the hidden shift problem of finding the unknown displacement a ∈ ZN is equivalent to the dihedral hidden subgroup problem. Therefore, in this case [17, 18], if there exists an algorithm that can efficiently solve the dihedral implicit subgroup problem, it can efficiently solve the hidden shift problem, and vice versa. Specifically, define the function h : DN → A on the dihedral group, and let the subgroup of the function h be H = {(0, 0), {1, d}} ,H is generated by the reflection {1, d} when h(0, x) is injective, and according to the properties of dihedral groups it is known that: 
h(0, x) = h(1, x+ d) (1) 
Define a monomial function on two cyclic groups f : ZN → A, g : ZN → A, A as any set of outputs, N=2n. By Property 3.1, we can make f(x) = h(0, x) , g(x) = h(1, x) , then equation 1 is equivalent: 
f(x) = g(x+ d) (2) 
In other words, the reflection slope d of the generator of the dihedral hidden subgroup problem is the same as the displacement a of the hidden shift problem. 
2.3 Kuperberg’s algorithm 
According to (Section 2.2) Sect. 2.2, the hidden subgroup problem solved by Kuper-berg’s algorithm can be equated to the hidden shift problem. Next, the Kuperberg’s algorithm will be described from the perspective of solving the hidden shift problem, 
4
and the specific flow is shown in 1. First, assume that there exists an Oracle that can efficiently query the values of functions f and g. The algorithm can be used to solve the hidden subgroup problem: 
|b⟩|x⟩|y⟩ o→ 
{ |0⟩|x⟩|y ⊕ f(x)⟩ if b = 0 
|1⟩|x⟩|y ⊕ g(x)⟩ if b = 1 (3) 
Algorithm 1: Kuperberg’s algorithm 
Input: positive integers N=2n, black boxes about functions f : ZN → R, g : ZN → R, R for any set. 
Output: positive integers N=2n, black boxes about functions f : ZN → R, g : ZN → R, R for any set. 
1 step 1: Prepare |0⟩|0⊗n⟩|0⊗m⟩, apply H⊗(n+1) to the first and second registers: 
|ψ⟩ = 1√ 2 (|0⟩+ |1⟩)⊗ 1√ 
2n 
∑ x∈{0,1}n 
|x⟩|0⟩. 
step 2: Query the oracle: 
|ψ⟩ = 1√ 2n+1 
∑ x∈{0,1}n 
(|0⟩|x⟩|f(x)⟩+ |1⟩|x⟩|g(x)⟩) . 
step 3: Measure the third register, collapsing to y0Collapse first and second registers to get: 
|ψ⟩ = 1√ 2 (|0⟩|x0⟩+ |1⟩|x0 + a⟩) . 
step 4: Apply Quantum Fourier Transform (QFT) to the second register: 
|ψ⟩ = 1√ 2n+1 
( 
2n−1∑ j=0 
e2πijx0/2 n 
|0⟩|j⟩+ 2n−1∑ k=0 
e2πik(x0+a)/2n |1⟩|k⟩) 
step 5: Measure the second register to obtain l, collapsing the first register to: 
|ψl⟩ = 1√ 2 
( e2πilx0/2 
n 
|0⟩+ e2πil(x0+a)/2n |1⟩ ) 
= 1√ 2 e2πilx0/2 
n ( |0⟩+ e2πila/2 
n 
|1⟩ ) 
= |0⟩+ e2πila/2 n 
|1⟩ 
step 6: |ψ2n−1⟩ is obtained by the sieve method proposed by Kuperberg, with l equal to 2n−1, at which point: 
|ψ2n−1⟩ = |0⟩+ eπia|1⟩ 
step 7: Apply a Hadamard gate, when the last bit of a is an even measurement yields 0 and the last bit is an odd measurement yields 1. 
5
Obviously, a single run of Algorithm 1 yields the last bit a0 of a. By ??, the functions f 
′ (x) = f(2x) and g 
′ (x) = g(2x + a0) can be constructed. We running 
Algorithm 1 again on the basis of the new functions constructed gives the last bit of 
a ′ = (a−a0) 
2 , which is the penultimate bit of a. Recursing this procedure yields the remaining bits of a obtained. 
It is worth noting that the sieving method used in step 6 of the algorithm is the most central part of the Kuperberg’s algorithm flow, which can reduce the complexity of the algorithm to the sub-exponential level. This is because there are 2n possibilities of l obtained by measurement in step 5. In order to obtain l = 2n−1, multiple measurements are needed and its time complexity is exponential, which will lose the advantage of quantum algorithm. In order to retain the advantages of quantum algorithms, Kuperberg proposed the sieving method, whose specific steps are described as follows: 
Firstly, steps 1-5 of algorithm 1 are used as black boxes to generate states | ψl⟩. We set m nodes, m = 
⌈√ n− 1 
⌉ . Through node 1 (measuring l have you got information), 
find out and quantum state l bits of |ψl1⟩ lowest m bits of the same quantum state l bits of |ψl2⟩, and the quantum state l bits of |ψl1⟩ and |ψl2⟩ execution with operation: CNOT was performed on |ψl2⟩ with |ψl1⟩ as the controlled bit, and then the second register was measured. At this time, the first register collapsed to | ψl1±l2⟩ = | 0⟩ + e2πi(l1±l2)a/2 
n | 1⟩. We get |ψl′ ⟩ = | ψl1−l2⟩ with 50% probability. Secondly, taking |ψl′ ⟩ as the input state of node 2, after enough states are accumulated in node 2, the states with the same lowest m + 1, · · · , 2m bits are screened from these states, and the combined operation is performed again.The obtained quantum state is taken as the input to the next node, and so on, until the node m is executed, because m ×m = n − 1, only two quantum states are left in the last node |ψ0⟩ and| ψ2n−1⟩. In other words, all the bits of the quantum state in the node are 0 except the most significant bit. Therefore, repeating this sieving step many times can obtain | ψ2n−1⟩ with high probability. 
Finally, the time complexity of Kuperberg’s algorithm is briefly analyzed. The complexity of this algorithm is determined by two main components: first, the number of bits in the hidden shift a bit. From Property 1, the number of bits of a is n = ⌈log2 |ZN |⌉ , then Algorithm 1 needs to perform O(n) iterations in total. The second is the complexity of the sieving method to get | ψ2n−1⟩ . From the specific steps of the sieving method, it can be seen that each node needs at least 4 states in order to output 1 state to the next node, and the current node needs to exist at least 2m states in order to find two states that meet the combination conditions with a probability of 50%. Therefore node 1 needs at least 8m×2m = 2O( 
√ n) states to get | ψ2n−1⟩ with high 
probability. The total time complexity is 2O( √ n) +2O( 
√ n−1) . . . . . .+2O( 
√ 2) = 2O( 
√ n) 
and the space complexity is also 2O( √ n). 
3 Distributed Kuperberg’s algorithm 
In this section, the proposed distributed Kuperberg’s algorithm is presented. First, assume that there are 2t distributed quantum computing nodes, and each node is 
6
denoted as Node w, w ∈ {0, 1}t. Secondly, the definitions and theorems related to the algorithm are given. 
Definition 3 Let the original function f, g : ZN → R satisfy f(x) = g(x + a), where a ∈ ZN is a hidden shift. ZN is decomposed into the input space t prefix and (n− t) a suffix, u ∈ {0, 1}n−t, w ∈ {0, 1}t, define a function: 
fw(u) = f(w||u), gw(u) = g(w||u) (4) 
Where w||u denotes the string concatenation operation. Each subfunction fw and gw is assigned to an independent quantum Node, Nodew, which only needs to process (n− t) bits of input. 
Definition 4 For all u ∈ {0, 1}n−t, there exist sets H(u) and R(u) containing the subfunction values generated by all nodes, respectively: 
H(u) = {fw(u) | w ∈ {0, 1}t}, R(u) = {gw(u) | w ∈ {0, 1}t} (5) 
Due to the injective property of f and g, the elements of H(u) and R(u) do not repeat each other. However, directly measuring these sets cannot directly obtain the information of hidden shift a, for two reasons: (1) the calculation results of different nodes are independent of each other, and the correlation across nodes cannot be directly established. (2) The elements in the sets H(u) and R(u) do not establish an explicit correspondence with the hidden shift a. In order to establish the relationship between subfunction values and hidden shifts, it is necessary to sort the set elements globally. Define the sorted strings F (u) and G(u) as follows: 
Definition 5 For all u ∈ {0, 1}n−t , the sorted strings F (u) and G(u) are as follows. 
F (u) = f(w0||u)||f(w1||u) · · · ||f(w2t−1||u) ∈ {0, 1}2 tm, 
G(v) = g(w0||v)||g(w1||v) · · · ||g(w2t−1||v) ∈ {0, 1}2 tm. 
(6) 
f(w0||u) ⩽ f(w1||u) ⩽ · · · ⩽ f(w2t−1||u), g(w0||v) ⩽ g(w1||v) ⩽ · · · ⩽ g(w2t−1||v), wi ∈ {0, 1}t When i ̸= j, wi ̸= wj . 
The sorting operation ensures that the generation of F (u) and G(u) depends only on the function value itself and is independent of the computing node, thus eliminating the randomness of the data distribution between nodes. 
Theorem 1 Let a = a1 ∥ a2, where a1 ∈ {0, 1}t, a2 ∈ {0, 1}n−t, for all u ∈ {0, 1}n−t, v ∈ {0, 1}n−t, there exists a2 such that: 
F (u) = G(v) if and only if u+ a2 = v (7) 
Proof Due to the injectivity of f and g, the elements in H(u) and R(u) are all distinct for ∀u, υ ∈ {0, 1}n−t. H(u) = R(v) if and only if F (u)=G(v), which is equivalent to proving 
7
that F (u) = G(v) if and only if u + a2 = v. Let w + a1 = w′: Necessity: ∀z ∈ H(u), ∃w ∈ {0, 1}t, z = f (w||u) . Since f (w||u) = g (w||u+ a) , z = g (w||u+ a). When u + a2 
has no carry, z = g (w + a1||u+ a2) = g ( w 
′ ||v 
) ∈ R(v). When u + a2 has a carry, z = 
g (w + a1||u+ a2) = g ( w 
′ + 1||v 
) ∈ R(v) . Therefore, H(u) ⊆ R(v). By the same reasoning, 
R(v) ⊆ H(u), so F (u) = G(v). Sufficiency: When F (u) = G(v), ∀z ∈ H(u), ∃w ∈ {0, 1}t, z = 
f (w||u) = g ( w 
′ ||u+ a 
) . When u+a2 has no carry, w||u+a = w′||v, w+a1 = w′, u+a2 = v. 
When u+ a2 has a carry, w||u+ a = w′ + 1||v, u+ a2 = v. In conclusion, u+ a2 = v. □ 
According to Theorem1 the core of the distributed Kuperberg’s algorithm is to obtain F (u) and G(v) , calculate the corresponding subfunctions through different nodes, and then use the quantum sorting algorithm to obtain F (u) and G(v) , and then extract the last bits of a2 through quantum Fourier transform (QFT). According 
to property 2 we can modify the original functions fw ′ (u) = fw(2u) and gw 
′ (u) = 
gw(2u+a0), where a0 is the last bit of a2, run the algorithm again to get the remaining bits of a2, and then recursively get a1 by the above formula, and finally recover all the information of a. For easy understanding, the distributed Kuperberg’s algorithm for two nodes, i.e. the case of t = 1, is firstly given as shown in Algorithm 2, and its corresponding circuit diagram is shown in Fig.1. 
8
Algorithm 2: Distributed Kuperberg’s algorithm (2 nodes) 
Input: the sub-function Oracles Ofw of the function f : ZN → R with the sub-function Oracles Ogw of g : ZN → R, R for any set, and w ∈ {0, 1}2. 
Output: Hide the last bit a0 of a2 in the shift a = a1||a2, a1 ∈ {0, 1}1, a2 ∈ {0, 1}n−1. 
1 step 1: Prepare the quantum state |0⟩|0 ⊗ 
n−1⟩ |0 ⊗ 
m 〉 |0 
⊗ m 〉 |0 
⊗ 2m 
〉 and 
apply H ⊗ 
(n) to registers 1 and 2: 1√ 2 (|0⟩+ |1⟩) 1√ 
2n−1 
∑ u∈{0,1}n−1 
|u⟩|0⟩|0⟩|0⟩ 
step 2: Query the oracle: 1√ 2 
1√ 2n−1 
∑ u∈{0,1}n−1 
(|0⟩|u⟩ |f1(u)⟩ |f0(u)⟩ |0⟩+ |1⟩ |u⟩|g1(u)⟩|g0(u)⟩|0⟩) 
step 3: Act on registers 3 and 4 at Usort and store the result after sorting registers 3 and 4 in register 5: 
1√ 2 
1√ 2n 
∑ u∈{0,1}n−1 
(|0⟩|u⟩|f1(u)⟩|f0(u)⟩|S(u)⟩+ |1⟩|u⟩|g1(u)⟩|g0(u)⟩|T (u)⟩) 
step 4: Measure register 5, collapsing register 2 to u0 and backing out registers 3 and 4 : 
1√ 2 (|0⟩|u0⟩+ |1⟩|u0 + a2⟩) 
step 5: Apply QFT to register 2: 
1√ 2n 
( 
2n−1−1∑ j=0 
e2πiju0/2 n−1 
|0⟩|j⟩+ 2n−1−1∑ k=0 
e2πik(u0+a2)/2 n−1 
|1⟩|k⟩) 
2 step 6: Measure register 2 and get l, Register 1 collapses to: 
|ψl⟩ = 1√ 2 
( e2πilu0/2 
n 
|0⟩+ e2πil(u0+a2)/2 n 
|1⟩ ) 
= 1√ 2 e2πilu0/2 
n ( |0⟩+ e2πila2/2 
n 
|1⟩ ) = |0⟩+ e2πila2/2 
n 
|1⟩ 
step 7: Through the sieve method to get |ψ2n−2⟩ , l is equal to 2n−2 , using the H door, when the last digit of a2 is an even number of measurements to get 0, The last digit is an odd number of measurements to get 1. 
Where, Usort implements the comparison of the values of two registers, after which the result of sorting in dictionary order and the third register are subjected to an 
9
Fig. 1: Distributed Kuperberg algorithm (2-node) 
all-or-nothing operation, with the expression 
Usort|q⟩|p⟩|r⟩ = 
{ |q⟩|p⟩|r ⊗ (q||p)⟩, p ≥ q 
|q⟩|p⟩|r ⊗ (p||q)⟩, p ≤ q , p, q ∈ {0, 1}m, r ∈ {0, 1}2m (8) 
Obviously, Usort does not change the value of the comparison, but only does a controlled operation based on the result of the registers. A controlled quantum gate operation between two different nodes can be realized using quantum stealth transmutation[19]. Further, Algorithm 2 can be extended to 2t nodes: replacing registers 3 and 4 with 2t control registers corresponding to 2t distributed computing nodes. Usort The implementation of the algorithm is changed to use the sorting network [20] to perform a dictionary order sorting operation on the 2t control registers, and the 2t elements can be sorted with the complexity of O(t). The specific algorithm flow is described in Algorithm 3. 
10
Algorithm 3: Distributed Kuperberg’s algorithm (t nodes) 
Input: a positive integer N=2n , with the number of nodes T = 2t , the sub-function Oracle Ofw of the function f : ZN → R with the sub-function Oracle Ogw of g : ZN → R , R for any set, w ∈ {0, 1}t. 
Output: Hide the last bit a0 of a2 in the shift a = a1||a2 , a1 ∈ {0, 1}t, a2 ∈ {0, 1}n−t. 
1 step 1: Prepare the quantum state|0⟩|0⟩|0⊗m⟩|0⊗m⟩ . . . |0⊗m⟩|0⊗2m⟩ and apply 
H ⊗ 
(n) to registers 1 and 2: 1√ 2 (|0⟩+ |1⟩) 1√ 
2 
∑ u∈{0,1}n−t 
|u⟩|0⊗m⟩ ⊗ |0⊗m⟩...⊗ |0⊗2tm⟩ 
step 2: Query the oracle: 1√ 2 · 1√ 
2 
∑ u∈{0,1}n−t 
( |0⟩|u⟩|fw0(u)⟩|fw1(u)⟩ · · · |fw2t−1 
(u)⟩|0⟩ 
+ |1⟩|u⟩|gw0(u)⟩|gw1(u)⟩ · · · |gw2t−1 (u)⟩|0⟩ 
) step 3: According to the result after sorting the last register by acting Usort 
on the 3rd -(2n−1 + 2)th register: 1√ 2 · 1√ 
2 
∑ u∈{0,1}n−t 
( |0⟩|u⟩|fw0(u)⟩|fw1(u)⟩ · · · |fw2t−1 
(u)⟩|S(u)⟩ 
+ |1⟩|u⟩|gw0(u)⟩|gw1(u)⟩ · · · |gw2t−1 (u)⟩|T (u)⟩ 
) step 4: Measuring the last register, register 2 collapses to u0 and backs out the middle 2t − 1 registers: 
1√ 2 (|0⟩|u0⟩+ |1⟩|u0 + a2⟩) 
step 5: Apply QFT to register 2: 
1√ 2n 
( 
2n−t−1∑ j=0 
e2πiju0/2 n−t 
|0⟩|j⟩+ 2n−t−1∑ k=0 
e2πik(u0+a2)/2 n−t 
|1⟩|k⟩) 
step 6: Measure register 2 and get l, Register 1 collapses to: 
|ψl⟩ = 1√ 2 
( e2πilu0/2 
n 
|0⟩+ e2πil(u0+a2)/2 n 
|1⟩ ) 1√ 
2 e2πilu0/2 
n ( |0⟩+ e2πila2/2 
n 
|1⟩ ) 
= |0⟩+ e2πila2/2 n 
|1⟩ 
step 7: Through the sieve method to get |ψ2n−2⟩ , l is equal to 2n−t−1 , using the H door, when the last digit of a2 is an even number of measurements to get 0, The last digit i s an odd number of measurements to get 1. 
Similarly, by modifying the original function fw ′ (u) = fw(2u) and gw 
′ (u) = 
gw(2u+ a0), repeat running algorithm 3 to obtain the remaining bits of a2, and then recursively obtain a1 through the above formula, and finally recover all the information of a. 
11
(a) OfSchematic of a quantum circuit (b) OgSchematic of a quantum circuit 
Fig. 2: Schematic diagram of Oracle quantum circuit of original Kuperberg’s algorithm 
Finally, the time complexity of algorithm 3 is briefly analyzed, and the complexity of algorithm 2 is the case of t = 1. The complexity of the algorithm of three also depends on two parts: one is the screening method, the time complexity of 2O( 
√ n−t), 
2 it is to get all a2 bits need to be repeated O(n − t) time, two parts complexity 
multiplied to 2O( √ n−t) + 2O( 
√ n−t−1) . . . . . .+2O( 
√ 2) = 2O( 
√ n−t). Similarly, to geta1. 
Similarly, the time complexity of a1 is 2O( √ t) + 2O( 
√ t−1) . . . . . .+2O( 
√ 2) = 2O( 
√ t), 
the overall complexity of: 2O( √ n−t) + 2O( 
√ t), when n ≫ t,2O( 
√ t) ≪ 2O( 
√ n−t), the 
complexity can be reduced to 2O( √ n−t). 
4 Experiments 
In this section, we further elucidate the correctness and effectiveness of the algorithm by running the distributed Kuperberg’s algorithm on the Qiskit version 0.44 platform. The functions defined in the experiments are the one-shot functions f : {0, 1}3 → {0, 1}4, g : {0, 1}3 → {0, 1}4, satisfying f(x) = g(x + a mod N), Their truth tables are shown in Table ??. The number of experimental runs is 2048, the number of 
Table 1: Truth table 
x g(x) f(x) x g(x) f(x) 
000 1001 1000 100 0111 0101 001 1100 1001 101 0011 0111 010 1010 1100 110 0001 0011 011 0101 1010 111 1000 0001 
nodes in the distributed experiment is 2, the number of input qubits is 3, the number of input qubits in the original Kuperberg experiment is 4, and the parameter a = 111 = 7. According to the DORCIS tool mentioned in Ref.[21], the quantum circuit design of the function Oracle component of the traditional Kuperberg’s algorithm and the distributed Kuperberg’s algorithm is carried out, as shown in Fig.2 and Fig.3 The experimental procedure includes superposition state initialization, Oracle query, quantum sorting Usort application and QFT measurement. The experimental results 
12
(a) Of0Schematic of a quantum circuit (b) Of1Schematic of a quantum circuit 
(c) Og0Schematic of a quantum circuit (d) Og1Schematic of a quantum circuit 
Fig. 3: Schematic diagram of distributed Kuperberg’s algorithm Oracle quantum circuits 
are shown in Figs.??, which indicate that the distributed version has a measurement success rate of 22.6% in obtaining the same results, which is significantly higher than that of the traditional algorithm, which is 10.6%. The circuit depth of a single node of the distributed architecture is reduced by 22% on average. The experiments verify the correctness of the distributed Kuperberg algorithm, which has a greater advantage in reducing the resource requirements and improving the probability of success. 
(a) Distributed Kuperberg’s algorithm with input bit 3 and correct result 101 
(b) Kuperberg’s algorithm with input bit 4 and correct result 1001 
Fig. 4: Comparison of experimental results 
13
5 Conclusion 
In this paper, a novel Kuperberg algorithm for distributed quantum computing environments is proposed, aiming to solve the problem of excessive quantum resource demand of the traditional algorithm. By decomposing the original function into multiple subfunctions and assigning them to different quantum nodes for parallel processing, the algorithm significantly reduces the depth of the quantum circuit and the number of qubits in a single node, while optimizing the time complexity. Theoretical analysis 
shows that the distributed version reduces the complexity from 2O( √ n) to 2O( 
√ n−t) (t 
is the number of nodes), and the advantage is especially obvious when the number of nodes is much smaller than the problem size. The experimental part validates the accuracy of the algorithm on the Qiskit platform, and the results show that the distributed version not only reduces the depth of the circuit, but also reduces the noise impact through parallelization. Additionally, the probability of measurement success is higher than that of the traditional method. This work provides new ideas for efficiently solving DHSP on NISQ devices. Future research can further explore more flexible function decomposition strategies and cross-node communication optimization to enhance the scalability and practicality of the algorithm. 
References 
[1] Shor, P.W.: Algorithms for quantum computation: discrete logarithms and factoring. In: Proceedings 35th Annual Symposium on Foundations of Computer Science, pp. 124–134 (1994) 
[2] Grover, L.K.: Quantum mechanics helps in searching for a needle in a haystack. Phys. Rev. Lett. 79, 325–328 (1997) 
[3] Harrow, A.W., Hassidim, A., Lloyd, S.: Quantum algorithm for linear systems of equations. Phys. Rev. Lett. 103, 150502 (2009) 
[4] Biamonte, J., Wittek, P., Pancotti, N., Rebentrost, P., Wiebe, N., Lloyd, S.: Quantum machine learning. Nature 549(7671), 195–202 (2017) 
[5] Preskill, J.: Quantum computing in the NISQ era and beyond. Quantum 2, 79 (2018) 
[6] Greinert, F., Müller, R., Goorney, S.R., Laurenza, R., Sherson, J., Ubben, M.S.: European competence framework for quantum technologies. In: Zenodo, pp. 1–30 (2024) 
[7] Caleffi, M., Cacciapuoti, A.S., Bianchi, G.: Quantum internet: from communication to distributed computing! In: Proceedings of the 5th ACM International Conference on Nanoscale Computing and Communication. NANOCOM ’18. Association for Computing Machinery, New York, NY, USA (2018) 
[8] Avron, J., Casper, O., Rozen, I.: Quantum advantage and noise reduction in 
14
distributed quantum computing. Phys. Rev. A 104, 052404 (2021) 
[9] Tan, J., Xiao, L., Qiu, D., Luo, L., Mateus, P.: Distributed quantum algorithm for simon’s problem. Phys. Rev. A 106, 032417 (2022) 
[10] Qiu, D., Luo, L., Xiao, L.: Distributed grover’s algorithm. Theoretical Computer Science 993, 114461 (2024) 
[11] Zhou, X., Qiu, D., Luo, L.: Distributed exact grover’s algorithm. Frontiers of Physics 18(5), 51305 (2023) 
[12] Ettinger, M., Hoyer, P., Knill, E.: Hidden subgroup states are almost orthogonal. arXiv preprint quant-ph/9901034 (1999) 
[13] Regev, O.: Quantum computation and lattice problems. Society for Industrial and Applied Mathematics Journal on Computing 33(3), 738–760 (2004) 
[14] Kuperberg, G.: A subexponential-time quantum algorithm for the dihedral hidden subgroup problem. Society for Industrial and Applied Mathematics Journal on Computing 35(1), 170–188 (2005) 
[15] Lane, S.M., Birkhoff, G.: Algebra: Third Edition. American Mathematical Society, New York (2023) 
[16] Childs, A.M., Van Dam, W.: Quantum algorithm for a generalized hidden shift problem. arXiv preprint quant-ph/0507190 (2005) 
[17] Moore, C., Rockmore, D., Russell, A., Schulman, L.J.: The power of strong fourier sampling: Quantum algorithms for affine groups and hidden shifts. Society for Industrial and Applied Mathematics Journal on Computing 37(3), 938–958 (2007) 
[18] Castryck, W., Dooms, A., Emerencia, C., Lemmens, A.: A fusion algorithm for solving the hidden shift problem in finite abelian groups. In: Post-Quantum Cryptography, pp. 133–153. Springer, Cham (2021) 
[19] Bennett, C.H., Brassard, G., Crépeau, C., Jozsa, R., Peres, A., Wootters, W.K.: Teleporting an unknown quantum state via dual classical and einstein-podolsky-rosen channels. Phys. Rev. Lett. 70, 1895–1899 (1993) 
[20] Paterson, M.S.: Improved sorting networks with o(logn) depth. Algorithmica 5(1), 75–92 (1990) 
[21] Chun, M., Baksi, A., Chattopadhyay, A.: DORCIS: Depth optimized quantum implementation of substitution boxes. Cryptology ePrint Archive, Paper 2023/286 (2023) 
15