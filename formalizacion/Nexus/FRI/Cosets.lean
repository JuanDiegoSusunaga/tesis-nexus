module

public import Nexus.AIR.Goldilocks
public import Nexus.FRI.Dominios
import Mathlib.Tactic

/-!
# Cosets sucesivos de FRI sobre Goldilocks

La capa j usa desplazamiento 7^(2^j), raíz de orden 2^(k+3-j)
y esa misma cantidad de puntos. El representante de cada pareja se toma
de la primera mitad de los índices; su existencia y unicidad se prueban.
-/

public section
namespace Nexus.Goldilocks

theorem dos_extension_no_cero : (2 : Fp2) ≠ 0 := by
  have hbase : (2 : Fp) ≠ 0 := by decide
  intro h
  apply hbase
  apply (algebraMap Fp Fp2).injective
  simpa only [map_ofNat, map_zero] using h

/-- Coherencia para un plegado: la raíz de la capa siguiente es el cuadrado. -/
theorem raiz_cuadrado (l : ℕ) (hl : l + 1 ≤ 32) : raiz (l + 1) ^ 2 = raiz l := by
  have hd : 2 ^ (l + 1) ∣ p - 1 := by
    apply dvd_trans (show 2 ^ (l + 1) ∣ 2 ^ 32 from ?_) (by norm_num [p])
    exact ⟨2 ^ (32 - (l + 1)), by rw [← pow_add, Nat.add_sub_of_le hl]⟩
  obtain ⟨a, ha⟩ := hd
  unfold raiz
  rw [← pow_mul]
  congr 1
  rw [ha]
  rw [Nat.mul_div_cancel_left a (by positivity)]
  rw [pow_succ, Nat.mul_assoc, Nat.mul_div_cancel_left _ (by positivity), Nat.mul_comm]

theorem raiz_extension_cuadrado (l : ℕ) (hl : l + 1 ≤ 32) :
    raizExtension (l + 1) ^ 2 = raizExtension l := by
  simpa only [raizExtension, ← map_pow] using congrArg (algebraMap Fp Fp2) (raiz_cuadrado l hl)

theorem raiz_media_opuesta (l : ℕ) (hl0 : 1 ≤ l) (hl : l ≤ 32) :
    raizExtension l ^ (2 ^ (l - 1)) = -1 := by
  have hexp : l - 1 + 1 = l := by omega
  have hmul : 2 ^ (l - 1) * 2 = 2 ^ l := by rw [← pow_succ, hexp]
  have hsquare : (raizExtension l ^ (2 ^ (l - 1))) ^ 2 = (1 : Fp2) ^ 2 := by
    rw [← pow_mul, hmul, (raiz_extension_primitiva l hl).pow_eq_one, one_pow]
  have hne : raizExtension l ^ (2 ^ (l - 1)) ≠ 1 := by
    apply (raiz_extension_primitiva l hl).pow_ne_one_of_pos_of_lt (by positivity)
    have hp : 0 < 2 ^ (l - 1) := by positivity
    omega
  exact (Nexus.FRI.raices_opuestas _ _ hsquare).resolve_left hne

@[expose] noncomputable def desplazamientoCapa (j : ℕ) : Fp2 :=
  algebraMap Fp Fp2 (7 : Fp) ^ (2 ^ j)

@[expose] noncomputable def puntoCapa (k j i : ℕ) : Fp2 :=
  desplazamientoCapa j * raizExtension (k + 3 - j) ^ i

@[expose] noncomputable def dominioCapa (k j : ℕ) : Finset Fp2 := by
  classical
  exact (Finset.range (2 ^ (k + 3 - j))).image (puntoCapa k j)

theorem desplazamiento_cuadrado (j : ℕ) :
    desplazamientoCapa j ^ 2 = desplazamientoCapa (j + 1) := by
  simp only [desplazamientoCapa, pow_succ, pow_mul]

theorem desplazamiento_no_cero (j : ℕ) : desplazamientoCapa j ≠ 0 := by
  apply pow_ne_zero
  exact (algebraMap Fp Fp2).injective.ne (by decide : (7 : Fp) ≠ 0)

theorem punto_capa_no_cero (k j i : ℕ) (hk : k ≤ 29) (hj : j ≤ k + 3) :
    puntoCapa k j i ≠ 0 := by
  apply mul_ne_zero (desplazamiento_no_cero j)
  apply pow_ne_zero
  exact (raiz_extension_primitiva (k + 3 - j) (by omega)).ne_zero (by positivity)

