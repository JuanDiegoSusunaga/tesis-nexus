# Generalized LRS Estimator for Min-entropy Estimation - arXiv

- **ID**: `eb8b93d4-4b25-42d1-9333-8e61c5a3279f`
- **Tipo de Fuente**: `SOURCE_TYPE_PDF`
- **URL**: [https://arxiv.org/pdf/2112.09376](https://arxiv.org/pdf/2112.09376)

---

## Contenido Extraído / Texto Completo

 
 
 
 
 
 
 
 
 
 
 
 
Generalized LRS Estimator for 
Min-entropy Estimation 
Jiheon Woo, Chanhee Yoo, Young-Sik Kim, Yuval Cassuto, and Yongjune Kim 
Abstract—The min-entropy is a widely used metric to quantify the randomness of generated random numbers, which measures the difficulty of guessing the most likely output. It is difficult to accurately estimate the min-entropy of a non-independent and identically distributed (non-IID) source. Hence, NIST Spe-cial Publication (SP) 800-90B adopts ten different min-entropy estimators and then conservatively selects the minimum value among ten min-entropy estimates. Among these estimators, the longest repeated substring (LRS) estimator estimates the collision entropy instead of the min-entropy by counting the number of repeated substrings. Since the collision entropy is an upper bound on the min-entropy, the LRS estimator inherently provides overestimated outputs. In this paper, we propose two techniques to estimate the min-entropy of a non-IID source accurately. The first technique resolves the overestimation problem by translating the collision entropy into the min-entropy. Next, we generalize the LRS estimator by adopting the general Rényi entropy instead of the collision entropy (i.e., Rényi entropy of order two). We show that adopting a higher order can reduce the variance of min-entropy estimates. By integrating these techniques, we propose a generalized LRS estimator that effectively resolves the overestimation problem and provides stable min-entropy estimates. Theoretical analysis and empirical results support that the proposed generalized LRS estimator improves the estimation accuracy significantly, which makes it an appealing alternative to the LRS estimator. 
I. INTRODUCTION 
Random numbers are essential for generating cryptographic 
information such as secret keys, nonces, salt values, etc. The 
security of cryptographic systems crucially relies on the ran-
domness of the generated random numbers [1]–[4]. Hence, it is 
critical to quantify the randomness of the generated numbers 
accurately. Among several ways to quantify randomness of 
generated random numbers, entropies are widely used metrics 
in standards such as AIS.31 [5], NIST Special Publication (SP) 
800-22 [6], and NIST SP 800-90B [1]. 
There are several kinds of entropies such as Shannon 
entropy, Rényi entropy, and min-entropy. Among them, the 
min-entropy is a well-justified metric in cryptographic appli-
cations [1], [3] since the min-entropy measures the difficulty 
of guessing the most likely output. Furthermore, the min-
entropy is a lower bound on the Shannon entropy and the 
Rényi entropy, i.e., one of the most conservative metrics. 
J. Woo and C. Yoo contributed equally. J. Woo, C. Yoo, and Y. Kim are with the Department of Information and Communication Engineering, Daegu Gyeongbuk Institute of Science and Technology (DGIST), Daegu 42988, South Korea (e-mail: {jhwoo1997, yoo1209, yjk}@dgist.ac.kr). Y.-S. Kim is with the Department of Information and Communication Engineering, Chosun University, Gwangju 61452, South Korea (e-mail: iamyskim@chosun.ac.kr). Y. Cassuto is with the Viterbi Department of Electrical and Computer Engineering, Technion–Israel Institute of Technology, Haifa 32000, Israel (e-mail: ycassuto@ee.technion.ac.il). 
For independent and identically distributed (IID) sources, 
the min-entropy can be readily estimated by the empirical 
estimator [1]. However, it is difficult to estimate the min-
entropy of non-IID sources accurately. Hence, NIST SP 800-
90B proposes ten different min-entropy estimators for non-
IID sources (see Table I). These estimators independently 
perform their own estimations based on different statistics 
of the examined non-IID sources. Then, NIST SP 800-90B 
conservatively selects the minimum among these ten different 
values as the final estimate of min-entropy. 
Among the ten min-entropy estimators, the longest repeated 
substring (LRS) estimator estimates the collision entropy (the 
Rényi entropy of order two) based on the number of repeated 
substrings, i.e., collision counts [1]. Since the collision entropy 
is an upper bound on the min-entropy, the LRS estimator 
overestimates the min-entropy, which violates the conservative 
estimation of NIST SP 800-90B. NIST SP 800-90B selects 
the minimum among ten estimates as the final min-entropy 
estimate; hence, the overestimated value by the LRS estimator 
would typically not affect the final estimate, which could 
undermine the justification to include the LRS estimator in 
NIST SP 800-90B. 
In this paper, we propose two techniques to amend the 
LRS estimator for accurate min-entropy estimation. The first 
technique resolves the overestimation problem by enabling 
the estimation of the min-entropy instead of the collision 
entropy. The proposed technique leverages the inequality of 
[7, Theorem 6], which characterizes the relation between 
the min-entropy and the Rényi entropy. For this technique, 
we show that the proposed estimator is almost unbiased for 
binary sources, which are the most common sources. Next, 
we generalize the LRS estimator by parameterizing the order, 
i.e., α of the Rényi entropy. By adopting a higher order α 
than two of the collision entropy, the variance of min-entropy 
estimates can be reduced, which leads to more stable estimates. 
We analytically show that the variance of estimates decreases 
with α, although the reduction of the variance diminishes as 
α increases. 
By integrating these two techniques, we propose a general-
ized LRS estimator that improves the estimation accuracy by 
twofold: 1) the bias is reduced by resolving the overestimation 
problem of the LRS estimator; 2) the variance of the min-
entropy estimates is reduced by adopting the higher order of 
the Rényi entropy. Theoretical analysis and empirical results 
support that the generalized LRS estimator significantly im-
proves the estimation accuracy of the LRS estimator, although 
both the LRS estimator and the proposed estimator rely on 
the same statistics, i.e., counts of repeated substrings. We
 TABLE I CLASSIFICATION OF NIST SP 800-90B ESTIMATORS [1], [8] 
