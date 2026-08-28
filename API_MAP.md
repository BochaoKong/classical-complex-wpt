# Mathlib API map

Pinned environment: Lean `4.32.0`; Mathlib
`81a5d257c8e410db227a6665ed08f64fea08e997`.

Only declarations checked in the pinned source or in a compiling scratch file
belong here.

## Analytic functions

- `AnalyticAt`, `AnalyticOnNhd`, `HasFPowerSeriesAt`, and
  `HasFPowerSeriesOnBall`: `Mathlib.Analysis.Analytic.Basic`.
- Algebraic constructions and product restrictions:
  `Mathlib.Analysis.Analytic.Constructions`.
- Composition: `Mathlib.Analysis.Analytic.Composition`.
- Analytic inverse formal series and convergence:
  `Mathlib.Analysis.Analytic.Inverse`.
- One-variable analytic order and local power factorization:
  `Mathlib.Analysis.Analytic.Order`.
- Moving-center expansions and quantitative radius bounds:
  `FormalMultilinearSeries.changeOrigin`, `changeOriginSeries`,
  `analyticAt_changeOrigin`, `changeOrigin_radius`, and
  `nnnorm_changeOrigin_le` in `Mathlib.Analysis.Analytic.ChangeOrigin`.
  The double-index Archimedean majorant used by the weighted coefficient map
  is `FormalMultilinearSeries.changeOriginSeries_summable_aux₁`.
- One-dimensional series uniqueness:
  `HasFPowerSeriesAt.eq_formalMultilinearSeries` in
  `Mathlib.Analysis.Analytic.Uniqueness`. This API is deliberately not used as
  a multivariable coefficient-uniqueness theorem.
- One-variable equivalence with eventual complex differentiability:
  `analyticAt_iff_eventually_differentiableAt` in
  `Mathlib.Analysis.Complex.CauchyIntegral`.

## Derivatives and product spaces

- `iteratedDeriv`: `Mathlib.Analysis.Calculus.IteratedDeriv.Defs` and related
  iterated-derivative modules.
- Coordinate maps are analytic via `analyticAt_fst`, `analyticAt_snd`, and
  continuous-linear-map composition.
- `HasFPowerSeriesOnBall.factorial_smul` identifies diagonal FMS coefficients
  with iterated Fréchet derivatives; `iteratedDeriv_eq_iteratedFDeriv` supplies
  the one-variable specialization.

## Complex integrals

- Circle integral and the Cauchy-integral formal power series:
  `Mathlib.MeasureTheory.Integral.CircleIntegral`.
- Cauchy formula and derivative formulas:
  `Mathlib.Analysis.Complex.CauchyIntegral`.
- Bochner integration commutes with continuous multilinear evaluation via
  `ContinuousMultilinearMap.integral_apply`.
- No ready theorem named for Rouché's theorem, the argument principle, or
  analytic dependence of a parameterized integral was located by `rg`; this is
  a negative API finding, not a mathematical impossibility claim.

## Formal series

- Algebraic division/preparation:
  `Mathlib.RingTheory.PowerSeries.WeierstrassPreparation`.
- Multivariable formal series: `Mathlib.RingTheory.MvPowerSeries.*`.
- Gauss norms exist, but the available multiplication API is primarily
  nonarchimedean and cannot be transplanted to the complex norm without new
  estimates.
- In particular, `PowerSeries.IsRestricted.mul` and
  `MvPowerSeries.isRestricted.mul` require `IsUltrametricDist`, while
  `MvPowerSeries.gaussNorm_mul_le` requires an `IsNonarchimedean` coefficient
  size. These hypotheses are essential, not instance-search inconveniences:
  over `ℂ`, `‖1 + 1‖ = 2 > max ‖1‖ ‖1‖`, and the radius-one Gauss sup norm of
  `(1 + X)^2` is `2` although each factor has Gauss sup norm `1`.

## Infinite sums and weighted coefficients

- `lp (fun _ : I ↦ ℂ) 1` is complete and provides the coefficient space used
  locally as `L1Coeff I`.
- `lp.singleContinuousLinearMap`, `lp.evalCLM`, `NNReal.summable_sigma`,
  `NNReal.summable_comp_injective`, `Summable.of_nnnorm_bounded`, and
  `nnnorm_tsum_le` support the compiled moving-coefficient encoder in
  `ClassicalComplexWPT/WeightedCoefficientMap.lean`.
- `lp.memℓp`, `lp.norm_eq_tsum_rpow`, `memℓp_gen`,
  `summable_sum_mul_antidiagonal_of_summable_mul`, and
  `Summable.tsum_mul_tsum_eq_tsum_sum_antidiagonal` support the compiled
  ordinary Cauchy-product norm estimate.
- `Units.oneSub` and `isUnit_one_sub_of_norm_lt_one` are the verified Neumann
  inversion route for a bounded operator of norm below one.
- `Ring.inverse`, `NormedRing.inverse_one_sub`, and `analyticAt_inverse`
  provide a proof-independent analytic inverse map.  The compiled Nat-indexed
  maps `seqDivisionQuotientGlobal` and `seqDivisionRemainderGlobal` use this API
  and are jointly analytic in the divisor tail and dividend on `‖p‖ < 1`.
