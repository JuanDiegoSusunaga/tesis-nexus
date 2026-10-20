module

public import Nexus.Canal.OraculosMerkle
public import Nexus.FRI.OraculoBase
public import Nexus.ROM.FormatoBase
import Mathlib.Tactic

/-!
# Oráculo inicial base y capas posteriores de extensión en N06

El oráculo inicial procede de hojas Fp de nueve bytes y se inyecta en Fp2.
Las capas posteriores usan su formato de diecisiete bytes. Los arreglos
mixtos conservan lectura y aperturas sin identificar los hashes de ambos
formatos. Se reciben los estados y cortes como datos; su construcción
causal para todas las fases del protocolo sigue pendiente.
-/

public section
namespace Nexus.Canal

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM

@[expose] noncomputable def oraculoBaseEnEstado {B : ℕ} (k j : ℕ) (defecto : Digest)
    (s : Estado B) (raiz : Digest) : Fp2 → Fp2 :=
  oraculoBase k j (funcionTabla defecto s.tabla) (s.tabla.map Prod.fst) raiz

@[expose] noncomputable def oraculosMixtos {B : ℕ} (k n : ℕ) (defecto : Digest)
    (base : Estado B) (raizBase : Digest) (estados : ℕ → Estado B) (raices : ℕ → Digest) : OraculosEmitidos n where
  inicial := oraculoBaseEnEstado k 0 defecto base raizBase
  siguientes := fun j => oraculoEnEstado k (j.val + 1) defecto (estados (j.val + 1)) (raices (j.val + 1))

theorem oraculo_base_estado_independiente_defecto {B : ℕ} (k j : ℕ)
    (s : Estado B) (raiz d e : Digest) :
    oraculoBaseEnEstado k j d s raiz = oraculoBaseEnEstado k j e s raiz := by
  apply oraculos_base_iguales k j
  funext i
  exact extraccion_independiente_defecto formatoBase s.tabla s.sinRepetidos d e (rutaIndice (k + 3 - j) i.val) raiz

theorem oraculo_base_antes_primera_exposicion {B : ℕ} {fin : Estado B}
    {estado raiz dAbs dReto : Digest} {tag : Octeto} {tipo : TipoReto}
    (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto) (k j : ℕ) (defecto : Digest) :
    oraculoBaseEnEstado k j defecto c.primera.antes raiz =
      oraculoBaseEnEstado k j defecto c.segunda.antes raiz :=
  oraculos_base_iguales k j _ _ _ _ raiz
    (vectores_indexados_iguales formatoBase _ _ _ _ (k + 3 - j) raiz
      (vector_base_previo_estable (corte_paso c.primera) c.segunda.prefijo defecto raiz
        (raiz_marcada_en_origen c) (k + 3 - j)))

theorem oraculo_base_antes_reto_estable {B : ℕ} {fin : Estado B}
    {estado raiz dAbs dReto : Digest} {tag : Octeto} {tipo : TipoReto}
    (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto) (k j : ℕ) (defecto : Digest) :
    oraculoBaseEnEstado k j defecto c.segunda.antes raiz = oraculoBaseEnEstado k j defecto fin raiz :=
  oraculos_base_iguales k j _ _ _ _ raiz
    (vectores_indexados_iguales formatoBase _ _ _ _ (k + 3 - j) raiz
      (vector_base_previo_estable (corte_paso c.segunda) c.segunda.sufijo defecto raiz
        (marcas_antes_respuesta _ _ (raiz_antes_de_primera_respuesta_reto c)) (k + 3 - j)))

theorem apertura_base_indexada_antes_reto {B : ℕ} {fin : Estado B}
    {estado raiz dAbs dReto : Digest} {tag : Octeto} {tipo : TipoReto}
    (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto)
    (k j : ℕ) (hk : k ≤ 29) (hj : j ≤ k + 3) (defecto : Digest)
    (i : ℕ) (hi : i < 2 ^ (k + 3 - j)) (v : Fp) (hermanos : List Digest)
    (ha : VerificaIndice formatoBase (funcionTabla defecto fin.tabla) raiz (k + 3 - j) i v hermanos)
    (hq : AperturaRegistrada formatoBase (funcionTabla defecto fin.tabla)
      (fin.tabla.map Prod.fst) v (hermanosDesdeRaiz i hermanos)) :
    oraculoBaseEnEstado k j defecto c.segunda.antes raiz (puntoCapa k j i) = algebraMap Fp Fp2 v := by
  have h := apertura_base_previa_respuesta (segunda_tiene_prefijo c) (corte_paso c.segunda) c.segunda.sufijo
    defecto raiz (marcas_antes_respuesta _ _ (raiz_antes_de_primera_respuesta_reto c)) (k + 3 - j) v
    (hermanosDesdeRaiz i hermanos) ((verificacion_equivale_apertura _ _ _ _ _ _ _).mp ha) hq
  unfold oraculoBaseEnEstado
  rw [oraculo_base_en_indice k j hk hj _ _ raiz ⟨i, hi⟩]
  apply congrArg (algebraMap Fp Fp2)
  simpa only [vectorIndexado, ruta_prueba_indexada, ha.1] using h

