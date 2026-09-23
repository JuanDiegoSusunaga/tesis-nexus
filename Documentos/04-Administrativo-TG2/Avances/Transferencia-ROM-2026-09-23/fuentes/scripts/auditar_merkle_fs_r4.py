"""Audita con hashlib el corpus público y calcula el sesgo ideal de los retos."""
from pathlib import Path
from fractions import Fraction as F
from hashlib import sha3_256, sha256
import json
import shutil

RAIZ = Path(__file__).resolve().parents[1]
ANTERIOR = RAIZ / 'Documentos/06-Evidencia-TG2/2026-09-22/R4-FRI-vinculado'
DESTINO = RAIZ / 'Documentos/06-Evidencia-TG2/2026-09-23/R4-Merkle-FS'
P = 2**64-2**32+1
DOMINIO = b'NEXUS-TG2-LINKED-FRI-v1'


def hash3(datos):
    return sha3_256(datos).digest()


def huella(ruta):
    return sha256(ruta.read_bytes()).hexdigest()


def u64(x):
    return x.to_bytes(8, 'little')


def frac(x):
    return {'numerador': str(x.numerator), 'denominador': str(x.denominator), 'aproximacion': float(x)}


class Lector:
    """Lector acotado al formato conocido del corpus local, con enteros fijos."""
    def __init__(self, datos):
        self.datos, self.pos = datos, 0

    def leer(self, n):
        assert 0 <= n <= len(self.datos)-self.pos
        salida = self.datos[self.pos:self.pos+n]
        self.pos += n
        return salida

    def entero(self, n=8):
        return int.from_bytes(self.leer(n), 'little')

    def campo(self):
        valor = self.entero()
        assert valor < P
        return valor

    def extension(self):
        return (self.campo(), self.campo())

    def cantidad(self, esperada):
        assert self.entero() == esperada


class Canal:
    def __init__(self):
        self.estado = hash3(DOMINIO)
        self.retos = []

    def absorber(self, etiqueta, datos):
        self.estado = hash3(self.estado+bytes([etiqueta])+u64(len(datos))+datos)

    def extension(self):
        self.estado = hash3(self.estado+b'E')
        valor = (int.from_bytes(self.estado[:16], 'little') % P,
                 int.from_bytes(self.estado[16:], 'little') % P)
        self.retos.append(valor)
        return valor

    def indices(self, m):
        salida, intentos = [], 0
        while len(salida) < 40:
            assert intentos < 10000
            self.estado = hash3(self.estado+b'I')
            i = int.from_bytes(self.estado[:8], 'little') & (m-1)
            if i not in salida:
                salida.append(i)
            intentos += 1
        return salida, intentos


def perfil(t, bits):
    return (1).to_bytes(2, 'little')+bits.to_bytes(4, 'little')+b''.join(u64(x) for x in [8*t, t, 2*t, 40])


def apertura(lector, raiz, valor, posicion, n):
    assert 0 <= posicion < n and n & (n-1) == 0
    profundidad = n.bit_length()-1
    lector.cantidad(profundidad)
    acumulado = hash3(b'\x00'+b''.join(u64(c) for c in valor))
    for _ in range(profundidad):
        hermano = lector.leer(32)
        par = hermano+acumulado if posicion & 1 else acumulado+hermano
        acumulado = hash3(b'\x01'+par)
        posicion >>= 1
    assert acumulado == raiz