theorem punto_capa_inyectivo (k j : ℕ) (hk : k ≤ 29) (hj : j ≤ k + 3) :
    Set.InjOn (puntoCapa k j) (Finset.range (2 ^ (k + 3 - j))) := by
  unfold puntoCapa
  simpa only [mul_comm] using (raiz_extension_primitiva (k + 3 - j) (by omega)).injOn_pow_mul
      (α := desplazamientoCapa j) (desplazamiento_no_cero j)

theorem cardinal_dominio_capa (k j : ℕ) (hk : k ≤ 29) (hj : j ≤ k + 3) :
    (dominioCapa k j).card = 2 ^ (k + 3 - j) := by
  classical
  rw [dominioCapa, Finset.card_image_of_injOn (punto_capa_inyectivo k j hk hj),
    Finset.card_range]

theorem punto_capa_cuadrado (k j i : ℕ) (hk : k ≤ 29) (hj : j < k + 3) :
    puntoCapa k j i ^ 2 = puntoCapa k (j + 1) i := by
  have hexp : k + 3 - j = (k + 3 - (j + 1)) + 1 := by omega
  have hroot : raizExtension (k + 3 - j) ^ 2 = raizExtension (k + 3 - (j + 1)) := by
    rw [hexp]
    exact raiz_extension_cuadrado _ (by omega)
  unfold puntoCapa
  rw [mul_pow, desplazamiento_cuadrado, ← pow_mul, Nat.mul_comm i 2, pow_mul, hroot]

theorem punto_capa_opuesto (k j i : ℕ) (hk : k ≤ 29) (hj : j < k + 3) :
    puntoCapa k j (i + 2 ^ (k + 2 - j)) = -puntoCapa k j i := by
  have hhalf : k + 3 - j - 1 = k + 2 - j := by omega
  have hroot := raiz_media_opuesta (k + 3 - j) (by omega) (by omega)
  rw [hhalf] at hroot
  simp only [puntoCapa, pow_add, hroot]
  ring

theorem dominio_capa_inicial (k : ℕ) : dominioCapa k 0 = cosetExtension (k + 3) := by
  classical
  rw [dominioCapa, cosetExtension, coset, Finset.image_image]
  simp only [Nat.sub_zero]
  congr 1
  funext i
  simp only [puntoCapa, desplazamientoCapa, pow_zero, pow_one, Nat.sub_zero,
    raizExtension, Function.comp_apply, map_mul, map_pow]

@[expose] noncomputable def indiceCapa (k j : ℕ) (y : Fp2) : ℕ := by
  classical
  exact if h : ∃ i, i < 2 ^ (k + 3 - j) ∧ puntoCapa k j i = y then Classical.choose h else 0

@[expose] noncomputable def representanteCapa (k j : ℕ) (y : Fp2) : Fp2 :=
  puntoCapa k j (indiceCapa k (j + 1) y)

theorem indice_capa_especificacion (k j : ℕ) (y : Fp2) (hy : y ∈ dominioCapa k j) :
    indiceCapa k j y < 2 ^ (k + 3 - j) ∧ puntoCapa k j (indiceCapa k j y) = y := by
  classical
  have hex : ∃ i, i < 2 ^ (k + 3 - j) ∧ puntoCapa k j i = y := by
    obtain ⟨i, hi, heq⟩ := Finset.mem_image.mp hy
    exact ⟨i, Finset.mem_range.mp hi, heq⟩
  unfold indiceCapa
  rw [dite_eq_left hex]
  exact Classical.choose_spec hex

/-- El representante coincide con el índice concreto de la primera mitad. -/
theorem representante_en_punto (k j i : ℕ) (hk : k ≤ 29) (hj : j < k + 3)
    (hi : i < 2 ^ (k + 3 - (j + 1))) :
    representanteCapa k j (puntoCapa k (j + 1) i) = puntoCapa k j i := by
  classical
  have hy : puntoCapa k (j + 1) i ∈ dominioCapa k (j + 1) :=
    Finset.mem_image.mpr ⟨i, Finset.mem_range.mpr hi, rfl⟩
  have hs := indice_capa_especificacion k (j + 1) _ hy
  have hindex : indiceCapa k (j + 1) (puntoCapa k (j + 1) i) = i :=
    punto_capa_inyectivo k (j + 1) hk (by omega)
      (Finset.mem_range.mpr hs.1) (Finset.mem_range.mpr hi) hs.2
  simp only [representanteCapa, hindex]

