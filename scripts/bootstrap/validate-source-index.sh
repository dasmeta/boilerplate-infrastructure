#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
ROOT="$(CDPATH='' cd -- "$SCRIPT_DIR/../.." && pwd)"
INDEX="$ROOT/config/infrastructure-source-index.json"
CUSTOMER_CONTEXT="$ROOT/config/customer-context.yaml"

fail() {
  printf 'invalid infrastructure source index: %s\n' "$1" >&2
  exit 1
}

while test "$#" -gt 0; do
  case "$1" in
    --index)
      test "$#" -ge 2 || fail '--index requires a path'
      INDEX="$2"
      shift 2
      ;;
    --customer-context)
      test "$#" -ge 2 || fail '--customer-context requires a path'
      CUSTOMER_CONTEXT="$2"
      shift 2
      ;;
    *)
      fail "unknown argument: $1"
      ;;
  esac
done

test -f "$INDEX" || fail "index does not exist: $INDEX"
test -f "$CUSTOMER_CONTEXT" || fail "customer context does not exist: $CUSTOMER_CONTEXT"
command -v jq >/dev/null 2>&1 || fail 'jq is required'
command -v ruby >/dev/null 2>&1 || fail 'ruby is required'

ruby "$ROOT/tests/validate-schema-example.rb" \
  "$ROOT/schemas/infrastructure-source-index.schema.json" \
  "$INDEX" >/dev/null

jq -e '
  ([.repositories[].id] | length) == ([.repositories[].id] | unique | length)
' "$INDEX" >/dev/null || fail 'repository IDs must be unique'

jq -e '
  ([.repositories[].id]) as $ids
  | ([.repositories[].dependencies[]] - $ids | length) == 0
' "$INDEX" >/dev/null || fail 'dependencies must reference configured repository IDs'

context_customer_id="$(ruby -ryaml -e '
  data = YAML.safe_load(File.read(ARGV.fetch(0)), permitted_classes: [], aliases: true)
  print data.fetch("customer").fetch("id")
' "$CUSTOMER_CONTEXT")"
context_source_ids="$(ruby -rjson -ryaml -e '
  data = YAML.safe_load(File.read(ARGV.fetch(0)), permitted_classes: [], aliases: true)
  print JSON.generate(data.fetch("stack_mappings").map { |mapping| mapping.fetch("source_id") })
' "$CUSTOMER_CONTEXT")"
index_customer_id="$(jq -r '.customer_id' "$INDEX")"

test "$context_customer_id" = "$index_customer_id" || \
  fail 'customer_id must match config/customer-context.yaml'

jq -e --argjson referenced "$context_source_ids" '
  ([.repositories[].id]) as $ids
  | ($referenced - $ids | length) == 0
' "$INDEX" >/dev/null || fail 'stack mappings must reference configured repository IDs'
