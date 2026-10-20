# Bytes Merkle y cobertura del extractor por ventanas hash

**Fecha:** 16 de octubre de 2026. Se añaden 37 resultados en cuatro módulos:
558 registrados, frente a los 521 de la
[etapa anterior](../Lean-Merkle-Congelado/README.md). N07 conserva su estado
de componente verificado, con obligaciones de transferencia pendientes.

- [Validación, axiomas y hashes](validacion.json).
- [Compilación](build.log) y [auditoría de axiomas](axiomas.log).
- [Conversión LE](../../../../formalizacion/Nexus/Bytes/LittleEndian.lean).
- [Codificación Merkle](../../../../formalizacion/Nexus/Merkle/Codificacion.lean).
- [Ventanas](../../../../formalizacion/Nexus/Merkle/Ventanas.lean).
- [Marcas globales](../../../../formalizacion/Nexus/Merkle/MarcasGlobales.lean).
- [Alcance vigente](../../../../formalizacion/ALCANCE-MANUSCRITO.md).

El formato abstracto anterior se instancia con octetos Fin 256 y digests de
32 octetos. La codificación LE de longitud fija usa cocientes y residuos en
base 256. Se prueban su longitud, rango, recuperación de enteros dentro del
rango, recuperación de todos los bytes e inyectividad.

Un Fp2 se serializa como sus dos coordenadas canónicas, ocho bytes LE cada
una. El lector exige longitud 16 y coordenadas menores que p. Una hoja añade
el prefijo 00 y mide 17 bytes; un nodo usa 01 y dos digests, y mide 65 bytes.
Se prueban la decodificación inversa y la reconstrucción exacta de cualquier
mensaje admitido. Los digests tienen cardinal 2^256.

Estas fórmulas corresponden a la codificación descrita en las fuentes
preservadas de [field.rs](../../2026-09-23/R4-Merkle-FS/fuentes/nexus/nexus-zk/src/stark/field.rs)
y [merkle.rs](../../2026-09-23/R4-Merkle-FS/fuentes/nexus/nexus-zk/src/stark/merkle.rs).
El informe añade el hash de esta última fuente. La equivalencia de la semántica
de enteros de máquina, invariantes y programa completo permanece pendiente;
no se ejecuta ni modifica Rust en esta etapa.

| Resultado | Propiedad |
|---|---|
| `leer_le_codificar` / `codificar_le_leer` | Identidades inversas de enteros y bytes |
| `leer_bytes_fp2` / `bytes_de_fp2_leido` | Recuperación canónica de valores y listas de bytes |
| `decodificar_hoja` / `decodificar_nodo` | Instancia concreta del formato abstracto |
| `nodo_decodificado_canonico` | Cualquier nodo admitido tiene exactamente la forma codificada |
| `ventanas_card` | A lo sumo 48 ventanas por entrada |
| `hijos_decodificados_en_ventanas` | Los dos hijos del nodo están cubiertos por las ventanas |
| `raiz_absorbida_en_ventanas` | La raíz está en offset 41 de su absorción de 73 bytes |
| `etiquetas_bytes_cubiertas` | Las marcas globales cubren las etiquetas del extractor concreto |
| `apertura_raiz_absorbida` | Una apertura posterior coincide con el vector congelado de una raíz absorbida antes |
| `probabilidad_acierto_nuevo` | Riesgo de un acierto uniforme nuevo ≤(49S+B)/2^256 |

Se incluyen todas las ventanas contiguas de 32 bytes de entradas de hasta
79 bytes. Las largas no aportan ventanas, pero su digest sí queda marcado.
Los hijos de cada nodo admitido aparecen en offsets 1 y 33. La absorción de
raíz tiene la forma estado || etiqueta || longitud u64 LE || digest. Su
digest está cubierto en offset 41. No se presupone separación global de roles;
una cadena puede tener además una interpretación del canal.

Con un conjunto adicional R de digests marcados, las marcas del registro son
como máximo 49·longitud+|R|. Antes de responder se añaden también las ventanas
de la entrada actual. Si el registro tiene menos de S consultas, quedan como
máximo 49S+|R| etiquetas previas. Los valores repetidos reducen el cardinal.

Se prueba que esas marcas contienen las etiquetas del extractor Merkle. Una
secuencia que evita aciertos contra ellas es una extensión segura del modelo
anterior y conserva el vector. Si una absorción de raíz ya está registrada
antes de congelar, la raíz está marcada. Bajo ausencia inicial de colisiones,
toda apertura posterior aceptada y registrada coincide con su valor congelado.

Para una respuesta uniforme nueva, con marcas fijadas antes de responder,
la media exacta del indicador de acierto se acota por (49S+|R|)/2^256.
La conclusión se refiere a esa respuesta nueva. La ejecución completa con
memoria, el tratamiento de repeticiones y la unión adaptativa hasta el primer
acierto todavía deben construirse para obtener S(49S+B_T)/2^256. Tampoco se
demuestran aún la gramática completa del canal, los índices y profundidades
de Rust, el enlace con los oráculos de N06 o la transferencia ROM integral.
QROM AIR/FRI sigue como trabajo futuro. La tesis completa no está verificada.

La auditoría compila el proyecto, comprueba los axiomas de los 558 resultados
y recomprueba secuencialmente 82 módulos con `leanchecker` de Lean 4.35.0,
confiando en los importados. No usa `--fresh` ni un verificador externo.
Solo admite `propext`, `Classical.choice` y `Quot.sound`. Pasan los cinco
controles del analizador de axiomas.

Se conservan hashes de 123 fuentes y 88 logs. Ocho de doce afirmaciones
tienen componentes mecanizados. El inventario sigue con 272 candidatos en
ocho fuentes y 36 bloques con correspondencia parcial. Se comprueban intactas
113 fuentes protegidas y 973 logs de las veinte etapas anteriores.
Se conservan capítulos, TG1, Rust y evidencia histórica. Los conteos no son
un porcentaje de cobertura.

Para repetir desde la raíz conservando otra ejecución:

```powershell
python scripts/verificar_formalizacion.py
python -m unittest discover -s scripts/tests -p test_verificar_formalizacion.py
```

No sustituir esta evidencia por la de una ejecución posterior.
