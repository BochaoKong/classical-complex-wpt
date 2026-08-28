# Lemma ledger

## Verified external and local declarations

| Purpose | Exact declaration or file | Status |
|---|---|---|
| Analytic germ at a point | `AnalyticAt` in `Mathlib.Analysis.Analytic.Basic` | source-verified |
| Restrict to a product coordinate | `AnalyticAt.curry_left`, `AnalyticAt.curry_right` | source-verified |
| Analytic composition with a continuous linear map | `AnalyticAt.compContinuousLinearMap` | source-verified |
| Analytic reciprocal near a nonzero value | `AnalyticAt.inv` | source-verified |
| Formal power-series WPT | `PowerSeries.exists_isWeierstrassFactorization` | source-verified |
| Formal WPT uniqueness | `PowerSeries.IsWeierstrassFactorization.unique` | source-verified |
| Analytic inverse formal series convergence | `FormalMultilinearSeries.radius_rightInv_pos_of_radius_pos` | source-verified |
| Fixed-circle Cauchy power series | `hasFPowerSeriesOn_cauchy_integral` | source-verified |
| Integrating multilinear maps pointwise | `ContinuousMultilinearMap.integral_apply` | source-verified |
| Analytic restriction to the distinguished axis | `ClassicalComplexWPT.analyticAt_lastSlice` | compiled |
| Derivative exact order equals analytic order | `exactOrderInLastVariable_iff_analyticOrderAt` | compiled |
| Axis factorization by `w^d` | `exists_lastSlice_eq_pow_mul` | compiled |
| Moving last-variable coefficients are analytic | `analyticAt_lastTaylorCoefficient` | compiled |
| Moving coefficient/derivative normalization | `factorial_smul_lastTaylorCoefficient_zero` | compiled |
| Exact order equals first nonzero moving coefficient | `exactOrderInLastVariable_iff_lastTaylorCoefficients` | compiled |
| Weighted moving coefficients have a positive-radius `ℓ¹` FMS | `radius_weightedCoefficientSeries_pos` | compiled |
| Weighted coefficient-valued map is analytic | `analyticAt_weightedCoefficientSeries_sum` | compiled |
| `ℓ¹` coordinate equals the moving Taylor coefficient | `weightedCoefficientSeries_sum_apply_lastTaylorCoefficient` | compiled |
| Weighted evaluation reconstructs the ambient FMS | `eval_weightedCoefficientSeries_eq` | compiled |
| Weighted evaluation reconstructs a represented function | `eval_weightedCoefficientSeries_eq_of_hasFPowerSeriesOnBall` | compiled |
| Weighted evaluation reconstructs a represented analytic germ | `eventually_eval_weightedCoefficientSeries_eq_of_hasFPowerSeriesAt` | compiled |
| Weighted coefficient evaluation is jointly analytic | `analyticAt_eval_weightedCoefficientSeries` | compiled |
| Explicit base-ball `ℓ¹` membership and norm bound | `exists_weightedLastCoeffs_on_baseBall` | compiled |
| Swapped double-index Archimedean majorant | `summable_changeOrigin_weighted_majorant` | compiled |
| Operator-valued `ℓ¹` evaluation series has radius at least one | `one_le_radius_l1OperatorSeries` | compiled |
| Joint analytic evaluation of analytic `ℓ¹` families | `AnalyticAt.evalL1PowerSeries` | compiled |
| Bundled evaluation equals the scalar power-series sum | `evalL1PowerSeries_eq_tsum` | compiled |
| Generic normal sum gives an analytic FMS | `hasFPowerSeriesOnBall_sumTsum` | compiled |
| `ℓ¹` convolution estimate | `norm_convolution_le` | compiled |
| High shift and low cutoff contractions | `norm_highShiftCLM_le`, `norm_lowCutCLM_le` | compiled |
| Direct Nat-indexed shift/cut decomposition | `seqLowShift_highShift_add_lowCut` | compiled |
| Neumann perturbation norm | `norm_seqDivisionPerturbation_le` | compiled |
| Unique Nat-indexed normalized division | `seqDivision_existsUnique` | compiled |
| Proof-independent analytic quotient | `analyticAt_seqDivisionQuotientGlobal` | compiled |
| Proof-independent analytic remainder | `analyticAt_seqDivisionRemainderGlobal` | compiled |
| Global quotient/remainder factorization | `seqDivisionGlobal_factorization` | compiled |
| Evaluation commutes with sequence scaling | `evalL1PowerSeries_smul` | compiled |
| Monomial sequence evaluates to `w ^ d` | `evalL1PowerSeries_monomialSeq` | compiled |
| Low-supported sequence evaluates as a `Fin d` sum | `evalL1PowerSeries_eq_sum_fin_of_highShift_eq_zero` | compiled |
| Small-radius normalized origin estimate | `exists_radius_normalizedOrigin_close_half` | compiled |
| Analytic normalized weighted divisor | `analyticAt_analyticNormalizedCoefficientMap` | compiled |
| Eventual Neumann-ball normalized divisor | `exists_normalizedAnalyticCoefficientMap` | compiled |
| Analytic normalized preparation quotient | `analyticAt_normalizedPreparationQuotient` | compiled |
| Analytic normalized preparation remainder | `analyticAt_normalizedPreparationRemainder` | compiled |
| Eventual normalized convolution factorization | `eventually_normalizedPreparation_factorization` | compiled |
| Exact-order origin remainder vanishes | `normalizedPreparationRemainder_zero` | compiled |
| Origin quotient has constant coefficient one | `normalizedPreparationQuotient_zero_apply_zero` | compiled |
| Packaged normalized preparation sequences | `exists_normalizedPreparationSequences` | compiled |
| Sequence factorization reconstructs the public scalar factorization | `preparation_factorization_of_sequence_factorization` | compiled |
| Full public preparation existence for every `n,d` | `exists_isWeierstrassPreparation` | compiled |
| Germ equality of `ℓ¹` evaluations determines coefficients | `eq_of_evalL1PowerSeries_eventuallyEq` | compiled |
| Abstract prepared-sequence uniqueness | `seqPreparedPolynomial_unique` | compiled |
| Evaluation-level prepared-sequence uniqueness | `seqPreparedPolynomial_unique_of_eventually_eval` | compiled |
| Full public preparation germ uniqueness | `isWeierstrassPreparation_unique` | compiled |
| Frozen headline existence-and-uniqueness theorem | `classicalComplexWeierstrassPreparation` | compiled |
| Explicit open-neighborhood preparation corollary | `exists_open_preparation_neighborhood` | compiled |
| Bounded `ℓ¹` evaluation | `norm_evalL1_le` | compiled |
| Analytic germ nonzero at base point is a unit | `analytic_germ_isUnit` | compiled |
| Complete preparation and uniqueness for `d = 0` | `classicalComplexWeierstrassPreparation_zero` | compiled |
| Complete preparation and uniqueness for `n = 0` | `classicalComplexWeierstrassPreparation_noBase` | compiled |

