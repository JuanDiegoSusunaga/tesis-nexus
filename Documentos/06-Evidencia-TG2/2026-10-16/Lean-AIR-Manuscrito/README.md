# AIR y ampliación al manuscrito completo

**Fecha:** 16 de octubre de 2026. **Resultado:** compilan 40 lemas y teoremas
registrados, pasan la auditoría de axiomas y la recomprobación del núcleo de
once módulos ejecutados por separado. La tesis completa sigue pendiente.

- [Informe, cobertura y hashes](validacion.json).
- [Axiomas de los 40 resultados](axiomas.log).
- [Compilación](build.log).
- [Alcance, resultados y obligaciones pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).
- [Inventario del manuscrito](../../../../formalizacion/inventario-manuscrito.json).

Esta etapa añade 23 resultados a los 17 de la
[primera ejecución](../Lean/README.md): doce sobre AIR y residuos polinómicos,
seis sobre costos y amortización, cuatro sobre residencia y los redondeos
de la tabla 5.2, y el lema de diferencia de preimágenes de retículos.

La equivalencia AIR demuestra, para un campo arbitrario, T ≥ 3 y una raíz
primitiva de orden T, que las condiciones de frontera y de transición se
cumplen si y solo si los tres residuos son nulos. También se conecta una
traza inválida fija con la cota de cancelación. Quedan pendientes los campos,
raíces y operaciones concretos de la implementación y otros componentes
del protocolo, entre ellos las capas FRI y el modelo Merkle/ROM.

El inventario registra 272 candidatos en ocho fuentes del manuscrito; es
un barrido inicial que requiere revisión semántica. Sus candidatos no son
teoremas independientes y no definen un porcentaje de avance. El informe
conserva los hashes de esas fuentes, del inventario y del dato histórico
R5 usado en el modelo de residencia.

Los registros `kernel-*.log` corresponden al `leanchecker` incluido en Lean
4.35.0. Se recomprueba cada módulo propio confiando en sus importaciones;
no se ejecutó `--fresh` ni un verificador externo. Los axiomas admitidos
son `propext`, `Classical.choice` y `Quot.sound`. La correspondencia de los
enunciados con el manuscrito requiere además revisión matemática.

Los nueve archivos históricos del catálogo conservaron sus SHA-256. La
revisión documental del informe da contexto; los hashes identifican los
bytes del árbol de trabajo efectivamente ejecutados. No se sustituyeron
los registros de la primera ejecución.

Para repetir y conservar una ejecución nueva, desde la raíz del repositorio:

```powershell
python scripts/lean.py preparar
python scripts/verificar_formalizacion.py
```

No sustituir los archivos de esta carpeta por los de otra ejecución.
