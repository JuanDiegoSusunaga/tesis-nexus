# R2 — Monitor de entropía y recuperación

**Fecha:** 22 de septiembre de 2026. **Resultado:** implementación del monitor del prototipo corregida y verificada. La vinculación y calificación de una fuente concreta de despliegue siguen requeridas. R3 conserva pendiente la renovación de claves operativas y el registro auditable.

## Cambios realizados

1. **APT:** suma numérica de la distribución binomial, sustituyendo la aproximación normal. Para H=7,5 y α=2⁻²⁰, W=512 y C=16. El contador incluye la referencia y falla al alcanzar C. Las ventanas se reinician en 512 muestras; el RCT continúa a través de sus fronteras.
2. **Arranque bloqueado:** crear una semilla no declara sana la fuente. La evaluación acumula 65.536 muestras entre llamadas, con histograma de tamaño fijo. Un lote parcial o vacío no habilita la derivación inicial.
3. **Fallo retenido:** un fallo RCT/APT o una frecuencia máxima empírica incompatible con la barra bloquea derivación y renovación de semilla. Enviar posteriormente un lote favorable no borra ese estado.
4. **Recuperación explícita:** `begin_source_recovery` abre una reevaluación sin declarar salud. Tras un lote completo favorable debe renovarse la semilla. La rotación conserva los controles continuos y el historial.
5. **Integración de API:** `rotate` devuelve `Result`; el gestor propaga el error. La derivación sin comprobaciones es privada. `KeyManager` permite entregar muestras y consultar/iniciar recuperación sin exponer la semilla.
6. **Configuración y errores:** parámetros de entropía inválidos quedan bloqueados; `try_new` informa el error. El contador de épocas rechaza desbordamiento. Si `OsRng` falla, la rotación no instala otra semilla.

## Modelo y límites

El modelo operativo del APT es B=1+Bin(511,2⁻⁷·⁵). La cola en C=15 es 1,522690×10⁻⁶; en C=16 es 2,764095×10⁻⁷, menor que α=9,536743×10⁻⁷. El resultado depende de las hipótesis declaradas sobre las muestras; se comprobó también el conteo de la referencia.

SP 800-90B diferencia muestras de ruido y salidas condicionadas; su APT usa ventanas de 512 para fuentes no binarias y de 1024 para binarias. Su estimador MCV completo incluye un límite de confianza. El barrido de la Decisión 001 y el control complementario actual usan frecuencia máxima **puntual**, sin ese límite ni una comprobación de independencia. [Fuente primaria: NIST SP 800-90B, §§4.3–4.4 y 6.3.1](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-90B.pdf).

La implementación evalúa el flujo que aporta la aplicación. La semilla inicial procede de ChaCha20 inicializado desde el generador del sistema operativo y la renovación obtiene material de `OsRng`. No se ha implementado un acceso a la fuente física de ruido del sistema operativo ni una vinculación automática entre el flujo observado y esa fuente. El despliegue debe documentar dicha relación, la calificación y el margen de al menos 0,2 bits sobre la barra exigido por la Decisión 001. Superar los controles no certifica entropía física, secreto de la semilla o conformidad FIPS.

## Estados de la derivación

| Situación | Derivación | Renovación de semilla | Transición requerida |
|---|---|---|---|
| Arranque o lote inicial incompleto | Bloqueada | Bloqueada | Completar un lote favorable |
| Evaluación favorable, política vigente | Habilitada | Permitida | Continuar el monitoreo |
| Fallo RCT/APT o frecuencia máxima insuficiente | Bloqueada | Bloqueada | Recuperar fuente externa e iniciar reevaluación |
| Reevaluación incompleta | Bloqueada | Bloqueada | Completar nuevas muestras |
| Reevaluación favorable tras recuperación | Bloqueada | Permitida | Renovar semilla |
| Renovación posterior a recuperación | Habilitada si la política lo permite | Permitida | Mantener controles e historial |
| Configuración inválida | Bloqueada | Bloqueada | Corregir la configuración del componente |

## Verificación ejecutada

El autor solicitó expresamente añadir y ejecutar las pruebas en esta sesión. Se ejecutaron, con dependencias locales y `CARGO_TARGET_DIR=C:\tmp\nexus-target`:

```powershell
cargo check --workspace --all-targets --locked --offline --manifest-path nexus/Cargo.toml
cargo test --workspace --locked --offline --manifest-path nexus/Cargo.toml
cargo build --workspace --locked --offline --manifest-path nexus/Cargo.toml
```

**Resultado: 123 pruebas pasan, cero fallos.** Distribución: core 15, crypto 38, anchor 16, active 20 y zk 34. Se añadieron 13 casos R2 y se adaptaron los casos existentes a la evaluación inicial y al retorno fallible de `rotate`.

Las pruebas nuevas cubren el cálculo binomial independiente, fallo en la muestra de referencia número 16, fronteras de ventana, continuidad del RCT, configuración inválida, lotes parciales, independencia del tamaño de las llamadas, bloqueo por frecuencia máxima, recuperación seguida de rotación, conservación de monitores al rotar, fallo al final de una ingestión, historial deshabilitado/desbordamiento de época e integración con `KeyManager`.

Los registros conservan advertencias del workspace sobre importaciones, variables y campos sin uso; las tres órdenes terminaron correctamente. El ejemplo `apt_sweep` se actualizó para contrastar el corte vigente con el histórico y compiló con `--all-targets`; no se repitió su simulación masiva ni los benchmarks históricos.

**Evidencia:** [metadatos, comandos y hashes](../../06-Evidencia-TG2/2026-09-22/R2-monitor/ejecucion.json), [suite completa](../../06-Evidencia-TG2/2026-09-22/R2-monitor/r2-cargo-test.log), [compilación](../../06-Evidencia-TG2/2026-09-22/R2-monitor/r2-cargo-build.log). La carpeta `fuentes/` de esa evidencia conserva los archivos exactos. Los cambios locales que ya existían se identifican en los metadatos; no se atribuye esta ejecución al commit base sin esos cambios.

## Siguiente paso

Continuar R3: especificar y conectar la renovación de las claves almacenadas, su vigencia por época y el registro auditable. Actualmente `KeyManager::rotate_sentinel` renueva la semilla y conserva las claves ya almacenadas; las pruebas de R2 hacen explícito ese límite. La política de firma con claves existentes y su tratamiento histórico deben cerrarse en R3.
