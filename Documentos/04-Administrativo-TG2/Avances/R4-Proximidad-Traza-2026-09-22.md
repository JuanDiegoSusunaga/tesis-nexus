# R4 — Contraejemplo a la premisa de proximidad de la traza

**Fecha:** 22 de septiembre de 2026. **Ámbito:** Objetivo 4 de TG2. Los módulos STARK heredados se conservan sin cambios.

## 1. Resultado

El verificador heredado acepta pruebas cuya traza comprometida está a distancia exacta **7/8** del código Reed–Solomon de grado menor que T. Se reprodujo con **T = 16, 32 y 64**, usando SHA3, Merkle, FRI y grinding reales del ejecutable, en desarrollo y release. Los coeficientes de composición no se eligieron ni se forzaron.

Esto refuta la implicación «aceptación ⇒ proximidad ≤ 1/24 de la traza comprometida a un polinomio de grado < T», requerida por la ruta suficiente propuesta en el [argumento algebraico anterior](R4-Algebra-AIR-FRI-2026-09-22.md). La premisa deja de ser solamente una obligación sin demostrar: **esa formulación no es válida para el protocolo actual**.

Los enunciados ensayados son válidos y conservan un testigo explícito. El resultado no es una falsificación de enunciado ni refuta por sí solo toda posible prueba de solidez del AIR. Puede existir otro argumento de extracción; no se ha establecido aquí.

Se implementó un control exhaustivo experimental que rechaza estos casos por exceso de grado y acepta la ejecución honesta. Es una referencia de costo lineal en comunicación y cuasilineal en verificación, no una reparación sucinta lista para producción.

## 2. Construcción y conservación de las restricciones

Sean H el subgrupo de orden T, D(X) = Xᵀ − 1 y f el interpolante de grado < T de una ejecución válida. Para cualquier λ ≠ 0 del campo base, se define:

$$
F(X)=f(X)+\lambda D(X).
$$

F tiene grado exactamente T y coincide con f en todos los puntos de H. Por ello conserva el inicio, la salida y cada transición de la recurrencia. El ensayo usa inicio 3, segunda fila 5 y λ = 1 para las pruebas completas.

En el dominio L de tamaño N = 8T, disjunto de H, el oráculo comprometido es u(x) = F(x). D no se anula en L, así que u difiere del LDE honesto f|L en **todas** las posiciones. La distancia a ese f concreto es 1; la distancia mínima al código entero será 7/8.

Las restricciones individuales siguen siendo divisibles por sus anuladores. Los cocientes de frontera tienen grado T−1. La transición C_F(X) = F(g²X) − F(gX)² − F(X)² tiene grado 2T: como gᵀ = 1, su coeficiente principal es −2λ², no nulo en Goldilocks. Al dividir por el anulador de T−2 puntos, el cociente tiene grado T+2.

Por tanto, **la composición tiene grado ≤ T+2 < 2T para T ≥ 4**, cualquiera que sea la combinación de coeficientes. Si el coeficiente de transición es no nulo, su grado es exactamente T+2. No se necesita cancelación excepcional ni buscar otra transcripción.

FRI recibe una palabra que pertenece a su código objetivo. Las aperturas locales usan el mismo F comprometido y satisfacen exactamente la fórmula del verificador. Por ello la familia es compatible con todas las consultas, no solamente con un conjunto afortunado de índices.

## 3. Distancia exacta al código de traza

Para cualquier h ∈ K[X] de grado < T, con K la extensión cuadrática, F−h tiene grado T y coeficiente principal λ. Tiene como máximo T raíces en L. En consecuencia, hay al menos N−T discrepancias:

$$
\operatorname{dist}(F|_L,\mathrm{RS}_{<T}(L;K))
\geq\frac{N-T}{N}=\frac78.
$$

La cota se alcanza. Elíjanse T puntos distintos x₁,…,x_T de L y defínase h = F − λ∏(X−xᵢ). Los términos de grado T se cancelan, de modo que deg h < T, y h coincide con F exactamente en esos T puntos. Así, la distancia es **igual a 7/8**, también cuando se permiten candidatos sobre K.

Las pruebas construyen este h y cuentan T acuerdos en cada dominio. Un script Python reproduce la interpolación mediante sumas directas, la división polinómica de la transición y los acuerdos, sin utilizar la NTT Rust.

## 4. Evidencia del ejecutable

| T | N | Grado F | Cota grado CP | Distancia a RS de grado < T | Verificador heredado |
|---:|---:|---:|---:|:---:|:---:|
| 16 | 128 | 16 | ≤ 18 | 7/8 | Acepta |
| 32 | 256 | 32 | ≤ 34 | 7/8 | Acepta |
| 64 | 512 | 64 | ≤ 66 | 7/8 | Acepta |

La construcción también se contrasta algebraicamente en 21 casos: siete tamaños entre 4 y 256 filas y tres valores no nulos de λ. Las pruebas completas se generan en los tres tamaños de la tabla; no se presenta una ejecución de todos los tamaños del perfil.

Se conservan **seis archivos binarios públicos**, uno por tamaño y perfil. Cada archivo codifica con bincode la tupla (TransitionStatement, StarkProof, Vec<Felt>), donde el último vector contiene todo el LDE comprometido. El ensayo deserializa lo que va a guardar, vuelve a verificar la aceptación heredada y comprueba el rechazo por grado del control exhaustivo. Los parámetros y el testigo son datos de demostración públicos.

La suite completa pasó **187 pruebas en desarrollo**. Las **siete nuevas** pasaron también en release, con los 20 bits de trabajo del perfil AIR. Check de todos los targets y build del workspace terminaron correctamente. No se ejecutaron nuevos benchmarks ni se modificaron las mediciones anteriores.

