"""Conserva la edición previa al ampliar el programa del verificador TG2."""

import hashlib
import json
from pathlib import Path

root = Path(__file__).resolve().parents[2]
folder = root / "Documentos/06-Evidencia-TG2/2026-10-17"
prep = folder / "Verificador-Completo-Antecedentes"
previous = folder / "Lean-Certificado-Gramatica/validacion.json"
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
audit = json.loads(previous.read_text(encoding="utf-8"))
assert audit["correcto"] and audit["teoremas_auditados"] == 1756 and len(audit["kernel"]["modulos"]) == 196
assert not prep.exists()
assert all(sha(root / p) == h for p, h in audit["sha256_fuentes"].items())
assert all(sha(previous.parent / p) == h for p, h in audit["sha256_logs"].items())
names = ["formalizacion/Nexus.lean", "formalizacion/Auditoria.lean", "formalizacion/cobertura.json",
    "formalizacion/inventario-manuscrito.json", "formalizacion/revision-manuscrito.json",
    "scripts/verificar_formalizacion.py", "formalizacion/README.md", "formalizacion/ALCANCE-MANUSCRITO.md",
    "formalizacion/REVISION-MANUSCRITO.md", "README.md", "BITACORA_TG2.md", "PENDIENTES.md",
    "Documentos/06-Evidencia-TG2/README.md", "Documentos/01-Manuscrito/README.md",
    "Documentos/04-Administrativo-TG2/Entrega-Final/README.md",
    "Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json"]
copies = {}
for name in names:
    target = prep / "version_anterior" / name
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes((root / name).read_bytes())
    copies[name] = {"archivo": target.relative_to(root).as_posix(), "sha256": sha(target)}
review = json.loads((root / "formalizacion/revision-manuscrito.json").read_text(encoding="utf-8"))
pending = [g["id"] for g in review["obligaciones"] if g["estado"] == "parcial"]
assert pending == ["M26", "M35", "M36", "M37", "M39", "M40", "M41"]
edition = json.loads((root / names[-1]).read_text(encoding="utf-8"))
assert len(edition["archivos"]) == 5051
manifest = {"esquema": 1, "en_preparacion": True,
    "auditoria_previa": {"archivo": previous.relative_to(root).as_posix(), "sha256": sha(previous)},
    "versiones_anteriores": copies, "grupos_iniciales": pending, "edicion_previa": edition,
    "sha256_reglas_git": sha(root / ".gitattributes"),
    "salidas_manuscrito": {p.relative_to(root).as_posix(): sha(p) for p in
        (root / "Documentos/01-Manuscrito").glob("Tesis-NEXUS-completa.*")}}
(prep / "manifiesto.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"versiones_conservadas": len(copies), "parciales": pending, "edicion_previa": 5051}))
