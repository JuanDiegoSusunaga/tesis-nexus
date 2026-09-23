"""Preserva las fuentes y los resultados de R3 sin sustituir la evidencia de R2."""
from pathlib import Path
import datetime
import hashlib
import json
import re
import shutil
import subprocess

RAIZ = Path(__file__).resolve().parents[1]
DESTINO = RAIZ / 'Documentos/06-Evidencia-TG2/2026-09-22/R3-rotacion'


def main():
    DESTINO.mkdir(parents=True, exist_ok=True)
    comandos = [
        ('r3-cargo-check-all.log', 'cargo check --workspace --all-targets --locked --offline --manifest-path nexus/Cargo.toml'),
        ('r3-cargo-test.log', 'cargo test --workspace --locked --offline --manifest-path nexus/Cargo.toml'),
        ('r3-cargo-build.log', 'cargo build --workspace --locked --offline --manifest-path nexus/Cargo.toml'),
        ('r3-demo.log', 'cargo run -p nexus-crypto --example rotation_demo --locked --offline --manifest-path nexus/Cargo.toml -- .tools/r3-registry.bin'),
    ]
    registros = []
    total = 0
    for nombre, comando in comandos:
        datos = (RAIZ / '.tools' / nombre).read_bytes()
        texto = datos.decode('utf-16' if datos.startswith(b'\xff\xfe') else 'utf-8-sig')
        if 'error:' in texto or 'test result: FAILED' in texto:
            raise ValueError(f'El registro contiene errores: {nombre}')
        if nombre == 'r3-cargo-test.log':
            resultados = re.findall(r'test result: ok\. (\d+) passed; (\d+) failed;', texto)
            if not resultados or any(int(fallos) for _, fallos in resultados):
                raise ValueError('La suite no finalizó correctamente.')
            total = sum(int(pasan) for pasan, _ in resultados)
        elif nombre == 'r3-demo.log':
            if 'firma_anterior_vigente=false; firma_anterior_historica=true; firma_nueva_vigente=true' not in texto:
                raise ValueError('No se encontró la comprobación completa de épocas.')
            demostracion = texto[texto.index('identidades=2;'):].strip()
        elif 'Finished `dev` profile' not in texto:
            raise ValueError(f'Compilación sin final satisfactorio: {nombre}')
        (DESTINO / nombre).write_text(texto, encoding='utf-8')
        registros.append({'comando': comando, 'resultado': 'correcto', 'registro': nombre,
                         'sha256': hashlib.sha256(texto.encode('utf-8')).hexdigest()})
    archivos = []
    for nombre in [
        'Cargo.toml', 'Cargo.lock', 'nexus-crypto/Cargo.toml',
        'nexus-crypto/src/entropy.rs', 'nexus-crypto/src/keypair.rs',
        'nexus-crypto/src/registry.rs', 'nexus-crypto/src/lib.rs',
        'nexus-crypto/src/dilithium.rs', 'nexus-crypto/examples/rotation_demo.rs',
    ]:
        origen = RAIZ / 'nexus' / nombre
        destino = DESTINO / 'fuentes' / nombre
        destino.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(origen, destino)
        archivos.append({'archivo': nombre, 'sha256': hashlib.sha256(origen.read_bytes()).hexdigest()})
    archivo_publico = RAIZ / '.tools/r3-registry.bin'
    shutil.copy2(archivo_publico, DESTINO / 'registro-publico-demo.bin')
    def salida(args):
        return subprocess.check_output(args, cwd=RAIZ, text=True, encoding='utf-8').strip()
    reporte = {
        'fecha': '2026-09-22',
        'registro_local': datetime.datetime.now().astimezone().isoformat(),
        'alcance': 'Gestor de claves y registro público R3; atomicidad en memoria y recuperación del historial público.',
        'limites': ['Sin anclaje externo L1 ni integración con el sequencer heredado.',
                    'No persiste semillas ni claves privadas; no recupera un firmador tras caída.',
                    'El checkpoint debe custodiarse independientemente y actualizarse.',
                    'Las muestras sintéticas no califican una fuente física; no demuestra borrado de todas las copias en RAM.'],
        'cargo_target_dir': str(Path('C:/tmp/nexus-target')),
        'toolchain': salida(['rustc', '-Vv']),
        'cargo': salida(['cargo', '--version']),
        'git_head': salida(['git', '-C', 'nexus', 'rev-parse', 'HEAD']),
        'git_estado': salida(['git', '-C', 'nexus', 'status', '--short']),
        'comandos': registros,
        'pruebas_totales': total,
        'pruebas_nuevas_r3': 19,
        'benchmarks_repetidos': False,
        'demostracion': demostracion,
        'archivo_publico': {'archivo': 'registro-publico-demo.bin', 'bytes': archivo_publico.stat().st_size,
                           'sha256': hashlib.sha256(archivo_publico.read_bytes()).hexdigest()},
        'fuentes': archivos,
    }
    (DESTINO / 'ejecucion.json').write_text(json.dumps(reporte, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    print(f'Evidencia R3: {total} pruebas, 19 nuevas; {len(archivos)} fuentes; 4 registros y archivo público.')


if __name__ == '__main__':
    main()
