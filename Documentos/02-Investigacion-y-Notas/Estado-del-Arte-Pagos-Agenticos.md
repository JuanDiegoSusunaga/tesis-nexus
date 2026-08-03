# Estado del Arte: Pagos Agénticos e IA Autónoma como Caso de Uso de NEXUS (Revisión 2026-08-03)

**Contexto:** Tesis NEXUS · Sustento bibliográfico del caso de uso "agentes de IA autónomos operando sobre QNexus" como motivación de TG2 (KeyGen-por-firma, métrica W, Deception Engine). Corte: agosto 2026.
**Metodología:** Tres revisiones paralelas con búsqueda web y verificación por lectura directa de las fuentes primarias más importantes: (1) protocolos de pago agéntico (Google AP2, Coinbase x402), (2) redes de tarjetas y fintech (Visa, Mastercard, OpenAI+Stripe, PayPal, Amazon, regulación EU), (3) seguridad (OWASP, prompt injection académico, papers de ataques a x402, zkML, TEE). Los hechos confirmados solo por fuente secundaria están marcados con ⚠️.

---

## 1. Resumen ejecutivo (veredicto)

| Iniciativa / literatura | Estado verificado (ago. 2026) | Relevancia para NEXUS/TG2 |
| :--- | :--- | :--- |
| **Google AP2** | Estándar en formación: anunciado 16-sep-2025 (60+ socios), spec v0.2, **donado a FIDO Alliance abr. 2026** (Mastercard y Visa presiden el Payments TWG). Sin cifras de adopción en fuente primaria. | Sus *mandates* firmados atacan el "intent binding" — el mismo problema que las subclaves por tarea acotan criptográficamente. Citar como estándar en formación. |
| **Coinbase x402** | Operativo: **~130M transacciones acumuladas a may-2026** (cifra académica independiente), x402 Foundation bajo Linux Foundation (abr. 2026). Volumen volátil y con hype de tokens. | Escala real de micropagos agénticos = el caso de estrés de KeyGen-por-firma. Es además el rail donde vive toda la literatura de ataques de 2026. |
| **Visa Intelligent Commerce / TAP / Connect** | Anuncios abr-2025 → oct-2025 → abr-2026; mayormente pilotos y rollout regional. | Validación bancaria del caso de uso; TAP estandariza identificación criptográfica de agentes. |
| **Mastercard Agent Pay** | Cardholders US habilitados (⚠️ nov-2025), Agent Toolkit como servidor **MCP**, alianza PayPal. Sin cifras públicas de uso. | Ídem; la tokenización agéntica es el análogo card-rail de las subclaves con alcance acotado. |
| **OpenAI + Stripe ACP / Instant Checkout** | Lanzado 29-sep-2025; **Instant Checkout RETIRADO el 4-mar-2026** (~12 comercios en vivo ⚠️; impuestos, fraude, inventario). El protocolo sigue, reorientado a discovery. | Evidencia primaria de que la capa de *ejecución* de pagos agénticos está inmadura → motiva la infraestructura de confianza que la tesis propone. |
| **OWASP (agéntico)** | Top 10 for Agentic Applications 2026 (dic-2025) + Agentic Threats & Mitigations v1.0 (feb-2025, T1–T15) + State of Agentic AI Security v2.01 (jun-2026: "documented attacks now exist across nearly every category"). | Modelo de amenaza citable del agente pagador: Tool Misuse, Intent Breaking, Identity Spoofing. |
| **Academia 2026 (x402 / SoK A2A)** | Tres papers arXiv 2026 analizan la seguridad de pagos agénticos; el SoK nombra brechas abiertas: *"weak intent binding, misuse under valid authorization, payment-service decoupling, limited accountability"*. **Ninguno toca PQC ni deception.** | **"Misuse under valid authorization" es el escenario que el honeytoken + sequencer-honeychecker detecta; "weak intent binding" es lo que KeyGen-por-firma con alcance por tarea acota.** Refuerza la intersección vacía de TG2 con literatura de 2026. |
| **zkML** | zkLLM (CCS 2024) escala a 13B parámetros; survey formal 2026. Lo que prueba: que la salida "was produced by the claimed computation" — **integridad de inferencia de un modelo comprometido, NO integridad de intención** (una inyección de prompt se probaría fielmente). | Solo Trabajo Futuro, con el encuadre honesto anterior. |
| **TEE** | Costan & Devadas (canónico) + survey 2026 de confidential computing para agentes (los agentes custodian credenciales; atestación = confianza verificable). | Sustenta la custodia de la semilla ξ fuera del alcance del agente (coherente con [Puffer23] y [RollupBoost25] ya citados). |

