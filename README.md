# Classical complex-analytic Weierstrass preparation in Lean

This repository gives a Mathlib-only Lean 4 formalization of the classical
complex-analytic Weierstrass preparation theorem, including existence and full
germ uniqueness for every number of base variables and every degree. The edge
cases `n = 0` and `d = 0` are included.

The project uses the Palomar Registry separation between a small independently
auditable statement in `Challenge.lean` and the substantive proof imported by
`Solution.lean`. Comparator checks the advertised declaration, recursively
including the definitions appearing in its type, and the verifier replays the
exported proof with NanoDa.

## Mathematical statement

Write `Base n = Fin n → ℂ` and `Ambient n = Base n × ℂ`, with points denoted
`(z,w)`. Let `f : Ambient n → ℂ` be analytic near the origin. Suppose the slice
`w ↦ f (0,w)` has exact order `d`: all derivatives below `d` vanish at zero and
the derivative of order `d` is nonzero.

Then there are analytic germs `a₀,…,a_{d-1}` on the base, all vanishing at
zero, and an analytic germ `u` on the ambient space with `u(0,0) ≠ 0`, such
that

```text
f(z,w) = u(z,w) (w^d + Σ_{i<d} a_i(z) w^i)
```

on a neighborhood of the origin. Every coefficient germ and the unit germ are
unique. When `d = 0`, the polynomial is `1` and the conclusion is precisely
that `f` is a nonvanishing analytic unit germ.

The compared Lean theorem is:

```lean
theorem ClassicalComplexWPT.classicalComplexWeierstrassPreparation
    (n d : ℕ) (f : Ambient n → ℂ)
    (hf : AnalyticAt ℂ f 0)
    (horder : ExactOrderInLastVariable f d) :
    ∃ (a : Fin d → Base n → ℂ) (u : Ambient n → ℂ),
      IsWeierstrassPreparation f d a u ∧
      ∀ (a' : Fin d → Base n → ℂ) (u' : Ambient n → ℂ),
        IsWeierstrassPreparation f d a' u' →
        (∀ i, a i =ᶠ[𝓝 0] a' i) ∧ u =ᶠ[𝓝 0] u'
```

Here `AnalyticAt ℂ` is Mathlib's convergent formal-multilinear-series notion,
and `=ᶠ[𝓝 0]` is equality on some neighborhood of zero. Thus functions serve
as representatives of analytic germs without adding a custom stalk or sheaf
layer. The nonzero value of the analytic unit at zero implies nonvanishing on a
smaller neighborhood. The separately proved
`exists_open_preparation_neighborhood` corollary exposes one such open set and
the pointwise factorization on it.

## Proof architecture

The proof is an ordinary Archimedean weighted-`ℓ¹` argument; it does not use an
ultrametric estimate and does not reduce analytic convergence to the existing
formal-power-series preparation theorem.

1. An `AnalyticAt` witness supplies an ambient formal multilinear series `p`.
   Moving-center expansions package all Taylor coefficients in the
   distinguished variable into one analytic map from the base to complex
   `ℓ¹(ℕ)`. A two-index absolute majorant proves one common positive radius.
2. A positive weight `r` is chosen so the coefficient sequence, normalized by
   its nonzero degree-`d` coefficient, is within `1/2` of the monomial sequence
   `e_d` at the origin and within the open unit ball nearby.
3. Direct bounded shifts, low cutoffs, and ordinary Cauchy convolution turn
   division by `e_d + p` into inversion of an operator within norm one of the
   identity. This gives analytic quotient and low-degree remainder maps and the
   exact sequence identity `e_d = q * G + rem`.
4. Analytic `ℓ¹` evaluation reconstructs the ambient function on a common
   neighborhood. The public coefficients are scaled remainder coordinates,
   and the quotient evaluation is inverted to produce the analytic unit.
5. For uniqueness, the ratio of two proposed units is itself encoded by a
   weighted `ℓ¹` sequence. One-variable analytic-series injectivity and the
   same division uniqueness theorem identify both low-degree tails and the
   ratio, yielding equality of every coefficient germ and of the unit germ.

This route proves every convergence, sum-rearrangement, Neumann-inversion, and
neighborhood-shrinking lemma locally in Lean.

## Repository layout

- `Challenge.lean`: frozen statement surface; its sole `sorry` is the
  advertised theorem hole.
- `Solution.lean`: imports the proved declaration from the substantive library.
- `ClassicalComplexWPT/Basic.lean`: public definitions mirrored independently
  from the challenge.
- `ClassicalComplexWPT/AnalyticSeries.lean` and
  `WeightedCoefficientMap.lean`: moving Taylor coefficients and the common
  weighted-`ℓ¹` analytic family.