Statistic-based estimator [2] Prediction-based estimator [3] 
Most common value estimator MultiMCW prediction estimator 
Collision estimator Lag prediction estimator 
Markov estimator MultiMMC prediction estimator 
Compression estimator LZ78Y prediction estimator 
t-Tuple estimator 
LRS estimator 
believe that the generalized LRS estimator is an appealing 
alternative to the LRS estimator of NIST SP 800-90B since 
the generalized LRS estimator outputs a more accurate and 
stable min-entropy estimate from the same statistics of a given 
sequence. 
The rest of this paper is organized as follows. Section II 
briefly explains the several types of entropies and the LRS 
estimator of NIST SP 800-90B. Section III presents the 
improved LRS estimator that accurately estimates the min-
entropy. Section IV proposes the generalized LRS estimator 
that enables more stable estimation. Section V provides nu-
merical results and Section VI concludes. 
II. PRELIMINARIES: ENTROPIES AND LRS ESTIMATOR 
A. Entropies and Power Sum 
Suppose that the input sequence s = (s1, . . . , sL), where 
si ∈ {x1, . . . , xk} is generated from a given source S. The 
Shannon entropy is defined as 
H(S) = H(p) = − k∑ 
i=1 
pi log2 pi, (1) 
where p = (p1, . . . , pk) denotes the distribution of S. 
The Rényi entropy of order α ∈ (0, 1) ∪ (1,∞) is defined 
as 
Hα(S) = Hα(p) = 1 
1− α log2 
k∑ 
i=1 
pαi . (2) 
For α = 2, the Rényi entropy corresponds to the collision 
entropy H2(S) as follows: 
H2(S) = H2(p) = − log2 
k∑ 
i=1 
p2i . (3) 
The min-entropy is defined as 
H∞(S) = H∞(p) = − log2 θ, (4) 
where 
θ = max i∈{1,...,k} 
{pi}. (5) 
Definition 1 (Power Sum): The power sum of order α (i.e., 
the αth moment) for a distribution p is defined as 
Mα(p) = 
k∑ 
i=1 
pαi . (6) 
Remark 2 (Collision Probability): The power sum of order 
α = 2 (i.e., M2(p)) is equivalent to the collision probability, 
Algorithm 1 LRS estimator of NIST 800-90B [1] 
Input: Sequence s = (s1, . . . , sL) where si ∈ {x1, . . . , xk}. 
Output: Collision entropy H2(S). 
1: Find the smallest u such that the number of occurrences 
of the most common u-tuple in s is less than 35. 
2: Find the largest v such that the number of occurrences of 
the most common v-tuple in s is at least 2. ⊲ Longest 
repeated substring problem 
3: for w ∈ {u, u+ 1, . . . , v} do 
4: Estimate the estimated w-tuple collision probability: 
Pw := 
∑ i 
( Ci 
2 
) ( l 2 
) , (9) 
where Ci is the number of occurrences of the ith unique 
w-tuple and l is the total number of w-tuples. 
5: Compute the collision probability per sample: 
P̃w := P 1/w w . (10) 
6: end for 
7: p̂c := max { P̃u, . . . , P̃v 
} . 
8: p̃c := min 
{ 1, p̂c + 2.576 
√ p̂c(1−p̂c) L−1 
} . 
9: H2(S) := − log2 p̃c. 
which is the probability that two arbitrary source outputs are 
equal. 
Remark 3: The Rényi entropy of order α is Hα(p) = 1 
1−α log2Mα(p). Remark 4: The following relations are well known: 
H(S) = lim α→1 
Hα(S), (7) 
H∞(S) = lim α→∞ 
Hα(S). (8) 
Remark 5: The Rényi entropy is non-increasing in α [9]. 
Hence, ∀α,H∞(S) ≤ Hα(S), i.e., the min-entropy is a lower 
bound on the Shannon entropy and the Rényi entropy. 
B. LRS Estimator and Its Overestimation Problem 
For non-IID sources, NIST SP 800-90B proposes ten dif-
ferent min-entropy estimators (see Table I). These estimators 
independently perform their own estimations based on differ-
ent statistics calculated from the examined non-IID sources. 
Among these ten estimators, the t-tuple estimator and the 
LRS estimator compute entropies based on the frequency 
of substrings (tuples) in the input sequence s. The t-tuple 
estimator estimates the min-entropy based on the frequency 
of some fixed-length repeated substrings. The LRS estimator 
handles substring sizes that are too large for the t-tuple 
estimator [1], [8]. 
Algorithm 1 describes the LRS estimator in NIST SP 800-
90B. Step 1 finds the smallest u such that the number of 
occurrences of the most common u-tuple is less than 35. Step 
2 solves the well-known longest repeated substring problem 
and set v as its length. Then, the range of w becomes 
{u, u + 1, . . . , v}. In contrast, the t-tuple estimator finds the 
largest t such that the number of occurrences of the most
 common t-tuple is at least 35 and the range of w in that test 
