"""Conserva fuentes primarias QROM y extrae su texto con versión y huellas."""
from argparse import ArgumentParser
from datetime import datetime, timezone
from pathlib import Path
from urllib.request import Request, urlopen
import hashlib
import json

import pymupdf as fitz

FUENTES = [
    ("CMS19", "https://eprint.iacr.org/2019/834.pdf"),
    ("DFM20", "https://arxiv.org/pdf/2003.05207v3"),
]


def huella(datos):
    return hashlib.sha256(datos).hexdigest()


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument("--salida", type=Path, required=True)
    args = parser.parse_args()
    destino = args.salida.resolve()
    destino.relative_to(Path(__file__).resolve().parents[1])
    destino.mkdir(parents=True, exist_ok=True)
    registros = []
    for clave, url in FUENTES:
        pdf, txt = destino/(clave+".pdf"), destino/(clave+".txt")
        if not pdf.exists():
            solicitud = Request(url, headers={"User-Agent": "NEXUS-TG2-research/1.0"})
            with urlopen(solicitud, timeout=60) as respuesta:
                datos = respuesta.read()
            if not datos.startswith(b"%PDF"):
                raise ValueError(f"La respuesta no es PDF: {url}")
            with pdf.open("xb") as archivo:
                archivo.write(datos)
        datos = pdf.read_bytes()
        with fitz.open(stream=datos, filetype="pdf") as documento:
            paginas = len(documento)
            portada = documento[0].get_text()
            texto = "\n".join(f"\n[PÁGINA PDF {i+1}]\n"+p.get_text() for i, p in enumerate(documento))
        if txt.exists():
            if txt.read_text(encoding="utf-8") != texto:
                raise ValueError(f"La extracción conservada difiere: {txt}")
        else:
            with txt.open("x", encoding="utf-8", newline="\n") as archivo:
                archivo.write(texto)
        registros.append({"id": clave, "url": url, "pdf": pdf.name, "texto": txt.name,
                          "paginas": paginas, "sha256_pdf": huella(datos), "sha256_texto": huella(txt.read_bytes()),
                          "portada": portada})
        print(f"{clave}: {paginas} páginas preservadas", flush=True)
    with (destino/"fuentes.json").open("x", encoding="utf-8", newline="\n") as archivo:
        json.dump({"consultada_utc": datetime.now(timezone.utc).isoformat(), "fuentes": registros},
                  archivo, ensure_ascii=False, indent=2)
        archivo.write("\n")


if __name__ == "__main__":
    main()