- `ClassicalComplexWPT/WeightedSeries.lean`, `L1Division.lean`, and
  `NormalizedCoefficients.lean`: ordinary-norm convolution, Neumann division,
  and exact-order normalization.
- `ClassicalComplexWPT/PreparationSequences.lean` and
  `PublicExistence.lean`: analytic quotient/remainder sequences and public
  factor reconstruction.
- `ClassicalComplexWPT/PreparationUniqueness.lean`: full coefficient and unit
  germ uniqueness.
- `ClassicalComplexWPT/Main.lean`: exact headline theorem and explicit-open-set
  corollary.
- `ClassicalComplexWPT/AxiomAudit.lean`: reproducible printed axiom closure.
- `STATEMENT_AUDIT.md`, `APPROACH_REGISTRY.md`, `API_MAP.md`, and
  `LEMMA_LEDGER.md`: semantic audit, route registry, checked API map, and proof
  dependency ledger.
- `AUDIT_REPORT.md` and `VERIFICATION.md`: adversarial and mechanical check
  records.
- `formalization.yaml`, `comparator.json`, and `PALOMAR_SUBMISSION.md`: Palomar
  metadata, trust configuration, and human handoff.

## Reproducible verification

The root project pins Lean `v4.32.0` and Mathlib at the corresponding release
manifest. From the repository root:

```bash
lake update
lake exe cache get
lake build
lake env lean ClassicalComplexWPT/AxiomAudit.lean
./scripts/audit-lean-sources.sh
ruby scripts/validate-formalization.rb
uvx --from 'check-jsonschema==0.38.0' check-jsonschema \
  --schemafile https://raw.githubusercontent.com/mathlib-initiative/formalization.yaml/main/schema/formalization.schema.json \
  formalization.yaml
```

On Linux, run the authoritative sandboxed comparison as an unprivileged user:

```bash
systemd-run --user --wait --pipe --collect \
  --property=RestrictAddressFamilies=~AF_UNIX \
  -E PATH="$PATH" -E HOME="$HOME" --working-directory="$(pwd)" \
  /usr/bin/bash -c 'test "$(id -u)" -ne 0; exec ./scripts/verify-comparator.sh'
```

The documentation build is:

```bash
(cd docbuild && MATHLIB_NO_CACHE_ON_UPDATE=1 lake update)
(cd docbuild && DISABLE_EQUATIONS=1 DOCGEN_SRC=file \
  lake build ClassicalComplexWPT:docs)
```

`DOCGEN_SRC=file` makes this command reproducible in a local or non-GitHub
checkout. CI uses `DOCGEN_SRC=github` after cloning the project-owned GitHub
remote so generated source links point back to that immutable snapshot.

The axiom audit prints exactly:

```text
'ClassicalComplexWPT.classicalComplexWeierstrassPreparation' depends on axioms: [propext, Classical.choice, Quot.sound]
```

Comparator, lean4export, NanoDa, and Landrun are pinned verification tools;
they are not Lean theorem dependencies. See `VERIFICATION.md` for the exact
tool revisions and recorded outputs. Palomar submission itself must be
performed by the human maintainer through the
[current submission form](https://submit.palomar-registry.org/).

## Dependencies, sources, and scope

The only external Lean library is Mathlib and its pinned dependency closure.
The principal mathematical reference is Jiří Lebl,
[*Tasty Bits of Several Complex Variables*, version 4.4, §6.2,
Theorem 6.2.3](https://www.jirka.org/scv/scv.pdf).
That source proves preparation through contour integrals and zero counting;
this formalization independently proves the germ theorem through weighted
Banach-space division. Mathlib's existing
[`PowerSeries` Weierstrass preparation](https://github.com/leanprover-community/mathlib4/blob/81a5d257c8e410db227a6665ed08f64fea08e997/Mathlib/RingTheory/PowerSeries/WeierstrassPreparation.lean)
is algebraic and formal, not a prior formalization of the complex-analytic
convergence theorem.

The theorem is stated at the origin. An arbitrary-base-point translation and a
public general analytic division theorem are not included. No claim of
mathematical novelty, external human peer review, Palomar acceptance, or
registration is made.

## AI disclosure

The Lean development, documentation, and automated audits were produced by
OpenAI GPT-5-family Codex (the exact backend model identifier was not exposed)
using direct multi-agent v2 coordination under user direction. Independent
Codex agents audited the frozen semantics, both central convergence layers,
full germ uniqueness, and the final trust surface. No external human
mathematical or code review is claimed.

The repository is licensed under Apache-2.0. Cited sources and tool
dependencies retain their own licenses.
