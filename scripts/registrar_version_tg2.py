"""Identifica una edición de trabajo y el commit de código que la acompaña."""
from datetime import date
import hashlib
import json
from pathlib import Path
import subprocess
from verificar_version_tg2 import es_temporal_word

RAIZ = Path(__file__).resolve().parents[1]
MANIFIESTO = RAIZ / 'Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json'


def git(carpeta, *argumentos):
    return subprocess.check_output(['git', '-C', str(carpeta), *argumentos], text=True, encoding='utf-8', creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0)).strip()


def registrar_integrado(raiz, manifiesto, datos):
    """Actualiza los hashes de los archivos incluidos, conservando su procedencia."""
    rutas = git(raiz, 'ls-files', '-z', '--cached').split('\0')
    archivos = []
    for nombre in sorted(set(rutas) - {''}):
        ruta = raiz / nombre
        if ruta.resolve() == manifiesto.resolve() or es_temporal_word(ruta):
            continue
        if not ruta.is_file():
            raise SystemExit('Falta un archivo versionado: ' + nombre)
        archivos.append({'archivo': nombre, 'bytes': ruta.stat().st_size,
                         'sha256': hashlib.sha256(ruta.read_bytes()).hexdigest()})
    codigo = datos['codigo']['directorio'].rstrip('/') + '/'
    if not any(item['archivo'].startswith(codigo) for item in archivos):
        raise SystemExit('Incorporar primero los archivos Rust al índice del repositorio unificado.')
    datos['fecha'] = date.today().isoformat()
    datos['documentos']['commit_contexto'] = git(raiz, 'rev-parse', 'HEAD')
    datos['archivos'] = archivos
    manifiesto.write_text(json.dumps(datos, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps({'manifiesto': manifiesto.relative_to(raiz).as_posix(),
                      'codigo_integrado': datos['codigo']['directorio'], 'archivos': len(archivos)}))


def main():
    if MANIFIESTO.exists():
        datos = json.loads(MANIFIESTO.read_text(encoding='utf-8'))
        if datos.get('esquema') == 2 and datos.get('codigo', {}).get('modo') == 'integrado':
            registrar_integrado(RAIZ, MANIFIESTO, datos)
            return
    codigo = RAIZ / 'nexus'
    if git(codigo, 'status', '--porcelain', '--untracked-files=all'):
        raise SystemExit('Registrar primero el commit de código; hay cambios o archivos nuevos pendientes.')
    archivos = []
    for carpeta in ['Documentos/01-Manuscrito', 'Documentos/06-Evidencia-TG2']:
        for ruta in sorted((RAIZ / carpeta).rglob('*')):
            if not ruta.is_file() or es_temporal_word(ruta):
                continue
            archivos.append({'archivo': ruta.relative_to(RAIZ).as_posix(), 'bytes': ruta.stat().st_size,
                             'sha256': hashlib.sha256(ruta.read_bytes()).hexdigest()})
    # Las rutas del manifiesto deben poder incluirse sin forzar las exclusiones.
    ignorados = git(RAIZ, 'ls-files', '-z', '--others', '--ignored', '--exclude-standard', '--',
                    'Documentos/01-Manuscrito', 'Documentos/06-Evidencia-TG2')
    ignorados = '\n'.join(p for p in ignorados.split('\0') if p and not es_temporal_word(Path(p)))
    if ignorados:
        raise SystemExit('Hay archivos de la edición ignorados por Git:\n' + ignorados)
    datos = {
        'esquema': 1, 'edicion': 'tg2-' + date.today().isoformat() + '-organizacion',
        'fecha': date.today().isoformat(), 'estado': 'Edición de trabajo preparada para revisión',
        'documentos': {'repositorio': 'https://github.com/JuanDiegoSusunaga/tesis-nexus.git',
                       'commit_anterior': git(RAIZ, 'rev-parse', 'HEAD'),
                       'identificacion': 'El commit que contiene este manifiesto identifica la edición documental.'},
        'codigo': {'repositorio': 'https://github.com/JuanDiegoSusunaga/nexus.git',
                   'directorio': 'nexus', 'commit': git(codigo, 'rev-parse', 'HEAD')},
        'archivos': archivos,
        'limite': 'Los hashes identifican archivos conservados; la aprobación académica y las obligaciones formales siguen en el balance de objetivos.',
    }
    MANIFIESTO.write_text(json.dumps(datos, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps({'manifiesto': MANIFIESTO.relative_to(RAIZ).as_posix(),
                      'codigo': datos['codigo']['commit'], 'archivos': len(archivos)}))


if __name__ == '__main__':
    main()
