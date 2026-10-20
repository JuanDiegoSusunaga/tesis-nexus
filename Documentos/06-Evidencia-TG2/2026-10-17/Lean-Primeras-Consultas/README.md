# Primeras consultas y congelación antes de la exposición del reto

**Fecha:** 17 de octubre de 2026. Se añaden 39 resultados en cuatro módulos:
679 registrados, frente a los 640 de la
[etapa anterior](../Lean-Congelacion-Canal/README.md). N07 mantiene su estado
de componente verificado con obligaciones de transferencia pendientes.

- [Validación, axiomas y hashes](validacion.json).
- [Compilación](build.log) y [auditoría de axiomas](axiomas.log).
- [Novedad de consultas](../../../../formalizacion/Nexus/ROM/Frescura.lean).
- [Orígenes y cortes](../../../../formalizacion/Nexus/ROM/Origen.lean).
- [Orden de primeras consultas](../../../../formalizacion/Nexus/ROM/OrdenConsultas.lean).
- [Primera exposición del reto](../../../../formalizacion/Nexus/Canal/PrimerasConsultas.lean).
- [Alcance vigente](../../../../formalizacion/ALCANCE-MANUSCRITO.md).

La etapa anterior fijaba el vector antes de dos llamadas locales de absorción
y reto. Una llamada repetida podía devolver un valor conocido antes de esa
secuencia. Ahora se recuperan sus instantes originales en el registro completo.

Cada par almacenado procede del estado inicial o de una consulta nueva. Desde
vacío siempre existe un corte con la solicitud original, la tabla anterior,
la ausencia de la entrada y los recorridos anterior y posterior. Las repeticiones
solo prolongan el recorrido. Las búsquedas persisten y todos los prefijos que
terminan antes del corte siguen sin contener la entrada.

| Resultado | Propiedad |
|---|---|
| `entrada_con_respuesta_ausente_despues` | Una entrada que contiene la respuesta nueva como ventana sigue ausente tras almacenarla |
| `origen_desde_vacio` | Recupera el corte de origen de una consulta almacenada |
| `corte_ausente_en_prefijos` | La entrada no estaba consultada en ningún prefijo anterior al corte |
| `corte_posicion` | La posición canónica coincide con la longitud de tabla anterior al origen |
| `orden_estricto_por_ventana` | Una respuesta que aparece en otra entrada fuerza orden estricto de sus primeras consultas |
| `dependencias_bien_fundadas` | El grafo de dependencias por ventanas tiene un rango natural y no admite ciclos |
| `reto_nuevo_tras_respuesta` | El reto que usa una respuesta nueva sin acierto no estaba consultado inmediatamente después |
| `origenes_raiz_reto` | Recupera ambos orígenes en orden para el par registrado de absorción y reto |
| `apertura_antes_primera_consulta_reto` | Vincula una apertura posterior al vector anterior a la primera exposición del reto |
| `existe_congelacion_primera_exposicion` | Un mismo corte sirve para todas las aperturas posteriores aceptadas y registradas |

La respuesta nueva sin acierto evita las ventanas de entradas anteriores y de
su propia entrada. Si aparece en las ventanas de otra entrada registrada, esa
entrada estaba ausente justo después de almacenar la respuesta. Por tanto su
origen está después. El índice de la entrada en la tabla da una posición canónica
independiente de la elección del corte y demuestra el orden estricto.

La relación de dependencia exige que ambas entradas estén registradas y que
la respuesta de una aparezca en las ventanas de la otra. Es irreflexiva,
asimétrica y bien fundada por ese rango natural. Se refiere a las ventanas
definidas para entradas de hasta 79 bytes. Las entradas largas no aportan
ventanas; no se afirma ese orden para cualquier coincidencia de bytes en ellas.

El estado de un reto F/E/I de 33 bytes y del trabajo de 41 está en sus ventanas.
También se cubre una absorción con hasta 38 bytes de datos. Si una respuesta
nueva se usa como estado del reto, su entrada sigue ausente tras almacenarla.
Esto se aplica a los orígenes del registro completo, aunque las llamadas que
se estén revisando ahora sean repeticiones.

Para una absorción de raíz y un reto que usa su respuesta, ambos registrados
desde vacío sin aciertos, se recuperan los dos orígenes en orden. La raíz
está marcada antes de la primera respuesta de absorción y persiste antes de
la primera respuesta del reto. El vector calculado en ambos instantes coincide.
Toda apertura posterior aceptada y registrada respeta ese vector. Un mismo
corte se elige antes de cuantificar sobre todos los valores y caminos de apertura.

Se exigen ambos hechos de consulta en el registro y un recorrido sin aciertos
desde vacío. Falta obtener esas premisas para todas las historias y perfiles
válidos y construir el adaptador causal completo N06. Sus oráculos son funciones
sobre Fp2; el extractor usa rutas binarias. Falta enlazar rutas, índices, dominios
y orden de hermanos. Tampoco se prueban aquí
los presupuestos S=Q+V_T y B_T, distribución de retos de campo, cola de índices,
potencial de nonces o semántica integral de Rust. No se deduce uniformidad al
condicionar a la ausencia de eventos futuros. La cota de aciertos del juego
parametrizado permanece min(1,S(49S+B)/2^256). QROM AIR/FRI sigue como trabajo
futuro. La tesis completa no está verificada.

La auditoría compila el proyecto, comprueba los axiomas de los 679 resultados
y recomprueba secuencialmente 94 módulos con `leanchecker` de Lean 4.35.0,
confiando en los importados. No usa `--fresh` ni un verificador externo.
Solo admite `propext`, `Classical.choice` y `Quot.sound`. Pasan los cinco
controles del analizador de axiomas.

Se conservan hashes de 136 fuentes y 100 logs. Ocho de doce afirmaciones
tienen componentes mecanizados. El inventario mantiene 272 candidatos en
ocho fuentes y 36 bloques con correspondencia parcial. Se comprueban intactas
127 fuentes protegidas y 1.249 logs de las veintitrés etapas anteriores.
Se conservan capítulos, TG1, Rust y evidencia histórica. Los conteos no son
un porcentaje de cobertura.

Para repetir desde la raíz conservando otra ejecución:

```powershell
python scripts/verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
