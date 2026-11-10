# Artículo Científico IEEE (Inglés y Español) — Formalización en Lean 4 y Endurecimiento en Rust del Verificador AIR/FRI (NEXUS TG2)

Esta carpeta contiene el código fuente en LaTeX (`\documentclass[conference]{IEEEtran}`) y los archivos PDF compilados (6 páginas cada uno) del artículo científico derivado del **Trabajo de Grado 2 (NEXUS)**:

- **Versión en inglés:**
  - Fuente LaTeX: `main.tex`
  - PDF compilado: `main.pdf` (*"Mechanized Soundness of a Byte-Level Linked AIR/FRI Verifier in the Finite Classical ROM: From Lean 4 Proofs to a Hardened Rust Implementation"*)
- **Versión en español:**
  - Fuente LaTeX: `main-es.tex`
  - PDF compilado: `main-es.pdf` (*"Solidez Mecanizada de un Verificador AIR/FRI Vinculado a Nivel de Bytes en el ROM Clásico Finito: De las Pruebas en Lean 4 a una Implementación Endurecida en Rust"*)

## Estándares Editoriales IEEE Aplicados

1. **Resumen (*Abstract*) de ~160 palabras:** Un único párrafo autodefinido conforme al *IEEE Editorial Style Manual* (rango recomendado de 150 a 200 palabras), evitando muros de texto en la primera columna y permitiendo que la Sección I inicie en la mitad inferior de la columna izquierda.
2. **Párrafos cortos y respirables en doble columna:** División modular de todas las secciones (incluyendo la separación entre *Trabajo Relacionado* y *Conclusión* en la Sección VI) e interlineado controlado en listas (`\itemsep`).
3. **Ecuaciones y referencias cruzadas IEEE (`(1)` a `(14)`):**
   - Cada fórmula se presenta en su propio entorno `\begin{equation} ... \end{equation}`, centrada en su columna y numerada consecutivamente a la derecha de `(1)` a `(14)`.
   - Puntuación gramatical al final de cada ecuación (`,` o `.`) como parte de la oración.
   - Referencias cruzadas con `\eqref{...}` usando únicamente `(1)` en medio de la frase y `Equation (12)` / `La ecuación (12)` al inicio de oración.

## Compilación a PDF (MiKTeX / TeX Live)

```powershell
pdflatex -interaction=nonstopmode -halt-on-error main.tex
pdflatex -interaction=nonstopmode -halt-on-error main.tex

pdflatex -interaction=nonstopmode -halt-on-error main-es.tex
pdflatex -interaction=nonstopmode -halt-on-error main-es.tex
```
