"""Conserva comprobaciones de la rama matemática en una salida sin sobrescrituras."""
from argparse import ArgumentParser
from datetime import datetime, timezone
from pathlib import Path
import hashlib
import json
import os
import re
import subprocess
import sys

RAIZ = Path(__file__).resolve().parents[1]
INFORME = RAIZ / "Documentos/04-Administrativo-TG2/Avances/Cierre-Matematico-2026-09-23"


def huella(ruta):
    return hashlib.sha256(ruta.read_bytes()).hexdigest()


def git(*argumentos):
    proceso = subprocess.run(["git", *argumentos], cwd=RAIZ, capture_output=True, check=True)
    return proceso.stdout.decode("utf-8").strip()


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument("--salida", type=Path, default=Path(".tools/cierre-matematico/verificacion"))
    args = parser.parse_args()
    destino = args.salida.resolve()
    destino.relative_to(RAIZ)
    destino.mkdir(parents=True, exist_ok=True)
    comandos = [
        ("pruebas-python", [sys.executable, "-m", "unittest", "discover", "-s", "scripts/tests",
                            "-p", "test_rbr_conjunto_tg2.py", "-v"]),
        ("pruebas-manifiesto", [sys.executable, "-m", "unittest", "discover", "-s", "scripts/tests",
                                "-p", "test_verificar_version_tg2.py", "-v"]),
        ("manifiesto", [sys.executable, "scripts/verificar_version_tg2.py"]),
        ("cargo-check", ["cargo", "check", "--workspace", "--all-targets", "--locked", "--offline",
                         "--manifest-path", "nexus/Cargo.toml"]),
        ("cargo-test", ["cargo", "test", "--workspace", "--locked", "--offline",
                        "--manifest-path", "nexus/Cargo.toml"]),
        ("cargo-build", ["cargo", "build", "--workspace", "--locked", "--offline",
                         "--manifest-path", "nexus/Cargo.toml"]),
    ]
    salidas = [destino / (nombre+".log") for nombre, _ in comandos] + [destino / "validacion.json"]
    if any(ruta.exists() for ruta in salidas):
        raise FileExistsError("La salida ya contiene comprobaciones; use una carpeta nueva")
    if git("-C", "nexus", "status", "--porcelain"):
        raise RuntimeError("El repositorio de código tiene cambios; revisar antes de fijar procedencia")
    inicio = {"documentos_base": git("rev-parse", "HEAD"),
              "codigo": git("-C", "nexus", "rev-parse", "HEAD"),
              "rama_documentos": git("branch", "--show-current"),
              "rama_codigo": git("-C", "nexus", "branch", "--show-current")}
    tg1 = sorted((RAIZ / "Documentos/03-Administrativo-TG1").rglob("*"))
    tg1 = {str(p.relative_to(RAIZ)): huella(p) for p in tg1 if p.is_file()}
    entorno = os.environ.copy()
    entorno["CARGO_TARGET_DIR"] = "C:/tmp/nexus-target"
    entorno["PYTHONUTF8"] = "1"
    resultados = []
    textos = {}
    for nombre, comando in comandos:
        print(f"Ejecutando {nombre}...", flush=True)
        proceso = subprocess.run(comando, cwd=RAIZ, env=entorno, capture_output=True)
        texto = proceso.stdout.decode("utf-8", errors="replace") + proceso.stderr.decode("utf-8", errors="replace")
        with (destino / (nombre+".log")).open("x", encoding="utf-8", newline="\n") as archivo:
            archivo.write(texto)
        resultados.append({"nombre": nombre, "comando": comando, "codigo_salida": proceso.returncode})
        textos[nombre] = texto
        if proceso.returncode:
            raise RuntimeError(f"Falló {nombre}: revisar su log completo en {destino}")
    if git("-C", "nexus", "status", "--porcelain"):
        raise RuntimeError("Las comprobaciones modificaron archivos del código")
    if git("-C", "nexus", "rev-parse", "HEAD") != inicio["codigo"]:
        raise RuntimeError("Cambió la revisión de código durante la comprobación")
    for nombre, digest in tg1.items():
        if huella(RAIZ / nombre) != digest:
            raise RuntimeError(f"Cambió un documento TG1: {nombre}")
    pruebas_python = int(re.search(r"Ran (\d+) tests", textos["pruebas-python"])[1])
    pruebas_manifiesto = int(re.search(r"Ran (\d+) tests", textos["pruebas-manifiesto"])[1])
    pruebas_rust = sum(int(x) for x in re.findall(r"test result: ok\. (\d+) passed", textos["cargo-test"]))
    if pruebas_python != 7 or pruebas_manifiesto != 10 or pruebas_rust != 197:
        raise RuntimeError(f"Conteos inesperados: Python={pruebas_python}, manifiesto={pruebas_manifiesto}, Rust={pruebas_rust}")
    fuentes = [RAIZ / "scripts/analizar_rbr_conjunto_tg2.py",
               RAIZ / "scripts/tests/test_rbr_conjunto_tg2.py", Path(__file__).resolve(),
               RAIZ / "scripts/verificar_version_tg2.py", RAIZ / "scripts/registrar_version_tg2.py",
               RAIZ / "scripts/tests/test_verificar_version_tg2.py",
               RAIZ / "nexus/nexus-zk/experiments/tg2_linked_trace_fri.rs"]
    fuentes += sorted((RAIZ / "nexus/nexus-zk/src/stark").glob("*.rs"))
    fuentes += [INFORME / nombre for nombre in ["README.md", "RBR-AIR-FRI.md", "calculos.json",
                                               "bibliografia/GMW25.pdf", "bibliografia/GMW25.txt"]]
    fuentes += [destino / (nombre+".log") for nombre, _ in comandos]
    registro = {"fecha_utc": datetime.now(timezone.utc).isoformat(), "revisiones": inicio,
                "estado": "Derivación escrita pendiente de revisión independiente; no garantía del ejecutable",
                "pruebas_python": pruebas_python, "pruebas_rust": pruebas_rust,
                "pruebas_manifiesto": pruebas_manifiesto,
                "documentos_tg1_preservados": len(tg1), "codigo_sin_cambios": True,
                "manifiesto_anterior": "Verificado: manuscrito y evidencia histórica preservados",
                "CARGO_TARGET_DIR": entorno["CARGO_TARGET_DIR"], "ejecuciones": resultados,
                "fuente_nueva": {"url": "https://eprint.iacr.org/2025/1993.pdf",
                                 "autores": ["Albert Garreta", "Nicolas Mohnblatt", "Benedikt Wagner"],
                                 "fecha_portada": "2026-03-27", "revision_eprint": "2026-03-31",
                                 "consultada": "2026-09-23", "licencia_eprint": "CC BY"},
                "archivos": [{"ruta": p.relative_to(RAIZ).as_posix(), "sha256": huella(p),
                              "bytes": p.stat().st_size} for p in fuentes]}
    with (destino / "validacion.json").open("x", encoding="utf-8", newline="\n") as archivo:
        json.dump(registro, archivo, ensure_ascii=False, indent=2)
        archivo.write("\n")
    print(json.dumps({"python": pruebas_python, "manifiesto": pruebas_manifiesto, "rust": pruebas_rust,
                      "tg1_preservados": len(tg1), "registro": str(destino / "validacion.json")},
                     ensure_ascii=False), flush=True)


if __name__ == "__main__":
    main()
