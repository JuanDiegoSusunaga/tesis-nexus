# NEXUS — tesis, formalización y evidencia

**Estado al 20 de octubre de 2026.** NEXUS estudia firmas poscuánticas, gestión de claves y registros verificables para **sistemas en general**, con una arquitectura blockchain dual como modelo de referencia.

## Por dónde empezar

**Alcance vigente:** por decisión del autor del 23 de septiembre, completar QROM del protocolo AIR/FRI queda como **trabajo futuro**. La ruta activa prioriza revisión de resultados y consolidación del manuscrito; la sustentación está aplazada por indicación del autor del 12 de octubre. Los avances QROM se conservan con sus límites.

**Complemento de validación, 12 de octubre:** el [catálogo de afirmaciones](Documentos/04-Administrativo-TG2/Avances/Catalogo-Validacion-2026-10-12/README.md) enlaza doce enunciados con hipótesis, dependencias y nueve archivos de evidencia identificados por SHA-256. `python scripts/verificar_catalogo_validacion.py` comprueba su integridad documental. Sus estados son históricos; la [revisión matemática vigente](formalizacion/REVISION-MANUSCRITO.md) distingue las pruebas posteriores del modelo, los límites externos y el dictamen independiente aún pendiente.

1. [Manuscrito vigente y formatos](Documentos/01-Manuscrito/README.md).
2. [Balance de los Objetivos 3 y 4](Documentos/04-Administrativo-TG2/Entrega-Final/Balance-Objetivos-TG2.md).
3. [Índice de entrega e identificación de la versión](Documentos/04-Administrativo-TG2/Entrega-Final/README.md).
4. [Ruta de cierre](Documentos/04-Administrativo-TG2/Ruta-de-Cierre-TG2.md), [pendientes](PENDIENTES.md) y [bitácora](BITACORA_TG2.md).
5. [Reproducción y herramientas](scripts/README.md).
   [Formalización Lean 4 y mathlib](formalizacion/README.md): 2709 declaraciones auditadas, 347 submódulos y el módulo raíz. La [global del 20 de octubre](Documentos/06-Evidencia-TG2/2026-10-20/Lean-Global/verificacion.json) pasó sin errores, advertencias, sorryAx ni axiomas fuera de la política; la consolidación Git no la repite.
   El puente causal y las cotas con trabajo, perfiles y reinicios están demostrados para el verificador matemático de bytes en ROM clásico finito. No equivalen a una prueba de todo el manuscrito, refinamiento universal de Rust, QROM ni aprobación académica.
   [Versionado local e integridad](Documentos/06-Evidencia-TG2/2026-10-20/Consolidacion-Lean/preparacion.json): fuentes existentes y herramientas incluidas sin modificar pruebas ni añadir obligaciones, recompilar o hacer push.
   Documentación: [manual de Lean 4.35.0](https://lean-lang.org/doc/reference/4.35.0/) y [referencia de mathlib](https://leanprover-community.github.io/mathlib4_docs/).
   **Antecedentes de formalización, 16–18 de octubre:** los enlaces siguientes conservan resultados y pendientes de cada etapa. Sus conteos no son el estado vigente; las obligaciones probabilísticas del modelo indicadas como abiertas quedaron cubiertas por el puente y las cotas finales del 19, auditados de nuevo el 20. Los límites de implementación y revisión independiente siguen separados.
   [Primera comprobación de la tesis en Lean](formalizacion/VERIFICACION.md): 17 lemas y teoremas sobre componentes de seis afirmaciones, con alcance y pendientes explícitos.
   [Inventario histórico del manuscrito](formalizacion/ALCANCE-MANUSCRITO.md): 2469 resultados registrados en 304 módulos, grados AIR válidos y cancelación sesgada, retículos euclídeos, FSwA, APT decimal, derivación/épocas, sesgo modular, cola y presupuestos, distribuciones MLWE, extracción MSIS y juegos EUF/sUF, anillos y parámetros ML-DSA, contraejemplo AIR de distancia exacta 7/8, residencia integral y captura, amortización, costos NTT y firma esperada, min-entropía, Shannon, RCT/APT y recuperación del gestor, campos Goldilocks, solidez AIR/FRI, memoria ROM, raíz compartida y seis aperturas autenticadas enlazadas con los controles locales de N06; inventario inicial de 272 candidatos matemáticos, anterior al cierre probabilístico del modelo.
   [Revisión matemática del manuscrito](formalizacion/REVISION-MANUSCRITO.md): 272 candidatos clasificados, 14 omisiones y 46 grupos; 216 bloques parcialmente enlazados y diez suplementos con pruebas. 34 modelos verificados en su alcance y 6 grupos parciales; siguen reducciones, SelfTarget bibliográfico y correspondencias con implementación.
   [AIR/FRI de los vectores reales](Documentos/06-Evidencia-TG2/2026-10-18/Lean-AIR-FRI-Real/README.md): 55 resultados nuevos; cardinal original bajo prefijo seguro, fallos de rondas clasificados y B=Q+24895 para R=512. En esa etapa faltaban probabilidades de rondas y excepciones, trabajo y composición global, cubiertos posteriormente dentro del modelo.
   [Canal canónico falso y exceso de cardinal](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Candidatos-Falsos/README.md): antecedente con 45 resultados sobre el filtro del pasado y la cota con exceso explícito.
   [Prefijo de llamadas y cobertura probabilística](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Prefijo-Selector/README.md): antecedente con 40 resultados sobre corte, prefijo bruto y unión por perfil fijo bajo g/m/B explícitos.
   [Muestra efectiva en GT/GC](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Consultas-Buenas/README.md): antecedente con 45 resultados sobre las cuarenta consultas aceptadas y su cinta real.
   [Semántica previa y GT/GC](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Semantica-Previa/README.md): 51 resultados nuevos; parámetros, retos, vectores y conjuntos buenos derivados del pasado y conservados hasta la vista final. Antecedente de la pertenencia posterior; el enlace probabilístico estaba pendiente en aquella etapa y quedó cubierto en el cierre del modelo.
   [Candidato previo](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Candidato-Previo/README.md): 34 resultados nuevos; aceptación con adversario, cadena del canal recuperada antes del primer I y vectores congelados. Antecedente de la interpretación semántica posterior; la composición probabilística estaba pendiente en aquella etapa y quedó cubierta en el cierre del modelo.
   [Primeras exposiciones](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Primeras-Exposiciones/README.md): 39 resultados nuevos; candidatos registrados, sin doble carga y cota por direcciones distintas. La cobertura integral y los conjuntos buenos causales faltaban en esa etapa, no en el cierre posterior del modelo.
   [Selector tras exploración adaptativa](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Selector-Adaptativo/README.md): 45 resultados nuevos; ley de continuación, decisiones basadas en el pasado y cota con Pr(preconsulta) explícita; seis grupos parciales.
   [Selector acoplado](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Selector-Acoplado/README.md): 52 resultados nuevos; transferencia local de omisión compartida y abandono con error explícito, bajo primera dirección fresca; seis grupos parciales.
   [Ley conjunta del ROM finito](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Ley-Conjunta-ROM/README.md): 63 resultados nuevos; igualdad de leyes de resultado y transcripción, prefijos efectivos y respuestas frescas; seis grupos parciales.
   [Familias causales AIR/FRI](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Familias-Causales/README.md): 73 resultados nuevos, cierre de M37 en su modelo finito y cota del fallo de reconstrucción; seis grupos parciales.
   [Adversario y primeras exposiciones](Documentos/06-Evidencia-TG2/2026-10-18/Lean-Adversario-Causal/README.md): 66 resultados nuevos; propuesta adaptativa, tabla común, ley local, selector y congelación. Siete grupos parciales conservados.
   [Verificador matemático completo](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Verificador-Completo/README.md): 105 resultados nuevos, presupuesto del programa y 50 casos externos Rust/Python; siete grupos parciales conservados.
   [Certificado y gramática](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Certificado-Gramatica/README.md): 49 resultados nuevos; cierra M31 en su alcance y quedan siete grupos parciales.
   [Revisión NIST](Documentos/06-Evidencia-TG2/2026-10-17/NIST-Referencias/README.md): doce fuentes oficiales conservadas, erratas y aplicación a los pendientes; en esa etapa se conservaron ocho grupos parciales.
   [Cierre por criterios originales](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Cierre-Criterios/README.md): 21 resultados nuevos, once cierres de modelos y ocho grupos parciales; obligaciones adicionales abiertas.
   [Selector, codecs y ciclos](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Selector-Ciclos/README.md): 76 resultados en diez módulos, uniformidad y ley causal finita, NTT y parser; 19 grupos parciales.
   [Pasada de los 22 grupos](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Obligaciones-22/README.md): 164 resultados nuevos; cierres M10/M32/M46 y 19 grupos parciales con criterios conservados.
   [Auditoría de grados AIR y cancelación](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Grados-Cancelacion/README.md): 53 resultados nuevos, cotas ajustadas y ejemplo exacto; M28/M29 verificados en su alcance.
   [Auditoría de modelos y conciliación TG2](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Modelos-Pendientes/README.md): 176 resultados nuevos y manuscrito corregido; límites de implementación y dictamen pendientes.
   [Auditoría de juegos reticulares](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Juegos-Reticulares/README.md): 114 resultados nuevos sobre distribuciones, extracción y juegos; dureza, reducciones y backend conservan sus pendientes.
   [Auditoría de anillos y contraejemplo](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Anillos-Contraejemplo/README.md): 121 pruebas nuevas sobre ML-DSA, normas, interpolación, grados AIR y mínimo 7/8; evidencia empírica del legado separada.
   [Auditoría de residencia y costos](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Costos-Residencia/README.md): 118 pruebas nuevas sobre integral, captura, memoria, amortización, NTT y rechazo; hipótesis y pendientes explícitos.
   [Auditoría de entropía y salud](Documentos/06-Evidencia-TG2/2026-10-17/Lean-Entropia-Salud/README.md): 87 resultados nuevos, corte APT mínimo 16 y bloqueo durante recuperación; límites de Rust/f64 y fuente explícitos.
6. [Derivaciones matemáticas en Word](Documentos/04-Administrativo-TG2/Avances/Derivaciones-Matematicas-TG2-2026-10-12.docx), con hipótesis, argumentos y preguntas para revisión.
7. [Transferencia matemática al protocolo TG2 v1](Documentos/04-Administrativo-TG2/Avances/Transferencia-ROM-2026-09-23/README.md): derivación clásica ROM con pérdidas de Merkle, Fiat–Shamir y nonces, cálculos y verificador independiente. Integrada en `main` junto con la [derivación ideal por rondas](Documentos/04-Administrativo-TG2/Avances/Cierre-Matematico-2026-09-23/README.md); integradas en §§6.7.8–6.7.9 y en el suplemento consolidado; dictamen independiente pendiente.

**Antecedente QROM conservado como trabajo futuro:** [cota cuántica de la cola de índices](Documentos/04-Administrativo-TG2/Avances/Cola-QROM-2026-09-23/README.md), con una demostración propuesta mediante conteo y amplitudes. Se registran 144 perfiles; la cota es útil en 16, usando cortes mayores del análisis. Pasan 96 pruebas Python y 197 Rust, con check/build. **Falta acotar la omisión de parejas incorrectas** para completar la [reducción al verificador](Documentos/04-Administrativo-TG2/Avances/Muestreo-QROM-2026-09-23/README.md). El conjunto requiere dictamen independiente y todavía no acredita seguridad QROM completa.

## Estructura

| Ubicación | Contenido y uso |
|---|---|
| `Documentos/01-Manuscrito/` | Capítulos fuente, bibliografía, figuras y una salida Markdown, Word y PDF |
| `Documentos/02-Investigacion-y-Notas/` | Decisiones, antecedentes y notas; consultar las actualizaciones de cada documento |
| `Documentos/03-Administrativo-TG1/` | Documentos históricos aprobados de TG1 |
| `Documentos/04-Administrativo-TG2/` | Plan, informes de avance, balance de entrega y preparación de sustentación |
| `Documentos/05-Estado-del-Arte/` | Corpus bibliográfico y matriz de trazabilidad |
| `Documentos/06-Evidencia-TG2/` | Resultados, fuentes de cada ejecución, logs y hashes por fecha y etapa |
| `Documentos/media/` | Imágenes de documentos históricos; las figuras vigentes están en `01-Manuscrito/Figuras/` |
| `scripts/` | Generación documental, análisis y verificación de la versión |
| `nexus/` | Repositorio Rust independiente, clonado dentro de esta carpeta |
| `.tools/`, `.venv/` | Herramientas, temporales y entorno local excluidos de Git |

Los capítulos de `01-Manuscrito/Capitulos/` son la fuente de edición. Las salidas `Tesis-NEXUS-completa.*` se regeneran juntas. Las instantáneas de evidencia conservan resultados históricos; su repetición se realiza en una copia separada siguiendo las [instrucciones](scripts/README.md).

## Dos repositorios relacionados

Este repositorio contiene los documentos, las fuentes de `formalizacion/` y sus herramientas de reproducción. La implementación Rust se mantiene en un segundo repositorio; `nexus/` está excluido únicamente en la raíz y no es un submódulo. Las copias de fuentes dentro de la evidencia sí se versionan. Las dependencias y artefactos Lean de `formalizacion/.lake/`, la instalación de `.tools/` y los temporales no se incorporan; reproducir la compilación requiere preparar el entorno con autorización, no solo clonar.

```powershell
git clone https://github.com/JuanDiegoSusunaga/tesis-nexus.git Tesis
Set-Location Tesis
git clone https://github.com/JuanDiegoSusunaga/nexus.git nexus
$versionTG2 = Get-Content 'Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json' -Raw | ConvertFrom-Json
git -C nexus checkout --detach $versionTG2.codigo.commit
python scripts/verificar_version_tg2.py
```

La disponibilidad de una revisión en el servidor depende de su publicación. La revisión local de documentos se obtiene con `git rev-parse HEAD`; el manifiesto enlazado fija el commit de código y los hashes del manuscrito y la evidencia.

## Estado técnico

La última [global Rust](Documentos/06-Evidencia-TG2/2026-10-20/Rust-Global-Final/verificacion.json), sobre `637e77c`, pasa check, 223 pruebas y build; conserva sus advertencias. Las 197 pruebas globales anteriores y las rondas aisladas de 113 y 55 son antecedentes y no se suman. Se preservan los 29 casos Criterion, 40 mediciones STARK y 40 repeticiones multinúcleo históricos con sus límites de procedencia. El [manuscrito con referencias aclaradas, glosario y notación en preliminares](Documentos/06-Evidencia-TG2/2026-10-20/Glosario-Preliminares/verificacion.json) tiene 123 páginas Word, 111 PDF, 34 tablas y 3 figuras; el glosario comienza en la página 7 de ambos formatos. Esta actualización documental no altera fórmulas ni objetivos originales y no recompila Lean o Rust.

Las garantías concretas del ejecutable, las integraciones de despliegue y el dictamen matemático tienen pendientes explícitos en el balance. El AIR escalar no valida transacciones L2 completas ni raíces SHA3 generales. Esta organización no constituye aprobación académica ni una garantía de 100 bits o conocimiento cero.

Para estudiar: [ruta actualizada](RUTA_DE_ESTUDIO.md). Para presentar: [guion de sustentación](Documentos/04-Administrativo-TG2/Presentaciones/Guion-Sustentacion-TG2.md).
