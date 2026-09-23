"""Preserva las salidas de la verificación R2 y las fuentes exactas revisadas."""
from pathlib import Path
import datetime
import hashlib
import json
import re
import shutil
import subprocess

RAIZ = Path(__file__).resolve().parents[1]
DESTINO = RAIZ / 'Documentos/06-Evidencia-TG2/2026-09-22/R2-monitor'


def main():
    DESTINO.mkdir(parents=True, exist_ok=True)
    comandos = [
        ('r2-cargo-check-all.log', 'cargo check --workspace --all-targets --locked --offline --manifest-path nexus/Cargo.toml'),
        ('r2-cargo-test.log', 'cargo test --workspace --locked --offline --manifest-path nexus/Cargo.toml'),
        ('r2-cargo-build.log', 'cargo build --workspace --locked --offline --manifest-path nexus/Cargo.toml'),
    ]
    registros = []
    total = 0
    for nombre, comando in comandos:
        origen = RAIZ / '.tools' / nombre
        # PowerShell 5 puede escribir redirecciones como UTF-16.
        datos = origen.read_bytes()
        texto = datos.decode('utf-16' if datos.startswith(b'\xff\xfe') else 'utf-8-sig')
        if 'error:' in texto or 'test result: FAILED' in texto:
            raise ValueError(f'El registro contiene errores: {nombre}')
        if nombre == 'r2-cargo-test.log':
            resultados = re.findall(r'test result: ok\. (\d+) passed; (\d+) failed;', texto)
            if not resultados or any(int(fallos) for _, fallos in resultados):
                raise ValueError('No se encontró una ejecución satisfactoria de la suite.')
            total = sum(int(pasan) for pasan, _ in resultados)
        elif 'Finished `dev` profile' not in texto:
            raise ValueError(f'Compilación sin final satisfactorio: {nombre}')
        (DESTINO / nombre).write_text(texto, encoding='utf-8')
        registros.append({'comando': comando, 'resultado': 'correcto', 'registro': nombre})
    archivos = []
    for nombre in [
        'Cargo.toml', 'Cargo.lock', 'nexus-crypto/Cargo.toml',
        'nexus-crypto/src/entropy.rs', 'nexus-crypto/src/keypair.rs',
        'nexus-sentinel/src/lib.rs', 'nexus-crypto/examples/apt_sweep.rs',
    ]:
        origen = RAIZ / 'nexus' / nombre
        destino = DESTINO / 'fuentes' / nombre
        destino.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(origen, destino)
        archivos.append({'archivo': nombre, 'sha256': hashlib.sha256(origen.read_bytes()).hexdigest()})
    def salida(args):
        return subprocess.check_output(args, cwd=RAIZ, text=True, encoding='utf-8').strip()
    reporte = {
        'fecha': '2026-09-22',
        'registro_local': datetime.datetime.now().astimezone().isoformat(),
        'alcance': 'Monitor del prototipo R2; flujos sintéticos. No califica una fuente física ni valida R3.',
        'cargo_target_dir': str(Path('C:/tmp/nexus-target')),
        'toolchain': salida(['rustc', '-Vv']),
        'cargo': salida(['cargo', '--version']),
        'git_head': salida(['git', '-C', 'nexus', 'rev-parse', 'HEAD']),
        'git_estado': salida(['git', '-C', 'nexus', 'status', '--short']),
        'archivos_preexistentes_con_cambios': [
            'nexus-crypto/Cargo.toml', 'nexus-zk/examples/stark_demo.rs',
            'nexus-crypto/benches/residencia_bench.rs', 'nexus-crypto/examples/',
        ],
        'comandos': registros,
        'pruebas_totales': total,
        'pruebas_nuevas_r2': 13,
        'benchmarks_repetidos': False,
        'parametros': {'H_bits_byte': 7.5, 'alpha': 2**-20, 'W': 512,
                       'APT_C': 16, 'RCT_C': 4, 'lote': 65536,
                       'modelo_APT': 'B = 1 + Binomial(511, 2^-7.5)',
                       'cola_C15': 1.5226900325474521e-6,
                       'cola_C16': 2.7640953150605826e-7},
        'fuentes': archivos,
    }
    (DESTINO / 'ejecucion.json').write_text(json.dumps(reporte, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    print(f'Evidencia R2 preservada: {total} pruebas, {len(archivos)} archivos fuente y 3 registros.')


if __name__ == '__main__':
    main()
