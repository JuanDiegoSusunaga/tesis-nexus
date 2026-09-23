"""Muestreo sin orden, expansión acotada y controles del puente de juegos."""
from copy import deepcopy
from dataclasses import replace
from fractions import Fraction as F
from itertools import product
from pathlib import Path
from unittest.mock import patch
import json
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from extraer_base_qrom_tg2 import BaseConsultas
from muestreo_base_qrom_tg2 import recorrer_indices, extraer_muestreo, parejas_buenas
from expandir_verificador_qrom_tg2 import expandir, repetir_expansion, ConsultaAusente
from analizar_muestreo_qrom_tg2 import auditar, datos_puente, cota_condicional, raiz_superior, racional
from analizar_extractor_qrom_tg2 import CORPUS
from analizar_transferencia_rom_tg2 import limites
from verificar_certificados_tg2 import leer_certificado

RAIZ = Path(__file__).resolve().parents[2]
PAQUETE = RAIZ/'Documentos/04-Administrativo-TG2/Avances/Muestreo-QROM-2026-09-23'


def cadena(indices):
    estado, tabla = b's'*32, {}
    for paso, i in enumerate(indices):
        salida = i.to_bytes(8, 'little')+(paso+1).to_bytes(8, 'little')+b'X'*16
        tabla[estado+b'I'] = salida
        estado = salida
    return BaseConsultas(tabla), b's'*32


def ejemplo():
    prueba = leer_certificado(CORPUS/'corpus-debug/honesto-16.bin')
    expansion = expandir(prueba, 12)
    base = BaseConsultas(expansion.tabla())
    sigma = next(x[:32] for x in base.tabla if len(x) == 41)
    return prueba, expansion, base, sigma


