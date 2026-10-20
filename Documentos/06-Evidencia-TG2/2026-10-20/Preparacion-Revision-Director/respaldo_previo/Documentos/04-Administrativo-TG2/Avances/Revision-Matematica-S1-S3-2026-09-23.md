# Paquete preparado para revisión matemática — S1 a S3

**Fecha:** 23 de septiembre de 2026. **Estado:** preparado; revisión independiente y envío no registrados. La aprobación previa del director no se atribuye a estas derivaciones posteriores.

**Decisión posterior del autor:** la transferencia QROM completa del protocolo AIR/FRI queda como trabajo futuro. La parte QROM de M5 y sus desarrollos pendientes se conservan para esa investigación. El cierre activo revisa las afirmaciones que se incluyan en la entrega y sus límites, sin exigir completar QROM. La presentación de resultados parciales debe identificarlos como propuestas pendientes de dictamen.

## Material y orden de lectura

**Catálogo complementario del 12 de octubre:** [enunciados, dependencias e integridad documental](Catalogo-Validacion-2026-10-12/README.md). Permite localizar doce afirmaciones en sus fuentes y relacionarlas con M1–M6. El comprobador no verifica las demostraciones ni registra un dictamen; QROM conserva su condición de trabajo futuro.

**Edición consolidada para revisión:** [Word del 12 de octubre](Derivaciones-Matematicas-TG2-2026-10-12.docx) y [fuente](Derivaciones-Matematicas-TG2-2026-10-12.md). Los argumentos por rondas, ROM y potencial se integran también en §§6.7.8–6.7.9 del manuscrito. La edición previa y los paquetes siguientes son antecedentes; sus estados históricos no sustituyen el estado de esta consolidación ni cierran M1–M6.

**Cota QROM de cola:** [conteo y recurrencia de amplitudes](Cola-QROM-2026-09-23/README.md). Se propone un límite para Tcola mediante ausencia de ciclos anclados, capacidad local, escalera de niveles y unión sobre conjuntos de 39 índices. Para M5 revisar esos pasos y la extensión analítica de R. Los 144 perfiles incluyen 16 cotas no triviales; pasan 96 Python y 197 Rust. La omisión S continúa sin cota útil y los exponentes de cola no acreditan seguridad global.

**Muestreo QROM y cambio de juego:** [reducción condicional al verificador](Muestreo-QROM-2026-09-23/README.md). Propone la cobertura de aceptación falsa, un verificador auxiliar acotado y la aplicación del lema 4.9 de CMS19. Para M5 se solicita revisar esos tres pasos, el tamaño del conjunto local G y el presupuesto Q+V. La probabilidad de omisión o cola se define mediante β, sin cota útil demostrada. Pasan 80 Python y 197 Rust; el corpus contiene enunciados válidos y la herramienta no decide falsedad ni demuestra β.

**Extractor QROM y componente de campo:** [lema de estabilidad y cota en base comprimida](Extractor-QROM-2026-09-23/README.md). Avanza Q1 y Q3 con catorce tests nuevos, 66 Python y 197 Rust en esa regresión. Para M5 se solicita revisar también la unicidad de preimágenes, las dos direcciones de inestabilidad y la aplicación de CMS19. El suplemento de muestreo incorpora su cota a una reducción todavía condicional.

**Nueva etapa QROM:** [reducción parcial de PoW y obligaciones Q1–Q5](QROM-2026-09-23/README.md). Se deriva una cota explícita mediante DFM20 y se identifican las diferencias frente al compilador de CMS19. La revisión de M5 debe considerar por separado esta reducción y el paso aún abierto que incorpora AIR/FRI. Se añaden doce tests, con 52 Python y 197 Rust en la regresión; los experimentos no sustituyen el dictamen.

**Suplemento de revisión interna:** [revisión crítica y potencial para nonces adaptativos](Revision-Critica-ROM-2026-09-23/README.md). Refuerza §§5–8 de la transferencia ROM y añade 96 escenarios de estrategias exactas; mantiene la fórmula. No constituye el dictamen independiente solicitado.

**Complementos posteriores integrados en `main`:** [solidez por rondas del IOP conjunto](Cierre-Matematico-2026-09-23/README.md) y [transferencia clásica ROM al protocolo TG2 v1](Transferencia-ROM-2026-09-23/README.md). El segundo propone una demostración con extracción por registro hash, gramática del canal, sesgo, nonces adaptativos y pérdidas explícitas. Ambos requieren dictamen y amplían M3–M5; las ediciones históricas se conservan y los argumentos están integrados en el manuscrito y suplemento del 12 de octubre. QROM permanece abierto.

