"""Compila las pruebas Lean de NEXUS y conserva evidencia con axiomas y hashes."""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time

from lean import ROOT, PROJECT
from verificar_revision_manuscrito import validate as validate_review


ALLOWED_AXIOMS = frozenset({"propext", "Classical.choice", "Quot.sound"})
CHECK_MODULES = (
    "Nexus.Merkle.RegistroVerificador",
    "Nexus.FRI.Recorrido",
    "Nexus.Canal.AceptacionRecorridos",
    "Nexus.MLDSA.ContrasteJMW",
    "Nexus.MLDSA.Retos",
    "Nexus.FRI.RetosAfines",
    "Nexus.Cripto.RotacionFirmada",
    "Nexus.Cripto.OperacionBytes",
    "Nexus.Salud.RachasCondicionales",
    "Nexus.Salud.InvariantesLote",
    "Nexus.MLDSA.NTTAlgebra",
    "Nexus.Complejidad.ContadorFirma",
    "Nexus.Complejidad.SerializacionPrueba",
    "Nexus.FRI.FormasLimites",
    "Nexus.Modelos.LayoutBackend",
    "Nexus.ROM.ReconstruccionPublica",
    "Nexus.ROM.SelectorRechazo",
    "Nexus.ROM.PotencialCandidatos",
    "Nexus.ROM.ComposicionCotas",
    "Nexus.ROM.EjemploNumerico",
    "Nexus.AIR.GradosValidos",
    "Nexus.AIR.CancelacionSesgada",
    "Nexus.AIR.EjemploCancelacion",
    "Nexus.Reticulos.Euclideos",
    "Nexus.MLDSA.Plantilla",
    "Nexus.Cripto.Variacion",
    "Nexus.ROM.Sesgo",
    "Nexus.Cripto.Derivacion",
    "Nexus.Cripto.RegistroEpocas",
    "Nexus.Cripto.Transacciones",
    "Nexus.Modelos.IdealHistorico",
    "Nexus.ROM.RaicesCanonicas",
    "Nexus.Complejidad.Comunicacion",
    "Nexus.Modelos.QuorumIncentivos",
    "Nexus.Modelos.Mediciones",
    "Nexus.ROM.ColaSelector",
    "Nexus.Salud.DecimalesAPT",
    "Nexus.Cripto.PerdidaQROM",
    "Nexus.ROM.Presupuestos",
    "Nexus.Cripto.Probabilidad",
    "Nexus.Cripto.Oraculo",
    "Nexus.MLDSA.Representantes",
    "Nexus.MLDSA.Cortos",
    "Nexus.MLDSA.MSIS",
    "Nexus.MLDSA.MLWE",
    "Nexus.MLDSA.SelfTarget",
    "Nexus.Cripto.Firma",
    "Nexus.Cripto.Seguridad",
    "Nexus.MLDSA.Parametros",
    "Nexus.MLDSA.Anillos",
    "Nexus.MLDSA.Normas",
    "Nexus.AIR.DistanciaExacta",
    "Nexus.AIR.Perturbacion",
    "Nexus.AIR.ComposicionAlejada",
    "Nexus.AIR.CocientesAlejados",
    "Nexus.AIR.Interpolacion",
    "Nexus.AIR.ContraejemploGoldilocks",
    "Nexus.Modelos.ResidenciaIntegral",
    "Nexus.Modelos.CapturaUniforme",
    "Nexus.Modelos.Memoria",
    "Nexus.Modelos.AmortizacionVariable",
    "Nexus.Complejidad.NTT",
    "Nexus.Complejidad.Rechazo",
    "Nexus.Complejidad.Firma",
    "Nexus.Entropia.Minima",
    "Nexus.Entropia.Shannon",
    "Nexus.Salud.RCT",
    "Nexus.Salud.Binomial",
    "Nexus.Salud.APT",
    "Nexus.Salud.Monitor",
    "Nexus.Salud.Fuente",
    "Nexus.FRI.PosicionesAIR",
    "Nexus.Canal.RaizCompartida",
    "Nexus.Canal.AperturasAIR",
    "Nexus.Canal.EnlaceComposicion",
    "Nexus.Merkle.CodificacionBase",
    "Nexus.ROM.FormatoBase",
    "Nexus.FRI.OraculoBase",
    "Nexus.Canal.OraculosBase",
    "Nexus.Merkle.Indices",
    "Nexus.Merkle.PruebasIndexadas",
    "Nexus.FRI.OraculoMerkle",
    "Nexus.Canal.OraculosMerkle",
    "Nexus.ROM.Frescura",
    "Nexus.ROM.Origen",
    "Nexus.ROM.OrdenConsultas",
    "Nexus.Canal.PrimerasConsultas",
    "Nexus.ROM.Preparacion",
    "Nexus.ROM.CongelacionPrevia",
    "Nexus.Canal.Entradas",
    "Nexus.Canal.Raices",
    "Nexus.ROM.Memoria",
    "Nexus.ROM.Juego",
    "Nexus.ROM.Probabilidad",
    "Nexus.ROM.RegistroFinal",
    "Nexus.Bytes.LittleEndian",
    "Nexus.Merkle.Codificacion",
    "Nexus.Merkle.Ventanas",
    "Nexus.Merkle.MarcasGlobales",
    "Nexus.Merkle.Registro",
    "Nexus.Merkle.Extraccion",
    "Nexus.Merkle.Etiquetas",
    "Nexus.Merkle.Temporal",
    "Nexus.N06.ExtensionRetos",
    "Nexus.N06.PasosExplicitos",
    "Nexus.N06.PlanesExplicitos",
    "Nexus.N06.TraduccionPlanes",
    "Nexus.N06.OraculosEmitidos",
    "Nexus.N06.DatosTranscripcion",
    "Nexus.N06.TranscripcionExplicita",
    "Nexus.N06.RondasExplicitas",
    "Nexus.N06.CongruenciaPrefijos",
    "Nexus.N06.PoliticasCompatibles",
    "Nexus.N06.TerminalesConstantes",
    "Nexus.N06.MensajesCompatibles",
    "Nexus.N06.ReiniciosObservados",
    "Nexus.N06.Prefijos",
    "Nexus.N06.TranscripcionCausal",
    "Nexus.N06.SolidezCausal",
    "Nexus.N06.ReiniciosAdaptativos",
    "Nexus.N06.Reinicios",
    "Nexus.N06.PrimerCambio",
    "Nexus.N06.Muestras",
    "Nexus.N06.ReiniciosIdeal",
    "Nexus.N06.Estado",
    "Nexus.N06.Monitores",
    "Nexus.N06.EstadoConjunto",
    "Nexus.N06.PorRondas",
    "Nexus.N06.Transcripcion",
    "Nexus.FRI.Experimento",
    "Nexus.N06.Ejecucion",
    "Nexus.N06.Solidez",
    "Nexus.N06.Consulta",
    "Nexus.FRI.Consulta",
    "Nexus.N06.Parejas",
    "Nexus.N06.Compartida",
    "Nexus.N06.Candidato",
    "Nexus.N06.Cancelacion",
    "Nexus.N06.SeleccionAIR",
    "Nexus.N06.Composicion",
    "Nexus.N06.Experimento",
    "Nexus.FRI.Adaptativo",
    "Nexus.N06.Goldilocks",
    "Nexus.FRI.Cosets",
    "Nexus.FRI.Goldilocks",
    "Nexus.FRI.Indices",
    "Nexus.FRI.Dominios",
    "Nexus.FRI.Torre",
    "Nexus.FRI.Muestreo",
    "Nexus.FRI.Presupuesto",
    "Nexus.N04.RadioReal",
    "Nexus.N04.Plegado",
    "Nexus.N05.Cotas",
    "Nexus.N05.Parejas",
    "Nexus.Modelos.Omision",
    "Nexus.Campos.Polinomios",
    "Nexus.N03.CampoBase",
    "Nexus.N03.Perfil",
    "Nexus.N03.Alternativa",
    "Nexus.Distancia.Propiedades",
    "Nexus.AIR.Localidad",
    "Nexus.AIR.Transferencia",
    "Nexus.Modelos.DistanciaAIR",
    "Nexus.Campos.Goldilocks",
    "Nexus.AIR.Grados",
    "Nexus.AIR.Goldilocks",
    "Nexus.AIR.Solucion",
    "Nexus.Modelos.Costos",
    "Nexus.Modelos.Residencia",
    "Nexus.Reticulos.Preimagenes",
    "Nexus.Distancia",
    "Nexus.N01.Solucion",
    "Nexus.N02.Solucion",
    "Nexus.N03.Solucion",
    "Nexus.N04.Solucion",
    "Nexus.N05.Muestreo",
    "Nexus.N12.Solucion",
)


