"""Resume la serie complementaria de ML-DSA y verificación multinúcleo."""
from pathlib import Path
import csv
import hashlib
import json
import statistics

RAIZ = Path(__file__).resolve().parents[1]
DESTINO = RAIZ/'Documentos/06-Evidencia-TG2/2026-09-22/R4-complemento'


def numero(valor, digitos=2):
    return f'{valor:.{digitos}f}'.replace('.', ',')


def main():
    entradas = []
    for ruta in sorted((DESTINO/'criterion').glob('**/r4-complemento/estimates.json')):
        mediana = json.loads(ruta.read_text())['median']
        muestras = json.loads((ruta.parent/'sample.json').read_text())
        intervalo = mediana['confidence_interval']
        assert intervalo['confidence_level'] == 0.95
        entradas.append({'caso': '/'.join(ruta.relative_to(DESTINO/'criterion').parts[:-2]),
                         'n': len(muestras['times']), 'mediana_us': mediana['point_estimate']/1000,
                         'inferior_us': intervalo['lower_bound']/1000, 'superior_us': intervalo['upper_bound']/1000,
                         'origen': ruta.relative_to(DESTINO).as_posix(),
                         'sha256': hashlib.sha256(ruta.read_bytes()).hexdigest()})
    assert len(entradas) == 12
    filas = list(csv.DictReader((DESTINO/'throughput.csv').open(encoding='utf-8')))
    assert len(filas) == 40
    grupos = {}
    for fila in filas:
        total = int(fila['verifications'])
        assert total == sum(int(c) for c in fila['worker_counts'].split(';'))
        assert int(fila['elapsed_ns']) >= 1_000_000_000
        assert abs(total*1e9/int(fila['elapsed_ns'])-float(fila['verifications_per_second'])) < 0.00001
        grupos.setdefault(int(fila['threads']), []).append(fila)
    base = statistics.median(float(f['verifications_per_second']) for f in grupos[1])
    throughput = []
    for hilos, grupo in sorted(grupos.items()):
        assert {int(f['repetition']) for f in grupo} == set(range(1, 6))
        valores = [float(f['verifications_per_second']) for f in grupo]
        throughput.append({'hilos': hilos, 'mediana': statistics.median(valores), 'min': min(valores),
                           'max': max(valores), 'razon_1_hilo': statistics.median(valores)/base})
    resumen = {'fecha': '2026-09-22', 'criterion': entradas, 'throughput': throughput,
               'corpus_sha256': hashlib.sha256((DESTINO/'corpus-publico.bin').read_bytes()).hexdigest(),
               'throughput_csv_sha256': hashlib.sha256((DESTINO/'throughput.csv').read_bytes()).hexdigest(),
               'interpretacion': 'Verificaciones aisladas de ML-DSA-65, no transacciones/s de una blockchain; rango de cinco repeticiones, no IC.'}
    (DESTINO/'resumen.json').write_text(json.dumps(resumen, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    tablas = ['**Tabla 6.13 — Complemento R4: ML-DSA; mediana e IC 95 %, microsegundos.**', '',
              '| Operación / nivel | n | Mediana (µs) | IC 95 % (µs) |', '|---|---:|---:|---:|']
    for fila in entradas:
        nombre = fila['caso'].replace('key_generation', 'Generación').replace('sign_and_verify', 'Firma y verificación').replace('signing', 'Firma').replace('verification', 'Verificación').replace('/', ' / ')
        tablas.append(f"| {nombre} | {fila['n']} | {numero(fila['mediana_us'])} | {numero(fila['inferior_us'])}–{numero(fila['superior_us'])} |")
    tablas += ['', '**Tabla 6.14 — Complemento R4: verificaciones/s de ML-DSA-65 con inicio coordinado.**', '',
               '| Hilos | Mediana (verif./s) | Mínimo–máximo | Razón frente a 1 hilo |', '|---:|---:|---:|---:|']
    for fila in throughput:
        tablas.append(f"| {fila['hilos']} | {numero(fila['mediana'], 0)} | {numero(fila['min'], 0)}–{numero(fila['max'], 0)} | {numero(fila['razon_1_hilo'])} |")
    (DESTINO/'tablas.md').write_text('\n'.join(tablas)+'\n', encoding='utf-8')
    print('\n'.join(tablas))


if __name__ == '__main__':
    main()
