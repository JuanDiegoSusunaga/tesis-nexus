# Revisión crítica interna de la demostración ROM

**Fecha:** 23 de septiembre de 2026. **Rama:** `main`. **Estado:** demostración ampliada propuesta; revisión independiente pendiente.

Se refuerza el argumento de nonces adaptativos mediante una cuenta de potencial y se contrastan las premisas de extracción Merkle y del canal. La fórmula ROM y el protocolo TG2 v1 conservan sus parámetros.

- [Hallazgos, demostración ampliada y límites](Revision-Critica-ROM.md).
- [96 escenarios adaptativos con resultados exactos](calculos.json).
- [Ejecuciones, protección de archivos y fuentes](validacion.json).
- [Analizador reproducible](../../../../scripts/analizar_revision_rom_tg2.py).
- [12 pruebas de revisión](../../../../scripts/tests/test_revision_rom_tg2.py).

La búsqueda finita no encontró un caso que supere la cota. Incluye intercalación, abandono, repetición de índices y una verificación final gratuita. Sus 6.318 estados se cuentan por ejecución, con dos o tres candidatos simultáneos. La demostración general por potencial no impone esa capacidad.

La [transferencia anterior](../Transferencia-ROM-2026-09-23/README.md) y sus hashes se conservan como registro de la etapa previa. Este suplemento precisa sus §§5–8. No es una revisión externa, una reducción QROM ni una garantía de 100 bits.

## Reproducción

```powershell
python -m unittest discover -s scripts/tests -p test_revision_rom_tg2.py -v
python scripts/analizar_revision_rom_tg2.py --salida .tools/revision-rom/repeticion.json
python scripts/verificar_revision_rom_tg2.py --salida .tools/revision-rom/verificacion
```

El registro completo ejecuta las 40 pruebas Python de estas etapas, las 197 Rust y check/build. Cargo usa `C:/tmp/nexus-target`, con dependencias locales. Las salidas rechazan sobrescrituras; elegir otra carpeta para cada repetición.
