"""Controles negativos de trazabilidad y de atribución de cierre matemático."""

from copy import deepcopy
import importlib.util
import json
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location('verificar_revision_manuscrito', ROOT / 'scripts/verificar_revision_manuscrito.py')
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class RevisionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.review = json.loads((ROOT / 'formalizacion/revision-manuscrito.json').read_text(encoding='utf-8'))
        cls.inventory = json.loads((ROOT / cls.review['inventario_base']['archivo']).read_text(encoding='utf-8'))

    def test_rechaza_omision_y_duplicado_de_bloque(self):
        for duplicate in (False, True):
            altered = deepcopy(self.review)
            altered['bloques'].pop()
            if duplicate:
                altered['bloques'].append(deepcopy(altered['bloques'][0]))
            with self.subTest(duplicate=duplicate), self.assertRaisesRegex(ValueError, 'cada candidato'):
                MODULE.validate(altered, self.inventory)

    def test_rechaza_cierre_sin_demostraciones(self):
        for flag in ('tesis_completa_verificada', 'cierre_matematico_completo', 'barrido_exhaustivo_demostrado'):
            altered = deepcopy(self.review)
            altered[flag] = True
            with self.subTest(flag=flag), self.assertRaisesRegex(ValueError, 'cierre matemático'):
                MODULE.validate(altered, self.inventory)
        altered = deepcopy(self.review)
        altered['obligaciones'][0]['estado'] = 'verificado'
        with self.assertRaisesRegex(ValueError, 'Obligación o criterio'):
            MODULE.validate(altered, self.inventory)

    def test_rechaza_declaracion_lean_inventada(self):
        altered = deepcopy(self.review)
        row = next(x for x in altered['bloques'] if x['lean'])
        row['lean'].append({'archivo': row['lean'][0]['archivo'], 'declaraciones': ['teorema_que_no_existe'], 'alcance': 'Control negativo.'})
        with self.assertRaisesRegex(ValueError, 'Declaración Lean'):
            MODULE.validate(altered, self.inventory)

    def test_rechaza_cambio_de_texto_o_linea(self):
        altered = deepcopy(self.inventory)
        altered['candidatos'][0]['linea'] += 1
        with self.assertRaisesRegex(ValueError, 'Texto o línea'):
            MODULE.validate(self.review, altered)

    def test_rechaza_eliminar_un_enlace_previo(self):
        altered = deepcopy(self.review)
        original = next(x for x in self.inventory['candidatos'] if x['lean'])
        row = next(x for x in altered['bloques'] if x['candidato'] == original['id'])
        row['lean'].clear()
        with self.assertRaisesRegex(ValueError, 'Enlace previo'):
            MODULE.validate(altered, self.inventory)

    def test_rechaza_salida_del_repositorio(self):
        with self.assertRaisesRegex(ValueError, 'fuera del repositorio'):
            MODULE.within(ROOT, '../archivo-ajeno.txt')


if __name__ == '__main__':
    unittest.main()
