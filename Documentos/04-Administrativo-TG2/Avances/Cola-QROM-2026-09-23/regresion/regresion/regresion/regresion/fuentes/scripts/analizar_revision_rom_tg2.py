"""Revisión finita del argumento adaptativo de nonces; aritmética racional exacta."""
from argparse import ArgumentParser
from fractions import Fraction as F
from functools import lru_cache
from itertools import permutations
from math import comb
from pathlib import Path
from hashlib import sha3_256
import json

from analizar_rbr_conjunto_tg2 import fraccion
from analizar_transferencia_rom_tg2 import RegistroOraculo


def probabilidad_restante(m, buenos, q, vistos):
    """Probabilidad de completar q distintos buenos tras observar 'vistos' buenos."""
    if not (1 <= q <= m and 0 <= buenos <= m):
        raise ValueError("Perfil de muestreo inválido")
    if vistos < 0 or buenos < q:
        return F(0)
    if not 0 <= vistos <= min(buenos, q):
        raise ValueError("Prefijo imposible")
    return F(comb(buenos-vistos, q-vistos), comb(m-vistos, q-vistos))


def probabilidad_cola(m, q, restantes, vistos=0):
    """Cola exacta del recolector de distintos, sin usar la unión de subconjuntos."""
    if not (1 <= q <= m and restantes >= 0 and 0 <= vistos <= m):
        raise ValueError("Perfil de cola inválido")
    # La recurrencia por niveles evita profundidad de pila proporcional a R.
    valores = [F(int(s < q)) for s in range(m+1)]
    for _ in range(restantes):
        valores = [F(s, m)*valores[s]+F(m-s, m)*valores[s+1]
                   if s < q else F(0) for s in range(m+1)]
    return valores[vistos]


def potencial(estado, m, buenos, q, bits):
    trabajo, _, vistos = estado
    if trabajo == 0 or vistos < 0:
        return F(0)
    factor = F(1, 2**bits) if trabajo == -1 else F(1)
    return factor*probabilidad_restante(m, buenos, q, vistos)


def acciones(estado, q):
    trabajo, semilla, vistos = estado
    if trabajo == 0 or vistos < 0:
        return []
    salida = []
    if trabajo == -1:
        salida.append("trabajo")
    if not semilla:
        salida.append("semilla")
    elif vistos < q:
        salida.append("indice")
    return salida


def transiciones(estado, accion, m, buenos, q, bits):
    if accion not in acciones(estado, q):
        raise ValueError("Acción ajena al estado")
    trabajo, semilla, vistos = estado
    if accion == "trabajo":
        return [(F(1, 2**bits), (1, semilla, vistos)),
                (1-F(1, 2**bits), (0, semilla, vistos))]
    if accion == "semilla":
        # Se contabiliza el hash de absorción; aquí no revela un índice.
        return [(F(1), (trabajo, True, vistos))]
    return [(F(vistos, m), estado),
            (F(buenos-vistos, m), (trabajo, True, vistos+1)),
            (F(m-buenos, m), (trabajo, True, -1))]


