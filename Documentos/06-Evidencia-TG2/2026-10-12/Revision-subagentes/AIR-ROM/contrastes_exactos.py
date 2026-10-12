"""Contraste independiente de cola real, campo y premisas de nueve perfiles.

No importa los analizadores originales. La cola se cuenta por número exacto de
secuencias con a símbolos distintos, en lugar de reutilizar la cota por unión.
"""
from fractions import Fraction
from math import comb
from pathlib import Path
import hashlib
import json

DESTINO = Path(__file__).resolve().parent
RAIZ = next(p for p in DESTINO.parents if (p / "nexus" / "Cargo.toml").exists())
P = 2**64 - 2**32 + 1


def codificar(fraccion):
    return {"numerador": str(fraccion.numerator), "denominador": str(fraccion.denominator)}


def exponente_superior(fraccion):
    """Devuelve e entero con fraccion <= 2^-e, mediante comparación exacta."""
    e = fraccion.denominator.bit_length() - fraccion.numerator.bit_length()
    while fraccion > Fraction(1, 2**e):
        e -= 1
    while fraccion <= Fraction(1, 2**(e+1)):
        e += 1
    return e


def cola_contada(m, q, r):
    # c[a] cuenta todas las secuencias etiquetadas con exactamente a distintos.
    # Los estados a >= q se descartan porque nunca vuelven al evento de cola.
    c = [1] + [0] * (q-1)
    for _ in range(r):
        c = [a*c[a] + ((m-a+1)*c[a-1] if a else 0) for a in range(q)]
    return Fraction(sum(c), m**r)


# Control discriminante: para q=2 la cola equivale a repetir un solo símbolo.
for m in (2, 4, 64):
    for r in (1, 2, 7):
        assert cola_contada(m, 2, r) == Fraction(m, m**r)

assert pow(7, (P-1)//2, P) == P-1, "7 debe ser no cuadrado para Fp2"
perfiles = []
for t in (2**i for i in range(4, 13)):
    n, m = 8*t, 4*t
    assert (P-1) % n == 0
    omega = pow(7, (P-1)//n, P)
    assert pow(omega, n, P) == 1 and pow(omega, n//2, P) != 1
    assert pow(7, n, P) != 1, "El coset podría intersectar el dominio de traza"
    unica = Fraction(n-t+1, n) - Fraction(1, 4)
    margen_enlace = Fraction(5*t+1, n) - Fraction(4, 8)
    margenes = {}
    for fase, grado in (("traza", t), ("composicion", 2*t)):
        margenes[fase] = [Fraction(5, 8)*(n//2**(j+1)) - (grado//2**(j+1)-1)
                          for j in range(grado.bit_length()-1)]
        assert min(margenes[fase]) > 0
    assert unica > 0 and margen_enlace > 0
    exacta = cola_contada(m, 40, 512)
    union = min(Fraction(1), comb(m, 39)*Fraction(39, m)**512)
    assert 0 < exacta <= union < Fraction(1, 2**300)
    perfiles.append({"T": t, "M": m,
                     "margen_unicidad": codificar(unica),
                     "distancia_enlace": codificar(margen_enlace),
                     "margenes_plegado": {k: [codificar(x) for x in v] for k, v in margenes.items()},
                     "cola_exacta": codificar(exacta), "cola_union": codificar(union),
                     "cola_exacta_le_2_menos": exponente_superior(exacta),
                     "cola_union_le_2_menos": exponente_superior(union)})

# Correspondencia material entre código actual y la instantánea de transferencia.
archivos = ["nexus/nexus-zk/experiments/tg2_linked_trace_fri.rs",
            "nexus/nexus-zk/src/stark/field.rs", "nexus/nexus-zk/src/stark/fri.rs",
            "nexus/nexus-zk/src/stark/channel.rs", "nexus/nexus-zk/src/stark/merkle.rs",
            "nexus/nexus-zk/src/stark/params.rs", "nexus/nexus-core/src/types.rs"]
correspondencia = []
for nombre in archivos:
    actual = RAIZ / nombre
    preservado = RAIZ / "Documentos/04-Administrativo-TG2/Avances/Transferencia-ROM-2026-09-23/fuentes" / nombre
    h_actual = hashlib.sha256(actual.read_bytes()).hexdigest()
    h_preservado = hashlib.sha256(preservado.read_bytes()).hexdigest()
    assert h_actual == h_preservado, f"Código cambiado respecto del objeto revisado: {nombre}"
    correspondencia.append({"archivo": nombre, "sha256": h_actual, "identico_instantanea": True})

resultado = {"fecha": "2026-10-12", "estado": "Contraste interno exacto; no dictamen académico",
             "alcance": "Nueve perfiles de TG2 v1; monedas ideales independientes; ROM clásico",
             "no_establece": "Seguridad QROM, SHA3 incondicional, 100 bits, ZK ni tiempo máximo del selector",
             "perfiles": perfiles, "codigo": correspondencia}
(DESTINO / "contrastes-exactos.json").write_text(json.dumps(resultado, ensure_ascii=False, indent=2)+"\n", encoding="utf-8")
print("Nueve perfiles: unicidad, plegados, extensión, cosets y cola exacta correctos.")
print("Siete archivos Rust coinciden con la instantánea revisada.")
print("Exponentes de cola por unión:", [x["cola_union_le_2_menos"] for x in perfiles])
print("Exponentes de cola exacta:", [x["cola_exacta_le_2_menos"] for x in perfiles])