def parse_axioms(output: str, expected: set[str]) -> dict[str, list[str]]:
    pattern = re.compile(
        r"'([^']+)' (?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)"
    )
    found = {}
    for match in pattern.finditer(output):
        name, values = match.groups()
        if name in found:
            raise ValueError(f"Teorema auditado dos veces: {name}")
        axioms = sorted(v.strip() for v in (values or "").split(",") if v.strip())
        forbidden = set(axioms) - ALLOWED_AXIOMS
        if forbidden:
            raise ValueError(f"{name}: axiomas no permitidos: {sorted(forbidden)}")
        found[name] = axioms
    if set(found) != expected:
        raise ValueError(
            f"Auditoría incompleta: faltan {sorted(expected - set(found))}; "
            f"sobran {sorted(set(found) - expected)}"
        )
    return found


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def execute(command: list[str], log: Path) -> str:
    env = os.environ.copy()
    env["PYTHONIOENCODING"] = "utf-8"
    started = time.monotonic()
    print(f"Comprobando {log.stem}...", flush=True)
    result = subprocess.run(
        command,
        cwd=ROOT,
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        encoding="utf-8",
        errors="replace",
        creationflags=subprocess.CREATE_NO_WINDOW if os.name == "nt" else 0,
    )
    log.write_text(
        json.dumps(command, ensure_ascii=False) + "\n\n" + result.stdout,
        encoding="utf-8",
    )
    if result.returncode:
        raise RuntimeError(f"Falló {log.stem} (código {result.returncode}); revisar {log}")
    if log.stem in {"build", "axiomas"} and re.search(r"\b(?:warning|error):", result.stdout):
        raise RuntimeError(f"{log.stem} produjo advertencias o errores; revisar {log}")
    print(f"Correcto: {log.stem} ({time.monotonic() - started:.1f} s)", flush=True)
    return result.stdout


