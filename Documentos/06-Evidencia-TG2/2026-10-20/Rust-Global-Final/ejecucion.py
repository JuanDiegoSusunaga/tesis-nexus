"""Verifica una sola vez el workspace Rust consolidado, sin alterar sus fuentes."""
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import time

RAIZ = Path(__file__).resolve().parents[1]
CODIGO = RAIZ / "nexus"
SALIDA = RAIZ / "Documentos/06-Evidencia-TG2/2026-10-20/Rust-Global-Final"
COMMIT = "637e77c99e804664915caf4ed928a10ef81cc870"
BANDERAS = getattr(subprocess, "CREATE_NO_WINDOW", 0)


def sha(ruta):
    return hashlib.sha256(ruta.read_bytes()).hexdigest()


def registro(ruta):
    return {"archivo": ruta.relative_to(RAIZ).as_posix(), "bytes": ruta.stat().st_size, "sha256": sha(ruta)}


def leer(ruta):
    return json.loads(ruta.read_text(encoding="utf-8-sig"))


def texto(comando):
    return subprocess.check_output(comando, cwd=RAIZ, text=True, encoding="utf-8",
        errors="replace", creationflags=BANDERAS).strip()


def guardar(datos):
    (SALIDA / "verificacion.json").write_text(json.dumps(datos, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def main():
    assert texto(["git", "-C", str(CODIGO), "rev-parse", "HEAD"]) == COMMIT
    assert not texto(["git", "-C", str(CODIGO), "status", "--porcelain", "--untracked-files=all"])
    fuentes = [registro(CODIGO / n) for n in texto(["git", "-C", str(CODIGO), "ls-files"]).splitlines()]
    consolidacion_ruta = RAIZ / "Documentos/06-Evidencia-TG2/2026-10-20/ActiveChain/consolidacion.json"
    lean_ruta = RAIZ / "Documentos/06-Evidencia-TG2/2026-10-20/Lean-Global/verificacion.json"
    lean = leer(lean_ruta)
    anterior = leer(consolidacion_ruta)
    assert len(fuentes) == 89
    assert {i["archivo"]: i["sha256"] for i in fuentes} == {
        i["archivo"]: i["sha256"] for i in anterior["fuentes_y_configuracion"]}
    fuentes_lean = lean["fuentes_sha256"]
    for item in fuentes_lean:
        assert sha(RAIZ / item["archivo"]) == item["sha256"], item["archivo"]
    manuscrito = RAIZ / "Documentos/01-Manuscrito"
    salidas = [registro(p) for p in sorted((manuscrito / "Capitulos").glob("*.md"))]
    salidas += [registro(manuscrito / ("Tesis-NEXUS-completa" + s)) for s in [".md", ".docx", ".pdf"]]
    SALIDA.mkdir(parents=True, exist_ok=False)
    respaldos = []
    for nombre in ["PENDIENTES.md", "BITACORA_TG2.md", "Documentos/01-Manuscrito/README.md",
        "Documentos/04-Administrativo-TG2/Entrega-Final/README.md",
        "Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json", "Documentos/06-Evidencia-TG2/README.md"]:
        destino = SALIDA / "respaldo_previo" / nombre
        destino.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(RAIZ / nombre, destino)
        assert sha(destino) == sha(RAIZ / nombre)
        respaldos.append(registro(destino))
    entorno = os.environ.copy()
    entorno["CARGO_TARGET_DIR"] = "C:/tmp/nexus-target"
    entorno["RUST_TEST_THREADS"] = "4"
    datos = {"fecha": "2026-10-20", "inicio_utc": datetime.now(timezone.utc).isoformat(),
        "estado": "en_ejecucion", "correcto": False,
        "autorizacion": "Dale a una sola pasada global final de check/test/build Rust, caché y cuatro trabajos, sin Lean.",
        "commit_codigo": COMMIT, "arbol_git": texto(["git", "-C", str(CODIGO), "rev-parse", "HEAD^{tree}"]),
        "rustc": texto(["rustc", "-Vv"]), "cargo": texto(["cargo", "-V"]),
        "target_dir": entorno["CARGO_TARGET_DIR"], "jobs": 4, "hilos_pruebas": 4,
        "perfil": "desarrollo", "locked": True, "offline": True, "limpieza_cache": False,
        "global": True, "all_features": False, "lean_recompilado": False, "fuentes_modificadas": False,
        "manuscrito_regenerado": False, "commit_creado": False, "push_realizado": False,
        "fuentes_sha256": fuentes, "fuentes_lean_sha256": fuentes_lean,
        "manuscrito_sha256": salidas, "respaldos_previos": respaldos,
        "consolidacion_rust_previa": registro(consolidacion_ruta), "auditoria_lean_previa": registro(lean_ruta),
        "pasos": [], "limite": "Verifica este workspace y sus casos de prueba; no prueba equivalencia universal Rust/Lean, validez L2 completa ni seguridad integral."}
    guardar(datos)
    for etapa, extras in [("check", ["--all-targets"]), ("test", []), ("build", [])]:
        comando = ["cargo", etapa, "--workspace", *extras, "--locked", "--offline", "--jobs", "4",
            "--manifest-path", str(CODIGO / "Cargo.toml")]
        log = SALIDA / ("cargo-" + etapa + ".log")
        inicio = time.monotonic()
        print("Inicia " + etapa + " global", flush=True)
        with log.open("wb") as flujo:
            proceso = subprocess.run(comando, cwd=RAIZ, env=entorno, stdout=flujo,
                stderr=subprocess.STDOUT, creationflags=BANDERAS, check=False)
        contenido = log.read_text(encoding="utf-8", errors="replace")
        resumen = re.findall(r"test result: (\w+)\. (\d+) passed; (\d+) failed; (\d+) ignored; (\d+) measured; (\d+) filtered out", contenido)
        paso = {"etapa": etapa, "comando": comando, "codigo_salida": proceso.returncode,
            "duracion_segundos": round(time.monotonic() - inicio, 3),
            "registro": log.relative_to(RAIZ).as_posix(), "sha256": sha(log),
            "advertencias_diagnosticas": sum(l.startswith("warning:") and "generated" not in l for l in contenido.splitlines()),
            "resumenes_test": [{"estado": r[0], "pasaron": int(r[1]), "fallaron": int(r[2]),
                "ignoradas": int(r[3]), "medidas": int(r[4]), "filtradas": int(r[5])} for r in resumen]}
        datos["pasos"].append(paso)
        guardar(datos)
        print(json.dumps({"etapa": etapa, "codigo_salida": proceso.returncode,
            "segundos": paso["duracion_segundos"], "pruebas": sum(int(r[1]) for r in resumen)}), flush=True)
        if proceso.returncode:
            datos["estado"] = "fallo_en_" + etapa
            datos["fin_utc"] = datetime.now(timezone.utc).isoformat()
            guardar(datos)
            raise SystemExit(proceso.returncode)
    for item in fuentes + fuentes_lean + salidas:
        assert sha(RAIZ / item["archivo"]) == item["sha256"], item["archivo"]
    datos["estado_git_final"] = texto(["git", "-C", str(CODIGO), "status", "--porcelain", "--untracked-files=all"])
    assert not datos["estado_git_final"]
    datos["pruebas_pasadas"] = sum(r["pasaron"] for p in datos["pasos"] if p["etapa"] == "test" for r in p["resumenes_test"])
    datos["pruebas_falladas"] = sum(r["fallaron"] for p in datos["pasos"] for r in p["resumenes_test"])
    datos["estado"] = "check_test_build_globales_correctos"
    datos["correcto"] = True
    datos["fuentes_rust_intactas"] = len(fuentes)
    datos["fuentes_lean_intactas"] = len(fuentes_lean)
    datos["manuscrito_intacto"] = True
    datos["fin_utc"] = datetime.now(timezone.utc).isoformat()
    guardar(datos)
    print(json.dumps({"estado": datos["estado"], "pruebas": datos["pruebas_pasadas"],
        "fuentes_rust_intactas": len(fuentes), "fuentes_lean_intactas": len(fuentes_lean),
        "lean_recompilado": False, "manuscrito_intacto": True}), flush=True)


if __name__ == "__main__":
    main()
