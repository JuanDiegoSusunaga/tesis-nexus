"""Ensambla una sola edición y comprueba tablas antes de generar Word.

Requiere Pandoc y lxml. Conserva ecuaciones como objetos matemáticos de Word.
"""

from pathlib import Path
import json
import re
import subprocess
from zipfile import ZipFile, ZIP_DEFLATED

from lxml import etree as E
from configuracion_manuscrito import FECHA, EVIDENCIA

RAIZ = Path(__file__).resolve().parents[1]
CARPETA = RAIZ / 'Documentos/01-Manuscrito'
CAPITULOS = CARPETA / 'Capitulos'
NS = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main',
      'r': 'http://schemas.openxmlformats.org/officeDocument/2006/relationships',
      'm': 'http://schemas.openxmlformats.org/officeDocument/2006/math'}
ANCHO = 9360


def etiqueta(nombre):
    prefijo, local = nombre.split(':')
    return '{' + NS[prefijo] + '}' + local


def nodo(padre, nombre, **atributos):
    hijo = padre.find(etiqueta(nombre))
    if hijo is None:
        hijo = E.SubElement(padre, etiqueta(nombre))
    for clave, valor in atributos.items():
        hijo.set(etiqueta('w:' + clave), str(valor))
    return hijo


def fuente(propiedades, puntos=12, familia='Times New Roman'):
    fuentes = nodo(propiedades, 'w:rFonts')
    fuentes.attrib.clear()
    for campo in ['ascii', 'hAnsi', 'eastAsia', 'cs']:
        fuentes.set(etiqueta('w:' + campo), familia)
    nodo(propiedades, 'w:sz', val=round(puntos * 2))
    nodo(propiedades, 'w:szCs', val=round(puntos * 2))
    color = nodo(propiedades, 'w:color', val='000000')
    for clave in list(color.attrib):
        if clave != etiqueta('w:val'):
            del color.attrib[clave]


def columnas(linea):
    return [celda.strip() for celda in re.split(r'(?<!\\)\|', linea.strip())[1:-1]]


def preparar_fuentes():
    documentos = {}
    referencias = {}
    resumen = []
    for ruta in sorted(CAPITULOS.glob('Cap[1-7]-*.md')):
        numero = int(ruta.name[3])
        texto = ruta.read_text(encoding='utf-8')
        texto = re.sub(r'^### \((.+)\)$', r'*\1*', texto, flags=re.M)
        texto = re.sub(r'(\$\\(?:sim|approx|gg)\$)(?=\d)', r'\1 ', texto)
        # Una fila multicolumn de LaTeX no es una fila válida de tabla Markdown.
        texto = re.sub(r'^\| \$n,\\ q\$ \| \\multicolumn.*$',
                       '| $n$ | 256 | 256 | 256 |\n| $q$ | 8.380.417 | 8.380.417 | 8.380.417 |', texto, flags=re.M)
        texto = re.sub(r'^> (\|.*\|)\s*$', r'\1', texto, flags=re.M)
        texto = re.sub(r'(?<!\$)\$\$(.+?)\$\$(?!\$)',
                       lambda m: '\n\n$$\n' + m.group(1).strip() + '\n$$\n\n', texto, flags=re.S)
        # Pandoc exige una separación antes de listas que siguen a un párrafo.
        separadas = []
        bloque_codigo = False
        for linea in texto.splitlines():
            if linea.startswith('```'):
                bloque_codigo = not bloque_codigo
            es_lista = re.match(r'^(?:[-+*] |\d+\. )', linea)
            anterior = separadas[-1] if separadas else ''
            if not bloque_codigo and es_lista and anterior.strip() and not re.match(r'^(?:\s|[-+*] |\d+\. )', anterior):
                separadas.append('')
            separadas.append(linea)
        texto = '\n'.join(separadas)
        lineas = texto.splitlines()
        salida = []
        contador = 0
        seccion = 'Síntesis'
        i = 0
        while i < len(lineas):
            linea = lineas[i]
            if linea.startswith('## '):
                seccion = re.sub(r'^## (?:\d+(?:\.\d+)*\s+)?', '', linea).rstrip('.')
            if linea.startswith('|') and i + 1 < len(lineas) and re.match(r'^\|[ :|\-]+\|$', lineas[i + 1]):
                contador += 1
                cantidad = len(columnas(linea))
                anterior = len(salida) - 1
                while anterior >= 0 and not salida[anterior].strip():
                    anterior -= 1
                rotulo = f'Tabla {numero}.{contador}'
                if anterior >= 0 and re.match(r'^\*\*Tabla \d+\.\d+', salida[anterior]):
                    viejo = re.search(r'Tabla \d+\.\d+', salida[anterior]).group()
                    referencias[viejo] = rotulo
                    salida[anterior] = salida[anterior].replace(viejo, rotulo, 1)
                else:
                    salida.extend([f'**{rotulo} — {seccion}.**', ''])
                filas = 0
                while i < len(lineas) and lineas[i].startswith('|'):
                    celdas = columnas(lineas[i])
                    if len(celdas) != cantidad:
                        raise ValueError(f'{ruta.name}:{i + 1}: {len(celdas)} columnas; esperadas {cantidad}')
                    if filas == 0 and not celdas[0]:
                        celdas[0] = 'Característica'
                        lineas[i] = '| ' + ' | '.join(celdas) + ' |'
                    salida.append(lineas[i].rstrip())
                    filas += 1
                    i += 1
                resumen.append({'rotulo': rotulo, 'archivo': ruta.name, 'columnas': cantidad, 'filas': filas - 1})
                continue
            salida.append(linea.rstrip())
            i += 1
        documentos[ruta] = re.sub(r'\n{3,}', '\n\n', '\n'.join(salida)).strip() + '\n'
    # Los rótulos ya fueron renumerados. Solo se ajustan referencias en prosa.
    for ruta, texto in documentos.items():
        lineas = texto.splitlines()
        for i, linea in enumerate(lineas):
            if not re.match(r'^\*\*Tabla \d+\.\d+', linea):
                lineas[i] = re.sub(r'Tabla \d+\.\d+', lambda m: referencias.get(m.group(), m.group()), linea)
        ruta.write_text('\n'.join(lineas) + '\n', encoding='utf-8')
    return resumen


