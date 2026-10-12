# Revisión independiente de evidencia experimental — TG2

**Fecha:** 12 de octubre de 2026. **Naturaleza:** revisión técnica interna por subagente, con contraste de fuentes primarias web. No constituye dictamen del director ni revisión matemática externa. No se ejecutaron nuevos benchmarks ni se modificaron datasets históricos, fuentes Rust, TG1 o el manuscrito compartido.

La serie R4 y su complemento tienen respaldo suficiente para conservar sus resultados como mediciones de componentes aislados. La conciliación de sus estadísticas y fuentes pasó **451 comprobaciones**, sin discrepancias. Las cifras H1/H2 y la caché Criterion recuperada deben conservar identidades distintas: la coincidencia de equipo o de fecha no permite afirmar que correspondan a la misma ejecución. No hace falta repetir los benchmarks de septiembre para resolver esa diferencia histórica.

Resultados reproducibles en [conciliacion.json](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/Evidencia/conciliacion.json), generados por [conciliar.py](../../../06-Evidencia-TG2/2026-10-12/Revision-subagentes/Evidencia/conciliar.py). El script solo lee archivos conservados y escribe su informe nuevo. Comprueba hashes del inventario recuperado y de instantáneas de fuentes; recalcula las 29 medianas Criterion y sus intervalos; contrasta 40 mediciones STARK y sus ocho resúmenes; comprueba 40 cuentas/relojes multinúcleo, ocho resúmenes y el corpus público; recalcula cinco escenarios R5. No reestima el bootstrap: verifica que sus límites almacenados coinciden con los publicados.

## 1. Procedencia comprobada

| Serie | Identidad y materiales | Alcance de la identificación |
|---|---|---|
| H1, julio de 2026 | Cap. 6, Tablas 6.5–6.6 y cifras clásicas/residencia referidas al README histórico | Resultado publicado; no se identificó en esta revisión una instantánea de fuentes, comando y muestras atribuible inequívocamente a cada cifra H1 |
| H2, 7 de agosto de 2026 | Cap. 6, Tablas 6.7–6.9; perfil Core Ultra 9 275HX | Resultado publicado; no unir automáticamente a la caché encontrada después |
| Caché recuperada, inventario del 22 de septiembre | `2026-09-22/inventario.json`, `criterion/**/new/{sample,estimates,benchmark,tukey}.json` | Archivos preexistentes copiados y verificados por SHA-256; el HEAD observado y el mtime no autentican la revisión o fecha de una corrida histórica |
| R4 inicial, 22 de septiembre | `R4-validacion/mediciones.json`, `equipo.json`, `fuentes/`, logs, JSON Criterion y `stark.csv` | Inicio 12:55:11, fin 13:01:34, zona −05:00. HEAD `6ec77633951004f37088abcdd41aa78ad290f36f` con cambios locales; los hashes de la instantánea identifican las fuentes. Dos ejecuciones bloqueadas se preservan |
| Complemento R4, mismo día | `R4-complemento/ejecucion.json`, `fuentes/`, `resumen.json`, JSON Criterion, `throughput.csv`, `corpus-publico.bin` | Inicio 13:32:30, fin 13:33:59, zona −05:00. Mismo HEAD con cambios locales. Smart App Control registrado en 0 después del cambio comunicado por el autor. ML-DSA y throughput finalizaron con código 0 |
| R5 | `R5-residencia/{sensibilidad.json,tabla-sensibilidad.md,representaciones.log,validacion.json}`, fuentes conservadas | Inventario de representaciones, pruebas de reconstrucción desde semilla y modelo de residencia; no captura exhaustiva de memoria |

R4 registra Windows 11 Home Single Language 10.0.26200, CPU Intel Core Ultra 9 275HX, 24 núcleos y 24 procesadores lógicos, plan Equilibrado y aproximadamente 32 GiB visibles. Toolchain: rustc 1.97.1 (`8bab26f4f`, 2026-07-14), cargo 1.97.1, destino `x86_64-pc-windows-msvc`, LLVM 22.1.6. El `Cargo.lock` de la instantánea fija **Criterion 0.5.1, fips204 0.4.6, p256 0.13.2, rsa 0.9.10 y zeroize 1.8.2**. Estos son metadatos preservados, sin reemplazarlos por la configuración actual.

Los argumentos exactos se conservan en los JSON de ejecución. Para Criterion: `cargo bench -p nexus-crypto --bench <harness> --locked --offline --manifest-path nexus/Cargo.toml -- --noplot --sample-size 50 --warm-up-time 1 --measurement-time 2 --save-baseline <r4 o r4-complemento>`. El harness RSA-2048 KeyGen fija diez muestras. STARK y throughput se ejecutaron con `cargo run --release --locked --offline`, sus ejemplos y destinos registrados. No hubo afinidad de CPU ni aislamiento exclusivo; los comandos se ejecutaron secuencialmente.

