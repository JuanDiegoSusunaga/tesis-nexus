"""Conserva validación, edición y revisión visual de la auditoría Merkle/FS."""
from pathlib import Path
import hashlib
import json
import re
import shutil
from urllib.parse import unquote

raiz = Path(__file__).resolve().parents[1]
evidencia = raiz / 'Documentos/06-Evidencia-TG2/2026-09-23'
destino = evidencia / 'R4-Merkle-FS'
historica = raiz / 'Documentos/06-Evidencia-TG2/2026-09-22'
anterior = historica / 'R4-cota-interactiva'
corpus = historica / 'R4-FRI-vinculado'
manuscrito = raiz / 'Documentos/01-Manuscrito'


def leer(ruta):
    return json.loads(ruta.read_text(encoding='utf-8-sig'))


def huella(ruta):
    return hashlib.sha256(ruta.read_bytes()).hexdigest()


def escribir(ruta, datos):
    ruta.write_text(json.dumps(datos, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')


analisis = leer(destino / 'analisis.json')
for item in analisis['fuentes']:
    assert huella(raiz / item['archivo']) == item['sha256']
    assert huella(destino / 'fuentes' / item['archivo']) == item['sha256']
for item in analisis['corpus']:
    assert huella(raiz / item['archivo']) == item['sha256']
assert len(analisis['corpus']) == 14
assert analisis['total_consultas'] == 560 and analisis['total_aperturas'] == 18880
fechas = leer(destino / 'validacion-fechas.json')
assert len(fechas) == 7 and all(c['comprobada'] for c in fechas)
ejecuciones = []
for tarea, argumentos in [('check', '--all-targets '), ('test', ''), ('build', '')]:
    archivo = destino / f'cargo-{tarea}.log'
    datos = archivo.read_bytes()
    texto = datos.decode('utf-16' if datos.startswith(b'\xff\xfe') else 'utf-8')
    assert 'Finished ' in texto and not re.search(r'^error(?:\[|:)', texto, re.M)
    pruebas = None
    if tarea == 'test':
        cuentas = re.findall(r'test result: ok\. (\d+) passed; (\d+) failed;', texto)
        pruebas = sum(int(n) for n, _ in cuentas)
        assert pruebas == 197 and all(int(n) == 0 for _, n in cuentas)
    ejecuciones.append({'comando': f'cargo {tarea} --workspace {argumentos}--locked --offline --manifest-path nexus/Cargo.toml',
                        'log': archivo.name, 'codigo_salida': 0, 'pruebas': pruebas, 'sha256': huella(archivo)})
previa = leer(corpus / 'validacion.json')
for item in previa['corpus']:
    assert huella(corpus / item['archivo']) == item['sha256']
for item in previa['corpus_anterior_reutilizado']:
    assert huella(raiz / item['archivo']) == item['sha256']
escribir(destino / 'validacion.json', {
    'fecha': '2026-09-23', 'pruebas_workspace_repetidas': 197, 'ejecuciones': ejecuciones,
    'cargo_target_dir': 'C:/tmp/nexus-target',
    'auditoria_python': {'certificados': 14, 'consultas': 560, 'aperturas': 18880,
                        'casos_distribucion': analisis['distribucion']['casos_pequenos_contrastados'],
                        'perfiles': len(analisis['perfiles']),
                        'limite': 'Comprueba formato, transcripción, nonce, consultas, Merkle y enlace de aperturas; no revalida plegados FRI ni composición AIR.'},
    'validacion_fechas': {'casos': 7, 'archivo': 'validacion-fechas.json', 'sha256': huella(destino / 'validacion-fechas.json')},
    'analisis_sha256': huella(destino / 'analisis.json'),
    'release': 'No repetido en esta etapa; diez casos pasaron en R4-FRI-vinculado, cuyas fuentes y corpus conservan los hashes.',
    'referencia_validacion_anterior': {'archivo': (corpus / 'validacion.json').relative_to(raiz).as_posix(),
                                     'sha256': huella(corpus / 'validacion.json')},
    'limite': 'Auditoría de correspondencia y sesgo ideal; no extracción de oráculos, cota RBR conjunta ni garantía ROM/QROM del ejecutable.',
})

word = leer(evidencia / 'paginacion-word.json')
pdf = leer(evidencia / 'revision-exportacion.json')
formato = leer(evidencia / 'formato-manuscrito.json')
graficas = leer(evidencia / 'revision-graficas.json')
previas = leer(anterior / 'revision-graficas.json')
assert word['paginas_word'] == 108 and pdf['paginas_pdf'] == 95
assert pdf['tablas_con_contenido_identico'] == 32 and pdf['celdas_comparadas'] == 822
assert not pdf['paginas_vacias'] and not pdf['texto_fuera_de_margenes']
assert len(word['tablas']) == 32
assert all(t['pagina_inicio'] == t['pagina_fin'] == t['pagina_rotulo'] for t in word['tablas'])
assert formato['ecuaciones_word'] == 541 and len(graficas['ecuaciones_en_bloque']) == 30
assert len(graficas['figuras']) == 3 and graficas['figuras'] == previas['figuras']
assert graficas['ecuaciones_en_bloque'][:29] == previas['ecuaciones_en_bloque']
assert word['tablas'][-2]['pagina_inicio'] == 91
assert pdf['sha256_pdf'] == huella(manuscrito / 'Tesis-NEXUS-completa.pdf')
for item in leer(anterior / 'revision-manuscrito.json')['archivos']:
    if '/Figuras/' in item['archivo']:
        assert huella(raiz / item['archivo']) == item['sha256']
cap6 = (manuscrito / 'Capitulos/Cap6-Validacion-Formal.md').read_text(encoding='utf-8')
assert all(s in cap6 for s in ['6.7.6', 'Tabla 6.20', '560', '18.880', '904', '1233'])
informes = ['formato-manuscrito.json', 'revision-graficas.json', 'revision-exportacion.json', 'paginacion-word.json']
for nombre in informes:
    assert huella(historica / nombre) == huella(anterior / nombre), nombre

observacion = (
    'Inspección del 2026-09-23: sección 6.7.6, Tabla 6.20 y fórmula 30 completas '
    'en Word pp. 90–92 y PDF pp. 80–82; láminas finales de ecuaciones revisadas '
    'en ambos formatos, sin recortes de las fórmulas observados. Las 32 tablas '
    'conservan rótulo y cuerpo en una misma página Word; 822 celdas coinciden '
    'con la conversión independiente. PDF sin páginas vacías ni texto fuera '
    'de márgenes. Las tres figuras y las 29 fórmulas previas conservan fuentes, '
    'dimensiones y ubicaciones registradas; se mantiene su revisión anterior. '
    'El peso aparente de las letras en la rasterización EMF de Word no implica '
    'negrita global. Los cuatro informes raíz del día 22 conservan sus hashes '
    'respecto de la etapa R4-cota-interactiva.'
)
formato['revision_visual'] = observacion
graficas['inspeccion_visual'] = observacion
escribir(evidencia / 'formato-manuscrito.json', formato)
escribir(evidencia / 'revision-graficas.json', graficas)
for nombre in informes:
    shutil.copy2(evidencia / nombre, destino / nombre)
imagenes = [raiz / f'.tools/render-word/word-{n:03}.png' for n in [90, 91, 92]]
imagenes += [raiz / f'.tools/revision-merkle-fs/pdf-{n:03}.png' for n in [80, 81, 82]]
imagenes += [raiz / f'.tools/revision-graficas/ecuaciones-{tipo}-5.png' for tipo in ['word', 'pdf']]
(destino / 'revision-visual').mkdir(exist_ok=True)
registros_imagenes = []
for archivo in imagenes:
    copia = destino / 'revision-visual' / archivo.name
    shutil.copy2(archivo, copia)
    registros_imagenes.append({'archivo': copia.relative_to(destino).as_posix(), 'sha256': huella(copia)})
fuentes = list((manuscrito / 'Capitulos').glob('*.md'))
assert len(fuentes) == 9
fuentes += [manuscrito / ('Tesis-NEXUS-completa.' + ext) for ext in ['md', 'docx', 'pdf']]
fuentes += list((manuscrito / 'Figuras').glob('*.png')) + list((manuscrito / 'Figuras').glob('*.svg'))
reportes = ['Documentos/04-Administrativo-TG2/Avances/R4-Merkle-Fiat-Shamir-2026-09-23.md',
            'Documentos/04-Administrativo-TG2/Avances/Revision-Matematica-S1-S3-2026-09-23.md']
fuentes += [raiz / f for f in reportes]
scripts = ['scripts/configuracion_manuscrito.py', 'scripts/compilar_manuscrito.py',
           'scripts/revisar_manuscrito.py', 'scripts/revisar_graficas_manuscrito.py',
           'scripts/renderizar_manuscrito_word.ps1', 'scripts/exportar_manuscrito_word.ps1',
           'scripts/exportar_manuscrito_pdf.py', '.tools/registrar_revision_visual_merkle_fs.py']
for nombre in scripts:
    copia = destino / 'fuentes' / nombre
    copia.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(raiz / nombre, copia)
seguimiento = [
    'PENDIENTES.md', 'BITACORA_TG2.md', 'Documentos/01-Manuscrito/README.md',
    'Documentos/04-Administrativo-TG2/Ruta-de-Cierre-TG2.md',
    'Documentos/04-Administrativo-TG2/Estado-del-Proyecto-para-Director.md',
    'Documentos/05-Estado-del-Arte/Resumenes-y-Matriz/Matriz-Trazabilidad-TG2.md',
    'Documentos/04-Administrativo-TG2/Avances/Revision-Graficas-y-Evaluacion-2026-09-22.md', 'nexus/README.md',
    'RUTA_DE_ESTUDIO.md', 'Documentos/04-Administrativo-TG2/Plan-de-Trabajo-TG2.md',
    'Documentos/02-Investigacion-y-Notas/Estado-del-Arte-Claves-Efimeras-y-Deception.md',
]
assert not (raiz / 'Lluvia de ideas').exists()
escribir(destino / 'revision-manuscrito.json', {
    'fecha': '2026-09-23', 'etapa': 'R4 auditoría Merkle/Fiat–Shamir',
    'paginas_word': 108, 'paginas_pdf': 95, 'tablas': 32, 'celdas': 822,
    'ecuaciones_word': 541, 'ecuaciones_bloque': 30, 'figuras': 3,
    'revision_visual': observacion, 'imagenes_inspeccionadas': registros_imagenes,
    'archivos': [{'archivo': f.relative_to(raiz).as_posix(), 'sha256': huella(f)} for f in sorted(fuentes)],
    'seguimiento': [{'archivo': f, 'sha256': huella(raiz / f)} for f in seguimiento],
    'generadores_y_registro': [{'archivo': f, 'sha256': huella(raiz / f)} for f in scripts],
    'depuracion_documental': 'Carpeta Lluvia de ideas y sus dos documentos eliminados por indicación del autor; referencias activas retiradas y antecedente histórico anotado.',
    'alcance_enlaces': 'Seguimiento e informes de esta etapa; en nexus/README.md solo el estado vigente.',
    'limite': 'Pendientes extracción de oráculos, cota RBR del protocolo conjunto, compilación ROM/QROM y revisión matemática independiente.',
})
referencias = 0
for nombre in seguimiento[:8] + reportes:
    archivo = raiz / nombre
    contenido = archivo.read_text(encoding='utf-8')
    if nombre == 'nexus/README.md':
        contenido = contenido.split('## Registro de cota interactiva ideal')[0]
    for enlace in re.findall(r'\[[^\]]*\]\(([^)]+)\)', contenido):
        if '://' in enlace or enlace.startswith('#'):
            continue
        assert (archivo.parent / unquote(enlace.split('#')[0])).exists(), (nombre, enlace)
        referencias += 1
print(f'Comprobado: 197 pruebas; 108/95 páginas, 32 tablas, 822 celdas y {referencias} enlaces locales.')
