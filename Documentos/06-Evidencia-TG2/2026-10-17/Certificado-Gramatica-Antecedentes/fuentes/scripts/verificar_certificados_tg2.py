"""Verificador Python del corpus TG2: SHA3, Merkle, AIR y ambos FRI; uso de investigación."""
from collections import Counter
from hashlib import sha3_256
from pathlib import Path

from auditar_merkle_fs_r4 import Lector, DOMINIO, P, u64, perfil
from analizar_transferencia_rom_tg2 import limites


class Rechazo(ValueError):
    pass


def exigir(condicion, motivo):
    if not condicion:
        raise Rechazo(motivo)


def sumar(a, b):
    return ((a[0]+b[0]) % P, (a[1]+b[1]) % P)


def restar(a, b):
    return ((a[0]-b[0]) % P, (a[1]-b[1]) % P)


def multiplicar(a, b):
    return ((a[0]*b[0]+7*a[1]*b[1]) % P, (a[0]*b[1]+a[1]*b[0]) % P)


def escalar(a, b):
    return (a[0]*b % P, a[1]*b % P)


def codificar(a):
    return u64(a[0])+u64(a[1])


class HashMedido:
    def __init__(self):
        self.cuentas = Counter()

    def __call__(self, entrada):
        self.cuentas[len(entrada)] += 1
        return sha3_256(entrada).digest()

    @property
    def total(self):
        return sum(self.cuentas.values())


class Canal:
    def __init__(self, hash_funcion):
        self.hash = hash_funcion
        self.estado = self.hash(DOMINIO)
        self.extracciones = 0

    def absorber(self, tag, datos):
        self.estado = self.hash(self.estado+bytes([tag])+u64(len(datos))+datos)

    def extension(self):
        self.estado = self.hash(self.estado+b'E')
        return (int.from_bytes(self.estado[:16], 'little') % P,
                int.from_bytes(self.estado[16:], 'little') % P)

    def indices(self, m):
        salida = []
        while len(salida) < 40:
            # Límite del auditor; el Rust v1 no tiene este corte. La cota incluye la cola.
            exigir(self.extracciones < 512, 'limite_auditor')
            self.estado = self.hash(self.estado+b'I')
            self.extracciones += 1
            indice = int.from_bytes(self.estado[:8], 'little') & (m-1)
            if indice not in salida:
                salida.append(indice)
        return salida


def leer_certificado(ruta):
    # Se usa el lector acotado del corpus previo; no es un decodificador de producción.
    lector = Lector(Path(ruta).read_bytes())
    inicio, salida, t = lector.campo(), lector.campo(), lector.entero()
    exigir(t in [2**i for i in range(4, 13)], 'filas')
    prueba = {'inicio': inicio, 'salida': salida, 'T': t,
              'version': lector.entero(2), 'bits': lector.entero(4), 'raiz': lector.leer(32)}
    fases = []
    for k in [t.bit_length()-1, t.bit_length()]:
        lector.cantidad(k)
        fases.append({'raices': [lector.leer(32) for _ in range(k)], 'final': lector.extension()})
    prueba['fases'] = fases
    prueba['nonce'] = lector.entero()
    lector.cantidad(40)
    consultas = []
    for _ in range(40):
        lector.cantidad(6)
        traza = []
        profundidad = (8*t).bit_length()-1
        for _ in range(6):
            valor = lector.campo()
            lector.cantidad(profundidad)
            traza.append({'valor': valor, 'camino': [lector.leer(32) for _ in range(profundidad)]})
        fri = []
        for k in [t.bit_length()-1, t.bit_length()]:
            lector.cantidad(k)
            capas = []
            for j in range(k):
                izquierda, derecha = lector.extension(), lector.extension()
                lector.cantidad(profundidad-j)
                camino_i = [lector.leer(32) for _ in range(profundidad-j)]
                lector.cantidad(profundidad-j)
                camino_d = [lector.leer(32) for _ in range(profundidad-j)]
                capas.append({'izquierda': izquierda, 'derecha': derecha,
                              'camino_i': camino_i, 'camino_d': camino_d})
            fri.append(capas)
        consultas.append({'traza': traza, 'fri': fri})
    prueba['consultas'] = consultas
    exigir(lector.pos == len(lector.datos), 'bytes_sobrantes')
    return prueba


def apertura(hash_funcion, raiz, n, indice, valor, camino):
    exigir(0 <= indice < n and len(camino) == n.bit_length()-1, 'forma_apertura')
    digest = hash_funcion(b'\x00'+codificar(valor))
    for hermano in camino:
        digest = hash_funcion(b'\x01'+(hermano+digest if indice & 1 else digest+hermano))
        indice >>= 1
    exigir(digest == raiz, 'merkle')


