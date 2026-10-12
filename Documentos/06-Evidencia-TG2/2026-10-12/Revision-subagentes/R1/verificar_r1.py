"""Verifica correspondencias R1 sin modificar sus instantáneas históricas."""
from pathlib import Path
from decimal import Decimal, localcontext
import ast
import hashlib
import json
import re
import sys
import urllib.request

BASE = Path(__file__).resolve().parent
RAIZ = BASE.parents[4]
sys.path.insert(0, str(RAIZ / '.tools/pdf'))
HIST = RAIZ / 'Documentos/06-Evidencia-TG2/2026-09-22/R1-correspondencia'

def huella(ruta):
    return hashlib.sha256(ruta.read_bytes()).hexdigest()

def evaluar(expr, nombres):
    def recorrer(n):
        if isinstance(n, ast.Constant) and isinstance(n.value, int): return n.value
        if isinstance(n, ast.Name): return nombres[n.id]
        if isinstance(n, ast.BinOp):
            a, b = recorrer(n.left), recorrer(n.right)
            if isinstance(n.op, ast.Add): return a+b
            if isinstance(n.op, ast.Sub): return a-b
            if isinstance(n.op, ast.LShift): return a << b
            if isinstance(n.op, ast.Div) and a % b == 0: return a//b
        raise ValueError(expr)
    return recorrer(ast.parse(expr, mode='eval').body)

