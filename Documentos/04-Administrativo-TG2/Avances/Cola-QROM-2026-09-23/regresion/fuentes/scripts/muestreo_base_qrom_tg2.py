"""Reconstrucción del sufijo de trabajo e índices sobre una base sin orden."""
from dataclasses import dataclass

from analizar_qrom_tg2 import hashes_prefijo
from extraer_base_qrom_tg2 import extraer_canal
from auditar_merkle_fs_r4 import P, u64
from verificar_certificados_tg2 import composicion, sumar, restar, escalar, multiplicar


@dataclass(frozen=True)
class PasoIndice:
    entrada: bytes
    salida: bytes
    indice: int


@dataclass(frozen=True)
class Recorrido:
    estado: str
    indices: tuple
    pasos: tuple


@dataclass(frozen=True)
class Muestreo:
    prefijo: object
    nonce: int
    entrada_trabajo: bytes
    salida_trabajo: bytes
    entrada_semilla: bytes
    semilla: bytes
    recorrido: Recorrido


def recorrer_indices(base, semilla, m, q=40, corte=512):
    if m < 1 or m & (m-1) or not 1 <= q <= m or corte < q or len(semilla) != 32:
        raise ValueError("Parámetros de muestreo inválidos")
    estado, indices, vistos, pasos = semilla, [], set(), []
    for _ in range(corte):
        entrada = estado+b'I'
        salida = base.tabla.get(entrada)
        if salida is None:
            return Recorrido("incompleto", tuple(indices), tuple(pasos))
        indice = int.from_bytes(salida[:8], 'little') & (m-1)
        pasos.append(PasoIndice(entrada, salida, indice))
        if indice not in vistos:
            vistos.add(indice)
            indices.append(indice)
        if len(indices) == q:
            return Recorrido("completo", tuple(indices), tuple(pasos))
        estado = salida
    return Recorrido("cola", tuple(indices), tuple(pasos))


def extraer_muestreo(base, sigma, nonce, t, bits, corte=512):
    if not isinstance(nonce, int) or not 0 <= nonce < 2**64 or not 40 <= corte <= 512:
        raise ValueError("Nonce o corte fuera del modelo comprobado")
    prefijo = extraer_canal(base, sigma, t, bits)
    if prefijo is None or len(prefijo.pasos) != hashes_prefijo(t):
        return None
    entrada_trabajo = sigma+b'\x05'+u64(nonce)
    trabajo = base.tabla.get(entrada_trabajo)
    if trabajo is None or int.from_bytes(trabajo, 'big') >= 2**(256-bits):
        return None
    entrada_semilla = sigma+b'\x05'+u64(8)+u64(nonce)
    semilla = base.tabla.get(entrada_semilla)
    if semilla is None:
        return None
    return Muestreo(prefijo, nonce, entrada_trabajo, trabajo, entrada_semilla, semilla,
                    recorrer_indices(base, semilla, 4*t, corte=corte))


def parametros_locales(prefijo):
    """Obtiene alpha, beta y constantes del prefijo completo ya validado."""
    if len(prefijo.pasos) != hashes_prefijo(prefijo.t):
        raise ValueError("Hace falta el prefijo completo")
    retos = [(int.from_bytes(p.salida[:16], 'little') % P,
              int.from_bytes(p.salida[16:], 'little') % P)
             for p in prefijo.pasos if p.etiqueta == -2]
    kt = prefijo.t.bit_length()-1
    finales = [tuple(int.from_bytes(p.datos[i:i+8], 'little') for i in (0, 8))
               for p in prefijo.pasos if p.etiqueta == 3]
    return retos[:3], [retos[3:3+kt], retos[3+kt:]], finales


def acepta_fri_local(vectores, betas, final, posicion, n):
    """Predicado algebraico sobre vectores extraídos; no consulta hashes."""
    arrastre, offset = None, 7
    for vector, beta in zip(vectores, betas):
        mitad, a = n//2, posicion % (n//2)
        izquierda, derecha = vector[a], vector[a+n//2]
        if arrastre is not None and arrastre != (izquierda if posicion < mitad else derecha):
            return False
        x = offset*pow(7, ((P-1)//n)*a, P) % P
        par = escalar(sumar(izquierda, derecha), (P+1)//2)
        impar = escalar(restar(izquierda, derecha), ((P+1)//2)*pow(x, -1, P) % P)
        arrastre = sumar(par, multiplicar(beta, impar))
        posicion, n, offset = a, mitad, offset*offset % P
    return arrastre == final


def parejas_buenas(prefijo):
    """Calcula G de la transcripción extraída, sin resolver si el enunciado es falso."""
    t, n = prefijo.t, 8*prefijo.t
    alphas, betas, finales = parametros_locales(prefijo)
    u = prefijo.oraculos[0].valores
    traza = [r.valores for r in prefijo.oraculos if r.rol == 'trace']
    cp = [r.valores for r in prefijo.oraculos if r.rol == 'composition']
    if not all(len(r.valores) == r.tamano for r in prefijo.oraculos):
        raise ValueError("Se necesitan vectores completos, no solo metadatos")
    prueba = {"T": t, "inicio": prefijo.enunciado[0], "salida": prefijo.enunciado[1]}
    buenas = []
    for i in range(n//2):
        posiciones = [i, (i+8) % n, (i+16) % n, i+n//2, (i+n//2+8) % n, (i+n//2+16) % n]
        valores = [u[j] for j in posiciones]
        if any(v[1] != 0 for v in valores):
            continue
        valores = [v[0] for v in valores]
        x = 7*pow(7, ((P-1)//n)*i, P) % P
        if cp[0][i] != composicion(prueba, alphas, x, valores[:3]):
            continue
        if cp[0][i+n//2] != composicion(prueba, alphas, -x % P, valores[3:]):
            continue
        if not acepta_fri_local(traza, betas[0], finales[0], i, n):
            continue
        if not acepta_fri_local(cp, betas[1], finales[1], i, n):
            continue
        buenas.append(i)
    return frozenset(buenas)
