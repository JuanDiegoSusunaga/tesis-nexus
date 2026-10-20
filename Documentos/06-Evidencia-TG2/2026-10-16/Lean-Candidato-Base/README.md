# Candidato base y no base en Lean

**Fecha:** 16 de octubre de 2026. Esta ejecución registra 126 lemas y teoremas,
28 más que los 98 de la [etapa anterior](../Lean-Transferencia/README.md).
La formalización completa de la tesis permanece en curso.

- [Informe, axiomas, cobertura y hashes](validacion.json).
- [Auditoría de axiomas](axiomas.log).
- [Compilación](build.log).
- [Alcance vigente y pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).

| Módulo | Resultados añadidos |
|---|---|
| [Campos/Polinomios](../../../../formalizacion/Nexus/Campos/Polinomios.lean) | 11: partes por coeficientes, sus grados, evaluación imaginaria, pertenencia al campo base y descomposición f=A+zB |
| [N03/CampoBase](../../../../formalizacion/Nexus/N03/CampoBase.lean) | 6: conteo de valores base de f y fracción no base del oráculo próximo, con tolerancias racionales y reales |
| [N03/Perfil](../../../../formalizacion/Nexus/N03/Perfil.lean) | 7: cotas en N=8T, margen >3/4 con δ≤1/8, comparación con d y unicidad concreta |
| [N03/Alternativa](../../../../formalizacion/Nexus/N03/Alternativa.lean) | 4: compatibilidad de la transición y validez AIR con la inmersión, invalidez del candidato base y alternativa algebraica |

Las partes A y B se construyen a partir de los coeficientes de f sobre la
extensión Goldilocks; no se supone la descomposición como premisa. Se prueba
que f viene del campo base si y solo si B=0, y que f(x) es base si y solo si
B(x)=0 para cada punto base x. Un candidato no base de grado <T tiene, por
tanto, a lo sumo T−1 evaluaciones base en puntos distintos.

Para u a distancia ≤δ de ese mismo f, su fracción de valores fuera del campo
base es al menos 1−(T−1)/N−δ. Las versiones racional y real se instancian en
el coset Goldilocks con N=8T y k≤29. Si δ≤1/8, esa fracción supera 3/4.
Con radios no negativos δt,δc, supera la cota de composición
d=(5T+1)/(8T)−3δt−δc por al menos 1/4.

Se prueba también la unicidad del candidato próximo para δ≤1/8. La validez
AIR de un polinomio base se conserva y refleja al elevar coeficientes. Bajo
la hipótesis de enunciado sin traza válida base, un candidato cercano dado
es base e inválido, o es no base y obliga a la fracción no base indicada.

No se afirma que todo oráculo tenga un candidato próximo. El tratamiento de
las fases con o sin candidato, la fijación temporal antes de los retos y la
composición por rondas quedan en N06. Las cotas de posiciones no verifican
por sí solas las aperturas autenticadas, la semántica completa de Rust,
FRI ni Merkle/ROM. QROM conserva su estado de trabajo futuro.

Se auditan los 126 resultados y se recomprueban veintidós módulos por
separado con `leanchecker` de Lean 4.35.0, confiando en sus importaciones.
No se usa `--fresh` ni un verificador externo. Los axiomas permitidos son
`propext`, `Classical.choice` y `Quot.sound`. Pasan los cinco controles del
analizador de la auditoría de axiomas.

El inventario conserva 272 candidatos en ocho fuentes, con 26 bloques de
correspondencia parcial revisada. No es un inventario semántico cerrado ni
un porcentaje de avance. Los capítulos y la evidencia histórica no cambiaron.

Para repetir desde la raíz y conservar otra ejecución:

```powershell
python scripts/lean.py preparar
python scripts/verificar_formalizacion.py
```

No sustituir los archivos de esta carpeta por los de otra ejecución.
