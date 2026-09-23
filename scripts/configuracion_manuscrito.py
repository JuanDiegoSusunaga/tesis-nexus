"""Fecha y carpeta de evidencia de la edición; admite reproducción de una fecha."""
from datetime import date
from pathlib import Path
import os

FECHA = os.environ.get('NEXUS_TG2_FECHA_EVIDENCIA') or date.today().isoformat()
if date.fromisoformat(FECHA).isoformat() != FECHA:
    raise ValueError('NEXUS_TG2_FECHA_EVIDENCIA debe usar el formato AAAA-MM-DD')
EVIDENCIA = Path(__file__).resolve().parents[1] / 'Documentos/06-Evidencia-TG2' / FECHA
