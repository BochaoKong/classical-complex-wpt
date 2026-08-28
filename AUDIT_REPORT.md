# Audit report

This report records the independent automated audits of the frozen statement,
the central convergence argument, the public reconstruction, uniqueness, and
the trust surface. No external human review is claimed.

## Frozen statement

- Compared declaration:
  `ClassicalComplexWPT.classicalComplexWeierstrassPreparation`.
- Frozen `Challenge.lean` SHA-256:
  `4f2f45a1d26d0c8409e03c85080ce905fbb987a4585c01bdd686d2b006733ef0`.
- The hash did not change during proof development.
- The statement audit checked the exact derivative order, `Fin d` indexing,
  monicity, analytic-germ encoding, unit condition, all coefficient and unit
  uniqueness clauses, satisfiability, and the `n=0` and `d=0` semantics.
- Compiled examples cover `w^d`, `w^d+z₀`, a nonconstant unit times an already
  prepared polynomial, and both edge-case interpretations.

Full details are in `STATEMENT_AUDIT.md`.

## Weighted analytic convergence audit

An independent agent audited `NormalSum.lean`,
`WeightedCoefficientMap.lean`, `WeightedEvaluation.lean`, and
`WeightedGermEvaluation.lean` and independently compiled every module plus a
consumer file.

The audit confirmed:

- the base radius is common to all distinguished-variable coefficients rather
  than chosen coefficientwise;
- the moving-center double sum has an explicit Archimedean absolute majorant;
- every `tsum` exchange is preceded by the required product summability;
- the moving-center and ambient convergence inequalities have the correct
  direction;
- cancellation of radius powers is used only after proving the radius positive;
- product norms are controlled by an ordinary triangle inequality; and
- the germ reconstruction intersects the base-series, ambient-series, and
  distinguished-disc neighborhoods before evaluating.

Representative audited SHA-256 values:

```text
122aafee260207eee7c56518ae32b3c413bb001c629136ee2a1e0acc9cf9d946  NormalSum.lean
fab31a82aaea58d5543dcce4c6afb3d625f7d829f8a0887673ec8bebe6e6e586  WeightedCoefficientMap.lean
0ee66a7c6392537a1ab7e220bd35561fa1f182d269dc7c0b6277dad0ddd05ab0  WeightedEvaluation.lean
ecbff0b1c60e6b7c6a038d01e08b823589ca8d21e93e28ba8cb957838a6f9cd7  WeightedGermEvaluation.lean
```

## Normalization, division, and reconstruction audit

A second independent agent audited `WeightedSeries.lean`, `L1Division.lean`,
`NormalizedCoefficients.lean`, `PreparationSequences.lean`,
`L1PolynomialEvaluation.lean`, and `PublicExistence.lean` and compiled them
independently. A separate degree-zero consumer also compiled.

The audit confirmed:

- ordinary complex `ℓ¹` convolution is submultiplicative without an
  ultrametric hypothesis;
- the perturbation has norm below one and the Neumann inverse has the correct
  sign (`oneSub (-T) = 1 + T`);
- exact order supplies a positive radius and nonzero normalizing coefficient;
- the sequence identity is `e_d = q * G + rem` with low-degree remainder;
- the public coefficient sign and scale are `-r^(d-i) rem_i`;
- the unit is `D * r⁻ᵈ * Q⁻¹`, producing `f = u * P` in the advertised
  orientation;
- quotient nonvanishing and reconstruction are intersected on one common
  ambient neighborhood; and
- the same construction correctly reduces `d=0` to a nonvanishing analytic
  unit.

Representative audited SHA-256 values:

```text
635b8872d4385924c1c6a8651f4cd7cfa63456845479f0eedc6b5a573314eaf8  WeightedSeries.lean
7670602368dfa7921c880e07ba6d06841d9858d2d76d71ac821d7992d6504458  L1Division.lean
7f4884df8a3a565c59e11864a4f50fa25499fbef911ad75311e8b5dc469eca11  NormalizedCoefficients.lean
c3a0a7212b9bd1f88909abdbc71c40cd6fdb20c826dcba246087d5f214d97b73  PreparationSequences.lean
1802308f6dbaac0ef890520e6c4a1d26ffa870c35f7371dd4f9728cd1e6c0752  L1PolynomialEvaluation.lean
33115044efb7a205c1554c79faa4dc2cd470895e1c0bc049112eabc39c4eb7e0  PublicExistence.lean
```

## Germ uniqueness audit

An independent agent compiled the full uniqueness module, instantiated its
consumer both generally and at `n=0,d=0`, and checked the scaling, common
neighborhoods, convolution orientation, support conditions, coefficient
cancellation, and final unit orientation.

The audited `PreparationUniqueness.lean` SHA-256 is
`fbda90cf61cffc65d236d2c83197c31883edbce31157fa2a23e54574153d3c29`.
No correctness gap was found.

## Trust-surface audit

The pinned Comparator source was inspected to check the role of
`definition_names`. The correct configuration leaves this list empty:
Comparator seeds comparison from the theorem type and recursively compares the
full constant information of every referenced public definition. Entries in
`definition_names` are intentionally treated as definition holes and compare
only their types, so listing the six fixed definitions there would weaken the
check.

The source scan over repository Lean files found only the deliberate advertised
`sorry` in `Challenge.lean`. There are no substantive occurrences of `admit`,
`sorryAx`, `native_decide`, `Lean.ofReduceBool`, explicit `axiom`, explicit
`opaque`, or proof-relevant `unsafe` code.

`ClassicalComplexWPT/AxiomAudit.lean` prints:

```text
'ClassicalComplexWPT.classicalComplexWeierstrassPreparation' depends on axioms: [propext, Classical.choice, Quot.sound]
```

Comparator matched the challenge and solution and both the default Lean kernel
and NanoDa accepted the solution export. The initial macOS verifier run did not
count as a Landlock enforcement test because pinned Landrun uses a documented
no-op best-effort fallback on non-Linux hosts. A subsequent clean Ubuntu
checkout used Landlock ABI 4, passed an explicit write-denial probe, and ran
Comparator as a non-root user under the prescribed systemd address-family
guard. Full commands, immutable SHA, outputs, and host facts are recorded in
`VERIFICATION.md`.

## Source fidelity and review boundary

The compared result is the origin-based germ form of Lebl, *Tasty Bits of
Several Complex Variables*, Theorem 6.2.3. It retains exact distinguished
order, monicity, analytic lower coefficients vanishing at zero, an analytic
unit, and full uniqueness. It omits the source theorem's chosen polydisc and
zero-location clause; a proved local-open-set corollary exposes the pointwise
factorization and nonvanishing unit. The proof is an independent weighted
Banach-division argument rather than the source's contour proof.

All audits described here were automated Codex-agent audits. They are evidence
of independent proof-path checking, not external human peer review or Palomar
editorial acceptance.
