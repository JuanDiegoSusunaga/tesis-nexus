# Primer intento de validación

El 23 de septiembre de 2026 pasaron las 28 pruebas Python y la verificación del manifiesto. `cargo check` se detuvo por acceso denegado al archivo `C:/tmp/nexus-target/debug/.cargo-build-lock` dentro del entorno restringido. Se conservan los seis archivos producidos, incluido el log completo.

La ejecución se repitió con permiso para acceder al directorio de compilación. Sus resultados correctos están en la carpeta superior y en `../validacion.json`. No se modificó Rust para resolver este fallo de permisos.