theorem existe_oraculo_base_antes_primera_exposicion {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (estado : Digest) (tag : Octeto) (raiz : Digest)
    (tipo : TipoReto) (dAbs dReto : Digest)
    (hAbs : buscar fin.tabla (entradaAbsorcion estado tag raiz.val) = some dAbs)
    (hReto : buscar fin.tabla (entradaReto dAbs tipo) = some dReto)
    (k j : ℕ) (hk : k ≤ 29) (hj : j ≤ k + 3) (defecto : Digest) :
    ∃ c : CorteRaizReto fin estado tag raiz tipo dAbs dReto,
      ∀ (i : ℕ), i < 2 ^ (k + 3 - j) → ∀ (v : Fp) (hermanos : List Digest),
        VerificaIndice formatoBase (funcionTabla defecto fin.tabla) raiz (k + 3 - j) i v hermanos →
        AperturaRegistrada formatoBase (funcionTabla defecto fin.tabla)
          (fin.tabla.map Prod.fst) v (hermanosDesdeRaiz i hermanos) →
        oraculoBaseEnEstado k j defecto c.segunda.antes raiz (puntoCapa k j i) = algebraMap Fp Fp2 v := by
  obtain ⟨c⟩ := origenes_raiz_reto r estado tag raiz tipo dAbs dReto hAbs hReto
  exact ⟨c, fun i hi v hermanos ha hq => apertura_base_indexada_antes_reto c k j hk hj defecto i hi v hermanos ha hq⟩

theorem leer_oraculos_mixtos_inicial {B : ℕ} (k n : ℕ) (defecto : Digest)
    (base : Estado B) (raizBase : Digest) (estados : ℕ → Estado B) (raices : ℕ → Digest) :
    leerOraculo (oraculosMixtos k n defecto base raizBase estados raices) 0 =
      oraculoBaseEnEstado k 0 defecto base raizBase :=
  leer_oraculo_inicial _

theorem leer_oraculos_mixtos_siguiente {B : ℕ} (k n : ℕ) (defecto : Digest)
    (base : Estado B) (raizBase : Digest) (estados : ℕ → Estado B) (raices : ℕ → Digest) (j : Fin (n - 1)) :
    leerOraculo (oraculosMixtos k n defecto base raizBase estados raices) (j.val + 1) =
      oraculoEnEstado k (j.val + 1) defecto (estados (j.val + 1)) (raices (j.val + 1)) :=
  leer_oraculo_siguiente _ j

theorem apertura_base_en_oraculos_mixtos {B : ℕ} {fin : Estado B}
    {estado raiz dAbs dReto : Digest} {tag : Octeto} {tipo : TipoReto}
    (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto)
    (k n : ℕ) (hk : k ≤ 29) (defecto : Digest) (estados : ℕ → Estado B) (raices : ℕ → Digest)
    (i : ℕ) (hi : i < 2 ^ (k + 3)) (v : Fp) (hermanos : List Digest)
    (ha : VerificaIndice formatoBase (funcionTabla defecto fin.tabla) raiz (k + 3) i v hermanos)
    (hq : AperturaRegistrada formatoBase (funcionTabla defecto fin.tabla)
      (fin.tabla.map Prod.fst) v (hermanosDesdeRaiz i hermanos)) :
    leerOraculo (oraculosMixtos k n defecto c.segunda.antes raiz estados raices) 0
      (puntoCapa k 0 i) = algebraMap Fp Fp2 v := by
  rw [leer_oraculos_mixtos_inicial]
  exact apertura_base_indexada_antes_reto c k 0 hk (by omega) defecto i hi v hermanos ha hq

theorem apertura_extension_en_oraculos_mixtos {B : ℕ} {fin : Estado B}
    {estado raiz dAbs dReto : Digest} {tag : Octeto} {tipo : TipoReto}
    (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto)
    (k n : ℕ) (hk : k ≤ 29) (j : Fin (n - 1)) (hj : j.val + 1 ≤ k + 3) (defecto : Digest)
    (base : Estado B) (raizBase : Digest) (estados : ℕ → Estado B) (raices : ℕ → Digest)
    (he : estados (j.val + 1) = c.segunda.antes) (hr : raices (j.val + 1) = raiz)
    (i : ℕ) (hi : i < 2 ^ (k + 3 - (j.val + 1))) (v : Fp2) (hermanos : List Digest)
    (ha : VerificaIndice formatoBytes (funcionTabla defecto fin.tabla) raiz (k + 3 - (j.val + 1)) i v hermanos)
    (hq : AperturaRegistrada formatoBytes (funcionTabla defecto fin.tabla)
      (fin.tabla.map Prod.fst) v (hermanosDesdeRaiz i hermanos)) :
    leerOraculo (oraculosMixtos k n defecto base raizBase estados raices) (j.val + 1)
      (puntoCapa k (j.val + 1) i) = v := by
  rw [leer_oraculos_mixtos_siguiente, he, hr]
  exact apertura_indexada_antes_reto c k (j.val + 1) hk hj defecto i hi v hermanos ha hq

theorem oraculos_mixtos_absorcion_reto {B : ℕ} {fin : Estado B}
    {estado raizBase dBase dRetoBase : Digest} {tag : Octeto} {tipo : TipoReto}
    (cb : CorteRaizReto fin estado tag raizBase tipo dBase dRetoBase) (k n : ℕ) (defecto : Digest)
    (estados raices dAbs dReto : ℕ → Digest) (tags : ℕ → Octeto) (tipos : ℕ → TipoReto)
    (c : ∀ j, CorteRaizReto fin (estados j) (tags j) (raices j) (tipos j) (dAbs j) (dReto j)) :
    oraculosMixtos k n defecto cb.primera.antes raizBase (fun j => (c j).primera.antes) raices =
      oraculosMixtos k n defecto cb.segunda.antes raizBase (fun j => (c j).segunda.antes) raices := by
  apply OraculosEmitidos.ext
  · exact oraculo_base_antes_primera_exposicion cb k 0 defecto
  · funext j
    exact oraculo_antes_primera_exposicion (c (j.val + 1)) k (j.val + 1) defecto

end Nexus.Canal