| Prueba nueva | Resultado comprobado |
|---|---|
| Familia algebraica | Conserva filas válidas y grado de composición en 21 casos |
| Aceptación heredada | Acepta los tres oráculos alejados, con compromisos y transcripción reales |
| Distancia exacta | Construye un candidato de grado < T con exactamente T acuerdos |
| Control honesto | Recupera las filas correctas y acepta la prueba ordinaria |
| Control del grado | Rechaza las tres aceptaciones heredadas por grado T |
| Límites y restricciones | Rechaza tamaños, longitud, no canonicidad, compromiso, fronteras y transición incorrectos |
| Vinculación de pruebas | Cambiar enunciado o aperturas invalida las pruebas; el control también exige el STARK |

## 5. Control exhaustivo experimental

La variante de referencia recibe el LDE completo y:

1. Comprueba potencia de dos y límite de 4–256 filas, longitud N y elementos canónicos.
2. Reconstruye la raíz Merkle del vector y exige igualdad con la raíz de traza de la prueba.
3. Interpola en el coset, deshaciendo el escalado por potencias de 7.
4. Exige que todos los coeficientes desde T sean cero.
5. Evalúa las T filas y comprueba ambas fronteras y las T−2 transiciones.
6. Ejecuta también el verificador heredado.

Si el control acepta, el vector suministrado pertenece exactamente al código de grado < T y representa una ejecución válida. Vincular esa conclusión a un compromiso recibido anteriormente requiere la propiedad de vinculación de Merkle. Las comprobaciones algebraicas son completas para ese vector; no dependen de un evento probabilístico de cancelación.

El control requiere **N elementos adicionales**, equivalentes a 64T bytes de valores canónicos, sin contar metadatos ni la prueba original. Usa O(N log N) operaciones y O(N) memoria; los límites del ensayo impiden considerarlo una implementación para tamaños arbitrarios. Revela toda la traza interpolable y no ofrece conocimiento cero.

Este control muestra una condición suficiente verificable y sirve para comparar variantes. No sustituye a un argumento de proximidad sucinto ni se incorpora al verificador de producción.

## 6. Consecuencia para S1–S5 y siguiente diseño

El argumento S1 y el lema de transferencia siguen siendo correctos bajo sus hipótesis. Los ejemplos presentes no violan ese lema: F no tiene grado < T y u está demasiado lejos de cualquier candidato admisible para aplicar ε ≤ 1/24.

Para S2, deben distinguirse dos rutas:

- **Argumento alternativo para el legado:** justificar extracción de una ejecución válida sin exigir la premisa refutada. La coincidencia F|H = f|H de esta familia explica por qué una traza alejada no basta para demostrar una falsificación.
- **Variante TG2 con comprobación adicional:** exigir la condición de grado/proximidad de la traza y vincularla al mismo compromiso utilizado por las aperturas del AIR. El control exhaustivo realiza una versión exacta de esa condición con un costo explícito.

Una futura prueba FRI separada de la traza deberá usar cota < T y una transcripción que ligue enunciado, dominio y compromisos. No basta anexar una prueba de otro vector: el árbol original serializa elementos del campo base, mientras FRI usa elementos de la extensión; se necesita una vinculación explícita entre ambos compromisos o una codificación compartida justificada. También hay que analizar consultas, proximidad correlacionada y errores de composición.

La literatura de [FRI](https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.ICALP.2018.14) trata proximidad al código consultado; [BGK+23](https://eprint.iacr.org/2023/1071) estudia las condiciones para componer esos argumentos y aplicar Fiat–Shamir. Ninguna de esas referencias acredita automáticamente esta variante concreta. S3 —pérdidas de Fiat–Shamir/Merkle/ROM/QROM— y S5 —revisión independiente— permanecen abiertas.

**Decisión de seguimiento:** registrar S2 como «premisa propuesta refutada para el legado; control exhaustivo experimental implementado». El siguiente trabajo es especificar y contrastar una variante de proximidad de traza vinculada al AIR, o desarrollar una extracción alternativa, antes de atribuir una cota de seguridad global.

## 7. Archivos y reproducción

- [Construcción y control de referencia](../../../nexus/nexus-zk/experiments/tg2_trace_proximity.rs).
- [Siete pruebas](../../../nexus/nexus-zk/tests/tg2_trace_proximity.rs).
- [Cálculo independiente y preservación de evidencia](../../../scripts/analizar_proximidad_traza_r4.py).
- [Análisis y hashes de fuentes](../../06-Evidencia-TG2/2026-09-22/R4-proximidad/analisis.json).
- [Comandos, resultados, toolchain y corpus](../../06-Evidencia-TG2/2026-09-22/R4-proximidad/validacion.json).
- [Identificación de la edición del manuscrito](../../06-Evidencia-TG2/2026-09-22/R4-proximidad/revision-manuscrito.json).

Para reproducir los siete casos desde la raíz:

    $env:CARGO_TARGET_DIR='C:\tmp\nexus-target'
    $env:NEXUS_TG2_TRACE_EVIDENCE_DIR='C:\Users\juand\Desktop\Tesis\Documentos\06-Evidencia-TG2\2026-09-22\R4-proximidad\corpus-release'
    cargo test -p nexus-zk --test tg2_trace_proximity --release --locked --offline --manifest-path nexus/Cargo.toml -- --nocapture

La carpeta de corpus es opcional; sin la variable, las pruebas no exportan archivos. El análisis posterior compara los registros preservados y calcula sus hashes; no reemplaza la ejecución de Cargo.
