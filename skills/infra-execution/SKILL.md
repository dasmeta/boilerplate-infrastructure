---
name: infra-execution
description: Use for bounded infrastructure changes in a bootstrapped customer infrastructure-management fork.
---

# Infrastructure Execution

## Purpose

Translate an approved infrastructure request into a bounded, YAML-first change
in this customer fork. This skill operates existing customer context; it does
not bootstrap a customer, author shared Terraform modules, redefine governance,
or edit generated Terraform.

## Required context

Read `AGENTS.md`, `AI-INDEX.md`, fork-local `WORKSPACE.md`, active customer and
standards bindings, `metacloud.yaml`, and the selected driver runbook. Resolve
the relevant asset, provider, Git, IaC platform, standard, owner, and approval
bindings before editing.

Stop execution when readiness is `partial`, a required management plane is
`gap`, evidence is stale or conflicting, access is read-only for a write, or
the requested scope has no accountable owner. Read-only diagnosis may continue
when authorised, but must report its evidence limits.

## Boundaries

- Edit IaC YAML and directly related fork documentation only.
- Never hand-edit `_metacloud.tf`, `_terraform/`, `_terragrunt/`, state, or
  other generated output.
- Ask for explicit approval before changing shared `_.yaml`, driver/backend
  defaults, account/environment scope, policy exceptions, access, `auto_apply`,
  apply, or destroy.
- Never write secrets or copied customer inventory into Git or evidence.
- Route reusable module, driver, shared-skill, and cross-customer standard
  changes to their owning repositories.

## Module policy

Prefer DasMeta modules when they satisfy the requirement and customer standard.
Use approved, pinned alternatives only when their source, immutable version or
digest, maintenance owner, security/license posture, standards fit, and reason
are recorded. Availability is not approval.

## Workflow

1. Restate outcome, environment, affected assets/stacks, risk, and requested
   execution level.
2. Load bindings and compare asset-management, provider, IaC-platform, Git, and
   standards evidence. Report conflicts rather than choosing silently.
3. Resolve only high-impact missing context: exposure/access, data sensitivity,
   recovery, scale/cost, monitoring, ownership, and approval.
4. Select a compliant module and target YAML; record low-risk assumptions.
5. Edit source YAML and directly related documentation. Keep cross-workspace
   links explicit.
6. Run `meta validate-yaml` before generation.
7. Regenerate and validate through the selected driver. Review generated output
   but never edit it.
8. Plan/apply only within confirmed authority, then collect remote execution
   evidence separately.

## Driver routing

- Terraform Cloud/TFE: use
  `docs/runbooks/terraform-cloud-compatibility.md`; VCS-driven generated output
  is committed after review and the remote HCP run is checked separately.
- Terramate: use `docs/runbooks/terramate.md` and scope plan/apply to approved
  stacks.
- Terragrunt: use `docs/runbooks/terragrunt.md` and scope plan/apply to approved
  units.

## Completion report

Report changed intent, module decision/provenance, context sources/freshness,
assumptions, approvals, local validation, generation, remote run evidence, and
remaining risks. If stopped, identify the exact missing binding, approval,
evidence, or module gap and next action.