theorem representante_cuadrado (k j : ℕ) (hk : k ≤ 29) (hj : j < k + 3)
    (y : Fp2) (hy : y ∈ dominioCapa k (j + 1)) :
    representanteCapa k j y ^ 2 = y := by
  rw [representanteCapa, punto_capa_cuadrado k j _ hk hj]
  exact (indice_capa_especificacion k (j + 1) y hy).2

theorem representante_no_cero (k j : ℕ) (hk : k ≤ 29) (hj : j < k + 3) (y : Fp2) :
    representanteCapa k j y ≠ 0 :=
  punto_capa_no_cero k j _ hk (by omega)

theorem tamano_capa_siguiente (k j : ℕ) (hj : j < k + 3) :
    2 ^ (k + 3 - j) = 2 * 2 ^ (k + 3 - (j + 1)) := by
  have hexp : k + 3 - j = k + 3 - (j + 1) + 1 := by omega
  rw [hexp, pow_succ, Nat.mul_comm]

theorem representante_pertenece (k j : ℕ) (_hk : k ≤ 29) (hj : j < k + 3)
    (y : Fp2) (hy : y ∈ dominioCapa k (j + 1)) :
    representanteCapa k j y ∈ dominioCapa k j := by
  classical
  have hi := (indice_capa_especificacion k (j + 1) y hy).1
  have hsize := tamano_capa_siguiente k j hj
  exact Finset.mem_image.mpr ⟨indiceCapa k (j + 1) y, Finset.mem_range.mpr (by omega), rfl⟩

theorem opuesto_representante_pertenece (k j : ℕ) (hk : k ≤ 29) (hj : j < k + 3)
    (y : Fp2) (hy : y ∈ dominioCapa k (j + 1)) :
    -representanteCapa k j y ∈ dominioCapa k j := by
  classical
  have hi := (indice_capa_especificacion k (j + 1) y hy).1
  have hsize := tamano_capa_siguiente k j hj
  have hhalf : k + 2 - j = k + 3 - (j + 1) := by omega
  refine Finset.mem_image.mpr ⟨indiceCapa k (j + 1) y + 2 ^ (k + 3 - (j + 1)),
    Finset.mem_range.mpr (by omega), ?_⟩
  simpa only [hhalf, representanteCapa] using punto_capa_opuesto k j (indiceCapa k (j + 1) y) hk hj

/-- Cada dominio es exactamente la unión de las dos mitades de las parejas siguientes. -/
theorem enlace_dominios_capa (k j : ℕ) (hk : k ≤ 29) (hj : j < k + 3) :
    dominioCapa k j = Nexus.FRI.elevar (representanteCapa k j) (dominioCapa k (j + 1)) := by
  classical
  have hsize := tamano_capa_siguiente k j hj
  have hhalf : k + 2 - j = k + 3 - (j + 1) := by omega
  ext x
  simp only [dominioCapa, Nexus.FRI.elevar, Finset.mem_union, Finset.mem_image, Finset.mem_range]
  constructor
  · rintro ⟨i, hiN, rfl⟩
    by_cases hi' : i < 2 ^ (k + 3 - (j + 1))
    · exact Or.inl ⟨_, ⟨i, hi', rfl⟩, representante_en_punto k j i hk hj hi'⟩
    · let b := i - 2 ^ (k + 3 - (j + 1))
      have hb : b < 2 ^ (k + 3 - (j + 1)) := by dsimp [b]; omega
      have hsum : b + 2 ^ (k + 3 - (j + 1)) = i := by dsimp [b]; omega
      have hop := punto_capa_opuesto k j b hk hj
      rw [hhalf, hsum] at hop
      exact Or.inr ⟨_, ⟨b, hb, rfl⟩,
        (congrArg Neg.neg (representante_en_punto k j b hk hj hb)).trans hop.symm⟩
  · intro hx
    rcases hx with ⟨y, ⟨i, hi, rfl⟩, heq⟩ | ⟨y, ⟨i, hi, rfl⟩, heq⟩
    · exact ⟨i, by omega, (representante_en_punto k j i hk hj hi).symm.trans heq⟩
    · have hop := punto_capa_opuesto k j i hk hj
      rw [hhalf] at hop
      exact ⟨i + 2 ^ (k + 3 - (j + 1)), by omega,
        hop.trans ((congrArg Neg.neg (representante_en_punto k j i hk hj hi)).symm.trans heq)⟩

end Nexus.Goldilocks