equals {1, . . . , t} where t < u. Note that the t-tuple estimator 
and the LRS estimator calculate the entropies based on disjoint 
substring lengths, where the LRS estimator handles the longer 
substrings. Hence, the t-tuple estimator and the LRS estimator 
are complementary. 
The LRS estimator estimates collision entropy instead of 
the min-entropy. Step 4 calculates the empirical collision 
probability of length-w substrings. The LRS estimator of NIST 
SP 800-90B uses overlapped tuples, i.e., l = L − w + 1 in 
Step 4. For non-overlapped tuple counts, the total number of 
w-tuples becomes l = ⌊ L w 
⌋ . 
The collision probability estimation by (9) is a key step 
of the LRS estimator, which was considered in [10], [11] for 
testing whether a distribution is close to uniform. Note that 
(9) is an unbiased estimator of the collision probability [12]. 
Step 5 computes the collision probability per sample (to 
normalize the estimated entropy) and Step 7 conservatively 
chooses the maximum (across w) collision probability (i.e., 
the minimum collision entropy). Step 8 ensures the confidence 
level of 99 % under the Gaussian assumption. Although Step 
7 and Step 8 follow the conservative approach of NIST SP 
800-90B, the LRS estimator overestimates the min-entropy 
since Step 9 estimates the collision entropy instead of the min-
entropy. 
Fig. 1 shows the ramifications from the fact that the LRS 
estimator estimates the collision entropy instead of the min-
entropy. The bias between the actual min-entropy and the 
estimate by the LRS estimator is considerable except for 
p = 0.5. The numerical results in [13, Table 2 and 3] also 
confirm this overestimation problem for the first-order Markov 
source and several pseudo-random data. 
NIST SP 800-90B conservatively selects the minimum 
among estimated values by ten estimators. Hence, an over-
estimated value by the LRS estimator would not affect the 
final estimate. Since the LRS estimator computes based on 
larger sizes of susbtrings than the t-tuple estimator, the LRS 
estimator takes around ten times longer execution time than 
the t-tuple estimator [8, Table V]. In spite of this considerable 
execution time, the LRS estimator rarely affects the final min-
entropy estimate due to overestimation problem noted above. 
III. MIN-ENTROPY ESTIMATION BY LRS ESTIMATOR 
A. Min-entropy Estimation by LRS Estimator 
In this section, we propose a method to resolve the overes-
timation problem of the LRS estimator. The proposed method 
attempts to estimate the min-entropy instead of the collision 
entropy by using the estimation values of the LRS estimator 
and the following bound. 
Lemma 6 ([7, Theorem 6]): Suppose that θ = maxi∈{1,...,k}{pi}. Then, the following inequality holds: 
Hα(S) ≤ 1 
1− α log2 
( θα + 
(1− θ)α 
(k − 1)α−1 
) (11) 
0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 
p 
0.1 
0.2 
0.3 
0.4 
0.5 
0.6 
0.7 
0.8 
0.9 
1 
E nt 
ro py 
Min-entropy Collision entropy Estimated min-entropy by LRS 
Fig. 1. Comparison of min-entropy, collision entropy and estimated value by LRS estimator for binary memoryless source (BMS) with parameter p. While the LRS estimator has a small underestimation gap to the true collision entropy (due to Step 8 in Algorithm 1), its overestimation gap (bias) to the min-entropy is significant. 
for α 6= 1. The bound is achieved with equality by the near-
uniform distribution pNU(θ) = (p1, . . . , pk) where 
pi = 
{ θ, if i = 1; 1−θ k−1 , otherwise. 
(12) 
Without loss of generality, p1 ≥ . . . ≥ pk is assumed. 
The bound (11) is the counterpart of Fano’s inequality, 
which applies to the Shannon entropy. 
Theorem 7: For the estimated collision probability p̂c by 
Algorithm 1, the following inequality holds: 
θ ≤ √ (k − 1)(pck − 1) + 1 
k , (13) 
where pc = E(p̂c). Since the near-uniform distribution 
achieves (11) with equality, (13) is the sharp upper bound. 
Proof: For α > 1, (11) leads to 
Mα(p) ≥ θα + (1 − θ)α 
(k − 1)α−1 . (14) 
Since M2(p) is equivalent to the collision probability pc [12], 
we can set pc ≥ θ2 + (1−θ)2 (k−1) . By (5), it is clear that θ ≥ 1 
k . 
Since θ2+ (1−θ)2 (k−1) is a non-decreasing function of θ for θ ≥ 1 
k , 
(13) holds. 
Based on Theorem 7, we estimate θ̂ as follows: 
θ̂ = 
√ (k − 1)(p̂ck − 1) + 1 
k , (15) 
which is a conservative min-entropy estimation. It is because 
an upper bound on θ leads to a lower bound on H∞(S), i.e., 
H∞(S) = − log2 θ ≥ − log2 θ̂ (16) 
if p̂c = pc. 
Algorithm 2 describes the proposed min-entropy estimator. 
Algorithm 2 enables estimating the min-entropy instead of 
the collision entropy by leveraging the LRS estimator. Step 
1 of Algorithm 2 estimates the collision probability by using
 Algorithm 2 Proposed Estimator (Improved LRS Estimator) 
Input: Sequence s = (s1, . . . , sL) where si ∈ {x1, . . . , xk}. 
Output: Min-entropy H∞(S). 
1: Estimate p̂c from s by Algorithm 1. 
2: if p̂c > 1 k then 
3: θ̂ := 
√ (k−1)(p̂ck−1)+1 
k . 
4: else 
5: θ̂ := 1 k . 
6: end if 
7: θ̃ := min 
( 1, θ̂ + 2.576 
√ θ̂(1−θ̂) L−1 
) . 
8: H∞(S) := − log2 θ̃. 
Algorithm 1. Theoretically, pc ≥ 1 k where the equality is 
achieved by the uniform distribution. If p̂c < 1 k , then we know 
that it results from estimation errors. Hence, in this case we set 
p̂c = 1 k , which leads to θ̂ = 1 
k . Step 7 ensures the confidence 
level of 99 % as in Step 8 of Algorithm 1. 
The proposed estimator attempts to estimate a lower bound 
on the min-entropy whereas the LRS estimator estimates 
an upper bound on the min-entropy (i.e., collision entropy). 
The proposed estimator matches the conservative approach of 
NIST SP 800-90B. It is worth mentioning that the collision 
estimator and the compression estimator of NIST SP 800-
90B (Table I) also estimate lower bounds on the min-entropy 
by using the near-uniform distribution as in the proposed 
estimator. Hence, the proposed estimator is better aligned with 
other estimators of NIST SP 800-90B than the LRS estimator. 
Importantly, the proposed estimator is unbiased for binary 
sources (i.e., it estimates the min-entropy itself instead of the 
lower bound since any binary distributions are near-uniform). 
In the next subsection, we further investigate the proposed 
estimator’s bias properties. 
B. Bias of Proposed Estimator 
We investigate the biases of the conventional LRS estimator 
and the proposed estimator. For the analysis, we neglect the 
step for 99 % confidence interval. Hence, p̂c and θ̂ instead of 
p̃c and θ̃ are considered in our analysis. 
The bias of the LRS estimator is given by 
bLRS(S) = E(− log2 p̂c)−H∞(S). (17) 
Proposition 8: The LRS estimator is overestimating, i.e., 
bLRS(S) > 0. 
Proof: We show that bLRS(S) > 0 as follows: 
bLRS(S) = E(− log2 p̂c)−H∞(S) 
> − log2 E(p̂c)−H∞(S) (18) 
= H2(S)−H∞(S) (19) 
≥ 0 (20) 
where (18) follows from Jensen’s inequality. Since − logx is 
strictly convex and p̂c is not constant for non-deterministic 
sources (18) holds. Also, (20) follows from Remark 5. Hence, 
bLRS(S) > 0. 
As shown in Fig. 1, H2(S)−H∞(S) can be large for BMS 
with p < 0.5. Hence, the LRS estimator suffers from the severe 
overestimation problem. 
The bias of the proposed estimator is given by 
bproposed(S) = E(− log2 θ̂)−H∞(S) > log2 θ 
E(θ̂) , (21) 
where log2 θ 
E(θ̂) ≤ 0 since θ̂ is an estimate of the upper bound 
on θ (see Theorem 7). If E(− log2 θ̂) ≃ − log2 E(θ̂), then the 
proposed estimator would be an underestimated estimator. 
Since NIST SP 800-90B conservatively estimates the min-
entropy, the proposed estimator is better aligned with NIST 
SP 800-90B than the LRS estimator. Further, we will show 
that the proposed estimator is unbiased for binary sources (see 
Corollary 14 and Remark 15). 
We characterize the bias bproposed(S) by the sharp1 lower and 
upper bounds on θ for a given collision probability pc. The 
sharp upper bound on θ is given in Theorem 7. We derive the 
sharp lower bound on θ by using the inverted near-uniform 
distribution. In [2], the inverted near-uniform distribution is 
defined as pINU(ψ) = (p1, . . . , pk) where 
pi = 
   
ψ, if i ∈ { 1, . . . , 
⌊ 1 ψ 
⌋} ; 
1− ⌊ 
1 ψ 
⌋ ψ, if i = 
⌊ 1 ψ 
⌋ + 1; 
0, otherwise. 
(22) 
Note that ψ = max{pINU(ψ)}. 
Lemma 9: For 1 n+1 < ψ ≤ 1 
n where n ∈ N, the following 
relation holds: ⌊ 1 
ψ 
⌋ = 
⌊ 1 
M2(pINU(ψ)) 
⌋ = n. (23) 
Proof: If ψ = 1 n , then 
M2(pINU(ψ)) = 1 
n . (24) 
Hence, (23) holds. 
If 1 n+1 < ψ < 1 
n , then M2(pINU(ψ)) is an increasing 
function of ψ. It is because dM2(pINU(ψ)) 
dψ = 2n(n + 1){ψ − 1 
n+1} > 0. By (24), we obtain 1 n+1 < M2(pINU) < 
1 n . Then, 
(23) holds. 
Remark 10: For an inverted near uniform distribution, 
Lemma 9 shows that the collision entropy is close to the min-
entropy since ψ ≃ M2(pINU). If ψ = 1 n , then the collision 
entropy is the same as the min-entropy. 
Theorem 11: For any distribution p = (p1, . . . , pk) with 
n = ⌊ 
1 pc 
⌋ , the following inequalities hold: 
ψ ≤ θ ≤ θ̂ (25) 
where 
ψ = 
√ n {pc(n+ 1)− 1}+ n 
n(n+ 1) , (26) 
θ̂ = 
√ (k − 1)(pck − 1) + 1 
k . (27) 
1The term “sharp bound” means that there exists a distribution that achieves this bound with equality.
 Proof: Since θ̂ is derived in Theorem 7, we need to 
derive only the sharp lower bound ψ. The lower bound ψ 
is achieved with equality by the inverted near-uniform distri-
bution pINU(ψ) [2], [14]. Hence, we need to identify pINU(ψ) satisfying M2(pINU(ψ)) = pc. Suppose that 1 
n+1 < ψ ≤ 1 n 
where n ∈ N (i.e., ⌊ 
1 ψ 
⌋ = n). By (22) and Lemma 9, we 
obtain M2(pINU(ψ)) = nψ2 + (1 − nψ)2 = pc, which leads 
to (26). 
Remark 12: For a given collision probability pc, the sharp 
lower and upper bounds on the min-entropy are given by 
− log2 θ̂ ≤ H∞(p) ≤ − log2 ψ, (28) 
where H∞(p) = − log2 θ. 
We note that ψ depends only on pc because n = ⌊ 
1 pc 
⌋ . On 
the other hand, θ̂ depends on pc and k (alphabet size |S|). For 
given pc and k, we define the estimation gap of θ as 
g(pc, k) = θ̂ − ψ, (29) 
which is the maximum possible bias. The following theorem 
shows that the estimation gap increases with k. 
Theorem 13: For non-deterministic sources, the estimation 
gap g(pc, k) = θ̂ − ψ increases with k. 
Proof: Since ψ does not depend on k, we show that θ̂(k) is an increasing function of k. The derivative of θ̂(k) is given 
by 
dθ̂(k) 
dk = pck + k − 2− 2 
√ (k − 1)(pck − 1) 
2k2 √ (k − 1)(pck − 1) 
. (30) 
We can set pc > 1 k because pc = 1 
k means that p is the 
uniform distribution, i.e., ψ = θ̂ = 1 k and H∞(p) = log2 k. 
By the arithmetic-geometric mean inequality, 
pck+k−2 = (pck−1)+(k−1) ≥ 2 √ (k − 1)(pck − 1). (31) 
Hence, dθ̂(k) dk > 0 for pc < 1. Note that pc < 1 for non-
deterministic sources. 
Corollary 14: For binary sources with k = 2, the estimation 
gap is zero, i.e., g(pc, k = 2) = 0. 
Proof: For binary sources, it is clear that θ ≥ 1 2 . For 
θ = 1 2 , p corresponds to the binary uniform distribution, the 
gap is zero. For θ > 1 2 , we can set n = 1 in (23) because 
1 2 < ψ < 1. By setting n = 1 and k = 2, (26) and (27) are 
identical, i.e., θ = ψ = θ̂ = √ 2pc−1+1 
2 . 
Remark 15 (Unbiasedness): The proposed estimator is un-
biased for binary sources. Since most random sources are 
binary or can be represented by binary sequences, the proposed 
estimator improves the accuracy of the LRS estimator. 
Fig. 2(a) shows that the near-uniform distribution and the 
inverted near-uniform distribution correspond to the upper and 
lower bounds on θ, respectively. Also, it shows that ψ = θ̂ 
for k = 2, i.e., the proposed estimator is unbiased for binary 
souces. Fig. 2(b) shows the relation between the collision en-
tropy and the min-entropy where the near-uniform distribution 
and the inverted near-uniform distribution correspond to the 
lower and upper bounds on the min-entropy. 
We note that the final min-entropy estimation could not be 
perfectly unbiased because of the two steps of the original LRS 
0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 
Collision probability 
0.2 
0.3 
0.4 
0.5 
0.6 
0.7 
0.8 
0.9 
1 
m ax 
(p ) 
Near-uniform distribution (k=2) Near-uniform distribution (k=3) Near-uniform distribution (k=4) Near-uniform distribution (k=5) Inverted near-uniform distribution 
(a) 
0 0.5 1 1.5 2 2.5 
Collision entropy 
0 
0.5 
1 
1.5 
2 
2.5 
M in 
-e nt 
ro py 
Near-uniform distribution (k=2) Near-uniform distribution (k=3) Near-uniform distribution (k=4) Near-uniform distribution (k=5) Inverted near-uniform distribution 
(b) 
Fig. 2. The relation of (a) the collision probability pc and θ = maxi∈{1,...,k} pi and (b) the collision entropy and the min-entropy for pNU 
and pINU. 
estimator. First, Step 7 of Algorithm 1 selects the maximum 
collision probability among v−u+1 candidates, which lowers 
the min-entropy estimates. Also, Step 8 of Algorithm 1 (or 
Step 7 of Algorithm 2) reduces the min-entropy estimates to 
ensure the confidence level of 99 %. These steps result from 
the conservative approach of NIST SP 800-90B. These extra-
confidence steps are also included in the other estimators of 
NIST SP 800-90B. 
IV. GENERALIZED LRS ESTIMATOR 
In this section, we propose a generalized LRS estimator by 
using the power sum of order α ≥ 2 instead of the collision 
probability (the power sum of order α = 2). We show that the 
generalized LRS estimator reduces the variance of estimates 
as the order α increases beyond 2. 
A. Generalized LRS Estimator 
The generalized LRS estimator is based on 1) the gener-
alized power sum Mα(p) and 2) the proposed technique in 
Algorithm 2.
 Algorithm 3 Generalized LRS estimator 
