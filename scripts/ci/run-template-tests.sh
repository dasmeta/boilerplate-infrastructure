#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
ROOT="$(CDPATH='' cd -- "$SCRIPT_DIR/../.." && pwd)"
META_BIN="${META_BIN:-meta}"

for command_name in git jq rg ruby; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'required template-test command is unavailable: %s\n' "$command_name" >&2
    exit 1
  fi
done

if [[ "$META_BIN" == */* ]]; then
  test -x "$META_BIN" || {
    printf 'configured meta executable is unavailable: %s\n' "$META_BIN" >&2
    exit 1
  }
elif ! command -v "$META_BIN" >/dev/null 2>&1; then
  printf 'required template-test command is unavailable: %s\n' "$META_BIN" >&2
  exit 1
fi
export META_BIN

completed=0
for test_file in "$ROOT"/tests/test-*.sh; do
  test -f "$test_file" || continue
  relative_path="${test_file#"$ROOT"/}"
  printf '==> %s\n' "$relative_path"
  bash "$test_file"
  completed=$((completed + 1))
done

test "$completed" -gt 0 || {
  printf 'no template tests found\n' >&2
  exit 1
}

printf 'Completed %s template test files.\n' "$completed"
