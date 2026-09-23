# Transferencia al protocolo concreto TG2 v1

**Fecha:** 23 de septiembre de 2026. **Integración:** `main` en documentos y código, por solicitud del autor.

Se desarrolla una cota de solidez para el algoritmo de la variante **NEXUS-TG2-LINKED-FRI-v1**, modelando sus llamadas a SHA3-256 mediante un único oráculo aleatorio clásico. El análisis incluye extracción de oráculos desde el registro de consultas, transcripción comprimida, sesgo de campo, muestreo sin reemplazo y búsqueda de nonces.

**Estado:** demostración escrita propuesta, pendiente de revisión independiente. El modelo no proporciona una prueba incondicional de SHA3 real ni una reducción QROM.

- [Teorema, demostración y correspondencia con el código](Transferencia-Protocolo-ROM.md).
- [108 escenarios con fracciones exactas](calculos.json).
- [Verificación independiente completa de los 14 certificados](corpus.json).
- [Pruebas, fuentes y hashes](validacion.json).
- [Cálculo y extractor de referencia](../../../../scripts/analizar_transferencia_rom_tg2.py).
- [Verificador Python de AIR, FRI, Merkle y transcripción](../../../../scripts/verificar_certificados_tg2.py).

El verificador independiente acepta los ocho certificados honestos y rechaza los seis lejanos en FRI de traza, igual que Rust. La auditoría anterior solo verificaba aperturas y transcripción; esta etapa añade las ecuaciones AIR y los plegados. Los ensayos finitos no sustituyen la prueba general.

## Interpretación de la cota

La cota depende de las consultas del adversario. Para `T=4096`, perfil release de 20 bits y `Q=2^20` consultas, el límite superior es **0,004757335454**; con `Q=2^28`, esta cuenta llega a 1 y deja de dar una garantía útil. Esto describe el alcance de la demostración, no una tasa de ataques observados. Los parámetros actuales no quedan acreditados como seguridad de 100 bits.

## Reproducir sin sobrescribir evidencia

```powershell
python -m unittest discover -s scripts/tests -p test_transferencia_rom_tg2.py -v
python scripts/analizar_transferencia_rom_tg2.py --salida .tools/transferencia-rom/repeticion.json
python scripts/verificar_transferencia_rom_tg2.py --salida .tools/transferencia-rom/verificacion
```

Los generadores rechazan sobrescrituras. La verificación requiere el corpus previo y las dependencias Rust instaladas. Conserva fuentes y repite check/test/build. La producción STARK de TG1 y el corpus histórico se preservan. Los informes anteriores registran etapas anteriores; este complemento actualiza el estado de la transferencia clásica ROM.

## Próximas obligaciones

Revisión independiente de la extracción, la contabilidad de consultas y el argumento adaptativo de nonces; reducción QROM con pérdidas explícitas; decisión sobre los parámetros si se exige una cota criptográfica más fuerte. R1-A–D sobre ML-DSA permanece como obligación distinta.
