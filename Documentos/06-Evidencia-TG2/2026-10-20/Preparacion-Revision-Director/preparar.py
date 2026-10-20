"""Prepara y verifica material para el director sin compilar ni emitir dictamen."""
from datetime import datetime, timezone
from fractions import Fraction
import hashlib
import json
from math import comb
from pathlib import Path
import re
import runpy
import shutil
import subprocess
import sys

RAIZ = Path(__file__).resolve().parents[1]
BASE = "df1eeae3fe026d3f47aa3e88b510489abd98845d"
CARPETA = "Documentos/06-Evidencia-TG2/2026-10-20/Preparacion-Revision-Director"
EVIDENCIA = RAIZ / CARPETA
PAQUETE = "Documentos/04-Administrativo-TG2/Avances/Revision-Matematica-S1-S3-2026-09-23.md"
MANIFIESTO = "Documentos/04-Administrativo-TG2/Entrega-Final/version-tg2.json"
CONTEXTO = RAIZ / "tmp/revision-director-contexto-2026-10-20.json"
EDITABLES = {PAQUETE, "BITACORA_TG2.md", "PENDIENTES.md",
    "Documentos/04-Administrativo-TG2/Entrega-Final/README.md", "Documentos/06-Evidencia-TG2/README.md"}
GLOBAL_RUST = "Documentos/06-Evidencia-TG2/2026-10-20/Rust-Global-Final/verificacion.json"
GLOBAL_LEAN = "Documentos/06-Evidencia-TG2/2026-10-20/Lean-Global/verificacion.json"
BANDERAS = getattr(subprocess, "CREATE_NO_WINDOW", 0)
TEOREMAS = {
    "formalizacion/Nexus/N02/Solucion.lean": ["cota"],
    "formalizacion/Nexus/N03/Solucion.lean": ["unicidad"],
    "formalizacion/Nexus/N06/Candidato.lean": ["candidato_unico"],
    "formalizacion/Nexus/Verificador/CotaAdaptativaFinal.lean": ["cardinal_excepciones", "cota_rondas"],
    "formalizacion/Nexus/Verificador/CotaSinBad.lean": ["cota_512"],
    "formalizacion/Nexus/Verificador/CotaTrabajoFinal.lean": ["cota_512", "cota_512_todos"],
    "formalizacion/Nexus/Verificador/CotaTrabajoNumerica.lean": ["aceptacion_release", "aceptacion_4096_release"],
    "formalizacion/Nexus/Verificador/PresupuestoGlobal.lean": ["presupuesto_512"],
}


def git(*args):
    return subprocess.check_output(["git", "-C", str(RAIZ), *args], creationflags=BANDERAS).decode("utf-8").strip()


def leer(nombre):
    return json.loads((RAIZ / nombre).read_text(encoding="utf-8-sig"))


