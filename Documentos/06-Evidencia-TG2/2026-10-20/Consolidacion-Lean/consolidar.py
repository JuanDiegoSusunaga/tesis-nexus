"""Consolida fuentes existentes y coteja su integridad sin ejecutar Lean ni Rust."""
import ast
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import runpy
import shutil
import subprocess
import sys

RAIZ = Path(__file__).resolve().parents[1]
BASE = "a9faf0e66af1400991ac5b0215c770f96ad712b8"
CARPETA = "Documentos/06-Evidencia-TG2/2026-10-20/Consolidacion-Lean"
EVIDENCIA = RAIZ / CARPETA
MANIFIESTO = "Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json"
GLOBAL_LEAN = "Documentos/06-Evidencia-TG2/2026-10-20/Lean-Global/verificacion.json"
GLOBAL_RUST = "Documentos/06-Evidencia-TG2/2026-10-20/Rust-Global-Final/verificacion.json"
CONTEXTO = RAIZ / "tmp/consolidacion-lean-contexto-2026-10-20.json"
RUTAS = RAIZ / "tmp/consolidacion-lean-rutas-2026-10-20.txt"
EDITABLES = {".gitattributes", "README.md", "formalizacion/README.md", "scripts/README.md",
    "BITACORA_TG2.md", "PENDIENTES.md", "Documentos/06-Evidencia-TG2/README.md",
    "Documentos/04-Administrativo-TG2/Entrega-Final/README.md"}
BANDERAS = getattr(subprocess, "CREATE_NO_WINDOW", 0)


def git(*args):
    return subprocess.check_output(["git", "-C", str(RAIZ), *args], creationflags=BANDERAS)


def nombres(*args):
    return {n.decode("utf-8") for n in git(args[0], "-z", *args[1:]).split(b"\0") if n}


def leer(nombre):
    return json.loads((RAIZ / nombre).read_text(encoding="utf-8-sig"))


