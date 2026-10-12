"""Conserva fuentes primarias recientes para contraste textual de AIR/ROM."""
from pathlib import Path
import hashlib
import json
import urllib.request
from datetime import datetime, timezone

BASE = Path(__file__).resolve().parent
FUENTES = {
    "GMW25-2026-09-25": "https://eprint.iacr.org/2025/1993.pdf",
    "BCS16-vigente": "https://eprint.iacr.org/2016/116.pdf",
    "BGK23-vigente": "https://eprint.iacr.org/2023/1071.pdf",
}

registro = []
for nombre, url in FUENTES.items():
    entrada = {"nombre": nombre, "url": url, "consultado_utc": datetime.now(timezone.utc).isoformat()}
    try:
        solicitud = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(solicitud, timeout=45) as respuesta:
            datos = respuesta.read()
            entrada["url_final"] = respuesta.url
            entrada["content_type"] = respuesta.headers.get("Content-Type")
        if not datos.startswith(b"%PDF"):
            raise ValueError("La respuesta no contiene un PDF")
        ruta = BASE / "bibliografia" / (nombre + ".pdf")
        ruta.parent.mkdir(parents=True, exist_ok=True)
        ruta.write_bytes(datos)
        entrada.update(archivo=str(ruta.relative_to(BASE)), sha256=hashlib.sha256(datos).hexdigest(), bytes=len(datos), estado="conservado")
    except Exception as error:
        entrada.update(estado="no_descargado", error=str(error))
    registro.append(entrada)
    print(json.dumps(entrada, ensure_ascii=True))
(BASE / "fuentes-web.json").write_text(json.dumps(registro, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
