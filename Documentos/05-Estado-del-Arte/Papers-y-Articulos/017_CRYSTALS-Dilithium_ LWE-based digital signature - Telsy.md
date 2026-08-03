# CRYSTALS-Dilithium: LWE-based digital signature - Telsy

- **ID**: `67b21cd3-b521-44d6-bc91-abced698b189`
- **Tipo de Fuente**: `SOURCE_TYPE_WEB_PAGE`
- **URL**: [https://www.telsy.com/en/crystals-dilithium-lwe-based-digital-signature/](https://www.telsy.com/en/crystals-dilithium-lwe-based-digital-signature/)

---

## Contenido Extraído / Texto Completo

CRYSTALS-Dilithium: LWE-based digital signature - Telsy
Gruppo TIM
Corporate
About us
Fondazione TIM
Services
TIM
TIM Business
TIM Enterprise
Olivetti
Noovle
Telsy
TIM Brasil
Infrastructures
Wholesale
Sparkle
To search, type something and press "enter" Cerca 
Close
About Us
Solutions
Go to Solutions
Cyber
Crypto
Quantum
Innovation
Careers
Blog
Featured News
27 Jul The 2026 FIFA World Cup: Old Cyber Threats and New Challenges
27 Jul New exploit chains and exploitation activity, AI between autonomous capabilities and offensive use, cyber incidents and campaigns
The 2026 FIFA World Cup: Old Cyber Threats and New Challenges
New exploit chains and exploitation activity, AI between autonomous capabilities and offensive use, cyber incidents and campaigns
View all
E n g l i s h
I t a l i a n o 
Cryptography, Quantum Security
CRYSTALS-Dilithium: LWE-based digital signature
31 May 2023
Share [](mailto:?subject=[Telsy]%20-%20CRYSTALS-Dilithium: LWE-based digital signature&body=CRYSTALS-Dilithium: LWE-based digital signature - https://www.telsy.com/en/crystals-dilithium-lwe-based-digital-signature/)  [](http://www.linkedin.com/shareArticle?url=https://www.telsy.com/en/crystals-dilithium-lwe-based-digital-signature/&title=CRYSTALS-Dilithium: LWE-based digital signature) [](https://twitter.com/share?url=https://www.telsy.com/en/crystals-dilithium-lwe-based-digital-signature/&text=CRYSTALS-Dilithium: LWE-based digital signature)  [](https://telegram.me/share/url?url=https://www.telsy.com/en/crystals-dilithium-lwe-based-digital-signature/&text=CRYSTALS-Dilithium: LWE-based digital signature)
Introduction
The NIST standardization process in the post-quantum domain has identified two cryptographic schemes to be considered “primary” solutions. Regarding Key Encapsulation Mechanisms (KEMs), i.e., key derivation schemes, CRYSTALS-Kyber was selected, while for digital signatures the choice fell on CRYSTALS-Dilithium (that has now been standardized under the ML-DSA name). Within modern cryptographic communication protocols, Dilithium will replace the schemes currently used for digital signatures, including RSA and those based on elliptic curves, both proven to be vulnerable to attacks by a quantum computer.
CRYSTALS-Dilithium
Similarly to Kyber, Dilithium bases its security on certain computational problems defined over lattices, which are considered intractable even for a quantum computer. In particular, as will be analyzed later, the generation of the public-private key pair occurs through the definition of an instance of Module-LWE. For completeness, we also mention the Short Integer Solution (SIS)[ 1] problem, namely the problem of finding small-norm solutions to a linear system, formally defined as: *Given a matrix 
, a positive integer 
, and a positive real number 
, find a vector 
such that*
 ;
 .
Before going into the details of the Dilithium signature scheme, it is useful to fix some notation.
 is a prime number
 denotes the set
 denotes the set of polynomials in with coefficients in with the relation
 denotes a subset of with coefficients bounded by
Let be a set, indicates that is sampled uniformly from
 denotes the subset of consisting of polynomials with coefficients equal to and the rest equal to
 is a hash function with codomain
As a digital signature scheme, the phases that make up Dilithium, reported below in a simplified form, are identified as Key Generation, Signing, and Verification. 
Key Generation
In this phase, the private key and the public key are generated, which will be used respectively to produce and verify a signature. A public matrix 
is sampled uniformly, where each component is a polynomial in the set 
. The entries of the private key 
are sampled uniformly from the set 
. Using the matrix 
and the vectors 
, the vector 
is computed, which, together with 
, forms the public key of the signature scheme. As mentioned earlier, key generation in Dilithium consists of creating an instance of Module-LWE. In fact, to recover the secrets 
of the private key given the public key 
, an attacker would need to solve the Module-LWE problem and, given the assumption of its intractability, this provides strong security guarantees for the scheme. It is worth noting that, unlike other lattice-based schemes participating in the NIST process, the secret vectors 
are sampled uniformly rather than according to a discrete Gaussian distribution. The authors argue that, thanks to this choice, it is possible to reduce the risk of certain side-channel attacks that could make some implementations insecure. It is also important to note that, since the random matrix 
consists of 
polynomials in 
, its representation would be excessively large, making transmission quite costly and thus the use of Dilithium less practical. The adopted solution is to generate 
from a smaller seed; in this way, it is sufficient to transmit only the identified seed within the public key.
Signing
The signing of a message in Dilithium is carried out using the approach known as Fiat-Shamir with Aborts, introduced by Ukrainian-American mathematician Vadim Lyubashevsky in 2009. In this strategy, the signature scheme is derived from an identification protocol in which interactivity is removed using the Fiat-Shamir transform, as is done for the Schnorr signature in EdDSA. In an identification protocol, a Prover must demonstrate to a Verifier that they possess a certain secret, in this case the pair 
, without revealing it. 
The identification scheme depicted above involves an interaction between the parties that is preparatory to sending the proof 
. In a signature scheme, these two preliminary communications can be removed, allowing the prover to generate the challenge 
by computing it as the hash of the concatenation of the message 
and the commitment 
. 
It should be noted that, following the signature scheme described above, for some unfortunate choices of the vector 
, an attacker may be able to extract information about the private key from the signature 
. A so-called rejection sampling phase is therefore required to address this possibility, repeating the signing process whenever certain parameters fall outside a secure regime. Indeed, to complete the Fiat-Shamir with Aborts construction, it is necessary to introduce this check before sending the signature. In the Dilithium scheme, rejection sampling is performed through a loop that terminates only when the coefficients of the signature fall within certain bounds derived from the scheme's parameters. In Dilithium, several optimizations are introduced that allow only the most significant bits of the commitment 
to be considered. In order to preserve the correctness of the operations, it is necessary to transmit a hint that enables signature verification even when only a truncated version of the commitment vector is available. While sending a hint requires adding approximately 100 bytes to the signature size, this same measure allows the public key size to be reduced by about a factor of 2.
Verification
In the verification step, it is checked that the commitment 
, contained in the signature, matches the output of the hash function computed on the concatenation of the message 
and 
, where 
is derived from the signature 
and the public key 
. Also in the signature verification process, some optimizations have been introduced which, by working only with the most significant bits, significantly reduce the size of the digital signature.
Performance
The main goal of the authors of CRYSTALS-Dilithium is to design a scheme that minimizes the sizes of both the public key and the message signature. This choice is intended to support the use of Dilithium in contexts such as secure web browsing, where it is necessary to transmit a chain of certificates containing multiple signatures and their corresponding public keys used for verification. 
In the graph shown above, a comparison is provided between the performance of Dilithium and two of the most widely used traditional schemes (RSA and EdDSA), in terms of transmitted data size (on the left), i.e., public key and signature, and computational cost of the components described in the previous sections (on the right). While computational efficiency in required cycles is not an issue – Dilithium is comparable to EdDSA and much more efficient than RSA – transmission costs require further investigation. In fact, it can be observed that in Dilithium the size of the public key and signature is significantly larger than that produced by traditional algorithms. Moreover, this size exceeds the Maximum Transmission Unit (MTU), typically set to 1500 bytes and representing the maximum capacity of an IP packet. The transition process to post-quantum schemes must therefore carefully take this issue into account in order to mitigate its effects in terms of latency and packet fragmentation. [ 1] In Dilithium, variations of SIS play a fundamental role in a more in-depth security analysis, beyond the scope of this article.
This article belongs to a series of contributions, edited by the Telsy Cryptography Research Group, devoted to quantum computing and its implications on Cryptography. For reference to other articles, please refer to the index.
For other articles related to Quantum and Cryptography topics, please refer to the related categories in the blog.
The authors
Francesco Stocco, a master's degree in Mathematics at the University of Padua and the Université de Bordeaux attending the course of study “Algebra Geometry And Number Theory” (ALGANT), joined the Telsy research group in Cryptography at the end of 2020 focusing in particular on issues related to quantum technologies.
Marco Rinaudo, a bachelor's degree in Mathematics from the University of Turin and a master's degree with a specialization in Cryptography from the University of Trento. Following a 2022 curricular internship at Telsy, he has been part of the Cryptography Research Group since January 2023.  
Post navigation
Previous: eXtended Detection and Response (XDR)
Next: The Spyware
Find out more
About us
Solutions
Careers
Blog
Governance
Privacy Policy
Cookie Policy
Comment Policy
Whistleblowing
Accessibility
GDPR Information Notice
Courtesy page
Operational Offices
Turin
Corso Svizzera, 185, 10149
Rome
Via Bartolomeo Marliano, 27, 00162
Via Antonio Nibby, 4-6, 00161
Naples
Centro Direzionale, Isola F6, 80143
Orvieto
Via delle Acacie, 17, 05018 Ciconia (TR)
Contacts
Phone
+39 011 77 14 343
Mail
contact@telsy.it
Follow us
 
 
© 2023 Telsy SpA company with a single shareholder TIM Group • VAT 00737690016 • REA TO443365
Preferenze cookie
Informativa e Consenso Cookie
Telsy S.p.A. attraverso il presente Sito e i suoi partner conservano e/o accedono alle informazioni su un dispositivo, come gli ID univoci nei cookie per il trattamento dei dati personali. Questo sito utilizza cookie tecnici, necessari per effettuare la navigazione, agevolare la fruizione di contenuti online o fornire un servizio richiesto dagli utenti; cookie di profilazione, propri e/o di terze parti, per personalizzare contenuti ed annunci, inviare agli utenti pubblicità in linea con le proprie preferenze, misurare l'efficacia del messaggio pubblicitario ed adottare conseguenti strategie commerciali; cookie di analytics per raccogliere informazioni e produrre statistiche aggregate sul numero degli utenti e su come visitano il Sito ai fini dell'ottimizzazione dello stesso. Se vuoi sapere di più clicca qui.
Se selezioni il sottostante comando "Accetto", esprimi il consenso accettando tutti i cookie.
Puoi modificare le tue preferenze in ogni momento su tutte le pagine di questo sito cliccando su "Preferenze Cookie" selezionando in modo analitico solo le funzionalità, i cookie e le terze parti a cui intendi prestare il consenso.
Se scegli di chiudere il banner utilizzando il pulsante "Continua senza accettare" in alto a destra, saranno mantenute le impostazioni predefinite che non consentono l'utilizzo di cookie o altri strumenti di tracciamento diversi da quelli tecnici. Queste scelte saranno segnalate ai nostri partner.
Se accetti i cookie di profilazione di terza parte, questi saranno creati sul tuo dispositivo per: utilizzare dati di geolocalizzazione precisi, scansionare attivamente delle caratteristiche del dispositivo ai fini dell'identificazione, archiviare e/o accedere a informazioni su un dispositivo, mostrare annunci e contenuti personalizzati, valutazione degli annunci e del contenuto, osservazioni del pubblico e sviluppo di prodotti.
Preferenze cookie
ACCETTA E CHIUDI
Continua senza accettare 
Preferenze Cookie
La tua privacy
La tua privacy
Questo Sito utilizza cookie tecnici, necessari per effettuare la navigazione, agevolare la fruizione di contenuti online o fornire un servizio richiesto dagli utenti; cookie di profilazione, propri e di terze parti, per personalizzare contenuti ed annunci, inviare agli utenti pubblicità in linea con le proprie preferenze, misurare l'efficacia del messaggio pubblicitario ed adottare conseguenti strategie commerciali; cookie di analytics per analizzare il traffico mediante la raccolta di informazioni aggregate sul numero degli utenti e su come visitano il Sito ai fini dell'ottimizzazione dello stesso. Ulteriori informazioni
Cookie Strettamente Necessari
Cookie Strettamente Necessari
Sempre attivi Questi cookie sono utilizzati per la trasmissione della comunicazione o per fornire il servizio richiesto dall'utente; più precisamente permettono di abilitare ed ottimizzare il funzionamento del sito internet, eseguire autenticazioni informatiche e prevenire abusi, monitorare le sessioni, migliorare l'esperienza di navigazione degli utenti (ad esempio mantenendo attiva la connessione ad aree riservate durante la navigazione attraverso le pagine del sito senza la necessità di reinserire User-Id e password oppure ricordando l'impostazione espressa dall'utente per la lingua).
Cookie Analytics
Sempre attivi Questi cookie, basati su servizi di analytics forniti da terze parti, sono utilizzati per raccogliere informazioni relative al tuo browser, al tuo dispositivo, alla tua connessione internet, alla zona geografica da cui ti connetti, al tuo indirizzo IP mascherato in tutto o in parte, alle pagine che hai visitato su questo Sito e produrre statistiche aggregate sul numero degli utenti e su come questi visitano il presente Sito (anche eventualmente ripartiti per area geografica, fascia oraria della connessione e altre caratteristiche), ai fini dell'ottimizzazione dello stesso. Visualizza dettagli fornitore
Cookie di Profilazione
Cookie di Profilazione
[-]  Cookie di Profilazione Inattivi
Cookie per Pubblicità Mirata
[-]  Switch Label label Questi cookie permettono di costruire un profilo dei tuoi interessi al fine di mostrarti annunci per te pertinenti. Se non si accettano questi cookie, non riceverai una pubblicità mirata. Visualizza dettagli fornitore
Elenco fornitori
Consent Leg.Interest [-]
checkbox label label [-]
checkbox label label [-]
checkbox label label
Clear [-]
checkbox label label
Apply Cancel
Conferma le mie scelte
Consenti tutti