#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)"
SEED="$ROOT"
META_BIN="${META_BIN:-meta}"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

require_file() {
  test -f "$1" || fail "missing required file: ${1#"$ROOT"/}"
}

validate_fixture() {
  local fixture_source="$1"
  local fixture_tmp
  local fixture
  local relative_path
  local target_path

  fixture_tmp="$(mktemp -d "${TMPDIR:-/tmp}/boilerplate-fixture.XXXXXX")"

  while IFS= read -r fixture; do
    relative_path="${fixture#"$fixture_source"/}"
    target_path="$fixture_tmp/${relative_path%.fixture}"
    mkdir -p "$(dirname "$target_path")"
    cp "$fixture" "$target_path"
  done < <(find "$fixture_source" -type f -name '*.fixture' -print)

  if ! "$META_BIN" validate-yaml --yaml-dir "$fixture_tmp"; then
    rm -rf -- "$fixture_tmp"
    fail "fixture validation failed: ${fixture_source#"$ROOT"/}"
  fi
  rm -rf -- "$fixture_tmp"
}

render_terraform_cloud_fixture() {
  local fixture_path="$1"
  local meta_path
  local meta_real_path
  local meta_root

  if [[ "$META_BIN" == */* ]]; then
    meta_path="$META_BIN"
  else
    meta_path="$(command -v "$META_BIN")"
  fi

  meta_real_path="$(ruby -e 'puts File.realpath(ARGV.fetch(0))' "$meta_path")"
  meta_root="$(CDPATH='' cd -- "$(dirname -- "$meta_real_path")/.." && pwd)"

  node - "$meta_root" "$fixture_path" <<'NODE'
const path = require('node:path');
const fs = require('node:fs');
const metaRoot = process.argv[2];
const fixturePath = process.argv[3];
const {parse} = require(require.resolve('yaml', {paths: [metaRoot]}));
const {normalizeMetaCloudConfig, generateTerraformCloudTF} = require(path.join(metaRoot, 'dist', 'utils.js'));
const config = normalizeMetaCloudConfig(parse(fs.readFileSync(fixturePath, 'utf8')));

process.stdout.write(generateTerraformCloudTF(config));
NODE
}

for path in \
  AGENTS.md \
  AI-INDEX.md \
  README.md \
  WORKSPACE.md \
  .gitignore \
  metacloud.yaml \
  docs/runbooks/bootstrap-customer-context.md \
  docs/runbooks/development-orchestrator-reuse.md \
  docs/runbooks/template-fork-contract.md \
  docs/runbooks/terraform-cloud-compatibility.md \
  docs/runbooks/terramate.md \
  docs/runbooks/terragrunt.md \
  schemas/customer-context.schema.json \
  schemas/infrastructure-source-index.schema.json \
  schemas/standards-binding.schema.json \
  config/customer-context.yaml \
  config/infrastructure-source-index.json \
  config/standards-binding.yaml \
  schemas/bootstrap-proposal.schema.json \
  skills/infra-execution/SKILL.md \
  skills/infra-execution/PROVENANCE.md \
  skills/infrastructure-bootstrap/SKILL.md \
  skills/infrastructure-bootstrap/PROVENANCE.md \
  scripts/bootstrap/validate-proposal.sh \
  scripts/bootstrap/validate-source-index.sh \
  scripts/ci/run-template-tests.sh \
  .github/workflows/template-contract.yml \
  .gitlab-ci.yml \
  bitbucket-pipelines.yml \
  tests/fixtures/terraform-cloud/current/metacloud.yaml.fixture \
  tests/fixtures/terraform-cloud/current/version-contract.json \
  tests/fixtures/terraform-cloud/legacy-without-driver/metacloud.yaml.fixture
do
  require_file "$ROOT/$path"
done

test -L "$ROOT/.agents/skills" || fail '.agents/skills must be a symlink'
test "$(readlink "$ROOT/.agents/skills")" = '../skills' || fail '.agents/skills must target ../skills'

jq empty "$ROOT/schemas/customer-context.schema.json"
jq empty "$ROOT/schemas/standards-binding.schema.json"
ruby "$ROOT/tests/validate-schema-example.rb" \
  "$ROOT/schemas/customer-context.schema.json" \
  "$ROOT/config/customer-context.yaml"
ruby "$ROOT/tests/validate-schema-example.rb" \
  "$ROOT/schemas/standards-binding.schema.json" \
  "$ROOT/config/standards-binding.yaml"
ruby "$ROOT/tests/validate-schema-example.rb" \
  "$ROOT/schemas/infrastructure-source-index.schema.json" \
  "$ROOT/config/infrastructure-source-index.json"

grep -Fq '0-accounts/' "$ROOT/AGENTS.md"
grep -Fq 'metacloud.yaml' "$ROOT/README.md"
grep -Fq 'populate' "$ROOT/skills/infrastructure-bootstrap/SKILL.md"
grep -Fq 'must not move' "$ROOT/skills/infrastructure-bootstrap/SKILL.md"

test ! -f "$SEED/_metacloud.tf" || fail 'canonical _metacloud.tf must be generated, not committed'
grep -Fqx 'driver: terraform-cloud' "$SEED/metacloud.yaml"
grep -Fq 'handler_version: "~> 2.5.0"' "$SEED/metacloud.yaml"
grep -Fqx 'yaml_dir: .' "$SEED/metacloud.yaml"
grep -Fqx 'git_branch: main' "$SEED/metacloud.yaml"
grep -Fqx 'git_enabled: true' "$SEED/metacloud.yaml"
grep -Fiq 'schema-backed bootstrap' "$SEED/README.md"
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
test ! -d "$ROOT/boilerplate-infrastructure" || fail 'canonical IaC must not be nested under boilerplate-infrastructure/'
test ! -d "$ROOT/demo-infrastructure" || fail 'demo YAML must not be inside the live root discovery tree'
test ! -f "$ROOT/WORKSPACE.example.md" || fail 'bootstrap must populate WORKSPACE.md in place'
test ! -f "$ROOT/config/customer-context.example.yaml" || fail 'bootstrap must populate customer-context.yaml in place'
test ! -f "$ROOT/config/standards-binding.example.yaml" || fail 'bootstrap must populate standards-binding.yaml in place'
test ! -f "$ROOT/metacloud.example.yaml" || fail 'bootstrap must populate metacloud.yaml in place'
if find "$ROOT/tests" -type f -name '*.yaml' -print | grep -q .; then
  fail 'test fixtures must not be discoverable as live root YAML'
fi
grep -Fq 'scripts/ci/run-template-tests.sh' "$ROOT/.github/workflows/template-contract.yml"
grep -Fq 'scripts/ci/run-template-tests.sh' "$ROOT/.gitlab-ci.yml"
grep -Fq 'scripts/ci/run-template-tests.sh' "$ROOT/bitbucket-pipelines.yml"
if grep -Eq 'for command_name .* rg([[:space:]]|;)' "$ROOT/scripts/ci/run-template-tests.sh"; then
  fail 'template test runner must not require ripgrep'
fi
for ci_file in \
  "$ROOT/.github/workflows/template-contract.yml" \
  "$ROOT/.gitlab-ci.yml" \
  "$ROOT/bitbucket-pipelines.yml"
do
  if grep -Fq 'ripgrep' "$ci_file"; then
    fail "CI must not install unused ripgrep dependency: ${ci_file#"$ROOT"/}"
  fi
done
test ! -e "$ROOT/.gitlab-ci.yaml" || fail '.gitlab-ci.yaml conflicts with GitLab default .gitlab-ci.yml entrypoint'
test ! -e "$ROOT/.github.yaml" || fail 'empty .github.yaml placeholder must not be shipped'
test ! -e "$ROOT/.bitbucket.yaml" || fail 'empty .bitbucket.yaml placeholder must not be shipped'
ruby -ryaml -e '
  pipeline = YAML.safe_load(File.read(ARGV.fetch(0)), permitted_classes: [], aliases: true)
  abort "missing template-contract job" unless pipeline.key?("template-contract")
  abort "missing infrastructure apply job" unless pipeline.key?("apply")
  abort "apply must run after validation" unless pipeline.fetch("apply").fetch("stage") == "apply"
' "$ROOT/.gitlab-ci.yml"
for ci_file in \
  "$ROOT/.github/workflows/template-contract.yml" \
  "$ROOT/.gitlab-ci.yml" \
  "$ROOT/bitbucket-pipelines.yml"
do
  grep -Fq '@dasmeta/meta-cli@0.0.16' "$ci_file" || \
    fail "CI must use the documented meta-cli floor: ${ci_file#"$ROOT"/}"
done
ruby -ryaml -e '
  ARGV.each { |path| YAML.safe_load(File.read(path), permitted_classes: [], aliases: true) }
' \
  "$ROOT/.github/workflows/template-contract.yml" \
  "$ROOT/.gitlab-ci.yml" \
  "$ROOT/bitbucket-pipelines.yml"

if grep -REn "passwordTerraform12|db_password:[[:space:]]*[\"'][^$]" \
  "$SEED/0-accounts" \
  "$SEED/1-environments" \
  "$SEED/2-products" \
  "$SEED/config" \
  "$SEED/metacloud.yaml"; then
  fail 'secret-like database password remains in canonical seed'
fi

test "$(jq -r '.driver_management.required_version' "$ROOT/tests/fixtures/terraform-cloud/current/version-contract.json")" = '~> 1.8'
test "$(jq -r '.generated_workspace.required_version' "$ROOT/tests/fixtures/terraform-cloud/current/version-contract.json")" = '>= 1.8.0'
test "$(jq -r '.hcp_executor.follows' "$ROOT/tests/fixtures/terraform-cloud/current/version-contract.json")" = 'independent'

validate_fixture "$ROOT/tests/fixtures/terraform-cloud/current"
validate_fixture "$ROOT/tests/fixtures/terraform-cloud/legacy-without-driver"
rendered_tfe="$(render_terraform_cloud_fixture "$ROOT/tests/fixtures/terraform-cloud/current/metacloud.yaml.fixture")"
printf '%s\n' "$rendered_tfe" | grep -Fq 'git_branch   = "main"' || \
  fail 'current Terraform Cloud fixture does not render git_branch'
printf '%s\n' "$rendered_tfe" | grep -Fq 'git_enabled  = true' || \
  fail 'current Terraform Cloud fixture does not render git_enabled'
"$META_BIN" validate-yaml --yaml-dir "$SEED"

printf 'PASS: template foundation contract\n'