## Complete theorem chain and alternate-route record

1. **Compiled:** public-space and germ definitions compile for every `n d : ℕ`
   in `Basic.lean` and the frozen `Challenge.lean`.
2. **Compiled:** `AnalyticAt ℂ f 0` restricts to an analytic last-variable slice
   (`analyticAt_lastSlice`).
3. **Compiled:** the derivative exact-order predicate agrees both with
   `analyticOrderAt` and with the first nonzero moving Taylor coefficient; the
   `d = 0` case is fully proved.
4. **Compiled coefficient-space core:** `seqDivisionGlobal_factorization`
   produces the quotient and degree-`< d` remainder, while
   `analyticAt_seqDivisionQuotientGlobal` and
   `analyticAt_seqDivisionRemainderGlobal` prove joint analyticity under the
   exact normalized-tail hypothesis `‖p‖ < 1`.
   `exists_normalizedPreparationSequences` composes that family with the
   quotient/remainder maps and proves the exact eventual convolution identity,
   support condition, and origin normalizations. Converting these sequences to
   the public polynomial and unit witnesses is compiled as
   `exists_isWeierstrassPreparation`.
5. **Abandoned alternate implicit-function route:** it would additionally need
   an analytic remainder map for division by a variable monic polynomial.
6. **Abandoned alternate implicit-function route:** it would then need an
   invertible derivative in the polynomial-coefficient variables at the axis
   factorization.
7. **Abandoned alternate implicit-function route:** an analytic inverse theorem
   would select the coefficient germs. These three items are not dependencies
   or missing goals of the completed weighted-division proof.
8. **Compiled:** the resulting quotient is nonzero at the origin, yielding
   preparation (`exists_isWeierstrassPreparation`).
9. **Compiled:** prepared coefficient and unit germs are unique
   (`isWeierstrassPreparation_unique`).
10. **Compiled:** representative examples, `d = 0`, `n = 0`, and the general
    explicit-open-neighborhood corollary compile.

## Final proof frontier

The generic infinite-sum theorem, the concrete FMS-to-weighted-series encoder,
and the jointly analytic `ℓ¹` evaluation map are now compiled.
`WeightedCoefficientMap.lean` supplies the
per-degree absolute summability, the swapped double-index normal majorant,
positive radius, the analytic `ℓ¹`-valued sum, and its exact coordinate
identity, while `L1PowerSeries.lean` reconstructs analytic ambient functions
from analytic coefficient families. The abstract `ℓ¹` division operator is now
compiled, including exact coefficient identities, uniqueness, the `< 1`
Neumann hypothesis, and joint analyticity of its proof-independent quotient
and remainder. `NormalizedCoefficients.lean` also compiles the asymmetric-radius
tail estimate and produces a normalized analytic divisor that eventually lies
in the required open unit ball. `PreparationSequences.lean` completes its
composition with the division maps, and `PublicExistence.lean` reconstructs
the public polynomial/unit witnesses. `PreparationUniqueness.lean` proves full
coefficient and unit germ uniqueness, and `Main.lean` assembles the exact frozen
headline theorem plus an explicit open-neighborhood corollary. The mathematical
theorem chain is compiled and independently audited. The immutable proof
snapshot also passed clean Linux Comparator, NanoDa, Lean-kernel, source, axiom,
metadata, and build checks recorded in `VERIFICATION.md`. No contour theorem,
formal descent theorem, or ultrametric estimate is hidden behind this frontier.
