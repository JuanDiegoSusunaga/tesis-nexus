# Transferencia local de errores AIR en Lean

**Fecha:** 16 de octubre de 2026. Esta ejecución registra 98 lemas y teoremas,
22 más que los 76 de la [etapa anterior](../Lean-Goldilocks/README.md).
La formalización global de la tesis permanece en curso.

- [Informe, axiomas, cobertura y hashes](validacion.json).
- [Auditoría de axiomas](axiomas.log).
- [Compilación](build.log).
- [Alcance y obligaciones pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).

| Módulo | Resultados añadidos |
|---|---|
| [Distancia/Propiedades](../../../../formalizacion/Nexus/Distancia/Propiedades.lean) | 5: no negatividad, simetría, desigualdad triangular y conteo de errores bajo reindexaciones inyectivas |
| [AIR/Localidad](../../../../formalizacion/Nexus/AIR/Localidad.lean) | 9: composición local, identidad con el numerador polinómico y la fórmula racional, localidad en tres puntos, cota de errores 3ε y transferencia racional/real |
| [AIR/Transferencia](../../../../formalizacion/Nexus/AIR/Transferencia.lean) | 7: periodicidad de índices, clausura del coset, identidad de desplazamientos LDE, transferencia concreta y margen mayor que 1/2 |
| [Modelos/DistanciaAIR](../../../../formalizacion/Nexus/Modelos/DistanciaAIR.lean) | Tabla 6.16: N=8T en las cinco filas y diez cotas redondeadas hacia abajo con error menor que 10^-6 |

La prueba de localidad cuenta la unión de las discrepancias en x, gx y g²x.
Las dos rotaciones son inyectivas y permanecen en el dominio; esas propiedades
se derivan para el coset Goldilocks. También se demuestra que el índice
(i+8j) mod N usado en la transición representa el punto g^j*x.
El argumento no necesita independencia probabilística.

Para T=2^k, 4≤k≤29, un candidato f de grado <T, un oráculo u próximo a ese
mismo f y un residuo combinado no nulo, se obtiene frente a todo h de grado <2T:

```text
distancia(c_u,h) ≥ max(0, (5T+1)/(8T) − 3ε).
```

Se exportan tolerancias racionales y reales. Para ε≤1/24 se prueba que la
distancia es estrictamente mayor que 1/2. El perfil implementado TG2 v1,
4≤k≤12, está incluido; la fila T=262144 de la tabla es un cálculo del modelo
matemático y no un perfil admitido por ese ejecutable.

Se comprueba que la composición local coincide con la composición polinómica
para u=f.eval y con la fórmula racional de las tres partes de `compose`
fuera de los polos. Estas identidades no verifican todavía la semántica de
máquina de Rust, las aperturas autenticadas ni la fijación temporal de los
oráculos. Tampoco deducen la proximidad de u a partir de la aceptación.

Se auditan los 98 resultados y se recomprueban dieciocho módulos por separado
con `leanchecker` de Lean 4.35.0, confiando en sus módulos importados. No se
usa `--fresh` ni un verificador externo. Los axiomas permitidos son
`propext`, `Classical.choice` y `Quot.sound`. Pasan los cinco controles del
analizador de la auditoría de axiomas.

El inventario conserva 272 candidatos en ocho fuentes y 23 bloques con
correspondencia parcial revisada. FRI, el estado conjunto del protocolo,
Merkle/ROM y las otras obligaciones del manuscrito siguen pendientes.
QROM mantiene su estado de trabajo futuro. Los archivos del manuscrito y
de las ejecuciones históricas no se modificaron.

Para repetir desde la raíz del repositorio y conservar otra ejecución:

```powershell
python scripts/lean.py preparar
python scripts/verificar_formalizacion.py
```

No sustituir los archivos de esta carpeta por los de una ejecución nueva.
