"""Auditoría aritmética y conservación de fuentes de la revisión STARK R4."""
from decimal import Decimal, getcontext
from fractions import Fraction
from pathlib import Path
import hashlib
import json
import re
import shutil
import sys

RAIZ = Path(__file__).resolve().parents[1]
DESTINO = RAIZ / 'Documentos/06-Evidencia-TG2/2026-09-22/R4-solidez'
getcontext().prec = 90


def huella(ruta):
    return hashlib.sha256(ruta.read_bytes()).hexdigest()


def decimal(fraccion):
    return Decimal(fraccion.numerator) / Decimal(fraccion.denominator)


def bits(probabilidad):
    return -decimal(probabilidad).ln() / Decimal(2).ln()


def main():
    DESTINO.mkdir(parents=True, exist_ok=True)
    carpeta = RAIZ / 'nexus/nexus-zk/src/stark'
    textos = {p.stem: p.read_text(encoding='utf-8') for p in carpeta.glob('*.rs')}
    p = int(re.search(r'pub const P: u64 = (0x[\w]+)', textos['field'])[1].replace('_', ''), 16)
    b = int(re.search(r'pub const BLOWUP: usize = (\d+)', textos['air'])[1])
    consultas = int(re.search(r'pub const NUM_QUERIES: usize = (\d+)', textos['fri'])[1])
    trabajo = int(re.search(r'pub const POW_BITS: u32 = (\d+)', textos['params'])[1])
    assert (b, consultas, trabajo) == (8, 40, 20)
    assert 'degree_bound: 2 * t' in textos['air']
    assert 'NUM_QUERIES.min(domain)' in textos['fri']
    filas = []
    for t in [4, 8, 16, 64, 256, 1024, 4096, 262144]:
        n = b * t
        q = min(consultas, n // 2)
        filas.append({'T': t, 'N': n, 'cota_grado_estricta': 2*t, 'capas': (2*t).bit_length()-1,
                      'consultas': q, 'perfil_tg2': t >= 16,
                      'aritmetica_pg_sin_justificacion': q*2,
                      'aritmetica_pg_mas_pow_release_sin_justificacion': q*2+trabajo})
    # Distribución exacta al reducir una cadena uniforme de 128 bits módulo p.
    m = 1 << 128
    cociente, residuo = divmod(m, p)
    variacion = Fraction(residuo*(p-residuo), p*m)
    maxima = Fraction(cociente+1, m)
    # Escenario del teorema citado, separado de su aplicabilidad al código.
    rho, eta, delta = Fraction(1, 4), Fraction(1, 24), Fraction(5, 12)
    assert 0 < eta < Fraction(1, 12)
    assert 0 < delta < Fraction(1, 2)-eta
    referencias = []
    for t in [16, 4096, 262144]:
        n = b*t
        algebraico = Fraction(7, 2)**7 * n*n / (3*Fraction(1, 8)*p*p)
        consulta = (1-delta)**consultas * Fraction(1, 2**trabajo)
        error = max(algebraico, consulta)
        referencias.append({'T': t, 'bits_termino_algebraico': str(bits(algebraico)),
                            'bits_consulta_con_pow': str(bits(consulta)),
                            'bits_error_rbr_referencia': str(bits(error))})
    pruebas = (DESTINO/'cargo-test.log').read_text(encoding='utf-16')
    cercano = re.search(r'TG2_PROXIMIDAD n=(\d+) grado=(\d+) cota=(\d+) aceptadas=(\d+) rechazadas=(\d+)', pruebas)
    assert cercano
    campos = ['N', 'grado_interpolado', 'cota', 'aceptadas', 'rechazadas']
    resultado = {
        'fecha': '2026-09-22', 'parametros': filas,
        'muestreo_campo': {'p': p, 'bits_entrada_coordenada': 128, 'cociente': cociente,
                          'residuo': residuo, 'variacion_total': str(variacion),
                          'bits_variacion_total': str(bits(variacion)),
                          'probabilidad_maxima_coordenada': str(maxima),
                          'probabilidad_maxima_extension': str(maxima*maxima),
                          'limite': 'Bajo bytes uniformes ideales; no prueba independencia de SHA3 ni una cota global.'},
        'escenario_bt24': {'fuente': 'Teorema 1, §3.2 y Lema 1 de BT24',
                           'rho': str(rho), 'm': 3, 'eta': str(eta), 'delta': str(delta),
                           'resultados': referencias,
                           'limite': 'Aritmética de referencia clásica; aplicación al código y composición AIR/Merkle/Fiat-Shamir no demostradas. No es estimación certificada de bits de NEXUS.'},
        'ensayo_proximidad': dict(zip(campos, map(int, cercano.groups()))),
        'probabilidad_ideal_evitar_pareja': str(Fraction(256-40, 256)),
    }
    resultado['ensayo_proximidad']['limite'] = '32 contextos públicos fijos, FRI aislado sin grinding; distancia 1/512 a cero. No es un enunciado AIR falso aceptado ni un ataque de 100 bits.'
    fuentes = list(carpeta.glob('*.rs')) + [
        RAIZ/'nexus/nexus-core/src/types.rs',
        RAIZ/'nexus/nexus-zk/tests/tg2_soundness.rs',
        RAIZ/'nexus/nexus-active/experiments/tg2_canonical_verifier.rs',
        RAIZ/'nexus/Cargo.toml', RAIZ/'nexus/Cargo.lock',
        Path(__file__).resolve(),
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
    resultado['fuentes'] = registros
    (DESTINO/'analisis.json').write_text(json.dumps(resultado, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    tabla = ['**Tabla 6.15 — Parámetros efectivos del PoC STARK por tamaño de traza.**', '',
             '| Filas T | Dominio N | Cota de grado | Capas FRI | Consultas distintas | Perfil TG2 |',
             '|---:|---:|---:|---:|---:|:---:|']
    for f in filas:
        tabla.append(f'| {f["T"]} | {f["N"]} | < {f["cota_grado_estricta"]} | {f["capas"]} | {f["consultas"]} | {"Sí" if f["perfil_tg2"] else "No"} |')
    (DESTINO/'tabla-parametros.md').write_text('\n'.join(tabla)+'\n', encoding='utf-8')
    sys.path.insert(0, str(RAIZ/'.tools/pdf'))
    import pymupdf
    publicaciones = []
    for nombre, url in [
        ('BT24', 'https://eprint.iacr.org/2024/1161.pdf'),
        ('BGK23', 'https://eprint.iacr.org/2023/1071.pdf'),
        ('FRI18', 'https://drops.dagstuhl.de/storage/00lipics/lipics-vol107-icalp2018/LIPIcs.ICALP.2018.14/LIPIcs.ICALP.2018.14.pdf'),
    ]:
        archivo = DESTINO/'bibliografia'/f'{nombre}.pdf'
        with pymupdf.open(archivo) as doc:
            paginas = [pagina.get_text() for pagina in doc]
        archivo.with_suffix('.txt').write_text(
            '\n'.join(f'[PÁGINA PDF {i+1}]\n{texto}' for i, texto in enumerate(paginas)), encoding='utf-8')
        publicaciones.append({'archivo': archivo.name, 'url': url, 'paginas': len(paginas), 'sha256': huella(archivo)})
    (DESTINO/'bibliografia.json').write_text(
        json.dumps({'consulta': '2026-09-22', 'fuentes': publicaciones}, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    print(json.dumps({k: resultado[k] for k in ['ensayo_proximidad', 'escenario_bt24', 'muestreo_campo']}, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
