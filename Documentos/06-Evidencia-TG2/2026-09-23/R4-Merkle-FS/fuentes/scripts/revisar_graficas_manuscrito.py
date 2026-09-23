"""Inventaría figuras y ecuaciones; prepara recortes para inspección visual."""
from pathlib import Path
import json
import re
import subprocess
import sys
import unicodedata
from difflib import SequenceMatcher

from PIL import Image, ImageDraw
from lxml import etree
from configuracion_manuscrito import FECHA, EVIDENCIA

RAIZ = Path(__file__).resolve().parents[1]
CARPETA = RAIZ / 'Documentos/01-Manuscrito'
SALIDA = RAIZ / '.tools/revision-graficas'
sys.path.insert(0, str(RAIZ / '.tools/pdf'))
import pymupdf


def nodos(valor):
    if isinstance(valor, dict):
        yield valor
        for hijo in valor.values():
            yield from nodos(hijo)
    elif isinstance(valor, list):
        for hijo in valor:
            yield from nodos(hijo)


def main():
    SALIDA.mkdir(parents=True, exist_ok=True)
    ast = json.loads(subprocess.check_output([
        'pandoc', str(CARPETA / 'Tesis-NEXUS-completa.md'), '-f',
        'markdown+tex_math_single_backslash-implicit_figures', '-t', 'json'],
        text=True, encoding='utf-8'))
    elementos = list(nodos(ast['blocks']))
    imagenes = [n['c'][2][0] for n in elementos if n.get('t') == 'Image']
    ecuaciones = [n['c'][1] for n in elementos if n.get('t') == 'Math'
                  and n['c'][0]['t'] == 'DisplayMath']
    word = json.loads((EVIDENCIA / 'paginacion-word.json').read_text(encoding='utf-8-sig'))
    if len(imagenes) != len(word['figuras']):
        raise ValueError('El número de figuras difiere entre Markdown y Word.')
    if len(ecuaciones) != len(word['ecuaciones_bloque']):
        raise ValueError('El número de ecuaciones en bloque difiere entre Markdown y Word.')
    documento = pymupdf.open(CARPETA / 'Tesis-NEXUS-completa.pdf')
    html = json.loads((RAIZ / '.tools/render/formulas-html.json').read_text(encoding='utf-8'))
    if len(html) != len(ecuaciones):
        raise ValueError('El número de fórmulas HTML difiere del manuscrito.')
    if any(f['tamano_pt'] < 11.9 or f['ancho_contenido_pt'] > 468 for f in html):
        raise ValueError('Hay fórmulas reducidas o más anchas que la caja de texto.')
    figuras = []
    for ruta, ubicacion in zip(imagenes, word['figuras']):
        archivo = CARPETA / ruta
        numero = re.search(r'figura-(\d)-(\d)', archivo.stem)
        rotulo = f'Figura {numero[1]}.{numero[2]}'
        paginas = [i+1 for i, pagina in enumerate(documento) if rotulo in pagina.get_text()]
        if len(paginas) != 1:
            raise ValueError(f'Rótulo duplicado o ausente en PDF: {rotulo}')
        for extension in ('.png', '.svg', '.pdf'):
            if not archivo.with_suffix(extension).is_file():
                raise FileNotFoundError(archivo.with_suffix(extension))
        with Image.open(archivo) as imagen:
            dimensiones = list(imagen.size)
        pagina = documento[paginas[0]-1]
        pagina.get_pixmap(matrix=pymupdf.Matrix(1.5, 1.5)).save(SALIDA / f'{archivo.stem}-pdf.png')
        figuras.append({'rotulo': rotulo, 'fuente': ruta, 'pagina_pdf': paginas[0],
                        **ubicacion, 'dimensiones_png': dimensiones,
                        'formatos': ['SVG', 'PDF vectorial', 'PNG 320 ppp']})
    # Recortes de todas las ecuaciones nativas, sobre las páginas renderizadas por Word.
    for inicio in range(0, len(ecuaciones), 6):
        recortes = []
        for fila, (formula, ubicacion) in enumerate(zip(
                ecuaciones[inicio:inicio+6], word['ecuaciones_bloque'][inicio:inicio+6])):
            numero = inicio + fila + 1
            pagina = ubicacion['pagina']
            imagen = Image.open(RAIZ / f'.tools/render-word/word-{pagina:03}.png')
            superior = max(0, (ubicacion['y_inicio_pt']-16)*1.5)
            # Word puede informar la primera línea como final de una matriz alineada.
            margen_inferior = 72 + 36 * formula.count(r"\\")
            inferior = min(imagen.height, (ubicacion['y_fin_pt']+margen_inferior)*1.5)
            recorte = imagen.crop((70, int(superior), 865, int(inferior)))
            recortes.append((numero, pagina, recorte))
        # Las fórmulas de varias líneas requieren filas de altura variable.
        lamina = Image.new('RGB', (810, sum(r.height+35 for _, _, r in recortes)), 'white')
        dibujo = ImageDraw.Draw(lamina)
        posicion = 0
        for numero, pagina, recorte in recortes:
            lamina.paste(recorte, (5, posicion+25))
            dibujo.text((10, posicion+5), f'Ecuacion {numero} | Word p. {pagina}', fill='black')
            posicion += recorte.height+35
        lamina.save(SALIDA / f'ecuaciones-word-{inicio//6+1}.png')
    # Busca bloques de texto matemático del PDF para preparar recortes de su salida real.
    # La coincidencia textual propone ubicaciones; los recortes requieren revisión visual.
    def normalizar(texto):
        texto = unicodedata.normalize('NFKD', texto)
        return ''.join(c for c in texto if c.isalnum()).lower()
    candidatos = []
    for i, pagina in enumerate(documento):
        bloques = pagina.get_text('dict')['blocks']
        for bloque in bloques:
            if bloque['type'] != 0:
                continue
            spans = [s for linea in bloque['lines'] for s in linea['spans']]
            if any('Math' in s['font'] for s in spans):
                texto = ''.join(s['text'] for s in spans)
                candidatos.append((i, bloque['bbox'], normalizar(texto)))
                cercanos = [b for b in bloques if b['type'] == 0
                            and b['bbox'][1] < bloque['bbox'][3]+20
                            and b['bbox'][3] > bloque['bbox'][1]-20]
                union = pymupdf.Rect(bloque['bbox'])
                textos = []
                for vecino in cercanos:
                    union |= pymupdf.Rect(vecino['bbox'])
                    textos.extend(s['text'] for linea in vecino['lines'] for s in linea['spans'])
                candidatos.append((i, tuple(union), normalizar(''.join(textos))))
    posiciones_pdf = []
    for inicio in range(0, len(html), 6):
        lamina = Image.new('RGB', (810, 6*185), 'white')
        dibujo = ImageDraw.Draw(lamina)
        for fila, formula in enumerate(html[inicio:inicio+6]):
            math = etree.fromstring(formula['mathml'].encode('utf-8'))
            for anotacion in math.xpath('//*[local-name()="annotation"]'):
                anotacion.getparent().remove(anotacion)
            objetivo = normalizar(''.join(math.itertext()))
            puntuar = lambda c: SequenceMatcher(None, objetivo, c[2]).ratio()
            elegido = max(candidatos, key=puntuar)
            pagina, caja, _ = elegido
            similitud = puntuar(elegido)
            # Amplía el recorte para mostrar exponentes y límites sobre la línea principal.
            superior = max(60, caja[1]-25)
            inferior = min(730, caja[3]+12)
            pix = documento[pagina].get_pixmap(matrix=pymupdf.Matrix(1.5,1.5),
                clip=pymupdf.Rect(55, superior, 557, inferior))
            recorte = Image.frombytes('RGB', [pix.width, pix.height], pix.samples)
            recorte.thumbnail((795, 155))
            lamina.paste(recorte, (5, fila*185+25))
            dibujo.text((10, fila*185+5), f'Ecuacion {formula["numero"]} | PDF p. {pagina+1}', fill='black')
            posiciones_pdf.append({'numero': formula['numero'], 'pagina_pdf': pagina+1,
                                   'similitud_textual': round(similitud,3),
                                   'tamano_pt': formula['tamano_pt'],
                                   'ancho_contenido_pt': formula['ancho_contenido_pt']})
        lamina.save(SALIDA / f'ecuaciones-pdf-{inicio//6+1}.png')
    reporte = {'fecha': FECHA, 'figuras': figuras,
               'bloques_codigo_en_manuscrito': sum(n.get('t') == 'CodeBlock' for n in elementos),
               'ecuaciones_en_bloque': [{'numero': i+1, 'latex': formula, **ubicacion}
                   for i, (formula, ubicacion) in enumerate(zip(ecuaciones, word['ecuaciones_bloque']))],
               'formulas_pdf': posiciones_pdf,
               'inspeccion_visual': 'Recortes generados; registrar la inspección en el informe de revisión.'}
    (EVIDENCIA / 'revision-graficas.json').write_text(
        json.dumps(reporte, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps({'figuras': figuras, 'ecuaciones_en_bloque': len(ecuaciones)}, ensure_ascii=False))


if __name__ == '__main__':
    main()
