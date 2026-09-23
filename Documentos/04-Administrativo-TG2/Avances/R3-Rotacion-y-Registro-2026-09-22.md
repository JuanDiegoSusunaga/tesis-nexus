# R3 — Rotación efectiva y registro de épocas

**Fecha:** 2026-09-22. **Actividad:** 3.2, Objetivo 3 de TG2.

**Resultado:** implementados y probados el gestor de claves por época y el registro público autenticado. `cargo check --workspace --all-targets`, `cargo test --workspace` y `cargo build --workspace` terminan correctamente: **142 pruebas pasan**, incluidas **19 nuevas** para R3. Se ejecutó además `rotation_demo`. Los benchmarks históricos no se repitieron.

**Evidencia:** [ejecución, comandos, hashes y alcance](../../06-Evidencia-TG2/2026-09-22/R3-rotacion/ejecucion.json), [registro de pruebas](../../06-Evidencia-TG2/2026-09-22/R3-rotacion/r3-cargo-test.log), [demostración](../../06-Evidencia-TG2/2026-09-22/R3-rotacion/r3-demo.log). Las fuentes exactas están preservadas dentro de `R3-rotacion/fuentes/`. La evidencia R2 se conserva por separado.

## 1. Cambio implementado

Antes de R3, `KeyManager::rotate_sentinel` renovaba la semilla sin sustituir las claves guardadas. Ahora prepara una semilla nueva, deriva una clave por identidad, crea un evento conjunto autorizado, lo verifica y finalmente instala las claves y la semilla. El descarte de los contenedores anteriores activa su borrado con `zeroize`.

La dirección del alta se conserva como identidad lógica. La clave pública, su identificador y su época cambian; la dirección derivada de la nueva clave pública no reemplaza automáticamente la identidad lógica. El gestor mantiene su identidad predeterminada y las etiquetas de claves.

Se eliminó una copia innecesaria del derivado de 32 bytes en `NexusKeypair::from_sentinel_seed`: el material temporal queda en `Zeroizing`, también al retornar un error. No se modificó la primitiva ML-DSA de TG1. Estas medidas no demuestran eliminación de toda copia en pila, registros, volcados o almacenamiento externo.

## 2. Política y API

| Operación | Comportamiento vigente |
|---|---|
| Reexpandir una semilla idéntica | Reproduce la misma clave; no cambia la época |
| Derivar una clave adicional | Consume una derivación de Sentinel y registra un alta |
| Rotar Sentinel desde el gestor | Sustituye todas las claves activas y avanza una época en un evento conjunto |
| Firmar una operación | Exige fuente evaluada y sana, edad y cupo válidos, y recuperación terminada |
| Retirar una identidad | Evento firmado por la clave saliente; revoca vigencia y descarta el secreto del gestor |

`sign` y `sign_default` devuelven `EpochSignature`: identidad y época se autentican junto al mensaje bajo un dominio propio. `get_key` y `default_key` exponen vistas públicas; `key_metadata` permite consultar metadatos. No entregan un objeto con capacidad privada de firma. `add_key` pasa a ser falible y exige pertenencia a la semilla vigente cuando hay Sentinel; `remove_key` registra el retiro y devuelve `Result<()>`, sin exportar el secreto.

La política cuenta **derivaciones**, no firmas. Para instalar una nueva época debe quedar cupo después de regenerar las identidades activas; si no queda, se rechaza la transición y se conserva el estado previo. Puede retirarse una identidad antes de volver a rotar. El retiro se permite aunque la fuente esté bloqueada: es una operación de revocación con un dominio distinto al de las operaciones de aplicación. La transición tras un fallo requiere reevaluación satisfactoria.

La API cambió dentro del prototipo; se revisaron y actualizaron sus llamadas en el workspace. El firmador primitivo, `SignedTransaction` y el sequencer heredados de TG1 no consumen todavía esta API. Por tanto, la política verificada corresponde al gestor y a `KeyRegistry`, sin atribuirla a toda ruta de firma existente.

## 3. Registro y autenticación

El nuevo módulo `nexus-crypto::registry` evita introducir una dependencia circular de `nexus-core` hacia la implementación ML-DSA. El formato público versión 1 usa bincode con enteros de ancho fijo, rechaza bytes sobrantes y limita la importación/exportación a 64 MiB.

Cada registro contiene versión, secuencia, hash completo del anterior, marca de tiempo y evento. Se admiten:

- **Alta:** identidad derivada de la clave inicial, época, clave pública y compromiso de semilla, si procede; firma de posesión de la clave inicial.
- **Rotación:** épocas consecutivas, compromisos de ambas semillas, motivo y todas las claves públicas sustitutas, ordenadas por identidad. Cada clave saliente autoriza el mismo evento y cada entrante prueba posesión firmándolo.
- **Retiro:** autorización de la clave vigente; el historial público permanece y la identidad no puede darse de alta otra vez.

La secuencia y el enlace SHA3-256 fijan el orden. La marca de tiempo es metadato firmado, sin garantía de tiempo certificado. El registro guarda información pública; no guarda semillas, derivados ni claves privadas.

