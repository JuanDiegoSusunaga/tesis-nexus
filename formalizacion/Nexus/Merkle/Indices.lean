module

public import Nexus.Merkle.Extraccion
import Mathlib.Tactic

/-!
# Índices numéricos y rutas binarias de Merkle

Los bits se consumen desde el menos significativo al verificar desde la
hoja. La ruta del extractor los invierte para empezar en la raíz. Las
inversas exigen un índice menor que 2 elevado a la altura.
-/

public section
namespace Nexus.Merkle

@[expose] def bitsBajos : ℕ → ℕ → List Bool
  | 0, _ => []
  | n + 1, i => decide (i % 2 = 1) :: bitsBajos n (i / 2)

@[expose] def indiceBits : List Bool → ℕ
  | [] => 0
  | b :: resto => (if b then 1 else 0) + 2 * indiceBits resto

@[expose] def rutaIndice (altura i : ℕ) : List Bool := (bitsBajos altura i).reverse

@[expose] def indiceRuta (ruta : List Bool) : ℕ := indiceBits ruta.reverse

theorem bits_bajos_longitud (altura i : ℕ) : (bitsBajos altura i).length = altura := by
  induction altura generalizing i with
  | zero => rfl
  | succ n ih => simp only [bitsBajos, List.length_cons, ih]

theorem ruta_indice_longitud (altura i : ℕ) : (rutaIndice altura i).length = altura := by
  simp only [rutaIndice, List.length_reverse, bits_bajos_longitud]

theorem indice_bits_cota (bits : List Bool) : indiceBits bits < 2 ^ bits.length := by
  induction bits with
  | nil => simp only [indiceBits, List.length_nil, pow_zero, Nat.zero_lt_one]
  | cons b resto ih =>
    simp only [indiceBits, List.length_cons, pow_succ]
    split_ifs <;> omega

theorem indice_bits_bajos (altura i : ℕ) (hi : i < 2 ^ altura) :
    indiceBits (bitsBajos altura i) = i := by
  induction altura generalizing i with
  | zero =>
    have hz : i = 0 := by simpa using hi
    subst i
    rfl
  | succ n ih =>
    have hdiv : i / 2 < 2 ^ n := by
      rw [pow_succ] at hi
      omega
    have hm := Nat.mod_lt i (by omega : 0 < 2)
    have hd := Nat.mod_add_div i 2
    simp only [bitsBajos, indiceBits, ih (i / 2) hdiv, decide_eq_true_eq]
    split_ifs <;> omega

theorem bits_bajos_indice (bits : List Bool) :
    bitsBajos bits.length (indiceBits bits) = bits := by
  induction bits with
  | nil => rfl
  | cons b resto ih =>
    cases b
    · simp only [List.length_cons, indiceBits, Bool.false_eq_true, ite_false, zero_add]
      have hm : (2 * indiceBits resto) % 2 ≠ 1 := by omega
      have hd : 2 * indiceBits resto / 2 = indiceBits resto := by omega
      simp only [bitsBajos, hm, decide_false, hd, ih]
    · simp only [List.length_cons, indiceBits, ite_true]
      have hm : (1 + 2 * indiceBits resto) % 2 = 1 := by omega
      have hd : (1 + 2 * indiceBits resto) / 2 = indiceBits resto := by omega
      simp only [bitsBajos, hm, decide_true, hd, ih]

theorem indice_ruta_cota (ruta : List Bool) : indiceRuta ruta < 2 ^ ruta.length := by
  simpa only [indiceRuta, List.length_reverse] using indice_bits_cota ruta.reverse

theorem indice_ruta_indice (altura i : ℕ) (hi : i < 2 ^ altura) :
    indiceRuta (rutaIndice altura i) = i := by
  simpa only [indiceRuta, rutaIndice, List.reverse_reverse] using indice_bits_bajos altura i hi

theorem ruta_indice_ruta (ruta : List Bool) : rutaIndice ruta.length (indiceRuta ruta) = ruta := by
  have h := congrArg List.reverse (bits_bajos_indice ruta.reverse)
  simpa only [rutaIndice, indiceRuta, List.length_reverse, List.reverse_reverse] using h

theorem ruta_indice_inyectiva (altura : ℕ) :
    Function.Injective (fun i : Fin (2 ^ altura) => rutaIndice altura i.val) := by
  intro i j hij
  apply Fin.ext
  have h := congrArg indiceRuta hij
  simpa only [indice_ruta_indice altura i.val i.isLt, indice_ruta_indice altura j.val j.isLt] using h

/-- La equivalencia conserva la numeración binaria usual de las hojas. -/
@[expose] def equivalenciaRutas (altura : ℕ) :
    {ruta : List Bool // ruta.length = altura} ≃ Fin (2 ^ altura) where
  toFun ruta := ⟨indiceRuta ruta.val, by simpa only [ruta.property] using indice_ruta_cota ruta.val⟩
  invFun i := ⟨rutaIndice altura i.val, ruta_indice_longitud altura i.val⟩
  left_inv ruta := by
    apply Subtype.ext
    simpa only [← ruta.property] using ruta_indice_ruta ruta.val
  right_inv i := Fin.ext (indice_ruta_indice altura i.val i.isLt)

theorem rutas_numeradas_completas (altura : ℕ) (ruta : List Bool) (hr : ruta.length = altura) :
    ∃ i : Fin (2 ^ altura), rutaIndice altura i.val = ruta := by
  refine ⟨equivalenciaRutas altura ⟨ruta, hr⟩, ?_⟩
  exact congrArg Subtype.val ((equivalenciaRutas altura).left_inv ⟨ruta, hr⟩)

variable {V D E : Type*} [Zero V] [DecidableEq D]

@[expose] def vectorIndexado (f : Formato V D E) (H : E → D) (registro : List E)
    (altura : ℕ) (raiz : D) : Fin (2 ^ altura) → V :=
  fun i => extraer f H registro (rutaIndice altura i.val) raiz

theorem vector_indexado_en_ruta (f : Formato V D E) (H : E → D) (registro : List E)
    (altura : ℕ) (raiz : D) (ruta : List Bool) (hr : ruta.length = altura) :
    vectorIndexado f H registro altura raiz (equivalenciaRutas altura ⟨ruta, hr⟩) =
      extraer f H registro ruta raiz := by
  unfold vectorIndexado
  congr 1
  exact congrArg Subtype.val ((equivalenciaRutas altura).left_inv ⟨ruta, hr⟩)

theorem vectores_indexados_iguales (f : Formato V D E) (H G : E → D) (A B : List E)
    (altura : ℕ) (raiz : D)
    (h : vectorExtraido f H A altura raiz = vectorExtraido f G B altura raiz) :
    vectorIndexado f H A altura raiz = vectorIndexado f G B altura raiz := by
  funext i
  let ruta : Fin altura → Bool := fun j =>
    (rutaIndice altura i.val).get ⟨j.val, (ruta_indice_longitud altura i.val).symm ▸ j.isLt⟩
  have he : List.ofFn ruta = rutaIndice altura i.val := by
    apply List.ext_getElem
    · simp only [List.length_ofFn, ruta_indice_longitud]
    · intro j hj hj'
      simp only [List.getElem_ofFn, ruta, List.get_eq_getElem]
  have hv := congrFun h ruta
  simpa only [vectorExtraido, vectorIndexado, he] using hv

end Nexus.Merkle
