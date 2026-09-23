"""Primeras cotas QROM y contrastes exactos; no instancia el compilador AIR/FRI."""
from argparse import ArgumentParser
from fractions import Fraction as F
from math import comb
from pathlib import Path
import json

from analizar_rbr_conjunto_tg2 import fraccion, decimal_superior, omision
from analizar_transferencia_rom_tg2 import limites


def hashes_prefijo(t):
    datos = limites(t)
    # Dominio/perfil/enunciado/raíz, tres alpha, dos fases/finales y cada raíz/beta.
    return 11+2*(datos["k_t"]+datos["k_c"])


def cota_trabajo(t, bits, consultas):
    if bits not in (12, 20) or consultas < 0 or not isinstance(consultas, int):
        raise ValueError("Perfil o presupuesto inválido")
    c = hashes_prefijo(t)
    total = consultas+c
    limite = min(F(1), F((2*total+1)**2, 2**bits))
    return {"T": t, "bits": bits, "Q": consultas, "hashes_prefijo": c,
            "consultas_reduccion": total, "cota": fraccion(limite),
            "cota_superior": decimal_superior(limite, 12), "vacia": limite == 1}


def grover_exacto(n, marcados, iteraciones):
    """Amplitudes relativas a 1/sqrt(n); cada iteración usa dos consultas XOR a H."""
    if n < 1 or n & (n-1) or not 0 <= marcados <= n or iteraciones < 0:
        raise ValueError("Experimento de búsqueda inválido")
    buena, mala = F(1), F(1)
    for _ in range(iteraciones):
        media = (-marcados*buena+(n-marcados)*mala)/n
        buena, mala = 2*media+buena, 2*media-mala
    norma = (marcados*buena**2+(n-marcados)*mala**2)/n
    if norma != 1:
        raise ArithmeticError("La evolución no preserva la norma")
    return F(marcados, n)*buena**2


def grover_rom(n, bits, iteraciones):
    """Promedio exacto sobre tablas aleatorias H; número de marcados binomial."""
    if bits < 1:
        raise ValueError("Se necesita al menos un bit de trabajo")
    p = F(1, 2**bits)
    return sum(comb(n, m)*p**m*(1-p)**(n-m)*grover_exacto(n, m, iteraciones)
               for m in range(n+1))


def salto_ultima_consulta(m, buenos, q):
    if not 1 <= q <= buenos <= m:
        raise ValueError("Perfil inválido")
    # q-1 distintos buenos conocidos y trabajo ya válido, sin el último índice.
    return F(buenos-q+1, m)


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument("--salida", type=Path, required=True)
    args = parser.parse_args()
    perfiles = [cota_trabajo(2**i, g, q) for i in range(4, 13) for g in (12, 20)
                for q in (0, 16, 64, 256, 512, 1024)]
    busqueda = []
    for n, bits in [(4, 2), (16, 4), (64, 6)]:
        for r in range(4):
            valor = grover_rom(n, bits, r)
            q = 2*r
            lineal = min(F(1), F(q+1, 2**bits))
            cuadratica = min(F(1), F((2*q+1)**2, 2**bits))
            busqueda.append({"N": n, "bits": bits, "iteraciones": r, "consultas_H": q,
                             "exito_promedio": fraccion(valor), "expresion_lineal": fraccion(lineal),
                             "cota_cuadratica": fraccion(cuadratica),
                             "supera_lineal": valor > lineal})
    saltos = []
    for i in range(4, 13):
        t, m = 2**i, 4*2**i
        buenos = 7*m//8
        salto = salto_ultima_consulta(m, buenos, 40)
        h = omision(m, 40, F(1, 8))
        saltos.append({"T": t, "M": m, "buenos": buenos, "h_ideal": fraccion(h),
                       "salto_terminal": fraccion(salto), "salto_mayor_que_h": salto > h})
    datos = {"fecha": "2026-09-23", "modelo": "QROM, adversario de Q consultas, una prueba clásica final",
             "estado": "Cota propuesta basada solo en la condición PoW; transferencia AIR/FRI completa pendiente",
             "fuente_cota": "DFM20, Theorem 2, arXiv:2003.05207v3, página PDF 5",
             "perfiles_trabajo": perfiles, "busqueda_cuantica": busqueda,
             "obstaculo_muestreo": saltos,
             "limites": ["La simulación no es un ataque SHA3/NEXUS ni hardware cuántico",
                         "Los saltos pertenecen al modelo abstracto de parejas fijas; no son falsificaciones",
                         "No se introduce un factor h_T en la cota QROM de trabajo"]}
    args.salida.parent.mkdir(parents=True, exist_ok=True)
    with args.salida.open("x", encoding="utf-8", newline="\n") as archivo:
        json.dump(datos, archivo, ensure_ascii=False, indent=2)
        archivo.write("\n")
    print(json.dumps({"perfiles_trabajo": len(perfiles), "busqueda": len(busqueda), "saltos": len(saltos)}))


if __name__ == "__main__":
    main()