def estilos_xml(contenido):
    raiz = E.fromstring(contenido)
    defaults = nodo(raiz, 'w:docDefaults')
    fuente(nodo(nodo(defaults, 'w:rPrDefault'), 'w:rPr'))
    parrafo = nodo(nodo(defaults, 'w:pPrDefault'), 'w:pPr')
    nodo(parrafo, 'w:spacing', line=360, lineRule='auto', after=120)
    for estilo in raiz.findall('w:style', NS):
        identificador = estilo.get(etiqueta('w:styleId'), '')
        tipo = estilo.get(etiqueta('w:type'))
        if tipo not in ['paragraph', 'character']:
            continue
        rpr = nodo(estilo, 'w:rPr')
        fuente(rpr)
        if tipo != 'paragraph':
            continue
        ppr = nodo(estilo, 'w:pPr')
        nodo(ppr, 'w:widowControl')
        if identificador in ['Normal', 'BodyText', 'FirstParagraph', 'Compact']:
            nodo(ppr, 'w:spacing', before=0, after=120, line=360, lineRule='auto')
            nodo(ppr, 'w:jc', val='both')
        if identificador.startswith('Heading'):
            fuente(rpr, 14 if identificador == 'Heading1' else 12)
            nodo(rpr, 'w:b')
            nodo(ppr, 'w:keepNext')
            nodo(ppr, 'w:keepLines')
            nodo(ppr, 'w:spacing', before=240, after=120, line=360, lineRule='auto')
            nodo(ppr, 'w:jc', val='left')
            if identificador == 'Heading1':
                nodo(ppr, 'w:pageBreakBefore')
        if identificador in ['Title', 'Author', 'Date', 'Subtitle']:
            fuente(rpr, 18 if identificador == 'Title' else 12)
            nodo(ppr, 'w:jc', val='center')
            nodo(ppr, 'w:spacing', before=240, after=240, line=360, lineRule='auto')
        if identificador == 'TOCHeading':
            nodo(ppr, 'w:pageBreakBefore')
            nodo(ppr, 'w:keepNext')
        if identificador in ['SourceCode', 'VerbatimChar']:
            fuente(rpr, 8, 'Consolas')
            nodo(ppr, 'w:spacing', before=0, after=0, line=240, lineRule='auto')
    return E.tostring(raiz, xml_declaration=True, encoding='UTF-8', standalone=True)


