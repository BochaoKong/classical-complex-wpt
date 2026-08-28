# Verification record

This file records reproducible checks for the immutable submission snapshot.
The final clean-checkout commit and any platform-specific caveats are listed in
the final section.

## Pinned environment

- Lean: `v4.32.0` (`leanprover/lean4:v4.32.0`).
- Mathlib manifest revision:
  `81a5d257c8e410db227a6665ed08f64fea08e997`.
- Comparator: `68a064109f01c08f47c8edc9f51d6a2bbffaa188`.
- lean4export: `4e7915201d3f9f04470d9eae002fa695f7cdc589`.
- NanoDa: `68d5ca9db226849b41a6fff59d796ff19d0a8840`.
- Landrun: `811cfff51ceaf3d9843708aa6d22e9b84ccac8b4`.
- Codex CLI observed during preflight: `0.142.5`.
- Root license: Apache-2.0.

The sole direct Lean dependency is Mathlib. Its committed manifest resolves the
following immutable Lean-library closure:

```text
mathlib           81a5d257c8e410db227a6665ed08f64fea08e997
plausible         e12c1910fe855cbfc38803cd4e55543906d5fa62
LeanSearchClient  c5d5b8fe6e5158def25cd28eb94e4141ad97c843
importGraph       7e9612bf0b9ee66db3cb5b9988a35afc706f5a12
proofwidgets      6e311e2a844da9b2cc3971187df2fe0066947b93
aesop             a7dbf0c63b694e47f425f3dcddbc0e178bb432d3
Qq                38d591e778f100aec9762bb582f9c7f55f50e9dc
batteries         023ce7d62a0531e22a5331e20b587817a80d49ff
Cli               88679d088c9720c27ebdf2ba4dafe17341747f94
```

Doc-gen4 and its closure live only in the nested documentation project.
Comparator, lean4export, NanoDa, and Landrun are verification tools rather than
Lean theorem dependencies.

## Root build

The following commands passed on the working macOS checkout:

```bash
lake update
lake exe cache get
lake build
lake env lean Solution.lean
lake env lean ClassicalComplexWPT/Main.lean
lake env lean ClassicalComplexWPT/AxiomAudit.lean
ruby scripts/validate-formalization.rb
uvx --from 'check-jsonschema==0.38.0' check-jsonschema \
  --schemafile https://raw.githubusercontent.com/mathlib-initiative/formalization.yaml/main/schema/formalization.schema.json \
  formalization.yaml
```

`lake build` built 2227 jobs. Its sole warning was the deliberate theorem hole
in `Challenge.lean`; `Solution.lean` and every substantive module built without
warnings or errors. The metadata validator reported no template values, and
the current upstream schema validator reported `ok -- validation done`.

## Axiom closure

Command:

```bash
lake env lean ClassicalComplexWPT/AxiomAudit.lean
```

Output:

```text
'ClassicalComplexWPT.classicalComplexWeierstrassPreparation' depends on axioms: [propext, Classical.choice, Quot.sound]
```

No `sorryAx` occurs in the solution dependency closure.

## Comparator and external kernel

Command:

```bash
./scripts/verify-comparator.sh
```

The pinned toolchain built the challenge and solution, exported the compared
declaration, ran NanoDa, and ran the default Lean kernel. The decisive output
was:

```text
Running nanoda kernel on solution
Nanoda kernel accepts the solution
Running Lean default kernel on solution.
Lean default kernel accepts the solution
Your solution is okay!
```

This Darwin run verifies statement comparison and both kernels. It does not
verify Landlock enforcement: the pinned go-landlock implementation deliberately
falls back to no restriction on non-Linux systems when Landrun is invoked with
`--best-effort`. The final Linux clean-checkout result is recorded below.

## Source scan

The repository scan is packaged as:

```bash
./scripts/audit-lean-sources.sh
```

The script checks `sorry`, `admit`, `sorryAx`, `native_decide`,
`Lean.ofReduceBool`, `axiom`, `opaque`, `unsafe`, and `extern`. Its only match
is `./Challenge.lean:69:  sorry`, the deliberate advertised hole, and it also
asserts the frozen
challenge SHA-256
`4f2f45a1d26d0c8409e03c85080ce905fbb987a4585c01bdd686d2b006733ef0`.

