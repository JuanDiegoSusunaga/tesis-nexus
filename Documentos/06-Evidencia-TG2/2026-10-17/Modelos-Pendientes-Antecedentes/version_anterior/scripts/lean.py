"""Prepare and run the project's local Lean/mathlib toolchain on Windows."""

from __future__ import annotations

import hashlib
import os
from pathlib import Path
import shutil
import subprocess
import sys
import urllib.request
import zipfile


ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "formalizacion"
TOOLS = ROOT / ".tools" / "lean"
ELAN = TOOLS / "elan"
ELAN_VERSION = "v4.2.4"
ELAN_ARCHIVE = "elan-x86_64-pc-windows-msvc.zip"
ELAN_SHA256 = "fad2e980a191c15884cc1d80d170ffc5fa84f3774541020145b66d1a644c6111"
CACHE_MODULES = [
    "Mathlib.Probability.ProbabilityMassFunction.Constructions",
    "Mathlib.Data.Int.Interval",
    "Mathlib.Data.Matrix.Mul",
    "Mathlib.Data.Matrix.ColumnRowPartitioned",
    "Mathlib.Order.Filter.AtTopBot.Basic",
    "Mathlib.RingTheory.AdjoinRoot",
    "Mathlib.Data.ZMod.ValMinAbs",
    "Mathlib.Analysis.SpecialFunctions.Sqrt",
    "Mathlib.LinearAlgebra.Lagrange",
    "Mathlib.MeasureTheory.Integral.Bochner.Set",
    "Mathlib.MeasureTheory.Measure.Lebesgue.Basic",
    "Mathlib.Probability.Distributions.Uniform",
    "Mathlib.Probability.Distributions.Geometric",
    "Mathlib.Analysis.Asymptotics.Basic",
    "Mathlib.Analysis.SpecificLimits.Normed",
    "Mathlib.Analysis.SpecialFunctions.Log.Basic",
    "Mathlib.Analysis.SpecialFunctions.Log.Base",
    "Mathlib.Analysis.SpecialFunctions.Log.NegMulLog",
    "Mathlib.Probability.Distributions.Binomial",
    "Mathlib.Basic.Real.Basic",
    "Mathlib.Algebra.Polynomial.Roots",
    "Mathlib.RingTheory.RootsOfUnity.PrimitiveRoots",
    "Mathlib.NumberTheory.LucasPrimality",
    "Mathlib.Algebra.QuadraticAlgebra.Basic",
    "Mathlib.FieldTheory.Finite.Basic",
    "Mathlib.Algebra.Polynomial.SpecificDegree",
    "Mathlib.Analysis.SpecificLimits.Basic",
    "Mathlib.Data.Fin.VecNotation",
    "Mathlib.Data.Rat.Cast.Order",
    "Mathlib.Data.Finset.Powerset",
    "Mathlib.Tactic",
]


def environment() -> dict[str, str]:
    env = os.environ.copy()
    env["ELAN_HOME"] = str(ELAN)
    env["MATHLIB_CACHE_DIR"] = str(TOOLS / "cache")
    env["MATHLIB_NO_CACHE_ON_UPDATE"] = "1"
    env["PATH"] = str(ELAN / "bin") + os.pathsep + env.get("PATH", "")
    return env


def run(*args: str, cwd: Path = PROJECT) -> None:
    # Console helpers stay hidden, including when launched from a GUI editor.
    command = [str(arg) for arg in args]
    with subprocess.Popen(
        command,
        cwd=cwd,
        env=environment(),
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        encoding="utf-8",
        errors="replace",
        creationflags=subprocess.CREATE_NO_WINDOW,
    ) as process:
        assert process.stdout is not None
        for line in process.stdout:
            print(line, end="", flush=True)
        returncode = process.wait()
    if returncode:
        raise subprocess.CalledProcessError(returncode, command)


def prepare() -> None:
    TOOLS.mkdir(parents=True, exist_ok=True)
    elan = ELAN / "bin" / "elan.exe"
    if not elan.is_file():
        archive = TOOLS / ELAN_ARCHIVE
        url = (
            "https://github.com/leanprover/elan/releases/download/"
            f"{ELAN_VERSION}/{ELAN_ARCHIVE}"
        )
        print(f"Descargando Elan {ELAN_VERSION}...", flush=True)
        with urllib.request.urlopen(url, timeout=60) as response:
            with archive.open("wb") as output:
                shutil.copyfileobj(response, output)
        if hashlib.sha256(archive.read_bytes()).hexdigest() != ELAN_SHA256:
            raise RuntimeError("El SHA-256 del instalador de Elan no coincide.")
        installer = TOOLS / "elan-init.exe"
        with zipfile.ZipFile(archive) as source:
            with source.open("elan-init.exe") as input_file:
                with installer.open("wb") as output:
                    shutil.copyfileobj(input_file, output)
        run(str(installer), "-y", "--no-modify-path", "--default-toolchain", "none")

    run(str(elan), "--version")
    toolchain = (PROJECT / "lean-toolchain").read_text(encoding="utf-8").strip()
    run(str(elan), "toolchain", "install", toolchain)
    lake = str(ELAN / "bin" / "lake.exe")
    if not (PROJECT / "lake-manifest.json").is_file():
        run(lake, "update")
    run(lake, "exe", "cache", "get", *CACHE_MODULES)
    run(lake, "build")


def main() -> int:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    if os.name != "nt":
        print("Este lanzador local requiere Windows.", file=sys.stderr)
        return 2
    args = sys.argv[1:] or ["build"]
    if args == ["preparar"]:
        prepare()
        return 0
    if args[0] not in {"build", "lake", "lean", "elan"}:
        print(
            "Uso: python scripts/lean.py [preparar|build|lake ...|lean ...|elan ...]",
            file=sys.stderr,
        )
        return 2
    program = "lake" if args[0] in {"build", "lean"} else args.pop(0)
    if args[0:1] == ["lean"]:
        args.insert(0, "env")
    executable = ELAN / "bin" / f"{program}.exe"
    if not executable.is_file():
        print("Ejecuta primero: python scripts/lean.py preparar", file=sys.stderr)
        return 2
    run(str(executable), *args)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except subprocess.CalledProcessError as error:
        raise SystemExit(error.returncode)
    except (OSError, RuntimeError, zipfile.BadZipFile) as error:
        print(f"Error: {error}", file=sys.stderr)
        raise SystemExit(1)
