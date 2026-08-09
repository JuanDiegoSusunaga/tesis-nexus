# Bibliografía

> *Bibliografía consolidada del trabajo. Cada obra se define una sola vez bajo su clave de cita; las listas «Referencias del capítulo» que cierran cada capítulo son índices locales que remiten a esta sección. **Toda obra listada abajo se invoca en los Capítulos 1–7**, por su clave o por su designación en prosa (el caso de los estándares NIST/IETF y de las fuentes de industria). Las fuentes revisadas para la línea de trabajo aún no incorporada al manuscrito se recogen, declaradas como tales, en el **anexo bibliográfico** al final.*

## Artículos, libros y actas

- **[BDF+11]** D. Boneh, Ö. Dagdelen, M. Fischlin, A. Lehmann, C. Schaffner, M. Zhandry. *Random Oracles in a Quantum World*. ASIACRYPT 2011.
- **[BDGL16]** A. Becker, L. Ducas, N. Gama, T. Laarhoven. *New Directions in Nearest Neighbor Searching with Applications to Lattice Sieving*. SODA 2016. *(constante clásica de tamizado 0,292)*
- **[BSCIKS20]** E. Ben-Sasson, D. Carmon, Y. Ishai, S. Kopparty, S. Saraf. *Proximity Gaps for Reed–Solomon Codes*. FOCS 2020. *(2 bits de soundness por consulta a* rate *ρ en FRI)*
- **[Buterin21]** V. Buterin. *An Incomplete Guide to Rollups*. 2021.
- **[CD16]** V. Costan, S. Devadas. *Intel SGX Explained*. Cryptology ePrint Archive 2016/086, 2016. *(referencia canónica de TEE: integridad y confidencialidad aun con el software privilegiado comprometido)*
- **[D+18]** L. Ducas, E. Kiltz, T. Lepoint, V. Lyubashevsky, P. Schwabe, G. Seiler, D. Stehlé. *CRYSTALS-Dilithium: A Lattice-Based Digital Signature Scheme*. IACR Transactions on Cryptographic Hardware and Embedded Systems (ToCHES) 2018(1), pp. 238–268.
- **[ADP18]** M. R. Albrecht, A. Deo, K. G. Paterson. *Cold Boot Attacks on Ring and Module LWE Keys Under the NTT*. IACR TCHES 2018. *(extracción de claves reticulares desde volcados de RAM)*
- **[BRS22]** J. W. Bos, J. Renes, A. Sprenkels. *Dilithium for Memory Constrained Devices*. AFRICACRYPT 2022. *(re-derivación on-the-fly por escasez de RAM en embebidos)*
- **[Gro96]** L. K. Grover. *A Fast Quantum Mechanical Algorithm for Database Search*. STOC 1996.
- **[JR13]** A. Juels, R. L. Rivest. *Honeywords: Making Password-Cracking Detectable*. ACM CCS 2013. *(patrón honeychecker: el backend detecta el uso del señuelo)*
- **[KLS18]** E. Kiltz, V. Lyubashevsky, C. Schaffner. *A Concrete Treatment of Fiat-Shamir Signatures in the Quantum Random-Oracle Model*. EUROCRYPT 2018.
- **[Kup05]** G. Kuperberg. *A Subexponential-Time Quantum Algorithm for the Dihedral Hidden Subgroup Problem*. SIAM Journal on Computing 35(1), 2005. *(barrera del HSP diédrico)*
- **[Laa15]** T. Laarhoven. *Search Problems in Cryptography* (tamizado cuántico para SVP). Tesis doctoral, TU Eindhoven, 2015. *(constante cuántica de tamizado 0,265)*
- **[LS15]** A. Langlois, D. Stehlé. *Worst-Case to Average-Case Reductions for Module Lattices*. Designs, Codes and Cryptography 75(3), pp. 565–599, 2015.
- **[Lyu09]** V. Lyubashevsky. *Fiat-Shamir with Aborts: Applications to Lattice and Factoring-Based Signatures*. ASIACRYPT 2009. *(origen de la técnica rejection-sampling / aborts)*
- **[Lyu12]** V. Lyubashevsky. *Lattice Signatures without Trapdoors*. EUROCRYPT 2012. *(esquema del que desciende Dilithium)*
- **[Pei16]** C. Peikert. *A Decade of Lattice Cryptography*. Foundations and Trends in Theoretical Computer Science, 2016.
- **[Reg09]** O. Regev. *On Lattices, Learning with Errors, Random Linear Codes, and Cryptography*. Journal of the ACM 56(6), 2009.
- **[Sawa25]** Y. Sawa et al. *Analysis of Encryption Key Zeroization from a System-Wide Perspective*. ACSAC 2025. *(medición empírica de la residencia de claves en RAM)*
- **[Sho97]** P. W. Shor. *Polynomial-Time Algorithms for Prime Factorization and Discrete Logarithms on a Quantum Computer*. SIAM Journal on Computing 26(5), 1997.
- **[Yang23]** Z. Yang, H. Alfauri, B. Farkiani, R. Jain, R. Di Pietro, A. Erbad. *A Survey and Comparison of Post-Quantum and Quantum Blockchains*. IEEE Communications Surveys & Tutorials, 2023.

