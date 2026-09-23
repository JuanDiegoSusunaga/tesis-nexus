"""Comprueba parámetros y calcula escenarios de las fuentes formales de R1."""
from pathlib import Path
from decimal import Decimal, localcontext
import ast
import hashlib
import json
import re
import shutil

RAIZ = Path(__file__).resolve().parents[1]
DESTINO = RAIZ / 'Documentos/06-Evidencia-TG2/2026-09-22/R1-correspondencia'
REGISTRO = Path.home() / '.cargo/registry/src'


def evaluar(expr, nombres):
    nodo = ast.parse(expr, mode='eval').body
    def valor(n):
        if isinstance(n, ast.Constant) and isinstance(n.value, int):
            return n.value
        if isinstance(n, ast.Name):
            return nombres[n.id]
        if isinstance(n, ast.BinOp):
            a, b = valor(n.left), valor(n.right)
            if isinstance(n.op, ast.Add):
                return a+b
            if isinstance(n.op, ast.Sub):
                return a-b
            if isinstance(n.op, ast.LShift):
                return a << b
            if isinstance(n.op, ast.Div):
                if a % b:
                    raise ValueError('Se esperaba división entera exacta.')
                return a//b
        raise ValueError(f'Expresión no admitida: {expr}')
    return valor(nodo)


def huella(ruta):
    return hashlib.sha256(ruta.read_bytes()).hexdigest()


def main():
    candidatos = list(REGISTRO.glob('*/fips204-0.4.6'))
    if len(candidatos) != 1:
        raise ValueError('Se esperaba un único backend fips204 0.4.6.')
    backend = candidatos[0]
    texto = (backend/'src/lib.rs').read_text(encoding='utf-8')
    q = evaluar(re.search(r'const Q: i32 = ([^;]+);', texto)[1], {})
    d = evaluar(re.search(r'const D: u32 = ([^;]+);', texto)[1], {})
    parametros, contraste = [], []
    for nivel in ['44', '65', '87']:
        bloque = texto.split(f'pub mod ml_dsa_{nivel} {{', 1)[1].split('functionality!();', 1)[0]
        valores = {'nivel': nivel, 'Q': q, 'D': d, 'N': 256}
        for nombre, expr in re.findall(r'(?:pub )?const (\w+): \w+ = ([^;]+);', bloque):
            valores[nombre] = evaluar(expr, valores)
        valores['BETA'] = valores['TAU']*valores['ETA']
        parametros.append(valores)
        # Traducción de §4, ec. (38), de JMW24 al contraste de su condición.
        zeta = max(valores['GAMMA1']-valores['BETA'],
                   2*valores['GAMMA2']+1+(2**(d-1))*valores['TAU'])
        dimension = valores['K']+valores['L']+1
        izquierdo_minimo = 2*zeta*256*dimension
        derecho = q//32
        assert q % (2*256) == 1
        assert izquierdo_minimo >= derecho
        contraste.append({
            'nivel': nivel, 'zeta': zeta, 'm_mas_k_teorema': dimension,
            'eta_auxiliar_minima': 1, 'lado_izquierdo_minimo': izquierdo_minimo,
            'lado_derecho': derecho, 'cumple_desigualdad_estricta': False,
            'limite': 'Descarta esta aplicación directa del Teorema 2; no demuestra un ataque ni imposibilidad de otra reducción.',
        })
    with localcontext() as contexto:
        contexto.prec = 80
        dos = Decimal(2)
        qs, qh = dos**64, dos**192
        p = Decimal(103)/128
        eps, delta = dos**-1180, dos**-362
        primero = 2*qs*eps.sqrt()/(1-p)*(qh+1+qs/(1-p)).sqrt()
        segundo = 2*(qh+1)*(qs*eps/(1-p)).sqrt()
        perdida = primero+segundo+delta
        assert perdida <= dos**-360
        escenario = {
            'fuente': 'B+23, §7, Figura 8, fila QROM NIST3 (PDF p. 31)',
            'log2_qS': 64, 'log2_qH': 192, 'p': '103/128',
            'log2_epsilon': -1180, 'log2_delta': -362, 'zeta_zk': 0,
            'log2_L_estrella': str(perdida.ln()/dos.ln()),
            'cumple_cota_publicada_2_menos_360': True,
            'limite': 'Reproducción aritmética del escenario del artículo; p usa su heurística. No es cota de NEXUS ni prueba de sus hipótesis.',
        }
    fuentes = []
    rutas = [
        RAIZ/'nexus/nexus-crypto/src/dilithium.rs',
        RAIZ/'nexus/nexus-crypto/src/keypair.rs',
        RAIZ/'nexus/nexus-crypto/src/entropy.rs',
        RAIZ/'nexus/nexus-crypto/tests/tg2_correspondence.rs',
        RAIZ/'nexus/Cargo.toml', RAIZ/'nexus/Cargo.lock',
        Path(__file__), RAIZ/'scripts/recopilar_fuentes_r1.py',
    ]
    rutas += [backend/'src'/nombre for nombre in
              ['lib.rs', 'traits.rs', 'ml_dsa.rs', 'types.rs', 'hashing.rs', 'conversion.rs']]
    for ruta in rutas:
        if ruta.is_relative_to(RAIZ):
            relativo = ruta.relative_to(RAIZ)
        else:
            relativo = Path('backend-fips204-0.4.6')/ruta.relative_to(backend)
        copia = DESTINO/'fuentes'/relativo
        copia.parent.mkdir(parents=True, exist_ok=True)
        if copia.exists() and copia.read_bytes() != ruta.read_bytes():
            raise ValueError(f'La instantánea ya existe y difiere: {relativo}')
        if not copia.exists():
            shutil.copy2(ruta, copia)
        fuentes.append({'archivo': relativo.as_posix(), 'sha256': huella(ruta)})
    informe = {
        'fecha': '2026-09-22', 'backend': 'fips204 0.4.6', 'parametros': parametros,
        'contraste_jmw24': contraste, 'escenario_b23': escenario, 'fuentes': fuentes,
        'alcance': 'Auditoría de correspondencia y aritmética reproducible; no verificación formal del binario.',
    }
    (DESTINO/'correspondencia.json').write_text(
        json.dumps(informe, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    tabla = ['| ML-DSA | Zeta | m+k del teorema | Lado izquierdo mínimo | Lado derecho |',
             '|---|---:|---:|---:|---:|']
    for fila in contraste:
        tabla.append(f"| {fila['nivel']} | {fila['zeta']} | {fila['m_mas_k_teorema']} | "
                     f"{fila['lado_izquierdo_minimo']} | {fila['lado_derecho']} |")
    (DESTINO/'contraste-jmw24.md').write_text('\n'.join(tabla)+'\n', encoding='utf-8')
    print('\n'.join(tabla))
    print('B+23: log2(L*) =', escenario['log2_L_estrella'])


if __name__ == '__main__':
    main()
