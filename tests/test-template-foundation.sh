#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)"
SEED="$ROOT/boilerplate-infrastructure"
META_BIN="${META_BIN:-meta}"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

require_file() {
  test -f "$1" || fail "missing required file: ${1#"$ROOT"/}"
}

for path in \
  AGENTS.md \
  AI-INDEX.md \
  README.md \
  WORKSPACE.example.md \
  docs/runbooks/bootstrap-customer-context.md \
  docs/runbooks/template-fork-contract.md \
  docs/runbooks/terraform-cloud-compatibility.md \
  docs/runbooks/terramate.md \
  docs/runbooks/terragrunt.md \
  schemas/customer-context.schema.json \
  schemas/standards-binding.schema.json \
  config/customer-context.example.yaml \
  config/standards-binding.example.yaml \
  skills/infra-execution/SKILL.md \
  skills/infra-execution/PROVENANCE.md \
  tests/fixtures/terraform-cloud/current/metacloud.yaml \
  tests/fixtures/terraform-cloud/current/version-contract.json \
  tests/fixtures/terraform-cloud/legacy-without-driver/metacloud.yaml
do
  require_file "$ROOT/$path"
done

test -L "$ROOT/.agents/skills" || fail '.agents/skills must be a symlink'
test "$(readlink "$ROOT/.agents/skills")" = '../skills' || fail '.agents/skills must target ../skills'

jq empty "$ROOT/schemas/customer-context.schema.json"
jq empty "$ROOT/schemas/standards-binding.schema.json"
ruby "$ROOT/tests/validate-schema-example.rb" \
  "$ROOT/schemas/customer-context.schema.json" \
  "$ROOT/config/customer-context.example.yaml"
ruby "$ROOT/tests/validate-schema-example.rb" \
  "$ROOT/schemas/standards-binding.schema.json" \
  "$ROOT/config/standards-binding.example.yaml"

grep -Fq 'boilerplate-infrastructure/' "$ROOT/AGENTS.md"
grep -Fq 'demo-infrastructure/' "$ROOT/AGENTS.md"
grep -Fq 'boilerplate-infrastructure/' "$ROOT/README.md"
grep -Fq 'CloudBrowser is one supported adapter' "$ROOT/AGENTS.md"
grep -Fq 'Prefer DasMeta modules' "$ROOT/skills/infra-execution/SKILL.md"
grep -Fq 'approved, pinned alternatives' "$ROOT/skills/infra-execution/SKILL.md"
grep -Fq 'meta-cli >= 0.0.16' "$ROOT/docs/runbooks/terraform-cloud-compatibility.md"
grep -Fqx 'git_branch: main' "$ROOT/tests/fixtures/terraform-cloud/current/metacloud.yaml"
grep -Fqx 'git_enabled: true' "$ROOT/tests/fixtures/terraform-cloud/current/metacloud.yaml"
grep -Fq 'discard both generated sides' "$ROOT/docs/runbooks/template-fork-contract.md"

test ! -f "$SEED/_metacloud.tf" || fail 'canonical _metacloud.tf must be generated, not committed'
grep -Fqx 'driver: terraform-cloud' "$SEED/metacloud.example.yaml"
grep -Fq 'handler_version: "~> 2.5.0"' "$SEED/metacloud.example.yaml"
grep -Fqx 'yaml_dir: .' "$SEED/metacloud.example.yaml"
grep -Fqx 'git_branch: main' "$SEED/metacloud.example.yaml"
grep -Fqx 'git_enabled: true' "$SEED/metacloud.example.yaml"
grep -Fq 'schema-backed bootstrap' "$SEED/README.md"
if grep -Fq 'Set right values in _metacloud.tf' "$SEED/README.md"; then
  fail 'canonical README must not instruct hand-editing generated bootstrap HCL'
fi
git -C "$SEED" check-ignore --no-index -q _metacloud.tf || fail '_metacloud.tf must be ignored'
if git -C "$SEED" check-ignore --no-index -q _terraform/example.tf; then
  fail '_terraform must remain committable for VCS-driven Terraform Cloud'
fi

for root_yaml_path in 0-accounts 1-environments 2-products; do
  test -d "$SEED/$root_yaml_path" || fail "$root_yaml_path must remain at the canonical seed root"
done
test ! -d "$SEED/examples/legacy-yaml" || fail 'root YAML directories must not be moved under examples'
grep -Fqi 'non-authoritative' "$ROOT/demo-infrastructure/README.md"

if rg -n "passwordTerraform12|db_password:[[:space:]]*[\"'][^$]" "$SEED"; then
  fail 'secret-like database password remains in canonical seed'
fi

test "$(jq -r '.driver_management.required_version' "$ROOT/tests/fixtures/terraform-cloud/current/version-contract.json")" = '~> 1.8'
test "$(jq -r '.generated_workspace.required_version' "$ROOT/tests/fixtures/terraform-cloud/current/version-contract.json")" = '>= 1.8.0'
test "$(jq -r '.hcp_executor.follows' "$ROOT/tests/fixtures/terraform-cloud/current/version-contract.json")" = 'independent'

"$META_BIN" validate-yaml --yaml-dir "$ROOT/tests/fixtures/terraform-cloud/current"
"$META_BIN" validate-yaml --yaml-dir "$ROOT/tests/fixtures/terraform-cloud/legacy-without-driver"
"$META_BIN" validate-yaml --yaml-dir "$SEED"

printf 'PASS: template foundation contract\n'
