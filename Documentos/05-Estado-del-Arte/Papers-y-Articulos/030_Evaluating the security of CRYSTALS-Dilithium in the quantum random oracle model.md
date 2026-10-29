# Evaluating the security of CRYSTALS-Dilithium in the quantum random oracle model

- **ID**: `bbb9822f-62f0-4b8d-8de0-d90f41aa3609`
- **Tipo de Fuente**: `SOURCE_TYPE_PDF`
- **URL**: [https://csrc.nist.gov/csrc/media/Projects/post-quantum-cryptography/documents/pqc-seminars/presentations/12-evaluating-the-security-05072024.pdf](https://csrc.nist.gov/csrc/media/Projects/post-quantum-cryptography/documents/pqc-seminars/presentations/12-evaluating-the-security-05072024.pdf)

---

## Contenido Extraído / Texto Completo

    
  
       
            
        
Evaluating the security of CRYSTALS-Dilithium 
in the QROM 
K. A. Jackson1, Carl A. Miller2,3, Daochen Wang4 
University of Maryland: Department of Physics1 and UMIACS2, National Institute of Standards and Technology3, University of British Columbia: 
Department of Computer Science4 
      
 
  
Cryptography must adapt to a post-quantum setting 
FALCON CRYSTALS 
- Kyber 
SIKE 
BIKE 
HQC 
NTRU 
SPHINCS + 
Rainbow 
Classic -McEliece 
CRYSTALS -
Dilithium 
        
   
  
Quantum-accessible hash functions are constructed from classical hash functions 
Classical: Quantum: 
Boneh et al., 2010 
         
  
   
   
The (Quantum) Random Oracle Model is a useful postquantum tool 
Classical: Quantum: 
  
Standard Model: 
Random Oracle Model: 
Boneh et al., 2010 
     
       
CRYSTALS-Dilithium’s security depends on a novel problem 
 
Bai et al., 2021; Langlois & Stehlé, 2012 
     
      
 
       
CRYSTALS-Dilithium’s security depends on a novel problem 
ROM: , at least as hard as 
SVP 
 
SIS LWE 
(over ℤ[x]/(𝑥 
 
+ 1)) 
MSIS MLWE 
SelfTargetMSIS 
Bai et al., 2021; Langlois & Stehlé, 2012 
 
   
   
Structure Definitions 
Bai et al., 2021 
 
   
Structure Definitions 
   
   (Small) 
Bai et al., 2021 
 
   
Structure Definitions 
   
   (Small) 
    (Short) 
Bai et al., 2021 
  
   
Definition of MLWE 
MLWE 
Bai et al., 2021 
  
   
Definition of MLWE 
MLWE 
Bai et al., 2021 
  
   
Definition of MLWE 
MLWE 
Bai et al., 2021 
  
   
    
Definition of MSIS 
MSIS 
Bai et al., 2021 
   , set of “small” vectors 
  
   
    
Definition of MSIS 
 , set of “small” vectors  
MSIS 
Requires: 
Bai et al., 2021 
  
   
        
Definition of SelfTargetMSIS 
 , set of “small” vectors  
, set of “short” vectors  
SelfTargetMSIS 
Bai et al., 2021 
  
   
        
Definition of SelfTargetMSIS 
 , set of “small” vectors  
, set of “short” vectors  
SelfTargetMSIS  
 
×   
Bai et al., 2021 
  
   
        
Definition of SelfTargetMSIS 
 , set of “small” vectors  
, set of “short” vectors  
  
 SelfTargetMSIS  
×   
Bai et al., 2021 
  
   
        
Definition of SelfTargetMSIS 
 , set of “small” vectors  
, set of “short” vectors  
SelfTargetMSIS   
  
×   
Requires: 
Bai et al., 2021 
 
  
    
Proof Roadmap 
, , , , ,   | ⟩ 
, , , , ,   
, , , ,   
, , , ,   
Jackson, Miller, & Wang, 2024 
 
  
    
Proof Roadmap 
, , , , ,   | ⟩ 
, , , , ,   
, , , ,   
, , , ,   
Jackson, Miller, & Wang, 2024 
        
 
   
 
  
Rewinding works in the ROM, but not the QROM 
𝑛, 𝜎 𝐴  ... 𝐴  𝐴  𝐴  ... 𝐴  
 Glossary: 
-classical 
query alg. with 
success prob. 
Bellare & Neven, 2006 
        
 
   
 
  
Rewinding works in the ROM, but not the QROM 
𝑛, 𝜎 𝐴  ... 𝐴  𝐴  𝐴  ... 𝐴  
 
n , 𝜎𝐴   ... 𝐴  
 𝐴   𝐴  ... 𝐴  
 
Glossary: 
-classical 
query alg. with 
success prob. 
Bellare & Neven, 2006 
        
 
 
   
 
  
Rewinding works in the ROM, but not the QROM 
𝑛, 𝜎 𝐴  ... 𝐴  𝐴  𝐴  ... 𝐴  
 
n , 𝜎𝐴   ... 𝐴  
 𝐴   𝐴  ... 𝐴  
 
ROM: 
Glossary: 
-classical 
query alg. with 
success prob. 
Bellare & Neven, 2006 
      
 
   
 
   
Reprogramming can be used in the QROM 
𝜎 𝐴  ... 𝐴  𝐴  𝐴  ... 𝐴  
 Glossary: 
-quantum 
query alg. with 
success 
prob. 
Don et al., 2020 
      
 
   
 
   
Reprogramming can be used in the QROM 
Glossary: 
𝐴  ... 𝐴  𝐴  𝐴  ... 𝐴  𝜎 
-quantum 
𝐴  ... 𝐴  
 𝐴  𝐴  ... 𝐴  𝜎  
query alg. with 
success 
prob. 
 
  
 
Don et al., 2020 
     
 
   
   
 
   
We map quantum-query SelfTargetMSIS to classical-query SelfTargetMSIS 
Glossary: 
𝐴  ... 𝐴  𝐴  𝐴  ... 𝐴  𝜎 
-quantum 
𝐴  ... 𝐴  
 𝐴  𝐴  ... 𝐴  𝜎  query quantum alg. 
: -classical query 
quantum alg. 
Don et al., 2020 
     
    
Mapping SelfTargetMSIS to a Chosen-Coordinate Binding Experiment 
Prover Verifier 
Jackson, Miller, & Wang, 2024 
     
    
Mapping SelfTargetMSIS to a Chosen-Coordinate Binding Experiment 
Prover Verifier 
Jackson, Miller, & Wang, 2024 
     
    
Mapping SelfTargetMSIS to a Chosen-Coordinate Binding Experiment 
Prover Verifier 
Jackson, Miller, & Wang, 2024 
     
    
Mapping SelfTargetMSIS to a Chosen-Coordinate Binding Experiment 
Prover Verifier 
Jackson, Miller, & Wang, 2024 
 
  
Proof Roadmap 
, , , , ,   | ⟩ 
, , , , ,   
, , , ,   
, , , ,   
                         
   
 
  
What is a Collapsingness Experiment? 
Algorithm passes the collapsingness experiment iff  can construct a register such that  has a better than random chance of detecting if a verifier has destructively measured the register 
Register 
Dall’Agnol & Spooner, 2023 
                         
   
 
  
What is a Collapsingness Experiment? 
Algorithm passes the collapsingness experiment iff  can construct a register such that  has a better than random chance of detecting if a verifier has destructively measured the register 
Register  
 
Dall’Agnol & Spooner, 2023 
                         
   
 
  
What is a Collapsingness Experiment? 
Algorithm passes the collapsingness experiment iff  can construct a register such that  has a better than random chance of detecting if a verifier has destructively measured the register 
Register  
 
  
Dall’Agnol & Spooner, 2023 
Mapping the Chosen-Coordinate Binding Experiment to a Collapsingness Experiment 
Builds registers over    
∗ 
Jackson, Miller, & Wang, 2024 
 
 
Apply 
Measure register 
ϯ
   
       
    
 
 Measure register 
ϯ 
Mapping the Chosen-Coordinate Binding Experiment to a Collapsingness Experiment 
   ∗Builds registers over   
Apply  ,  ∈ × 
∈  
  , ,  
Jackson, Miller, & Wang, 2024 
   
       
    
 
 
Mapping the Chosen-Coordinate Binding Experiment to a Collapsingness Experiment 
   ∗Builds registers over   
 
Apply 
Measure  register 
ϯ 
 ,  ∈ × ∈  
  , ,  
  
 
Jackson, Miller, & Wang, 2024 
 
  
Proof Roadmap 
, , , , ,   | ⟩ 
, , , , ,   
, , , ,   
, , , ,   
     
    
  vs. 
vs. 
A Collapsingness Distinguisher Implies an MLWE Distinguisher 
Jackson, Miller, & Wang, 2024 
   
     
    
A Collapsingness Distinguisher Implies an MLWE Distinguisher 
vs.  
vs. 
,   then measure  
Jackson, Miller, & Wang, 2024 
     
    
 
  
A Collapsingness Distinguisher Implies an MLWE Distinguisher 
vs.  
vs. 
,   then measure  
Jackson, Miller, & Wang, 2024 
  
  
   
 
Details on 
computational basis measurement 
  
 
       
   
  
  
   
     
      
 
Details on 
computational basis measurement 
  
       
  
  
We can prove that for some parameters: 
      
      
            
   
      
     
    
SelfTargetMSIS to MLWE Reduction for Security Applications 
Conclusion: An algorithm that solves , , , , with advantage ϵ from queries reduces to , , with advantage like   for . 
We can approximate quantum Core-SVP security like: 
  
 
Jackson, Miller, & Wang, 2024 
 
  
    
Proof Roadmap 
, , , , ,   | ⟩ 
, , , , ,   
, , , ,   
, , , ,   
Jackson, Miller, & Wang, 2024 
          
    
Conclusions 
We provide the first proof that SelfTargetMSIS is hard in the QROM 
Jackson, Miller, & Wang, 2024 
          
   
 
   
   
    
Conclusions 
We provide the first proof that SelfTargetMSIS is hard in the QROM 
Compared to original Dilithium: 
Increase 
Increase size of 
Increase size of 
  
Jackson, Miller, & Wang, 2024 
          
   
 
   
   
 
    
Conclusions 
We provide the first proof that SelfTargetMSIS is hard in the QROM 
Compared to original Dilithium: 
Increase 
Increase size of 
Increase size of 
Provable security 
  
Jackson, Miller, & Wang, 2024 
     Dilithium-QROM reformulates Dilithium in a different ring 
CRYSTALS-Dilithium 
Dilithium-QROM
          
  
   
   
    
Conclusions 
We provide the first proof that SelfTargetMSIS is hard in the QROM 
Compared to Dilithium-QROM: 
Increase size of 
Increase size of 
Jackson, Miller, & Wang, 2024 
          
  
  
 
 
 
   
   
    
Conclusions 
We provide the first proof that SelfTargetMSIS is hard in the QROM 
Compared to Dilithium-QROM: 
Increase size of 
Increase size of 
Jackson, Miller, & Wang, 2024 
Better-studied ring structure 
Faster KeyGen 
Faster Sign 
Faster Verify 
          
   
      
     
    
Conclusions 
We provide the first proof that SelfTargetMSIS is hard in the QROM 
Our version of Dilithium is: 
Provably secure under safer assumptions than CRYSTALS-Dilithium 
More efficient to implement than Dilithium-QROM 
Jackson, Miller, & Wang, 2024 
Acknowledgements 
          
             
   
              
        
         
              
              
         
        
Questions? 
1. Boneh et al. “Random Oracles in a Quantum World”. ASIACRYPT 2011. DOI: 10.1007/978-3-642-25385-0_3 
2. Bai et al. “CRYSTALS-Dilithium: Algorithm Specifications and 
Quantum Cryptography. URL: https://pq-crystals.org/dilithium/ 
Supporting Documentation, Round 3.1”. NIST: Post 
3. Langlois & Stehlé. “Worst-Case to Average-Case Reductions for Module Lattices”. Designs, Codes and Cryptography. DOI: 10.1007/s10623-014-9938-4 
4. Bellare and Neven. “Multi-Signatures in the Plain Public-Key Model and a General Forking Lemma”. CCS ’06. DOI: 10.1145/1180405.1180453 
5. Don et al. “The Measure-and-Reprogram Technique 2.0: Multi-round Fiat-Shamir and More”. CRYPTO 2020. DOI: 10.1007/978-3-030-56877-1_21 
6. Dall’Agnol & Spooner. “On the Necessity of Collapsing for Post-Quantum and Quantum Commitments”. TQC 2023. DOI: 10.4230/LIPIcs.TQC.2023.2 
7. Jackson, Miller, & Wang. “Evaluating the security of CRYSTALS-Dilithium in the quantum random oracle model”. EUROCRYPT 2024. DOI:10.48550/arXiv.2312.16619 
    
  
 
Define “breaking” a hash function 
Assume: 
Realizable, Deterministic, Surjective 
Computationally Efficient 
 
  
    
     
                
       
       
       
       
       
 
       
The Forking Lemma is technically sound 
Let 𝐴  be a randomized 𝑝-query algorithm with access to 𝐻: 𝑋 → 𝑌 that with given input 𝜒 and random queries 
∈ 𝑋  outputs n, 𝜎 ∈ 𝑍 × 𝑌  for arbitrary constant 𝑛 with success probability 𝛿.𝑥 : 𝑖 ∈ 𝑝 
Then, the forking algorithm 𝑅 𝐴 [.] acts as follows: 
1. Set random tape 𝑟 for 𝐴 and select inputs 𝑥 : 𝑖 ∈ 𝑝 ← 𝑋 accordingly 
2. Output 𝑛, 𝜎 ← 𝐴(𝜒, 𝑥 , … , 𝑥 : 𝑟). If 𝑛 = 0, break and return (0, 𝜎, 𝜎). 
3. Select new inputs for 𝐴 at random like 
4. Output 𝑛′, 𝜎′ ← 𝐴(𝜒, 𝑥 , … , 𝑥 , 𝑥 , … , 𝑥  : 𝑟). 
5. If 𝑛 = 𝑛 and 𝑥 ≠ 𝑥 , return (1, 𝜎, 𝜎 ). Else return (0, 𝜎, 𝜎 ) 
𝑥 ′: 𝑗 ∈ 𝑛, 𝑝 ← 𝑋 
 
  
                  
         
   
       
     
    
    
Details on 
Lemma (Dall’Agnol & Spooner, 2023): Let be projectors in ×  and be a density matrix in 
 such that . Then, . 
1. Prep states with   , then apply 2. Make projective measurement 3. If measurement outputs   
. 
Apply ϯ 
Make projective measurement on the bound coordinate register. 
If measurement outputs : o  
Else, if measurement outputs o  
Else, if measurement outputs   
 
. 
  
  
 
 
 
  
  
   
     
      
 
Details on 
computational basis measurement 
  
       
  
  
We can prove that for some parameters: 
      
      
  Concrete Parameter Tables 
  
  
  
  
  
• • 
Concrete Complexity Tables 
NTT :  
 
NTT : 
HTT :  
 
HTT : 
Gen Sign Verify 