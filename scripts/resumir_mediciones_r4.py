"""Deriva tablas de la serie R4 sin alterar los resultados originales."""
from pathlib import Path
import csv
import hashlib
import json
import statistics

RAIZ = Path(__file__).resolve().parents[1]
DESTINO = RAIZ / 'Documentos/06-Evidencia-TG2/2026-09-22/R4-validacion'


def numero(valor, decimales=2):
    return f'{valor:.{decimales}f}'.replace('.', ',')


def main():
    entradas = []
    for ruta in sorted((DESTINO / 'criterion').glob('**/r4/estimates.json')):
        estimaciones = json.loads(ruta.read_text())
        muestras = json.loads((ruta.parent / 'sample.json').read_text())
        mediana = estimaciones['median']
        intervalo = mediana['confidence_interval']
        assert intervalo['confidence_level'] == 0.95
        entradas.append({'caso': '/'.join(ruta.relative_to(DESTINO / 'criterion').parts[:-2]),
                         'n': len(muestras['times']), 'mediana_us': mediana['point_estimate']/1000,
                         'inferior_us': intervalo['lower_bound']/1000,
                         'superior_us': intervalo['upper_bound']/1000,
                         'origen': str(ruta.relative_to(DESTINO)).replace('\\', '/'),
                         'sha256': hashlib.sha256(ruta.read_bytes()).hexdigest()})
    assert len(entradas) == 17
    filas = list(csv.DictReader((DESTINO / 'stark.csv').open(encoding='utf-8')))
    assert len(filas) == 40
    stark = []
    for steps in sorted({int(fila['steps']) for fila in filas}):
        grupo = [fila for fila in filas if int(fila['steps']) == steps]
        assert {int(f['repetition']) for f in grupo} == set(range(1, 6))
        assert all(int(f['queries']) == 40 and int(f['pow_bits_runtime']) == 20 for f in grupo)
        assert len({int(f['proof_bytes']) for f in grupo}) == 1
        generacion = [int(f['prove_ns'])/1e6 for f in grupo]
        verificacion = [int(f['verify_total_ns'])/int(f['verify_iterations'])/1e6 for f in grupo]
        stark.append({'filas': steps, 'prueba_bytes': int(grupo[0]['proof_bytes']),
                      'generacion_ms': {'mediana': statistics.median(generacion), 'min': min(generacion), 'max': max(generacion)},
                      'verificacion_ms': {'mediana': statistics.median(verificacion), 'min': min(verificacion), 'max': max(verificacion)}})
    resumen = {'fecha': '2026-09-22', 'criterion': entradas, 'stark': stark,
               'bloqueados': ['dilithium_bench', 'throughput'],
               'stark_csv_sha256': hashlib.sha256((DESTINO/'stark.csv').read_bytes()).hexdigest(),
               'nota': 'Criterion: mediana e IC bootstrap 95%. STARK: mediana y rango de cinco repeticiones; verificación media de 20 operaciones por repetición.'}
    (DESTINO / 'resumen-mediciones.json').write_text(json.dumps(resumen, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    tablas = []
    for titulo, condicion in [('Tabla 6.10 — Serie R4: firmas clásicas, tiempos en microsegundos.', lambda c: c.startswith('classical_')),
                               ('Tabla 6.11 — Serie R4: residencia y expansión de claves, tiempos en microsegundos.', lambda c: not c.startswith('classical_'))]:
        tablas.extend([f'**{titulo}**', '', '| Operación / nivel | n | Mediana (µs) | IC 95 % (µs) |', '|---|---:|---:|---:|'])
        for fila in entradas:
            if condicion(fila['caso']):
                nombre = fila['caso'].replace('classical_key_generation', 'Generación').replace('classical_signing', 'Firma').replace('classical_verification', 'Verificación').replace('firma_cacheada', 'Firma cacheada').replace('firma_efimera', 'Firma efímera').replace('keygen_desde_semilla', 'Expansión').replace('ecdsap256', 'ECDSA P-256').replace('rsa2048', 'RSA-2048').replace('rsa3072', 'RSA-3072').replace('/', ' / ')
                tablas.append(f"| {nombre} | {fila['n']} | {numero(fila['mediana_us'])} | {numero(fila['inferior_us'])}–{numero(fila['superior_us'])} |")
        tablas.extend(['', ''])
    tablas.extend(['**Tabla 6.12 — Serie R4: STARK; mediana [mínimo–máximo] de cinco repeticiones.**', '',
                   '| Filas del AIR | Prueba (KiB) | Generación (ms) | Verificación (ms) |', '|---:|---:|---:|---:|'])
    for fila in stark:
        def rango(campo):
            valores = fila[campo]
            return f"{numero(valores['mediana'])} [{numero(valores['min'])}–{numero(valores['max'])}]"
        tablas.append(f"| {fila['filas']} | {numero(fila['prueba_bytes']/1024)} | {rango('generacion_ms')} | {rango('verificacion_ms')} |")
    (DESTINO / 'tablas-mediciones.md').write_text('\n'.join(tablas)+'\n', encoding='utf-8')
    print('\n'.join(tablas))


if __name__ == '__main__':
    main()
