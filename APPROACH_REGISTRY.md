# Proof approach registry

This registry is organized by mathematical mechanism. A route is *blocked* only
when its remaining gap is theorem-strength rather than a missing local API lemma.
All API claims below refer to Lean 4.32.0 and Mathlib commit
`81a5d257c8e410db227a6665ed08f64fea08e997` unless noted otherwise.

At finalization no proof-search agent remains assigned. The root agent
integrated the proof; Kuhn independently audited weighted convergence,
Schrodinger audited normalization/division/existence, Chandrasekhar audited the
headline statement and trust surface, and a final requirements agent audited
the package. Each family below records its final assignment and disposition.

## A. Formal WPT plus majorant convergence

- Status: blocked as a standalone existence route; retained as a possible
  uniqueness backend.
- Agents currently assigned: none; the route is closed unless a new
  formal-to-convergent descent theorem appears.
- Compiled reconnaissance: an exploratory scratch consumer constructed the
  coefficient ring `MvPowerSeries (Fin n) ℂ`, proved the missing maximal-ideal
  identification, invoked `PowerSeries.exists_isWeierstrassFactorization`, and
  extracted degree, vanishing-constant-coefficient, and
  unit-constant-coefficient facts. It was deliberately not retained as a
  submission module because this route was blocked and none of its code enters
  the final dependency closure.
- Exact blocker: Mathlib has no theorem that the formal distinguished and unit
  factors of a convergent input converge on one smaller complex polydisc.
  Ordinary complex evaluation is not an instance of the linearly-topologized
  `MvPowerSeries.Evaluation` API.
- Gap type: theorem-strength formal-to-convergent descent, essentially the
  analytic core of WPT itself.
- Evidence for blocking: the compiled formal factorization stopped precisely
  before any common positive complex convergence radius; route B supplies that
  analytic theorem directly and therefore supersedes this route.

## B. Banach-algebra Weierstrass division

- Status: completed primary end-to-end route.
- Agents currently assigned: none; implementation and independent audits are
  complete.
- Compiled local infrastructure:
  `ClassicalComplexWPT/WeightedSeries.lean` proves ordinary `ℓ¹`
  submultiplicativity, bounded high shifts and low cuts, and bounded unit-
  polydisc evaluation. `ClassicalComplexWPT/L1Division.lean` now proves direct
  Nat-indexed Neumann division with exact hypothesis `‖p‖ < 1`, unique
  quotient/remainder identities, and joint analyticity of the proof-independent
  quotient and remainder maps.
- Compiled normalization:
  `ClassicalComplexWPT/NormalizedCoefficients.lean` proves
  `exists_normalizedAnalyticCoefficientMap`, choosing a positive weight whose
  normalized divisor is within `1/2` of the monomial at the origin and
  eventually has perturbation norm `< 1`.
- Compiled composition:
  `exists_normalizedPreparationSequences` supplies analytic quotient/remainder
  families with the exact eventual convolution identity and origin
  normalization.
- Compiled public reconstruction:
  `preparation_factorization_of_sequence_factorization` evaluates the
  convolution identity and `exists_isWeierstrassPreparation` packages analytic
  coefficients and a nonvanishing analytic unit for every `n,d`.
- Compiled uniqueness: `isWeierstrassPreparation_unique` encodes the analytic
  unit ratio as weighted coefficients, applies ordinary one-variable series
  injectivity and normalized division uniqueness on each nearby base fiber,
  and recovers all coefficient germs and the unit germ.
- Compiled final assembly:
  `classicalComplexWeierstrassPreparation` has the exact frozen public type,
  and `exists_open_preparation_neighborhood` exposes a pointwise factorization
  with a nonzero unit on one open neighborhood.
- Gap type: none.
- Evidence for completion: the exact frozen theorem, explicit-open-set
  corollary, full germ uniqueness, clean builds, and three independent audits
  all pass; mechanical details are recorded in `VERIFICATION.md` and
  `AUDIT_REPORT.md`.

## C. Weighted multivariable power-series algebra

- Status: coefficient-valued analytic bridge completed; merged into route B.
- Agents currently assigned: none; this infrastructure is integrated and was
  independently audited by Kuhn.
