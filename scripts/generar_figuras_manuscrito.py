"""Dibuja las figuras conceptuales a tamaño de impresión; no simula mediciones."""
from pathlib import Path

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch, Polygon

DESTINO = Path(__file__).resolve().parents[1] / 'Documentos/01-Manuscrito/Figuras'
TINTA = '#183348'
FONDO = '#eef3f6'
matplotlib.rcParams.update({'font.family': 'DejaVu Sans', 'font.size': 10,
                            'svg.fonttype': 'path', 'pdf.fonttype': 42})


def lienzo(alto):
    fig = plt.figure(figsize=(6.5, alto))
    ax = fig.add_axes([0, 0, 1, 1])
    ax.set(xlim=(0, 6.5), ylim=(0, alto))
    ax.set_axis_off()
    return fig, ax


def caja(ax, x, y, ancho, alto, texto, color=FONDO, tamano=10):
    ax.add_patch(FancyBboxPatch((x-ancho/2, y-alto/2), ancho, alto,
                 boxstyle='round,pad=0.015,rounding_size=0.06',
                 linewidth=1, edgecolor=TINTA, facecolor=color))
    ax.text(x, y, texto, ha='center', va='center', color=TINTA,
            fontsize=tamano, linespacing=1.35)


def flecha(ax, inicio, fin):
    ax.add_patch(FancyArrowPatch(inicio, fin, arrowstyle='-|>',
                 mutation_scale=11, linewidth=1.2, color=TINTA,
                 shrinkA=3, shrinkB=3))


def guardar(fig, nombre):
    DESTINO.mkdir(parents=True, exist_ok=True)
    for extension in ('svg', 'pdf', 'png'):
        fig.savefig(DESTINO / f'{nombre}.{extension}', dpi=320, facecolor='white')
    plt.close(fig)


def arco():
    fig, ax = lienzo(2.5)
    posiciones = [(1.1, 1.83), (3.25, 1.83), (5.4, 1.83),
                  (5.4, 0.63), (3.25, 0.63), (1.1, 0.63)]
    textos = ['1. Amenaza cuántica\na la autenticación',
              '2. Firmas\npost-cuánticas',
              '3. Sobrecosto\nde datos',
              '4. Arquitectura\nblockchain dual',
              '5. Pruebas de validez\npost-cuánticas',
              '6. Validación:\nseguridad y costo']
    for (x, y), texto in zip(posiciones, textos):
        caja(ax, x, y, 1.95, 0.78, texto)
    flecha(ax, (2.075, 1.83), (2.275, 1.83))
    flecha(ax, (4.225, 1.83), (4.425, 1.83))
    flecha(ax, (5.4, 1.44), (5.4, 1.02))
    flecha(ax, (4.425, .63), (4.225, .63))
    flecha(ax, (2.275, .63), (2.075, .63))
    guardar(fig, 'figura-1-1-arco')


def arquitectura():
    fig, ax = lienzo(5.0)
    caja(ax, .9, 4.52, 1.45, .68, 'Usuario\nfirma ML-DSA')
    ax.text(2.0, 4.52, 'Operación firmada de la aplicación', color=TINTA, va='center')
    caja(ax, 3.25, 3.26, 6.2, 1.58, '', color='white')
    ax.text(.35, 3.78, 'L2 · Capa activa — flujo propuesto', color=TINTA, weight='bold')
    xs = [.9, 2.46, 4.02, 5.58]
    pasos = ['Verificar firma\nML-DSA', 'Ejecutar\noperación',
             'Agrupar\noperaciones', 'Generar\nprueba STARK']
    for x, paso in zip(xs, pasos):
        caja(ax, x, 3.16, 1.37, .72, paso)
    flecha(ax, (.9, 4.18), (.9, 4.05))
    for a, b in zip(xs[:-1], xs[1:]):
        flecha(ax, (a+.685, 3.16), (b-.685, 3.16))
    ax.plot([5.58, 5.58, 1.2], [2.80, 2.08, 2.08], color=TINTA, linewidth=1.2)
    flecha(ax, (1.2, 2.08), (1.2, 1.83))
    ax.text(3.25, 2.23, 'Prueba y compromiso de estado', color=TINTA, ha='center')
    caja(ax, 3.25, 1.04, 6.2, 1.58, '', color='white')
    ax.text(.35, 1.57, 'L1 · Capa de anclaje — flujo propuesto', color=TINTA, weight='bold')
    for x, paso in zip([1.2, 3.25, 5.3],
                       ['Verificar\nprueba', 'Anclar compromiso\nde estado', 'Alcanzar\nfinalidad']):
        caja(ax, x, .93, 1.8, .75, paso)
    flecha(ax, (2.1, .93), (2.35, .93))
    flecha(ax, (4.15, .93), (4.4, .93))
    guardar(fig, 'figura-3-1-arquitectura')


def ciclo():
    fig, ax = lienzo(6.6)
    caja(ax, 2.0, 6.1, 3.5, .68, 'Fuente de muestras\nCaracterización requerida')
    caja(ax, 2.0, 5.12, 2.85, .62, 'Monitoreo de muestras\nRCT y APT')
    flecha(ax, (2, 5.76), (2, 5.43))
    ax.add_patch(Polygon([(2, 4.65), (3.4, 4.12), (2, 3.59), (.6, 4.12)],
                 closed=True, facecolor=FONDO, edgecolor=TINTA, linewidth=1))
    ax.text(2, 4.12, '¿Controles\nsatisfechos?', ha='center', va='center', color=TINTA)
    flecha(ax, (2, 4.81), (2, 4.65))
    caja(ax, 5.13, 4.12, 2.15, 1.05, 'Bloquear derivación\ny firma de operaciones\nRecuperar la fuente\ny obtener muestras', color='#fff1e5')
    flecha(ax, (3.4, 4.12), (4.055, 4.12))
    ax.text(3.69, 4.23, 'No', ha='center', color=TINTA)
    ax.plot([5.13, 5.13, 3.62], [4.66, 5.12, 5.12], color=TINTA, linewidth=1.2)
    flecha(ax, (3.62, 5.12), (3.425, 5.12))
    ax.text(4.8, 5.45, 'Repetir los controles\nantes de habilitar', ha='center', color=TINTA)
    flecha(ax, (2, 3.59), (2, 3.3))
    ax.text(2.14, 3.43, 'Sí', color=TINTA)
    caja(ax, 2.0, 2.97, 3.5, .66, 'KDF → semilla ξ\nSeparación de dominio y época')
    flecha(ax, (2, 2.64), (2, 2.37))
    caja(ax, 2.0, 2.05, 3.5, .64, 'ML-DSA.KeyGen(ξ) → (pk, sk)\nPreparar claves de la época')
    flecha(ax, (2, 1.73), (2, 1.44))
    caja(ax, 3.25, .78, 6.15, 1.29,
         'Rotación por política — gestor R3\n'
         'Derivaciones / antigüedad / recuperación → nueva época\n'
         'Preparar claves, autorizar y verificar el registro\n'
         'Instalar el conjunto y descartar secretos anteriores', color='#f0f5ef')
    guardar(fig, 'figura-5-1-ciclo-claves')


if __name__ == '__main__':
    arco()
    arquitectura()
    ciclo()
    print('Tres figuras generadas en SVG, PDF vectorial y PNG de 320 ppp.')
