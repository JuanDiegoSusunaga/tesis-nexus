# Reglas y Memoria del Proyecto NEXUS — Trabajo de Grado 2 (TG2)

## Objetivos Específicos de Trabajo de Grado 2 (TG2)

### Objetivo Específico 3: Lógica de Seguridad Activa del Ciclo de Vida de Claves
Modelar e implementar la lógica de seguridad activa del ciclo de vida de claves: monitoreo de la fuente de entropía basado en min-entropía y pruebas de salud en línea (NIST SP 800-90B: RCT y APT), y rotación de claves con secrecia hacia adelante.
- **Actividad 3.1:** Modelo de la fuente de entropía: min-entropía y pruebas de salud en línea (RCT/APT, NIST SP 800-90B).
- **Actividad 3.2:** Algoritmo de rotación con secrecia hacia adelante por política y registro auditable.

### Objetivo Específico 4: Formalización y Validación de Seguridad y Complejidad
Formalizar y validar la seguridad y la complejidad: reducción de la in-forjabilidad de Dilithium a Module-LWE, SelfTargetMSIS y Module-SIS (y de éstos a Mod-SIVP de peor caso), con el argumento de no aplicabilidad del algoritmo de Shor; y análisis de complejidad computacional (notación O) de la verificación de firmas y validación empírica (*benchmarks*).
- **Actividad 4.1:** Desarrollo de la cadena de reducciones (in-forjabilidad -> Module-LWE / SelfTargetMSIS / Module-SIS -> Mod-SIVP).
- **Actividad 4.2:** Análisis de complejidad computacional y validación empírica (*benchmarks*).

## Regla Estricta e Invariable sobre TG1
- **INMUTABILIDAD DE TG1**: Bajo ninguna circunstancia se debe modificar, alterar o modificar el alcance, documentos ni entregables ya aprobados correspondientes a **Trabajo de Grado 1 (TG1)** (Objetivos 1 y 2). 
- Todo el trabajo, desarrollo, refactorizaciones y avances deben enfocarse de manera estricta y exclusiva en **Trabajo de Grado 2 (TG2)** (Objetivos Específicos 3 y 4).

## Memoria y Bitácora del Semestre TG2

### Registro de Bitácora
- **Archivo de Seguimiento Continuo:** `BITACORA_TG2.md` (ubicado en la raíz del proyecto). Debe actualizarse de forma continua a medida que se ejecuten cambios, código, refactorizaciones o avances en los Objetivos 3 y 4.

### Decisiones Metodológicas y Criptográficas Consolidadas (TG2)
1. **Modelo de Entropía (Objetivo 3 - Actividad 3.1):**
   - Se utiliza **Min-Entropía de peor caso (\(H_{\infty}\), NIST SP 800-90B)** en sustitución de la entropía de Shannon.
   - El ciclo de vida de claves incorpora pruebas de salud en línea: **RCT (Repetition Count Test)** y **APT (Adaptive Proportion Test)**.
   - Ante degradación de entropía, la derivación KDF (HKDF/SHAKE256) debe suspenderse automáticamente.
2. **Formalización de Seguridad (Objetivo 4 - Actividad 4.1):**
   - La in-forjabilidad de firmas CRYSTALS-Dilithium reposa sobre la cadena de reducciones: \(\text{EUF-CMA} \to \text{Module-LWE / SelfTargetMSIS / Module-SIS} \to \text{Mod-SIVP}\).
   - Demostración de no aplicabilidad del algoritmo de Shor por ausencia de estructura de período abeliano.
3. **Defensa en Profundidad Off-Chain:**
   - La estrategia de *Honeytokens / Centinelas* en L2 Sequencer y Nitro Verifier se cataloga como defensa de infraestructura off-chain y trabajo futuro complementario.

## 🛠️ Reglas y Metodología de Construcción de Código y Desarrollo (Workflow)

### 1. Idioma y Comentarios en Código
- **Idioma del Agente:** Siempre responder en español.
- **Comentarios en Código:** Todos los comentarios dentro del código fuente (Rust, scripts, configuraciones) deben redactarse estrictamente en español.

### 2. Ciclo de Construcción y Verificación Estricta
- **Verificación Empírica Obligatoria:** Nunca declarar una tarea o refactorización completada sin haber ejecutado la verificación del código (`cargo check`, `cargo test`, `cargo build`).
- **Diagnóstico Riguroso de Errores:** Ante fallos de compilación o runtime, inspeccionar los logs completos antes de proponer cambios. Prohibido ocultar o tragar excepciones/panics (evitar `.unwrap()` / `.expect()` sin tratamiento adecuado de errores en módulos de producción).

### 3. Principios de Ingeniería de Software en el Monorepo Rust (`nexus/`)
- **Respeto a la Arquitectura Modular:** Preservar la separación de responsabilidades entre crates (`nexus-crypto`, `nexus-core`, `nexus-zk`, `nexus-node`).
- **Integridad de API:** Si se modifica una firma o estructura, actualizar síncronamente todas sus llamadas en el espacio de trabajo.
- **Seguridad en la Construcción:** Prohibido exponer material criptográfico sensible (claves privadas, semillas) en trazados de logs o estados globales no protegidos.

### 4. Flujo de Documentación y Trazabilidad Activa
- **Registro Continuo:** Tras cada avance, corrección o implementación en TG2, actualizar la bitácora `BITACORA_TG2.md` con los detalles y hallazgos.
- **Protección de TG1:** Toda refactorización de construcción debe garantizar que los entregables y alcance ya aprobados de TG1 permanezcan intactos.

### 5. Entorno de Compilación y Tooling Específico (Alineación con `.claude`)
- **Compilación Eficiente en Rust (`nexus/`):** Para agilizar las verificaciones y evitar bloqueos en disco, utilizar el directorio de compilación alternativo:
  - Verificación: `CARGO_TARGET_DIR=/c/tmp/nexus-target cargo check --workspace --manifest-path C:/Users/x/Desktop/Tesis/nexus/Cargo.toml`
  - Pruebas y Benchmarks: `CARGO_TARGET_DIR=/c/tmp/nexus-target cargo test --workspace --manifest-path C:/Users/x/Desktop/Tesis/nexus/Cargo.toml` o `cargo bench -p nexus-crypto`
- **Compilación Documental (Pandoc):** Al compilar el manuscrito en Markdown a formato Word (`.docx`):
  - `pandoc "Documentos/Tesis-NEXUS-completa.md" -o "Documentos/Tesis-NEXUS-completa.docx" --toc --toc-depth=2 --metadata lang=es`

