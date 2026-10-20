# Extracción Merkle congelada sobre un registro de consultas

**Fecha:** 16 de octubre de 2026. Se añaden 26 resultados en cuatro módulos:
521 resultados registrados, frente a los 495 de la
[etapa anterior](../Lean-Planes-Explicitos/README.md).
N07 pasa a tener un componente verificado; no se declara cerrado.

- [Validación, axiomas y hashes](validacion.json).
- [Compilación](build.log) y [auditoría de axiomas](axiomas.log).
- [Registro y formato](../../../../formalizacion/Nexus/Merkle/Registro.lean).
- [Extracción y aperturas](../../../../formalizacion/Nexus/Merkle/Extraccion.lean).
- [Etiquetas](../../../../formalizacion/Nexus/Merkle/Etiquetas.lean).
- [Conservación temporal](../../../../formalizacion/Nexus/Merkle/Temporal.lean).
- [Alcance vigente y pendientes](../../../../formalizacion/ALCANCE-MANUSCRITO.md).

Se formaliza el componente determinista del enunciado N07: una apertura
aceptada después coincide con un vector extraído y congelado antes del reto,
bajo las condiciones de registro indicadas. Corresponde parcialmente al bloque
Cap6-Validacion-Formal-174 del inventario y a la extracción de la
[transferencia ROM propuesta](../../../04-Administrativo-TG2/Avances/Transferencia-ROM-2026-09-23/Transferencia-Protocolo-ROM.md).
La probabilidad del evento excepcional de esa transferencia sigue pendiente.

`Formato` contiene las codificaciones de hojas y nodos y una decodificación
inversa para ambas. Los tipos de valores, digests y entradas son generales.
Existe una instancia etiquetada concreta de esa interfaz. No se identifica
todavía con bytes de campo, SHA3 o el código Rust. La interfaz permite entradas
ajenas no decodificables y no supone separación global de todos los roles.

El hash H es una función fija y el registro lista sus entradas consultadas.
`preimagen` busca en él un productor del digest; bajo `SinColisiones` esa
preimagen es única. La ausencia de colisiones solo se exige en el registro,
sin postular inyectividad global de H. Las consultas repetidas pueden usar
la respuesta existente; no crean un nuevo paso de extensión segura.

`extraer` recorre la ruta de la raíz a la hoja. Regiones ausentes o de forma
incorrecta devuelven cero. `vectorExtraido` fija la altura y da un valor para
cada una de sus 2^altura rutas binarias, aun con subárboles incompletos.
`reconstruir` calcula una raíz desde el valor, direcciones y hermanos.
`Acepta` comprueba esa raíz y la altura. Las consultas de la apertura deben
estar en el registro del momento usado por el teorema.

| Resultado | Propiedad |
|---|---|
| `preimagen_de_consulta` | Una consulta registrada se recupera por su digest sin colisiones locales |
| `extraer_apertura_registrada` | El recorrido extraído coincide con el valor de una apertura registrada |
| `aperturas_registradas_vinculadas` | Misma raíz y ruta vinculan el valor bajo ausencia de colisiones |
| `etiquetas_card` | Las etiquetas locales de este extractor son a lo sumo 3·longitud+1 |
| `consulta_segura_nueva` | Evitar las etiquetas implica que la entrada es nueva |
| `extension_segura_sin_colisiones` | La ausencia de colisiones se conserva en las extensiones seguras |
| `vector_congelado_estable` | Todo el vector permanece igual tras esas extensiones |
| `apertura_posterior_coincide_congelada` | Una apertura posterior aceptada y registrada coincide con el valor congelado |

Las etiquetas contienen la raíz examinada, todas las salidas registradas y
los dos hijos de cada nodo decodificado. Cada entrada aporta a lo sumo tres
etiquetas y la raíz una adicional. Una extensión segura añade una consulta
cuyo digest evita las etiquetas existentes. Esa regla preserva las búsquedas
que puede realizar el extractor y, por inducción sobre la ruta, todo el vector.

El lema temporal recibe una secuencia de extensiones seguras y ausencia de
colisiones en el registro inicial. Deduce ausencia de colisiones en el final,
estabilidad del vector y coincidencia con la apertura final. No recibe como
premisa la coincidencia que debe demostrar. Los subárboles ajenos a la ruta
pueden estar incompletos.

La condición de extensión segura es determinista. Faltan el formato canónico
de bytes de Fp2 y nodos, la orientación de índices y profundidades del programa,
el enlace de estas etiquetas con las ventanas del registro real y con Bad_H,
su muestreo perezoso y cota de probabilidad S(49S+B_T)/2^256. La cota local
3·longitud+1 cuenta datos de Merkle y no sustituye la cuenta global del canal.
También faltan el enlace con los oráculos de N06 y la transferencia ROM completa.
QROM AIR/FRI permanece como trabajo futuro. La tesis completa no está verificada.

La auditoría compila el proyecto, comprueba los axiomas de los 521 resultados
y recomprueba secuencialmente 78 módulos con `leanchecker` de Lean 4.35.0,
confiando en los importados. No usa `--fresh` ni un verificador externo.
Solo admite `propext`, `Classical.choice` y `Quot.sound`. Pasan los cinco
controles del analizador de axiomas.

El informe conserva hashes de 118 fuentes y 84 logs. Hay ocho afirmaciones
del catálogo con componentes mecanizados, de doce, sin cierre integral.
El inventario mantiene 272 candidatos en ocho fuentes y ahora 36 bloques con
correspondencia parcial. Se comprueban intactas 109 fuentes protegidas y
889 logs de las diecinueve etapas anteriores. Se conservan los capítulos,
TG1, Rust y la evidencia histórica. Estos conteos no expresan porcentaje de cobertura.

Para repetir desde la raíz y conservar una ejecución nueva:

```powershell
python scripts/verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
