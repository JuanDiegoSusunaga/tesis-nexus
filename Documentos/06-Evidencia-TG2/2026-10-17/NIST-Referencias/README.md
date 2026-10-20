# Revisión de fuentes oficiales NIST para TG2

Consulta: 17 de octubre de 2026, hora de Bogotá. Se conservan doce fuentes
con URL, fecha de descarga y SHA-256 en [fuentes.json](fuentes.json).
Esta revisión documental mantiene **1707 resultados en 191 módulos**, 32 modelos
verificados en su alcance y ocho grupos parciales. No añade resultados Lean,
validación ACVP, calificación de fuente ni dictamen independiente.

## Firma ML-DSA y erratas

[FIPS 204](https://csrc.nist.gov/pubs/fips/204/final) sigue identificado como
final de agosto de 2024; su ficha enlaza posibles correcciones de julio de 2026.
El PDF actual coincide con R1 y la hoja de erratas coincide byte por byte con
las copias de septiembre y del 12 de octubre: [comparación](comparacion-errata.json).
Se mantiene la revisión previa sobre una sola evaluación NTT, M', orden mu||w1,
Montgomery y rechazo. Las cifras propuestas de repeticiones son 4.36/5.14/3.91
y el límite mínimo propuesto de iteraciones es 821; son posibles correcciones,
no una nueva versión oficial ni una probabilidad del backend demostrada aquí.
La [extracción previa de erratas](../../2026-09-22/R1-correspondencia/errata-fips204.json)
conserva sus localizadores; no se modifica la hoja.

## Entropía y pruebas de salud

[SP 800-90B](https://csrc.nist.gov/pubs/sp/800/90/b/final), secciones 4.4.1–4.4.2,
da el corte RCT y el pseudocódigo APT con referencia incluida en B=1 y W-1
muestras posteriores. Las páginas 25–27 se [renderizaron](visual/salud-34.png)
y revisaron. El perfil H=7.5, alpha=2^-20 corresponde a RCT=4 y al APT=16
certificado en [RCT.lean](../../../../formalizacion/Nexus/Salud/RCT.lean) y
[APT.lean](../../../../formalizacion/Nexus/Salud/APT.lean), con sus hipótesis.
La tabla 2 no contiene una fila H=7.5: APT=16 procede del cálculo del perfil.

Las [dos erratas](https://csrc.nist.gov/files/pubs/sp/800/90/b/final/docs/sp800-90b_errata_potential_updates.pdf)
del 29 de mayo de 2025 afectan 5.2.4 y 6.3.1: valor crítico 27.877 y ejemplo
con pu=0.6822 y min-entropía 0.5518. No cambian el pseudocódigo RCT/APT citado.
Para validación de fuente, 3.1.1 pide datos brutos secuenciales de al menos
un millón de muestras y datos de 1000 reinicios con 1000 muestras cada uno.
El lote de monitoreo propio de 65536 no reemplaza ese proceso.

[SP 800-90C](https://csrc.nist.gov/pubs/sp/800/90/c/final) ya es final desde
el 25 de septiembre de 2025. Integra fuentes de 90B con mecanismos DRBG de 90A;
sirve para revisar el flujo de generación, sin atribuir conformidad a una KDF
o composición HKDF/SHAKE por la sola referencia. La calificación de una fuente
concreta y las leyes físicas mantienen su obligación.

## Custodia y herramientas

[SP 800-57 Parte 1 Rev. 5](https://csrc.nist.gov/pubs/sp/800/57/pt1/r5/final),
8.3.4, exige contemplar todas las copias secretas cuando dejan de necesitarse,
incluidas las conservadas en respaldos. Las claves públicas pueden conservarse.
La [página revisada](visual/destruccion-126.png) no demuestra borrado físico ni
secrecia hacia adelante del prototipo. La [Rev. 6 consultada](https://csrc.nist.gov/pubs/sp/800/57/pt1/r6/ipd)
es un borrador inicial de diciembre de 2025; no se presenta como final.

La [especificación ACVP ML-DSA](https://pages.nist.gov/ACVP/draft-celi-acvp-ml-dsa.html)
separa algoritmo, modo, revisión, perfil e interfaz. FIPS204-tr1 designa una
revisión de pruebas contra FIPS 204. Distingue pure/preHash, internal/external
y externalMu; un hash externo de aplicación no identifica automáticamente la
interfaz HashML-DSA. Sus casos deterministas y de rechazo son útiles para R1-D.
Esta revisión no descarga vectores de una sesión, ejecuta pruebas ni certifica.

[EntropyAssessment](https://github.com/usnistgov/SP800-90B_EntropyAssessment)
ofrece herramientas C++ para IID, no-IID y reinicios. Para usarlas con afirmaciones
de despliegue hacen falta datos de una fuente concreta y su procedencia.
Sus resultados son contraste experimental, no términos de prueba Lean.

## Efecto sobre la matriz

La [trazabilidad](trazabilidad-nist.json) enlaza las fuentes con M05–M24 y M43,
según su alcance. Continúan parciales **M26/M31/M35/M36/M37/M39/M40/M41**.
Las fuentes no identifican las corridas H1/H2 ni los certificados del ejemplo;
los enlaces completos Rust/ROM requieren las pruebas propias pendientes.
M01/M08/M09 mantienen sus dependencias bibliográficas; M43/M44, su respaldo
documental; QROM AIR/FRI sigue futuro. No se cambia el registro auditado.

Se registra además una observación para la próxima conciliación: la tabla de
Capítulo 7, línea 21, debe distinguir la rotación implementada de la secrecia
hacia adelante aún pendiente. No se editan capítulos ni salidas publicadas.

## Fuentes conservadas y comprobación

| Copia local | Procedencia |
|---|---|
| [FIPS204.html](fuentes/FIPS204.html) | [fuente oficial](https://csrc.nist.gov/pubs/fips/204/final) |
| [FIPS204.pdf](fuentes/FIPS204.pdf) | [fuente oficial](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.204.pdf) |
| [FIPS204-errata.xlsx](fuentes/FIPS204-errata.xlsx) | [fuente oficial](https://csrc.nist.gov/files/pubs/fips/204/final/docs/fips-204-potential-updates.xlsx) |
| [SP800-90B.html](fuentes/SP800-90B.html) | [fuente oficial](https://csrc.nist.gov/pubs/sp/800/90/b/final) |
| [SP800-90B.pdf](fuentes/SP800-90B.pdf) | [fuente oficial](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-90B.pdf) |
| [SP800-90B-errata.pdf](fuentes/SP800-90B-errata.pdf) | [fuente oficial](https://csrc.nist.gov/files/pubs/sp/800/90/b/final/docs/sp800-90b_errata_potential_updates.pdf) |
| [SP800-90C.html](fuentes/SP800-90C.html) | [fuente oficial](https://csrc.nist.gov/pubs/sp/800/90/c/final) |
| [SP800-57r5.html](fuentes/SP800-57r5.html) | [fuente oficial](https://csrc.nist.gov/pubs/sp/800/57/pt1/r5/final) |
| [SP800-57r5.pdf](fuentes/SP800-57r5.pdf) | [fuente oficial](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-57pt1r5.pdf) |
| [SP800-57r6-ipd.html](fuentes/SP800-57r6-ipd.html) | [fuente oficial](https://csrc.nist.gov/pubs/sp/800/57/pt1/r6/ipd) |
| [ACVP-ML-DSA.html](fuentes/ACVP-ML-DSA.html) | [fuente oficial](https://pages.nist.gov/ACVP/draft-celi-acvp-ml-dsa.html) |
| [EntropyAssessment-README.md](fuentes/EntropyAssessment-README.md) | [fuente oficial](https://raw.githubusercontent.com/usnistgov/SP800-90B_EntropyAssessment/master/README.md) |

La [validación documental](validacion-documental.json) comprueba fuentes,
pruebas auditadas sin cambios, criterios y estados, y recuperación de los
4652 archivos de la edición anterior mediante sus versiones conservadas.
Se reutiliza la auditoría Lean por identidad de sus 454 fuentes y 197 logs;
no se vuelve a compilar ni se atribuye a este trámite una revisión independiente.
