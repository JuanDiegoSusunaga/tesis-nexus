# Cierre de modelos por sus criterios originales

La [auditoría](validacion.json) comprueba **1707 resultados en 191 módulos**.
Se añaden **21 resultados en cuatro módulos** y 26 correspondencias.
De los 19 grupos antes parciales, **11 cierran su modelo y 8 siguen parciales**.
La matriz contiene 32 modelos verificados en su alcance, tres dependencias
bibliográficas, dos respaldos documentales y un trabajo futuro QROM AIR/FRI.

Cierran: M05, M11, M13, M16, M18, M21, M23, M24, M25, M27, M33. La [evaluación](Revision-Alcance.md) compara cada criterio
original con sus definiciones, teoremas y límites. No se cambia ningún criterio.
Varios criterios ya estaban demostrados; esta etapa agrega los puentes faltantes
de autenticación, operaciones, familias de anchos y muestreo DA. Los cierres
son juicios de correspondencia semántica del agente, sin dictamen independiente.

| Módulo | Resultados | Alcance |
|---|---:|---|
| [Cripto/AplicacionAutenticada](../../../../formalizacion/Nexus/Cripto/AplicacionAutenticada.lean) | 6 | El contexto procede del registro de claves. Aceptar aplica el documento y consume el nonce atómicamente; repetir la solicitud rechaza. Bajo un contrato explícito de procedencia de firmas, admitir implica documento autorizado o colisión con un documento autorizado; excluir ese evento da autorización. |
| [Salud/Operaciones](../../../../formalizacion/Nexus/Salud/Operaciones.lean) | 6 | Composición atómica de derivación por política y admisión de una operación. Sin evaluación, renovación pendiente o reevaluación sin rotación no se produce estado de operación; éxito exige política, consumo de uso y admisión. Una admisión fallida no produce estado nuevo. |
| [Complejidad/FamiliasCodificacion](../../../../formalizacion/Nexus/Complejidad/FamiliasCodificacion.lean) | 7 | Biyeción de índices de cabecera y bits de cada coeficiente con posiciones del paquete. Codificación inyectiva, recuperación de todos los bits y longitud exacta. Cotas O para familias en las que cabecera, componentes, grado y ancho varían simultáneamente, con cota uniforme explícita de la cabecera. |
| [Modelos/DisponibilidadCondicional](../../../../formalizacion/Nexus/Modelos/DisponibilidadCondicional.lean) | 2 | Muestreo DA sin reemplazo: espacio no vacío y probabilidad exacta de omitir fragmentos no disponibles, fijado el conjunto disponible antes de muestrear. Contraejemplo a intersección honesta con quórums inclusivos 2/3 y peso bizantino exactamente 1/3. |

## Ocho grupos parciales

| Grupo | Tema | Trabajo pendiente |
|---|---|---|
| M26 | Aritmética de mediciones: unidades, razones y redondeos | Identificar las corridas originales H1/H2, sus versiones y el alcance de los datos, junto con M44. Las cuentas y redondeos están probados; no certifican procedencia, causalidad ni capacidad sostenida. |
| M31 | Límites del verificador legado y del conocimiento cero | Identificar y extraer los nodos y evaluaciones concretos de los certificados del ejemplo; enlazar su reconstrucción con esos certificados y el verificador legado. La interpolación condicional ya probada no establece esa correspondencia ni conocimiento cero general. |
| M35 | Muestra compartida e hipergeométrica H | Derivar de todas las historias del protocolo las claves frescas y leyes de entrada del selector implementado, con la tabla compartida. Conservar la muestra común de ambas fases FRI; no suponer independencia entre ellas. |
| M36 | Solidez ideal por rondas y reinicios | Completar el adaptador externo de rondas y reinicios y obtener revisión independiente. El autor declaró que no hay dictamen. El presupuesto de inicios ideal B no equivale automáticamente a consultas hash. |
| M37 | Extracción Merkle, bytes y orden temporal ROM | Construir las familias causales y los hechos de registro para todas las historias del protocolo usando una tabla común, a partir de sus eventos y gramática reales. |
| M39 | Presupuestos, formas, gramática y semántica del verificador | Derivar todas las formas, rechazos y presupuestos de la gramática, serialización, deserialización e índices del verificador Rust y su semántica de enteros de máquina. |
| M40 | Potencial de nonces y cola del selector | Instanciar el potencial con los árboles de candidatos reales, sus conjuntos buenos, leyes, nonces, trabajo y tabla compartida antes de responder; cubrir abandono, intercalación y duplicados sin condicionar a un nonce encontrado. |
| M41 | Cota ROM completa y ejemplo numérico | Probar las inclusiones y leyes de los eventos del ejecutable bajo un mismo experimento e instanciar la composición de los tres términos con el adaptador causal, sesgos, selector y presupuestos. La aritmética numérica existente es condicional. |

## Obligaciones adicionales abiertas

El cierre del modelo no demuestra refinamiento Rust, seguridad ML-DSA, KDF,
codec efectivo, distribución de rechazo real, ABI, Rust/f64, fuente física,
custodia, borrado ni secrecia hacia adelante. Los once grupos conservan estas
obligaciones en límites explícitos. Tampoco se formalizan las reducciones
bibliográficas ni se identifica el presupuesto ideal de inicios con consultas hash.

La procedencia de firmas es una hipótesis explícita del historial autorizado;
se obtiene autorización o un evento de colisión, y autorización si se excluye
ese evento. No se supone que un hash finito sea globalmente inyectivo. El
contador de nonce y los datos se actualizan juntos en el modelo Option.

La compuerta se aplica a operaciones que usan la clave. Reevaluar sin rotar
no habilita esas operaciones. El codec de bits recupera cada posición y sus
cotas asintóticas permiten variar cabecera, dimensiones y ancho, con una cota
eventual uniforme de la cabecera. Son formatos matemáticos declarados.

R5 vincula las cuentas de memoria a fips204 0.4.6 y a sus fuentes y logs
históricos congelados; no generaliza sizeof a otros compiladores. El muestreo
DA fija el conjunto disponible antes de tomar la muestra. El contraejemplo
de quórum excluye una intersección honesta automática justo en la frontera.

## Validación y conservación

Compilación, auditoría de axiomas y replay de los 191 módulos correctos;
solo propext, Classical.choice y Quot.sound. El replay confía en importados,
no es --fresh ni revisión externa. Se fijan 454 fuentes y 197 logs.
Los [controles](controles.log), [trazabilidad](revision-manuscrito.json) e
[integridad](integridad-cierre-criterios.json) conservan los 4413 archivos de
la edición previa mediante versiones y hashes. Se archivan 16 versiones y
cuatro fuentes R5. Capítulos, salidas publicadas, Rust y TG1 no cambian.
El autor declaró «No hay dictamen»; la tesis completa sigue sin verificar.
