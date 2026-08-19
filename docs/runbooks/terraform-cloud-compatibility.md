# Terraform Cloud/TFE Compatibility

## Baseline

New forks use explicit `driver: terraform-cloud`; legacy configuration without
`driver` still resolves to Terraform Cloud. Require `meta-cli >= 0.0.16` and
the `dasmeta/cloud/tfe` 2.5 release line (current reviewed baseline: v2.5.10).
`meta init` generates `_metacloud.tf`; never maintain it by hand.

## Three version controls

1. The TFE driver management workspace requires Terraform `~> 1.8`.
2. Each generated workspace has its own YAML `terraform_version` constraint.
3. The HCP workspace executor version is an independent organisation/workspace
   binding and otherwise inherits the organisation default.

The driver aligns loader and renderer internals at 1.2.2. Forks do not pin those
internal components separately.

## Current YAML behavior

- A setup needs `source` and `version` to become a workspace.
- Shared `_.yaml` is supported and is approval-sensitive shared scope.
- Prefer name-based `variable_sets`; `variable_set_ids` remains legacy support.
- Explicit `linked_workspaces` and `${workspace.path.output}` references are
  supported; directory names do not infer dependencies.
- `workspace.agent_pool_name` overrides an enabled shared pool default.
- TFE token and AWS variable sets are enabled by default; meta-cli 0.0.15
  supports their configured opt-outs.
- `auto_apply` is supported and requires explicit approval.
- `git_branch` selects the VCS branch explicitly; omit it to use the repository
  default branch.
- `git_enabled` controls whether the TFE module manages the VCS connection; set
  it to false when that integration is managed outside this repository.

## Lifecycle

1. Load execution-ready customer context and approvals.
2. Run `meta exec`, then `meta init` when driver inputs changed.
3. Run `meta validate-yaml` against the configured YAML root.
4. Apply the generated management workspace only with explicit authority.
5. Review generated `_terraform/` output.
6. For VCS-driven HCP workspaces, commit it with the source YAML.
7. Confirm the remote HCP plan/apply separately.

Local generation is not remote execution evidence.
