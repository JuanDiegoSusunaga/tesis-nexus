"""Revisión interna: decisiones adaptativas, premisas Merkle y gramática real."""
from fractions import Fraction as F
from hashlib import sha3_256
from itertools import product, permutations
from pathlib import Path
from copy import deepcopy
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from analizar_revision_rom_tg2 import (
    acciones, transiciones, potencial, estrategia_optima, ordenes_merkle,
    probabilidad_restante, probabilidad_cola,
)
from analizar_transferencia_rom_tg2 import RegistroOraculo, cola
from verificar_certificados_tg2 import leer_certificado, verificar, HashMedido, Rechazo
from auditar_merkle_fs_r4 import DOMINIO, perfil, u64

RAIZ = Path(__file__).resolve().parents[2]


def racional(datos):
    return F(int(datos["numerador"]), int(datos["denominador"]))


class RevisionRom(unittest.TestCase):
    def test_identidad_del_potencial_en_cada_accion(self):
        for m, buenos, q in [(2, 1, 1), (4, 3, 2), (4, 3, 3), (8, 7, 4)]:
            for bits in (1, 2):
                estados = [(w, True, s) for w in (-1, 0, 1) for s in range(q+1)]
                estados += [(w, False, 0) for w in (-1, 0, 1)]
                for estado in estados:
                    for accion in acciones(estado, q):
                        ramas = transiciones(estado, accion, m, buenos, q, bits)
                        self.assertEqual(sum(p for p, _ in ramas), 1)
                        media = sum(p*potencial(e, m, buenos, q, bits) for p, e in ramas)
                        self.assertEqual(media, potencial(estado, m, buenos, q, bits))

    def test_estrategias_adaptativas_bellman(self):
        escenarios = 0
        for m, buenos, q in [(2, 1, 1), (4, 3, 2), (4, 3, 3)]:
            for bits in (1, 2):
                for capacidad in (2, 3):
                    previo = F(0)
                    for presupuesto in range(8):
                        dato = estrategia_optima(m, buenos, q, bits, presupuesto, capacidad)
                        valor = racional(dato["optimo"])
                        self.assertLessEqual(valor, racional(dato["cota"]))
                        self.assertGreaterEqual(valor, previo)
                        previo = valor
                        escenarios += 1
        self.assertEqual(escenarios, 96)

    def test_un_intento_y_verificacion_gratuita_formula_cerrada(self):
        for bits in (1, 2, 3):
            p = F(1, 2**bits)
            a = p*F(1, 2)
            self.assertEqual(racional(estrategia_optima(2, 1, 1, bits, 0)["optimo"]), a)
            self.assertEqual(racional(estrategia_optima(2, 1, 1, bits, 1)["optimo"]), a*(2-p))

    def test_probabilidad_restante_por_enumeracion(self):
        for vistos in range(3):
            conocidos = set(range(vistos))
            posibles = [x for x in range(4) if x not in conocidos]
            muestras = list(permutations(posibles, 2-vistos))
            exacta = F(sum(3 not in s for s in muestras), len(muestras))
            self.assertEqual(exacta, probabilidad_restante(4, 3, 2, vistos))

    def test_cola_exacta_por_enumeracion_y_cota(self):
        for m in range(2, 5):
            for q in range(1, m+1):
                for r in range(6):
                    exacta = F(sum(len(set(s)) < q for s in product(range(m), repeat=r)), m**r)
                    self.assertEqual(exacta, probabilidad_cola(m, q, r))
                    self.assertLessEqual(exacta, cola(m, q, r))
                    for vistos in range(q):
                        media = F(vistos, m)*probabilidad_cola(m, q, r, vistos)
                        media += F(m-vistos, m)*probabilidad_cola(m, q, r, vistos+1)
                        self.assertEqual(media, probabilidad_cola(m, q, r+1, vistos))

    def test_condicionar_al_nonce_ganador_no_es_cobrar_su_inicio(self):
        universo = list(product(range(4), permutations(range(4), 2)))
        ganadores = [(w, muestra) for w, muestra in universo if w == 0]
        exito_conjunto = F(sum(w == 0 and 3 not in s for w, s in universo), len(universo))
        exito_condicionado = F(sum(3 not in s for _, s in ganadores), len(ganadores))
        self.assertEqual(exito_conjunto, F(1, 8))
        self.assertEqual(exito_condicionado, F(1, 2))
        self.assertGreater(exito_condicionado, exito_conjunto)

    def test_ordenes_merkle_con_raiz_previa(self):
        datos = ordenes_merkle()
        self.assertEqual(datos["ordenes"], 60)
        self.assertEqual(datos["sin_evento_hash"], 2)
        self.assertEqual(datos["discrepancias_sin_evento_hash"], 0)

    def test_premisa_de_raiz_marcada_es_necesaria(self):
        entrada = b"\x00"+u64(9)+u64(0)
        raiz = sha3_256(entrada).digest()
        sin_premisa = RegistroOraculo()
        congelado = sin_premisa.extraer(raiz, 1)
        sin_premisa.consultar(entrada)
        self.assertEqual(congelado, [(0, 0)])
        self.assertEqual(sin_premisa.extraer(raiz, 1), [(9, 0)])
        self.assertFalse(sin_premisa.eventos)
        con_premisa = RegistroOraculo()
        con_premisa.consultar(bytes(32)+b"\x01"+u64(32)+raiz)
        con_premisa.extraer(raiz, 1)
        con_premisa.consultar(entrada)
        self.assertEqual(len(con_premisa.eventos), 1)

    def test_nodo_y_enunciado_pueden_coincidir_sin_evento_hash(self):
        # Es una asignación artificial del oráculo, no un ataque contra SHA3.
        hoja_a = b"\x00"+u64(3)+u64(0)
        hoja_b = b"\x00"+u64(9)+u64(0)
        hijo_i = b"\x77"*31+b"\x04"
        enunciado = u64(3)+u64(9)+u64(16)
        hijo_d = u64(24)+enunciado
        estado_perfil = b"\x01"+hijo_i[:31]
        inicial = sha3_256(DOMINIO).digest()
        datos_perfil = perfil(16, 12)
        entrada_perfil = inicial+b"\x10"+u64(len(datos_perfil))+datos_perfil
        respuestas = {hoja_a: hijo_i, hoja_b: hijo_d, entrada_perfil: estado_perfil}
        oracle = RegistroOraculo(lambda e: respuestas[e] if e in respuestas else sha3_256(e).digest())
        oracle.consultar(DOMINIO)
        oracle.consultar(hoja_a)
        oracle.consultar(hoja_b)
        oracle.consultar(entrada_perfil)
        entrada_nodo = b"\x01"+hijo_i+hijo_d
        entrada_enunciado = estado_perfil+b"\x04"+u64(24)+enunciado
        self.assertEqual(entrada_nodo, entrada_enunciado)
        digest = oracle.consultar(entrada_nodo)
        consultas = len(oracle.tabla)
        self.assertEqual(oracle.consultar(entrada_enunciado), digest)
        self.assertEqual(len(oracle.tabla), consultas)
        self.assertFalse(oracle.eventos)
        self.assertEqual(oracle.extraer(digest, 2), [(3, 0), (9, 0)])

    def test_anticipar_un_estado_de_indices_activa_el_evento(self):
        futuro = b"\x55"*32
        semilla = b"\x66"*32+b"\x05"+u64(8)+u64(1)
        oracle = RegistroOraculo(lambda e: futuro if e == semilla else sha3_256(e).digest())
        oracle.consultar(futuro+b"I")
        oracle.consultar(semilla)
        self.assertEqual(len(oracle.eventos), 1)

    def test_ciclo_y_reutilizacion_de_consultas(self):
        x, y = b"\x21"*32, b"\x32"*32
        respuestas = {b"semilla": x, x+b"I": y, y+b"I": x}
        oracle = RegistroOraculo(lambda e: respuestas[e])
        oracle.consultar(b"semilla")
        oracle.consultar(x+b"I")
        oracle.consultar(x+b"I")
        self.assertEqual(len(oracle.tabla), 2)
        self.assertFalse(oracle.eventos)
        oracle.consultar(y+b"I")
        self.assertEqual(len(oracle.eventos), 1)

    def test_formas_invalidas_rechazan_antes_de_hash(self):
        ruta = RAIZ/"Documentos/06-Evidencia-TG2/2026-09-22/R4-FRI-vinculado/corpus-debug/honesto-16.bin"
        original = leer_certificado(ruta)
        casos = []
        prueba = deepcopy(original)
        prueba["fases"][0]["raices"].extend([b"x"*32]*100)
        casos.append(prueba)
        prueba = deepcopy(original)
        prueba["consultas"][0]["traza"][0]["camino"].extend([b"x"*32]*100)
        casos.append(prueba)
        for prueba in casos:
            hash_funcion = HashMedido()
            with self.assertRaisesRegex(Rechazo, "^forma$"):
                verificar(prueba, 12, hash_funcion)
            self.assertEqual(hash_funcion.total, 0)


if __name__ == "__main__":
    unittest.main(verbosity=2)
