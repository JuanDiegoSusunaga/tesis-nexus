# Reinicios con políticas de oráculos elegidas por rama

**Fecha:** 16 de octubre de 2026. Se registran 371 lemas y teoremas,
5 más que los 366 de la [instancia con política fija](../Lean-Reinicios-Ideales/README.md).
Esta continuación añade en total 26 resultados respecto de los 345 de la
[etapa por rondas](../Lean-Solidez-Rondas/README.md).

- [Informe, axiomas, cobertura y hashes](validacion.json).
- [Auditoría de axiomas](axiomas.log).
- [Compilación](build.log).
- [Alcance vigente y pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).
- [Módulo y cinco resultados](../../../../formalizacion/Nexus/N06/ReiniciosAdaptativos.lean).

La instancia anterior deja que el plan de peticiones dependa de todas las
respuestas, pero mantiene una política de oráculos como parámetro global.
Para permitir también decisiones distintas de oráculos entre ramas,
`NodoAdaptativo` guarda la política junto con el nodo y `PeticionAdaptativa`
elige la política del siguiente reto. La continuación del árbol puede
depender de toda la historia de intentos al escoger esa petición.

Los nodos ya guardados conservan la política con la que se obtuvieron.
Una nueva política no cambia sus marcas ni borra una excepción anterior.
La regla de mensajes puede añadir cualquier nodo con la misma marca que
su origen guardado, incluyendo otra política. Las funciones de oráculo
pueden ser arbitrarias; los tipos de respuesta de cada reto son finitos
y su sorteo es uniforme. La política de la petición se elige antes de
su respuesta nueva.

| Resultado | Propiedad demostrada |
|---|---|
| `acepta_adaptativo_marcado` | Una salida aceptada conserva la marca de aceptación de su propia política |
| `cambio_adaptativo_cota` | El certificado por rondas se instancia con la política de cada petición |
| `reinicios_politicas_adaptativas` | Cota min(1,B·errorRonda(k,q)) desde la raíz cero |
| `reinicios_adaptativos_perfiles` | Cota min(1,B·h_T) en los nueve perfiles con q=40 |
| `reinicios_adaptativos_promedio` | La misma cota al promediar planes con semilla finita uniforme |

Para un enunciado falso fijado y el perfil δt=δc=1/8, 4≤k≤29 y q≤4T,
el certificado de cada política proporciona la cota local común
`errorRonda(k,q)=max(1/p²,4T/p²,H(4T,q,1/8))`. La cota abstracta del
registro restaurable da

```text
probabilidadAdaptativa ≤ min(1, B·errorRonda(k,q)).
```

En los nueve perfiles 4≤k≤12 con q=40 se obtiene

```text
probabilidadAdaptativa ≤ min(1, B·H(4T,40,1/8)).
```

La demostración aplica el certificado a la política de la petición actual;
no recibe la cota global como premisa. El registro requiere que cada origen
esté guardado y mantiene las marcas de ramas anteriores. Desde la raíz cero,
una aceptación se acota por el riesgo de una primera transición excepcional.
Los eventos pueden depender de toda la historia; no se supone su independencia.
También se permite una semilla uniforme finita que elija el plan antes de
los retos frescos.

B limita el total de respuestas nuevas a retos ideales. Restaurar un nodo
anterior no devuelve el presupuesto consumido. Reutilizar una respuesta ya
obtenida consiste en volver a su nodo guardado y no requiere otro sorteo.
Pedir una respuesta fresca desde el mismo origen sí consume una unidad.
Los mensajes conservan la marca y no consumen retos.

La regla de mensajes sigue siendo una abstracción que permite añadir
cualquier nodo con la misma marca. Permanece su adaptador formal a la
transcripción tipada, a la definición bibliográfica y al verificador del
protocolo. El enunciado y el perfil permanecen fijados durante el juego.
B no se identifica con consultas SHA3. La extracción/vinculación Merkle,
el sesgo modular, el selector de parejas y la transferencia Fiat–Shamir en
ROM continúan pendientes. QROM AIR/FRI permanece como trabajo futuro.
La tesis completa no está verificada.

La validación compila el proyecto, audita los 371 resultados y recomprueba
58 módulos secuencialmente con `leanchecker` de Lean 4.35.0, confiando en
los módulos importados. No se usa `--fresh` ni un verificador externo.
Solo se permiten `propext`, `Classical.choice` y `Quot.sound`. Pasan los
cinco controles del analizador de axiomas.

El informe conserva hashes de 98 fuentes y 64 logs. El inventario mantiene
272 candidatos en ocho fuentes y 35 bloques con correspondencia parcial
revisada. Se conservan los capítulos, TG1, Rust y las catorce etapas anteriores:
92 fuentes protegidas y 530 logs históricos se comprueban sin diferencias.
El total de resultados no se interpreta como porcentaje del manuscrito.

Para repetir desde la raíz, conservando otra ejecución:

```powershell
python scripts/verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
