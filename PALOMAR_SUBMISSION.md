# Palomar submission handoff

This is a preparation handoff for the human maintainer. It is not evidence of
Palomar registration, acceptance, or editorial review.

## Snapshot

- Local repository path: `/Volumes/Extreme Pro/Lean/wpt`.
- Current Git remote: `starter`, pointing to
  `https://github.com/PalomarRegistry/PalomarTemplate.git`. This is the template
  remote, not a project-owned submission remote.
- Project path: repository root.
- Branch: `codex/classical-complex-wpt`.
- Clean-Linux-verified theorem/package content SHA:
  `8497ff7deffacb130965f4bba0ddaff1dc231f76`.
- Final attestation commit: the commit containing this handoff, reported as a
  full 40-character SHA in the final Codex response and recoverable with
  `git rev-parse HEAD`. A commit cannot contain its own hash without changing
  that hash; this file therefore records the independently verified content
  predecessor and the external handoff records the final attestation SHA.
- Compared declaration:
  `ClassicalComplexWPT.classicalComplexWeierstrassPreparation`.
- Comparator configuration: `comparator.json`.
- Registry metadata: `formalization.yaml`.
- Frozen statement audit: `STATEMENT_AUDIT.md`.
- Mechanical verification record: `VERIFICATION.md`.
- Adversarial audit record: `AUDIT_REPORT.md`.

## Clean verification commands

The following creates a detached local checkout without copying any generated
files from the source worktree. Replace `source_repo` with the human
maintainer's project-owned remote after it exists, and replace `snapshot` with
the final externally reported attestation SHA to repeat the editorial checks on
that exact commit.

```bash
source_repo='/Volumes/Extreme Pro/Lean/wpt'
snapshot=8497ff7deffacb130965f4bba0ddaff1dc231f76
scratch=$(mktemp -d /tmp/classical-complex-wpt.XXXXXX)
repo="$scratch/repository"
git clone --no-local "$source_repo" "$repo"
git -C "$repo" checkout --detach "$snapshot"
test "$(git -C "$repo" rev-parse HEAD)" = "$snapshot"
test -z "$(git -C "$repo" status --porcelain=v1 --untracked-files=all)"
cd "$repo"
```

Run the substantive and packaging gates on Linux:

```bash
./test/landrun_wrapper_test.sh
systemd-run --user --wait --pipe --collect \
  --property="RestrictAddressFamilies=~AF_UNIX" \
  -E "PATH=$PATH" -E "HOME=$HOME" --working-directory="$(pwd)" \
  /usr/bin/bash -c 'test "$(id -u)" -ne 0; exec ./scripts/verify-comparator.sh'
lake update
git diff --exit-code -- lake-manifest.json
lake exe cache get
lake build
lake env lean Solution.lean
lake env lean ClassicalComplexWPT/Main.lean
lake env lean ClassicalComplexWPT/AxiomAudit.lean
if [ -x ./scripts/audit-lean-sources.sh ]; then
  ./scripts/audit-lean-sources.sh
else
  matches=$(rg -n '\b(sorry|admit|sorryAx|native_decide|Lean\.ofReduceBool|axiom|opaque|unsafe|extern)\b' \
    --glob '*.lean' --glob '!.lake/**' --glob '!docbuild/.lake/**' . || true)
  test "$matches" = './Challenge.lean:69:  sorry'
  test "$(sha256sum Challenge.lean | awk '{print $1}')" = \
    4f2f45a1d26d0c8409e03c85080ce905fbb987a4585c01bdd686d2b006733ef0
fi
ruby scripts/validate-formalization.rb
uvx --from 'check-jsonschema==0.38.0' check-jsonschema \
  --schemafile https://raw.githubusercontent.com/mathlib-initiative/formalization.yaml/main/schema/formalization.schema.json \
  formalization.yaml
user_gem_bin="$(ruby -e 'print Gem.user_dir')/bin"
gem install --user-install bundler -v 2.7.2
PATH="$user_gem_bin:$PATH" BUNDLE_PATH="$scratch/license-gems" \
  BUNDLE_FROZEN=true bundle install
PATH="$user_gem_bin:$PATH" BUNDLE_PATH="$scratch/license-gems" \
  bundle exec licensee detect LICENSE --json --no-packages --no-readme \
  > "$scratch/license.json"
ruby -rjson -e '
  ids = JSON.parse(File.read(ARGV.fetch(0))).fetch("licenses").map { |x| x.fetch("spdx_id") }
  abort "LICENSE is not exactly Apache-2.0" unless ids == ["Apache-2.0"]
' "$scratch/license.json"
(cd docbuild && MATHLIB_NO_CACHE_ON_UPDATE=1 lake update)
(git diff --exit-code -- docbuild/lake-manifest.json)
(cd docbuild && DISABLE_EQUATIONS=1 DOCGEN_SRC=file \
  lake build ClassicalComplexWPT:docs)
test -z "$(git status --porcelain=v1 --untracked-files=all)"
```

The final source scan should report only `Challenge.lean`'s deliberate theorem
hole:

`./scripts/audit-lean-sources.sh` prints that sole match and also asserts the
frozen `Challenge.lean` SHA-256.

## Human-only steps

Before submission, the responsible maintainer must:

1. inspect the immutable snapshot and all candid scope/fidelity disclosures;
2. confirm that the repository author and responsible-maintainer identity
   `BochaoKong` is correct and choose a project-owned public Git remote;
3. compare the final attestation commit to the verified content SHA and confirm
   that only the documented workflow/metadata/editorial files differ;
4. push the exact final attestation commit without modifying it;
5. confirm authorization to submit the substantive formalization;
6. decide whether to obtain external human mathematical/code review; and
7. complete the current Palomar authorization and submission process at
   <https://submit.palomar-registry.org/>.

Do not claim Palomar acceptance before the registry's actual review process.
