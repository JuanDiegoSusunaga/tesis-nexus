# Contrato de formato para la solicitud de revisión matemática

## Referencia y conservación

La autoridad visual es la instantánea de Documentos/01-Manuscrito/Tesis-NEXUS-completa.docx anterior a esta edición, SHA256 b08eb3eda721da63436a705c52e394207cbf74e00f4b172f8eda3d6919dafe48, con 115 páginas y una sección. Se conserva sin cambios como referencia.docx junto a este contrato y en Claridad-Referencias/respaldo_previo. Los renders nativos ya verificados de la referencia se encuentran en tmp/conciliacion-rust/word-final; sus controles y huellas pertenecen a la evidencia Conciliacion-Manuscrito-Rust del 20 de octubre. Se consultan los patrones de portada, prosa, títulos y tablas; el cuerpo de la tesis no se convierte en contenido de la solicitud. La tesis vigente se modifica después por autorización separada para aclarar referencias e incorporar el glosario y la notación.

El renderizador empaquetado se ha probado de nuevo y falla al importar pdf2image. Tampoco está disponible el cargador de dependencias de la habilidad. Se usa el generador Pandoc ya instalado y un parche OOXML sobre una copia real de la referencia, con Word COM oculto para actualizar campos y renderizar. No se instala software ni se usa LibreOffice de escritorio.

## Página y tipografía

Papel carta vertical 12240 por 15840 twips. Márgenes de 1440 twips en los cuatro lados, encabezado y pie de 720. Una columna. Primera página diferenciada como en la tesis. Se mantienen los seis vínculos originales de encabezados y pies y sus partes.

Se conservan byte por byte styles.xml, stylesWithEffects.xml, tema, fuentes y todos los estilos de la referencia en el ensamblaje previo a Word. Las referencias de estilo nuevas se enlazan por el nombre real del estilo, incluyendo sus identificadores localizados. Normal y Body Text usan Times New Roman 12, texto justificado, interlineado 1,5 y separación posterior de 6 puntos. Title, identificador Ttulo, usa 18 puntos y centrado. Author y Date usan 12 puntos centrados. Heading 2, identificador Ttulo2, usa 12 puntos en negrita, con 12 puntos antes y conservación con el párrafo siguiente. Se reutiliza Heading 2 para las secciones de esta solicitud corta; no se crean capítulos nuevos ni se fuerzan saltos de capítulo.

La notación estructurada se transforma en ecuaciones nativas OMML usando Pandoc, con Cambria Math como en la tesis. No se rasterizan ecuaciones. Los identificadores de código conservan sus valores literales; los hashes largos pueden incluir oportunidades de salto invisibles sin cambiar sus caracteres visibles.

## Tablas y listas

Hay dos tablas: hipótesis del experimento y preguntas numeradas del 1 al 6. Ancho útil de 9360 twips. Primera tabla con columnas 2200 y 7160. Segunda con columnas 1300, 3120 y 4940; la primera se ensancha para que la cabecera Pregunta no se corte. Se conserva la apariencia de las tablas de la tesis: bordes B8B8B8 de medio punto, encabezado EDEDED con texto negro y negrita, cuerpo Times New Roman 10, alineación vertical centrada y espacio de 3 puntos antes y después. Se permite continuidad entre páginas, con cabecera repetida y sin dividir filas; no se usa altura fija. El identificador corto de la segunda tabla se centra. Se preserva el resto de las columnas narrativas alineado a la izquierda. Las listas toman las definiciones de numeración generadas y se anexan con identificadores nuevos a la numeración original, sin sustituirla.

## Contenido y espacios editables

Se sustituye únicamente el cuerpo de la copia por el contenido de la solicitud vigente. Se conserva el sentido, las seis preguntas y las hipótesis. Las referencias de sección se escriben con palabras; las preguntas se numeran del 1 al 6 y se explica que las antiguas etiquetas M1–M6 identificaban preguntas, no módulos ni demostraciones faltantes. Se distingue esa etiqueta de M como cantidad matemática, cuyo significado depende del contexto. El título usa el estilo Title y se presenta sin guion ornamental. Se añade el autor ya identificado en la tesis. No se añaden aprobación, envío ni dictamen. La fuente Markdown de la solicitud permanece como antecedente sin cambios durante esta conversión; las modificaciones autorizadas de la tesis se documentan por separado.

Los vínculos del cuerpo se trasladan con relaciones nuevas, sin colisionar con las de la referencia. La geometría de sección y los pies se copian de la referencia. Se permiten cambios únicamente en document.xml, relaciones del documento, numbering.xml, settings.xml y propiedades básicas del documento. Las otras partes se conservan exactamente en el ensamblaje; los cambios de serialización que haga Word se contrastan por estructura y estilos al cerrar.

## Verificaciones antes de publicar

Se comprueban dos tablas, sus 41 celdas, seis preguntas, 35 vínculos locales y 19 objetos matemáticos nativos; el texto de cada celda coincide con una conversión Pandoc independiente. Se renderizan e inspeccionan las seis páginas definitivas a tamaño nativo, incluidos pies y continuación de tablas. Se comparan nueve estilos relevantes y la geometría de sección con la referencia. Las 354 fuentes/configuraciones Lean y 89 Rust conservan sus hashes; no se recompilan. Las fuentes y salidas de la tesis sí cambian por las autorizaciones editoriales posteriores, conservando sus fórmulas y objetivos originales y sus respaldos. Los PNG de revisión son internos. La solicitud se publica como Revision-Matematica-NEXUS.docx, SHA256 6655cef84bb9eb92cc6cb4926b067de30f236d77c345580ad89d094e8f5d5898, sin envío ni dictamen.
