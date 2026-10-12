"""Recalcula estadísticas conservadas sin ejecutar ni sobrescribir benchmarks."""
from pathlib import Path
import csv
import hashlib
import json
import math
import statistics
import tomllib
from datetime import datetime, timezone, timedelta

ROOT = Path(__file__).resolve().parents[5]
BASE = ROOT / "Documentos/06-Evidencia-TG2/2026-09-22"
OUT = Path(__file__).resolve().parent

def leer(p):
    return json.loads(p.read_text(encoding="utf-8-sig"))

def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def relativo(p):
    return p.relative_to(ROOT).as_posix()

checks = []
def comprobar(nombre, estado, detalle=None):
    checks.append({"nombre": nombre, "pasa": bool(estado), "detalle": detalle})

inventario = leer(BASE / "inventario.json")
for row in inventario["archivos"]:
    p = BASE / row["archivo"]
    comprobar("Inventario recuperado: " + row["archivo"], p.exists() and sha(p) == row["sha256"])

series = []
for carpeta, meta in [("R4-validacion", "mediciones.json"), ("R4-complemento", "ejecucion.json")]:
    directory = BASE / carpeta
    j = leer(directory / meta)
    for source in j["fuentes"]:
        p = directory / "fuentes" / source["archivo"]
        comprobar(carpeta + ": fuente " + source["archivo"], p.exists() and sha(p) == source["sha256"])
    summary = leer(directory / ("resumen-mediciones.json" if carpeta == "R4-validacion" else "resumen.json"))
    for row in summary["criterion"]:
        p = directory / row["origen"]
        estimates = leer(p)
        sample = leer(p.with_name("sample.json"))
        median = statistics.median(t / n for t, n in zip(sample["times"], sample["iters"]))
        expected = estimates["median"]["point_estimate"]
        comprobar(carpeta + ": mediana " + row["caso"], math.isclose(median, expected, rel_tol=1e-12))
        comprobar(carpeta + ": resumen " + row["caso"], sha(p) == row["sha256"] and math.isclose(expected / 1000, row["mediana_us"], rel_tol=1e-12) and len(sample["times"]) == row["n"])
        ci = estimates["median"]["confidence_interval"]
        comprobar(carpeta + ": IC " + row["caso"], ci["confidence_level"] == .95 and math.isclose(ci["lower_bound"] / 1000, row["inferior_us"], rel_tol=1e-12) and math.isclose(ci["upper_bound"] / 1000, row["superior_us"], rel_tol=1e-12))
    series.append({"serie": carpeta, "inicio": j["inicio"], "fin": j["fin"], "git_head": j["git_head"], "git_sucio": bool(j["git_estado"]), "casos_criterion": len(summary["criterion"]), "comandos": j["comandos"], "meta_sha256": sha(directory / meta)})

stark = []
with (BASE / "R4-validacion/stark.csv").open(encoding="utf-8-sig", newline="") as f:
    rows = list(csv.DictReader(f))
for steps in sorted({int(r["steps"]) for r in rows}):
    cases = [r for r in rows if int(r["steps"]) == steps]
    prove = [int(r["prove_ns"]) / 1e6 for r in cases]
    verify = [int(r["verify_total_ns"]) / int(r["verify_iterations"]) / 1e6 for r in cases]
    comprobar("STARK repeticiones: " + str(steps), len(cases) == 5 and all(int(r["verify_iterations"]) == 20 for r in cases))
    stark.append({"filas": steps, "repeticiones": len(cases), "prueba_KiB": int(cases[0]["proof_bytes"]) / 1024, "generacion_ms": {"mediana": statistics.median(prove), "min": min(prove), "max": max(prove)}, "verificacion_ms": {"mediana_de_medias": statistics.median(verify), "min": min(verify), "max": max(verify)}})
summary_stark = leer(BASE / "R4-validacion/resumen-mediciones.json")
for actual, recorded in zip(stark, summary_stark["stark"]):
    comprobar("STARK tamaño: " + str(actual["filas"]), actual["filas"] == recorded["filas"] and actual["prueba_KiB"] * 1024 == recorded["prueba_bytes"])
    comprobar("STARK generación: " + str(actual["filas"]), all(math.isclose(actual["generacion_ms"][k], recorded["generacion_ms"][k], rel_tol=1e-12) for k in ["mediana", "min", "max"]))
    comprobar("STARK verificación: " + str(actual["filas"]), all(math.isclose(actual["verificacion_ms"][k1], recorded["verificacion_ms"][k2], rel_tol=1e-12) for k1, k2 in [("mediana_de_medias", "mediana"), ("min", "min"), ("max", "max")]))
comprobar("STARK CSV", sha(BASE / "R4-validacion/stark.csv") == summary_stark["stark_csv_sha256"])

with (BASE / "R4-complemento/throughput.csv").open(encoding="utf-8-sig", newline="") as f:
    rows = list(csv.DictReader(f))