def composicion(prueba, alphas, x, valores):
    t = prueba['T']
    g = pow(7, (P-1)//t, P)
    h1, h2 = pow(g, t-1, P), pow(g, t-2, P)
    inv = lambda v: pow(v % P, -1, P)
    a, b, c = valores
    partes = [(a-prueba['inicio'])*inv(x-1) % P,
              (a-prueba['salida'])*inv(x-h1) % P,
              (c-b*b-a*a)*(x-h1)*(x-h2)*inv(pow(x, t, P)-1) % P]
    resultado = (0, 0)
    for alpha, valor in zip(alphas, partes):
        resultado = sumar(resultado, escalar(alpha, valor))
    return resultado


def verificar_fri(hash_funcion, capas, compromiso, betas, posicion, n, fase):
    arrastre, offset = None, 7
    for op, raiz, beta in zip(capas, compromiso['raices'], betas):
        mitad = n//2
        a = posicion % mitad
        izquierda, derecha = op['izquierda'], op['derecha']
        apertura(hash_funcion, raiz, n, a, izquierda, op['camino_i'])
        apertura(hash_funcion, raiz, n, a+mitad, derecha, op['camino_d'])
        if arrastre is not None:
            exigir(arrastre == (izquierda if posicion < mitad else derecha), fase)
        x = offset*pow(7, ((P-1)//n)*a, P) % P
        par = escalar(sumar(izquierda, derecha), (P+1)//2)
        impar = escalar(restar(izquierda, derecha), ((P+1)//2)*pow(x, -1, P) % P)
        arrastre = sumar(par, multiplicar(beta, impar))
        posicion, n, offset = a, mitad, offset*offset % P
    exigir(arrastre == compromiso['final'], fase)


def verificar(prueba, bits_esperados, hash_funcion=None):
    medidor = hash_funcion or HashMedido()
    t = prueba['T']
    exigir(t in [2**i for i in range(4, 13)], 'filas')
    exigir(prueba['version'] == 1 and prueba['bits'] == bits_esperados and bits_esperados in (12, 20), 'perfil')
    exigir(0 <= prueba['inicio'] < P and 0 <= prueba['salida'] < P, 'no_canonico')
    exigir(len(prueba['raiz']) == 32 and len(prueba['fases']) == 2 and len(prueba['consultas']) == 40, 'forma')
    for fase, k in zip(prueba['fases'], [t.bit_length()-1, t.bit_length()]):
        exigir(len(fase['raices']) == k and all(len(r) == 32 for r in fase['raices']), 'forma')
        exigir(all(0 <= v < P for v in fase['final']), 'no_canonico')
    exigir(prueba['fases'][0]['raices'][0] == prueba['raiz'], 'raiz_traza')
    for consulta in prueba['consultas']:
        exigir(len(consulta['traza']) == 6 and len(consulta['fri']) == 2, 'forma')
        for punto in consulta['traza']:
            exigir(0 <= punto['valor'] < P, 'no_canonico')
            exigir(len(punto['camino']) == (8*t).bit_length()-1 and all(len(h) == 32 for h in punto['camino']), 'forma')
        for capas, k in zip(consulta['fri'], [t.bit_length()-1, t.bit_length()]):
            exigir(len(capas) == k, 'forma')
            for j, op in enumerate(capas):
                exigir(all(0 <= x < P for v in [op['izquierda'], op['derecha']] for x in v), 'no_canonico')
                for camino in [op['camino_i'], op['camino_d']]:
                    exigir(len(camino) == (8*t).bit_length()-1-j and all(len(h) == 32 for h in camino), 'forma')
    canal = Canal(medidor)
    canal.absorber(16, perfil(t, bits_esperados))
    canal.absorber(4, u64(prueba['inicio'])+u64(prueba['salida'])+u64(t))
    canal.absorber(1, prueba['raiz'])
    alphas = [canal.extension() for _ in range(3)]
    betas = []
    for rol, fase in zip([b'trace', b'composition'], prueba['fases']):
        canal.absorber(17, rol)
        retos = []
        for raiz in fase['raices']:
            canal.absorber(2, raiz)
            retos.append(canal.extension())
        canal.absorber(3, codificar(fase['final']))
        betas.append(retos)
    trabajo = medidor(canal.estado+b'\x05'+u64(prueba['nonce']))
    exigir(int.from_bytes(trabajo, 'big') < 2**(256-bits_esperados), 'grinding')
    canal.absorber(5, u64(prueba['nonce']))
    indices = canal.indices(4*t)
    n = 8*t
    for consulta, indice in zip(prueba['consultas'], indices):
        posiciones = [indice, (indice+8) % n, (indice+16) % n,
                      indice+n//2, (indice+n//2+8) % n, (indice+n//2+16) % n]
        valores = [p['valor'] for p in consulta['traza']]
        for punto, posicion in zip(consulta['traza'], posiciones):
            apertura(medidor, prueba['raiz'], n, posicion, (punto['valor'], 0), punto['camino'])
        primera = consulta['fri'][0][0]
        exigir(primera['izquierda'] == (valores[0], 0) and primera['derecha'] == (valores[3], 0), 'enlace_traza')
        verificar_fri(medidor, consulta['fri'][0], prueba['fases'][0], betas[0], indice, n, 'fri_traza')
        x = 7*pow(7, ((P-1)//n)*indice, P) % P
        primera = consulta['fri'][1][0]
        exigir(primera['izquierda'] == composicion(prueba, alphas, x, valores[:3])
                and primera['derecha'] == composicion(prueba, alphas, -x % P, valores[3:]), 'enlace_composicion')
        verificar_fri(medidor, consulta['fri'][1], prueba['fases'][1], betas[1], indice, n, 'fri_composicion')
    esperado = limites(t)['hashes_verificador_maximos']-512+canal.extracciones
    exigir(medidor.total == esperado, 'cuenta_hashes')
    return {'acepta': True, 'extracciones_indices': canal.extracciones, 'hashes': medidor.total,
            'longitudes_entrada': dict(sorted(medidor.cuentas.items()))}