def guardar(ruta, datos):
    ruta.write_text(json.dumps(datos, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def huella(nombre):
    datos = (RAIZ / nombre).read_bytes()
    return {"archivo": nombre, "bytes": len(datos), "sha256": hashlib.sha256(datos).hexdigest()}


def verificar_lista(lista):
    for item in lista:
        actual = huella(item["archivo"])
        assert actual["sha256"] == item["sha256"], "Huella diferente: " + item["archivo"]
        if "bytes" in item:
            assert actual["bytes"] == item["bytes"], item["archivo"]


def integridad():
    funcion = runpy.run_path(str(RAIZ / "scripts/verificar_version_tg2.py"))["verificar"]
    informe = funcion(RAIZ, RAIZ / MANIFIESTO)
    assert informe["correcto"], informe
    return informe


def protegidos():
    ejecucion = leer(GLOBAL_RUST)
    assert ejecucion["correcto"] and ejecucion["pruebas_pasadas"] == 223
    listas = {k: ejecucion[k] for k in ("fuentes_sha256", "fuentes_lean_sha256", "manuscrito_sha256")}
    for lista in listas.values():
        verificar_lista(lista)
    return listas


def revision_estatica(fuentes):
    # Se analiza texto; no se importan los lanzadores ni se invocan compiladores.
    scripts = sorted(n for n in fuentes if n.startswith("scripts/") and n.endswith(".py"))
    for nombre in scripts:
        ast.parse((RAIZ / nombre).read_text(encoding="utf-8-sig"), filename=nombre)
    modulos = {"Nexus"} | {".".join(Path(n).relative_to("formalizacion").with_suffix("").parts)
        for n in fuentes if n.startswith("formalizacion/Nexus/") and n.endswith(".lean")}
    assert len(modulos) == 348, len(modulos)
    enlaces = 0
    for nombre in sorted(n for n in fuentes if n.endswith(".lean")):
        texto = (RAIZ / nombre).read_text(encoding="utf-8-sig")
        for linea in texto.splitlines():
            if re.match(r"^(?:public\s+)?import\s", linea):
                for modulo in linea.split("import", 1)[1].split("--", 1)[0].split():
                    if modulo == "Nexus" or modulo.startswith("Nexus."):
                        assert modulo in modulos, (nombre, modulo)
                        enlaces += 1
    return {"scripts_sintaxis_correcta": len(scripts), "modulos_nexus_incluida_raiz": len(modulos),
        "importaciones_nexus_con_fuente": enlaces, "lean_ejecutado": False, "rust_ejecutado": False}


def preparar():
    assert git("rev-parse", "HEAD").decode().strip() == BASE
    assert not git("diff", "--cached", "--name-only").strip(), "El índice contiene cambios ajenos."
    assert not EVIDENCIA.exists() and not CONTEXTO.exists(), "Ya existe una preparación."
    comprobacion = integridad()
    listas = protegidos()
    fuentes = nombres("ls-files", "--others", "--exclude-standard", "--", "formalizacion", "scripts")
    assert len([n for n in fuentes if n.startswith("formalizacion/")]) == 361
    assert len([n for n in fuentes if n.startswith("scripts/")]) == 7
    assert not any("/.lake/" in n or "__pycache__" in n or n.endswith(".olean") for n in fuentes)
    assert {i["archivo"] for i in listas["fuentes_lean_sha256"]} <= fuentes
    analisis = revision_estatica(fuentes)
    EVIDENCIA.mkdir(parents=True)
    respaldos = []
    for nombre in sorted(EDITABLES | {MANIFIESTO}):
        destino = EVIDENCIA / "respaldo_previo" / nombre
        destino.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(RAIZ / nombre, destino)
        registro = huella(destino.relative_to(RAIZ).as_posix())
        assert registro["sha256"] == huella(nombre)["sha256"]
        respaldos.append(registro)
    copia = EVIDENCIA / "consolidar.py"
    shutil.copy2(Path(__file__), copia)
    guardar(CONTEXTO, {"commit_base": BASE, "integridad_previa": comprobacion,
        "fuentes_a_incluir": [huella(n) for n in sorted(fuentes)], "respaldos": respaldos,
        "fuentes_protegidas": listas, "revision_estatica": analisis,
        "manifiesto_previo": huella(MANIFIESTO), "herramienta": huella(copia.relative_to(RAIZ).as_posix())})
    print(json.dumps({"integridad_previa": comprobacion, "fuentes_a_incluir": len(fuentes),
        "respaldos": len(respaldos), "revision_estatica": analisis}, ensure_ascii=False))


def sellar():
    contexto = leer(CONTEXTO.relative_to(RAIZ))
    assert git("rev-parse", "HEAD").decode().strip() == BASE
    assert not git("diff", "--cached", "--name-only").strip()
    protegidos()
    verificar_lista(contexto["respaldos"])
    verificar_lista([contexto["herramienta"]])
    fuentes = {i["archivo"] for i in contexto["fuentes_a_incluir"]}
    verificar_lista([i for i in contexto["fuentes_a_incluir"] if i["archivo"] not in EDITABLES])
    analisis = revision_estatica(fuentes)
    ruta_previa = CARPETA + "/respaldo_previo/" + MANIFIESTO
    anterior = leer(ruta_previa)
    actualizados = []
    for item in anterior["archivos"]:
        actual = huella(item["archivo"])
        if actual["sha256"] != item["sha256"]:
            assert item["archivo"] in EDITABLES, "Cambio fuera de alcance: " + item["archivo"]
            actualizados.append(item["archivo"])
    informe = {"fecha": "2026-10-20", "fecha_utc": datetime.now(timezone.utc).isoformat(),
        "estado": "preparacion_verificada_para_commit_local_de_formalizacion",
        "commit_base_documental": BASE,
        "autorizacion": "Dale a consolidar Lean y sus herramientas, conciliar README y verificar integridad; sin compilar ni hacer push.",
        "alcance": "Versionado de fuentes ya auditadas; no se añaden módulos ni obligaciones matemáticas.",
        "lean_fuentes_config_intactas": len(contexto["fuentes_protegidas"]["fuentes_lean_sha256"]),
        "rust_fuentes_config_intactas": len(contexto["fuentes_protegidas"]["fuentes_sha256"]),
        "manuscrito_fuentes_salidas_intactas": len(contexto["fuentes_protegidas"]["manuscrito_sha256"]),
        "auditoria_lean_previa": huella(GLOBAL_LEAN), "global_rust_previa": huella(GLOBAL_RUST),
        "revision_estatica": analisis, "compilaciones_repetidas": False, "pruebas_repetidas": False,
        "manuscrito_regenerado": False, "push_realizado": False,
        "exclusiones": ["formalizacion/.lake/", ".tools/", "__pycache__/", "tmp/",
            "Presentacion-Tesis-NEXUS.pdf", "Repositorio independiente nexus/"],
        "limites": "La auditoría conserva sus hipótesis: ROM clásico finito, no refinamiento universal Rust ni QROM ni dictamen independiente.",
        "fuentes_versionadas": [huella(n) for n in sorted(fuentes)],
        "documentacion_conciliada": [huella(n) for n in sorted(EDITABLES)],
        "archivos_previos_actualizados": actualizados,
        "respaldos": contexto["respaldos"], "herramienta": contexto["herramienta"],
        "manifiesto_previo_conservado": huella(ruta_previa)}
    ruta_informe = CARPETA + "/preparacion.json"
    guardar(RAIZ / ruta_informe, informe)
    nombres_actuales = {i["archivo"] for i in anterior["archivos"]} | fuentes | EDITABLES
    nombres_actuales.update(p.relative_to(RAIZ).as_posix() for p in EVIDENCIA.rglob("*") if p.is_file())
    anterior["fecha_utc"] = informe["fecha_utc"]
    anterior["estado"] = ("Tesis final sincronizada con Rust y ActiveChain. Fuentes Lean previamente auditadas y herramientas "
        "incluidas en la consolidación local autorizada, sin recompilar ni hacer push. Se conservan la global Lean de 2709 "
        "declaraciones y la global Rust de 223 pruebas. No acredita refinamiento universal, validez L2 completa, QROM ni aprobación académica.")
    anterior["documentos"]["commit_contexto"] = BASE
    anterior["manifiesto_previo"] = huella(ruta_previa)
    anterior["consolidacion_lean"] = huella(ruta_informe)
    anterior["lean"]["fuentes_versionadas"] = "Incluidas en el commit local que contiene este manifiesto; sin cachés ni dependencias vendorizadas."
    anterior["archivos"] = [huella(n) for n in sorted(nombres_actuales)]
    guardar(RAIZ / MANIFIESTO, anterior)
    comprobacion = integridad()
    adicionales = {p.relative_to(RAIZ).as_posix() for p in EVIDENCIA.rglob("*") if p.is_file()}
    seleccion = fuentes | EDITABLES | {MANIFIESTO} | adicionales
    cambios = nombres("diff", "--name-only") | nombres("ls-files", "--others", "--exclude-standard",
        "--", "formalizacion", "scripts", CARPETA)
    assert cambios == seleccion, {"extras": sorted(cambios - seleccion), "faltan": sorted(seleccion - cambios)}
    assert not any("/.lake/" in n or "/__pycache__/" in n for n in seleccion)
    for nombre in seleccion:
        assert huella(nombre)["bytes"] < 100 * 1024 * 1024, nombre
        assert Path(nombre).name.lower() not in {".env", "credentials", "id_rsa", "id_ed25519"}, nombre
    contexto["seleccion"] = [huella(n) for n in sorted(seleccion)]
    contexto["integridad_nueva"] = comprobacion
    guardar(CONTEXTO, contexto)
    RUTAS.write_bytes(b"".join(n.encode("utf-8") + b"\0" for n in sorted(seleccion)))
    print(json.dumps({"archivos_a_confirmar": len(seleccion), "bytes": sum(i["bytes"] for i in contexto["seleccion"]),
        "integridad": comprobacion, "revision_estatica": analisis}, ensure_ascii=False))


def comprobar_indice(revision=None):
    contexto = leer(CONTEXTO.relative_to(RAIZ))
    esperado = {i["archivo"]: i for i in contexto["seleccion"]}
    if revision:
        encontrados = nombres("diff-tree", "--no-commit-id", "--name-only", "-r", revision)
    else:
        encontrados = nombres("diff", "--cached", "--name-only")
    assert encontrados == set(esperado), {"extras": sorted(encontrados - set(esperado)),
        "faltantes": sorted(set(esperado) - encontrados)}
    verificar_lista(list(esperado.values()))
    entradas = b"".join(((revision + ":" if revision else ":") + n).encode("utf-8") + b"\n" for n in sorted(esperado))
    salida = subprocess.run(["git", "-C", str(RAIZ), "cat-file", "--batch"], input=entradas,
        capture_output=True, creationflags=BANDERAS, check=True).stdout
    posicion = 0
    normalizados = []
    for nombre in sorted(esperado):
        final = salida.index(b"\n", posicion)
        cabecera = salida[posicion:final].split()
        assert cabecera[1] == b"blob", nombre
        cantidad = int(cabecera[2])
        blob = salida[final + 1:final + 1 + cantidad]
        posicion = final + cantidad + 2
        contenido = (RAIZ / nombre).read_bytes()
        assert blob == contenido or blob == contenido.replace(b"\r\n", b"\n"), nombre
        if blob != contenido:
            normalizados.append(nombre)
    assert posicion == len(salida)
    protegidos()
    informe = {"archivos": len(esperado), "bytes_cotejados_con_blobs": True,
        "normalizacion_crlf_lf": normalizados, "integridad": integridad(),
        "compilaciones_repetidas": False, "pruebas_repetidas": False, "push_realizado": False}
    if revision:
        assert git("rev-parse", revision + "^").decode().strip() == BASE
        assert not git("diff", "--cached", "--name-only").strip()
        assert not nombres("ls-files", "--others", "--exclude-standard", "--", "formalizacion", "scripts")
        informe["commit_local"] = git("rev-parse", revision).decode().strip()
        informe["arbol_git"] = git("rev-parse", revision + "^{tree}").decode().strip()
        guardar(RAIZ / "tmp/commit-lean-verificado-2026-10-20.json", informe)
    print(json.dumps(informe, ensure_ascii=False))


if __name__ == "__main__":
    {"preparar": preparar, "sellar": sellar, "indice": comprobar_indice,
        "verificar": lambda: comprobar_indice("HEAD")}[sys.argv[1]]()