- `ContinuousMultilinearMap.tsum_eval`, `norm_tsum_le_tsum_norm`,
  `summable_prod_of_nonneg`, and `Summable.tsum_comm` support the local theorem
  `ClassicalComplexWPT.hasFPowerSeriesOnBall_sumTsum`.
- Mathlib has no generic `AnalyticAt.tsum`; the local theorem is intentionally
  hypothesis-explicit rather than appealing to a nonexistent closure rule.
- `weightedCoefficientSeries` is an explicit FMS into `lp (fun _ : ℕ ↦ ℂ) 1`.
  Theorems `radius_weightedCoefficientSeries_pos` and
  `weightedCoefficientSeries_sum_apply_lastTaylorCoefficient` prove that its
  analytic sum has coordinate `r ^ k * lastTaylorCoefficient p k z` on the
  common convergence neighborhood.
- `eval_weightedCoefficientSeries_eq` reconstructs `p.sum (z, w)` by evaluating
  the weighted sequence at `r⁻¹ * w`; its ball-valued companion
  `eval_weightedCoefficientSeries_eq_of_hasFPowerSeriesOnBall` reconstructs the
  represented function itself.
- `eventually_eval_weightedCoefficientSeries_eq_of_hasFPowerSeriesAt` shrinks
  all three explicit convergence conditions simultaneously and exposes that
  reconstruction as an `EventuallyEq` germ identity.
- `evalL1PowerSeries_monomialSeq` identifies the normalized distinguished
  monomial sequence with `w ^ d`, while
  `evalL1PowerSeries_eq_sum_fin_of_highShift_eq_zero` turns the abstract
  high-shift support condition into the exact finite sum over `Fin d` used by
  the public prepared-polynomial definition.
- `analyticAt_eval_weightedCoefficientSeries` is the direct specialization of
  `AnalyticAt.evalL1PowerSeries` used to turn analytic weighted quotient or unit
  coefficient maps back into jointly analytic functions of `(z, w)`.
- `l1OperatorSeries` packages coordinate evaluation into an operator-valued
  FMS of radius at least one. `analyticAt_evalL1PowerSeries` and
  `AnalyticAt.evalL1PowerSeries` prove joint analytic evaluation of a fixed or
  analytically varying `ℓ¹` coefficient sequence at scalar coordinate zero.
- `seqHighShift`, `seqLowShift`, and `seqLowCut` are the direct
  `lp (fun _ : ℕ ↦ ℂ) 1` shift/cut operations used by the weighted coefficient
  bridge. `seqDivision_existsUnique` is the exact Neumann division theorem for
  the normalized divisor `w^d + p`; its only smallness hypothesis is
  `‖p‖ < 1`.
- `exists_normalizedAnalyticCoefficientMap` combines exact distinguished order,
  diagonal radius scaling, and the ordinary `ℓ¹` norm to choose `r > 0` such
  that the normalized analytic coefficient map is within `1/2` of the monomial
  at the origin and eventually remains within the Neumann ball of radius one.
- `exists_normalizedPreparationSequences` feeds that analytic family into the
  proof-independent division operators. It returns analytic quotient and
  low-degree remainder maps, their eventual convolution factorization, zero
  origin remainder, and quotient constant coefficient one at the origin.
- `eventually_eval_weightedCoefficientSeries_eq_of_hasFPowerSeriesAt` and the
  finite-support evaluation lemmas reconstruct those sequences on one common
  ambient neighborhood. `exists_isWeierstrassPreparation` packages the result
  as analytic public coefficients and a nonvanishing analytic unit for every
  `n d : ℕ`.
- `eq_of_evalL1PowerSeries_eventuallyEq` proves injectivity of one-variable
  `ℓ¹` evaluation at the germ level using Mathlib's one-dimensional formal
  series uniqueness. `isWeierstrassPreparation_unique` applies this pointwise
  after encoding the ratio of two analytic units by weighted coefficients and
  yields equality of every coefficient germ and of the unit germ.

## Analytic inverse machinery

- `AnalyticAt.hasStrictFDerivAt` converts analytic maps to the strict derivative
  hypothesis used by the inverse theorem.
- `HasStrictFDerivAt.toOpenPartialHomeomorph`,
  `OpenPartialHomeomorph.analyticAt_symm'`, and the eventual left/right inverse
  lemmas suffice to package a general analytic implicit-function theorem.
- There is no single packaged multivariable analytic implicit theorem in the
  pinned revision. A historical exploratory scratch consumer compiled the
  wrapper used to assess the companion route, but it was not retained as a
  submission module because that route was abandoned and the wrapper is not a
  dependency or evidence for the completed weighted-division proof.

## Verification tools

- Palomar starter commit:
  `128a6c5ce5f48622e69927ccd639cbff401022e8`.
- Palomar policy read at:
  `d5a647db3757303b1d928cfae4d3d232eed3e79e`.
- Upstream `formalization.yaml` schema read at:
  `99c678e569c7c4c0772db297c5ddd5e4c9b6322e`.
- The checked-in starter verifier pins Comparator
  `68a064109f01c08f47c8edc9f51d6a2bbffaa188`, lean4export
  `4e7915201d3f9f04470d9eae002fa695f7cdc589`, NanoDa
  `68d5ca9db226849b41a6fff59d796ff19d0a8840`, and Landrun
  `811cfff51ceaf3d9843708aa6d22e9b84ccac8b4`.