Input: Sequence s = (s1, ..., sL) and an integer α ≥ 2 Output: Min-entropy H∞(S). 
1: Find the smallest u such that the number of occurrences 
of the most common u-tuple in s is less than 35. 
2: Find the largest v such that the number of occurrences of 
the most common v-tuple in s is at least α. 
3: for w ∈ {u, u+ 1, . . . , v} do 
4: Estimate the w-tuple power sum of order α: 
M̂α,w := 
∑ i 
( Ci 
α 
) ( l α 
) , (32) 
where Ci is the number of occurrences of the ith unique 
w-tuple and l is the total number of w-tuples. 
5: M̃α,w := M̂ 1 w α,w. 
6: end for 
7: M̃α := max{M̃α,u, . . . , M̃α,v}. 
8: if M̃α > 1 
kα−1 then 
9: By the bisection method, solve the following equation 
for θ̂ ∈ [ 1 k , 1 
] : 
M̃α = θ̂α + (1 − θ̂)α 
(k − 1)α−1 . (33) 
10: else 
11: θ̂ := 1 k . 
12: end if 
13: θ̃ := min 
( 1, θ̂ + 2.576 
√ θ̂(1−θ̂) L−1 
) . 
14: H∞(S) := − log2 θ̃. 
The generalized LRS estimator is described in Algorithm 3. 
First, it estimates the power sum Mα(p) for a given α by Steps 
1–7. Step 2 of Algorithm 3 is modified to estimate Mα(p). Step 4 estimates the w-tuple power sum of order α by counting 
the α-wise collisions. Step 5 computes the power sum of order 
α per sample (to normalize the estimated min-entropy) and 
Step 7 conservatively chooses the maximum among estimated 
power sums of α, which is denoted by M̃α. 
The estimation M̂α(p) by (32) is a key step, which 
generalizes (9) in Algorithm 1. The estimation by (32) is 
unbiased [12], [15]. However, M̃α in Step 7 is an overestimate 
of Mα(p), which leads to an underestimate of the min-
entropy. We maintain this conservative approach as in the LRS 
estimator of Algorithm 1. 
Afterward, we estimate θ̂ from M̃α in Steps 8–12. First, 
we note that M̃α ≥ 1 kα−1 where the equality is achieved by 
the uniform distribution. Hence, we set θ̂ = 1 k in Step 11 
if M̃α < 1 
kα−1 . If M̃α > 1 
kα−1 , then θ̂ is estimated by (14), 
which is the sharp upper bound on θ. Especially, θ̂ is unbiased 
for binary sources k = 2 (see Corollary 14). Step 13 ensures 
the confidence level of 99 % under the Gaussian assumption. 
Finally, Step 14 estimates the min-entropy from θ̃. 
The proposed Algorithm 3 improves the bias and reduces 
the variance compared to the LRS estimator (Algorithm 1). 
The bias is improved since Algorithm 3 estimates the min-
entropy whereas the LRS estimator estimates the collision 
entropy as discussed in Section III-B. The variance can be 
reduced by using the higher-order power sum instead of the 
collision probability, which is supported by empirical results 
in Section V. In the following subsection, we provide a 
theoretical analysis of how the order α affects the variance 
of estimation. 
B. Variance of Generalized LRS Estimator 
In this subsection, we attempt to characterize how the order 
α affects the variance of θ̂ calculated by (33) in Algorithm 3. 
Suppose that θ̂α and θ̂α+1 are the estimated θ̂ in Algorithm 3 
by using M̃α and M̃α+1, respectively. We characterize the 
relation between α and Var(θ̂) = E(θ̂2)− E 2(θ̂). We assume 
that the length-w tuples counted in Algorithm 3 are non-
overlapping to simplify the analysis. 
Theorem 16: For a uniformly distributed s = (s1, . . . , sL) with a large L, the variance ratio’s dependence on α is as 
follows: 
ξ(α) = Var(θ̂α+1) 
Var(θ̂α) ≈ 
( α 
α+ 1 
)4 
, (34) 
where ≈ hides multiplicative terms that tend to 1 as L goes 
to infinity. 
Proof: The proof is given in Appendix B. 
Since ξ(α) < 1, Var(θ̂) decreases with α for high-entropy 
sources. The reduction of Var(θ̂α) diminishes as α increases. 
The range of w ∈ {u, . . . , v} is an important parameter that 
affects the variance of θ̂. It is clear that 
vα ≥ vα+1, u = uα = uα+1, (35) 
where vα and vα+1 are calculated by Step 2 of Algorithm 3 for 
α and α+1, respectively. Note that u in Algorithm 3 does not 
depend on α. The proof of Theorem 16 relies on this relation 
since the reduction of v leads to the reduction of Var(θ̂). 
Theorem 16 characterizes Var(θ̂) by (33), i.e., for M̃α > 1 
kα−1 . If M̃α < 1 kα−1 , then Step 11 sets θ̂ := 1 
k . It is 
because the power sum of order α cannot be lower than 1 
kα−1 (attained by the uniform distribution). It is difficult to 
analyze the probability of M̃α < 1 kα−1 due to Step 7 of 
M̃α := max{M̃α,u, . . . , M̃α,v} in Algorithm 3. 
Although Theorem 16 focuses on uniformly distributed 
sources, the following section empirically supports that Var(θ̂) decreases with α even for non-uniformly distributed sources. 
V. NUMERICAL RESULTS 
We evaluate our proposed estimators for simulated and 
real-world data samples. The empirical results show that the 
proposed estimator effectively reduces the bias problem of the 
LRS estimator. 
The following representative samples are considered as in 
[3], [16]: 
 Binary memoryless source (BMS): Samples are generated 
