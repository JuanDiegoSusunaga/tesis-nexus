"""Genera el PDF local desde las mismas fuentes que Word, con MathML nativo."""
from pathlib import Path
import json
import re
import subprocess
import sys
from urllib.parse import unquote

RAIZ = Path(__file__).resolve().parents[1]
CARPETA = RAIZ / 'Documentos/01-Manuscrito'
RENDER = RAIZ / '.tools/render'
CSS = r'''
@page { size: letter; margin: 2.54cm;
  @bottom-center { content: counter(page); font: 10pt "Times New Roman"; }
}
@page:first { @bottom-center { content: none; } }
* { box-sizing: border-box; }
html { background: white; color: black; }
body { max-width: 6.5in; margin: 0 auto; font: 12pt/1.5 "Times New Roman", serif; }
p { margin: 0 0 6pt; text-align: justify; orphans: 3; widows: 3; }
h1,h2,h3,h4 { line-height: 1.5; break-after: avoid; margin: 12pt 0 6pt; }
h1 { font-size: 14pt; break-before: page; }
h2,h3,h4 { font-size: 12pt; }
header { min-height: 7in; padding-top: 1in; }
header h1 { font-size: 18pt; text-align: center; break-before: auto; }
header p { text-align: center; margin: 18pt 0; }
nav { break-before: page; break-after: page; font-size: 11pt; line-height: 1.15; }
nav ul { list-style: none; margin: 0; padding-left: 16pt; }
nav > ul { padding-left: 0; }
nav a { text-decoration: none; color: black; display: block; position: relative; padding-right: 24pt; }
nav .pagina { position: absolute; right: 0; top: 0; font-variant-numeric: tabular-nums; }
nav li { margin-bottom: 2pt; }
blockquote { margin: 8pt 0 10pt 18pt; padding-left: 10pt; border-left: 2pt solid #ccc; }
blockquote p { text-align: left; }
a { color: black; overflow-wrap: anywhere; }
table { border-collapse: collapse; width: 100%; margin: 0 0 12pt; font-size: 10pt; line-height: 1.2; table-layout: fixed; break-inside: avoid; }
thead { display: table-header-group; }
tr { break-inside: avoid; }
th,td { border: 0.5pt solid #b8b8b8; padding: 4pt; text-align: left !important; vertical-align: middle; overflow-wrap: anywhere; }
th { background: #ededed; font-weight: bold; }
td p { text-align: left; margin: 0; }
p.rotulo { font-weight: bold; text-align: left; break-after: avoid; margin: 10pt 0 5pt; line-height: 1.2; }
p.ilustracion { text-align: center; break-inside: avoid; break-after: avoid; line-height: 1; }
p.ilustracion img { display: block; width: 100%; height: auto; }
code { font-family: Consolas, monospace; font-size: 0.85em; overflow-wrap: anywhere; }
pre { font: 8pt/1.2 Consolas, monospace; white-space: pre; margin: 8pt 0; break-inside: avoid; }
pre code { font-size: inherit; overflow-wrap: normal; }
math { font-family: "Cambria Math", math; }
math[display="block"] { margin: 12pt 0; break-inside: avoid; }
hr { border: 0; border-top: 0.5pt solid #bbb; margin: 12pt 0; }
'''
AJUSTES = r'''
<script>
const paginas = __PAGINAS__;
for (const enlace of document.querySelectorAll('nav a')) {
  const pagina = document.createElement('span');
  pagina.className = 'pagina';
  pagina.textContent = paginas[decodeURIComponent(enlace.getAttribute('href').slice(1))] || '';
  enlace.append(pagina);
}
// Ajusta solo presentación; los textos y las ecuaciones provienen del ensamblado.
for (const p of document.querySelectorAll('p')) {
  if (/^(Tabla|Figura) [1-7]\.\d+/.test(p.textContent.trim())) p.classList.add('rotulo');
  if (p.querySelector('img')) p.classList.add('ilustracion');
}
const fecha = document.querySelector('header .date');
if (fecha) fecha.innerHTML = fecha.innerHTML.replaceAll(' · ', '<br>');
for (const tabla of document.querySelectorAll('table')) {
  const filas = [...tabla.rows];
  const cantidad = filas[0].cells.length;
  if (cantidad >= 6) tabla.style.fontSize = '9pt';
  const pesos = Array.from({length:cantidad}, (_, c) =>
    Math.pow(Math.max(10, Math.min(65, filas.reduce((n,f)=>n+f.cells[c].textContent.length,0)/filas.length)),0.6));
  const total = pesos.reduce((a,b)=>a+b,0);
  const colgroup = document.createElement('colgroup');
  for (const peso of pesos) {
    const col = document.createElement('col'); col.style.width = (100*peso/total)+'%'; colgroup.append(col);
  }
  tabla.querySelectorAll('colgroup').forEach(e=>e.remove());
  tabla.prepend(colgroup);
}
for (const bloque of document.querySelectorAll('pre, math')) {
  const celda = bloque.closest('td,th');
  const ancho = celda ? celda.clientWidth - 12 : document.body.clientWidth;
  const medido = Math.max(bloque.scrollWidth || 0, bloque.getBoundingClientRect().width,
    ...[...bloque.querySelectorAll('mrow,mtable')].map(e=>e.getBoundingClientRect().width));
  if (medido > ancho) {
    const tamano = parseFloat(getComputedStyle(bloque).fontSize);
    bloque.style.fontSize = (tamano * ancho / medido * 0.97) + 'px';
  }
}
// Evita que el navegador reduzca globalmente la página por una fórmula ancha.
document.documentElement.style.width = '6.5in';
document.documentElement.style.margin = '0 auto';
// Registra el tamaño efectivo de cada fórmula sin añadir contenido visible.
const registro = document.createElement('script');
registro.type = 'application/json';
registro.id = 'revision-formulas';
registro.textContent = JSON.stringify([...document.querySelectorAll('math[display="block"]')].map((m,i)=>({
  numero: i+1,
  tamano_pt: parseFloat(getComputedStyle(m).fontSize)*0.75,
  ancho_contenido_pt: Math.max(...[...m.querySelectorAll('mrow,mtable')].map(e=>e.getBoundingClientRect().width),0)*0.75,
  mathml: m.outerHTML,
  contexto_anterior: m.parentElement.previousElementSibling?.textContent || ''
})));
document.body.append(registro);
</script>
'''