Se emplean firmas de las claves de las cuentas, según su variante ML-DSA, en lugar de introducir una clave adicional de nodo como en el esquema inicial de la Decisión 002. Es una precisión de implementación registrada en esta sesión; no se atribuye aprobación académica adicional a esta variante.

## 4. Firmas vigentes e históricas

`verify_current` acepta únicamente la época vigente de una identidad activa. Después de rotar o retirar una identidad, sus firmas anteriores no sirven para operaciones vigentes.

`verify_historical` comprueba una firma contra la clave de su época, incluso retirada. **No prueba cuándo se creó la firma.** Una clave antigua comprometida todavía podría producir una firma matemáticamente válida para esa época. Para acreditar aceptación anterior al retiro, la aplicación debe aportar evidencia independiente de posición o inclusión en un historial confiable.

`verify_at_record` añade la comprobación de vigencia en el intervalo de posiciones del registro `[alta, retiro)`. La posición recibida debe proceder de esa evidencia confiable; un dato declarado por el firmante no basta. La prevención de repetición dentro de una época también necesita nonces y reglas propias de la aplicación.

## 5. Atomicidad, persistencia y confianza

La operación en memoria valida derivaciones, firmas, pertenencia y evento completo antes de instalar la transición. Las pruebas inyectan un error después de derivar la primera clave y un cambio incompatible que falla al validar el registro. En ambos casos permanecen iguales semilla, claves, metadatos y cabecera pública.

La recarga pública vuelve a verificar todos los eventos antes de reconstruir los índices. Se probó escritura de archivo con `sync_all`, descarte del gestor y recuperación del registro desde el archivo. **No se implementó persistencia de secretos ni recuperación de un firmador tras una caída.** Tampoco existe una transacción durable entre la custodia privada y un almacenamiento externo. Esas integraciones siguen abiertas.

El punto de control contiene longitud y cabecera completa de 256 bits. Al recargar, el registro debe conservar ese prefijo y no puede ser más corto. El punto debe autenticarse y guardarse fuera del archivo sometido a comprobación; guardar ambos bajo el mismo control del atacante no protege contra retrocesos. Un punto antiguo solo protege el prefijo ya comprometido y permite perder eventos posteriores sin detectarlo.

La demostración produce 3 eventos para 2 identidades ML-DSA-65: **28.416 B** de archivo y **17.498 B** para el evento de rotación. La estimación histórica de unos 150 B no incluía las claves públicas y las firmas. La ruta actual genera y verifica firmas síncronamente; no se ha medido ni demostrado un costo de microsegundos ni ausencia de bloqueo durante la rotación. Las consultas por identidad/época usan índices hash; reconstruir el historial requiere verificar todos sus eventos.

**Anclaje pendiente:** el registro no entra todavía en el estado del sequencer ni en L1. Los límites de aceptación y codificación de raíces del PoC requieren la revisión R4. La cabecera local y su checkpoint no se presentan como consenso ni inmutabilidad global.

## 6. Comprobaciones ejecutadas

Las 19 pruebas nuevas cubren cambio de todas las claves y conservación de identidad/default; autenticación de mensaje, identidad y época; bloqueo y recuperación; edad; cupo agotado; dos fallos intermedios; retiro; importación incompatible; altas entre rotaciones; recarga desde archivo; alteración de metadatos y firmas; eliminación/reordenamiento/duplicación; truncamiento y checkpoint antiguo; historial ajeno y último byte del hash; formatos truncados o sobrantes; rotación parcial; alta duplicada; y saltos de época, claves repetidas o identidades duplicadas.

Distribución final del workspace: core 15, crypto 57, anchor 16, active 20 y zk 34: **142/142**. No hubo fallos ni pruebas ignoradas. Persisten advertencias de compilación preexistentes sobre imports, variables y campos sin uso. La toolchain carece de `rustfmt`; la compilación y las pruebas validan sintaxis y comportamiento, sin atribuir una ejecución de ese formateador.

La demostración confirma: bloqueo por fallo y durante recuperación; claves cambiadas; firma anterior rechazada como vigente y aceptada como histórica; firma nueva aceptada tras recarga pública. No es un benchmark ni una certificación de fuente física.

## 7. Siguiente paso

**Edición documental comprobada:** Word de 83 páginas y PDF de 73, con índices propios, 19 tablas y 389 celdas idénticas a las fuentes. Las tablas y sus rótulos comparten página en Word; el PDF no presenta páginas vacías ni texto fuera de los márgenes comprobados. Se inspeccionaron las tres figuras y las 18 ecuaciones en bloque en ambos formatos; Word conserva 356 objetos matemáticos nativos. La figura 5.1 ahora muestra bloqueo de firma y preparación/validación antes de instalar las claves. [Hashes y revisión de la edición](../../06-Evidencia-TG2/2026-09-22/R3-rotacion/revision-manuscrito.json).

Abordar R4: aislar y comprobar las condiciones reales de aceptación del verificador y el enlace de raíces completas, preservando los antecedentes de TG1. Después, conciliar o repetir los experimentos afectados. La integración durable, la política de épocas en el sequencer y el anclaje del registro dependen de ese trabajo. R1 conserva la revisión formal y R5 el modelo y medición de residencia.
