# Campos y dominios Goldilocks en Lean

**Fecha:** 16 de octubre de 2026. Esta ejecución registra 76 lemas y teoremas,
36 más que los 40 de la [etapa anterior](../Lean-AIR-Manuscrito/README.md).
La formalización global de la tesis permanece en curso.

- [Informe, axiomas, cobertura y hashes](validacion.json).
- [Auditoría de axiomas](axiomas.log).
- [Compilación](build.log).
- [Alcance vigente y obligaciones pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).

Los nuevos módulos son:

| Módulo | Resultados añadidos |
|---|---|
| [Campos/Goldilocks](../../../../formalizacion/Nexus/Campos/Goldilocks.lean) | 20: certificado de Lucas de la primalidad de p=2^64−2^32+1, generador 7, raíces primitivas, desplazamiento del exponente, coherencia de raíces, irreducibilidad de X²−7, cardinales y operaciones algebraicas de la extensión |
| [AIR/Grados](../../../../formalizacion/Nexus/AIR/Grados.lean) | 7: derivación de las cotas de grado de los numeradores AIR y su combinación |
| [AIR/Goldilocks](../../../../formalizacion/Nexus/AIR/Goldilocks.lean) | 9: equivalencia AIR, cancelación 1/p², cardinal de cosets, ausencia de polos y distancia de la composición concreta |

La primalidad, el orden del generador y la ausencia de raíces de X²−7 se
demuestran dentro de Lean. La extensión por pares tiene estructura de campo
y cardinal p². Se verifica también la raíz numérica de orden 2^32 y la
relación g=omega^8 entre los dominios de filas y de evaluación extendida.

Para T=2^k, 4≤k≤29, el coset de N=8T puntos tiene el cardinal requerido y
evita los ceros de X^T−1. El perfil implementado TG2, 4≤k≤12, está incluido.
Los grados de los numeradores se derivan de grado(f)<T. La distancia frente
a todo polinomio de grado <2T queda acotada por (5T+1)/(8T) si el residuo de
la combinación no es cero. Para una traza inválida fija y retos uniformes
independientes, la probabilidad de esa cancelación es a lo sumo 1/p².

Se auditan los 76 resultados y se recomprueban catorce módulos por separado
con `leanchecker` de Lean 4.35.0, confiando en sus módulos importados. No se
usa `--fresh` ni un verificador externo. Los axiomas permitidos son
`propext`, `Classical.choice` y `Quot.sound`.

Las fórmulas de la extensión coinciden algebraicamente con la copia histórica
de `field.rs` identificada en los hashes. Esto no verifica todavía la semántica
completa del ejecutable Rust, sus bucles, desbordamientos ni serialización.
La transferencia a oráculos no polinómicos, las capas FRI y Merkle/ROM conservan
obligaciones pendientes. QROM mantiene su condición de trabajo futuro.

El inventario contiene 272 candidatos en ocho fuentes, con 19 bloques de
correspondencia parcial revisada. No es un inventario semántico cerrado ni
permite calcular un porcentaje de avance a partir del número de teoremas.
Los archivos del manuscrito y de la evidencia histórica no se modificaron.

Para repetir desde la raíz del repositorio, conservando una ejecución nueva:

```powershell
python scripts/lean.py preparar
python scripts/verificar_formalizacion.py
```

No sustituir los archivos de esta carpeta por los de otra ejecución.
