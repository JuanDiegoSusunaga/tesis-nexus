# Catálogo de afirmaciones para la validación de NEXUS

**Fecha:** 12 de octubre de 2026. Este complemento vincula las afirmaciones del AIR demostrativo TG2 v1 con sus hipótesis, dependencias, documentos y evidencia conservada. La estructura adapta la separación entre enunciado, solución y alcance utilizada por Lean/Comparator. Las derivaciones de NEXUS siguen pendientes de dictamen independiente y no disponen aquí de pruebas mecanizadas.

El catálogo acompaña las [preguntas M1–M6](../Revision-Matematica-S1-S3-2026-09-23.md) y la [matriz TG2](../../../05-Estado-del-Arte/Resumenes-y-Matriz/Matriz-Trazabilidad-TG2.md). La transferencia QROM completa de AIR/FRI permanece como trabajo futuro por decisión del autor. La incorporación de Lean es una posible mejora de validación, no una nueva condición de cierre académico.

## Afirmaciones y dependencias

**Complemento del 16 de octubre:** la [primera comprobación en Lean](../../../../formalizacion/VERIFICACION.md) añade 17 lemas y teoremas sobre componentes de N01–N05 y N12, con [evidencia de ejecución](../../../06-Evidencia-TG2/2026-10-16/Lean/validacion.json). El JSON y los estados siguientes conservan la instantánea histórica del 12 de octubre; la [cobertura actual](../../../../formalizacion/cobertura.json) distingue los fragmentos mecanizados de sus puentes y obligaciones pendientes.

Los enunciados siguientes se leen con todas las hipótesis de [catalogo.json](catalogo.json) y de sus localizadores. «Derivación propuesta» identifica una demostración escrita pendiente de revisión; «contraste empírico» identifica resultados del corpus, sin generalizarlos a todos los adversarios. Ninguna fila significa que Lean haya aceptado una prueba.

| ID | Afirmación delimitada | Dependencias del catálogo | Revisión relacionada | Estado |
|---|---|---|---|---|
| N01 | Para una traza inválida fijada antes de los retos, la probabilidad de cancelación del residuo es a lo sumo 1/p² con coeficientes uniformes independientes en K | Ninguna | M1 | Derivación propuesta |
| N02 | Sin cancelación y sin polos, la composición de la traza fija tiene distancia al código de grado < 2T al menos (5T+1)/(8T) | Ninguna; N01 controla el evento excluido | M1 | Derivación propuesta |
| N03 | El candidato de grado < T próximo a la traza es único bajo 2δt < (N−T+1)/N; el caso fuera del campo base requiere el argumento específico | Ninguna | M2 | Derivación propuesta |
| N04 | El lema A conserva el mismo conjunto de acuerdo para las dos funciones, salvo a lo sumo n retos excepcionales, bajo (1−3θ)n > e−1 | Ninguna | M3 | Derivación propuesta |
| N05 | Sin eventos excepcionales de plegado, una traza a distancia > θ tiene a lo sumo 1−θ parejas aceptantes; el muestreo sin reemplazo se acota mediante H(M,q,θ) | N04 | M3 | Derivación propuesta |
| N06 | La función de estado conjunto acota la aceptación falsa del IOP ideal de AIR y ambos FRI con consulta compartida | N01–N05 | M4 | Derivación propuesta |
| N07 | Fuera de Bad_H, las aperturas coinciden con el vector extraído del registro cuando la raíz ya está marcada antes del reto | Ninguna | M5 ROM | Derivación propuesta |
| N08 | El potencial cobra al inicio de cada candidato el trabajo y la omisión, incluyendo selección adaptativa y la cola de índices | N05, N07 | M5 ROM | Derivación propuesta |
| N09 | La fórmula E_ROM acota la aceptación de un enunciado falso para TG2 v1, bajo un único oráculo aleatorio clásico y presupuesto Q | N06–N08 | M5 ROM y M6 | Derivación propuesta |
| N10 | Los verificadores Python y Rust coinciden en los 14 certificados preservados: ocho honestos aceptados y seis alejados rechazados | Ninguna | M6 | Contraste empírico documentado |
| N11 | La cota QROM de cola es un resultado parcial; la omisión β^S y la transferencia completa permanecen abiertas | Ninguna; no se usa para cerrar N09 | M5 QROM | Trabajo futuro |
| N12 | El perfil ML-DSA y la inaplicabilidad directa del teorema JMW24 se documentan en R1; las obligaciones R1-A–E permanecen | Ninguna; AIR/FRI no demuestra seguridad de firma | R1 y M6 | Correspondencia documentada |

