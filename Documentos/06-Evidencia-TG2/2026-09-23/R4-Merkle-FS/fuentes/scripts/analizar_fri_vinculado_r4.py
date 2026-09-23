"""Conserva ensayos de FRI vinculada y reproduce el tamaño del formato binario."""
from pathlib import Path
from fractions import Fraction
import hashlib
import json
import math
import re
import shutil
import subprocess

RAIZ = Path(__file__).resolve().parents[1]
DESTINO = RAIZ / 'Documentos/06-Evidencia-TG2/2026-09-22/R4-FRI-vinculado'


def huella(ruta):
    return hashlib.sha256(ruta.read_bytes()).hexdigest()


def tamano(t):
    lt = t.bit_length()-1
    lc = lt+1
    d = (8*t).bit_length()-1
    suma = (lt+lc)*d-(lt*(lt-1)+lc*(lc-1))//2
    consulta = 120+192*d+48*(lt+lc)+64*suma
    # Tupla (enunciado, prueba), enteros fijos y longitudes u64 de bincode.
    return 126+32*(lt+lc)+40*consulta


def main():
    ejecuciones = []
    filas = {}
    for nombre, comando, esperado in [
        ('cargo-check.log', 'cargo check --workspace --all-targets --locked --offline --manifest-path nexus/Cargo.toml', None),
        ('cargo-test.log', 'cargo test --workspace --locked --offline --manifest-path nexus/Cargo.toml -- --nocapture', 197),
        ('cargo-build.log', 'cargo build --workspace --locked --offline --manifest-path nexus/Cargo.toml', None),
        ('cargo-test-release.log', 'cargo test -p nexus-zk --test tg2_linked_trace_fri --release --locked --offline --manifest-path nexus/Cargo.toml -- --nocapture', 10),
    ]:
        datos = (DESTINO / nombre).read_bytes()
        texto = datos.decode('utf-16' if datos.startswith(b'\xff\xfe') else 'utf-8')
        assert 'Finished ' in texto and not re.search(r'^error(?:\[|:)', texto, re.M)
        if esperado is not None:
            cuentas = re.findall(r'test result: ok\. (\d+) passed; (\d+) failed;', texto)
            assert sum(int(p) for p, _ in cuentas) == esperado
            assert all(int(f) == 0 for _, f in cuentas)
            registros = re.findall(
                r'TG2_FRI_VINCULADO T=(\d+) N=(\d+) bytes=(\d+) capas_traza=(\d+) capas_cp=(\d+) consultas=40 honesto=true', texto)
            assert len(registros) == 4
            for valores in registros:
                t, n, size, lt, lc = map(int, valores)
                assert n == 8*t and lt == t.bit_length()-1 and lc == lt+1
                assert size == tamano(t)
                fila = {'T': t, 'N': n, 'capas_traza': lt, 'capas_cp': lc,
                        'consultas': 40, 'bytes_tupla': size, 'bytes_solo_lde': 8*n}
                if t in filas:
                    assert filas[t] == fila
                filas[t] = fila
            for t in [16, 32, 64]:
                assert f'TG2_FRI_RECHAZO T={t} legado=true variante=TraceFri' in texto
        ejecuciones.append({'comando': comando, 'log': nombre, 'codigo_salida': 0,
                            'pruebas': esperado, 'sha256': huella(DESTINO / nombre)})
    assert sorted(filas) == [16, 64, 256, 4096]
    corpus = []
    for perfil in ['debug', 'release']:
        for tipo, tamanos in [('honesto', sorted(filas)), ('lejano', [16, 32, 64])]:
            for t in tamanos:
                archivo = DESTINO / f'corpus-{perfil}/{tipo}-{t}.bin'
                assert archivo.stat().st_size == tamano(t)
                corpus.append({'archivo': archivo.relative_to(DESTINO).as_posix(),
                               'bytes': archivo.stat().st_size, 'sha256': huella(archivo)})
    anterior = RAIZ / 'Documentos/06-Evidencia-TG2/2026-09-22/R4-proximidad'
    reutilizados = []
    for item in json.loads((anterior / 'validacion.json').read_text(encoding='utf-8'))['corpus']:
        archivo = anterior / item['archivo']
        assert huella(archivo) == item['sha256']
        reutilizados.append({'archivo': archivo.relative_to(RAIZ).as_posix(), 'sha256': huella(archivo)})
    validacion = {
        'fecha': '2026-09-22', 'pruebas_workspace': 197, 'pruebas_nuevas_release': 10,
        'nuevas_r4_fri_vinculado': 10, 'cargo_target_dir': 'C:/tmp/nexus-target',
        'variable_corpus': 'NEXUS_TG2_LINKED_EVIDENCE_DIR',
        'rustc': subprocess.check_output(['rustc', '-Vv'], text=True).strip(),
        'cargo': subprocess.check_output(['cargo', '-V'], text=True).strip(),
        'ejecuciones': ejecuciones, 'corpus': corpus, 'corpus_anterior_reutilizado': reutilizados,
        'limite': 'Casos concretos y tamaños de serialización; sin nuevos benchmarks ni cota global de solidez.',
    }
    (DESTINO / 'validacion.json').write_text(json.dumps(validacion, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    fuentes = list((RAIZ / 'nexus/nexus-zk/src/stark').glob('*.rs')) + [
        RAIZ / 'nexus/nexus-zk/experiments/tg2_linked_trace_fri.rs',
        RAIZ / 'nexus/nexus-zk/tests/tg2_linked_trace_fri.rs',
        RAIZ / 'nexus/Cargo.toml', RAIZ / 'nexus/Cargo.lock',
        RAIZ / 'nexus/nexus-zk/Cargo.toml', Path(__file__).resolve(),
    ]
    registros = []
    for fuente in fuentes:
        relativo = fuente.relative_to(RAIZ)
        copia = DESTINO / 'fuentes' / relativo
        copia.parent.mkdir(parents=True, exist_ok=True)
        if copia.exists():
            assert copia.read_bytes() == fuente.read_bytes(), str(relativo)
        else:
            shutil.copy2(fuente, copia)
        registros.append({'archivo': relativo.as_posix(), 'sha256': huella(fuente)})
    # Escenario combinatorio condicional: oráculos fijos y consultas uniformes ideales.
    m, malas, q = 256, 64, 40
    omision = Fraction(math.comb(m-malas, q), math.comb(m, q))
    assert omision <= Fraction(3, 4)**q
    analisis = {
        'fecha': '2026-09-22', 'dominio': 'NEXUS-TG2-LINKED-FRI-v1', 'version': 1,
        'filas_minimas': 16, 'filas_maximas': 4096,
        'codificacion_traza': 'Fp2(u,0), 16 bytes; misma raíz que capa 0 de FRI de traza',
        'orden': ['perfil', 'enunciado', 'raiz_traza', 'tres_alphas', 'fase_trace_FRI',
                  'fase_composition_FRI', 'nonce', '40_indices_comunes'],
        'tamanos': [filas[t] for t in sorted(filas)],
        'conteo_serializacion': '126+32*(Lt+Lc)+40*(120+192*D+48*(Lt+Lc)+64*((Lt+Lc)*D-(Lt*(Lt-1)+Lc*(Lc-1))/2))',
        'escenario_omision_ideal': {'parejas': m, 'parejas_malas': malas, 'consultas': q,
                                   'probabilidad_exacta': str(omision),
                                   'cota_superior': str(Fraction(3, 4)**q),
                                   'limite': 'No incluye errores FRI, selección adaptativa, Merkle ni Fiat–Shamir; no es una cota del protocolo.'},
        'fuentes': registros,
    }
    (DESTINO / 'analisis.json').write_text(json.dumps(analisis, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    lineas = [
        '**Tabla 6.18 — Formato de la variante con FRI de traza vinculada.**', '',
        '| Filas T | Capas traza / CP | Consultas | Enunciado y prueba (B) | Solo LDE completo (B) |',
        '|---:|:---:|---:|---:|---:|',
    ]
    for t in sorted(filas):
        c = filas[t]
        lineas.append(f'| {t} | {c["capas_traza"]} / {c["capas_cp"]} | 40 | {c["bytes_tupla"]} | {c["bytes_solo_lde"]} |')
    (DESTINO / 'tabla-formato.md').write_text('\n'.join(lineas)+'\n', encoding='utf-8')
    print(json.dumps({'pruebas': 197, 'release': 10, 'corpus': len(corpus), 'tamanos': analisis['tamanos']}, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
