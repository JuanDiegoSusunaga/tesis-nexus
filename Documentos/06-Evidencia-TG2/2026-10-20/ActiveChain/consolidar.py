"""Consolida la procedencia de ActiveChain, sin ejecutar Cargo ni Lean."""
from datetime import datetime, timezone
from pathlib import Path
import json
import runpy
import sys

RAIZ = Path(__file__).resolve().parents[4]
CARPETA = Path(__file__).resolve().parent
COMMIT = "637e77c99e804664915caf4ed928a10ef81cc870"
MANIFIESTO = RAIZ / "Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json"
PREVIO = CARPETA / "consolidacion-respaldo" / MANIFIESTO.relative_to(RAIZ)
SALIDA = CARPETA / "consolidacion.json"
VALIDACION = RAIZ / "Documentos/04-Administrativo-TG2/Entrega-Final/verificacion-consolidacion-active-chain-2026-10-20.json"
SEGUIMIENTO = ["PENDIENTES.md", "BITACORA_TG2.md",
    "Documentos/04-Administrativo-TG2/Entrega-Final/README.md", "Documentos/06-Evidencia-TG2/README.md"]

# Reutiliza las funciones de hashes y Git de la consolidación anterior; no ejecuta su main.
ayudas = runpy.run_path(str(CARPETA.parent / "Rust-Lean/consolidar.py"))
exigir, leer, registro, comprobar, git, guardar, sha = [ayudas[nombre] for nombre in
    ["exigir", "leer", "registro", "comprobar", "git", "guardar", "sha"]]


