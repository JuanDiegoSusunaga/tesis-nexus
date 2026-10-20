# Antecedentes del certificado y la gramática

El [manifiesto](manifiesto.json) conserva 16 versiones canónicas previas y
27 registros de fuentes y artefactos, incluidos 18 archivos fuente congelados.
Conserva la auditoría de 1707 resultados en 191 módulos y la edición NIST
de 4693 archivos. [modelos.json](modelos.json) registra los 49 resultados;
[revision-criterios.json](revision-criterios.json) evalúa los ocho grupos.

En [certificado](certificado/) están el binario público legado nuevo, consultas,
ranuras y valores, la relectura independiente y los logs cargo check/test/build.
El fallo inicial offline se conserva; se corrigió la resolución reutilizando
Cargo.lock sin alterar nexus. Rust y Python enlazan los bytes con constantes
Lean, sin formalización universal de SHA3/bincode ni certificación de ZK.
