"""Registra la revisión crítica ROM y repite las comprobaciones de la etapa previa."""
from argparse import ArgumentParser
from datetime import datetime, timezone
from pathlib import Path
import json
import os
import re
import shutil
import subprocess
import sys

from verificar_transferencia_rom_tg2 import RAIZ, huella, git, guardar_nuevo

INFORME = RAIZ/"Documentos/04-Administrativo-TG2/Avances/Revision-Critica-ROM-2026-09-23"


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument("--salida", type=Path, default=Path(".tools/revision-rom/verificacion"))
    args = parser.parse_args()
    destino = args.salida.resolve()
    destino.relative_to(RAIZ)
    destino.mkdir(parents=True, exist_ok=True)
    nombres = ["validacion.json", "pruebas-revision.log", "regresion.log", "calculos.log",
               "calculos-reproducidos.json", "proteccion.json", "fuentes", "regresion"]
    if any((destino/n).exists() for n in nombres):
        raise FileExistsError("La salida ya contiene una ejecución; indicar otra carpeta")
    revision = {"documentos_base": git("rev-parse", "HEAD"), "codigo": git("-C", "nexus", "rev-parse", "HEAD"),
                "rama_documentos": git("branch", "--show-current"), "rama_codigo": git("-C", "nexus", "branch", "--show-current")}
    if git("-C", "nexus", "status", "--porcelain"):
        raise RuntimeError("El código debe estar limpio")
    carpetas = ["Documentos/03-Administrativo-TG1",
                "Documentos/04-Administrativo-TG2/Avances/Cierre-Matematico-2026-09-23",
                "Documentos/04-Administrativo-TG2/Avances/Transferencia-ROM-2026-09-23"]
    protegidos = {p: huella(p) for sub in carpetas for p in (RAIZ/sub).rglob("*")
                  if p.is_file() and not p.name.startswith("~$")}
    env = os.environ.copy()
    env["PYTHONUTF8"] = "1"
    env["CARGO_TARGET_DIR"] = "C:/tmp/nexus-target"
    comandos = [
        ("pruebas-revision", [sys.executable, "-m", "unittest", "discover", "-s", "scripts/tests",
                             "-p", "test_revision_rom_tg2.py", "-v"]),
        ("calculos", [sys.executable, "scripts/analizar_revision_rom_tg2.py", "--salida",
                      str(destino/"calculos-reproducidos.json")]),
        ("regresion", [sys.executable, "scripts/verificar_transferencia_rom_tg2.py", "--salida",
                       str(destino/"regresion")]),
    ]
    ejecuciones, textos = [], {}
    for nombre, comando in comandos:
        print(f"Ejecutando {nombre}...", flush=True)
        proceso = subprocess.run(comando, cwd=RAIZ, env=env, capture_output=True)
        texto = proceso.stdout.decode("utf-8", errors="replace")+proceso.stderr.decode("utf-8", errors="replace")
        with (destino/(nombre+".log")).open("x", encoding="utf-8", newline="\n") as archivo:
            archivo.write(texto)
        textos[nombre] = texto
        ejecuciones.append({"nombre": nombre, "comando": comando, "codigo_salida": proceso.returncode})
        if proceso.returncode:
            raise RuntimeError(f"Falló {nombre}; leer el log completo en {destino}")
    pruebas = int(re.search(r"Ran (\d+) tests", textos["pruebas-revision"])[1])
    anterior = json.loads((destino/"regresion/validacion.json").read_text(encoding="utf-8"))
    if pruebas != 12 or anterior["pruebas_python"] != 28 or anterior["pruebas_rust"] != 197:
        raise RuntimeError("Conteos inesperados")
    calculos = json.loads((destino/"calculos-reproducidos.json").read_text(encoding="utf-8"))
    if calculos != json.loads((INFORME/"calculos.json").read_text(encoding="utf-8")):
        raise RuntimeError("Los cálculos conservados no coinciden")
    if git("-C", "nexus", "status", "--porcelain") or git("-C", "nexus", "rev-parse", "HEAD") != revision["codigo"]:
        raise RuntimeError("Cambió el código durante la comprobación")
    for ruta, digest in protegidos.items():
        if huella(ruta) != digest:
            raise RuntimeError(f"Archivo protegido alterado: {ruta}")
    guardar_nuevo(destino/"proteccion.json", {
        "carpetas": carpetas, "sin_cambios": True,
        "archivos": [{"ruta": p.relative_to(RAIZ).as_posix(), "sha256": digest}
                     for p, digest in sorted(protegidos.items())]})
    fuentes = []
    for nombre in ["analizar_revision_rom_tg2.py", "verificar_revision_rom_tg2.py", "tests/test_revision_rom_tg2.py"]:
        ruta = RAIZ/"scripts"/nombre
        copia = destino/"fuentes/scripts"/nombre
        copia.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(ruta, copia)
        fuentes.append({"original": ruta.relative_to(RAIZ).as_posix(), "copia": copia.relative_to(RAIZ).as_posix(),
                        "sha256": huella(copia), "bytes": copia.stat().st_size})
    archivos = [INFORME/n for n in ["README.md", "Revision-Critica-ROM.md", "calculos.json"]]
    archivos += [destino/(nombre+".log") for nombre, _ in comandos]
    archivos += [destino/n for n in ["calculos-reproducidos.json", "proteccion.json", "regresion/validacion.json"]]
    registro = {"fecha_utc": datetime.now(timezone.utc).isoformat(), "revisiones": revision,
                "estado": "Revisión interna y demostración ampliada propuestas; dictamen externo y QROM pendientes",
                "pruebas_python": pruebas+anterior["pruebas_python"], "pruebas_nuevas": pruebas,
                "pruebas_rust": anterior["pruebas_rust"], "corpus": anterior["corpus"],
                "escenarios_adaptativos": len(calculos["escenarios"]),
                "estados_bellman_sumados": sum(x["estados_bellman"] for x in calculos["escenarios"]),
                "extraccion": calculos["extraccion"], "archivos_protegidos": len(protegidos),
                "codigo_sin_cambios": True, "manifiesto_897": "verificado por la regresión",
                "CARGO_TARGET_DIR": env["CARGO_TARGET_DIR"], "ejecuciones": ejecuciones, "fuentes": fuentes,
                "archivos": [{"ruta": p.relative_to(RAIZ).as_posix(), "sha256": huella(p), "bytes": p.stat().st_size}
                             for p in archivos]}
    guardar_nuevo(destino/"validacion.json", registro)
    print(json.dumps({"python": registro["pruebas_python"], "rust": registro["pruebas_rust"],
                      "escenarios": registro["escenarios_adaptativos"], "registro": str(destino/"validacion.json")},
                     ensure_ascii=False), flush=True)


if __name__ == "__main__":
    main()
