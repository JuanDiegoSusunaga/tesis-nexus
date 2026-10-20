"""Compila las pruebas Lean de NEXUS y conserva evidencia con axiomas y hashes."""

from __future__ import annotations

import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
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
    "Nexus.ROM.TablaInversa",
    "Nexus.ROM.PrefijoCorte",
    "Nexus.Canal.Trayecto",
    "Nexus.Canal.TrayectoTG2",
    "Nexus.Canal.ReconstruccionSelector",
    "Nexus.Canal.SoporteCandidato",
    "Nexus.Verificador.CandidatoPrevio",
    "Nexus.ROM.ActivacionPrefijo",
    "Nexus.ROM.PrimeraExposicion",
    "Nexus.ROM.ConteoActivaciones",
    "Nexus.ROM.CargaPrimeras",
    "Nexus.ROM.SelectorPrimeras",
    "Nexus.Canal.PrimerasExposiciones",
    "Nexus.ROM.ContinuacionPrefijo",
    "Nexus.ROM.ParticionObservada",
    "Nexus.ROM.ObservacionesPrefijo",
    "Nexus.ROM.SelectorPrefijo",
    "Nexus.ROM.SelectorAdaptativo",
    "Nexus.Canal.SelectorAdaptativo",
    "Nexus.Verificador.ContinuacionCausal",
    "Nexus.ROM.CintasRetos",
    "Nexus.ROM.ComparacionAcoplada",
    "Nexus.ROM.RepeticionesCinta",
    "Nexus.ROM.CadenaMemoria",
    "Nexus.ROM.AcoplamientoCadena",
    "Nexus.ROM.SelectorAcoplado",
    "Nexus.Canal.SelectorAcoplado",
    "Nexus.ROM.PromediosCompletaciones",
    "Nexus.ROM.LeyArbol",
    "Nexus.ROM.SoporteFinito",
    "Nexus.ROM.LeyMuestreoPrograma",
    "Nexus.ROM.ProgramaObservado",
    "Nexus.ROM.PrefijosGlobales",
    "Nexus.Verificador.LeyConjunta",
    "Nexus.Canal.RegistroRaices",
    "Nexus.Canal.RegistroSelector",
    "Nexus.Canal.RegistroCompleto",
    "Nexus.Merkle.AperturasPrograma",
    "Nexus.FRI.AperturasPrograma",
    "Nexus.Verificador.SoporteConsulta",
    "Nexus.Verificador.SoporteCompleto",
    "Nexus.Canal.FamiliasPrograma",
    "Nexus.Verificador.FamiliasAceptadas",
    "Nexus.ROM.PlanPrograma",
    "Nexus.Verificador.ExperimentoCausal",
    "Nexus.ROM.ProgramaBytes",
    "Nexus.ROM.ProyeccionDigest",
    "Nexus.ROM.HistoriaLocal",
    "Nexus.ROM.EjecucionBytes",
    "Nexus.ROM.PalabrasDigest",
    "Nexus.Canal.Intercalaciones",
    "Nexus.Canal.CongelacionPrograma",
    "Nexus.Canal.CintaSelector",
    "Nexus.Verificador.Adversario",
    "Nexus.ROM.RegistroPrograma",
    "Nexus.Merkle.ProgramaVerificacion",
    "Nexus.Bytes.Lectura",
    "Nexus.Bytes.Codec",
    "Nexus.Verificador.Certificado",
    "Nexus.Canal.SelectorOrdenado",
    "Nexus.FRI.ProgramaVerificacion",
    "Nexus.Canal.DesafiosPrograma",
    "Nexus.Verificador.Forma",
    "Nexus.Verificador.Consulta",
    "Nexus.Verificador.Completo",
    "Nexus.ROM.CertificadoLegado16",
    "Nexus.Canal.GramaticaTG2",
    "Nexus.ROM.ProgramaCompartido",
    "Nexus.Canal.ProgramaTG2",
    "Nexus.FRI.IndicesMaquina",
    "Nexus.Cripto.AplicacionAutenticada",
    "Nexus.Salud.Operaciones",
    "Nexus.Complejidad.FamiliasCodificacion",
    "Nexus.Modelos.DisponibilidadCondicional",
    "Nexus.MLDSA.CardinalRetos",
    "Nexus.MLDSA.ProductoNTT",
    "Nexus.Complejidad.CosteNTT",
    "Nexus.ROM.UniformidadSelector",
    "Nexus.ROM.LeySelector",
    "Nexus.ROM.AcoplamientoSelector",
    "Nexus.ROM.FrescuraFinita",
    "Nexus.ROM.HistoriaCausal",
    "Nexus.Cripto.DecodificacionOperacion",
    "Nexus.Cripto.CiclosFirmados",
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


