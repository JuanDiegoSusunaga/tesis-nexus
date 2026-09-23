"""Contrastes finitos QROM y enlace del prefijo PoW con el corpus TG2 v1."""
from fractions import Fraction as F
from hashlib import sha3_256
from itertools import product
from pathlib import Path
import json
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from analizar_qrom_tg2 import (
    hashes_prefijo, cota_trabajo, grover_exacto, grover_rom, salto_ultima_consulta,
)
from analizar_transferencia_rom_tg2 import RegistroOraculo
from verificar_certificados_tg2 import leer_certificado, verificar, HashMedido
from auditar_merkle_fs_r4 import DOMINIO, perfil, u64

RAIZ = Path(__file__).resolve().parents[2]
PAQUETE = RAIZ/"Documentos/04-Administrativo-TG2/Avances/QROM-2026-09-23"


def racional(dato):
    return F(int(dato["numerador"]), int(dato["denominador"]))


def circuito_xor(tabla, bits, rondas):
    """Estado completo (x,y), coeficientes relativos a 1/sqrt(N), todo exacto."""
    n, ancho = len(tabla), 2**bits
    estado = [F(y == 0) for x in range(n) for y in range(ancho)]
    consultas = 0
    for _ in range(rondas):
        # Calcular H, cambiar el signo cuando H(x)=0 y descalcular H.
        for paso in range(2):
            nuevo = [F(0)]*len(estado)
            for x in range(n):
                for y in range(ancho):
                    nuevo[x*ancho+(y ^ tabla[x])] = estado[x*ancho+y]
            estado = nuevo
            consultas += 1
            if paso == 0:
                for x in range(n):
                    estado[x*ancho] *= -1
        # Difusión solo sobre el registro x.
        for y in range(ancho):
            media = sum(estado[x*ancho+y] for x in range(n))/n
            for x in range(n):
                estado[x*ancho+y] = 2*media-estado[x*ancho+y]
    assert sum(a*a for a in estado)/n == 1
    assert all(estado[x*ancho+y] == 0 for x in range(n) for y in range(1, ancho))
    return sum(estado[x*ancho]**2 for x in range(n) if tabla[x] == 0)/n, consultas


