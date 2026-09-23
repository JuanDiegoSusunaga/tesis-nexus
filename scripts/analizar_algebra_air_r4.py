"""Conserva el contraste numérico y las fuentes de la reducción algebraica AIR."""
from fractions import Fraction
from pathlib import Path
import hashlib
import json
import re
import shutil

RAIZ = Path(__file__).resolve().parents[1]
DESTINO = RAIZ/'Documentos/06-Evidencia-TG2/2026-09-22/R4-algebra'


def huella(ruta):
    return hashlib.sha256(ruta.read_bytes()).hexdigest()


def inferior_seis(valor):
    entero = valor.numerator*1_000_000//valor.denominator
    return f'{entero//1_000_000},{entero%1_000_000:06}'


def main():
    field = (RAIZ/'nexus/nexus-zk/src/stark/field.rs').read_text(encoding='utf-8')
    p = int(re.search(r'pub const P: u64 = (0x[\w]+)', field)[1].replace('_', ''), 16)
    generador = int(re.search(r'pub const GENERATOR: u64 = (\d+)', field)[1])
    dominios = []
    for exponente in range(2, 19):
        t = 1 << exponente
        n = 8*t
        omega = pow(generador, (p-1)//n, p)
        g = pow(generador, (p-1)//t, p)
        assert pow(omega, n, p) == 1 and pow(omega, n//2, p) != 1
        assert pow(omega, 8, p) == g
        assert pow(g, t, p) == 1 and pow(g, t//2, p) != 1
        assert pow(generador, n, p) != 1
        dominios.append({'T': t, 'N': n, 'ordenes_y_desplazamiento_verificados': True,
                         'coset_disjunto': True})
    tabla = []
    for t in [16, 64, 256, 4096, 262144]:
        exacta = Fraction(5*t+1, 8*t)
        transferida = exacta-Fraction(3, 24)
        assert transferida > Fraction(1, 2)
        tabla.append({'T': t, 'N': 8*t, 'distancia_exacta': str(exacta),
                      'distancia_con_delta_1_24': str(transferida),
                      'inferior_exacta_6_decimales': inferior_seis(exacta),
                      'inferior_transferida_6_decimales': inferior_seis(transferida)})
    # Cálculo independiente con enteros modulares del caso de cancelación Rust.
    t = 16
    g = pow(generador, (p-1)//t, p)
    h1, h2 = pow(g, t-1, p), pow(g, t-2, p)
    r0 = t
    r2 = (-7*(1-h1)*(1-h2)) % p
    alpha0 = (-r2*pow(r0, -1, p)) % p
    assert (alpha0*r0+r2) % p == 0 and alpha0 != 0
    texto = (DESTINO/'cargo-test.log').read_text(encoding='utf-16')
    assert f'TG2_CANCELACION T=16 alpha0={alpha0} grado_cp=16' in texto
    assert 'TG2_TRANSFERENCIA errores_traza=2 diferencias_cp=6 dominio=128' in texto
    maximo = Fraction(((1 << 128)//p)+1, 1 << 128)**2
    reporte = {
        'fecha': '2026-09-22', 'dominios': dominios, 'cotas_condicionales': tabla,
        'cancelacion': {'T': t, 'alpha0': alpha0, 'alpha1': 1, 'alpha2': 1,
                        'residuo_inicial_en_1': r0, 'residuo_transicion_en_1': r2,
                        'grado_cp': 16,
                        'limite': 'Traza inválida y coeficientes elegidos; no se fuerzan retos SHA3. El enunciado conserva una traza válida alternativa.'},
        'transferencia': {'errores_traza': 2, 'diferencias_cp': 6, 'N': 128},
        'cancelacion_ideal_uniforme': str(Fraction(1, p*p)),
        'masa_maxima_extension_bytes_uniformes': str(maximo),
        'limite': 'Derivación condicional para f fijo de grado <T o un oráculo próximo a ese f. No prueba que el verificador garantice esa proximidad ni acota Fiat-Shamir adaptativo.',
    }
    fuentes = list((RAIZ/'nexus/nexus-zk/src/stark').glob('*.rs')) + [
        RAIZ/'nexus/nexus-zk/experiments/tg2_air_algebra.rs',
        RAIZ/'nexus/nexus-zk/tests/tg2_air_algebra.rs',
        RAIZ/'nexus/Cargo.toml', RAIZ/'nexus/Cargo.lock', Path(__file__).resolve(),
    ]
    registros = []
    for fuente in fuentes:
        relativo = fuente.relative_to(RAIZ)
        copia = DESTINO/'fuentes'/relativo
        copia.parent.mkdir(parents=True, exist_ok=True)
        if copia.exists():
            assert copia.read_bytes() == fuente.read_bytes(), str(relativo)
        else:
            shutil.copy2(fuente, copia)
        registros.append({'archivo': relativo.as_posix(), 'sha256': huella(fuente)})
    reporte['fuentes'] = registros
    (DESTINO/'analisis.json').write_text(json.dumps(reporte, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    lineas = [
        '**Tabla 6.16 — Distancias mínimas condicionales de la composición al código.**', '',
        '| Filas T | Dominio N | Traza polinómica exacta | Traza a distancia ≤ 1/24 |',
        '|---:|---:|---:|---:|',
    ]
    for fila in tabla:
        lineas.append(f'| {fila["T"]} | {fila["N"]} | {fila["inferior_exacta_6_decimales"]} | {fila["inferior_transferida_6_decimales"]} |')
    (DESTINO/'tabla-distancias.md').write_text('\n'.join(lineas)+'\n', encoding='utf-8')
    print(json.dumps({k: reporte[k] for k in ['cancelacion', 'transferencia', 'cotas_condicionales']}, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
