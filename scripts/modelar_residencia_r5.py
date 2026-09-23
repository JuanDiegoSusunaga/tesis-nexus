"""Sensibilidad de residencia de regiones protegidas; no mide memoria física."""
from pathlib import Path
import hashlib
import json
import re
import shutil

RAIZ = Path(__file__).resolve().parents[1]
DESTINO = RAIZ/'Documentos/06-Evidencia-TG2/2026-09-22/R5-residencia'


def log(nombre):
    datos = (DESTINO/nombre).read_bytes()
    return datos.decode('utf-16' if datos.startswith(b'\xff\xfe') else 'utf-8-sig')


def main():
    r4 = RAIZ/'Documentos/06-Evidencia-TG2/2026-09-22/R4-validacion/resumen-mediciones.json'
    resumen = json.loads(r4.read_text(encoding='utf-8'))
    mediana = next(f['mediana_us'] for f in resumen['criterion'] if f['caso'] == 'firma_efimera/dilithium3')
    tau = mediana/1e6
    escenarios = []
    for tasa in [1, 10, 100, 1000, 2000]:
        ocupacion = tasa*tau
        assert 0 <= ocupacion < 1
        promedio = 32 + 4032*ocupacion
        escenarios.append({'operaciones_s_supuestas': tasa, 'fraccion_temporal_supuesta': ocupacion,
                           'bytes_protegidos_medios_modelados': promedio, 'razon_cache_reexpansion': 4064/promedio})
    datos = {'fecha': '2026-09-22', 'metodo': 'Modelo, no medición de residencia ni probabilidad empírica.',
             'latencia_us_usada_como_proxy': mediana, 'origen_sha256': hashlib.sha256(r4.read_bytes()).hexdigest(),
             'supuestos': ['Una copia de semilla de 32 B retenida en ambas políticas.',
                          'Región de clave codificada de 4032 B; incluye 96 B públicos.',
                          'Operaciones periódicas, secuenciales, duración fija igual a la mediana R4.',
                          'Sin copias adicionales, residuos, interrupciones ni memoria auxiliar.',
                          'No inferir seguridad: un volcado con la semilla permite reconstruir la clave.'],
             'escenarios': escenarios}
    (DESTINO/'sensibilidad.json').write_text(json.dumps(datos, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    lineas = ['**Tabla 5.2 — Sensibilidad del modelo de regiones protegidas; valores supuestos.**', '',
               '| Operaciones/s | Fracción temporal (%) | W/T (B) | Razón cacheada/reexpansión |', '|---:|---:|---:|---:|']
    for fila in escenarios:
        valores = [fila['operaciones_s_supuestas'], fila['fraccion_temporal_supuesta']*100,
                   fila['bytes_protegidos_medios_modelados'], fila['razon_cache_reexpansion']]
        lineas.append('| '+str(valores[0])+' | '+' | '.join(f'{v:.3f}'.replace('.', ',') for v in valores[1:])+' |')
    (DESTINO/'tabla-sensibilidad.md').write_text('\n'.join(lineas)+'\n', encoding='utf-8')
    resultados = re.findall(r'test result: ok\. (\d+) passed; (\d+) failed', log('cargo-test.log'))
    assert sum(int(x) for x, _ in resultados) == 163 and all(int(y) == 0 for _, y in resultados)
    assert 'objetos_backend,12416,17536,23680' in log('representaciones.log')
    fuentes = []
    rutas = ['nexus/nexus-crypto/tests/tg2_residence.rs', 'nexus/nexus-crypto/benches/residencia_bench.rs',
             'nexus/nexus-crypto/src/dilithium.rs', 'nexus/nexus-crypto/src/keypair.rs',
             'nexus/nexus-crypto/src/entropy.rs', 'nexus/Cargo.lock', 'scripts/modelar_residencia_r5.py']
    for nombre in rutas:
        ruta = RAIZ/nombre
        copia = DESTINO/'fuentes'/nombre
        copia.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(ruta, copia)
        fuentes.append({'archivo': nombre, 'sha256': hashlib.sha256(ruta.read_bytes()).hexdigest()})
    dependencia = Path('C:/Users/juand/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/fips204-0.4.6/src/types.rs')
    shutil.copy2(dependencia, DESTINO/'fips204-0.4.6-types.rs')
    reporte = {'pruebas': 163, 'nuevas_r5': 3, 'perfil': 'desarrollo', 'fuentes': fuentes,
                'backend_types_sha256': hashlib.sha256(dependencia.read_bytes()).hexdigest(),
                'limite': 'Tamaños de tipo y representación comprobados; sin lectura de memoria liberada ni medición de residuos del SO.'}
    for nombre in ['cargo-check.log', 'cargo-test.log', 'cargo-build.log', 'representaciones.log']:
        reporte[nombre] = hashlib.sha256((DESTINO/nombre).read_bytes()).hexdigest()
    (DESTINO/'validacion.json').write_text(json.dumps(reporte, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    print('\n'.join(lineas))


if __name__ == '__main__':
    main()
