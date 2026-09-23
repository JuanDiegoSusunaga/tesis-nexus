"""Ejecuta las mediciones R4 en serie y conserva procedencia y salidas originales."""
from pathlib import Path
import datetime
import hashlib
import json
import os
import platform
import subprocess
import time

RAIZ = Path(__file__).resolve().parents[1]
DESTINO = RAIZ / 'Documentos/06-Evidencia-TG2/2026-09-22/R4-validacion'


def salida(comando):
    return subprocess.check_output(comando, cwd=RAIZ, text=True, encoding='utf-8').strip()


def main():
    DESTINO.mkdir(parents=True, exist_ok=True)
    if (DESTINO / 'mediciones.json').exists():
        raise RuntimeError('Ya existe una corrida completa; crear otra carpeta para nuevas mediciones.')
    entorno = os.environ.copy()
    entorno['CARGO_TARGET_DIR'] = 'C:/tmp/nexus-target'
    entorno['CRITERION_HOME'] = str(DESTINO / 'criterion')
    fuentes = []
    candidatos = salida(['rg', '--files', '--hidden', '--no-ignore', '-g', '!**/target/**',
                          '-g', '!**/.git/**', '-g', '*.rs', '-g', 'Cargo.toml', '-g', 'Cargo.lock', 'nexus']).splitlines()
    for ruta in sorted(RAIZ / nombre for nombre in candidatos):
        if ruta.is_file() and (ruta.suffix == '.rs' or ruta.name in ('Cargo.toml', 'Cargo.lock')):
            relativo = ruta.relative_to(RAIZ / 'nexus')
            if 'target' in relativo.parts or '.git' in relativo.parts:
                continue
            copia = DESTINO / 'fuentes' / relativo
            copia.parent.mkdir(parents=True, exist_ok=True)
            datos = ruta.read_bytes()
            copia.write_bytes(datos)
            fuentes.append({'archivo': str(relativo).replace('\\', '/'),
                            'sha256': hashlib.sha256(datos).hexdigest()})
    registro = {
        'fecha': '2026-09-22', 'inicio': datetime.datetime.now().astimezone().isoformat(),
        'sistema': platform.platform(), 'maquina': platform.machine(), 'cpu_logicos': os.cpu_count(),
        'rustc': salida(['rustc', '-Vv']), 'cargo': salida(['cargo', '--version']),
        'git_head': salida(['git', '-C', 'nexus', 'rev-parse', 'HEAD']),
        'git_estado': salida(['git', '-C', 'nexus', 'status', '--short']),
        'entorno': {'CARGO_TARGET_DIR': entorno['CARGO_TARGET_DIR'], 'CRITERION_HOME': entorno['CRITERION_HOME']},
        'alcance': 'Componentes aislados en el equipo actual; no reproduce retrospectivamente H1/H2 ni mide una blockchain completa.',
        'ejecucion': 'Comandos secuenciales; sin afinidad ni control exclusivo del sistema operativo.',
        'fuentes': fuentes, 'comandos': [],
    }
    manifiesto = ['--locked', '--offline', '--manifest-path', 'nexus/Cargo.toml']
    comandos = []
    for bench in ['dilithium_bench', 'classical_baseline', 'residencia_bench']:
        comandos.append((bench, ['cargo', 'bench', '-p', 'nexus-crypto', '--bench', bench, *manifiesto,
                                '--', '--noplot', '--sample-size', '50', '--warm-up-time', '1',
                                '--measurement-time', '2', '--save-baseline', 'r4']))
    comandos.append(('throughput', ['cargo', 'run', '-p', 'nexus-crypto', '--example', 'tg2_throughput',
                                   '--release', *manifiesto, '--', str(DESTINO)]))
    comandos.append(('stark', ['cargo', 'run', '-p', 'nexus-zk', '--example', 'tg2_stark_measure',
                             '--release', *manifiesto, '--', str(DESTINO / 'stark.csv')]))
    parcial = DESTINO / 'mediciones-en-curso.json'
    if parcial.exists():
        previo = json.loads(parcial.read_text(encoding='utf-8'))
        if previo['fuentes'] != fuentes:
            raise RuntimeError('Las fuentes cambiaron desde la ejecución parcial.')
        registro = previo
    ejecutados = {entrada['nombre'] for entrada in registro['comandos']}
    for nombre, comando in comandos:
        if nombre in ejecutados:
            print(f'Conservando intento previo de {nombre}; no se vuelve a ejecutar.', flush=True)
            continue
        print(f'Iniciando {nombre}', flush=True)
        inicio = time.monotonic()
        with (DESTINO / f'{nombre}.log').open('w', encoding='utf-8') as archivo:
            resultado = subprocess.run(comando, cwd=RAIZ, env=entorno,
                                       stdout=archivo, stderr=subprocess.STDOUT, text=True)
        registro['comandos'].append({'nombre': nombre, 'argumentos': comando,
                                     'exit_code': resultado.returncode,
                                     'duracion_s': time.monotonic()-inicio, 'registro': f'{nombre}.log'})
        (DESTINO / 'mediciones-en-curso.json').write_text(json.dumps(registro, ensure_ascii=False, indent=2), encoding='utf-8')
        if resultado.returncode:
            texto = (DESTINO / f'{nombre}.log').read_text(encoding='utf-8')
            if 'os error 4551' in texto:
                print(f'Windows bloqueó {nombre}; se conserva el fallo y continúan experimentos distintos.', flush=True)
                continue
            raise RuntimeError(f'Falló {nombre}; revisar el registro completo antes de continuar.')
        print(f'Terminado {nombre}: {registro["comandos"][-1]["duracion_s"]:.1f} s', flush=True)
    registro['fin'] = datetime.datetime.now().astimezone().isoformat()
    registro['estado'] = 'parcial: ejecuciones bloqueadas por Windows' if any(
        entrada['exit_code'] for entrada in registro['comandos']) else 'completo'
    for entrada in fuentes:
        ruta = RAIZ / 'nexus' / entrada['archivo']
        if hashlib.sha256(ruta.read_bytes()).hexdigest() != entrada['sha256']:
            raise RuntimeError(f'La fuente cambió durante la medición: {ruta}')
    (DESTINO / 'mediciones.json').write_text(json.dumps(registro, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    print(f'Mediciones R4: {registro["estado"]}; salidas y fuentes preservadas.', flush=True)


if __name__ == '__main__':
    main()
