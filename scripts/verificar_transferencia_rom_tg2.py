"""Registra tests, correspondencia del corpus y fuentes de la transferencia ROM."""
from argparse import ArgumentParser
from datetime import datetime, timezone
from pathlib import Path
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys

from verificar_certificados_tg2 import leer_certificado, verificar, Rechazo, HashMedido

RAIZ = Path(__file__).resolve().parents[1]
INFORME = RAIZ/'Documentos/04-Administrativo-TG2/Avances/Transferencia-ROM-2026-09-23'
CORPUS = RAIZ/'Documentos/06-Evidencia-TG2/2026-09-22/R4-FRI-vinculado'


def huella(ruta):
    return hashlib.sha256(ruta.read_bytes()).hexdigest()


def git(*args):
    resultado = subprocess.run(['git', *args], cwd=RAIZ, capture_output=True, check=True)
    return resultado.stdout.decode('utf-8').strip()


def guardar_nuevo(ruta, datos):
    with ruta.open('x', encoding='utf-8', newline='\n') as archivo:
        json.dump(datos, archivo, ensure_ascii=False, indent=2)
        archivo.write('\n')


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument('--salida', type=Path, default=Path('.tools/transferencia-rom/verificacion'))
    args = parser.parse_args()
    destino = args.salida.resolve()
    destino.relative_to(RAIZ)
    destino.mkdir(parents=True, exist_ok=True)
    comandos = [(nombre, [sys.executable, '-m', 'unittest', 'discover', '-s', 'scripts/tests', '-p', patron, '-v'])
                for nombre, patron in [('pruebas-rom', 'test_transferencia_rom_tg2.py'),
                                       ('pruebas-rbr', 'test_rbr_conjunto_tg2.py'),
                                       ('pruebas-manifiesto', 'test_verificar_version_tg2.py')]]
    comandos += [('manifiesto', [sys.executable, 'scripts/verificar_version_tg2.py']),
                 ('cargo-check', ['cargo', 'check', '--workspace', '--all-targets', '--locked', '--offline', '--manifest-path', 'nexus/Cargo.toml']),
                 ('cargo-test', ['cargo', 'test', '--workspace', '--locked', '--offline', '--manifest-path', 'nexus/Cargo.toml']),
                 ('cargo-build', ['cargo', 'build', '--workspace', '--locked', '--offline', '--manifest-path', 'nexus/Cargo.toml'])]
    nombres = [n+'.log' for n, _ in comandos]+['validacion.json', 'corpus.json', 'fuentes']
    if any((destino/n).exists() for n in nombres):
        raise FileExistsError('Hay resultados previos: indicar otra carpeta de salida')
    revisiones = {'documentos_base': git('rev-parse', 'HEAD'), 'codigo': git('-C', 'nexus', 'rev-parse', 'HEAD'),
                  'rama_documentos': git('branch', '--show-current'), 'rama_codigo': git('-C', 'nexus', 'branch', '--show-current')}
    if git('-C', 'nexus', 'status', '--porcelain'):
        raise RuntimeError('El código tiene cambios sin registrar')
    protegidos = [p for sub in ['Documentos/03-Administrativo-TG1',
                              'Documentos/04-Administrativo-TG2/Avances/Cierre-Matematico-2026-09-23']
                  for p in (RAIZ/sub).rglob('*') if p.is_file() and not p.name.startswith('~$')]
    anteriores = {p: huella(p) for p in protegidos}
    resultados_corpus = []
    for entrada in json.loads((CORPUS/'validacion.json').read_text(encoding='utf-8'))['corpus']:
        ruta = CORPUS/entrada['archivo']
        if huella(ruta) != entrada['sha256']:
            raise RuntimeError(f'Corpus alterado: {ruta}')
        prueba = leer_certificado(ruta)
        bits = 12 if 'corpus-debug' in str(ruta) else 20
        medidor = HashMedido()
        try:
            resultado = verificar(prueba, bits, medidor)
        except Rechazo as error:
            resultado = {'acepta': False, 'motivo': str(error), 'hashes_hasta_rechazo': medidor.total}
        esperado = ruta.name.startswith('honesto-')
        if resultado['acepta'] != esperado or (not esperado and resultado['motivo'] != 'fri_traza'):
            raise RuntimeError(f'Difiere de Rust: {ruta}: {resultado}')
        resultados_corpus.append({'archivo': ruta.relative_to(RAIZ).as_posix(), 'sha256': huella(ruta),
                                  'T': prueba['T'], 'bits': bits, **resultado})
    if len(resultados_corpus) != 14 or sum(x['acepta'] for x in resultados_corpus) != 8:
        raise RuntimeError('Conteo de corpus inesperado')
    guardar_nuevo(destino/'corpus.json', {'protocolo': 'NEXUS-TG2-LINKED-FRI-v1',
                   'alcance': 'Verificación independiente de SHA3, formato, Merkle, AIR y ambos FRI del corpus',
                   'aceptados': 8, 'rechazados_fri_traza': 6, 'certificados': resultados_corpus})
    entorno = os.environ.copy()
    entorno['CARGO_TARGET_DIR'] = 'C:/tmp/nexus-target'
    entorno['PYTHONUTF8'] = '1'
    resultados, textos = [], {}
    for nombre, comando in comandos:
        print(f'Ejecutando {nombre}...', flush=True)
        proceso = subprocess.run(comando, cwd=RAIZ, env=entorno, capture_output=True)
        texto = proceso.stdout.decode('utf-8', errors='replace')+proceso.stderr.decode('utf-8', errors='replace')
        with (destino/(nombre+'.log')).open('x', encoding='utf-8', newline='\n') as archivo:
            archivo.write(texto)
        resultados.append({'nombre': nombre, 'comando': comando, 'codigo_salida': proceso.returncode})
        textos[nombre] = texto
        if proceso.returncode:
            raise RuntimeError(f'Falló {nombre}; revisar el log completo en {destino}')
    cuentas = {n: int(re.search(r'Ran (\d+) tests', textos[n])[1])
               for n in ['pruebas-rom', 'pruebas-rbr', 'pruebas-manifiesto']}
    rust = sum(int(x) for x in re.findall(r'test result: ok\. (\d+) passed', textos['cargo-test']))
    if list(cuentas.values()) != [11, 7, 10] or rust != 197:
        raise RuntimeError(f'Conteos inesperados: {cuentas}, Rust={rust}')
    if git('-C', 'nexus', 'status', '--porcelain') or git('-C', 'nexus', 'rev-parse', 'HEAD') != revisiones['codigo']:
        raise RuntimeError('Cambió el código durante la comprobación')
    for ruta, digest in anteriores.items():
        if huella(ruta) != digest:
            raise RuntimeError(f'Archivo protegido alterado: {ruta}')
    fuentes = [RAIZ/'scripts'/nombre for nombre in ['analizar_transferencia_rom_tg2.py', 'verificar_certificados_tg2.py',
                'verificar_transferencia_rom_tg2.py', 'auditar_merkle_fs_r4.py', 'analizar_rbr_conjunto_tg2.py',
                'verificar_version_tg2.py', 'tests/test_transferencia_rom_tg2.py']]
    fuentes += sorted((RAIZ/'nexus/nexus-zk/src/stark').glob('*.rs'))
    fuentes += [RAIZ/'nexus/nexus-zk/experiments/tg2_linked_trace_fri.rs',
                RAIZ/'nexus/nexus-zk/tests/tg2_linked_trace_fri.rs', RAIZ/'nexus/nexus-core/src/types.rs']
    registros = []
    for ruta in fuentes:
        copia = destino/'fuentes'/ruta.relative_to(RAIZ)
        copia.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(ruta, copia)
        registros.append({'original': ruta.relative_to(RAIZ).as_posix(), 'copia': copia.relative_to(RAIZ).as_posix(),
                          'sha256': huella(copia), 'bytes': copia.stat().st_size})
    archivos = [INFORME/n for n in ['README.md', 'Transferencia-Protocolo-ROM.md', 'calculos.json', 'bibliografia/BCS16.pdf']]
    archivos += [destino/(n+'.log') for n, _ in comandos]+[destino/'corpus.json']
    registro = {'fecha_utc': datetime.now(timezone.utc).isoformat(), 'revisiones': revisiones,
                'estado': 'Derivación ROM clásica propuesta pendiente de revisión independiente; sin reducción QROM',
                'pruebas_python': sum(cuentas.values()), 'detalle_python': cuentas, 'pruebas_rust': rust,
                'corpus': {'total': 14, 'aceptados': 8, 'rechazados_fri_traza': 6},
                'proteccion': {'archivos_tg1_y_rbr_previos': len(anteriores), 'codigo_sin_cambios': True,
                              'manifiesto_897': 'verificado'},
                'CARGO_TARGET_DIR': entorno['CARGO_TARGET_DIR'], 'ejecuciones': resultados, 'fuentes': registros,
                'bibliografia_nueva': {'url': 'https://eprint.iacr.org/2016/116.pdf', 'version_portada': '2016-02-10',
                                      'consultada': '2026-09-23'},
                'archivos': [{'ruta': p.relative_to(RAIZ).as_posix(), 'sha256': huella(p), 'bytes': p.stat().st_size}
                             for p in archivos]}
    guardar_nuevo(destino/'validacion.json', registro)
    print(json.dumps({'python': sum(cuentas.values()), 'rust': rust, 'corpus': 14,
                      'registro': str(destino/'validacion.json')}, ensure_ascii=False), flush=True)


if __name__ == '__main__':
    main()