**Lectura consolidada:** [documento Word de las derivaciones](Derivaciones-Matematicas-TG2-2026-10-12.docx) y [fuente Markdown](Derivaciones-Matematicas-TG2-2026-10-12.md). Reúne los argumentos completos, sus hipótesis, evidencia y preguntas M1–M6. La sección 1.1 explica la diferencia entre una demostración escrita pendiente de revisión y el paso de compilación que sigue abierto.

1. [Manuscrito vigente](../../01-Manuscrito/README.md), §§6.7.2–6.7.6 y conclusiones.
2. [S1: álgebra y transferencia de distancia](R4-Algebra-AIR-FRI-2026-09-22.md).
3. [Contraejemplo de proximidad del legado](R4-Proximidad-Traza-2026-09-22.md) y [variante vinculada](R4-FRI-Vinculado-2026-09-22.md).
4. [S2: composición interactiva ideal](R4-Cota-Interactiva-2026-09-22.md).
5. [S3: Merkle, distribución y Fiat–Shamir](R4-Merkle-Fiat-Shamir-2026-09-23.md).

El objeto revisado es una recurrencia AIR demostrativa. La validez de firmas ML-DSA y la lógica completa de aplicaciones no están aritmetizadas en este AIR. El dominio de la tesis sigue siendo sistemas en general.

## Preguntas que requieren dictamen

| ID | Afirmación a revisar | Evidencia o punto de atención | Estado |
|---|---|---|---|
| M1 | S1: divisibilidad, cancelación ≤ 1/p² y distancia ≥ (5T+1)/(8T) | Traza fija antes de α; grados y ausencia de polos; distinguir traza inválida de enunciado falso | Pendiente |
| M2 | Unicidad y selección previa del candidato próximo | Distancia mínima RS; caso de coeficientes fuera del campo base | Pendiente |
| M3 | FRI ideal local y nueva derivación elemental | Corolario 5.5; lema A de acuerdo, elevación de conjuntos en FRI, constante final y muestreo sin reemplazo | Pendiente |
| M4 | Composición AIR/FRI ordinaria y por rondas | Historia adaptativa, coeficiente AIR crítico, estado absorbente, consulta compartida y una sola contribución de omisión | Pendiente |
| M5 | Teorema ROM y desarrollos QROM propuestos para el canal concreto | En ROM: extracción y potencial. En QROM: extractor, campo, conjunto G, cobertura, lema 4.9 y cola; β^S permanece abierto | ROM: dictamen pendiente. QROM: trabajo futuro |
| M6 | Suficiencia para el alcance aprobado de TG2 | Afirmaciones que pueden quedar como resultados condicionales y obligaciones que requieren trabajo adicional antes de la entrega | Pendiente |

## Afirmaciones que la edición conserva

- Resultados de componentes y pruebas de software, con fuentes y condiciones identificadas.
- Contraejemplo sobre proximidad de una traza, con enunciado válido.
- Variante experimental que detecta esos casos, con costos y límites medidos.
- Argumento y cota conservadora en un modelo interactivo ideal, sujetos a revisión.
- Auditoría de correspondencia Merkle/Fiat–Shamir y distribución exacta bajo sus hipótesis.
- Nueva demostración propuesta en ROM clásico, con 108 escenarios y verificador independiente completo del corpus; once pruebas nuevas y 28 Python en total.

La demostración ROM y los cuatro complementos QROM siguen pendientes de dictamen: trabajo del nonce, extractor con escapes de campo, muestreo con reducción condicional y cota de cola. Falta una cota útil β^S de omisión para obtener una garantía QROM completa de AIR/FRI mediante esa reducción. No se acredita seguridad incondicional de SHA3, 100 bits, conocimiento cero ni validación completa de una blockchain. El análisis se refiere exclusivamente a TG2 v1 y su AIR demostrativo.

## Registro de resolución

Para cada M1–M6 registrar: revisor, fecha, observación, corrección requerida y estado final. Este archivo no constituye aprobación ni evidencia de envío. El cierre académico depende del alcance acordado y de ese dictamen; la auditoría no agrega por sí sola un requisito de probar un nuevo teorema criptográfico.
