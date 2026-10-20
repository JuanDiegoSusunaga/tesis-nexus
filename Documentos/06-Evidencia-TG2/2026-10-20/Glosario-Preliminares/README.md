# Glosario y notación en las páginas preliminares

El autor solicita situar el glosario al inicio de la tesis. Se reubica su fuente completa después del alcance y antes del capítulo 1, conservando las 33 entradas de términos y las 20 de notación, sin cambiar su texto. El glosario comienza en la página 7 de Word y PDF. La notación empieza en la 12 de Word y la 11 de PDF. La introducción comienza en la 15 y la 13, respectivamente.

`preparacion.json` registra la integridad previa de 9738 rutas y los 22 respaldos. `verificacion.json` comprueba que las diez fuentes Markdown son idénticas y que el ensamblado solo cambia de orden; conserva 34 tablas, 848 celdas, tres figuras y 664 ecuaciones nativas. Word/PDF mantienen 123/111 páginas. La plantilla, Lean y Rust no cambian. `artifact.md` conserva la referencia de formato y el alcance.

Se renderizan las 234 páginas. El cotejo por regiones reutiliza únicamente cuerpos y pies con identidad exacta de píxeles respecto de imágenes previamente inspeccionadas, nunca una semejanza aproximada. Se revisan completas las 16 primeras páginas Word y 61 páginas PDF, incluidas todas las regiones distintas y el bloque preliminar, mediante veinte láminas a tamaño nativo. Los demás cuerpos y todos los pies coinciden exactamente con regiones ya revisadas. Los PNG internos permanecen en las rutas indicadas por el informe; no son entregables de lectura.

El renderizador empaquetado falla por falta de `pdf2image`. Se conservan los generadores locales y Word oculto, sin instalaciones ni LibreOffice de escritorio. No se compilan Lean/Rust ni se ejecutan suites, añaden resultados matemáticos, crean commit/push o registran envío y dictamen del director. Los informes anteriores no se reescriben.
