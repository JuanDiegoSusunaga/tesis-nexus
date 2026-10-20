# Cierre de M37 contra sus criterios originales

Estado: modelo verificado en su alcance; juicio semántico del agente, sin
dictamen independiente. Se conserva el texto de ambos criterios:

- Conservar extracción, congelación y órdenes de primeras consultas bajo ausencia de aciertos.
- Obtener los hechos de registro y familias causales para todas las historias del protocolo.

El primer criterio conserva los resultados anteriores de extracción y orden.
Las nuevas familias prueban que cada tabla previa es el prefijo de la primera
consulta y que el oráculo no cambia al elegir otro testigo. Para el segundo,
la aceptación con propuesta de bytes e intercalaciones produce todos los
registros, cortes y familias AIR/FRI. El cierre no recibe la pertenencia de
absorciones, retos o aperturas como premisas externas.

## Resultados registrados

- [Nexus.Verificador.SoporteCompleto.soporte_total](../../../../formalizacion/Nexus/Verificador/SoporteCompleto.lean)
- [Nexus.Verificador.SoporteCompleto.origen_total](../../../../formalizacion/Nexus/Verificador/SoporteCompleto.lean)
- [Nexus.Canal.FamiliasPrograma.depende_del_prefijo](../../../../formalizacion/Nexus/Canal/FamiliasPrograma.lean)
- [Nexus.Canal.FamiliasPrograma.independiente_del_testigo](../../../../formalizacion/Nexus/Canal/FamiliasPrograma.lean)
- [Nexus.Verificador.FamiliasAceptadas.cierre_adversario](../../../../formalizacion/Nexus/Verificador/FamiliasAceptadas.lean)
- [Nexus.Verificador.ExperimentoCausal.cota_fallo](../../../../formalizacion/Nexus/Verificador/ExperimentoCausal.lean)

Alcance exacto: Registro, extracción y congelación del modelo clásico finito TG2: desde una aceptación con propuesta adaptativa de bytes e intercalaciones arbitrarias, se derivan todas las consultas AIR/FRI y se construyen sus familias antes de la primera exposición del reto asociado. Las tablas son prefijos efectivos y la elección de testigos no altera el oráculo. SinBad se conserva explícito y el muestreo del mismo programa acota el fallo de reconstrucción bajo altura<=S.

## Obligaciones que no se cierran

- Programas clásicos finitos y ausencia de excepciones para la congelación; la cota de reconstrucción exige altura(programa)<=S.
- Quedan ley conjunta del selector y transferencia de cotas de solidez, candidatos y eventos integrales, refinamiento universal Rust/Lean y coste real de memoria/CPU.
- No se declara seguridad SHA3 concreta, solidez integral, ZK, QROM ni revisión independiente; R sigue siendo un corte analítico.

La cota de excepción cubre fallo de reconstrucción, no aceptación falsa.
Los seis grupos parciales conservan sus criterios. Cerrar M37 en el modelo
no cierra la tesis, la seguridad global ni las correspondencias con Rust.
