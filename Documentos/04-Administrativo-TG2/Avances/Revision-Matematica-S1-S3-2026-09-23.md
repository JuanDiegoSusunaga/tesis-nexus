# Paquete preparado para revisión matemática — S1 a S3

**Fecha:** 23 de septiembre de 2026. **Estado:** preparado; revisión independiente y envío no registrados. La aprobación previa del director no se atribuye a estas derivaciones posteriores.

## Material y orden de lectura

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
| M5 | Teorema ROM propuesto para el canal concreto | Extracción congelada, solapamiento nodo/enunciado, evento de grafo, candidatos de nonce y cola del muestreo; revisar constantes y presupuesto Q | Pendiente |
| M6 | Suficiencia para el alcance aprobado de TG2 | Afirmaciones que pueden quedar como resultados condicionales y obligaciones que requieren trabajo adicional antes de la entrega | Pendiente |

## Afirmaciones que la edición conserva

- Resultados de componentes y pruebas de software, con fuentes y condiciones identificadas.
- Contraejemplo sobre proximidad de una traza, con enunciado válido.
- Variante experimental que detecta esos casos, con costos y límites medidos.
- Argumento y cota conservadora en un modelo interactivo ideal, sujetos a revisión.
- Auditoría de correspondencia Merkle/Fiat–Shamir y distribución exacta bajo sus hipótesis.
- Nueva demostración propuesta en ROM clásico, con 108 escenarios y verificador independiente completo del corpus; once pruebas nuevas y 28 Python en total.

La demostración ROM propuesta sigue pendiente de dictamen. No se acredita una garantía incondicional de SHA3, seguridad QROM, 100 bits, conocimiento cero ni la validación completa de una blockchain. El análisis se refiere exclusivamente a la variante experimental vinculada TG2 v1 y su AIR demostrativo.

## Registro de resolución

Para cada M1–M6 registrar: revisor, fecha, observación, corrección requerida y estado final. Este archivo no constituye aprobación ni evidencia de envío. El cierre académico depende del alcance acordado y de ese dictamen; la auditoría no agrega por sí sola un requisito de probar un nuevo teorema criptográfico.
