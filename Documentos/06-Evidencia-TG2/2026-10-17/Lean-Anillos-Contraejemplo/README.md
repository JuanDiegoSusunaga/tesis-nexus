# Lean: anillos ML-DSA y contraejemplo AIR

La pasada M03/M30 añade **121 resultados en nueve módulos**. Se alcanzan
**1103 lemas y teoremas en 129 módulos**, con [auditoría completa correcta](validacion.json).
Los dos grupos quedan como modelos verificados en el alcance descrito. La tesis
completa, las correspondencias con programas y el dictamen siguen pendientes.

| Módulo | Resultados nuevos | Alcance |
|---|---:|---|
| [MLDSA/Parametros](../../../../formalizacion/Nexus/MLDSA/Parametros.lean) | 21 | Primalidad, raíces, perfiles y aritmética del formato declarado |
| [MLDSA/Anillos](../../../../formalizacion/Nexus/MLDSA/Anillos.lean) | 17 | Cocientes negacíclicos, representantes, reducción y cardinalidades |
| [MLDSA/Normas](../../../../formalizacion/Nexus/MLDSA/Normas.lean) | 15 | Representantes centrados, normas y polinomios pequeños |
| [AIR/DistanciaExacta](../../../../formalizacion/Nexus/AIR/DistanciaExacta.lean) | 14 | Acuerdos, aproximante y mínimo de distancia alcanzado |
| [AIR/Perturbacion](../../../../formalizacion/Nexus/AIR/Perturbacion.lean) | 13 | Grado T, filas y validez conservadas, distancias al testigo y al código |
| [AIR/ComposicionAlejada](../../../../formalizacion/Nexus/AIR/ComposicionAlejada.lean) | 12 | Grados exactos, composición acotada y evaluación racional |
| [AIR/CocientesAlejados](../../../../formalizacion/Nexus/AIR/CocientesAlejados.lean) | 9 | Anulador de T−2 transiciones y cociente de grado T+2 |
| [AIR/Interpolacion](../../../../formalizacion/Nexus/AIR/Interpolacion.lean) | 8 | Recurrencia, transporte e interpolante válido construido |
| [AIR/ContraejemploGoldilocks](../../../../formalizacion/Nexus/AIR/ContraejemploGoldilocks.lean) | 12 | Construcción base/extensión desde 3 y 5 y contraejemplo conjunto |

## Anillos y parámetros de ML-DSA

Se prueba que q=8380417 es primo, q=2^23−2^13+1=512·16368+1 y n=256=2^8.
La raíz explícita 1753 satisface zeta^512=1 y zeta^256=−1, y se certifica
su orden exacto 512. Su cuadrado tiene orden 256.

AdjoinRoot construye R=Z[X]/(X^256+1) y Rq=Fq[X]/(X^256+1), sin afirmar que
Rq sea un campo. Los representantes son únicos y tienen grado menor que 256.
La relación negacíclica X^256=−1 y una base de 256 coordenadas se demuestran.
La reducción R→Rq es un homomorfismo sobreyectivo. Se obtienen |Rq|=q^256,
|Rq^r|=q^(256r) y la cardinalidad correspondiente de matrices.

Cada coeficiente modular tiene un entero centrado único en (−q/2,q/2], con
valor absoluto a lo sumo 4190208. Se definen las normas infinito y euclídea
de R, Rq y vectores aplanados. La norma infinito se caracteriza por cotas de
todos los coeficientes, separa cero en Rq y define S_eta sobre R. Se demuestra
la fórmula cuadrática de la norma euclídea y su cota por el número de coordenadas.

Los perfiles 44/65/87 fijan k, ell, eta, tau, beta, gamma1 y gamma2. Se prueban
beta=tau·eta, las potencias/cocientes de gamma y los márgenes positivos. Las
cuentas de clave pública 1312/1952/2592 y firma 2420/3309/4627 se derivan de los
anchos y componentes del formato declarado. No se verifican sus codecs reales,
la implementación NTT, las distribuciones MLWE/MSIS ni una garantía de seguridad.
Las categorías NIST conservan su respaldo bibliográfico; R1 mantiene su alcance.

## Contraejemplo de distancia y composición