def estrategia_optima(m, buenos, q, bits, presupuesto, capacidad=2):
    """Bellman exacto con consultas adaptativas y una verificación final gratuita.

    Modelo de monedas frescas: omite eventos hash y algebraicos. Mantiene hasta
    'capacidad' candidatos, puede descartar uno, abrir otro y elegir el final.
    Los índices repetidos cuestan una consulta. Las respuestas hash auxiliares
    no ofrecen información útil adicional en este modelo sin coincidencias.
    """
    if presupuesto < 0 or capacidad < 1 or bits < 0:
        raise ValueError("Presupuesto inválido")
    nuevo = (-1, False, 0)
    inicial = potencial(nuevo, m, buenos, q, bits)

    def normalizar(estados):
        return tuple(sorted(e for e in estados if potencial(e, m, buenos, q, bits) > 0))

    @lru_cache(None)
    def resolver(restantes, estados):
        # El último candidato puede estar parcialmente explorado o ser nuevo.
        mejor = max([inicial]+[potencial(e, m, buenos, q, bits) for e in estados])
        if restantes == 0 or mejor == 1:
            return mejor
        opciones = [(estados, i) for i in range(len(estados))]
        if len(estados) < capacidad:
            opciones.append((estados+(nuevo,), len(estados)))
        else:
            # Abandono voluntario, incluso de candidatos que siguen siendo viables.
            opciones += [(estados[:i]+estados[i+1:]+(nuevo,), capacidad-1)
                         for i in range(capacidad)]
        for base, i in opciones:
            for accion in acciones(base[i], q):
                media = F(0)
                for probabilidad, siguiente in transiciones(base[i], accion, m, buenos, q, bits):
                    if probabilidad:
                        actualizados = base[:i]+(siguiente,)+base[i+1:]
                        media += probabilidad*resolver(restantes-1, normalizar(actualizados))
                mejor = max(mejor, media)
        return mejor

    valor = resolver(presupuesto, ())
    return {"M": m, "buenos": buenos, "q": q, "bits": bits, "Q": presupuesto,
            "capacidad_simultanea": capacidad, "optimo": fraccion(valor),
            "cota": fraccion(min(F(1), (presupuesto+1)*inicial)),
            "estados_bellman": resolver.cache_info().currsize}


def ordenes_merkle():
    """Enumera los 60 órdenes con raíz absorbida antes del reto, en un árbol de 2 hojas."""
    hoja_a = b"\x00"+(3).to_bytes(8, "little")+bytes(8)
    hoja_b = b"\x00"+(9).to_bytes(8, "little")+bytes(8)
    ha, hb = sha3_256(hoja_a).digest(), sha3_256(hoja_b).digest()
    padre = b"\x01"+ha+hb
    raiz = sha3_256(padre).digest()
    absorcion = bytes(32)+b"\x01"+(32).to_bytes(8, "little")+raiz
    reto = sha3_256(absorcion).digest()+b"E"
    entradas = {"a": hoja_a, "b": hoja_b, "padre": padre, "absorcion": absorcion, "reto": reto}
    total = sin_evento = discrepancias = 0
    for orden in permutations(entradas):
        if orden.index("absorcion") > orden.index("reto"):
            continue
        oracle = RegistroOraculo()
        congelado = None
        for paso in orden:
            if paso == "reto":
                congelado = oracle.extraer(raiz, 2)
            oracle.consultar(entradas[paso])
        total += 1
        if not oracle.eventos:
            sin_evento += 1
            discrepancias += congelado != [(3, 0), (9, 0)]
    return {"ordenes": total, "sin_evento_hash": sin_evento,
            "discrepancias_sin_evento_hash": discrepancias}


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument("--salida", type=Path, required=True)
    args = parser.parse_args()
    escenarios = [estrategia_optima(m, buenos, q, bits, presupuesto, capacidad)
                  for m, buenos, q in [(2, 1, 1), (4, 3, 2), (4, 3, 3)]
                  for bits in (1, 2) for capacidad in (2, 3) for presupuesto in range(8)]
    datos = {"fecha": "2026-09-23", "modelo": "Monedas frescas; sin eventos hash ni algebraicos",
             "limite": "Contrastes finitos y revisión interna; no certificación de la demostración general",
             "escenarios": escenarios, "extraccion": ordenes_merkle()}
    args.salida.parent.mkdir(parents=True, exist_ok=True)
    with args.salida.open("x", encoding="utf-8", newline="\n") as archivo:
        json.dump(datos, archivo, ensure_ascii=False, indent=2)
        archivo.write("\n")
    print(json.dumps({"escenarios": len(escenarios), "extraccion": datos["extraccion"]}))


if __name__ == "__main__":
    main()
