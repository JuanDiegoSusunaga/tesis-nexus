"""Contrastes de extracción sin orden, estabilidad y cota de escape de campo."""
from fractions import Fraction as F
from hashlib import sha3_256
from itertools import permutations
from pathlib import Path
import json
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from extraer_base_qrom_tg2 import BaseConsultas, extraer_canal, esquema, siguiente_reto, ventanas
from analizar_extractor_qrom_tg2 import auditar_certificado, cota_escape, CORPUS
from analizar_transferencia_rom_tg2 import MU
from auditar_merkle_fs_r4 import DOMINIO, P, perfil, u64

RAIZ = Path(__file__).resolve().parents[2]
PAQUETE = RAIZ/"Documentos/04-Administrativo-TG2/Avances/Extractor-QROM-2026-09-23"


def racional(d):
    return F(int(d["numerador"]), int(d["denominador"]))


def arbol_constante(valor, n):
    hoja = b'\x00'+u64(valor)+u64(0)
    digest = sha3_256(hoja).digest()
    tabla = {hoja: digest}
    while n > 1:
        entrada = b'\x01'+digest+digest
        digest = sha3_256(entrada).digest()
        tabla[entrada] = digest
        n //= 2
    return tabla, digest, hoja


def prefijo(raiz=None):
    raiz = raiz or b'r'*32
    estado = sha3_256(DOMINIO).digest()
    tabla = {DOMINIO: estado}
    for tag, datos in [(16, perfil(16, 20)), (4, u64(1)+u64(2)+u64(16)), (1, raiz)]:
        entrada = estado+bytes([tag])+u64(len(datos))+datos
        estado = sha3_256(entrada).digest()
        tabla[entrada] = estado
    return tabla, estado


def propiedad_artificial(base):
    """Regla de prueba: alpha_0 igual a primera hoja; no decide el AIR real."""
    if base.colisiones:
        return False
    for entrada, salida in base.tabla.items():
        if len(entrada) != 33 or entrada[-1:] != b'E':
            continue
        tr = extraer_canal(base, entrada[:32], 16, 20)
        if siguiente_reto(tr) == ("alpha", 0):
            valor = (int.from_bytes(salida[:16], 'little') % P, int.from_bytes(salida[16:], 'little') % P)
            if valor == tr.oraculos[0].valores[0]:
                return True
    return False