## Estándares (NIST / IETF)

- **[FIPS203]** NIST. *FIPS 203: Module-Lattice-Based Key-Encapsulation Mechanism Standard (ML-KEM)*. 2024.
- **[NIST24]** NIST. *FIPS 204: Module-Lattice-Based Digital Signature Standard (ML-DSA)*. 2024. *(estándar del esquema de firma usado por NEXUS; implementado vía el crate `fips204`)*
- **[FIPS205]** NIST. *FIPS 205: Stateless Hash-Based Digital Signature Standard (SLH-DSA)*. 2024.
- **[FIPS206]** NIST. *FIPS 206: FN-DSA (Falcon)* — borrador (estandarización ~fin 2026).
- **[SP800-90B]** M. S. Turan et al. *NIST SP 800-90B: Recommendation for the Entropy Sources Used for Random Bit Generation*. NIST, 2018. *(min-entropía y pruebas de salud RCT/APT; complementan SP 800-90A/C sobre DRBG y construcciones RBG)*
- **[SP800-108]** NIST. *SP 800-108: Recommendation for Key Derivation Using Pseudorandom Functions*.
- **[RFC5869]** H. Krawczyk. *Cryptographic Extraction and Key Derivation: The HKDF Scheme*. CRYPTO 2010 (RFC 5869).
- **[RFC9881]** J. Massimo, P. Kampanakis, S. Turner, B. Westerbaan. *RFC 9881: Internet X.509 PKI — Algorithm Identifiers for ML-DSA*. IETF, 2025. *(la semilla ξ como formato RECOMENDADO de clave privada ML-DSA)*
- **[DORA22]** Parlamento Europeo y Consejo. *Reglamento (UE) 2022/2554 relativo a la resiliencia operativa digital del sector financiero (DORA)*; art. 9(2) — obligación de sostener la disponibilidad, **autenticidad, integridad** y confidencialidad de los datos; normas técnicas de desarrollo desde ene. 2024. *(fundamento normativo del requisito R1, Cap. 1 §1.3)*
- **[Connolly26]** D. Connolly. *ML-DSA Security Considerations*. draft-connolly-cfrg-ml-dsa-security-considerations, IETF (borrador), 2026. *(recomienda seed-only; sugiere cachear la clave expandida durante las operaciones — contrapunto de la política de §5.6)*

## Fuentes del sector financiero (banca central, supervisión y marcos de migración)

- **[BIS-Leap23]** BIS Innovation Hub, Banque de France, Deutsche Bundesbank (Fase 1, 2023); con Banca d'Italia, Nexi-Colt y Swift (Fase 2, *Quantum-proofing payment systems*). *Project Leap: Quantum-proofing the financial system*. bis.org/about/bisih/topics/cyber_security/leap.htm. Acceso: ago. 2026. *(Fase 2 sustituyó las firmas digitales clásicas por post-cuánticas en un sistema de pagos operativo: viabilidad demostrada, con tiempos de procesamiento significativamente mayores — véase el contraste de Cap. 6, §6.6.2)*
- **[BIS-Roadmap25]** Bank for International Settlements. *Roadmap to quantum-readiness* (jul. 2025) y *Quantum computing and the financial system: opportunities and risks* (oct. 2024). *(inventario criptográfico, cripto-agilidad, defensa en profundidad y migración por fases como condiciones de la transición)*
- **[PQFIF25]** D. B. Corvelo Costa et al. *Post-Quantum Financial Infrastructure Framework (PQFIF): A Roadmap for the Quantum-Safe Transition of Global Financial Infrastructure*. Aportación escrita a la *U.S. Crypto Assets Task Force*, SEC, sep. 2025. sec.gov. *(propuesta de marco presentada al regulador —**no** es regulación vigente—; prioriza custodia (SAB 121) e infraestructura crítica de mercado (Regulation SCI), con HSM, rotación automatizada y* audit trail *inmutable)*