def guardar(ruta, datos):
    ruta.write_text(json.dumps(datos, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def registro(nombre):
    datos = (RAIZ / nombre).read_bytes()
    return {"archivo": nombre, "bytes": len(datos), "sha256": hashlib.sha256(datos).hexdigest()}


def cotejar(lista):
    for item in lista:
        actual = registro(item["archivo"])
        assert actual["sha256"] == item["sha256"], item["archivo"]
        if "bytes" in item:
            assert actual["bytes"] == item["bytes"], item["archivo"]


def integridad():
    funcion = runpy.run_path(str(RAIZ / "scripts/verificar_version_tg2.py"))["verificar"]
    resultado = funcion(RAIZ, RAIZ / MANIFIESTO)
    assert resultado["correcto"], resultado
    return resultado


def protegidos():
    datos = leer(GLOBAL_RUST)
    for clave in ["fuentes_sha256", "fuentes_lean_sha256", "manuscrito_sha256"]:
        cotejar(datos[clave])
    return {clave: datos[clave] for clave in ["fuentes_sha256", "fuentes_lean_sha256", "manuscrito_sha256"]}


def preparar():
    assert git("rev-parse", "HEAD") == BASE
    assert not git("diff", "--cached", "--name-only")
    assert not git("diff", "--name-only"), "Hay cambios previos que requieren revisión."
    assert not EVIDENCIA.exists() and not CONTEXTO.exists()
    inicial = integridad()
    fuentes = protegidos()
    EVIDENCIA.mkdir(parents=True)
    respaldos = []
    for nombre in sorted(EDITABLES | {MANIFIESTO}):
        destino = EVIDENCIA / "respaldo_previo" / nombre
        destino.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(RAIZ / nombre, destino)
        item = registro(destino.relative_to(RAIZ).as_posix())
        assert item["sha256"] == registro(nombre)["sha256"]
        respaldos.append(item)
    # La copia conserva el programa temporal utilizado, no crea otro lanzador de pruebas.
    copia = EVIDENCIA / "preparar.py"
    shutil.copy2(Path(__file__), copia)
    guardar(CONTEXTO, {"commit_base": BASE, "integridad_previa": inicial, "respaldos": respaldos,
        "protegidos": fuentes, "herramienta": registro(copia.relative_to(RAIZ).as_posix())})
    print(json.dumps({"integridad_previa": inicial, "respaldos": len(respaldos),
        "destinatario": "director", "envio_registrado": False}, ensure_ascii=False))


def aritmetica():
    # Solo contrasta las expresiones racionales publicadas; no verifica sus premisas probabilísticas.
    p = 2 ** 64 - 2 ** 32 + 1
    tasa = Fraction(130709, p * p) + Fraction(2524360, 10 ** 35)
    def cota(L, bits, Q, perfiles):
        B = Q + 24895
        acoplamiento = min(Fraction(1), Fraction(512 * (B + 515), 2 ** 256))
        riesgo = sum((Fraction(comb((7 * 2 ** (k + 2)) // 8, 40), comb(2 ** (k + 2), 40))
            + Fraction(1, 2 ** 300) + acoplamiento for k in perfiles), Fraction(0))
        return min(Fraction(1), min(Fraction(1), Fraction(B * (49 * B + L), 2 ** 256))
            + tasa * B + Fraction(Q + 1, 2 ** bits) * riesgo)
    casos = []
    for L, bits, Q, perfiles, limite, nombre in [
        (1000000, 20, 2 ** 20, [12], Fraction(4757335454, 10 ** 12), "perfil_4096"),
        (1000000, 20, 1000000, list(range(4, 13)), Fraction(1, 20), "todos_perfiles_trabajo20"),
        (1000000, 12, 1000, list(range(4, 13)), Fraction(1, 80), "todos_perfiles_trabajo12"),
    ]:
        valor = cota(L, bits, Q, perfiles)
        assert valor < limite, nombre
        casos.append({"caso": nombre, "L": L, "bits": bits, "Q": Q, "perfiles": perfiles,
            "limite_superior": str(limite), "comparacion_racional_exacta": True})
    return {"casos": casos, "alcance": "Cotejo aritmético de las expresiones; no es dictamen independiente ni nueva prueba de solidez."}


def sellar():
    contexto = leer(CONTEXTO.relative_to(RAIZ))
    assert git("rev-parse", "HEAD") == BASE
    assert not git("diff", "--cached", "--name-only")
    protegidos()
    cotejar(contexto["respaldos"] + [contexto["herramienta"]])
    texto = (RAIZ / PAQUETE).read_text(encoding="utf-8-sig")
    preguntas = re.findall(r"^\| (M[1-6]) \|", texto, re.M)
    assert preguntas == [f"M{i}" for i in range(1, 7)], preguntas
    assert "Director de la tesis" in texto and "Sin dictamen registrado" in texto
    referencias = []
    for destino in sorted(set(re.findall(r"\]\(([^)\s]+)\)", texto))):
        assert not re.match(r"https?://", destino), "Este paquete usa referencias locales conservadas."
        ruta = ((RAIZ / PAQUETE).parent / destino.split("#", 1)[0]).resolve()
        assert ruta.is_relative_to(RAIZ) and ruta.is_file(), destino
        referencias.append(registro(ruta.relative_to(RAIZ).as_posix()))
    for nombre, teoremas in TEOREMAS.items():
        fuente = (RAIZ / nombre).read_text(encoding="utf-8-sig")
        for teorema in teoremas:
            assert re.search(r"^theorem " + re.escape(teorema) + r"(?:\s|\{|:)", fuente, re.M), (nombre, teorema)
    previo = CARPETA + "/respaldo_previo/" + MANIFIESTO
    datos = leer(previo)
    for item in datos["archivos"]:
        if item["archivo"] not in EDITABLES:
            cotejar([item])
    informe = {"fecha": "2026-10-20", "fecha_utc": datetime.now(timezone.utc).isoformat(),
        "estado": "paquete_preparado_para_revision_del_director_sin_dictamen",
        "autorizacion": "Dale al siguiente paso de revisión; el autor identifica a su director como revisor.",
        "destinatario": {"rol": "director", "nombre": None},
        "envio_registrado": False, "recepcion_registrada": False, "dictamen": None,
        "preguntas": {p: "pendiente_de_revision_del_director" for p in preguntas},
        "commit_documental_base": BASE, "commit_rust": datos["codigo"]["commit"],
        "paquete": registro(PAQUETE), "referencias_locales": referencias,
        "localizadores_teoremas": TEOREMAS, "cotejo_aritmetico": aritmetica(),
        "auditoria_lean_previa": registro(GLOBAL_LEAN), "global_rust_previa": registro(GLOBAL_RUST),
        "lean_fuentes_config_intactas": 354, "rust_fuentes_config_intactas": 89,
        "manuscrito_fuentes_salidas_intactas": 12,
        "compilaciones_repetidas": False, "manuscrito_regenerado": False, "commit_creado": False,
        "push_realizado": False, "obligaciones_matematicas_nuevas": False,
        "limite": "Preparación documental y cotejos internos, no revisión externa ni aprobación. QROM AIR/FRI sigue como trabajo futuro.",
        "respaldos": contexto["respaldos"], "herramienta": contexto["herramienta"],
        "documentacion_actualizada": [registro(n) for n in sorted(EDITABLES - {PAQUETE})]}
    destino = CARPETA + "/preparacion.json"
    guardar(RAIZ / destino, informe)
    rutas = {i["archivo"] for i in datos["archivos"]} | EDITABLES
    rutas.update(p.relative_to(RAIZ).as_posix() for p in EVIDENCIA.rglob("*") if p.is_file())
    datos["fecha_utc"] = informe["fecha_utc"]
    datos["manifiesto_previo"] = registro(previo)
    datos["preparacion_revision_director"] = registro(destino)
    datos["estado"] += " Paquete M1–M6 actualizado para el director; sin envío ni dictamen registrados, nuevas compilaciones o commit."
    datos["archivos"] = [registro(n) for n in sorted(rutas)]
    guardar(RAIZ / MANIFIESTO, datos)
    resultado = integridad()
    guardar(RAIZ / "tmp/revision-director-integridad-2026-10-20.json", resultado)
    print(json.dumps({"integridad": resultado, "preguntas": preguntas,
        "referencias_locales": len(referencias), "declaraciones_localizadas": sum(map(len, TEOREMAS.values())),
        "cotejos_aritmeticos": 3, "dictamen": None, "envio_registrado": False}, ensure_ascii=False))


if __name__ == "__main__":
    {"preparar": preparar, "sellar": sellar}[sys.argv[1]]()
