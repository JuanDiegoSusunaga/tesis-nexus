# The Hidden Subgroup Problem - arXiv

- **ID**: `aee16957-9d1f-4677-a070-a192ae036fd8`
- **Tipo de Fuente**: `SOURCE_TYPE_PDF`
- **URL**: [https://arxiv.org/pdf/1008.0010](https://arxiv.org/pdf/1008.0010)

---

## Contenido Extraído / Texto Completo

Datalogisk Institut Det Naturvidenskabelige Fakultet Aarhus Universitet Danmark 
École Nationale Supérieure d'Informatique pour l'Industrie et l'Entreprise Evry France 
The Hidden Subgroup Problem 
Master's Project 
Frédéric Wang 20090566 
Supervisor: Ivan Damgård 
July 2010
ii 
Abstract 
We review the Hidden Subgroup Problem (HSP), one of the most prominent topic in quantum computing. We  start  with  some  "historical"  quantum  algorithms  which  are  exponentially  faster  than  their  classical counterparts,  including  the  famous  Shor's  factoring  algorithm.  Then,  we  define  HSP  and  show  how  the previous algorithms can be interpreted as solutions to this problem. 
In a second part, we describe in detail the "standard method". We recall the solution to the abelian case as well as some representation theory background that allows to use Fourier Transform over Finite Groups. We also  define  Fourier Sampling  and mention  how the  weak version  extends the  abelian  case to  find  normal hidden subgroups and solve the dedekindian HSP. 
In a third part, we discuss all the results known so far for the cases of the Dihedral and Symmetric groups, which are expected to provide new efficient algorithms. Solving the dihedral HSP in a particular way gives an algorithm for  poly(n)-uniqueSVP while  a  solution  to  the  symmetric  HSP gives  an  algorithm for  the  graph isomorphism problem. 
Finally, we conclude our study with the general HSP. We make some proposals for a general approach and discuss the solutions and techniques known so far. Next, we indicate how HSP relates to various efficient algorithms. We  also  give  an  overview  of miscellaneous  variants  and  extensions  to  the  hidden  subgroup problem that have been proposed. 
In addition to gathering in a single document an introduction to the Hidden Subgroup problem as well as an overview of the state-of-the-art for this research topic, we also bring some contributions: 
We  provide  a  detailed  and  corrected  computation  of  the  fact  that,  in  the  Strong  Fourier  Sampling, measuring the row yields no information. In  the sketchy proof of Grigni  et al., a  family of vectors was claimed to be orthonormal whereas it is only orthogonal. In appendix B, we compute the exact expression of Strong Fourier Sampling over the dihedral  group. When  the  hidden  subgroup  is  reduced  to  {(0, 0), (d , 1)},  it  has  already been  mentioned  that Strong Fourier Sampling over DN  is similar to using the Quantum Fourier Transform over ℤN ×ℤ2  and hence a particular  case  of  the  dihedral  coset  problem.  For  a  general  hidden  subgroup,  we  prove  that  the expression of the Strong Fourier Sampling is the same as if we were directly working in  the quotient group DN 
(H ∩(ℤN×{0})) . 
In appendix G, we propose an entirely new approach to try to find the slope d  of the dihedral HSP. Rather than using coset sampling, we consider uniform superpositions over large subsets of f (DN ). In particular, 
we  can  solve  the  case  N = 2n  if  we  have  an  efficient  process  to  create  for  b = 0, 1  the  states 1 
2 n−1√ ∑ 
i = 0 
2 n−1 − 1 ∣ f (2i, b)⟩. 
We give more detail  on the relation between HSP and lattice problems. In  particular, we show that if Regev's algorithm is based on a solution to the dihedral coset problem with a query complexity O(nD 
) 
then it gives a  solution to  Θ ( 
n 1 2 
+ 2 D 
) -uniqueSVP. We indicate  that the relation still  holds if we use a 
solution over D2 n  or Dih(ℤ 2 4n n 
) = ℤ 2 4n n ⋊ℤ2  using a "recursive DCP algorithm". However, we also provide 
an overview of lattice-based problems in appendix E and warn that Regev's algorithm would only have
small  impact on lattice-based cryptosystems. Hence, we propose to  consider also HSP algorithms for stronger lattice problems. 
In  appendix D, we give  a  reduction of Monotone 1-in-3  3SAT to  GapCVP∞ where one step uses the abelian  HSP algorithm to  find  the  kernel  of group  homomorphism. Although  the  quantum part is  not actually needed here, this provides another example where a hidden subgroup problem can be used. In appendix F, we give an alternative algorithm for the cyclic and abelian hidden subgroup problems, based  on  a  change  of the  underlying  group. Even  if it does not generalize, it is  a  good  example  of subgroup reduction. We present a general approach to the Hidden Subgroup Problem and show that in theory, we can solve it if we have a solution to HSP over simple groups and a way to build efficient oracles for some reduction techniques. We also propose iterative subgroup and quotient reductions: using a maximal supergroup of H  for the former and the normal subgroup obtained by Weak Fourier Sampling for the latter. Maximal subgroup reduction is a possible approach for HSP over simple groups. We indicate how to reduce the rigid graph isomorphism problem to HSP over the alternating group An, which is simple for n > 4. 
We notice how the Hidden Polynomial Problem is a natural extension of the abelian HSP over G = Fq m, 
when the subgroup H  is promised to be a hyperplane.
ii 
iv 
vi 
1 
5 
7 7 8 9 
11 
15 15 17 21 25 
28 28 31 33 37 
41 41 45 48 49 
53 
iv 
Table of Contents 
Abstract 
Table of Contents 
Acknowledgments 
Introduction 
Prerequisites 
Efficient Quantum Algorithms and The Hidden Subgroup Problem Simon's Problem Shor's Factoring Algorithm Shor's Discrete Logarithm Algorithm The Hidden Subgroup Problem 
The "Standard Method" for The Hidden Subgroup Problem The Abelian Hidden Subgroup Problem Fourier Transform over Finite Groups Weak and Strong Fourier Sampling The Dedekindian Hidden Subgroup Problem and its extensions 
The Dihedral and Symmetric Hidden Subgroup Problems The Dihedral Hidden Subgroup Problem The Dihedral Coset Problem Dihedral HSP, Lattice Problems and Cryptosystems The Symmetric Hidden Subgroup Problem 
The General Hidden Subgroup Problem General approach to the Hidden Subgroup Problem Known solutions to the Hidden Subgroup Problem The Hidden Subgroup Problem and Efficient Algorithms Variants and Extensions 
Conclusion
54 54 61 70 70 71 72 73 78 80 80 81 83 83 85 
88 
Appendix Appendix A: Table of Hidden Subgroup Problems Appendix B: Strong Fourier Sampling and the DHSP Appendix C: Attempts to solve DHSP by Fourier Sampling 
Approximation of a trigonometric expression Randomized algorithm and parity of d Eliminating many values in one call 
Appendix D: Reduction of Monotone 1-in-3 3SAT Appendix E: Table of Lattice-based Cryptosystems Appendix F: Variant for the Abelian HSP algorithm 
Cyclic Hidden Subgroup Problem Abelian Hidden Subgroup Problem 
Appendix G: Attempts to solve DHSP by superposition of oracle values Finding the parity of d Finding an approximation of d 
Bibliography
vi 
Acknowledgments 
Jeg vil  gerne sige tak til  Ivan Damgård, for at have lært mig Quantum Information Processing på først semester og have accepteret at blive min vejleder. Mange tak for at have fulgt mit arbejde og have gjort alt for at jeg kunne have en mundtlig eksamen. 
Jeg vil også give tak til alle folk, som har givet mig til at have et dejligt ophold i Danmark. Specialt tak til Mikkel  Gravgaard,  for  sin  hjælp  med  administrative  ting  da  jeg  kom.  Mange  tak  til  alle  beboere  på Skejbygårdkollegiet for alle hyggelige aftener samt sjove fodboldkampe. 
Je tiens aussi à exprimer ma gratitude envers toutes les personnes de l'ENSIIE qui m'ont permis de passer ma troisième année à Århus dans les meilleurs conditions. 
Enfin, je souhaite remercier ma famille pour son soutien tout le long de mon séjour au Danemark. Merci notamment à mon frère et ma sœur pour être venus me rendre visite quelques jours à Århus.
1. Introduction 
The Hidden Subgroup Problem is one of the most prominent topic in quantum computing. Most quantum algorithms running exponentially faster than their classical counterparts fall into this framework. It is expected that finding more solutions to Hidden Subgroup Problems will provide new efficient quantum algorithms. 
The first example of a black-box algorithm of this kind was given by Simon [Sim1994]. Classical algorithms can not give the right answer to that black-box problem unless they use an exponential number of oracle calls. This result strengthened the earlier Deutsch–Jozsa algorithm, which is only exponentially more efficient than deterministic classical  algorithm. Despite its theoretical  importance for demonstrating the power of quantum computer, Simon's algorithm does not lead to practical applications. 
However,  shortly  after  Simon  published  his  algorithm, Shor  [Sho1995] extended  it  to  find  periods  of functions  over  ℤN  and  ℤp− 1 
2 .  He  used  these  period  finding  algorithms as  key  steps  to  solve  two  difficult problems:  factoring  integer  and  computing  discrete  logarithms.  The  hardness  of  both  problems  is  the assumption on which some cryptographic systems such that the ubiquitous RSA system are based. Hence Shor's algorithms had a strong impact since they proved how quantum computers can break cryptographic systems and it has been one of the great success of quantum computing. 
Simon's  problem  and  Shor's  algorithms  can  be  better  understood  in  the  framework  of  the  Hidden Subgroup Problem. We work on a group G and try to find an unknown subgroup H  using calls to a function f . This function is constant on cosets of H  and takes different values on distinct cosets. Ettinger, Høyer and Knill proved that the subgroup H  can always be determined using only O(log∣G∣) calls to the oracle f  but the whole procedure is not necessarily efficient [EttHøyKni1999]. 
We recall the "historical" results as well as the definition of the Hidden Subgroup Problem in the first part of this report. Although they are well known by researchers working on this topic, they remain a good introduction and motivate the subsequent work. 
Once  the  framework  of  the  Hidden  Subgroup  Problem  set,  the  special  case  of  abelian  group  was addressed. Indeed, the algorithms given by Simon and Shor work on abelian groups and the main ingredients such that entanglement over a coset and Quantum Fourier Transform could easily be extended to solve the abelian  Hidden  Subgroup  Problem.  The  algorithm  requires  the  knowledge  of  a  decomposition  G ≅ 
ℤt1 ×ℤt2 
×ℤt3 ×…×ℤtk 
 but if the group is given in a black box form, we can still  determine that decomposition. 