## Fuentes del estado del arte (industria; estado a mediados de 2026)

- **[EthRoadmap26]** Ethereum Foundation. *Roadmap — Future-proofing: Quantum resistance* (Lean Consensus / leanXMSS; leanVM; abstracción de cuentas EIP-7702, EIP-8141). ethereum.org/roadmap/future-proofing/quantum-resistance. Acceso: jun. 2026.
- **[Fusaka25]** Ethereum Foundation. *Fusaka Mainnet — PeerDAS (EIP-7594)*. Nov. 2025.
- **[Solana-QR26]** Solana / Anza. *Quantum Readiness* (Falcon; Winternitz Vault) y *Alpenglow* (Votor/Rotor, 2025–2026). Acceso: jun. 2026.
- **[US10521584]** N. Sharifi Mehr (Amazon Technologies). *Computer Threat Analysis Service*. Patente US 10,521,584 B1, 2019. *(claves criptográficas señuelo detectadas por el backend al verificar la firma — prior art más cercano del Deception Engine)*
- **[Puffer23]** Puffer Finance. *Secure-Signer + RAVe* (claves de validador selladas en SGX; atestación remota verificada on-chain). 2023–2025.
- **[RollupBoost25]** Flashbots. *Rollup-Boost* (block builder de L2 en TEE, desplegado en Unichain). 2025.

---

## Anexo bibliográfico — fuentes de la línea de trabajo en curso (TG2)

> *Las obras de esta sección **no se citan en los Capítulos 1–7**. Corresponden a la revisión del estado del arte de pagos agénticos (ago. 2026, documento companion `Estado-del-Arte-Pagos-Agenticos`), que sustenta el caso de uso en desarrollo para TG2 y todavía no está incorporado al manuscrito. Se listan aquí, separadas y declaradas como tales, para dejar constancia del trabajo de revisión sin inflar la bibliografía del cuerpo del documento; migrarán a la sección correspondiente cuando el caso de uso se integre al texto.*

### Artículos y actas

- **[BBC+25]** L. Beurer-Kellner, B. Buesser, A.-M. Creţu, E. Debenedetti et al. *Design Patterns for Securing LLM Agents against Prompt Injections*. arXiv:2506.08837, 2025. *(patrones de diseño con resistencia fundamentada a la inyección de prompts)*
- **[DSF+25]** E. Debenedetti, I. Shumailov, T. Fan, J. Hayes, N. Carlini et al. *Defeating Prompt Injections by Design*. arXiv:2503.18813, 2025. *(CaMeL: separación de flujos de control y de datos alrededor del LLM)*
- **[FKH26]** J. Forough, M. Kogias, H. Haddadi. *When Agents Handle Secrets: A Survey of Confidential Computing for Agentic AI*. arXiv:2605.03213, 2026. *(custodia de credenciales por agentes; atestación TEE como confianza verificable)*
- **[GAM+23]** K. Greshake, S. Abdelnabi, S. Mishra, C. Endres, T. Holz, M. Fritz. *Not What You've Signed Up For: Compromising Real-World LLM-Integrated Applications with Indirect Prompt Injection*. ACM AISec 2023. *(introduce la inyección indirecta de prompts)*
- **[LHD+26]** S. Ling, Y. Huang, Y. Du, Y. Chen, Y. Zhou, L. Wu, C. Wang. *Free-Riding the Agentic Web: A Systematic Security Analysis of x402 Payments*. arXiv:2605.30998, 2026. *(~130M de transacciones x402; 4 clases de vulnerabilidades con fuga de hasta 100%)*
- **[LWW26]** Z. Li, Q. Wang, Z. Wang. *Five Attacks on x402 Agentic Payment Protocol*. arXiv:2605.11781, 2026. *(cinco ataques concretos validados en redes reales)*
- **[PZW+26]** Z. Peng, C. Zhao, T. Wang et al. *A Survey of Zero-Knowledge Proof Based Verifiable Machine Learning*. Artificial Intelligence Review 59:157, 2026. *(zkML prueba que la salida proviene del cómputo declarado — integridad de inferencia, no de intención)*
- **[SLZ24]** H. Sun, J. Li, H. Zhang. *zkLLM: Zero Knowledge Proofs for Large Language Models*. ACM CCS 2024. *(primeras pruebas ZK para LLMs de 13B parámetros)*
- **[ZXL+26]** Y. Zhang, Y. Xiang, Y. Lei, Q. Wang et al. *SoK: Blockchain Agent-to-Agent Payments*. arXiv:2604.03733, 2026. *(brechas abiertas del campo: weak intent binding, misuse under valid authorization, limited accountability)*

