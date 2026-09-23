"""Preserva evidencia local de TG2 sin ejecutar ni atribuir nuevas mediciones."""

import hashlib
import json
from pathlib import Path
import shutil
import subprocess

RAIZ = Path(__file__).resolve().parents[1]
SALIDA = RAIZ / 'Documentos/06-Evidencia-TG2/2026-09-22'
CACHE = Path('C:/tmp/nexus-target/criterion')


def sha256(ruta):
    return hashlib.sha256(ruta.read_bytes()).hexdigest()


def git(ruta, *argumentos):
    return subprocess.check_output(['git', '-C', str(ruta), *argumentos], text=True).strip()


def main():
    SALIDA.mkdir(parents=True, exist_ok=True)
    registros = []
    medianas = {}
    for origen in sorted(CACHE.glob('**/new/*.json')):
        relativo = origen.relative_to(CACHE)
        destino = SALIDA / 'criterion' / relativo
        destino.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(origen, destino)
        registros.append({'origen': str(origen), 'archivo': str(destino.relative_to(SALIDA)),
                          'sha256': sha256(destino), 'mtime_origen': origen.stat().st_mtime})
        if origen.name == 'estimates.json':
            datos = json.loads(origen.read_text(encoding='utf-8'))
            medianas[str(relativo.parent.parent).replace('\\', '/')] = datos['median']
    archivos = ['Cargo.toml', 'Cargo.lock', 'nexus-crypto/Cargo.toml',
                'nexus-crypto/benches/dilithium_bench.rs',
                'nexus-crypto/benches/classical_baseline.rs',
                'nexus-crypto/benches/residencia_bench.rs',
                'nexus-crypto/examples/apt_sweep.rs',
                'nexus-crypto/examples/throughput_tps.rs',
                'nexus-zk/examples/stark_demo.rs']
    for nombre in archivos:
        origen = RAIZ / 'nexus' / nombre
        destino = SALIDA / 'codigo-observado' / nombre
        destino.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(origen, destino)
        registros.append({'origen': str(origen), 'archivo': str(destino.relative_to(SALIDA)),
                          'sha256': sha256(destino), 'mtime_origen': origen.stat().st_mtime})
    manifiesto = {
        'fecha_inventario': '2026-09-22',
        'naturaleza': 'Copia de evidencia preexistente; no es una nueva ejecución.',
        'limite': 'El HEAD observado no identifica por sí solo la revisión de las corridas históricas. Hay cambios locales.',
        'documentos_head': git(RAIZ, 'rev-parse', 'HEAD'),
        'codigo_head': git(RAIZ / 'nexus', 'rev-parse', 'HEAD'),
        'codigo_estado': git(RAIZ / 'nexus', 'status', '--short'),
        'archivos': registros,
        'medianas_criterion_ns': medianas,
    }
    (SALIDA / 'inventario.json').write_text(json.dumps(manifiesto, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(f'Evidencia preservada: {len(registros)} archivos; {len(medianas)} medianas Criterion.')
    for nombre, valor in medianas.items():
        if 'dilithium3' in nombre:
            print(f'{nombre}: {valor["point_estimate"] / 1000:.3f} microsegundos')


if __name__ == '__main__':
    main()
