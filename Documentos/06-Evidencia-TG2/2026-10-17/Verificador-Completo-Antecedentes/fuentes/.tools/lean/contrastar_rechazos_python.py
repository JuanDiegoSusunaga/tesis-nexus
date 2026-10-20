"""Relee los cincuenta casos con Python y conserva la diferencia de EOF."""

import hashlib
import json
from pathlib import Path
import sys

sys.stdout.reconfigure(encoding="utf-8")
root = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(root / "scripts"))
from verificar_certificados_tg2 import HashMedido, Rechazo, leer_certificado, verificar

folder = root / "Documentos/06-Evidencia-TG2/2026-10-17/Verificador-Completo-Antecedentes/contraste"
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
records = []
for profile, bits in [("debug", 12), ("release", 20)]:
    report = json.loads((folder / (profile + ".json")).read_text(encoding="utf-8"))
    for case in report["casos"]:
        path = folder / profile / case["archivo_binario"]
        assert path.stat().st_size == case["bytes"]
        data = path.read_bytes()
        assert hashlib.sha3_256(data).hexdigest() == case["sha3_256"], case
        measured, reason = HashMedido(), None
        try:
            proof = leer_certificado(path)
            verificar(proof, bits, measured)
            accepted = True
        except (Rechazo, AssertionError) as error:
            accepted, reason = False, type(error).__name__ + ": " + str(error)
        assert accepted == (case["envoltura_estricta"] == "Acepta"), (profile, case["nombre"], reason)
        records.append({"perfil": profile, "caso": case["nombre"], "archivo": path.relative_to(root).as_posix(),
            "sha256": sha(path), "acepta_python_estricto": accepted, "rust_predeterminado": case["rust"],
            "rust_estricto": case["envoltura_estricta"], "hashes_python": measured.total, "rechazo_python": reason})
assert len(records) == 50 and sum(r["acepta_python_estricto"] for r in records) == 8
report = {"esquema": 1, "correcto": True, "casos": records, "aceptados_estrictos": 8, "rechazados_estrictos": 42,
    "fuentes": {n: sha(root / n) for n in ["scripts/verificar_certificados_tg2.py", "scripts/auditar_merkle_fs_r4.py",
        "scripts/analizar_transferencia_rom_tg2.py", ".tools/lean/contraste-verificador/src/main.rs"]},
    "alcance": "Mismos cincuenta bytes: aceptación/rechazo de Python coincide con Rust envuelto con EOF estricto. Los tipos de error y el orden de lecturas pueden diferir; no es ejecución de Lean ni refinamiento universal. Dos sufijos son aceptados por el bincode predeterminado y rechazados por ambas envolturas estrictas."}
(folder / "contraste-python.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"correcto": True, "casos": len(records), "aceptados": 8, "rechazados": 42}))
