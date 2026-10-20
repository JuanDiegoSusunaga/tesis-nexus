"""Cota clásica ROM del protocolo TG2 v1; SHA3 se modela como oráculo aleatorio."""
from argparse import ArgumentParser
from fractions import Fraction as F
from hashlib import sha3_256
from math import comb
from pathlib import Path
import json

from analizar_rbr_conjunto_tg2 import P, omision, fraccion, decimal_superior

R = 512
MU = F(2**128 // P + 1, 2**128)**2


def limites(t, q=40, extracciones=R):
    if t not in [2**i for i in range(4, 13)] or q != 40 or extracciones < q:
        raise ValueError("Perfil ajeno a la variante vinculada v1")
    n = 8*t
    kt, kc, profundidad = t.bit_length()-1, t.bit_length(), n.bit_length()-1
    caminos = q*(6*profundidad + 2*sum(profundidad-j for j in range(kt))
                 + 2*sum(profundidad-j for j in range(kc)))
    hojas = q*(6+2*kt+2*kc)
    etiquetas = 1+kt+kc+caminos
    canal = 13+2*(kt+kc)+extracciones
    return {"T": t, "N": n, "M": n//2, "q": q, "k_t": kt, "k_c": kc,
            "retos_extension": 3+kt+kc, "etiquetas_prueba": etiquetas,
            "hashes_merkle": caminos+hojas, "hashes_canal_maximos": canal,
            "hashes_verificador_maximos": caminos+hojas+canal,
            "extracciones_maximas_analisis": extracciones}


def cola(m, q, r):
    if not (1 <= q <= m and r >= 0):
        raise ValueError("Parámetros de cola inválidos")
    return min(F(1), comb(m, q-1)*F(q-1, m)**r)


def cota(t, bits, consultas, extracciones=R):
    if bits not in (12, 20) or consultas < 0:
        raise ValueError("Perfil de grinding o presupuesto inválido")
    datos = limites(t, extracciones=extracciones)
    h = omision(datos["M"], 40, F(1, 8))
    tail = cola(datos["M"], 40, extracciones)
    s = consultas+datos["hashes_verificador_maximos"]
    grafo = F(s*(49*s+datos["etiquetas_prueba"]), 2**256)
    campo = (consultas+datos["retos_extension"])*(datos["N"]//2)*MU
    muestreo = F(consultas+1, 2**bits)*h
    largo = F(consultas+1, 2**bits)*tail
    total = min(F(1), grafo+campo+muestreo+largo)
    return {**datos, "bits_grinding": bits, "consultas_adversario": consultas,
            "masa_maxima_extension": fraccion(MU), "omision_condicional": fraccion(h),
            "cola_muestreo": fraccion(tail), "perdida_grafo": fraccion(grafo),
            "perdida_campo": fraccion(campo), "perdida_consultas": fraccion(muestreo),
            "perdida_ejecucion_larga": fraccion(largo), "cota_rom": fraccion(total),
            "cota_rom_superior": decimal_superior(total, 12), "cota_vacia": total == 1}


class RegistroOraculo:
    """Modelo observable para probar el extractor; sus respuestas por defecto son SHA3."""
    def __init__(self, responder=None):
        self.responder = responder or (lambda entrada: sha3_256(entrada).digest())
        self.tabla = {}
        self.preimagenes = {}
        self.etiquetas = set()
        self.eventos = []

    def marcar_prueba(self, etiquetas):
        for etiqueta in etiquetas:
            if len(etiqueta) != 32:
                raise ValueError("Etiqueta con longitud incorrecta")
            self.etiquetas.add(etiqueta)

    def consultar(self, entrada):
        if entrada in self.tabla:
            return self.tabla[entrada]
        # Ventanas del propio mensaje se marcan antes de recibir la respuesta.
        if len(entrada) <= 79:
            self.etiquetas.update(entrada[j:j+32] for j in range(max(0, len(entrada)-31)))
        respuesta = self.responder(entrada)
        if len(respuesta) != 32:
            raise ValueError("El modelo usa salidas de 256 bits")
        if respuesta in self.etiquetas:
            self.eventos.append({"consulta": len(self.tabla)+1, "tipo": "colision_o_referencia_adelantada"})
        self.tabla[entrada] = respuesta
        self.preimagenes.setdefault(respuesta, entrada)
        self.etiquetas.add(respuesta)
        return respuesta

    def extraer(self, raiz, n):
        if n < 1 or n & (n-1):
            raise ValueError("Tamaño Merkle inválido")
        def recorrer(digest, tamano):
            entrada = self.preimagenes.get(digest, b"")
            if tamano == 1:
                if len(entrada) == 17 and entrada[0] == 0:
                    a = int.from_bytes(entrada[1:9], "little")
                    b = int.from_bytes(entrada[9:17], "little")
                    if a < P and b < P:
                        return [(a, b)]
                return [(0, 0)]
            if len(entrada) == 65 and entrada[0] == 1:
                return recorrer(entrada[1:33], tamano//2) + recorrer(entrada[33:65], tamano//2)
            return [(0, 0)]*tamano
        # La lista es una instantánea: futuras consultas no la modifican.
        return recorrer(raiz, n)


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument("--salida", type=Path)
    args = parser.parse_args()
    datos = {"fecha": "2026-09-23", "protocolo": "NEXUS-TG2-LINKED-FRI-v1",
             "modelo": "ROM clásico, una prueba final, consultas del adversario incluidas las de preparación",
             "estado": "Derivación propuesta pendiente de revisión independiente",
             "limite": "No es una reducción QROM ni una prueba incondicional de SHA3",
             "perfiles": [cota(t, g, q) for t in [2**i for i in range(4, 13)]
                           for g in [12, 20] for q in [0, 2**10, 2**20, 2**24, 2**28, 2**32]]}
    contenido = json.dumps(datos, ensure_ascii=False, indent=2)+"\n"
    if args.salida:
        args.salida.parent.mkdir(parents=True, exist_ok=True)
        with args.salida.open("x", encoding="utf-8", newline="\n") as archivo:
            archivo.write(contenido)
        print(f"Guardados {len(datos['perfiles'])} escenarios ROM")
    else:
        print(contenido, end="")


if __name__ == "__main__":
    main()
