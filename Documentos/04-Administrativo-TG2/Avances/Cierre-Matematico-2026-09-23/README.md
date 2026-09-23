# Investigación matemática TG2 — solidez del protocolo ideal por rondas

**Fecha:** 23 de septiembre de 2026. **Rama en ambos repositorios:** `investigacion/cierre-matematico-tg2`.

**Estado:** derivación escrita y contrastes finitos; pendiente de revisión matemática independiente. Este avance pertenece a la rama de investigación. El manuscrito y el Word de derivaciones anteriores conservan su edición identificada.

## Resultado de esta etapa

Se construye una función de estado para el IOP conjunto de AIR, FRI de traza, FRI de composición y consulta común. Se obtiene una cota por ronda, además de una cota ordinaria más ajustada, bajo oráculos completos inmutables y retos uniformes frescos. El argumento incluye el candidato fuera del campo base y los tres coeficientes AIR enviados por separado.

Para los parámetros existentes, las nuevas cotas ideales superiores van de **0,000166165 a 0,004757331**, según el tamaño. Son límites superiores derivados en el modelo indicado: no son tasas de ataque observadas ni garantías del ejecutable.

- [Demostración y límites](RBR-AIR-FRI.md).
- [Fracciones exactas de nueve perfiles](calculos.json).
- [Comprobaciones y procedencia](validacion.json).
- [Script de cálculo](../../../../scripts/analizar_rbr_conjunto_tg2.py).
- [Pruebas finitas](../../../../scripts/tests/test_rbr_conjunto_tg2.py).
- [Fuente primaria conservada: GMW, revisión del 31 de marzo de 2026](bibliografia/GMW25.pdf).

## Qué queda pendiente

1. Revisar independientemente el lema elemental y la función de estado conjunta.
2. Probar la correspondencia del canal concreto con una compilación segura: extracción de oráculos Merkle, estados hash, distribución de retos, consulta generada mediante una cadena y reinicios con nonces.
3. Fijar un presupuesto de consultas del adversario y calcular las pérdidas en ROM; QROM necesita su propia reducción y constantes.
4. Continuar R1-A–D para ML-DSA: el argumento AIR/FRI no resuelve esas obligaciones.

No se ha publicado ni fusionado la rama. La aprobación anterior del director no se atribuye a estos resultados.

## Reproducción

Desde la raíz del repositorio:

```powershell
python -m unittest discover -s scripts/tests -p test_rbr_conjunto_tg2.py -v
python scripts/analizar_rbr_conjunto_tg2.py --salida .tools/cierre-matematico/repeticion.json
python scripts/verificar_version_tg2.py
```

El cálculo rechaza sobrescribir una salida existente. El manifiesto de la edición anterior sigue cubriendo sus 897 archivos de manuscrito y evidencia histórica. Esta carpeta de investigación está fuera de ese alcance y tiene un registro propio de hashes, además de su revisión Git.