def main():
    fuentes = []
    # Las páginas de registro se consultaron por web; aquí se fijan los bytes descargados.
    for nombre, url in [
        ('FFH25-eprint-actual.pdf', 'https://eprint.iacr.org/2025/985.pdf'),
        ('FFH25-CWI.pdf', 'https://ir.cwi.nl/pub/35239/35239.pdf'),
        ('B23-CWI-actual.pdf', 'https://ir.cwi.nl/pub/33405/33405.pdf'),
        ('JMW24-v2-actual.pdf', 'https://arxiv.org/pdf/2312.16619v2'),
        ('FIPS204-errata-actual.xlsx', 'https://csrc.nist.gov/files/pubs/fips/204/final/docs/fips-204-potential-updates.xlsx'),
    ]:
        ruta = BASE / nombre
        entrada = {'archivo': nombre, 'url': url, 'fecha_consulta': '2026-10-12'}
        try:
            solicitud = urllib.request.Request(url, headers={'User-Agent': 'NEXUS-TG2-revision/1.0'})
            with urllib.request.urlopen(solicitud, timeout=45) as respuesta:
                datos = respuesta.read()
                entrada['url_final'] = respuesta.geturl()
            ruta.write_bytes(datos)
            entrada.update({'bytes': len(datos), 'sha256': huella(ruta)})
            if nombre.endswith('.pdf'):
                import pymupdf
                with pymupdf.open(ruta) as doc:
                    entrada['paginas'] = len(doc)
                    texto = '\n'.join(f'[PAGINA PDF {i+1}]\n' + p.get_text() for i,p in enumerate(doc))
                ruta.with_suffix('.txt').write_text(texto, encoding='utf-8')
        except Exception as error:
            entrada['error'] = f'{type(error).__name__}: {error}'
        fuentes.append(entrada)
    copias = {
        'B23-CWI-actual.pdf': HIST/'bibliografia/B23.pdf',
        'JMW24-v2-actual.pdf': HIST/'bibliografia/JMW24.pdf',
        'FIPS204-errata-actual.xlsx': HIST/'bibliografia/FIPS204-errata.xlsx',
    }
    for f in fuentes:
        if f['archivo'] in copias and 'sha256' in f:
            f['sha256_preservado'] = huella(copias[f['archivo']])
            f['bytes_iguales_instantanea'] = f['sha256'] == f['sha256_preservado']
    backend = next((Path.home()/'.cargo/registry/src').glob('*/fips204-0.4.6'))
    comparacion = []
    for nombre in ['lib.rs','traits.rs','ml_dsa.rs','hashing.rs','conversion.rs','types.rs']:
        actual = backend/'src'/nombre
        previo = HIST/'fuentes/backend-fips204-0.4.6/src'/nombre
        comparacion.append({'archivo': nombre, 'sha256_actual': huella(actual),
                            'sha256_preservado': huella(previo), 'identico': huella(actual)==huella(previo)})
    texto = (backend/'src/lib.rs').read_text(encoding='utf-8')
    q = evaluar(re.search(r'const Q: i32 = ([^;]+);', texto)[1], {})
    d = evaluar(re.search(r'const D: u32 = ([^;]+);', texto)[1], {})
    perfiles = []
    for nivel in ['44','65','87']:
        bloque = texto.split(f'pub mod ml_dsa_{nivel} {{')[1].split('functionality!();')[0]
        v = {'Q': q,'D': d}
        for nombre,expr in re.findall(r'(?:pub )?const (\w+): \w+ = ([^;]+);', bloque): v[nombre] = evaluar(expr,v)
        beta = v['TAU']*v['ETA']
        zeta = max(v['GAMMA1']-beta,2*v['GAMMA2']+1+2**(d-1)*v['TAU'])
        lhs = 2*zeta*256*(v['K']+v['L']+1)
        assert lhs >= q//32
        # Conteo aritmético del contador; no produce un ataque ni fuerza firmas patológicas.
        completas = 65536//v['L']
        perfiles.append({'nivel':nivel,'zeta':zeta,'jmw_lhs_eta_1':lhs,'jmw_rhs':q//32,
                         'jmw_aplica':False,'L':v['L'],
                         'intentos_mascara_completos_antes_desborde':completas,
                         'siguiente_intento':completas+1,
                         'tipo_desborde': 'incremento tras rechazo' if 65536 % v['L']==0 else 'mu+r dentro de ExpandMask'})
    with localcontext() as ctx:
        ctx.prec = 100
        dos=Decimal(2); qs=dos**64; qh=dos**192; p=Decimal(103)/128
        eps=dos**-1180; delta=dos**-362
        b23=2*qs*eps.sqrt()/(1-p)*(qh+1+qs/(1-p)).sqrt()+2*(qh+1)*(qs*eps/(1-p)).sqrt()+delta
        # FFH25 Cor.1, mismo evento B23 como comparación aritmética condicionada.
        ffh=8*qs*((qh+1)*eps).sqrt()/(1-p)+delta
        assert b23 < dos**-360
        perdida={'B23_log2':str(b23.ln()/dos.ln()),'FFH25_mismos_datos_B23_log2':str(ffh.ln()/dos.ln()),
                 'limite':'Mismas hipótesis y mismo evento del artículo B23; no tabla optimizada FFH25, no cota del ejecutable.'}
    entradas = ['nexus/nexus-crypto/src/dilithium.rs','nexus/nexus-crypto/src/entropy.rs',
                'nexus/nexus-crypto/src/keypair.rs','nexus/nexus-crypto/src/signer.rs',
                'nexus/nexus-core/src/transaction.rs','nexus/nexus-core/src/types.rs','nexus/Cargo.toml','nexus/Cargo.lock']
    entradas = [{'archivo': p, 'sha256': huella(RAIZ/p)} for p in entradas]
    informe={'fecha':'2026-10-12','fuentes_web':fuentes,'backend':comparacion,'entradas_codigo':entradas,
             'perfiles':perfiles,'perdidas':perdida,
             'alcance':'Revisión interna de fuentes y aritmética; sin dictamen académico, sin ensayo de desborde real.'}
    (BASE/'verificacion.json').write_text(json.dumps(informe,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({'perfiles':perfiles,'perdidas':perdida,'fuentes':fuentes,'backend_identico':all(c['identico'] for c in comparacion)},ensure_ascii=False,indent=2))

if __name__ == '__main__': main()
