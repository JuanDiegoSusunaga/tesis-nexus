"""Comprueba la integridad documental del catálogo; no verifica demostraciones."""
import argparse
import hashlib
import json
from pathlib import Path
import re


RAIZ = Path(__file__).resolve().parents[1]
CATALOGO = RAIZ / 'Documentos/04-Administrativo-TG2/Avances/Catalogo-Validacion-2026-10-12/catalogo.json'
ESTADOS = {'derivacion_propuesta', 'contraste_empirico', 'correspondencia_documentada', 'trabajo_futuro'}


def verificar(raiz, datos):
    raiz = raiz.resolve()
    errores = []
    if datos.get('esquema') != 1:
        raise ValueError('Esquema de catálogo no admitido.')
    if datos.get('qrom_air_fri') != 'trabajo_futuro':
        errores.append('El alcance QROM de AIR/FRI debe conservarse como trabajo futuro.')
    if not re.fullmatch(r'[0-9a-f]{40}', datos.get('revision_codigo_analizada', '')):
        errores.append('La revisión de código debe ser un commit completo.')

    archivos = {}
    textos = {}
    for item in datos['archivos']:
        clave, nombre = item['id'], item['archivo']
        if clave in archivos:
            errores.append('ID de archivo repetido: ' + clave)
            continue
        archivos[clave] = item
        ruta = (raiz / nombre).resolve()
        if Path(nombre).is_absolute() or not ruta.is_relative_to(raiz):
            errores.append('Ruta fuera del proyecto: ' + nombre)
            continue
        if not re.fullmatch(r'[0-9a-f]{64}', item.get('sha256', '')):
            errores.append('SHA-256 inválido: ' + nombre)
            continue
        if not ruta.is_file():
            errores.append('Falta: ' + nombre)
            continue
        contenido = ruta.read_bytes()
        if hashlib.sha256(contenido).hexdigest() != item['sha256']:
            errores.append('Contenido diferente: ' + nombre)
        textos[clave] = contenido.decode('utf-8')

    afirmaciones = {}
    usados = set()
    for item in datos['afirmaciones']:
        clave = item['id']
        if clave in afirmaciones:
            errores.append('ID de afirmación repetido: ' + clave)
            continue
        afirmaciones[clave] = item
        for campo in ['enunciado', 'modelo', 'alcance']:
            if not isinstance(item.get(campo), str) or not item[campo].strip():
                errores.append(clave + ': falta ' + campo)
        for campo in ['hipotesis', 'exclusiones', 'revision', 'evidencia']:
            if not isinstance(item.get(campo), list) or not item[campo]:
                errores.append(clave + ': falta ' + campo)
        if item.get('estado') not in ESTADOS:
            errores.append(clave + ': estado no admitido en este catálogo.')
        if item.get('mecanizacion') != 'no_disponible' or item.get('dictamen') is not None:
            errores.append(clave + ': una nueva prueba o dictamen requiere una revisión del esquema y su evidencia.')
        if item.get('modelo') == 'QROM' and item.get('estado') != 'trabajo_futuro':
            errores.append(clave + ': el resultado QROM debe permanecer como trabajo futuro.')
        for evidencia in item['evidencia']:
            ref = evidencia['archivo_id']
            usados.add(ref)
            if ref not in archivos:
                errores.append(clave + ': evidencia desconocida ' + ref)
            localizador = evidencia.get('localizador', '')
            if not localizador or (ref in textos and localizador not in textos[ref]):
                errores.append(clave + ': localizador ausente en ' + ref)

    activos, terminados = set(), set()

    def visitar(clave):
        if clave in activos:
            errores.append('Ciclo de dependencias en ' + clave)
            return
        if clave in terminados:
            return
        activos.add(clave)
        for dependencia in afirmaciones[clave]['dependencias']:
            if dependencia not in afirmaciones:
                errores.append(clave + ': dependencia desconocida ' + dependencia)
            else:
                visitar(dependencia)
        activos.remove(clave)
        terminados.add(clave)

    for clave in afirmaciones:
        visitar(clave)
    for clave in archivos.keys() - usados:
        errores.append('Archivo sin afirmación asociada: ' + clave)
    if not archivos or not afirmaciones:
        errores.append('El catálogo necesita archivos y afirmaciones.')
    return {
        'correcto': not errores,
        'afirmaciones': len(afirmaciones),
        'archivos': len(archivos),
        'errores': errores,
        'alcance': 'Integridad y coherencia documental; no verifica verdad matemática ni seguridad.',
        'mecanizacion': 'no_disponible',
        'dictamen': 'pendiente',
        'qrom_air_fri': datos.get('qrom_air_fri'),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--catalogo', type=Path, default=CATALOGO)
    args = parser.parse_args()
    try:
        informe = verificar(RAIZ, json.loads(args.catalogo.read_text(encoding='utf-8')))
    except (OSError, ValueError, KeyError, TypeError) as error:
        informe = {'correcto': False, 'errores': [str(error)]}
    print(json.dumps(informe, ensure_ascii=False, indent=2))
    return 0 if informe['correcto'] else 1


if __name__ == '__main__':
    raise SystemExit(main())
