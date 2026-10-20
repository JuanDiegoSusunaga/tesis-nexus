"""Comprueba trazabilidad de la revisión manual; no decide su corrección matemática."""

from __future__ import annotations

import argparse
from collections import Counter
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
REVIEW = Path('formalizacion/revision-manuscrito.json')
CLASSES = {
    'resumen', 'limite', 'dependencia_bibliografica', 'hipotesis', 'modelo_condicional',
    'calculo', 'objetivo_estructura', 'definicion', 'referencia_documental', 'medicion',
    'implementacion', 'dato_parametro', 'estado_implementacion', 'antecedente',
    'resultado_propio', 'resultado_propuesto', 'trabajo_futuro', 'alcance_metodologico',
    'rotulo', 'metodologia', 'resultado_experimental',
}
STATES = {'pendiente', 'parcial', 'dependencia_bibliografica', 'respaldo_documental', 'trabajo_futuro'}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def within(root: Path, relative: str) -> Path:
    """Impide que una referencia de la revisión salga del repositorio."""
    path = (root / relative).resolve()
    if not path.is_relative_to(root.resolve()):
        raise ValueError(f'Referencia fuera del repositorio: {relative}')
    return path


def check_text(root: Path, source: dict) -> None:
    text = source['texto']
    if hashlib.sha256(text.encode('utf-8')).hexdigest() != source['sha256_texto_utf8']:
        raise ValueError(f"Hash de texto incorrecto: {source.get('id', source.get('candidato'))}")
    lines = within(root, source['archivo']).read_text(encoding='utf-8').splitlines()
    start = source['linea'] - 1
    if start < 0 or '\n'.join(lines[start:start + len(text.splitlines())]) != text:
        raise ValueError(f"Texto o línea no coincide con la fuente: {source.get('id')}")


def validate(review: dict, inventory: dict, root: Path = ROOT) -> dict:
    """Rechaza omisiones, cierres no permitidos y enlaces inexistentes."""
    if (review['tipo'] != 'primera_clasificacion_manual'
            or review['tesis_completa_verificada'] is not False
            or review['cierre_matematico_completo'] is not False
            or review['barrido_exhaustivo_demostrado'] is not False
            or review['revision_independiente'] != 'pendiente'):
        raise ValueError('La clasificación no puede declarar cierre matemático, exhaustividad ni dictamen.')
    if review['fuentes'] != inventory['fuentes']:
        raise ValueError('Las fuentes revisadas no coinciden con el inventario base.')
    for source in review['fuentes']:
        if sha256(within(root, source['archivo'])) != source['sha256']:
            raise ValueError(f"Fuente modificada: {source['archivo']}")

    candidates = {x['id']: x for x in inventory['candidatos']}
    if len(candidates) != len(inventory['candidatos']):
        raise ValueError('Identificadores duplicados en el inventario.')
    ids = [x['candidato'] for x in review['bloques']]
    if len(ids) != len(set(ids)) or set(ids) != set(candidates):
        raise ValueError('Debe existir una revisión exacta de cada candidato, sin duplicados ni omisiones.')

    obligations = {x['id']: x for x in review['obligaciones']}
    if len(obligations) != len(review['obligaciones']):
        raise ValueError('Obligaciones duplicadas.')
    for item in obligations.values():
        if (item['estado'] not in STATES or item['prioridad'] not in {1, 2, 3, 4}
                or not item['titulo'].strip() or not item['criterio_cierre']
                or any(not text.strip() for text in item['criterio_cierre'])):
            raise ValueError(f"Obligación o criterio de cierre incorrecto: {item['id']}")

    used, links = set(), 0
    extra_ids = [x['id'] for x in review['suplementos']]
    if len(extra_ids) != len(set(extra_ids)) or set(extra_ids) & set(candidates):
        raise ValueError('Identificadores de suplementos repetidos.')
    for row in review['bloques'] + review['suplementos']:
        identifier = row.get('candidato', row.get('id'))
        if ('estado_lean' in row or not row['clases'] or not set(row['clases']) <= CLASSES
                or not row['nota_revision'].strip()):
            raise ValueError(f'Clasificación no admitida: {identifier}')
        if len(row['obligaciones']) != len(set(row['obligaciones'])) or not set(row['obligaciones']) <= set(obligations):
            raise ValueError(f'Obligación desconocida o repetida: {identifier}')
        if not row['obligaciones'] and not set(row['clases']) <= {
                'resumen', 'objetivo_estructura', 'alcance_metodologico', 'rotulo'}:
            raise ValueError(f'Bloque con contenido y sin obligación registrada: {identifier}')
        used.update(row['obligaciones'])
        if 'candidato' in row:
            item = candidates[identifier]
            check_text(root, item)
            if row['sha256_texto_utf8'] != item['sha256_texto_utf8']:
                raise ValueError(f'Revisión de un texto distinto al candidato: {identifier}')
            for old in item['lean']:
                if old not in row['lean']:
                    raise ValueError(f'Enlace previo omitido o alterado: {identifier}')
        else:
            check_text(root, row)
            if row['archivo'] not in {x['archivo'] for x in review['fuentes']}:
                raise ValueError(f'Suplemento fuera de las fuentes revisadas: {identifier}')
            if any(x['texto'] == row['texto'] for x in inventory['candidatos']):
                raise ValueError(f'Suplemento que duplica un candidato: {identifier}')
        for link in row['lean']:
            path = within(root, link['archivo'])
            if not link['archivo'].startswith('formalizacion/Nexus/') or path.suffix != '.lean':
                raise ValueError(f'Enlace Lean fuera de los módulos: {identifier}')
            source = path.read_text(encoding='utf-8')
            names = set(re.findall(r'\b(?:def|theorem|abbrev|structure|inductive)\s+(\w+)', source))
            if (not link['declaraciones'] or not set(link['declaraciones']) <= names
                    or not link['alcance'].strip()):
                raise ValueError(f'Declaración Lean o alcance incorrecto: {identifier}')
            links += 1
    if used != set(obligations):
        raise ValueError(f'Obligaciones sin fuente: {sorted(set(obligations) - used)}')
    known = set(candidates) | set(extra_ids)
    if not set(review['prioridades_actuales']) <= set(obligations):
        raise ValueError('Prioridad sin obligación identificada.')
    for issue in review['hallazgos_editoriales']:
        if not set(issue.get('candidatos', [])) <= known or not issue['hallazgo'] or not issue['accion']:
            raise ValueError(f"Hallazgo sin referencia o acción: {issue['id']}")

    chapters = []
    for source in review['fuentes']:
        source_ids = {x['id'] for x in candidates.values() if x['archivo'] == source['archivo']}
        source_rows = [x for x in review['bloques'] if x['candidato'] in source_ids]
        chapters.append({'archivo': source['archivo'], 'candidatos_clasificados': len(source_rows),
                         'bloques_con_enlace_lean_parcial': sum(bool(x['lean']) for x in source_rows),
                         'suplementos': sum(x['archivo'] == source['archivo'] for x in review['suplementos'])})
    return {'bloques_clasificados': len(ids), 'suplementos_identificados': len(extra_ids),
            'grupos_obligaciones': len(obligations), 'enlaces_lean_con_alcance': links,
            'bloques_con_enlace_lean_parcial': sum(bool(x['lean']) for x in review['bloques']),
            'estados_obligaciones': dict(Counter(x['estado'] for x in obligations.values())),
            'clases': dict(Counter(c for x in review['bloques'] for c in x['clases'])),
            'capitulos': chapters, 'hallazgos_editoriales': len(review['hallazgos_editoriales'])}