def formatear_docx(ruta, es_plantilla=False):
    with ZipFile(ruta) as archivo:
        partes = {nombre: archivo.read(nombre) for nombre in archivo.namelist()}
    partes['word/styles.xml'] = estilos_xml(partes['word/styles.xml'])
    doc = E.fromstring(partes['word/document.xml'])
    cuerpo = doc.find('w:body', NS)
    seccion = cuerpo.find('w:sectPr', NS)
    if seccion is None:
        seccion = E.SubElement(cuerpo, etiqueta('w:sectPr'))
    nodo(seccion, 'w:pgSz', w=12240, h=15840)
    nodo(seccion, 'w:pgMar', top=1440, right=1440, bottom=1440, left=1440, header=720, footer=720, gutter=0)
    if not es_plantilla:
        for parrafo in cuerpo.findall('.//w:p', NS):
            estilo = parrafo.find('w:pPr/w:pStyle', NS)
            identificador = estilo.get(etiqueta('w:val')) if estilo is not None else ''
            texto = ''.join(parrafo.xpath('.//w:t/text()', namespaces=NS))
            if re.match(r'^(Tabla|Figura) \d+\.\d+', texto):
                ppr = nodo(parrafo, 'w:pPr')
                nodo(ppr, 'w:keepNext', val=1)
                nodo(ppr, 'w:jc', val='left')
                nodo(ppr, 'w:spacing', before=180, after=100, line=240, lineRule='auto')
            if parrafo.find('.//w:drawing', NS) is not None:
                ppr = nodo(parrafo, 'w:pPr')
                nodo(ppr, 'w:keepLines', val=1)
                nodo(ppr, 'w:keepNext', val=1)
                nodo(ppr, 'w:jc', val='center')
                nodo(ppr, 'w:spacing', before=0, after=100, line=240, lineRule='auto')
            if identificador == 'Date':
                # Distribuye institución y director en líneas de portada.
                for run in parrafo.findall('w:r', NS):
                    t = run.find('w:t', NS)
                    if t is not None and ' · ' in (t.text or ''):
                        trozos = t.text.split(' · ')
                        t.text = trozos[0]
                        for trozo in trozos[1:]:
                            E.SubElement(run, etiqueta('w:br'))
                            E.SubElement(run, etiqueta('w:t')).text = trozo
            if identificador == 'SourceCode':
                longitud = max([len(s) for s in texto.splitlines()] or [1])
                tamano = min(8, max(5.5, 780 / max(longitud, 1)))
                for run in parrafo.findall('w:r', NS):
                    fuente(nodo(run, 'w:rPr'), tamano, 'Consolas')
                nodo(nodo(parrafo, 'w:pPr'), 'w:jc', val='left')
        for tabla in cuerpo.findall('.//w:tbl', NS):
            filas = tabla.findall('w:tr', NS)
            cantidad = len(filas[0].findall('w:tc', NS))
            pesos = []
            for col in range(cantidad):
                longitudes = []
                for fila in filas:
                    celdas = fila.findall('w:tc', NS)
                    if len(celdas) != cantidad:
                        raise ValueError('Tabla Word con número de celdas inconsistente')
                    longitudes.append(len(''.join(celdas[col].xpath('.//w:t/text() | .//m:t/text()', namespaces=NS))))
                pesos.append(max(10, min(65, sum(longitudes) / len(longitudes))) ** 0.6)
            anchos = [round(ANCHO * p / sum(pesos)) for p in pesos]
            anchos[-1] += ANCHO - sum(anchos)
            propiedades = nodo(tabla, 'w:tblPr')
            nodo(propiedades, 'w:tblW', w=ANCHO, type='dxa')
            nodo(propiedades, 'w:tblLayout', type='fixed')
            nodo(propiedades, 'w:jc', val='center')
            bordes = nodo(propiedades, 'w:tblBorders')
            for borde in ['top', 'left', 'bottom', 'right', 'insideH', 'insideV']:
                nodo(bordes, 'w:' + borde, val='single', sz=4, color='B8B8B8')
            grid = nodo(tabla, 'w:tblGrid')
            grid.clear()
            for ancho in anchos:
                E.SubElement(grid, etiqueta('w:gridCol')).set(etiqueta('w:w'), str(ancho))
            for numero, fila in enumerate(filas):
                trpr = nodo(fila, 'w:trPr')
                nodo(trpr, 'w:cantSplit')
                if numero == 0:
                    nodo(trpr, 'w:tblHeader')
                for col, celda in enumerate(fila.findall('w:tc', NS)):
                    tcpr = nodo(celda, 'w:tcPr')
                    nodo(tcpr, 'w:tcW', w=anchos[col], type='dxa')
                    nodo(tcpr, 'w:vAlign', val='center')
                    if numero == 0:
                        nodo(tcpr, 'w:shd', fill='EDEDED', val='clear')
                    for parrafo in celda.findall('.//w:p', NS):
                        ppr = nodo(parrafo, 'w:pPr')
                        nodo(ppr, 'w:spacing', before=60, after=60, line=240, lineRule='auto')
                        nodo(ppr, 'w:jc', val='left')
                        # Todas las tablas de esta edición caben en una página.
                        nodo(ppr, 'w:keepNext', val=int(numero < len(filas) - 1))
                        for run in parrafo.findall('w:r', NS):
                            fuente(nodo(run, 'w:rPr'), 10 if cantidad < 6 else 9)
                            if numero == 0:
                                nodo(nodo(run, 'w:rPr'), 'w:b')
    partes['word/document.xml'] = E.tostring(doc, xml_declaration=True, encoding='UTF-8', standalone=True)
    settings = E.fromstring(partes['word/settings.xml'])
    nodo(settings, 'w:updateFields', val='true')
    partes['word/settings.xml'] = E.tostring(settings, xml_declaration=True, encoding='UTF-8', standalone=True)
    temporal = ruta.with_suffix('.tmp')
    with ZipFile(temporal, 'w', ZIP_DEFLATED) as archivo:
        for nombre, datos in partes.items():
            archivo.writestr(nombre, datos)
    temporal.replace(ruta)


