# Revisiting Post-Quantum Fiat-Shamir - NSF PAR

- **ID**: `ff2955ca-1f00-4698-b0a1-47f948a27def`
- **Tipo de Fuente**: `SOURCE_TYPE_PDF`
- **URL**: [https://par.nsf.gov/servlets/purl/10164788](https://par.nsf.gov/servlets/purl/10164788)

---

## Contenido Extraído / Texto Completo

Revisiting Post-Quantum Fiat-Shamir 
Qipeng Liu1, Mark Zhandry1 
Princeton University, Princeton NJ 08544, USA 
Abstract. The Fiat-Shamir transformation is a useful approach to building non-interactive arguments (of knowledge) in the random oracle model. Unfortunately, existing proof techniques are incapable of proving the security of Fiat-Shamir in the quantum setting. The problem stems from (1) the difficulty of quantum rewinding, and (2) the inability of current techniques to adaptively program random oracles in the quantum setting. In this work, we show how to overcome the limitations above in many settings. In particular, we give mild conditions under which Fiat-Shamir is secure in the quantum setting. As an application, we show that existing lattice signatures based on Fiat-Shamir are secure without any modifications. 
1 Introduction 
The Fiat-Shamir transformation is an approach to remove interaction in a protocol by using a hash function, by setting one party’s messages to be hashes of the communication transcript. The transformation has many important applications, from removing interaction from proofs to constructing efficient signatures. 
With the growing threat of quantum computers, there is great need for so-called “post quantum” cryptosystems, those secure against quantum attack. In the case of signatures, the most efficient constructions [DKL+18] use the Fiat-Shamir transformation [FS87]. Fiat-Shamir is a general tool to remove interaction from interactive protocols using a hash function. 
Classically, the security of the transform is proved in the classical random oracle model (ROM) [BR93, PS96]. Here, the hash function is replaced with a truly random function that can only be evaluated by query access. As argued by Boneh et al. [BDF+11], the correct way to model random oracles in the quantum setting is to allow quantum queries to the random oracle. While many techniques have been developed to prove security in the quantum ROM [BDF+11, Zha12, BZ13, Unr17, TU15, Unr15, KLS18, Zha18], to date the post-quantum security of general Fiat-Shamir remains unresolved. 
In fact, there has been some compelling justification for this state of affiars. Dagdelen, Fischlin, and Gagliardoni [DFG13] demonstrate that there cannot be a reduction with certain natural features (discussed below) which capture many of the existing techniques. What’s more, Ambainis, Rosmanis, and Un-ruh [ARU14] show that many classical results about Fiat-Shamir that rely on rewinding are simply false in the quantum setting. In particular, they show that special soundness is insufficient to prove the security of Fiat-Shamir in the quantum ROM. 
As a result, authors have proposed various ways to strengthen the underlying protocol so that postquantum Fiat-Shamir can be proved (e.g. [DFG13, Unr17, KLS18]) or use an alternative transformation altogether (e.g. [Unr15]). However, in all cases, this leads to a less efficient and less elegant scheme. 
1.1 Summary of Results 
In this work, we revisit Fiat-Shamir, showing that in many cases Fiat-Shamir can be successfully applied for post-quantum security without modifying the underlying protocols. 
Our results come in two parts. The first set of results concerns the Fiat-Shamir transformation itself, resurrecting standard classical results in the quantum ROM: 
– If the underlying protocol is an argument (of knowledge), then Fiat-Shamir gives an argument (of knowledge).
– If the underlying protocol is a secure identification scheme, then Fiat-Shamir gives a secure signature scheme. 
These results do not require making any additional assumptions on the underlying protocol than what is needed classically (other than, of course, needing security to hold against quantum adversaries). 
These results overcome the barrier of Dagdelen, Fischlin, and Gagliardoni [DFG13] by giving a proof that is outside the class of natural reductions they consider. On the other hand, the results side-step the rewinding barrier of Ambainis, Rosmanis, and Unruh [ARU14], as the rewinding barrier already applies to the security of the underlying protocol. 
Our second set of results concerns overcoming the rewinding barrier of [ARU14]. Classically, 2-soundness/2-extractability1 are often used to prove that a protocol is an argument/argument of knowledge. While [ARU14] show that in general these conditions are insufficient in the quantum setting, we show the following: 
– We define a notion of collapsing for a protocol which is similar to the notion of collapsing for hash functions [Unr16b]. 
– Abstracting a result of Unruh [Unr16b], we show that the usual classical results carry over to the quantum setting, provided the protocol is collapsing. That is, 2-soundness plus collapsing implies an argument, and 2-extractability plus collapsing implies an argument of knowledge. 
– Next, we give two weaker conditions, either of which are sufficient for a protocol to be collapsing. The first is that the protocol has an associated lossy function with certain properties. The second is that the protocol is separable, a new notion we define. 
– Finally, we then show that the lattice-based protocol of Lyubashevsky [Lyu12] is separable under the LWE assumption. Piecing together with our other results, we demonstrate that Lyubashevsky’s protocol is secure in the quantum random oracle model without any modifications. These results naturally extend to protocols built from this protocol, such as [DKL+18]. 
A key feature of our results is that they can be used as a black box without requiring the complicated details of quantum computing. In particular, the needed security properties are 2-soundness/2-extractability and associated lossy functions/separability. These properties are essentially classical in nature (except for having to hold with respect to quantum adversaries) and can be proved using classical proof techniques, and trivially porting them into the quantum setting. All of the quantum difficulties are hidden inside our proofs. 
1.2 Technical Details 
A Quantum ROM Fiat-Shamir Proof Our first result is to prove the security of Fiat-Shamir in the quantum random oracle model, showing that Fiat-Shamir is an argument (of knowledge) assuming the original protocol is. 
Fiat-Shamir operates on a sigma protocol, which is a three-message protocol with a public-coin verifier. The prover has some witness w for a statement x. In the first message, the prover sends a commitment a. Then the verifier chooses a random challenge c which it sends back. Finally, the prover comes up with a response r. The verifier then looks at the transcript (a, c, r), which it accepts or rejects. The protocol is an argument if no (computationally bounded) malicious prover can cause the verifier to output 1 in the case x is false. The protocol is an argument of knowledge if, moreover, from any computationally bounded prover, a valid witness w can be extracted. 
Honest verifier zero knowledge means that it is possible to generate valid transcripts (a, c, r) without knowing a witness. Note that this generation procedure typically chooses a based on c and maybe r; as such a generation procedure does not allow one to break the soundness of the argument. 
The Fiat-Shamir transformation, using a hash function H, simply replaces the verifier’s challenge with c = H(a). Thus the prover can generate the entire interaction for himself. The hope is that the hash function prevents a dishonest prover from using the zero knowledge property to generate the transcript, by forcing c 
1 2-extractability is often called “special soundness” in the literature 
2
to be determined after a. In fact, in the classical random oracle model, this idea can be turned into a proof, showing how to turn any adversary for Fiat-Shamir into an adversary for the original sigma protocol. 
In the classical proof, the reduction simulates the random oracle on the fly, keeping track of the points the adversary queries and programming the random oracle to fresh random points with each query. It is straightforward to prove that if the adversary eventually outputs a valid argument (a, c = H(a), r), then one of the random oracle queries must have been on a. If the reduction knew which query this was at the time of that query, it sends a as it’s commitment to the sigma protocol. When it receives c from the verifier, it programs H(a) = c instead of choosing its own random value. Since the verifier chose c at random anyway, this is undetectable to the adversary. Finally, when the adversary outputs (a, c, r), the reduction simply sends r to the verifier, which will pass. Now, the reduction does not know which query will correspond to the adversary’s output when the query is made, so the adversary simply guesses a query at random, and aborts if the guess turned out wrong. The resulting adversary still succeeds with non-negligible probability. 
This proof strategy is problematic once we consider quantum queries to the random oracle. The classical on-the-fly simulation strategy of random oracles does not work once quantum queries are allowed. The reason is that the simulation strategy requires recording the adversary’s queries; if the queries were quantum, the result is effectively a measurement of the adversary’s query. Such a measurement is easily detectable. A mischievous adversary could test for such a measurement, and refuse to keep working if detected. 
This is a universal problem in the quantum ROM; as such, the typical solution is to avoid on-the-fly simulation. Instead, the function is set once and for all to be a fixed function chosen from a careful distribution [BDF+11, Zha12, BZ13, Unr17, TU15, Unr15, KLS18]. The reduction then answers the queries with this function, without trying to record anything about the adversary’s query. By designing the function to be indistinguishable from a truly random oracle, the adversary cannot tell that it was given a different oracle. 
However, while such fixed functions can be made to work in a wide variety of settings, they seem incapable of proving the security of Fiat-Shamir. Indeed, an impossibility of this sort is formalized by [DFG13]. The issue is that a Fiat-Shamir proof needs to extract a from the adversary’s queries and feed it into it’s own verifier. But such an extraction constitutes a detectable measurement. Even worse, it then needs to program the challenge c into the oracle, but this might be happening after many queries to the random oracle. Therefore, it seems crucial for a proof to adaptively program the random oracle. 
Compressed Oracles. Toward resolution, we start with a very recent technique that allows for on-the-fly simulation of random oracles in the quantum setting: Zhandry’s compressed oracles [Zha18]. 
Zhandry’s key observation is that some sort of on-the-fly simulation analogous to the classical simulation is possible if care is taken to implement the oracle correctly. Concretely, Zhandry simulates the random oracle as a stateful oracle which stores a quantum superposition databases D, where a database is just a list of input/output pairs (x, y). A database intuitively represents a partial specification of the oracle: if a pair (x, y) is in the database, it means the oracle on input x is set to y, whereas if there is no pair that begins with x, it means the oracle is un-specified at x. Since the oracle actually stores a superposition of databases, a point x can be in superposition of being specified and unspecified. Originally, the database starts out empty. 
In the classical setting, on query x, the oracle would look up x in the database and add a pair (x, y) for a random y if x was not found. Afterward (since there is now guaranteed to be a pair (x, y)) it will output y. 
In the quantum setting, something similar happens. The following description is slightly inaccurate, but gives the high-level idea. On query x, very roughly, if x is not found in the database, a pair (x, y) is added, where y is in uniform superposition over all possible y values. Recall that the query can be quantum, so this addition to the database is happening in superposition. Then once x is guaranteed to be specified, the query is answered (again in superposition). 
Now, an important difference from the classical setting is this: in order to maintain perfect indistinguishability from a truly random oracle, a particular test is performed on the database after answering the query. This test determines whether the adversary maintains any knowledge of the oracle at input x. If not, the pair (x, y) is removed from the database. 
The above description is informal and slightly inaccurate. But nonetheless by carrying out the operations correctly, Zhandry shows that this approach can be made to correctly simulate a random oracle. 
3
For us, Zhandry’s simulation gives a glimmer of hope. Indeed, we notice that the oracle is now recording information about which points the adversary is interested in. Therefore, the database has all the information we need to generate a. Unfortunately though, there is a problem: in order for the reduction to win against the verifier, it must produce a classical a. However, in order to produce a classical a, we must measure the adversary’s database. But such a measurement will affect the state of the oracle, and can be detected by the adversary. Indeed, it is straightforward to devise adversaries that can catch such a measurement and refuse to keep running. 
Our New Extraction Technique. First, we observe that when the adversary outputs (a, c, r), the first thing the verifier does is to check that c = H(a). If the adversary succeeds, it means that the adversary knows about the value of H at a. But a Lemma of Zhandry [Zha18] whose that in the compressed oracle simulation, the pair (a, c) must be in the oracles database (whp). By the end of the experiment, a has been measured (since the adversary produces a classical output) which roughly has the effect of measuring a in the oracle’s database. Since the oracle’s database starts out empty, this must mean that (a, c) was added at some query. One may hope that this means it is possible to measure a random query to get a. 
Unfortunately, things are not so straightforward. The problem is that a might not have been added to the database at a well-defined point in time. It could be that each of the adversary’s queries is on a superposition that contains a, and only after making several queries does the adversary have enough information to determine H(a). 
Now, as a thought experiment, consider running the adversary, and after each query measuring the database in the compressed oracle. We will define the adversary’s history as the vector of resulting databases (D1, . . . , Dq). Suppose the adversary still was able to output (a, c, r) that passed verification. Then we know that (a, c) ∈ Dq, and so there must be some point i at which a first enters Di. But this means the adversary actually queries on input a for query i. This means we could use the classical strategy for extracting a. 
Unfortunately, measuring all the queries would of course destroy the adversary’s state, making it potentially unlikely the adversary would still pass verification. The good news is that we can show the probability of passing verification is at least non-zero. Indeed, Boneh and Zhandry [BZ13] give a measurement lemma which says that if a measurement has T possibilities, it can only reduce the adversary’s success probability by at most a multiplicative factor of T . Therefore, the adversary still passes with probability at least the reciprocal of the number of database histories. Of course, the number of histories is exponentially large, so this is not useful yet. We note that the measurement lemma is tight in general. 
However, we can use this notion of a history to help us achieve an extraction technique with a higher success probability. For a history h, let |φh〉 be the final state (where the queries were measured as above) of the algorithm conditioned on observing the history h. Recall that quantum states are usually complex vectors of unit norm. In contrast, |φh〉 will not be normalized, but instead have norm whose square is equal to the probability of observing h. 
Our key idea is to group histories in together, and apply a generalization of the measurement lemma to the groups of histories. We show that a polynomial number of groups of histories are possible, leading to a non-negligible chance of success. 
In more detail, we observe that the adversary’s final state, if we did not measure the history, is exactly∑ h |φh〉 where the sum is over all possible histories. This is similar to the classical case, where the adversary’s 
probability distribution is the sum of the conditional probability distributions for each history, weighted by the probability of that history. The key difference is that in the quantum setting, the relation between states and probabilities distributions requires squaring the amplitudes. 
Next, we partition the histories into a polynomial number of sets S1, . . . , Sq. Set Si consists of all histories (D1, . . . , Dq) for which: 
– Di−1 does not contain a – Di through Dq all contain a 
For the clarity of exposition, we assume that the adversary always outputs a successful tuple (a, c, r), meaning we know that a is in Dq. Therefore, Dq will contain a in all histories. As such, the sets Si in fact 
4
do partition the space of all possible histories. In the more general case where the adversary may fail, we would include a set S⊥ of histories where Dq does not contain q. 
Now we consider the states |φSi 〉 = ∑ 
h∈Si |φh〉. We note that 
∑ i |φSi 
〉 is exactly the adversary’s final state, since the Si form a partition. By generalizing the Boneh-Zhandry measurement lemma, we can show that the |φSi 
〉 must result in (a, c, r) which pass verification with non-negligible probability. Therefore, our goal is to extract a from the adversary’s query, and then hope that the resulting state is 
|φSi 〉 for some i. First, we choose a random i. For that query, we measure two things: 
– Whether that query resulted in a value being added to the database – And if so, we measure that value to get a guess a′ for a 
If successful, this corresponds to the requirement that histories have Di−1 which did not contain a and Di contained a. If unsuccessful, we abort. Then, for each subsequent query, we measure if a′ is still in the database, corresponding to the requirement that a ∈ Dj for all subsequent databases; if not we abort. At the end, the we test that the value a′ we measured happens to match the a in the adversary’s output (a, c, r). If a′ = a, the end result is exactly the state |φSi 
〉, since our measurements remove all histories except those in Si. 
We show that this procedure succeeds with non-negligible probability, and then by applying the generalized measurement lemma we get that (a, c, r) passes verification with non-negligible probability. The result is that we can actually extract the a at query time, and still have the adversary succeed in producing a valid (a, c, r), just as in the classical setting. 
Our New Programming Technique. Unfortunately, the above is not quite sufficient for a reduction. After all, while we can now query the verifier on a, it is unclear what it should do with the response c. It could program H(a) = c by adding the pair (a, c) to the database (recall that H was previously un-programmed at a since a /∈ Di−1). However, this is different from what the compressed oracle would have done: the compressed oracle would have added a uniform superposition over c of (a, c) pairs. 
In particular, the information the compressed oracle uses to determine if a pair should be removed is stored in the phase information of the output registers in the database. By inserting a classical value c into the output, there is no phase information for the compressed oracle to use. Actually, this will cause the compressed oracle to almost always decide to keep the value in the database, even if it should have been removed. 
A natural solution is: in query i once we have extracted a, switch the oracle database for input a to be permanently “uncompressed”. On all other inputs, the database will behave as before, but on the special input a, it will no longer run the check to remove a from the database. 
Such a modification can indeed be made to Zhandry’s compressed oracle, allowing for programming a random c. However, it does not quite work for us. Remember that our extraction technique above required testing whether a was in the database after query i. But this test needed to be applied to the original compressed oracle, not the new oracle which doesn’t compress a. In particular, the new compressed oracle will always report that a is in the database. Roughly this means our extraction captures all histories where a was added to the database at query i, even those where it was subsequently removed and added again. 
Let Ti be the set of histories of this form. Notice that the Ti’s do not partition all histories: the multi-set obtained by unioning the Ti contains each history multiple times. In fact, the number of times each history is included is equal to the number of times a is added to the database in that history. Some histories will add a many times. 
In order to overcome this issue, we need a way to partition the set of histories such that the set of histories for query i is independent of the history after the query. This corresponds to, after query i, no longer testing whether a is in the database. If we do not need such a test, we can switch the oracle at a to be uncompressed and then program a random c. 
One thought is to reverse the sets Si. That is, let S′i the set of histories where a is not in the history at any query up until i, and then is added at query i; we do not care after i if a is added or removed from the database. These S′i certainly partition the set of all histories, but unfortunately they cannot be sampled 
5
efficiently. The problem is that a is not known until it is added to the database in query i; yet, sampling histories in S′i requires knowing a at the very beginning in order to test for a’s presence from the start. 
Our solution is to try to combine the features of Si and S′i so that we do not need to know a at the beginning, but also do not need to test for a’s presence at the end. Toward that end, we define sets Ti,j,k. A history is in set Ti,j,k if: 
– a is added to the database at query i – a remains in the database until query j, at which point it is removed – a remains absent from the database until query k, at which point it is added a second time. 
These sets can be easily sampled: at query i, we measure to learn a guess a′ for a. Then we keep testing to make sure that a′ is in the database until query j, at which point we make sure that a′ is removed. Then we keep testing that a′ is absent until query k, when it is added back in. Once we get to query k, the database is now programmed at point a′, and we will never need to check for the presence of a′ in the database again. Therefore we can change the compressed oracle to be uncompressed at a′, and simply program it’s value to c. When the adversary finally outputs (a, c, r), we test if a′ = a; if so, the adversary’s state is exactly the collection of histories in Ti,j,k. 
The problem, of course, is that these Ti,j,k also do not partition the space of all histories. In fact, if a history adds a a total of ` times, it will appear in `−1 histories. Therefore the multi-set obtained by unioning the Ti,j,k contains each history equal to the number of times a is added, minus 1. 
Our final idea is to observe that if we take the multiset derived from the Ti’s, and subtract the multiset derived from the Ti,j,k’s, we will get every history exactly once. That means if we define |φT 〉 = 
∑ h∈T |φh〉, 
we have that 
|φ〉 = ( ∑ 
i 
|φTi 〉 ) − 
 ∑ 
i,j,k 
|φTi,j,k 〉 
  
Analogous to the case of the Si’s this allows us to sample a |φTi 〉 or |φTi,j,k 
〉 — which let us extract a and program c — and then have the adversary give us a valid (a, c, r) with non-negligible probability. The reduction then simply sends r and convinces the verifier. The end result is any adversary for Fiat-Shamir can be turned into an adversary for the original interactive protocol, completing the proof of security. 
How to Rewind an Argument For our next set of results, we show how to rewind a sigma protocol to allow for proving that the protocol is an argument (of knowledge). We note that [ARU14] show that 2-soundness/2-extractability is insufficient. Therefore, we aim to identify some mild extra conditions that will allow for the proof to go through. 
The difficulty in proving soundness comes from the difficulty of quantum rewinding, which was first observed by Watrous [Wat06]. In a classical rewinding proof, the adversary commits to a, gets a challenge c1 from the verifier, and responds with r1. Then, the adversary is rewound to just after a is produced. The adversary is then run on a different challenge c2, which causes it to give a different response r2. Then the tuple (a, c1, r1, c2, r2) either breaks 2-soundness, or in the case of 2-extractability can be used to generate a witness. 2-soundness/2-extractability are typically easy to prove using standard tools. 
In the quantum setting, a problem arises. Namely, while the adversary is quantum, the r1 it produces during the first run is classical. This means that r1 must be measured. But this measurement in general cannot be undone. As such, it is in general impossible to rewind back to the first message to try again. [ARU14] formalizes this observation by showing (relative to an oracle) that there are schemes for which 2-soundness/2-extractability are not enough to prove security. 
The natural solution, and the approach we take in this work, is to show that for some schemes rewinding is possible. Basically, in the absence of measurements quantum computation is reversible. Therefore we know that if r1 is not measured, then the adversary can be rewound and it will succeed in producing r2. What we need to show is that measuring r1 does not significantly impact the probability that the adversary will successfully produce r2. 
6
Unruh [Unr12] shows that if a sigma protocol additionally satisfies the notion of strict soundness — meaning that for every a, c there is unique valid r — then rewinding is possible. The idea is that you can leave r1 in superposition and not measure it. Then, just the fact that (a, c1, r1) passed verification means that the superposition over r1 collapses to the unique valid r1. Therefore, measuring r1 has no additional affect over measuring whether verification succeeded. Of course, measuring whether verification succeeded will also affect the probability r2 passes, but Unruh shows that the probability is not too low. 
Collapsing Protocols. Unfortunately, strict soundness is undesirable in practice, as it leads to inefficient schemes. Instead, Unruh [Unr16b] shows that for a particular protocol built from an object known as a collapse-binding commitment, rewinding is possible even though there are multiple valid r. Collapse-binding commitments can in turn be built from a so-called a collapsing hash function. 
We abstract Unruh’s ideas, defining a general notion of collapsing for sigma protocols. Roughly, a collapsing sigma protocol is one where there may be many valid r’s for a given (a, c), but the adversary cannot tell whether a superposition of valid r’s is measured or not. This is exactly what Unruh’s protocol guarantees, and is exactly what is needed to be able to rewind in the setting of many r’s. By following Unruh’s techniques, we show that collapsing is a sufficient extra condition to get the classical results to carry though to the quantum setting 
But now we face another challenge: how do we construct a collapsing sigma protocol? We can look for techniques for building collapsing hash functions or commitments and see if they apply. However, the techniques are sparse. [Unr16b] only shows that a random oracle is collapsing, and a more recent work of Unruh’s [Unr16a] gives a construction using lossy trapdoor functions (LTDFs). However, trying to embed a LTDF in the sigma protocol construction will result a less efficient scheme, which will be important for the application to signatures. In particular, Lyubashevsky’s scheme is inherently lossy, and moving to a regime where there is an injective mode will significantly increase parameter sizes. 
Associated Lossy Functionss. Our resolution is to devise a new technique for proving that a sigma protocol (or hash function) is collapsing. They key idea is that the protocol itself does not need to be lossy, just that there is an associated lossy function (not necessarily trapdoored) with a useful relationship to the protocol. 
In more detail, an associated lossy function for a sigma protocol consists of two sampling procedures GenL,GenI . GenI(a, c) takes as input the first two messages of the protocol, and outputs a function f . It guarantees that over the space of valid r, f is injective. In contrast, GenL(a, c) samples a lossy mode f , which is guaranteed to be constant over the space of valid r. In either case, no guarantees are made on invalid r. Lastly, we require that for any a, c, the two modes are computationally indistinguishable (even if the attacker knows a, c). 
Any scheme with an associated lossy function is collapsing. Indeed, given a, c and a superposition over valid r, sample a lossy mode f . Then measuring f(r) has no effect on the state (since f is constant over the set of valid r). Then we switch f to an injective mode and still measure f(r). By the computational indistinguishability of the modes, this change is undetectable. Finally, in the injective mode, f(r) informationtheoretically contains all information about r, so measuring f(r) is equivalent to measuring r. This means we can measure r without detection. 
Next, we observe that typical lattice-based sigma protocols have associated lossy functions. For example, Lyubashevsky’s signature scheme [Lyu12] uses a sigma protocol where the set of valid responses r are short vectors such that A ·r = u mod q where A is a short wide matrix that is part of the public key and u depends on a, c. We will define our associated lossy function to be the natural lossy function built from the Learning With Errors (LWE) problem [AKPW13]. A lossy mode f is sampled by choosing a tall skinny matrix C, a matrix E with short entries, and computing B = C ·A+E mod q. The function fB(r) is then bB · r mod qe, where b·e represents a suitably course rounding. Since r is short and E has short entries, we will have that B · r mod q ≈ C ·A · r mod q = C · u mod q, which is independent of which valid r is used. 
For the injective mode, we simply choose B at random mod q. By choosing parameters correctly, one can ensure that fB(r) is injective. 
One problem with the above is that, in order for the lossy mode to be constant, we need that q is super-polynomial. Otherwise, rounding errors will cause fB(r) in the lossy mode to not quite equal bC · ue, 
7
and the errors will depend on r. As such, for polynomial modulus, fB(r) is not constant on valid r. Using a super-polynomial modulus will negatively impact the efficiency of the scheme, and requires a stronger computational assumption. 
Our first observation is that we do not actually need full indistinguishability of the measured vs not measured r. For our application to sigma protocols, we just need that anything that happens when r is unmeasured will also happen with reasonable probability when r is measured. But the two cases could be distinguishable in the strict sense. This gives a weak notion of collapsing which is sufficient for rewinding. 
What this allows us to do is shrink q to be small, and we will have that the lossy mode in constant with non-negligible probability, which we show is sufficient. However, we still need q to be somewhat larger than what is required classically. This is because when we prove that the lossy mode is constant, we need to union bound over each row of C. Decreasing the height of C improves the probability of success, but we need to keep C a certain height so that the injective mode is actually injective. 
Separable Sigma Protocols. In order circumvent the above difficulties and get an optimally-small q, we show that we can get by using a single row of C. 
In more detail, we will say that a sigma protocol is separable if there is an associated family of functions with particular properties. Like associated lossy functions, the family of functions has two modes: a preserving mode (which can be seen as the analog of the lossy mode) and a separating mode (the analog of the injective mode). Unlike the lossy functions, the family of functions here will output only a single bit. In this case, there clearly can not be an injective mode. 
Instead, we will use the following requirements. A preserving mode f is still constant on valid r. On the other hand, the separating mode has the property that, for any valid r 6= r′, f(r) = f(r′) with probability, say, 1/2. 
We show that such separating functions can be used to show collapsing. What’s more, for lattice-based schemes, the separating functions can be seen as instances of the lossy functions where C is just a single row. As before, we will need to allow for some weak indistinguishability between preserving and separating modes, leading to weak collapsing. We will also need to handle separating modes where the probability is not necessarily exactly 1/2. We show how to do all of this, demonstrating that Lyubashevsky’s sigma protocol [Lyu12] is weakly collapsing. 
Putting It All Together Piecing our results from the previous sections together, we show that Lyuba-shevsky’s signature scheme [Lyu12] is secure under standard lattice assumptions. Namely, 2-soundness follows from the SIS assumption, under the same asymptotic parameters needed to prove security classically. The separating function we need in the quantum setting follows from the LWE assumption; recall that LWE implies SIS. The result is that the sigma protocol underlying Lyubashevsky’s signatures is sound under the LWE assumption. Then we apply our Fiat-Shamir proof, obtaining existentially unforgeable signatures. Our techniques readily extend to schemes based on Lyubashevsky’s, such as the efficient signature scheme of [DKL+18]. 
Other Results Our techniques for showing lattice-based sigma protocols are collapsing can also be applied to hash functions. In particular, our techniques show that the SIS hash function is collapsing. Recall that the SIS hash function is specified by a short wide matrix A, takes as inputs short vectors r, and outputs A · r mod q. 
If q is super-polynomial, then SIS will have an associated lossy function with strong indistinguishability, namely the same function constructed for the sigma protocols. As such, SIS with super-polynomial q is collapsing. On the other hand, for polynomial q, SIS is weakly separable using the same functions as above, showing that SIS is weakly collapsing. This gives the to-date most efficient standard-model collapsing hash function. 
8
Limitations The obvious limitation of our work is the tightness of our reductions. Our Fiat-Shmir proof is quite loose, losing a factor of q9 where q is the number of random oracle queries; we leave tightening our proof as an important open problem. 
This looseness makes our results all but useless for guiding parameter choices in practice. However, we note that in practice parameter choices typically are chosen to block the best attacks rather than the bounds obtained by reductions. Of course, getting a tight bound that matches the parameters used in practice is the ideal outcome, but this is often not attainable. Indeed, even the classical Fiat-Shamir proof is somewhat loose. This has lead to some authors (e.g. [DKL+18]) to make new assumptions that incorporate the hash function which can be tightly connected to the security of their scheme. These new assumptions can then be justified (with a loss!) using the classical Fiat-Shamir proof. 
We therefore view our results as at least showing asymptotically that Lyubashevsky’s and related signature schemes are secure, meaning there are no fundamental weaknesses incurred by using the Fiat-Shamir heuristic in the quantum world. Alternatively, our proof can be used to give a quantum justification for assumptions which can then be tightly connected to the security of schemes. 
1.3 Independent and Concurrent Work 
Very recently, Don, Fehr, Majenz and Schaffner [DFMS19] also showed that the security of Fiat-Shamir in the quantum random oracle model. That is, applied to standard soundness and proof-of-knowledge definitions, their reduction implies both post-quantum security properties, in both computational and the statistical variant, are preserved under Fiat-Shamir transformation. The comparisons are summarized below: 
1. Don, Fehr, Majenz and Schaffner showed how to “read-out” a query from the adversary and reprogram a fresh random value. The way this works is simple. They choose the query uniformly at random among all the queries made by the adversary and measure it in order to get x. Subsequently they reprogram the RO, so as to answer x with a random value Θ, either from this point on or from the following query on, where this binary choice is made at random. The total loss here is O(q2). Our work also has both “extract” and “reprogram” techniques, which are based on variants of Zhandry’s compressed oracles. They incur an O(q9) loss as mentioned earlier in this section. 
2. Both work showed given their “extract” and “reprogram” techniques, post-quantum standard soundness and proof-of-knowledge hold under Fiat-Shamir transformation (with O(q2) and O(q9) loss respectively) in computational setting. 
3. In their work, they first used the definition “computationally unique response” from [KLS18] to solve the problem of rewinding an argument. And then they gave a new definition called “quantum computationally unique response” which is essentially the same as our definition “collapsing sigma protocol”. Then they showed – Assume that ZKBoo uses either i) a collapsing hash function, or ii) a hash function treated in 
the QROM, as commitment scheme. Then Sig[ZKBoo] is strongly existentially unforgeable in the QROM. The assumption here directly makes the sigma protocol have quantum computationally unique response. 
– They made the following assumption: Let q be super-polynomial, and m and n be polynomial, in the security parameter η. Then the function family fA keyed by a uniformly random matrix A ∈ Fm×n 
q 
is collapsing. In our language, SIS with super-polynomial q is collapsing. And under this assumption, they showed the signature scheme based on [Lyu12] is strongly existentially unforgeable in the QROM. 
In our work, we define “collapsing sigma protocol” and also “weakly collapsing”. We showed that even under weakly collapsing, we can rewind an argument. Besides, we showed that [Lyu12] is strongly existentially unforgeable even if q is polynomial: – We proved the above assumption made by Don, Fehr, Majenz and Schaffner. We showed that when q is super-polynomial, SIS is collapsing. So the resulting sigma protocol is collapsing. 
– We also gave two sufficient conditions for weakly collapsing, namely compatible lossy function and compatible separable function. We showed that even if q is polynomial, there exist compatible lossy function and separable function for SIS. In other words, the resulting sigma protocol with polynomial q is weakly collapsing. 
9
– Follow the conclusion above, even if q is polynomial, signatures based on [Lyu12] is strongly existentially unforgeable. 
Acknowledgements 
This work is supported by NSF and DARPA. Opinions, findings and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of NSF or DARPA. 
2 Preliminaries 
2.1 Sigma Protocol 
For every λ, there is a relation Rλ = {(x,w) : x ∈ Lλ, w ∈ W (x)} such that the length of x and w is bounded by a polynomial of λ, x is a statement in an NP language Lλ and W (x) is the set of witness for proving x ∈ Lλ. In other words, there is an polynomial time algorithm runs in poly(λ) that decides whether (x,w) ∈ Rλ. 
Definition 1 (Sigma Protocol). A sigma protocol for Rλ consists two polynomial time algorithms, prover P and verifier V. The sigma protocol procedure looks like the follows: 
– P is given both x,w and generates (a, st) ← P.Commit(1λ, x, w). st is its own state and it sends the commitment a to V; 
– V given x and a, generates a challenge c uniformly at random in {0, 1}λ where wlog λ is the security parameter of this protocol; 
– P given the challenge c, generates a response r ← P.Prove(1λ, x, w, st, c); – The verifier V.Ver checks whether (a, c, r) is valid. If it is, V.Ver(1λ, x, a, c, r) returns 1. 
When it is clear in the context, we omit 1λ for convenience. 
Instance Generation Sometimes, we will need to consider a distribution over instances. In these cases, we associate a Gen(·) algorithm to a sigma protocol. Gen(1λ) outputs a pair of (x,w) ∈ Rλ. Gen(·) defines a distribution over Rλ. In this setting, we use pk to denote x and sk to denote (x,w). Moreover, we have P.Commit(sk) = P.Commit(x,w), P.Prove(sk, st, c) = P.Prove(x,w, st, c) and V.Ver(pk, a, c, r) = V.Ver(x, a, c, r). This notation will be useful when we build an ID protocol or a signature scheme from a sigma protocol. 
Completeness We say a sigma protocol is complete if for every λ, every (x,w) ∈ Rλ, honest P with (x,w) and honest V with x, 
Pr 
[ V.Ver(x, a, c, r) = 1 : 
(a,st)←P.Commit(x,w) 
c←{0,1}λ r←P.Prove(x,w,st,c) 
] = 1 
Throughout the paper, we will need a notion of weak completeness for sigma protocol associated with some Gen(·). This requires that, for almost all valid (pk, sk), honestly generated transcripts pass the verification with non-negligible probability (rather than perfect probability, as in standard completeness). In other words, there exist sets Goodλ, polynomial p(·) such that for every λ, honest P with pk and V with sk, 
Pr (pk,sk)←Gen(1λ) 
[(pk, sk) ∈ Goodλ] ≥ 1− negl(λ) 
And for every (pk, sk) ∈ Goodλ, 
Pr 
[ V.Ver(pk, a, c, r) = 1 : 
(a,st)←P.Commit(sk) 
c←{0,1}λ r←P.Prove(sk,st,c) 
] ≥ 1 
p(λ) 
There are several possibilities to have imperfect completeness. One example is that P.Prove will flip a coin. It outputs nothing if the coin is 1 and otherwise it outputs a valid proof. In this case, the sigma protocol has 1/2 completeness. Another example is that P.Prove is only able to compute a valid proof on 1/p(λ) fraction of random challenges c. So there are some hard challenges on which P.Prove will fail. 
10
Unpredictable Commitment We say a sigma protocol has unpredictable commitments if there exits a negligible function negl(·), for all λ, for every (x,w) ∈ Rλ, 
Pr[a = a′, (a, st)← P.Commit(x,w), (a′, st′)← P.Commit(x,w)] ≤ negl(λ) 
We say a sigma protocol associated with Gen(·) has unpredictable commitments if there exits a negligible function negl(·), for all λ, taken the randomness of (pk, sk)← Gen(1λ), 
Pr[a = a′, (a, st)← P.Commit(sk), (a′, st′)← P.Commit(sk)] ≤ negl(λ) 
We can always assume a sigma protocol has unpredictable commitments. There are two reasons. First, we can always append a random string of length λ at the end of a and when a prover proves or a verifier verifies it, they first throw away the random suffix. This construction gives the sigma protocol unpredictable commitment property and does not affect other properties. 
The second reason is, if the sigma protocol does not have this property, (P,V) can be modified to ZK with CRS. The idea is to avoid the commitment round, let V guess the commitment a′, and P at the prove stage, uses CRS as the random challenge c, sends both the commitment a and proof r to V. V will check a = a′ (which happens with non-negligible probability) and (a, c, r) is a valid transcript. This transformation will leads to a ZK with CRS and weak completeness. 
So in the rest of the paper, we always assume a sigma protocol has unpredictable commitments. 
2-Soundness The post-quantum 2-soundness of a sigma protocol associated with Gen(·) is the following: for any λ and any pk, for any polynomial time quantum algorithm A, given only pk, the following probability is negligible, taken the randomness of (pk, sk)← Gen(1λ), 
Pr [ V.Ver(pk,a,c,r)=1 V.Ver(pk,a,c′,r′)=1 
: (a, c, r, c′, r′)← A(pk), c 6= c′ ] < negl(λ) 
In other words, there is no polynomial time quantum adversary that can find two valid transcripts with the same a but different c 6= c′. 
ID Soundness When using a sigma protocol for identification, the soundness requirements above are insufficient on their own to protect against eavesdropping attacks. Instead, we will need the notion of ID soundness. The definition allows a malicious prover to get polynomial number of honestly generated transcripts. 
The post-quantum computational ID soundness of a sigma protocol associated with Gen(·) is the following: for any polynomial time quantum prover P ′ = (A0,A1) without sk, but only given pk and polynomial number of transcripts {(ai, ci, ri)}qi=1 generated by honest prover and verifier with sk and pk respectively, the probability, taken the randomness of (pk, sk)← Gen(1λ), 
Pr 
[ V.Ver(pk, a, c, r) = 1 : 
a,|φa〉←A0(pk,{(ai,ci,ri)}) c 
$←{0,1}λ r←A1(pk,{(ai,ci,ri)},|φa〉,c) 
] ≤ negl(λ) 
If the ID protocol has perfect completeness, all honest transcripts are valid. If it only has weak completeness, each transcript has at least 1/p(λ) probability to be valid. 
Statistical/Quantum Computational HVZK there exists a polynomial time classical/quantum simulator Sim, for every λ and (x,w) ∈ Rλ, given only x, the following two distributions are statistically/computationally indistinguishable against any quantum polynomial time distinguisher: 
{(a, c, r)← Sim(x)} ≈c 
{ (a, c, r) 
∣∣∣∣ (a,st)←P.Commit(x,w) 
c←{0,1}λ r←P.Prove(x,w,st,c) 
} 
11
If the sigma protocol has perfect completeness, Sim is required to output valid transcripts. But when the sigma protocol only has weak completeness, Sim does not always output valid transcripts. The definition only requires Sim outputs transcripts that looks like as being generated by honest prover P and verifier V. 
Similarly, we can define statistical/quantum computational HVZK for a sigma protocol associated with Gen(·). Similar to weak completeness, there exists sets Goodλ such that 
Pr (pk,sk)←Gen(1λ) 
[(pk, sk) ∈ Goodλ] > 1− negl(λ) 
and there exists a efficient simulator Sim, for every (pk, sk) ∈ Goodλ, the above equation holds. 
2-Extractability We say a sigma protocol has 2-extractability if there exists a classical polynomial time extractor E, such that for all λ and all x, given two valid transcripts a, c, r and a, c′, r′ such that c 6= c′, we have 
Pr [(x,E(x, a, c, r, c′, r′)) ∈ Rλ] = 1 
For this definition, E can be either quantum or classical. All the proofs in the paper remain the same if E is a quantum extractor. 
Proof of Knowledge (QPoK) We say a sigma protocol has validity (c, p, κ, negl) if there is quantum polynomial time extractor E, a constant c, a polynomial p(·), and negligible functions κ(·), negl(·), such that for any (quantum) prover A = (A0,A1), for any x satisfying 
Pr 
[ V.Ver(x, a, c, r) = 1 : 
(a,|φa〉)←A0(x) 
c $←{0,1}λ 
r←A1(x,|φa〉,c) 
] ≥ κ(λ) 
we have, 
Pr [( x,EA(x)(x) 
) ∈ Rλ 
] ≥ 
1 
p(λ) · ( Pr 
[ V.Ver(x, a, c, r) = 1 : 
(a,|φa〉)←A0(x) 
c $←{0,1}λ 
r←A1(x,|φa〉,c) 
] − κ(λ) 
)c 
− negl(λ) 
where E is given oracle access to A(x). Similar to [Unr12], the oracle machine EA(x) means: 
– A0(x) is defined as applying a unitary U and doing measurement, – A1(x, |φ〉, c) is defined as computing Vc based on pk, c, applying Vc on |φ〉 and doing measurement. It is 
equivalent to the case that |φ〉 maps to |φ, c〉 and applies a unitary ∑ 
c Vc ⊗ |c〉〈c|. For convenience, we consider this is the first case. 
– EA(x) can do quantum computation, making oracle access to U , Vc as well as U † and V †c . Each oracle access costs one unit time. 
2.2 More Definitions from Sigma Protocol 
Definition 2 (Quantum Secure Sigma Protocol). We say a sigma protocol associated with Gen(·) is (weakly) quantum secure if it has perfect/weak completeness, post-quantum 2-soundness, post-quantum computational HVZK. 
Definition 3 (Quantum Secure Identification Protocol). A (weakly) quantum secure identification protocol is a sigma protocol associated with Gen(·), having perfect/weak completeness and post-quantum computational ID soundness. 
Definition 4 (Quantum HVZKPoK). We say a sigma protocol is a quantum honest verifier zero-
knowledge proof of knowledge if it has perfect completeness, post-quantum computational HVZK and validity (c, p, κ, negl) for some constant c, polynomial p and negligible functions κ, negl. 
12
2.3 NIZKPoK with QRO 
For every λ, there is a relation Rλ = {(x,w) : x ∈ Lλ, w ∈ W (x)} such that the length of x and w is bounded by a polynomial of λ, x is a statement in an NP language Lλ and W (x) is the set of witness for proving x ∈ Lλ. In other words, there is an polynomial time algorithm runs in poly(λ) that decides whether (x,w) ∈ Rλ. 
Definition 5 (NIZKPoK with QRO). A quantum non-interactive zero-knowledge proof of knowledge protocol for Rλ consists two polynomial time algorithms, oracle prover PO and oracle verifier VO. The protocol procedure is the follows: 
– A random oracle O is chosen; – P.ProveO is given (x,w), it generates a proof π and sends it to the verifier. – The verifier runs V.VerO(x, π) and returns whatever the verifying algorithm returns. 
And it has the following properties: 
Completeness: for all λ and (x,w) ∈ Rλ, and all random oracle O, 
Pr [ V.VerO(x, π) = 1, π ← P.ProveO(x,w) 
] = 1 
Zero-Knowledge: Given a simulator S, the oracle S′(x,w) runs S(x) and returns its output. It is also allowed to simulate a random oracle |OS〉 and answer random oracle queries made by a distinguisher. Given a prover P, the oracle P ′(x,w) runs P.ProveO(x,w) and returns its output. 
We say the non-interactive proof system (P,V) is zero-knowledge if there exists an efficient classi-cal/quantum simulator S, such that for every efficient quantum distinguisher D, there is a negligible function negl(·) such that ∣∣∣Pr[DS′,|OS〉 = 1]− Pr 
O [DP 
′,|O〉 = 1] ∣∣∣ ≤ negl(λ) 
where D is only allowed to make query (x,w) ∈ Rλ. 
QPoK: We say it has validity (c, p, κ, negl) if there is quantum polynomial time extractor E, a constant c, a polynomial p(·), and negligible functions κ(·), negl(·), such that for any quantum prover P ′, for any x satisfying 
Pr [ V.VerO(x, π) = 1 : π ← P ′.Prove|O〉(x) 
] ≥ κ(λ) 
we have, 
Pr [( x,EP 
′|O〉(x)(x) ) ∈ Rλ 
] ≥ 
1 
p(λ) · ( Pr [ V.VerO(x, π) = 1 : π ← P ′.Prove|O〉(x) 
] − κ(λ) 
)c − negl(λ) 
where E is given oracle access to P ′|O〉(x) and simulates a random oracle which allows P ′ to access. Having oracle access to P ′|O〉(x) meaning having both oracle access to the unitary and inverse of the unitary in 
P ′.Prove|O〉(x). In other words, if P ′.Prove|O〉(x) = UqOUq−1O · · ·U2OU1O|ψx〉 (and a final measurement), 
E has oracle access to all Ui and U † i . 
2.4 Digital Signature 
Definition 6 (Digital Signature). A digital signature scheme consists three polynomial time algorithms Gen, Sign,Ver: 
– Gen(1λ): given a security parameter, it outputs a verification key vk and a signing key sk; – Sign(sk,m): given a signing key sk and a message m, it outputs a signature σ; – Ver(vk,m, σ′): it outputs 0/1 meaning if σ′ is a valid signature of m. 
13
Correctness We say a digital signature scheme is correct if for any security parameter λ, any message m, we have 
Pr [ Ver(vk,m, σ) = 1 : vk,sk←Gen(1λ) 
σ←Sign(sk,m) 
] ≥ 1− negl(λ) 
Security (Existential Unforgeability) Let us consider the following game GameλA: 
– The challenger generates a pair of keys vk, sk← Gen(1λ), and A is given vk. 
– A can make polynomial number of signing queries mi, the challenger returns σi = Sign(vk,mi). 
– A can also make a challenge query m∗ at any stage. Finally it comes out with σ∗. – A wins if (x∗, σ∗) is not equal to any (xi, σi) and Ver(vk,m∗, σ∗) = 1. 
We say it is (t, q, ε)-secure if for any quantum algorithm A of running time at most t = poly(λ) and making at most q = poly(λ) signing queries, 
Pr[GameλA = 1] ≤ ε(λ) 
We can also define a quantum secure digital signature scheme with respect to a quantum random oracle where we allow A to be a quantum polynomial time algorithm and make polynomial number of quantum oracle queries and classical signing queries. 
Definition 7 (Digital Signature with QRO). A digital signature scheme consists three polynomial time algorithms Gen, and oracle algorithms SignO,VerO: 
– Gen(1λ): given a security parameter, it outputs a verification key vk and a signing key sk; 
– SignO(sk,m): given a signing key sk and a message m, it can make quantum queries to O. It finally outputs a signature σ; 
– VerO(vk,m, σ′): it outputs 0/1 meaning if σ′ is a valid signature of m. It can also make quantum queries to O. 
Correctness We say a digital signature scheme with QROM is correct if for any security parameter λ, any message m, we have 
Pr O 
[ VerO(vk,m, σ) = 1 : vk,sk←Gen(1λ) 
σ←SignO(sk,m) 
] ≥ 1− negl(λ) 
Post-Quantum Security (Existential Unforgeability) Let us consider the following game GameλA: 
– The challenger generates a pair of keys vk, sk ← Gen(1λ), and A is given vk. A random oracle O is chosen. The challenger has access to O and A has access to |O〉 which means it can make quantum queries to O. 
– A can make polynomial number of signing queries mi, the challenger returns σi = SignO(vk,mi). 
– A can make polynomial number of oracle queries to |O〉. – A can also make a challenge query m∗ at any stage. Finally it comes out with σ∗. – A wins if (x∗, σ∗) is not equal to any (xi, σi) and VerO(vk,m∗, σ∗) = 1. 
We say it is (t, q, ε)-secure if for any quantum algorithm A of running time at most t = poly(λ) and making at most q = poly(λ) signing queries and quantum oracle queries, 
Pr[GameλA = 1] ≤ ε(λ) 
14
3 Weakly Collapsing Sigma Protocol 
3.1 Collapsing 
In addition to the usual properties considered classically, we define a new notion of security for sigma protocols, inspired by Unruh’s notion of collapsing for hash functions and commitments [Unr16b]: 
Definition 8 (Collapsing Sigma Protocol). For any λ, for any Gen(1λ) and any polynomial time quantum distinguisher D, define the following game CollapsingGamebD,pk,sk: 
– (pk, sk)← Gen(1λ), D is given pk and generates and sends a to the challenger; it then gets a uniformly random c from the challenger Ch; then it generates a superposition |φ〉 over all r (may not be a valid r) together with its own quantum states and sends the part |φ〉 to the challenger Ch; 
– Upon receiving |φ〉, Ch verifies in superposition that |a, c〉|φ〉 is a superposition over valid transcripts. If the verification fails, Ch outputs a random bit and aborts. Otherwise, let |φ′〉 be the superposition after the measurement, which is the projection of |φ〉 onto r such that |a, c, r〉 is valid. Then Ch flips a coin b, if b = 0, it does nothing; if b = 1, it measures |φ′〉 in computational basis. Finally it sends the superposition back to D. 
– The experiment’s output is what D outputs. 
We say a quantum sigma protocol associated with Gen(·) is collapsing if for every polynomial time quantum distinguisher D, the probability D distinguishes is negligible, in other words, there is a negligible function negl, such that 
∣∣Pr [ CollapsingGame0D,pk,sk = 0 
] − Pr 
[ CollapsingGame1D,pk,sk = 0 
]∣∣ ≤ negl(λ) 
Where probabilities are taken over the randomness of (pk, sk)← Gen(1λ) and the randomness of D. We can similarly define weakly collapsing property which is used in the rest of the paper. 
Definition 9 ((γ-)Weakly Collapsing). We say a quantum secure sigma protocol associated with Gen(1λ) is weakly collapsing, if there exists a non-negligible γ(·), such that for any polynomial time quantum distinguisher D, 
Pr [ CollapsingGame1D,pk,sk = 0 
] ≥ γ(λ) · Pr 
[ CollapsingGame0D,pk,sk = 0 
] − negl(λ) 
Weak collapsing captures the setting where measuring the adversary’s response causes a noticeable change in outcome in contrast to not measuring, but any event that occurs in the un-measured setting also occurs in the measured setting. We can similarly define a worst case version of weak collapsing where that holds for any choice of (x,w) ∈ R, rather than for a random (pk, sk) chosen from Gen. 
In the next subsections, we give sufficient conditions for demonstrating the collapsing property. Our definitions are given for sigma protocols, but can easily be extended to hash functions. A key feature of our definitions is that they are essentially classical definitions, as opposed to collapsing which is inherently quantum. As such, we believe our weaker definitions will be easier to instantiate, as we demonstrate in Section 5. 
3.2 Compatible Lossy Function 
A compatible lossy function can be thought as a function generator CLF.Gen(·). It takes all the parameters λ, pk, sk, a, c and mode ∈ {constant, injective}, outputs a constant or small range (polynomial size) function over all valid r. Here valid r means V.Ver(pk, a, c, r) = 1. Also, no efficient quantum algorithm can distinguish whether it is given a function description from constant mode or injective mode. 
Definition 10 ((p, γ)-Compatible Lossy Function). A compatible lossy function respective to a sigma protocol is an efficiently computable function generator CLF.Gen(λ, pk, sk, a, c,mode) which takes a security parameter λ, pk, sk, a commitment a, a challenge c and mode ∈ {constant, injective}, it outputs a description of an efficiently computable function f such that 
15
1. constant mode: for all r satisfying (a, c, r) is a valid transcript, f has image of polynomial size with probability at least an inverse of some polynomial. Formally, there exists a polynomial p and a non-negligible function γ(·), such that for all λ, pk, sk, for all a, c, let Fconstant be the distribution of functions that sampled by CLF.Gen(λ, pk, sk, a, c, constant), 
Pr f←Fconstant 
[|Im(f)| ≤ p(λ)] ≥ γ(λ) 
The reason why it is called constant mode is because we only need the function to be a constant function defined on all valid r with constant probability in our proof. But this can be relaxed to have polynomial size range with probability at least an inverse of some polynomial. 
2. injective mode: f is an injective function defined over all r satisfying (a, c, r) is a valid transcript, with overwhelming probability. Formally, there exists a polynomial q, such that for all λ, pk, sk, for all a, c, let Finjective be the distribution of functions that sampled by CLF.Gen(λ, pk, sk, a, c, injective), 
Pr f←Finjective 
[f is injective over all valid r] ≥ 1− negl(λ) 
3. Indistinguishability: Let us first define LFGamebD,pk,sk: – D is given pk and interacts with the challenger Ch which has pk, sk, – D sends a pair of valid a, c to the challenger, – Ch chooses a random function f from Fconstant if b = 0 or from Finjective if b = 1, where Fconstant or Finjective is determined by pk, sk, a, c, 
– D is given the description of f , the result of the game is the output of D. We require that for every λ, for every polynomial time quantum distinguisher D, taken the randomness of (pk, sk)← Gen(1λ), 
∣∣Pr [ LFGame0D,pk,sk = 0 
] − Pr 
[ LFGame1D,pk,sk = 0 
]∣∣ ≤ negl(λ) 
Next, we have the following lemma which gives us the first sufficient condition to get a collapsing sigma protocol. 
Lemma 1. If a quantum secure sigma protocol associated with Gen(·) has (pc, γ)-compatible lossy functions, it is (γ/pc)-weakly collapsing. 
Proof. Assume there is a non-negligible function ε(·), a polynomial time quantum distinguisher D that breaks the (γ/pc)-weakly collapsing property of this sigma protocol. From the definition, taken the randomness of (pk, sk)← Gen(1λ), we have, 
Pr [ CollapsingGame1D,pk,sk = 0 
] < 
γ(λ) 
pc(λ) Pr [ CollapsingGame0D,pk,sk = 0 
] − ε(λ) 
Let us assume there exist a (pc, γ)-compatible lossy function. We will build an adversary A that uses D as a subroutine and breaks the compatible lossy function. Here is what A does: 
– A given pk, it runs D and gets a, 
– A chooses a random c $← {0, 1}λ, and gives c to D and a, c to the challenger Ch, 
– A gets |φ〉 from D and a function f from Ch. It first checks |φ〉 contains valid r on superposition. If the measurement does not pass, A randomly guesses a bit. Otherwise, let |φ′〉 = 
∑ r αr|r〉 be the 
superposition after the measurement. It applies f to |φ′〉, 
Uf |φ′〉|0〉 = ∑ 
valid r 
αr|r, f(r)〉 
and it measures the f(r) registers to get y and uncomputes f(r). The remaining state is |φy〉 =∑ valid r,f(r)=y αr|r〉. 
16
– It gives |φy〉 to D and outputs what D outputs. 
We want to prove that the equation does not hold, ∣∣Pr [ LFGame0A,pk,sk = 0 
] − Pr 
[ LFGame1A,pk,sk = 0 
]∣∣ ≤ neglCLF(λ) 
By the first constant mode requirement, assuming the corresponding Fconstant samples a function f of image size at most pc(λ) with probability at least γ(λ) for any pk, sk, a, c: 
Pr [ LFGame0A,pk,sk = 0 
] ≥ γ(λ) · Pr 
[ LFGame0A,pk,sk = 0 
∣∣ |f | ≤ pc(λ) ] 
That is, the probability A outputs 0 given a function f ← Fconstant is not too small comparing to the probability conditioned on f has image size at most pc(λ). 
Combining with lemma 2.1 in [BZ13], which says 
Lemma 2 (Lemma 2.1 from [BZ13]). Let A be a quantum algorithm, and let Pr[x] be the probability that A outputs x. Let A0 be another quantum algorithm obtained from A by pausing A at an arbitrary stage of execution, performing a partial measurement that obtains one of k outcomes, and then resuming A. Let Pr0[x] be the probability A0 outputs x. Then Pr0[x] ≥ Pr[x]/k. 
We can view A in the game LFGame0A,pk,sk as doing a partial measurement in the game CGame0D,a,c. So we have, 
Pr [ LFGame0A,pk,sk = 0 
∣∣ |f | ≤ pc(λ) ] ≥ 1 
pc(λ) · Pr[CGame0D,a,c = 0] 
Here CGame stands for CollapsingGame. Overall, we have 
Pr [ LFGame0A,pk,sk = 0 
] ≥ γ(λ) 
pc(λ) Pr[CGame0D,a,c = 0] 
Next, assuming the corresponding Finjective samples an injective function f over all valid r with probability at least 1− neglinj(λ) for all pk, sk, a, c, we have 
Pr [ LFGame1A,pk,sk = 0 
] ≤ Pr 
[ LFGame1A,pk,sk = 0 
∣∣ f is injective ] + neglinj(λ) 
= Pr[CGame1D,a,c = 0] + neglinj(λ) 
where neglinj(λ) is upper bound of the probability that f is not an injective function. Combining all the inequalities above, we have, 
Pr [ LFGame1A,pk,sk = 0 
] < Pr 
[ LFGame0A,pk,sk = 0 
] + neglinj(λ)− ε(λ) 
which breaks the compatible lossy function. ut 
3.3 Compatible Separable Function 
Definition 11 ((τ, β)-Compatible Separable Function). A compatible separable function for a sigma protocol is an efficient procedure CSF.Gen(λ, pk, sk, a, c,mode) which takes a security parameter λ, pk, sk, a commitment a, a challenge c and mode ∈ {preserving, separating}, it outputs a description of an efficiently computable function f that outputs 0, 1 such that 
1. preserving mode: over the set Va,c of valid r, with non-negligible probability f is a constant function. Formally, there exists a non-negligible function τ(·), such that for all λ, pk, sk, for all a, c, let Fp be the distribution sampled by CSF.Gen(λ, pk, sk, a, c, preserving), 
Pr f←Fp 
[|Im(f)| = 1] ≥ τ(λ) 
where Im(f) is the image of f over all valid r satisfying (a, c, r) is a valid transcript. 
17
2. separating mode: there exists an α such that, for all valid r 6= r′, the probability of f(r) = f(r′) is exactly 1+α 2 where the randomness is taken over the choice of f . 
Formally, there exists β(λ) < τ(λ) such that τ(λ)−β(λ) is non-negligible, for all λ, pk, sk, for all a, c, let Fs be the distribution of functions that sampled by CSF.Gen(λ, pk, sk, a, c, injective), there exists an α(·) which is upper bounded by β(·) (but which is potentially negative), for every pair of valid r 6= r′, 
Pr f←Fs 
[f(r) = f(r′)] = 1 + α(λ) 
2 
3. Indistinguishability: Let us first define SFGamebD,pk,sk: – D is given pk and interacts with the challenger Ch which has pk, sk, – D sends a pair of valid a, c to the challenger, – Ch chooses a random function f from Fp if b = 0 or from Fs if b = 1, where Fp or Fs is determined 
by pk, sk, a, c, – D is given the description of f , the result of the game is D’s output. 
We require that for every λ, for every polynomial time quantum distinguisher D, taken the randomness of (pk, sk)← Gen(1λ), 
∣∣Pr [ SFGame0D,pk,sk = 0 
] − Pr 
[ SFGame1D,pk,sk = 0 
]∣∣ ≤ negl(λ) 
Lemma 3. If a sigma protocol associated with Gen(·) has (τ, β)-compatible separable functions, it is τ−β 2 -
weakly collapsing. 
Proof. Assume there is a non-negligible function ε(·) and a polynomial time quantum distinguisher D that breaks the τ−β 
2 -weakly collapsing property of this sigma protocol. From the definition, taken the randomness of pk, sk, we have, 
Pr [ CGame1D,pk,sk = 0 
] < τ(λ)− β(λ) 
2 · Pr 
[ CGame0D,pk,sk = 0 
] − ε(λ) 
where CGame stands for CollapsingGame. Let us assume there exist a (τ, β)-compatible separable function. We will build an adversary A that uses 
D as a subroutine and breaks the compatible separable function. Here is what A does: 
– A given pk, it runs D (which taks pk as input) and gets a, 
– A samples c $← {0, 1}λ, and gives c to D and a, c to the challenger Ch, 
– A gets |φ〉 from D and a function f from Ch. It first checks |φ〉 contains valid r on superposition. If the measurement does not pass, A randomly guesses a bit. Otherwise, let |φ′〉 = ∑ 
r αr|r〉 be the superposition after the measurement. It applies f to |φ′〉, 
|φ′′〉 = Uf |φ′〉 = ∑ 
valid r 
αr · (−1)f(r)|r〉 
– It gives |φ′′〉 to D and outputs what D outputs. 
For any pk, sk, a, c, any possible |φ′〉 = ∑ valid r αr|r〉 in the above game, what is the density matrix of 
|φ′〉 or |φ′〉 measured in computational basis? If the state is not measured (which corresponds to the density matrix in CGame0D,pk,sk), we have the density matrix is 
ρ0 = ∑ 
valid r,r′ 
ᾱrαr′ |r〉〈r′| 
and if |φ′〉 is measured (which corresponds to the density matrix in CGame1D,pk,sk), the density matrix is 
ρ1 = ∑ 
valid r 
|αr|2 · |r〉〈r| 
18
If we take a function f ← Fp, let Uf be a unitary Uf |r〉 = (−1)f(r)|r〉. Apply Uf to ρ0, we have 
ρp = ∑ 
f←Fp 
1 
|Fp| · Uf ρ0 U 
† f = Pr 
f←Fp 
[|Im(f)| = 1] · ρ0 + ∑ 
f←Fp 
f is not constant 
1 
|Fp| · Ufρ0U 
† f 
which is easy to see that ρp is a convex combination of ρ0 and Ufρ0U † f for f is not constant. The above 
equality holds because when f is a constant function, Uf is an identity. It says if a distinguisher outputs 0 when ρ0 is given, the same distinguisher outputs 0 with probability at least Pr[|Im(f)| = 1] ≥ τ(λ) when ρp is given. In other words, we have 
Pr[SFGame0A,pk,sk = 0] ≥ τ(λ) · Pr[CGame0D,pk,sk = 0] 
Next if we apply Uf where f ← Fs to the density matrix ρ0, we have 
ρs = ∑ 
f←Fs 
1 
|Fs| · Uf ρ0 U 
† f = 
∑ 
valid r,r′ 
∑ 
f←Fs 
1 
|Fs| · ᾱrαr′ · Uf |r〉〈r′|U †f 
= ∑ 
valid r 
|αr|2 · |r〉〈r|+ ∑ 
valid r 6=r′ 
ᾱrαr′ · |r〉〈r′| · 
   ∑ 
