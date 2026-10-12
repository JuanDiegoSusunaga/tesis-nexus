"""Verifica enlaces locales del informe y conserva su trazabilidad interna."""
from pathlib import Path
import hashlib
import json
import re
from urllib.parse import unquote

BASE = Path(__file__).resolve().parent
RAIZ = next(p for p in BASE.parents if (p / "nexus" / "Cargo.toml").exists())
INFORME = RAIZ / "Documentos/04-Administrativo-TG2/Avances/Revision-Subagentes-2026-10-12/Revision-AIR-ROM.md"
enlaces = []
for valor in re.findall(r"\[[^\]]+\]\(([^)]+)\)", INFORME.read_text(encoding="utf-8")):
    if valor.startswith(("http://", "https://", "#")):
        continue
    ruta = (INFORME.parent / unquote(valor.split("#", 1)[0])).resolve()
    assert ruta.is_file(), f"Enlace local ausente: {valor}"
    enlaces.append(valor)
archivos = [INFORME] + sorted(p for p in BASE.rglob("*") if p.is_file() and p.name != "verificacion-informe.json")
resultado = {"fecha": "2026-10-12", "alcance": "Enlaces e integridad del informe interno AIR/ROM",
             "enlaces_locales": enlaces,
             "archivos": [{"ruta": p.relative_to(RAIZ).as_posix(), "sha256": hashlib.sha256(p.read_bytes()).hexdigest(), "bytes": p.stat().st_size} for p in archivos],
             "dictamen_externo": False, "reabre_QROM": False}
(BASE / "verificacion-informe.json").write_text(json.dumps(resultado, ensure_ascii=False, indent=2)+"\n", encoding="utf-8")
print(f"Informe: {len(enlaces)} enlaces locales correctos, {len(archivos)} archivos registrados.")
