# Contributing

Contributions that simplify, generalize, document, or independently audit this
formalization are welcome. The public theorem statement is frozen: do not edit
`Challenge.lean` without first explaining the semantic change, updating
`STATEMENT_AUDIT.md`, and obtaining a fresh independent statement audit.

## Local checks

Use the pinned Lean toolchain and committed manifests. From the repository root:

```bash
lake update
lake exe cache get
lake build
lake env lean ClassicalComplexWPT/AxiomAudit.lean
./scripts/audit-lean-sources.sh
ruby scripts/validate-formalization.rb
./test/landrun_wrapper_test.sh
```

Build the API documentation with:

```bash
(cd docbuild && MATHLIB_NO_CACHE_ON_UPDATE=1 lake update)
(cd docbuild && DISABLE_EQUATIONS=1 DOCGEN_SRC=file \
  lake build ClassicalComplexWPT:docs)
```

The authoritative Challenge/Solution comparison additionally needs Linux,
Git, Go, Rust/Cargo, Python, and a functioning Landlock sandbox. Run it as an
unprivileged user under the systemd address-family guard documented in
`VERIFICATION.md`.

## Pull-request expectations

- Keep the theorem dependency closure Mathlib-only.
- Do not add `sorry`, `admit`, custom axioms, opaque proof escapes, unsafe
  proof code, generated `.olean` files, `.lake` directories, downloaded
  binaries, or caches.
- Compile every changed Lean module and add focused consumers for edge cases
  or delicate API behavior.
- Preserve ordinary Archimedean norm estimates; nonarchimedean or ultrametric
  shortcuts are invalid for this theorem over `ℂ`.
- Update the lemma ledger, approach registry, README, metadata, and verification
  record whenever a change affects their claims.
- Describe any external code or proof that materially influenced the change,
  including its immutable revision and license.

No contribution should claim external review, Palomar acceptance, or registry
status that has not actually occurred.