def main():
    RENDER.mkdir(parents=True, exist_ok=True)
    salida = subprocess.check_output([
        'pandoc', str(CARPETA / 'Tesis-NEXUS-completa.md'),
        '-f', 'markdown+tex_math_single_backslash-implicit_figures', '-t', 'html5',
        '--standalone', '--mathml', '--toc', '--toc-depth=2',
        '--metadata', 'toc-title=Contenido'], text=True, encoding='utf-8',
        creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0))
    salida = re.sub(r'<style>.*?</style>', '', salida, flags=re.S)
    # El PDF utiliza los originales vectoriales locales de las figuras de Word.
    def imagen_local(coincidencia):
        ruta = CARPETA / unquote(coincidencia.group(1))
        vector = ruta.with_suffix('.svg')
        if not vector.is_file():
            raise FileNotFoundError(vector)
        return 'src="' + vector.as_uri() + '"'
    salida = re.sub(r'src="(Figuras/[^"]+\.png)"', imagen_local, salida)
    salida = salida.replace('</head>', '<style>' + CSS + '</style>\n</head>')
    html = RENDER / 'manuscrito.html'
    navegador = Path('C:/Program Files/Google/Chrome/Application/chrome.exe')
    if not navegador.exists():
        navegador = Path('C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe')
    pdf = CARPETA / 'Tesis-NEXUS-completa.pdf'
    comando = [
        str(navegador), '--headless=new', '--disable-gpu', '--disable-extensions',
        '--disable-background-networking', '--disable-sync', '--no-first-run',
        '--no-default-browser-check', '--no-pdf-header-footer',
        '--user-data-dir=' + str(RAIZ / '.tools/perfil-pdf'),
        '--print-to-pdf=' + str(pdf), '--dump-dom', '--virtual-time-budget=1500', html.as_uri()]
    sys.path.insert(0, str(RAIZ / '.tools/pdf'))
    import pymupdf
    paginas = {}
    for intento in range(3):
        ajustes = AJUSTES.replace('__PAGINAS__', json.dumps(paginas, ensure_ascii=False))
        html.write_text(salida.replace('</body>', ajustes + '\n</body>'), encoding='utf-8')
        resultado = subprocess.run(comando, capture_output=True, text=True,
                                   encoding='utf-8', errors='replace', timeout=90,
                                   creationflags=subprocess.CREATE_NO_WINDOW)
        if resultado.returncode or not pdf.exists():
            raise RuntimeError(resultado.stderr)
        registro = re.search(r'<script type="application/json" id="revision-formulas">(.*?)</script>',
                             resultado.stdout, flags=re.S)
        if not registro:
            raise RuntimeError('No se pudo recuperar el inventario de fórmulas del navegador.')
        (RENDER / 'formulas-html.json').write_text(registro.group(1), encoding='utf-8')
        with pymupdf.open(pdf) as documento:
            nuevas = {unquote(k): v['page'] + 1 for k, v in documento.resolve_names().items() if 'page' in v}
        if nuevas == paginas:
            break
        paginas = nuevas
    else:
        raise RuntimeError('La paginación del índice PDF no se estabilizó.')
    print(f'PDF local generado: {pdf.name} ({pdf.stat().st_size} bytes).')


if __name__ == '__main__':
    main()
