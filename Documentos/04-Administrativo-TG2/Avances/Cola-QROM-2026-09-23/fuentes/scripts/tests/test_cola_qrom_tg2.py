"""Contrastes exactos de la cota de cola y de sus hipótesis estructurales."""
from fractions import Fraction as F
from hashlib import sha256
from math import comb, isqrt
from pathlib import Path
import json
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from analizar_cola_qrom_tg2 import (cota_cola_exacta, cota_cola_diadica, frobenius_bloque,
                                  testigo_cola_registrada, perfil, escenarios)
from extraer_base_qrom_tg2 import BaseConsultas

RAIZ = Path(__file__).resolve().parents[2]
PAQUETE = RAIZ/'Documentos/04-Administrativo-TG2/Avances/Cola-QROM-2026-09-23'


def cadena(indices):
    entrada = b'A'*32+b'\x05'+(8).to_bytes(8, 'little')+bytes(8)
    estado = b'S'*32
    tabla = {entrada: estado}
    for j, indice in enumerate(indices):
        salida = indice.to_bytes(8, 'little')+(j+1).to_bytes(8, 'little')+b'Z'*16
        tabla[estado+b'I'] = salida
        estado = salida
    return BaseConsultas(tabla), entrada


def matriz(d, fase):
    signo = lambda y: 1-2*((fase & y).bit_count() % 2)
    raiz = isqrt(d)
    if raiz*raiz != d:
        raise ValueError('Este contraste requiere raíz entera')
    if fase == 0:
        return [[F(i == j) for j in range(d+1)] for i in range(d+1)]
    filas = []
    for u in range(d+1):
        fila = []
        for r in range(d+1):
            if u == r == d:
                valor = F(0)
            elif u == d or r == d:
                valor = F(signo(r if u == d else u), raiz)
            else:
                valor = F(signo(u) if u == r else 0)+F(1-signo(u)-signo(r), d)
            fila.append(valor)
        filas.append(fila)
    return filas


