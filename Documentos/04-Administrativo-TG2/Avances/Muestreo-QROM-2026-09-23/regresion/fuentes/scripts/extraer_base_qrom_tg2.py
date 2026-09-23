"""Extractor retrospectivo del prefijo AIR/FRI sobre una base hash sin orden."""
from dataclasses import dataclass
from types import MappingProxyType

from auditar_merkle_fs_r4 import DOMINIO, P, perfil
from analizar_qrom_tg2 import hashes_prefijo


@dataclass(frozen=True)
class Paso:
    etiqueta: int
    datos: bytes
    entrada: bytes
    salida: bytes


@dataclass(frozen=True)
class OraculoExtraido:
    rol: str
    capa: int
    tamano: int
    raiz: bytes
    valores: tuple


@dataclass(frozen=True)
class Transcripcion:
    t: int
    bits: int
    enunciado: tuple | None
    pasos: tuple
    oraculos: tuple


def ventanas(entrada):
    """Etiquetas de 32 bytes de entradas que podrían pertenecer al protocolo."""
    if len(entrada) > 79:
        return frozenset()
    return frozenset(entrada[i:i+32] for i in range(max(0, len(entrada)-31)))


class BaseConsultas:
    """Instantánea inmutable de pares entrada/salida; no guarda una cronología."""
    def __init__(self, tabla):
        copia = dict(tabla)
        if any(not isinstance(x, bytes) or not isinstance(y, bytes) or len(y) != 32
               for x, y in copia.items()):
            raise ValueError("Se requieren entradas bytes y digests de 32 bytes")
        inverso, colisiones = {}, False
        for entrada, salida in copia.items():
            if salida in inverso:
                colisiones = True
            inverso[salida] = entrada
        self.tabla = MappingProxyType(copia)
        self.inverso = MappingProxyType(inverso)
        self.colisiones = colisiones

    def etiquetas(self):
        return frozenset(v for x in self.tabla for v in ventanas(x))

    def insertar(self, entrada, salida):
        if entrada in self.tabla:
            raise ValueError("La inserción del lema debe usar una entrada nueva")
        return BaseConsultas({**self.tabla, entrada: salida})

    def merkle(self, raiz, tamano):
        if len(raiz) != 32 or tamano < 1 or tamano & (tamano-1):
            raise ValueError("Raíz o tamaño inválido")
        if self.colisiones:
            return None
        # La profundidad decrece incluso cuando los digests forman un ciclo.
        def recorrer(digest, n):
            entrada = self.inverso.get(digest)
            if n == 1:
                if entrada is not None and len(entrada) == 17 and entrada[0] == 0:
                    valor = (int.from_bytes(entrada[1:9], 'little'), int.from_bytes(entrada[9:17], 'little'))
                    if all(v < P for v in valor):
                        return (valor,)
                return ((0, 0),)
            if entrada is not None and len(entrada) == 65 and entrada[0] == 1:
                return recorrer(entrada[1:33], n//2)+recorrer(entrada[33:], n//2)
            return ((0, 0),)*n
        return recorrer(raiz, tamano)


def esquema(t, bits):
    """Cada posición fija etiqueta, datos obligatorios y metadatos de raíz."""
    hashes_prefijo(t)
    if bits not in (12, 20):
        raise ValueError("Perfil de trabajo no admitido")
    lista = [(-1, DOMINIO, None), (16, perfil(t, bits), None), (4, None, None),
             (1, None, ("traza-inicial", 0, 8*t))]+[(-2, b'', None)]*3
    for rol, cantidad in [(b'trace', t.bit_length()-1), (b'composition', t.bit_length())]:
        lista.append((17, rol, None))
        for capa in range(cantidad):
            lista.extend([(2, None, (rol.decode('ascii'), capa, (8*t) >> capa)), (-2, b'', None)])
        lista.append((3, None, None))
    return tuple(lista)


def interpretar(entrada, salida):
    if entrada == DOMINIO:
        return Paso(-1, DOMINIO, entrada, salida)
    if len(entrada) == 33 and entrada[-1:] == b'E':
        return Paso(-2, b'', entrada, salida)
    if 41 <= len(entrada) <= 79 and entrada[32] in (1, 2, 3, 4, 16, 17):
        largo = int.from_bytes(entrada[33:41], 'little')
        if largo == len(entrada)-41:
            return Paso(entrada[32], entrada[41:], entrada, salida)
    return None


def extraer_canal(base, sigma, t, bits, incluir_vectores=True):
    """Devuelve un prefijo válido hasta una constante FRI, o None si no lo hay.

    No consulta H, no mide un adversario y no incluye nonce ni cadena de índices.
    La misma entrada de 65 bytes puede interpretarse como nodo y como enunciado.
    """
    esperado = esquema(t, bits)
    if not isinstance(sigma, bytes) or len(sigma) != 32:
        raise ValueError("Estado final inválido")
    if base.colisiones:
        return None
    inversos, visitados, actual = [], set(), sigma
    for _ in range(len(esperado)):
        if actual in visitados:
            return None
        visitados.add(actual)
        entrada = base.inverso.get(actual)
        if entrada is None:
            return None
        paso = interpretar(entrada, actual)
        if paso is None:
            return None
        inversos.append(paso)
        if paso.etiqueta == -1:
            break
        actual = entrada[:32]
    else:
        return None
    pasos = tuple(reversed(inversos))
    enunciado, raiz_traza, oraculos, cache = None, None, [], {}
    for paso, (etiqueta, datos, raiz) in zip(pasos, esperado):
        if paso.etiqueta != etiqueta or (datos is not None and paso.datos != datos):
            return None
        if etiqueta == 4:
            if len(paso.datos) != 24:
                return None
            enunciado = tuple(int.from_bytes(paso.datos[i:i+8], 'little') for i in range(0, 24, 8))
            if enunciado[2] != t or not all(v < P for v in enunciado[:2]):
                return None
        if etiqueta == 3:
            if len(paso.datos) != 16 or any(int.from_bytes(paso.datos[i:i+8], 'little') >= P for i in (0, 8)):
                return None
        if raiz is not None:
            if len(paso.datos) != 32:
                return None
            rol, capa, n = raiz
            if rol == "traza-inicial":
                raiz_traza = paso.datos
            if rol == "trace" and capa == 0 and paso.datos != raiz_traza:
                return None
            clave = (paso.datos, n)
            if clave not in cache:
                cache[clave] = base.merkle(*clave) if incluir_vectores else ()
            oraculos.append(OraculoExtraido(rol, capa, n, paso.datos, cache[clave]))
    return Transcripcion(t, bits, enunciado, pasos, tuple(oraculos))


def siguiente_reto(transcripcion):
    """Identifica alpha o beta únicamente cuando el siguiente paso es E."""
    if transcripcion is None:
        return None
    posicion = len(transcripcion.pasos)
    if posicion in (4, 5, 6):
        return ("alpha", posicion-4)
    for i, (_, _, raiz) in enumerate(esquema(transcripcion.t, transcripcion.bits)):
        if raiz is not None and raiz[0] != "traza-inicial" and posicion == i+1:
            return ("beta-"+raiz[0], raiz[1])
    return None
