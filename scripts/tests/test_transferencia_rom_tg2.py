"""Pruebas finitas del modelo ROM y correspondencia independiente con el corpus Rust."""
from copy import deepcopy
from fractions import Fraction as F
from hashlib import sha3_256
from itertools import permutations, product
from math import comb
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from analizar_transferencia_rom_tg2 import MU, P, RegistroOraculo, cola, cota, limites
from analizar_rbr_conjunto_tg2 import omision
from verificar_certificados_tg2 import leer_certificado, verificar, Rechazo, HashMedido, codificar

RAIZ = Path(__file__).resolve().parents[2]
CORPUS = RAIZ/'Documentos/06-Evidencia-TG2/2026-09-22/R4-FRI-vinculado'


def fraccion(entrada):
    return F(int(entrada['numerador']), int(entrada['denominador']))


class TransferenciaRom(unittest.TestCase):
    def test_cuentas_de_todos_los_perfiles(self):
        for i in range(4, 13):
            t = 2**i
            datos = limites(t)
            n, kt, kc = 8*t, i, i+1
            caminos = 0
            hojas = 0
            for _ in range(40):
                for _ in range(6):
                    caminos += n.bit_length()-1
                    hojas += 1
                for k in (kt, kc):
                    for j in range(k):
                        caminos += 2*((n >> j).bit_length()-1)
                        hojas += 2
            self.assertEqual(datos['etiquetas_prueba'], 1+kt+kc+caminos)
            self.assertEqual(datos['hashes_merkle'], caminos+hojas)
            self.assertEqual(datos['hashes_verificador_maximos'], caminos+hojas+13+2*(kt+kc)+512)
        self.assertEqual(limites(4096)['etiquetas_prueba'], 22106)
        self.assertEqual(limites(4096)['hashes_verificador_maximos'], 24895)

    def test_cota_y_dependencia_del_presupuesto(self):
        for t in [16, 64, 256, 4096]:
            previa = F(0)
            for q in [0, 2**10, 2**20, 2**24, 2**28, 2**32]:
                datos = cota(t, 20, q)
                suma = sum(fraccion(datos[k]) for k in ['perdida_grafo', 'perdida_campo',
                            'perdida_consultas', 'perdida_ejecucion_larga'])
                valor = fraccion(datos['cota_rom'])
                self.assertEqual(valor, min(F(1), suma))
                self.assertGreaterEqual(valor, previa)
                self.assertGreaterEqual(F(datos['cota_rom_superior']), valor)
                self.assertLessEqual(valor, fraccion(cota(t, 12, q)['cota_rom']))
                previa = valor
        self.assertTrue(cota(4096, 20, 2**28)['cota_vacia'])

    def test_masa_maxima_en_extension(self):
        self.assertGreaterEqual(MU, F(1, P*P))
        self.assertLess(MU, 2*F(1, P*P))
        for bits in range(2, 6):
            s = 2**bits
            for p in [3, 5, 7]:
                masa = F(s//p+1, s)**2 if s % p else F(1, p*p)
                cuentas = {}
                for a, b in product(range(s), repeat=2):
                    elemento = (a % p, b % p)
                    cuentas[elemento] = cuentas.get(elemento, 0)+1
                self.assertEqual(max(F(v, s*s) for v in cuentas.values()), masa)

    def test_cola_por_enumeracion_exhaustiva(self):
        for m in range(2, 5):
            for q in range(1, m+1):
                for r in range(0, 7):
                    casos = list(product(range(m), repeat=r))
                    exacta = F(sum(len(set(s)) < q for s in casos), len(casos))
                    self.assertLessEqual(exacta, cola(m, q, r))
        for i in range(4, 13):
            self.assertLess(cola(4*2**i, 40, 512), F(1, 2**300))

    def test_grinding_ambos_ordenes_de_busqueda(self):
        # Dos candidatos; g=2, cuatro parejas, dos consultas, una pareja mala.
        candidatos = list(product(range(4), permutations(range(4), 2)))
        exitos_pow_primero = exitos_consulta_primero = 0
        for primero, segundo in product(candidatos, repeat=2):
            candidatos_par = [primero, segundo]
            exitos_pow_primero += any(pow_ == 0 and 0 not in muestra for pow_, muestra in candidatos_par)
            exitos_consulta_primero += any(0 not in muestra and pow_ == 0 for pow_, muestra in candidatos_par)
        individual = F(1, 4)*omision(4, 2, F(1, 4))
        exacta = 1-(1-individual)**2
        self.assertEqual(F(exitos_pow_primero, len(candidatos)**2), exacta)
        self.assertEqual(exitos_pow_primero, exitos_consulta_primero)
        self.assertLessEqual(exacta, 2*individual)

    def test_extraccion_previa_y_repeticion(self):
        oracle = RegistroOraculo()
        valores = [(3, 7), (5, 2), (9, 0), (11, 8)]
        hojas = [oracle.consultar(b'\x00'+codificar(v)) for v in valores]
        izquierda = oracle.consultar(b'\x01'+hojas[0]+hojas[1])
        derecha = oracle.consultar(b'\x01'+hojas[2]+hojas[3])
        raiz = oracle.consultar(b'\x01'+izquierda+derecha)
        extraido = oracle.extraer(raiz, 4)
        self.assertEqual(extraido, valores)
        consultas = len(oracle.tabla)
        self.assertEqual(oracle.consultar(b'\x01'+izquierda+derecha), raiz)
        self.assertEqual(len(oracle.tabla), consultas)
        oracle.consultar(b'otro contexto')
        self.assertEqual(extraido, valores)
        self.assertFalse(oracle.eventos)
        self.assertLessEqual(len(oracle.etiquetas), 49*len(oracle.tabla))

    def test_referencia_futura_no_es_extraccion_gratuita(self):
        oracle = RegistroOraculo()
        a, b = (3, 0), (9, 0)
        hoja_a = oracle.consultar(b'\x00'+codificar(a))
        # Se coloca deliberadamente una respuesta futura conocida por la prueba.
        hoja_b = sha3_256(b'\x00'+codificar(b)).digest()
        raiz = oracle.consultar(b'\x01'+hoja_a+hoja_b)
        extraido = oracle.extraer(raiz, 2)
        self.assertEqual(extraido, [a, (0, 0)])
        oracle.consultar(b'\x00'+codificar(b))
        self.assertEqual(len(oracle.eventos), 1)
        self.assertEqual(extraido, [a, (0, 0)])

    def test_colision_y_etiquetas_de_la_prueba(self):
        oracle = RegistroOraculo(lambda _: b'c'*32)
        oracle.consultar(b'primera entrada')
        oracle.consultar(b'segunda entrada')
        self.assertEqual(len(oracle.eventos), 1)
        marcado = RegistroOraculo(lambda _: b'r'*32)
        marcado.marcar_prueba([b'r'*32])
        marcado.consultar(b'raiz no consultada antes')
        self.assertEqual(len(marcado.eventos), 1)

    def test_codificaciones_nonce_disjuntas(self):
        estado, nonce = b'e'*32, (1).to_bytes(8, 'little')
        trabajo = estado+b'\x05'+nonce
        absorcion = estado+b'\x05'+len(nonce).to_bytes(8, 'little')+nonce
        self.assertEqual(len(trabajo), 41)
        self.assertEqual(len(absorcion), 49)
        self.assertNotEqual(trabajo, absorcion)
        self.assertNotEqual(estado+b'E', estado+b'I')

    def test_corpus_completo_coincide_con_rust(self):
        aceptados = rechazados = 0
        for modo, bits in [('debug', 12), ('release', 20)]:
            for ruta in sorted((CORPUS/f'corpus-{modo}').glob('*.bin')):
                prueba = leer_certificado(ruta)
                if ruta.name.startswith('honesto-'):
                    resultado = verificar(prueba, bits)
                    self.assertTrue(resultado['acepta'])
                    self.assertLessEqual(resultado['hashes'], limites(prueba['T'])['hashes_verificador_maximos'])
                    aceptados += 1
                else:
                    with self.assertRaisesRegex(Rechazo, '^fri_traza$'):
                        verificar(prueba, bits)
                    rechazados += 1
        self.assertEqual((aceptados, rechazados), (8, 6))

    def test_mutaciones_rechazadas_antes_de_aceptar(self):
        original = leer_certificado(CORPUS/'corpus-debug/honesto-16.bin')
        cambios = []
        prueba = deepcopy(original)
        prueba['version'] = 2
        cambios.append((prueba, 'perfil'))
        prueba = deepcopy(original)
        prueba['consultas'][0]['traza'][0]['valor'] = P
        cambios.append((prueba, 'no_canonico'))
        prueba = deepcopy(original)
        prueba['fases'][0]['raices'][0] = b'c'*32
        cambios.append((prueba, 'raiz_traza'))
        prueba = deepcopy(original)
        prueba['consultas'][0]['traza'][0]['camino'].pop()
        cambios.append((prueba, 'forma'))
        prueba = deepcopy(original)
        prueba['consultas'][0]['traza'][0]['valor'] ^= 1
        cambios.append((prueba, 'merkle'))
        for prueba, motivo in cambios:
            with self.assertRaisesRegex(Rechazo, '^'+motivo+'$'):
                verificar(prueba, 12)


if __name__ == '__main__':
    unittest.main(verbosity=2)
