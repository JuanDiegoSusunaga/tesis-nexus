"""Comprueba las dependencias documentales instaladas sin regenerar archivos."""
import argparse
import importlib
import importlib.metadata
import importlib.util
import json
from pathlib import Path
import platform
import shutil
import subprocess
import sys

RAIZ = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--salida', type=Path, help='Conservar el informe JSON en esta ruta.')
    args = parser.parse_args()
    # Compatibilidad con la instalación local usada para la edición conservada.
    if importlib.util.find_spec('pymupdf') is None and (RAIZ / '.tools/pdf').is_dir():
        sys.path.insert(0, str(RAIZ / '.tools/pdf'))
    paquetes = []
    for linea in (RAIZ / 'requirements.txt').read_text(encoding='utf-8').splitlines():
        if not linea or linea.startswith('#'):
            continue
        nombre, version = linea.split('==')
        try:
            instalada = importlib.metadata.version(nombre)
        except importlib.metadata.PackageNotFoundError:
            instalada = None
        paquetes.append({'paquete': nombre, 'esperada': version, 'instalada': instalada,
                         'coincide': instalada == version})
    modulos = []
    for nombre in ['lxml.etree', 'matplotlib', 'PIL.Image', 'numpy', 'pymupdf']:
        try:
            modulo = importlib.import_module(nombre)
            modulos.append({'modulo': nombre, 'carga': True, 'archivo': modulo.__file__})
        except ImportError as error:
            modulos.append({'modulo': nombre, 'carga': False, 'error': str(error)})
    herramientas = {}
    for nombre in ['git', 'pandoc', 'rustc', 'cargo', 'powershell.exe']:
        ruta = shutil.which(nombre)
        herramientas[nombre] = {'ruta': ruta}
        if ruta and nombre != 'powershell.exe':
            proceso = subprocess.run([ruta, '--version'], capture_output=True, text=True)
            herramientas[nombre]['version'] = proceso.stdout.splitlines()[0] if proceso.stdout else proceso.stderr.strip()
            herramientas[nombre]['codigo_salida'] = proceso.returncode
    navegadores = [Path('C:/Program Files/Google/Chrome/Application/chrome.exe'),
                   Path('C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe')]
    navegador = next((str(p) for p in navegadores if p.is_file()), None)
    registro_word = False
    if sys.platform == 'win32':
        import winreg
        try:
            with winreg.OpenKey(winreg.HKEY_CLASSES_ROOT, 'Word.Application\\CLSID'):
                registro_word = True
        except FileNotFoundError:
            pass
    correcto = (all(p['coincide'] for p in paquetes) and all(m['carga'] for m in modulos)
                and all(herramientas[n]['ruta'] for n in ['git', 'pandoc', 'powershell.exe'])
                and navegador is not None and registro_word)
    informe = {'python': platform.python_version(), 'plataforma': platform.platform(),
               'paquetes': paquetes, 'modulos': modulos, 'herramientas': herramientas,
               'navegador': navegador, 'word_registrado': registro_word,
               'limite': 'Detecta instalación e importaciones; no ejecuta Word ni acredita una instalación nueva.',
               'correcto': correcto}
    texto = json.dumps(informe, ensure_ascii=False, indent=2) + '\n'
    if args.salida:
        args.salida.parent.mkdir(parents=True, exist_ok=True)
        args.salida.write_text(texto, encoding='utf-8')
    print(texto)
    return 0 if correcto else 1


if __name__ == '__main__':
    raise SystemExit(main())