def kernel_identity() -> dict[str, str]:
    """Identifica las fuentes Lean y todos los importados compilados de esta instalación."""
    paths = set(PROJECT.glob("*.lean")) | set((PROJECT / "Nexus").rglob("*.lean"))
    paths.update(PROJECT / n for n in ["lean-toolchain", "lakefile.toml", "lake-manifest.json",
        "cobertura.json", "inventario-manuscrito.json", "revision-manuscrito.json"])
    for folder in [PROJECT / ".lake", ROOT / ".tools/lean/elan/toolchains"]:
        paths.update(p for p in folder.rglob("*.olean*") if p.is_file() and not p.name.endswith(".hash"))
    paths.update((ROOT / ".tools/lean/elan/toolchains").glob("*/bin/leanchecker.exe"))
    return {p.relative_to(ROOT).as_posix(): sha256(p) for p in sorted(paths)}


def load_kernel_cache(path: Path, launcher: list[str]) -> tuple[dict[str, bytes], dict]:
    """Rechaza cambios de fuentes, importados, ejecutor o logs antes de reutilizar pruebas."""
    data = json.loads(path.read_text(encoding="utf-8"))
    if data["esquema"] != 1 or data["identidad_kernel"] != kernel_identity():
        raise ValueError("Las fuentes o importados difieren de la caché de replay.")
    result = {}
    for name, record in data["modulos_confirmados"].items():
        log = (ROOT / record["archivo"]).resolve()
        if (not log.is_relative_to(ROOT) or record["exito_confirmado_en_salida_del_padre"] is not True
                or sha256(log) != record["sha256"]):
            raise ValueError(f"Registro de replay alterado o sin éxito confirmado: {name}")
        command, output = log.read_text(encoding="utf-8").split("\n\n", 1)
        if (json.loads(command) != launcher + ["lake", "env", "leanchecker", "--verbose", name]
                or output != "replaying " + name + "\n"):
            raise ValueError(f"El registro de replay no coincide con el comando: {name}")
        result[name] = log.read_bytes()
    for name, value in data["fuentes_del_ejecutor"].items():
        if sha256(ROOT / name) != value:
            raise ValueError(f"Ejecutor previo alterado: {name}")
    return result, data


def replay_kernel(launcher: list[str], modules: tuple[str, ...], destination: Path, workers: int = 1,
                  cached: dict[str, bytes] | None = None) -> None:
    """Recomprueba todos los módulos con uno, dos o cuatro procesos simultáneos."""
    if workers not in (1, 2, 4) or len(modules) != len(set(modules)):
        raise ValueError("El replay exige uno, dos o cuatro procesos y módulos sin duplicados.")
    cached = cached or {}
    if not set(cached) <= set(modules):
        raise ValueError("La caché incluye módulos ajenos al replay.")

    def check(module):
        log = destination / f"kernel-{module}.log"
        if module in cached:
            log.write_bytes(cached[module])
            print(f"Reutilizado por identidad: {module}", flush=True)
            return
        execute(launcher + ["lake", "env", "leanchecker", "--verbose", module], log)

    if workers == 1:
        for module in modules:
            check(module)
        return
    errors = []
    with ThreadPoolExecutor(max_workers=workers) as pool:
        futures = {pool.submit(check, module): module for module in modules}
        for future in as_completed(futures):
            try:
                future.result()
            except Exception as error:
                errors.append((futures[future], error))
    if errors:
        raise RuntimeError("Falló el replay de: " + "; ".join(f"{name}: {error}" for name, error in errors)) from errors[0][1]


