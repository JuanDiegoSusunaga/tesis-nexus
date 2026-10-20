"""El paralelismo acotado conserva todos los replays y propaga sus errores."""

import importlib.util
from pathlib import Path
import sys
import threading
import time
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


if __name__ == "__main__":
    unittest.main()
