#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
ROOT="$(CDPATH='' cd -- "$SCRIPT_DIR/../.." && pwd)"
PROPOSAL=""
PRINT_TOKEN=false

fail() {
  printf 'invalid infrastructure bootstrap proposal: %s\n' "$1" >&2
  exit 1
}

while test "$#" -gt 0; do
  case "$1" in
    --proposal)
      test "$#" -ge 2 || fail '--proposal requires a path'
      PROPOSAL="$2"
      shift 2
      ;;
    --print-token)
      PRINT_TOKEN=true
      shift
      ;;
    *)
      fail "unknown argument: $1"
      ;;
  esac
done

test -n "$PROPOSAL" || fail '--proposal is required'
test -f "$PROPOSAL" || fail "proposal does not exist: $PROPOSAL"
command -v jq >/dev/null 2>&1 || fail 'jq is required'
command -v ruby >/dev/null 2>&1 || fail 'ruby is required'

ruby "$ROOT/tests/validate-schema-example.rb" \
  "$ROOT/schemas/bootstrap-proposal.schema.json" \
  "$PROPOSAL" >/dev/null

expected_planes='["asset_service_context","change_delivery","iac_lifecycle","identity_access_secrets","knowledge_evidence","operational_assurance","resource_control","source_configuration","standards_policy_exceptions"]'

jq -e --argjson expected "$expected_planes" '
  ([.bindings[].plane] | sort) == $expected
  and ([.bindings[].plane] | length) == ([.bindings[].plane] | unique | length)
' "$PROPOSAL" >/dev/null || fail 'bindings must contain every management plane exactly once'

jq -e '
  if (.status == "ready" or .status == "approved")
  then (.unresolved_questions | length) == 0
  else true
  end
' "$PROPOSAL" >/dev/null || fail 'ready or approved proposals cannot have unresolved questions'

jq -e '
  if .status == "approved"
  then .approval.confirmed == true
    and (.approval.confirmed_at | type == "string" and length > 0)
    and (.approval.confirmed_by | type == "string" and length > 0)
  else .approval.confirmed == false
  end
' "$PROPOSAL" >/dev/null || fail 'approval fields do not match proposal status'

jq -e '
  if .target_readiness == "execution-ready"
  then all(.bindings[]; .status == "bound" or .status == "not-applicable")
  else true
  end
' "$PROPOSAL" >/dev/null || fail 'execution-ready requires every management plane to be bound or not-applicable'

if test "$PRINT_TOKEN" = true; then
  if command -v sha256sum >/dev/null 2>&1; then
    jq -S -c 'del(.approval) | .status = "ready"' "$PROPOSAL" | sha256sum | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    jq -S -c 'del(.approval) | .status = "ready"' "$PROPOSAL" | shasum -a 256 | awk '{print $1}'
  else
    fail 'sha256sum or shasum is required to print a token'
  fi
fi