def verify(destination: Path) -> dict:
    destination.mkdir(parents=True, exist_ok=False)
    registry = json.loads((PROJECT / "cobertura.json").read_text(encoding="utf-8"))
    catalog_path = ROOT / registry["catalogo_base"]
    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    if registry["tesis_completa_verificada"] is not False:
        raise ValueError("Esta etapa no puede declarar verificada la tesis completa.")
    manuscript = json.loads((PROJECT / "inventario-manuscrito.json").read_text(encoding="utf-8"))
    review = json.loads((PROJECT / "revision-manuscrito.json").read_text(encoding="utf-8"))
    review_summary = validate_review(review, manuscript, ROOT)
    if set(registry["axiomas_permitidos"]) != ALLOWED_AXIOMS:
        raise ValueError("La lista de axiomas permitidos no coincide con la política del verificador.")
    ids = [a["id"] for a in registry["afirmaciones"]]
    if len(ids) != len(set(ids)) or set(ids) != {a["id"] for a in catalog["afirmaciones"]}:
        raise ValueError("La cobertura debe registrar cada afirmación del catálogo exactamente una vez.")
    theorem_list = registry["teoremas_auxiliares"] + [
        t for a in registry["afirmaciones"] for t in a["teoremas"]
    ] + [t for a in registry.get("resultados_manuscrito", []) for t in a["teoremas"]]
    if len(theorem_list) != len(set(theorem_list)):
        raise ValueError("Teoremas repetidos en la cobertura.")
    expected = set(theorem_list)
    audit_names = re.findall(r"^#print axioms (\S+)$",
                            (PROJECT / "Auditoria.lean").read_text(encoding="utf-8"), re.M)
    if set(audit_names) != expected or len(audit_names) != len(expected):
        raise ValueError("Auditoria.lean no coincide con los teoremas registrados.")

    py = sys.executable
    launcher = [py, str(ROOT / "scripts/lean.py")]
    integrity = json.loads(execute(
        [py, str(ROOT / "scripts/verificar_catalogo_validacion.py")], destination / "catalogo.log"
    ))
    if integrity.get("correcto") is not True:
        raise ValueError("No pasó la integridad del catálogo histórico.")
    version = execute(launcher + ["lake", "--version"], destination / "version.log").strip()
    execute(launcher + ["build"], destination / "build.log")
    output = execute(launcher + ["lean", "Auditoria.lean"], destination / "axiomas.log")
    axioms = parse_axioms(output, expected)

    # Los nombres exactos evitan recomprobar todos los módulos en paralelo,
    # cargando muchas copias de mathlib y agotando la memoria de Windows.
    for module in CHECK_MODULES:
        execute(launcher + ["lake", "env", "leanchecker", "--verbose", module],
                destination / f"kernel-{module}.log")

    manifest = json.loads((PROJECT / "lake-manifest.json").read_text(encoding="utf-8"))
    mathlib = next(p for p in manifest["packages"] if p["name"] == "mathlib")
    actual_rev = execute(
        ["git", "-C", str(PROJECT / ".lake/packages/mathlib"), "rev-parse", "HEAD"],
        destination / "mathlib-revision.log",
    ).strip()
    if actual_rev != mathlib["rev"]:
        raise ValueError("La revisión instalada de mathlib difiere del manifiesto.")
    docs_rev = execute(["git", "rev-parse", "HEAD"], destination / "documentos-revision.log").strip()

    paths = set(PROJECT.glob("*.lean")) | set((PROJECT / "Nexus").rglob("*.lean"))
    paths.update(PROJECT / name for name in ("lean-toolchain", "lakefile.toml", "lake-manifest.json", "cobertura.json"))
    paths.update(ROOT / "scripts" / name for name in ("lean.py", "verificar_formalizacion.py", "verificar_catalogo_validacion.py"))
    paths.add(ROOT / "scripts/tests/test_verificar_formalizacion.py")
    paths.add(ROOT / "scripts/inventariar_matematica.py")
    paths.add(PROJECT / "inventario-manuscrito.json")
    wide_antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-17/Obligaciones-22-Antecedentes"
    paths.update(wide_antecedents / name for name in ("manifiesto.json", "modelos.json", "revision-22.json"))
    wide_previous = json.loads((wide_antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    if wide_previous["en_preparacion"]:
        raise ValueError("La pasada de 22 obligaciones conserva antecedentes en preparación.")
    for record in list(wide_previous["versiones_anteriores"].values()) + wide_previous["datos_fuente"]:
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente de obligaciones modificado: {record['archivo']}")
        paths.add(frozen)
    degree_antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-17/Grados-Cancelacion-Antecedentes"
    paths.update(degree_antecedents / name for name in ("manifiesto.json", "modelos.json", "ejemplo.json"))
    degree_previous = json.loads((degree_antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    if degree_previous["en_preparacion"]:
        raise ValueError("Los antecedentes de grados/cancelación siguen en preparación.")
    for record in list(degree_previous["versiones_anteriores"].values()) + degree_previous["datos_fuente"]:
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente de grados/cancelación modificado: {record['archivo']}")
        paths.add(frozen)
    model_antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-17/Modelos-Pendientes-Antecedentes"
    paths.update(model_antecedents / name for name in ("manifiesto.json", "modelos.json", "mediciones.json"))
    model_previous = json.loads((model_antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    if model_previous["en_preparacion"]:
        raise ValueError("El bloque de modelos conserva un manifiesto en preparación.")
    for record in list(model_previous["versiones_anteriores"].values()) + model_previous["datos_fuente"]:
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente de modelos modificado: {record['archivo']}")
        paths.add(frozen)
    game_antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-17/Juegos-Reticulares-Antecedentes"
    paths.update(game_antecedents / name for name in ("manifiesto.json", "modelos.json"))
    game_previous = json.loads((game_antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    for record in game_previous["versiones_anteriores"].values():
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente de juegos modificado: {record['archivo']}")
        paths.add(frozen)
    algebra_antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-17/Anillos-Contraejemplo-Antecedentes"
    paths.update(algebra_antecedents / name for name in ("manifiesto.json", "evidencia-empirica.json"))
    algebra_previous = json.loads((algebra_antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    for record in list(algebra_previous["versiones_anteriores"].values()) + algebra_previous["fuentes_r4"]:
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente de anillos/contraejemplo modificado: {record['archivo']}")
        paths.add(frozen)
    paths.add(ROOT / ".gitattributes")
    cost_antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-17/Costos-Residencia-Antecedentes"
    paths.update(cost_antecedents / name for name in ("manifiesto.json", "datos-modelos.json"))
    cost_previous = json.loads((cost_antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    for record in list(cost_previous["versiones_anteriores"].values()) + cost_previous["fuentes_r5"]:
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente de costos modificado: {record['archivo']}")
        paths.add(frozen)
    paths.add(PROJECT / "revision-manuscrito.json")
    paths.add(ROOT / "scripts/verificar_revision_manuscrito.py")
    paths.add(ROOT / "scripts/tests/test_verificar_revision_manuscrito.py")
    antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-17/Entropia-Salud-Antecedentes"
    paths.update(antecedents / name for name in ("manifiesto.json", "fuentes-normativas.json"))
    previous = json.loads((antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    for record in list(previous["versiones_anteriores"].values()) + [previous["rust_modelado"]]:
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente modificado: {record['archivo']}")
        paths.add(frozen)
    manuscript = json.loads((PROJECT / "inventario-manuscrito.json").read_text(encoding="utf-8"))
    for source in manuscript["fuentes"]:
        source_path = ROOT / source["archivo"]
        if sha256(source_path) != source["sha256"]:
            raise ValueError(f"El inventario no corresponde al manuscrito: {source['archivo']}")
        paths.add(source_path)
    paths.add(ROOT / "Documentos/06-Evidencia-TG2/2026-09-22/R5-residencia/sensibilidad.json")
    paths.add(ROOT / "Documentos/06-Evidencia-TG2/2026-09-23/R4-Merkle-FS/fuentes/nexus/nexus-zk/src/stark/field.rs")
    paths.add(ROOT / "Documentos/06-Evidencia-TG2/2026-09-23/R4-Merkle-FS/fuentes/nexus/nexus-zk/src/stark/air.rs")
    paths.add(ROOT / "Documentos/06-Evidencia-TG2/2026-09-23/R4-Merkle-FS/fuentes/nexus/nexus-zk/src/stark/fri.rs")
    paths.add(ROOT / "Documentos/06-Evidencia-TG2/2026-09-23/R4-Merkle-FS/fuentes/nexus/nexus-zk/src/stark/merkle.rs")
    paths.add(ROOT / "Documentos/06-Evidencia-TG2/2026-09-23/R4-Merkle-FS/fuentes/nexus/nexus-zk/src/stark/channel.rs")
    paths.add(catalog_path)
    paths.update(ROOT / item["archivo"] for item in catalog["archivos"])
    hashes = {p.relative_to(ROOT).as_posix(): sha256(p) for p in sorted(paths)}
    report = {
        "esquema": 1,
        "fecha_utc": datetime.now(timezone.utc).isoformat(),
        "correcto": True,
        "tesis_completa_verificada": False,
        "version": version,
        "mathlib_revision": actual_rev,
        "revision_documental_contexto": docs_rev,
        "nota_revision": "Los hashes identifican el árbol de trabajo ejecutado; el commit de contexto puede no contener estos cambios.",
        "afirmaciones_catalogo": len(ids),
        "afirmaciones_con_teoremas": sum(bool(a["teoremas"]) for a in registry["afirmaciones"]),
        "teoremas_auditados": len(axioms),
        "bloques_adicionales_manuscrito": len(registry.get("resultados_manuscrito", [])),
        "candidatos_inventario_manuscrito": len(manuscript["candidatos"]),
        "inventario_revisado_completamente": manuscript["completo_semanticamente"],
        "revision_manual_manuscrito": review_summary,
        "axiomas": axioms,
        "kernel": {
            "herramienta": "leanchecker incluido en Lean 4.35.0",
            "modulos": list(CHECK_MODULES),
            "modo": "Replay de cada módulo por separado; se confía en los módulos importados. No es --fresh ni un verificador externo.",
        },
        "integridad_catalogo_historico": integrity,
        "cobertura": registry["afirmaciones"],
        "resultados_manuscrito": registry.get("resultados_manuscrito", []),
        "sha256_fuentes": hashes,
        "sha256_logs": {p.name: sha256(p) for p in sorted(destination.glob("*.log"))},
        "dictamen_independiente": "pendiente",
        "qrom_air_fri": "trabajo_futuro",
    }
    (destination / "validacion.json").write_text(
        json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    return report


def main() -> int:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--salida", type=Path, default=ROOT / ".tools/lean/validaciones" /
                        datetime.now().strftime("%Y%m%d-%H%M%S"))
    args = parser.parse_args()
    try:
        report = verify(args.salida.resolve())
    except (OSError, ValueError, RuntimeError, KeyError, StopIteration) as error:
        print(f"Validación fallida: {error}", file=sys.stderr)
        return 1
    print(f"Verificados {report['teoremas_auditados']} teoremas; "
          f"{report['afirmaciones_con_teoremas']}/12 afirmaciones con componentes mecanizados.")
    print(f"Evidencia: {args.salida.resolve() / 'validacion.json'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