## 2. Mapa de afirmación, tabla y respaldo

Todas las rutas de esta tabla se refieren a `Documentos/06-Evidencia-TG2/2026-09-22/`, salvo indicación distinta. Los localizadores por capítulo/sección no dependen de la paginación Word/PDF.

| Afirmación / localizador | Dataset y respaldo exacto | Resultado de revisión y acción |
|---|---|---|
| Latencias H1, Tabla 6.6 y conclusiones históricas | Publicación histórica citada en §6.6.1; no dataset inequívocamente atribuido a H1 en el paquete examinado | Mantener como históricas con respaldo limitado. Buscar primero logs/commit originales; una corrida actual no reconstruye H1 |
| Latencias H2, Tabla 6.7 y ML-DSA de Tabla 6.8 | H2 publicado; caché `criterion/verification/dilithium3/new/estimates.json` contiene una cifra próxima distinta | Conservar 77,6 µs como cifra publicada y 77,170 µs como recuperada, sin presentarlas como una sola corrida |
| Menor verificación ML-DSA que las bases clásicas, Tablas 6.4/6.8 | Tabla histórica; nuevas bases clásicas en R4 y ML-DSA en complemento separados | Válido como observación de bibliotecas/serie concreta. No demuestra superioridad general, comparación pareada o madurez equivalente |
| PoC STARK histórica, Tabla 6.9 | Serie anterior; R4 registra una nueva serie de la recurrencia con cinco testigos | No imputar nuevos tiempos a la corrida histórica ni a la variante TG2 v1 con FRI de traza vinculada |
| Tamaños históricos de Tabla 3.3 | 132/268/445 KB frente a 132072/267880/444648 B de R4 para 16/256/4096 filas | La magnitud coincide al redondear **KB decimales**. Tabla 6.9 usa KiB aunque rótulo histórico diga KB. Aclarar unidades; esto no prueba igualdad de bytes o de ejecución |
| Latencias clásicas R4, Tabla 6.10 | `R4-validacion/resumen-mediciones.json`, `criterion/classical_*/<caso>/r4/{estimates,sample}.json`, `classical_baseline.log` | Ocho casos reproducen mediana, IC y n; manténganse, sin repetir |
| Firma cacheada/efímera y expansión, Tabla 6.11 y §5.6.4 | `R4-validacion/criterion/{firma_cacheada,firma_efimera,keygen_desde_semilla}/<nivel>/r4/`, `residencia_bench.log` | Nueve casos reproducen estadísticas. Diferencia ML-DSA-65 = 151,327195 µs; no es medición pareada de sobrecosto ni duración observada de todas las regiones secretas |
| STARK repetido, Tabla 6.12 | `R4-validacion/stark.csv`, `stark.log`, `fuentes/nexus-zk/examples/tg2_stark_measure.rs` | 40 filas, ocho tamaños y cinco repeticiones; generación mediana/rango y verificación mediana de cinco medias de veinte verificaciones coinciden. Rango no es IC |
| ML-DSA complemento, Tabla 6.13 | `R4-complemento/criterion/<operación>/<nivel>/r4-complemento/`, `resumen.json`, `dilithium_bench.log` | Doce casos reproducen estadísticas, incluida Verify ML-DSA-65 84,610354691 µs. No reemplazan retrospectivamente H2 |
| Multinúcleo corregido, Tabla 6.14 | `R4-complemento/throughput.csv`, `throughput.log`, `corpus-publico.bin`; instantáneas `examples/tg2_throughput.rs` y `experiments/tg2_throughput.rs` | Cuentas por trabajador y denominadores coinciden; mediana 136389,689738 verif./s con 24 hilos, razón 11,044967 frente a uno. No son transacciones/s de la aplicación |
| Representaciones de clave, Tabla 5.1 | `R5-residencia/representaciones.log`, fuentes del backend y `tests/tg2_residence.rs` | 4032 B codificados, 3936 B componentes sensibles, 17536 B objeto `PrivateKey`; 5993 B par serializado no equivale a RAM secreta |
| Sensibilidad de residencia, Tabla 5.2 | `R5-residencia/sensibilidad.json` y script conservado | Cinco escenarios aritméticos coinciden. Usa 478,744078947 µs como duración fija supuesta; no mide probabilidad de captura ni residencia física |
| Datos de amortización, §6.6.5 | Escenario F(m), 786600 B de prueba STARK R4 y supuestos d=32 B, c=128 B | Modelo aritmético explícito; no acredita correspondencia entre filas AIR y transacciones ML-DSA |

## 3. Conciliación de 77,170 frente a 77,6 µs

