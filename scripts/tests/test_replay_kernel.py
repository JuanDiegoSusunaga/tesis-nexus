"""El paralelismo acotado conserva todos los replays y propaga sus errores."""

import importlib.util
import hashlib
import json
from pathlib import Path
import sys
import threading
import time
import tempfile
import unittest
from unittest.mock import patch

scripts = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(scripts))
spec = importlib.util.spec_from_file_location("replay_verificador", scripts / "verificar_formalizacion.py")
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


class ReplayTests(unittest.TestCase):
    def test_replays_every_module_once_with_at_most_two_workers(self):
        lock = threading.Lock()
        calls, active, maximum = [], 0, 0

        def fake(command, log):
            nonlocal active, maximum
            with lock:
                calls.append((command, log))
                active += 1
                maximum = max(maximum, active)
            time.sleep(0.01)
            with lock:
                active -= 1
            return "correcto"

        names = tuple("Nexus.Prueba" + str(i) for i in range(7))
        with patch.object(module, "execute", side_effect=fake):
            module.replay_kernel(["python", "lean.py"], names, Path("evidencia"), 2)
        self.assertEqual(sorted(c[-1] for c, _ in calls), sorted(names))
        self.assertEqual(len({str(log) for _, log in calls}), len(names))
        self.assertLessEqual(maximum, 2)
        for command, log in calls:
            self.assertEqual(command[:-1], ["python", "lean.py", "lake", "env", "leanchecker", "--verbose"])
            self.assertEqual(log.name, "kernel-" + command[-1] + ".log")

    def test_failure_is_reported_after_collecting_every_result(self):
        calls = []

        def fake(command, log):
            calls.append(command[-1])
            if command[-1] in ("Nexus.B", "Nexus.C"):
                raise RuntimeError("rechazo " + command[-1])
            return "correcto"

        with patch.object(module, "execute", side_effect=fake):
            with self.assertRaisesRegex(RuntimeError, r"Nexus\.[BC].*Nexus\.[BC]"):
                module.replay_kernel([], ("Nexus.A", "Nexus.B", "Nexus.C", "Nexus.D"), Path("evidencia"), 2)
        self.assertEqual(set(calls), {"Nexus.A", "Nexus.B", "Nexus.C", "Nexus.D"})

    def test_rejects_unbounded_workers_and_duplicate_modules(self):
        for workers, names in [(0, ("A",)), (3, ("A",)), (2, ("A", "A"))]:
            with self.subTest(workers=workers, names=names), self.assertRaises(ValueError):
                module.replay_kernel([], names, Path("evidencia"), workers)

    def test_sequential_mode_keeps_the_original_order(self):
        with patch.object(module, "execute", return_value="correcto") as execute:
            module.replay_kernel([], ("Nexus.C", "Nexus.A"), Path("evidencia"))
        self.assertEqual([call.args[0][-1] for call in execute.call_args_list], ["Nexus.C", "Nexus.A"])

    def test_four_workers_replay_every_module_and_respect_the_limit(self):
        lock = threading.Lock()
        active, maximum, seen = 0, 0, []

        def fake(command, log):
            nonlocal active, maximum
            with lock:
                seen.append(command[-1])
                active += 1
                maximum = max(maximum, active)
            time.sleep(0.01)
            with lock:
                active -= 1

        names = tuple("Nexus.F" + str(i) for i in range(11))
        with patch.object(module, "execute", side_effect=fake):
            module.replay_kernel([], names, Path("evidencia"), 4)
        self.assertCountEqual(seen, names)
        self.assertLessEqual(maximum, 4)

    def test_reuses_only_validated_logs_and_runs_every_other_module(self):
        with tempfile.TemporaryDirectory() as folder:
            destination = Path(folder)
            with patch.object(module, "execute", return_value="correcto") as execute:
                module.replay_kernel([], ("Nexus.A", "Nexus.B"), destination, 4, {"Nexus.A": b"registro conservado"})
            self.assertEqual((destination / "kernel-Nexus.A.log").read_bytes(), b"registro conservado")
            self.assertEqual([call.args[0][-1] for call in execute.call_args_list], ["Nexus.B"])

    def test_cache_rejects_changed_imports(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / "cache.json"
            path.write_text(json.dumps({"esquema": 1, "identidad_kernel": {"modulo": "anterior"}}), encoding="utf-8")
            with patch.object(module, "kernel_identity", return_value={"modulo": "actual"}):
                with self.assertRaisesRegex(ValueError, "importados"):
                    module.load_kernel_cache(path, [])

    def test_cache_rejects_tampered_logs(self):
        with tempfile.TemporaryDirectory() as folder:
            parent = Path(folder)
            log = parent / "registro.log"
            log.write_text('[]\n\nreplaying Nexus.A\n', encoding="utf-8")
            path = parent / "cache.json"
            data = {"esquema": 1, "identidad_kernel": {}, "modulos_confirmados": {
                "Nexus.A": {"archivo": "registro.log", "sha256": hashlib.sha256(log.read_bytes()).hexdigest(),
                    "exito_confirmado_en_salida_del_padre": True}}, "fuentes_del_ejecutor": {}}
            path.write_text(json.dumps(data), encoding="utf-8")
            log.write_text("alterado", encoding="utf-8")
            with patch.object(module, "ROOT", parent), patch.object(module, "kernel_identity", return_value={}):
                with self.assertRaisesRegex(ValueError, "alterado"):
                    module.load_kernel_cache(path, [])


if __name__ == "__main__":
    unittest.main()
