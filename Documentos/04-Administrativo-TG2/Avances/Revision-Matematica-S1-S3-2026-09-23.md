# Paquete preparado para revisión matemática — S1 a S3

**Fecha:** 23 de septiembre de 2026. **Estado:** preparado; revisión independiente y envío no registrados. La aprobación previa del director no se atribuye a estas derivaciones posteriores.

## Material y orden de lectura

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
| M3 | Aplicación de Corolario 5.5 al FRI ideal local | Campo K, normalización del coset, constante final y consultas por parejas sin reemplazo | Pendiente |
| M4 | Unión de errores de §6.7.5 | Condicionamiento por historia, consulta compartida y una sola contribución de omisión local | Pendiente |
| M5 | Límite de la compilación concreta | Vinculación frente a extracción; Eideal ordinario frente a εrbr; SHA3 adaptativo y grinding | Pendiente |
| M6 | Suficiencia para el alcance aprobado de TG2 | Afirmaciones que pueden quedar como resultados condicionales y obligaciones que requieren trabajo adicional antes de la entrega | Pendiente |

## Afirmaciones que la edición conserva

- Resultados de componentes y pruebas de software, con fuentes y condiciones identificadas.
- Contraejemplo sobre proximidad de una traza, con enunciado válido.
- Variante experimental que detecta esos casos, con costos y límites medidos.
- Argumento y cota conservadora en un modelo interactivo ideal, sujetos a revisión.
- Auditoría de correspondencia Merkle/Fiat–Shamir y distribución exacta bajo sus hipótesis.

No se presenta como establecido un teorema de solidez del ejecutable, 100 bits, conocimiento cero o la validación completa de una blockchain.

## Registro de resolución

Para cada M1–M6 registrar: revisor, fecha, observación, corrección requerida y estado final. Este archivo no constituye aprobación ni evidencia de envío. El cierre académico depende del alcance acordado y de ese dictamen; la auditoría no agrega por sí sola un requisito de probar un nuevo teorema criptográfico.
