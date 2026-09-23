"""Contrastes finitos de la derivación; no reemplazan una demostración general."""
from fractions import Fraction as F
from itertools import combinations, product
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from analizar_rbr_conjunto_tg2 import P, calcular, decimal_superior, omision


def leer(x):
    return F(int(x["numerador"]), int(x["denominador"]))


class CotasRbr(unittest.TestCase):
    def test_nueve_perfiles_y_sumas_geometricas(self):
        for i in range(4, 13):
            t = 2**i
            fila = calcular(t)
            h = omision(4*t, 40, F(1, 8))
            self.assertEqual(leer(fila["perdida_plegados_traza"]), F(8*t-8, P*P))
            self.assertEqual(leer(fila["perdida_plegados_composicion"]), F(8*t-4, P*P))
            self.assertEqual(leer(fila["epsilon_rbr"]), h)
            self.assertEqual(leer(fila["cota_ideal"]), h + F(8*t-3, P*P))
            self.assertLess(leer(fila["cota_ideal"]), leer(fila["cota_anterior"]))

    def test_redondeo_siempre_superior(self):
        for i in range(4, 13):
            fila = calcular(2**i)
            for nombre in ["cota_ideal", "epsilon_rbr", "cota_anterior"]:
                valor = leer(fila[nombre])
                redondeado = F(decimal_superior(valor))
                self.assertGreaterEqual(redondeado, valor)
                self.assertLess(redondeado-valor, F(1, 10**9))

    def test_muestreo_por_enumeracion(self):
        casos = 0
        for m in range(2, 10):
            for q in range(1, m+1):
                for b in range(m+1):
                    conjuntos = list(combinations(range(m), q))
                    prob = F(sum(all(i >= b for i in s) for s in conjuntos), len(conjuntos))
                    self.assertEqual(prob, omision(m, q, F(b, m)))
                    self.assertLessEqual(prob, (1-F(b, m))**q)
                    casos += 1
        self.assertEqual(casos, 328)

    def test_consulta_completa_y_parametros_invalidos(self):
        for t in [16, 64, 4096]:
            fila = calcular(t, q=4*t)
            self.assertEqual(leer(fila["omision_traza"]), 0)
            self.assertEqual(leer(fila["cota_ideal"]), F(8*t-3, P*P))
        for t, q, dt, dc in [(15, 40, F(1, 8), F(1, 8)),
                              (16, 65, F(1, 8), F(1, 8)),
                              (16, 40, F(1, 2), F(1, 8)),
                              (16, 40, F(1, 8), F(1, 2))]:
            with self.assertRaises(ValueError):
                calcular(t, q, dt, dc)

    def test_mca_todos_los_pares_de_funciones_f5(self):
        # Dominio de cuatro puntos, código de constantes y conjuntos de al menos tres.
        # Para cada combinación, su conjunto completo de acuerdos contiene a los demás.
        palabras = list(product(range(5), repeat=4))
        acuerdos = {}
        for palabra in palabras:
            acuerdos[palabra] = [tuple(i for i, x in enumerate(palabra) if x == c)
                                 for c in range(5) if palabra.count(c) >= 3]
        casos = 0
        for a in palabras:
            for b in palabras:
                malos = 0
                for beta in range(5):
                    palabra = tuple((x+beta*y) % 5 for x, y in zip(a, b))
                    for s in acuerdos[palabra]:
                        if len({a[i] for i in s}) > 1 or len({b[i] for i in s}) > 1:
                            malos += 1
                            break
                self.assertLessEqual(malos, 4)
                casos += 1
        self.assertEqual(casos, 390625)

    def test_ultima_coordenada_de_cancelacion(self):
        # Residuos vectoriales en F3²; la última columna no nula es previa a los retos.
        vectores = list(product(range(3), repeat=2))
        casos = 0
        for residuos in product(vectores, repeat=3):
            if all(r == (0, 0) for r in residuos):
                continue
            j = max(i for i, r in enumerate(residuos) if r != (0, 0))
            for prefijo in product(range(3), repeat=j):
                suma = tuple(sum(prefijo[i]*residuos[i][c] for i in range(j)) % 3
                             for c in range(2))
                ganadores = [alpha for alpha in range(3)
                             if all((suma[c]+alpha*residuos[j][c]) % 3 == 0 for c in range(2))]
                self.assertLessEqual(len(ganadores), 1)
                self.assertTrue(all(r == (0, 0) for r in residuos[j+1:]))
                casos += 1
        self.assertEqual(casos, 6056)

    def test_estado_fri_con_oraculos_binarios_en_f17(self):
        # Un plegado: N=8, grado<2, theta=1/4; cada beta y cada final se enumeran.
        p, dominio, inv2 = 17, [pow(2, i, 17) for i in range(8)], 9
        codigo = [tuple((a+b*x) % p for x in dominio)
                  for a, b in product(range(p), repeat=2)]
        casos = 0
        for valores in product(range(2), repeat=8):
            distancia = min(sum(x != y for x, y in zip(valores, c)) for c in codigo)
            pares = [((valores[i]+valores[i+4])*inv2 % p,
                      (valores[i]-valores[i+4])*inv2*pow(dominio[i], -1, p) % p)
                     for i in range(4)]
            malos = 0
            for beta in range(p):
                plegado = [(a+beta*b) % p for a, b in pares]
                escape = False
                for constante in range(p):
                    s = [i for i in range(4) if plegado[i] == constante]
                    if len(s) >= 3 and len({pares[i] for i in s}) > 1:
                        escape = True
                malos += escape
                if not escape and distancia > 2:
                    self.assertLessEqual(max(plegado.count(c) for c in range(p)), 3)
                casos += 1
            self.assertLessEqual(malos, 4)
        self.assertEqual(casos, 4352)


if __name__ == "__main__":
    unittest.main(verbosity=2)