---

## 2. Frente 1 — Protocolos de pago agéntico

### 2.1 Google AP2 (Agent Payments Protocol)
- **Anuncio:** 16-sep-2025, blog de Google Cloud (S. Parikh, R. Surapaneni). [Anuncio](https://cloud.google.com/blog/products/ai-machine-learning/announcing-agents-to-payments-ap2-protocol) · Spec/GitHub Apache-2.0: [google-agentic-commerce/AP2](https://github.com/google-agentic-commerce/AP2) · [ap2-protocol.org](https://ap2-protocol.org/)
- **Núcleo técnico:** confianza vía *mandates* — **Intent Mandate** (petición inicial del usuario, contexto auditable) y **Cart Mandate** (registro inmutable de ítems/precio tras aprobación) — firmados como **Verifiable Digital Credentials**; la cadena intención→carrito→pago forma un *"non-repudiable audit trail"*. Dos modos: humano-presente y **delegado/humano-ausente** (el agente ejecuta cuando se cumplen reglas de precio/tiempo). Extensión de A2A y MCP; agnóstico al método de pago.
- **60+ socios en el lanzamiento:** Mastercard, PayPal, American Express, Adyen, Ant International, Coinbase, Etsy, Revolut, Salesforce, UnionPay, Worldpay, etc.
- **Extensión A2A x402** para pagos cripto, con Coinbase, Ethereum Foundation y MetaMask: [a2a-x402](https://github.com/google-agentic-commerce/a2a-x402) (flujo: merchant agent responde payment-required → client agent firma → settlement on-chain).
- **Estado 2026:** spec **v0.2** (soporta pagos "Human Not Present"; la terminología evolucionó a Checkout/Payment Mandate Open/Closed). **Donado a la FIDO Alliance** — press release FIDO 27-abr-2026 ([BusinessWire](https://www.businesswire.com/news/home/20260427506015/en/FIDO-Alliance-to-Develop-Standards-for-Trusted-AI-Agent-Interactions)), post de Google 28-abr-2026 ([blog.google](https://blog.google/products-and-platforms/platforms/google-pay/agent-payments-protocol-fido-alliance/)); working groups: Agentic Authentication TWG (chairs: CVS Health, Google, OpenAI) y Payments TWG (chairs: **Mastercard, Visa**); estándar "Verifiable Intent" co-desarrollado con Mastercard ([FIDO](https://fidoalliance.org/building-the-trust-layer-for-agentic-payments-with-ap2-and-verifiable-intent/)).
- ⚠️ Despliegues de producción (wallet PayPal, piloto Agent Pay, Shopify/BigCommerce) solo aparecen en fuentes secundarias; el post oficial de abr-2026 no da cifras de adopción. Citar AP2 como **estándar en formación**, no como despliegue.

### 2.2 Coinbase x402
- **Lanzamiento:** 6-may-2025, Coinbase Developer Platform; colaboradores AWS, **Anthropic**, Circle, NEAR. [Anuncio](https://www.coinbase.com/developer-platform/discover/launches/x402) · [Whitepaper](https://www.x402.org/x402-whitepaper.pdf) · [x402.org](https://x402.org)
- **Núcleo técnico:** reusa **HTTP 402 Payment Required** — cliente pide recurso → 402 con requirements → reenvío con payload de pago firmado → verificación (local o vía *facilitator*) → settlement on-chain → recurso. Sin cuentas ni API keys. Scheme **"exact"** en EVM: **EIP-3009 `transferWithAuthorization`** (firma 65 B + authorization from/to/value/validAfter/validBefore/nonce; el facilitator paga el gas), además Permit2 y ERC-7710; firmas EIP-712. [Spec del scheme](https://github.com/coinbase/x402/blob/main/specs/schemes/exact/scheme_exact_evm.md)
- **Settlement dominante:** USDC sobre Base (micropagos ~$0,01; también Solana/SVM, Stellar). SDKs TS/Python/Go.
- **Gobernanza:** intención de x402 Foundation anunciada por Coinbase+Cloudflare el 23-sep-2025 ([Cloudflare](https://blog.cloudflare.com/x402/) — Cloudflare añadió x402 a su Agents SDK y propuso el scheme "deferred"); **formalizada bajo la Linux Foundation el 2-abr-2026** (governing body: Coinbase, Cloudflare, Stripe; apoyos de Google, Microsoft, Visa). [Press LF](https://www.linuxfoundation.org/press/linux-foundation-is-launching-the-x402-foundation-and-welcoming-the-contribution-of-the-x402-protocol) · Repo canónico actual: [x402-foundation/x402](https://github.com/x402-foundation/x402) (`x402Version: 2`; V2 del 11-dic-2025 movió los pagos a headers HTTP, identidad wallet-based, discovery, CAIP multi-chain: [V2 launch](https://www.x402.org/writing/x402-v2-launch)).
- **Volumen — usar la cifra académica:** **~130M transacciones acumuladas a may-2026** (arXiv:2605.30998, independiente). The Block: 75M txns por solo ~$24M de valor a dic-2025 (micropagos reales) ([The Block](https://www.theblock.co/post/382284/)). Chainalysis: "100M agentic payments on Base" ([Chainalysis](https://www.chainalysis.com/blog/x402-agentic-payments-adoption/)).
- ⚠️ **Caveat de hype:** colapso de ~92% en transacciones diarias entre dic-2025 (~731k/día) y feb-2026 (~57k/día), ligado a especulación con tokens "x402" (fuente secundaria); "$600M annualized Q1 2026" es una anualización estimada, no volumen realizado. Tratar todas las cifras como direccionales, no auditadas; **no citar el "100M+" de marketing de x402.org**.

---

## 3. Frente 2 — Redes de tarjetas y fintech

### 3.1 Visa
- **Visa Intelligent Commerce** (30-abr-2025): "AI-Ready Cards" — credenciales tokenizadas para que el agente nunca maneje el PAN; autenticación de agente; límites de gasto por agente fijados por el consumidor; señales en tiempo real para disputas. Socios de IA nombrados en el press release: **Anthropic, IBM, Microsoft, Mistral AI, OpenAI, Perplexity, Samsung, Stripe**. [Press release](https://usa.visa.com/about-visa/newsroom/press-releases.releaseId.21361.html) — ⚠️ la lista de socios es de "colaboración/exploración", no integraciones en producción.
- **Visa Trusted Agent Protocol** (14-oct-2025, con Cloudflare como socio principal): estandariza la **identificación criptográfica de agentes ante comercios** — firmas por agente sobre **HTTP Message Signatures**, alineado con Web Bot Auth (IETF); transmite Agent Intent, Consumer Recognition y Payment Information. Feedback de Adyen, Coinbase, Fiserv, Microsoft, Shopify, Stripe, Worldpay, etc. [Press release](https://usa.visa.com/about-visa/newsroom/press-releases.releaseId.21716.html) · [Cloudflare](https://blog.cloudflare.com/secure-agentic-commerce/)
- **Estado 2026:** primeras transacciones de agentes completadas (dic-2025, [investor.visa.com](https://investor.visa.com/news/news-details/2025/Visa-and-Partners-Complete-Secure-AI-Transactions-Setting-the-Stage-for-Mainstream-Adoption-in-2026/default.aspx)); **Intelligent Commerce Connect** (8-abr-2026): gateway *network-agnostic* (acepta tarjetas no-Visa) con tokenización + controles + autenticación en una integración, en piloto ([press release](https://usa.visa.com/about-visa/newsroom/press-releases.releaseId.22276.html)). ⚠️ "Mainstream adoption in 2026" es lenguaje promocional; a mediados de 2026 sigue en piloto/rollout regional.

### 3.2 Mastercard
- **Agent Pay** (29-abr-2025): **Agentic Tokens** extienden la tokenización existente (MDES/passkeys) para iniciar pagos desde interfaces conversacionales sin exponer el número de tarjeta. Socios del anuncio: **Microsoft** (Azure OpenAI + Copilot Studio), **IBM** (watsonx Orchestrate, B2B), Braintree, Checkout.com. **OpenAI NO figura en el press release.** [Press release (espejo investor)](https://investor.mastercard.com/investor-news/investor-news-details/2025/Mastercard-Unveils-Agent-Pay-Pioneering-Agentic-Payments-Technology-to-Power-Commerce-in-the-Age-of-AI/default.aspx)
- **Sep-2025:** **Agent Toolkit** — servidor **MCP** que expone APIs de Mastercard a Claude, Cursor y GitHub Copilot ([repo](https://github.com/Mastercard/developers-agent-toolkit)); Agent Sign-Up; Insight Tokens; trabajo con FIDO en credenciales verificables. Pilotos con cardholders de **Citi y U.S. Bank**. [Press release](https://investor.mastercard.com/investor-news/investor-news-details/2025/Mastercard-Unveils-New-Tools-and-Collaborations-to-Power-Smarter-Safer-Agentic-Commerce/default.aspx)
- **Oct-2025:** alianza **Mastercard + PayPal** — Agent Pay en el wallet de PayPal; "Agent Pay Acceptance Framework". [PayPal newsroom](https://newsroom.paypal-corp.com/2025-10-27-Mastercard-and-PayPal-Join-Forces-To-Accelerate-Secure-Global-Agentic-Commerce)
- **Estado 2026:** habilitación de cardholders US ⚠️ ~nov-2025 (compromiso "holiday season"; mes exacto de fuentes secundarias); **Agent Suite** empresarial en ene-2026 ([press](https://www.mastercard.com/us/en/news-and-trends/press/2026/january/mastercard-launches-agent-suite-to-ready-enterprises-for-a-new-e.html)). ⚠️ Habilitación ≠ uso: sin cifras públicas de transacciones agénticas.

### 3.3 OpenAI + Stripe — Agentic Commerce Protocol (ACP) / Instant Checkout
- **Anuncio:** 29-sep-2025 — "Buy it in ChatGPT" (compras a vendedores de Etsy en el chat; ">1M comercios Shopify coming soon"). Spec open-source co-mantenida: [agentic-commerce-protocol](https://github.com/agentic-commerce-protocol/agentic-commerce-protocol) · [Stripe newsroom](https://stripe.com/newsroom/news/stripe-openai-instant-checkout) · cobertura [CNBC](https://www.cnbc.com/2025/09/29/chatgpt-instant-checkout-etsy-shopify.html)
- **Núcleo técnico:** **Shared Payment Token (SPT)** — Stripe emite un token acotado al comercio específico y al total del carrito; el comercio sigue siendo *merchant of record*. **Delegated Payment Spec** con *allowance constraints* (límites temporales y monetarios): [spec](https://developers.openai.com/commerce/specs/payment). Diferencia con AP2: ACP = modelo de interacción del checkout (agente↔comercio); AP2 = capa de autorización con mandates firmados. No son excluyentes.
- **⭐ Dato clave — RETIRO:** **OpenAI retiró Instant Checkout el 4-mar-2026** (~5 meses tras el lanzamiento): *"the initial version… did not offer the level of flexibility that we aspire to provide"*; solo ⚠️ ~12 comercios Shopify llegaron a estar en vivo; problemas citados: sales tax, fraude, sincronización de inventario. [Forbes](https://www.forbes.com/sites/jasongoldberg/2026/03/10/why-openais-checkout-retreat-spells-trouble-for-its-commerce-strategy/). El protocolo sigue activo reorientado a *discovery* (Target, Sephora, Nordstrom… ⚠️ lista de fuente secundaria). **Uso para la tesis:** evidencia primaria de inmadurez de la capa de ejecución → falta infraestructura de confianza, que es el hueco que QNexus/TG2 argumenta.

### 3.4 Otros y frente regulatorio (una línea cada uno)
- **PayPal:** Agent Toolkit + servidor MCP remoto (Dev Days, abr-2025); **Agentic Commerce Services** (28-oct-2025, disponible early 2026). [Newsroom](https://newsroom.paypal-corp.com/2025-10-28-PayPal-Launches-Agentic-Commerce-Services-to-Power-AI-Driven-Shopping)
- **Amazon "Buy for Me"** (piloto, 3-abr-2025): agente compra en sitios de terceros usando Amazon Nova + **Claude de Anthropic**; datos de pago cifrados. [Retail Dive](https://www.retaildive.com/news/amazon-buy-for-me-agentic-ai-third-party-sites/745047/)
- **Regulación EU:** PSD3 (en negociación desde 2026) discute la iniciación delegada de pagos y la responsabilidad en transacciones iniciadas por IA ([Osborne Clarke](https://www.osborneclarke.com/insights/agentic-payments-new-challenge-europes-payments-ecosystem)); discursos ECB (24-feb-2026) y Sarah Breeden/BoE (Sintra, 30-jun-2026: la regulación actual no contempla agentes autónomos — [BoE](https://www.bankofengland.co.uk/speech/2026/june/sarah-breeden-panel-at-the-european-central-bank-forum-on-central-banking-2026)). ⚠️ **No hay texto normativo vigente** específico para pagos agénticos: citar como discusión regulatoria, nunca como norma.

---

## 4. Frente 3 — Seguridad: OWASP y academia

### 4.1 OWASP
- **[OWASP-LLM25] Top 10 for LLM Applications 2025** (publicado nov-2024 ⚠️ fecha exacta de sello del PDF 2024-11-14): **"LLM01:2025 Prompt Injection"** #1 por segunda edición consecutiva; define inyección **directa** ("a user's prompt input directly alters the behavior of the model") e **indirecta** ("an LLM accepts input from external sources, such as websites or files"). [Recurso](https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/) · [LLM01](https://genai.owasp.org/llmrisk/llm01-prompt-injection/) — **cita para definir prompt injection.**
- **[OWASP-ASI26] Top 10 for Agentic Applications 2026** (9-dic-2025): lista nueva y separada — Agent Goal Hijack, **Tool Misuse & Exploitation**, Agent Identity & Privilege Abuse, Memory & Context Poisoning, Rogue Agents. [Anuncio](https://genai.owasp.org/2025/12/09/owasp-genai-security-project-releases-top-10-risks-and-mitigations-for-agentic-ai-security/) · [Recurso](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/) — ⚠️ códigos oficiales (ASI01…) no verificados en primaria, solo nombres. **Mejor cita para el modelo de amenaza del agente pagador.**
- **[OWASP-ATM25] "Agentic AI — Threats and Mitigations" v1.0** (17-feb-2025): taxonomía de 15 amenazas T1–T15; relevantes para un agente de pagos: **T1 Memory Poisoning, T2 Tool Misuse, T6 Intent Breaking & Goal Manipulation, T9 Identity Spoofing**. [Recurso](https://genai.owasp.org/resource/agentic-ai-threats-and-mitigations/) — ⚠️ nombres T1–T15 consistentes en múltiples secundarias, no extraídos del PDF oficial.
- **"State of Agentic AI Security and Governance" v2.01** (⚠️ 1-jun-2026): basado en incidentes reales — *"documented attacks now exist across nearly every category"*; añade tracker de incidentes y modelo de madurez. [Recurso](https://genai.owasp.org/resource/state-of-agentic-ai-security-and-governance/)

### 4.2 Prompt injection — anclas académicas
- **[GAM+23] Greshake et al.**, *Not What You've Signed Up For…* (ACM AISec 2023, DOI 10.1145/3605764.3623985, arXiv:2302.12173): introduce la **inyección indirecta** y su taxonomía de seguridad. [arXiv](https://arxiv.org/abs/2302.12173)
- **[DSF+25] Debenedetti et al.** (DeepMind + ETH), *Defeating Prompt Injections by Design* — **CaMeL**: capa protectora que separa flujos de control y de datos alrededor del LLM; 67% de tareas resueltas con seguridad demostrable en AgentDojo. arXiv:2503.18813 (⚠️ citar como preprint; venue no verificado). [Código](https://github.com/google-research/camel-prompt-injection)
- **[BBC+25] Beurer-Kellner et al.**, *Design Patterns for Securing LLM Agents against Prompt Injections* — patrones con resistencia fundamentada, trade-offs utilidad/seguridad. arXiv:2506.08837.

### 4.3 Papers 2026 sobre pagos agénticos (la conexión directa con TG2)
- **[LWW26]** Li, Wang, Wang. *Five Attacks on x402 Agentic Payment Protocol* (arXiv:2605.11781, may-2026): análisis formal de x402; 5 ataques concretos (autorización, binding, replay, capa web) **validados en redes reales**.
- **[LHD+26]** Ling et al. *Free-Riding the Agentic Web: A Systematic Security Analysis of x402 Payments* (arXiv:2605.30998, may/jun-2026): 4 clases de fallos — cross-resource substitution, duplicate-settlement race, allowance overdraft, denial of settlement — con fuga de recursos de hasta 100%; fuente de la cifra **~130M txns**.
- **[ZXL+26]** Zhang et al. *SoK: Blockchain Agent-to-Agent Payments* (arXiv:2604.03733, abr-2026): sistematiza el ciclo discovery→authorization→execution→accounting e identifica las brechas abiertas del campo: *"**weak intent binding, misuse under valid authorization**, payment-service decoupling, and limited accountability"*.
- **Lectura para la tesis:** *misuse under valid authorization* = el atacante (p. ej. vía prompt injection) hace que el agente firme algo **válido** pero no deseado — exactamente el escenario que el **honeytoken + sequencer-honeychecker** detecta; *weak intent binding* = lo que **KeyGen-por-firma con alcance por tarea** acota; *limited accountability* = lo que la **métrica W** cuantifica. **Ninguno de los tres papers toca PQC ni deception** → la intersección vacía de TG2 queda reforzada con literatura de 2026.
- ⚠️ El incidente "wallet de Grok, $175K (may-2026)" circula solo en medios cripto — **no citable** sin verificación adicional.

---

## 5. Frente 4 — zkML y TEE (solo Trabajo Futuro, con encuadre honesto)

### 5.1 zkML
- **[SLZ24]** Sun, Li, Zhang. *zkLLM: Zero Knowledge Proofs for Large Language Models* (ACM CCS 2024, DOI 10.1145/3658644.3670334, arXiv:2404.16109): primeras pruebas ZK para LLMs de 13B parámetros (CUDA). [Código](https://github.com/jvhs0706/zkllm-ccs2024)
- **[PZW+26]** Peng et al. *A Survey of Zero-Knowledge Proof Based Verifiable Machine Learning* (arXiv:2502.18535; *Artificial Intelligence Review* 59:157, 2026).
- **EZKL** (Zkonduit; Halo2, entrada ONNX, v21 auditada por Trail of Bits — citar como software: [repo](https://github.com/zkonduit/ezkl)) · **Modulus Labs**, *The Cost of Intelligence* (2023; ahora [IACR ePrint 2026/1063](https://eprint.iacr.org/2026/1063)): primer benchmark de sistemas ZK sobre primitivas de ML.
- **Qué prueba zkML (de los propios abstracts):** que el resultado *"was produced by the claimed computation"* — **integridad de inferencia de un modelo comprometido**, sin revelar pesos. **NO prueba que la entrada no fuera un prompt inyectado** (probaría fielmente la inferencia sobre la entrada maliciosa). Redactar cualquier mención en Trabajo Futuro con esta distinción: integridad de inferencia ≠ integridad de intención.

### 5.2 TEE
- **[CD16]** Costan, Devadas. *Intel SGX Explained* (IACR ePrint 2016/086): garantías de integridad/confidencialidad aun con todo el software privilegiado malicioso. [ePrint](https://eprint.iacr.org/2016/086)
- **[FKH26]** Forough, Kogias, Haddadi. *When Agents Handle Secrets: A Survey of Confidential Computing for Agentic AI* (arXiv:2605.03213, may-2026): los agentes acumulan contexto sensible y **custodian credenciales**; la atestación remota de TEEs *"enables verifiable trust across distributed deployments"* — sustenta directamente "la semilla ξ vive fuera del alcance del agente". Coherente con [Puffer23] y [RollupBoost25] ya en la bibliografía.

---

## 6. Mapa de uso en la tesis

| Dónde | Qué citar | Para qué afirmación |
| :--- | :--- | :--- |
| **Cap1 / Intro TG2** | [AP2-25] [x402-25] [VisaIC25] [AgentPay25] [ACP25] [LHD+26] | "Los pagos agénticos ya operan a escala (~130M txns) pero la infraestructura es inmadura (retiro de Instant Checkout, mar-2026)" |
| **Modelo de amenaza** | [OWASP-ASI26] [OWASP-ATM25] [OWASP-LLM25] [GAM+23] | Tool Misuse / Intent Breaking / inyección indirecta como riesgos del agente pagador |
| **Discusión (primitivas→riesgos)** | [ZXL+26] + benchmarks propios (187,3×; +0,75 ms; W) | "Misuse under valid authorization" → honeytoken/honeychecker; "weak intent binding" → subclaves por tarea; "limited accountability" → métrica W |
| **Estado del arte TG2** | [LWW26] [LHD+26] [ZXL+26] | Intersección vacía: la literatura de seguridad de pagos agénticos (2026) no toca PQC ni deception |
| **Trabajo Futuro** | [SLZ24] [PZW+26] [DSF+25] [BBC+25] [CD16] [FKH26] | zkML (integridad de inferencia, no de intención), defensas por diseño contra prompt injection, custodia de semilla en TEE |

---

## 7. Precauciones (qué NO citar / cómo cubrirse)

1. **Cifras de marketing:** no citar "100M+" de x402.org ni "1M de comercios Shopify" de ACP; usar ~130M de [LHD+26] y el retiro de Instant Checkout como hechos.
2. **Volatilidad x402:** el pico de otoño-2025 estuvo ligado a especulación con tokens; caída ~92% dic-2025→feb-2026 (secundaria). Citar volumen como direccional.
3. **Hechos solo de fuente secundaria (marcados ⚠️ arriba):** nombres T1–T15 del PDF de OWASP; despliegues de producción de AP2; mes exacto (nov-2025) del rollout US de Agent Pay; ~12 comercios de Instant Checkout; lista de retailers ACP-discovery; fecha exacta del State of Agentic AI v2.01.
4. **No citable:** incidente del wallet de Grok (solo medios cripto); venue de conferencia de CaMeL (citar como arXiv).
5. **Regulación:** PSD3/ECB/BoE son discusión y discursos, no norma vigente.
6. **Errores a evitar heredados del borrador analizado:** OpenAI no es socio del anuncio de Mastercard Agent Pay; zkML no protege contra prompt injection; los honeytokens detectan (no "congelan en tiempo real"); "miles de tx/s" es objetivo arquitectónico, no capacidad medida del PoC.
