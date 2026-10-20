# Gramática explícita y transporte de planes completos

**Fecha:** 16 de octubre de 2026. Se añaden 29 resultados en cuatro módulos:
495 resultados registrados, frente a los 466 de la
[etapa anterior](../Lean-Transcripcion-Explicita/README.md).

- [Validación, axiomas y hashes](validacion.json).
- [Compilación](build.log) y [auditoría de axiomas](axiomas.log).
- [Extensión de retos](../../../../formalizacion/Nexus/N06/ExtensionRetos.lean).
- [Pasos de mensajes](../../../../formalizacion/Nexus/N06/PasosExplicitos.lean).
- [Planes explícitos](../../../../formalizacion/Nexus/N06/PlanesExplicitos.lean).
- [Traducción de planes](../../../../formalizacion/Nexus/N06/TraduccionPlanes.lean).
- [Alcance vigente y pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).

Anexar una respuesta conserva las coordenadas e historias anteriores.
Dos políticas con los mismos mensajes en el origen de un reto producen
los mismos mensajes en su destino. Por tanto el destino explícito canónico
coincide con el de cualquier realización de los datos del origen.

`PasoExplicito` contiene un paso de la gramática `PasoSinReto` y los datos
de su destino. La política canónica del destino debe reproducir los mensajes
ya fijados en el origen. La igualdad de estados se deduce de esa regla;
no se recibe como permiso de transición. Se prueba correspondencia exacta
con los pasos observados y cualquier política compatible puede realizarlo.

`PlanExplicito` guarda un registro de nodos. Cada mensaje usa un origen
guardado y esa gramática; cada reto fresco usa una petición con los mensajes
de su origen guardado. Se añade el destino sin modificar los nodos anteriores.
Restaurar no devuelve presupuesto. La evaluación propia del plan usa medias
uniformes condicionales y coincide con su expansión al árbol genérico.

| Resultado | Propiedad |
|---|---|
| `captura_destino_desde_origen` | Respuesta explícita independiente de la realización elegida para el origen |
| `paso_explicito_iff_observado` | Correspondencia exacta de los pasos de mensajes de ambos modelos |
| `paso_explicito_conserva_estado` | Los mensajes autorizados conservan el estado |
| `reinicios_explicitos_cota` | Cota min(1,B·errorRonda(k,q)) para los planes explícitos |
| `reinicios_explicitos_perfiles` | Cota min(1,B·h_T) para los nueve perfiles |
| `transportar_plan_explicito` / `transportar_plan_observado` | Para cada función terminal se transporta todo el plan conservando su valor |
| `plan_explicito_misma_probabilidad` / `plan_observado_misma_probabilidad` | Cada plan tiene uno del otro modelo con la misma probabilidad de aceptación |

Las traducciones codifican o decodifican el registro completo y mantienen
el mismo presupuesto. La inducción cubre todas las ramas de respuestas,
incluida la muestra común de parejas. No supone independencia de los eventos
excepcionales entre rondas o intentos.

Para T=2^k, 4≤k≤29, q≤4T y un enunciado sin polinomio base A de grado<T
que satisfaga AIR, se demuestra

```text
Pr[algún nodo guardado acepta] ≤ min(1, B·errorRonda(k,q))
errorRonda(k,q) = max(1/p², 4T/p², H(4T,q,1/8)).
```

Para 4≤k≤12 y q=40 se sustituye errorRonda por h_T=H(4T,40,1/8).
B cuenta retos ideales frescos, no consultas SHA3. Los enunciados válidos
conservan el estado uno desde la raíz, como en la etapa anterior.

La correspondencia es entre los dos modelos ideales internos. Los planes
desde vacío solo recorren pasos autorizados; no se afirma que todas las
formas tipadas arbitrarias sean alcanzables ni se realiza una familia
arbitraria de transcripciones sin restricciones de compatibilidad.
El adaptador bibliográfico integral, formatos inválidos, aperturas,
semántica integral de Rust, extracción/vinculación Merkle, sesgo modular,
selector de parejas y Fiat–Shamir en ROM siguen pendientes. Los oráculos
son funciones matemáticas completas. QROM AIR/FRI permanece como trabajo futuro.
La tesis completa no está verificada.

La auditoría compila el proyecto, comprueba los axiomas de los 495 resultados
y recomprueba secuencialmente 74 módulos con `leanchecker` de Lean 4.35.0,
confiando en los módulos importados. No usa `--fresh` ni un verificador externo.
Solo admite `propext`, `Classical.choice` y `Quot.sound`. Pasan los cinco
controles del analizador de axiomas.

El informe conserva hashes de 114 fuentes y 80 logs. El inventario mantiene
272 candidatos en ocho fuentes y 35 bloques con correspondencia parcial.
Se comprueban intactas 105 fuentes protegidas y 809 logs de las dieciocho
etapas anteriores. Los capítulos, TG1, Rust y la evidencia histórica se
conservan. Estos números no expresan un porcentaje de cobertura.

Para repetir desde la raíz y conservar una ejecución nueva:

```powershell
python scripts/verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