f←Fs 
1 
|Fs| (−1)f(r)+f(r′) 
   
= ∑ 
valid r 
|αr|2 · |r〉〈r|+ α(λ) · ∑ 
valid r 6=r′ 
ᾱrαr′ · |r〉〈r′| 
= (1− α(λ)) · ρ1 + α(λ) · ρ0 
If α(λ) ≤ 0, we have ρ1 = 1 1−α(λ) ·ρs+ 
−α(λ) 1−α(λ) ·ρ0. If a distinguisher outputs 0 when ρs is given, the same 
distinguisher outputs 0 with probability at least 1 2 when ρ1 is given. In other words, for any distinguisher 
D′, 
Pr[D′(ρs) = 0] ≤ 2 · Pr[D′(ρ1) = 0] 
If α(λ) is positive, we have ρs = (1 − α(λ)) · ρ1 + α(λ) · ρ0. In other words, for any distinguisher D′, because α(λ) < β(λ), 
Pr[D′(ρs) = 0] = (1− α(λ)) · Pr[D′(ρ1) = 0] + α(λ) · Pr[D′(ρ0) = 0] 
≤ Pr[D′(ρ1) = 0] + β(λ) · Pr[D′(ρ0) = 0] 
Combining the two above equations, taken over the randomness of pk, sk, a, c, 
Pr[SFGame1A,pk,sk = 0] ≤ 2 · Pr[CGame1D,pk,sk = 0]+ 
β(λ) · Pr[CGame0D,pk,sk = 0] 
Finally, we show that A breaks the compatible separable function, 
Pr[SFGame0A,pk,sk = 0]− Pr[SFGame1A,pk,sk = 0] 
> τ(λ) · Pr[CGame0D,pk,sk = 0]− ( 2 · Pr[CGame1D,pk,sk = 0] + β(λ) · Pr[CGame0D,pk,sk = 0] 
) 
= (τ(λ)− β(λ)) · Pr[CGame0D,pk,sk = 0]− 2 · Pr[CGame1D,pk,sk = 0] 
> 2 · ε(λ) 
ut 
19
4 Quantum ID Protocol and Quantum HVZKPoK 
In this section, we will see that given a quantum secure sigma protocol with weakly collapsing property, we can overcome the difficulty of doing quantum rewinding and build a quantum secure identification protocol. The same technique can be applied to HVZKPoK. 
4.1 Quantum ID Protocol 
Theorem 1. Assume we have a quantum secure sigma protocol with associated Gen(·) which satisfies the weakly collapsing property (with perfect/weak completeness). Then it is a quantum secure identification protocol (with perfect/weak completeness). 
In other words, if a sigma protocol has (1) perfect/weak completeness, (2) post-quantum 2-soundness, (3) statistical/post-quantum computational HVZK and (4) weakly collapsing property, it is a sigma protocol with (1) perfect/weak completeness, (2) post-quantum ID soundness. 
Proof. The perfect/weak completeness remains the same. Based on statistical/post-quantum computational HVZK, wlog the adversary breaking the computational 
ID soundness can generate honestly generated transcripts itself (as long as with overwhelming probability, (pk, sk) ∈ Goodλ). So let us assume the adversary breaking ID soundness is not given any transcripts. 
Assume there is a polynomial time quantum adversary A = (A0,A1) that breaks the computational ID soundness of this identification protocol. So in other words, taken the randomness of (pk, sk)← Gen(1λ) and A, the probability, taken over the randomness of (pk, sk)← Gen(1λ), 
Pr 
[ V.Ver(pk, a, c, r) = 1 : 
(a,|φa〉)←A0(pk) 
c $←{0,1}λ 
r←A1(pk,|φa〉,c) 
] > ε(λ) 
where ε is a non-negligible function. We can assume wlog that A0 has two parts, the first part is the commitment registers and the second 
part is its own state registers. In other words, 
– A0(pk) starts with ∑ 
a,s αa,s|a, s〉. – A0 measures the commitment registers and gets a, |φa〉 = 
∑ s αa,s|s〉 (normalized). 
– A1 takes c and |φa〉 = ∑ 
s αa,s|s〉 (normalized), applies Vc to |φa〉. – Wlog, Vc|φa〉 starts with the output registers: 
Vc|φa〉 = ∑ 
r,s′ 
βr,s′ |r, s′〉 
A1 first does a projective measurement Pa,c that checks whether (a, c, r) is a valid transcript. If the outcome is 1 meaning it only contains valid r, it measures the output registers and gets one valid r. Otherwise, A does not find a valid r. 
Let us consider algorithm A′ = (A′0,A′1) where A′0 keeps the same as what A0 does and A′1 is almost the same as A1 but A′1 after applying Pa,c, does not measure r on computational basis. In other words, A′(pk) starts with 
∑ a,s αa,s|a, s〉 and measures the commitment registers to get a and |φa〉 = 
∑ s αa,s|s〉 
(normalized); A′1 then gets a random c and applies Vc on |φa〉; finally it applies a projector Pa,c on it and checks whether the outcome is 1 meaning the superposition contains only valid r. Finally A′1 does not measure on r registers but just outputs the superposition after the projective measurement Pa,c. 
Moreover, we define the following adversary B′ (to keep the notation consistent with A′) that does rewinding on A′: 
– B′ starts with A′0(pk), the state is ∑ 
a,s αa,s|a, s〉, – B′ applies A′0: it measures the commitment register and gets a, the remaining registers are |φa〉 =∑ 
s αa,s|s〉 normalized, 
20
– Given random c1, B′ runs A′1(pk, c1, |φa〉). In other words, it applies Vc1 to |φa〉 and measures Pa,c1 . If the measurement passes, it applies V −1c1 . Let |φ′a〉 = V −1c1 Pa,c1Vc1 |φa〉 (normalized). 
– Given another random c2, B′ runs A′1(pk, c2, |φ′a〉). In other words, it applies Vc2 to |φ′a〉 and measures Pa,c2 . If the measurement passes, it applies V −1c2 . 
If B′ with non-negligible probability passes both measurements, and we can somehow (will show it later) modify B′ such that it extracts valid r for both c1, c2, B′ can break the 2-soundness of this sigma protocol. 
Now we need the following lemma from [Unr12] to bound the probability of a successful rewinding, 
Lemma 4 ([Unr12] Lemma 7). Let C be a set of size |C|. Let {Pi}i∈C be a set of orthogonal projectors on a Hilbert space H. Let |φ〉 ∈ H be a unit vector. Let ε = 
∑ i∈C 
1 |C|‖Pi|φ〉‖2 and δ = 
∑ i,j 
1 |C|2 ‖PiPj |φ〉‖2. 
We have δ ≥ ε3. In this algorithm, we can think C = {0, 1}λ contains all possible c received by A′0. Fixing a, we have 
P a c = V −1c Pa,cVc which is a set of orthogonal projectors and |φ〉 = |φpka 〉 in the algorithm when pk is given. 
Moreover, by assumption, A breaks the ID soundness with probability at least ε(λ), in other words, let εpka be the probability that Vc|φpka 〉 passes the measurement Pa,c conditioned on pk, a is chosen, and ppka be the probability that pk, a is chosen, we have 
∑ 
a,pk 
ppka ∑ 
c∈{0,1}λ 
1 
2λ ‖V −1c Pa,cVc|φpka 〉‖2 
= ∑ 
a,pk 
ppka ∑ 
c∈{0,1}λ 
1 
2λ ‖P a 
c |φpka 〉‖2 = ∑ 
a,pk 
ppka ε pk a (λ) > ε(λ) 
By applying lemma 4, we have the following inequality holds for all a, pk: 
∑ 
c1,c2∈{0,1}λ 
1 
22λ ∥∥V −1c2 Pa,c2Vc2 · V −1c1 Pa,c1Vc1 |φpka 〉 
∥∥2 ≥ εpka (λ)3 
Finally, the probability of both measurement of B′ gives 1 based on all randomness of B′ (including the measurement of a and the challenge c and the measurement Pa,c) is 
∑ a,pk p 
pk a ε 
pk a (λ)3. By Jensen’s inequality, 
we have 
∑ 
a,pk 
ppka ε pk a (λ)3 ≥ 
 ∑ 