class QromTg2(unittest.TestCase):
    def test_cuenta_prefijo_en_nueve_perfiles(self):
        for k in range(4, 13):
            self.assertEqual(hashes_prefijo(2**k), 13+4*k)

    def test_prefijo_real_y_trabajo_en_catorce_certificados(self):
        class PrefijoCompleto(Exception):
            pass

        class Captura(HashMedido):
            def __call__(self, entrada):
                if len(entrada) == 41:
                    self.entrada_trabajo = entrada
                    raise PrefijoCompleto()
                return super().__call__(entrada)

        rutas = sorted((RAIZ/"Documentos/06-Evidencia-TG2/2026-09-22/R4-FRI-vinculado").glob("corpus-*/*.bin"))
        self.assertEqual(len(rutas), 14)
        for ruta in rutas:
            p = leer_certificado(ruta)
            captura = Captura()
            with self.assertRaises(PrefijoCompleto):
                verificar(p, p["bits"], captura)
            self.assertEqual(captura.total, hashes_prefijo(p["T"]))
            # Reconstrucción directa sin reutilizar Canal ni sus absorb/extension.
            estado = sha3_256(DOMINIO).digest()
            mensajes = [(16, perfil(p["T"], p["bits"])),
                        (4, u64(p["inicio"])+u64(p["salida"])+u64(p["T"])),
                        (1, p["raiz"])]
            for tag, datos in mensajes:
                estado = sha3_256(estado+bytes([tag])+u64(len(datos))+datos).digest()
            for _ in range(3):
                estado = sha3_256(estado+b'E').digest()
            for rol, fase in zip([b'trace', b'composition'], p["fases"]):
                estado = sha3_256(estado+b'\x11'+u64(len(rol))+rol).digest()
                for raiz in fase["raices"]:
                    estado = sha3_256(estado+b'\x02'+u64(32)+raiz).digest()
                    estado = sha3_256(estado+b'E').digest()
                final = b''.join(u64(v) for v in fase["final"])
                estado = sha3_256(estado+b'\x03'+u64(16)+final).digest()
            esperado = estado+b'\x05'+u64(p["nonce"])
            self.assertEqual(captura.entrada_trabajo, esperado)
            self.assertLess(int.from_bytes(sha3_256(esperado).digest(), 'big'), 2**(256-p["bits"]))

    def test_cota_exacta_monotona_y_umbral(self):
        anterior = F(0)
        for q in range(453):
            dato = cota_trabajo(4096, 20, q)
            exacta = min(F(1), F((2*(q+61)+1)**2, 2**20))
            self.assertEqual(racional(dato["cota"]), exacta)
            self.assertGreaterEqual(F(dato["cota_superior"]), exacta)
            self.assertGreaterEqual(exacta, anterior)
            anterior = exacta
        self.assertFalse(cota_trabajo(4096, 20, 450)["vacia"])
        self.assertTrue(cota_trabajo(4096, 20, 451)["vacia"])

    def test_rechaza_perfiles_fuera_del_modelo(self):
        for t, g, q in [(15, 20, 0), (8192, 20, 0), (16, 13, 0), (16, 20, -1), (16, 20, 1.5)]:
            with self.assertRaises(ValueError):
                cota_trabajo(t, g, q)
        for args in [(3, 1, 1), (4, 5, 1), (4, 1, -1)]:
            with self.assertRaises(ValueError):
                grover_exacto(*args)

    def test_busqueda_extremos_y_un_marcado(self):
        for n in (1, 2, 4, 16):
            for r in range(5):
                self.assertEqual(grover_exacto(n, 0, r), 0)
                self.assertEqual(grover_exacto(n, n, r), 1)
            for m in range(n+1):
                self.assertEqual(grover_exacto(n, m, 0), F(m, n))
        self.assertEqual(grover_exacto(4, 1, 1), 1)

    def test_circuito_xor_y_promedio_de_256_oraculos(self):
        for r in (0, 1, 2):
            suma = F(0)
            for tabla in product(range(4), repeat=4):
                probabilidad, consultas = circuito_xor(tabla, 2, r)
                self.assertEqual(consultas, 2*r)
                self.assertEqual(probabilidad, grover_exacto(4, tabla.count(0), r))
                suma += probabilidad
            self.assertEqual(suma/256, grover_rom(4, 2, r))

    def test_promedios_superan_expresion_clasica(self):
        self.assertEqual(grover_rom(16, 4, 1), F(13073, 32768))
        self.assertEqual(grover_rom(64, 6, 1), F(4338497, 33554432))
        for n, bits in [(16, 4), (64, 6)]:
            self.assertGreater(grover_rom(n, bits, 1), F(3, 2**bits))

    def test_doce_busquedas_respetan_cota_cuadratica(self):
        for n, bits in [(4, 2), (16, 4), (64, 6)]:
            for r in range(4):
                self.assertLessEqual(grover_rom(n, bits, r), min(F(1), F((4*r+1)**2, 2**bits)))

    def test_medir_el_registro_destruye_esta_amplificacion(self):
        # N=4, un marcado: tras medir x, cada rama es un vector de la base.
        # Su signo global no influye; cada columna de la difusión tiene |a|²=1/4.
        n, marcado = 4, 0
        exito_medido = sum(F(1, n)*(F(2, n)-int(marcado == x))**2 for x in range(n))
        self.assertEqual(exito_medido, F(1, 4))
        self.assertEqual(grover_exacto(n, 1, 1), 1)

    def test_bad_cronologico_no_es_propiedad_de_la_tabla(self):
        hojas = [b'\x00'+u64(v)+u64(0) for v in (3, 9)]
        padre = b'\x01'+b''.join(sha3_256(h).digest() for h in hojas)
        ordenado, anticipado = RegistroOraculo(), RegistroOraculo()
        for entrada in hojas+[padre]:
            ordenado.consultar(entrada)
        for entrada in [padre]+hojas:
            anticipado.consultar(entrada)
        self.assertEqual(ordenado.tabla, anticipado.tabla)
        self.assertFalse(ordenado.eventos)
        self.assertTrue(anticipado.eventos)

    def test_salto_terminal_por_enumeracion(self):
        m, buenos, q = 8, set(range(6)), 4
        vistos = set(range(q-1))
        exacta = F(sum(x in buenos-vistos for x in range(m)), m)
        self.assertEqual(exacta, salto_ultima_consulta(m, len(buenos), q))
        self.assertEqual(exacta, F(3, 8))
        self.assertGreater(exacta, F(3, 14))  # C(6,4)/C(8,4).

    def test_calculos_archivados(self):
        datos = json.loads((PAQUETE/"calculos.json").read_text(encoding="utf-8"))
        self.assertEqual(len(datos["perfiles_trabajo"]), 108)
        self.assertEqual(len(datos["busqueda_cuantica"]), 12)
        self.assertEqual(len(datos["obstaculo_muestreo"]), 9)
        for p in datos["perfiles_trabajo"]:
            self.assertEqual(p, cota_trabajo(p["T"], p["bits"], p["Q"]))
        for caso in datos["obstaculo_muestreo"]:
            self.assertEqual(racional(caso["salto_terminal"]), salto_ultima_consulta(caso["M"], caso["buenos"], 40))
            self.assertGreater(racional(caso["salto_terminal"]), racional(caso["h_ideal"]))


if __name__ == "__main__":
    unittest.main(verbosity=2)