by Bernoulli distribution with P (S = 1) = p and P (S = 0) = 1− p (IID);
 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 
p 
0.1 
0.2 
0.3 
0.4 
0.5 
0.6 
0.7 
0.8 
0.9 
1 E 
nt ro 
py 
Min-entropy LRS estimator Proposed estimator ( =2) Proposed estimator ( =3) Proposed estimator ( =4) Proposed estimator ( =5) Proposed estimator ( =6) Proposed estimator ( =7) 
(a) 
0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 
p 
0 
0.001 
0.002 
0.003 
0.004 
0.005 
0.006 
0.007 
0.008 
0.009 
0.01 
0.011 
V ar 
ia nc 
e of 
 e st 
im at 
ed  m 
in -e 
nt ro 
py 
Proposed estimator ( =2) Proposed estimator ( =3) Proposed estimator ( =4) Proposed estimator ( =5) Proposed estimator ( =6) Proposed estimator ( =7) 
(b) 
Fig. 3. (a) Estimated min-entropy and (b) the variance of min-entropy estimates by the proposed generalized LRS estimator for the BMS sources with p. 
 Markov source: Samples are generated using the first-
order Markov model with P (Si+1 = 1|Si = 0) = P (Si+1 = 0|Si = 1) = p (non-IID); 
 Near-uniform distribution: Samples are generated by the 
near-uniform distribution with k = 64 (see (12)) (IID); 
 Inverted near-uniform distribution: Samples are gener-
ated by the inverted near-uniform distribution with k = 64 (see (22)) (IID). 
For each of the above sources, one thousand simulated sources 
were created in each of the above datasets. BMS source and 
Markov source generate a sequence of L = 100, 000 bits. The 
other sources generate a sequence of L = 10, 000 bits and 
k = 64. 
Fig. 3 compares the min-entropy estimators for BMS as 
a function of p. The theoretical min-entropy and collision 
entropy are given by H∞(S) = − log2 max{p, 1 − p} and 
H2(S) = − log2{p2 + (1 − p)2}, respectively. As discussed 
in Section II (viz. Fig. 1), the LRS estimator estimates the 
collision entropy instead of the min-entropy. Since H∞(S) ≤ H2(S), the LRS estimator undesirably overestimates the min-
entropy. For p = 0.3, the bias of the LRS estimator is around 
0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 
p 
0.1 
0.2 
0.3 
0.4 
0.5 
0.6 
0.7 
0.8 
0.9 
1 
E nt 
ro py 
Min-entropy LRS estimator Proposed estimator ( =2) Proposed estimator ( =3) Proposed estimator ( =4) Proposed estimator ( =5) Proposed estimator ( =6) Proposed estimator ( =7) 
(a) 
0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 
p 
0 
0.001 
0.002 
0.003 
0.004 
0.005 
0.006 
0.007 
0.008 
0.009 
0.01 
0.011 
V ar 
ia nc 
e of 
 e st 
im at 
ed  m 
in -e 
nt ro 
py 
Proposed estimator ( =2) Proposed estimator ( =3) Proposed estimator ( =4) Proposed estimator ( =5) Proposed estimator ( =6) Proposed estimator ( =7) 
(b) 
Fig. 4. (a) Estimated min-entropy and (b) the variance of min-entropy by the proposed generalized LRS estimator for the first-order Markov sources with p = p(1|0) = p(0|1). 
0.28. 
The proposed estimator accurately estimates the min-
entropy as shown in Fig. 3(a). As p → 0.5 (i.e., uniformly 
distributed sources), the higher α reduces Var(θ̂), which 
supports Theorem 16. We note that the reduction of Var(θ̂) diminishes as α increases as shown in Fig. 3(b). 
We observe in Fig. 3(a) that the higher α slightly improves 
the bias as p → 0.5. It is surprising because (32) is unbiased 
estimator for any α. The bias improvement results from Step 
11 of Algorithm 3. Since the power sum of order α cannot be 
lower than 1 2α−1 for binary sources (i.e., k = 2), we set θ̂ = 1 
2 
for M̃α < 1 2α−1 , which leads to H∞(S) = 1. For a BMS 
source with p = 1 2 , the estimated min entropy would be 1 (for 
M̃α ≤ 1 2α−1 ) or lower than 1 (for M̃α > 1 
2α−1 ). Hence, the 
increase of α can simultaneously reduce Var(θ̂) and improve 
the bias for high-entropy sources. 
It is worth mentioning that because of the finite sample size 
L, the higher order α reduces the number of valid Ci due to the 
requirement of Ci ≥ α in (32). Then, (32) could underestimate 
the power sum of α. Given the sample size L, an α value 
should be picked so as to satisfy Ci ≥ α for values of w as
 2 2.5 3 3.5 4 4.5 5 
Min-entropy 
1 
1.5 
2 
2.5 
3 
3.5 
4 
4.5 
5 
5.5 
6 E 
st im 
at ed 
 m in 
