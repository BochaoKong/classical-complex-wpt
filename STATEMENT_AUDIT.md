# Statement audit

## Freeze record

The public statement in `Challenge.lean` passed an independent semantic and
adversarial audit and was frozen on 2026-08-28.

- SHA-256 of `Challenge.lean`:
  `4f2f45a1d26d0c8409e03c85080ce905fbb987a4585c01bdd686d2b006733ef0`
- Compared theorem:
  `ClassicalComplexWPT.classicalComplexWeierstrassPreparation`
- Human review: none claimed.

Any change to `Challenge.lean` requires a root-agent decision, a written
semantic diff, a new independent audit, and a replacement hash here.

## Readable statement

For `n d : ℕ` and an analytic germ
`f : (Fin n → ℂ) × ℂ → ℂ` at the origin, assume that the slice
`w ↦ f (0,w)` has vanishing iterated derivatives in every order below `d` and
nonvanishing derivative in order `d`. Then there are analytic coefficient
germs `a_i : (Fin n → ℂ) → ℂ`, all vanishing at the origin, and an analytic
unit germ `u`, nonzero at the origin, such that locally

```text
f(z,w) = u(z,w) (w^d + ∑_{i : Fin d} a_i(z) w^i).
```

Every coefficient germ and the unit germ are unique. Here `n` counts base
variables, so the ambient complex dimension is `n + 1`.

## Semantic checks

- `AnalyticAt ℂ` is used on the intended finite-dimensional complex normed
  spaces.
- `Fin d` indexes exactly `0, …, d-1`; the separate `w^d` term makes the
  polynomial syntactically monic.
- Mathlib's
  `analyticOrderAt_eq_nat_iff_iteratedDeriv_eq_zero` confirms the off-by-one
  convention: lower derivatives vanish and derivative `d` is nonzero.
- For `w^d`, the derivative in order `d` is `d!`; the public condition only
  asserts nonvanishing, so factorial normalization causes no mismatch.
- `=ᶠ[𝓝 0]` is equality on a common neighborhood and therefore equality of
  germs.
- Analyticity plus `u 0 ≠ 0` makes `u` eventually nonzero and hence a unit in
  the function-germ ring; this is proved in `ClassicalComplexWPT/Germs.lean`.
- Coefficient analyticity and uniqueness are per coordinate, and finiteness of
  `Fin d` supplies a common neighborhood.
- For `d = 0`, the derivative condition is `f 0 ≠ 0`, the coefficient family is
  empty, and the prepared polynomial is `1`. The full conclusion and uniqueness
  compile in `classicalComplexWeierstrassPreparation_zero`.
- For `n = 0`, the base is the empty finite product and the full theorem for
  every `d` compiles in
  `classicalComplexWeierstrassPreparation_noBase`.
- The hypotheses are satisfiable and the factorization is nonvacuous.

## Compiled witnesses

`ClassicalComplexWPT/Examples.lean` contains kernel-checked examples for:

- `f(z,w) = w^d`;
- `f(z,w) = w^d + z₀`;
- `(1+w)(w+z₀)`, exhibiting a nonconstant analytic unit;
- the `n = 0` and `d = 0` interpretations.

Verification command:

```bash
lake build ClassicalComplexWPT.Examples Challenge
```

The only warning expected from this command is the deliberate advertised
`sorry` in `Challenge.lean`.

## Source fidelity

The statement matches the germ form of Jiří Lebl, *Tasty Bits of Several
Complex Variables*, Theorem 6.2.3. Lebl states uniqueness of the monic
Weierstrass polynomial and the nonvanishing holomorphic factor and explicitly
notes the degree-zero convention `P = 1` and the obvious germ version. The
local fixed-disc zero-localization used in the source proof is correctly absent
from this germ-level conclusion.