- Compiled foundation:
  `L1Coeff`, `convolution`, `highShiftCLM`, `lowCutCLM`, `evalL1`, and their norm
  bounds in `ClassicalComplexWPT/WeightedSeries.lean`.
  `ClassicalComplexWPT/NormalSum.lean` proves a generic common-radius
  normal-convergence theorem producing `HasFPowerSeriesOnBall`.
  `ClassicalComplexWPT/WeightedCoefficientMap.lean` now constructs the explicit
  FMS into `lp (fun _ : ℕ ↦ ℂ) 1`, proves its positive radius from
  `changeOriginSeries_summable_aux₁`, and identifies coordinate `k` with
  `r ^ k * lastTaylorCoefficient p k z` on a common base ball.
  `ClassicalComplexWPT/L1PowerSeries.lean` proves that an analytic map into this
  coefficient space evaluates jointly analytically with the distinguished
  variable, so the later quotient sequence reconstructs an ambient analytic
  function without a generic `AnalyticAt.tsum` rule.
- Compiled normalization/small-tail estimate:
  `exists_normalizedAnalyticCoefficientMap`.
- Compiled final sequence layer: `exists_normalizedPreparationSequences`
  composes the coefficient-valued analytic map with the quotient and remainder
  operators from route B.
- Compiled public witness reconstruction: `exists_isWeierstrassPreparation`.
- Compiled uniqueness bridge: `isWeierstrassPreparation_unique`.
- Gap type: none for the public existence/uniqueness chain.
- Evidence for merging: its weighted coefficient encoder is the input to route
  B's division operator, so retaining it as a separate end-to-end route would
  duplicate the same construction.

## D. Cauchy-integral and zero-counting

- Status: blocked after independent compiled reconnaissance.
- Agents currently assigned: none; the route is closed absent new contour
  zero-counting and parameter-integral APIs.
- Source mechanism: Lebl, *Tasty Bits of Several Complex Variables*, Theorems
  6.2.3 and 6.2.5. The quotient and remainder are given by a fixed-circle Cauchy
  integral; the remainder is polynomial because
  `(P ζ - P w) / (ζ - w)` is polynomial in `w`.
- Compiled foundation found locally: circle integrals and Cauchy formulas in
  `Mathlib.Analysis.Complex.CauchyIntegral`; no Rouché or argument-principle
  theorem was found by source search.
- Exact blockers: no Rouché/argument-principle/contour-zero-count API; no
  multivariable analytic parameter-integral theorem; the available
  differentiable-implies-analytic and removable-singularity theorems have
  one-dimensional domain.
- Gap type: several theorem-strength developments before preparation itself.
- Evidence for blocking: pinned-source searches and compiled Cauchy-API probes
  found the scalar fixed-circle machinery but none of the three named
  multivariable/zero-counting bridges.

## E. Analytic implicit-function route

- Status: viable coefficient-selection subroute, but not a complete division
  route by itself.
- Agents currently assigned: none; the completed weighted division route makes
  further assignment unnecessary.
- Compiled foundation found locally: general analytic formal-series inversion in
  `Mathlib.Analysis.Analytic.Inverse` and local analytic inverse results in
  `Mathlib.Analysis.Calculus.InverseFunctionTheorem.Analytic`.
- Candidate mechanism: use finite-dimensional remainder coefficients from
  division by a nearby monic polynomial, then solve the zero-remainder equations
  for the coefficients.
- Compiled reconnaissance: exploratory scratch consumers packaged a general
  analytic local inverse/implicit theorem and built analytic moving
  coefficients, companion powers, affine derivatives, and normal convergence
  of individual remainder summands. They were not retained because they are
  abandoned-route experiments and are not evidence for the final theorem.
- Exact missing steps: regroup companion summands into FMS satisfying the local
  normal-sum hypotheses, prove the triangular Toeplitz derivative is an
  equivalence, and independently recover a jointly analytic quotient.
- Gap type: local FMS majorants plus a quotient theorem; therefore secondary to
  the weighted division route.
- Evidence for blocking: even after the finite-dimensional inverse theorem
  compiled, the missing jointly analytic quotient remained the full analytic
  division problem already solved by route B.

## F. Direct coefficient recursion

- Status: merged into the weighted operator route: high shift plus convolution
  is the recursion written as a bounded linear fixed-point equation.
- Agents currently assigned: none; the recursion is part of the completed
  primary implementation.
- Compiled realization: `seqDivisionPerturbation`,
  `norm_seqDivisionPerturbation_le`, and `seqDivision_existsUnique`.
- Compiled quantitative input: `exists_normalizedAnalyticCoefficientMap`.
- Compiled completion: `exists_normalizedPreparationSequences` composes the
  recursion with the normalized analytic input and records its origin values.
- Gap type: none at the sequence level; public reconstruction belongs to route
  B.
- Evidence for merging: `exists_normalizedPreparationSequences` is exactly the
  compiled recursive solution packaged for route B's public reconstruction.

## G. Analytic germ algebra

