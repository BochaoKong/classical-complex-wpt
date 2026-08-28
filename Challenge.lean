import Mathlib.Analysis.Analytic.Constructions
import Mathlib.Analysis.Calculus.IteratedDeriv.Defs
import Mathlib.Analysis.Complex.Basic

open scoped BigOperators Topology

/-!
# Classical complex-analytic Weierstrass preparation

This is the small, independently audited statement surface.  Here `n` is the
number of base variables, so `Ambient n` has total complex dimension `n + 1`.
Analytic germs are represented by functions together with equality in the
neighborhood filter of the origin.
-/

namespace ClassicalComplexWPT

/-- The complex parameter space `ℂⁿ`. -/
abbrev Base (n : ℕ) := Fin n → ℂ

/-- The parameter space together with the distinguished complex variable. -/
abbrev Ambient (n : ℕ) := Base n × ℂ

/-- Restriction of a function to the distinguished-variable axis. -/
def lastSlice {n : ℕ} (f : Ambient n → ℂ) : ℂ → ℂ :=
  fun w ↦ f (0, w)

/--
The distinguished-variable slice has a zero of exact order `d` at the origin:
all derivatives of order below `d` vanish and the derivative of order `d` does
not vanish.
-/
def ExactOrderInLastVariable {n : ℕ} (f : Ambient n → ℂ) (d : ℕ) : Prop :=
  (∀ k < d, iteratedDeriv k (lastSlice f) 0 = 0) ∧
    iteratedDeriv d (lastSlice f) 0 ≠ 0

/-- The monic degree-`d` polynomial in the distinguished variable. -/
def preparedPolynomial {n : ℕ} (d : ℕ) (a : Fin d → Base n → ℂ)
    (x : Ambient n) : ℂ :=
  x.2 ^ d + ∑ i : Fin d, a i x.1 * x.2 ^ (i : ℕ)

/--
`f` is locally the product of a nonvanishing analytic unit and a monic
distinguished-variable polynomial whose lower coefficients are analytic and
vanish at the base origin.
-/
def IsWeierstrassPreparation {n : ℕ} (f : Ambient n → ℂ) (d : ℕ)
    (a : Fin d → Base n → ℂ) (u : Ambient n → ℂ) : Prop :=
  (∀ i, AnalyticAt ℂ (a i) 0) ∧
    (∀ i, a i 0 = 0) ∧
    AnalyticAt ℂ u 0 ∧
    u 0 ≠ 0 ∧
    f =ᶠ[𝓝 0] fun x ↦ u x * preparedPolynomial d a x

/--
Classical complex-analytic Weierstrass preparation at the origin, including
existence and uniqueness of every coefficient germ and of the unit germ.  The
statement includes `n = 0` and `d = 0`.
-/
theorem classicalComplexWeierstrassPreparation
    (n d : ℕ) (f : Ambient n → ℂ)
    (hf : AnalyticAt ℂ f 0)
    (horder : ExactOrderInLastVariable f d) :
    ∃ (a : Fin d → Base n → ℂ) (u : Ambient n → ℂ),
      IsWeierstrassPreparation f d a u ∧
      ∀ (a' : Fin d → Base n → ℂ) (u' : Ambient n → ℂ),
        IsWeierstrassPreparation f d a' u' →
        (∀ i, a i =ᶠ[𝓝 0] a' i) ∧ u =ᶠ[𝓝 0] u' := by
  sorry

end ClassicalComplexWPT
