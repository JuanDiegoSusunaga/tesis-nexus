"""Registra el candidato previo sin declarar nuevos grupos cerrados."""

from copy import deepcopy
import hashlib
import json
from pathlib import Path
import re
import sys

from config_semantica_previa import MODELS, OPEN

sys.stdout.reconfigure(encoding="utf-8")
root = Path(__file__).resolve().parents[2]
folder = root / "Documentos/06-Evidencia-TG2/2026-10-18"
prep, stage = folder / "Semantica-Previa-Antecedentes", folder / "Lean-Semantica-Previa"
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
load = lambda p: json.loads(p.read_text(encoding="utf-8"))


def save(path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


manifest = load(prep / "manifiesto.json")
assert manifest["en_preparacion"] and not stage.exists()
registry = load(root / "formalizacion/cobertura.json")
inventory = load(root / "formalizacion/inventario-manuscrito.json")
review = load(root / "formalizacion/revision-manuscrito.json")
initial = {g["id"] for g in review["obligaciones"] if g["estado"] == "parcial"}
assert initial == {"M26", "M35", "M36", "M39", "M40", "M41"}
assert set(OPEN) <= initial
for name, record in manifest["versiones_anteriores"].items():
    assert sha(root / name) == record["sha256"], name
models = deepcopy(MODELS)
assert len(models) == 8
for name, model in models.items():
    source = (root / "formalizacion/Nexus" / (name + ".lean")).read_text(encoding="utf-8")
    assert not re.search(r"\b(?:sorry|admit|axiom|native_decide|unsafe|implemented_by)\b", source), name
    namespace = re.search(r"^namespace (\S+)", source, re.M)[1]
    model["teoremas"] = [namespace + "." + n for n in re.findall(r"^theorem (\w+)", source, re.M)]
    assert model["teoremas"], name
new = sum(len(m["teoremas"]) for m in models.values())
assert new == 51
total, modules = 2233 + new, 261 + len(models)
evaluations = []
for group in review["obligaciones"]:
    gid = group["id"]
    if gid not in initial:
        continue
    relevant = [n for n, m in models.items() if gid in m["grupos"]]
    item = {"id": gid, "titulo": group["titulo"], "estado_anterior": "parcial", "estado_actual": "parcial",
        "criterio_cierre_conservado": deepcopy(group["criterio_cierre"]),
        "pendientes_anteriores": deepcopy(group["pendiente_actual"]), "modulos_nuevos": relevant,
        "evaluacion_criterios": [{"criterio_original": c, "evaluacion": "conservado_sin_declarar_cierre",
            "teoremas": []} for c in group["criterio_cierre"]],
        "juicio": "Correspondencia semántica del agente; no sustituye revisión independiente."}
    if relevant:
        group["avance_verificado"] += " " + " ".join(models[n]["verificado"] for n in relevant)
    if gid in OPEN:
        group["pendiente_actual"] = [OPEN[gid]]
    item["pendiente_actual"] = deepcopy(group["pendiente_actual"])
    group["revision_semantica_previa"] = {"registro": (prep / "revision-criterios.json").relative_to(root).as_posix(),
        "nota": "GT/GC semanticos definidos antes del primer I y conservados hasta la vista final. Faltan pertenencia de consultas aceptadas, puente probabilistico y cotas globales; se conservan seis grupos parciales."}
    evaluations.append(item)
save(prep / "modelos.json", models)
save(prep / "revision-criterios.json", {"esquema": 1, "grupos_revisados": evaluations,
    "cerrados_en_su_modelo": [], "parciales_restantes": sorted(initial), "criterios_reducidos": False,
    "obligaciones_adicionales_cerradas": False, "tesis_completa_verificada": False,
    "dictamen_independiente": "pendiente"})
source_names = ["nexus/Cargo.lock", "nexus/nexus-zk/src/stark/air.rs", "nexus/nexus-zk/src/stark/channel.rs",
    "nexus/nexus-zk/src/stark/field.rs", "nexus/nexus-zk/src/stark/fri.rs", "nexus/nexus-zk/src/stark/merkle.rs",
    "nexus/nexus-zk/src/stark/params.rs", "nexus/nexus-core/src/types.rs",
    "nexus/nexus-zk/experiments/tg2_linked_trace_fri.rs", "scripts/verificar_certificados_tg2.py",
    "scripts/auditar_merkle_fs_r4.py", "scripts/analizar_transferencia_rom_tg2.py",
    ".tools/lean/config_semantica_previa.py", ".tools/lean/registrar_semantica_previa.py",
    ".tools/lean/preparar_semantica_previa.py"]
frozen = []
for name in source_names:
    source, target = root / name, prep / "fuentes" / name
    assert source.is_file() and not target.exists(), name
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(source.read_bytes())
    frozen.append({"fuente_original": name, "archivo": target.relative_to(root).as_posix(), "sha256": sha(target)})
for name, model in models.items():
    identifier = "TG2-" + name.replace("/", "-").upper()
    assert identifier not in {g["id"] for g in registry["resultados_manuscrito"]}
    registry["resultados_manuscrito"].append({"id": identifier, "secciones": model["secciones"],
        "estado": "componentes_verificados", "verificado": model["verificado"],
        "teoremas": model["teoremas"], "pendiente": model["limites"]})
save(root / "formalizacion/cobertura.json", registry)
for name, addition in [
    ("formalizacion/Nexus.lean", "\n".join("public import Nexus." + n.replace("/", ".") for n in models)),
    ("formalizacion/Auditoria.lean", "\n".join("#print axioms " + t for m in models.values() for t in m["teoremas"]))]:
    path = root / name
    path.write_text(path.read_text(encoding="utf-8").rstrip() + "\n" + addition + "\n", encoding="utf-8")
path = root / "scripts/verificar_formalizacion.py"
text = path.read_text(encoding="utf-8").replace("CHECK_MODULES = (\n", "CHECK_MODULES = (\n" + "".join(
    '    "Nexus.' + n.replace("/", ".") + '",\n' for n in models), 1)
anchor = '    paths.add(PROJECT / "inventario-manuscrito.json")\n'
addition = '''    law_antecedents = ROOT / "Documentos/06-Evidencia-TG2/2026-10-18/Semantica-Previa-Antecedentes"
    paths.update(law_antecedents / name for name in ("manifiesto.json", "modelos.json", "revision-criterios.json"))
    law_previous = json.loads((law_antecedents / "manifiesto.json").read_text(encoding="utf-8"))
    if law_previous["en_preparacion"]:
        raise ValueError("La reconstrucción del candidato conserva antecedentes en preparación.")
    for record in list(law_previous["versiones_anteriores"].values()) + law_previous["datos_fuente"]:
        frozen = ROOT / record["archivo"]
        if sha256(frozen) != record["sha256"]:
            raise ValueError(f"Antecedente del candidato previo modificado: {record['archivo']}")
        paths.add(frozen)
'''
assert text.count(anchor) == 1
path.write_text(text.replace(anchor, anchor + addition), encoding="utf-8")
by_id = {g["id"]: g for g in inventory["candidatos"]}
changed, links = [], 0
for row in review["bloques"]:
    relevant = [n for n, m in models.items() if set(row["obligaciones"]) & set(m["grupos"])]
    if not relevant:
        continue
    for name in relevant:
        model = models[name]
        link = {"archivo": "formalizacion/Nexus/" + name + ".lean",
            "declaraciones": [t.rsplit(".", 1)[1] for t in model["teoremas"]],
            "alcance": model["verificado"] + " Límites: " + " ".join(model["limites"])}
        row["lean"].append(link)
        by_id[row["candidato"]]["lean"].append(link)
        links += 1
    by_id[row["candidato"]]["revision_semantica"] = "parcial"
    changed.append(row["candidato"])
review["auditoria_lean_actual"] = {"archivo": stage.relative_to(root).as_posix() + "/validacion.json",
    "teoremas": total, "modulos": modules}
save(root / "formalizacion/inventario-manuscrito.json", inventory)
save(root / "formalizacion/revision-manuscrito.json", review)
manifest.update({"en_preparacion": False, "datos_fuente": frozen,
    "cambios_fuentes_previas_autorizados": ["formalizacion/Nexus.lean", "formalizacion/Auditoria.lean",
        "formalizacion/cobertura.json", "formalizacion/inventario-manuscrito.json",
        "formalizacion/revision-manuscrito.json", "scripts/verificar_formalizacion.py"],
    "resultados_nuevos": new, "modulos_nuevos": len(models), "teoremas": total, "modulos": modules,
    "grupos_cerrados": [], "grupos_revisados": sorted(initial),
    "correspondencias_actualizadas": changed, "enlaces_nuevos": links})
save(prep / "manifiesto.json", manifest)
print(json.dumps({"resultados_nuevos": new, "teoremas": total, "modulos": modules, "cierres": [],
    "parciales": sorted(initial), "correspondencias": len(changed), "enlaces_nuevos": links,
    "registros_congelados": len(frozen)}, ensure_ascii=False, indent=2))
