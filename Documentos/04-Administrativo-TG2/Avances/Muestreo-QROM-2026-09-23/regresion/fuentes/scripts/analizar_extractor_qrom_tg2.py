"""Cota del evento de escape AIR/FRI en la base comprimida; no es solidez completa."""
from argparse import ArgumentParser
from fractions import Fraction as F
from pathlib import Path
from hashlib import sha3_256
import json

from analizar_rbr_conjunto_tg2 import fraccion, decimal_superior
from analizar_transferencia_rom_tg2 import MU, limites
from analizar_qrom_tg2 import hashes_prefijo
from extraer_base_qrom_tg2 import BaseConsultas, extraer_canal, siguiente_reto
from verificar_certificados_tg2 import leer_certificado, verificar, HashMedido, Rechazo
from auditar_merkle_fs_r4 import P

RAIZ = Path(__file__).resolve().parents[1]
CORPUS = RAIZ/"Documentos/06-Evidencia-TG2/2026-09-22/R4-FRI-vinculado"


class RegistroSinOrden(HashMedido):
    """Instrumentación clásica del corpus para construir una base de contraste."""
    def __init__(self):
        super().__init__()
        self.tabla, self.trabajo = {}, None

    def __call__(self, entrada):
        salida = super().__call__(entrada)
        self.tabla[entrada] = salida
        if len(entrada) == 41:
            self.trabajo = entrada
        return salida


