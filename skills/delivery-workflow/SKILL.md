---
name: delivery-workflow
description: Use to run an infrastructure change end to end from a Jira ticket to verified, documented closure, with risk-based controls and an evidence package. Wraps infra-execution for the edit and apply steps.
---

# Delivery Workflow

## Purpose

One standard path from "someone asks for an infrastructure change" to "it is
done, verified, and documented". AI does the routine work; people make the
decisions. Small changes stay fast; risky ones get more care. Rationale and
gaps are in `docs/plans/DMVP-10650-delivery-platform-planning.md`.

This skill sequences the work. The YAML edit, validation, generation, and
apply steps follow `skills/infra-execution/SKILL.md` and the selected driver
runbook; this skill does not replace them. Its stop rules apply here too:
stop when readiness is `partial`, a required plane is `gap`, or access or
approval is not execution-ready.

## Rules that always apply

- Start from a Jira ticket. Jira is the index of the change; it links to the
  real evidence and does not replace it.
- Production changes need human approval for this exact plan, scope,
  environment, and version. AI instructions are not enforcement. Do not use or
  request new AI production access for this workflow.
- The executor of an Elevated or Critical change is never its only approver.
- Silence, a missing response, a status such as "Scheduled", or "deployed
  successfully" is never approval or validation.
- Never put secrets, customer inventory, or personal data in tickets,
  announcements, or evidence. Send customer data to a model only as the
  `ai_processing` binding in `config/customer-context.yaml` allows.

## Steps

1. **Ticket.** Confirm the ticket states outcome, environment, and owner.
2. **Diagnose.** Gather what is deployed, versions, and health from the bound
   systems, read-only. If no change is needed, record the finding and hand off.
3. **Rate risk.** Rate each aspect `None`, `Low`, `Medium`, or `High` with a
   one-line reason, then set the level (below).
4. **Plan.** List the YAML edits, steps, and recovery path. New components use
   the newest compatible module release, not a version copied from an older
   setup. A module upgrade follows the change contract published by the module
   repository. Check the module's release notes before choosing a version.
5. **Prepare validation.** Find existing tests and checks and where they run.
   Record gaps. Agree the evidence that shows the result is satisfactory.
   If a required test is missing or failing, exactly one applies before
   execution: an approved alternative validation, explicit risk acceptance by
   someone authorized for that level, or the change is blocked.
6. **Approve and announce.** Standard: PR review. Elevated and Critical: a
   named approver, separate from the executor, approves the plan. Link a
   CloudBrowser Maintenance announcement to the ticket where the level requires
   one. If the integration is unavailable, record that and use the bound
   fallback; do not skip communication silently.
7. **Execute** through the selected driver, within the approved scope.
8. **Verify.** Check that the service works, not only that the apply passed.
   If it does not, recover (below).
9. **Document.** Update the customer's infrastructure documentation from the
   verified actual outcome, including partial changes and failures. Name an
   owner for any documentation gap.
10. **Close.** Complete the evidence package, finish the announcement, and
    link follow-up tickets for remaining risks.

## Risk levels

Aspects: availability, performance, security, cost, data.

- **Standard:** no aspect above `Low`, and either non-production, or
  production with an easy, tested rollback.
- **Elevated:** any aspect `Medium`, or a production change that does not meet
  every Standard condition.
- **Critical:** any aspect `High`, a hard or slow rollback, or broad or unclear
  blast radius.

When in doubt, choose the stricter level. For each `Medium` or `High` aspect,
prepare as the "One risk model" section of
`docs/plans/DMVP-10650-delivery-platform-planning.md` states.

| Level | Approval | Customer communication | Validation | Evidence |
| --- | --- | --- | --- | --- |
| Standard | Reviewer approves the PR | None, unless customer-visible; then follow the communication rule | Existing checks or a recorded alternative | Core package |
| Elevated | Named approver for this plan and version, separate from executor | Maintenance announcement before and after | Agreed checks per `Medium` aspect; rollback trigger defined | Core plus aspect evidence |
| Critical | Named approver plus customer agreement where bound; separate executor | Announcement with window, impact, and acknowledgement where required | Pre-production run where possible; checks per `Medium`/`High` aspect; stop conditions | Full package plus recovery rehearsal or justification |

## Recovery

When verification fails or the outcome is unknown, record exactly one:

- **Rolled back:** previous state restored and verified. Record cause; replan
  or close as not delivered.
- **Rolled forward:** fix applied on top. Same approval level again if the plan
  changed materially.
- **Manually repaired:** fixed outside IaC. Reconcile IaC with actual state and
  record the drift.
- **Partial or unknown:** stop further changes. Establish actual state from
  provider and IaC run evidence before any retry.
- **Escalated:** hand to the accountable owner with reapproval before more
  changes.
- **Failed:** terminal state. Record it, escalate, and open a follow-up ticket.

## Incident variant

Investigation and containment that does not change production start
immediately. Any production change needs human authorization first (a named
backup approver when the primary is unavailable) and a minimum incident
record: ticket, affected service and environment, proposed action, approver,
and time. Complete the rest of the evidence package afterwards.

## Evidence package

Link, do not paste:

- approved plan, risk level, aspect ratings;
- approver identity, decision, and time;
- announcement and acknowledgement where required;
- PR and commit;
- IaC run and executing identity;
- test and check results (a comment saying "tests passed" is not evidence);
- service-health verification;
- recovery result, if any;
- updated documentation;
- remaining risks and follow-up tickets.

## Report

Finish with the `infra-execution` completion report plus: risk level and
aspect ratings, approval record, validation outcome and any accepted gap,
recovery outcome, evidence package links, and documentation updated.