- Status: blocked as an existence route; elementary unit facts retained.
- Agents currently assigned: none; only the useful local unit lemma was merged.
- Compiled local result: `ClassicalComplexWPT/Germs.lean` proves that an
  analytic representative nonzero at the base point is a unit in
  `Filter.Germ (𝓝 x) ℂ`.
- Exact blocker: the ring of convergent analytic germs is not adically complete;
  descent from its formal completion is again the missing convergence theorem.
- Gap type: theorem-strength completion comparison.
- Evidence for blocking: the proved germ-unit lemma supplies local inversion,
  but no adic-completeness or faithful formal-to-convergent comparison exists
  for these analytic germs.

## H. Structural lessons from Tate-algebra formalizations

- Status: completed and integrated as an ordinary-norm architecture.
- Agents currently assigned: none; reconnaissance and replacement estimates
  are complete.
- Reused structure: coefficient space, coordinate inclusions/projections,
  shifts/cuts, absolute convolution, and quotient/remainder organization.
  The analytic encoder is implemented in
  `ClassicalComplexWPT/WeightedCoefficientMap.lean` using weighted `ℓ¹`, not a
  Gauss sup norm.
- Rejected shortcuts: `PowerSeries.IsRestricted.mul` and
  `MvPowerSeries.isRestricted.mul` require `IsUltrametricDist`; the proof step
  bounding an antidiagonal sum by the largest summand is false over `ℂ`.
  Likewise `MvPowerSeries.gaussNorm_mul_le` assumes an `IsNonarchimedean`
  coefficient size. The counterexample `(1 + X)^2 = 1 + 2X + X^2` at radius
  one shows ordinary complex Gauss-sup submultiplicativity fails.
- Replacement estimate: absolute summability and the ordinary triangle
  inequality give the weighted `ℓ¹` convolution bound, while
  `changeOriginSeries_summable_aux₁` supplies the two-radius binomial majorant.
- Gap type: none; the resulting ordinary-norm implementation is part of route B.
- External-influence disclosure: “Tate-algebra” here described only a structural
  comparison against the pinned Mathlib files
  `RingTheory/PowerSeries/Restricted.lean`,
  `RingTheory/MvPowerSeries/Restricted.lean`, and
  `RingTheory/MvPowerSeries/GaussNorm.lean` (Mathlib commit above,
  Apache-2.0). No external Tate-algebra repository was imported, copied, or
  adapted. The influence was conceptual—organizing coefficients, shifts,
  cutoffs, and multiplication—while every complex `ℓ¹` estimate was written
  locally and checked independently.
- Evidence for completion: the invalid ultrametric shortcut was rejected by
  its hypotheses and an explicit complex counterexample, and the replacement
  Archimedean estimates compile in the primary chain.

## I. Mathlib API route comparison

- Status: completed API comparison; all selected infrastructure is integrated.
- Agents currently assigned: none.
- Concrete findings:
  - `AnalyticAt` is defined through `HasFPowerSeriesAt` in
    `Mathlib.Analysis.Analytic.Basic`.
  - product restrictions are supplied by `AnalyticAt.curry_left` and
    `AnalyticAt.curry_right`.
  - analytic scalar inversion is `AnalyticAt.inv`.
  - formal inverse series have proved positive convergence radius in
    `Mathlib.Analysis.Analytic.Inverse`.
  - `FormalMultilinearSeries.changeOrigin` proves that every moving
    distinguished-variable Taylor coefficient is analytic with uniform radius
    control; this is integrated in `AnalyticSeries.lean`.
  - `HasFPowerSeriesAt.eq_formalMultilinearSeries` is one-dimensional only;
    multivariable arguments must use diagonal evaluations or canonical
    iterated derivatives explicitly.
  - no generic `AnalyticAt.tsum` exists; the local
    `hasFPowerSeriesOnBall_sumTsum` theorem now supplies the needed rigorous
    replacement under explicit majorant hypotheses.
  - the concrete `weightedCoefficientSeries` bridge now packages all moving
    distinguished coefficients into one analytic `ℓ¹`-valued map, with a
    proved positive radius and exact pointwise coordinate identity.
- Final decision: weighted `ℓ¹` division is the shortest complete chain;
  companion/implicit remains an independent challenge to its coefficient and
  uniqueness layer, while formal, contour, and germ-completion existence routes
  stay blocked for recorded theorem-strength reasons.
- Gap type: none for the selected route; the alternate-route gaps are recorded
  above.
- Evidence for completion: every API used by the final chain is named in
  `API_MAP.md`, compiled in a local module, and exercised by the clean root
  build.