def verify(root: Path = ROOT) -> dict:
    review = json.loads((root / REVIEW).read_text(encoding='utf-8'))
    for key in ('inventario_base', 'auditoria_lean_base'):
        ref = review[key]
        if sha256(within(root, ref['archivo'])) != ref['sha256']:
            raise ValueError(f'Referencia base modificada: {key}')
    inventory = json.loads(within(root, review['inventario_base']['archivo']).read_text(encoding='utf-8'))
    audit_path = within(root, review['auditoria_lean_base']['archivo'])
    audit = json.loads(audit_path.read_text(encoding='utf-8'))
    if (audit['correcto'] is not True or audit['tesis_completa_verificada'] is not False
            or audit['teoremas_auditados'] != review['auditoria_lean_base']['teoremas']
            or len(audit['kernel']['modulos']) != review['auditoria_lean_base']['modulos']):
        raise ValueError('La auditoría base no tiene el estado ni los conteos declarados.')
    for name, expected in audit['sha256_fuentes'].items():
        if sha256(within(root, name)) != expected:
            raise ValueError(f'Fuente de la auditoría Lean modificada: {name}')
    log_count, stage_count = 0, 0
    evidence = root / 'Documentos/06-Evidencia-TG2'
    for report_path in sorted(evidence.glob('*/Lean*/validacion.json')):
        report = json.loads(report_path.read_text(encoding='utf-8'))
        for name, expected in report['sha256_logs'].items():
            if sha256(within(report_path.parent, name)) != expected:
                raise ValueError(f'Log histórico modificado: {report_path.parent.name}/{name}')
            log_count += 1
        stage_count += 1
    summary = validate(review, inventory, root)
    return {'esquema': 1, 'fecha_utc': datetime.now(timezone.utc).isoformat(),
            'correcto': True, 'tipo': 'integridad_y_trazabilidad_de_revision_manual',
            'tesis_completa_verificada': False, 'cierre_matematico_completo': False,
            'barrido_exhaustivo_demostrado': False, 'revision_independiente': 'pendiente',
            'recompilacion_lean': False, 'auditoria_lean_reutilizada': review['auditoria_lean_base'],
            'fuentes_de_auditoria_lean_intactas': len(audit['sha256_fuentes']),
            'etapas_lean_preservadas': stage_count, 'logs_lean_intactos': log_count,
            'resumen': summary,
            'limite': 'El comprobador no valida la verdad del juicio semántico ni demuestra los pendientes. La auditoría Lean previa se reutiliza por identidad de sus fuentes y logs; no hay pruebas Lean nuevas.',
            'sha256_revision': {name: sha256(root / name) for name in (
                REVIEW.as_posix(), 'scripts/verificar_revision_manuscrito.py',
                'scripts/tests/test_verificar_revision_manuscrito.py', 'formalizacion/REVISION-MANUSCRITO.md')},
            'sha256_fuentes_manuscrito': {x['archivo']: x['sha256'] for x in review['fuentes']}}


def main() -> int:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--salida', type=Path)
    args = parser.parse_args()
    try:
        report = verify()
        if args.salida:
            with args.salida.open('x', encoding='utf-8') as output:
                json.dump(report, output, ensure_ascii=False, indent=2)
                output.write('\n')
    except (OSError, KeyError, ValueError) as error:
        print(f'Revisión inválida: {error}', file=sys.stderr)
        return 1
    print(json.dumps({key: report[key] for key in ('correcto', 'fuentes_de_auditoria_lean_intactas',
        'etapas_lean_preservadas', 'logs_lean_intactos', 'resumen', 'tesis_completa_verificada')}, ensure_ascii=False, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
