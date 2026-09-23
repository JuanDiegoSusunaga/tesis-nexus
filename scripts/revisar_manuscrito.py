"""Comprueba celdas contra Pandoc y prepara láminas para revisión visual del PDF."""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import re
import subprocess
import sys

from lxml import etree as E
from configuracion_manuscrito import FECHA, EVIDENCIA

RAIZ = Path(__file__).resolve().parents[1]
CARPETA = RAIZ / 'Documentos/01-Manuscrito'
RENDER = RAIZ / '.tools/render'
NS = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main',
      'm': 'http://schemas.openxmlformats.org/officeDocument/2006/math'}


def celdas(ruta):
    with ZipFile(ruta) as archivo:
        doc = E.fromstring(archivo.read('word/document.xml'))
    # Word guarda ℓ como «l» con estilo matemático script al actualizar el índice.
    for run in doc.findall('.//m:r', NS):
        estilo = run.find('m:rPr/m:scr', NS)
        texto = run.find('m:t', NS)
        if estilo is not None and estilo.get('{' + NS['m'] + '}val') == 'script' and texto is not None and (texto.text or '').strip() == 'l':
            texto.text = texto.text.replace('l', 'ℓ')
    resultado = []
    for tabla in doc.findall('.//w:tbl', NS):
        filas = []
        for fila in tabla.findall('w:tr', NS):
            valores = []
            for celda in fila.findall('w:tc', NS):
                # Conserva el orden de texto y ecuaciones, independientemente de sus estilos.
                texto = ''.join(celda.xpath('.//w:t/text() | .//m:t/text()', namespaces=NS))
                texto = re.sub(r'\s+', ' ', texto).strip()
                valores.append(texto)
            filas.append(valores)
        resultado.append(filas)
    return resultado


def main():
    RENDER.mkdir(parents=True, exist_ok=True)
    referencia = RENDER / 'tablas-referencia.docx'
    subprocess.run(['pandoc', str(CARPETA / 'Tesis-NEXUS-completa.md'),
                    '-f', 'markdown+tex_math_single_backslash-implicit_figures',
                    '--resource-path=' + str(CARPETA), '-o', str(referencia)], check=True)
    esperado = celdas(referencia)
    observado = celdas(CARPETA / 'Tesis-NEXUS-completa.docx')
    if esperado != observado:
        diferencias = []
        for i, (a, b) in enumerate(zip(esperado, observado), 1):
            if a != b:
                diferencias.append({'tabla': i, 'fuente': a, 'word': b})
        raise ValueError(f'Contenido de tablas diferente: {diferencias}')
    reporte = {'tablas_con_contenido_identico': len(esperado),
               'celdas_comparadas': sum(len(f) for t in esperado for f in t),
               'sha256_contenido_tablas': hashlib.sha256(
                   json.dumps(esperado, ensure_ascii=False).encode('utf-8')).hexdigest()}
    pdf = CARPETA / 'Tesis-NEXUS-completa.pdf'
    if pdf.exists():
        sys.path.insert(0, str(RAIZ / '.tools/pdf'))
        import pymupdf as fitz
        from PIL import Image, ImageDraw
        documento = fitz.open(pdf)
        paginas_tablas = []
        margenes = []
        paginas_vacias = []
        miniaturas = []
        texto_total = []
        for i, pagina in enumerate(documento):
            texto = pagina.get_text()
            texto_total.append(texto)
            rotulos = re.findall(r'Tabla\s+[1-7]\.\d+', texto)
            if rotulos:
                paginas_tablas.append({'pagina': i + 1, 'rotulos': rotulos})
                pagina.get_pixmap(matrix=fitz.Matrix(1.5, 1.5)).save(RENDER / f'pagina-{i+1:03}.png')
            if len(texto.strip()) < 5:
                paginas_vacias.append(i + 1)
            for palabra in pagina.get_text('words'):
                if palabra[0] < 65 or palabra[2] > pagina.rect.width - 65:
                    margenes.append({'pagina': i + 1, 'texto': palabra[4],
                                     'x0': round(palabra[0], 1), 'x1': round(palabra[2], 1)})
            pix = pagina.get_pixmap(matrix=fitz.Matrix(0.4, 0.4))
            miniatura = Image.frombytes('RGB', [pix.width, pix.height], pix.samples)
            miniaturas.append(miniatura)
        for inicio in range(0, len(miniaturas), 12):
            lamina = Image.new('RGB', (3 * 265, 4 * 342), '#dddddd')
            dibujo = ImageDraw.Draw(lamina)
            for j, miniatura in enumerate(miniaturas[inicio:inicio+12]):
                x, y = (j % 3) * 265, (j // 3) * 342
                lamina.paste(miniatura, (x + 10, y + 20))
                dibujo.text((x + 10, y + 3), f'Página {inicio+j+1}', fill='black')
            lamina.save(RENDER / f'lamina-{inicio//12+1:02}.png')
        (RENDER / 'texto-pdf.txt').write_text('\n\f\n'.join(texto_total), encoding='utf-8')
        reporte.update({'paginas_pdf': len(documento), 'paginas_con_tablas': paginas_tablas,
                        'paginas_vacias': paginas_vacias, 'texto_fuera_de_margenes': margenes,
                        'sha256_pdf': hashlib.sha256(pdf.read_bytes()).hexdigest()})
    reporte['fecha'] = FECHA
    salida = EVIDENCIA / 'revision-exportacion.json'
    salida.parent.mkdir(parents=True, exist_ok=True)
    salida.write_text(json.dumps(reporte, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(reporte, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
