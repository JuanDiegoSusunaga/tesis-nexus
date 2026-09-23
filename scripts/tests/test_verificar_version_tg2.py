"""Pruebas de detección de alteraciones en el manifiesto de la edición."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from verificar_version_tg2 import verificar


class VerificacionVersion(unittest.TestCase):
    def setUp(self):
        self.temporal = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporal.cleanup)
        self.raiz = Path(self.temporal.name)
        self.codigo = self.raiz / 'nexus'
        self.codigo.mkdir()
        for carpeta in [self.raiz, self.codigo]:
            self.git(carpeta, 'init', '-q')
        self.git(self.codigo, '-c', 'user.name=Prueba TG2', '-c', 'user.email=prueba@example.invalid',
                 'commit', '--allow-empty', '-qm', 'Base de prueba')
        self.archivo = self.raiz / 'Documentos/01-Manuscrito/documento.md'
        self.archivo.parent.mkdir(parents=True)
        self.archivo.write_bytes(b'contenido\r\n')
        self.manifiesto = self.raiz / 'version.json'
        self.datos = {'esquema': 1, 'edicion': 'prueba', 'codigo': {
            'directorio': 'nexus', 'commit': self.git(self.codigo, 'rev-parse', 'HEAD')},
            'archivos': [{'archivo': 'Documentos/01-Manuscrito/documento.md', 'bytes': 11,
                          'sha256': hashlib.sha256(self.archivo.read_bytes()).hexdigest()}]}
        self.guardar()

    def git(self, carpeta, *argumentos):
        return subprocess.check_output(['git', '-C', str(carpeta), *argumentos],
                                       text=True, stderr=subprocess.PIPE).strip()

    def guardar(self):
        self.manifiesto.write_text(json.dumps(self.datos), encoding='utf-8')

    def test_edicion_integra(self):
        self.assertTrue(verificar(self.raiz, self.manifiesto)['correcto'])

    def test_alteracion_de_bytes(self):
        self.archivo.write_bytes(b'contenido\n')
        self.assertIn('Contenido diferente:', verificar(self.raiz, self.manifiesto)['errores'][0])

    def test_archivo_faltante(self):
        self.archivo.unlink()
        self.assertIn('Falta:', verificar(self.raiz, self.manifiesto)['errores'][0])

    def test_archivo_adicional(self):
        self.archivo.with_name('nuevo.md').write_text('nuevo', encoding='utf-8')
        self.assertIn('Sin registrar', verificar(self.raiz, self.manifiesto)['errores'][0])

    def test_temporales_de_word_no_forman_parte_de_la_edicion(self):
        for extension in ['.docx', '.docm', '.doc', '.dotx', '.dotm']:
            self.archivo.with_name('~$cumento'+extension).write_bytes(b'propietario temporal')
        self.assertTrue(verificar(self.raiz, self.manifiesto)['correcto'])

    def test_prefijo_temporal_no_oculta_otros_archivos(self):
        self.archivo.with_name('~$datos.csv').write_text('datos', encoding='utf-8')
        self.assertIn('Sin registrar', verificar(self.raiz, self.manifiesto)['errores'][0])

    def test_ruta_exterior(self):
        self.datos['archivos'][0]['archivo'] = '../fuera.md'
        self.guardar()
        with self.assertRaises(ValueError):
            verificar(self.raiz, self.manifiesto)

    def test_ruta_duplicada(self):
        self.datos['archivos'].append(self.datos['archivos'][0].copy())
        self.guardar()
        with self.assertRaises(ValueError):
            verificar(self.raiz, self.manifiesto)

    def test_commit_distinto(self):
        self.datos['codigo']['commit'] = '0' * 40
        self.guardar()
        self.assertIn('El commit de código difiere', verificar(self.raiz, self.manifiesto)['errores'][0])

    def test_codigo_con_archivo_nuevo(self):
        (self.codigo / 'nuevo.rs').write_text('// Ejemplo de cambio local.', encoding='utf-8')
        self.assertIn('El código tiene cambios', verificar(self.raiz, self.manifiesto)['errores'][0])


if __name__ == '__main__':
    unittest.main()
