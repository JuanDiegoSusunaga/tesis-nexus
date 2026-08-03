# Forward secrecy - Wikipedia

- **ID**: `050ebb24-64e6-4c7c-a76d-888a7ac946df`
- **Tipo de Fuente**: `SOURCE_TYPE_WEB_PAGE`
- **URL**: [https://en.wikipedia.org/wiki/Forward_secrecy](https://en.wikipedia.org/wiki/Forward_secrecy)

---

## Contenido Extraído / Texto Completo

Forward secrecy - Wikipedia
Jump to content [-]
Main menu
Main menu
move to sidebar hide
Navigation
Main page
Contents
Current events
Random article
About Wikipedia
Contact us
Contribute
Help
Learn to edit
Community portal
Recent changes
Upload file
Special pages
WikipediaThe Free Encyclopedia
Search
Search [-]
Appearance
Donate
Create account
Log in [-]
Personal tools
Donate
Create account
Log in
Contents
move to sidebar hide
(Top)
1 History
2 Definition
3 Example
4 Attacks
5 Non-interactive forward secrecy
6 Weak perfect forward secrecy
7 Protocols
8 Use
9 See also
10 References
11 Bibliography
12 External links [-]
Toggle the table of contents
Forward secrecy
[-]
22 languages
العربية
Català
Čeština
Deutsch
Esperanto
Español
Eesti
فارسی
Suomi
Français
עברית
Magyar
Italiano
日本語
한국어
Nederlands
Polski
Português
Русский
Türkçe
Українська
中文
Edit links
Article
Talk [-]
English
Read
Edit
View history [-]
Tools
Tools
move to sidebar hide
Actions
Read
Edit
View history
General
What links here
Related changes
Upload file
Permanent link
Page information
Cite this page
Get shortened URL
Switch to legacy parser
Expand all
Edit interlanguage links
Print/export
Download as PDF
Printable version
In other projects
Wikidata item
Appearance
move to sidebar hide
Text
[-] 0 Small [x] 1 Standard [-] 2 Large
This page always uses small font size
Width
[x] 1 Standard [-] 0 Wide
The content is as wide as possible for your browser window.
Color
[-] os Automatic [x] day Light [-] night Dark
This page is always in light mode.
From Wikipedia, the free encyclopedia
Practice in cryptography 
A key derivation function (KDF) can help achieve forward secrecy. A KDF is a one-way function that generates a new key from the current key. Leaking a key does not allow discovery of prior keys.
In cryptography, forward secrecy ( FS), also known as perfect forward secrecy ( PFS), is a feature of specific key-agreement protocols that gives assurances that session keys will not be compromised even if long-term secrets used in the session key exchange are compromised, limiting damage. [1] [2] [3] For TLS, the long-term secret is typically the private key of the server. Forward secrecy protects past sessions against future compromises of keys or passwords. By generating a unique session key for every session a user initiates, the compromise of a single session key will not affect any data other than that exchanged in the specific session protected by that particular key. This by itself is not sufficient for forward secrecy, which additionally requires that a long-term secret compromise does not affect the security of past session keys.
Forward secrecy protects data on the transport layer of a network that uses common transport layer security protocols, including OpenSSL, [4] when its long-term secret keys are compromised, as with the Heartbleed security bug. If forward secrecy is used, encrypted communications and sessions recorded in the past cannot be retrieved and decrypted should long-term secret keys or passwords be compromised in the future, even if the adversary actively interfered, for example via a man-in-the-middle (MITM) attack.
The value of forward secrecy is that it protects past communication. This reduces the motivation for attackers to compromise keys. For instance, if an attacker learns a long-term key, but the compromise is detected and the long-term key is revoked and updated, relatively little information is leaked in a forward secure system.
The value of forward secrecy depends on the assumed capabilities of an adversary. Forward secrecy has value if an adversary is assumed to be able to obtain secret keys from a device (read access) but is either detected or unable to modify the way session keys are generated in the device (full compromise). In some cases an adversary who can read long-term keys from a device may also be able to modify the functioning of the session key generator, as in the backdoored Dual Elliptic Curve Deterministic Random Bit Generator. If an adversary can make the random number generator predictable, then past traffic will be protected but all future traffic will be compromised.
The value of forward secrecy is limited not only by the assumption that an adversary will attack a server by only stealing keys and not modifying the random number generator used by the server but it is also limited by the assumption that the adversary will only passively collect traffic on the communications link and not be active using a man-in-the-middle attack. Forward secrecy typically uses an ephemeral Diffie–Hellman key exchange to prevent reading past traffic. The ephemeral Diffie–Hellman key exchange is often signed by the server using a static signing key. If an adversary can steal (or obtain through a court order) this static (long term) signing key, the adversary can masquerade as the server to the client and as the client to the server and implement a classic man-in-the-middle attack. [5]
History
[ edit]
The term "perfect forward secrecy" was coined by C. G. Günther in 1990 [6] and further discussed by Whitfield Diffie, Paul van Oorschot, and Michael James Wiener in 1992, [7] where it was used to describe a property of the Station-to-Station protocol. [8]
Forward secrecy has also been used to describe the analogous property of password-authenticated key agreement protocols where the long-term secret is a (shared) password. [9]
In 2000 the IEEE first ratified IEEE 1363, which establishes the related one-party and two-party forward secrecy properties of various standard key agreement schemes. [10]
Definition
[ edit]
An encryption system has the property of forward secrecy if plain-text (decrypted) inspection of the data exchange that occurs during key agreement phase of session initiation does not reveal the key that was used to encrypt the remainder of the session.
Example
[ edit]
This section does not cite any sources. Please help improve this section by adding citations to reliable sources. Unsourced material may be challenged and removed. ( February 2018) ( Learn how and when to remove this message)
The following is a hypothetical example of a simple instant messaging protocol that employs forward secrecy:
Alice and Bob each generate a pair of long-term, asymmetric public and private keys, then verify public-key fingerprints in person or over an already-authenticated channel. Verification establishes with confidence that the claimed owner of a public key is the actual owner.
Alice and Bob use a key exchange algorithm such as Diffie–Hellman, to securely agree on an ephemeral session key. They use the keys from step 1 only to authenticate one another during this process.
Alice sends Bob a message, encrypting it with a symmetric cipher using the session key negotiated in step 2.
Bob decrypts Alice's message using the key negotiated in step 2.
The process repeats for each new message sent, starting from step 2 (and switching Alice and Bob's roles as sender/receiver as appropriate). Step 1 is never repeated.
Forward secrecy (achieved by generating new session keys for each message) ensures that past communications cannot be decrypted if one of the keys generated in an iteration of step 2 is compromised, since such a key is only used to encrypt a single message. Forward secrecy also ensures that past communications cannot be decrypted if the long-term private keys from step 1 are compromised. However, masquerading as Alice or Bob would be possible going forward if this occurred, possibly compromising all future messages.
Attacks
[ edit]
Forward secrecy is designed to prevent the compromise of a long-term secret key from affecting the confidentiality of past conversations. However, forward secrecy cannot defend against a successful cryptanalysis of the underlying ciphers being used, since a cryptanalysis consists of finding a way to decrypt an encrypted message without the key, and forward secrecy only protects keys, not the ciphers themselves. [11] A patient attacker can capture a conversation whose confidentiality is protected through the use of public-key cryptography and wait until the underlying cipher is broken (e.g. large quantum computers could be created which allow the discrete logarithm problem to be computed quickly), a.k.a. harvest now, decrypt later attacks. This would allow the recovery of old plaintexts even in a system employing forward secrecy.
Non-interactive forward-secure key exchange protocols face additional threats that are not relevant to interactive protocols. In a message suppression attack, an attacker in control of the network may itself store messages while preventing them from reaching the intended recipient; as the messages are never received, the corresponding private keys may not be destroyed or punctured, so a compromise of the private key can lead to successful decryption. Proactively retiring private keys on a schedule mitigates, but does not eliminate, this attack. In a malicious key exhaustion attack, the attacker sends many messages to the recipient and exhausts the private key material, forcing a protocol to choose between failing closed (and enabling denial of service attacks) or failing open (and giving up some amount of forward secrecy). [12]
Non-interactive forward secrecy
[ edit]
Most key exchange protocols are interactive, requiring bidirectional communication between the parties. A protocol that permits the sender to transmit data without first needing to receive any replies from the recipient may be called non-interactive, or asynchronous, or zero round-trip time (0-RTT). [13] [14]
Interactivity is onerous for some applications— for example, in a secure messaging system, it may be desirable to have a store-and-forward implementation, rather than requiring sender and recipient to be online at the same time; loosening the bidirectionality requirement can also improve performance even where it is not a strict requirement, for example at connection establishment or resumption. These use cases have stimulated interest in non-interactive key exchange, and, as forward security is a desirable property in a key-exchange protocol, in non-interactive forward secrecy. [15] [16] This combination has been identified as desirable since at least 1996. [17] However, combining forward secrecy and non-interactivity has proven challenging; [18] it had been suspected that forward secrecy with protection against replay attacks was impossible non-interactively, but it has been shown to be possible to achieve all three desiderata. [14]
Broadly, two approaches to non-interactive forward secrecy have been explored, pre-computed keys and puncturable encryption. [16]
With pre-computed keys, many key pairs are created and the public keys shared, with the private keys destroyed after a message has been received using the corresponding public key. This approach has been deployed as part of the Signal protocol. [19]
In puncturable encryption, the recipient modifies their private key after receiving a message in such a way that the new private key cannot read the message but the public key is unchanged. Ross J. Anderson informally described a puncturable encryption scheme for forward secure key exchange in 1997, [20] and Green & Miers (2015) formally described such a system, [21] building on the related scheme of Canetti, Halevi & Katz (2003), which modifies the private key according to a schedule so that messages sent in previous periods cannot be read with the private key from a later period. [18] Green & Miers (2015) make use of hierarchical identity-based encryption and attribute-based encryption, while Günther et al. (2017) use a different construction that can be based on any hierarchical identity-based scheme. [22] Dallmeier et al. (2020) experimentally found that modifying QUIC to use a 0-RTT forward secure and replay-resistant key exchange implemented with puncturable encryption incurred significantly increased resource usage, but not so much as to make practical use infeasible. [23]
Weak perfect forward secrecy
[ edit]
Weak perfect forward secrecy (Wpfs) is the weaker property whereby when agents' long-term keys are compromised, the secrecy of previously established session keys is guaranteed, but only for sessions in which the adversary did not actively interfere. This new notion, and the distinction between this and forward secrecy, was introduced by Hugo Krawczyk in 2005. [24] [25] This weaker definition implicitly requires that full (perfect) forward secrecy maintains the secrecy of previously established session keys even in sessions where the adversary did actively interfere or attempted to act as a man in the middle.
Protocols
[ edit]
Forward secrecy is present in several protocol implementations, such as SSH and IPsec (RFC 2412), though it is optional in the latter. Off-the-Record Messaging, a cryptography protocol and library for many instant messaging clients, as well as OMEMO which provides additional features such as multi-user functionality in such clients, both provide forward secrecy as well as deniable encryption.
In Transport Layer Security (TLS), cipher suites based on Diffie–Hellman key exchange (DHE- RSA, DHE- DSA) and elliptic curve Diffie–Hellman key exchange (ECDHE- RSA, ECDHE- ECDSA) are available. In theory, TLS can use forward secrecy since SSLv3, but many implementations do not offer forward secrecy or provided it with lower-grade encryption. [26] TLS 1.3 removed support for RSA for key exchange, leaving Diffie–Hellman (with forward secrecy) as the sole algorithm for key exchange. [27]
OpenSSL supports forward secrecy using elliptic curve Diffie–Hellman since version 1.0, [28] with a computational overhead of approximately 15% for the initial handshake. [29]
The Signal Protocol uses the Double Ratchet Algorithm to provide forward secrecy. [30]
On the other hand, among popular protocols currently in use, WPA Personal did not support forward secrecy before WPA3. [31]
Use
[ edit]
Since late 2011, Google provided forward secrecy with TLS by default to users of its Gmail service, Google Docs service, and encrypted search services. [28] Since November 2013, Twitter provided forward secrecy with TLS to its users. [32] Wikis hosted by the Wikimedia Foundation have all provided forward secrecy to users since July 2014, [33] and have required the use of forward secrecy since August 2018.
Facebook reported as part of an investigation into email encryption that, as of May 2014, 74% of hosts that support STARTTLS also provide forward secrecy. [34] TLS 1.3, published in August 2018, dropped support for ciphers without forward secrecy. As of February 2019 [update] , 96.6% of web servers surveyed support some form of forward secrecy, and 52.1% will use forward secrecy with most browsers. [35]
At WWDC 2016, Apple announced that all iOS apps would need to use App Transport Security (ATS), a feature which enforces the use of HTTPS transmission. Specifically, ATS requires the use of an encryption cipher that provides forward secrecy. [36] ATS became mandatory for apps on January 1, 2017. [37]
The Signal messaging application employs forward secrecy in its protocol, notably differentiating it from messaging protocols based on PGP. [38]
In one survey in June 2025 [update] , forward secrecy was supported by about 95% of popular websites when accessed with modern browsers, while 0.2% did not support it at all. [39]
See also
[ edit]
Forward anonymity
Diffie–Hellman key exchange
Elliptic curve Diffie–Hellman
Harvest now, decrypt later
References
[ edit]
↑ "Perfect Forward Secrecy Explained: How it Works, In IPsec, SSL". Bootcamp Security. 2024-10-17. Retrieved 2025-05-08.
↑ Boyd, Colin; Gellert, Kai (2021-04-19). "A Modern View on Forward Security". The Computer Journal. 64 (4): 639– 652. doi: 10.1093/comjnl/bxaa104. hdl: 11250/2730309. ISSN 0010-4620.
↑ Krawczyk, Hugo (2005), "Perfect Forward Secrecy", in van Tilborg, Henk C. A. (ed.), Encyclopedia of Cryptography and Security, Boston, MA: Springer US, pp. 457– 458, doi: 10.1007/0-387-23483-7_298, ISBN 978-0-387-23483-0 , retrieved 2025-05-08
↑ "/docs/man1.1.1/man3/SSL_set_tmp_dh.html". www.openssl.org. Retrieved 2024-05-25.
↑ "tls – Does Perfect Forward Secrecy (PFS) make Man-in-the-Middle (MitM) attacks more difficult?". Information Security Stack Exchange. Retrieved 2020-10-11.
↑ Günther, C. G. (1990). An identity-based key-exchange protocol. Advances in Cryptology EUROCRYPT '89 (LNCS 434). pp. 29– 37.
↑ Menzies, Alfred; van Oorscot, Paul C; Vanstone, SCOTT (1997). Handbook of Applied Cryptography. CRC Pres. ISBN 978-0-8493-8523-0 .
↑ Diffie, Whitfield; van Oorschot, Paul C.; Wiener, Michael J. (June 1992). "Authentication and Authenticated Key Exchanges" (PDF). Designs, Codes and Cryptography. 2 (2): 107– 125. CiteSeerX 10.1.1.59.6682. doi: 10.1007/BF00124891. S2CID 7356608. Retrieved 2013-09-07.
↑ Jablon, David P. (October 1996). "Strong Password-Only Authenticated Key Exchange". ACM Computer Communication Review. 26 (5): 5– 26. CiteSeerX 10.1.1.81.2594. doi: 10.1145/242896.242897. S2CID 2870433.
↑ "IEEE 1363-2000 – IEEE Standard Specifications for Public-Key Cryptography". IEEE. Retrieved 2018-06-14.
↑ Nilsson, Dennis K.; Roosta, Tanya; Lindqvist, Ulf; Valdes, Alfonso (2008-03-31). "Key management and secure software updates in wireless process control environments". Proceedings of the first ACM conference on Wireless network security. WiSec '08. Alexandria, VA, USA: Association for Computing Machinery. pp. 100– 108. doi: 10.1145/1352533.1352550. ISBN 978-1-59593-814-5 . S2CID 15382932.
↑ Boyd & Gellert 2020, p. 645.
↑ Boyd & Gellert 2020, p. 639-640.
Jump up to: 1 2 Günther et al. 2017, p. 1.
↑ Boyd & Gellert 2020, p. 640.
Jump up to: 1 2 Boyd & Gellert 2020, p. 643.
↑ Back 1996.
Jump up to: 1 2 Green & Miers 2015, p. 1.
↑ Boyd & Gellert 2020, p. 644-645.
↑ Anderson 2002.
↑ Boyd & Gellert 2020, p. 643-644.
↑ Günther et al. 2017, p. 5.
↑ Dallmeier et al. 2020, p. 18-19.
↑ Krawczyk, Hugo (2005). HMQV: A High-Performance Secure Diffie–Hellman Protocol. Advances in Cryptology – CRYPTO 2005. Lecture Notes in Computer Science. Vol. 3621. pp. 546– 566. doi: 10.1007/11535218_33. ISBN 978-3-540-28114-6 .
↑ Cremers, Cas; Feltz, Michèle (2015). "Beyond eCK: perfect forward secrecy under actor compromise and ephemeral-key reveal" (PDF). Designs, Codes and Cryptography. 74 (1): 183– 218. CiteSeerX 10.1.1.692.1406. doi: 10.1007/s10623-013-9852-1. hdl: 20.500.11850/73097. S2CID 53306672. Retrieved 8 December 2015.
↑ "Re: [ TLS] security levels for TLS". www.ietf.org.
↑ "A Detailed Look at RFC 8446 (a.k.a. TLS 1.3)". The Cloudflare Blog. 2018-08-10. Retrieved 2019-02-26.
Jump up to: 1 2 "Protecting data for the long term with forward secrecy". Retrieved 2012-11-05.
↑ Vincent Bernat (28 November 2011). "SSL/TLS & Perfect Forward Secrecy". Retrieved 2012-11-05.
↑ Unger, Nik; Dechand, Sergej; Bonneau, Joseph; Fahl, Sascha; Perl, Henning; Goldberg, Ian; Smith, Matthew (17–21 May 2015). "SoK: Secure Messaging". 2015 IEEE Symposium on Security and Privacy (PDF). San Jose, CA: Institute of Electrical and Electronics Engineers. p. 241. doi: 10.1109/SP.2015.22. ISBN 978-1-4673-6949-7 . S2CID 2471650. Retrieved 4 December 2015.
↑ "Wi-Fi Gets More Secure: Everything You Need to Know About WPA3 – IEEE Spectrum". IEEE. Retrieved 2024-05-04.
↑ Hoffman-Andrews, Jacob. "Forward Secrecy at Twitter". Twitter. Retrieved 25 November 2013.
↑ "Tech/News/2014/27 – Meta". Wikimedia Foundation. 2014-06-30. Retrieved 30 June 2014.
↑ "The Current State of SMTP STARTTLS Deployment". Facebook. Retrieved 7 June 2014.
↑ Qualys SSL Labs. "SSL Pulse". Archived from the original (3 February 2019) on 15 February 2019. Retrieved 25 February 2019.
↑ "iOS 9.0".
↑ "App Transport Security REQUIRED January 2017 | Apple Developer Forums". forums.developer.apple.com. Retrieved 2016-10-20.
↑ Evans, Jon (22 January 2017). "WhatsApp, Signal, and dangerously ignorant journalism". TechCrunch. Retrieved 18 April 2018.
↑ "SSL Pulse". Qualys SSL Labs. 2026-05-02. Archived from the original on 2026-05-02. Retrieved 2026-05-04.
Bibliography
[ edit]
Anderson, Ross (2002). "Two Remarks on Public Key Cryptology" (PDF).
Canetti, Ran; Halevi, Shai; Katz, Jonathan (2003). "A Forward-Secure Public-Key Encryption Scheme". Advances in Cryptology — EUROCRYPT 2003. Lecture Notes in Computer Science. Vol. 2656. pp. 255– 271. doi: 10.1007/3-540-39200-9_16. ISBN 978-3-540-14039-9 .
Green, Matthew D.; Miers, Ian (2015). "Forward Secure Asynchronous Messaging from Puncturable Encryption". 2015 IEEE Symposium on Security and Privacy. pp. 305– 320. doi: 10.1109/SP.2015.26. ISBN 978-1-4673-6949-7 . S2CID 9171925.
Günther, Felix; Hale, Britta; Jager, Tibor; Lauer, Sebastian (2017). "0-RTT Key Exchange with Full Forward Secrecy" (PDF).
Back, Adam (6 September 1996). "non-interactive forward secrecy". Cypherpunks (Mailing list).
Boyd, Colin; Gellert, Kai (24 August 2020). "A Modern View on Forward Security". The Computer Journal. 64 (4) (published April 2021): 639– 652. doi: 10.1093/comjnl/bxaa104. hdl: 11250/2730309. Retrieved 8 June 2021. {{ [cite journal](https://en.wikipedia.org/wiki/Template:Cite_journal)}} : CS1 maint: deprecated archival service ( link)
Dallmeier, Fynn; Drees, Jan P.; Gellert, Kai; Handrik, Tobias; Jager, Tibor; Klauke, Jonas; Nachtigall, Simon; Renzelmann, Timo; Wolf, Rudi (2020). "Forward-Secure 0-RTT Goes Live: Implementation and Performance Analysis in QUIC" (PDF).
External links
[ edit]
RFC 2412 IETF, H. Orman. The OAKLEY Key Determination Protocol
Perfect Forward Secrecy can block the NSA from secure web pages, but no one uses it Computerworld June 21, 2013
SSL: Intercepted today, decrypted tomorrow Netcraft June 25, 2013
Deploying Forward Secrecy SSL Labs June 25, 2013
SSL Labs test for web browsers
SSL Labs test for web servers
hide
v
t
e
TLS and SSL
Protocols and technologies
Transport Layer Security / Secure Sockets Layer (TLS/SSL)
Datagram Transport Layer Security (DTLS)
Server Name Indication (SNI)
Application-Layer Protocol Negotiation (ALPN)
DNS-based Authentication of Named Entities (DANE)
DNS Certification Authority Authorization (CAA)
HTTPS
HTTP Strict Transport Security (HSTS)
HTTP Public Key Pinning (HPKP)
OCSP stapling
Opportunistic TLS
Perfect forward secrecy
Public-key infrastructure
Automated Certificate Management Environment (ACME)
Certificate authority (CA)
CA/Browser Forum
Certificate policy
Certificate revocation
Certificate revocation list (CRL)
Online Certificate Status Protocol (OCSP)
OCSP stapling
Domain-validated certificate (DV)
Extended Validation Certificate (EV)
Public key certificate
Public-key cryptography
Public key infrastructure (PKI)
Root certificate
Self-signed certificate
See also
Domain Name System Security Extensions (DNSSEC)
Internet Protocol Security (IPsec)
Secure Shell (SSH)
History
Export of cryptography from the United States
Server-Gated Cryptography
Implementations
Bouncy Castle
BoringSSL
Botan
BSAFE
cryptlib
GnuTLS
JSSE
LibreSSL
MatrixSSL
mbed TLS
NSS
OpenSSL
Rustls
s2n-tls
SChannel
SSLeay
stunnel
wolfSSL
Notaries
Certificate Transparency
Convergence
HTTPS Everywhere
Vulnerabilities
Retrieved from " https://en.wikipedia.org/w/index.php?title=Forward_secrecy&oldid=1352447196"
Categories:
Key management
Public-key cryptography
Transport Layer Security
Hidden categories:
Articles with short description
Short description is different from Wikidata
Articles needing additional references from February 2018
All articles needing additional references
Articles containing potentially dated statements from February 2019
All articles containing potentially dated statements
Articles containing potentially dated statements from June 2025
CS1 maint: deprecated archival service
This page was last edited on 4 May 2026, at 06:42 (UTC).
Page was rendered with Parsoid.
Text is available under the Creative Commons Attribution-ShareAlike 4.0 License; additional terms may apply. By using this site, you agree to the Terms of Use and Privacy Policy. Wikipedia® is a registered trademark of the Wikimedia Foundation, Inc., a non-profit organization.
Privacy policy
About Wikipedia
Disclaimers
Contact Wikipedia
Legal & safety contacts
Code of Conduct
Developers
Statistics
Cookie statement
Mobile view
Search
Search [-]
Toggle the table of contents
Forward secrecy
22 languages Add topic 