La mediana recuperada es **77,16965449804432 µs**; la publicada es **77,6 µs**. Diferencia −0,43034550195567 µs, equivalente a −0,5545689458 %. No es una diferencia de redondeo a una decimal: la mediana recuperada redondearía a 77,2 µs.

El inventario conserva `mtime_origen` equivalente a **7 de agosto de 2026, 11:18:54 −05:00**. Coincide con la fecha declarada H2, pero `benchmark.json` solo identifica `verification/Dilithium3`, sin commit, comando, equipo o identidad de sesión. El mtime puede cambiar y no constituye firma de procedencia. Tampoco basta observar que las cifras son próximas para fusionarlas.

El contraste se extiende a las nueve cifras de Tabla 6.7; no es una única discrepancia aislada. Valores recuperados redondeados aquí a tres decimales, con exactos y hashes en `H2_contraste` del JSON nuevo:

| Operación | Nivel | H2 publicada (µs) | Caché recuperada (µs) |
|---|---:|---:|---:|
| Generación | 2 | 92,5 | 87,294 |
| Generación | 3 | 142,1 | 143,344 |
| Generación | 5 | 198,1 | 197,788 |
| Firma | 2 | 183,0 | 184,035 |
| Firma | 3 | 290,0 | 288,668 |
| Firma | 5 | 343,3 | 344,156 |
| Verificación | 2 | 48,8 | 49,064 |
| Verificación | 3 | 77,6 | 77,170 |
| Verificación | 5 | 129,2 | 129,768 |

**Decisión recomendada:** dar por conciliada su **clasificación**, conservando dos registros y la salvedad histórica. Mantener pendiente la reconstrucción de la corrida H2 exacta mientras no aparezcan logs originales. Si se necesita una cifra principal plenamente trazable para TG2, usar 84,61 µs del complemento R4 con sus condiciones, citando H1/H2 como antecedentes. No repetir una corrida actual para intentar demostrar qué ocurrió en agosto.

## 4. Qué mide la ruta cacheada y qué no mide residencia

La instantánea de `residencia_bench.rs` retiene un `DilithiumKeypair` codificado en la ruta cacheada. El wrapper vuelve a copiar y deserializar la clave en cada firma, creando el objeto `PrivateKey` con precomputación. Por ello no compara «precomputación del backend permanentemente cacheada» contra «reexpansión completa»; compara las dos rutas concretas del wrapper. La ruta efímera expande la misma semilla pública de ensayo, firma y libera el par; no renueva entropía ni rota la época. Cap. 5 §5.6 ya lo distingue correctamente.

Las medianas 327,416883943 y 478,744078947 µs dan la diferencia descriptiva 151,327195005 µs, que redondea a **151,33 µs**. El valor 151,32 del manuscrito procede de restar primero las medianas ya redondeadas (478,74−327,42); conviene usar los valores fuente antes de redondear. La expansión aislada es 145,03 µs. No sumarlas ni exigir igualdad: son benchmarks distintos, con asignación, copia, firma hedged y destrucción; resta de medianas no es mediana de diferencias. Los 0,75/0,12 ms históricos de Cap. 5 y Cap. 7 deben conservar rótulo histórico y no sustituir los resultados R4.