## Documentation

Commands:

```bash
(cd docbuild && MATHLIB_NO_CACHE_ON_UPDATE=1 lake update)
(cd docbuild && DISABLE_EQUATIONS=1 DOCGEN_SRC=file \
  lake build ClassicalComplexWPT:docs)
```

The local documentation build completed successfully: `4649` jobs in the
cached rerun, including doc-info generation for every project module and the
final `ClassicalComplexWPT:docs` target. An initial attempt with
`DOCGEN_SRC=github` generated every project doc-info target but correctly
rejected the template remote as a source-link origin; using the documented
`file` source mode resolved that packaging-only issue.

## Final clean-checkout verification

The immutable theorem/package content snapshot was
`8497ff7deffacb130965f4bba0ddaff1dc231f76`. It was cloned from a Git bundle
into a new guest-native ext4 checkout, detached at that exact SHA, and checked
both before and after verification with:

```bash
snapshot=8497ff7deffacb130965f4bba0ddaff1dc231f76
bundle=/Users/kbc/wpt-$snapshot.bundle
repo=$HOME/wpt-clean-$snapshot
git clone "$bundle" "$repo"
git -C "$repo" checkout --detach "$snapshot"
test "$(git -C "$repo" rev-parse HEAD)" = "$snapshot"
test -z "$(git -C "$repo" status --porcelain=v1 --untracked-files=all)"
```

The clone's warning that its bundle remote had no default `HEAD` was expected;
the explicit detached checkout succeeded. The final HEAD was exactly the SHA
above and the final porcelain status was empty.

The verification host was a non-root Ubuntu 24.04.4 aarch64 Lima 2.2.0/VZ VM
using kernel `6.8.0-134-generic`. The kernel configuration had
`CONFIG_SECURITY_LANDLOCK=y`, the active LSM list included `landlock`, and a
direct syscall reported Landlock ABI 4. The checkout lived on guest-native
ext4; no writable host or external-volume mount was used.

Before any unsandboxed project build, an explicit pinned-Landrun probe printed
`Landlock restrictions applied successfully`: a write inside its sole allowed
subdirectory succeeded and a parent-directory write failed with
`Permission denied`. Comparator then ran as uid 501 in the prescribed user
systemd unit:

```bash
systemd-run --user --wait --pipe --collect \
  --property="RestrictAddressFamilies=~AF_UNIX" \
  -E "PATH=$PATH" -E "HOME=$HOME" \
  --working-directory="$repo" \
  /usr/bin/bash -c 'test "$(id -u)" -ne 0; exec ./scripts/verify-comparator.sh'
```

The unit finished with `result: success`; Comparator printed all three decisive
success lines recorded above. Runtime was 7m57.892s, CPU time 12m57.202s, peak
memory 11.3 GiB, and swap use zero.

The following clean-checkout gates also passed:

- `lake update`, followed by an unchanged-manifest assertion;
- `lake exe cache get` and `lake build` (`2227` jobs);
- focused Lean checks of `Solution.lean`, `Main.lean`, and `AxiomAudit.lean`;
- the exact three-axiom output and the source/frozen-hash scan;
- `16` metadata-validator tests with `83` assertions and no failures;
- the no-template validator and `check-jsonschema` 0.38.0 against the live
  upstream schema;
- Bundler 2.7.2 / Licensee 10.0.0 detection of exactly `Apache-2.0`;
- the README submission-link gate and Landrun-wrapper policy test; and
- `DISABLE_EQUATIONS=1 DOCGEN_SRC=file lake build
  ClassicalComplexWPT:docs` (`6871` jobs, 515 MiB output).

The only nonfatal messages were the advertised Challenge `sorry`, the bundle
default-HEAD warning, and doc-gen's known inability to obtain detailed
information for `Qq.Impl.mkLambdaQ` and `Qq.Impl.withLetHave`. The docs target
completed successfully. The 40 GiB VM retained 18 GiB free.

Commits after the SHA above contain only the final verification attestation,
workflow hardening, metadata wording, and editorial records; no Lean theorem,
Challenge, Solution, manifest, or Comparator configuration changed. A Git
commit cannot literally contain its own hash, so `PALOMAR_SUBMISSION.md`
records this verified content SHA and the final externally reported attestation
SHA separately.
