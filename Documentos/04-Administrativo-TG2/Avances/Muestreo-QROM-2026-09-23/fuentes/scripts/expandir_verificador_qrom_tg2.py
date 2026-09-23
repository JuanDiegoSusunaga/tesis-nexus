"""Expansión acotada del verificador y repetición sin acceso a H; herramienta de prueba."""
from dataclasses import dataclass
from hashlib import sha3_256, sha256

from verificar_certificados_tg2 import verificar, HashMedido, Rechazo
from analizar_transferencia_rom_tg2 import limites
from auditar_merkle_fs_r4 import DOMINIO


class FinDelCorte(Exception):
    pass


class ConsultaAusente(ValueError):
    pass


@dataclass(frozen=True)
class Expansion:
    resultado: str
    motivo: str | None
    pares: tuple
    llamadas: int
    extracciones: int
    maximo: int
    corte: int

    @property
    def gana_ampliado(self):
        return self.resultado in ('acepta', 'cola')

    def tabla(self):
        return dict(self.pares)

    def huella(self):
        datos = b''.join(len(x).to_bytes(8, 'little')+x+y for x, y in self.pares)
        return sha256(datos).hexdigest()


class RegistroAcotado(HashMedido):
    def __init__(self, corte, tabla=None):
        super().__init__()
        self.corte, self.tabla_fuente = corte, tabla
        self.pares, self.extracciones = [], 0

    def __call__(self, entrada):
        if len(entrada) == 33 and entrada[-1:] == b'I':
            if self.extracciones == self.corte:
                raise FinDelCorte()
            self.extracciones += 1
        if self.tabla_fuente is None:
            salida = sha3_256(entrada).digest()
        else:
            if entrada not in self.tabla_fuente:
                raise ConsultaAusente("Falta una respuesta de la expansión")
            salida = self.tabla_fuente[entrada]
            if not isinstance(salida, bytes) or len(salida) != 32:
                raise ValueError("Respuesta de oráculo inválida")
        self.cuentas[len(entrada)] += 1
        self.pares.append((entrada, salida))
        return salida


def expandir(prueba, bits, corte=512, tabla=None):
    if not 40 <= corte <= 512:
        raise ValueError("Corte fuera del modelo comprobado")
    maximo = limites(prueba['T'], extracciones=corte)['hashes_verificador_maximos']
    registro = RegistroAcotado(corte, tabla)
    try:
        verificar(prueba, bits, registro)
        resultado, motivo = 'acepta', None
    except FinDelCorte:
        resultado, motivo = 'cola', 'sin_40_distintos_en_el_corte'
    except Rechazo as error:
        if str(error) == 'limite_auditor' and corte == 512 and registro.extracciones == 512:
            resultado, motivo = 'cola', 'sin_40_distintos_en_el_corte'
        else:
            resultado, motivo = 'rechaza', str(error)
    # Longitud fija para el juego: repetir un par ya consultado no cuesta hashes.
    if not registro.pares:
        registro(DOMINIO)
    if registro.total > maximo:
        raise ArithmeticError("La expansión excede el presupuesto")
    pares = tuple(registro.pares)+tuple([registro.pares[0]]*(maximo-len(registro.pares)))
    return Expansion(resultado, motivo, pares, registro.total, registro.extracciones, maximo, corte)


def repetir_expansion(prueba, bits, expansion):
    tabla = {}
    for entrada, salida in expansion.pares:
        if entrada in tabla and tabla[entrada] != salida:
            raise ValueError("La expansión da dos respuestas a la misma entrada")
        tabla[entrada] = salida
    repetida = expandir(prueba, bits, expansion.corte, tabla)
    if repetida != expansion:
        raise ValueError("La expansión no reproduce el verificador acotado")
    return repetida
