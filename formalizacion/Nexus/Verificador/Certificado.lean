module

public import Nexus.Bytes.Codec
import Mathlib.Tactic

/-!
# Certificado TG2 v1 y lectura de todos sus campos

El orden corresponde a (TransitionStatement, LinkedProof): enunciado, versión,
perfil, raíz, dos compromisos, nonce y consultas. Las cuentas vectoriales y
anchos forman un dominio explícito; los campos se leen canónicamente. El
lector con resto y la envoltura de EOF estricto se distinguen. No se afirma
equivalencia de consumo de memoria con bincode ni con un endpoint desplegado.
-/

public section
namespace Nexus.Verificador

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.Goldilocks.Recorrido
open Nexus.Bytes.Codecs

structure Punto where
  valor : Fp
  hermanos : List Digest

structure Consulta where
  traza : List Punto
  friTraza : List Apertura
  friComposicion : List Apertura

structure Compromiso where
  raices : List Digest
  final : Fp2

structure Enunciado where
  inicio : Fp
  salida : Fp
  pasos : ℕ

structure Prueba where
  version : ℕ
  bits : ℕ
  raiz : Digest
  traza : Compromiso
  composicion : Compromiso
  nonce : ℕ
  consultas : List Consulta

structure Certificado where
  enunciado : Enunciado
  prueba : Prueba

@[expose] def codecPunto : Codec Punto :=
  transportar (par campo (lista digest)) (fun x => ⟨x.1, x.2⟩)
    (fun x => (x.valor, x.hermanos)) (fun _ => rfl)

@[expose] def codecCapa : Codec Apertura :=
  transportar (par extension (par extension (par (lista digest) (lista digest))))
    (fun x => ⟨x.1, x.2.1, x.2.2.1, x.2.2.2⟩)
    (fun x => (x.izquierda, x.derecha, x.pruebaIzquierda, x.pruebaDerecha)) (fun _ => rfl)

@[expose] def codecCompromiso : Codec Compromiso :=
  transportar (par (lista digest) extension) (fun x => ⟨x.1, x.2⟩)
    (fun x => (x.raices, x.final)) (fun _ => rfl)

@[expose] def codecConsulta : Codec Consulta :=
  transportar (par (lista codecPunto) (par (lista codecCapa) (lista codecCapa)))
    (fun x => ⟨x.1, x.2.1, x.2.2⟩)
    (fun x => (x.traza, x.friTraza, x.friComposicion)) (fun _ => rfl)

@[expose] def codecEnunciado : Codec Enunciado :=
  transportar (par campo (par campo (entero 8))) (fun x => ⟨x.1, x.2.1, x.2.2⟩)
    (fun x => (x.inicio, x.salida, x.pasos)) (fun _ => rfl)

@[expose] def codecPrueba : Codec Prueba :=
  transportar (par (entero 2) (par (entero 4) (par digest (par codecCompromiso
    (par codecCompromiso (par (entero 8) (lista codecConsulta)))))))
    (fun x => ⟨x.1, x.2.1, x.2.2.1, x.2.2.2.1, x.2.2.2.2.1, x.2.2.2.2.2.1, x.2.2.2.2.2.2⟩)
    (fun x => (x.version, x.bits, x.raiz, x.traza, x.composicion, x.nonce, x.consultas)) (fun _ => rfl)

@[expose] def codecCertificado : Codec Certificado :=
  transportar (par codecEnunciado codecPrueba) (fun x => ⟨x.1, x.2⟩)
    (fun x => (x.enunciado, x.prueba)) (fun _ => rfl)

theorem lectura_certificado (c : Certificado) (hc : codecCertificado.dominio c) (resto : List Octeto) :
    codecCertificado.leer (codecCertificado.codificar c ++ resto) = some (c, resto) :=
  codecCertificado.ida_vuelta c hc resto

theorem lectura_exacta_certificado (c : Certificado) (hc : codecCertificado.dominio c) :
    Lectura.exacto codecCertificado.leer (codecCertificado.codificar c) = some c :=
  lectura_completa codecCertificado c hc

theorem codificacion_certificado_inyectiva (a b : Certificado)
    (ha : codecCertificado.dominio a) (hb : codecCertificado.dominio b)
    (h : codecCertificado.codificar a = codecCertificado.codificar b) : a = b :=
  codificacion_inyectiva codecCertificado a b ha hb h

theorem sufijo_en_envoltura_estricta (c : Certificado) (hc : codecCertificado.dominio c)
    (resto : List Octeto) (hr : resto ≠ []) :
    Lectura.exacto codecCertificado.leer (codecCertificado.codificar c ++ resto) = none :=
  sufijo_exacto_rechazado codecCertificado c hc resto hr

theorem longitud_enunciado (s : Enunciado) : (codecEnunciado.codificar s).length = 24 := by
  simp [codecEnunciado, transportar, par, campo, entero, codificar_le_longitud]

theorem longitud_punto (p : Punto) : (codecPunto.codificar p).length = 16 + 32 * p.hermanos.length := by
  simp only [codecPunto, transportar, par, campo, lista, digest, List.length_append,
    codificar_le_longitud]
  have h := Nexus.Complejidad.Serializacion.longitud_camino p.hermanos
  change 8 + (Nexus.Complejidad.Serializacion.camino p.hermanos).length = _
  rw [h]
  omega

theorem capa_corresponde_serializacion (d : Apertura) : codecCapa.codificar d =
    Nexus.Complejidad.Serializacion.capa d := rfl

end Nexus.Verificador
