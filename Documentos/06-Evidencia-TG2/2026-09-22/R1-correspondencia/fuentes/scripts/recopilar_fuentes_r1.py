"""Conserva fuentes primarias y sus huellas para la revisión formal R1."""
from pathlib import Path
import hashlib
import json
import urllib.request
import sys

RAIZ = Path(__file__).resolve().parents[1]
DESTINO = RAIZ / 'Documentos/06-Evidencia-TG2/2026-09-22/R1-correspondencia'
FUENTES = [
    ('B23.pdf', 'https://ir.cwi.nl/pub/33405/33405.pdf'),
    ('JMW24.pdf', 'https://arxiv.org/pdf/2312.16619v2'),
    ('LS15.pdf', 'https://perso.ens-lyon.fr/damien.stehle/downloads/MSIS.pdf'),
    ('DIL21.pdf', 'https://pq-crystals.org/dilithium/data/dilithium-specification-round3-20210208.pdf'),
    ('FIPS204.pdf', 'https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.204.pdf'),
]


def main():
    carpeta = DESTINO / 'bibliografia'
    carpeta.mkdir(parents=True, exist_ok=True)
    sys.path.insert(0, str(RAIZ / '.tools/pdf'))
    import pymupdf
    registros = []
    for nombre, url in FUENTES:
        ruta = carpeta / nombre
        if not ruta.exists():
            with urllib.request.urlopen(url, timeout=45) as respuesta:
                contenido = respuesta.read()
            if not contenido.startswith(b'%PDF'):
                raise ValueError(f'La fuente no es un PDF: {url}')
            ruta.write_bytes(contenido)
        documento = pymupdf.open(ruta)
        paginas = [pagina.get_text() for pagina in documento]
        ruta.with_suffix('.txt').write_text(
            '\n'.join(f'\n[PÁGINA PDF {i+1}]\n{pagina}' for i, pagina in enumerate(paginas)),
            encoding='utf-8')
        registros.append({'archivo': nombre, 'url': url, 'paginas': len(paginas),
                          'sha256': hashlib.sha256(ruta.read_bytes()).hexdigest()})
        print(f'{nombre}: {len(paginas)} páginas', flush=True)
    (DESTINO / 'bibliografia.json').write_text(
        json.dumps({'consulta': '2026-09-22', 'fuentes': registros}, ensure_ascii=False, indent=2)+'\n',
        encoding='utf-8')


if __name__ == '__main__':
    main()