def cota_escape(t, presupuesto):
    if not isinstance(presupuesto, int) or presupuesto < 0:
        raise ValueError("El presupuesto debe ser un entero no negativo")
    n = limites(t)["N"]
    epsilon = (n//2)*MU
    inestabilidad = epsilon+F(49*presupuesto+1, 2**256)
    campo = 6*presupuesto**2*epsilon
    grafo = F(6*presupuesto**2*(49*presupuesto+1), 2**256)
    cota = min(F(1), campo+grafo)
    return {"T": t, "L": presupuesto, "epsilon_campo": fraccion(epsilon),
            "inestabilidad_cota": fraccion(inestabilidad), "termino_campo": fraccion(campo),
            "termino_colision_estabilidad": fraccion(grafo), "cota_base_comprimida": fraccion(cota),
            "cota_superior": decimal_superior(cota, 40), "vacia": cota == 1}


def auditar_certificado(ruta):
    prueba, registro = leer_certificado(ruta), RegistroSinOrden()
    try:
        verificar(prueba, prueba["bits"], registro)
        acepta, motivo = True, None
    except Rechazo as error:
        acepta, motivo = False, str(error)
    if registro.trabajo is None:
        raise RuntimeError("El certificado no llegó al trabajo")
    base = BaseConsultas(registro.tabla)
    sigma = registro.trabajo[:32]
    transcripcion = extraer_canal(base, sigma, prueba["T"], prueba["bits"])
    if transcripcion is None or len(transcripcion.pasos) != hashes_prefijo(prueba["T"]):
        raise RuntimeError("No se reconstruyó el prefijo completo")
    if transcripcion.enunciado != (prueba["inicio"], prueba["salida"], prueba["T"]):
        raise RuntimeError("Enunciado extraído diferente")
    invertida = BaseConsultas(dict(reversed(list(registro.tabla.items()))))
    if extraer_canal(invertida, sigma, prueba["T"], prueba["bits"]) != transcripcion:
        raise RuntimeError("La extracción depende del orden")
    retos = []
    # Solo hace falta la gramática para cotejar los valores de alpha y beta.
    for paso in transcripcion.pasos:
        if paso.etiqueta == -2:
            previo = extraer_canal(base, paso.entrada[:32], prueba["T"], prueba["bits"], incluir_vectores=False)
            rol = siguiente_reto(previo)
            if rol is None:
                raise RuntimeError("Un reto no tiene prefijo válido")
            valor = (int.from_bytes(paso.salida[:16], 'little') % P,
                     int.from_bytes(paso.salida[16:], 'little') % P)
            retos.append({"rol": rol[0], "indice": rol[1], "valor": valor})
    aperturas = 0
    # Todas las hojas efectivamente hasheadas por el verificador deben extraerse.
    for raiz in transcripcion.oraculos:
        valores = raiz.valores
        for indice, valor in enumerate(valores):
            if valor != (0, 0):
                hoja = b'\x00'+b''.join(v.to_bytes(8, 'little') for v in valor)
                if sha3_256(hoja).digest() not in base.inverso:
                    raise RuntimeError("Valor sin preimagen registrada")
        if raiz.rol == "traza-inicial":
            # Cotejo independiente con las aperturas AIR alcanzadas por verificar.
            canal_indices = []
            estado = sha3_256(registro.trabajo[:32]+b'\x05'+(8).to_bytes(8, 'little')+prueba["nonce"].to_bytes(8, 'little')).digest()
            for _ in range(512):
                estado = sha3_256(estado+b'I').digest()
                i = int.from_bytes(estado[:8], 'little') & (4*prueba["T"]-1)
                if i not in canal_indices:
                    canal_indices.append(i)
                if len(canal_indices) == 40:
                    break
            if len(canal_indices) != 40:
                raise RuntimeError("Muestreo fuera del corpus acotado")
            for i, consulta in zip(canal_indices, prueba["consultas"]):
                posiciones = [i, (i+8) % (8*prueba["T"]), (i+16) % (8*prueba["T"])]
                posiciones += [(j+4*prueba["T"]) % (8*prueba["T"]) for j in posiciones]
                for pos, punto in zip(posiciones, consulta["traza"]):
                    # Si el verificador rechazó antes de esta apertura, puede faltar.
                    acumulado = sha3_256(b'\x00'+punto["valor"].to_bytes(8, 'little')+bytes(8)).digest()
                    visto, lugar = acumulado in base.inverso, pos
                    for hermano in punto["camino"]:
                        entrada = b'\x01'+(hermano+acumulado if lugar & 1 else acumulado+hermano)
                        acumulado = sha3_256(entrada).digest()
                        visto = visto and entrada in base.tabla
                        lugar >>= 1
                    if visto and acumulado == raiz.raiz:
                        if valores[pos] != (punto["valor"], 0):
                            raise RuntimeError("Apertura AIR diferente de la extracción")
                        aperturas += 1
    return {"archivo": ruta.relative_to(RAIZ).as_posix(), "T": prueba["T"], "bits": prueba["bits"],
            "acepta": acepta, "motivo": motivo, "consultas_distintas": len(base.tabla),
            "colisiones": base.colisiones, "pasos_prefijo": len(transcripcion.pasos),
            "oraculos_extraidos": len(transcripcion.oraculos), "retos": retos,
            "aperturas_air_cotejadas": aperturas, "invariante_al_invertir_orden": True}


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument("--salida", type=Path, required=True)
    args = parser.parse_args()
    registros = [auditar_certificado(p) for p in sorted(CORPUS.glob("corpus-*/*.bin"))]
    datos = {"fecha": "2026-09-23", "estado": "Q1 propuesto y escape de campo en base comprimida; muestreo y salida real pendientes",
             "perfiles": [cota_escape(2**i, l) for i in range(4, 13) for l in (0, 2**10, 2**20, 2**32, 2**40)],
             "corpus": registros, "fuente": "CMS19, lemas 5.9, 5.10 y analogía con 8.8; versión 2020-01-14",
             "limites": ["No es una cota de aceptación del verificador", "La regla de escape AIR/FRI se define matemáticamente, no se decide exhaustivamente en estos scripts",
                         "El extractor termina antes del nonce y de los índices", "La tabla del corpus es instrumentación clásica, no medición de consultas de un adversario cuántico"]}
    args.salida.parent.mkdir(parents=True, exist_ok=True)
    with args.salida.open("x", encoding="utf8", newline="\n") as archivo:
        json.dump(datos, archivo, ensure_ascii=False, indent=2)
        archivo.write("\n")
    print(json.dumps({"perfiles": len(datos["perfiles"]), "certificados": len(registros),
                      "retos": sum(len(r["retos"]) for r in registros),
                      "aperturas_air": sum(r["aperturas_air_cotejadas"] for r in registros)}))


if __name__ == "__main__":
    main()
