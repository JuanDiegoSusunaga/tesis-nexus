"""Reproduce cotas ideales de composición; no estima ataques ni seguridad de SHA3."""
from pathlib import Path
from fractions import Fraction as F
from itertools import product, combinations
from math import comb, log2
import hashlib
import json
import shutil

RAIZ = Path(__file__).resolve().parents[1]
DESTINO = RAIZ / 'Documentos/06-Evidencia-TG2/2026-09-22/R4-cota-interactiva'
ANTERIOR = DESTINO.parent / 'R4-FRI-vinculado'
P = 2**64 - 2**32 + 1


def huella(archivo):
    return hashlib.sha256(archivo.read_bytes()).hexdigest()


def fraccion(x):
    return {'numerador': str(x.numerator), 'denominador': str(x.denominator)}


def techo(x):
    return -(-x.numerator // x.denominator)


def omision(m, q, distancia):
    b = techo(m * distancia)
    return F(comb(m-b, q), comb(m, q)) if m-b >= q else F(0)


def decimal_superior(x, cifras=6):
    escala = 10**cifras
    entero = techo(x * escala)
    return f'{entero // escala},{entero % escala:0{cifras}d}'


def contrastes_finitos():
    # Enumeración completa pequeña para unicidad y componente fuera del campo base.
    dominio = [1, 2, 4, 3]
    codigo = [tuple((a+b*x) % 5 for x in dominio) for a, b in product(range(5), repeat=2)]
    distancia = lambda u, v: sum(x != y for x, y in zip(u, v))
    assert min(distancia(u, v) for u, v in combinations(codigo, 2)) == 3
    palabras = list(product(range(5), repeat=4))
    for u in palabras:
        assert sum(distancia(u, v) <= 1 for v in codigo) <= 1
    # F25 = F5[z]/(z²-2). Si B no es cero, A+zB toma valores base a lo sumo una vez.
    assert pow(2, 2, 5) == 4
    no_base = 0
    for a0, a1, b0, b1 in product(range(5), repeat=4):
        if b0 or b1:
            no_base += 1
            assert sum((b0+b1*x) % 5 == 0 for x in dominio) <= 1
    referencia = codigo[7]
    def local(u):
        return tuple((u[(i+2) % 4]-u[(i+1) % 4]**2-u[i]**2) % 5 for i in range(4))
    for u in palabras:
        assert distancia(local(u), local(referencia)) <= 3*distancia(u, referencia)
    casos_muestreo = 0
    for m in range(2, 10):
        for q in range(1, m+1):
            for b in range(m+1):
                conjuntos = list(combinations(range(m), q))
                real = F(sum(all(i >= b for i in s) for s in conjuntos), len(conjuntos))
                calculada = omision(m, q, F(b, m))
                assert real == calculada and real <= (1-F(b, m))**q
                casos_muestreo += 1
    # Cambio de variable del coset: beta se divide por su desplazamiento.
    casos_plegado = 0
    inv2 = pow(2, -1, P)
    for j in range(13):
        a = pow(7, 2**j, P)
        for y in [1, 3, 17]:
            for beta in [(0, 0), (1, 0), (3, 5)]:
                izq, der = (11, 19), (23, 29)
                par = tuple((l+r)*inv2 % P for l, r in zip(izq, der))
                impar = tuple((l-r)*inv2 % P for l, r in zip(izq, der))
                def mul(u, v):
                    return ((u[0]*v[0]+7*u[1]*v[1]) % P, (u[0]*v[1]+u[1]*v[0]) % P)
                def plegar(x, reto):
                    termino = mul(reto, tuple(c*pow(x, -1, P) % P for c in impar))
                    return tuple((c+d) % P for c, d in zip(par, termino))
                assert plegar(a*y % P, beta) == plegar(y, tuple(c*pow(a, -1, P) % P for c in beta))
                casos_plegado += 1
    return {'palabras_unicidad': len(palabras), 'polinomios_no_base': no_base,
            'palabras_localidad': len(palabras), 'escenarios_muestreo': casos_muestreo,
            'identidades_plegado': casos_plegado,
            'limite': 'Contrastes finitos de identidades y cuentas; no son pruebas de solidez de Rust.'}


def main():
    DESTINO.mkdir(parents=True, exist_ok=True)
    assert pow(7, (P-1)//2, P) == P-1
    filas = []
    for t in [2**i for i in range(4, 13)]:
        n, m, q = 8*t, 4*t, 40
        kt, kc = t.bit_length()-1, t.bit_length()
        dt = dc = F(1, 8)
        d = F(5*t+1, n)-3*dt-dc
        d_base = 1-F(t-1, n)-dt
        assert 2*dt < 1-F(t-1, n)
        assert dt <= F(7, 16) and dc <= F(3, 8)
        assert 0 < d <= d_base <= 1
        omega = pow(7, (P-1)//n, P)
        assert pow(omega, n, P) == 1 and pow(omega, n//2, P) != 1
        assert pow(7, n, P) != 1
        rt = max(F(n, P*P), (1-dt)**q)
        rc = max(F(n, P*P), (1-dc)**q)
        et, ec = (kt+1)*rt, (kc+1)*rc
        enlace = omision(m, q, d)
        assert omision(m, q, d_base) <= enlace <= (1-d)**q
        total = min(F(1), F(1, P*P)+et+ec+enlace)
        filas.append({'T': t, 'N': n, 'M': m, 'q': q, 'k_traza': kt, 'k_cp': kc,
                      'delta_traza': fraccion(dt), 'delta_cp': fraccion(dc),
                      'distancia_enlace': fraccion(d), 'parejas_malas_minimas': techo(m*d),
                      'error_fri_traza': fraccion(et), 'error_fri_cp': fraccion(ec),
                      'error_enlace': fraccion(enlace), 'cota_ideal': fraccion(total),
                      'cota_decimal_superior': decimal_superior(total),
                      'menos_log2_solo_cota': -log2(float(total))})
    fuentes = []
    for entrada in json.loads((ANTERIOR/'analisis.json').read_text(encoding='utf-8'))['fuentes']:
        archivo = RAIZ / entrada['archivo']
        assert huella(archivo) == entrada['sha256']
        fuentes.append(archivo)
    fuentes += [Path(__file__).resolve()]
    fuentes += [DESTINO.parent/'R4-solidez/bibliografia'/f'BGK23.{ext}' for ext in ['pdf', 'txt']]
    registros = []
    for archivo in fuentes:
        relativo = archivo.relative_to(RAIZ)
        copia = DESTINO/'fuentes'/relativo
        copia.parent.mkdir(parents=True, exist_ok=True)
        if copia.exists():
            assert huella(copia) == huella(archivo), relativo
        else:
            shutil.copy2(archivo, copia)
        registros.append({'archivo': relativo.as_posix(), 'sha256': huella(archivo)})
    datos = {'fecha': '2026-09-22', 'modelo': 'Interactivo, oráculos ideales fijos y retos uniformes independientes en Fp2',
             'fuente': 'BGK+23, versión de 2024-02-15, Corolario 5.5, p. 34; Algoritmo 1, p. 40',
             'metodo': 'Unión conservadora de k+1 rondas por FRI; cancelación y enlace por muestreo sin reemplazo',
             'P': P, 'filas': filas, 'contrastes': contrastes_finitos(), 'fuentes': registros,
             'limite': 'Cota superior derivada bajo hipótesis ideales, pendiente de revisión independiente; no probabilidad de ataque observada ni garantía del ejecutable Fiat–Shamir/Merkle/QROM.'}
    (DESTINO/'analisis.json').write_text(json.dumps(datos, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    tabla = ['**Tabla 6.19 — Cota conservadora de aceptación en el modelo interactivo ideal.**', '',
             '| Filas T | Rondas FRI traza / CP | Consultas | Cota superior ideal |', '|---:|:---:|---:|---:|']
    for f in filas:
        if f['T'] in [16, 64, 256, 4096]:
            tabla.append(f"| {f['T']} | {f['k_traza']+1} / {f['k_cp']+1} | {f['q']} | {f['cota_decimal_superior']} |")
    (DESTINO/'tabla-cota.md').write_text('\n'.join(tabla)+'\n', encoding='utf-8')
    print(json.dumps({'perfiles': len(filas), 'contrastes': datos['contrastes'],
                      'cota_maxima': filas[-1]['cota_decimal_superior']}, ensure_ascii=False))


if __name__ == '__main__':
    main()