def recorrer(valor):
    if isinstance(valor, dict):
        yield valor
        for hijo in valor.values():
            yield from recorrer(hijo)
    elif isinstance(valor, list):
        for hijo in valor:
            yield from recorrer(hijo)


def main():
    tablas = preparar_fuentes()
    front = (CAPITULOS / '_tesis-frontmatter.md').read_text(encoding='utf-8')
    front = re.sub(r'^## (Resumen|Abstract|Alcance de la tesis|Alcance de la edición TG2)$', r'# \1 {.unnumbered}', front, flags=re.M)
    partes = [front.strip()]
    partes.extend(p.read_text(encoding='utf-8').strip().replace('](../Figuras/', '](Figuras/')
                  for p in sorted(CAPITULOS.glob('Cap[1-7]-*.md')))
    partes.append((CAPITULOS / '_tesis-glosario.md').read_text(encoding='utf-8').strip())
    partes.append((CAPITULOS / '_tesis-bibliografia.md').read_text(encoding='utf-8').strip())
    conjunto = '\n\n'.join(partes) + '\n'
    markdown = CARPETA / 'Tesis-NEXUS-completa.md'
    markdown.write_text(conjunto, encoding='utf-8')
    formato = 'markdown+tex_math_single_backslash-implicit_figures'
    ast = json.loads(subprocess.check_output(['pandoc', str(markdown), '-f', formato, '-t', 'json'], text=True, encoding='utf-8', creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0)))
    nodos = list(recorrer(ast['blocks']))
    numero_tablas = sum(n.get('t') == 'Table' for n in nodos)
    if numero_tablas != len(tablas):
        raise ValueError(f'Pandoc produjo {numero_tablas} tablas, esperadas {len(tablas)}')
    if any(n.get('t') == 'RawInline' and n.get('c', [''])[0] == 'tex' for n in nodos):
        raise ValueError('LaTeX sin convertir fuera de ecuaciones; revisar tablas')
    plantilla = CARPETA / 'plantilla-referencia.docx'
    formatear_docx(plantilla, es_plantilla=True)
    word = CARPETA / 'Tesis-NEXUS-completa.docx'
    proceso = subprocess.run(['pandoc', str(markdown), '-f', formato, '-o', str(word),
                              '--reference-doc=' + str(plantilla), '--resource-path=' + str(CARPETA),
                              '--toc', '--toc-depth=2',
                              '--metadata', 'lang=es', '--metadata', 'toc-title=Contenido'],
                             text=True, encoding='utf-8', capture_output=True,
                             creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0))
    if proceso.returncode or proceso.stderr.strip():
        raise RuntimeError('Pandoc requiere revisión: ' + proceso.stderr)
    formatear_docx(word)
    with ZipFile(word) as z:
        doc = E.fromstring(z.read('word/document.xml'))
        finales = doc.findall('.//w:tbl', NS)
        if len(finales) != len(tablas):
            raise ValueError('Cambió el número de tablas al generar Word')
        for tabla, esperado in zip(finales, tablas):
            filas = tabla.findall('w:tr', NS)
            if len(filas) != esperado['filas']:
                raise ValueError(f'Filas distintas en {esperado["rotulo"]}')
            if any(len(f.findall('w:tc', NS)) != esperado['columnas'] for f in filas):
                raise ValueError(f'Columnas distintas en {esperado["rotulo"]}')
        ecuaciones = len(doc.findall('.//m:oMath', NS))
    reporte = {'fecha': FECHA, 'tablas': tablas, 'ecuaciones_word': ecuaciones,
               'figuras_word': len(doc.findall('.//w:drawing', NS)),
               'tablas_word': len(finales), 'advertencias_pandoc': [],
               'revision_visual': 'Pendiente de renderizado de Word/PDF.'}
    destino = EVIDENCIA / 'formato-manuscrito.json'
    destino.parent.mkdir(parents=True, exist_ok=True)
    destino.write_text(json.dumps(reporte, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(f'Edición ensamblada: {len(finales)} tablas verificadas y {ecuaciones} ecuaciones Word.')


if __name__ == '__main__':
    main()
