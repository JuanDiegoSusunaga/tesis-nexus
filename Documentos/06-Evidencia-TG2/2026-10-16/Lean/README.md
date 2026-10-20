# Primera comprobación Lean de NEXUS

**Fecha:** 16 de octubre de 2026. **Resultado:** compilan 17 lemas y teoremas
de componentes de N01–N05 y N12. Pasan la auditoría de axiomas y la
recomprobación del núcleo de siete módulos, ejecutados por separado.

- [Informe y hashes](validacion.json).
- [Axiomas por teorema](axiomas.log).
- [Compilación](build.log).
- [Cobertura, hipótesis, límites y reproducción](../../../../formalizacion/VERIFICACION.md).

La cobertura alcanza componentes de seis afirmaciones del catálogo. Las
construcciones AIR concretas y su correspondencia con Rust, el estado conjunto
del IOP y la transferencia Merkle/ROM permanecen pendientes. QROM conserva su
estado de trabajo futuro. Esta evidencia no declara verificada la tesis completa.

Los nombres `kernel-*.log` corresponden al `leanchecker` incluido en Lean
4.35.0. El comprobador vuelve a verificar las declaraciones de cada módulo
propio, confiando en sus módulos importados; no es un verificador externo.
Los archivos históricos del catálogo conservaron sus nueve SHA-256.

El informe registra hashes de las fuentes efectivamente ejecutadas, incluidas
las definiciones y los enunciados. El commit documental da contexto al árbol
de trabajo y puede preceder a la incorporación de los nuevos archivos.

Para repetir en una carpeta nueva:

```powershell
python scripts/lean.py preparar
python scripts/verificar_formalizacion.py
```

No sustituir los registros de esta carpeta por los de otra ejecución.