La documentación primaria de **zeroize 1.8.2** garantiza que la operación de borrado no se elimina por optimización, pero advierte copias por movimientos/reasignación y límites relativos a registros y canales microarquitecturales. Un contrato `ZeroizeOnDrop` o un `size_of` no acredita que todas las copias hayan desaparecido. Es coherente conservar la limitación vigente del manuscrito. [Documentación de la versión usada](https://docs.rs/zeroize/1.8.2/zeroize/).

La captura de una semilla suficiente conserva capacidad de reconstrucción aunque se libere la clave expandida. El modelo W/T declara regiones elegidas y cuenta la semilla de 32 B más el contenedor codificado de 4032 B; incluye 96 B públicos porque protege el contenedor completo. Sus razones de residencia no son razones de probabilidad de compromiso. No hace falta repetir un benchmark de firma para confirmar esta limitación.

## 5. Contraste metodológico con fuentes primarias web

Criterion distingue calentamiento, medición, análisis y comparación. Cada muestra puede contener numerosas iteraciones; los tiempos por iteración se obtienen dividiendo duración por iteraciones. Su análisis usa remuestreo bootstrap para estimar mediana e intervalos y mantiene los atípicos en el análisis. Por ello «50 muestras» no significa cincuenta ejecuciones individuales ni cincuenta días independientes. El IC de una corrida no cuantifica por sí solo variación entre equipos/días. [Proceso de análisis oficial](https://bheisler.github.io/criterion.rs/book/analysis.html).

La conservación de baselines con nombre permite separar series y evitar atribuir la carpeta mutable `new` a una corrida única. La documentación distingue `--save-baseline`, que puede sobrescribir un baseline, de `--baseline`, que compara sin modificarlo; nuestros archivos de septiembre se leen sin volver a ejecutar esa escritura. [Opciones oficiales](https://bheisler.github.io/criterion.rs/book/user_guide/command_line_options.html).

Para una **fuente concreta de entropía**, SP 800-90B exige caracterización y datos crudos; las pruebas de salud se aplican antes del acondicionamiento. Su §3.1.1 pide al menos un millón de muestras secuenciales y datos de reinicio 1000×1000 para la validación correspondiente. Ejecutar RCT/APT sobre salida sintética o ya acondicionada no equivale a calificar físicamente la fuente. Esta es una obligación distinta de los tiempos de firma y la residencia. [NIST SP 800-90B, §§3.1.1 y 4.3](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-90B.pdf). La página oficial registra erratas potenciales del 29 de mayo de 2025; deben revisarse al concretar la fuente. [Estado oficial](https://csrc.nist.gov/pubs/sp/800/90/b/final).

## 6. Correcciones concretas recomendadas

1. **Cap. 6, inicio de §6.6 y contraste de §6.6.1:** sustituir «dos perfiles permiten aislar» y «es exactamente lo que predice; hardware no forma» por «las razones observadas son compatibles con el modelo para estos parámetros y perfiles; no aíslan causalmente hardware ni prueban el comportamiento asintótico». Son tres niveles con n=256 fijo y condiciones históricas limitadas.
2. **Cap. 6 §6.6.3:** separar la forma estructural de tamaños (capas/caminos) de los tiempos. Los incrementos medidos no prueban una ley asintótica. La frase «la verificación exhibe el mismo patrón» no acredita un ajuste cuadrático sin análisis de residuos/dispersión.
3. **Tabla 3.3:** rotular «KB decimales; cifra histórica redondeada», distinguiéndola de KiB de Tablas 6.9/6.12. Las tres magnitudes concilian por unidades/redondeo; las latencias 6,0/8,9/12,9 ms siguen como otra serie histórica.
4. **nexus/README.md, párrafo de R4 cercano a línea 45:** agregar que el complemento completó las ejecuciones; la frase vigente «no tiene una cifra optimizada medida» quedó obsoleta. Mantener intactos los logs históricos del fallo. Este cambio debe tramitarlo la raíz porque el repositorio Rust tiene reglas de revisión comunes.
5. **Cap. 6 Tablas 6.9/6.12 y referencias al PoC:** explicitar que el harness medido llama a la API STARK heredada. No atribuir esos tiempos a TG2 v1 con FRI de traza vinculada, cuyo costo no fue medido por esos datasets.
6. **Cierre de evidencia:** registrar que se verificó la reproducción de estadísticas R4 y se delimitó la diferencia histórica. No dejar la expresión general «conciliación pendiente» como si las tablas nuevas carecieran de respaldo. La reconstrucción exacta de H1/H2 permanece abierta y separada.
7. **Cap. 5 §5.6.4 y Cap. 6 §6.6.4:** calcular la diferencia descriptiva desde los JSON completos antes de redondear y reportar 151,33 µs. Mantener la salvedad de comparación no pareada. No modificar los informes históricos que restaron 478,74−327,42.

## 7. Repeticiones necesarias y límites de cierre

**No es necesario** repetir las series R4, su complemento ni R5 para documentar las cifras conservadas. Tampoco repetir las ejecuciones que Windows bloqueó: el complemento ya satisface esa acción. La cifra histórica de 199218 verif./s no debe usarse como capacidad validada; el ensayo corregido de 24 hilos registra 136390 verif./s, sin atribuir causalmente toda la diferencia al reloj.

**Sí se necesitaría nueva medición, con destino independiente y sin sobrescribir**, si el manuscrito quiere afirmar alguno de estos resultados nuevos: rendimiento de la variante TG2 v1; duración física observada de las regiones secretas; menor probabilidad de captura; comparación causal o entre días; o capacidad de la aplicación completa con verificación ML-DSA dentro del AIR, persistencia, consenso y anclaje. Esas afirmaciones hoy no están respaldadas por estas mediciones y pueden mantenerse fuera del alcance de cierre.

Una integración y calificación de fuente de entropía requiere su propia adquisición de datos crudos y protocolo. No se resuelve midiendo firmas más veces. Quedan pendientes el alcance académico aprobado de esa fuente, su custodia y las integraciones operativas. QROM completo permanece como investigación futura según la decisión del autor; esta auditoría de rendimiento no cambia esa decisión.

**Para el cierre actual:** incorporar las correcciones de rótulo y fuerza de conclusión; conservar los 29 casos Criterion, 40 STARK y 40 multinúcleo con el mapa anterior; presentar el informe al director como revisión interna y mantener el dictamen académico separado. La sustentación no se prepara en esta etapa, según instrucción del autor.