-e nt 
ro py 
Correct min-entropy Correct collision entropy LRS estimator Proposed estimator ( =2) Proposed estimator ( =4) Proposed estimator ( =6) 
(a) 
2 2.5 3 3.5 4 4.5 5 
Min-entropy 
1 
1.5 
2 
2.5 
3 
3.5 
4 
4.5 
5 
5.5 
6 
E st 
im at 
ed  m 
in -e 
nt ro 
py 
Correct min-entropy Correct collision entropy LRS estimator Proposed estimator ( =2) Proposed estimator ( =4) Proposed estimator ( =6) 
(b) 
Fig. 5. Comparison of min-entropy estimators for (a) near-uniform distributed sources and (b) inverted near-uniform distributed sources. 
large as of interest to the randomness tester. In our experiments 
with L = 100, 000, we recommend α ∈ {3, 4, 5, 6} by taking 
into account valid Ci and diminishing variance reduction of 
α. 
For the first-order Markov sources, the min-entropy es-
timators estimate the min-entropy rate. By [17], [18], the 
accurate min-entropy rate and the collision entropy rate are 
given by H∞(S) = − log2 max{p, 1 − p} and H2(S) = − log2{p2+(1−p)2}, respectively. Note that the entropy rates 
of the first-order Markov sources are the same as the entropies 
of the BMS. 
Fig. 4 compares the min-entropy estimators for the first-
order Markov sources with parameter p. The LRS estimator of 
NIST SP 800-90B undesirably overestimates the min-entropy 
of the Markov sources as shown in Fig. 4(a). The proposed 
estimator effectively improves the accuracy of min-entropy 
estimates. As in Fig. 3, the generalized estimator improves not 
only the variance of estimates but also the bias as p → 0.5. 
Note that the improvement of Var(θ̂) diminishes as α increases 
as shown in Fig. 4(b). 
Fig. 5 compares the min-entropy estimators for near-
uniform distributed sources and inverted near-uniform dis-
tributed sources where the alphabet size is 64, i.e., k = 64. 
TABLE II MIN-ENTROPY ESTIMATES FOR REAL-WORLD SOURCES 
α = 2 α = 4 α = 6 
RANDOM.ORG 0.8889 0.9549 0.9572 
Ubld.it 0.8277 0.8598 0.8941 
LKRNG 0.9364 0.9843 0.9844 
The sequences generated by these non-binary sources are 
represented by binary values. Then, we estimate the min-
entropies from these binary sequences. 
Fig. 5(a) shows that the LRS estimator undesirably overes-
timates the min-entropy for near-uniform distributed sources 
since the gap between the collision entropy and the min-
entropy is significant. On the other hand, the proposed es-
timators estimate the min-entropy accurately. We note that the 
generalized LRS estimator with α > 2 (Algorithm 3) is more 
accurate than the improved LRS estimator (Algorithm 2). 
For the inverted near-uniform distributed sources, the LRS 
estimator is relatively accurate (but still overestimating) since 
the collision entropy is close to the min-entropy as discussed 
in Remark 10. Fig. 5(b) also supports Remark 10. We observe 
that the LRS estimator is close to the collision entropy 
(and the min-entropy) although it slightly overestimates the 
min-entropy. The proposed estimators underestimate the min-
entropy, which can be explained by (15). Since θ̂ > p̂c in 
(15), we observe that θ̂ > p̂c ≃ θ for inverted near-uniform 
distributed sources. Fortunately, the underestimation bias can 
be reduced by adopting a higher order α as shown in Fig. 5(b). 
It is worth mentioning that the compression estimator of 
NIST SP 800-90B also suffers from this underestimation 
problem for inverted near-uniform distributed sources [1], [16]. 
Compared to the compression estimator, our proposed estima-
tors are much more accurate. For an inverted near-uniform 
distributed source with H∞(S) = 5, the estimated value by 
the proposed estimator with α = 6 is around 4.3, which is 
much better than the compression estimator’s value of 1.55 
(see [16, Fig. 6(b)]). Since NIST SP 800-90B conservatively 
selects the minimum estimates among ten different estimators 
including the compression estimator, the proposed generalized 
LRS estimator does not degrade the final estimation accuracy 
even for this exceptional inverted near-uniform distribution. 
We also evaluate min-entropy estimates using random num-
ber generators deployed in the real-world as in [3], [16]. The 
true min-entropies for these sources are unknown even though 
they are believed to be high-entropy sources. We evaluate 
RANDOM.ORG, Ubld.it, and Linux kernel random number 
generator (LKRNG). RANDOM.ORG [19] is a service that 
provides random numbers based on atmospheric noise and 
Ubld.it generates random numbers by a TrueRNG device 
by [20]. The min-entropy estimates of the real-world sources 
are presented in Table II. We observe that the generalized 
LRS estimator improves the accuracy of min-entropy estimates 
by assuming that these real-world sources are high-entropy 
sources. 
We observe that the LRS estimator suffers from significant 
overestimation problem for most cases of BMS, Markov 
sources, and near-uniform distributed sources. Hence, the
 proposed estimator would be an appealing alternative to the 
original LRS estimator. 
VI. CONCLUSION 
We proposed accurate min-entropy estimators to resolve 
the overestimation problem of the LRS estimator. Although 
the proposed estimator (improved LRS estimator) relies on 
the estimated collision probability as in the LRS estimator, it 
effectively reduces the bias by leveraging the relation between 
the collision entropy and the min-entropy. Furthermore, we 
proposed the generalized LRS estimator by parameterizing α 
instead of setting α = 2. It was shown that the generalized 
LRS estimator can improve the bias and variance of min-
entropy estimates. 
APPENDIX A 
ANALYSIS ON v 
In this appendix, we analyze v (i.e., the maximum value 
of w), which is used in Algorithms 1 and 3. We denote the 
number of α-wise collisions as Dα,w for the w-tuples in Step 
4 of Algorithm 3, which is given by 
Dα,w = 
kw∑ 
i=1 
( Ci 
α 
) , (36) 
where Ci is the number of occurrences of the ith w-tuple. We 
suppose that ( Ci 
α 
) = 0 if Ci < α. Note that (36) is the same 
as the numerator of (32). 
The following lemma shows the relation between the tuple 
size w and the number of α-wise collisions (36). 
Lemma 17: For a large L, E(Dα,w+1) ≈Mα(p) ·E(Dα,w). Proof: Denote {a1, . . . , akw} as the alphabet of w-tuples 
and {c1, . . . , ckw} as the number of occurrences of each w-
tuple in s. For a w-tuple element aj for j ∈ {1, . . . , kw}, we 
can represent aj as (aj,1, . . . , aj,w) where aj,i ∈ {x1, . . . , xk} for i ∈ {1, . . . , w}. 
For each w-tuple aj = (aj,1, . . . , aj,w), there are k dif-
ferent ways to add a symbol and obtain a (w + 1)-tuple. 
The expected numbers of occurrences with aj as prefix are 
{cj · p1, cj · p2, . . . , cj · pk}. Hence, the expected number of 
α-wise collisions for (w + 1)-tuples is given by 
E(Dα,w+1) = 
kw∑ 
j=1 
k∑ 
i=1 
( cjpi 
α 
) 
≈ kw∑ 
j=1 
k∑ 
i=1 
cαj p α i 
α! ≈ 
kw∑ 
j=1 
cαjMα(p) 
α! (37) 
≈ kw∑ 
j=1 
( cj 
α 
) ·Mα(p) (38) 
=Mα(p) · E(Dα,w), (39) 
where (37) follows from ( cjpi α 
) ≈ cαj p 
α i 
α! for cjpi ≫ α (i.e., for 
a large L) and Definition 1. If a cjpi is not much greater than 
α, then it can be neglected. Also, (38) follows from ( cj α 
) ≈ cαj 
α! . 
Finally, (39) follows from (36). 
For the proof of Theorem 16, we will take the value of v 
to be v, which is defined to be the tuple length at which the 
distribution attains in expectation the cutoff property of having 
at least one tuple occurring at least α times in the sequence 
(see Step 2 in Algorithm 3). 
Lemma 18: For a large L, v ≈ log 1 Mα 
( l α 
) . 
Proof: By the definition of v and (36), v is the largest 
value such that E(Dα,v) ≥ 1. Hence, E(Dα,1) · (Mα) v−1 ≥ 1 
and E(Dα,1) · (Mα) v < 1 by Lemma 17. Then, we can obtain 
log 1 Mα 
E(Dα,1) < v ≤ log 1 Mα 
E(Dα,1) + 1 (40) 
log 1 Mα 
( l 
α 
) Mα < v ≤ log 1 
Mα 
( l 
α 
) Mα + 1 (41) 
log 1 Mα 
( l 
α 
) − 1 < v ≤ log 1 
Mα 
( l 
α 
) . (42) 
For l ≫ α, v ≈ log 1 Mα 
( l α 
) . 
Lemma 19: For a uniformly distributed s = (s1, . . . , sL) with a large L, 
vα+1 
vα ≈ α2 − 1 
α2 , (43) 
which is less than one. Note that vα denotes the v with order 
α. 
Proof: We can obtain 
vα+1 
vα = 
logk ( lα+1 
α+1 
) 
α · α− 1 
logk ( lα α 
) (44) 
= α− 1 
α · ln ( lα+1 
α+1 
) 
ln ( lα α 
) (45) 
≈ α− 1 
α · lnL 
α+1 − ln vα+1 α+1 − ln(α+ 1)! 
lnLα − ln vαα − lnα! (46) 
≈ α− 1 
α · lnL 
α+1 
lnLα (47) 
= (α− 1)(α+ 1) 
α2 , (48) 
where (44) follows from Lemma 18 and Mα = k−(α−1) for a 
uniformly distributed source. For a large L, (46) follows from( lα α 
) ≈ lαα 
α! and lα = ⌊ L vα 
⌋ ≈ L 
vα . Also, (47) follows from 
Lα ≫ vαα and Lα ≫ α! for a large L. 
APPENDIX B 
PROOF OF THEOREM 16 
For every subset I ⊆ {1, . . . , l = ⌊ L w 
⌋ } of size α, we define 
XI be a 0-1 random variable that gets the value 1 iff all the 
values xi are the same (i.e., I forms a α-wise collision). By 
(36), it is clear that 
Dα,w = ∑ 
|I|=α XI (49) 
and 
E(XI) =Mα,w, (50) 
where Mα,w is the w-tuple power sum of order α. Also, we 
set XI = XI −Mα,w as in [15]. 
For two subsets I and J such that |I| = |J | = α, E(XI · XJ) = E(XI) · E(XJ ) = 0 if I ∩ J = ∅. If I ∩ J 6= ∅, then
 