class MuestreoQrom(unittest.TestCase):
    def test_256_secuencias_con_distintos_y_duplicados(self):
        for secuencia in product(range(4), repeat=4):
            base, semilla = cadena(secuencia)
            resultado = recorrer_indices(base, semilla, 4, q=3, corte=4)
            vistos, consumidos = [], 0
            for i in secuencia:
                consumidos += 1
                if i not in vistos:
                    vistos.append(i)
                if len(vistos) == 3:
                    break
            self.assertEqual(resultado.indices, tuple(vistos))
            self.assertEqual(len(resultado.pasos), consumidos)
            self.assertEqual(resultado.estado, 'completo' if len(vistos) == 3 else 'cola')

    def test_terminar_en_el_corte_no_es_cola(self):
        base, semilla = cadena([0, 0, 1, 2])
        r = recorrer_indices(base, semilla, 4, q=3, corte=4)
        self.assertEqual((r.estado, len(r.pasos)), ('completo', 4))

    def test_ciclo_y_ausencia_tienen_resultados_distintos(self):
        s = b's'*32
        base = BaseConsultas({s+b'I': s})
        r = recorrer_indices(base, s, 64, corte=512)
        self.assertEqual((r.estado, len(r.pasos), len(r.indices)), ('cola', 512, 1))
        r = recorrer_indices(BaseConsultas({}), s, 64)
        self.assertEqual((r.estado, len(r.pasos)), ('incompleto', 0))

    def test_sufijo_exige_trabajo_y_semilla_distintos(self):
        p, _, base, sigma = ejemplo()
        trabajo = next(x for x in base.tabla if len(x) == 41)
        semilla = next(x for x in base.tabla if len(x) == 49)
        self.assertNotEqual(trabajo, semilla)
        for eliminado in (trabajo, semilla):
            parcial = BaseConsultas({x:y for x,y in base.tabla.items() if x != eliminado})
            self.assertIsNone(extraer_muestreo(parcial, sigma, p['nonce'], 16, 12))
        invalido = BaseConsultas({**base.tabla, trabajo: b'\xff'*32})
        self.assertIsNone(extraer_muestreo(invalido, sigma, p['nonce'], 16, 12))

    def test_sufijo_orden_y_consultas_locales(self):
        p, _, base, sigma = ejemplo()
        muestra = extraer_muestreo(base, sigma, p['nonce'], 16, 12)
        invertida = BaseConsultas(dict(reversed(list(base.tabla.items()))))
        self.assertEqual(muestra, extraer_muestreo(invertida, sigma, p['nonce'], 16, 12))
        self.assertEqual(len(muestra.recorrido.indices), 40)
        self.assertGreater(len(muestra.recorrido.pasos), 40)
        buenas = parejas_buenas(muestra.prefijo)
        self.assertLessEqual(set(muestra.recorrido.indices), buenas)

    def test_repeticion_no_consulta_sha3(self):
        p, expansion, _, _ = ejemplo()
        with patch('expandir_verificador_qrom_tg2.sha3_256', side_effect=AssertionError('Consulta nueva a SHA3')):
            self.assertEqual(repetir_expansion(p, 12, expansion), expansion)

    def test_respuesta_ausente_impide_repeticion(self):
        p, expansion, _, _ = ejemplo()
        quitar = next(x for x, _ in expansion.pares if len(x) == 41)
        pares = tuple(par for par in expansion.pares if par[0] != quitar)
        alterada = replace(expansion, pares=pares+(expansion.pares[0],)*(expansion.maximo-len(pares)))
        with self.assertRaises(ConsultaAusente):
            repetir_expansion(p, 12, alterada)

    def test_respuestas_inconsistentes_rechazan(self):
        p, expansion, _, _ = ejemplo()
        x, y = expansion.pares[0]
        otro = y[:-1]+bytes([y[-1] ^ 1])
        alterada = replace(expansion, pares=expansion.pares[:-1]+((x, otro),))
        with self.assertRaisesRegex(ValueError, 'dos respuestas'):
            repetir_expansion(p, 12, alterada)

    def test_rechazo_previo_tiene_relleno_acotado(self):
        p, _, _, _ = ejemplo()
        p = deepcopy(p)
        p['consultas'] = []
        expansion = expandir(p, 12)
        self.assertEqual((expansion.resultado, expansion.llamadas), ('rechaza', 1))
        self.assertFalse(expansion.gana_ampliado)
        self.assertEqual(len(expansion.pares), expansion.maximo)
        self.assertEqual(len(expansion.tabla()), 1)
        repetir_expansion(p, 12, expansion)

    def test_cola_512_con_oraculo_artificial_no_es_aceptacion_rust(self):
        p, _, base, sigma = ejemplo()
        tabla = dict(base.tabla)
        estado = tabla[next(x for x in tabla if len(x) == 49)]
        for j in range(512):
            salida = bytes(8)+(j+1).to_bytes(8, 'little')+b'Z'*16
            tabla[estado+b'I'] = salida
            estado = salida
        expansion = expandir(p, 12, tabla=tabla)
        self.assertEqual(expansion.resultado, 'cola')
        self.assertTrue(expansion.gana_ampliado)
        self.assertEqual(expansion.extracciones, 512)
        muestra = extraer_muestreo(BaseConsultas(expansion.tabla()), sigma, p['nonce'], 16, 12)
        self.assertEqual((muestra.recorrido.estado, len(muestra.recorrido.indices)), ('cola', 1))
        repetir_expansion(p, 12, expansion)

    def test_presupuestos_y_parametro_pendiente(self):
        for k in range(4, 13):
            for corte in (40, 512):
                p = datos_puente(2**k, 1024, corte)
                self.assertEqual(p['V'], limites(2**k)['hashes_verificador_maximos']-512+corte)
                self.assertEqual(p['L'], 1024+p['V'])
                self.assertEqual(racional(p['correccion_salida_al_cuadrado']), F(p['V'], 2**256))
                self.assertIsNone(p['beta_muestreo'])
                self.assertIsNone(p['cota_aceptacion_completa'])
        self.assertEqual(datos_puente(4096, 0)['V'], 24895)

    def test_raiz_superior_y_calculo_condicional(self):
        for valor in (F(0), F(1, 4), F(2), F(1, 2**256), F(7, 19)):
            r = raiz_superior(valor)
            self.assertGreaterEqual(r*r, valor)
            if r:
                self.assertLess((r-F(1, 10**100))**2, valor)
        self.assertEqual(racional(cota_condicional(4096, 1024, F(1))['cota_condicional']), 1)
        previo = F(0)
        for beta in (F(0), F(1, 2**80), F(1, 2**40), F(1, 2**20), F(1)):
            r = racional(cota_condicional(4096, 1024, beta)['cota_condicional'])
            self.assertGreaterEqual(r, previo)
            previo = r

    def test_parametros_invalidos_no_se_extrapolan(self):
        p, _, base, sigma = ejemplo()
        for corte in (39, 513):
            with self.assertRaises(ValueError):
                expandir(p, 12, corte)
            with self.assertRaises(ValueError):
                extraer_muestreo(base, sigma, p['nonce'], 16, 12, corte)
        with self.assertRaises(ValueError):
            cota_condicional(16, 0, F(-1))
        with self.assertRaises(ValueError):
            extraer_muestreo(base, sigma, 2**64, 16, 12)

    def test_28_recorridos_y_72_presupuestos_archivados(self):
        datos = json.loads((PAQUETE/'calculos.json').read_text(encoding='utf8'))
        corpus = [auditar(p, r) for r in (40, 512) for p in sorted(CORPUS.glob('corpus-*/*.bin'))]
        self.assertEqual(json.loads(json.dumps(corpus)), datos['corpus'])
        self.assertEqual(len(datos['perfiles']), 72)
        for p in datos['perfiles']:
            self.assertEqual(p, datos_puente(p['T'], p['Q'], p['R']))
        for corte, esperados in [(40, (2, 0, 12)), (512, (8, 6, 0))]:
            cuentas = tuple(sum(r['R'] == corte and r['resultado_acotado'] == e for r in corpus)
                           for e in ('acepta', 'rechaza', 'cola'))
            self.assertEqual(cuentas, esperados)


if __name__ == '__main__':
    unittest.main(verbosity=2)