a,pk 
ppka ε pk a (λ) 
  
3 
≥ ε(λ)3 
So B′ can successfully rewind it and succeed doing two independent measurements with probability at least ε(λ)3. 
Finally, by slightly modifying B′ to B, we will see B is a quantum polynomial time algorithm that produces (a, c, r) and (a, c′, r′) such that c 6= c′ with non-negligible. B is almost the same as B′ except that the first A′1 in B is changed to A1. 
We have the following lemma: 
Lemma 5. Pr[B succeeds] ≥ γ(λ) · Pr[B′ succeeds]− negl(λ) 
where ‘B′ succeeds’ means B′ does two consecutive measurements and gets two 1 as results. Besides, γ(·) is the parameter in the weakly collapsing property. 
Proof. Assume the above claim is not true. We have 
Pr[B succeeds] < γ(λ) · Pr[B′ succeeds]− negl(λ) 
Then there is a distinguisher D that breaks weakly collapsing property of this sigma protocol. Here is the distinguisher D: 
21
1. D runs A0(pk) and gets a, |φa〉, 2. D gets a random c from the challenger Ch, and runs A′1(pk, c, |φa〉). 3. After A′1 applies Vc, the state is 
|ψa,c〉 = Vc|φa〉 = ∑ 
r,s′ 
βr,s′ |r, s′〉 
D pauses A′ and gives |ψa,c〉 to the challenger. 
4. D will get |ψ′′a,c〉 from the challenger: if Ch’s coin is 0, the superposition is unchanged; otherwise the r registers get measured. 
5. D applies A′1 ( V −1c |ψ′′a,c〉 
) . 
6. If both measurements give 1, D outputs 1. 
So when the coin is 0, it is exactly B′; and it is B if the coin is 1. So we have D such that 
Pr [ CollapsingGame1D = 0 
] < γ(λ) · Pr 
[ CollapsingGame0D = 0 
] − negl(λ) 
which is a contradiction. ut 
Finally, B can replace the second A′1 to A1 with the same loss. We have B has non-negligible probability γ(λ)2 · ε(λ)3 − negl(λ) to rewind successfully. Because B applies A1, the output register is measured under computational basis so B can record the output r1, r2. So when c1 6= c2 and B rewinds correctly, it gets (a, c1, r1) and (a, c2, r2) which breaks the 2-soundness of this sigma protocol. ut 
Note that the construction of B only requires oracle access to A, which is helpful for the next proof. 
4.2 Quantum HVZKPoK 
Theorem 2. If a sigma protocol has (1) perfect completeness, (2) statistical/post-quantum computational HVZK, (3) worst case weakly collapsing property and (4) 2-extractability, it is a quantum HVZKPoK. In other words, it is a sigma protocol with (1) perfect completeness, (2) statistical/post-quantum computational HVZK and (3) (c, p, κ, negl)−validity form c = 3, polynomial p and negligible functions κ = 0, negl. 
The proof for Theorem 2 is almost identical to the proof in the last section. We just mention the idea of the proof here: 
– In the last proof (of proving ID soundness), B only uses A0,A1 as a quantum oracle. That is, B only need oracle access to Vc and V −1c for all possible c. 
So there is quantum polynomial time algorithm E, a constant c = 3, a polynomial p(·), and negligible functions κ = 0, negl(·), such that for any (quantum) malicious prover A = (A0,A1), for any x, 
Pr [ valid (a, c 6= c′, r)← EA(x)(x) 
] 
≥ 1 
p(λ) · ( Pr 
[ V.Ver(x, a, c, r) = 1 : 
(a,|φa〉)←A0(x) 
c $←{0,1}λ 
r←A1(x,|φa〉,c) 
])3 
− negl(λ) 
Because validity is a worst case statement, the proof requires worst case weakly collapsing. 
– Combining with 2-extractability, validity follows. That is, as long as an algorithm knows valid a, c, r and a, c′, r′ such that c 6= c′, it can apply the extractor in the 2-extractability definition and learn a witness. 
22
5 Construction of Collapsing Sigma Protocol 
5.1 Preliminaries 
Normal Distribution Here are some definitions and lemmas that are useful. We list them here. Most of the contents are from [Lyu12]. 
Definition 12. The continuous Normal distribution over R m centered at v with standard deviation σ is 
defined by the function ρmv,σ(x) = ( 
1√ 2πσ2 
)m e−‖x−v‖ 
2/2σ2 
. 
When v = 0, we just write ρmv,σ(x) as ρ m σ (x). The discrete Normal distribution over Zm is defined as follows, 
Definition 13. The discrete Normal distribution over Zm with standard deviation σ is defined as Dm v,σ(x) = 
ρmv,σ(x)/ρ m σ (Zm) where ρmσ (Zm) = 
∑ z∈Zm ρmσ (z) is a normalization that makes Dm 
σ (·) a probability distribution over Z 
m. 
Next, we need the following lemmas. 
Lemma 6. For any vector v ∈ R m and any σ, r > 0, 
Pr [ |〈z,v〉| ≤ r; z $← Dm 
σ 
] > 1− 2 · e−r2/(2‖v‖2σ2) 
Lemma 7. For any k > 1, Pr [ ‖z‖2 > kσ 
√ m; z 
$← Dm σ 
] < kme 
m 2 (1−k2). 
Lemma 8. For any v ∈ Z m, if σ = λ · ‖v‖ · 
√ logm ( λ > 1), then 
Pr [ Dm 
σ (z)/Dm v,σ(z) = O(1); z 
$← Dm σ 
] = 1− 2−ω(λ2 logm) 
Proof. By definition, we have 
Dm σ (z)/Dm 
v,σ(z) = exp 
(−2〈z,v〉+ ‖v‖2 2σ2 
) 
From lemma 6, we have |〈z,v〉| is smaller than λ‖v‖ √ logm · σ with probability at least 1 − 2−ω(λ2 logm). 
And in this case, we have 
Dm σ (z)/Dm 
v,σ(z) = exp 
(−2〈z,v〉+ ‖v‖2 2σ2 
) 
< exp 
(‖v‖2 2σ2 
+ λ √ logm‖v‖ σ 
) 
≤ exp 
( 1 
2λ2 logm + 1 
) = O(1) 
SIS problem 
Definition 14 (`2-SISq,n,m,β problem). Given a random matrix A $← Z 
n×m q , find a vector v ∈ Z 
m q such 
that A · v = 0 (mod q) and ‖v‖2 ≤ β. The following theorem says the problem is hard as long as GapSVPγ or SIVPγ is hard. This was firstly shown in [Ajt96]. 
Theorem 3. For any m = poly(n) and β > 0, and any sufficiently large q > βnc (for any constant c > 0), solving `2-SISq,n,m,β with non-negligible probability is as hard as solving GapSVPγ or SIVPγ from some γ = β ·O( 
√ n) with a high probability in a worst case scenario. 
23
LWE problem 
Definition 15 (LWEq,Dq,αq ). The learning with errors problem LWEq,Dq,αq 
is to find a secret vector s $← Z 
n q , 
given polynomially many samples of the following form 
(ai, 〈ai, s〉+ ei) ai $← Z 
n q , ei 
$← Dq,αq 
where Dq,αq is discrete Normal distribution over Zq with standard deviation αq. 
Definition 16 (DLWEq,Dq,αq ). The decisional learning with errors problem DLWEq,Dq,αq 
is to distinguish between the two cases, given polynomially many samples of the following form 
(ai, 〈ai, s〉+ ei) ai $← Z 
n q , ei 
$← Dq,αq 
where s $← Z 
n q or given the following samples: 
(ai,bi) ai $← Z 
n q ,bi 
$← Zq 
From [Reg09], the quantum security of LWE can be based on the following theorem: 
Theorem 4 (Informal). Let n,p be integers and α ∈ (0, 1)be such that αp > 2 √ n. If there exists an 
efficient algorithm that solves LWEq,Ψα then there exists an efficient quantum algorithm that approximates 
the decision version of the shortest vector problem (GapSVP) and the shortest independent vectors problem (SIVP) to within Õ(n/α) in the worst case. 
5.2 Construction 
The following protocol is from [Lyu12]. Although in the paper, Lyubashevsky only shows a digital signature scheme, it follows the framework of Fiat-Shamir. We extract the following sigma protocol from the digital signature. We will re-prove it is a quantum secure sigma protocol (which is already shown to be secure as a signature scheme in [Lyu12]) and then show it has compatible lossy/separable functions. 
– Gen(1λ): A $← Z 
n×m q and S 
$← {−d, · · · , d}m×k and let pk = (A,T = AS) and sk = (A,S). 
– Commitment Stage: P given sk, y $← Dm 
σ and a = Ay. It sends a to the verifier V. – Challenge Stage: V randomly samples c 
$← {−1, 0, 1}k satisfying ‖c‖1 ≤ κ and sends c to P. – Response Stage: P after getting c, r = Sc + y and sends y with probability pr(c, r). Otherwise, it 
sends ⊥. pr(c, r) = min 
{ Dm 
σ (r) 
M ·Dm Sc,σ(r) 
, 1 
} 
– Verification Stage: V outputs 1 if Ar = Tc+ a and ‖r‖2 ≤ ησ √ m. 
Remark: We note that the protocol only satisfies a weak completeness requirement, where the honest prover succeeds with non-negligible probability. 
The challenge stage looks different from a challenge stage defined by a sigma protocol. But indeed, we can think of it as choosing a random bit string and mapping it to a vector c that c ∈ {−1, 0, 1}k and ‖c‖1 ≤ κ. 
The parameters are chosen in the following way (as Section 5 in [Lyu12]): 
– m = 64 + n · log q log(2d+1) to make sure 2d+ 1 ≈ qn/m where both n,m are polynomial of λ. 
– d is a constant, for example 1. – ∣∣{c|c ∈ {−1, 0, 1}k, ‖c‖1 ≤ κ} 
∣∣ > 2λ, in other words, the range of the random oracle is of size about 2λ. – σ = λ′ 
√ logm · d · κ√m is a polynomial of λ, in other words, λ′ is a polynomial of λ. 
– Some constant η and M . – We will set the prime q according to the proof in compatible lossy functions/separable functions, which 
is also a polynomial of λ. This can be found in the theorems statements. 
24
5.3 [Lyu12] construction is a secure quantum sigma protocol 
Combining with lemma 8, we have the following theorem (Theorem 4.6 and Lemma 4.7) from [Lyu12] (this is a slightly different version): 
Theorem 5. Let V be a subset of Zm in which all elements have norms less than T , σ be some element in R such that σ = λ′T 
√ logm, and h : V → R be a probability distribution. Then there exists a constant 
M = O(1) such that the distribution of the following algorithm A: 
1. v $← h, 
2. z $← Dm 
v,σ, 
3. output (z,v) with probability min ( 
Dm σ (z) 
M ·Dm v,σ(z) 
, 1 ) . 
is within statistical distance 2−ω(λ′2 logm)/M of the distribution of the following algorithm F : 
1. v $← h, 
2. z $← Dm 
σ , 3. output (z,v) with probability 1/M . 
From the above theorem, because ‖Sc‖2 ≤ dκ √ m and σ = λ′ 
√ logm · κd√m, we have 
Corollary 1. Let V = {Sc | c $← {−1, 0, 1}k, ‖c‖1 ≤ κ} (where S ∈ {−d,−d+1, · · · , d−1, d}m×k and S has full rank) be a subset of Zm in which all elements have norms less than T = dκ 
√ m, σ be some element in 
R such that σ = λ′T √ logm, and h : V → R be a probability distribution (defined below). Then there exists 
a constant M = O(1) such that the distribution of the following algorithm A: 
1. v $← h, in other words, draw c 
$← {−1, 0, 1}k and ‖c‖1 ≤ κ and let v = Sc. 
2. r $← Dm 
v,σ, 
3. output (c, r) with probability min ( 
Dm σ (r) 
M ·Dm v,σ(r) 
, 1 ) . 
is within statistical distance 2−ω(λ′2 logm)/M of the distribution of the following algorithm F : 
1. c $← {−1, 0, 1}k and ‖c‖1 = κ, 
2. r $← Dm 
σ , 3. output (c, r) with probability 1/M . 
The above corollary directly comes from Theorem 5. The only difference requires both A and F output (Sc, r) instead of (c, r). However, with the right choice of parameters, there will be an one-to-one mapping (with overwhelming probability) between c and Sc so the statistical distance is not increased when S has full rank. So we can define Goodλ = {(A,S, T ) |S has full rank}. For example, when m > k log p, Pr[(A,S, T ) ∈ Goodλ] is overwhelming. 
The corollary says, the transcripts of honest P and V are statistically close to the case where r is completely independent from S or c. 
Lemma 9 (HVZK). The above protocol is statistical HVZK. 
Proof. First, for all (A,S, T ) ∈ Goodλ, honest transcripts sampled according to probability pr(c, r) = 
min ( 
Dm σ (r) 
MDm v,σ(r) 
, 1 ) is statistically close (with distance 2−ω(λ′2 logm)) to the following, from Corollary 1: 
1. Given pk = (A,T = AS), 
2. c $← {v ∈ {−1, 0, 1}k, ‖v‖1 ≤ κ}, 
3. r $← Dm 
σ , 
25
4. a $← Ar−Tc, 
5. Outputs (a, c, r) with probability 1/M . Otherwise, it outputs (a, c,⊥). 
And the above procedure does not require the knowledge of a secret key. ut 
Lemma 10 (Completeness). The above protocol has weak completeness. 
Proof. For all (A,S, T ) ∈ Goodλ, honest transcripts sampled are statistically close (with distance 2−ω(λ′2 logm)) to the following, from Corollary 1: 
1. Given pk = (A,T = AS), 
2. c $← {v ∈ {−1, 0, 1}k, ‖v‖1 ≤ κ}, 
3. r $← Dm 
σ , 
4. a $← Ar−Tc, 
5. Outputs (a, c, r) with probability 1/M . Otherwise, it outputs (a, c,⊥). 
First, (a, c, r) is valid with probability at least 1/M − 2−ω(λ′2 logm). And because r $← Dm 
σ , from Lemma 7, ‖r‖2 ≤ ησ 
√ m with overwhelming probability. So with constant probability, it is correct. ut 
Lemma 11 (Unpredictable Commitment). The above protocol has unpredictable commitment. 
Proof. 
Pr A,r1,r2 
[A · (r1 − r2) = 0] = Pr A,r 
[A · r = 0] 
≤ Pr A,r 
[r = 0m] + Pr A,r 
[A · r = 0|r 6= 0m] = 1 
qn + 
1 
qm 
ut 
Next let us look at 2-soundness. 
Lemma 12 (2-Soundness). The above protocol has 2-soundness. 
Proof. If a quantum algorithm A finds valid pairs a, c, r and a, c′, r′ such that c 6= c′, we have 
‖r− Sc− r′ + Sc′‖ ≤ ‖r‖+ ‖r′‖+ ‖Sc‖+ ‖Sc′‖ ≤ (2κd+ 2ησ) √ m 
and with overwhelming probability it is non-zero. Besides, a = Ar−Tc = A(r− Sc) = A(r′ − Sc′). So we can construct a quantum algorithm B that generates an instance of sigma protocol (allowing itself to know the secret key S), uses A as a subroutine and breaks the average hardness of SIS problem. ut 
5.4 Collapsing 
Next let us prove it is weakly collapsing. Theorem 6 directly follows from Theorem 8 or Theorem 7. 
Theorem 6. The sigma protocol constructed above is weakly collapsing. 
26
Compatible Lossy Functions 
Theorem 7. There exists (1, 1/3)-compatible lossy function CLF.Gen, for any λ, pk = (A,T), sk = (A,S),a, c, 
Fconstant = 
{ f : f(r) = [(CA+E)r+ z]t , 
for C $← Z 
l×n q ,E = 
  E1 
... El 
  ,Ei 
$← Dm q,αq, z 
$← Z l q 
} 
Finjective = { f : f(r) = [Br+ z]t , for B 
$← Z l×m q , z 
$← Z l q 
} 
where [x]t is a function that rounds x to the nearest multiple of t, t = q/4, αq > 2 √ n, l = t/(2∆) = q/(8∆), 
∆ = (ησ √ m) · (αq) · 2√m and q is the polynomial of λ such that l = q/(8∆) = Ω(m logm). 
Lemma 13. For every pk = (A,T), sk = (A,S),a, c, choosing f ← Fconstant, f is a constant function with non-negligible probability. 
Proof. The proof contains several hybrids, each hybrid describes a set of functions with a non-negligible fraction being constant functions. 
– Hyb 0. In this hybrid, a function is chosen from F0 = {f : f(r) = Ar}. Because for any A,S,T = AS,a, c, all valid r satisfying Ar = Tc+ a. So with probability 1, it is a constant function. 
– Hyb 1. In this hybrid, a function draw from F1: 
F1 = {f : f(r) = C ·Ar+ z, for C $← Z 
l×n q , z 
$← Z l q} 
When l ≥ 2n, C has full rank (which is n) with probability 1−O(q−n). So we have with probability at least 1−O(q−n), a chosen function f is constant. 
– Hyb 2. In this hybrid, the challenger applies a function from F2, 
F2 = {f : f(r) = [C ·Ar+ z]t, for C $← Z 
l×n q , z 
$← Z l q} 
The following lemma and corollary hold for any z, so we only prove it for z = 0. 
Lemma 14. For fixed ∆ 6= 0n and random v $← Z 
1×n q , the probability that there exists some x ∈ Z 
n q , 
[v · x]t = [v · (x+∆)]t is at most (2t+ 1)/q. 
Proof. When v ·∆ is in the range [t, q − t], [vx]t is different from [v(x+∆)]t. We have 
Pr v [∃x, [vx]t = [v(x+∆)]t] = 1− Pr 
v [∀x, [vx]t 6= [v(x+∆)]t] 
≤ 1− Pr v [v ·∆ ∈ [t, q − t]] 
= 1− q − 2t− 1 
q = 
2t+ 1 
q 
Pr[v ·∆ ∈ [t, q − t]] = q−2t−1 q holds by assuming q is a prime. 
Corollary 2. For any fixed ∆ 6= 0n, 
Pr C 
$←Z l×n q 
[∃x, [Cx]t = [C(x+∆)]t] ≤ ( 2t+ 1 
q 
)l 
27
Lemma 15. 
Pr C 
$←Z l×n q 
[∀∆ 6= 0n, ∀x, [Cx]t 6= [C(x+∆)]t] > 1− qn ( 2t+ 1 
q 
)l 
Proof. It follows from union bound. ut 
If t = q/4, q = poly(n) and l ≥ Ω(n log n), the probability is at least 1 − O(2−n). So with probability 1−O(q−n), [Cx]t is an injective function of x. Moreover, it holds for [Cx+ z]t for all z. 
– Hyb 3. In this hybrid, a function is drawn from F3 = Fconstant, 
F3 = 
   f : f(r) = [CAr+Er+ z]t,C 
$← Z l×n q ,E = 
  E1 
... El 
  ,Ei ← Dm 
q,αq, z $← Z 
l q 
   
We have the following corollary that bounds the inner product of Ei and r from lemma 6, 
Corollary 3. For any r ∈ R m, ‖r‖ ≤ ησ√m, we have 
Pr [ |〈Ei, r〉| > ∆ ; Ei ← Dm 
q,αq 
] ≤ 2e 
− ∆2 
2(ησ √ 
m)2(αq)2 
By letting ∆ = (ησ √ m)(αq) · 2√m, we have the above probability is bounded by 2e−m. 
And we have the following corollary, 
Corollary 4. If E1,E2, · · · ,El ← Dm q,αq, 
Pr [ ∀‖r‖ ≤ ησ 
√ m, ∀i, |〈Ei, r〉| ≤ ∆ 
] ≥ 1− 2l · e−m 
Let Safe = ∪i[i · t − t/2 + ∆, i · t + t/2 − ∆]. Intuitively, if x ∈ Safe, with a noise e of norm at most |e| ≤ ∆, [x]t is the same as [x+ e]t. 
Lemma 16. For random C $← Z 
l×n q and z 
$← Z l q, all entries of CAr + z fall into Safe with probability 
(1− 2∆/t)l. 
Proof. Each entry of CAr + z is uniformly at random. So each entry is not in Safe with probability at most 2∆ 
t . So the overall probability is at most (1− 2∆/t)l. ut 
When l = t/(2∆), the probability is at least 1/3. So we have, 
Pr f←Fconstant 
[f is constant] ≥ 1 
3 ut 
Lemma 17. For every pk = (A,T), sk = (A,S),a, c, choosing f ← Finjective, f is an injective function with overwhelming probability. 
Proof. The proof contains several hybrids, each hybrid describes a set of functions 
– Hyb 0. In this hybrid, a function f is chosen from F0, where 
F0 = { f : f(r) = Br+ z,B 
$← Z l×m q , z 
$← Z l q 
} 
When l ≥ 2m, Br+ z is an injective function with probability 1−O(q−m). 
28
– Hyb 1. In this hybrid, a function f is chosen from F1 = Finjective, where 
F1 = { f : f(r) = [Br+ z]t,B 
$← Z l×m q , z 
$← Z l q 
} 
Similar to Hyb 2 in the previous proof, we have the following claim: if t = q/4, q = poly(n) and l ≥ Ω(m logm), with probability 1 − O(q−m), [Cx]t is an injective function of x ∈ Z 
m q . Moreover, it 
holds for [Cx+ z]t for all z. ut 
Lemma 18. There exists a negligible function negl for every λ, for any polynomial time quantum distinguisher D, taken the randomness of (pk, sk)← Gen(1λ), 
∣∣Pr [ LFGame0D,pk,sk = 0 
] − Pr 
[ LFGame1D,pk,sk = 0 
]∣∣ ≤ negl(λ) 
where the game is defined the compatible lossy function CLF.Gen. 
Proof. First, it is easy to see that Finjective and Fconstant is independent with a, c but only dependent with A. So the game can be simplified as distinguishing the following two cases, 
– Case 1. B where B $← Z 
l×m q , 
– Case 2. CA+E where C $← Z 
l×n q ,E = 
  E1 
... El 
  ,Ei ← Dm 
αq. 
They are exactly l parallel DLWE instances. By l hybrids, the advantage is bounded by l · advLWE(λ) which is negligible (because l is a polynomial of λ). ut 
Compatible Separable Functions 
Theorem 8. There exists (τ, β)-compatible separable function CSF.Gen where τ(λ) = 0.499 and β(λ) = 1/q(λ)2, for any λ, pk = (A,T), sk = (A,S),a, c, 
Fp = { f : f(r) = [(uA+ e) · r+ z][q/2],u 
$← Z n q , e 
$← Dm q,αq, z 
$← Zq 
} 
Fs = { f : f(r) = [v · r+ z][q/2],v 
$← Z m q , z 
$← Zq 
} 
where [x][q/2] rounds x/[q/2] to the nearest integer (0 or 1), αq > 2 √ n, ∆ = (ησ 
√ m) · (αq) · 2√m = q/8. In 
which case, q = 32ησm √ n is a polynomial of λ. 
Proof. Preserving: First, let us show that for any λ, pk, sk, a, c, the corresponding Fp has many constant functions. 
Because we say r is valid if and only if Ar = Tc+ a and r is short. For any function f $← Fp, we have 
f(r) = [(uA+ e) · r+ z][q/2] = [uAr+ er+ z][q/2] 
where uAr+ z = uA(Tc+ a) + z is constant regardless of the input r and with the random choice of z, its value is uniformly at random in Zq. 
We have the following corollary that bounds the inner product of e and r from lemma 6, 
Corollary 5. For any r ∈ R m, ‖r‖ ≤ ησ√m, we have 
Pr [ |〈e, r〉| > ∆ ; e← Dm 
q,αq 
] ≤ 2e 
− ∆2 
2(ησ √ 
m)2(αq)2 
By letting ∆ = (ησ √ m)(αq) · 2√m, we have the above probability is bounded by 2e−m. 
29
By setting ∆ = q/8, in which case αq = q 16·ησm , we know that 
1. uAr+ z falls into [∆, [q/2]−∆] or [[q/2] +∆, q −∆] with probability ≥ 1/2, 
2. Draw e $← Dm 
q,αq, for all valid r, with overwhelming probability, |〈e, r〉| ≤ ∆. 
So τ(λ) = Prf←Fp [|Im(f)| = 1] > 1 
2 − negl(λ) > 0.499. 
0 Separating: Second, let us show that there exists a β(·) such that for any λ, pk, sk,a, c, for any pair 
of valid r 6= r′, f(r) and f(r′) will be mapped to the same bits with the same probability 1+α(λ) 2 where 
β(λ) = α(λ) = 1 q2 . 
Fixing r 6= r′, let us consider the distribution of (vr+ z,vr′+ z) for random chosen v, z. Given a random chosen v, the difference vr−vr′ is uniformly at random. And given the random choice of z, (vr+ z,vr′+ z) is a uniformly random element in Zq × Zq. Therefore we have 
Pr f←Fs 
[f(r) = f(r′)] = 1− 2 · ([q/2] + 1) · [q/2] q2 
= 1 + α(λ) 
2 where α(λ) = 
1 
q2 
It also satisfies that τ − β is non-negligible. 
Indistinguishability: A distinguisher is given either (uA+e, z) or (v, z). It corresponds to an instance of DLWE. Based on the quantum security of DLWE, indistinguishability holds. ut 
6 Compressed Oracles 
In [Zha18], Zhandry showed a new proof technique to analyze random oracles [2N ] → [2N ] under quantum query access. The technique allows a simulator, given a random oracle machine making polynomial number of queries, to simulate a quantum random oracle efficiently. The full details can be found in Appendix A, and we sketch the details here: 
1. Compressed Fourier Oracles: Assume a simulator B is simulating a quantum random oracle for A. The simulator B maintains a superposition over databases of pairs D = {(xi, ui)} (here we always assume a database is sorted according to xi). At the beginning, B only has |D0〉 which is a pure state over an empty database D0. We will think of the database as being the specification for a function, where (xi, ui) ∈ D means xi 7→ ui, whereas if x is not present in the database, then x 7→ 0. Define D(x) = ⊥ if x is not in the database and D(x) = ui if there is a pair (xi, ui) such that x = xi. We then define the following operation ⊕ for a database D and a pair (x, u). Intuitively, thinking of D as the encoding of a function, it will XOR u into the image of x. More precisely, (1) if u = 0, D ⊕ (x, u) = D, (2) else if D(x) = ⊥, D ⊕ (x, u) = D ∪ {(x, u)}, (3) else if D(x) = ui and u + ui ≡ 0 (mod 2N ), D ⊕ (x, u) = D \ {(x, ui)} and (4) otherwise, D ⊕ (x, u) = (D \ {(x, ui)}) ∪ {(x, ui + u)}. So we start with 
∑ x,u a 
0 x,u|x, u〉 ⊗ |D0〉 where D0 is empty. After making the i-th query, we have 
CFourierO ∑ 
x,u,D 
ai−1x,u,D|x, u〉 ⊗ |D〉 ⇒ ∑ 
x,u,D 
ai−1x,u,D|x, u〉 ⊗ |D ⊕ (x, u)〉 
One observation is when the algorithmA only makes q queries, any database in the superposition contains at most q non-zero entries. So B can efficiently simulate quantum random oracle. And Zhandry shows the density matrices of A given B or a true quantum random oracle are identical. 
2. Compressed Phase Oracles: By applying the QFT on the database of a compressed Fourier oracle, we get a compressed phase oracle. In this model, a database contains all the pairs (xi, ui) which means the oracle outputs ui on xi and uniformly at random on other inputs. We can also define D(x) = ⊥ if x is not in the database and D(x) = ui if there is a pair (xi, ui) such that x = xi. When making a query on |x, u,D〉, – If (x, u′) is in the database D for some u′, a phase ωuu′ 
N (where ωN = e2πi/2 N 
) will be added to the state; it corresponds to update u′ to u′ + u in the compressed Fourier oracle model; 
30
– Otherwise a superposition is appended to the state |x〉 ⊗∑u′ ωuu′ 
N |u′〉; it corresponds to put a new pair (x, u′) in the list in the compressed Fourier oracle model; 
– Also make sure that the list will never have a (x, 0) pair in the compressed Fourier oracle model (by doing a QFT and see if the register is 0); if there is one, delete that pair; 
– all the ‘append’ and ‘delete’ operations above means doing QFT on |0〉 or a uniform superposition. 
Intuitively, it is identical to a compressed Fourier oracle. You can image QFT is automatically applied to every entry of the compressed Fourier database and converts it to a compressed phase oracle. 
In this paper, we introduce two more quantum oracle variations. These variations can be based on both compressed Fourier oracles and compressed phase oracles. Here we only introduce the first case. The second one is straightforward. 
– The first variation is almost compressed Fourier oracles, which is based on compressed Fourier oracles. For most points, we simulate using the compressed Fourier oracle. However, for a small set of points, we just keep them as a (uncompressed) phase oracle. Formally, let x∗ be an element in the domain of the random oracle O : X → Y . The database D contains only the (x, u) pairs for x 6= x∗, the whole system can be written as the following, at the beginning of the computation, D0 is an empty list: 
∑ 
x,u 
αx,u|x, u〉 ⊗ ( |D0〉 ⊗ 
∑ 
r 
|r〉 ) 
By making a quantum query, the simulator does the follows: 
 If the query is (x, u) and x 6= x∗, the simulator updates D as what it does in the compressed Fourier oracle setting; 
 If the query is on the special point (x∗, u), the second part of the oracle is updated as a phase oracle: 
αx∗,u,D,u′ |x∗, u〉 ⊗ |D〉 ⊗ ∑ 
r 
ωu′r N |r〉 
⇒αx∗,u,D,u′ |x∗, u〉 ⊗ |D〉 ⊗ ∑ 
r 
ω (u′+u)r N |r〉 
In other words, we only apply QFT on most of the domain but x∗. This random oracle model can be extended to the case where we exclude a polynomial numbe of special points from D. As long as the number is polynomial, it can be efficiently simulated. 
– The second one is inspired from our technique of extracting information from quantum oracle queries in the next section. Assume before the i-th query, the database does not have x∗, in other words, for any D containing x∗ and arbitrary x, u, z, αx,u,z,D = 0. The superposition is 
∑ 
x,u,z,D D(x∗)=⊥ 
αx,u,z,D|x, u, z,D〉 
Then we can switch random oracle models between the i-th query: before the i-th query, we simulate a random oracle as a compressed Fourier oracle, and right before the i-th query, we switch to almost compressed Fourier random oracle. We call i is the switch stage. Because before the i-th query, every database D with non-zero weight does not contain x∗, we can simply append 
∑ r |r〉 to the superposition. 
So the superposition now becomes 
∑ 
x,u,z,D D(x∗)=⊥ 
αx,u,z,D|x, u, z,D〉 ⊗ ∑ 
r 
|r〉 
31
7 Extracting Information From Quantum Oracle Queries 
We first describe a technique for extracting the adversary’s query, without perturbing its behavior too much. The setting is the following. The adversary makes some number of oracle queries (let us say q) to a random oracle, implemented as a compressed Fourier oracle. At the end of the interaction, we measure the entire state of the adversary and oracle, obtaining (w,D), where w is some string that we will call a witness. We will only be interested in the case where D is non-empty. Let γw,D denote the probability of obtaining w,D. 
We now consider the following experiment on the adversary. We run the adversary as above, but we pick a random query i ∈ [q] or a random triple i < j < k ∈ [q] with equal probability. That is, we pick a random i with probability 1/(q+ 
( q 3 
) ) or pick a random triple i, j, k with probability 1/(q+ 
( q 3 
) ). Then we do Expi or 
Expi,j,k as follows: 
1. Expi: Before making the i-th query, we measure the query register to get x∗ and check if the database D does not have x∗ before the i-th query and has x∗ right after the i-th query. In other words, before measuring query register, let us assume the state is 
∑ 
x,u,z,D 
αx,u,z,D |x, u, z,D〉 
Conditioned on the measurement gives x∗, the state becomes 
∑ 
u,z,D 
αx∗,u,z,D |x∗, u, z,D〉 
If the database D does not have x∗ before the i-th query and has x∗ right after the i-th query, it means (1) all D does not contain x∗, (2) u 6= 0 so that after the i-th query, all D will contain x∗. So if the check passes, the state becomes ∑ 
u 6=0,z,D:D(x∗)=⊥ αx∗,u,z,D |x∗, u, z,D〉 
And then we do not care whether D contains x∗ for all the remaining oracle queries and computation. If it does not satisfy any condition, we abort. We know that after the measurement, the superposition contains all D that does not contain x∗. We can switch to almost compressed Fourier oracle with the special point x∗. 
2. Expi,j,k: We measure the query register to get x∗ before making the i-th query. And we check the following (on superposition) that – D does not have x∗ before the i-th query, – D always has x∗ after the i-th query and before the j-th query, – D does not have x∗ after the j-th query and before the k-th query, – D has x∗ right after the k-th query. (But we do not care whether D contains x∗ for the remaining 
oracle queries and computation.) 
If the check does not pass, we abort. Just right before the k-th query, we switch to almost compressed Fourier oracles with the special point x∗. 
Let γi,x∗,w,D be the probability that conditioned on we are in Expi, the measurement gives x∗ and the final output is w,D. Let γi,j,k,x∗,w,D be the probability that conditioned on we are in Expi,j,k, the measurement gives x∗ and the final output is w,D. We have the following lemma: 
Theorem 9. For any w,D, for any x such that D(x) 6= ⊥, there are at least one i or one tuple i < j < k such that γi,x,w,D ≥ γw,D/(q + 
( q 3 
) )2 or γi,j,k,x,w,D ≥ γw,D/(q + 
( q 3 
) )2. 
Proof. Let ∑ 
x,y,z αx,y,z|x, y, z〉 be the state of the adversary just before the first query, and let U (i) x,y,z,x′,y′,z′ 
be the transition function after the i-th query. For vectors x,y, z and w, let 
αx,y,z,w = αx1,y1,z1U (1) x1,y1,z1,x2,y2,z2 · · ·U 
(q) xq,yq,zq,w 
32
Then we can write the final joint state of the adversary and oracle as: 
∑ 
x,y,z,w 
αx,y,z,w|w〉 ⊗ ∣∣∣∣∣ 
q⊕ 
i=1 
(xi, yi) 
〉 
For any D, define the following sets SD: it contains all the vector x,y pairs such that ⊕q 
i=1(xi, yi) = D. Thus we have γw,D = |γ′w,D|2 where 
γ′w,D = ∑ 
(x,y)∈SD,z 
αx,y,z,w 
Next consider any x such that D(x) 6= ⊥, we can define the following sets: 
– SD,i: it contains all the vector x,y such that 1. The fixed x is not in the database defined by ⊕i−1 
j=1(xi, yi), 2. xi = x and yi 6= 0. In other words, x is not in the database before the i-th query and appears in the database right after i-th query. We can define γ′i,x,w,D = 
∑ (x,y)∈SD,i,z 
αx,y,z,w. Similarly we have γi,x,w,D = |γ′i,x,w,D|2. – SD,i,j,k: it contains all the vector x,y such that 
1. x is not in the database before the i-th query, 2. x is in the database after the i-th query and before the j-th query, 3. x is not in the database after the j-th query and before the k-th query, 4. x appears in the database right after the k-th query. We can define γ′i,j,k,x,w,D = 
∑ (x,y)∈SD,i,j,k,z 
αx,y,z,w. Similarly we have γi,j,k,x,w,D = |γ′i,j,k,x,w,D|2. 
Then we have the following lemma: 
Lemma 19. For any w,D and any x such that D(x) 6= ⊥, we have 
∑ 
i 
γ′i,x,w,D − ∑ 
i<j<k 
γ′i,j,k,x,w,D = γ′w,D 
Given the lemma above, we can argue that there exists some i or some triple i < j < k such that either |γ′i,x,w,D| ≥ |γw,D|/(q + 
( q 3 
) ) or |γ′i,j,k,x,w,D| ≥ |γw,D|/(q + 
( q 3 
) ) by triangle inequality. Combining with 
γi,x,w,D = |γ′i,x,w,D|2 and γi,j,k,x,w,D = |γ′i,j,k,x,w,D|2, we complete the proof of our theorem. The only thing we need to prove is lemma 19. 
Proof. Consider every (x,y) ∈ SD and z, consider the database defined by these vectors. Assume x is inserted t times into the database. On the left side, αx,y,z,w,D will appear in 
∑ i γ ′ i,x,w,D exactly t times and 
appear in the second term ∑ 
i<j<k γ ′ i,j,k,x,w,D exactly t − 1 times. On the right side, it appears only once. 
Every αx,y,z,w,D appears exactly once on both side. So the left side is equal to the right side. ut We finish our proof for the theorem 9. ut 
And we notice that if A makes measurement during computation, the theorem also holds. And all the theorems and corollary below apply to the case where the algorithm can make measurement during computation. This proof and all proofs for the theorems below are in Appendix B. 
Theorem 10. For any w, compressed Fourier database D and any x such that D(x) 6= ⊥, let τx,w,D be the probability that in the above extracting experiment (that is to randomly pick Expi or Expi,j,k), the measurement 
gives x and the output is w,D, we have τx,w,D ≥ 1 
(q+(q3))3 · γw,D. 
Proof. It follows directly from theorem 9. Because we have probability 1 
q+(q3) to stay in the experiment 
that maximize the probability of getting x and outputting w,D, the total probability is at least τx,w,D ≥ 1 
(q+(q3))3 · γw,D. ut 
33
Theorem 10 can be generalized to the setting where D is a compressed phase database, i.e, applying QFT on compressed Fourier database. 
Corollary 6. Define a set S contains pairs of w and compressed phase database D. Define a measurement, P0 = 
∑ (w,D)∈S |w,D〉〈w,D|, P1 = I − P0. 
Let τ be the probability that in the extracting experiment, the extraction gives some xw,D in the database D for a given pair (w,D) and the final measurement is 0. Let γ be the probability that in the normal game, the final measurement is 0. q is the total number of oracle queries made. We have τ ≥ 1 
(q+(q3))3 · γ. 
8 Programming Quantum Random Oracles 
Lemma 20. Assume an adversary A is interacting with an almost compressed phase oracle whose the switch stage is i and the special point is x∗. Wlog, assume the random oracle maps {0, 1}N → {0, 1}N . Instead of appending 
∑ r |r〉 before the i-th query, the simulator chooses a random r and appends |r〉 to the whole 
superposition. Then the adversary and the simulator keeps running. Finally the simulator measures the output registers. 
Let γr,w,D be the probability that the output is w,D ∪ {(x∗, r)} in the normal game (where D does not contain x∗) and γ′r,w,D be the probability that the output is w,D ∪ {(x∗, r)} in the modified game with |r〉 is appended. We have 
1 
2N γ′r,w,D = γr,w,D 
where D is a compressed phase database. 
In other words, if we choose r uniformly at random, the probability of getting certain output does not change at all even if we program the oracle at x∗ to output r. The lemma also holds if the almost compressed phase oracle has several special points and applies the technique to all the special points. The proof directly follows the proof for a single special point. 
Proof. The theorem holds even if A allows to make measurements during computation. The following proof only shows the case where A just applies unitary transformation. The generalized proof is straightforward. 
First, it is easy to see that even if we program the oracle at x∗ to output r by appending |r〉, the updating operation of the simulated oracle still make sense. If the query is not x∗, we update the compressed phase oracle. Otherwise, we just put a phase ωy·r 
N on the overall state. Let the state before the i-th query be 
∑ x,y,z,D 
D(x∗)=⊥ αx,y,z,D|x, y, z,D〉. After we switch to almost compressed 
phase oracle, the state becomes 
∑ 
x,y,z,D D(x∗)=⊥ 
αx,y,z,D|x, y, z,D〉 ⊗ ∑ 
r 
1√ 2N |r〉 
= ∑ 
r 
1√ 2N 
∑ 
x,y,z,D D(x∗)=⊥ 
αx,y,z,D ⊗ |x, y, z,D, r〉 
It is easy to see that the state in the normal experiment is a linear combination of all the states in the modified experiment. 
Let |φi〉 be the superposition of the whole system in the normal experiment before the i-th query and |φr,i〉 be the superposition of the whole system in the modified experiment with randomness r before the i-th query. We rewrite the above equation as |φi〉 = 1√ 
2N 
∑ r |φr,i〉. 
And if A applies a unitary on its side, it does not change the relation. If A makes an oracle query, 
– On the left side, for any x, y, z,D and y′, |x, y, z,D〉 ⊗ ∑ 
r ω ry′ 
N |r〉 becomes |x, y, z,D〉 ⊗ ∑ 
r ω (y′+y)r N |r〉. 
34
– On the right side, for every r and every x, y, z,D, y′, |x, y, z,D〉⊗ωy′r N |r〉 becomes |x, y, z,D〉⊗ω(y′+y)r 
N |r〉. So the equation holds even if A makes an oracle query. So we have for all j ≥ i, |φj〉 = 1√ 
2N 
∑ r |φr,j〉. 
Moreover, the final state satisfies |φq+1〉 = 1√ 2N 
∑ r |φr,q+1〉. 
If we measure the whole superposition under w,D ∪ {(x∗, r)}, we have the conclusion. ut 
Corollary 7. Assume an adversary A is interacting with an almost compressed phase oracle whose the switch stage is i and the special point is x∗. Wlog, assume the random oracle maps {0, 1}N → {0, 1}N . Instead of appending 
∑ r |r〉 before the i-th query, the simulator chooses a random r and appends |r〉 to the 
whole superposition. Then the adversary and the simulator keeps running. Finally the simulator measures the output registers. 
Let S be a set of w and compressed phase database D ∪ {(x∗, r)}. Define a measurement P0, P1, 
P0 = ∑ 
(w,D∪{(x∗,r)})∈S |w,D ∪ {(x∗, r)}〉〈w,D ∪ {(x∗, r)}| P1 = I − P0 
Let γ be the probability that the measurement gives 0 in the normal game and γ′ the probability that the measurement gives 0 in the extracting game where |r〉 is randomly chosen. We have γ = γ′. 
The lemma also holds if the almost compressed phase oracle has several special points and applies the technique to all the special points. 
Proof. This is the proof for only a single special point. 
γ = ∑ 
w,D∪{(x∗,r)}∈S γr,w,D = 
∑ 
w,D∪{(x∗,r)}∈S 
1 
2N γ′r,w,D = γ′ 
ut 
9 Fiat-Shamir in the QROM 
9.1 Post-Quantum Signature 
Consider a (weakly complete) quantum secure identification protocol P,V, Fiat-Shamir approach gives a post-quantum digital signature as follows: 
– It generates a pair of valid keys for identification protocol, say (pk, sk). pk is the verification key and sk is the signing key. 
– SignH(sk,m): it generates (a, st)← P.Commit(sk), and c← H(a||m); and it generates r ← P.Prove(sk, st, c). If r is not valid, it runs another round. It keeps running until r is valid. Finally it returns σ = (a, c, r). 
– VerH(pk,m, σ = (a′, c′, r′)): given pk,m and a′, c′, r′, it first verifies whether c′ is generated honestly, in other words, c′ = H(a′||m). Then it checks (a′, c′, r′) is a valid transcript by checking whether V.Ver(pk, a′, c′, r′) = 1. 
Theorem 11. For a (weakly complete) secure quantum identification protocol with unpredictable commitment, Fiat-Shamir heuristic gives a secure post-quantum digital signature in the quantum random oracle model. 
First, let us look at completeness. By definition, there exist sets Goodλ, such that for all (pk, sk) ∈ Goodλ, a honest generated transcript (a, c, r) is valid with some non-negligible probability at least η(λ). It is easy to see when SignH runs the sigma protocol λ · 1 
η(λ) rounds, it generates a valid transcript with probability 
≥ 1 − O(e−λ). Besides, if (pk, sk) is sampled by Gen(1λ), with overwhelming probability (pk, sk) ∈ Goodλ. Completeness follows. Next, let us look at security (existential unforgeability). 
Proof. Assume we have quantum polynomial time A that makes q classical signing queries and p quantum oracle queries breaks the digital signature with advantage ε where ε is non-negligible. 
35
Hyb 0: Let ChSign be the challenger in A’s game. The game is defined as the following: 
1. A makes p quantum oracle queries to the random oracle which is simulated by B; 2. A makes q classical signing queries to the challenger ChSign. Every time A wants to make 
a classical signing query, it measures the query register (to make sure the signing query is classical). To answer signing queries mi, the challenger draws (ai, st) ← P.Commit(sk), makes a classical oracle query to the random oracle to get ci = H(ai||mi) and gets ri = P.Prove(sk, st, ci). ChSign sends σi = (ai, ci, ri) to A. 
Wlog, the final superposition will have three parts. The first part is A’s registers containing a new signature, the second part is ChSign’s registers which contain all the signing queries made by A and the third part is the oracle’s registers (which B simulates it by using a compressed phase oracle). 
Define the following measurement that checks if A succeeds in forgery: 
P0 = ∑ 
valid m,σ,s {(mi,σi},D 
|m,σ, s〉|{(mi, σi)}〉|D〉〈m,σ, s|〈{(mi, σi)}|〈D| 
and P1 = I − P0. In P0, we require that the output satisfies 
1. σ = (a, c, r) and σi = (ai, ci, ri). 2. It contains a valid new signature m,σ and all signing queries mi, σi. 3. m,σ is new relative to {(mi, σi)}qi=1, i.e, (m,σ) 6∈ {(mi, σi)}qi=1. 4. All the signatures (including the newly forged one) are valid. First, for all i, V.Ver(sk, ai, ci, ri) = 1 and V.Ver(sk, a, c, r) = 1. And second, for all i, D(ai||mi) = ci and D(a||m) = c. 
BecauseD is a compressed phase oracle. It is possible thatD(ai||mi) = ⊥ but still we haveH(ai||mi) = ci. But in this case, H(ai||mi) is completely random. From Lemma 5 in [Zha18], there is only negligible loss (as long as q is polynomial). So we have in the above game, the final measurement gives 0 with probability at least ε0 = ε− negl(λ) which is non-negligible. 
Next we are going to modify the above game step by step until we get a B which simulates signing queries and breaks the underlying identification protocol. The difference of each hybrid is marked and the detailed algorithms in each hybrid are in Appendix C. 
Hyb 1: Here for each classical query ai||mi made by ChSign, B checks the current compressed phase database does not have ai||mi. In other words, B applies the measurement 
∑ w,D:D(ai||mi)=⊥ |w,D〉〈w,D|. 
Because the sigma protocol has unpredictable commitments, the probability the measurement does not pass is negligible in λ. And every time B checks ai||mi is not in any database, it puts ai||mi into the set of the special points, i.e, append 
∑ ci |ci〉 to the oracle superposition denoting D(ai||mi) = ci. 
Let ε1 be the probability that in the above game, all the intermediate measurements pass and the final measurement gives 0. We have ε1 ≥ ε0 − negl(λ) which is non-negligible. 
Hyb 2: The algorithm A is interacting with a simulated random oracle (simulated by B) and ChSign. B applies our extracting technique in Section 7: it randomly picks i or i, j, k ∈ [p], and does one of the experiments. 
We care about the probability the all that measurements/checks pass, the extracted x = a||m contains the same thing (the same a,m) as the message of the forged signature x, σ = (a, c, r) and the final measurement gives 0 which tells a valid new signature is generated correctly. 
From corollary 6, given w = ((m,σ), s, {(mi, σi)}qi=1) and D that passes the measurement P0, define xw,D = a||m. Then we have the probability that the above experiment passes all the checks, the extracted query is a||m and the final output measured over P0, P1 is 0 is at least ε2 ≥ 1 
(q+(q3))3 · ε1. 
Hyb 3: At the time of appending ∑ 
c |c〉 or ∑ 
ci |ci〉 to the superposition, B randomly picks c and ci 
and appends |c〉 and |ci〉. From corollary 7, the probability that the experiment passes all the checks, the extracted query is a||m and the final output measured over P0, P1 is 0 remains the same, i.e, ε3 = ε2. 
36
Hyb 4: Now each ci is chosen uniformly at random. B can simulate ChSign using the honest generated transcripts. Every time A makes a signing query mi, B picks the next generated transcript (ai, ci, ri). Let H(ai||mi) = ci and σi = (ai, ci, ri). 
The distribution of transcripts does not change. So the overall probability that the experiment passes all the checks, the extracted query is a||m and the final output measured over P0, P1 is 0 remains the same, i.e, ε4 = ε3. 
Hyb 5: In the final hybrid, |c〉 is not longer chosen uniformly at random. B is now in the game of breaking the quantum computational soundness of an identification protocol with the challenger Chid. B gives a to Chid where the extracted query is x = a||m, and receives c from Chid. It then uses the given 
|c〉 instead of the randomly chosen one. The distribution does not change because c is also uniformly chosen by Chid. The overall probability that the experiment passes all the checks, the extracted query is a||m and the final output measured over P0, P1 is 0 remains the same, i.e, ε5 = ε4 is non-negligible. 
And because the extracted query is x = a||m and the newly forged signature is m,σ = (a, c, r). We know that a, c, r is valid. So B can use an adversary A for breaking the signature scheme with advantage ε, to break the underlying identification protocol with advantage at least Ω(ε/p9)− negl(λ). ut 
9.2 Quantum NIZKPoK 
First, let us recall a classical Fiat-Shamir for building NIZKPoK. 
Definition 17 (Classical Fiat-Shamir Heuristic for NIZKPoK). Fiat-Shamir Heuristic converts a classical HVZKPoK (in the form of a sigma protocol) into a NIZKPoK, by assuming a random oracle H. 
Consider we have a sigma protocol protocol (P,V), we can construct a NIZKPoK (P̃, Ṽ) as follows: 
– P̃.ProveH(x,w): it runs P.Commit(x) to get (a, st), let c = H(a) and r = P.Prove(x,w, st, c, r). It returns π = (a, c, r). 
– Ṽ.VerH(x, π): it verifies V.Ver(x, a, c, r) = 1 and H(a) = c. 
We have the following theorem: 
Theorem 12. If a sigma protocol has (1) perfect completeness, (2) post-quantum computational HVZK, (3) quantum proof of knowledge, (4) unpredictable commitments, the Fiat-Shamir heuristic gives a quantum NIZKPoK. 
Proof. Completeness: Unruh proves a similar statement of completeness where the completeness definition of a sigma protocol allows A to choose (x,w) ∈ Rλ: for any polynomial quantum A, there exists a negligible function negl, for all λ, 
Pr 
 V.Ver(x, a, c, r) = 0 ∧ (x,w) ∈ Rλ 
∣∣∣∣∣∣ 
(x,w)←A() a,st←P.Commit(x,w) 
c $←{0,1}λ 
r←P.Prove(x,w,a,c) 
  < negl(λ) 
And similarly for NIZKPoK, for any polynomial quantum A, there exists a negligible function negl, for all λ, 
Pr [ Ṽ.VerO(x, a, c, r) = 0 ∧ (x,w) ∈ Rλ 
∣∣∣ (x,w)←A() 
π←P̃.ProveO(x,w) 
] < negl(λ) 
Unruh proves if a sigma protocol satisfies the first definition and has unpredictable commitment property, NIZKPoK from Fiat-Shamir satisfies the second completeness definition. This is a stronger statement. 
HVZK: We use the same HVZK definition which is also proven in [Unr17]. Validity: Finally, let us show validity. The general idea follows the proof of secure quantum signature 
scheme. Assume there exists an efficient extractor E for the underlying quantum HVZK, such that there 
37
exists a polynomial p(·), a constant c, negligible function κ(·), negl(·), such that for any (quantum) prover A = (A0,A1), for any x satisfying, 
Pr 
[ V.Ver(x, a, c, r) = 1 : 
(a,|φa〉)←A0(x) 
c $←{0,1}λ 
r←A1(x,|φa〉,c) 
] ≥ κ(λ) 
we have, 
Pr [( x,EA(x)(x) 
) ∈ Rλ 
] ≥ 
1 
p(λ) · ( Pr 
[ V.Ver(x, a, c, r) = 1 : 
(a,|φa〉)←A0(x) 
c $←{0,1}λ 
r←A1(x,|φa〉,c) 
] − κ(λ) 
)c 
− negl(λ) 
We want to construct an efficient extractor Ẽ for quantum NIZKPoK. Consider any prover Ã for quantum NIZKPoK that makes q̃(λ) quantum oracle queries, by doing extracting and programming technique, we have a prover A for quantum HVZK such that A is chosen uniformly at random from the set A = {Ai,j,k}∪ {Ai} (which corresponds to be in Expi,j,k or Expi), and for any x, 
Pr A $←A 
[ V.Ver(x, a, c, r) = 1 : 
(a,|φa〉)←A0(x) 
c $←{0,1}λ 
r←A1(x,|φa〉,c) 
] ≥ 
1 (( 
q̃(λ) 3 
) + q̃(λ) 
)3 · PrO [ Ṽ.VerO(x, π) = 1 : π ← Ã|O〉(x) 
] − ñegl(λ) 
And from validity of this quantum HVZK, we have 
Pr A $←A 
[ (x,EA(x)(x)) ∈ Rλ 
] ≥ 
1 
q(λ) 
( Pr A $←A 
[ V.Ver(x, a, c, r) = 1 : 
(a,|φa〉)←A0(x) 
c $←{0,1}λ 
r←A1(x,|φa〉,c) 
] − κ(λ) 
)c 
− negl(λ) 
Given Ã, here is how Ẽ does: Ẽ simulates a compressed random oracle and 
– Ẽ uses E as a subroutine, – Given oracle access to Ã, it can simulate oracle access to A where it is uniformly at random chosen 
A $← A; this is by applying the same technique of extracting and programming, – Ẽ gives oracle access of Ã to E, and outputs what E outputs. 
It is easy to see that Ẽ’s behavior is the same as E is given A $← A, in other words, 
Pr [ (x, ẼÃ|O〉(x)(x)) ∈ Rλ 
] = Pr A $←A 
[ (x,EA(x)(x)) ∈ Rλ 
] 
Combining all the inequalities above, we prove (C,Q,K,N)-validity of the quantum NIZKPoK with the following parameters: 
C = c 
Q(λ) = q(λ) · (( 
q̃(λ) 
3 
) + q̃ 
)3C 
K(λ) = ( κ(λ) + ñegl(λ) 
) · (( 
q̃(λ) 
3 
) + q̃ 
)3 
N(λ) = negl(λ) 
ut 
38
References 
Ajt96. Miklós Ajtai. Generating hard instances of lattice problems. In Proceedings of the twenty-eighth annual ACM symposium on Theory of computing, pages 99–108. ACM, 1996. 23 
AKPW13. Joël Alwen, Stephan Krenn, Krzysztof Pietrzak, and Daniel Wichs. Learning with rounding, revisited -new reduction, properties and applications. In Ran Canetti and Juan A. Garay, editors, CRYPTO 2013, Part I, volume 8042 of LNCS, pages 57–74. Springer, Heidelberg, August 2013. 7 
ARU14. Andris Ambainis, Ansis Rosmanis, and Dominique Unruh. Quantum attacks on classical proof systems: The hardness of quantum rewinding. In 55th FOCS, pages 474–483. IEEE Computer Society Press, October 2014. 1, 2, 6 
BDF+11. Dan Boneh, Özgür Dagdelen, Marc Fischlin, Anja Lehmann, Christian Schaffner, and Mark Zhandry. Random oracles in a quantum world. In Dong Hoon Lee and Xiaoyun Wang, editors, ASIACRYPT 2011, volume 7073 of LNCS, pages 41–69. Springer, Heidelberg, December 2011. 1, 3 
BR93. Mihir Bellare and Phillip Rogaway. Random oracles are practical: A paradigm for designing efficient protocols. In V. Ashby, editor, ACM CCS 93, pages 62–73. ACM Press, November 1993. 1 
BZ13. Dan Boneh and Mark Zhandry. Secure signatures and chosen ciphertext security in a quantum computing world. In Ran Canetti and Juan A. Garay, editors, CRYPTO 2013, Part II, volume 8043 of LNCS, pages 361–379. Springer, Heidelberg, August 2013. 1, 3, 4, 17 
DFG13. Özgür Dagdelen, Marc Fischlin, and Tommaso Gagliardoni. The Fiat-Shamir transformation in a quantum world. Cryptology ePrint Archive, Report 2013/245, 2013. http://eprint.iacr.org/2013/245. 1, 2, 3 
DFMS19. Jelle Don, Serge Fehr, Christian Majenz, and Christian Schaffner. Security of the fiat-shamir transformation in the quantum random-oracle model. Cryptology ePrint Archive, Report 2019/190, 2019. https://eprint.iacr.org/2019/190. 9 
DKL+18. Lo Ducas, Eike Kiltz, Tancrde Lepoint, Vadim Lyubashevsky, Peter Schwabe, Gregor Seiler, and Damien Stehl. Crystals-dilithium: A lattice-based digital signature scheme. IACR Transactions on Cryptographic Hardware and Embedded Systems, 2018(1):238–268, Feb. 2018. 1, 2, 8, 9 
FS87. Amos Fiat and Adi Shamir. How to prove yourself: Practical solutions to identification and signature problems. In Andrew M. Odlyzko, editor, CRYPTO’86, volume 263 of LNCS, pages 186–194. Springer, Heidelberg, August 1987. 1 
KLS18. Eike Kiltz, Vadim Lyubashevsky, and Christian Schaffner. A concrete treatment of Fiat-Shamir signatures in the quantum random-oracle model. In Jesper Buus Nielsen and Vincent Rijmen, editors, EUROCRYPT 2018, Part III, volume 10822 of LNCS, pages 552–586. Springer, Heidelberg, April / May 2018. 1, 3, 9 
Lyu12. Vadim Lyubashevsky. Lattice signatures without trapdoors. In David Pointcheval and Thomas Johansson, editors, EUROCRYPT 2012, volume 7237 of LNCS, pages 738–755. Springer, Heidelberg, April 2012. 2, 7, 8, 9, 10, 23, 24, 25 
PS96. David Pointcheval and Jacques Stern. Provably secure blind signature schemes. In Kwangjo Kim and Tsu-tomu Matsumoto, editors, ASIACRYPT’96, volume 1163 of LNCS, pages 252–265. Springer, Heidelberg, November 1996. 1 
Reg09. Oded Regev. On lattices, learning with errors, random linear codes, and cryptography. Journal of the ACM (JACM), 56(6):34, 2009. 24 
TU15. Ehsan Ebrahimi Targhi and Dominique Unruh. Quantum security of the Fujisaki-Okamoto and OAEP transforms. Cryptology ePrint Archive, Report 2015/1210, 2015. http://eprint.iacr.org/2015/1210. 1, 3 
Unr12. Dominique Unruh. Quantum proofs of knowledge. In David Pointcheval and Thomas Johansson, editors, EUROCRYPT 2012, volume 7237 of LNCS, pages 135–152. Springer, Heidelberg, April 2012. 7, 12, 21 
Unr15. Dominique Unruh. Non-interactive zero-knowledge proofs in the quantum random oracle model. In Elisabeth Oswald and Marc Fischlin, editors, EUROCRYPT 2015, Part II, volume 9057 of LNCS, pages 755–784. Springer, Heidelberg, April 2015. 1, 3 
Unr16a. Dominique Unruh. Collapse-binding quantum commitments without random oracles. In Jung Hee Cheon and Tsuyoshi Takagi, editors, ASIACRYPT 2016, Part II, volume 10032 of LNCS, pages 166– 195. Springer, Heidelberg, December 2016. 7 
Unr16b. Dominique Unruh. Computationally binding quantum commitments. In Marc Fischlin and Jean-Sébastien Coron, editors, EUROCRYPT 2016, Part II, volume 9666 of LNCS, pages 497–527. Springer, Heidelberg, May 2016. 2, 7, 15 
39
Unr17. Dominique Unruh. Post-quantum security of Fiat-Shamir. In Tsuyoshi Takagi and Thomas Peyrin, editors, ASIACRYPT 2017, Part I, volume 10624 of LNCS, pages 65–95. Springer, Heidelberg, December 2017. 1, 3, 37 
Wat06. John Watrous. Zero-knowledge against quantum attacks. In Jon M. Kleinberg, editor, 38th ACM STOC, pages 296–305. ACM Press, May 2006. 6 
Zha12. Mark Zhandry. Secure identity-based encryption in the quantum random oracle model. In Reihaneh Safavi-Naini and Ran Canetti, editors, CRYPTO 2012, volume 7417 of LNCS, pages 758–775. Springer, Heidelberg, August 2012. 1, 3 
Zha18. Mark Zhandry. How to record quantum queries, and applications to quantum indifferentiability. Cryp-tology ePrint Archive, Report 2018/276, 2018. https://eprint.iacr.org/2018/276. 1, 3, 4, 30, 36, 41 
40
A Quantum Random Oracle Models 
In [Zha18], Zhandry showed a new technique to deal with quantum random oracles, compressed Fourier oracles and compressed standard oracles. 
The basic idea is the following: assume A is making a query to a random oracle h and the query is∑ x,u ax,u|x, u〉, instead of writing the whole system as 
∑ x,u ax,u|x, u+ h(x)〉 for a random oracle h (which 
is a density matrix from A’s view), we can actually treat the whole system as ∑ 
x,u 
∑ 
h 
ax,u|x, u+ h(x)〉 ⊗ |h〉 
where |h〉 is the truth table of h. Because A only has access to x, u registers, from A’s view, it is equivalent to the density matrix mentioned above. By looking at random oracles that way, Zhandry showed that these five oracle models are equivalent: 
1. Standard Oracles: This is the standard oracle model. By making a quantum oracle query on |x, u〉, the resulting registers are |x, u+ h(x)〉. 
StO ∑ 
x,u 
ax,u|x, u〉 ⊗ ∑ 
h 
|h〉 ⇒ ∑ 
x,u 
∑ 
h 
ax,u|x, u+ h(x)〉 ⊗ |h〉 
2. Phase Oracles: By applying quantum Fourier transform between a standard query, we have the following relation 
PhO ∑ 
x,u 
ax,u|x, u〉 ⊗ ∑ 
h 
|h〉 ⇒ ∑ 
x,u,h 
ω h(x)u N ax,u|x, u〉 ⊗ |h〉 
Because we can push the phase ω h(x)·u N (where ωN = e2πi/2 
N 
) to the oracle register, we conclude the following form of a phase oracle: 
PhO ∑ 
x,u 
ax,u|x, u〉 ⊗ ∑ 
h 
|h〉 ⇒ ∑ 
x,u 
ax,u|x, u〉 ⊗ ∑ 
h 
ω h(x)u N |h〉 
3. Fourier Oracles: We can view ∑ 
h |h〉 as QFT|02N 〉. In other words, if we do Fourier transform on a function that always outputs 0, we will get a uniform superposition over all the possible functions 
∑ h |h〉. 
Moreover, ∑ 
h ω h(x)u N |h〉 is equivalent to QFT|0N ⊕ (x, u)〉. Here ⊕ means updating the x-th entry in the 
database |02N 〉 to be (0 + u) mod N . So in this model, we start with 
∑ x,u a 
0 x,u|x, u〉 ⊗QFT|D0〉 where D0 is an all-zero database. By making 
the i-th query, we have 
FourierO ∑ 
x,u,D 
ai−1x,u,D|x, u〉 ⊗ QFT|D〉 ⇒ ∑ 
x,u,D 
ai−1x,u,D|x, u〉 ⊗ QFT|D ⊕ (x, u)〉 
We omit QFT here and write it as 
FourierO ∑ 
x,u,D 
ai−1x,u,D|x, u〉 ⊗ |D〉 ⇒ ∑ 
x,u,D 
ai−1x,u,D|x, u〉 ⊗ |D ⊕ (x, u)〉 
4. Compressed Fourier Oracles: The idea is basically the same as Fourier oracles. But when the algorithm only makes q queries, a database contains at most q non-zero entries. So to describe a database after making q queries, we only need at most q different (xi, ui) pairs which says the database is ui 6= 0 on xi and 0 everywhere else. And we define D⊕ (x, u) is doing the following: 1) if x is not in the list D and u 6= 0, put (x, u) in D; 2) if (x, u′) is in the list D and u′ 6= u, update u′ 
to u′ + u in D; 3) if (x, u′) is in the list and u′ = u, remove (x′, u′) from D. In the model, we start with 
∑ x,u a 
0 x,u|x, u〉 ⊗ |D0〉 where D0 is an empty list. After making the i-th 
query, we have 
CFourierO ∑ 
x,u,D 
ai−1x,u,D|x, u〉 ⊗ |D〉 ⇒ ∑ 
x,u,D 
ai−1x,u,D|x, u〉 ⊗ |D ⊕ (x, u)〉 
41
5. Compressed Phase Oracles: By applying QFT on the database of a compressed Fourier oracle, we get a compressed phase oracle. In this model, a database contains all the pairs (xi, ui) which means the oracle outputs ui on xi and uniformly at random on other inputs. When making a query on |x, u,D〉, – if (x, u′) is in the database D for some u′, a phase ωuu′ 
N will be added to the state; it corresponds to update u′ to u′ + u in the compressed Fourier oracle model; 
– otherwise a superposition is appended to the state |x〉 ⊗ ∑ 
u′ ωuu′ 
N |u′〉; it corresponds to put a new pair (x, u′) in the list in the compressed Fourier oracle model; 
– also make sure that the list will never have a (x, 0) pair in the compressed Fourier oracle model (by doing a QFT and see if the register is 0); if there is one, delete that pair; 
– all the ‘append’ and ‘delete’ operations above means doing QFT. 
B Full Proofs for Extracting Technique 
B.1 Generalizing Theorem 9 
The following is the proof idea for a generalization of Theorem 9. 
Proof. The idea is basic the same as the proof for Theorem 9. Let us look at the proof for a single measurement on computational basis. Assume A completely measure its register at time l (the case A only measures part of its registers is similar). 
Fixing x∗, y∗, z∗, we can define γ′i,x,w,D as: 
γ′i,x,w,D = ∑ 
(x,y)∈SD,i,z xl,yl,zl=x∗,y∗,z∗ 
αx,y,z,w 
And define γi,x,w,D as the probability that we are in Expi, the final measurement gives w,D, and A does the intermediate measurement and gets x∗, y∗, z∗ at time l. Similarly, we can define γ′i,j,k,x,w,D, γi,j,k,x,w,D. The same equations hold, for any w,D and x such that D(x) 6= ⊥, 
∑ 
i 
γ′i,x,w,D − ∑ 
i<j<k 
γ′i,j,k,x,w,D = γ′w,D 
γi,x,w,D = |γ′i,x,w,D|2 
γi,j,k,x,w,D = |γ′i,j,k,x,w,D|2 
where γ′w,D is defined as the probability that we run A normally, the final measurement gives w,D, and A does the intermediate measurement and gets x∗, y∗, z∗ at time l. 
So Theorem 9 holds conditioned on the intermediate measurement is some x∗, y∗, z∗. By averaging over all possible x∗, y∗, z∗, the theorem follows. ut 
B.2 Theorem 13 
Theorem 13. For any w, compressed phase database D and any x such that D(x) 6= ⊥ (here D(x) 6= ⊥ means D does not contain (x, u) for any u), let τx,w,D be the probability that in the extracting experiment (of randomly picking Expi or Expi,j,k), the measurement gives x and the output is w,D, and γw,D be the probability of getting w,D in the normal experiment. We have τx,w,D ≥ γw,D 
(q+(q3))3 . 
Proof. Assume the final superposition before making a measurement is 
∑ 
w′,D′ 
γ′w′,D′ |w′, D′〉 
42
where D′ is a compressed database and γ′w′,D′ is the magnitude mentioned in lemma 19. Equivalently, in the compressed phase oracle, the state is 
∑ 
w′ 
D′={(x1,u1),··· ,(xk,uk)} 
∑ 
v1,··· ,vk D′′={(x1,v1),··· ,(xk,vk)} 
ωu1v1+u2v2+···+ukvk 
N · γ′w′,D′ |w′, D′′〉 
Let γ′′w′,D′′ be the magnitude of getting w′, (compressed phase database) D′′. From the above equation, γ′′w′,D′′ where D′′ = {(x1, v1), · · · , (xk, vk)} is a linear combination of γ′w′,D′ where D is also non-empty at x1, · · · , xk. In other words, we have 
γ′′w′,D′′ = ∑ 
u1 6=0,··· ,uk 6=0 D′={(x1,u1),··· ,(xk,uk)} 
ωu1v1+u2v2+···+ukvk 
N · γ′w′,D′ 
Let γ′′i,x,w′,D′′ be the magnitude of |w′, D′′〉 at Expi and γ′′i,j,k,x,w′,D′′ be the magnitude of |w′, D′′〉 at Expi,j,k. Following the lemma 19, we have for any w,D such that D(x) 6= ⊥, 
∑ 
i 
γ′′i,x,w,D − ∑ 
i<j<k 
γ′′i,j,k,x,w,D = γ′′w,D 
The remaining proof is identical to the proof for theorem 9 and 10. ut 
B.3 Corollary 6 
Proof. Following theorem 13, τ is at least the sum of τxw,D,w,D for all (w,D) ∈ S and any xw,D such that D(xw,D) 6= ⊥. In other words, let xw,D be any element in D, we have 
τ = ∑ 
(w,D)∈S τxw,D,w,D ≥ 
1 
(q + ( q 3 
) )3 · ∑ 
(w,D)∈S γw,D = 
1 
(q + ( q 3 
) )3 · γ 
ut 
C Algorithms in Proof for Theorem 11 
C.1 Hyb 1: 
The algorithm A is interacting with a simulated random oracle (simulated by B) and ChSign. 
1. A makes p quantum oracle queries to the random oracle which is simulated by B; 2. A makes q classic signing queries to the challenger ChSign. 
To answer signing queries mi, the challenger draws ai, makes a classical oracle query to the random oracle. B checks ai||mi is not in the compressed phase database. If it is, the game fails and does not output anything. Otherwise, B makes ai||mi as a special point of this compressed oracle and 
∑ ci |ci〉 
is appended (which is H(ai||mi)). Then ChSign gets ci = H(ai||mi) and gets ri = P.Prove(sk, ai, ci). ChSign sends σi = (ai, ci, ri) to A. 
3. B checks for the forged signature m,σ = (a, c, r), a||m is in the database. If it is not, the game fails. 
C.2 Hyb 2: 
The algorithm A is interacting with a simulated random oracle (simulated by B) and ChSign. B applies our extracting technique: it randomly picks i or i, j, k ∈ [p], and does one of the experiments (in step 3 or 4). 
1. A makes p quantum oracle queries to the random oracle which is simulated by B; 
43
2. A makes q classic signing queries to the challenger ChSign. To answer signing queries mi, the challenger draws ai, makes a classical oracle query to the random oracle. B checks ai||mi is not in the compressed phase database. If it is, the game fails and does not output anything. Otherwise, 
∑ ci |ci〉 is appended corresponding to H(ai||mi). 
Then ChSign gets ci = H(ai||mi) and gets ri = P.Prove(sk, ai, ci). ChSign sends σi = (ai, ci, ri) to A. 3. If Expi is picked, B measures the query registers before the i-th quantum oracle query to get (x, u). If 
the database D has x or u = 0, it aborts and the game fails. Otherwise, x becomes a special point and∑ c |c〉 is append to the whole superposition. 
4. If Expi,j,k is picked, B measures the query registers before the i-th quantum oracle query to get x. It checks – D does not have x before the i-th query, – D has x after the i-th query and before the j-th query, – D does not have x after the j-th query and before the k-th query, – Before the k-th query, the query register is (x, u) for any u 6= 0 so that D will have x after making 
the k-th query. And then x becomes a special point. ∑ 
c |c〉 is append to the whole superposition. 5. B checks for the forged signature m,σ = (a, c, r), a||m is in the database. If it is not, the game fails. 
C.3 Hyb 3: 
1. A makes p quantum oracle queries to the random oracle which is simulated by B; 2. A makes q classic signing queries to the challenger ChSign. 
To answer signing queries mi, the challenger draws ai, makes a classical oracle query to the random oracle. B checks ai||mi is not in the compressed phase database. If it is, the game fails and does not output anything. Otherwise, a random |ci〉 is appended corresponding to H(ai||mi). ChSign gets ci = H(ai||mi) and gets ri = P.Prove(sk, ai, ci). ChSign sends σi = (ai, ci, ri) to A. 
3. If Expi is picked, B measures the query registers before the i-th quantum oracle query to get (x, u). If the database D has x or u = 0, it aborts and the game fails. Otherwise, x becomes a special point and |c〉 is append to the whole superposition for a uniformly random c. 
4. If Expi,j,k is picked, B measures the query registers before the i-th quantum oracle query to get x. It checks – D does not have x before the i-th query, – D has x after the i-th query and before the j-th query, – D does not have x after the j-th query and before the k-th query, – Before the k-th query, the query register is (x, u) for any u 6= 0 so that D will have x after making 
the k-th query. And then x becomes a special point. |c〉 is append to the whole superposition for a uniformly random c. 
5. B checks for the forged signature m,σ = (a, c, r), a||m is in the database. If it is not, the game fails. 
C.4 Hyb 4: 
1. A makes p quantum oracle queries to the random oracle which is simulated by B; 2. A makes q classic signing queries to the challenger ChSign which is also simulated by B. 
To answer signing queries mi, B picks the next honest generated transcript ai, ci, ri. B checks ai||mi is not in the compressed phase database. If it is, the game fails and does not output anything. Otherwise, |ci〉 is appended corresponding to H(ai||mi). Finally, B takes the honestly generated transcript and sends σi = (ai, ci, ri) to A. 
3. If Expi is picked, B measures the query registers before the i-th quantum oracle query to get (x, u). If the database D has x or u = 0, it aborts and the game fails. Otherwise, x becomes a special point and |c〉 is append to the whole superposition for a uniformly random c. 
4. If Expi,j,k is picked, B measures the query registers before the i-th quantum oracle query to get x. It checks – D does not have x before the i-th query, 
44
– D has x after the i-th query and before the j-th query, – D does not have x after the j-th query and before the k-th query, – Before the k-th query, the query register is (x, u) for any u 6= 0 so that D will have x after making 
the k-th query. And then x becomes a special point. |c〉 is append to the whole superposition for a uniformly random c. 
5. B checks for the forged signature m,σ = (a, c, r), a||m is in the database. If it is not, the game fails. 
45