for i, r in enumerate(rows):
    rate = int(r["verifications"]) * 1e9 / int(r["elapsed_ns"])
    comprobar("Throughput cuenta y reloj: " + str(i + 1), int(r["verifications"]) == sum(map(int, r["worker_counts"].split(";"))) and abs(rate - float(r["verifications_per_second"])) < 1e-6)
throughput = []
for workers in sorted({int(r["threads"]) for r in rows}):
    rates = [float(r["verifications_per_second"]) for r in rows if int(r["threads"]) == workers]
    comprobar("Throughput repeticiones: " + str(workers), len(rates) == 5)
    throughput.append({"hilos": workers, "mediana": statistics.median(rates), "min": min(rates), "max": max(rates)})
summary = leer(BASE / "R4-complemento/resumen.json")
for actual, recorded in zip(throughput, summary["throughput"]):
    comprobar("Throughput resumen: " + str(actual["hilos"]), all(math.isclose(actual[k], recorded[k], rel_tol=1e-12) for k in ["mediana", "min", "max"]))
comprobar("Corpus público", sha(BASE / "R4-complemento/corpus-publico.bin") == summary["corpus_sha256"])
comprobar("CSV throughput", sha(BASE / "R4-complemento/throughput.csv") == summary["throughput_csv_sha256"])

lock = tomllib.loads((BASE / "R4-validacion/fuentes/Cargo.lock").read_text(encoding="utf-8"))
versions = {p["name"]: p["version"] for p in lock["package"] if p["name"] in {"criterion", "fips204", "p256", "rsa", "zeroize"}}
cachep = BASE / "criterion/verification/dilithium3/new/estimates.json"
cache = leer(cachep)["median"]
entry = next(r for r in inventario["archivos"] if r["archivo"].replace("\\", "/") == "criterion/verification/dilithium3/new/estimates.json")
historical = {"mediana_recuperada_us": cache["point_estimate"] / 1000, "H2_publicada_us": 77.6, "diferencia_us": cache["point_estimate"] / 1000 - 77.6, "diferencia_porcentaje": (cache["point_estimate"] / 1000 / 77.6 - 1) * 100, "mtime_origen_bogota": datetime.fromtimestamp(entry["mtime_origen"], timezone(timedelta(hours=-5))).isoformat(), "mtime_no_es_fecha_autenticada_de_corrida": True, "revision_historica_no_identificada": True}
h2_contraste = []
for operation, values in {"key_generation": [92.5, 142.1, 198.1], "signing": [183.0, 290.0, 343.3], "verification": [48.8, 77.6, 129.2]}.items():
    for level, published in zip([2, 3, 5], values):
        p = BASE / "criterion" / operation / ("dilithium" + str(level)) / "new/estimates.json"
        j = leer(p)["median"]
        h2_contraste.append({"operacion": operation, "nivel": level, "publicada_H2_us": published, "recuperada_us": j["point_estimate"] / 1000, "origen": relativo(p), "sha256": sha(p), "misma_corrida_no_acreditada": True})
residencia = leer(BASE / "R5-residencia/sensibilidad.json")
cacheada = leer(BASE / "R4-validacion/criterion/firma_cacheada/dilithium3/r4/estimates.json")["median"]["point_estimate"] / 1000
efimera = leer(BASE / "R4-validacion/criterion/firma_efimera/dilithium3/r4/estimates.json")["median"]["point_estimate"] / 1000
diferencia_firma = {"cacheada_us": cacheada, "efimera_us": efimera, "diferencia_us": efimera - cacheada, "diferencia_redondeada_us": round(efimera - cacheada, 2), "resta_de_cifras_redondeadas_us": round(round(efimera, 2) - round(cacheada, 2), 2), "no_es_estimacion_pareada": True}
for row in residencia["escenarios"]:
    fraction = row["operaciones_s_supuestas"] * residencia["latencia_us_usada_como_proxy"] / 1e6
    average = 32 + 4032 * fraction
    comprobar("R5 escenario: " + str(row["operaciones_s_supuestas"]), math.isclose(average, row["bytes_protegidos_medios_modelados"], rel_tol=1e-12) and math.isclose(4064 / average, row["razon_cache_reexpansion"], rel_tol=1e-12))

result = {"fecha_revision": "2026-10-12", "naturaleza": "Conciliación de evidencia conservada; ninguna nueva medición", "versiones": versions, "series": series, "historica": historical, "H2_contraste": h2_contraste, "diferencia_firma": diferencia_firma, "stark": stark, "throughput": throughput, "comprobaciones": checks, "total": len(checks), "fallos": sum(not c["pasa"] for c in checks)}
(OUT / "conciliacion.json").write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
print(json.dumps({k: result[k] for k in ["total", "fallos", "versiones", "historica"]}, ensure_ascii=False))
raise SystemExit(bool(result["fallos"]))
