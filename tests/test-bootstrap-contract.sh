#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)"
VALIDATOR="$ROOT/scripts/bootstrap/validate-proposal.sh"
SOURCE_VALIDATOR="$ROOT/scripts/bootstrap/validate-source-index.sh"
EXAMPLE="$ROOT/templates/bootstrap/proposal.example.json"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/infrastructure-bootstrap-test.XXXXXX")"

cleanup() {
  rm -rf -- "$TMP_ROOT"
}
trap cleanup EXIT

test -f "$ROOT/schemas/bootstrap-proposal.schema.json"
test -f "$ROOT/schemas/infrastructure-source-index.schema.json"
test -f "$ROOT/config/infrastructure-source-index.json"
test -f "$EXAMPLE"
test -x "$VALIDATOR"
test -x "$SOURCE_VALIDATOR"

ruby "$ROOT/tests/validate-schema-example.rb" \
  "$ROOT/schemas/bootstrap-proposal.schema.json" \
  "$EXAMPLE"

"$VALIDATOR" --proposal "$EXAMPLE"
"$SOURCE_VALIDATOR" \
  --index "$ROOT/config/infrastructure-source-index.json" \
  --customer-context "$ROOT/config/customer-context.yaml"
jq -e 'all(.stack_mappings[]; has("source_id") and (has("repository") | not))' \
  < <(ruby -rjson -ryaml -e '
    data = YAML.safe_load(File.read(ARGV.fetch(0)), permitted_classes: [], aliases: true)
    puts JSON.generate(data)
  ' "$ROOT/config/customer-context.yaml") >/dev/null
jq '
  .status = "ready"
  | .unresolved_questions = []
' "$EXAMPLE" > "$TMP_ROOT/ready.json"

token="$("$VALIDATOR" --proposal "$TMP_ROOT/ready.json" --print-token)"
test "${#token}" -eq 64
printf '%s' "$token" | grep -Eq '^[a-f0-9]{64}$'

jq '
  .status = "approved"
  | .approval.confirmed = true
  | .approval.confirmed_at = "2026-08-19T00:00:00Z"
  | .approval.confirmed_by = "customer-platform-owner"
' "$TMP_ROOT/ready.json" > "$TMP_ROOT/approved.json"

approved_token="$("$VALIDATOR" --proposal "$TMP_ROOT/approved.json" --print-token)"
test "$approved_token" = "$token"

jq '.driver = "terragrunt"' "$TMP_ROOT/approved.json" > "$TMP_ROOT/changed-approved.json"
changed_token="$("$VALIDATOR" --proposal "$TMP_ROOT/changed-approved.json" --print-token)"
test "$changed_token" != "$token"

jq '
  .status = "approved"
  | .approval.confirmed = false
  | .unresolved_questions = ["Select the customer asset-management binding."]
' "$EXAMPLE" > "$TMP_ROOT/invalid-approved.json"

if "$VALIDATOR" --proposal "$TMP_ROOT/invalid-approved.json" >/dev/null 2>&1; then
  echo 'approved proposal with unresolved questions was accepted' >&2
  exit 1
fi

jq '.repositories[0].dependencies = ["missing_source"]' \
  "$ROOT/config/infrastructure-source-index.json" \
  > "$TMP_ROOT/invalid-source-index.json"

if "$SOURCE_VALIDATOR" \
  --index "$TMP_ROOT/invalid-source-index.json" \
  --customer-context "$ROOT/config/customer-context.yaml" \
  >/dev/null 2>&1; then
  echo 'source index with unknown dependency was accepted' >&2
  exit 1
fi

printf 'PASS: infrastructure bootstrap contract\n'
