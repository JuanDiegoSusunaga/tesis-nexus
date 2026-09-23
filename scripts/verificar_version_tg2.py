"""Verifica la integridad de una edición conservada sin modificar el proyecto."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

RAIZ = Path(__file__).resolve().parents[1]


def es_temporal_word(ruta):
    """Reconoce archivos de propietario de Word, ajenos a la edición documental."""
    return ruta.name.startswith('~$') and ruta.suffix.lower() in {'.doc', '.docx', '.docm', '.dotx', '.dotm'}


def verificar(raiz, manifiesto):
    datos = json.loads(manifiesto.read_text(encoding='utf-8'))
    if datos.get('esquema') != 1:
        raise ValueError('Esquema de manifiesto no admitido.')
    errores = []
    rutas = set()
    for item in datos['archivos']:
        nombre = item['archivo']
        ruta = (raiz / nombre).resolve()
        if not ruta.is_relative_to(raiz.resolve()) or nombre in rutas:
            raise ValueError('Ruta fuera del proyecto o repetida: ' + nombre)
        rutas.add(nombre)
        if not ruta.is_file():
            errores.append('Falta: ' + nombre)
        elif ruta.stat().st_size != item['bytes'] or hashlib.sha256(ruta.read_bytes()).hexdigest() != item['sha256']:
            errores.append('Contenido diferente: ' + nombre)
    actuales = {p.relative_to(raiz).as_posix() for carpeta in ['Documentos/01-Manuscrito', 'Documentos/06-Evidencia-TG2']
                for p in (raiz / carpeta).rglob('*') if p.is_file() and not es_temporal_word(p)}
    for nombre in sorted(actuales - rutas):
        errores.append('Sin registrar en la edición: ' + nombre)
    codigo = (raiz / datos['codigo']['directorio']).resolve()
    if not codigo.is_relative_to(raiz.resolve()):
        raise ValueError('Directorio de código fuera del proyecto.')
    for carpeta in [raiz, codigo]:
        if not (carpeta / '.git').exists():
            errores.append('Falta el repositorio Git: ' + carpeta.name)
    if not errores:
        revision = subprocess.check_output(['git', '-C', str(codigo), 'rev-parse', 'HEAD'], text=True).strip()
        if revision != datos['codigo']['commit']:
            errores.append('El commit de código difiere del registrado.')
        estado = subprocess.check_output(['git', '-C', str(codigo), 'status', '--porcelain', '--untracked-files=all'], text=True)
        if estado.strip():
            errores.append('El código tiene cambios locales o archivos nuevos sin registrar.')
    return {'edicion': datos['edicion'], 'archivos_comprobados': len(rutas),
            'commit_codigo': datos['codigo']['commit'], 'errores': errores, 'correcto': not errores}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--manifiesto', type=Path,
                        default=RAIZ / 'Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json')
    args = parser.parse_args()
    informe = verificar(RAIZ, args.manifiesto)
    print(json.dumps(informe, ensure_ascii=False, indent=2))
    return 0 if informe['correcto'] else 1


if __name__ == '__main__':
    raise SystemExit(main())