class ColaQrom(unittest.TestCase):
    def test_parametros_invalidos(self):
        for args in [(63, 40, 512, 600), (64, 1, 512, 600), (64, 65, 512, 600),
                     (64, 40, 39, 600), (64, 40, 512, -1), (64, 40, 512.0, 600)]:
            with self.assertRaises(ValueError):
                cota_cola_exacta(*args)

    def test_soporte_insuficiente(self):
        self.assertEqual(cota_cola_exacta(64, 40, 512, 511), 0)
        self.assertTrue(cota_cola_diadica(64, 40, 512, 511)['cero'])

    def test_formula_de_conteo(self):
        esperado = comb(64, 2)*comb(12, 10)**2*F(12, 64)**10
        self.assertEqual(cota_cola_exacta(64, 3, 10, 12), min(F(1), esperado))
        self.assertLess(esperado, 1)

    def test_redondeo_superior_exacto(self):
        for m in (8, 16, 64, 256):
            for r in (3, 6, 12, 20):
                for l in (r-1, r, r+3, 2*r):
                    exacta = cota_cola_exacta(m, 3, r, l)
                    dato = cota_cola_diadica(m, 3, r, l)
                    if dato['cero']:
                        self.assertEqual(exacta, 0)
                    else:
                        e = dato['exponente_superior']
                        superior = F(1, 2**(-e))
                        self.assertGreaterEqual(superior, exacta)
                        if superior < 1:
                            self.assertGreater(exacta, superior/2)

    def test_1792_bloques_con_suma_directa(self):
        d = 8
        for mascara in range(2**d):
            b = {y for y in range(d) if mascara >> y & 1}
            for fase in range(1, d):
                signo = lambda y: 1-2*((fase & y).bit_count() % 2)
                directa = F(len(b), d)+sum(F((1-signo(u)-signo(r))**2, d*d)
                                          for u in b for r in range(d) if r not in b)
                self.assertEqual(frobenius_bloque(d, b, fase), directa)
                self.assertLessEqual(directa, F(6*len(b), d))

    def test_matriz_compresion_unitaria_20_fases(self):
        for d in (4, 16):
            for fase in range(d):
                u = matriz(d, fase)
                for i in range(d+1):
                    for j in range(d+1):
                        producto = sum(u[i][k]*u[j][k] for k in range(d+1))
                        self.assertEqual(producto, i == j)

    def test_escalera_binomial(self):
        alfa = F(1, 3)
        valores = [F(1)]+[F(0)]*9
        for t in range(1, 10):
            valores = [F(1)]+[valores[k]+alfa*valores[k-1] for k in range(1, 10)]
            for k in range(10):
                self.assertEqual(valores[k], comb(t, k)*alfa**k if k <= t else 0)

    def test_bloque_coherente_no_es_probabilidad_clasica(self):
        # Una sola fila: Frobenius y norma de operador coinciden.
        valor = frobenius_bloque(16, {1}, 1)
        self.assertEqual(valor, F(6, 16)-F(9, 256))
        self.assertGreater(valor, F(1, 16))

    def test_cola_anclada_de_1024_respuestas(self):
        base, entrada = cadena([0]*1024)
        resultado = testigo_cola_registrada(base, entrada, 64, corte=1024)
        self.assertEqual(resultado, {'R': 1024, 'entradas_distintas': 1024,
                                    'salidas_distintas': 1024, 'indices': [0], 'cantidad_indices': 1})

    def test_ciclo_sin_ancla_no_satisface_hipotesis(self):
        s = b'S'*32
        base = BaseConsultas({s+b'I': s})
        self.assertFalse(base.colisiones)
        entrada = b'A'*32+b'\x05'+(8).to_bytes(8, 'little')+bytes(8)
        with self.assertRaisesRegex(ValueError, 'absorción'):
            testigo_cola_registrada(base, entrada, 64)

    def test_anclar_el_ciclo_crea_colision(self):
        base, entrada = cadena([])
        s = base.tabla[entrada]
        base = BaseConsultas({**base.tabla, s+b'I': s})
        with self.assertRaisesRegex(ValueError, 'colisiones'):
            testigo_cola_registrada(base, entrada, 64)

    def test_completar_en_el_corte_no_es_cola(self):
        base, entrada = cadena(range(40))
        self.assertIsNone(testigo_cola_registrada(base, entrada, 64, corte=40))

    def test_ausencia_no_es_cola(self):
        base, entrada = cadena([0]*20)
        self.assertIsNone(testigo_cola_registrada(base, entrada, 64, corte=40))

    def test_144_perfiles_reproducidos(self):
        datos = json.loads((PAQUETE/'calculos.json').read_text(encoding='utf8'))
        self.assertEqual(escenarios(), datos['perfiles'])
        self.assertEqual(len(datos['perfiles']), 144)
        self.assertEqual(sum(p['exponente_superior'] < 0 for p in datos['perfiles']), 16)
        self.assertTrue(all(p['beta_omision'] is None and p['cota_aceptacion_completa'] is None
                            for p in datos['perfiles']))

    def test_presupuesto_y_limite_a_512(self):
        for r in (512, 16384, 65536):
            p = perfil(4096, 1024, r)
            self.assertEqual(p['V'], 24383+r)
            self.assertEqual(p['L'], 1024+p['V'])
        self.assertEqual(perfil(4096, 1024, 512)['cota'], '1')
        self.assertEqual(perfil(4096, 1024, 16384)['cota'], '2^-19302')

    def test_fuente_identificada_y_huellas(self):
        carpeta = PAQUETE/'bibliografia'
        fuente = json.loads((carpeta/'fuentes.json').read_text(encoding='utf8'))['fuentes'][0]
        self.assertEqual(fuente['paginas'], 33)
        self.assertIn('2010.11658v4', fuente['portada'])
        for archivo, digest in [('pdf', 'sha256_pdf'), ('texto', 'sha256_texto')]:
            self.assertEqual(sha256((carpeta/fuente[archivo]).read_bytes()).hexdigest(), fuente[digest])


if __name__ == '__main__':
    unittest.main(verbosity=2)
