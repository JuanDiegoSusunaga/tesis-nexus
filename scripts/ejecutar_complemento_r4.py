"""Repite los dos experimentos pendientes después del cambio de Windows por el autor."""
from pathlib import Path
import datetime
import hashlib
import json
import os
import platform
import subprocess
import time
import winreg

RAIZ = Path(__file__).resolve().parents[1]
DESTINO = RAIZ / 'Documentos/06-Evidencia-TG2/2026-09-22/R4-complemento'


def salida(comando):
    return subprocess.check_output(comando, cwd=RAIZ, text=True, encoding='utf-8').strip()


def main():
    if DESTINO.exists():
        raise RuntimeError('El complemento ya existe; no se sobrescribe la evidencia.')
    with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r'SYSTEM\CurrentControlSet\Control\CI\Policy') as clave:
        estado = winreg.QueryValueEx(clave, 'VerifiedAndReputablePolicyState')[0]
    if estado != 0:
        raise RuntimeError('No se confirma el cambio de configuración comunicado por el autor.')
    DESTINO.mkdir(parents=True)
    entorno = os.environ.copy()
    entorno.update(CARGO_TARGET_DIR='C:/tmp/nexus-target', CRITERION_HOME=str(DESTINO/'criterion'))
    fuentes = []
    for nombre in salida(['rg', '--files', '--hidden', '--no-ignore', '-g', '!**/target/**',
                          '-g', '!**/.git/**', '-g', '*.rs', '-g', 'Cargo.toml', '-g', 'Cargo.lock', 'nexus']).splitlines():
        ruta = RAIZ / nombre
        relativo = ruta.relative_to(RAIZ)
        datos = ruta.read_bytes()
        copia = DESTINO/'fuentes'/relativo
        copia.parent.mkdir(parents=True, exist_ok=True)
        copia.write_bytes(datos)
        fuentes.append({'archivo': relativo.as_posix(), 'sha256': hashlib.sha256(datos).hexdigest()})
    registro = {'fecha': '2026-09-22', 'inicio': datetime.datetime.now().astimezone().isoformat(),
                'sistema': platform.platform(), 'cpu_logicos': os.cpu_count(),
                'rustc': salida(['rustc', '-Vv']), 'cargo': salida(['cargo', '--version']),
                'git_head': salida(['git', '-C', 'nexus', 'rev-parse', 'HEAD']),
                'git_estado': salida(['git', '-C', 'nexus', 'status', '--short']),
                'smart_app_control': estado,
                'cambio': 'El autor comunicó que desactivó Smart App Control. El agente solo consultó el estado.',
                'alcance': 'Complemento separado; los fallos de R4-validacion permanecen intactos.',
                'fuentes': fuentes, 'comandos': []}
    manifiesto = ['--locked', '--offline', '--manifest-path', 'nexus/Cargo.toml']
    comandos = [
        ('dilithium_bench', ['cargo', 'bench', '-p', 'nexus-crypto', '--bench', 'dilithium_bench', *manifiesto,
                            '--', '--noplot', '--sample-size', '50', '--warm-up-time', '1', '--measurement-time', '2',
                            '--save-baseline', 'r4-complemento']),
        ('throughput', ['cargo', 'run', '-p', 'nexus-crypto', '--example', 'tg2_throughput', '--release',
                        *manifiesto, '--', str(DESTINO)])]
    for nombre, comando in comandos:
        print(f'Iniciando {nombre}', flush=True)
        inicio = time.monotonic()
        with (DESTINO/f'{nombre}.log').open('w', encoding='utf-8') as archivo:
            resultado = subprocess.run(comando, cwd=RAIZ, env=entorno, stdout=archivo, stderr=subprocess.STDOUT)
        registro['comandos'].append({'nombre': nombre, 'argumentos': comando, 'exit_code': resultado.returncode,
                                     'duracion_s': time.monotonic()-inicio})
        (DESTINO/'ejecucion.json').write_text(json.dumps(registro, ensure_ascii=False, indent=2), encoding='utf-8')
        if resultado.returncode:
            raise RuntimeError(f'Falló {nombre}; revisar el registro antes de continuar.')
        print(f'Terminado {nombre}', flush=True)
    for entrada in fuentes:
        assert hashlib.sha256((RAIZ/entrada['archivo']).read_bytes()).hexdigest() == entrada['sha256']
    registro['fin'] = datetime.datetime.now().astimezone().isoformat()
    registro['estado'] = 'completo'
    (DESTINO/'ejecucion.json').write_text(json.dumps(registro, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    print('Complemento R4 completo; fuentes y resultados conservados.', flush=True)


if __name__ == '__main__':
    main()
