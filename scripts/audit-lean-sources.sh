#!/usr/bin/env bash
set -euo pipefail

repository_root=$(cd "$(dirname "$0")/.." && pwd)
cd "$repository_root"

matches=$(python3 <<'PY'
import pathlib
import re

pattern = re.compile(
    r"\b(sorry|admit|sorryAx|native_decide|Lean\.ofReduceBool|axiom|opaque|unsafe|extern)\b"
)
for path in sorted(pathlib.Path(".").rglob("*.lean")):
    if any(part.startswith(".") for part in path.parts):
        continue
    for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        if pattern.search(line):
            print(f"./{path}:{line_number}:{line}")
PY
)
expected='./Challenge.lean:69:  sorry'

if [ "$matches" != "$expected" ]; then
  echo "error: Lean escape-hatch scan differs from the frozen expected surface" >&2
  if [ -n "$matches" ]; then
    printf '%s\n' "$matches" >&2
  else
    echo "(no matches)" >&2
  fi
  exit 1
fi

if command -v shasum >/dev/null 2>&1; then
  challenge_hash=$(shasum -a 256 Challenge.lean | awk '{print $1}')
else
  challenge_hash=$(sha256sum Challenge.lean | awk '{print $1}')
fi
expected_hash=4f2f45a1d26d0c8409e03c85080ce905fbb987a4585c01bdd686d2b006733ef0
if [ "$challenge_hash" != "$expected_hash" ]; then
  echo "error: frozen Challenge.lean hash changed" >&2
  echo "expected: $expected_hash" >&2
  echo "actual:   $challenge_hash" >&2
  exit 1
fi

printf '%s\n' "$matches"
echo "Lean source scan and frozen Challenge hash passed"
