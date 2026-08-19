# AI Index

## Canonical navigation

| Need | Canonical source |
| --- | --- |
| Repository role, authority, limits | `AGENTS.md` |
| Template/fork ownership | `docs/runbooks/template-fork-contract.md` |
| Development-orchestrator reuse boundary | `docs/runbooks/development-orchestrator-reuse.md` |
| Bootstrap procedure | `docs/runbooks/bootstrap-customer-context.md` |
| Customer context schema | `schemas/customer-context.schema.json` |
| Infrastructure source-index schema | `schemas/infrastructure-source-index.schema.json` |
| Bootstrap proposal schema | `schemas/bootstrap-proposal.schema.json` |
| Standards schema | `schemas/standards-binding.schema.json` |
| Customer overlay | `WORKSPACE.md`, `config/customer-context.yaml`, `config/infrastructure-source-index.json`, `config/standards-binding.yaml` |
| Driver choice | active `metacloud.yaml` |
| Terraform Cloud lifecycle | `docs/runbooks/terraform-cloud-compatibility.md` |
| Terramate lifecycle | `docs/runbooks/terramate.md` |
| Terragrunt lifecycle | `docs/runbooks/terragrunt.md` |
| Bounded IaC execution | `skills/infra-execution/SKILL.md` |
| Customer bootstrap/refresh | `skills/infrastructure-bootstrap/SKILL.md` |
| Proposal validation | `scripts/bootstrap/validate-proposal.sh` |
| Source-index validation | `scripts/bootstrap/validate-source-index.sh` |
| Canonical IaC root | repository root |
| Active YAML trees | `0-accounts/`, `1-environments/`, `2-products/` |

## Readiness vocabulary

Every management plane uses `bound`, `read-only`, `planned`,
`not-applicable`, or `gap`. Overall readiness is `context-ready`,
`execution-ready`, or `partial`.

- `context-ready`: required context can be loaded and compared.
- `execution-ready`: context plus access, standards, approvals, driver, and
  evidence paths are ready for the requested execution scope.
- `partial`: at least one required plane is planned, missing, stale, or a gap.

## Validation and generated output

Run `bash tests/test-template-foundation.sh` for upstream/template conformance.
Run `bash scripts/ci/run-template-tests.sh` for the complete reusable test
suite used by supported forge adapters.
In a fork, validate the configured root with
`meta validate-yaml --yaml-dir .` before generation.

`_metacloud.tf`, `_terraform/`, and `_terragrunt/` are generated and never
editing surfaces. Terraform Cloud may require `_terraform/` committed as a VCS
delivery artifact. Generated output is evidence of generation, not proof of a
successful remote apply.
