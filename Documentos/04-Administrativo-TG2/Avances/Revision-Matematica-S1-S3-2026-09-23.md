# Paquete preparado para revisión matemática — S1 a S3

**Fecha:** 23 de septiembre de 2026. **Estado:** preparado; revisión independiente y envío no registrados. La aprobación previa del director no se atribuye a estas derivaciones posteriores.

## Material y orden de lectura

**Extractor QROM y componente de campo:** [lema de estabilidad y cota en base comprimida](Extractor-QROM-2026-09-23/README.md). Avanza Q1 y Q3 con catorce tests nuevos, 66 Python y 197 Rust en la regresión. Para M5 se solicita revisar también la unicidad de preimágenes, las dos direcciones de inestabilidad y la aplicación de CMS19. La selección de índices y el paso de base comprimida a aceptación real permanecen abiertos.

**Nueva etapa QROM:** [reducción parcial de PoW y obligaciones Q1–Q5](QROM-2026-09-23/README.md). Se deriva una cota explícita mediante DFM20 y se identifican las diferencias frente al compilador de CMS19. La revisión de M5 debe considerar por separado esta reducción y el paso aún abierto que incorpora AIR/FRI. Se añaden doce tests, con 52 Python y 197 Rust en la regresión; los experimentos no sustituyen el dictamen.

**Suplemento de revisión interna:** [revisión crítica y potencial para nonces adaptativos](Revision-Critica-ROM-2026-09-23/README.md). Refuerza §§5–8 de la transferencia ROM y añade 96 escenarios de estrategias exactas; mantiene la fórmula. No constituye el dictamen independiente solicitado.

**Complementos posteriores integrados en `main`:** [solidez por rondas del IOP conjunto](Cierre-Matematico-2026-09-23/README.md) y [transferencia clásica ROM al protocolo TG2 v1](Transferencia-ROM-2026-09-23/README.md). El segundo propone una demostración con extracción por registro hash, gramática del canal, sesgo, nonces adaptativos y pérdidas explícitas. Ambos requieren dictamen y amplían M3–M5; el manuscrito y el Word siguientes conservan su edición anterior. QROM permanece abierto.

**Lectura consolidada:** [documento Word de las derivaciones](Derivaciones-Matematicas-TG2-2026-09-23.docx) y [fuente Markdown](Derivaciones-Matematicas-TG2-2026-09-23.md). Reúne los argumentos completos, sus hipótesis, evidencia y preguntas M1–M6. La sección 1.1 explica la diferencia entre una demostración escrita pendiente de revisión y el paso de compilación que sigue abierto.

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
| M5 | Teorema ROM propuesto para el canal concreto | Extracción congelada, solapamiento nodo/enunciado, evento de grafo y nuevo potencial para nonces/cola; revisar condicionamiento, constantes y presupuesto Q | Pendiente |
| M6 | Suficiencia para el alcance aprobado de TG2 | Afirmaciones que pueden quedar como resultados condicionales y obligaciones que requieren trabajo adicional antes de la entrega | Pendiente |

## Afirmaciones que la edición conserva

- Resultados de componentes y pruebas de software, con fuentes y condiciones identificadas.
- Contraejemplo sobre proximidad de una traza, con enunciado válido.
- Variante experimental que detecta esos casos, con costos y límites medidos.
- Argumento y cota conservadora en un modelo interactivo ideal, sujetos a revisión.
- Auditoría de correspondencia Merkle/Fiat–Shamir y distribución exacta bajo sus hipótesis.
- Nueva demostración propuesta en ROM clásico, con 108 escenarios y verificador independiente completo del corpus; once pruebas nuevas y 28 Python en total.

La demostración ROM y los dos resultados parciales QROM siguen pendientes de dictamen. Uno controla el trabajo; el otro, colisiones y escapes de campo en la base comprimida. Falta una garantía QROM completa de AIR/FRI para el juego de aceptación real. No se acredita seguridad incondicional de SHA3, 100 bits, conocimiento cero ni validación completa de una blockchain. El análisis se refiere exclusivamente a TG2 v1 y su AIR demostrativo.

## Registro de resolución

Para cada M1–M6 registrar: revisor, fecha, observación, corrección requerida y estado final. Este archivo no constituye aprobación ni evidencia de envío. El cierre académico depende del alcance acordado y de ese dictamen; la auditoría no agrega por sí sola un requisito de probar un nuevo teorema criptográfico.
