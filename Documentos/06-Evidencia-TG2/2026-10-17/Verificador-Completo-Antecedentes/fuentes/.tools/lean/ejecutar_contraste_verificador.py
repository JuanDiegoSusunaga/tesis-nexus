"""Ejecuta check/test/build y los dos perfiles del contraste sin ventanas."""

import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

sys.stdout.reconfigure(encoding="utf-8")
root = Path(__file__).resolve().parents[2]
prep = root / "Documentos/06-Evidencia-TG2/2026-10-17/Verificador-Completo-Antecedentes"
out = prep / "contraste"
out.mkdir(exist_ok=True)
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
before = {p.relative_to(root).as_posix(): sha(p) for p in (root / "nexus").rglob("*.rs") if "target" not in p.parts}
env = os.environ.copy()
target = root / ".tools/lean/target-exportador"
env["CARGO_TARGET_DIR"] = str(target)
manifest = str(root / ".tools/lean/contraste-verificador/Cargo.toml")
lock = root / ".tools/lean/contraste-verificador/Cargo.lock"
if not lock.exists():
    # Se reutilizan resoluciones históricas descargadas; no se actualizan dependencias.
    text = (root / ".tools/lean/exportador-legado/Cargo.lock").read_text(encoding="utf-8")
    anchor = 'name = "tg2-exportador-legado"'
    start, end = text.index(anchor), text.index('[[package]]', text.index(anchor) + 1)
    package = text[start:end].replace("tg2-exportador-legado", "tg2-contraste-verificador")
    package = package.replace(' "bincode",', ' "bincode",\n "nexus-core",')
    lock.write_text(text[:start] + package + text[end:], encoding="utf-8")
corpus = str(root / "Documentos/06-Evidencia-TG2/2026-09-22/R4-FRI-vinculado")
commands = [
    ("cargo-check", ["cargo", "check", "--offline", "--manifest-path", manifest]),
    ("cargo-test", ["cargo", "test", "--offline", "--manifest-path", manifest]),
    ("cargo-build", ["cargo", "build", "--offline", "--manifest-path", manifest]),
    ("contraste-debug", [str(target / "debug/tg2-contraste-verificador.exe"), corpus, str(out / "debug.json")]),
    ("cargo-build-release", ["cargo", "build", "--offline", "--release", "--manifest-path", manifest]),
    ("contraste-release", [str(target / "release/tg2-contraste-verificador.exe"), corpus, str(out / "release.json")]),
]
records = []
for name, command in commands:
    log = out / (name + ".log")
    index = 1
    while log.exists():
        index += 1
        log = out / (name + "-" + str(index) + ".log")
    print("Ejecutando " + name, flush=True)
    with log.open("wb") as stream:
        result = subprocess.run(command, cwd=root, env=env, stdout=stream, stderr=subprocess.STDOUT,
            creationflags=subprocess.CREATE_NO_WINDOW)
    records.append({"nombre": name, "argumentos": command, "codigo": result.returncode,
        "archivo": log.relative_to(root).as_posix(), "sha256": sha(log)})
    if result.returncode:
        print(log.read_text(encoding="utf-8", errors="replace"))
        raise SystemExit(result.returncode)
    print(name + " correcto", flush=True)
assert all(sha(root / n) == h for n, h in before.items())
reports = [json.loads((out / (p + ".json")).read_text(encoding="utf-8")) for p in ("debug", "release")]
assert all(r["correcto"] for r in reports)
data = {"esquema": 1, "correcto": True, "ejecuciones": records, "fuentes_rust_inalteradas": before,
    "casos": sum(len(r["casos"]) for r in reports), "casos_por_perfil": {r["perfil"]: len(r["casos"]) for r in reports},
    "diferencia_sufijos": "bincode::deserialize admite la cola; la envoltura EOF estricta la rechaza.",
    "alcance": "Pruebas del paquete auxiliar y contraste de ejemplos, sin ejecutar Lean ni demostrar equivalencia universal Rust/Lean."}
(out / "validacion.json").write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"correcto": True, "casos": data["casos"]}))
