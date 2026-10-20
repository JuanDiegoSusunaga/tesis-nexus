"""Conserva la edición previa al acoplamiento del selector ROM."""

import hashlib
import json
from pathlib import Path

root = Path(__file__).resolve().parents[2]
folder = root / "Documentos/06-Evidencia-TG2/2026-10-18"
prep = folder / "Selector-Acoplado-Antecedentes"
previous = folder / "Lean-Ley-Conjunta-ROM/validacion.json"
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
audit = json.loads(previous.read_text(encoding="utf-8"))
assert audit["correcto"] and audit["teoremas_auditados"] == 2063 and len(audit["kernel"]["modulos"]) == 234
assert not prep.exists()
assert all(sha(root / n) == h for n, h in audit["sha256_fuentes"].items())
assert all(sha(previous.parent / n) == h for n, h in audit["sha256_logs"].items())
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
edition = json.loads((root / names[-1]).read_text(encoding="utf-8"))
assert len(edition["archivos"]) == 6278 and edition["qiskit"]["estado"] == "trabajo_futuro"
assert len(pending) == 6
data = {"esquema": 1, "en_preparacion": True,
    "auditoria_previa": {"archivo": previous.relative_to(root).as_posix(), "sha256": sha(previous)},
    "versiones_anteriores": copies, "grupos_iniciales": pending, "edicion_previa": edition,
    "sha256_reglas_git": sha(root / ".gitattributes"),
    "salidas_manuscrito": {p.relative_to(root).as_posix(): sha(p) for p in
        (root / "Documentos/01-Manuscrito").glob("Tesis-NEXUS-completa.*")}}
(prep / "manifiesto.json").write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"versiones_conservadas": len(copies), "edicion_previa": 6278, "parciales": pending}))
