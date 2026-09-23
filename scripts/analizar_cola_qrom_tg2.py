"""Cota propuesta de cola QROM por conteo de respuestas; omisión aún pendiente."""
from argparse import ArgumentParser
from fractions import Fraction as F
from hashlib import sha256
from math import comb
from pathlib import Path
import json

from analizar_transferencia_rom_tg2 import limites
from muestreo_base_qrom_tg2 import recorrer_indices


def parametros(m, q, r, consultas):
    if any(not isinstance(x, int) for x in (m, q, r, consultas)):
        raise ValueError('Los parámetros deben ser enteros')
    if m < 2 or m & (m-1) or not 2 <= q <= m or r < q or consultas < 0:
        raise ValueError('Parámetros fuera del modelo de cola')


def cota_cola_exacta(m, q, r, consultas):
    """Superset del evento de cola sin colisiones, tras consultas totales a H."""
    parametros(m, q, r, consultas)
    if consultas < r:
        return F(0)
    a2 = min(F(1), F(6*(q-1), m))
    return min(F(1), comb(m, q-1)*comb(consultas, r)**2*a2**r)


def cota_cola_diadica(m, q, r, consultas):
    """Redondeo superior exacto a potencia de dos, sin convertir a float."""
    parametros(m, q, r, consultas)
    resultado = {'M': m, 'q': q, 'R': r, 'L': consultas,
                 'cero': False, 'exponente_superior': 0,
                 'cota': '1', 'metodo': 'cota_universal',
                 'numerador_sha256': None, 'bits_numerador': None,
                 'exponente_denominador': None}
    if consultas < r:
        return {**resultado, 'cero': True, 'cota': '0', 'metodo': 'soporte_insuficiente'}
    # Si C(L,R) >= (L/R)^R ya hace la expresión >= 1, evitamos enteros grandes.
    a2 = min(F(1), F(6*(q-1), m))
    if a2 == 1 or consultas**2*a2 >= r**2:
        return resultado
    num = comb(m, q-1)*comb(consultas, r)**2*a2.numerator**r
    den_exp = (a2.denominator.bit_length()-1)*r
    if a2.denominator != 1 << (a2.denominator.bit_length()-1):
        raise ArithmeticError('Se esperaba denominador potencia de dos')
    e = num.bit_length()-den_exp-(num & (num-1) == 0)
    e = min(0, e)
    return {**resultado, 'exponente_superior': e, 'cota': '1' if e == 0 else f'2^{e}',
            'metodo': 'entero_exacto_y_redondeo_superior',
            'numerador_sha256': sha256(num.to_bytes((num.bit_length()+7)//8, 'big')).hexdigest(),
            'bits_numerador': num.bit_length(), 'exponente_denominador': den_exp}


def frobenius_bloque(d, seleccion, fase):
    """Norma de Frobenius al cuadrado del bloque no marcado -> marcado."""
    b = frozenset(seleccion)
    if d < 2 or d & (d-1) or not 0 <= fase < d or any(not 0 <= y < d for y in b):
        raise ValueError('Grupo, subconjunto o carácter inválido')
    if fase == 0:
        return F(0)
    signo = lambda y: 1-2*((fase & y).bit_count() % 2)
    p, a = F(len(b), d), F(sum(signo(y) for y in b), d)
    return 4*p-3*p*p-2*a+4*p*a-2*a*a


def testigo_cola_registrada(base, entrada_semilla, m, q=40, corte=512):
    """Comprueba la inclusión estructural; no decide falsedad ni exige trabajo."""
    parametros(m, q, corte, corte)
    if base.colisiones:
        raise ValueError('El lema requiere ausencia de colisiones')
    if (len(entrada_semilla) != 49 or entrada_semilla[32:41] != b'\x05'+(8).to_bytes(8, 'little')
            or entrada_semilla not in base.tabla):
        raise ValueError('Hace falta la absorción registrada del nonce')
    recorrido = recorrer_indices(base, base.tabla[entrada_semilla], m, q, corte)
    if recorrido.estado != 'cola':
        return None
    entradas = {p.entrada for p in recorrido.pasos}
    salidas = {p.salida for p in recorrido.pasos}
    if len(entradas) != corte or len(salidas) != corte:
        raise ArithmeticError('Una cadena anclada sin colisiones no puede repetirse')
    return {'R': corte, 'entradas_distintas': len(entradas), 'salidas_distintas': len(salidas),
            'indices': sorted(recorrido.indices), 'cantidad_indices': len(recorrido.indices)}


def perfil(t, consultas_adversario, corte):
    presupuesto = limites(t, extracciones=corte)
    v = presupuesto['hashes_verificador_maximos']
    cota = cota_cola_diadica(4*t, 40, corte, consultas_adversario+v)
    return {'T': t, 'Q': consultas_adversario, 'V': v, **cota,
            'beta_omision': None, 'cota_aceptacion_completa': None,
            'alcance': 'Cota propuesta de Tcola en la base comprimida; no de S ni de toda aceptación'}


def escenarios():
    return [perfil(2**k, q, r) for k in range(4, 13)
            for q in (0, 2**10, 2**16, 2**20) for r in (512, 4096, 16384, 65536)]


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument('--salida', type=Path, required=True)
    args = parser.parse_args()
    perfiles = escenarios()
    datos = {'fecha': '2026-09-23', 'estado': 'Demostración propuesta de la cola; dictamen y omisión pendientes',
             'formula': 'min(1,C(M,39)*C(L,R)^2*min(1,234/M)^R)',
             'modelo': 'Base del oráculo comprimido tras L consultas totales; Tcola excluye colisiones',
             'perfiles': perfiles,
             'limites': ['No se demuestra beta de omisión',
                         'R es un corte del análisis, no un parámetro nuevo de Rust',
                         'La expansión software anterior sigue limitada a R<=512',
                         'Los exponentes son redondeos superiores de una cota, no probabilidades observadas']}
    args.salida.parent.mkdir(parents=True, exist_ok=True)
    with args.salida.open('x', encoding='utf8', newline='\n') as archivo:
        json.dump(datos, archivo, ensure_ascii=False, indent=2)
        archivo.write('\n')
    print(json.dumps({'perfiles': len(perfiles), 'no_vacios': sum(p['exponente_superior'] < 0 for p in perfiles)}))


if __name__ == '__main__':
    main()
