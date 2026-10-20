"""Localiza candidatos matemáticos del manuscrito para su revisión y trazabilidad Lean."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
SOURCES = ROOT / 'Documentos/01-Manuscrito/Capitulos'
MATH = re.compile(r'\$|\\\(|\\\[|\b(?:lema|teorema|proposición|corolario|probabilidad|entropía|cota|polinomio|complejidad|asintótico|retículo|logaritmo|desigualdad)\b|\d\s*(?:%|bits|bytes|µs|ms|×)', re.I)


def inventory():
    entries, chapters = [], []
    for path in sorted(SOURCES.glob('*.md')):
        if path.name == '_tesis-bibliografia.md':
            continue
        text = path.read_text(encoding='utf-8')
        lines, section, index, count = text.splitlines(), '', 0, 0
        relpath = path.relative_to(ROOT).as_posix()
        while index < len(lines):
            line = lines[index].strip()
            if line.startswith('#'):
                section = line.lstrip('#').strip()
                index += 1
                continue
            if not line or line == '---':
                index += 1
                continue
            start, kind = index, 'parrafo'
            if line.startswith('$$'):
                kind = 'formula_bloque'
                index += 1
                if not (len(line) > 2 and line.endswith('$$')):
                    while index < len(lines):
                        end = lines[index].strip() == '$$'
                        index += 1
                        if end:
                            break
            elif line.startswith('|'):
                kind = 'tabla'
                while index < len(lines) and lines[index].strip().startswith('|'):
                    index += 1
            elif line.startswith('```'):
                kind = 'codigo_o_diagrama'
                index += 1
                while index < len(lines):
                    end = lines[index].strip().startswith('```')
                    index += 1
                    if end:
                        break
            else:
                while index < len(lines) and lines[index].strip():
                    if index > start and lines[index].strip().startswith(('#', '|', '$$', '```')):
                        break
                    index += 1
                if re.search(r'\*\*(?:Definición|Lema|Teorema|Proposición|Corolario|Resultado)', lines[start]):
                    kind = 'enunciado'
            block = '\n'.join(lines[start:index])
            if kind != 'parrafo' or MATH.search(block):
                count += 1
                entries.append({
                    'id': f'{path.stem}-{count:03d}',
                    'archivo': relpath,
                    'linea': start + 1,
                    'seccion': section,
                    'tipo': kind,
                    'texto': block,
                    'sha256_texto_utf8': hashlib.sha256(block.encode('utf-8')).hexdigest(),
                    'revision_semantica': 'pendiente',
                    'lean': [],
                })
        chapters.append({'archivo': relpath, 'sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
                         'candidatos': count})
    return {
        'esquema': 1,
        'alcance_solicitado': 'Toda la matemática del manuscrito, no solo el catálogo N01-N12.',
        'completo_semanticamente': False,
        'metodo': 'Barrido de fórmulas, enunciados, tablas, código y párrafos con indicadores matemáticos; requiere revisión manual para resolver falsos positivos, omisiones y correspondencia exacta con Lean.',
        'fuentes': chapters,
        'candidatos': entries,
    }


def main():
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--salida', type=Path, required=True)
    args = parser.parse_args()
    result = inventory()
    with args.salida.open('x', encoding='utf-8') as output:
        json.dump(result, output, ensure_ascii=False, indent=2)
        output.write('\n')
    print(f"{len(result['candidatos'])} candidatos en {len(result['fuentes'])} fuentes; revisión semántica pendiente.")
    for item in result['fuentes']:
        print(f"{item['archivo']}: {item['candidatos']}")


if __name__ == '__main__':
    main()
