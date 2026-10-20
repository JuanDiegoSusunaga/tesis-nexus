module

public import Nexus.Canal.PrimerasConsultas
public import Nexus.FRI.OraculoMerkle
public import Nexus.N06.OraculosEmitidos
import Mathlib.Tactic

/-!
# Oráculos FRI congelados antes de la primera exposición del reto

Se transporta la congelación de rutas al índice numérico y al dominio de
campo. Una familia dada de estados y raíces produce los arreglos explícitos
de N06. Construir esa familia causalmente para todo el protocolo y demostrar
las distribuciones y los presupuestos ROM sigue siendo una obligación aparte.
-/

public section
namespace Nexus.Canal

open Nexus.Bytes Nexus.Merkle Nexus.Goldilocks Nexus.ROM

@[expose] noncomputable def oraculoEnEstado {B : ℕ} (k j : ℕ) (defecto : Digest)
    (s : Estado B) (raiz : Digest) : Fp2 → Fp2 :=
  oraculoMerkle k j (funcionTabla defecto s.tabla) (s.tabla.map Prod.fst) raiz

@[expose] noncomputable def oraculosCongelados {B : ℕ} (k n : ℕ) (defecto : Digest)
    (estados : ℕ → Estado B) (raices : ℕ → Digest) : OraculosEmitidos n :=
  capturarOraculos n (fun j => oraculoEnEstado k j defecto (estados j) (raices j))

theorem oraculo_antes_primera_exposicion {B : ℕ} {fin : Estado B}
    {estado raiz dAbs dReto : Digest} {tag : Octeto} {tipo : TipoReto}
    (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto) (k j : ℕ) (defecto : Digest) :
    oraculoEnEstado k j defecto c.primera.antes raiz =
      oraculoEnEstado k j defecto c.segunda.antes raiz :=
  oraculos_merkle_iguales k j _ _ _ _ raiz
    (vectores_indexados_iguales formatoBytes _ _ _ _ (k + 3 - j) raiz
      (vector_antes_primera_exposicion c defecto (k + 3 - j)))

theorem oraculo_antes_reto_estable {B : ℕ} {fin : Estado B}
    {estado raiz dAbs dReto : Digest} {tag : Octeto} {tipo : TipoReto}
    (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto) (k j : ℕ) (defecto : Digest) :
    oraculoEnEstado k j defecto c.segunda.antes raiz = oraculoEnEstado k j defecto fin raiz :=
  oraculos_merkle_iguales k j _ _ _ _ raiz
    (vectores_indexados_iguales formatoBytes _ _ _ _ (k + 3 - j) raiz
      (vector_previo_estable (corte_paso c.segunda) c.segunda.sufijo defecto raiz
        (marcas_antes_respuesta _ _ (raiz_antes_de_primera_respuesta_reto c)) (k + 3 - j)))

theorem apertura_indexada_antes_reto {B : ℕ} {fin : Estado B}
    {estado raiz dAbs dReto : Digest} {tag : Octeto} {tipo : TipoReto}
    (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto)
    (k j : ℕ) (hk : k ≤ 29) (hj : j ≤ k + 3) (defecto : Digest)
    (i : ℕ) (hi : i < 2 ^ (k + 3 - j)) (v : Fp2) (hermanos : List Digest)
    (ha : VerificaIndice formatoBytes (funcionTabla defecto fin.tabla) raiz (k + 3 - j) i v hermanos)
    (hq : AperturaRegistrada formatoBytes (funcionTabla defecto fin.tabla)
      (fin.tabla.map Prod.fst) v (hermanosDesdeRaiz i hermanos)) :
    oraculoEnEstado k j defecto c.segunda.antes raiz (puntoCapa k j i) = v := by
  have h := apertura_antes_primera_consulta_reto c defecto (k + 3 - j) v (hermanosDesdeRaiz i hermanos)
    ((verificacion_equivale_apertura _ _ _ _ _ _ _).mp ha) hq
  unfold oraculoEnEstado
  rw [oraculo_merkle_en_indice k j hk hj _ _ raiz ⟨i, hi⟩]
  simpa only [vectorIndexado, ruta_prueba_indexada, ha.1] using h

