"""Contrasta la familia de trazas lejanas y conserva evidencia reproducible."""
from pathlib import Path
import hashlib
import json
import re
import shutil
import subprocess

RAIZ = Path(__file__).resolve().parents[1]
DESTINO = RAIZ / 'Documentos/06-Evidencia-TG2/2026-09-22/R4-proximidad'
P = 2**64 - 2**32 + 1


def huella(ruta):
    return hashlib.sha256(ruta.read_bytes()).hexdigest()


def evaluar(coeficientes, x):
    valor = 0
    for c in reversed(coeficientes):
        valor = (valor*x+c) % P
    return valor


def multiplicar(a, b):
    producto = [0]*(len(a)+len(b)-1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            producto[i+j] = (producto[i+j]+x*y) % P
    return producto


def dividir(a, b):
    resto = a.copy()
    cociente = [0]*max(1, len(a)-len(b)+1)
    while resto and resto[-1] == 0:
        resto.pop()
    while len(resto) >= len(b):
        i = len(resto)-len(b)
        c = resto[-1]*pow(b[-1], -1, P) % P
        cociente[i] = c
        for j, d in enumerate(b):
            resto[i+j] = (resto[i+j]-c*d) % P
        while resto and resto[-1] == 0:
            resto.pop()
    return cociente, resto


def contraste(t):
    n = 8*t
    g = pow(7, (P-1)//t, P)
    omega = pow(7, (P-1)//n, P)
    traza = [3, 5]
    for _ in range(t-2):
        traza.append((traza[-1]**2+traza[-2]**2) % P)
    # Interpolación directa, independiente de la NTT del proyecto.
    f = [sum(traza[j]*pow(g, (-j*k) % t, P) for j in range(t))*pow(t, -1, P) % P
         for k in range(t)]
    aumentado = f+[1]
    aumentado[0] = (aumentado[0]-1) % P
    assert [evaluar(aumentado, pow(g, j, P)) for j in range(t)] == traza
    puntos = [7*pow(omega, j, P) % P for j in range(n)]
    assert all(pow(x, t, P) != 1 for x in puntos)
    assert all(evaluar(aumentado, x) != evaluar(f, x) for x in puntos)
    producto = [1]
    for x in puntos[:t]:
        producto = multiplicar(producto, [-x % P, 1])
    cercano = [(a-b) % P for a, b in zip(aumentado, producto)]
    assert cercano[-1] == 0
    acuerdos = sum(evaluar(aumentado, x) == evaluar(cercano, x) for x in puntos)
    assert acuerdos == t
    # División exacta de la transición de F por el anulador correspondiente.
    f_g = [c*pow(g, j, P) % P for j, c in enumerate(aumentado)]
    f_g2 = [c*pow(g, 2*j, P) % P for j, c in enumerate(aumentado)]
    cuadrados = [multiplicar(aumentado, aumentado), multiplicar(f_g, f_g)]
    c = [((f_g2[i] if i < len(f_g2) else 0)-cuadrados[0][i]-cuadrados[1][i]) % P
         for i in range(2*t+1)]
    d = [P-1]+[0]*(t-1)+[1]
    excepciones = multiplicar([-pow(g, t-1, P) % P, 1], [-pow(g, t-2, P) % P, 1])
    z, resto = dividir(d, excepciones)
    assert not resto
    q, resto = dividir(c, z)
    assert not resto and len(q)-1 == t+2 and q[-1] != 0 and t+2 < 2*t
    return {'T': t, 'N': n, 'grado_traza': t, 'grado_cociente_transicion': t+2,
            'cota_grado_cp': t+2, 'cota_fri_exclusiva': 2*t,
            'acuerdos_con_testigo_grado_menor_T': acuerdos, 'distancia_exacta_RS_T': '7/8',
            'legado': 'Acepta', 'control_exhaustivo': 'Rechaza por grado'}


def main():
    field = (RAIZ / 'nexus/nexus-zk/src/stark/field.rs').read_text(encoding='utf-8')
    assert int(re.search(r'pub const P: u64 = (0x[\w]+)', field)[1].replace('_', ''), 16) == P
    casos = [contraste(t) for t in [16, 32, 64]]
    ejecuciones = []
    for nombre, comando, esperado in [
        ('cargo-check.log', 'cargo check --workspace --all-targets --locked --offline --manifest-path nexus/Cargo.toml', None),
        ('cargo-test.log', 'cargo test --workspace --locked --offline --manifest-path nexus/Cargo.toml -- --nocapture', 187),
        ('cargo-build.log', 'cargo build --workspace --locked --offline --manifest-path nexus/Cargo.toml', None),
        ('cargo-test-release.log', 'cargo test -p nexus-zk --test tg2_trace_proximity --release --locked --offline --manifest-path nexus/Cargo.toml -- --nocapture', 7),
    ]:
        datos = (DESTINO / nombre).read_bytes()
        texto = datos.decode('utf-16' if datos.startswith(b'\xff\xfe') else 'utf-8')
        assert 'Finished ' in texto and not re.search(r'^error(?:\[|:)', texto, re.M)
        if esperado is not None:
            cuentas = re.findall(r'test result: ok\. (\d+) passed; (\d+) failed;', texto)
            assert sum(int(p) for p, _ in cuentas) == esperado
            assert all(int(f) == 0 for _, f in cuentas)
            for caso in casos:
                assert (f'TG2_TRAZA_LEJANA T={caso["T"]} N={caso["N"]} grado_traza={caso["T"]} '
                        f'cota_cp={caso["cota_grado_cp"]} distancia=7/8 acepta=true') in texto
        ejecuciones.append({'comando': comando, 'log': nombre, 'codigo_salida': 0,
                            'pruebas': esperado, 'sha256': huella(DESTINO / nombre)})
    corpus = []
    for perfil in ['debug', 'release']:
        for caso in casos:
            archivo = DESTINO / f'corpus-{perfil}/traza-lejana-{caso["T"]}.bin'
            assert archivo.is_file()
            corpus.append({'archivo': archivo.relative_to(DESTINO).as_posix(),
                           'bytes': archivo.stat().st_size, 'sha256': huella(archivo)})
    validacion = {
        'fecha': '2026-09-22', 'pruebas_workspace': 187, 'nuevas_r4_proximidad': 7,
        'pruebas_nuevas_release': 7, 'cargo_target_dir': 'C:/tmp/nexus-target',
        'variable_corpus': 'NEXUS_TG2_TRACE_EVIDENCE_DIR',
        'rustc': subprocess.check_output(['rustc', '-Vv'], text=True).strip(),
        'cargo': subprocess.check_output(['cargo', '-V'], text=True).strip(),
        'ejecuciones': ejecuciones, 'corpus': corpus,
        'limite': 'Suite completa en desarrollo; siete pruebas nuevas en release. Corpus público, enunciados válidos y trazas alejadas; no contiene una falsificación de enunciado.',
    }
    (DESTINO / 'validacion.json').write_text(json.dumps(validacion, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    fuentes = list((RAIZ / 'nexus/nexus-zk/src/stark').glob('*.rs')) + [
        RAIZ / 'nexus/nexus-zk/experiments/tg2_air_algebra.rs',
        RAIZ / 'nexus/nexus-zk/experiments/tg2_trace_proximity.rs',
        RAIZ / 'nexus/nexus-zk/tests/tg2_trace_proximity.rs',
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
    reporte = {
        'fecha': '2026-09-22', 'familia': 'F=f+lambda*(X^T-1), lambda no nulo',
        'casos': casos, 'casos_algebraicos_en_rust': 21,
        'implicacion_refutada': 'Aceptación heredada implica distancia <=1/24 de la traza comprometida a RS de grado <T',
        'control': {'filas_minimas': 4, 'filas_maximas': 256, 'grado_exigido': '<T',
                    'costo': 'O(N log N)', 'memoria': 'O(N)', 'elementos_adicionales': 'N=8T',
                    'conocimiento_cero': False, 'integrado_en_produccion': False},
        'fuentes': registros,
    }
    (DESTINO / 'analisis.json').write_text(json.dumps(reporte, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    lineas = [
        '**Tabla 6.17 — Trazas alejadas aceptadas y control exhaustivo TG2.**', '',
        '| Filas T | Grado traza | Cota grado CP | Distancia | Legado | Control TG2 |',
        '|---:|---:|---:|:---:|:---:|:---:|',
    ]
    for c in casos:
        lineas.append(f'| {c["T"]} | {c["grado_traza"]} | ≤ {c["cota_grado_cp"]} | 7/8 | Acepta | Rechaza |')
    (DESTINO / 'tabla-proximidad.md').write_text('\n'.join(lineas)+'\n', encoding='utf-8')
    print(json.dumps({'pruebas': 187, 'release': 7, 'casos': casos, 'archivos_corpus': len(corpus)}, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
