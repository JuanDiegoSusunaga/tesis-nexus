"""Audita el muestreo y la expansión; registra el parámetro QROM aún pendiente."""
from argparse import ArgumentParser
from fractions import Fraction as F
from math import isqrt
from pathlib import Path
import json

from analizar_rbr_conjunto_tg2 import fraccion, decimal_superior
from analizar_transferencia_rom_tg2 import limites
from analizar_extractor_qrom_tg2 import cota_escape, CORPUS, RAIZ
from extraer_base_qrom_tg2 import BaseConsultas
from muestreo_base_qrom_tg2 import extraer_muestreo, parejas_buenas
from expandir_verificador_qrom_tg2 import expandir, repetir_expansion
from verificar_certificados_tg2 import leer_certificado


def racional(dato):
    return F(int(dato['numerador']), int(dato['denominador']))


def raiz_superior(valor, decimales=100):
    if valor < 0 or decimales < 0:
        raise ValueError("Raíz o precisión inválida")
    escala = 10**decimales
    a, b = valor.numerator*escala**2, valor.denominator
    entero = isqrt(a//b)
    if entero*entero*b != a:
        entero += 1
    return F(entero, escala)


def datos_puente(t, q, corte=512):
    if not isinstance(q, int) or q < 0 or not 40 <= corte <= 512:
        raise ValueError("Presupuesto o corte inválido")
    v = limites(t, extracciones=corte)['hashes_verificador_maximos']
    l = q+v
    return {'T': t, 'Q': q, 'R': corte, 'V': v, 'L': l,
            'cota_campo_base': cota_escape(t, l)['cota_base_comprimida'],
            'correccion_salida_al_cuadrado': fraccion(F(v, 2**256)),
            'beta_muestreo': None,
            'cota_aceptacion_completa': None,
            'motivo': 'Falta demostrar una cota beta para omisión o cola en la base comprimida'}


def cota_condicional(t, q, beta, corte=512):
    """Solo válida si beta es una cota demostrada del evento definido en el informe."""
    if not isinstance(beta, F) or not 0 <= beta <= 1:
        raise ValueError("Se requiere una cota racional beta entre cero y uno")
    datos = datos_puente(t, q, corte)
    delta = min(F(1), racional(datos['cota_campo_base'])+beta)
    gamma = racional(datos['correccion_salida_al_cuadrado'])
    superior = min(F(1), delta+gamma+2*raiz_superior(delta*gamma))
    return {'hipotesis_beta': fraccion(beta), 'cota_condicional': fraccion(superior),
            'redondeo_superior': decimal_superior(superior, 40),
            'advertencia': 'Este cálculo no demuestra la hipótesis beta'}


def auditar(ruta, corte):
    prueba = leer_certificado(ruta)
    expansion = expandir(prueba, prueba['bits'], corte)
    repetir_expansion(prueba, prueba['bits'], expansion)
    base = BaseConsultas(expansion.tabla())
    trabajo = [x for x in base.tabla if len(x) == 41]
    if len(trabajo) != 1 or base.colisiones:
        raise RuntimeError("Corpus fuera de las condiciones del contraste")
    muestra = extraer_muestreo(base, trabajo[0][:32], prueba['nonce'], prueba['T'], prueba['bits'], corte)
    if muestra is None or muestra.recorrido.estado == 'incompleto':
        raise RuntimeError("La base no contiene el recorrido del verificador")
    if (expansion.resultado == 'cola') != (muestra.recorrido.estado == 'cola'):
        raise RuntimeError("El evento de cola no corresponde")
    if len(muestra.recorrido.pasos) != expansion.extracciones:
        raise RuntimeError("Conteo de extracciones diferente")
    invertida = BaseConsultas(dict(reversed(list(base.tabla.items()))))
    if extraer_muestreo(invertida, trabajo[0][:32], prueba['nonce'], prueba['T'], prueba['bits'], corte) != muestra:
        raise RuntimeError("El sufijo depende del orden de inserción")
    buenas = parejas_buenas(muestra.prefijo) if muestra.recorrido.estado == 'completo' else None
    dentro = set(muestra.recorrido.indices) <= buenas if buenas is not None else None
    if expansion.resultado == 'acepta' and not dentro:
        raise RuntimeError("Aceptación sin inclusión en G extraído")
    return {'archivo': ruta.relative_to(RAIZ).as_posix(), 'T': prueba['T'], 'bits': prueba['bits'],
            'R': corte, 'resultado_acotado': expansion.resultado, 'motivo': expansion.motivo,
            'llamadas': expansion.llamadas, 'V': expansion.maximo, 'pares_salida': len(expansion.pares),
            'entradas_distintas': len(base.tabla), 'extracciones': expansion.extracciones,
            'indices': muestra.recorrido.indices, 'distintos': len(muestra.recorrido.indices),
            'estado_muestreo': muestra.recorrido.estado, 'parejas_buenas': len(buenas) if buenas is not None else None,
            'indices_dentro_de_G': dentro, 'repeticion_sin_oraculo': True,
            'huella_expansion': expansion.huella(),
            'alcance_enunciado': 'Corpus con enunciados válidos; no decide falsedad ni prueba la cota de omisión'}


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument('--salida', type=Path, required=True)
    args = parser.parse_args()
    corpus = [auditar(p, corte) for corte in (40, 512) for p in sorted(CORPUS.glob('corpus-*/*.bin'))]
    datos = {'fecha': '2026-09-23', 'estado': 'Reducción a un evento de muestreo explícito; cota beta pendiente',
             'formula': 'min(1,(sqrt(min(1,A_T(Q+V)+beta_T,g,R(Q+V)))+sqrt(V/2^256))^2)',
             'perfiles': [datos_puente(2**i, q, corte) for i in range(4, 13)
                          for q in (0, 2**10, 2**20, 2**32) for corte in (40, 512)],
             'corpus': corpus,
             'fuente': 'CMS19, definición 4.1 y lema 4.9, páginas PDF 20 y 22; copia de enero de 2020',
             'limites': ['No se ha demostrado beta', 'El resultado cola pertenece a un verificador auxiliar del análisis',
                         'La decisión de falsedad del enunciado solo aparece en el juego matemático',
                         'No se modifica el Rust ni se atribuye una tasa de falsificación al corpus']}
    args.salida.parent.mkdir(parents=True, exist_ok=True)
    with args.salida.open('x', encoding='utf8', newline='\n') as archivo:
        json.dump(datos, archivo, ensure_ascii=False, indent=2)
        archivo.write('\n')
    print(json.dumps({'perfiles': len(datos['perfiles']), 'recorridos': len(corpus),
                      'resultados': {str(r): {e: sum(x['R'] == r and x['resultado_acotado'] == e for x in corpus)
                                             for e in ['acepta', 'rechaza', 'cola']} for r in (40, 512)}}))


if __name__ == '__main__':
    main()
