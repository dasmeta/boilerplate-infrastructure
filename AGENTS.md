# Customer Infrastructure-Management Template

## Role

This public repository is the tenant-neutral template for customer
infrastructure-management forks. Its canonical seed is
`boilerplate-infrastructure/`. `demo-infrastructure/` is non-authoritative
example material and must not be treated as customer intent or copied without
review.

A customer fork owns declared IaC intent, customer-specific operating context,
the selected IaC lifecycle, standards bindings, and execution evidence. This
repository is not an application-delivery orchestrator, Terraform module
library, asset-management product, generic governance repository, or secret
store.

The canonical seed's active YAML directories remain at
`boilerplate-infrastructure/{0-accounts,1-environments,2-products}/`.
Template updates must preserve these paths because customer forks and generated
workspace roots depend on them.

## Mandatory read order

1. This file and `AI-INDEX.md`.
2. Fork-local `WORKSPACE.md`, when present.
3. `config/customer-context.yaml` and `config/standards-binding.yaml`, when
   present, including readiness and binding status.
4. The active `metacloud.yaml`, relevant IaC YAML, and selected driver runbook.
5. `skills/infra-execution/SKILL.md` plus applicable skills named by the
   standards binding.

If bootstrap context is missing or `partial`, do not invent customer facts.
Read-only reasoning may continue from authorised evidence, but execution stops
when a required plane is `gap` or approval/access is not execution-ready.

## Sources of truth

- The selected asset-management system owns topology, ownership, service scope,
  and customer relationships. CloudBrowser is one supported adapter; another
  system may implement the same binding.
- Provider APIs own observed resource state.
- Git and IaC YAML own declared managed intent and review history.
- The selected IaC platform owns state, plans, runs, and execution evidence.
- Standards bindings own applicable policy, skills, approvals, and exceptions.

Compare these sources when they conflict. No one source silently overrides all
others.

## Authority and limits

- Fork-local IaC and non-secret customer bindings belong here.
- Application/platform delivery behavior belongs in its orchestrator. Map such
  stacks here; do not absorb their delivery configuration.
- Shared modules, drivers, generic skills, and cross-customer standards belong
  in Infra Governance or their owning repositories.
- Never commit tokens, passwords, private keys, copied cloud inventory, or
  private access instructions.
- Require explicit approval for shared `_.yaml`, backend/driver-wide defaults,
  account or environment scope, access, policy exceptions, `auto_apply`, and
  apply/destroy actions.

## Generated boundaries

Edit source YAML and directly related documentation. Never hand-edit
`_metacloud.tf`, `_terraform/`, `_terragrunt/`, state, or other generated
output. Terraform Cloud VCS-driven workspaces require reviewed `_terraform/`
delivery output in Git; Terramate and Terragrunt follow their own runbooks.

The committed `.agents/skills -> ../skills` symlink requires POSIX/Git symlink
support. Windows checkouts without symlink support are outside v1 support.
