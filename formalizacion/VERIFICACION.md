# Primera comprobación de la tesis con Lean

**16 de octubre de 2026.** Lean 4.35.0 y mathlib v4.35.0, revisión
`56a005855ea17e0b0958f73ec801ae140b0a1679`.

Se formalizaron **17 lemas y teoremas**, correspondientes a componentes de
**6 de las 12 afirmaciones** del catálogo. La comprobación corresponde a los
enunciados e hipótesis escritos en Lean. La tesis completa, la seguridad del
ejecutable y el dictamen independiente conservan obligaciones pendientes.

## Qué se comprueba

| Catálogo | Resultado mecanizado | Alcance que falta enlazar |
|---|---|---|
| N01 | Unicidad del coeficiente que cancela, a lo sumo \|K\|² triples cancelantes y probabilidad ≤1/\|K\|=1/p² | Campos concretos, validez AIR ↔ residuos nulos y distribución del canal real |
| N02 | Distancia ≥(5T+1)/(8T) de A/D a cada candidato de grado <2T | Fórmulas concretas de A y D, sus cotas de grado, dominio sin polos y transferencia local a u |
| N03 | Unicidad del candidato de grado <T bajo la desigualdad estricta de distancia mínima | Existencia, rama fuera del campo base y selección anterior al reto |
| N04 | Lema A: salvo ≤n retos, ambas funciones concuerdan con polinomios sobre el mismo conjunto S; radios racionales no negativos, incluido 1/8 | Instanciación en el plegado y los dominios concretos de FRI; no se formaliza aquí el radio real arbitrario |
| N05 | Conteo hipergeométrico exacto de muestras uniformes sin reemplazo; cota según el número de parejas malas | Lema B de todas las capas FRI, ceil(θM), cota exponencial y distribución hash |
| N06 | Pendiente | Estado conjunto y aceptación falsa del IOP |
| N07 | Pendiente | Registro del oráculo y extracción Merkle previa |
| N08 | Pendiente | Nonces adaptativos, potencial y cola del selector |
| N09 | Pendiente | Teorema ROM completo y correspondencia con Rust |
| N10 | Integridad de la evidencia histórica comprobada | No se repitió el corpus Rust/Python ni se demostró equivalencia general |
| N11 | Trabajo futuro conservado | Transferencia QROM y cota de omisión |
| N12 | La condición numérica examinada falla para todo η' entero ≥1 en los tres perfiles; cuentas mínimas verificadas | Correspondencia bibliográfica y del backend, obligaciones R1-A–E y seguridad de ML-DSA |

Los resultados generales cuantifican sobre campos, polinomios y dominios
arbitrarios que satisfacen las hipótesis. No son enumeraciones de campos
pequeños. N12 verifica una desigualdad concreta y no demuestra un ataque.

## Organización de las pruebas

N01–N04 y N12 separan `Enunciado.lean` de `Solucion.lean`. Las definiciones
de distancia están en [Nexus/Distancia.lean](Nexus/Distancia.lean); la parte de
muestreo de N05 está en [Nexus/N05/Muestreo.lean](Nexus/N05/Muestreo.lean).
[Auditoria.lean](Auditoria.lean) comprueba los tipos de las soluciones y lista
los axiomas de todos los teoremas registrados en [cobertura.json](cobertura.json).

El ejemplo `Nexus.cuadrado_suma` solo comprueba el entorno y no cuenta entre
los 17 resultados de la tesis.

## Ejecución reproducible

Desde la raíz del repositorio, tras `python scripts/lean.py preparar`:

```powershell
python scripts/lean.py build
python scripts/lean.py lean Auditoria.lean
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py -v
python scripts/verificar_formalizacion.py
```

El verificador crea una carpeta nueva en `.tools/lean/validaciones/`; `--salida`
permite elegir otra carpeta nueva. Rechaza sobrescribir ejecuciones. Compila
sin advertencias, exige la lista completa de teoremas y admite únicamente
`propext`, `Classical.choice` y `Quot.sound`. Rechaza `sorryAx`, axiomas
adicionales y resultados de auditoría ausentes o duplicados. Los cinco
controles del analizador verifican esos rechazos y no sustituyen las pruebas Lean.

Después ejecuta `leanchecker` por cada uno de los siete módulos que contienen
las pruebas. Esto vuelve a pasar las declaraciones propias por el núcleo,
confiando en sus módulos importados. Es el comprobador incluido en Lean,
no una ejecución `--fresh`, Comparator ni un verificador externo independiente.
La ejecución por módulo evita cargar simultáneamente varias copias de mathlib.

La [evidencia del 16 de octubre](../Documentos/06-Evidencia-TG2/2026-10-16/Lean/validacion.json)
contiene los axiomas de cada teorema, versiones, registros de ejecución y
SHA-256 de fuentes, catálogo y archivos históricos utilizados. El commit
documental registrado da contexto; los hashes identifican el árbol de trabajo
efectivamente ejecutado aunque aún no se haya hecho commit.

El [catálogo del 12 de octubre](../Documentos/04-Administrativo-TG2/Avances/Catalogo-Validacion-2026-10-12/catalogo.json)
permanece como instantánea histórica. `cobertura.json` registra el avance
actual sin convertir sus estados anteriores en una certificación integral.

## Siguiente obligación matemática

Conectar las fórmulas AIR concretas con N01–N02 y completar la rama no base
de N03. Después se puede instanciar N04 en cada plegado, demostrar el lema B
de N05 y construir el estado conjunto N06. La extracción Merkle y el modelo
de consultas adaptativas de N07–N09 requieren sus propias definiciones
probabilísticas y temporales; una suma de las cotas ya demostradas no los
establece por sí sola.
