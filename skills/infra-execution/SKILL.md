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

Run [delivery-stage tracking](../../docs/runbooks/bootstrap-customer-context.md#delivery-change-tracking)
as part of this workflow. Once the Jira work item qualifies, save and sync
the opening event. After each material stage outcome, call the same step
again with that outcome. A pending Announcement update does not hold up the
next stage.

1. Restate outcome, environment, affected assets/stacks, risk, and requested
   execution level. Save the opening event once the priority and expected
   window are established.
2. Load bindings and compare asset-management, provider, IaC-platform, Git, and
   standards evidence. Record the assessment, risk, conflicts, and any
   no-change or handoff decision.
3. Resolve only high-impact missing context: exposure/access, data sensitivity,
   recovery, scale/cost, monitoring, ownership, and approval.
4. Select a compliant module and target YAML. Record the plan, scope,
   low-risk assumptions, and relevant version-specific guidance.
5. Edit source YAML and directly related documentation. Keep cross-workspace
   links explicit.
6. Run `meta validate-yaml` before generation.
7. Regenerate and validate through the selected driver. Review generated output
   but never edit it. Record the reviewed revision, verification plan, and
   the disposition of any required check that cannot be run.
8. Apply the delivery risk policy. Record each required approval, schedule
   decision, agreement, and communication when its evidence is available.
9. Plan or apply only within confirmed authority. Save the actual attempt
   start as soon as the IaC platform provides it. Capture the outcome and
   remote run evidence separately, including interrupted or partial attempts.
   On resume, read the bound IaC platform for the actual attempt state before
   recording missing evidence or proceeding with any authorized new action.
10. Verify service health. Save the actual verification outcome, recovery
    actions, and escalation or reapproval where applicable.
11. Save the final disposition and reconcile the Announcement on completed,
    canceled, handed-off, and failed paths when tracking has started. A
    postponement records the reason and any new expected window.

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
remaining risks. Include the Announcement ID and sync outcome, with a Jira
gap if records still need to be synchronized. If stopped, identify the exact
missing binding, approval, evidence, or module gap and next action.