Because the algorithm is fundamental, we start the second part of this report by recalling how the abelian HSP algorithm works. We also sketch the idea of Cheung and Mosca [CheMos2001] to get the decomposition for a black-box group. 
The success of the Fourier Sampling to solve the abelian HSP naturally made the researchers study its generalization over non-abelian groups. This is quite technical, so we take care to define precisely Quantum Fourier Transform and Fourier Sampling. We study how they apply to non-abelian HSP in the remainder of the second part of this report. 
We first extract the  essential  points from the  reference  book on  group  representation  theory by Serre [Ser1971] to show that it is always possible to define a general Quantum Fourier Transform over finite groups 
1
as a unitary operation. We indicate how it extends the classical Quantum Fourier Transform used for abelian groups. In the non-abelian case, it turns out that each choice of basis for the set of irreducible representations gives rise  to  a  specific  Quantum Fourier  Transform. We  use  the  Schur's  lemma to  show  that they are  all described modulo basis changes in the space of each irreducible representation. 
Next, we turn our attention to the Fourier Sampling over finite groups using the studies of [HalRusTa-2000] and [GriSchVaz2000]. It is the occasion to recall the standard method of coset sampling: we gather information on the hidden subgroup from coset states i.e. uniform superposition over a random coset of H . Then, we apply several Fourier Samplings to these cosets states: a Quantum Fourier Transform followed by a measurement of an irreducible representation. We define the Weak and Strong versions and recall  classical  expressions on distribution probabilities. In particular, we give a detailed proof of the fact that measuring the row is not relevant for Strong Fourier Sampling. 
We then  see  how the  Weak Fourier  Sampling  is enough  to  solve  the  Dedekindian  Hidden  Subgroup Problem i.e. for groups that have only normal subgroups. In the new framework, the algorithm of the abelian case can be seen as computing the hidden subgroup as the intersection of the kernels of the representations measured  by  Fourier  Sampling.  Independently,  [HalRusTa-2000]  and  [GriSchVaz2000]  showed  that  this technique  still  works  when  the  hidden  subgroup  is  normal,  thus  solving  the  dedekindian  in  theory. [HalRusTa-2000]  contains  an  explicit  algorithm  for  the  class  of  hamiltonian  groups  which  are  the  only non-abelian  dedekindian  groups. We also  mention  briefly more  results of [GriSchVaz2000] and  [Gav2004] such that extensions to groups that are in some sense not too far from the dedekindian case as well as a black box result to find normal subgroups. 
The third part of this report is dedicated to the two most important open non-abelian HSPs: those over the dihedral  and  symmetric groups. Regev showed  that a  solution  to  the  Hidden  Subgroup  Problem over the dihedral group using coset samplings on a particular reduced case would provide an efficient algorithm for the poly(n)-uniqueSVP [Reg2004]. uniqueSVP is an instance of lattice problems, which are involved in many tasks believed  to  be  computationally  hard. More  specifically,  some  cryptographic  systems are  based  on  lattice problems and some of them use the poly(n)-uniqueSVP. A solution to the Hidden Subgroup Problem over the symmetric group gives a polynomial algorithm to determine whether two given graphs are isomorphic, one of the very rare problems whose exact complexity has remained unknown for many decades. 
The dihedral Hidden Subgroup Problem was first considered by Ettinger and Høyer as a first study of the non-abelian  case  [EttHøy1998]. They gave  an  interesting  reduction  of the  problem to  the  case  where  the hidden subgroup is {(0, 0), (d , 1)} and showed that we can determine d  with efficient query and measurement but exponential post-processing. We describe the structure of the dihedral group and explain the techniques of Ettinger and Høyer. We also discuss whether the algorithms of the previous section work. In particular, we give a  very detailed  description  of Fourier  Sampling  over the  dihedral  group  in  appendix B and  present some attempts to solve DHSP using this method in appendix C. We introduce the Dihedral Coset Problem which is essentially asking whether we can solve the dihedral HSP using a black box that outputs coset states. This problem encapsulates all the previous approaches. However, we propose a totally new method in appendix G. 
In  another  section,  we  study  the  results  obtained  from  this  dihedral  coset  black  box.  In  [Kup2003], Kuperberg gave a subexponential time algorithm to determine the parity of d  from a dihedral coset black box, using a new combine-and-measure technique. This algorithm can be easily extended to get a solution to the dihedral  HSP with subexponential  time. Actually, Kuperberg's algorithm uses exponential  space but Regev gave a modification that makes the space requirement polynomial [Reg2004]. More generally, Bacon, Childs and van Dam used tools from quantum-information theory to characterize the measurement on k outputs of the black box that gives the optimal information [BacChiDam2005]. They showed that k must be at least linear even 
2
for determining the parity of d  as in Kuperberg's algorithm. They also demonstrated a relation between the implementation of the optimal measurement and the subset sum problem. Actually, Regev had already shown such a relation in [Reg2003]. 
Next we look more carefully to Regev's algorithm [Reg2003] that establishes a connection between the polynomial  uniqueSVP  and  a  solution  to  the  dihedral  coset  problem.  We  show  how  the  degree  of  the polynomial complexity of a solution to the dihedral coset problem is related to the degree of the approximation in the uniqueSVP. We notice that mutatis mutandis his algorithm can be applied using more HSP problems over the family of generalized dihedral  groups. Similarly, we indicate that the algorithm still  holds for some kinds of recursive dihedral coset problem as in the case of Kuperberg's algorithm. We sum up in appendix E the overview of [MicReg2008] and notice that the problem considered is however not of major importance. We suggest some research directions to investigate. 
Then  we  turn  our  attention  to  the  case  of the  symmetric  group. We  recall  the  definition  of the  graph isomorphism problem as well as related problems. We describe the straightforward reduction of the equivalent graph automorphism problem to  the  symmetric hidden subgroup problem, or more  specifically to  the  case where we want to determine whether the hidden subgroup is trivial or not. We also talk about another reduction for the case of rigid graphs given in [MooRusSch2005]: the underlying group is Sn ≀ ℤ2 ⊆ S2n  and the hidden subgroup H = {Id, σ}. Moreover, we prove that the rigid graph isomorphism problem can actually be set in the reduced case of the simple group A2n . Unfortunately, even these simpler cases have remained unsolved. We recall the negative results on the symmetric group and suggest to split the problem in more separate cases. 
In a final part, we study the general hidden subgroup problem. We recall the two fundamental theorems describing how finite  groups are built from simple groups using composition series. We state conditions to solve the general  HSP: find a way to solve the HSP over simple group and to build efficient oracles when breaking down the group. For the second conditions, we isolate two particular reduction methods: subgroup reduction and quotient reduction. We propose iterative quotient reduction to make the hidden subgroup not contain any non-trivial normal subgroup. We also suggest iterative maximal subgroup reduction as a possible way to solve the HSP over the simple groups. We sum up our ideas in a general schema for a possible HSP algorithm. We notice how these ideas relate to an alternative abelian HSP algorithm proposed in appendix F and to dihedral and symmetric HSP. We explain how the classical attempts for dihedral HSP are using quotient and subgroup reductions. For the symmetric HSP, the reductions give two difficult problems: either solving HSP over the large simple group An or building a oracle over ℤ2 from the big initial oracle over Sn. 
In the next section, we review the solutions and techniques obtained for non-abelian groups. We recall the Fourier Sampling techniques as well as all the methods that have been discovered in order to find a solution to the dihedral  HSP. We mention other techniques relying on the blackbox paradigm. We give an overview of efficient HSP algorithms based on these methods. They can essentially be classified into three groups: the extensions to  the  Dedekindian  HSP which  apply to  groups with  a  large  amount of normal  subgroups, the semi-direct products of two abelian groups A⋊B which are broken down into the abelian groups A and B with respect to the description of the previous section and another category of groups whose normal series structure is simple enough to apply blackbox techniques. In some sense, they are all  close to the abelian case. We mention a partial result for an exception which includes the simple group PGL(2, pm), namely finding 1-point stabilizer of some Lie groups. 
The  following  section  is  devoted  to  relation  between  HSP  and  efficient  algorithms  with  concrete applications. We recall  the results for dihedral and symmetric HSP. We mention Hallgren's generalization to infinite  groups ℝr  which  allowed  him to  solve  Pell's  equation  and  other number fields problems. We also mention  more relationship  between HSP an cryptography. Considering  that the  general  HSPs are  actually 
3
difficult, Moore, Russell, Vazirani  constructed  a  one-way function  which  is  as hard  to  invert as  the  graph isomorphism problem. [Dam1988] contains a proposal  for a hard problem with application to cryptography: Given l + 1 = O(log p)  successive evaluations of the Legendre symbol  ( 
s p), ( 
s+ 1 p ), …, ( 
s+ l p ) predict the next 
value ( s+ l+ 1 
p ). We mention how a weaker problem can be set in the HSP framework and has been solved 
[DamHalIp2002].  The  authors  say  that  the  solution  to  this  weaker  problem  allows  attacks  to  some cryptosystems,  already  broken  by  Shor's  algorithm  though.  We  also  discuss  the  comparaison  given  in [LomKau2006] between Shor's algorithm and Grover's algorithm. We compare their method with the algorithms for  the  1-point  stabilizer  given  in  [DenMooRus2008]  and  wonder  whether  they  can  be  interpreted  as exponentially fast solutions to some concrete search problems. 
We conclude our study with some variants and extensions to the hidden subgroup problem which are also expected to yield new efficient quantum algorithms. We mention the generalization to hypergroups and infinite groups. Other extensions include the Hidden Symmetries Problem and the Hidden Covering Space Problem. We  describe  the  quite  popular  variants  of the  Hidden  Shift Problem which  is  related  to  the  dihedral  and symmetric HSP, as well  as its generalizations the Generalized Hidden Shift Problem and the Hidden Coset Problem. We mention  three  problems introduced in  [FriEtAl2002] to  solve  some instances of HSP: Hidden Stabilizer  Problem,  Orbit  Coset  Problem  and  Orbit  Superposition  Problem.  We  also  talk  about  some decision/search versions of hidden subgroup problems. Next, we show how finding hyperplane subgroups of the  vector  space  G = Fq 
m  naturally  generalizes to  the  Hidden  Polynomial  Problem. Finally, we  discuss the category of Hidden Shifted Subset Problems. 
4
2. Prerequisites 
Unless otherwise specified, we use the notations described in this section as well as other classical ones not mentioned below. We assume basic knowledge of quantum computing: an excellent introduction is the book of Nielsen and Chuang [NieChu2007]. The paper of Lomont [Lom2004] also contains a presentation of the main ideas as well as a good overview of the Hidden Subgroup Problem and its status as of 2004. Some advanced mathematical concepts will also be required and sometimes recalled as needed. 
log (binary logarithm), φ(n) (Euler's totient function), ∣S ∣ (cardinality). 
numbers: ⅈ (imaginary unit), ⅇ (euler's number), c *  (conjugate), ⌊c⌋ and ⌈ f ⌉ (ceiling and floor). limit and asymptotic approximation: f → c ( f  has limit c), f = O(g) ( f  bounded above by a constant times g), f = Ω(g) ( f  bounded below by a constant times g), f = Θ(g) (the two previous equalities hold), f = o(g) 
( f  bounded above by εg  with  ε → 0), f ∼ g  ( f  and g  are  equivalent), comp( f )  means the worse-case 
complexity of f , poly(x) means O(P(x)) for polynomial P of x. Recall that n ! ∼ 2πn√ ( n ⅇ) 
n  (Stirling formula) 
and φ(n) 
n = Ω( 
1 log(log(n))). 
Group laws are noted + for abelian groups and by a multiplication for general groups. ℤ2 n may be seen as 
n-bits numbers, so in that case ⊕ is sometimes used instead of +. algebraic structures: G1 ⊕G2  (direct sum), G1×G2  (direct product), G1⋊φG2  (semi-direct product), G1 ≀G2 
(wreath product), G H  (quotient), H ⊲ G (normality), Ker f  (kernel), Imf  (image), G1 ≅ G2  (isomorphy), gH 
and Hg (left and right coset), ⟨S⟩ (group generated by S), N(S) = {g ∈ G, S = gSg−1 } (normalizer of S), [G1 
, G2] = ⟨ g 1 −1g 
2 −1g1g2 (g1, g2) ∈ G1×G2{ }|| ⟩  ,  [G, G]  (derived  or  commutator  subgroup),  Φ(G) = 
⋂ H  proper maximal subgroup G 
H  (Frattini subgroup), Z (G) (center of G). We also simply use the term "Coset" for 
left coset. We also define the normal subgroup MG = ⋂ H  subgroup ofG 
N(H ). 
some  algebraic  structures: ℤk  (cyclic  group  ℤ kℤ ), ℤp 
*  with  p  prime  (multiplicative  group  of invertible 
elements  of  ℤp),  ℚ8  (quaternion  group),  DN  (dihedral  group),  SN  (symmetric  group),  AN  (alternating group), GLn(K) (general linear group of degree n over a field K). Fq is the finite field of order q. GL(n, q) = 
GLn(Fq). 
vectors  and  matrices:  x.y = ∑ i = 1 
n xi yi,  0n  (zero  vector  of  length  n),  A† = (A*) t = (A 
t ) 
*  (hermitian 
conjugate), ⟨A, B⟩F (Frobenius hermitian product), ‖A‖F = tr(A †A)√  (Frobenius norm). Recall that if U , V 
are unitary, ‖UAV‖F = ‖A‖F. 
quantum mechanics: ∣x⟩, ⟨x∣, ⟨x∣y⟩, ∣x⟩∣y⟩ (bra-ket notations). 
quantum circuit:   (measurement),  H  (hadamard  gate),  U ⊗V  and  U⊗n  (tensor  product  of  unitary 
transforms). For any function f : ℤ2 n → ℤ2 
m, we define the gate Uf  by ∀ (x, y) ∈ ℤ2 n×ℤ2 
m, Uf (∣x⟩∣y⟩) = ∣x⟩ 
∣ f (x) ⊕ y⟩. If f  can be implemented using a poly(n) complexity then it is also the case for the quantum version Uf . probability theory: P(X)  (probability of an event X), P( X Y )  (conditional  probability of X  given Y ), E(X) 
(mean).  To  bound  probabilities,  we  use  variants  of  Hoeffding's  inequality:  if  we  have  independent 
5
bounded variables Xk ∈ [0, 1] then their sum S = ∑ k= 1 
n Xk satisfies P(S − E(S) ≥ t) ≤ exp( − 2 t 2 
n ). 
number  theory:  let  p  be  an  odd  prime,  the  Legendre  symbol  ( a p)  is  0  if  a  is  a  multiple  of  p  and 
a ( p−1) 
2  mod (p) = ± 1 otherwise. 
6
3. Efficient Quantum Algorithms and The Hidden Subgroup Problem 
3.1. Simon's Problem 
This  problem  imagined  by  Simon  [Sim1994]  demonstrates  a  quantum  algorithm  solving  a  black-box problem exponentially faster than any probabilistic classical  algorithm. Contrary to Deutsch–Jozsa algorithm [DeuJoz1992], it is even exponentially faster than probabilistic classical algorithms. 
Definition 3.1 (Simon's problem) 
Let m ≥ n be natural numbers and f : ℤ2 n → ℤ2 
m a function. Assume that there is a string s ∈ ℤ2 n such that 
two distinct x, x ' have the same image iff x ' = x ⊕ s. Simon's problem is to determine s. ◇ 
The quantum solution to the problem is to repeat enough time the procedure given by the following circuit: 
0n|| ⟩ 
0m|| ⟩ Uf 
H⊗n H⊗n 
Figure 3.1 
After applying Uf , we are in the state: 
1 
N√ ∑ x= 0 
N − 1 
∣x⟩∣ f (x)⟩ (3.1) 
Measuring the second register gives a value y and makes the first register collapse to the superposition of its two preimages x, x ⊕ s : 
1 
2√ (∣x⟩ + ∣x ⊕ s⟩)∣y⟩ (3.2) 
After the second Hadamard gate, the state in the first register is 
1 
2√ 
1 
N√ ∑ z = 0 
N − 1 
((−1) z .x + (−1) z .( x⊕s))∣z⟩ (3.3) 
Performing a standard measurement on the first register yields a random n-bits vector z such that z.s = 0 
i.e. in the subspace orthogonal to s. Repeating the procedure O(n) times gives a set of generators z1, …zO(n) for 
7
this  subspace  with  probability  exponentially  close  to  1.  Said  otherwise,  we  have  a  system of  equations 
∑ i = 1 
n z i 
j si ≡ 0 mod (2) of rank the dimension of the subspace and n unknowns s1, …sn. If s = 0, then the rank of 
the system is n, so we get the unique solution s = 0. Otherwise s ≠ 0 and the rank of the system is n − 1, so solving the system gives a subspace of dimension n − (n − 1) = 1, which is simply {0, s}. In either case, we have obtained s as expected. The procedure is repeated O(n) times, so a polynomial number of queries to the oracle f  are used. 
What about (probabilistic) classical algorithm? Consider the special case m = n. Let's choose randomly f to  be  a  permutation  (s = 0)  or  a  two-to-one  function  (s ≠ 0).  In  the  former  case,  we  randomly  choose  a permutation f  and in the latter case a nonzero string s. Simon proved that a classical algorithm calling f  no 
more than 2 n 
4  times can not determine whether s is zero or not with success probability greater than 1 2 
+ 2− n 2 . 
Hence for a fixed minimal probability of success 1 2 
+ δ, no classical  algorithm using a polynomial number of 
queries can solve Simon's problem. 
3.2. Shor's Factoring Algorithm 
Shor's algorithm [Sho1995] allows to factor an integer N0  in poly(log N0) time. No classical algorithm are currently known to run this task in polynomial time. Actually, some cryptographic protocols are based on the assumption that no efficient algorithm exists for integer factoring and hence Shor's algorithm shows that they can be broken by quantum computation. 
Shor's  algorithm  contains  classical  parts  that  can  be  executed  in  polynomial  time  and  quantum computation is actually only used in a sub-procedure. More precisely, one step is to choose a random integer a 
< N0  (which can be assumed to be coprime with N0). The function defined on ℤ  by f (x) = ax  mod (N0) is r -periodic and the problem reduces to find the period r. We can restrict our study to the domain ℤN ⊆ ℤ for some multiple N  of the period. Of course, we do not know how to choose N  precisely but it is possible to find some 
value N = O(N0 2 ) for which the approximation does not change the final result. For simplicity, let's assume N 
= rM  is an exact multiple of the period. The period-finding submodule can be executed in poly(log N) = poly 
(log N0) using the circuit of figure 3.2, which is very similar to the one of Simon's problem. We define the Fourier transform FN  to be the symmetric matrix 
FN = 1 
N√ ∑ i = 0 
N − 1 
∑ j = 0 
N − 1 
ⅇ 2π ⅈ N 
i j ∣ j⟩⟨i∣ (3.4) 
It can easily be shown to be unitary and hence a valid quantum operation. We assume that there exists an efficient implementation of poly(log N) elementary gates computing FN . This implementation uses n = ⌈log N⌉ 
qubits, so we are working in an Hilbert Space of dimension 2n ≥ N. Hence some basis states may not be used, they are just unchanged by the gate implementing FN . 
8
0n|| ⟩ 
0n|| ⟩ Uf 
FN FN 
Figure 3.2 
The first call to FN  on 0n  returns the first column of FN  i.e. a uniform superposition of basis vectors as in Simon's algorithm. Hence the state after Uf  is also 
1 
N√ ∑ x= 0 
N − 1 
∣x⟩∣ f (x)⟩ (3.5) 
Measuring the second register gives a value y and makes the first register collapse to the superposition of the preimages of y. If x0 is such an image all the others are obtained by x0 + ir for i going from 0 to M − 1: 
1 
M√ ∑ i = 0 
M − 1 
∣x0 + ir⟩∣y⟩ (3.6) 
After the second Fourier Transform gate, the state in the first register is 
1 
MN√ ∑ j = 0 
N − 1 
( ∑ i = 0 
M − 1 
ⅇ 2π ⅈ N 
( x0 + ir) j 
) ∣ j⟩ (3.7) 
Each sum over i  is a geometric series of initial term ⅇ 2π ⅈ 
N x0 j 
 and ratio ⅇ 2π ⅈ 
N r j 
. So the sum is nonzero (and 
equal to Mⅇ 2π ⅈ 
N x0 j 
) iff ⅇ 2π ⅈ 
N r j 
= 1 iff j ≡ 0 mod ( N r ) iff j is multiple of M. Hence the state can be rewritten: 
1 
r√ ∑ j multiple of M 
ⅇ 
2π ⅈ x0 j 
N ∣ j⟩ (3.8) 
All the vectors in the sum have same amplitude, so measuring the first register yields a uniformly random multiple of M  between 0 and N − 1. Using k trials gives j1, … jk  multiples of M . One can show that gcd( j1, … jk) 
= M  with success probability ≥ 1 − 2− k 2  (see Appendix E of [Lom2004] applied to ti = ji M 
) and thus we get r = 
N M 
. 
3.3. Shor's Discrete Logarithm Algorithm 
Definition 3.2 (discrete logarithm) 
Let p be a prime number and g a generator of ℤp * . Any x ∈ ℤp 
*  can be written uniquely as x = gy  for some 
y ∈ ℤp− 1. y = logg x is called the discrete logarithm of x (with respect to g). ◇ 
9
Similarly  to  Shor's  algorithm,  some  cryptographic  protocols  are  based  on  the  difficulty  of  computing discrete  logarithms.  In  [Sho1995],  Shor  describes  a  quantum  algorithm  to  compute  these  logarithms  in polynomial time. So suppose x, g are given and that we want to find y. 
We first define the function f (a, b) = ga xb mod (p) going from ℤp− 1×ℤp− 1  to ℤp. Each call  to f  is clearly 
done in  time poly(log(p)). Note that we can rewrite  f  using the discrete logarithm y: f (a, b) = ga+ yb  mod (p). Hence (a1, b1) ≡ (a2, b2) + λ(y, − 1) mod (p − 1) implies f (a1, b1) = f (a2, b2). Conversely, if this equality is true, we have a2 − a1 ≡ y(b1 − b2) mod (p − 1) and we can take λ ∈ ℤp− 1 to be the unique element congruent with b2 
−b1 modulo p − 1 to recover the previous equality. As a consequence, we can say that (y, − 1) is the period of f  and all the values are obtained when λ varies from 0 to p − 2. 
We now define a circuit which is really similar to those we saw earlier. Here, the first register is the tensor product of two ⌈log(p − 1)⌉-qubits state and the second a ⌈log(p)⌉-qubits state. On the first register we apply Fp− 1 ⊗Fp− 1 i.e. a Fourier transform on each state of the tensor product: 
Uf 
0|| ⟩ 
0|| ⟩ 0|| ⟩ Fp− 1 ⊗Fp− 1 Fp− 1 ⊗Fp− 1 
Figure 3.3 
On the first register applying the first Fp− 1 ⊗Fp− 1  gives, as in Shor's algorithm, a superposition over the whole group 
( 
1 
p − 1√ ∑ a = 0 
p− 2 
∣a⟩ )( 
1 
p − 1√ ∑ b = 0 
p− 2 
∣b⟩ ) 
= 1 
p − 1 ∑ a ,b = 0 
p− 2 
∣a⟩∣b⟩ (3.9) 
Then, applying the Uf  operator gives the superposition 
1 
p − 1 ∑ a ,b = 0 
p− 2 
∣a⟩∣b⟩∣ f (a, b)⟩ (3.10) 
Measuring the second register yields a f (a0, b0) and makes the first register collapse to the superposition of the preimages. By the discussion above it is: 
1 
p − 1√ ∑ λ= 0 
p− 2 
∣a0 + λy⟩∣b0 − λ⟩∣ f (a0, b0)⟩ (3.11) 
Now, we apply Fp− 1 ⊗Fp− 1 on the first register, giving the state 
10
1 p − 1√ ∑ λ= 0 
p− 2 
( 
1 
p − 1√ ∑ u = 0 
p− 2 
ⅇ 
2π ⅈ(a0 + λy)u 
p− 1 ∣u⟩ )( 
1 
p − 1√ ∑ v= 0 
p− 2 
ⅇ 
2π ⅈ(b0 − λ)v 
p− 1 ∣v⟩ ) 
(3.12) 
which we can further simplify to 
1 
( p − 1√ ) 3 ∑ 
λ, u , v= 0 
p− 2 
ⅇ 
2π ⅈ((a0u+b0v)+ λ( yu−v)) 
p− 1 ∣u⟩∣v⟩ = 1 
( p − 1√ ) 3 ∑ 
u , v= 0 
p− 2 
ⅇ 
2π ⅈ(a0u+b0v) 
p− 1 
( ∑ λ= 0 
p− 2 
[ ⅇ 
2π ⅈ( yu−v) 
p− 1 
] 
λ 
) ∣u⟩∣v⟩ 
(3.13) 
The sum over lambda is a geometric series, and its value is nonzero (and of value p − 1) iff yu − v ≡ 0 mod 
(p − 1). Replacing v by yu in the expression gives the final state: 
1 
p − 1√ ∑ u = 0 
p− 1 
ⅇ 
2π ⅈ(a0 +b0 y)u 
p− 1 ∣u⟩∣yu⟩ (3.14) 
A measurement in the standard basis gives u and yu modulo p − 1. If u and p − 1 are coprime, using the euclidean algorithm we can find  v  such that uv = 1  modulo  p − 1  from the  first state. Then, we get y = yuv 
modulo p − 1 from the second state. So we have obtained y = logg x  as expected. Note that u and p − 1 are 
coprime with probability φ(p− 1) 
p = Ω( 
1 log(log(p))) so we only need to repeat the procedure about log(log(p)) times 
to ensure a success with high probability. 
3.4. The Hidden Subgroup Problem 
In this section, we interpret the algorithms seen in previous sections in a common framework. The hope is to find new algorithms exponentially faster than their classical counterparts. 
Definition 3.3 (hidden subgroup problem) 
Let  G  be  a  group  and  H ⊆ G  one  of  its  subgroup.  Let  S  be  any  set  and  f : G → S  a  function  that distinguishes cosets of H  i.e. ∀ g1, g2 ∈ G, f (g1) = f (g2) ⇔ g1H = g2H . The hidden subgroup problem (HSP) is 
to determine the subgroup H  using calls to f . ◇ 
11
Example 3.4 (interpretation of previous algorithms) 
Problem G H S f Comment 
Simon ℤ2 n {0, s} ℤ2 
m 
Such that two distinct elements x, x ' 
have the same image iff x ' = x 
⊕ s. 
s is any n-bits strings. 
Shor's algorithm (order finding subroutine) 
ℤN rℤN ℤN 
f (x) = ax  mod 
(N0) 
N0 is the number to factor, a < N0 
a random integer coprime with N0, r is the order of a modulo N0. Ideally, N should be a multiple of r but we can choose some N = 
O(N0 2 ) giving a good 
approximation. 
Discrete logarithm 
ℤp− 1×ℤp− 1 (y, − 1)ℤp− 1 ℤp * 
f (a, b) = ga xb 
 mod (p) 
p is prime, g a generator of ℤp * , x 
an element of ℤp * , y the discrete 
logarithm of x. 
Figure 3.4 
In the remaining of this document, we are only considering the case of a finite group G. In particular, the set S  may also  be  taken to  be  finite  and we may even assume ∣S ∣ ≤ ∣G∣. Consequently, we can formulate  the problem in terms of circuits: we encode the elements of the two sets with at most n = ⌈log∣G∣⌉ bits and hence f 
can be viewed as a function f : ℤ2 n → ℤ2 
n  and represented by a quantum logic gate Uf . A naive algorithm for the hidden subgroup problem is the following: 
compute s0 = f (0)1. compute f (g) for all g ∈ G and return those for which f (g) = s0 i.e. the elements of H .2. 
The runtime complexity of this algorithm is O(∣G∣comp( f )) so at least O(exp(n)). This is really bad compared with the efficient quantum algorithms previously seen. For instance Shor's algorithm run in poly(log N) = poly(n) 
i.e. exponentially faster. Hence we are lead to the following definition: 
Definition 3.5 (efficient) 
An  algorithm for  the  hidden  subgroup  problem is  said  to  be  efficient iff it returns a  generating  set of elements of H  using a complexity polynomial in n = ⌈log ∣G∣⌉. ◇ 
12
In particular, we have the following requirements for an efficient solution: 
f  has a polynomial complexity.1. f  is called a polynomial number of times.2. the set generating H  has a polynomial size.3. 
Note that not all  functions f : ℤ2 n → ℤ2 
n  have a polynomial complexity, as indicated in exercise 3.16 of 
[NieChu2007]. The idea is that there are (2n)(2 n) such functions so one can note encode all of them using only a polynomial number of elementary gates. As a consequence, f  has to be chosen carefully to satisfy the first property. 
The argument given in appendix A.2.1.1 of [NieChu2007] shows that there is a set of size at most log(∣H ∣) 
≤ log(∣G∣) that generates H . Actually, for any group K, if we pick uniformly at random t + log(∣K ∣) elements of K 
(for  some  integer  t ≥ 0)  then  the  set obtained  generates K  with  probability  ≥ 1 − 2− t  (see  Appendix  D  of [Lom2004]). 
Ettinger, Høyer and Knill [EttHøyKni1999] proved that the second requirement can always be satisfied i.e. only a polynomial number of calls to f  is needed to identify H . The idea is to prepare the state 
1 
∣G∣m√ ∑ g1, …,gm ∈G 
∣g1, …, gm⟩∣ f (g1), …, f (gm)⟩ (3.15) 
and measure the second register to get a tensor product of m coset states (see definition 4.8). Then they apply measurements for each g ∈ G, that check whether g ∈ H . They prove that the  answers given by the algorithm are correct with high probability for some m = O(n). However, the whole algorithm is not poly(n) since we test ∣G∣ = Ω(exp(n)) elements. 
Example 3.6 
In  Simon's problem an efficient algorithm means a  poly(n)  (i.e. the  number of bits in  the  strings x, s...) 
complexity and n = log( ∣ ℤ2 n ∣ ). Here, we measure the complexity using the numbers of queries to the oracle 
rather than elementary operations (because f  may not be computed efficiently per comment above). 
In Shor's algorithm and the discrete logarithm problem, it means polynomial in the number of bits needed to encode the numbers we work on, i.e. ⌈log(N)⌉ and ⌈log(p)⌉ respectively. f  uses basic operations on such 
numbers so has a polynomial complexity. The sizes of the groups we work with are N  and (p − 1)2 respectively, so their logG's are equivalent to the values we previously used to measure efficiency. 
In all cases, there is only one generator to the group H , namely s, r and (y, − 1). ▱ 
In the particular examples of previous sections, there are natural encoding of the elements and algorithm to compute the product of two elements. For instance, for the cyclic HSP G = ℤN  the elements are encoded as binary number of length ⌈log(N)⌉ and there are well-known algorithms of complexity polynomial in ⌈log(N)⌉ for the group operations. To study the general HSP, it is often useful to see the group G as a black-box where the 
13
operations are performed by a group oracle. As in the case of the HSP oracle computing f , replacing the group oracles by polynomial-time operations yields an efficient algorithm. 
Definition 3.7 (black-box group, unique encoding, encoding length, input size) 
Let n = O(log(N)) and m ≥ 0. n is called the encoding length and mn the input size. A black-box group with unique encoding has the following properties: 
G is given by generators g1, …, gm.1. there are oracles to perform multiplication and inversion.2. each element can be represented by a binary string of length n.3. the previous representation is unique.4. 
For a black-box group without unique encoding  we replace the point 4 by an oracle performing identity testing (hence equality). ◇ 
14
4. The "Standard Method" for The Hidden Subgroup Problem 
4.1. The Abelian Hidden Subgroup Problem 
This section deals with the abelian HSP and is mostly based on [Dam2001]. We just give the big picture of the general method and show how it generalizes the three previous examples. A more detailed presentation is given in [Lom2004]. 
In the previous chapter, we have seen three efficient quantum algorithms that fit into the framework of the hidden subgroup problem. Actually, these problems are also sharing the same kind of algorithm. First, they are all  based  on  a  particular  case  of HSP where  the  group  is  abelian. As  it  is  well-known, such  a  group  is isomorphic to a product of cyclic groups ℤt1 
×ℤt2 ×ℤt3 
×…×ℤtk  and this is clearly the case in the three previous 
algorithms. We can then describe the quantum circuit in a general way: 
0|| ⟩ 
Uf 
0|| ⟩ 0|| ⟩… 0|| ⟩ Ft1 ⊗Ft2 … ⊗Ftk 
Ft1 ⊗Ft2 … ⊗Ftk 
Figure 4.1 
The first register is composed of a product of k  states of ⌈log(ti)⌉  qubits and we apply to this register the operation FG = Ft1 ⊗Ft2 … ⊗Ftk  i.e. the Fourier transform Fti  to the i-th state (note that for Simon's problem, H = 
F2 ). First, let's consider the effect of FG on any element g ∈ G: 
FG∣g⟩ = FG(⊗i = 1 
k ∣gi⟩) 
= ⊗i = 1 
k 
(Fti ∣gi⟩) 
= ⊗i = 1 
k ⎛ 
⎝ 
⎜ ⎜ 
1 
ti√ ∑ gi ′= 0 
ti − 1 
ⅇ 
2ⅈπgigi ′ 
ti ∣gi′⟩ 
⎞ 
⎠ 
⎟ ⎟ 
= 1 
∏ i = 1 
k ti√ 
∑ g ′∈G 
( ∏ i = 1 
k 
ⅇ 
2ⅈπgigi ′ 
ti 
)(⊗i = 1 
k ∣gi′⟩) 
= 1 
∣G∣√ ∑ g ′∈G 
χg(g′)∣g′⟩ 
(4.1) 
Where we have introduced the characters χg(g′). Note that g ↦ χg is a group homomorphism i.e. χg+g ' = χg 
χg ' .  We  also  have  χg(g′) = χg ' (g)  and  so  χg(g′ + g′′) = χg(g′) χg(g′′).  Hence  we  can  define  the  group  H ⊥ = 
15
g ∈ G χg(H ) = 1{ }|| . By Theorem 3.10 of [Lom2004], H ⊥  is isomorphic to G H  and moreover (H ⊥ 
) ⊥ 
= H . 
As we have already seen many times, the state after the gate Uf  is the following superposition: 
1 
∣G∣√ ∑ g ∈G 
∣g⟩∣ f (g)⟩ where ∣g⟩ = ∣g1⟩… ∣ gk⟩ (4.2) 
Measuring the second register gives a value y = f (g 0 ) and leaves the first register in the state 
1 
∣H ∣√ ∑ h ∈ H 
∣g0 + h⟩ (4.3) 
Then we apply the Fourier transform FG. Using the expression of formula 4.1 and the properties of the characters, we get 
FG ( 
1 
∣H ∣√ ∑ h ∈ H 
∣g0 + h⟩ ) 
= 1 
∣H ∣√ ∑ h ∈ H 
(FG∣g0 + h⟩) 
= 1 
∣H ∣∣G∣√ ∑ h ∈ H 
∑ g ∈G 
χ (g 
0 +h) (g)∣g⟩ 
= 1 
∣H ∣∣G∣√ ∑ h ∈ H 
∑ g ∈G 
χg(g0) χg(h)∣g⟩ 
= 1 
∣H ∣∣G∣√ ∑ g ∈G 
( χg(g0) ∑ 
h ∈ H 
χg(h) ) 
∣g⟩ 
(4.4) 
If we measure the first register, the probability to get an element of H ⊥  is: 
1 
∣H ∣∣G∣ ∑ g ∈ H ⊥ 
∣ 
∣ 
∣ ∣ χg(g0) ∑ 
h ∈ H 
χg(h) ∣ 
∣ 
∣ ∣ 
2 
= 1 
∣H ∣∣G∣ ∑ g ∈ H ⊥ 
( ∣ χg(g0)∣ 
2 ∣ 
∣ 
∣ ∣ ∑ h ∈ H 
1 ∣ 
∣ 
∣ ∣ 
2 
) 
= 1 
∣H ∣∣G∣ ∑ g ∈ H ⊥ 
(12∣H ∣2 ) 
= ∣∣H 
⊥ ∣∣∣H ∣2 
∣H ∣∣G∣ 
= ∣G∣∣H ∣2 
∣H ∣2∣G∣ 
= 1 
(4.5) 
Moreover,  the  previous  calculation  shows  that  each  element  of  H ⊥  has  the  same  probability  to  be 
measured. Hence, measuring  the  first  register  yields  a  uniformly  random element of  H ⊥ .  Repeating  the 
previous circuit about n = ⌈log ∣G∣⌉ times gives with high probability a set of generators g1, …, gO(n)  of H ⊥ . We 
16
have h ∈ H = (H ⊥ 
) ⊥  iff for all j, χh(g 
j ) = 1 = ∏ 
i = 1 
k ⅇ 
2ⅈ πhig i 
j 
ti . If we denote e the lower common multiple of the ti's 
and α i 
g j = eg 
i 
j 
ti , h ∈ H  iff ∑ 
i = 1 
k α i 
g j hi ≡ 0 mod (e). We can put this system in Smith normal form (i.e. write as a 
diagonal system) in time polynomial of n. Then get O(n) linear congruences i.e. of the form ax ≡ b mod (e). The method to enumerate the list of solution to a linear congruence is well-known. We randomly pick one solution to each linear congruence to get a uniformly random element of H . Repeating this about n times gives with high probability a set of generators of H . 
As previously stated, we also need an efficient quantum circuit to compute the Fourier transform FG. Note that such  a  circuit is known for F2 x  and  an  approximate  one  (i.e. measuring  the  result gives a  probability distribution very close to the exact version) for other Fx 's. See for instance [Lom2004]. This allows to have an approximate implementation of FG = Ft1 ⊗Ft2 … ⊗Ftk  that does not change too much the measurement of the 
circuit of figure 4.1. 
As  a  consequence,  we  have  an  efficient  solution  to  the  abelian  HSP  if  we  know  a  decomposition ℤt1 
×ℤt2 ×ℤt3 
×…×ℤtk  of G. Otherwise, we  can  get it if we  are  working  in  the  black-box model  with  unique 
encoding. We  describe  the  idea  of [CheMos2001], without trying  to  optimize  the  computation. We choose randomly k ' = O(n) elements a1, …, ak '  of G, so that they generate the group with high probability. Then we 
define f : ℤ∣G ∣ k ' → G by f (x) = ∑ 
i = 1 
k ' xiai. Each term xiai is computed using O(log xi) = O(log∣G∣) = poly(n) sums (by 
a double-and-add algorithm), so f  has a polynomial complexity. ℤ∣G ∣ k '  is abelian and we know its decomposition 
so we can apply the HSP algorithm to find a set of generators for the hidden subgroup H = Ker f . Alternatively, these generators can be obtained using the algorithm of [BucNei1996]. It can be shown that from this set of 
generators we can find (classically) in poly(n) a set of generators u1 ̅,̅ …, uk ̅̅ of ℤ ∣G∣ k ' 
H  that satisfies: 
ℤ∣G ∣ k ' 
H = ⟨u1 ̅̅⟩ ⊕ … ⊕ ⟨uk ̅̅⟩ (4.6) 
Using the isomorphism G ≅ ℤ 
∣G∣ k ' 
H , we get G = ⟨v1⟩ ⊕ … ⊕ ⟨vk⟩ where vi = f (ui). We define an abelian HSP 
by fi : ℤ∣G ∣ → G and fi(x) = xvi (again, f  has a poly(n) complexity). As in Shor's algorithm, the hidden subgroup 
is ti ℤ∣G ∣ where ti is the order of vi. Finally, we get G ≅ ℤt1 ×ℤt2 
×ℤt3 ×…×ℤtk 
. 
4.2. Fourier Transform over Finite Groups 
In  order  to  generalize  the  previous  algorithm  to  any  finite  group,  we  need  a  way  to  define  Fourier Transform. First, we give a brief overview of representation theory of groups, based on [Ser1971]. 
Definition 4.1 (representation) 
A representation  of a  group  G  is a  group  homomorphism ρ : G → GL(V )  where  GL(V )  is the  group of automorphisms over a  finite  dimensional  vector space  V . The  dimension  dρ  of the  representation  ρ  is  the dimension of V . A subspace W ⊆ V  is invariant iff ∀ g ∈ G, ρ(g)(W) ⊆ W . If the only invariant subspaces are {0} 
and V , we say that ρ is irreducible. Two representations ρ : G → GL(Vρ) and τ : G → GL(Vτ ) of G are equivalent 
or  isomorphic  iff  there  is  an  isomorphism ψ : Vρ → Vτ  such  that τ(g) = ψ ∘ ρ(g) ∘ψ −1  for  any  g ∈ G.  Given  a 
17
representation ρ, we define the character χρ by χρ(g) = tr(ρ(g)). ◇ 
In  [Ser1971],  it  is  shown  that  any  finite  group  G  has  only  a  finite  number  of  irreducible  pairwise 
non-isomorphic representations. More precisely, if we denote Ĝ  a complete set of such representations and Vρ and dρ  the associated vector space and dimension (for any ρ ∈ Ĝ), we have the following equality from 2.4 Décomposition de la représentation régulière - Corollaire 2: 
1 
∣G∣ ∑ ρ ∈ Ĝ 
dρ χρ(g) = δg , 1 (4.7) 
In particular for g = 1, because χρ(1) = tr( Idρ) = dρ, we have: 
∣G∣ = ∑ ρ ∈ Ĝ 
dρ 2 (4.8) 
For each ρ, we can choose a basis of Vρ and then ρ(g) is represented by a matrix of size dρ. Again, in view 
of formula 4.8, we can group all  the coefficients (ρi j (g))1≤ i, j ≤ dρ ,g ∈G  in a square matrix of dimension ∣G∣. To 
make this matrix unitary, we add the requirement that each ρ(g) is unitary. We will see that it is always possible to choose the basis such that this requirement is satisfied. Once such a basis is chosen and when no confusion is possible, we will also denote ρ(g) the matrix representation of ρ(g) in this basis. 
Definition 4.2 (general Fourier Transform) 
Let G be a group and Ĝ  a complete set of pairwise non-isomorphic representations ρ : G → GL(Vρ) of size dρ.  For  any  ρ,  we  fix  a  basis  of  Vρ  such  that  for  each  g ∈ G  we  have  a  unitary  matrix  representation 
(ρi j (g))1≤ i, j ≤ dρ  of ρ(g). Then the Fourier Transform over G in the given basis is defined as a linear operation 
over  a  Hilbert  space  of  dimension∣G∣.  More  precisely,  if  we  denote  the  canonical  basis  either  by  group elements (∣g⟩g ∈G ) or by representations/coordinates (∣ρi j⟩ρ ∈ Ĝ , 1≤ i, j ≤ dρ 
), we have: 
∀ g ∈ G, FG∣g⟩ = 1 
∣G∣√ ∑ ρ ∈ Ĝ 
dρ√ ∑ i, j = 1 
dρ 
ρi j (g)∣ρi j⟩ (4.9) 
or, if Ĝ = {ρ1, ⋯, ρM} and dk = dρk , by the images of basis vectors: 
18
FG∣g⟩ = 1 
∣G∣√ 
d1√ (ρ11 1 (g)) 
d1√ (ρ12 1 (g)) 
⋮ 
d1√ (ρ1d1 
1 (g)) 
d1√ (ρ21 1 (g)) 
⋮ 
d1√ (ρ2d1 
1 (g)) 
⋮ 
d1√ (ρd1d1 
1 (g)) 
d2√ (ρ11 2 (g)) 
⋮ 
dM√ (ρdMdM 
M (g)) 
⎛ 
⎝ 
⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ 
(4.10) 
◇ 
Proposition 4.3 (Fourier Transform is unitary) 
FG is a unitary transform i.e. the columns (FG∣g⟩)g ∈G  of FG form an orthonormal family. 
proof: We have χρ((g′) −1g) = tr(ρ(g ')−1ρ(g)) = tr(ρ(g ')†ρ(g)) = ⟨ρ(g '), ρ(g)⟩F = ∑i, j = 1 
dρ (ρi j (g′)) 
* (ρi j (g)). 
So the hermitian product of two such columns FG∣g '⟩ and FG∣g⟩ is exactly: 
(FG∣g′⟩)†(FG∣g⟩) = 1 
∣G∣ ∑ ρ ∈ Ĝ 
dρ ∑ i, j = 1 
dρ 
(ρi j (g′)) * (ρi j (g)) = 
1 
∣G∣ ∑ ρ ∈ Ĝ 
dρ χρ((g′) −1g) (4.11) 
and we conclude with formula 4.7. □ 
Proposition 4.4 (representations are unitarizable) 
For each ρ ∈ Ĝ , there is a basis ( fi ρ )1≤ i ≤ dρ 
 of Vρ such that every ρ(g) is unitary. 
proof:  Let (ei ρ )1≤ i ≤ dρ 
 be  an  arbitrary  basis  of Vρ.  We  have  the  canonical  hermitian  product given  by 
⟨ ∑i = 1 
dρ aiei 
ρ , ∑i = 1 
dρ biei 
ρ 
⟩ = ∑i = 1 
dρ a i *bi. We define ⟨a, b⟩G = ∑ 
g ∈G ⟨ρ(g)(a), ρ(g)(b)⟩  which is still  a  inner product 
because  ρ(g)  is  an  automorphism.  Using  Gram-Schmidt  process,  we  construct  a  new  basis  f 1 
ρ , …, f 
dρ 
ρ 
orthonormal  for  ⟨., .⟩G  in  which  we  express  ρ(g).  On  the  one  hand,  we  have  by  construction  ⟨a, b⟩G  = 
19
⟨ρ(g)(a), ρ(g)(b)⟩G  and  in  particular  ⟨ρ(g)( fi ρ ), ρ(g)( fj 
ρ )⟩G 
= ⟨( fi ρ ), ( fj 
ρ )⟩G 
.  On  the  other  hand, 
ρ(g)( fj ρ ) = ∑k= 1 
dρ ρk j (g) f 
k 
ρ and hence ⟨ρ(g)( fi ρ ), ρ(g)( fj 
ρ )⟩G 
= ∑k= 1 
dρ ρ k, i * (g)ρk, j (g). Finally we have: 
ρ(g)†ρ(g) = ( ∑ 
k= 0 
dρ 
ρk, i * (g)ρk, j (g) 
) 1≤ i, j ≤ dρ 
= (⟨ρ(g)( fi ρ ), ρ(g)( fj 
ρ )⟩G) 
1≤ i, j ≤ dρ 
= (⟨( fi ρ ), ( fj 
ρ )⟩G) 
1≤ i, j ≤ dρ 
= (δi, j)1≤ i, j ≤ dρ 
= Idρ 
(4.12) 
□ 
Let's see how the previous definition generalizes the abelian case: 
Example 4.5 (Abelian Fourier Transform) 
Suppose  G  is  abelian  and  define  for  all  g ∈ G  the  1-dimensional  (i.e.  dρg = 1)  representation  ρg : 
G → GL(ℂ1 ) ≅ ℂ*  by  ρg(h) = χg(h)  where  χg  is  the  character  defined  in  the  previous  chapter.  The 
representations are clearly unitary. Note that χρg (h) = χg(h) so the definition of the character is consistent with 
what we have seen earlier. Suppose that two representations ρ(g) and ρ(g ') are isomorphic. This means that 
there is a λ ≠ 0 such that ρg(h) = λρg ' (h)λ−1 = ρg ' (h) for all h ∈ G. With the notation of previous chapter, we have 
ρg 
ρg ' 
(h) = 1 = 
⎛ 
⎝ 
⎜ ⎜ ∏ i = 1 
k 
ⅇ 
2ⅈπ(gi −gi ')hi ti 
⎞ 
⎠ 
⎟ ⎟ 
(4.13) 
For j going from 1 to k, we evaluate the equality at h = hj = (δi, j)1≤ i ≤ k  we get gj − gj ' = 0 and finally g = g '. 
So Ĝ = ρ(g) g ∈ G{ }||  is a set of pairwise non-isomorphic 1-dimensional representations. It is complete since it 
satisfies the equality of formula 4.8. Using the identification ∣g⟩ ≅ ∣ρg11⟩, and (ρg)11 (h) = χg(h) we recover the 
definition of the abelian Fourier Transform. ▱ 
Remark 4.6 (irreducible representations of non-abelian groups) 
In  3.1  Sous-groupes  commutatifs  -  Théorème  9  of  [Ser1971],  it  is  shown  that  G  is  abelian  iff  all  its irreducible representations are 1-dimensional. So in the nonabelian case, we will always have to deal with at least one representation of dimension greater than 1. △ 
The proposition 4.4 above shows that there is at least one basis of Vρ. Actually, we obtain all of them by 
20
unitary change of basis: 
Proposition 4.7 
Let τ  be an irreducible representation of G and let τ(g) denote an unitary matrix representation. Then the possible unitary matrix representations of all other isomorphic representations ρ are given by ∀ g ∈ G, ρ(g) = U 
τ(g)U † for any unitary matrix U . 
proof: First, it is  clear that given  a  unitary matrix, then  ρ(g) = Uτ(g)U †  is  still  unitary and  is the  matrix representation of ρ = τ  obtained using U  as a change-of-basis matrix. Conversely, suppose ρ is isomorphic to τ  and  let  ρ(g)  denote  an  unitary  matrix  representation.  Then  there  is  an  invertible  matrix  M  (the  matrix 
representation of an isomorphism between τ , ρ in their respective basis) such that ∀ g ∈ Gρ(g) = Mτ(g)M−1. This gives: 
I = ρ(g)†ρ(g) = (Mτ(g)M −1 ) 
† 
(Mτ(g)M −1 ) = (M 
† ) 
−1 τ(g) −1M †Mτ(g)M −1 (4.14) 
and finally τ(g)M †M = M †Mτ(g) for any g ∈ G. Since τ  is irreducible, the Schur's lemma (see Le lemme de 
Schur ; premières applications -  Proposition  4  of [Ser1971])  implies that M †M = λ I  for  some  λ ∈ ℂ. More 
precisely, λ = 1 dτ 
tr(M †M) = 1 
dτ ‖M‖F 
2 ∈ ℝ+ * . We conclude the proof by taking U = 1 
λ√ M  . □ 
In this section, we have defined an operation FG  for any given group. We know that it is unitary so a valid quantum. However, if we want to to use it in a HSP algorithm, we need to implement it efficiently i.e. using poly(n) elementary gates. As mentioned above, there is an approximate efficient implementation of FN  for cyclic group. By taking the tensor product of such operations, we get an approximate efficient implementation for any abelian group G. Other efficient implementations are known for various groups, see [Lom2004] for an overview. The  exact  description  of  the  quantum  gate  FG  depends  on  the  design  used  for  the  implementation. Nevertheless, we will suppose in what follows that the gate implementing FG  works on n qubits. The input ∣g⟩ 
and output ∣ρi j⟩ are encoded by the integers 0, …, ∣G∣ − 1. The possible remaining basis states are not touched by the gate. 
4.3. Weak and Strong Fourier Sampling 
For the generalized version of the Fourier Sampling circuit, we replace the first Fourier Transform by a gate V  that computes a superposition 1 
∣G ∣√ ∑ 
g ∈G ∣g⟩ from the ∣0n⟩ state. There is no canonical implementation for V 
but if the elements of G are encoded by the integer 0, …, ∣G∣ − 1 (as we have assumed in previous section) we can use the following circuit: 
0n|| ⟩ 
0|| ⟩ Ug 
H⊗n 
Figure 4.2 
21
We use a hadamard gate to create a superposition over 0, …, 2n − 1 and a function g to select the values less than ∣G∣: g(i) = 1 if 0 ≤ i < ∣G∣ and g(i) = 0 otherwise (It can be implemented efficiently, just by comparing the binary decomposition of i and ∣G∣). We succeed to create the superposition if the result of the measurement 
is 1. We have 2n− 1 < ∣G∣ ≤ 2n, so this happens with probability ∣G ∣ 
2 n > 1 
2 . 
The remaining of the circuit is similar to what we have previously seen, with the use of a general Fourier Transform gate FG: 
0n|| ⟩ 
0n|| ⟩ Uf 
V FG 
Figure 4.3 
After applying the gate Uf  we have the superposition 
1 
∣G∣√ ∑ g ∈G 
∣g⟩∣ f (g)⟩ (4.15) 
We then measure the second register and get y = f (g 0 ). We obtain a superposition on a coset g0H : 
1 
∣H ∣√ ∑ h ∈ H 
∣g0h⟩ (4.16) 
Creating this superposition is the starting point for all HSP algorithms currently known. Hence we define: 
Definition 4.8 (coset sampling, the "standard method", coset state) 
Coset sampling also known as the "standard method" for HSP consists in creating many states given by formula 4.16, where g0 ∈ G is chosen uniformly at random. These states are called coset states. ◇ 
For Fourier Sampling, the next step is to apply the Fourier Transform FG. This gives the state 
∑ ρ ∈ G 
̂^ ∑ i, j = 1 
dρ dρ 
∣G∣√ ( 
1 
∣H ∣√ ∑ h ∈ H 
ρ(g0h) ) 
i j 
∣ρi j⟩ = ∑ ρ ∈ Ĝ 
∑ i, j = 1 
dρ dρ 
∣G∣√ (ρ(g0H ))i j ∣ρi j⟩ (4.17) 
where  we have  introduced ρ(g0H ) = 1 
∣H ∣√ ∑ 
h ∈ H ρ(g0h). Finally, we perform a  measurement on  the  first 
register. 
Definition 4.9 (Fourier Sampling Algorithm) 
The Fourier Sampling algorithm for the HSP consists in running the circuit of figure 4.3 several times and 
22
trying to deduce information on the hidden subgroup H . We distinguish two forms of Fourier Sampling: 
In the Weak Fourier Sampling  for the HSP, we observe a representation ρ ∈ Ĝ  with probability P(ρ) = 
∑i, j = 0 
dρ P(ρ, i, j) 
In  the  Strong  Fourier  Sampling,  we  observe  a  representation  ρ ∈ Ĝ  as  well  as  coordinates i, j  with probability P(ρ, i, j). 
What is the distribution probability? First the conditional probability given g0 is P( ρ , i, j 
g 0 ) = dρ 
∣G ∣ ∣∣ρ(g0H )∣∣i j 
2. 
Hence for the Weak Fourier Sampling, we have P( ρ 
g 0 ) = ∑i, j = 1 
dρ P( ρ , i, j 
g 0 ) = dρ 
∣G ∣ ‖‖ρ(g0H )‖‖F 
2  and using ρ(g 0H) 
= ρ(g 0 )ρ(H ) and the fact that ρ(g 
0 ) is unitary: 
P(ρ) = dρ 
∣G∣ ‖ρ(H )‖F 
2 (4.18) 
It  was  proven  in  [GriSchVaz2000]  that  ρ(H )  is  ∣H ∣√  times  a  projection  matrix  P.  Moreover,  ρ(H )  is hermitian: 
ρ(H )† = 1 
∣H ∣√ ∑ h ∈ H 
ρ(h)† = 1 
∣H ∣√ ∑ h ∈ H 
ρ(h−1) = 1 
∣H ∣√ ∑ h ' ∈ H 
ρ(h ') = ρ(H ) (4.19) 
Hence 1 ∣H ∣ 
‖ρ(H )‖F 2 = tr(P 
†P) = tr(P 2 ) = tr(P) = 1 
∣H ∣√ tr(ρ(H )) and formula 4.18 can be rewritten: 
P(ρ) = dρ 
∣G∣ ∣H ∣√ tr(ρ(H )) (4.20) 
In particular, this probability does not depend on the choice of the basis of Vρ! 
For the Strong Fourier Sampling, we first note that the ∣G∣-dimensional vectors (ρ(g0)ik)g 0 ∈G  for 1 ≤ k ≤ dρ 
are orthogonal of norm ∣G ∣ 
dρ√ : 
⟨(ρ(g 0 )ik)g 0 ∈G 
, (ρ(g 0 )ik′)g 0 ∈G⟩ = ∑ 
g 0 ∈G 
ρ(g 0 )ik 
* ρ(g 
0 )ik′ 
= ∑ g 0 ∈G 
ρ((g 0 ) 
−1 
) ki ρ(g 
0 )ik′ 
= ∣G∣ 
dρ δkk′δii 
(4.21) 
where the last line is 2.2 Le lemme de Schur ; premières applications - Corollaire 3 of [Ser1971]. We use this fact to simplify the expression of P(ρ, i, j) as described in [GriSchVaz2000]. Because g0  has been chosen uniformly it is the mean of P( 
ρ , i, j g 0 ) over the elements of the group G: 
23
P(ρ, i, j) = dρ 
∣G∣2 ∑ g 0 ∈G 
∣∣ρ(g0H )i j ∣∣ 2 
= dρ 
∣G∣2 ∥ ∥(ρ(g0H )i j)g 0 ∈G 
∥ ∥ 
2 
= dρ 
∣G∣2 
∥ 
∥∥((ρ(g0)ρ(H ))i j)g 0 ∈G 
∥ 
∥∥ 
2 
= dρ 
∣G∣2 
∥ 
∥ 
∥ ∥ ∥( ∑ 
k= 0 
dρ 
ρ(g0)ik ρ(H )k j) g 0 ∈G 
∥ 
∥ 
∥ ∥ ∥ 
2 
= dρ 
∣G∣2 
∥ 
∥ 
∥ ∥ ∑ k= 0 
dρ 
ρ(H )k j(ρ(g0)ik)g 0 ∈G 
∥ 
∥ 
∥ ∥ 
2 
= dρ 
∣G∣2 ∑ k= 0 
dρ ⎛ 
⎝ ⎜∣∣ρ(H )k j ∣∣ 
2 ∣G∣ 
dρ 
⎞ 
⎠ ⎟ 
= 1 
∣G∣ ∥∥ρ(H )j∥∥ 
2 
(4.22) 
and we finally obtain an expression which is totally independent of i: 
P(ρ, i, j) = 1 
∣G∣ ∥∥ρ(H )j 
∥∥ 2 
P(ρ, ., j) = dρ 
∣G∣ ∥∥ρ(H )j∥∥ 
2 
(4.23) 
This means that measuring  the  row provides no  information  and  the  Strong  Fourier Sampling  can  be reduced to observing ρ, j. Note that summing over all the j, we recover formula 4.18. 
Remark 4.10 (measurement of f (g 0 )) 
As in the abelian case, the measurement of y = f (g 0 ) is only used to produce a superposition over one 
coset. As noted in [GriSchVaz2000], we may discard information by not using this value later. For example, just 
counting the number of distinct values after many samplings gives an indication on ∣G ∣ 
∣H ∣  so on the size of the 
hidden subgroup H . In particular, it is easy to determine whether H  is a proper subgroup of G  (i.e. the ratio above is at least 2) by repeating several measurements until we find two distinct values or get k times the same value. In the former case we know with certainty that H  is a proper subgroup of G and in the latter case we 
know that H = G with probability at least 1 − 2−k. For completeness, we give the distribution probability. If x1, … 
, x ∣G∣ ∣H ∣  is a  complete  set of coset representatives, P(ρ, i, j, f (xk)) = ∑ 
g 0 ∈G P(xk)P(g0 / f (x k))P(ρ, i, j /g0) = 
∑ h ∈ H 
∣H ∣ 
∣G ∣ 1 
∣H ∣ 
dρ 
∣G ∣ ∣∣(ρ(xkhH ))i j ∣∣ 
2  and finally 
24
P(ρ, i, j, f (xk)) = dρ ∣H ∣ 
∣G∣2 ∣∣(ρ(xkH ))i j ∣∣ 
2 (4.24) 
It seems difficult to construct an algorithm from these values since we do not know the xk  corresponding to the measured value f (xk). △ 
As  said  in  remark  4.6,  all  the  irreducible  representations  are  1-dimensional  in  the  abelian  case. Consequently, the  Strong Fourier Sampling  is the  same as the  Weak Fourier Sampling: we only take  into account the irreducible representations ρgj  measured. More precisely, we measure random elements g1, …, 
gO(n)  in H ⊥ = g ∈ G χg(H ) = 1{ }| | = g ∈ G H ⊆ Ker ρg{ }| 
| . Then we solve the systems of equations χg j (h) = χh(g j ) 
= 1 to get elements h in H . Said otherwise, we are looking to random elements in H = ⋂ j = 1 
O(n) Ker ρgj 
. In the next 
section, we will see that more generally, considering the intersection of irreducible representations measured gives information on H  and allows to solve the HSP in some particular cases. 
4.4. The Dedekindian Hidden Subgroup Problem and its extensions 
In this section, we see how the Weak Fourier Sampling can be used to extend the abelian HSP. The idea 
is  to  measure  ρ1, …, ρO(n)  irreducible  representations  and  to  consider  the  intersection  ⋂ j = 1 
O(n) Ker ρj.  Let's 
consider first what is happening in an example: 
Example 4.11 (Fourier Sampling on the dihedral group D4) 
The dihedral group D4 is the group of isometries of the plane generated by the reflection s about the x-axis 
and the rotation r of 90°. It is composed of 4 rotations rk  and 4 reflections rks (for 0 ≤ k ≤ 3). It satisfies r4 = s2 
= srsr = Id. A set of complete irreducible representations is given by the table of figure 4.4 (adapted from 5.3 Le groupe diédral Dn of [Ser1971]): 
ρ ρ(r k ) ρ(r 
ks) Ker ρ 
a 1 1 D4 
b 1 -1 {Id, r, r2, r3} 
c (−1)k (−1)k {Id, r2, s, sr2} 
d (−1)k (−1)k+ 1 {Id, r2, sr, sr3} 
e ( − ⅈ)k 0 
0 ⅈk 
⎛ 
⎝ 
⎜ ⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ ⎟ 
0 ( − ⅈ)k 
ⅈk 0 
⎛ 
⎝ 
⎜ ⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ ⎟ 
{Id} 
Figure 4.4 
25
We are considering two hidden subgroups H1 = {1, rs} and H2 = {1, r2}. Using formula 4.20 and formula 4.23, it is easy to get: 
H = H1 H = H2 
ρ ρ(H ) P(ρ) ρ(H ) P(ρ) 
a 2√ 1 4 2√ 1 
4 
b 0 0 2√ 1 4 
c 0 0 2√ 1 4 
d 2√ 1 4 2√ 1 
4 
e 1 
2√ 
1 −ⅈ 
ⅈ 1 
⎛ 
⎝ 
⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ 
1 2 
0 0 
0 0 
⎛ 
⎝ 
⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ 0 
Figure 4.5 
and the probability distribution observed by a Strong Fourier Sampling is: 
P(a, ., 1) P(b, ., 1) P(c, ., 1) P(d , ., 1) P(e, ., 1) P(e, ., 2) 
H1 1 4 0 0 1 
4 1 4 
1 4 
H2 1 4 
1 4 
1 4 
1 4 0 0 
Figure 4.6 
Suppose  we  repeat  enough  time  the  Weak  Fourier  Sampling.  For  H = H1,  we  will  measure  the representations  a, d , e.  The  intersection  of  their  kernels  is  {Id} ≠ H .  For  H = H2,  we  will  measure  the 
representations a, b, c, d. The intersection of their kernels is {Id, r2} = H . ▱ 
Consequently, the direct application of the abelian method does not always work. Note that H2 is normal (it 
is  the  of  center  D4)  but  H1  is  not  (for  example  s(rs)s−1 = sr = r3s ∉ H1).  In  general,  tr(ρ(g−1Hg)) = tr 
(ρ(g)−1ρ(H )ρ(g)) = tr(ρ(H )) so by formula 4.20, the Weak Fourier Sampling can not distinguish H  with one of 
its  conjugate  g−1Hg.  However, we  can  still  hope  that it  will  work  for  a  normal  subgroup  H .  This  is  what Hallgren, Russel and Ta-Shma proved in [HalRusTa-2000]: 
26
Theorem 4.12 (Normal Hidden Subgroup) 
Let ρ1, …, ρs  be s = c log(∣G∣) samples of Weak Fourier Sampling for a normal hidden subgroup H . We have 
P ( H = 
⋂ i 
Ker ρi) ≥ 1 − ⅇ 
− (c− 2)2 
2c log(∣G ∣) 
(4.25) 
□ 
As a consequence, we can use this to solve the Dedekindian Hidden Subgroup Problem i.e. over groups that have only normal subgroups. Of course, this includes the Abelian HSP that we have previously studied. The non-abelian Dedekind groups are called Hamiltonian and they are of the form G = ℤ2 
k×A×ℚ8 where A is an abelian group with all elements of odd order. The appendix B.2 of [HalRusTa-2000] gives a precise algorithm for the Hamiltonian HSP: an efficient implementation of the Weak Fourier Sampling over G and a way to pick O(n) random solutions to the system ρi(h) = Idρi 
 in order to get a set of generators for H . 
By calling several times the Weak Fourier Sampling (possibly over subgroups of G), the Dedekindian HSP can be generalized. However the possibility to compute the Fourier Transform, to solve systems ρi(h) = Idρi 
 and 
to do the same for any of its subgroup involved in the algorithm, depends on the underlying group G. First, as noted in [GriSchVaz2000], running this algorithm for any H  (not necessarily normal) gives with high probability the highest subgroup of H  which is normal in G. We can also solve the case where "almost all" subgroups of G 
are normal i.e. the intersection of normalizers MG is big enough or, equivalently, that ∣G ∣ 
∣∣MG ∣∣  is small. For example 
MG = G  for  an  abelian  group  and  ∣G ∣ 
∣∣MG ∣∣ 
= 1.  In  [GriSchVaz2000],  Grigni  et  al.  presented  an  efficient  HSP 
algorithm when  ∣G ∣ 
∣∣MG ∣∣ 
∈ exp(O( log(log∣G∣)√ )).  They  give  an  application  to  the  semi-direct  product  ℤ3⋊ℤ2 n . 
Gavinsky [Gav2004] strengthened their result to ∣G ∣ 
∣∣MG ∣∣ 
∈ poly(log∣G∣). Actually, he proved that we can even just 
assume ∣G ∣ 
∣∣HMG ∣∣ 
∈ poly(log∣G∣) so that the algorithm still works when H  is large. 
Note  that if the  group is given as a  black-box group without necessarily unique encoding, there  is an alternative  way to  find  the  normal  subgroup  H  as described  in  [IvaMagSan2001]. The  algorithm does not require the assumptions on Fourier Transform and systems above. Its complexity is given by the input size + a number v(G H ) that we will define later. We will come back to this method in the last part of this report. 
27
5. The Dihedral and Symmetric Hidden Subgroup Problems 
5.1. The Dihedral Hidden Subgroup Problem 
For any N ≥ 1, the dihedral group DN  is the group of isometries of the plane generated by the reflection s 
about the x-axis and the rotation r of angle 2π N 
. It is composed of 2N  elements: N  rotations rk  and N  reflections 
rks (0 ≤ k ≤ N − 1) . The elements satisfy the relation rN = s2 = srsr = Id. We have already seen the case N = 4 
in an example of Fourier Sampling. Alternatively, we can describe DN  as a semi-direct product ℤN⋊ℤ2, where 
(a, b)  represents  the  isometry  rasb.  We  have  ra1 s0ra2 sb2 = ra1 +a2 s0 +b2  and  ra1 s1ra2 sb2 = ra1 −a2 (ra2 sra2 )sb2 = 
ra1 −a2 s1+b2 , so the law of this semi-direct product is given by 
(a1, b1)(a2, b2) = (a1 + (−1)b1a2, b1 + b2) (5.1) 
and consequently the inverse operation is 
(a, b)−1 = ((−1)b+ 1a, b) (5.2) 
Definition 5.1 (DHSP) 
The dihedral HSP (DHSP) is the hidden subgroup problem for the dihedral group G = DN ≅ ℤN⋊ℤ2. An efficient algorithm for the dihedral HSP has a complexity poly(log(N)) (this is equivalent to our general definition because log(∣G∣) = log(2N) = 1 + log(N)). ◇ 
DHSP is by itself a natural candidate for finding efficient quantum algorithm based on a nonabelian HSP: on the one hand it is a nonabelian group with a simple structure (so we can hope it is not too difficult to solve) and on the other hand ⟨(d , 1)⟩0 ≤ d ≤ N − 1 is an exponential number of subgroups (so the brute-force guessing is infeasible). We will see another motivation in the next section. 
What are the possible hidden subgroups H? Consider the cyclic subgroup G ' = ℤN×{0} of G. Then H ' = 
G ' ∩ H  is a subgroup of G ' so there is a divisor r  of N  such that H ' = (rℤN )×{0}. If H ' ≠ H  then there exists (d , 1) ∈ H . If (a, 1) is another element of H , then (d , 1)(a, 1) = (d − a, 0) ∈ H '. We have (a, 1) = (d , 1)(d − a, 0) ∈ 
(d , 1)H '. As a consequence, H = H ' ∪ (d , 1)H '. Note that if d = rq + d ' is the euclidean division of d  by r, (d ', 1) 
= (−rq, 0)(d , 1) ∈ H . Replacing d by d ', we can assume 0 ≤ d < r. Finally, we have: 
Proposition 5.2 (subgroups of DN ) 
The subgroups of DN  are: 
Hr = (rℤN )×{0} = {(rl, 0) ∣ 0 ≤ l < N r } for a divisor r of N 
Hr , d = Hr ∪ (d , 1)Hr = {(rl, 0), (d + rl, 1) ∣∣ 0 ≤ l < N r } for a divisor r of N and some 0 ≤ d < r. 
28
Moreover, the dihedral HSP reduces to efficiently find d  when H = Hr , d  and r is known. 
proof:  The  first  part  has  been  discussed  above.  The  value  r  can  be  found  with  high  probability  in O(poly(log N))  by  the  cyclic  HSP algorithm using  the  oracle  f∣G ' .  Hence  we  may assume  that r  is  known. 
Suppose  we have  an  algorithm that finds d  with  high  probability when  H = Hr , d  and  r  is  known. We can suppose that this algorithm always returns a value d0. If f (d0, 1) = f (0, 0) then we return H = Hr , d0 
 otherwise 
we return H = Hr. Because the sub-routines succeed with high probability, so does the whole algorithm. □ 
Can we use the general algorithms based on the Weak Fourier Sampling, that we have previously seen? We  note  that  (a, b)(rl, 0)(a, b)−1 = ((−1)brl, 0)  so  Hr  is  normal.  We  also  have  (a, b)(d + rl, 1)(a, b)−1 = 
(2a + (−1)b(d + rl), 1) so Hr , d  is normal iff for all a, b ∈ ℤN  we have 2a + (−1)bd ≡ d  mod (r) (which is obviously 
true for r being 1 or 2). The case a = 1 and b = 0 shows that r can not be more than 2 if we want this equality to hold. As a consequence, the normal subgroups are H = Hr  (for any divisor r of N), H = H1, 0 = G and (if N  is even)  H = H2, 0  or  H = H2,1.  It  is  easy to  check that they correspond  to  the  intersection  of the  kernels  of representations measured in theorem 9.9 of Appendix B. We notice that MG ⊆ N(HN , 0 ) = {(a, b) ∣ 2a ≡ 0 mod 
(N)} so 1 ≤ ∣MG∣ ≤ 4. As a consequence, ∣G ∣ 
∣∣HMG ∣∣ 
= ∣G ∣∣∣MG ∩H ∣∣ 
∣H ∣∣∣MG ∣∣ 
= 2 N N r 
∣∣MG ∩H ∣∣ 
∣∣MG ∣∣ 
= Θ(r). So Gavinski's HSP algorithm is 
successful iff r = poly(log N). 
Ettinger and Høyer proved in [EttHøy1998] that the dihedral HSP reduces to the case where H = HN ,d = 
⟨(d , 1)⟩ . To see that, suppose we start with the reduced case of the theorem i.e. H = Hr , d  and r is known. The elements of G Hr  are (i, 0)Hr  and (i, 1)Hr  for 0 ≤ i < r  while  the elements of H Hr  are given by Hr, (d , 1)Hr. Hence,  moving  to  the  quotient  group  we  have  the  hidden  subgroup  problem  for  G Hr ≅ Dr  and  hidden subgroup  ⟨(d , 1)⟩.  We  see  that we  have  a  solution  to  the  hidden  subgroup  problem with  complexity  poly 
(log(N), r) (poly(N) to find r and poly(r) to find d  working in Dr). In particular the algorithm is already efficient in the case r = poly(log N) solved by Gavinski's HSP algorithm. We have proved the important reduction: 
Proposition 5.3 (reduction to finding a slope) 
The dihedral HSP reduces to efficiently find the slope d when H = ⟨(d , 1)⟩. □ 
0|| ⟩ 
0|| ⟩ 
0|| ⟩ Uf 
FN ⊗ H FN 
H 
(1) 
(2) 
(3) 
Figure 5.1 
Ettinger and Høyer used the same circuit as in HSP over ℤN×ℤ2  and proved that this yields an algorithm for the dihedral HSP. In this quantum circuit, we distinguish two registers for encoding the elements of DN  and 
29
perform three separate measurements. 
As usual, the first part of the circuit produces a superposition 
∑ a = 0 
N − 1 
∑ b = 0 
1 
∣a⟩∣b⟩∣ f (a, b)⟩ (5.3) 
The first measurement yields a f (a0, b0) and makes the two first registers collapse to 
1 
2√ (∣a0⟩∣b0⟩ + ∣∣a0 + (−1)b0d⟩∣b0 + 1⟩) = 
⎧ 
⎨ 
⎩ 
⎪ ⎪ ⎪ ⎪ ⎪ ⎪ 
1 
2√ (∣a0⟩∣0⟩ + ∣a0 + d⟩∣1⟩) if b0 = 0 
1 
2√ (∣(a0 − d)⟩∣0⟩ + ∣(a0 − d) + d⟩∣1⟩) if b0 = 1 
(5.4) 
since a0 and b0 are chosen uniformly at random, this is equivalent to have a state 
1 
2√ (∣x⟩∣0⟩ + ∣x + d⟩∣1⟩) (5.5) 
for some x ∈ ℤN  chosen uniformly at random. Applying the Fourier transform FN  to the first register gives the state 
1 
2N√ ∑ k= 0 
N − 1 
( ⅇ 
2ⅈπk x N ∣k⟩∣0⟩ + ⅇ 
2ⅈπk( x+d) 
N ∣k⟩∣1⟩ ) 
(5.6) 
The second measurement returns a k ∈ ℤN  chosen uniformly at random and make the second register collapse to the state 
1 
2√ ⅇ 
2ⅈπk x N 
( ∣0⟩ + ⅇ 
2ⅈπkd N ∣1⟩ 
) (5.7) 
Finally, we apply an hadamard gate on the second register to get 
1 
2 ⅇ 
2ⅈπk x N 
( (∣0⟩ + ∣1⟩) + ⅇ 
2ⅈπkd N (∣0⟩ − ∣1⟩) 
) = 
1 
2 ⅇ 
2ⅈπk x N ⅇ 
ⅈπkd N 
(( ⅇ 
ⅈπkd N + ⅇ 
− ⅈπkd N 
) ∣0⟩ + 
( −ⅇ 
ⅈπkd N + ⅇ 
− ⅈπkd N 
) ∣1⟩ 
) 
= ⅇ 2ⅈπk x N 
( cos 
( 
kπd 
N ) ∣0⟩ − isin 
( 
kπd 
N ) ∣1⟩ 
) 
(5.8) 
The measurement given by (2) and (3) is then: 
P(k, j) = 
⎧ 
⎨ 
⎩ 
⎪ ⎪ ⎪ ⎪ ⎪ ⎪ 
1 
N cos2 
( 
kπd 
N ) if j = 0 
1 
N sin2 
( 
kπd 
N ) if j = 1 
(5.9) 
30
The algorithm of Ettinger and Høyer starts by checking the values d = 0 or d = N 2  (just by comparing f (0, 0) 
with  f (0, 1)  and  f ( N 2 , 1)).  Otherwise,  they  show  that  there  is  some  m = O(log N)  such  that  from k1, …, km 
samples  of  the  previous  algorithm  we  can  find  d,  just  by  searching  the  minimum  of  a  function  x ↦ 
g(x, k1, …, km)  over the  domain  {1,2, …, ⎢⎣ N 2 ⎥⎦}. The whole  algorithm allows to  solve  the  dihedral  HSP using 
O(log N) calls to f . However, to find the minimum of the function g we test O(N) elements. 
The state at the output of coset sampling is important since it is the base of all the other DHSP algorithms. Thus we define the following problem, to which DHSP reduces: 
Definition 5.4 (Dihedral Coset Problem) 
Let N ∈ ℕ and d ∈ ℤN . The dihedral coset problem (DCP) is to find the value of d  given a black box that outputs a state given in formula 5.5 for a random x ∈ ℤN . ◇ 
Note that the circuit of figure 5.1 is not the Fourier Sampling based on group representations. Appendix B studies in detail all the possible distribution obtained by this latter method. One of the main results is that the distribution  probability  of formula  5.9  can  be  obtained  from the  output of a  Strong  Fourier  Sampling  in  a particular basis and so Ettinger and Høyer 's algorithm applies. The second important result is that Strong Fourier Sampling  is less general  than DCP, in  the  sense that a  black-box for DCP can simulate  a  Strong Fourier Sampling. This includes the case where we apply Strong Fourier Sampling with any hidden subgroup H  and not only HN ,d . Actually, it is quite remarkable that applying Strong Fourier Sampling on the initial group is essentially the same as applying Strong Fourier Sampling on the quotient group. Some attempts to solve DHSP via Strong Fourier Sampling are given in Appendix C and suggest that this method is not likely to work. Indeed, Fourier Sampling uses only measurement on one coset state at once, while we will see later that we require a polynomial number of them. In appendix G, we propose an entirely new approach, based on uniform superpositions over large subsets of f (DN ). In particular, we can solve the case N = 2n  if we have an efficient 
process to create for b = 0, 1 the states 1 
N ′√ ∑ 
i = 0 
N ′− 1 ∣ f (2i, b)⟩. 
In the next section, we will see in more details the different results obtained for DCP. 
5.2. The Dihedral Coset Problem 
The  next  successful  step  after  Ettinger  and  Høyer  was  the  discovery  by  Kuperberg  [Kup2003]  of  a subexponential-time algorithm to find the slope d  and thus the hidden subgroup. First note that ignoring the phase factor, formula 5.7 allows to generate states: 
∣Ψk⟩ = 1 
2√ ( ∣0⟩ + ⅇ 
2ⅈπkd N ∣1⟩ 
) (5.10) 
We now give a rough description of Kuperberg's algorithm in the particular case N = 2n. In that case, if we 
are able to create ∣∣Ψ2 n−1 ⟩ = 1 
2√ (∣0⟩ + (−1)d∣1⟩)  then a measure in the Hadamard basis gives the parity of d . 
Kuperberg noted that the hidden subgroup is necessarily included in the subgroup H2,0 (if d  is even) or H2,1 (if d is odd). Both  are  isomorphic to  D2 n−1  so  we can restrict to  the  appropriate  subgroup and use an iterative 
algorithm for finding the other digits of d . 
31
Suppose we have two states ∣Ψk⟩ and ∣Ψl⟩. Taking their tensor product, applying a CNOT gate and ignoring the phase factor gives a state ∣Ψk± l⟩ on the first register where ± is randomly determined by the measurement 
of the second register. If both k, l are multiple of 2 i (i.e. have 0's as their i least significant bits) then one of k ± l 
is multiple of 2 i '  for some i ' > i. 
DCP Black Box ∣Ψk⟩ ∣Ψ*****00⟩ ∣Ψ***0000⟩ ∣Ψ*000000⟩ 
... 
Figure 5.2 
The idea of Kuperberg  is to  use a  pipeline  as represented in  figure  5.2. At the  input, many ∣Ψk⟩'s are created by the DCP black box. At each stage i, we have states ∣Ψk⟩ such that the ni least significant bits of k are zeros. We make many combinations as described above and we get at stage i + 1 a certain amount of states ∣Ψk ' ⟩ such that the ni+ 1 > ni  least significant bits of k  are zeros. At the output of the pipeline, we get the state ∣∣Ψ2 n−1 ⟩ with high probability. 
The running  time of Kupenberg's algorithm is 2O( log N√ )  which  is subexponential  but unfortunately, the 
algorithm also requires 2O( log N√ )  quantum space. Shortly after that Kupenberg designed its algorithm, Regev [Reg2004] gave an improved version that requires only polynomial space at the price of increasing the running time to 2O( log(log N )log N√ ). Note that in both algorithms the query complexity is actually the same as the running time. 
In [BacChiDam2005] quantum-information theory is used to see how much information we can get from a DCP black box. If we let ∣∣φx, d⟩ = 1 
2√ (∣x⟩∣0⟩ + ∣x + d⟩∣1⟩) then the density matrix output by the DCP black box is 
ρd = 1 N 
∑ x∈ ℤN 
∣∣φx, d⟩⟨φx, d ∣∣. So if we use k = ν log(N) outputs from this black box, our purpose is to identify the 
density matrix ρ d 
⊗k  among all  the a priori  equiprobable values of d. Bacon, Childs and van Dam found the 
optimal  measurement for that purpose (the so-called "pretty good measurement") and showed that we can determine d  with exponentially small probability if ν < 1 and a constant probability if ν > 1. Since the algorithm of Ettinger  and  Høyer  gives  an  algorithm using  linear  (in  log(N))  oracle  calls,  this  means  that the  query complexity of DCP is exactly Θ(log(N)). Note that Bacon, Childs and van Dam have a similar result in the case where we try to determine only the parity of d. 
Finally, let's mention a relationship between DCP and the subset sum problem. Recall that this problem is to  find  a  subset of a  given set of k  integers that sums to  another given integer r. It is well-known that the decision version of the problem is NP-complete. However, in the discussion below, we fix a density k > log(N). We can still hope that it is possible to solve some instances at that density and so that it will help us to get better algorithms for DHSP. 
Definition 5.5 (subset sum problem) 
32
Let N > 0 be an integer. The subset sum problem at a fixed density k > 0 is, given a x ∈ ℤN k  and a target 
value t ∈ ℤN , to find an element of St x = {b ∈ ℤ2 
k  such that b.x = t mod (N)}. A legal  instance of the problem is 
such that St x ≠ ∅. ◇ 
In [Reg2003], Regev proved that if it is possible to solve a fraction 1 poly(log N ) 
 of the legal instances of the 
subset sum problem if k > 4 + log(N), then we have a solution to DCP. Some algorithms have been proposed after  Regev's  paper  [FlaPrz2004] [Lyu2004],  giving  an  alternative  solution  for  DHSP with  subexponential complexity. 
Bacon,  Childs  and  van  Dam  gave  a  similar  result  in  [BacChiDam2005].  We  define  the  uniform superposition of solutions to a legal instance of the subset sum problem with input (t, x): 
∣St x⟩ = 
1 
∣∣St x ∣∣√ 
∑ b ∈ S 
t x 
∣b⟩ (5.11) 
if we have a quantum circuit that operates on input states ∣t, x⟩ and sends the legal instances to ∣St x , x⟩ 
then we can implement the optimal measurement and thus solve DCP. Producing these states ∣St x⟩ is stronger 
than the Regev's condition: not only we need to be able to solve all the legal instances but also for a given input we need to gather all the solutions in one big entangled state. Conversely, Bacon, Childs and van Dam showed  that an  implementation  of the  optimal  measurement according  to  their  particular  schema yields a solution to the subset sum problem. 
Note that these DCP solutions based on the subset sum problem are solving DHSP by coset sampling over  the  whole  group.  In  contrast,  Kuperberg's  algorithm  for  DHSP  works  recursively:  we  need  a  DCP black-box which is able to sample over subgroups of DN  containing H . However, there is an alternative non recursive version where we use the phase estimation algorithm to approximate d . 
5.3. Dihedral HSP, Lattice Problems and Cryptosystems 
In the two previous sections, we have given an overview of the DHSP results known so far. While we can try to find efficient HSP algorithms for their own sake, Regev showed that the case of the dihedral  group is particularly interesting: it is related to some lattice problems whose difficulty is assumed in some cryptographic systems. This section, based on [Reg2003] and [MicReg2008], explains more precisely this relationship. 
33
(0, 0) 
b1 
b2 
Figure 5.3 
Definition 5.6 (lattice) 
Let  n > 0  be  an  integer  and  b1, b2, …, bn  a  basis  of  ℝn  (or  equivalently  a  matrix  [b1 ∣ b2 ∣ … ∣ bn] 
= B ∈ GLn(ℝ)). We define the lattice generated by the basis as the set of all linear combinations of the basis vectors with integer-valued coefficients: 
ℒ(B) = {Bx = ∑ i = 1 
n 
xibi ∣ x ∈ ℤn} (5.12) 
◇ 
An example of a 2-dimensional lattice i.e. generated by a basis b1, b2  of ℝ2  is given in figure 5.3 (notice that an alternative basis is also given). Lattices are involved in many problems assumed to be hard. The one that we will particularly be interested in is the following: 
Definition 5.7 (f(n)-uniqueSVP) 
The Shortest vector problem (SVP) is to find in the lattice a non zero vector of minimum length. In the f (n) 
-uniqueSVP (uniqueSVP) we have the promise that such a vector is necessarily shorter by a factor f (n) than all other non-parallel vectors. ◇ 
As we have seen at the beginning, Shor's algorithms allow to break cryptosystems based on the hardness of factoring or discrete logarithm's computation. One kind of alternative cryptosystems proposed is based on lattices. In Appendix E, we summarize in one table the overview of [MicReg2008]. 
In order to establish a connection between one of the f (n)-uniqueSVP and DCP, we need to modify the black-box in a way that allows errorous output. So we introduce: 
34
Definition 5.8 (DCP with failure parameter p) 
Let N > 0 be an integer and p > 0. The DCP over DN  with failure parameter p is the problem of finding a hidden slope d ∈ ℤN  given a black box that behaves almost always like a DCP black box. More precisely, this 
black box produces a DCP-state 1 
2√ (∣x⟩∣0⟩ + ∣x + d⟩∣1⟩) for some uniformly random x ∈ ℤN  with probability at 
least 1 − 1 
(log N )p  and an arbitrary ∣a⟩∣b⟩ ∈ DN  otherwise. ◇ 
We can now state the main theorem, due to Regev [Reg2003]: 
Theorem 5.9 
Let n > 0 an integer and define N = 2(4n+ 1)n . If there is a solution to the DCP over DN  with failure parameter 
p then there is solution to the Θ ( n 
1 2 
+ 2 p 
) -uniqueSVP. □ 
Regev said  that if we have a solution to  the exact DCP, then by taking p large enough the black-box outputs only DCP-states. He concluded that a solution to DCP gives a solution to the poly(n)-uniqueSVP. Let's state a slightly stronger version of its corollary: 
Corollary 5.10 
If there is a solution to DCP over D2 (4n+1)n  whose query complexity can be expressed as a polynomial of 
degree D, then there is a solution to Θ ( n 
1 2 
+ 2 D 
) -uniqueSVP. 
proof: the probability that the DCP with failure parameter p produces only DCP-states after ∑ i = 0 
D ai(log N) i 
oracle calls is at least 
( 1 − 
1 
(log N)p) 
∑ i =0 D ai(log N ) i 
= ∏ i = 0 
D ⎡ 
⎣ 
⎢ ⎢( 
1 − 1 
(log N)p) 
(log N ) i⎤ 
⎦ 
⎥ ⎥ 
ai 
(5.13) 
When N → + ∞, the limit of the bracket term is 0 if i > p, ⅇ−1 if i = p and 1 otherwise. So the above value is 
bounded below by a constant c > 0 iff D ≤ p. In that case, we can repeat the procedure about 1 c  times to be sure 
that we solve DCP over D2 (4n+1)n  with failure parameter p = D and so the Θ ( n 
1 2 
+ 2 D 
) -uniqueSVP. □ 
The corollary gives the optimal  degree of the approximate polynomial  for uniqueSVP we can get from Regev's  algorithm,  assuming  that  the  DCP  algorithm  does  not  accept  failure  at  all.  By  the  result  of [BacChiDam2005], a DCP algorithm can not work with sublinear query complexity, so the best we can do is 
Θ(n 5 2 
)-uniqueSVP.  If  we  look  to  figure  12.1,  this  would  be  a  rather  minor  result  since  it  affects  only 
Ajtai-Dwork cryptosystem improved by Goldreich/Goldwasser/Halev, which is not likely to be used in practice. Moreover it is important to  note  that an  algorithm for uniqueSVP only invalidates the  proof of security but, 
35
contrary for example to Shor's algorithm, does not necessarily give a way to break them. 
However,  solving  DCP  would  give  a  HSP-related  algorithm  that  invalidates  the  security  proof  of  a cryptosystem and hence gives hope that more algorithms of this kind could be found. According to figure 12.1, an  interesting  direction  would  be  to  find  algorithms  for  other  problems  such  that  SVP,  SIVP  or  LWE. Considering  specific  version  of lattices used  in  cryptosystems such  that "ideal  lattices" would  maybe  help finding efficient algorithms. 
It is worth looking to the ideas of Regev's algorithm. First Regev introduces the "two points problem" which is essentially DCP where the scalars x, x + d  are replaced by two vectors in ℤM 
n  with constant difference. The 
two point problem reduces to DCP over D(2 M )n  by considering the mapping: 
(a1, a2, …, an) ↦ a1 + a22M + …+an(2M)n− 1 (5.14) 
This  is  clearly  one-to-one  and  so  (modulo  some  additional  wires)  can  be  implemented  as  a  unitary transform permuting the basis states. In general, it is not clear that it can be done efficiently but in Regev's case, M = 24n  is the power of 2, so this is just adding wires and permuting them. As announced above, we are considering DCP over D2 (4n+1)n . In particular, we only need a solution to DCP over a power of 2, which may be 
easier than the general  N. We also note another way to solve this step: we can directly find the difference 
v ∈ ℤM n  if we have an algorithm for a DCP-like problem over Dih(ℤ 
2 4n n 
) = ℤ 2 4n n ⋊ℤ2  in place of DN ≅ ℤN⋊ℤ2. 
This corresponds to a generalized DHSP over ℤM n  with hidden subgroup ⟨(v, 1)⟩. 
Then, Regev creates a  polynomial  number  of instances for  the  two  points  problem. Among  all  these instances, there is at least one giving an output from which we can extract the shortest vector. So we only run the procedure many times and keep the shortest vector inside the lattice. The routine uses a funtion F = g ∘ f 
where  f  maps  elements  of  ℤM n  to  lattice  vectors  and  is  very  similar  to  coset  sampling:  we  start  by  a 
superposition over ℤM n , apply UF  and measure the result image of F. Regev gives two versions with different g 
(one based on cube partition of the space and a more efficient based on sphere partition) but in any case it is chosen such that with high probability, we are going to have a superposition over two very close lattice points encoded in a state 1 
2√ (∣x⟩∣0⟩ + ∣x + v⟩∣1⟩). 
This similarity between the coset sampling procedure and Regev's algorithm is really important. While all the  studies that have  been made so  far on  DHSP were  based on  the  DCP problem i.e. a  standard  coset sampling on H = ⟨(d , 1)⟩, it is well possible that modifying our coset sampling procedure will give better results to solve DHSP. Hopefully, the modifications can be applied in a straightforward manner to Regev's procedure, and so our relation with uniqueSVP will  still  hold. The example 5.11 gives possible modifications we have experimented, but they have not lead to improvements. 
Example 5.11 (modified coset samplings) 
Modifying the oracle. Fix k > 0 and define the function f1(a, b) = f (a, b mod (2)) where a ∈ ℤN , b ∈ ℤ2k  ( f  is 
the  DCP  oracle).  Then  the  coset  sampling  using  f1  as  oracle  produces  a  state 1 
2k√ ∑ 
i = 1 
2k (∣xi⟩∣2i⟩ + ∣xi + d⟩∣2i + 1⟩) for some uniformly random elements xi ∈ ℤN . 
Modifying the input state on the oracle register: fix some k > 0. Rather than sending the state ∣0⟩ on the 
36
oracle register (i.e. the last register of Uf ) send a superposition of k  basis states 1 
k√ ∑ 
i = 1 
k ∣∣yk⟩ for some 
uniformly  random  distinct  elements  yk.  Then  the  coset  sampling  produces  a  state  1 
2k√ 
((∑ i = 1 
k ∣xi⟩)∣0⟩ + (∑ 
i = 1 
k ∣xi + d⟩)∣1⟩) for some uniformly random distinct elements xi ∈ ℤN . 
Making the superposition non-uniform: input the states ∑ a = 0 
N − 1 ∑ 
b = 0 
1 pa ,b ∣a⟩∣b⟩ for a distribution probability 
pa ,b . The coset sampling produces a state 1 
2√ (px, 0 ∣x⟩∣0⟩ + px+d , 1∣x + d⟩∣1⟩). 
One important variant is DCP over another hidden slope problem for the dihedral group, derived from the initial DN . For example in Kuperberg's algorithm, we use a coset sampling over DN  to determine the parity b of 
d, over DN /2 ≅ H2,b ⊆ DN  and so forth... Similarly for Dih(ℤ 2 4n n 
), we can get information on v  and move to a 
smaller subgroup. For example if we determine the parity of b of the ith coordinate of v  then we can work in H(1,1, …, 1, 2, 1, …, 1),b  (with  a  2  at the ith  position) instead, which is isomorphic to  another generalized dihedral 
group Dih(ℤN i− 1×ℤN /2 ×ℤN 
N − i− 1 ) and by induction, we continue to move to dihedral groups of the form Dih(A) 
with smaller and smaller complexity. Of course, if we are only working on a specific class of group we have to ensure that we remain in this class at each induction step, contrary to the previous example. 
In the case of A = ℤ 2 4n n , this reduction to a smaller group can be translated in a straightforward way to 
Regev's algorithm: we create the superposition over the new subgroup of A rather than on the whole A. For the dihedral group, we have to look carefully to what is happening with the mapping of formula 5.14. Determining the digit of d  in the increasing order of their significance is doing the same for each ai for an increasing i (again, this works well because M  is a power of 2). Hence we can again create the superposition over subgroups of the corresponding A. The mapping sends them to the decreasing sequence of groups described above for Kuperberg's algorithm. Finally, we have the following corollary: 
Corollary 5.12 (class-preserving recursive DCP algorithm is allowed) 
The  previous  connections  between  DCP  and  uniqueSVP  hold  for  class-preserving  recursive  DCP algorithms over some generalized dihedral  groups. More precisely, we mean an algorithm based on coset sampling  over  a  class  of generalized  dihedral  group  Dih(A)  which  includes  Dih(ℤ 
2 4n n 
)  and  such  that the 
recursive step moves to a subgroup of the same class. A recursive DCP algorithm is also allowed for A = ℤ2 n 
group if the inductive step consists in determining the parity b of d and moving to H2,b ≅ DN /2 . □ 
As  a  final  remark,  Regev's  procedure  generates  a  superposition  of  two  lattice  points  with  constant difference. Maybe we could increase the number of points in the superposition and use another group with larger coset states (for example semi-direct product A⋊ℤp with A abelian). Allowing more points in one partition could weaken the uniqueSVP promise. 
5.4. The Symmetric Hidden Subgroup Problem 
For any n ≥ 1, let Sn denote the symmetric group i.e. the group of permutations on a set of n elements. This 
group is of order n !, so log∣Sn∣ = ∑ i = 2 
n log(i) and since 1 ≤ log(i) ≤ i for i ≥ 2, we have n − 1 ≤ log∣Sn∣ ≤ 
n(n+ 1) 
2 − 1. 
37
This means that n can be used as a measure of efficiency since log∣Sn∣ = poly(n) (more precisely, the Stirling 
formula gives ∣Sn∣ = 2πn√ ( n ⅇ) 
n (1 + o(1)) so log∣Sn∣ ∼ 
n → ∞ n log n). 
Definition 5.13 (SHSP) 
The  symmetric  HSP  (SHSP) is  the  hidden  subgroup  problem for  the  symmetric  group  Sn. An  efficient algorithm for the symmetric HSP has a complexity poly(n). ◇ 
By Cayley's theorem, every group G is isomorphic to a subgroup of S∣G ∣. Hence to find a subgroup H  of G, one can apply a SHSP to the corresponding subgroup of S∣G ∣. However, an efficient algorithm for S∣G ∣ would be poly(∣G∣) while an efficient algorithm for G needs to be poly(log(∣G∣)). 
A more  exciting  application  is that an  efficient algorithm for SHSP would  give  a  solution  to  the  graph isomorphism problem, which has remained unsolved for many decades. We recall: 
Definition 5.14 (Graph isomorphism and automorphism problems) 
Let (V1, E1) and (V2, E2) be two (undirected) graphs. They are said to be isomorphic iff there is a bijection φ : V1 → V2  such  that  for  any  two  vertices  a, b ∈ V1  we  have  {a, b} ∈ E1  iff  {φ(a), φ(b)} ∈ E2.  The  graph 
isomorphism problem is to determine whether two such graphs are isomorphic, in time polynomial in the size of the input parameters (the number of vertices for example). The graph automorphism problem is to determine whether a graph has a non-trivial automorphism (i.e. there exists a φ ≠ Id which is a permutation of the vertices of the graph). ◇ 
Figure 5.4 
The figure 5.4 shows an example of three isomorphic graphs. Clearly, the automorphisms are given by the bijections fixing the vertex of degree 4. 
Notice that the definition above is the decisional version of the graph isomorphism problem. It turns out that finding an explicit isomorphism or counting the number of isomorphism has the same complexity, so we can restrict ourselves to the decisional version. This version is clearly in the class NP, but it is known neither to be NP-complete  nor  to  belong  to  the  class  P.  Many  problems  are  computationally  equivalent  to  the  graph isomorphism problem. For instance, it is the case of the graph automorphism problem, to the weaker version with connected graphs or to the stronger version with directed graphs. See, [Köb1993] for details. 
Let's consider first the reduction of the graph automorphism problem to SHSP. Let (V , E) be a graph and 
38
define H  to  be the set of its automorphisms. Obviously, the identity is an automorphism, the inverse of an automorphism is an  automorphism and  the  composition  of two  automorphisms is again  an  automorphism. Hence H  is a subgroup of the permutations of V  that can itself be viewed as Sn for n = ∣V ∣. We define the oracle f  to be the function that send φ ∈ Sn  to f (φ) = (φ(V ), φ(E)). As indicated in [Lom2004], f  can be computed efficiently. Suppose for instance that we have fixed an enumeration {0, ⋯, n − 1}  of the vertices V  and we represent the graph (V , E) by an ordered list of pairs (a, b) where a ≤ b ∈ V  and {a, b} ∈ E. Given (V , E), we can compute (φ(V ), φ(E)) efficiently by replacing each (a, b) by (φ(a), φ(b)) and then applying classical sorting algorithms on the whole structure. 
Finally, we have H  a subgroup of Sn  and clearly ∀ φ1, φ2 ∈ Sn, f (φ1) = f (φ2) ⇔ φ1H = φ2H . So an efficient 
algorithm for DHSP gives a poly(n) algorithm for determining H . Actually, we only need a weaker version of DHSP where we want to determine whether H  is non-trivial i.e. the graph has a non-trivial automorphism. 
When the two graphs (V1, E1) and (V2, E2) are rigid i.e. do not have a non-trivial automorphism, there exists a reduction from the graph isomorphism problem to a somewhat simpler version of HSP. First, if the graphs do not have the same number of vertices, then they are clearly not isomorphic and we are done. So let n be their 
common number of vertices. It is easy to check whether each graph is connected in time O(n 2 ). Again, if one is 
connected and the other is not then we are done. If both are not connected, then their complement graphs are connected  and  using  these  complement  graphs  instead  changes  neither  the  answer  to  the  graph automorphism nor the rigidity of the graphs. Hence we suppose that the two graphs are connected and rigid. 
We now build a 2-component graph of 2n vertices by taking the disjoint union of (V1, E1) and (V2, E2) . We suppose V1 = {1, ⋯, n} and V2 = {n + 1, ⋯, 2n}. The permutations of V1 ∪ V2  can be viewed as the group S2n . An isomorphism φ : V1 → V2 between the two initial graphs can be seen as an element of Sn. If we introduce the the  involution  sn  permuting  i  and  n + i  for  all  1 ≤ i ≤ n,  φ  can  actually  be  seen  as  the  automorphism 
(φ, φ−1 )sn ∈ S2n  of the disjoint union of the initial graphs. 
As above the set H  of all automorphisms of the union graph is a subgroup of S2n . Since we know that the union graph is made of two connected rigid components, we have either H = {Id} if the two initial graphs are 
not  isomorphic  or  otherwise  H = {Id, σ}  where  σ = (φ, φ−1 )s  is  an  involution  of  S2n  permuting  the  two 
components. Hence we have obtained a variant of DHSP where the graph is either trivial or a conjugate of H0 
= {Id, s}  and  whose  solution  gives  an  efficient  algorithm  to  determine  whether  two  rigid  graphs  are isomorphic. 
We can actually simplify the problem any further: H  is always included in the group G generated by sn and the permutations of S2n  fixing each component (i.e. elements of Sn×Sn ⊆ S2n ). We have (a, b)sn = sn(b, a) and sn is  of order  2  so  any  element of G  can  be  written  (a, b)sn 
c  for  some  (a, b) ∈ Sn×Sn  and  c ∈ ℤ2.  If  τ  is  the transposition of S2 then the law of G is defined by: 
(a1, b1, c1)(a2, b2, c2) = ((a1, b1) ∘τ c2 (a2, b2), c1 + c2) (5.15) 
This is called the wreath product of Sn  and ℤ2  and denoted by G ≅ Sn ≀ ℤ2 = (Sn×Sn)⋊ℤ2. Finally, we now have an instance of HSP over the group Sn ≀ ℤ2  and we only have to distinguish the cases H  trivial (the two 
graphs are not isomorphic) or H = {Id, (a, a−1, 1)} ( a ∈ Sn is the isomorphism between the two graphs). 
39
We can notice that we have a reduction from the rigid  graph isomorphism problem to the simple HSP group A2n . If ε  denotes the signature of permutation, we have ε(σ) = ε(φ)2ε(sn) = 1(−1)n. If n is even, then we can directly work in A2n . Otherwise, let m = n + 1, add to each initial rigid graph another connected component composed  of  only  one  single  node,  and  combine  them into  a  big  graph  of  2m  nodes.  If  we  define  the transposition τ = (m, 2m), then the automorphism group H  of the big graph is a subgroup of S2m and is similar to 
the previous case: either H = ⟨τ⟩ or H = ⟨τ , σ⟩ where σ = (φ, m ↦ m, φ−1, 2m ↦ 2m)sm. The problem is now to 
determine whether the subgroup H ∩ A2m of A2m is trivial or ⟨σ⟩. 
Attempts  to  solve  SHSP, even  the  restricted  versions have  not reached  any success so  far. The  first question is whether the classical Fourier Sampling method is helpful. Some negative results were proved for the  weak  Fourier  Sampling  [GriSchVaz2000]  [HalRusTa-2000],  extended  to  strong  Fourier  Sampling [MooRusSch2005] and finally to an arbitrary POVM over many entangled coset states [HalRoeSen2005]. More precisely,  the  last  result  shows  that  we  need  to  perform measurement on  at  least  Ω(log(∣Sn∣)) = Ω(nlog n) 
entangled states at once. 
One model for using such an entanglement is Kuperberg's algorithm for DHSP. It can be interpreted as a repetition of combine-and-measure operations on representation state (i.e. given representation states ρi  and 
ρj, apply measurement on  their  tensor product ρi ⊗ ρj  to  get a  new representation  state) until  we  reach  a representation  from which  one  can  extract useful  information  on  the  hidden  subgroup. [MooRusSni2006], proved however that such an algorithm can not succeed for the symmetric group unless it takes ⅇΩ( n√ )  time. 
This  does  not give  any  meaningful  improvement over  the  best known  classical  algorithms: ⅇO( n log n√ )  for 
general graphs [BabLuk1983] or ⅇ O(n 
1 3 log 2 n) for strongly regular graph [Spi1996]. 
Despite intensive study, no quantum algorithm for SHSP are known. It is worth noting that the structure of the symmetric group is very complex (Sn  contains all the groups of order n as subgroups) and is likely to be much more difficult to solve. It is possible that a straightforward method (i.e. performing coset sampling over the Sn  or Sn ≀ ℤ2) is not appropriate and we should rather distinguish many particular or reduced cases as in the classical algorithms mentioned above, which rely on classification of finite simple groups. Solving HSP for other groups  will  provide  us  more  techniques  and  probably  help  us  to  find  a  general  method.  For  example, O'Nan–Scott theorem gives the form of the maximal subgroups of Sn  and we could use the "maximal subgroup reduction" method given in the next section. 
40
6. The General Hidden Subgroup Problem 
6.1. General approach to the Hidden Subgroup Problem 
In this section, we recall  the two fundamental theorems of group theory describing all  finite groups. We show how they can be used to solve the general HSP under certain conditions. We study the special cases of dedekindian, dihedral and symmetric groups in that framework. 
A group G  is said to be simple, if it contains no other normal subgroups than {1}  and G. Finite simple groups are the "building blocks" for all  finite groups and their classification are given by a theorem of group theory. More precisely, the theorem states that the possibilities for a finite simple group are: 
Cyclic groups ℤp for p prime. Alternating groups An for n ≥ 5. Simple groups of Lie type. 26 sporadic simple groups. 
For an arbitrary finite group G, a composition series is a sequence of subgroups of G 
{1} = H0 ⊲ H1 ⊲ H2 ⊲ … ⊲ Hn = G (6.1) 
such that each Hi  is a maximal normal subgroup of Hi+ 1. The integer n is called the composition length, and is clearly O(log∣G∣). Each Hi +1 Hi 
 is called a composition factor and is by definition a simple group. Any 
finite group has a composition series: informally, we can start with {1} ⊲ G and insert normal subgroup Hi until we get a composition series. Moreover, the Jordan–Hölder theorem says that all  the composition series of a group are equivalent i.e. they all have the same length and are made of the same composition factors (up to isomorphism and permutation). 
The consequence of these two theorems is that we know how any finite group G is built. Let's see how they can be used to solve the general HSP. Suppose H  is a subgroup hidden by f  and N ⊲ G a normal subgroup. Then H ̅̅ = {hN , h ∈ H} is a subgroup of G N  and H ∩ N  a subgroup of N. We can consider the HSPs over G N 
and H ∩ N  respectively and get two sets of generator H ̅̅ = ⟨hiN⟩ and H ∩ N = ⟨xi⟩. Finally we obtain a set of generators ⟨hi, xj⟩ = H ̅̅H ∩ N = H  for the hidden subgroup. Of course, this quotient reduction is only relevant if {1} ⊈ N ⊊ G i.e. is only possible if the group is not simple. Moreover, if n1, n2 are the length of two composition series for G H  and H ∩ N  we have n = n1 + n2. Hence if we repeat the previous quotient reduction to  these subgroups we will  reach simple groups in O(log∣G∣) steps. Note that the Jordan–Hölder theorem essentially says that there are no privileged choice for the normal subgroup N  at each step. Finally, we have the following theorem: 
Theorem 6.1 (solution to the general HSP) 
We have a solution to the general HSP if 
We have an efficient algorithm for HSP over simple groups. 
41
For any hidden subgroup problem G, H , f  over a non-simple group and a normal subgroup {1} ⊈ N ⊊ G, we  have  an  efficient way to  build  polynomial-time  oracles f ̅̅  and  f∣H ∩N  over  G N  and  N  hiding  the 
subgroups H ̅ ̅and H ∩ N. 
Thus, one research direction is to try to solve HSP over simple groups. We can also restrict in a first time to solvable  groups (i.e. such that the composition factors are abelian, or more precisely cyclic groups of prime order) and use the HSP algorithm that we already have for the composition factors. 
The  second  research  direction  is  to  find  reduction  methods. We  have  already  seen  many  times  the following subgroup and quotient reduction: 
Definition 6.2 (subgroup reduction, quotient reduction) 
Let G, H , f  be a HSP problem. We have the following reductions: 
Subgroup reduction: Suppose we can find in polynomial time a subgroup G1 ⊆ G that contains H  and an 
isomorphism G2 ≅ g G1  such that g has polynomial  complexity. The oracle f ∘g over G2  hides the group 
g-1(H ). A solution to HSP over G2 gives a set of generators u1, …, un for g-1(H ) and so a set of generators g(u1), …, g(un) for H . 
Moreover, if G1 ⊊ G, then ∣G1∣ ≤ 1 2 
∣G∣. 
Quotient reduction: Suppose we can find in  polynomial  time a normal  subgroup H1 ⊆ H ⊆ G, a  set of 
generators u1, …, un  for H1  and an isomorphism G2 ≅ g 
G H1 
 such that g has polynomial complexity. The 
oracles f ∘g hides the group g-1 ( H 
H1 ). A solution to HSP over G2  gives a set of generators v1, …, vn  for 
g-1 ( H 
H1 ) and so a set of generators g(v1), …, g(vn) for H H1 . Then the union of ui, g(vj) generates H . 
Moreover, if H1 ≠ {1} then ∣∣G H1 ∣∣ ≤ 1 
2 ∣G∣. 
Note that the theorem 6.1 uses a combination of generalized versions of these reduction methods with N = G1 = H1  and  without the  constraints  H ⊆ G1 = N  and  N = H1 ⊆ H .  For  the  subgroup  reduction  part, the 
oracle does not need to be changed and will hide the expected group H ∩ N  instead. However, it is less clear how to build the oracle for the quotient reduction part because two elements g1, g2 ∈ G that belong to the same 
class in G N  may not belong to the same preimage of f . Note that if H ≠ G, then it is always included in a maximal subgroup G1  and thus subgroup reduction is always possible. This is particularly interesting in the case  of the  simple  group, where  quotient reduction  is  not possible. However, the  complete  description  of maximal groups is only known for some groups. 
Theorem 6.3 (iterative maximal subgroup reduction) 
We have  a  solution  to  HSP over  a  group  G  if we  have  an  algorithm to  find  a  maximal  subgroup  G1 
containing  H , apply subgroup  reduction  to  G1  and  repeat the  operation  inductively. We stop  when we no longer can find a maximal subgroup i.e. H = G. □ 
42
Let's consider the groups we have previously studied. First, in the Dedekindian HSP we work on a group whose subgroups are all normal. An algorithm is given in appendix F for the particular case of abelian group, but should also work for hamiltonian ones. The idea is to use Weak Fourier Sampling to get a sequence of subgroups of G  containing H  that become smaller and smaller. Because all  groups are normal, we have a subsequence of a composition series: 
{1} ⊲ H ⊲ Gm ⊲ … ⊲ G0 = G (6.2) 
In that case, H Gk  is the trivial group and H ∩Gk = Gk, so the algorithm of theorem 6.1 is really only using 
subgroup reduction. The abelian algorithm of appendix F also shows the importance of "nice" description of groups, such that the one provided by black box groups. In our definition 3.3 of the hidden subgroup problem, we say that we  want to  determine  the  hidden  subgroup  H  and  definition  3.5  asks for a  set of generating elements. However in  the  abelian  case, to  be  able  to  iterate  the  reductions we  use  at each  step  a  direct 
decomposition  Gk = ⊕i = 1 
dk+1 ⟨ai 
k+ 1 ⟩  so  that  we  can  have  the  polynomial-time  isomorphism  mentioned  in 
definition 6.2 and thus efficient oracles on the new groups. 
Another  interesting  case  is  the  reduction  we  have  made  so  far  for  the  dihedral  group. The  possible composition series are given in figure 6.1, where the dots correspond to composition series of the isomorphic groups indicated. 
H1 ≅ ℤN 
{(0,0)} = HN 
{(0,0)} = HN 
H1 ≅ ℤN 
H2, 0 ≅ DN 2 
H2, 1 ≅ DN 2 
H1, 0 = G 
H1, 0 = G 
⋯ 
⋯ 
N even 
N odd 
Figure 6.1 
As usual, we consider the case H = Hr , d  which contains the normal subgroup Hr. Because Hr = H1 ∩ H , we can apply a subgroup reduction to determine r: we move in H1 which is isomorphic to ℤN  and apply a cyclic HSP algorithm. Since we now have a normal subgroup included in H , we can use a quotient reduction. We have G Hr ≅ DN ℤ N r 
≅ Dr  so we still have a similar composition series diagram and we now assume r = N. 
The hidden subgroup becomes HN ,d  and we want to determine d. It easy to see that none of the candidates for quotient  reduction  (i.e.  normal  subgroups  of  G  included  in  the  hidden  subgroup)  provide  any  further simplification. As a consequence, we are turning our attention to subgroup reduction. The possibilities are Ha ,b 
where a is a divisor of N  and d ≡ b mod(a). In that case, we have Ha ,b ≅ DN a  and the new hidden subgroup is 
generated by a slope (q, 1) where q is the quotient of the division of d  by a. We repeat subgroup reduction until we have determined entirely d  and again we need only O(log∣G∣) reduction steps. Note that variations of this kind are proposed in Kuperberg's paper [Kup2003]. The key step for solving DHSP is thus to determine the 
43
remainder of d  modulo a divisor a of N. For N = 2n  the procedure will be to determine the bits of d, from the least to the most significant ones. Finally, we recover the techniques that have been used so far. Note that the dihedral is solvable, so we already have a solution for the simple groups involved. Hence a solution to DHSP will either be an algorithm to find the parity of d  (or any other remainder of d) or by new reduction techniques. 
There is an alternative way to see the first quotient reduction by Hr. Using theorem 9.9 one can see that, except in the degenerated cases H = H2,d , the intersection of the kernels of the representations measured by a Weak Fourier Sampling over the dihedral  group is exactly Hr. Actually, we know that in  general  the Weak Fourier Sampling gives the largest normal subgroup of G which is included in H . Hence a general method is to apply Weak Fourier Sampling to find that subgroup and then use a quotient reduction. In the quotient group, we can  still  repeat  this  procedure.  After  O(log∣G∣)  reductions  of  this  kind,  we  will  not  be  able  to  reduce  the underlying group any further: the largest hidden subgroup of H  normal in G is the trivial group {1}. If this group is also H , then we can determine the original hidden subgroup. Otherwise, H  is not necessarily simple and we need to use subgroup reduction or other methods as in the case of the dihedral group. We have: 
Proposition 6.4 (iterative quotient reduction) 
A repetition  of quotient reduction  using  the  largest normal  subgroup  included in  the  hidden subgroup leads to a hidden subgroup problem where the reduced hidden subgroup H  does not contain any non-trivial normal subgroup. If the reduced hidden subgroup is trivial then we can solve HSP using this method. □ 
Finally, let's consider the symmetric group Sn. We may discard small values of n and assume n ≥ 5. In that case, {Id} ⊲ An ⊲ Sn is a composition series and in particular Sn is not solvable. Moreover, consider the case of our reduction of rigid graph isomorphism problem in S2n , where H  is trivial or H = ⟨σ⟩ for some involution σ = 
(φ, φ−1 )sn with signature ε(σ) = (−1)n. If we split the HSP problem between S2n A2n 
≅ ℤ2 and A2n , we have two cases: 
n is even, so H ∩ A2n = H ⊆ A2n  and all the information is in A2n . However, this group is simple so we can not reduce it any further using quotient groups. n is odd, so H ∩ A2n = {Id} and all the information is in S2n A2n 
≅ ℤ2. The HSP is trivial on this group and all the hardness consists in the construction of an oracle. 
Actually, we have even seen in  the  previous section  that we can reduce the  rigid  graph isomorphism problem to the simple group A2n . 
Possible algorithm for the general HSP 
Input: The group G the oracle f . Output: The hidden subgroup H . 
Use at most k coset measurements (remark 4.10) to determine whether H = G with probability of success 
at least 1 − 2k or H  is a proper subgroup of G with certainty. In the former case, return G. 
1. 
If we have an efficient HSP algorithm over G, execute it and return the subgroup H  found.2. If G is simple, determine a maximal subgroup G ' containing H , and use it to apply subgroup reduction. Call this algorithm recursively and return H . 
3. 
44
Apply Weak Fourier Sampling to determine a maximal normal subgroup H ' of G included in H . If H ' is non-trivial, use it to apply quotient reduction. Call this algorithm recursively and return H . 
4. 
Otherwise, find a way to reduce the problem by using a normal subgroup {1} ⊈ N ⊊ G, subgroup reduction or any other methods... Call this algorithm recursively and return H . 
5. 
Figure 6.2 
As a conclusion of this section, we have seen a general approach to the HSP based on solution to the simple HSP and various reduction methods. A possible algorithm is proposed in figure 6.2. For the problems related to the dihedral and symmetric groups, it seems however that all  the known reductions have already been used. 
6.2. Known solutions to the Hidden Subgroup Problem 
In this section, we review miscellaneous solutions and techniques obtained for non-abelian groups. The HSP table of appendix A completes this section with a good overview of the state of the art. 
The groups for which an efficient algorithm is known are mainly semi-direct products of abelian groups, so we start by recalling the definition. Given two groups G1, G2 and an automorphism φ : G2 → G1, the semi-direct product G1⋊φG2 is the group with the operation 
(a1, b1)(a2, b2) = (a1(φ(b2)(a2)), b1b2) (6.3) 
For example, we have seen the dihedral group DN ≅ ℤN⋊φℤ2  where φ(b)(a) = (−1)ba and a subgroup of 
the symmetric group Sn ≀ ℤ2 = (Sn×Sn)⋊φℤ2  where φ(c)(a, b) = τ c(a, b) and τ  permutes the two coordinates. The latter is an example of a wreath product G1 ≀G2. Each element b ∈ G2  defines a permutation of the elements of G2  by  x ↦ bx.  Hence  we  can  identify  it  with  a  permutation  σb  of  S∣∣G2∣∣.  We  then  define 
φ(b)(a1, …, a∣∣G2∣∣) = (aσb(1), …, aσb(∣∣G2∣∣)) and G1 ≀G2 = G1 ∣∣G2∣∣⋊φG2. 
The first non-abelian HSP considered was DHSP. Although still unsolved, many methods were introduced, so let's recall them: 
enumerating all the subgroups of G: they can all be described by two parameters d < r. using the abelian Fourier Sampling on abelian subgroups: working on ℤN×{0} allows to find r. using quotient reduction: using the normal subgroup Hr yields the standard reduction for DHSP. applying the abelian Fourier Sampling on the whole group, viewed as a cartesian product: this produces coset states and reduces the problem to DCP. using group reduction: as we have seen in previous section, determining the remainder of d  modulo a divisor a of N is like moving to a subgroup isomorphic to DN a 
. pipeline of coset states: this allows to determine d  in subexponential time. 
pretty good measurement: we consider the  tensor product of k  coset states ρ d 
⊗k  and  use the  optimal 
measurement to identify it among an equiprobable repartition of d ∈ ℤN . If it is efficiently implementable for some k > log(N) then we can find d . superposition of many oracle values: a new approach to determine d  proposed in appendix G. 
45
We have presented  in  details Fourier Sampling  based on  Fourier Transform over finite  groups. It is a natural and elegant extension of the abelian case and was presented as a promising method in the review paper of Lomont [Lom2004]. The  non-abelian  Fourier  Transform has been  used  as a  key element for the Dedekindian HSP [HalRusTa-2000], ℤ2 
n ≀ ℤ2 [RötBet1998], ℤ3⋊φℤ2 n  [GriSchVaz2000], the affine group Aff(1, p) 
as well as some particular cases of q-hedral groups [MooEtAl2005]. More recently it has been used to solve the Weyl-Heisenberg  group  [KroRöt2008]  and  to  find  1-point  stabilizer  of  some  finite  Lie  groups [DenMooRus2008]. However, most efficient non-abelian HSP algorithms currently known do not require it and we know that it would not work for all groups. Again, we recall the methods: 
Weak Fourier Sampling to find normal subgroups or more generally the largest normal subgroup of G contained in H . As previously said, it is Hr  for the dihedral group (except for H = H2,d ) and so it is an alternative way to determine r. Strong Fourier Sampling. It was proved in [MooEtAl2005] that it helps to solve some HSPs on which the weak version fails. Weak Fourier Sampling over subgroups. They are used in the extensions proposed in [GriSchVaz2000] and [Gav2004]. 
The other fundamental methods are given by black box results and we refer to [Lom2004] for a review. Recall that the degree of a group G is defined to be the smallest integer k > 0 such that there is a one-to-one homomorphism φ : G → Sk. For example, we have k ≤ ∣G∣ by Cayley's theorem, k = p for a cyclic group G = ℤp 
of prime order and more generally k = ∑ i = 1 
m ∣Ai∣ for an abelian group with decomposition A = A1×A2×…×Am 
where each Ai  is cyclic of prime order. We have seen in previous section that every group has a composition series and we define: 
Definition 6.5 (nu of G) 
For  any  group  G,  ν(G) > 0  is  the  smallest  positive  integer  bounding  the  degrees  of  the  nonabelian composition factors. ◇ 
In particular, if G is solvable all the composition factors are abelian (and even cyclic) so we have ν(G) = 1. In  general,  we  will  be  interested  in  groups  for  which  ν(G) = poly(log∣G∣).  [IvaEtAl2001]  contains  various interesting algorithms, including: 
For a blackbox group with unique encoding, we can find generators of a hidden normal subgroup N  in time ν(G N ) + input size. For a blackbox group with unique encoding, we can solve HSP in time the input size + [G, G]. 
Actually, an extension of the second point is given in [MooEtAl2005]. 
Let G1 ⊲ G, G G1 ≅ G2. Assume that G1 is of size polynomial in log∣G2∣ and that we have an efficient HSP 
algorithm for G2, then we also have an efficient HSP algorithm for G. 
Unfortunately, this construction can not be iterated more than a constant number of times whereas we would like to repeat this a polynomial number of time for the algorithm of figure 6.2. This extension was used in [DenMooRus2008] to solve some particular cases of Aff(1, pm). Note that the particular case of the commutator 
is G1 = G ' , G2 is the abelianization of G, to which we can apply the abelian HSP and we have ∣G1∣ = poly(log∣G∣) 
46
= poly(log∣G1∣, log∣G2∣) = poly(log∣G2∣). 
Inui and Le Gall studied the case ℤp n⋊φℤq for p, q prime [InuLeG2004] and gave a complete classification. 
One  of the  class  contains  groups isomorphic  to  ℤp n⋊φℤp  (pn ≠ 22  and  φ(b)(a) = a(p n− 1 + 1) 
b)  which  they solved using enumeration of subgroups and blackbox techniques. Chi, Kim and Lee [ChiKimLee2006] noted that the algorithm also works for some groups ℤ2 p n⋊φℤp  and extended the algorithm to the class ℤN⋊φℤp 
under some conditions. The idea is to use a factorization of N to factor out the group and then apply Inui and Le Gall's  algorithm.  Using  a  similar  approach,  Cosme  and  Portugal  [CosPor2007]  solved  some  HSPs  over ℤN⋊φℤp 2 . Inui and Le Gall also proposed a different approach for some cases of ℤpm 
n ⋊φℤp, based on blackbox 
techniques [InuLeG2004]. 
A general proposal for the semi-direct products A⋊φℤp  for some abelian group A and p prime is made in [BacChiDam2005bis]. The first step is similar to the reduction of the dihedral HSP: you use the abelian HSP algorithm over A to find H1 = H ∩ (A×{0}) and use a "quotient reduction" (H1 may not be normal, but they find a way to workaround that issue). This reduces the problem to a semi-direct product A2⋊φℤN  with A2  a subgroup of A. The hidden subgroup is either trivial or the subgroup of size N  generated by (d , 1) for some d ∈ A2. Next, we  use  the  pretty good  measurement with  a  product of m  coset states and  reduce  the  problem to  finding equations of a system with m unknowns and some parameters uniformly chosen at random. The authors called it the matrix sum problem and solved it for various groups A. In particular, they obtained efficient HSP for G = 
ℤp k⋊φℤp (p prime, k constant) and ℤN⋊φℤq (Nq = poly(log N) and q prime). 
More blackbox techniques have also been developed. Using the hidden shift problem, the HSP over some semi-direct  products  ℤ 
p k n ⋊φℤ2  was  solved  in  [FriEtAl2002].  They  also  introduced  orbit  coset  and  orbit 
superposition problems and use it to solve HSP over some solvable groups. More precisely, they defined: 
Definition 6.6 (smoothly solvable) 
An abelian group is smoothly solvable  if it can be decomposed into the direct product of a subgroup of bounded exponent and a subgroup of polylogarithmic size. A solvable group is smoothly solvable if its derived series is of bounded length and has smoothly abelian factor groups. ◇ 
They obtained: 
HSP can be solved in solvable groups having smoothly solvable commutator subgroups 
Ivanyos, Sanselme, Santha solved HSP over extraspecial  groups [IvaSanSan2007] and later extended their result to nil-2 groups [IvaSanSan2007bis] i.e. such that [[G, G], G] = {1}. They first used the concept of hiding procedure defined in [FriEtAl2002] which generalizes the hiding oracle f : 
hiding procedure for a subgroup H  of G: for every g1, …, gn ∈ G, given the input ∣g1⟩∣g2⟩…∣gN⟩∣0⟩ it outputs 
∣g1⟩∣g2⟩…∣gN⟩∣Ψg1 
1 ⟩∣Ψg2 
2 ⟩…∣ΨgN 
N ⟩,  where  {∣Ψg i⟩, g ∈ G}  form a  hiding  set of unit  states  i.e. ∣Ψg 
i⟩, ∣Ψ g ' 
i ⟩  are 
orthogonal if g, g ' are in distinct left cosets of H  and equal otherwise. 
The  abelian  HSP algorithm still  works when  the  oracle  is  replaced  by such  a  procedure. Then, they 
47
reduced the HSP over nil-2 groups to those having exponent p. They showed that in that case we can find a hidden subgroup H  if we have a hiding procedure for H [G, G] and succeeded in constructing such a hiding procedure. 
Finally, note that all the positive results previously mentioned in this section work for groups which are in some sense almost abelian. This is the case for the extensions of the Dedekindian HSP which work for groups with a large amount of normal subgroups, of the semi-directs product of abelian groups G = A⋊B which can be broken down into A ≅ A×{0} ⊲ G and G A×{0} = {0}×B ≅ B. More generally, the results obtained from the black box methods break down the groups into abelian pieces through a normal series. However, it does not seem possible to apply this method for groups which contain a non-cyclic simple group in their composition series such that An  or Sn. One attempt in  that direction is [DenMooRus2008], with  algorithms to find some hidden 
subgroups over the simple group PGL(2, pm) and other related finite groups of Lie type. More precisely, we have a group G acting on a set S  and have the promise that H  is a one point stabilizer Gs, s ∈ S . Their idea is to restrict to one of this stabilizer Gs0 
, apply a Strong Fourier Sampling on this group to determine Gs0 ∩Gs  and 
deduce s. However to make this work, they need some additional hypotheses that do not seem to be satisfied by many groups. Moreover, it is still open whether we can find an efficient HSP taking into account the other subgroups. This may be hard, for example some maximal subgroups of PGL(2, pm) are dihedral  groups for which we do not have solutions yet. 
6.3. The Hidden Subgroup Problem and Efficient Algorithms 
In this section we discuss how HSP is related to some efficient algorithms with concrete applications. We have already mentioned in the first part of this report how particular abelian HSP have been used by Shor to make efficient algorithms for factoring numbers and computing discrete logarithms. In appendix D, we give a 
reduction of Monotone 1-in-3 3SAT to GapCVP∞ where one step uses the abelian HSP algorithm to find the kernel of a group homomorphism. Although the quantum part is not actually needed here, this provides another example where a HSP can be used. Hallgren solved particular cases of HSP over the infinite abelian groups ℝ 
and  ℝr  [Hal2002], [Hal2005]. This  allowed  him to  design  polynomial-time  algorithms for  finding  solutions 
(x, y) ∈ ℤ2  to  Pell's equation x 2 − d y 2 = 0 (where d  is a  positive non-square integer) to  which the factoring problem reduces. He also solved many important number fields problems. 
The two non-abelian cases always mentioned are dihedral and symmetric groups. The HSP over these groups (or their variants: generalized dihedral HSP, alternating HSP etc) is expected to solve a lattice problem used in cryptography and the graph isomorphism problem. However, the first application requires the dihedral HSP to be solved by coset sampling while the second looks like out of the scope of all the techniques currently known. Hence, there  is another point of view which  consists in  building  cryptographic tools assuming  the hardness of the HSP. For example, a classical one-way function is proposed in [MooRusVaz2007] and is at least as hard to invert as solving the Graph Isomorphism Problem. Also, inverting the function reduces to HSP over GL(n, q) which is believed to be hard, given the negative results on its subgroup Sn. 
[Dam1988] contains a proposal for a hard problem with application in cryptography: Given l + 1 = O(log p) 
successive  evaluations  of the  Legendre  symbol  ( s p), ( 
s+ 1 p ), …, ( 
s+ l p )  predict the  next value  ( 
s+ l+ 1 p ).  The 
authors of [DamHalIp2002], proposed the related shifted Legendre symbol problem: given access to an oracle f (x) = ( 
x+ s p )  determine  the  hidden  shift  s.  Obviously,  an  algorithm to  solve  the  shifted  Legendre  symbol 
problem  using  only oracle  calls for values 0 ≤ x ≤ l  provides a  solution  to  the  problem of [Dam1988]. The 
48
authors of [DamHalIp2002] solved the shifted Legendre symbol problem as well as other related hidden shift problems. They indicate that they can break certain cryptosystems by a reduction to the shifted Legendre symbol problem. They say that these cryptosystems can also be broken by Shor’s algorithm, but the two attacks on the cryptosystems appear to use completely different ideas. Hence this shifted Legendre symbol problem shows another relation between cryptosystems and HSP: it can be reduced to the HSP over G = Dp  (under certain assumptions) and as we will see in the next section it can also be reduced to a HSP over G = ℤp ≀ ℤ2. 
Recall  that  in  Grover's  algorithm  we  have  N  elements  indexed  from  0  to  N − 1,  an  oracle  φ : 
{0, …, N − 1} → {0, 1} taking the value 1 for M ≤ N 2  elements and we want to find one of these elements. Here, 
we  take  M = 1  and  denote  j0  the  element that satisfies  φ( j0) = 1.  Lomonaco  and  Kauffman  proposed  a comparaison between this case and Shor's algorithm [LomKau2006]. They described Shor's algorithm as an infinite HSP over ℤ with a subgroup pℤ hidden by an oracle f . They defined a "push" method, used to reduce 
the problem to some HSP over ℤq  (for some integer q) and a new oracle f .̃ Next, they considered the HSP over SN  with hidden subgroup H = Stabj0  of permutations stabilizing j0. They used the subgroup Stab0 and their 
"push" method  to  get a  new  problem where  the  oracle  f ̃ = φ  is  just Grover's  oracle. However, from the definition of a "push" given of their paper, it is not obvious that their algorithm is applyable since we are loosing the group structure. They say that the definitions of the "push" and Fourier Sampling can be generalized but still the  algorithm fails to  provide  a  solution  [Lom2010] . Anyway, Grover's algorithm can  be  interpreted  as an efficient HSP algorithm for otherwise we would have an exponential  speedup instead of the known optimal quadratic speedup [Zal1997]. Here, we are working over G = SN  and an efficient algorithm is expected to be polynomial in N log N . With the promise H = Stabj0 , we only need to find the j satisfying f (σj) = f (Id) where we 
use the cycle  σj = (0,1, …, j − 1, j + 1, …, N − 1)  moving all  elements but j. This can be done in  O(N)  time classically (brute-force search) or even in O( N√ ) time quantumly (Grover's algorithm) and thus the HSP in that case  is  efficiently  solvable.  This  was  actually  noted  in  [DenMooRus2008],  where  efficient  algorithms  are provided for 1-point stabilizer subgroups of SL(2, q), PGL(2, q), PSL(2, q). Interestingly, the big picture of their algorithm is similar to the "push" method above: rather than working over the whole group, they reduce the sampling to a particular 1-point stabilizer for which they can apply the non-abelian Fourier Sampling. Note that the  size  (or  number of 1-point stabilizers)  of these  three  groups is  polynomial  in  q  and  the  efficient HSP algorithm polynomial in log q. Thus, the following open question: can we interpret these algorithms as concrete search problems with an exponentially fast solution? 
6.4. Variants and Extensions 
In this section, we present various problems related to the Hidden Subgroup Problem. Indeed, there have been several proposals to interpret the efficient algorithms of the first part of this report, other than the abelian HSP. New problems have  been  defined  and  solved  for  some particular  cases. These  problems are  often related  to  HSP and their study has sometimes lead to  solutions to  instances of HSP. More  generally, it is expected that these problems will also provide new quantum algorithms exponentially faster than the classical ones. 
One extension is to allow G to be an infinite group: it was actually already the case for the original Shor's algorithm which reduces the HSP over the infinite group G = ℤ to the HSP over some cyclic group ℤq, for some q large enough. In general, the abelian HSP algorithm works for any finitely generated abelian group such that 
G = ℤn. In order to solve various problem, Hallgren had to introduce HSP over ℝ and ℝr [Hal2002], [Hal2005]. The  HSP he  considered  is  finding  a  hidden  subgroup  H = ⟨τ⟩  of ℝ  generated  by an  irrational  τ  (or  said 
49
otherwise, determining an irrational period τ  of a function f ) as well as finding a hidden lattice H  of ℝr. In both cases, the rough idea is to construct a computable discretized version of the oracle f  and show that we can approximate generators for H . 
Other extensions to HSP have been proposed in  three different papers, but they do not seem to have subsequently been studied. One proposal is the Hidden Subhypergroup Problem [AmiKalRoo2006] where the group G is generalized to an hypergroup i.e. the product of two elements is a subset of G rather than a single element.  A  second  proposal  is  the  Hidden  Symmetries  Problem  [SchUnr2003]  where  we  generalize  the condition  that  f  is  constant  on  each  left  coset  to  a  more  general  property  ∀ x ∈ G, V ( f (x), f (U (x))).  For example, saying that f  hides H  is simply taking V  to be the equality and U (x) = xH . The third proposal is the Hidden  Covering  Space  Problem  [OsbSev2004] which  generalizes  the  version  of  HSP given  as  a  coset sampling black-box. This proposal involves topological spaces and is a bit more complicated to define. We will just say that we consider Cayley graph of groups endowed with their natural topology. 
A variation that has been extensively studied is the Hidden Shift Problem. In this problem, we have two injective functions f0, f1  on G satisfying ∀ x ∈ G, f1(x) = f0(x + s) for some s ∈ G. The purpose is to determine 
the hidden shift s. The problem was solved for many cases, including smoothly solvable groups [FriEtAl2002], bent functions [Röt2008], functions close to a quadratic [Röt2009], Legendre symbol [DamHalIp2002] as well as more  general  multiplicative  characters on  finite  fields and  on  ideals  ℤ 
n ℤ  [DamHalIp2002]. When  G  is abelian, the problem is equivalent to HSP over the generalized dihedral group G⋊ℤN . In particular, for G = ℤN 
the problem is equivalent to DHSP. A decision version is considered in [ChiWoc2005]: either a shift s exists or the images of f0, f1  are disjoint. We are asked to determine in which case we are. A solution to this decision 
version for the symmetric group G = Sn  would provide an efficient algorithm for the rigid graph isomorphism problem. A Generalized Hidden Shift Problem is considered in [ChiDam2005] and solve for the cyclic group G = ℤN  under  certain  conditions.  The  generalization  consists  in  having  M  injective  functions  f0, …, fM − 1 
satisfying ∀ x ∈ G, fi(x) = f0(x + is). Note that the generalized hidden shift problem reduces to HSP over the 
wreath  product  G ≀ ℤM  [FenZha2006].  Hence,  the  two  solutions  to  the  hidden  shift  problem from Rötteler 
mentioned above are particular case of G = ℤ2 n  which is solved from the efficient algorithm he obtained with 
Beth [RötBet1998]. When the functions f0, f1  are  not injective, the set of elements s ∈ G  satisfying the shift 
equality can be proved to be a coset of some subgroup H  [DamHalIp2002]. Finding this set is then called the Hidden  Coset  Problem.  It  turns  out  that  this  problem  is  actually  polynomial-time  equivalent  to  HSP [FenZha2006]. If H  is normal, we can work in the quotient group G H  and reduce the problem to the hidden shift problem [Ip2002], [DamHalIp2002]. 
To solve some HSP instances, Friedl et al. [FriEtAl2002] used several HSP-related problems. In addition to the Hidden Shift Problem discussed above (which is called hidden translation in their paper), they introduced the Hidden Stabilizer Problem, Orbit Coset Problem, and Orbit Superposition Problem. For the first one, we have a group G acting on a set of pairwise orthogonal quantum states. Given such a state we are asked to find its stabilizer subgroup. The second one is a generalization: given two states ∣Ψ0⟩ and ∣Ψ1⟩ we have to answer whether the intersection of their orbits is empty or find an element g ∈ G  sending ∣Ψ0⟩ to ∣Ψ1⟩ as well  as the stabilizer  subgroup  of ∣Ψ1⟩. One  interesting  feature  of Orbit Coset Problem on  a  group  G  is  the  following self-reductibility property: if N  is a solvable normal subgroup of G, then the problem reduces to the Orbit Coset Problem on G N  and on subgroups of N. Notice that such a property would be really appreciated for HSP to design an algorithm similar to the one of figure 6.2. Finally, the Orbit Superposition Problem asks to create the 
50
uniform superposition over the orbit of a given state ∣Ψ ⟩. For solvable groups, it reduces to Orbit Coset Problem. Again, in  [FenZha2006] it is proved that Orbit Coset is polynomial-time equivalent to  the Hidden Subgroup Problem when we allow the oracle f  to be a quantum function. 
As many other problems, decision and search versions of HSP have also been imagined. [FenZha2006] defines HSPD  to  be  the  problem of deciding  whether H  is trivial  and  HSPS  to  be  the  problem of findind  a nontrivial  element of H , if there is one. As we have previously seen, this is of particular importance for the dihedral and symmetric HSP. In the paper, they give a reduction of HSP to HSPD for the dihedral group (under certain conditions) and a polynomial-time equivalence between HSPS  and HSPD  for permutation groups. The latter equivalence suggests that the problem is hard, since we have this property for problems considered to be difficult such that NP-complete or graph isomorphism. Another proposal for a decision version of HSP is the Hidden Subgroup Test Function where we are given G, H , as well as a function f  on G and want to decide whether the function hides the subgroup H . In [AblVas2009], the function f  is encoded as a particular "input sequence". Similarly in [FriEtAl2002bis], the Large Period Problem is studied: we are given G, a subgroup K and a function f . We want to decide whether K  is a proper superset of some subgroup H ⊆ G hidden by f . The problem is solved for abelian subgroups. The paper also defines the Common Coset Range Problem: given H ⊆ G and two functions f0, f1 on G do we have the equality ∀ x ∈ G, f1(xH ) = f0(xH )? Again, the problem is solved for some particular cases. 
Let's consider now the case of the abelian HSP dealing with the vector space G = Fq m over the finite field Fq 
, which is studied in [ChiSchVaz2007]. Any subgroup H  is a linear subspace of G and cosets g + H  are parallel 
affine subspaces. Thus in  the abelian HSP over Fq m  we have an oracle constant on each affine subspace, 
taking  distinct values  on  different ones  and  want to  find  a  subspace  H .  If  H  is  a  hyperplane, there  are 
coefficients qi ∈ Fq  such that the linear polynomial P(x) = ∑ i = 0 
m qi xi satisfies H = KerP. Moreover, P  is constant 
on each coset and takes distinct values on different ones. Thus the oracle can be written f (x) = π(P(x)) for some fixed unknown permutation π  of Fq. The Hidden Polynomial Problem is to determine the polynomial P whose degree is still bounded, but we now allow this degree to be greater than 1. Similarly to the case of the hyperplane H , we assume that the constant term is P(0) = 0, for otherwise that term can not be determined, since  π  is  arbitrary. The  problem can  also  be  viewed  as finding  the  hidden  hypersurface  defined  by  the equation P(x) = 0 and the cosets are replaced by level  hypersurfaces (defined by equations P(x) = k). One special case is when the polynomial is of the form P(x) = xm − Q(x1, …, xm− 1) i.e. the hidden hypersurface is defined by the parametric equation xm = Q(x1, …, xm− 1). In that case, the level hypersurfaces are just obtained by  translating  along  the  xm-axis.  This  problem,  called  Hidden  Polynomial  Function  Graph  Problem  is considered in [DecWoc2007], [DecDraWoc2007] and solved for quadratic and cubic polynomial Q. 
The authors of [ChiSchVaz2007] also consider other hidden structure problems on G = Fq m. They define 
the Hidden Radius Problem: determine an unknown radius r given a blackbox that outputs superposition over the points of a sphere of radius r whose center is chosen uniformly at random. Similarly they define the Hidden Flat of Center: determine a flat given a blackbox that outputs superposition over unit sphere whose center is chosen uniformly at random in the hidden flat. They give a partial solution to the former and a complete solution to the latter. Other algorithms of this kind are given in [Mon2008] for the group G = {0, 1}n. All these problems are included in the more general category of Hidden Shifted Subset Problems. We have a group G, a subset of elements S  and a subset of shifts T  the black box outputs uniform superposition of element over the set S + t for 
51
a t ∈ T  chosen uniformly at random. The purpose is to determine some property of S  or T . To compare their power with the one of a classical computer, we would like an approach similar to HSP where we just have an oracle  f  whose  preimages are  the  possible  superpositions output by the  black box. This  does not seem possible in the general case, since the superpositions considered may intersect but some workarounds are used for the particular problems mentioned above. 
52
7. Conclusion 
In  this  report  we  have  studied  the  Hidden  Subgroup  Problem, whose  solution  for  various  groups  is expected to provide new efficient quantum algorithms. In a first part, we have reviewed the classical efficient Quantum algorithms of Simon and Shor and identified their main features. We have introduced the Hidden Subgroup Problem and showed how the previous algorithms can be defined in that framework. 
In a second part, we have been interested in the standard method based on coset sampling. We have presented the well-known solution to the abelian case which includes the algorithms seen in the first part. We have  described  precisely  a  natural  extension  to  the  non-abelian  case,  by  defining  a  Quantum  Fourier Transform over finite  groups as well  as Weak/Strong Fourier Sampling. We have shown that Weak Fourier Sampling  is able  to  find  normal  hidden subgroups and thus provides a  solution  to  HSP over dedekindian groups.  We  have  mentioned  some  extensions  when  the  group  is,  in  some  sense,  not  too  far  from  a dedekindian group. However, the Weak Fourier Sampling can not distinguish conjugate groups and thus it is not applyable to an arbitrary group. 
In a third part, we have turned our attention to the dihedral and symmetric hidden subgroup problems. We have given a complete presentation of the structure of the dihedral  group and recalled the reduction of the dihedral HSP to the search of a hidden slope d . We have presented Kupenberg's subexponential algorithm to find this slope and mentioned the results about the optimal measurement for dihedral coset sampling. We have studied Regev's algorithm for the uniqueSVP and noticed that it can be modified to work for some generalized dihedral groups and "recursive" coset sampling. We have also shown that the approximation factor obtained for the  uniqueSVP is  strongly  related  to  the  degree  of the  polynomial  bounding  the  complexity  of the  coset sampling  algorithm used.  Finally,  we  have  presented  the  classical  reduction  from graph  isomorphism to symmetric hidden subgroup problems but have also recalled the negative results on the symmetric group: we need at least a linear number of entangled coset states at once but using an algorithm similar to Kupenberg's one does not help. 
In the fourth and last part, we have considered the general HSP. We have suggested a general approach to the hidden subgroup problem based on the mathematical description of finite groups. We have shown that we could reduce the general case to a solution over simple groups and construction of some efficient oracles. These two points are precisely where we are stuck on for dihedral and symmetric groups. However, several efficient algorithms have been discovered for other non-abelian groups. We have given an overview of these solutions which are essentially with respect to "almost abelian" groups in some sense or the other. We have described some efficient algorithms with concrete application, including applications in cryptography, which are related to the hidden subgroup problem. Finally, we have mentioned variants and extensions to the HSP which have been solved for some particular cases and are expected to yield new efficient quantum algorithms. 
As a conclusion, we have provided a good overview of the hidden subgroup problem going from its origin to the state of the art as of 2010. We have also brought some contributions to the topic. While the general problem still  remains difficult, we hope that our work will  help people to have a better understanding of the subject and guide them toward some research directions. 
53
Appendix 
Appendix A: Table of Hidden Subgroup Problems 
In the description, we give the underlying group G  as well  as the expected complexity poly(log∣G∣) of an efficient algorithm. For convenience, the letters p, pi, q denote prime numbers. Otherwise, letters are chosen to 
give an indication of their magnitudes with respect to the size of the group: capital letters N , M , Ni  are O(∣G∣), minuscule  letters  n, m  are  O(log∣G∣)  and  k  is  a  constant O(1).  When  some  homomorphisms φ  used  for  a semi-direct product are explicitly given, it means that they do not cover all  the possibilities unless otherwise specified. 
Note:  some  notions  and  techniques  are  defined  elsewhere  in  this  report.  For  blackbox  groups,  this includes unique encoding and input size (definition 3.7), v(G) (definition 6.5) and smoothly solvable (definition 6.6). 
Name Description Examples and applications 
Methods and remarks References 
Cyclic HSP 
G ≅ ℤN 
Polynomial in log N 
Shor's factoring algorithm Order of elements in a group Decomposition of abelian group 
Enumeration of Subgroups, Fourier Sampling over cyclic group For review, see for instance 
this report, [Dam2001], [Lom2004] or [NieChu2007] 
See also [Sim1994] and [Sho1995], [Kit1995] 
To determine the decomposition see [CheMos2001]Abelian HSP 
Abelian group i.e. 
G ≅ ℤN1 ×ℤN2 
×ℤN3 ×…×ℤNn 
Polynomial in log N1, …, log Nn 
Cyclic HSP Simon's problem Discrete logarithm 
Fourier Sampling over abelian group 
We assume we know the decomposition of the group. We can determine it if the group is given as a black-box with unique encoding 
Hamiltonian HSP 
Hamiltonian groups i.e. G = 
ℤ2 n 
×A×ℚ8 where A is an 
abelian group with all elements of odd order 
Polynomial in n, log∣∣A∣∣ 
Weak Fourier Sampling Solved in [HalRusTa-2000] 
Dedekindian HSP and extensions. 
G has only normal subgroups i.e. abelian or hamiltonian 
Extensions: 
Finding a normal subgroup H 
A group G such that ∣G∣ 
∣∣MG ∣∣ 
∈ poly(log∣∣G∣∣) 
Abelian HSP Hamiltonian HSP 
Weak Fourier Sampling 
Some extensions use Weak Fourier Sampling over subgroups of G 
Extensions are given in an "abstract" way. We assume an efficient implementation of Weak Fourier Sampling as well 
Solved in [HalRusTa-2000] 
Extensions in [GriSchVaz2000] and [Gav2004] 
See also blackbox groups in [IvaMagSan2001] 
54
Name Description Examples and applications 
Methods and remarks References 
Finding a subgroup H such that 
∣G∣ 
∣∣H MG ∣∣ 
∈ poly(log∣∣G∣∣) 
as a way to solve the systems ρi(h) = Idρi 
 for 
the representations measured ρi 
In the context of a blackbox group, a normal subgroup H can always be found wih complexity the input size + v(G H ) 
Dihedral HSP 
G = DN ≅ ℤN⋊φℤ2 where 
φ(b)(a) = (−1)ba for all 
(a, b) ∈ G 
Polynomial in log N 
Θ ( n 
1 
2 +2D 
) 
-uniqueSVP if solved by a "classpreserving recursive algorithm" DCP algorithm of query 
complexity O(n D 
) 
Enumeration of Subgroups, Quotient Group Reduction, Subgroup Reduction, Cyclic Fourier Sampling on ℤN×{0} or Weak 
Fourier Sampling to find r, Abelian Fourier Sampling on the direct product to reduce the problem to DCP, Pipeline of coset states to get subexponential algorithms, Pretty good measurement, Superposition of many oracle values 
To get the uniqueSVP algorithm, it is enough 
to consider N = 2 n 
See [EttHøy1998], 
[Kup2003] and [Reg2004] 
Relation to uniqueSVP in [Reg2003] and this report 
See this report for the relation with the degree of query complexity as well as what is meant by a "classpreserving recursive algorithm" 
See appendix G for a 
solution to the case N = 2 n 
assuming that we have an efficient process to create for a given b ∈ ℤ2 the 
superpositions of oracles values ∣ f (2i, b)⟩, i ∈ ℤ 
2n−1Generalized dihedral HSP over 
ℤN n 
G = Dih(ℤN n 
) = ℤN n 
⋊φℤ2 where 
φ(b)(a) = (−1)ba for all 
(a, b) ∈ G 
Polynomial in n, log N 
To get the uniqueSVP algorithm, it is enough 
to consider N = 2 4n 
Semidirect HSP ℤN⋊φℤM 
ℤN⋊φℤq with Nq = poly(log N ) 
Polynomial in log N , log q 
Dihedral HSP Quasi-dihedral HSP q-hedral groups 
ℤN⋊φℤq 
Aff(1, p) ≅ 
ℤp⋊φℤ p−1 
quotient group reduction, pretty good measurement, Strong Fourier Sampling 
Solved in [BacChiDam2005bis] 
See also [MooEtAl2005] for results on q-hedral group and 
Aff(1, ℤp) 
See [GriSchVaz2000] for ℤ3⋊φℤ2n 
55
Name Description Examples and applications 
Methods and remarks References 
ℤ3⋊φℤ2n  where 
φ(b)(a) = 2 ba for 
(a, b) ∈ G (the only possible non-trivial semi-direct product) 
G = ℤpn⋊φℤq 
Polynomial in n, log p, log q 
All these semi-direct products 
satisfy φ(b)(a) = a(φ(1)(1))b for 
all (a, b) ∈ G 
Moreover, they belong to one of these disjoint classes: 
n ≥ 1 and q ∣ p − 11. 
Dihedral group D2n ≅ 
ℤ2n⋊φℤ2 and φ(1)(1) = 
2 n − 1 
2. 
Quasi-dihedral group QD2n ≅ ℤ2n⋊φℤ2 and 
φ(1)(1) = 2 n−1 − 1 
3. 
P p, n ≅ ℤpn⋊φℤp where 
φ(1)(1) = t p n−1 + 1, pn 
≠ 2 2 and 0 < t < p 
4. 
Direct product ℤpn×ℤq 
i.e. φ(1)(1) = 1 
5. 
For class 4: enumeration of subgroups, blackbox methods, pretty good measurement 
See [InuLeG2004] for the classification 
Class 1 solved when p n 
q = 
poly(n, log p) in [BacChiDam2005bis] 
Class 4 solved in [InuLeG2004] 
Class 5 solved by abelian HSP 
G = ℤ2pn⋊φℤp where φ(b)(a) 
= a(t p n−1 + 1) 
b, p odd and 0 
< t < p 
(these are the only possible non-trivial semi-direct product) 
Polynomial in n, log p 
enumeration of subgroups, blackbox methods. 
Solved in [InuLeG2004] and [ChiKimLee2006] 
G = ℤN⋊φℤp with the 
factorization N = ∏i =1 n 
p i 
ri  and 
an odd p which does not divide 
pi − 1. 
Polynomial in log N , log p 
enumeration of subgroups, blackbox methods. 
Solved in 
[ChiKimLee2006] 
G = ℤN⋊φℤ p2  with the 
factorization N = ∏i =1 n 
p i 
ri 
such that ri > 4 and an odd p 
which does not divide pi − 1. 
enumeration of subgroups, blackbox methods. 
Solved in [CosPor2007] 
56
Name Description Examples and applications 
Methods and remarks References 
Polynomial in log N , log p 
Semidirect HSP 
ℤN n 
⋊φℤM 
G = ℤp k 
⋊φℤp 
Polynomial in log p 
Semidirect HSP ℤN⋊φℤM 
Generalized dihedral HSP over 
ℤN n 
Heisenberg HSP i.e. over the only non-trivial semi-direct 
product ℤp 2⋊ℤp 
pretty good measurement 
Solved in [BacChiDam2005bis] 
See also [RadRöeSen2005] for Heisenberg group 
G = ℤ pk n 
⋊φℤ2 
Polynomial in n, log p 
blackbox methods Solved in [FriEtAl2002] 
G = ℤ pm n 
⋊φℤp where (φ(b)(a))i 
= ai(p n−1 + 1) 
b 
Polynomial in n, m, log p 
blackbox methods Solved in [InuLeG2004] 
G = ℤ2 n 
≀ ℤ2 = (ℤ2 n 
×ℤ2 n 
)⋊φℤ2 
where φ(c)(a, b) = τc (a, b) and τ permutes the two coordinates. 
Polynomial in n 
Fourier Sampling over abelian subgroup, Weak Fourier Sampling 
Solved in [RötBet1998] 
Semidirect HSP 
A⋊φℤN 
G = A⋊φℤN where A ≅ 
ℤN1 ×ℤN2 
×ℤN3 ×…×ℤNn  is 
abelian 
Polynomial in log N1, …, log Nn 
, log N 
Generalized dihedral HSP i.e. N = 2 and φ(b)(a) 
= (−1)ba for all 
(a, b) ∈ G . Also called Hidden Shift Problem over an abelian group A Semidirect HSP 
ℤN n 
⋊φℤM 
pretty good measurement 
Unsolved 
See [BacChiDam2005bis] when N  is a prime 
p-group HSP 
G is a p-group i.e. all elements 
are of order a power of p 
D2n  and 
Dih(ℤ 24n n 
), which 
are the cases relevant for the polynomial uniqueSVP algorithm Heisenberg HSP Weyl-Heisenberg HSP 
blackbox methods, hiding procedure 
Unsolved 
Solved in [IvaSanSan2007bis] for p -group of nilpotency class 2 
See also [IvaSanSan2007] for extraspecial HSP and [KroRöt2008] for Weyl-Heisenberg HSP 
57
Name Description Examples and applications 
Methods and remarks References 
G = ℤp n+1 
⋊φℤp n 
where φ(x )(y) = 
In 0 
x t 1 
⎛ 
⎝ 
⎜ ⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ ⎟ y 
Extraspecial HSP i.e. the commutator, center and Frattini subgroup of G are equal and of order p 
nilpotent HSP 
G is nilpotent i.e. there is m 
such that Am+1 = {1} for the 
sequence A1 = G, Ai +1 = 
[Ai , G] 
p-group HSP 
blackbox methods , hiding procedure 
Can be reduced to the p -group HSP if we can determine the decomposition of G as a product of its Sylow subgroups. 
Unsolved 
Solved in [IvaSanSan2007bis] for nilpotent group of class m = 
2 
solvable HSP 
G is solvable i.e. there is m 
such that G (m) = {1} for the 
sequence G (0) = G, G (i +1) = 
(G (i) 
) ' 
nilpotent HSP In black box with unique encoding, It is possible to create coset states. 
Unsolved 
See some algorithms in [Wat2000] and [IvaEtAl2001] 
Solved in [FriEtAl2002] for smoothly solvable groups having a smoothly solvable commutator subgroup. 
Symmetric HSP. 
G = Sn ≀ ℤ2 = (Sn×Sn)⋊φℤ2 
where φ(c)(a, b) = τc (a, b) and τ permutes the two coordinates. 
Polynomial in n log n 
rigid graph isomorphism problem 
For the rigid graph isomorphism, we can restrict to n even and distinguishing the cases H trivial (the graphs are 
not isomorphic) or H = { 
Id, (a, a−1, 1)} where 
a ∈ Sn /2 is an 
isomorphism between the two graphs. 
A solution by coset sampling using an arbitrary POVM would require Ω(n log n) 
entangled state at once. In particular, Strong Fourier Sampling fails. 
Unsolved 
See [MooRusSch2005] and [HalRoeSen2005] 
58
Name Description Examples and applications 
Methods and remarks References 
G = Sn 
Polynomial in nlog n 
graph isomorphism problem Alternating HSP 
Sn ≀ ℤ2 and An are 
subgroups of S2n so a 
solution of HSP over the whole symmetric group implies a solution over Sn ≀ ℤ2 and An. 
Alternating HSP 
G = An 
Polynomial in nlog n 
rigid graph isomorphism problem 
For the rigid graph isomorphism, we can restrict to n even and distinguishing the cases H trivial (the graphs are 
not isomorphic) or H = { 
Id, (φ, φ−1 )σ} where 
a ∈ An /2 is an 
isomorphism between the two graphs and σ is the product of transpositions 
∏i =1 n /2 
(i, i + n 
2) 
Unsolved 
See this report for a reduction of the graph isomorphism problem for rigid graphs 
Wreath HSP 
F ≀ ℤm 
G = Fm⋊φℤm  where 
φ(b) applies a permutation σb to 
the m first coordinates and σb is 
an element of S∣F ∣ identified 
with x ↦ b x 
Polynomial in m, log(∣∣F∣∣) 
Hidden Shift Problem over F for 
m = 2 
Generalized Hidden Shift Problem over F rigid graph isomorphism problem for m = 2 
and F = Sn 
For m = 2 and G = 
ℤp solve the 
shifted Legendre symbol Problem. 
Some solutions exist for the related hidden shift problems. 
Unsolved. 
Solved in [RötBet1998] for F 
= ℤ2 n and m = 2. 
Affine HSP 
G = Aff(n, pm) = 
F pm n ⋊GL(n, pm) 
Polynomial in n, m, log p 
Aff(1, p) = 
ℤp⋊φℤ p−1 i.e. n 
= m = 1 
Aff(1, pm) i.e. n 
= 1 
Strong Fourier Sampling 
Unsolved 
Solved for n = m = 1 in [MooEtAl2005] 
See also some particular cases for n = 1 in [DenMooRus2008] 
Lie HSP G is a finite Lie group. 
General linear 
groups GL(n, pm). Special linear 
Strong Fourier Sampling 
Unsolved 
Solved for 1-point stabilizer 
subgroups of SL(2, pm), 
59
Name Description Examples and applications 
Methods and remarks References 
groups SL(n, pm) 
Projective general linear group 
PGL(n, pm) 
Projective special linear group 
PSL(n, pm) 
PGL(2, pm), PSL(2, pm) in [DenMooRus2008] 
Simple HSP 
Simple group G i.e. without any 
normal subgroup other than {1} 
, G: 
Cyclic groups ℤp for p 
prime. 
1. 
Alternating groups An for 
n ≥ 5. 
2. 
Simple groups of Lie type. 
3. 
26 sporadic simple groups. 
4. 
Cyclic HSP: ℤn 
for a prime n Alternating HSP: An 
PGL(2, pm) 
Could be a key step for solving the general HSP 
A possible approach could be to use (maximal) subgroup reduction. 
Unsolved. 
Solved for cyclic groups of prime order 
Solved for 1-point stabilizer 
subgroups of PGL(2, pm) in [DenMooRus2008] 
See this report for the relation with general HSP and subgroup reduction 
General HSP 
Arbitrary finite group G. 
Finding quantum algorithms exponentially faster than their classical counterparts 
We know that a polynomial number of oracle calls is enough to build a state that identifies the hidden subgroup. In the context of blackbox with unique encoding, solvable with complexity input size + size of the commutator group A possible approach could be a combination of quotient and subgroup reductions as well as solving the simple HSP. 
Unsolved 
Polynomial query-complexity in [EttHøy1998] 
See [IvaMagSan2001] for some black box results 
See this report for a suggestion toward a solution 
60
Appendix B: Strong Fourier Sampling and the DHSP 
In this section, we study the Fourier Sampling over the Dihedral group. We describe all the possible cases of the Strong Fourier Sampling, show the relation to the dihedral coset problem and in particular how to recover the algorithm of [EttHøy1998]. This similarity between Strong Fourier Sampling and dihedral coset sampling has already been noticed in [Kup2003] and [BacChiDam2005]. 
We  consider  a  complete  set of pairwise  non-isomorphic  representation, adapted  from 5.3  Le  groupe diédral Dn  of [Ser1971]. If we let ωN = ⅇ 
2ⅈ π N , we define the 2-dimensional irreducible representations τ k(a, 0) 
= 
ω N 
−ka 0 
0 ω N 
ka 
⎛ 
⎝ 
⎜ ⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ ⎟  and τ k(a, 1) = 
0 ω N 
−ka 
ω N 
ka 0 
⎛ 
⎝ 
⎜ ⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ ⎟  for 0 < k < N 
2 . We have two 1-dimensional irreducible representations 
Ψ0(a, b) = 1  and  ψ1(a, b) = (−1)b.  In  the  case  where  N  is  even,  we  need  to  add  two  1-dimensional 
representations to  get a  complete  set: Ψ2(a, b) = (−1)a  and  Ψ3(a, b) = (−1)a+b . We  start with  the  case  H = 
⟨(d , 1)⟩. 
Lemma 9.1 (distribution probability of the Weak Fourier Sampling) 
The distribution probability of the Weak Fourier Sampling over DN  for the hidden subgroup H = ⟨(d , 1)⟩ is given by 
P(ψ0) = 1 N 
P(ψ1) = 0 
P(ρ) = 2 N 
 for any 2-dimensional irreducible representation ρ ∈ Ĝ 
and moreover if N is even 
P(ψ2) = 
⎧ 
⎨ 
⎩ 
⎪ 
⎪ 
0 if d  is odd 
1 N 
if d  is even 
P(ψ3) = 
⎧ 
⎨ 
⎩ 
⎪ 
⎪ 
1 N 
if d  is odd 
0 if d  is even 
proof: This is a straightforward application of formula 4.20. For the 1-dimensional representations we have Ψ2(H ) = 1 
2√ (Ψ2(0, 0) + ψ2(d , 1)) = 1 
2√ (1 + (−1)d) is 0 if d  is odd and 2√  otherwise, so P(ψ2) = 1 2 N 
2√ Ψ2(H ) is as 
claimed. The cases of ψ0, ψ1, ψ3 are similar. Any 2-dimensional irreducible representations ρ ∈ Ĝ  is isomorphic 
to some τ k  i.e. satisfies ρ(g) = Mτ(g)M−1 for some matrix M. We have τ k(H ) = 1 
2√ 
1 ω N 
−kd 
ω N 
kd 1 
⎛ 
⎝ 
⎜ ⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ ⎟  so P(ρ) = 2 
2 N 2√ tr 
(ρ(H )) = 2√ 
N tr(τ 
k(H )) = 2√ 
N 2 
2√ = 2 
N . □ 
In the probability distribution, measuring a 2-dimensional irreducible representations gives no indication 
61
over H : they all  have equal  probability 2 N 
 to  be observed whatever the value of d. Measuring ψ0  yields no 
information either and so if N  is odd, the Weak Fourier Sampling fails. If N  is even, we can only get the parity of d, if we observe ψ2 or ψ3 . Nevertheless, since these representations are measured with a very small probability the Weak Fourier Sampling provides essentially no information: 
Theorem 9.2 (Weak Fourier Sampling fails over DN ) 
Suppose we take M  samplings of the Weak Fourier Sampling over DN  for a hidden subgroup H = ⟨(d , 1)⟩. 
If N is odd, then we get no information on d. If N  is even, the best we can get is the parity of d . If M = poly(log (N)), this information is obtained with a 
success probability exponentially close to 0 i.e. less than K ⅇ− λ log(N ) for some constants K , λ > 0. 
proof: If N  is odd, the distribution probability is entirely independent of d  and so it is impossible to get any information from the samplings. If N is even, the only thing we can know is whether d is even (if we measure ψ2) 
or odd (if we measure ψ3). If we have M(N) samplings this happens with probability P(N) = 1 − (1 − 1 N) 
M (N ) . We 
have: 
P(N) = 1 − ( 
1 − 1 
N) 
M (N ) 
= 1 − exp ( 
ln ( 
1 − 1 
N) M(N) 
) 
= 1 − exp (( 
− 1 
N + o 
( 
1 
N)) M(N) 
) 
= 1 − exp ( 
− M(N) 
N + o 
( 
M(N) 
N )) 
= 1 − ( 
1 − M(N) 
N + o 
( 
M(N) 
N )) 
= M(N) 
N (1 + o(1)) 
= M(N) 
N (1 + ε(N)) 
(9.1) 
where  ε(N) ⎯ →⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯ N → + ∞ 
0. In  particular, there  is K ' > 0  such that (1 + ε(N)) < K '. Similarly, if M = poly(log(N)) 
then M(N)2 − 
log(N) 
2 ⎯ →⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯ N → + ∞ 
0. So there is K ' ' > 0 such that M(N)2 − 
log(N) 
2 < K ' '. Thus M (N ) 
N = M(N)2 
− log(N) 
2 2 − 
log(N) 
2 < 
K ' '2 − 1 
2 log(N ). Finally, we get P(N) < K 'K ' '2 
− 1 2 
log(N ) = K ⅇ− λ log(N ) (with K = K 'K ' ' and λ = ln2 
2 ). □ 
What about the Strong Fourier Sampling? To answer this question, we need to describe all possible matrix representations of irreducible  2-dimensional  representations. We  know  at least one  complete  set of such 
62
representations given by τ k  and we will use proposition 4.7. So we must enumerate all the unitary matrices of dimension 2: 
Proposition 9.3 (unitary matrices of dimension 2) 
The unitary matrices of dimension 2 are the matrices 
U = ⅇⅈ γ cos(θ) sin(θ)ⅇⅈα 
sin(θ)ⅇⅈ β −cos(θ)ⅇⅈ (α+ β) 
⎛ 
⎝ 
⎜ ⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ ⎟ 
for α, β , γ , θ ∈ ℝ. 
proof: First of all, such a matrix U  is clearly hermitian since its columns are orthonormal. Now, suppose U 
= r11 ⅇⅈθ11 r12 ⅇⅈθ12 
r21 ⅇⅈθ21 r22 ⅇⅈθ22 
⎛ 
⎝ 
⎜ ⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ ⎟ 
 is unitary. Then because the columns/rows are orthonormal we have r 11 2 + r 
12 2 = r 
11 2 + r 
21 2 = 
r 22 2 + r 
12 2 = r 
22 2 + r 
21 2 = 1 so there exists θ ∈ ℝ such that r11 = r22 = cos(θ) and r12 = r21 = sin(θ). The orthogonality of 
the  column gives sin θcos θ(ⅇⅈ (θ12 −θ11) + ⅇⅈ (θ22 −θ21) ) = 0. The  cases sin θ = 0  and  cos θ = 0  are  included  in  the 
general expression of U . Otherwise, we have θ12 − θ11 ≡ θ22 − θ21 + π  mod (2π). If we let γ = θ11, α = θ12 − γ , β = 
θ21 − γ  we have ⅇⅈ (θ22 − γ) = −ⅇⅈ (α+ β) and we get the expression of the statement. □ 
For any 2-dimensional  irreducible representation ρ isomorphic to some τ k, the matrix representation of 
ρ(0, 0) is always the identity. Thus for H = ⟨(d , 1)⟩, all we need in order to compute ρ(H ) is ρ(d , 1) = Uτ k(d , 1) 
U †. It is easy to get an explicit formula, as given in the following lemma. 
Lemma 9.4 
For any representation ρ such that ρ(d , 1) = Uτ k(d , 1)U † for some unitary matrix U = u11 u12 
u21 u22 
⎛ 
⎝ 
⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟  we have 
ρ(H ) = 1 
2√ 
1 + x z 
z * 1 − x 
⎛ 
⎝ 
⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ 
where x = 2Re(u12u11 * ω 
N 
kd ) ∈ ℝ and z = u12u21 
* ωkd + u11u22 * ω−kd . 
proof: This is just a matrix product: 
63
ρ(d , 1) = 
⎛ 
⎝ 
⎜ ⎜ 
u11 u12 
u21 u22 
⎞ 
⎠ 
⎟ ⎟ 
⎛ 
⎝ 
⎜ ⎜ ⎜ 
0 w N 
−kd 
w N 
kd 0 
⎞ 
⎠ 
⎟ ⎟ ⎟ 
⎛ 
⎝ 
⎜ ⎜ ⎜ 
u11 * u21 
* 
u12 * u22 
* 
⎞ 
⎠ 
⎟ ⎟ ⎟ 
= 
⎛ 
⎝ 
⎜ ⎜ ⎜ 
(u12wN 
kd ) (u11wN 
−kd ) 
(u22wN 
kd ) (u21wN 
−kd ) 
⎞ 
⎠ 
⎟ ⎟ ⎟ 
⎛ 
⎝ 
⎜ ⎜ ⎜ 
u11 * u21 
* 
u12 * u22 
* 
⎞ 
⎠ 
⎟ ⎟ ⎟ 
= 
⎛ 
⎝ 
⎜ ⎜ ⎜ 
(u11 * u12wN 
kd + u11u12 * w 
N 
−kd ) (u12u21 
* w N 
kdu11u22 * w 
N 
−kd ) 
(u11 * u22wN 
kdu12 * u21wN 
−kd ) (u21 
* u22wN 
kdu21u22 * w 
N 
−kd ) 
⎞ 
⎠ 
⎟ ⎟ ⎟ 
= 
⎛ 
⎝ 
⎜ ⎜ 
x z 
z * −x 
⎞ 
⎠ 
⎟ ⎟ 
(9.2) 
where we have used the relation of orthogonality u 11 * u12 + u 
21 * u22 = 0 in the last line. 
Finally ρ(H ) = 1 
2√ (ρ(0, 0) + ρ(d , 1)) = 1 
2√ 
⎛ 
⎝ 
⎜ ⎜I + 
x z 
z * −x 
⎛ 
⎝ 
⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ 
⎞ 
⎠ 
⎟ ⎟ = 1 
2√ 
1 + x z 
z * 1 − x 
⎛ 
⎝ 
⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟. □ 
Now, using  proposition  9.3, we  can  simplify  the  expression  of x, z  above  and  get the  corresponding probability P(ρ, ., j): 
Proposition 9.5 
For  any  representation  ρ  such  that  ρ(d , 1) = Uτ k(d , 1)U †  for  some  unitary  matrix  U = ⅇⅈ γ 
cos(θ) sin(θ)ⅇⅈα 
sin(θ)ⅇⅈ β −cos(θ)ⅇⅈ (α+ β) 
⎛ 
⎝ 
⎜ ⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ ⎟ 
 we have 
P(ρ, ., j) = 1 
N ( 1 + (−1) j+ 1sin(2θ)cos 
( 
2π 
N kd + α 
)) (9.3) 
proof: We let θ ' = 2π N kd + α. With the notation of the previous lemma, we have x = 2Re(sin θcos θ ⅇⅈα ω 
N 
kd ) = 
sin(2θ)cos(θ ')  and  z = sin2 θ ⅇⅈ (α− β) ω N 
kd − cos2 θ ⅇ−ⅈ(α+ β) ω N 
−kd = ⅇ−ⅈ β (sin2 θ ⅇⅈα ω 
N 
kd − cos2 θ ⅇ−ⅈα ω N 
−kd ).  We  can 
write: 
sin2 θ ⅇⅈα ω N 
kd − cos2 θ ⅇ−ⅈα ω N 
−kd = 
⎧ 
⎨ 
⎩ 
⎪ 
⎪ 
ⅇⅈθ ' − 2cos2 θcos(θ ') 
2sin2 θcos(θ ') − ⅇ−ⅈθ ' (9.4) 
so taking half the sum of the two expressions: 
64
sin2 θ ⅇⅈα ω N 
kd − cos2 θ ⅇ−ⅈα ω N 
−kd = 1 
2 (2(sin2 θ − cos2 θ)cos(θ ') + ⅇⅈθ ' − ⅇ−ⅈθ ' 
) = −cos(2θ)cos(θ ') + ⅈsin(θ ') (9.5) 
If ± is plus if j = 1 and minus if j = 2 we have: 
∥∥ 2√ ρ(H )j ∥∥ 
2 = ∣z∣2 + (1 ± x)2 
= (cos2(2θ)cos2θ′ + sin2θ′) + (1 ± 2sin(2θ)cosθ′ + sin22θcos2θ′) 
= 2(1 ± sin2θcosθ′) 
(9.6) 
using formula 4.23 we finally conclude: 
P(ρ, ., j) = 2 2 N 
(1 ± sin2θcosθ′) = 1 N (1 + (−1) j+ 1sin(2θ)cos( 
2π N kd + α)). □ 
Note that parameters β , γ  do not appear in the probability expression P(ρ, ., j). Also sin(2θ) is really just a parameter between [ − 1; + 1] and we can restrict this value to a smaller interval by playing with α. Finally, we can sum up the distribution probabilities of Strong Fourier Sampling for H = ⟨(d , 1)⟩, in a very simple manner: 
Theorem 9.6 (distribution probability of the Strong Fourier Sampling) 
The possible distribution probabilities of a Strong Fourier Sampling over DN  for the hidden subgroup H = 
⟨(d , 1)⟩ are given by: 
P(ψ0) = 1 N 
, P(ψ1) = 0. 
If N is even P(ψ2) = 
⎧ 
⎨ 
⎩ 
⎪ 
⎪ 
0 if d  is odd 
1 N 
 if d  is even  and P(ψ3) = 
⎧ 
⎨ 
⎩ 
⎪ 
⎪ 
1 N 
 if d  is odd 
0 if d  is even 
. 
For 0 < k < N 2 , P(ρ 
k , ., j) = 1 N (1 + (−1) j λkcos( 
2π N kd + μk)) with λk ∈ [0,1] and μk ∈ [0,2π) 
Moreover, such a distribution is obtained by taking αk = μk + π, θk = arcsin(λk ) 
2  and Uk = 
cos θk sin θk ⅇⅈαk 
sin θk −cos θk ⅇⅈαk 
⎛ 
⎝ 
⎜ ⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ ⎟ 
as change-of-basis matrix in each Vτk : ∀ g ∈ Gρk(g) = Ukτ k(g)Uk 
†. 
proof: The case of 1-dimensional representation is as in lemma 9.1. Let ρk  (0 < k < N 2 ) a complete set of 
2-dimensional irreducible representations. We may assume that each ρk  is isomorphic to τ k. By proposition 4.7 
there are unitary matrices Uk such that ρk(d , 1) = Ukτ k(d , 1)U 
k 
†. By , the distribution probability is: 
P(ρ k , ., j) = 
1 
N ( 1 + (−1) j+ 1sin(2θk)cos 
( 
2π 
N kd + αk)) 
(9.7) 
where θk , αk  are the coefficients in Uk  as given in proposition 9.3. We can make this expression in the form of the statement by taking λk = ∣sin(2θk)∣ and (according to the expected sign) μk = αk  or μk = αk + π  (modulo 2π ). 
65
Conversely, it is easy to check that for the ρk  given at the end of the statement, we find the probability with the correct λk , μk. □ 
It is worth noting some facts about these distribution probabilities. As in the Weak Fourier Sampling ψ0, ψ 1 
are useless. ψ2, ψ 3 give the parity of d, but since they are observed with exponentially small probability we can 
ignore  them when  designing  an  efficient algorithm based  on  Strong  Fourier Sampling. The  2-dimensional irreducible representations have equal probability 1 
2 N  to be observed and for each of them we can spread the 
probability between the two columns. We have only two degrees of freeness to do that: deciding how much the probability of the two columns differ in the extremal cases (amplitude parameter λk) and moving this extremal 
cases (phase parameter αk). Note that taking αk = 2π N kd ' allows to have control over d. Since each ρk  has very 
small  probability to be measured, an efficient algorithm for DHSP needs to consider them as a whole (or at least to consider an exponential number of them). Some attempts are given in Appendix C and where we also give some hints on why the Strong Fourier Sampling approach is likely to  fail. Note however, that using a particular basis, we recover the distribution of theorem 9.6 and so the algorithm on which it is based: 
Proposition 9.7 
Take λ = 1 and μ = − π  in the theorem 9.6 (this corresponds to ρ(g) = Hτ k(g)H ). Apply a Strong Fourier Sampling and return the following value: 
If ψ0 is measured, return (0, 0) 
If ψ2 or ψ3 is measured (so in the case where N is even), return ( N 2 
, 1) 
If ρk , j is measured, then flip a coin (or measure an EPR state) to decide to return (k, j − 1) 
or (N − k, j − 1) 
Then the distribution probability of the returned value is the same as in formula 5.9. 
proof: Let k ' denote the parameter in formula 5.9. In the degenerated case k ' = 0 (respectively k ' = N 2 ) (k ', 0) 
(respectively (k ', 1)) is returned with probability 1 N 
 and (k ', 1) (respectively (k ', 0)) with probability 0. Since ψ0 
and ψ2 ∪ ψ3 happens both with probability 1 N 
, we get the same result by returning the values of the statement. 
Now, note that for any 0 < k ' < N 2 
 (i.e. N 2 
< N − k ' < N), the probability to return (k ', j) is the same as the 
probability  to  return  (N − k ', j)  in  formula  5.9.  This  is  because  cos2 ( π N 
(N − k ')d) = ((−1)dcos( − π N k ')) 
2 = 
cos2 ( π N k 'd) and similarly for sin. By theorem 9.6, the probability distribution of the Strong Fourier Sampling for 
the 2-dimensional ρk is: 
P(ρ k , ., 1) = 1 
N (1 + cos( 2π N kd)) = 2 
N cos2 
( π N kd) 
P(ρ k , ., 2) = 1 
N (1 − cos( 2π N kd)) = 2 
N sin2 
( π N kd) 
so taking half these values and sharing between k or N − k we recover formula 5.9. □ 
66
Corollary 9.8 (Strong Fourier Sampling solves dihedral HSP) 
It is possible to solve the HSP over DN  using only a poly(log N) number of Strong Fourier Samplings (but an exponential post-processing) 
proof: use the previous proposition to simulate the distribution of formula 5.9 and apply the algorithm of Ettinger and Høyer. □ 
The  previous corollary shows that to  extract information, the  Strong  Fourier  Sampling  is  indeed  more powerful  than the Weak Fourier Sampling. Another well-known fact (see [GriSchVaz2000]) is that a random choice for the basis of Strong Fourier Sampling is not helpful. Intuitively, this can be seen in the expression of theorem 9.6: with a uniform choice of the phase αk ∈ [0,2π) we are totally blurring the parameter d . A random 
approach could still be useful, for instance randomly choosing αk = 2π N kp for an even integer p leaves only the 
parity of d. Again, see Appendix C to get some arguments about why this is likely to fail. 
proposition 5.2 indicates that solving DHSP by a Fourier Sampling over H = ⟨(d , 1)⟩ yields an algorithm in the most general case. However, it could be possible that the Fourier Sampling can not solve the case H = 
⟨(d , 1)⟩ while still  being able to find other hidden subgroups H . We could even hope that DHSP reduces to these subgroups. The next theorem clarify this: 
Theorem 9.9 (distribution probabilities of the Fourier Sampling) 
Let Sr = {N r , 2 N 
r …, ⎡⎢r 
2 − 1⎤⎥ 
N r }. The possible distribution probabilities of Fourier Sampling are: 
For H = Hr 
P(ψ0) = P(ψ1) = 1 2r 
P(ψ2) = P(ψ3) = 
⎧ 
⎨ 
⎩ 
⎪ 
⎪ 
1 2r 
 if r is even 
0  if r is odd 
For 0 < k < N 2 , P(ρ 
k , ., j) = 
⎧ 
⎨ 
⎩ 
⎪ 
⎪ 
1 r 
if k ∈ Sk 
0 otherwise 
 . In particular, P(ρ k ) = 
⎧ 
⎨ 
⎩ 
⎪ 
⎪ 
2 r 
 if k ∈ Sk 
0 otherwise 
1. 
For H = Hr , d 
P(ψ0) = 1 r 
P(Ψ1) = 0 
P(ψ2) = 
⎧ 
⎨ 
⎩ 
⎪ 
⎪ 
1 r 
 if r and d  are even 
0 otherwise 
P(ψ3) = 
⎧ 
⎨ 
⎩ 
⎪ 
⎪ 
1 r 
 if r is even and d  is odd 
0 otherwise 
2. 
67
For  0 < k < N 2 ,  P(ρ 
k , ., j) = 
⎧ 
⎨ 
⎩ 
⎪ 
⎪ 
1 r (1 + (−1) j λkcos( 
2π N kd + μk)) if k ∈ Sk 
0 otherwise 
 (where  λk ∈ [0,1]  and 
μk ∈ [0,2π]). In particular, P(ρ k ) = 
⎧ 
⎨ 
⎩ 
⎪ 
⎪ 
2 r 
 if k ∈ Sk 
0 otherwise 
. 
The λk , μk can be obtained by the same change-of-basis as in theorem 9.6. 
proof: The proof is very similar to the one of theorem 9.6 so we do not give all the detail here. One can 
check that ρk(Hr) = 1 
∣Hr ∣√ Uk 
⎛ 
⎝ 
⎜ ⎜ ⎜ ⎜ 
∑l = 0 
N r − 1 (ωN 
−kr ) l 
0 
0 (ωN 
kr ) l 
⎛ 
⎝ 
⎜ ⎜ ⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ ⎟ ⎟ 
⎞ 
⎠ 
⎟ ⎟ ⎟ ⎟ 
U k 
†. The inner sum is nonzero and of value N r I  iff k ∈ Sr. 
So  ρk(Hr) = N r√ I  if  k ∈ Sr  and  zero  otherwise.  Similarly,  ρk(Hr , d) = ρk(HN ,d)ρ 
k(Hr).  We  find  that  it  is  a 
nonzero matrix iff k ∈ Sr  and in that case ρk(Hr , d) = N r√ ρk(HN ,d)  and we use the computation for ρk(HN ,d) 
made in the previous section. □ 
Corollary 9.10 
The  Fourier  Sampling  over  DN  for  a  hidden  subgroup  H ∈ {Hr, Hr , d}  is  equivalent  to  the  Fourier Sampling over Dr for the hidden subgroup H Hr ∈ {{0}, ⟨(d , 1)⟩}. 
proof: The probabilities and matrix representations of observable irreducible representations are the same in both case. □ 
In the general  Strong Fourier Sampling over the dihedral  group, the weak part i.e. the measure of the representation labels is essentially the same as doing a cyclic Fourier Sampling over G ' = ℤN×{0}. Hence, we can find  r  and  in  particular find  H = Hr. However, the  strong version  gives the  same result as if we were working in Dr  . Thus we can really restrict ourselves to the case H = ⟨(d , 1)⟩  when studying Strong Fourier Sampling. 
We conclude this section by showing the converse of proposition 9.7: the states generated by DCP allow to simulate any Strong Fourier Sampling. One consequence is that to solve DHSP, the Dihedral Coset Problem method is more general than Strong Fourier Sampling. 
Proposition 9.11 (DCP simulates Strong Fourier Sampling) 
Any Strong Fourier Sampling over the dihedral group can be simulated using the output of DCP. 
proof: The DCP allows to produce states of the form formula 5.7. Applying a unitary gate of the form of proposition 9.3, we obtained (k, j) with probability: 
1 
2N ( 1 + (−1) jsin(2θ)cos 
( 
2π 
N kd + α 
)) (9.8) 
68
For any 0 < k < N 2 , we choose the same θk , αk  for k and N − k, in a way that we recover half the probability 
P(ρ k , ., 2 − j) of Strong Fourier Transform. If one of k, N − k  is measured then we return ρk , ., 2 − j. For k = 0, 
we choose arbitrary θ, α and we return ψ0  if it is measured. Finally if N  even and k = N 2  we choose α = 0 and θ 
= π 2  and return ψ2 + j . □ 
69
Appendix C: Attempts to solve DHSP by Fourier Sampling 
In this section, we describe several attempts to solve DHSP using a Strong Fourier Sampling. We restrict ourselves  to  the  case  H = HN ,d = ⟨(d , 1)⟩  and  use  only  2-dimensional  irreducible  representations.  As previously mentioned, we need to consider them as a whole since each of them as only a small probability to be observed. 
Approximation of a trigonometric expression 
A first idea is that the sum of the λk cos( 2π N kd + μk) can be expressed using trigonometric functions whose 
argument contains l = 2π N d. Trying various values of the parameters, we can obtain the values of l  modulo 2π 
and so the value of d . This sum can be approximated by counting the number of observation (ρk , ., 1) and so we can hope to get d  with a small probability of error. More formally, we define X  to be the random variable 
taking value 1 if a (ρk , ., 1) is measured and 0 otherwise. This random variable is bounded in an interval of length 1 so we can apply Hoeffding's inequality: S = X1 + X2 + … + Xm then for any t > 0, we have 
P(∣S − E(S)∣ ≥ mt) ≤ 2exp(−2mt 2 ) (10.1) 
We start by trying to approximate the trigonometric expression tan( l 2): 
For i = 1, 2, we denote S i the random variable where we choose for all k λk = 1 and μk = (1 − i) π 2 
= μ(i). We 
have E(S i ) = m 
N (M + xi) where M = ⎡⎢ 
N 2 
− 1⎤⎥ and xi = ∑ k= 1 
M cos( 
2π N d + μ(i) 
) is the sum we want to estimate. We 
let θ = ( M 2 
+ 1)l. By one oracle call, we can check that d ≠ 0 and in that case we have: 
xi = sin( 
M + 1 2 
l) 
sin( l 2) 
cos(θ − μ(i) ) = 
⎛ 
⎝ 
⎜ ⎜ ⎜ 
sin θ 
tan l 2 
− cos θ 
⎞ 
⎠ 
⎟ ⎟ ⎟ cos(θ − μ(i) 
) (10.2) 
Note  that sin( M + 1 
2 l) = 0  iff (M + 1)d ≡ 0 mod (N). Distinguishing  the  case  where  N  is  even  or  odd  and 
applying the euclidean algorithm, it is easy to check that 1 ≤ gcd(M + 1, N) ≤ 5 and so by at most 5 oracle calls, 
we can ensure that sin( M + 1 
2 l) is nonzero. Similarly, we can ensure that cos(θ − μ(2) 
) = sin θ and cos(θ − μ(1) ) = 
cos θ are nonzero by discarding solutions to the linear congruence (M + 2)d ≡ (2 − i) N 2 
 mod (N). We even get a 
stronger result: because M , d takes integer values, the arguments of these trigonometric functions is far from 0, 
π , ± π 2  by at least 1 
N . Hence we can find a constant a such that ∣∣sin( 
M + 1 2 
l) ∣∣ , ∣ cos θ ∣ , ∣ sin θ∣ are in the interval [ a N 
, 1]. 
Now, we have tan θ = sin θ cosθ 
= x2 x1 
 so θ ≡ ± atan x2 x1 
 mod (2π). Reporting in the expression of x1, extracting tan l 2 
and after simplification, we get d = ± N 2π 
f (x1, x2) mod (N) where f (x1, x2) = atan x2 
x1 2 + x2 
2 + x1 
. If we have the exact 
values of x1, x2 then we only have to check two values for d ! 
If m is repeated enough time, we measure S i = m N 
(M + xi + εi) and can assume that the error satisfies ∣εi ∣ 
70
≤ ε  for some ε  sufficiently small. We sketch how to bound the error on f (x1, x2), without giving the explicit 
constant. First using the constant a above, we can find a bound O( 1 
N 2 ) ≤ ∣xi∣ ≤ O(N), and so again for some ε 
≤ O( 1 
N 2 )  we  can  find  a  bound  O( 1 
N 2 ) ≤ ∣xi + ε∣ ≤ O(N).  Then  bounding  the  expression  of the  first partial 
derivatives of f  on the ball  Bε(x1, x2) we finally use the Taylor formula to get ∣ f (x1, x2) − f (x1 + ε1, x2 + ε2)∣ ≤ 
O(εN 7 ). This is a rough bound, so assume we can do better, said the first partial derivative of f  are bounded 
by a constant, and then replace the previous bound by O(ε). Then the error for N 2π 
f (x1, x2) is O(εN). We see that 
we must choose t  in Hoeffding's inequality to be O( poly(log N ) 
N 2 ) if we want this error poly(log N). In that case d  is 
reachable  by  calling  the  oracle  around  two  bands  of  size  poly(log N)  with  centers  ± 1 2π 
f (x1 + ε1, x2 + ε2). 
Nonetheless, we are also forced to choose m = Ω(N 4 )  i.e an exponential  number of sampling calls... Even 
assuming the size of the band to be O(N) (for example N 2  to eliminate half of the possibilities for d) gives m = Ω 
(N 2 ). 
To summarize we see that, in addition to the technical bound on the first partial derivatives, there are two major difficulties in the previous algorithm: the leading coefficient 1 
N  in the expression of the probability makes 
the error of the trigonometric function Ω(N) and the coefficient 1 N 
 inside the trigonometric function increases the 
error again to Ω(N 2 ). So we must at least make m = Ω(N 
2 ) Fourier Sampling if we want this error to be O(N), 
which is the worse we can tolerate. It seems that trying to extract d with this kind of approach is likely to fail. 
Let's mention a way to get cos l  and sin l  with different parameters i.e. two get only one band rather than 
two. Take the two same values for μk and lambda to be λk = λk for 0 < λ < 1. We get 
xi = λ M + 3 cos((M + 1)l) − λ M + 2 cos((M + 2)l) − λ2 + λcos(l − μ(i) 
) 
λ2 − 2λcos l + 1 (10.3) 
Using several values of λ we get system of linear equations with cos l, sin l  among their unknowns (these unknowns are even related by trigonometric formulas, so we can reduce the number of λ needed to make the system invertible). We have not tried to bound the error but anyway the comment above on the two difficulties are still valid. 
Randomized algorithm and parity of d 
Rather than trying to approximate d, we try to make the sum of the λk cos( 2π N kd + μk) reveal the parity of d . 
For simplicity, we assume N = 2n  for some n ≥ 2. We take λk = 1 and randomize the algorithm by uniformly 
choosing at each sampling some value d ' and let μk = 2π N k(2d '). The random variable X now takes the value 1 if 
(ρk , ., 1) is measured for some odd k and 0 otherwise. If b is the parity of d , then we now have: 
E(S) = m ∑ q = 0 
N 2 
− 1 1 
N 2 
⎛ 
⎝ 
⎜ ⎜ ⎜ 
∑ p = 0 
N 4 
− 1 
( 
1 
N ( 1 + cos 
( 
2π 
N (2p + 1)(2q + b) 
))) 
⎞ 
⎠ 
⎟ ⎟ ⎟ 
= m ( 
1 
4 + δb , 0 
N ) (10.4) 
71
So to  distinguish  whether δb, 0 
N  is  0  or  1 
N  we  need  to  take  t = 1 
2 N  and  so  m = Ω(N 
2 ). The  detail  of the 
calculation shows that the sum over p for the cosinus is nonzero and of value N 4  for only two values (namely 2q 
+d = 0, N 2 ). The factor 1 
N  reduces this value to 1 
4 . However, if we want to test all  the even values, we need to 
randomize  q:  this  introduces  a  coefficient  1 N 
2  and  makes  the  difference  between  the  cases  odd/even 
exponentially small. So while randomizing allows to test more values, it also decreases the precision by the same order. As previously stated, a stronger randomization of μk  is likely to blur the parameter d  and so make the information inaccessible. 
Eliminating many values in one call 
Once  we  have  computed  a = f (0, 0),  then  for  each  d ' ∈ ℤN ,  we  can  check d ' = d  by  one  call  just by checking f (d ', 1) = a. In this section, we see how many values of d  we can eliminate in one call. The idea is to 
choose λk = 1 and μk = − 2π N lk  for some integer lk ∈ ℤN . Suppose that d ' is such that cos( 
2π N 
(kd ' − lk)) = ± 1 
then the repartition of the probability of ρk  is 1 2 N 
 in one column and zero in the other. In that case, measuring ρk 
, j eliminates all the d ' that satisfy P(ρ k , ., j) = 0. Note that the cosinus takes the value ±1 iff kd ≡ lk  mod (N) or 
kd ≡ lk + N 2 
 mod (N). We now suppose N = 2n  for some n ≥ 2. Each 1 ≤ k ≤ 2n− 1 − 1 can be written in a unique 
way as (2xk + 1)2 ik  where 0 ≤ ik ≤ n − 1 and 0 ≤ xk ≤ 2n− ik − 1 − 1 and conversely any such (ik , xk) define a k  in the expected domain. In binary decomposition, the number made with first n − il − 1 bits is xk, the next bit is a 1 
and the ik  last bits are 0's. Clearly, we have gcd(k, N) = 2 ik . Because N 2 
= 2n− 1 is a multiple of 2 ik , the previous 
linear congruence have a solution iff lk = yk2 ik  for some 0 ≤ yk ≤ 2n− ik − 1. Again, in binary decomposition, the 
number made with first n − ik  bits of lk  is yk  and the ik  last bits are 0's. Let rk , sk  such that rk xk + sk2 n− ik = 1 then 
the possible solutions are given by rk yk + λ2n− ik  (cos = 1) and rk(yk + 2n− 1− ik ) + λ2n− ik  (cos = -1) for 0 ≤ λ ≤ 2 ik 
−1. So  measuring  a  representation  ρk  allows to  eliminate  with  certainty 2 ik  values. For the  1-dimensional 
representation, measuring  ψ2, ψ3  eliminates 2n− 1  possibilities and  we  get no  information  from ψ0, ψ1. As a consequence, in mean we can hope to eliminate with certainty in one call of Fourier Sampling: 
2n− 1 
N + 
2n− 1 
N + ∑ 
k= 1 
2 n−1 − 1 2 ik 
2N = 1 + ∑ 
ik = 0 
n− 1 
2n− ik − 1 2 ik 
2.2n = 1 + log(N) 
4 (10.5) 
which is only poly(log(N)). So even in the ideal case where each call eliminates different values for d  (for example we could hope to do so by choosing the lk  in a clever way at each step), repeating this procedure a polynomial number of time will in mean only discard a poly(log(N)) number of values for d! 
72
Appendix D: Reduction of Monotone 1-in-3 3SAT 
In this section, we try to solve a version of the famous boolean satisfiability problem using an abelian HSP. The version considered is the monotone 1-in-3 3-SAT which is known to be NP-complete [Sch1978]. We obtain 
a reduction of monotone 1-in-3 3-SAT to a lattice problem called GapCVP∞ using a quantum algorithm. Note 
however that a (classical) reduction of the subset sum problem to GapCVP1 is already known [MicGol2002]. Moreover, in  our  algorithm, the  HSP solution  is  only  used  to  find  generators  for  the  kernel  of a  module homomorphism. However, there exists an efficient classical algorithm for this task [BucNei1996]. Nevertheless, it  remains  an  illustration  of  general  techniques  based  on  HSP,  where  we  use  the  kernel  of  a  group homomorphism as the hidden subgroup. 
Monotone one-in-three 3-SAT is a variant of the boolean satisfiability problem where each clause has only three literals and those literals are not negated. We want to find a truth value where only one literal is true in each clause. More formally: 
Definition 11.1 (monotone one-in-three 3-SAT) 
Let x1, …xn  be  boolean  variables and  consider N > 0  different clauses defined  for all  0 ≤ i ≤ N − 1  by 
xσi(1) ∨ xσi(2) ∨ xσi(3), where σi ∈ n{1, 2, 3} is a combination . Define the predicate: 
P = ⋀ i = 0 
N − 1 
(xσi(1) ∨ xσi(2) ∨ xσi(3)) (11.1) 
The monotone 1-in-3 3-SAT is the following question: can we find a truth value for the xi's such that exactly one literal is true in each clause (and hence the whole conjunction P is true). ◇ 
Note that N ≤ n 
3( ) ≤ n 3 
6  (N  is at most the number of combination of three variables among n) and n ≤ 3N 
(each clause contains three variables). As a consequence, a polynomial algorithm for answering the question can be equivalently measured with N  or n. Without loss of generality, we are now considering the case where the first clause is x1 ∨ x2 ∨ x3 and the variables x1, x2, x3 are not used in other clauses (we will see later why this is needed). We can add such a clause to any given predicate and this changes neither the answer nor the complexity of the initial problem. 
Let us define the following function, which is going to be our oracle: 
f : 
⎧ 
⎨ 
⎩ 
⎪ ⎪ ⎪ ⎪ ⎪ ⎪ 
ℤ 4N n → ℤ4N 
x ↦ ( ∑ 
i = 0 
N − 1 
(∑ k= 1 
3 
xσi(k) ) 
4 i 
) 
(11.2) 
Note that the expression of f  is quite similar to the one of P if the variables are viewed as the coordinates 
of a vector x ∈ ℤ2 n ⊆ ℤ 
4N n . This function allows to characterize all the solutions of the monotone 1-in-3 3-SAT via 
the following lemma: 
73
Lemma 11.2 
A vector x ∈ ℤ2 n is a solution to the monotone 1-in-3 3-SAT iff f (x) = 4N− 1 
3 . 
proof: For such a vector x ∈ ℤ2 n, the i-th sum over k is a value between 0 and 3 that indicates the number of 
literals that are true in the i-th clause. So f (x) can be viewed as a representation of a an integer between 0 to 
4N − 1 in base 4. Hence x is solution to the solution to the monotone 1-in-3 3-SAT iff each digit is 1 i.e. f (x) = 
4N− 1 3 
. □ 
The following lemma is almost straightforward from the definition: 
Lemma 11.3 
f  is a module homomorphism. 
proof:  if  x, y ∈ ℤ 4N n ,  then  f (x + y) ≡ (∑ 
i = 0 
N − 1 (∑ 
k= 1 
3 (x + y)σi(k))4 i 
) ≡ (∑ i = 0 
N − 1 (∑ 
k= 1 
3 (xσi(k) + yσi(k)))4 i 
) ≡ 
f (x) + f (y) mod (4N ). 
Similarly, We prove that f (ax) ≡ a f (x) mod (4N ) for any a ∈ ℤ. □ 
If we define the sub-module H = Ker f  of ℤ 4N n  and the point p = 
4N− 1 3 
0 
⋮ 
0 
⎛ 
⎝ 
⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ 
, we have: 
Theorem 11.4 
The set of solutions of the monotone 1-in-3 3-SAT is exactly (p + H ) ∩ ℤ2 n. 
proof: We have f (g1) = f (g2) iff f (g1 − g2) = 0 iff g1 − g2 ∈ H . So f  distinguishes cosets of H . The coset p + 
H  corresponds to all the vectors that take the value f (p). By the restriction on the predicate P  we discussed 
earlier, this value is exactly 4N− 1 3 
. By a previous lemma, the solutions are exactly the vectors of ℤ2 n contained in 
this coset. 
Remark 11.5 
Given two subsets S1 and S2  of G and g ∈ G, the Coset Intersection Problem is to determine whether ⟨S1⟩ 
and g⟨S2⟩ have a non-empty intersection. However, the problem to decide whether (p + H ) ∩ ℤ2 n ≠ ∅ does not 
exactly fit into that framework, because ℤ2 n is not a subgroup of ℤ 
4N n . △ 
74
Using the efficient algorithm for abelian HSP, we get: 
Proposition 11.6 
There exists a quantum algorithm with a polynomial complexity in n that returns a set of generators for H with probability of success exponentially close to 1. 
proof: H = Ker f  is a subgroup of G = ℤ 4N n . f  distinguishes cosets of H  and each call to f  is an operation 
on integers of ⎡⎢log(4N )⎤⎥ = O(n) bits, so of polynomial complexity. G is an abelian group of order (4N 
) n , so we 
can apply the abelian HSP algorithm and find a set of t + log( ∣ G ∣ ) = t + 2nN  vectors that generate H  with 
probability 1 − 2 t (we can just take t = n). □ 
Remark 11.7 
This kind of interpretation as a HSP works for any group homomorphism. Moreover, the kernel is always a normal subgroup, so G needs not be abelian (we already know an efficient HSP algorithm in that case). △ 
Remark 11.8 
A classical  and non-probabilistic algorithm already exists to find a set of generators for the kernel  of a module homomorphism [BucNei1996]. The ring is R = ℤ4N  and, similarly to the call to f , the elementary "ring 
operations" are  polynomial  in  n.  The  whole  procedure  is  polynomial.  Hence  quantum computation  is  not needed here. △ 
Rather than searching the solution in ℤ2 n we are now looking into p + H  and try to find a vector with only 0 
and 1 coordinates. In some sense, we want to find a non-zero vector of smallest coordinates in p + H  (i.e short for the infinity norm), although we need some technical modifications to make this statement exact (vectors with -1 coordinates are also short, we work modulo 4N ...). Before to do that, let's define our lattice problem: 
Definition 11.9 (decisional closest vector problem) 
Let b1, …, bn ∈ ℚn (or equivalently ℤn) a basis of ℝn. The lattice corresponding to this basis is the set of all 
linear combinations x = ∑ i = 1 
n xib 
i  with  coefficients xi ∈ ℤ. If d ∈ ℝ  and v ∈ ℝn, the  decisional  closest vector 
problem with infinity norm (GapCVP∞) is to answer whether inf x in the lattice 
‖v − x‖∞ ≤ d. ◇ 
Note that the previous proposition gives a generating sets bi of vectors for H . According to module theory, 
since the rank of the image of f  is 1, the rank of the module H  is n − 1. Hence we can extract n − 1 vectors b1, 
…bn− 1 ∈ ℤn  that generate H , and this can be done in polynomial time, using classical reduction on the matrix 
whose columns are the vectors bi. The extracted vectors are independent linear vectors of ℝn: suppose there 
are  ai's  such  that if ∑ i = 1 
n− 1 aib 
i = 0. We  can  determine  them by a  Gaussian  elimination  they are  integer (or 
rational, but since we get a 1-dimensional space of solutions, we can always make them integer). Hence the 
75
equality ∑ i = 1 
n− 1 aib 
i = 0 holds in ℤ4N  and get that the ai's are zeros. 
As a consequence, we almost have a GapCVP∞ version. What we want is to find a vector x  in the lattice 
generated by bi  such that p + x  is a vector of ℤ2 n  (i.e. with only 0's and 1's entries). Equivalently, we want to 
determine the minimum distance (for the infinity norm) from a vector of the lattice to the the point v = − p + 
1 2 
1 2 
⋮ 
1 2 
⎛ 
⎝ 
⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ 
. This distance is less or equal to d = 1 2  iff there is a solution to the monotone 1-in-3 3-SAT. We have 
two problems to overcome: the bi's are not a basis of ℝn  and we want to allow the result modulo 4N . First we 
complete the n − 1 vectors with a vector bn in order to get a basis. We can assume that bn is integer-valued and 
even that all his coefficients are of the form ki4N . Next, we move to ℝ2n : we extend v, p and each vector bi with n 
zeros and for all 1 ≤ i ≤ n we define the vector bn+ i  that has only two nonzero entries: 4N  at position i  and a 
rational ε at position n + i. Clearly, we have a basis of ℝ2n  that we now denote cj (p and v will denote either the initial vectors or those extended with zero, depending on the context). In matrix form, we can write: 
C = 
b1 1 b1 
2 ⋯ b 1 
n− 1 k14N 4N 0 ⋯ 0 
b2 1 ⋮ ⋮ k24N 0 ⋱ ⋮ 
⋮ ⋮ ⋮ ⋮ ⋮ ⋱ 0 
bn 1 bn 
2 ⋯ bn n− 1 kn4N 0 0 ⋯ 4N 
0 0 ⋯ ⋯ 0 ε 0 ⋯ 0 
0 0 0 0 ε ⋮ 
⋮ ⋮ ⋮ ⋮ ⋱ 0 
0 0 ⋯ ⋯ 0 0 ⋯ 0 ε 
⎛ 
⎝ 
⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ ⎜ 
⎞ 
⎠ 
⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ ⎟ 
(11.3) 
If we restrict ourselves to the n first coordinates, then the combination of the column of C  is exactly the 
values of H  modulo 4N . The intuition is that if ε is small enough, we can almost stay in the subspace of vectors whose n last coordinates are zero, where the vector v  lives and can ignore what is happening in the n last coordinates. This is exactly what the following lemma says: 
Lemma 11.10 
Let R > 0 be a rational and define B(R) = x = ∑ j = 1 
2n ujb 
j ∀ j∣∣uj∣∣ ≤ R{ }| | . There exists a rational ε > 0 such that 
for any x ∈ B(R) in the lattice, ‖v − x‖∞ = max1≤ i ≤ n ∣xi − vi∣. 
proof: If r is the shortest distance of the GapCVP∞ problem, we take ε > 0 any rational less than r R . For any 
x ∈ B(R) and 1 ≤ i ≤ n∣xn+ i − vn+ i ∣ = ∣un+ i ε − 0∣ = ∣un+ i ∣∣ ε ≤ R r 
R = r ≤ ‖ v − x‖∞ = max1≤ i ≤ 2n ∣xi − vi∣. Hence we 
76
have ‖v − x‖∞ = max1≤ i ≤ n ∣xi − vi∣. □ 
Remark 11.11 
The proof of the previous lemma can be rewritten in a constructive way. For example we will choose an accurate R in the next theorem. We do not know the value of r. However, we are working with integer values in 
the n first coordinates so the minimum values for the ∣xi − vi∣ is at least 1 2  and thus r ≥ 1 
2 . Hence we can take the 
rational ε = 1 2 R 
, which can be computed in polynomial time. △ 
We can now conclude this section: 
Theorem 11.12 
There is some ε > 0, such that a solution to the initial monotone 1-in-3 3-SAT problem exists iff the answer 
to the GapCVP∞ with that parameter is true. 
proof: Let Mb = (1 + sup ∣ ∣ bi 
j∣ ∣) (the supremum is taken for 1 ≤ i ≤ n and 1 ≤ j ≤ n − 1), R = max {Mb + 2, 4N 
−1} and choose ε accordingly. 
A solution to monotone 1-in-3 3-SAT yields a vector x = ∑ j = 1 
2n ujb 
j  in the lattice such that max1≤ i ≤ n ∣xi − vi∣ 
= 1 2 . We can assume that the n − 1 first uj's to be between 0 and 4N − 1, un = 0. The coordinates of ∑ 
j = 1 
n ujb 
j are 
bounded in  absolute  values by 4NMb. Because we want to  come back inside  [ − 4N + 1, 4N − 1]  where  the 
coordinates vi ± 1 2  are located, the ∣uj∣'s for the n last coordinates need only be less than or equal to Mb + 2. 
Hence we have for all the uj, ∣uj ∣ ≤ R  and thus x ∈ B(R). By the previous lemma, ‖v − x‖∞ = max1≤ i ≤ n ∣xi − vi∣ 
= 1 2 
= d, so the GapCVP∞ problem is true. 
Conversely, suppose the GapCVP∞ problem is true. Then there is is a closest vector x = ∑ j = 1 
2n ujcj  such 
that d = 1 2 
≥ ‖v − x‖∞ ≥ max1≤ i ≤ n ∣xi − vi∣. In the n first coordinates, this means that for all i, ∣xi + pi − 1 2 
∣ ≤ 1 2  and 
because we are only working with integer values, xi + pi is 0 or 1. Hence pi + ∑ j = 1 
n− 1 ujbi 
j ≡ 0 or 1 modulo 4N  i.e. 
p + ∑ j = 1 
n− 1 ujb 
j ∈ (p + H ) ∩ ℤ2 n. In that case it is a solution to the monotone 1-in-3 3-SAT. □ 
Corollary 11.13 
Monotone 1-in-3 3SAT reduces to GapCVP∞. □ 
77
Appendix E: Table of Lattice-based Cryptosystems 
In this section, we sum up in a table the overview of lattice-based cryptosystems given in [MicReg2008]. The  coefficient in  uniqueSVP problems are  according  to  [Reg2003bis].  We  will  list  many  other  problems without defining them: Shortest Vector Problem (SVP), unique Shortest Vector Problem (uniqueSVP), Shortest Independent Vectors Problem (SIVP), Closest vector problem (CVP), Learning With Errors (LWE). Also, more assumptions are often made on these problems: particular structure of the lattice (e.g. uniqueSVP rather than SVP), approximate factors etc. 
There is often a trade-off between efficient implementation and security insurance: adding assumptions may  make  the  system  more  vulnerable  but  also  more  realizable  in  practice.  An  important  feature  of lattice-based cryptosystems is that a security proof, when we have one, is based on worst-case hardness rather than average-case hardness. 
Classification in 
[MicReg2008] Cryptosystem Security proof Practical Implementation 
Hash Functions 
Ajtai's construction of hash functions, based on q-ary lattices. 
approximate SIVP, SVP, or CVP over q -ary lattices. 
Quite inefficient. Collision resistant functions. 
Ajtai's construction restricted to cyclic lattices. 
approximate SIVP over cyclic lattices. 
Efficient Only one-way functions (not strong enough for practical use). 
Ajtai's construction restricted to ideal lattices. 
approximate SVP over ideal lattices. 
Efficient (there exists an optimized version, the SWIFFT hash function). Collision resistant functions. 
Public Key Encryption Schemes 
GGH/HNF none Attacks are known. 
NTRU none Attacks are known. 
Ajtai-Dwork cryptosystem, improved by Goldreich/Goldwasser /Halevi. 
O(n 7 )-uniqueSVP Quite inefficient. 
78
Classification in 
[MicReg2008] Cryptosystem Security proof Practical Implementation 
Ajtai-Dwork cryptosystem improved by Regev. 
O(n 3 
2 )-uniqueSVP Quite inefficient. 
Regev's cryptosystem LWE 
Relatively efficient (can be optimized any further, by restricting to some class of lattices). 
Digital Signature Schemes 
GGH/NTRUSign none 
Efficient Attacks are known. For NTRUSign, there are some countermeasures based on perturbation techniques. 
Schemes based on preimage sampleable trapdoor functions. 
approximate SIVP and more. 
Quadratic complexity. 
Schemes based on collision resistant hash functions. 
approximate SVP in ideal lattices. 
Almost linear complexity. 
Other Cryptographic Primitives 
CCA-secure cryptosystems LWE / 
IBE LWE / 
OT protocols LWE / 
Zero-Knowledge proofs and ID schemes 
approximate-SVP / 
Figure 12.1 
79
Appendix F: Variant for the Abelian HSP algorithm 
In this section, we study an alternative algorithm for the abelian hidden subgroup problem. The idea is to use  the  information  obtained  after each  call  to  move to  a  simpler Hidden Subgroup  Problem, built on  the original one. It does not generalize to arbitrary group, but is a good example of a subgroup reduction method. 
Cyclic Hidden Subgroup Problem 
We have already described an algorithm for the Cyclic HSP in the period-finding submodule of Shor's factoring algorithm. Recall that we do a constant number k  of Weak Fourier Samplings on G = ℤN  in order to 
find  a  hidden  subgroup  H = d ℤN  for  some 1 ≤ d ≤ N. For each  sampling, we  get a  number λ N d 
 for  some 
λ ∈ {0, …d − 1}. Computing the greatest common divisor of these multiples gives N d 
 with probability at least 
1 − 2− k 2 . 
The idea of our algorithm is the following. If we compute the irreducible fraction of λk N d , the denominator is 
a  divisor a1  of d. This gives H = d ℤN ⊆ a1 ℤN ⊆ G = ℤN  and  we can now work in  the  group a1 ℤN  instead. Repeating  this  several  times, we  get some  ak ℤN 's  which  are  closer  and  closer  to  H .  Said  otherwise, ak becomes d. 
More  precisely, we  define  G0 = G = ℤN , H0 = dℤN  and  a0 = 1. At each  step  k, we  have  another cyclic 
hidden subgroup problem: Gk = ak ℤN ≅ ℤNk , H = Hk ≅ dk ℤNk 
 with Nk = N ak 
 and dk = d ak 
. Moreover, to  build  a 
oracle on Gk = ℤNk  from the initial f , we define fk(x) = f (ak x). 
Now at the step k, applying a Weak Fourier Sampling over Gk  gives a λk Nk dk 
 for some λk ∈ {0, …, dk − 1}. 
We compute the irreducible fraction pk qk 
 of λk Nk dk 
ak N 
= λk dk 
 and get a divisor qk  of dk. We set ak+ 1 = qkak  and continue 
this  procedure  until  k = m.  Very  often, we  have  λk > 0  (i.e. qk > 1)  an  so  ak+ 1 ≥ 2ak.  Hence  repeating  this 
O(log N) times, ak should reach d. This is essentially what the following theorem says: 
Theorem 13.1 
If  we  repeat  the  procedure  above  m = 2clog N  times  for  some  c ≥ 2  then  we  have  P(am = d) ≥ 1 − 
ⅇ− (c−1) 2 
c log N . Moreover, all  the operations are done on log N  bits so we have a solution to the cyclic hidden subgroup problem. 
proof: First, the probability of failure given that ak has reached d before the mth call is zero. Hence we have: 
P(am ≠ d) = P(am < d) = P(am < d / ∀ k < m, ak < d)P((∀ k < m, ak < d)) + 0 ≤ P(am < d / ∀ k < m, ak < d) 
(13.1) 
Now per discussion above, if the number of λk ≠ 0 is ≥ log N then 
am = ∏ k<m 
qk ≥ ∏ k<m, λk ≠ 0 
2 ≥ 2log N = N ≥ d (13.2) 
80
Thus we have 
P(am ≠ d) ≤ P(∣{k < m, λk ≠ 0}∣ < log N / ∀ k < m, ak < d) (13.3) 
In  order  to  majorate  the  right hand  side  probability, we  introduce  a  variable  Xk  following  a  Bernoulli 
distribution with equal failure/success probability 1 2 . Since ak < d, we have λk > 0 with a probability at least 1 
2 . 
Hence  if  S = ∑ k<m 
Xk,  we  have  P(am ≠ d) ≤ P(S ≤ log N) = P(S − c log N ≤ (1 − c)log N)  and  finally  using 
Hoeffding's inequality: 
P(am ≠ d) ≤ ⅇ − 
2(c− 1)2log 2 N m = ⅇ 
− (c− 1)2 
c log N (13.4) 
□ 
While this algorithm does not really improve the complexity, it is interesting to note how it works: rather than  applying  Fourier  Sampling  over  ℤN ,  we  gather  information  on  H  to  "reduce" the  group  and  hidden subgroup at each step. Finally, we reach the case where Hm = Gm is i.e. we know everything about the hidden subgroup. 
Abelian Hidden Subgroup Problem 
We mimic the  previous algorithm by building  a  sequence  of subgroups H = Gm ⊆ Gm− 1 ⊆ … ⊆ G0 = G. Since  Gk ⊆ G  is  abelian, we  have  an  isomorphism Gk ≅ ℤ 
t 1 
k ×ℤ t 2 
k ×…×ℤ t dk 
k . We  assume  that each  factor  is 
nontrivial, so the length dk of this decomposition is of size O(log∣G∣). 
We let G0 = G, H0 = H  and f0 = f . For 1 ≤ i ≤ d0, a i 
0  is element of G0  with a one at the ith position and 
zeros elsewhere. At step k, we apply a Weak Fourier Sampling over ℤ t 1 
k ×ℤ t 2 
k ×…×ℤ t dk 
k  to find a subgroup Hk 
hidden by a function fk. This gives an element gk ∈ Gk such that Hk ⊆ Ker χgk = Gk+ 1. Note that we have Gk+ 1 ⊊ 
Gk  if gk ≠ 1. This happens with probability at least 1 2  if we have not reached H  yet: in  that case H ⊊ Gk, so 
∣Gk ∣ ≥ 2∣H ∣ ≥ 2 and by formula formula 4.20, P(1) = ∣H ∣√ 
∣∣Gk ∣∣ 
≤ 
∣∣Gk ∣∣ 
2 √ 
∣∣Gk ∣∣ 
= 1 
2 ∣∣Gk ∣∣√ 
≤ 1 
4√ = 1 
2 . Because of the isomorphism 
Gk+ 1 ≅ ℤ t 1 
k+1 ×ℤ t 2 
k+1 ×…×ℤ t dk+1 
k+1  there  are  elements  a 1 
k+ 1, …, adk+1 
k+ 1  of  Gk  such  that  we  have  the  direct 
decomposition Gk+ 1 = ⊕i = 1 
dk+1 ⟨ai 
k+ 1 ⟩. We define fk+ 1(x1, …, xdk+1 ) = fk(∑i = 1 
dk+1 xiai k+ 1 
). 
Note how everything is similar to the cyclic HSP algorithm above. When Gk+ 1 ⊊ Gk, we have ∣Gk+ 1∣ ≤ 1 2 
∣Gk ∣ 
and so we have the equivalent of theorem 13.1 above saying that O(log∣G∣) steps are enough. However, we need more care to claim that all the operations are poly(log∣G∣). First, it is easy to show by induction that for k ≥ 1 
, an element (x1 
k , …, x dk 
k ) ∈ Gk corresponds to following element of the initial group G: 
81
∑ ik = 1 
dk 
x ik 
k ⎡ 
⎣ 
⎢ ⎢ ∑ j = 0 
k− 1 
∑ ij = 1 
dj 
(∏ l = 0 
k− 1 
a il +1, il 
l+ 1 a i0 
0 
)] (13.5) 
We define the term in brackets to be a vector u ik 
k ∈ G and these are the vectors we keep in memory. So we 
start with u i0 
0 = a i0 
0  and at each step we compute u ik+1 
k+ 1 = ∑ik = 1 
dk a ik+1, ik 
k+ 1 u ik 
k  in poly(log∣G∣). A call  to the oracle fk 
consists in computing x = ∑ik=1 
dk x ik 
k u ik 
k  in poly(log∣G∣) followed by a call to f (x). Also, with very high probability, 
we have Hm = Gm = ℤt 1 
m×ℤt 2 
m×…×ℤt dk 
m  and so the elements of H  are obtained by ∑im=1 
dm x im 
mu im 
m  for x im 
m ∈ ℤt im 
m  and 
we have directly obtained: 
H = ⊕ i = 1 
dm 
⟨ui m 
⟩ ≅ ℤt 1 
m×ℤt 2 
m×…×ℤt dm 
m (13.6) 
The  more  annoying  thing  is  to  determine  the  element  a i 
k+ 1  in  the  direct  decomposition  Ker χgk = 
⊕i = 1 
dk+1 ⟨ai 
k+ 1 ⟩. As we have previously seen, any element h ∈ Ker χgk 
 is solution to a congruence equation of the 
form ∑i = 1 
dk αihi ≡ 0 mod (ek) where ek = lcm 1≤ i ≤ dk 
(ti k ). We can view h ∈ ℤek 
dk  and using the kernel algorithm 6.1 of 
[BucNei1996], we can compute a generating set for Ker χgk  in poly(log∣G∣). Nevertheless, this generating set 
does not necessarily form a direct sum as wanted. However, we use the technique proposed by Cheung and 
Mosca in [CheMos2001] to get the decomposition Ker χgk = ⊕i = 1 
dk+1 ⟨ai 
k+ 1 ⟩ from this generating set in poly(log∣G∣) 
. Their algorithm uses the cyclic HSP to compute the orders t i 
k+ 1 of a i 
k+ 1 in poly(log∣G∣). 
To conclude this section, note that the algorithm may also work for Hamiltonian HSP: it is easy to see that the Gk 's will  remain Dedekindian i.e. isomorphic to  either an abelian or a  hamiltonian group. The possible irreducible representations are described in [HalRusTa-2000]. However, we have not been able to figure out how to construct the isomorphism from the kernel equations. For more general groups, the Hm obtained at the end will be the largest normal subgroup of G containing H , as noted in [GriSchVaz2000]. Thus we may need to continue the procedure, for example by using a quotient reduction as indicated in proposition 6.4. 
82
Appendix G: Attempts to solve DHSP by superposition of oracle values 
In  this section, we try to  solve the HSP over DN = ℤN⋊φℤ2, reduced to  the case H = ⟨(d , 1)⟩  for some 
d ∈ ℤN . Contrary to  all  the  other approaches proposed so  far, we will  not use  coset states of the  form 1 
2√ 
(∣x⟩∣0⟩ + ∣x + d⟩∣1⟩) but superpositions over many oracle values. In particular, this approach will not a priori yield an efficient algorithm for polynomial uniqueSVP. 
Finding the parity of d 
First let's recall the classical inductive method to determine d . If M  is a divisor of N, we let N ' = N M 
 and write 
the euclidean division d = Md ' + r. If we are able to determine r  in polynomial time, then we can define the oracle  f '(x, y) = f (Mx + r, y)  for  x ∈ ℤN ' ,  y ∈ ℤ2  and  obtain  a  new  dihedral  HSP  with  hidden  subgroup ⟨(d ', 1)⟩. Since the prime factorization has only O(log N) factors, we can repeat this inductive step to get an efficient algorithm. Of course, this is likely to be useful only when the factors are small, for otherwise it may be as much difficult to determine r as to determine the whole d. One interesting case is N = 2n and M = 2: at each step, N remains a power of 2 and we only need to determine one digit of d . 
If  we  fix  b ∈ {0, 1},  the  elements  (Mi + j, b)  for  i ∈ ℤN ' , j ∈ ℤM  form  a  complete  set  of  coset representatives, and  so  the  elements f (Mi + j, b)  are  the  N  possible  values of f (DN ). Moreover, we  can consider a partition of f (DN ) by defining for all j ∈ ℤM the subsets 
E j 
b = { f (Mi + j, b), i ∈ ℤN ′} (14.1) 
From the equality f (g(d , 1)) = f (g) we have the relation: 
Ej 1 = { f (Mi + j, 1), i ∈ ZN ′} 
= { f ((Mi + j − d , 0)(d , 1)), i ∈ ZN ′} 
= { f (Mi + j − (Md′ + r), 0), i ∈ ZN ′} 
= { f (Mi + ( j − r), 0), i ∈ ZN ′} 
= E ( j− r)mod(M ) 
0 
(14.2) 
In  particular  for  j = r, we  have  the  equality  E 0 
0 = Er 1  and  so  we  can  hope  to  get information  on  r  by 
comparing the superposition over E 0 
0 and those over E j 1. We show that it is possible for M = 2, but it also works 
for any polynomial value by an obvious modification. In that case, the uniform superposition over E 0 
0  and E 0 1 
are respectively 
∣ψ0⟩ = 1 
N′√ ∑ i = 0 
N ′− 1 
∣ f (2i, 0)⟩ (14.3) 
and 
83
∣ϕ0⟩ = 1 
N′√ ∑ i = 0 
N ′− 1 
∣ f (2i, 1)⟩ (14.4) 
If  r = 0,  ∣ψ0⟩ = ∣ϕ0⟩  is  the  uniform  superposition  over  E 0 
0.  Otherwise,  r = 1  and  ∣ϕ0⟩  is  the  uniform 
superposition over the complementary set E 0 1. We let f 
i 
b = f (2i + b, 0) and measure the product state ∣ψ0⟩∣ϕ0⟩ in 
the  basis  ∣x⟩∣x⟩ x∈ ℤN ,  1 
2√ (∣x⟩∣y⟩ + ∣x⟩∣y⟩) 
x< y∈ ℤN ,  1 
2√ (∣x⟩∣y⟩ − ∣x⟩∣y⟩) 
x< y∈ ℤN  .  It  turns  out  that  this  allows  to 
distinguish the two cases: 
If r = 0, the product contains vectors with the same coordinates ∣ f i 
0⟩∣ f i 
0⟩ for i ∈ ℤN . For the other vectors, 
we have a symmetry between the two coordinates. Hence we can group them by pairs ∣ f i1 
0⟩∣ f i2 
0⟩ + ∣ f i2 
0⟩∣ f i1 
0⟩ 
for  i1 < i2 ∈ ℤN .  Finally,  the  product  state  belongs  to  the  space  spanned  by  ∣x⟩∣x⟩ x∈ ℤN  and 
∣x⟩∣y⟩ + ∣x⟩∣y⟩ x< y∈ ℤN . 
If r = 1, the product contains vectors ∣ f i1 
0⟩∣ f i2 
1⟩  where the two coordinates are  not equal. This time, we 
never have two symmetric vectors i.e. which are the same modulo permutation of the two coordinates. Moreover, each vector ∣ f 
i1 
0⟩∣ f i2 
1⟩ is the expression of a sum/difference (according to the respective order of 
f i1 
0  and  f i2 
1)  of  two  vectors  ∣x⟩∣y⟩ + ∣x⟩∣y⟩  and  ∣x⟩∣y⟩ − ∣x⟩∣y⟩.  So  the  product  state  belongs  half  to 
∣x⟩∣y⟩ + ∣x⟩∣y⟩ x< y∈ ℤN  and half to ∣x⟩∣y⟩ − ∣x⟩∣y⟩ x< y∈ ℤN 
. 
Suppose that we have a procedure to create many states ∣ψ0⟩ and ∣ϕ0⟩. We measure a state in the space 1 
2√ (∣x⟩∣y⟩ − ∣x⟩∣y⟩) 
x< y∈ ℤN  with probability r 
2 . So repeating the procedure a constant number of times allows to 
determine r with high probability! 
It is not however clear whether we can create the states ∣ψ0⟩ and ∣ϕ0⟩ efficiently. With the usual approach, 
we  can  start by creating  a  superposition  over  the  elements (2i, b)  and  apply  the  gate  Uf . To  remove  the entanglement  between  a  point  and  its  image  by  f ,  we  apply  a  Quantum  Fourier  Transform  to  the  first coordinate and measure it. We get two random numbers j1, j2 ∈ ℤN '  as well as the states 
∣ψ j1 ⟩ = 
1 
N′√ ∑ i = 0 
N ′− 1 
ⅇ 2ⅈπ j1 i 
N ′ ∣ f (2i, 0)⟩ (14.5) 
and 
∣ϕ j2 ⟩ = 
ⅇ 2ⅈπ j2d ′ 
N ′ 
N′√ ∑ i = 0 
N ′− 1 
ⅇ 2ⅈπ j2 i 
N ′ ∣ f (2i − r, 0)⟩ (14.6) 
Note that we can actually ignore the phase factor in the second one. The desired result j1 = j2 = 0 only happens with exponentially small probability. Nonetheless, we can still apply the previous measurement. After a bit of calculation, we get the probabilities: 
84
Space case r = 0 case r = 1 
∣x⟩∣x⟩ x∈ ℤN 1 N ' 0 
∣x⟩∣y⟩ + ∣x⟩∣y⟩ x< y∈ ℤN 
2 
N ′2 
∑ i2 = 0 
N ′−1 ∑i1 = 0 
i2 − 1 cos2 π 
N ′ ( j2 − j1)(i2 − i1) 
1 2 
∣x⟩∣y⟩ − ∣x⟩∣y⟩ x< y∈ ℤN 
2 
N ′2 
∑ i2 = 0 
N ′−1 ∑i1 = 0 
i2 − 1 sin2 π 
N ′ ( j2 − j1)(i2 − i1) 
1 2 
If we repeat the procedure several times, we need to take the means over the choice of j1, j2 ∈ ℤN ' . By 
classical trigonometric identities, it is possible to write the sums of the first column 1 2 
+ S + o( 1 N ') where S  is a 
sum of cosinus. Unfortunately, evaluating  S  with  a  computer suggests that S = Θ( 1 N ')  . Hence, we can not 
distinguish the two cases with only a polynomial (in log N) number of samplings... 
Finding an approximation of d 
For convenience, we assume N = 4M  and define N ' = 2M = N 2 . In this section, we consider for a ∈ ℤN  and 
b ∈ ℤ2 the sets of N ' successive values 
Fa b = { f (a + i, b), i ∈ ℤN ′} (14.7) 
The algorithm is based on the assumption that we can efficiently create uniform superposition over these states. As above, we have Fa 
1 = F a−d 
0 = Fs 0  with −N < s < N  and we measure the tensor product of the uniform 
superpositions  over  Fa 1 = Fs 
0  and  F 0 
0  in  the  basis  ∣x⟩∣x⟩ x∈ ℤN ,  1 
2√ (∣x⟩∣y⟩ + ∣x⟩∣y⟩) 
x< y∈ ℤN , 
1 
2√ (∣x⟩∣y⟩ − ∣x⟩∣y⟩) 
x< y∈ ℤN . We define l = ∣∣F0 
0 ∩ Fa 1∣∣ the number of common elements. 
f (0, 0) f (N ', 0) f (N − 1, 0) 
F 0 
0 Fs 
0 
s l 
N ' 
0 ≤ s ≤ N ' 
Figure 14.1 
The figure 14.1 shows that in the case 0 ≤ s ≤ N ', we have l = N ' − s. In general, the expression is 
85
l = ∣N ' − ∣s∣∣ = ∣N ' − ∣d − a∣∣ (14.8) 
The possible vectors in the product of the uniform superpositions over Fa 1 = Fs 
0 and F 0 
0 are: 
l vectors of the form 1 N ' 
(∣x⟩∣x⟩) for x ∈ F 0 
0 ∩ Fa 1 in the intersection. 
l 
2( ) = l(l− 1) 
2  vectors  of  the  form 2√ 
N ' ( 1 
2√ (∣x⟩∣y⟩ + ∣x⟩∣y⟩))  for  x, y ∈ F 
0 
0 ∩ Fa 1  two  distinct  elements  of  the 
intersection. N '2 − l 2 other vectors ∣x⟩∣y⟩ for x ≠ y with one of the vector ouside the intersection F 
0 
0 ∩ Fa 1, which can be 
written  as  a  combination  of  two  vectors  of  the  basis.  For  example  if  x < y,  it  is  2√ 
2 N ' 
( 1 
2√ (∣x⟩∣y⟩ + ∣x⟩∣y⟩) + 1 
2√ (∣x⟩∣y⟩ − ∣x⟩∣y⟩)) 
The probability of measuring ∣x⟩∣x⟩ or 1 
2√ (∣x⟩∣y⟩ + ∣x⟩∣y⟩) is thus 
P = 1 
N′2 ( l + 2 
l(l − 1) 
2 + 
1 
2 (N′2 − l 2 
)) 
= 1 
2 [ 1 + 
( 
l 
N′) 
2 
] 
(14.9) 
and of course the one of measuring 1 
2√ (∣x⟩∣y⟩ − ∣x⟩∣y⟩) is the complementary: 
1 − P = 1 
N′2 ( 
1 
2 (N′2 − l 2 
)) 
= 1 
2 [ 1 − 
( 
l 
N′) 
2 
] 
(14.10) 
We can try to repeat m times the measurement in order to approximate P and hence also l, s and finally d. Of course, we can test several values of a and compare the different approximations of d  to refine them. Once again, we use Hoeffding's inequality. We define X to be the random variable taking the value 1 with probability 
P and 0 otherwise and S = X1 + X2 + … + Xm. We take m = (log N)2 p+ 1 for some fixed p and t = log N 
m√ = 1 
(log N )p 
i.e. mt 2 = log N. We have: 
P ( 
1 
m ∣S − E(S)∣ ≥ t 
) ≤ 2exp(−2mt 2 
) = 2exp(−2log N) (14.11) 
So if lexp  is the  experimental  value  of l  we  have  with  very high  probability, ∣l 2 − lexp 2 ∣ < tN '2 = N ' 2 
(log N )p . 
Unfortunately, this  does  not provide  a  good  precision. Instead, we  will  turn  toward  a  more  modest goal: determine whether l is less than N ' 
2 . This is possible if lexp is sufficiently far from N ' 
2 . Note that 
86
∣ ∣ ∣ ∣ lexp 
2 − ( 
N′ 
2 ) 
2∣ 
∣ ∣ ∣ <tN′2 ⇔ lexp 
2 = ( 
N′ 
2 ) 
2 
+ εtN′2 for some ∣ε∣<1 
⇔ lexp = N′ 
2 1 + 4εt√ for some ∣ε∣<1 
⇔ 1 − 4t√ N′ 
2 < lexp < 1 + 4t√ 
N′ 
2 
(14.12) 
Hence, if t is small enough, we can decide with certainty whether l is less than N ' 2 
, except if lexp is in a small 
interval around N ' 2 
. Unfortunately again, we have 1 ± 4t√ = 1 ± 2t + o(t) so this interval is approximately of size 
tN ' = N 
2(log N )p  which is exponentially large... 
The algorithm fails in general but still may give a partial hint. For example, if log N ≥ 2 and if we take p = 3, 
the  answer is  correct for  at least lexp  out of the  intervall  ] N ' 3 
, 2 N ' 3 [. This is  in  contrast to  the  approximation 
proposed in appendix C, for which the error seems too difficult to bound in order to get any information. 
As a conclusion, both methods above provide improvement over the standard coset sampling approach. It is not clear how we can create efficiently the uniform superpositions over the sets of oracle values E 
j 
b or Fa b, but 
they may provide an alternative research direction to solve the dihedral HSP. 
87
Bibliography 
[AblVas2009] Farid Ablayev, Alexander Vasiliev, 2009, Algorithms for Quantum Branching Programs Based on Fingerprinting . EPTCS 9, 2009, pp. 1-11 http://arxiv.org/abs/0911.2317 
[AmiKalRoo2006] Massoud Amini, Mehrdad Kalantar, Mahmood M. Roozbehani, 2006, Hidden Subhypergroup Problem. http://arxiv.org/abs/quant-ph/0609220 
[BabLuk1983] László Babai and Eugene M. Luks, 1983, Canonical labeling of graphs. STOC '83: Proceedings of the fifteenth annual ACM symposium on Theory of computing 
[BacChiDam2005] Dave Bacon, Andrew M. Childs and Wim van Dam, 2005, Optimal measurements for the dihedral hidden subgroup problem. Chicago Journal of Theoretical Computer Science (2006), no. 2 http://arxiv.org/abs/quant-ph/0501044 
[BacChiDam2005bis] Dave Bacon, Andrew M. Childs and Wim van Dam, 2005, From optimal measurement to efficient quantum algorithms for the hidden subgroup problem over semidirect product groups. Proc. 46th IEEE Symposium on Foundations of Computer Science (FOCS 2005), pp. 469-478 http://arxiv.org/abs/quant-ph/0504083 
[BucNei1996] Johannes Buchmann and Stefan Neis, 1996, Algorithms for Linear Algebra Problems over Principal Ideal Ring. http://lips.cdc.informatik.tu-darmstadt.de/reports/TR/TI-96-7.linear_algebra.ps 
[CheMos2001] Kevin K. H. Cheung and Michele Mosca, 2001, Decomposing Finite Abelian Groups. http://arxiv.org/abs/cs/0101004v1 
[ChiDam2005] Andrew M. Childs, Wim van Dam, 2005, Quantum algorithm for a generalized hidden shift problem. Proc. 18th ACM-SIAM Symposium on Discrete Algorithms (SODA 2007), pp. 1225-1234 http://arxiv.org/abs/quant-ph/0507190 
[ChiKimLee2006] Dong Pyo Chi, Jeong San Kim and Soojoon Lee, 2006, Notes on the hidden subgroup problem on some semi-direct product groups. Phys. Lett. A 359, 114 (2006). http://arxiv.org/abs/quant-ph/0604172 
[ChiSchVaz2007] Andrew M. Childs, Leonard J. Schulman, Umesh V. Vazirani, 2007, Quantum algorithms for hidden nonlinear structures. Proc. 48th IEEE Symposium on Foundations of Computer Science (FOCS 2007), pp. 395-404 http://arxiv.org/abs/0705.2784 
[ChiWoc2005] Andrew M. Childs, Pawel Wocjan, 2005, 
88
On the quantum hardness of solving isomorphism problems as nonabelian hidden shift problems . Quantum Information and Computation, Vol. 7, No. 5-6 (2007) 504-521 http://arxiv.org/abs/quant-ph/0510185 
[CosPor2007] Carlos Magno M. Cosme and Renato Portugal, 2007, Quantum algorithm for the hidden subgroup problem on a class of semidirect product groups. http://arxiv.org/abs/quant-ph/0703223v2 
[Dam1988] Ivan Damgård, 1988, On the Randomness of Legendre and Jacobi Sequences. Proceedings of the 8th Annual International Cryptology Conference on Advances in Cryptology, pp. 163-172 
[Dam2001] Ivan Damgård, 2001, QIP note: on the quantum Fourier transform and applications. http://www.daimi.au.dk/~ivan/fourier.pdf 
[DamHalIp2002] Wim van Dam, Sean Hallgren, Lawrence Ip, 2002, Quantum Algorithms for some Hidden Shift Problems. Proceedings of the ACM-SIAM Symposium on Discrete Algorithms, pages 489-498 (2003) http://arxiv.org/abs/quant-ph/0211140 
[DecDraWoc2007] Thomas Decker, Jan Draisma, Pawel Wocjan, 2007, Efficient Quantum Algorithm for Identifying Hidden Polynomials. http://arxiv.org/abs/0706.1219 
[DecWoc2007] Thomas Decker, Pawel Wocjan, 2007, Efficient Quantum Algorithm for Hidden Quadratic and Cubic Polynomial Function Graphs. http://arxiv.org/abs/quant-ph/0703195 
[DenMooRus2008] Aaron Denney, Cristopher Moore and Alexander Russell, 2008 Finding conjugate stabilizer subgroups in PSL(2; q) and related groups. http://arxiv.org/abs/0809.2445 
[DeuJoz1992] David Deutsch and Richard Jozsa, 1992, Rapid Solution of Problems by Quantum Computation. Proceedings: Mathematical and Physical Sciences, Volume 439, Issue 1907, pp. 553-558 
[EttHøy1998] Mark Ettinger and Peter Høyer, 1998, On Quantum Algorithms for Noncommutative Hidden Subgroups. http://arxiv.org/abs/quant-ph/9807029 
[EttHøyKni1999] Mark Ettinger, Peter Høyer and Emanuel Knill, 1999, Hidden Subgroup States are Almost Orthogonal. http://arxiv.org/abs/quant-ph/9901034 
[FenZha2006] S. A. Fenner, Y. Zhang, 2006, The central nature of the Hidden Subgroup problem. http://arxiv.org/abs/cs/0610086 
89
[FlaPrz2004] Abraham D. Flaxman and Bartosz Przydatek, 2004 Solving Medium-Density Subset Sum Problems in Expected Polynomial Time. http://eref.uqu.edu.sa/files/solving_medium_density_subset_sum_proble.pdf 
[FriEtAl2002]  Katalin  Friedl, Gábor Ivanyos, Frédéric  Magniez, Miklos Santha  and  Pranab  Sen, 2002, Hidden Translation and Orbit Coset in Quantum Computing. http://arxiv.org/abs/quant-ph/0211091 
[FriEtAl2002bis] Katalin Friedl, Frederic Magniez, Miklos Santha, Pranab Sen, 2002, Quantum testers for hidden group properties. http://arxiv.org/abs/quant-ph/0208184 
[Gav2004] Dmitry Gavinsky, 2004, Quantum Solution to the Hidden Subgroup Problem for Poly-Near-Hamiltonian Groups. http://www.nec-labs.com/~dmitry/papers/G03_j.pdf 
[GriSchVaz2000] Michelangelo Grigni, Leonard Schulman and Umesh Vazirani 2000, Quantum Mechanical Algorithms for the Nonabelian Hidden Subgroup Problem. http://math.ucdavis.edu/~vazirani/Papers/hidden.subgroup.pdf 
[Hal2002] Sean Hallgren, 2002, Polynomial-Time Quantum Algorithms for Pell's Equation and the Principal Ideal Problem. STOC '02: Proceedings of the thirty-fourth annual ACM symposium on Theory of computing Journal of the ACM, 54(1):1-19, 2007. http://www.cse.psu.edu/~hallgren/pell.pdf 
[Hal2005] Sean Hallgren, 2005, Fast Quantum Algorithms for Computing the Unit Group and Class Group of a Number Field. STOC '05: Proceedings of the thirty-seventh annual ACM symposium on Theory of computing http://www.cse.psu.edu/~hallgren/unitgroup.pdf 
[HalRoeSen2005] Sean Hallgren, Martin Roetteler and Pranab Sen, 2005, Limitations of Quantum Coset States for Graph Isomorphism. http://arxiv.org/abs/quant-ph/0511148 
[HalRusTa-2000] Sean Hallgren, Alexander Russel and Amnon Ta-Shma, 2000 Normal Subgroup Reconstruction and Quantum Computation Using Group Representations. http://www.cs.tau.ac.il/~amnon/Papers/HRT.stoc00.ps 
[InuLeG2004] Yoshifumi Inui and Francois Le Gall, 2004, Efficient Quantum Algorithms for the Hidden Subgroup Problem over a Class of Semi-direct Product Groups. Quantum Information and Computation, Vol. 7, No. 5&6 (2007), 559-570 http://arxiv.org/abs/quant-ph/0412033 
[IvaEtAl2001] Gábor Ivanyos, Frédéric Magniez, Miklos Santha, 2001, Efficient quantum algorithms for some instances of the non-Abelian hidden subgroup problem. http://arxiv.org/abs/quant-ph/0102014 
90
[IvaSanSan2007] Gábor Ivanyos, Luc Sanselme and Miklos Santha, 2007, An efficient quantum algorithm for the hidden subgroup problem in extraspecial groups. stacs 2007 http://arxiv.org/abs/quant-ph/0701235 
[IvaSanSan2007bis] Gábor Ivanyos, Luc Sanselme and Miklos Santha, 2007, An efficient quantum algorithm for the hidden subgroup problem in nil-2 groups. http://arxiv.org/abs/0707.1260 
[Kit1995] A.Yu.Kitaev, 1995, Quantum measurements and the Abelian Stabilizer Problem. http://arxiv.org/abs/quant-ph/9511026 
[KroRöt2008] Hari Krovi and Martin Rötteler, 2008, An Efficient Quantum Algorithm for the Hidden Subgroup Problem over Weyl-Heisenberg Groups . http://arxiv.org/abs/0810.3695 
[Kup2003] Greg Kuperberg, 2003, A subexponential-time quantum algorithm for the dihedral hidden subgroup problem. http://arxiv.org/abs/quant-ph/0302112 
[Köb1993] Johannes Köbler, 1993, The Graph Isomorphism Problem : Its Structural Complexity. Progress in Theoretical Computer Science - Boston: Birkhäuser, 1993 
[Lom2004] Chris Lomont, 2004, The Hidden Subgroup Problem Review and Open Problems. http://arxiv.org/abs/quant-ph/0411037 
[Lom2010] Samuel J. Lomonaco, 2010, (private communication) 
[LomKau2006] Samuel J. Lomonaco and Louis H. Kauffman, 2006, Is Grover's Algorithm a Quantum Hidden Subgroup Algorithm ?. http://arxiv.org/abs/quant-ph/0603140 
[Lyu2004] Vadim Lyubashevsky, 2004 On Random High Density Subset Sums. http://eccc.uni-trier.de/report/2005/007/download/ 
[MicGol2002] Daniele Micciancio and Shafi Goldwasser, 2002, Complexity of Lattice Problems: a cryptographic perspective 
[MicReg2008] Daniele Micciancio and Oded Regev, 2008, chapter Lattice-based Cryptography, from Post-Quantum Cryptography, Springer Berlin Heidelberg. http://www.cs.tau.ac.il/~odedr/papers /pqc.pdf 
[Mon2008] Ashley Montanaro, 2008, Quantum algorithms for shifted subset problems. 
91
Quantum Information & Computation vol. 9 no. 5&6, pp. 500-512, 2009 http://arxiv.org/abs/0806.3362 
[MooEtAl2005] Cristopher Moore, Daniel Rockmore, Alexander Russell and Leonard J. Schulman, 2005, The Power of Strong Fourier Sampling: Quantum Algorithms for Affine Groups and Hidden Shifts . http://arxiv.org/abs/quant-ph/0503095 
[MooRusSch2005] Cristopher Moore, Alexander Russell, Leonard J. Schulman, 2005, The Symmetric Group Defies Strong Fourier Sampling: Part I. http://arxiv.org/abs/quant-ph/0501056 
[MooRusSni2006] Cristopher Moore, Alexander Russell, Piotr Sniady, 2006, On the impossibility of a quantum sieve algorithm for graph isomorphism: unconditional results. STOC '07: Proceedings of the thirty-ninth annual ACM symposium on Theory of computing, pages 536-545, New York, NY, USA, 2007. ACM Press http://arxiv.org/abs/quant-ph/0612089 
[MooRusVaz2007] Cristopher Moore, Alexander Russell, Umesh Vazirani, 2007, A classical one-way function to confound quantum adversaries. http://arxiv.org/abs/quant-ph/0701115 
[NieChu2007] Michael A. Nielsen and Isaac L. Chuang 2007, Quantum Computation and Quantum Information (ninth printing). 
[OsbSev2004] Tobias J. Osborne, Simone Severini, 2004, Quantum Algorithms and Covering Spaces. http://arxiv.org/abs/quant-ph/0403127 
[RadRötSen2005] Jaikumar Radhakrishnan, Martin Rötteler and Pranab Sen, 2005, On the Power of Random Bases in Fourier Sampling: Hidden Subgroup Problem in the Heisenberg Group. http://arxiv.org/abs/quant-ph/0501044 
[Reg2003] Oded Regev, 2003, Quantum Computation and Lattice Problems. http://arxiv.org/abs/cs/0304005 
[Reg2003bis] Oded Regev, 2003, New Lattice Based Cryptographic Constructions. http://arxiv.org/abs/cs/0309051v1 
[Reg2004] Oded Regev, 2004, A Subexponential  Time  Algorithm for  the  Dihedral  Hidden  Subgroup  Problem with  Polynomial Space. http://arxiv.org/abs/quant-ph/0406151 
[Röt2008] Martin Rötteler, 2008, Quantum algorithms for highly non-linear Boolean functions. to  appear  in  Proceedings  of  the  21st  Annual  ACM-SIAM  Symposium  on  Discrete  Algorithms 
92
(SODA'10) http://arxiv.org/abs/0811.3208 
[Röt2009] Martin Rötteler, 2009, Quantum algorithms to  solve  the  hidden  shift  problem for  quadratics  and  for  functions of large Gowers norm. Proc. MFCS'09, LNCS vol. 5734, pp. 663-674, 200 http://arxiv.org/abs/0911.4724 
[RötBet1998] Martin Rötteler and Thomas Beth, 1998, Polynomial-Time Solution to the Hidden Subgroup Problem for a Class of non-abelian Groups. http://arxiv.org/abs/quant-ph/9812070 
[Sch1978] Thomas J. Schaefer, 1978, "The complexity of satisfiability problems" Proceedings of the 10th Annual ACM Symposium on Theory of Computing. http://www.ccs.neu.edu/home/lieber/courses/csg260/f06/materials/papers/max-sat/p216-schaefer.pdf 
[SchUnr2003] R. Schützhold, W. G. Unruh, 2003, Hidden symmetry detection on a quantum computer. http://arxiv.org/abs/quant-ph/0304090 
[Ser1971] Jean-Pierre Serre, 1971, Représentations linéaires des groupes finis. 
[Sho1995] Peter W. Shor, 1995, Polynomial-Time  Algorithms  for  Prime  Factorization  and  Discrete  Logarithms  on  a  Quantum Computer. http://arxiv.org/abs/quant-ph/9508027 
[Sim1994] Daniel R. Simon, 1994, On the power of quantum computation. Foundations of Computer Science, 1994 Proceedings., 35th Annual Symposium http://www.hep.princeton.edu/~mcdonald/examples/QM/simon_siamjc_26_1474_97.pdf 
[Spi1996] Daniel Spielman, 1996, Faster isomorphism testing of strongly regular graphs. STOC '96: Proceedings of the twenty-eighth annual ACM symposium on Theory of computing 
[Wat2000] John Watrous, 2000, Quantum algorithms for solvable groups. http://arxiv.org/abs/quant-ph/0011023 
[Zal1997] Christof Zalka, 1997, Grover's quantum searching algorithm is optimal. Phys.Rev. A60 (1999) 2746-2751 http://arxiv.org/abs/quant-ph/9711070 
93