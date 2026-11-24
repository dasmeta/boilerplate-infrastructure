#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT
lookup="$root/scripts/bootstrap/delivery-bindings.rb"
proposal="$tmp/proposal.json"
context="$tmp/context.json"
validate="$root/scripts/bootstrap/validate-proposal.sh"
base="$root/templates/bootstrap/proposal.example.json"
cat > "$tmp/record.json" <<'JSON'
{"name":"release_checks","scope":"prod/example","owner":"service-ops","status":"bound","provider":"git","locator":"checks/smoke","operation":"read","connector":"git","release":"2.54.0"}
JSON
jq --slurpfile records "$tmp/record.json" '
  .status="approved" | .unresolved_questions=[] | .approval={confirmed:true,confirmed_by:"ops",confirmed_at:"example"}
  | (.bindings[] | select(.plane=="operational_assurance")) += {status:"bound",capabilities:$records}
' "$base" > "$proposal"
ruby -ryaml -rjson -e 'puts JSON.generate(YAML.safe_load(File.read(ARGV[0])))' "$root/config/customer-context.yaml" > "$tmp/base.json"
jq --slurpfile records "$tmp/record.json" '
  .readiness="context-ready" | .management_planes.operational_assurance += {status:"bound",capabilities:$records}
' "$tmp/base.json" > "$context"

lookup_row() {
  local expected="$1"
  shift
  local rc=0
  ruby "$lookup" --context "$context" --proposal "$proposal" "$@" > "$tmp/report" || rc=$?
  test "$rc" -eq 2  # the other capabilities are deliberately missing
  jq -e --arg expected "$expected" '.capabilities[] | select(.name=="release_checks") | .status==$expected' "$tmp/report" >/dev/null
}
lookup_row configured --scope prod/example
lookup_row gap --scope stage/example
token="$("$validate" --proposal "$proposal" --print-token)"
jq '(.bindings[] | select(.plane=="operational_assurance").capabilities[0].provider)="alternate"' "$proposal" > "$tmp/change"
mv "$tmp/change" "$proposal"
test "$token" != "$("$validate" --proposal "$proposal" --print-token)"
lookup_row gap --scope prod/example
lookup_row proposed --scope prod/example --preview
jq '.management_planes.operational_assurance.capabilities[0].provider="alternate"' "$context" > "$tmp/change"
mv "$tmp/change" "$context"
lookup_row configured --scope prod/example
for state in disabled stale; do
  jq --arg state "$state" '(.bindings[] | select(.plane=="operational_assurance").capabilities[0]) += {status:$state,reason:"owner review"}' "$proposal" > "$tmp/change"
  mv "$tmp/change" "$proposal"
  lookup_row "$state" --scope prod/example --preview
done
jq '(.bindings[] | select(.plane=="operational_assurance").capabilities) |= (. + .)' "$proposal" > "$tmp/bad"
if "$validate" --proposal "$tmp/bad" >/dev/null 2>&1; then exit 1; fi
jq '(.bindings[] | select(.plane=="operational_assurance").capabilities[0]) += {status:"bound",release:"latest"}' "$proposal" > "$tmp/bad"
if "$validate" --proposal "$tmp/bad" >/dev/null 2>&1; then exit 1; fi
# A complete proposal populates all eight scoped records without connector calls.
jq --slurpfile records "$tmp/record.json" '
  {change_delivery:["request","announcement_destination"],asset_service_context:["service_inventory"],
   source_configuration:["target_environment","declared_version"],resource_control:["observed_version"],
   operational_assurance:["release_checks"],knowledge_evidence:["infrastructure_docs"]} as $catalog
  | .bindings |= map(. as $plane | .status="bound" | .capabilities=(
      [$catalog[$plane.plane][]? | . as $name | $records[0] + {name:$name}]))
' "$proposal" > "$tmp/full"
mv "$tmp/full" "$proposal"
jq --slurpfile proposals "$proposal" '
  .readiness="context-ready" |
  reduce $proposals[0].bindings[] as $plane (.;
    .management_planes[$plane.plane] += {status:$plane.status,capabilities:$plane.capabilities})
' "$tmp/base.json" > "$context"
ruby "$lookup" --context "$context" --proposal "$proposal" --scope prod/example > "$tmp/report"
jq -e '(.capabilities|length)==8 and all(.capabilities[]; .status=="configured")' "$tmp/report" >/dev/null
jq '.status="ready" | .approval.confirmed=false' "$proposal" > "$tmp/change"
mv "$tmp/change" "$proposal"
lookup_row gap --scope prod/example
cp "$tmp/base.json" "$context"
lookup_row gap --scope prod/example
echo "PASS: scoped routine-upgrade bindings"
