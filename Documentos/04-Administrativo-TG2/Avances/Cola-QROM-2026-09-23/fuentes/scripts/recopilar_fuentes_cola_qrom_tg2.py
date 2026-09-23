"""Conserva la versión v4 de CFHL21, su matriz local y los hashes de la fuente."""
from argparse import ArgumentParser
from datetime import datetime, timezone
from hashlib import sha256
from pathlib import Path
from urllib.request import Request, urlopen
import json

import pymupdf


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument('--salida', type=Path, required=True)
    destino = parser.parse_args().salida.resolve()
    destino.relative_to(Path(__file__).resolve().parents[1])
    destino.mkdir(parents=True, exist_ok=True)
    pdf, txt, registro = [destino/n for n in ['CFHL21-v4.pdf', 'CFHL21-v4.txt', 'fuentes.json']]
    if any(p.exists() for p in (pdf, txt, registro)):
        raise FileExistsError('La salida debe ser nueva')
    url = 'https://arxiv.org/pdf/2010.11658v4'
    with urlopen(Request(url, headers={'User-Agent': 'NEXUS-TG2-research/1.0'}), timeout=30) as respuesta:
        datos = respuesta.read()
    if not datos.startswith(b'%PDF'):
        raise ValueError('La fuente no es un PDF')
    with pymupdf.open(stream=datos, filetype='pdf') as doc:
        paginas = len(doc)
        portada = doc[0].get_text()
        texto = '\n'.join(f'\n[PÁGINA PDF {i+1}]\n'+p.get_text() for i, p in enumerate(doc))
    if paginas != 33 or '2010.11658v4' not in portada:
        raise ValueError('La fuente no corresponde a la versión identificada')
    with pdf.open('xb') as f:
        f.write(datos)
    with txt.open('x', encoding='utf8', newline='\n') as f:
        f.write(texto)
    fuente = {'id': 'CFHL21-v4', 'url': url, 'version': 'arXiv v4, 9 de julio de 2021',
              'pdf': pdf.name, 'texto': txt.name, 'paginas': paginas,
              'sha256_pdf': sha256(datos).hexdigest(), 'sha256_texto': sha256(txt.read_bytes()).hexdigest(),
              'localizadores': 'Lema 4.3 y figura 1, páginas PDF 11 y 12', 'portada': portada}
    with registro.open('x', encoding='utf8', newline='\n') as f:
        json.dump({'consultada_utc': datetime.now(timezone.utc).isoformat(), 'fuentes': [fuente]}, f,
                  ensure_ascii=False, indent=2)
        f.write('\n')
    print(json.dumps({'paginas': paginas, 'sha256_pdf': fuente['sha256_pdf']}))


if __name__ == '__main__':
    main()
