---
name: delivery-workflow
description: Use to run an infrastructure change end to end from a Jira ticket to verified, documented closure, with risk-based controls, one Announcement change record, and an evidence package. Wraps infra-execution for the edit and apply steps.
---

# Delivery Workflow

## Purpose

One standard path from "someone asks for an infrastructure change" to "it is
done, verified, and documented". AI does the routine work; people make the
decisions. Small changes stay fast; risky ones get more care. Rationale, gaps,
and record roles are in `docs/plans/DMVP-10650-delivery-platform-planning.md`.

This skill sequences the work. The YAML edit, validation, generation, and
apply steps follow `skills/infra-execution/SKILL.md` and the selected driver
runbook. Announcement tracking follows the "Delivery change tracking" section
of `docs/runbooks/bootstrap-customer-context.md`. This skill does not replace
either. The `infra-execution` stop rules apply here too: stop when readiness
is `partial`, a required plane is `gap`, or access or approval is not
execution-ready.

## Rules that always apply

- Start from a Jira ticket. Jira is the index of the change; it links to the
  real evidence and does not replace it.
- Each change carried out through this repository has one published
  Announcement linked to the ticket as its operational history, including
  changes that need no customer notice. Publishing or updating that record is
  not sending a message, not approval, and not validation.
- Production changes need human approval for this exact plan, scope,
  environment, and version. AI instructions are not enforcement. Do not use or
  request new AI production access for this workflow.
- The executor of an Elevated or Critical change is never its only approver.
- Silence, a missing response, a record status, or "deployed successfully" is
  never approval or validation.
- Never put secrets, customer inventory, or personal data in tickets,
  Announcements, or evidence. No customer-data rule for model use is bound yet
  (G-04): send the model only the minimum non-secret evidence the task needs,
  and ask the customer-data owner when unsure.

## Steps

1. **Ticket and change record.** Confirm the ticket states outcome,
   environment, and owner. Once it is prioritized and has a usable expected
   window (a tentative one qualifies), create or locate its Announcement with
   the approved `delivery-change-announcement` skill from the pinned Infra
   Governance release. Every later step adds its outcome to that same record.
2. **Diagnose.** Run `ruby scripts/bootstrap/delivery-bindings.rb --scope
   SCOPE` to locate the bound request, service inventory, declared and
   observed versions, release checks, Announcement destination, and
   infrastructure docs. Gather facts read-only from those sources. Report
   gaps; do not guess. If no change is needed, record the finding and hand off.
3. **Rate risk.** Rate each aspect `None`, `Low`, `Medium`, or `High` with a
   one-line reason, then set the level (below).
4. **Plan.** List the YAML edits, steps, and recovery path. New components use
   the newest compatible module release, not a version copied from an older
   setup. For module upgrades, use the module maintainers' tested guidance for
   the applicable versions, assess it against the target environment, record
   any deviation, and link the guidance from the Announcement.
5. **Prepare validation.** Find existing tests and checks and where they run.
   Record gaps. Agree the evidence that shows the result is satisfactory.
   If a required test is missing or failing, exactly one applies before
   execution: an approved alternative validation, explicit risk acceptance by
   someone authorized for that level, or the change is blocked.
6. **Approve and communicate.** Apply the approval and customer-communication
   rule for the level (below). Record the approval and any internal or
   customer communication in the Announcement. Sending messages follows the
   communication workflow.
7. **Execute** through the selected driver, within the approved scope. Record
   the start and result of each attempt.
8. **Verify.** Check that the service works, not only that the apply passed.
   If it does not, recover (below).
9. **Document.** Record the verified outcome in the Announcement. Update the
   customer's infrastructure documentation and component status from the
   verified actual outcome, including partial changes and failures. Name an
   owner for any documentation gap.
10. **Close.** Complete the evidence package and link follow-up tickets for
    remaining risks.

If an Announcement write cannot be completed, continue the delivery, retry at
the next step or at closure, and leave the unresolved gap visible on the Jira
ticket. Do not skip it silently.

## Risk levels

Aspects: availability, performance, security, cost, data.

- **Standard:** no aspect above `Low`, and either non-production, or
  production with an easy, tested rollback.
- **Elevated:** any aspect `Medium`, or a production change that does not meet
  every Standard condition.
- **Critical:** any aspect `High`, a hard or slow rollback, or broad or unclear
  blast radius.

When in doubt, choose the stricter level. For each `Medium` or `High` aspect,
prepare as the "One risk model" section of the plan states.

| Level | Approval | Customer communication | Validation | Evidence |
| --- | --- | --- | --- | --- |
| Standard | Reviewer approves the PR | None, unless customer-visible | Existing checks or a recorded alternative | Core package |
| Elevated | Named approver for this plan and version, separate from executor | Customer notice before and after, recorded in the Announcement | Agreed checks per `Medium` aspect; rollback trigger defined | Core plus aspect evidence |
| Critical | Named approver plus customer agreement where bound; separate executor | Customer notice with window, impact, and acknowledgement where required | Pre-production run where possible; checks per `Medium`/`High` aspect; stop conditions | Full package plus recovery rehearsal or justification |

## Recovery

When verification fails or the outcome is unknown, record exactly one, in the
ticket and the Announcement:

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
- Announcement with change history, communications, and acknowledgement where
  required;
- PR and commit;
- IaC run and executing identity;
- test and check results (a comment saying "tests passed" is not evidence);
- service-health verification;
- recovery result, if any;
- updated documentation;
- remaining risks and follow-up tickets.

## Report

Finish with the `infra-execution` completion report plus: risk level and
aspect ratings, approval record, Announcement link and any unresolved write
gap, validation outcome and any accepted gap, recovery outcome, evidence
package links, and documentation updated.
