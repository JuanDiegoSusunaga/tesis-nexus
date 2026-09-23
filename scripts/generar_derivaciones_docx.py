"""Compila el documento de derivaciones con ecuaciones nativas y tablas comprobadas."""
import hashlib
import json
from pathlib import Path
import subprocess
from zipfile import ZipFile, ZIP_DEFLATED

from lxml import etree
from compilar_manuscrito import formatear_docx, recorrer, nodo, fuente
from revisar_manuscrito import celdas

RAIZ = Path(__file__).resolve().parents[1]
FUENTE = RAIZ / 'Documentos/04-Administrativo-TG2/Avances/Derivaciones-Matematicas-TG2-2026-09-23.md'
SALIDA = FUENTE.with_suffix('.docx')
REVISION = RAIZ / '.tools/derivaciones'
NS = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main',
      'm': 'http://schemas.openxmlformats.org/officeDocument/2006/math'}


def compactar_referencias(ruta):
    """Mantiene las referencias juntas con fuente de 11 puntos y espacio sencillo."""
    with ZipFile(ruta) as z:
        partes = {nombre: z.read(nombre) for nombre in z.namelist()}
    doc = etree.fromstring(partes['word/document.xml'])
    referencias = False
    for parrafo in doc.findall('./w:body/w:p', NS):
        texto = ''.join(parrafo.xpath('.//w:t/text()', namespaces=NS))
        if texto.startswith('10. Fuentes y documentos de respaldo'):
            referencias = True
        estilo = parrafo.find('w:pPr/w:pStyle', NS)
        identificador = estilo.get('{' + NS['w'] + '}val', '') if estilo is not None else ''
        if referencias and not identificador.startswith('Heading'):
            nodo(nodo(parrafo, 'w:pPr'), 'w:spacing', before=0, after=80, line=240, lineRule='auto')
            for run in parrafo.findall('.//w:r', NS):
                fuente(nodo(run, 'w:rPr'), 11)
    partes['word/document.xml'] = etree.tostring(doc, xml_declaration=True, encoding='UTF-8', standalone=True)
    with ZipFile(ruta, 'w', ZIP_DEFLATED) as z:
        for nombre, datos in partes.items():
            z.writestr(nombre, datos)


def main():
    REVISION.mkdir(parents=True, exist_ok=True)
    trabajo = REVISION / 'generado.docx'
    formato = 'markdown+tex_math_single_backslash-implicit_figures'
    ast = json.loads(subprocess.check_output(
        ['pandoc', str(FUENTE), '-f', formato, '-t', 'json'], text=True, encoding='utf-8'))
    nodos = list(recorrer(ast['blocks']))
    tablas = sum(n.get('t') == 'Table' for n in nodos)
    matematicas = [n for n in nodos if n.get('t') == 'Math']
    bloques = sum(n['c'][0]['t'] == 'DisplayMath' for n in matematicas)
    if any(n.get('t') in ['RawInline', 'RawBlock'] and n.get('c', [''])[0] == 'tex' for n in nodos):
        raise ValueError('Hay LaTeX fuera de los nodos matemáticos.')
    proceso = subprocess.run(
        ['pandoc', str(FUENTE), '-f', formato, '-o', str(trabajo),
         '--reference-doc=' + str(RAIZ / 'Documentos/01-Manuscrito/plantilla-referencia.docx'),
         '--toc', '--toc-depth=2', '--metadata', 'toc-title=Contenido'],
        capture_output=True, text=True, encoding='utf-8')
    if proceso.returncode or proceso.stderr.strip():
        raise RuntimeError('Revisar la conversión Pandoc: ' + proceso.stderr)
    referencia = REVISION / 'referencia-pandoc.docx'
    referencia.write_bytes(trabajo.read_bytes())
    formatear_docx(trabajo)
    compactar_referencias(trabajo)
    esperadas = celdas(referencia)
    finales = celdas(trabajo)
    if esperadas != finales:
        raise ValueError('El formato cambió el contenido de las tablas.')
    with ZipFile(trabajo) as z:
        doc = etree.fromstring(z.read('word/document.xml'))
    ecuaciones = len(doc.findall('.//m:oMath', NS))
    if len(doc.findall('.//w:tbl', NS)) != tablas or ecuaciones != len(matematicas):
        raise ValueError('El número de tablas o ecuaciones no coincide con la fuente.')
    # Publicar solo cuando la conversión y sus comprobaciones han terminado.
    trabajo.replace(SALIDA)
    reporte = {'fuente': FUENTE.relative_to(RAIZ).as_posix(),
               'word': SALIDA.relative_to(RAIZ).as_posix(), 'tablas': tablas,
               'celdas': sum(len(fila) for tabla in finales for fila in tabla),
               'ecuaciones_nativas': ecuaciones, 'ecuaciones_bloque': bloques,
               'sha256_fuente': hashlib.sha256(FUENTE.read_bytes()).hexdigest(),
               'sha256_word_antes_actualizar_indice': hashlib.sha256(SALIDA.read_bytes()).hexdigest(),
               'advertencias_pandoc': [], 'revision_visual': 'Pendiente de paginación y renderizado.'}
    (REVISION / 'revision-estructural.json').write_text(
        json.dumps(reporte, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(reporte, ensure_ascii=False))


if __name__ == '__main__':
    main()