### Informes de seguridad (OWASP)

- **[OWASP-LLM25]** OWASP GenAI Security Project. *OWASP Top 10 for LLM Applications 2025*. Nov. 2024. genai.owasp.org. *(LLM01:2025 Prompt Injection — #1 por segunda edición consecutiva; distinción entre inyección directa e indirecta)*
- **[OWASP-ASI26]** OWASP GenAI Security Project. *OWASP Top 10 for Agentic Applications 2026*. Dic. 2025. genai.owasp.org. *(riesgos agénticos: Tool Misuse, Agent Goal Hijack, Identity & Privilege Abuse, Memory Poisoning)*
- **[OWASP-ATM25]** OWASP Agentic Security Initiative. *Agentic AI — Threats and Mitigations*, v1.0. Feb. 2025. genai.owasp.org. *(taxonomía T1–T15; T2 Tool Misuse, T6 Intent Breaking y T9 Identity Spoofing aplican al agente pagador; actualizado por «State of Agentic AI Security and Governance» v2.01, jun. 2026)*

### Protocolos de pago agéntico (industria)

- **[AP2-25]** Google Cloud. *Agent Payments Protocol (AP2)* — mandates firmados como credenciales digitales verificables; 60+ socios. Anunciado 16 sep. 2025; donado a la FIDO Alliance en abr. 2026. github.com/google-agentic-commerce/AP2. Acceso: ago. 2026.
- **[x402-25]** Coinbase. *x402: An Open Standard for Internet-Native Payments* (whitepaper, mayo 2025) — HTTP 402 + EIP-3009; micropagos USDC/Base. x402 Foundation bajo la Linux Foundation desde abr. 2026. x402.org. Acceso: ago. 2026. *(~130M de transacciones acumuladas a may. 2026 según [LHD+26]; no usar cifras de marketing)*
- **[VisaIC25]** Visa. *Visa Intelligent Commerce* (abr. 2025) y *Trusted Agent Protocol* (oct. 2025, con Cloudflare; identificación criptográfica de agentes vía HTTP Message Signatures). Acceso: ago. 2026.
- **[AgentPay25]** Mastercard. *Agent Pay* (abr. 2025; Agentic Tokens) y *Agent Toolkit* MCP (sep. 2025). Acceso: ago. 2026.
- **[ACP25]** OpenAI + Stripe. *Agentic Commerce Protocol / Instant Checkout* (sep. 2025; Shared Payment Tokens acotados por comercio y monto). Instant Checkout retirado en mar. 2026. Acceso: ago. 2026. *(evidencia de inmadurez de la capa de ejecución de pagos agénticos)*

> *Documentos companion del trabajo (no publicados): `Analisis-Overhead-PQC-DualChain` (argumentación cuantificada del overhead), `Ideas-Ethereum-Solana-para-NEXUS` (validación detallada de las fuentes de la industria), `Estado-del-Arte-Claves-Efimeras-y-Deception` (revisión con fuentes verificadas, jul. 2026, que sustenta §5.6 y §7.5) y `Estado-del-Arte-Pagos-Agenticos` (revisión ago. 2026: protocolos de pago agéntico, OWASP y literatura x402/zkML/TEE que sustenta el caso de uso agéntico).*