XI ·XJ is a 0-1 random variable that gets the value 1 iff all 
the values in I ∪ J are the same. Hence, 
E(XI ·XJ) =Mα+t,w −M2 α,w (51) 
if |I ∪ J | = α + t < 2α [15]. Since Mα,w = 1 kw(α−1) for a 
uniformly distributed source, we obtain 
E(XI ·XJ ) = 1 
kw(α+t−1) − 1 
k2w(α−1) . (52) 
The variance of Dα,w is given by 
Var(Dα,w) 
= 
α−1∑ 
t=0 
∑ 
|I∪J|=α+t E(XI ·XJ) (53) 
= 
α−1∑ 
t=0 
∑ 
|I∪J|=α+t 
( 1 
kw(α+t−1) − 1 
k2w(α−1) 
) (54) 
= 
α−1∑ 
t=0 
( l 
α 
)( l − α 
t 
)( α 
t 
)( 1 
kw(α+t−1) − 1 
k2w(α−1) 
) (55) 
≈ 1 
kw(α−1) 
( l 
α 
) α−2∑ 
t=0 
( l 
t 
)( α 
t 
)( 1 
kwt − 1 
kw(α−1) 
) , (56) 
where (54) follows from (52). Also, (56) follows from ( l−α t 
) ≈( 
l t 
) for l ≫ α and 1 
kwt − 1 kw(α−1) = 0 for t = α− 1. 
By taking into account normalization in Step 5 of Algo-
rithm 3, we obtain 
Var(M̃α,w) = Var 
( M̂ 
1 w α,w 
) 
≈ 1 
w2 · E(M̂α,w) 
2(1−w) w · Var(M̂α,w) (57) 
= 1 
w2 · k2(α−1)(w−1) · Var(Dα,w)( 
l α 
)2 (58) 
≈ k(α−1)(w−2) 
w2 · ∑α−2 
t=0 
( l t 
)( α t 
) ( k−wt − k−w(α−1) 
) ( l α 
) , (59) 
where (57) follows from the first-order Taylor approximation 
(i.e., Var(f(x)) ≈ f ′(E(x))2 · Var(x) where f(x) = x 1 w ). 
Since (32) is an unbiased estimator (i.e., E(M̂α,w) =Mα,w = k−w(α−1)), (58) holds. Finally, (59) follows from (56). 
Now we show that Var(M̃α,w) ≤ Var(M̃α,w+1) for w ≥ 3. 
For each term of (59), 
k(α−1)(w−2) 
w2 · ( l t 
)( α t 
) ( k−wt − k−w(α−1) 
) ( l α 
) 
< k(α−1)(w−2) 
(w + 1)2 · k 
α−1 
kt · ( l t 
)( α t 
) ( k−wt − k−w(α−1) 
) ( l α 
) (60) 
= k(α−1)(w−1) 
(w + 1)2 · ( l t 
)( α t 
) ( k−(w+1)t − k−{w(α−1)+t}) 
( l α 
) (61) 
< k(α−1)(w−1) 
(w + 1)2 · ( l t 
)( α t 
) ( k−(w+1)t − k−(w+1)(α−1) 
) ( l α 
) , (62) 
where (60) follows from ( 
w w+1 
)2 
· kα−1 
kt > 1 for k ≥ 2 and 
w ≥ 3. Also, (62) follows from t < α− 1. Hence, 
Var(M̃α,w) < Var(M̃α,w+1) (63) 
for w ≥ 3. 
In Step 7 of Algorithm 3, the maximum among 
{M̃α,u, . . . , M̃α,v} is chosen as M̃α. It is difficult to charac-
terize which M̃α,w for w ∈ {u, . . . , v} is the maximum value. 
As a conservative approach, we set Var(M̃α) ≈ Var(M̃α,v). Then, 
Var(M̃α) ≈ k(α−1)(vα−2) 
v2α 
· ∑α−2 
t=0 
( lα t 
)( α t 
) ( k−tvα − k−(α−1)vα 
) ( lα α 
) , (64) 
where we denote v = vα and l = lα since both v and l depend 
on α. 
By the first-order Taylor approximation, 
Var(θ̂α) ≈ z(θ̂α, α) 2 · Var(M̃α), (65) 
where z(θ̂α, α) is given by 
z(θ̂α, α) = dθ̂α 
dM̃α 
= 1 
α 
{ θ̂α−1 α − 
( 1−θ̂α k−1 
)α−1 } , (66) 
which is derived from (33). 
If M̃α = 1 kα−1 , then z(θ̂α, α) → ∞. However, Algorithm 3 
sets θ̂α = 1 k for M̃α ≤ 1 
kα−1 instead of solving (33). Hence, 
z(θ̂α, α) should be considered only if M̃α = 1 kα−1 + δ where 
0 < δ ≪ k for uniformly distributed sources. Then, we can 
set θ̂α = 1 k + δ′ where 0 < δ′ ≪ k. By [16, Theorem 4], 
z(θ̂α, α) ≈ kα−3 
α(α−1) · k−1 δ′ . Then, 
z(θ̂α+1, α+ 1) 
z(θ̂α, α) ≈ α− 1 
α+ 1 · k. (67) 
Then, we obtain 
ξ(α) = Var(θ̂α+1) 
Var(θ̂α) 
≈ z(θ̂α+1, α+ 1)2 
z(θ̂α, α)2 · Var(M̃α+1) 
Var(M̃α) (68) 
= 
( α− 1 
α+ 1 
)2 
· ( 
vα 
vα+1 
)2 
· ( lα α 
) ( lα+1 
α+1 
) · k{αvα+1−(α−1)vα} 
· ∑α−1 
t=0 
( lα+1 
t 
)( α+1 t 
) ( k−tvα+1 − k−αvα+1 
) ∑α−2 
t=0 
( lα t 
)( α t 
) ( k−tvα − k−(α−1)vα 
) (69) 
≈ ( α− 1 
α+ 1 
)2 
· ( 
vα 
vα+1 
)2 
· ∑α−1 
t=0 
( lα+1 
t 
)( α+1 t 
) ( k−tvα+1 − k−αvα+1 
) ∑α−2 
t=0 
( lα t 
)( α t 
) ( k−tvα − k−(α−1)vα 
) , (70) 
where (68) follows from (65). Also, (69) follows from (64) 
and (67). By Lemma 18 (see Appendix A) and Mα = 1 kα−1 , 
we obtain vα ≈ logkα−1 
( lα α 
) = 1 
α−1 logk ( lα α 
) , which leads to 
kvα ≈ ( lα 
α 
) 1 α−1 
. (71) 
Then, (70) follows from k{αvα+1−(α−1)vα} ≈ (lα+1 α+1 ) (lαα ) 
.
 