def verify(destination: Path, kernel_workers: int = 1, kernel_cache: Path | None = None) -> dict:
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

    # Se limita el paralelismo para no cargar muchas copias de mathlib en Windows.
    cached, cache_data = load_kernel_cache(kernel_cache, launcher) if kernel_cache else ({}, None)
    replay_kernel(launcher, CHECK_MODULES, destination, kernel_workers, cached)

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
    paths.add(ROOT / "scripts/tests/test_replay_kernel.py")
    if kernel_cache:
        paths.add(kernel_cache)
        paths.update(ROOT / name for name in cache_data["fuentes_del_ejecutor"])
        paths.add(kernel_cache.parent / "interrupcion.json")
    paths.add(ROOT / "scripts/inventariar_matematica.py")
    paths.add(PROJECT / "inventario-manuscrito.json")
    law_antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-18/Candidato-Previo-Antecedentes"
    paths.update(law_antecedents / name for name in ("manifiesto.json", "modelos.json", "revision-criterios.json"))
    law_previous = json.loads((law_antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    if law_previous["en_preparacion"]:
        raise ValueError("La reconstrucción del candidato conserva antecedentes en preparación.")
    for record in list(law_previous["versiones_anteriores"].values()) + law_previous["datos_fuente"]:
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente del candidato previo modificado: {record['archivo']}")
        paths.add(frozen)
    law_antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-18/Primeras-Exposiciones-Antecedentes"
    paths.update(law_antecedents / name for name in ("manifiesto.json", "modelos.json", "revision-criterios.json"))
    law_previous = json.loads((law_antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    if law_previous["en_preparacion"]:
        raise ValueError("Las primeras exposiciones conservan antecedentes en preparación.")
    for record in list(law_previous["versiones_anteriores"].values()) + law_previous["datos_fuente"]:
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente de primeras exposiciones modificado: {record['archivo']}")
        paths.add(frozen)
    law_antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-18/Selector-Adaptativo-Antecedentes"
    paths.update(law_antecedents / name for name in ("manifiesto.json", "modelos.json", "revision-criterios.json"))
    law_previous = json.loads((law_antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    if law_previous["en_preparacion"]:
        raise ValueError("El acoplamiento del selector conserva antecedentes en preparación.")
    for record in list(law_previous["versiones_anteriores"].values()) + law_previous["datos_fuente"]:
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente de acoplamiento del selector modificado: {record['archivo']}")
        paths.add(frozen)
    law_antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-18/Selector-Acoplado-Antecedentes"
    paths.update(law_antecedents / name for name in ("manifiesto.json", "modelos.json", "revision-criterios.json"))
    law_previous = json.loads((law_antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    if law_previous["en_preparacion"]:
        raise ValueError("El acoplamiento del selector conserva antecedentes en preparación.")
    for record in list(law_previous["versiones_anteriores"].values()) + law_previous["datos_fuente"]:
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente de acoplamiento del selector modificado: {record['archivo']}")
        paths.add(frozen)
    law_antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-18/Ley-Conjunta-Antecedentes"
    paths.update(law_antecedents / name for name in ("manifiesto.json", "modelos.json", "revision-criterios.json"))
    law_previous = json.loads((law_antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    if law_previous["en_preparacion"]:
        raise ValueError("La ley conjunta conserva antecedentes en preparación.")
    for record in list(law_previous["versiones_anteriores"].values()) + law_previous["datos_fuente"]:
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente de ley conjunta modificado: {record['archivo']}")
        paths.add(frozen)
    family_antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-18/Familias-Causales-Antecedentes"
    paths.update(family_antecedents / name for name in ("manifiesto.json", "modelos.json", "revision-criterios.json"))
    family_previous = json.loads((family_antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    if family_previous["en_preparacion"]:
        raise ValueError("Las familias causales conservan antecedentes en preparación.")
    for record in list(family_previous["versiones_anteriores"].values()) + family_previous["datos_fuente"]:
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente de familias causales modificado: {record['archivo']}")
        paths.add(frozen)
    causal_antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-18/Adversario-Causal-Antecedentes"
    paths.update(causal_antecedents / name for name in ("manifiesto.json", "modelos.json", "revision-criterios.json"))
    causal_previous = json.loads((causal_antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    if causal_previous["en_preparacion"]:
        raise ValueError("El bloque adversario causal conserva antecedentes en preparación.")
    for record in list(causal_previous["versiones_anteriores"].values()) + causal_previous["datos_fuente"]:
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente adversario causal modificado: {record['archivo']}")
        paths.add(frozen)
    complete_antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-17/Verificador-Completo-Antecedentes"
    paths.update(complete_antecedents / name for name in ("manifiesto.json", "modelos.json", "revision-criterios.json"))
    complete_previous = json.loads((complete_antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    if complete_previous["en_preparacion"]:
        raise ValueError("El verificador completo conserva antecedentes en preparación.")
    for record in list(complete_previous["versiones_anteriores"].values()) + complete_previous["datos_fuente"]:
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente del verificador completo modificado: {record['archivo']}")
        paths.add(frozen)
    certificate_antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-17/Certificado-Gramatica-Antecedentes"
    paths.update(certificate_antecedents / name for name in ("manifiesto.json", "modelos.json", "revision-criterios.json"))
    certificate_previous = json.loads((certificate_antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    if certificate_previous["en_preparacion"]:
        raise ValueError("El enlace de certificado y gramática conserva antecedentes en preparación.")
    for record in list(certificate_previous["versiones_anteriores"].values()) + certificate_previous["datos_fuente"]:
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente de certificado y gramática modificado: {record['archivo']}")
        paths.add(frozen)
    criteria_antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-17/Cierre-Criterios-Antecedentes"
    paths.update(criteria_antecedents / name for name in ("manifiesto.json", "modelos.json", "revision-criterios.json"))
    criteria_previous = json.loads((criteria_antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    if criteria_previous["en_preparacion"]:
        raise ValueError("El cierre por criterios conserva antecedentes en preparación.")
    for record in list(criteria_previous["versiones_anteriores"].values()) + criteria_previous["datos_fuente"]:
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente de cierre por criterios modificado: {record['archivo']}")
        paths.add(frozen)
    selector_antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-17/Selector-Ciclos-Antecedentes"
    paths.update(selector_antecedents / name for name in ("manifiesto.json", "modelos.json", "revision-selector-ciclos.json"))
    selector_previous = json.loads((selector_antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    if selector_previous["en_preparacion"]:
        raise ValueError("Selector y ciclos conserva antecedentes en preparación.")
    for record in list(selector_previous["versiones_anteriores"].values()) + selector_previous["datos_fuente"]:
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente de selector/ciclos modificado: {record['archivo']}")
        paths.add(frozen)
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
            "procesos_maximos": kernel_workers,
            "modulos_reutilizados_por_identidad": list(cached),
            "cache_sha256": sha256(kernel_cache) if kernel_cache else None,
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
    parser.add_argument("--procesos-kernel", type=int, choices=(1, 2, 4), default=1,
                        help="Máximo de procesos leanchecker simultáneos; por defecto uno.")
    parser.add_argument("--cache-kernel", type=Path,
                        help="Caché con identidad de fuentes/importados y logs de replays confirmados.")
    args = parser.parse_args()
    try:
        report = verify(args.salida.resolve(), args.procesos_kernel,
                        args.cache_kernel.resolve() if args.cache_kernel else None)
    except (OSError, ValueError, RuntimeError, KeyError, StopIteration) as error:
        print(f"Validación fallida: {error}", file=sys.stderr)
        return 1
    print(f"Verificados {report['teoremas_auditados']} teoremas; "
          f"{report['afirmaciones_con_teoremas']}/12 afirmaciones con componentes mecanizados.")
    print(f"Evidencia: {args.salida.resolve() / 'validacion.json'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
