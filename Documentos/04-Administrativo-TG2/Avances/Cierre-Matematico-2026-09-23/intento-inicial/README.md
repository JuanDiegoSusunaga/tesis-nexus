# Primera ejecución de las comprobaciones

Las siete pruebas matemáticas pasaron. El manifiesto detuvo la ejecución porque contó el archivo de propietario de Word `Documentos/01-Manuscrito/~$sis-NEXUS-completa.docx` como entrega adicional. Sus 897 archivos registrados conservaron los bytes esperados.

Se corrigieron `verificar_version_tg2.py` y `registrar_version_tg2.py` para reconocer estos temporales por prefijo y extensión Word. Se añadieron dos pruebas: permitir el temporal y seguir detectando otros archivos con prefijo `~$`. No se eliminó el archivo ni se cerró Word.

La [ejecución posterior](../validacion.json) completó las 17 pruebas Python, el manifiesto, cargo check, 197 pruebas Rust y cargo build. Estos logs conservan el resultado inicial sin sustituirlo.