theorem existe_oraculo_antes_primera_exposicion {B : ℕ} {fin : Estado B}
    (r : RecorridoSinAcierto B (inicial B) fin) (estado : Digest) (tag : Octeto) (raiz : Digest)
    (tipo : TipoReto) (dAbs dReto : Digest)
    (hAbs : buscar fin.tabla (entradaAbsorcion estado tag raiz.val) = some dAbs)
    (hReto : buscar fin.tabla (entradaReto dAbs tipo) = some dReto)
    (k j : ℕ) (hk : k ≤ 29) (hj : j ≤ k + 3) (defecto : Digest) :
    ∃ c : CorteRaizReto fin estado tag raiz tipo dAbs dReto,
      ∀ (i : ℕ), i < 2 ^ (k + 3 - j) → ∀ (v : Fp2) (hermanos : List Digest),
        VerificaIndice formatoBytes (funcionTabla defecto fin.tabla) raiz (k + 3 - j) i v hermanos →
        AperturaRegistrada formatoBytes (funcionTabla defecto fin.tabla)
          (fin.tabla.map Prod.fst) v (hermanosDesdeRaiz i hermanos) →
        oraculoEnEstado k j defecto c.segunda.antes raiz (puntoCapa k j i) = v := by
  obtain ⟨c⟩ := origenes_raiz_reto r estado tag raiz tipo dAbs dReto hAbs hReto
  exact ⟨c, fun i hi v hermanos ha hq => apertura_indexada_antes_reto c k j hk hj defecto i hi v hermanos ha hq⟩

theorem leer_oraculos_congelados {B : ℕ} (k n : ℕ) (defecto : Digest)
    (estados : ℕ → Estado B) (raices : ℕ → Digest) (j : ℕ) (hj : j < n) :
    leerOraculo (oraculosCongelados k n defecto estados raices) j =
      oraculoEnEstado k j defecto (estados j) (raices j) :=
  leer_captura_oraculos n _ j hj

theorem oraculos_congelados_absorcion_reto {B : ℕ} {fin : Estado B} (k n : ℕ) (defecto : Digest)
    (estados raices dAbs dReto : ℕ → Digest) (tags : ℕ → Octeto) (tipos : ℕ → TipoReto)
    (c : ∀ j, CorteRaizReto fin (estados j) (tags j) (raices j) (tipos j) (dAbs j) (dReto j)) :
    oraculosCongelados k n defecto (fun j => (c j).primera.antes) raices =
      oraculosCongelados k n defecto (fun j => (c j).segunda.antes) raices := by
  apply congrArg (capturarOraculos n)
  funext j
  exact oraculo_antes_primera_exposicion (c j) k j defecto

theorem apertura_en_oraculos_emitidos {B : ℕ} {fin : Estado B}
    {estado raiz dAbs dReto : Digest} {tag : Octeto} {tipo : TipoReto}
    (c : CorteRaizReto fin estado tag raiz tipo dAbs dReto)
    (k n j : ℕ) (hk : k ≤ 29) (hj : j ≤ k + 3) (hjn : j < n) (defecto : Digest)
    (estados : ℕ → Estado B) (raices : ℕ → Digest)
    (he : estados j = c.segunda.antes) (hr : raices j = raiz)
    (i : ℕ) (hi : i < 2 ^ (k + 3 - j)) (v : Fp2) (hermanos : List Digest)
    (ha : VerificaIndice formatoBytes (funcionTabla defecto fin.tabla) raiz (k + 3 - j) i v hermanos)
    (hq : AperturaRegistrada formatoBytes (funcionTabla defecto fin.tabla)
      (fin.tabla.map Prod.fst) v (hermanosDesdeRaiz i hermanos)) :
    leerOraculo (oraculosCongelados k n defecto estados raices) j (puntoCapa k j i) = v := by
  rw [leer_oraculos_congelados k n defecto estados raices j hjn, he, hr]
  exact apertura_indexada_antes_reto c k j hk hj defecto i hi v hermanos ha hq

end Nexus.Canal
