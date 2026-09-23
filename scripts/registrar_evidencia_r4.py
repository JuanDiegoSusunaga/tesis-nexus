"""Identifica las fuentes finales de validación sin sobrescribir las de medición."""
from pathlib import Path
import hashlib
import json
import re
import subprocess

raiz = Path(__file__).resolve().parents[1]
destino = raiz / 'Documentos/06-Evidencia-TG2/2026-09-22/R4-validacion'


def leer_salida(ruta):
    datos = ruta.read_bytes()
    return datos.decode('utf-16' if datos.startswith(b'\xff\xfe') else 'utf-8-sig')


def main():
    pruebas = leer_salida(destino / 'cargo-test.log')
    resultados = re.findall(r'test result: ok\. (\d+) passed; (\d+) failed', pruebas)
    assert sum(int(x) for x, _ in resultados) == 160
    assert all(int(y) == 0 for _, y in resultados)
    assert 'public_openings_recover_the_witness_for_the_16_row_example ... ok' in pruebas
    for nombre in ['cargo-check.log', 'cargo-build.log']:
        assert 'Finished `dev` profile' in leer_salida(destino / nombre)
    fuentes = []
    for carpeta in ['nexus/nexus-active/experiments', 'nexus/nexus-active/tests',
                    'nexus/nexus-crypto/experiments', 'nexus/nexus-crypto/tests']:
        for ruta in sorted((raiz / carpeta).glob('*.rs')):
            relativo = ruta.relative_to(raiz)
            copia = destino / 'fuentes-validacion' / relativo
            copia.parent.mkdir(parents=True, exist_ok=True)
            copia.write_bytes(ruta.read_bytes())
            fuentes.append({'archivo': str(relativo).replace('\\', '/'),
                            'sha256': hashlib.sha256(ruta.read_bytes()).hexdigest()})
    sin_cambios = ['nexus-active/src/verifier.rs', 'nexus-active/src/pq_verifier.rs', 'nexus-zk/src/stark']
    subprocess.run(['git', '-C', 'nexus', 'diff', '--exit-code', 'HEAD', '--', *sin_cambios], cwd=raiz, check=True)
    registro = {'fecha': '2026-09-22', 'etapa': 'R4', 'pruebas': 160,
                 'nuevas': 18, 'verificador': 15, 'sincronizacion': 3,
                 'perfil_pruebas': 'desarrollo; POW_BITS_RUNTIME=12',
                 'perfil_mediciones_stark': 'release; POW_BITS_RUNTIME=20',
                 'comandos': ['cargo check --workspace --all-targets --locked --offline --manifest-path nexus/Cargo.toml',
                              'cargo test --workspace --locked --offline --manifest-path nexus/Cargo.toml',
                              'cargo build --workspace --locked --offline --manifest-path nexus/Cargo.toml'],
                 'CARGO_TARGET_DIR': 'C:/tmp/nexus-target',
                 'fuentes': fuentes, 'componentes_heredados_sin_cambios_respecto_HEAD': sin_cambios,
                 'nota': 'La prueba de reconstrucción del testigo se añadió después de las mediciones. Sus fuentes finales se preservan aquí; fuentes/ y mediciones.json identifican la instantánea anterior de los benchmarks.'}
    for nombre in ['cargo-check.log', 'cargo-test.log', 'cargo-build.log']:
        registro[nombre] = hashlib.sha256((destino / nombre).read_bytes()).hexdigest()
    (destino / 'validacion.json').write_text(json.dumps(registro, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    print('R4: check/build correctos; 160 pruebas, 18 nuevas. Fuentes y hashes registrados.')


if __name__ == '__main__':
    main()