class ExtractorQrom(unittest.TestCase):
    def test_base_inmutable_y_orden_independiente(self):
        tabla, sigma = prefijo()
        base = BaseConsultas(tabla)
        esperado = extraer_canal(base, sigma, 16, 20)
        for orden in permutations(tabla.items()):
            self.assertEqual(extraer_canal(BaseConsultas(dict(orden)), sigma, 16, 20), esperado)
        tabla[b'otra'] = b'a'*32
        self.assertNotIn(b'otra', base.tabla)
        with self.assertRaises(TypeError):
            base.tabla[b'otra'] = b'a'*32

    def test_colision_global_impide_extraccion(self):
        tabla, sigma = prefijo()
        base = BaseConsultas({**tabla, b'colision': sigma})
        self.assertTrue(base.colisiones)
        self.assertIsNone(extraer_canal(base, sigma, 16, 20))
        self.assertIsNone(base.merkle(sigma, 2))

    def test_merkle_completa_regiones_ausentes_y_canonicas(self):
        tabla, raiz, hoja = arbol_constante(7, 128)
        self.assertEqual(BaseConsultas(tabla).merkle(raiz, 128), ((7, 0),)*128)
        parcial = BaseConsultas({x:y for x, y in tabla.items() if x != hoja})
        self.assertEqual(parcial.merkle(raiz, 128), ((0, 0),)*128)
        no_canonica = b'\x00'+u64(P)+u64(0)
        base = BaseConsultas({no_canonica: b'z'*32})
        self.assertEqual(base.merkle(b'z'*32, 1), ((0, 0),))

    def test_ciclos_terminan_por_profundidad_o_rechazo(self):
        sigma = b'x'*32
        base = BaseConsultas({b'\x01'+sigma+sigma: sigma})
        self.assertEqual(base.merkle(sigma, 128), ((0, 0),)*128)
        canal = BaseConsultas({sigma+b'E': sigma})
        self.assertIsNone(extraer_canal(canal, sigma, 16, 20))

    def test_prefijos_incompletos_y_extensiones_fuera_de_fase(self):
        tabla, sigma = prefijo()
        tr = extraer_canal(BaseConsultas(tabla), sigma, 16, 20)
        self.assertEqual(siguiente_reto(tr), ("alpha", 0))
        for i in range(3):
            entrada = sigma+b'E'
            sigma = sha3_256(entrada).digest()
            tabla[entrada] = sigma
            tr = extraer_canal(BaseConsultas(tabla), sigma, 16, 20)
            self.assertEqual(siguiente_reto(tr), ("alpha", i+1) if i < 2 else None)
        entrada = sigma+b'E'
        sigma = sha3_256(entrada).digest()
        tabla[entrada] = sigma
        self.assertIsNone(extraer_canal(BaseConsultas(tabla), sigma, 16, 20))
        del tabla[DOMINIO]
        self.assertIsNone(extraer_canal(BaseConsultas(tabla), sigma, 16, 20))

    def test_gramatica_en_todos_los_perfiles_y_raiz_compartida(self):
        for t in [2**k for k in range(4, 13)]:
            for bits in (12, 20):
                tabla, sigma = {}, None
                for tag, dato, raiz in esquema(t, bits):
                    if tag == -1:
                        entrada = DOMINIO
                    elif tag == -2:
                        entrada = sigma+b'E'
                    else:
                        dato = dato if dato is not None else (u64(1)+u64(2)+u64(t) if tag == 4 else bytes(16) if tag == 3 else b'r'*32)
                        entrada = sigma+bytes([tag])+u64(len(dato))+dato
                    sigma = sha3_256(entrada).digest()
                    tabla[entrada] = sigma
                    tr = extraer_canal(BaseConsultas(tabla), sigma, t, bits, incluir_vectores=False)
                    self.assertIsNotNone(tr)
                    self.assertEqual(len(tr.pasos), len(tabla))
                self.assertEqual(len(tr.pasos), 13+4*(t.bit_length()-1))
                self.assertIsNone(extraer_canal(BaseConsultas(tabla), sigma, t, 12 if bits == 20 else 20))
        tabla, sigma = prefijo()
        for tag, dato in [(-2, b'')]*3+[(17, b'trace'), (2, b's'*32)]:
            entrada = sigma+b'E' if tag == -2 else sigma+bytes([tag])+u64(len(dato))+dato
            sigma = sha3_256(entrada).digest()
            tabla[entrada] = sigma
        self.assertIsNone(extraer_canal(BaseConsultas(tabla), sigma, 16, 20))

    def test_entrada_65_bytes_con_dos_roles(self):
        hijo_i = b'\x77'*31+b'\x04'
        hijo_d = u64(24)+u64(3)+u64(9)+u64(16)
        estado = b'\x01'+hijo_i[:31]
        nodo = b'\x01'+hijo_i+hijo_d
        self.assertEqual(nodo, estado+b'\x04'+u64(24)+u64(3)+u64(9)+u64(16))
        inicial = sha3_256(DOMINIO).digest()
        entrada_perfil = inicial+b'\x10'+u64(38)+perfil(16, 20)
        base = BaseConsultas({DOMINIO: inicial, entrada_perfil: estado, nodo: b's'*32,
                              b'\x00'+u64(3)+u64(0): hijo_i,
                              b'\x00'+u64(9)+u64(0): hijo_d})
        tr = extraer_canal(base, b's'*32, 16, 20)
        self.assertEqual(tr.enunciado, (3, 9, 16))
        self.assertEqual(base.merkle(b's'*32, 2), ((3, 0), (9, 0)))

    def test_estabilidad_en_subconjuntos_e_inserciones(self):
        # Todos los subconjuntos de siete entradas reales, con varias respuestas nuevas.
        hojas = [b'\x00'+u64(v)+u64(0) for v in (3, 9)]
        digests = [sha3_256(h).digest() for h in hojas]
        nodo = b'\x01'+b''.join(digests)
        raiz = sha3_256(nodo).digest()
        tabla, sigma = prefijo(raiz)
        tabla.update(dict(zip(hojas+[nodo], digests+[raiz])))
        entradas = list(tabla)
        candidatos = list(tabla.values())+[b'a'*32, b'b'*32]
        comprobados = cambios = 0
        for mascara in range(2**len(entradas)):
            base = BaseConsultas({x:tabla[x] for i, x in enumerate(entradas) if mascara >> i & 1})
            antes = (extraer_canal(base, sigma, 16, 20), base.merkle(raiz, 2))
            permitidos = base.etiquetas() | {sigma, raiz}
            for x in entradas:
                if x in base.tabla:
                    continue
                for y in candidatos:
                    ampliada = base.insertar(x, y)
                    if ampliada.colisiones:
                        continue
                    despues = (extraer_canal(ampliada, sigma, 16, 20), ampliada.merkle(raiz, 2))
                    if antes != despues:
                        self.assertIn(y, permitidos)
                        cambios += 1
                    comprobados += 1
        self.assertEqual(comprobados, 2688)
        self.assertGreater(cambios, 0)

    def test_necesidad_de_estado_fijo_y_premisa_sin_colision(self):
        tabla, sigma = prefijo()
        base = BaseConsultas(tabla)
        entrada = b'nueva'
        # Una colisión puede invalidar globalmente la extracción aunque toque otra raíz.
        y = tabla[DOMINIO]
        self.assertIsNotNone(extraer_canal(base, sigma, 16, 20))
        self.assertIsNone(extraer_canal(base.insertar(entrada, y), sigma, 16, 20))
        with self.assertRaises(ValueError):
            base.insertar(DOMINIO, b'w'*32)

    def test_sobrescribir_no_es_el_lema_de_insercion(self):
        tabla, sigma = prefijo()
        base = BaseConsultas(tabla)
        nueva = b'w'*32
        self.assertNotIn(nueva, base.etiquetas() | {sigma})
        cambiada = BaseConsultas({**tabla, DOMINIO: nueva})
        self.assertIsNotNone(extraer_canal(base, sigma, 16, 20))
        self.assertIsNone(extraer_canal(cambiada, sigma, 16, 20))

    def test_escape_artificial_cambia_en_ambos_sentidos(self):
        arbol, raiz, hoja = arbol_constante(1, 128)
        canal, sigma = prefijo(raiz)
        for objetivo in (0, 1):
            tabla = {**arbol, **canal, sigma+b'E': objetivo.to_bytes(16, 'little')+bytes(16)}
            y = tabla.pop(hoja)
            base = BaseConsultas(tabla)
            self.assertIn(y, base.etiquetas())
            self.assertEqual(propiedad_artificial(base), objetivo == 0)
            self.assertEqual(propiedad_artificial(base.insertar(hoja, y)), objetivo == 1)

    def test_ventanas_y_cota_de_cardinalidad(self):
        for largo in range(100):
            entrada = bytes(range(largo))
            self.assertLessEqual(len(ventanas(entrada)), 48)
            self.assertEqual(len(ventanas(entrada)), max(0, largo-31) if largo <= 79 else 0)
        tabla, _ = prefijo()
        self.assertLessEqual(len(BaseConsultas(tabla).etiquetas()), 48*len(tabla))

    def test_cota_de_base_comprimida_exacta(self):
        for t in [2**k for k in range(4, 13)]:
            anterior = F(0)
            for l in (0, 2**10, 2**20, 2**32, 2**40):
                dato = cota_escape(t, l)
                self.assertEqual(racional(dato["epsilon_campo"]), 4*t*MU)
                exacta = min(F(1), 6*l*l*(4*t*MU+F(49*l+1, 2**256)))
                self.assertEqual(racional(dato["cota_base_comprimida"]), exacta)
                self.assertGreaterEqual(F(dato["cota_superior"]), exacta)
                self.assertGreaterEqual(exacta, anterior)
                anterior = exacta
        with self.assertRaises(ValueError):
            cota_escape(16, -1)

    def test_corpus_y_calculos_archivados(self):
        registros = [auditar_certificado(p) for p in sorted(CORPUS.glob('corpus-*/*.bin'))]
        self.assertEqual(len(registros), 14)
        self.assertEqual(sum(r["acepta"] for r in registros), 8)
        self.assertTrue(all(r["acepta"] or r["motivo"] == 'fri_traza' for r in registros))
        self.assertEqual(sum(len(r["retos"]) for r in registros), 236)
        self.assertEqual(sum(r["aperturas_air_cotejadas"] for r in registros), 1974)
        datos = json.loads((PAQUETE/'calculos.json').read_text(encoding='utf8'))
        # Normalizar tuplas para comparar con el formato JSON.
        self.assertEqual(json.loads(json.dumps(registros)), datos['corpus'])
        self.assertEqual(len(datos['perfiles']), 45)
        for p in datos['perfiles']:
            self.assertEqual(p, cota_escape(p['T'], p['L']))


if __name__ == '__main__':
    unittest.main(verbosity=2)
