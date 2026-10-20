"""Vincula el commit autorizado con evidencia previa, sin compilar ni probar código."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import subprocess
import sys

RAIZ = Path(__file__).resolve().parents[4]
CARPETA = Path(__file__).resolve().parent
CODIGO = RAIZ / "nexus"
COMMIT = "3e40e283dddc15502830f9fc220e556385f9d477"
MANIFIESTO = RAIZ / "Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json"
PREVIO = CARPETA / "respaldo_previo/Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json"
SALIDA = CARPETA / "consolidacion.json"
SEGUIMIENTO = ["PENDIENTES.md", "BITACORA_TG2.md",
    "Documentos/04-Administrativo-TG2/Entrega-Final/README.md",
    "Documentos/06-Evidencia-TG2/README.md"]


def exigir(condicion, mensaje):
    if not condicion:
        raise ValueError(mensaje)


def sha(datos):
    return hashlib.sha256(datos).hexdigest()


def leer(ruta):
    return json.loads(ruta.read_text(encoding="utf-8-sig"))


def registro(ruta):
    contenido = ruta.read_bytes()
    return {"archivo": ruta.relative_to(RAIZ).as_posix(),
        "bytes": len(contenido), "sha256": sha(contenido)}


def comprobar(item):
    exigir(sha((RAIZ / item["archivo"]).read_bytes()) == item["sha256"],
        "Huella distinta: " + item["archivo"])


def git(*argumentos, binario=False):
    resultado = subprocess.check_output(["git", "-C", str(CODIGO), *argumentos],
        creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
    return resultado if binario else resultado.decode("utf-8").strip()


def guardar(ruta, datos):
    ruta.write_text(json.dumps(datos, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def main():
    exigir(not SALIDA.exists(), "La consolidación ya existe; no se sobrescribe.")
    exigir(git("rev-parse", "HEAD") == COMMIT, "Commit distinto del autorizado.")
    exigir(not git("status", "--porcelain=v1", "--untracked-files=all"), "Árbol Rust no limpio.")
    exigir(MANIFIESTO.read_bytes() == PREVIO.read_bytes(), "El manifiesto previo cambió.")
    exigir(sha(PREVIO.read_bytes()) == "8a6bd3af02835ba0916e9886ce4fbab21d801b82559319416b78ebcb2488e824",
        "Respaldo del manifiesto distinto.")
    anterior = leer(MANIFIESTO)
    adaptacion = leer(CARPETA / "adaptacion.json")
    revision = leer(CARPETA / "revision-final.json")
    comprobar(revision["referencias_intactas"][0])
    exigir(git("rev-parse", "HEAD^") == adaptacion["commit_base"], "Base de código distinta.")
    lean = leer(RAIZ / adaptacion["global_lean_sin_cambio_de_fuentes"]["archivo"])
    referencias = [registro(CARPETA / "adaptacion.json"), registro(CARPETA / "revision-final.json")]
    for clave in ["global_rust_antes_de_editar", "global_lean_sin_cambio_de_fuentes", "verificacion_final_aislada"]:
        item = adaptacion[clave]
        comprobar(item)
        referencias.append(item)
        datos = leer(RAIZ / item["archivo"])
        for paso in datos["pasos"]:
            comprobar({"archivo": paso["registro"], "sha256": paso["sha256"]})
    for item in lean["fuentes_sha256"] + adaptacion["manuscrito_sin_cambios"]:
        comprobar(item)
    for item in adaptacion["certificados_historicos"]["archivos"]:
        comprobar(item)

    fuentes = []
    cambios_desde_revision = []
    finales_normalizados = []
    for item in adaptacion["fuentes_actuales"]:
        ruta = RAIZ / item["archivo"]
        actual = registro(ruta)
        nombre = ruta.relative_to(CODIGO).as_posix()
        if actual["sha256"] != item["sha256"]:
            cambios_desde_revision.append(nombre)
        contenido = ruta.read_bytes()
        blob = git("cat-file", "blob", COMMIT + ":" + nombre, binario=True)
        exigir(blob == contenido or blob == contenido.replace(b"\r\n", b"\n"),
            "El objeto Git no representa el archivo: " + nombre)
        if blob != contenido:
            finales_normalizados.append(nombre)
        fuentes.append({**actual, "objeto_git": git("rev-parse", COMMIT + ":" + nombre),
            "sha256_blob_git": sha(blob), "bytes_blob_git": len(blob)})
    exigir(cambios_desde_revision == ["REPRODUCIBILIDAD_TG2.md"],
        "Hay cambios adicionales a la nota documental de procedencia.")
    nombres = set(git("ls-files").splitlines())
    exigir(nombres == {i["archivo"].removeprefix("nexus/") for i in fuentes},
        "El inventario Git difiere de la instantánea revisada.")
    cambiados_commit = git("diff-tree", "--no-commit-id", "--name-only", "-r", COMMIT).splitlines()
    exigir(set(cambiados_commit) == {i["archivo"].removeprefix("nexus/") for i in adaptacion["cambios"]},
        "El commit incluye rutas distintas de las revisadas.")

    protegidos = 0
    for item in anterior["archivos"]:
        if item["archivo"] not in SEGUIMIENTO:
            comprobar(item)
            protegidos += 1
    respaldos = []
    for nombre in SEGUIMIENTO:
        copia = CARPETA / "consolidacion-respaldo" / nombre
        exigir(copia.is_file(), "Falta respaldo del seguimiento: " + nombre)
        respaldos.append(registro(copia))

    resultado = {
        "fecha": "2026-10-20", "fecha_utc": datetime.now(timezone.utc).isoformat(),
        "autorizacion": "El autor respondió Sí a consolidar el cambio en un commit y actualizar la evidencia.",
        "estado": "Adaptación Rust consolidada localmente; evidencia previa vinculada sin recompilar.",
        "codigo": {"commit": COMMIT, "padre": git("rev-parse", "HEAD^"),
            "arbol_git": git("rev-parse", "HEAD^{tree}"), "archivos_del_commit": cambiados_commit,
            "arbol_limpio": True, "push_realizado": False},
        "fuentes_y_configuracion": fuentes,
        "cambios_desde_la_revision": cambios_desde_revision,
        "motivo_cambio_documental": "Sustituir la nota de cambios sin commit por la procedencia de las instantáneas y la consolidación posterior; ninguna fuente .rs cambia.",
        "finales_de_linea": {"archivos_normalizados_por_git": finales_normalizados,
            "criterio": "Cada blob coincide byte a byte con el archivo de trabajo o con su normalización CRLF a LF; se registran ambas huellas sin reescribir fuentes."},
        "evidencia_previa_intacta": referencias,
        "manifiesto_previo_conservado": registro(PREVIO),
        "archivos_del_manifiesto_previo_intactos_excepto_cuatro_indices_y_seguimiento": protegidos,
        "respaldos_del_seguimiento": respaldos,
        "seguimiento_actual": [registro(RAIZ / n) for n in SEGUIMIENTO],
        "fuentes_lean_intactas": len(lean["fuentes_sha256"]),
        "manuscrito_intacto": adaptacion["manuscrito_sin_cambios"],
        "certificados_historicos_intactos": len(adaptacion["certificados_historicos"]["archivos"]),
        "compilacion_rust_ejecutada_en_consolidacion": False,
        "compilacion_lean_ejecutada_en_consolidacion": False,
        "pruebas_rust_lean_repetidas_en_consolidacion": False,
        "pruebas_aisladas_previas": 113, "pruebas_nuevas_previas": 13,
        "manuscrito_regenerado": False, "commit_documental_creado": False,
        "limites": ["Sin prueba universal de refinamiento Rust/Lean ni validación L2 completa en ActiveChain.",
            "Los informes anteriores conservan su estado histórico previo al commit y al nuevo manifiesto.",
            "Sin aprobación académica ni dictamen independiente atribuidos; QROM y Qiskit siguen como trabajo futuro.",
            "El commit es local; los demás cambios del repositorio documental no se confirman ni publican."],
    }
    guardar(SALIDA, resultado)

    # Se conserva el esquema y toda la metainformación de la tesis unificada.
    anterior["fecha"] = "2026-10-20"
    anterior["fecha_utc"] = resultado["fecha_utc"]
    anterior["estado"] = ("Tesis final unificada y manuscrito del 19 intacto. Adaptación Rust al contrato Lean "
        "consolidada en commit local con evidencia aislada y revisión estática previas; sin nuevas compilaciones, "
        "regeneración documental, push ni aprobación académica atribuida.")
    anterior["codigo"]["commit"] = COMMIT
    anterior["manifiesto_previo"] = registro(PREVIO)
    anterior["lean"]["compilacion_global"] = "correcta_segun_registro_del_20_de_octubre; fuentes intactas"
    anterior["lean"]["recompilado_en_esta_conciliacion"] = False
    anterior["lean"]["auditoria"] = {**adaptacion["global_lean_sin_cambio_de_fuentes"],
        "declaraciones": 2709, "sorryAx": False, "axiomas_fuera_de_politica": []}
    anterior["consolidacion_rust_lean"] = {**registro(SALIDA), "commit_codigo": COMMIT,
        "pruebas_aisladas_previas": 113, "compilaciones_repetidas_en_consolidacion": False,
        "refinamiento_universal_demostrado": False}
    archivos = {item["archivo"]: item for item in anterior["archivos"]}
    for nombre in SEGUIMIENTO:
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

    # Reutiliza el comprobador de integridad existente; no ejecuta Cargo ni Lean.
    sys.path.insert(0, str(RAIZ / "scripts"))
    from verificar_version_tg2 import verificar
    verificacion = verificar(RAIZ, MANIFIESTO)
    exigir(verificacion["correcto"], json.dumps(verificacion, ensure_ascii=False))
    print(json.dumps({"commit": COMMIT, "integridad_manifiesto": verificacion,
        "fuentes_lean_intactas": resultado["fuentes_lean_intactas"],
        "fuentes_configuracion_rust": len(fuentes), "manuscrito_intacto": len(resultado["manuscrito_intacto"]),
        "manifiesto": registro(MANIFIESTO)}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