Para F=f+lambda·(X^T−1), grado(f)<T y lambda no nulo, se prueban grado(F)=T y
coeficiente principal lambda. F conserva todas las filas, ambas fronteras y las
transiciones de f. En cualquier dominio sin ceros de X^T−1, difiere del testigo
original en cada punto y la distancia a ese testigo es uno.

Frente a cualquier polinomio h de grado menor que T, F−h tiene a lo sumo T
ceros. Se eligen T puntos distintos del dominio y se construye
h=F−lc(F)·producto(X−x_i). El término principal se cancela y los acuerdos son
exactamente los elegidos. Esto prueba el **mínimo alcanzado** de distancia,
no solo una desigualdad. Para |L|=8T vale exactamente **7/8**, también frente
a candidatos sobre la extensión cuadrática.

En característica distinta de dos, la transición tiene coeficiente principal
−2·lambda^2 y grado 2T. Su anulador tiene grado T−2; se demuestra la divisibilidad
para ejecuciones válidas y el cociente de grado exacto T+2. Los cocientes de
frontera tienen grado T−1. La composición tiene grado a lo sumo T+2<2T para
T≥4, para toda elección de coeficientes. Su evaluación coincide con la
composición racional AIR en todos los puntos sin polos.

La ejecución se construye recursivamente desde dos filas y se interpola con
Lagrange, con grado y validez demostrados. En Goldilocks se fijan inicio 3,
segunda fila 5 y lambda=1. Se prueba que las trazas de extensión son imágenes
de polinomios base. Para **4≤k≤29**, T=2^k y el coset de tamaño 8T ya construido,
el [teorema conjunto](../../../../formalizacion/Nexus/AIR/ContraejemploGoldilocks.lean)
reúne ejecución válida, traza de grado T, mínimo 7/8 y composición de bajo
grado igual a la fórmula racional en todo el coset. No hay candidato de grado
menor que T a distancia ≤1/24. Se comprueban las cuentas algebraicas de las
tres filas de la tabla 6.17.

La aceptación del legado y el rechazo del control para 16/32/64 filas siguen
siendo [evidencia empírica preservada](../Anillos-Contraejemplo-Antecedentes/evidencia-empirica.json):
seis certificados binarios, cuatro logs, informe, análisis y tabla. No se vuelve
a ejecutar Rust ni se transforma la pertenencia de la composición al código en
un teorema de aceptación, solidez global o conocimiento cero.

## Trazabilidad e integridad

Se enlazan **17 bloques nuevos**: el inventario pasa de 68 a **85 bloques**
y la revisión de 79 a **96 bloques parcialmente enlazados**, además de dos
suplementos previos. Se conservan los 272 candidatos, 14 omisiones, 46 grupos,
ocho fuentes y sus textos, líneas e identificadores. Quedan siete modelos
verificados, 17 grupos parciales, 16 pendientes, tres dependencias bibliográficas,
dos respaldos documentales y QROM AIR/FRI futuro. No son porcentajes de avance.

Los [antecedentes](../Anillos-Contraejemplo-Antecedentes/README.md) conservan
quince versiones previas. De las 215 fuentes anteriores, siete registros o
herramientas cambian con copia; **208 quedan idénticas**. Se conserva el catálogo
N01–N12 y todos los resultados anteriores. Los capítulos, TG1 y Rust no cambian.

```powershell
python scripts/verificar_formalizacion.py --salida .tools/lean/repeticion-anillos-contraejemplo
python scripts/verificar_revision_manuscrito.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_revision_manuscrito.py
```

Compilación y axiomas pasan sin advertencias. El núcleo recompueba los **129
módulos secuencialmente confiando en importados**; no es --fresh ni una revisión
externa. Solo se permiten propext, Classical.choice y Quot.sound. El informe
fija **254 fuentes y 135 logs**. Los 13 controles del analizador
y trazabilidad están en [controles.log](controles.log), fuera de los logs
principales. La [revisión](revision-manuscrito.json) y el [control final](integridad-anillos-contraejemplo.json)
verifican 2053 logs de 30 etapas, incluidos los 1918 previos, y la documentación.
El dictamen independiente permanece pendiente; la tesis completa no está verificada.