def auditar(archivo):
    lector = Lector(archivo.read_bytes())
    inicio, salida, t = lector.campo(), lector.campo(), lector.entero()
    assert 16 <= t <= 4096 and t & (t-1) == 0
    version, bits = lector.entero(2), lector.entero(4)
    assert version == 1 and bits == (12 if 'debug' in str(archivo) else 20)
    raiz = lector.leer(32)
    canal = Canal()
    canal.absorber(16, perfil(t, bits))
    canal.absorber(4, u64(inicio)+u64(salida)+u64(t))
    canal.absorber(1, raiz)
    for _ in range(3):
        canal.extension()
    compromisos = []
    for rol, capas in [(b'trace', t.bit_length()-1), (b'composition', t.bit_length())]:
        lector.cantidad(capas)
        raices = [lector.leer(32) for _ in range(capas)]
        final = lector.extension()
        canal.absorber(17, rol)
        for r in raices:
            canal.absorber(2, r)
            canal.extension()
        canal.absorber(3, b''.join(u64(x) for x in final))
        compromisos.append(raices)
    assert compromisos[0][0] == raiz
    nonce = lector.entero()
    trabajo = hash3(canal.estado+b'\x05'+u64(nonce))
    assert int.from_bytes(trabajo, 'big') < 2**(256-bits)
    estado_antes_nonce = canal.estado.hex()
    canal.absorber(5, u64(nonce))
    indices, intentos = canal.indices(4*t)
    lector.cantidad(40)
    aperturas = 0
    for i in indices:
        lector.cantidad(6)
        valores = []
        for j in [i, (i+8) % (8*t), (i+16) % (8*t), i+4*t, (i+4*t+8) % (8*t), (i+4*t+16) % (8*t)]:
            valor = lector.campo()
            apertura(lector, raiz, (valor, 0), j, 8*t)
            valores.append(valor)
            aperturas += 1
        for fase, raices in enumerate(compromisos):
            lector.cantidad(len(raices))
            pos, n = i, 8*t
            for capa, r in enumerate(raices):
                izquierda, derecha = lector.extension(), lector.extension()
                if fase == 0 and capa == 0:
                    assert izquierda == (valores[0], 0) and derecha == (valores[3], 0)
                a = pos % (n//2)
                apertura(lector, r, izquierda, a, n)
                apertura(lector, r, derecha, a+n//2, n)
                aperturas += 2
                pos, n = a, n//2
    assert lector.pos == len(lector.datos)
    assert len(canal.retos) == 2*(t.bit_length()-1)+4
    return {'archivo': archivo.relative_to(RAIZ).as_posix(), 'sha256': huella(archivo),
            'T': t, 'bits_grinding': bits, 'nonce': nonce, 'indices': indices,
            'extracciones_indices': intentos, 'aperturas_comprobadas': aperturas,
            'retos_extension': len(canal.retos), 'estado_antes_nonce': estado_antes_nonce,
            'alcance': 'Formato, canonicidad, SHA3, nonce, índices, aperturas Merkle y enlace traza/FRI; no revalida plegados FRI ni composición AIR.'}


def main():
    DESTINO.mkdir(parents=True, exist_ok=True)
    validacion = json.loads((ANTERIOR/'validacion.json').read_text(encoding='utf-8'))
    corpus = []
    for entrada in validacion['corpus']:
        archivo = ANTERIOR/entrada['archivo']
        assert huella(archivo) == entrada['sha256']
        corpus.append(auditar(archivo))
    assert len(corpus) == 14
    # Distribución exacta de U mod p para U uniforme en un intervalo de longitud S.
    s = 2**128
    a, r = divmod(s, P)
    delta = F(r*(P-r), P*s)
    mu = F(a+1, s)**2
    assert r == P-2**32
    casos = 0
    for bits in range(2, 9):
        for modulo in [3, 5, 7, 11, 17]:
            tamano = 2**bits
            _, resto = divmod(tamano, modulo)
            masas = [F(sum(x % modulo == y for x in range(tamano)), tamano) for y in range(modulo)]
            exacta = sum(abs(v-F(1, modulo)) for v in masas)/2
            assert exacta == F(resto*(modulo-resto), modulo*tamano)
            casos += 1
    perfiles = []
    for bits in [12, 20]:
        for t in [2**k for k in range(4, 13)]:
            canal = Canal()
            canal.absorber(16, perfil(t, bits))
            # La absorción de enunciado y un nodo Merkle tienen longitud 65.
            # En estos 18 estados alcanzables, el primer byte los distingue.
            assert canal.estado[0] != 1
            retos = 2*(t.bit_length()-1)+4
            perfiles.append({'T': t, 'bits_grinding': bits, 'primer_byte_antes_enunciado': canal.estado[0],
                             'retos_extension': retos, 'sesgo_camino_uniforme_acotado': frac(2*retos*delta)})
    # Ensayo de la misma construcción de nonce sobre un contexto público, con 12 bits.
    base = hash3(b'TG2-Merkle-FS-nonces-publicos-2026-09-23')
    nonces = []
    for nonce in range(200000):
        if int.from_bytes(hash3(base+b'\x05'+u64(nonce)), 'big') < 2**244:
            canal = Canal()
            canal.estado = base
            canal.absorber(5, u64(nonce))
            indices, _ = canal.indices(64)
            nonces.append({'nonce': nonce, 'indices': indices})
            if len(nonces) == 2:
                break
    assert len(nonces) == 2 and nonces[0]['indices'] != nonces[1]['indices']
    # Evidencia de fuentes: se compara con la etapa que fijó la variante Rust.
    fuentes = []
    for entrada in json.loads((ANTERIOR/'analisis.json').read_text(encoding='utf-8'))['fuentes']:
        archivo = RAIZ/entrada['archivo']
        assert huella(archivo) == entrada['sha256']
        fuentes.append(archivo)
    fuentes += [RAIZ/'nexus/nexus-core/src/types.rs', RAIZ/'nexus/nexus-zk/tests/tg2_soundness.rs',
                Path(__file__).resolve(), RAIZ/'Documentos/06-Evidencia-TG2/2026-09-22/R4-solidez/bibliografia/BGK23.pdf']
    registros = []
    for archivo in fuentes:
        copia = DESTINO/'fuentes'/archivo.relative_to(RAIZ)
        copia.parent.mkdir(parents=True, exist_ok=True)
        if copia.exists():
            assert huella(copia) == huella(archivo), archivo
        else:
            shutil.copy2(archivo, copia)
        registros.append({'archivo': archivo.relative_to(RAIZ).as_posix(), 'sha256': huella(archivo)})
    resultado = {
        'fecha': '2026-09-23', 'corpus': corpus,
        'total_aperturas': sum(x['aperturas_comprobadas'] for x in corpus),
        'total_consultas': 40*len(corpus), 'distribucion': {'S': str(s), 'p': str(P), 'cociente': str(a),
            'resto': str(r), 'distancia_variacion_base': frac(delta), 'masa_maxima_extension': frac(mu),
            'cota_variacion_extension': frac(2*delta), 'casos_pequenos_contrastados': casos},
        'perfiles': perfiles, 'nonces_publicos': nonces, 'fuentes': registros,
        'dominios': {'inicial': 23, 'hoja_extension': 17, 'nodo': 65, 'perfil': 79, 'enunciado': 65,
                    'raiz': 73, 'fase_traza': 46, 'fase_composicion': 52, 'final': 57,
                    'squeeze': 33, 'pow': 41, 'absorcion_nonce': 49},
        'limite': 'Auditoría finita del corpus y cuentas de distribución ideal; sin extracción de oráculos, cota RBR del protocolo conjunto ni garantía ROM/QROM del ejecutable.',
    }
    (DESTINO/'analisis.json').write_text(json.dumps(resultado, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    print(json.dumps({'certificados': len(corpus), 'consultas': resultado['total_consultas'],
                      'aperturas': resultado['total_aperturas'], 'sesgo_base': float(delta),
                      'nonces_publicos': [x['nonce'] for x in nonces]}, ensure_ascii=False))


if __name__ == '__main__':
    main()