Las dependencias organizan la lectura y la futura mecanización; no sustituyen los lemas auxiliares, las fuentes bibliográficas ni el dictamen. N02 es una implicación determinista condicionada a residuo no nulo: N01 no se convierte en una premisa de su demostración.

## Verificación reproducible del catálogo

Desde la raíz de `Tesis`:

```powershell
python scripts/verificar_catalogo_validacion.py
```

El comando comprueba el esquema, identificadores, referencias de dependencia sin ciclos, localizadores y SHA-256 de los nueve archivos enlazados. Las huellas se calculan sobre bytes completos; cualquier cambio de un archivo exige revisar su relación con la afirmación antes de actualizar el catálogo. El comando solo lee archivos, funciona sin red ni paquetes adicionales y no actualiza huellas automáticamente.

Un resultado correcto acredita **integridad y coherencia del catálogo**, no verdad de los enunciados, aprobación matemática, pruebas generales de software ni seguridad criptográfica. Los estados de revisión permanecen pendientes aunque la comprobación pase.

La instantánea Rust enlazada está preservada en la evidencia R4-Merkle-FS. La transferencia se refiere a la revisión de código `01dcde960402b6c60a19242b7ae3d6ac3d82a518`; el catálogo no supone que `nexus/` esté actualmente en ese commit. El manuscrito publicado en los tres formatos conserva su edición identificada.

## Aplicación de Lean y Comparator

Comparator compara un enunciado de referencia con una solución, exige los axiomas permitidos y verifica su aceptación por el kernel bajo las condiciones de su entorno. El archivo de desafío puede contener `sorry`: ese marcador define lo que se pide demostrar y no constituye la solución. El alcance de cada comprobación debe leerse junto al enunciado y sus definiciones. [Documentación de Comparator](https://github.com/leanprover/comparator#comparator).

Para una futura mecanización de NEXUS, cada entrada tendrá un módulo de enunciado, otro de solución, una configuración Comparator y un registro de ejecución con versiones, axiomas y hashes. La primera prioridad propuesta es N01, descompuesta en un lema determinista de unicidad del coeficiente que anula una coordenada no nula y un lema de conteo para el coeficiente uniforme. Después seguirían la cota de raíces usada en N02 y el lema de acuerdo N04. Las operaciones concretas de Rust necesitan su propio puente de correspondencia.

Hasta disponer de esa ejecución, el catálogo declara `mecanizacion: no_disponible`. Las hipótesis de campo, distribución o ausencia de eventos excepcionales deben aparecer en el enunciado; no se admitirá como prueba general una enumeración de tamaños finitos. El dictamen M1–M6 y la aceptación por un kernel responden a preguntas distintas.

## Evaluación del resultado 279

OpenAI, *Exact quantum factoring over a fixed finite gate set*, preprint del 25 de septiembre de 2026, es un candidato secundario para el marco de amenaza cuántica. Su [nota de alcance](https://github.com/openai/math/blob/fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb/lean/docs/279.md) describe factorización exacta con una familia uniforme de circuitos y recursos polinomiales. La [configuración](https://github.com/openai/math/blob/fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb/lean/ComparatorChallenges/ExactQuantumFactoring.json) separa el desafío de `OAI.Computability.QuantumFactoring.Main` y admite `propext`, `Quot.sound` y `Classical.choice`.

Su pertinencia para NEXUS se limita al contexto de factorización cuántica. No permite concluir resistencia de ML-DSA, dureza de retículos, seguridad de curvas elípticas ni solidez de AIR/FRI. Shor conserva su papel como fundamento del marco teórico vigente. Antes de incorporar el preprint al manuscrito se requiere revisar el argumento, ejecutar su verificación y decidir qué novedad aporta frente a la fuente ya utilizada. Su estado bibliográfico es **candidato**, y no se añade como fundamento de una garantía de NEXUS.

La [ficha del manuscrito](https://github.com/openai/math/blob/fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb/preprints/Exact-quantum-factoring-over-a-fixed-finite-gate-set-September-25-2026/README.md) contiene el BibTeX oficial. El repositorio OpenAI se fija para esta consulta en `fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb`; sus resultados tienen distintos estados de verificación según su [README](https://github.com/openai/math/blob/fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb/README.md). El resultado 130 sobre Fourier queda como exploración futura: su modelo de aritmética compleja exacta no aporta una mejora demostrada a las NTT de NEXUS.
