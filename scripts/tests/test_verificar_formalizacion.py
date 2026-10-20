"""Controles de rechazo de auditorías incompletas o con axiomas adicionales."""

import importlib.util
from pathlib import Path
import sys
import unittest

SCRIPTS = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SCRIPTS))
spec = importlib.util.spec_from_file_location("verificar_formalizacion", SCRIPTS / "verificar_formalizacion.py")
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


class AuditTests(unittest.TestCase):
    def test_standard_axioms_and_axiom_free_proof(self):
        output = "'Nexus.a' depends on axioms: [propext, Quot.sound]\n'Nexus.b' does not depend on any axioms\n"
        self.assertEqual(module.parse_axioms(output, {"Nexus.a", "Nexus.b"}),
                         {"Nexus.a": ["Quot.sound", "propext"], "Nexus.b": []})

    def test_rejects_sorry_and_custom_or_native_axioms(self):
        for axiom in ("sorryAx", "MiAxioma", "proof._native"):
            with self.subTest(axiom=axiom), self.assertRaises(ValueError):
                module.parse_axioms(f"'Nexus.a' depends on axioms: [{axiom}]", {"Nexus.a"})

    def test_rejects_missing_theorem(self):
        with self.assertRaises(ValueError):
            module.parse_axioms("", {"Nexus.a"})

    def test_rejects_unregistered_theorem(self):
        with self.assertRaises(ValueError):
            module.parse_axioms("'Nexus.b' does not depend on any axioms", {"Nexus.a"})

    def test_rejects_duplicate_output(self):
        with self.assertRaises(ValueError):
            module.parse_axioms("'Nexus.a' does not depend on any axioms\n" * 2, {"Nexus.a"})


if __name__ == "__main__":
    unittest.main()