def main():
    exigir(not SALIDA.exists() and not VALIDACION.exists(), "No se sobrescribe evidencia cerrada.")
    exigir(git("rev-parse", "HEAD") == COMMIT, "Commit distinto del autorizado.")
    exigir(not git("status", "--porcelain=v1", "--untracked-files=all"), "El árbol Rust no está limpio.")
    integracion = leer(CARPETA / "integracion.json")
    exigir(git("rev-parse", "HEAD^") == integracion["commit_base"], "Base de código distinta.")
    exigir(MANIFIESTO.read_bytes() == PREVIO.read_bytes(), "El manifiesto anterior cambió.")
    comprobar(integracion["manifiesto_anterior_intacto"])
    exigir(registro(PREVIO)["sha256"] == "8d9db2a323a1e398349bc0937e73fb73c040013dbc13275606e778ee43c68c17",
        "Respaldo del manifiesto distinto.")
    anterior = leer(MANIFIESTO)
    comprobar(integracion["verificacion_aislada"])
    ronda = leer(RAIZ / integracion["verificacion_aislada"]["archivo"])
    exigir(ronda["correcto"] and ronda["pasos"][1]["pruebas_pasadas"] == 55,
        "La verificación aislada no corresponde a la evidencia esperada.")
    for paso in ronda["pasos"]:
        comprobar({"archivo": paso["registro"], "sha256": paso["sha256"]})
    for item in ronda["fuentes_nexus_active"]:
        comprobar(item)
    comprobar(integracion["auditoria_lean_previa"])
    lean = leer(RAIZ / integracion["auditoria_lean_previa"]["archivo"])
    for item in lean["fuentes_sha256"] + integracion["manuscrito_sin_cambios"]:
        comprobar(item)

    fuentes, cambios_desde_pruebas, normalizados = [], [], []
    for item in integracion["fuentes_actuales"]:
        ruta = RAIZ / item["archivo"]
        actual = registro(ruta)
        nombre = ruta.relative_to(RAIZ / "nexus").as_posix()
        if actual["sha256"] != item["sha256"]:
            cambios_desde_pruebas.append(nombre)
        contenido = ruta.read_bytes()
        blob = git("cat-file", "blob", COMMIT + ":" + nombre, binario=True)
        exigir(blob == contenido or blob == contenido.replace(b"\r\n", b"\n"),
            "El objeto Git no representa el archivo: " + nombre)
        if blob != contenido:
            normalizados.append(nombre)
        fuentes.append({**actual, "objeto_git": git("rev-parse", COMMIT + ":" + nombre),
            "sha256_blob_git": sha(blob), "bytes_blob_git": len(blob)})
    exigir(cambios_desde_pruebas == ["REPRODUCIBILIDAD_TG2.md"],
        "Hay cambios adicionales a la nota de procedencia posterior a las pruebas.")
    exigir(set(git("ls-files").splitlines()) == {i["archivo"].removeprefix("nexus/") for i in fuentes},
        "El inventario del commit difiere de la instantánea comprobada.")
    cambiados_commit = git("diff-tree", "--no-commit-id", "--name-only", "-r", COMMIT).splitlines()
    cambios_autorizados = {i["archivo"] for i in integracion["archivos_modificados_o_nuevos"]}
    exigir(set(cambiados_commit) == {n.removeprefix("nexus/") for n in cambios_autorizados},
        "El commit incluye rutas distintas de la integración autorizada.")
    protegidos = 0
    for item in anterior["archivos"]:
        if item["archivo"] not in cambios_autorizados | set(SEGUIMIENTO):
            comprobar(item)
            protegidos += 1
    respaldos = [registro(CARPETA / "consolidacion-respaldo" / nombre)
        for nombre in SEGUIMIENTO + ["nexus/REPRODUCIBILIDAD_TG2.md"]]
    copia_repro = CARPETA / "consolidacion-respaldo/nexus/REPRODUCIBILIDAD_TG2.md"
    previo_repro = next(i for i in integracion["fuentes_actuales"] if i["archivo"] == "nexus/REPRODUCIBILIDAD_TG2.md")
    exigir(registro(copia_repro)["sha256"] == previo_repro["sha256"], "La nota anterior no está preservada.")
    resultado = {
        "fecha": "2026-10-20", "fecha_utc": datetime.now(timezone.utc).isoformat(),
        "autorizacion": "El autor responde Dale a consolidar los cambios de integración en un commit.",
        "estado": "Integración de ActiveChain consolidada localmente, sin repetir compilaciones ni pruebas.",
        "codigo": {"commit": COMMIT, "padre": git("rev-parse", "HEAD^"),
            "arbol_git": git("rev-parse", "HEAD^{tree}"), "archivos_del_commit": cambiados_commit,
            "arbol_limpio": True, "push_realizado": False},
        "fuentes_y_configuracion": fuentes,
        "cambios_desde_las_pruebas": cambios_desde_pruebas,
        "motivo_cambio_documental": "Identificar el commit y la evidencia posterior a la instantánea de integración; ninguna fuente .rs cambia.",
        "finales_de_linea": {"archivos_normalizados_por_git": normalizados,
            "criterio": "Cada blob coincide con los bytes de trabajo o su normalización CRLF a LF; se conservan ambas huellas sin reescribir fuentes."},
        "integracion_previa_intacta": registro(CARPETA / "integracion.json"),
        "verificacion_aislada_previa_intacta": integracion["verificacion_aislada"],
        "pruebas_aisladas_previas": 55, "pruebas_nuevas_previas": 13,
        "compilacion_rust_ejecutada_en_consolidacion": False,
        "compilacion_lean_ejecutada_en_consolidacion": False,
        "pruebas_rust_lean_repetidas_en_consolidacion": False,
        "manifiesto_previo_conservado": registro(PREVIO),
        "archivos_del_manifiesto_previo_intactos_excepto_integracion_indices_y_seguimiento": protegidos,
        "respaldos_del_seguimiento": respaldos,
        "seguimiento_actual": [registro(RAIZ / n) for n in SEGUIMIENTO],
        "fuentes_lean_intactas": len(lean["fuentes_sha256"]),
        "manuscrito_intacto": integracion["manuscrito_sin_cambios"],
        "manuscrito_regenerado": False, "commit_documental_creado": False,
        "limites": integracion["limites"][:-1] + [
            "El commit de integración es local; no hay push ni confirmación de los demás cambios documentales.",
            "El informe de integración conserva su estado histórico previo al commit y al nuevo manifiesto."],
    }
    guardar(SALIDA, resultado)

    # Mantiene la tesis unificada y todas las referencias históricas del manifiesto.
    anterior["fecha"] = "2026-10-20"
    anterior["fecha_utc"] = resultado["fecha_utc"]
    anterior["estado"] = ("Tesis final unificada y manuscrito del 19 intacto. Integración local de ActiveChain "
        "con contexto confiable y evidencia previa de 55 pruebas aisladas; sin repetir compilaciones ni pruebas, "
        "regenerar documentos, hacer push ni atribuir validación L2 completa o aprobación académica.")
    anterior["codigo"]["commit"] = COMMIT
    anterior["manifiesto_previo"] = registro(PREVIO)
    anterior["consolidacion_active_chain"] = {**registro(SALIDA), "commit_codigo": COMMIT,
        "pruebas_aisladas_previas": 55, "pruebas_nuevas_previas": 13,
        "compilaciones_repetidas_en_consolidacion": False, "validez_general_l2_demostrada": False}
    archivos = {i["archivo"]: i for i in anterior["archivos"]}
    for nombre in SEGUIMIENTO + ["Documentos/04-Administrativo-TG2/Entrega-Final/verificacion-consolidacion-rust-lean-2026-10-20.json"]:
        archivos[nombre] = registro(RAIZ / nombre)
    for carpeta in ["Documentos/01-Manuscrito", "Documentos/06-Evidencia-TG2"]:
        for ruta in (RAIZ / carpeta).rglob("*"):
            if ruta.is_file() and not ruta.name.startswith("~$"):
                item = registro(ruta)
                archivos[item["archivo"]] = item
    for item in fuentes:
        archivos[item["archivo"]] = {k: item[k] for k in ["archivo", "bytes", "sha256"]}
    anterior["archivos"] = [archivos[n] for n in sorted(archivos)]
    guardar(MANIFIESTO, anterior)

    # El comprobador solo lee hashes y el estado Git; no ejecuta compiladores.
    sys.path.insert(0, str(RAIZ / "scripts"))
    from verificar_version_tg2 import verificar
    comprobacion = verificar(RAIZ, MANIFIESTO)
    exigir(comprobacion["correcto"], json.dumps(comprobacion, ensure_ascii=False))
    validacion = {"fecha": "2026-10-20", "estado": "Commit y manifiesto comprobados sin recompilar.",
        "integridad_manifiesto": comprobacion, "codigo": resultado["codigo"],
        "manifiesto": registro(MANIFIESTO), "consolidacion": registro(SALIDA),
        "fuentes_lean_intactas": len(lean["fuentes_sha256"]), "fuentes_configuracion_rust": len(fuentes),
        "manuscrito_intacto": len(integracion["manuscrito_sin_cambios"]),
        "compilaciones_y_pruebas_rust_lean_repetidas": False,
        "nota_integridad": "Registro externo posterior, fuera del inventario del propio manifiesto para evitar autorreferencia; hashes y Git no son nuevas pruebas del programa."}
    guardar(VALIDACION, validacion)
    print(json.dumps(validacion, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