Also, we obtain 
ξ(α) ≈ ( 
α 
α+ 1 
)4 
· ∑α−1 
t=0 
( lα+1 
t 
)( α+1 t 
) ( k−tvα+1 − k−αvα+1 
) ∑α−2 
t=0 
( lα t 
)( α t 
) ( k−tvα − k−(α−1)vα 
) (72) 
= 
( α 
α+ 1 
)4 
· 
∑α−1 t=0 
( lα+1 
t 
)( α+1 t 
){( lα+1 
α+1 
)− t α − 
( lα+1 
α+1 
)−1 } 
∑α−2 t=0 
( lα t 
)( α t 
){( lα α 
)− t α−1 − 
( lα α 
)−1 } (73) 
≈ ( 
α 
α+ 1 
)4 
· ∑α−1 
t=0 
( lα+1 
t 
)( α+1 t 
)( lα+1 
α+1 
)− t α 
∑α−2 t=0 
( lα t 
)( α t 
)( lα α 
)− t α−1 
, (74) 
where (72) and (73) follow from Lemma 19 and (71), respec-
tively. Also, (74) follows from ( lα 
α 
)− t α−1 
≫ ( lα 
α 
)−1 
(75) 
for t ≤ α− 2 and a large L. We derive (75) as follows: ( lα 
α 
)− t α−1 
≥ ( lα 
α 
)−1 
· ( lα 
α 
) 1 α−1 
(76) 
> 
( lα 
α 
)−1 
· ( lα 
α 
)1+ 1 α−1 
(77) 
≫ ( lα 
α 
)−1 
, (78) 
where (76) follows from t ≤ α − 2 and (77) follows from( lα α 
) > ( lαα )α for lα > α. Also, (78) holds because lα ≫ α. 
Finally, we show that (74) converges to ( 
α α+1 
)4 
. For a large 
L, lα = ⌊ L vα 
⌋ ≈ L 
vα and 
( lα t 
) ≈ ltα 
t! . Then, 
α−1∑ 
t=0 
( lα+1 
t 
)( α+ 1 
t 
)( lα+1 
α+ 1 
)− t α 
≈ α−1∑ 
t=0 
( α+ 1 
t 
) · (lα+1) 
t(1−α+1 α 
) 
t! · {(α+ 1)!}− t α 
(79) 
≈ α−1∑ 
t=0 
( α+ 1 
t 
) · 
( L 
vα+1 
)− t α 
t! · {(α+ 1)!}− t α 
(80) 
= α−1∑ 
t=0 
( α+ 1 
t 
) · {(α+ 1)! · vα+1} t 
α 
t! · L− t 
α . (81) 
Also, 
α−2∑ 
t=0 
( lα 
t 
)( α 
t 
)( lα 
α 
)− t α−1 
≈ α−2∑ 
t=0 
( α 
t 
) · (α! · vα) 
t α−1 
t! · L− t 
α−1 . (82) 
For a large L, (81) converges to one because the highest 
degree of L− t α is zero by t = 0. Similarly, (82) converges to 
one. Hence, ξ(α) ≈ ( 
α α+1 
)4 
for a large L. 
REFERENCES 
[1] M. S. Turan, E. Barker, J. Kelsey, K. A. McKay, M. L. Baish, and M. Boyle, Recommendation for the Entropy Sources Used for Random 
Bit Generation, NIST Special Publication 800-90B Std., Jan. 2018. [2] P. Hagerty and T. Draper, “Entropy bounds and statistical tests,” in Proc. 
NIST Random Bit Generation Workshop, Dec. 2012, pp. 1–28. [3] J. Kelsey, K. A. McKay, and M. S. Turan, “Predictive models for 
min-entropy estimation,” in Proc. Int. Workshop Cryptograph. Hardw. Embedded Syst. (CHES), Berlin, Heidelberg, Sep. 2015, pp. 373–392. 
[4] T. Amaki, M. Hashimoto, Y. Mitsuyama, and T. Onoye, “A worst-case-aware design methodology for noise-tolerant oscillator-based true random number generator with stochastic behavior modeling,” IEEE 
Trans. Inf. Forensics Security, vol. 8, no. 8, pp. 1331–1342, Aug. 2013. [5] W. Killmann and W. Schindler, A proposal for: Functionality classes 
for random number generators, German Federal Office for Information Security (BSI) Std., Rev. 2, Sep. 2011. 
[6] A. Rukhin, J. Soto, J. Nechvatal, M. Smid, E. Barker, S. Leigh, M. Levenson, M. Vangel, D. Banks, A. Heckert, J. Dray, and S. Vo, A 
statistical test suite for random and pseudorandom number generators for cryptographic applications, NIST Special Publication 800-22 Std., Rev. 1a, Apr. 2010. 
[7] M. Ben-Bassat and J. Raviv, “Renyi’s entropy and the probability of error,” IEEE Trans. Inf. Theory, vol. 24, no. 3, pp. 324–331, May 1978. 
[8] S. Zhu, Y. Ma, X. Li, J. Yang, J. Lin, and J. Jing, “On the analysis and improvement of min-entropy estimation on time-varying data,” IEEE 
Trans. Inf. Forensics Security, vol. 15, pp. 1696–1708, Oct. 2020. [9] C. Beck and F. Schögl, Thermodynamics of Chaotic Systems: An 
Introduction, ser. Cambridge Nonlinear Science Series. Cambridge University Press, 1993. 
[10] O. Goldreich and D. Ron, “On testing expansion in bounded-degree graphs,” Electron. Colloq. Comput. Complexity, vol. 7, Jan. 2000. 
[11] T. Batu, L. Fortnow, R. Rubinfeld, W. D. Smith, and P. White, “Testing closeness of discrete distributions,” J. ACM, vol. 60, no. 1, pp. 4:1–4:25, Feb. 2013. 
[12] J. Acharya, A. Orlitsky, A. T. Suresh, and H. Tyagi, “The complexity of estimating Rényi entropy,” in Proc. Annu. ACM-SIAM Symp. Discrete Algorithms (SODA), Jan. 2015, pp. 1855–1869. 
[13] S. Zhu, Y. Ma, T. Chen, J. Lin, and J. Jing, “Analysis and improvement of entropy estimators in NIST SP 800-90B for non-IID entropy sources,” IACR Trans. Symmetric Cryptol., vol. 2017, no. 3, pp. 151–168, Sep. 2017. 
[14] J. Golic, “On the relationship between the information measures and the Bayes probability of error,” IEEE Trans. Inf. Theory, vol. 33, no. 5, pp. 681–693, Sep. 1987. 
[15] Z. Bar-Yossef, R. Kumar, and D. Sivakumar, “Sampling algorithms: Lower bounds and applications,” in Proc. Annu. ACM Symp. Theory 
Comput. (STOC), Feb. 2002, pp. 266–275. [Online]. Available: https://webee.technion.ac.il/people/zivby/papers/sampling/sampling full.ps 
[16] Y. Kim, C. Guyot, and Y.-S. Kim, “On the efficient estimation of minentropy,” IEEE Trans. Inf. Forensics Security, vol. 16, pp. 3013–3025, Apr. 2021. 
[17] Z. Rached, F. Alajaji, and L. Lorne Campbell, “Renyi’s divergence and entropy rates for finite alphabet Markov sources,” IEEE Trans. Inf. 
Theory, vol. 47, no. 4, pp. 1553–1561, May 2001. [18] S. Kamath and S. Verdú, “Estimation of entropy rate and Rényi entropy 
rate for Markov chains,” in Proc. IEEE Int. Symp. Inf. Theory (ISIT), Jul. 2016, pp. 685–689. 
[19] “RANDOM.ORG.” [Online]. Available: https://www.random.org [20] “Ubld.it: TrueRNG.” [Online]. Available: 
http://ubld.it/products/truerng-hardware-random-number-generator/