# Alcance de los cierres M28 y M29

M28 cierra las cotas de los cocientes válidos escritas en §6.7.2. La identidad
racional se prueba bajo divisibilidad; no se infiere de una división euclídea
que descarte el resto. La validez AIR sigue siendo una hipótesis o un hecho
que debe derivarse de sus restricciones, no de la mera cota de grado.

M29 añade la cota por masa puntual máxima y el ejemplo exacto de cancelación.
La ley condicional fija el contexto antes del coeficiente y exige su cota de
masa; el corolario de tres retos usa el producto independiente de sus leyes.
No se obtiene uniformidad o frescura del canal de Fiat–Shamir como conclusión.

El ejemplo prueba invalidez de la traza y resto combinado nulo para coeficientes
elegidos algebraicamente. Prueba también una traza honesta alternativa para la
misma salida. Por eso no es aceptación de un enunciado falso, ni una búsqueda
exitosa de esos retos en SHA3, ni un certificado de solidez o conocimiento cero.
El polinomio concreto se formaliza sobre Fp. La correspondencia integral con
los objetos Fp2 y certificados serializados del verificador requiere su puente;
no se atribuye al módulo una equivalencia con esas ejecuciones.

Los dos estados modelo_verificado tienen alcances expresos y teoremas auditados.
Los puentes restantes con Rust/ROM, las reducciones, el origen de mediciones,
el despliegue y el dictamen independiente permanecen en sus propios grupos.

## Especificación del siguiente bloque M32

El [recorrido Rust](../../../../nexus/nexus-zk/src/stark/fri.rs) mantiene capa,
posición, tamaño, desplazamiento, raíz de unidad y valor acarreado. El lema
deberá obtener los invariantes de esos estados por inducción y cubrir cada
rechazo de longitud o desacuerdo, sin recibir la aceptación FRI como premisa.

Para cada capa se enlazarán las dos hojas autenticadas con el oráculo y con
el [plegado de pareja abierta](../../../../formalizacion/Nexus/FRI/OraculoMerkle.lean).
El acarreo identifica ese plegado con el valor de la capa siguiente; la
comparación final lo identifica con la constante terminal. El objetivo es
deducir [Acepta](../../../../formalizacion/Nexus/FRI/Muestreo.lean) para todas las
consultas verificadas, tanto de traza como de composición.

Las hipótesis de registro y ausencia de colisiones deberán seguir visibles.
La construcción causal de esas familias pertenece a M37. Los tamaños de
muestra, la ley del selector y los presupuestos pertenecen a M35/M39/M40:
no se deduce su cardinalidad de un zip ni se declara independencia entre los
dos recorridos por haber probado sus ecuaciones.
