"""Calcula cotas del IOP ideal; no atribuye garantías a SHA3 ni al ejecutable."""
from argparse import ArgumentParser
from fractions import Fraction as F
from math import comb
from pathlib import Path
import json

P = 2**64 - 2**32 + 1


def techo(x):
    return -(-x.numerator // x.denominator)


def omision(m, q, distancia):
    if not (0 <= q <= m and 0 <= distancia <= 1):
        raise ValueError("Parámetros de muestreo fuera del dominio")
    malos = techo(m * distancia)
    return F(comb(m - malos, q), comb(m, q)) if m - malos >= q else F(0)


def fraccion(x):
    return {"numerador": str(x.numerator), "denominador": str(x.denominator)}


def decimal_superior(x, cifras=9):
    escala = 10**cifras
    entero = techo(x * escala)
    return f"{entero // escala}.{entero % escala:0{cifras}d}"


def calcular(t, q=40, delta_t=F(1, 8), delta_c=F(1, 8)):
    if t not in [2**i for i in range(4, 13)]:
        raise ValueError("El perfil TG2 admite potencias de dos entre 16 y 4096")
    n, m = 8*t, 4*t
    if not 1 <= q <= m:
        raise ValueError("Debe cumplirse 1 <= q <= N/2")
    if not (0 < delta_t and 0 < delta_c and 2*delta_t < F(n-t+1, n)):
        raise ValueError("Umbrales incompatibles con la unicidad de traza")
    d = F(5*t+1, n) - 3*delta_t - delta_c
    d_base = 1 - F(t-1, n) - delta_t
    if not 0 < d <= d_base <= 1:
        raise ValueError("No queda distancia positiva para el enlace AIR")
    fases = {}
    for nombre, grado, delta in [("traza", t, delta_t), ("composicion", 2*t, delta_c)]:
        k = grado.bit_length()-1
        tamanos = [n // 2**(j+1) for j in range(k)]
        grados = [grado // 2**(j+1) for j in range(k)]
        # Condición del lema elemental para cada dominio después del plegado.
        if not all((1-3*delta)*ni > di-1 for ni, di in zip(tamanos, grados)):
            raise ValueError("El lema MCA elemental no cubre estos umbrales")
        fases[nombre] = {"k": k, "tamanos": tamanos,
                         "perdida": F(sum(tamanos), P*P),
                         "consulta": omision(m, q, delta)}
    ft, fc = fases["traza"], fases["composicion"]
    ht, hc = ft["consulta"], fc["consulta"]
    hd, hb = omision(m, q, d), omision(m, q, d_base)
    final = max(ht, hc, hd, hb)
    rbr = max(F(1, P*P), F(n, 2*P*P), final)
    casos = [ft["perdida"] + ht, hb,
             F(1, P*P) + fc["perdida"] + max(hc, hd)]
    ideal = min(F(1), max(casos))
    # Solo para comparar con la cuenta histórica en los radios que aquella usa.
    anterior = None
    if delta_t <= F(7, 16) and delta_c <= F(3, 8):
        anterior = min(F(1), F(1, P*P)
                       + (ft["k"]+1)*max(F(n, P*P), (1-delta_t)**q)
                       + (fc["k"]+1)*max(F(n, P*P), (1-delta_c)**q) + hd)
    return {"T": t, "N": n, "M": m, "q": q,
            "delta_traza": fraccion(delta_t), "delta_composicion": fraccion(delta_c),
            "distancia_enlace": fraccion(d), "distancia_no_base": fraccion(d_base),
            "tamanos_plegados_traza": ft["tamanos"],
            "tamanos_plegados_composicion": fc["tamanos"],
            "perdida_plegados_traza": fraccion(ft["perdida"]),
            "perdida_plegados_composicion": fraccion(fc["perdida"]),
            "omision_traza": fraccion(ht), "omision_composicion": fraccion(hc),
            "omision_enlace": fraccion(hd), "omision_no_base": fraccion(hb),
            "epsilon_rbr": fraccion(rbr), "epsilon_rbr_superior": decimal_superior(rbr),
            "cota_ideal": fraccion(ideal), "cota_ideal_superior": decimal_superior(ideal),
            "cota_anterior": fraccion(anterior) if anterior is not None else None,
            "cota_anterior_superior": decimal_superior(anterior) if anterior is not None else None}


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument("--salida", type=Path, help="Archivo nuevo; se rechaza sobrescribirlo")
    args = parser.parse_args()
    resultado = {"fecha": "2026-09-23", "rama": "investigacion/cierre-matematico-tg2",
                 "modelo": "Oráculos completos inmutables; retos uniformes frescos; consulta conjunta sin reemplazo",
                 "estado": "Derivación escrita pendiente de revisión independiente",
                 "limite": "No es una garantía del protocolo SHA3/Merkle/Fiat-Shamir ni del modelo cuántico",
                 "P": P, "perfiles": [calcular(2**i) for i in range(4, 13)]}
    contenido = json.dumps(resultado, ensure_ascii=False, indent=2)+"\n"
    if args.salida:
        args.salida.parent.mkdir(parents=True, exist_ok=True)
        with args.salida.open("x", encoding="utf-8", newline="\n") as salida:
            salida.write(contenido)
        print(f"Guardados {len(resultado['perfiles'])} perfiles en {args.salida}")
    else:
        print(contenido, end="")


if __name__ == "__main__":
    main()
