# Bootstrap Customer Context

Bootstrap is a bounded setup phase for a new customer fork. It records durable,
non-secret context so later assistants can load facts instead of repeating
discovery questions.

## Procedure

1. Populate the existing `WORKSPACE.md` with the customer ID, accountable
   owner, authorised scope, and prohibited scope.
2. Populate the existing `config/customer-context.yaml` and
   `config/standards-binding.yaml`; populate
   `config/infrastructure-source-index.json` with relevant repository roles,
   authority, scope, and dependencies. Do not create parallel example/active
   files.
3. Replace every example identifier and unresolved placeholder.
4. Bind each management plane to its authoritative system and record status,
   access mode, authority, freshness, owner, and gaps.
5. Select an asset-management adapter. CloudBrowser is one option; use another
   provider when it implements the same context contract.
6. Map deployed stacks and repositories, including delivery orchestrators, to
   the infrastructure scope they create or consume.
7. Populate the existing `metacloud.yaml` with the IaC driver and bind its
   state/run evidence.
8. Bind applicable standards, skills, approvals, and accepted exceptions.
9. Validate the active files against the schemas and set readiness honestly.

Use `skills/infrastructure-bootstrap/SKILL.md` for the reusable two-phase
workflow. Draft a proposal from `templates/bootstrap/proposal.example.json`,
keep unresolved questions explicit, validate it, show its immutable token, and
obtain confirmation before populating active files. The token remains stable
when a `ready` proposal is marked `approved`, but changes if any proposed
binding, driver, source, or file action changes.

## Rules

- Use `bound`, `read-only`, `planned`, `not-applicable`, or `gap` per plane.
- Use `context-ready`, `execution-ready`, or `partial` overall.
- Store locators and identifiers, not secret values or copied inventories.
- Populate values and customer YAML in place. Do not move or rename
  `WORKSPACE.md`, `metacloud.yaml`, `config/`, `0-accounts/`, `1-environments/`,
  or `2-products/` during bootstrap.
- Do not mark execution-ready while required access, approval, driver state, or
  evidence binding is missing.
- Re-bootstrap or refresh bindings when systems, ownership, or standards change.

## Routine-upgrade lookups

Run `ruby scripts/bootstrap/delivery-bindings.rb --scope prod/example-service` from the customer checkout. The report uses exact scope names and obtains the customer identity from local context. It shows the request, service inventory, target environment, declared and observed version sources, release checks, announcement destination and infrastructure documentation. Each row identifies its plane and owner. Exit 0 means all locations are configured, 2 means at least one gap, and 1 means invalid input. The command reads local files. Connector authentication, permission to act, live versions and release outcomes require separate evidence.

During refresh, add a `capabilities` array to the relevant proposal plane. To inspect the proposed locations before approval, add `--preview --proposal PATH`. After the confirmed populate step, copy the reviewed array to the same plane in customer context and commit the matching, non-secret approved proposal at `workspace/bootstrap/proposal.json` in the same customer-repo commit as the active context. During refresh, prepare drafts at a separate path so the last approved record stays usable until the replacement is confirmed. Active lookup checks that each entry matches. Legacy forks can run the report immediately and will see named gaps until they adopt the new fields.

For example, a production release check in the assurance plane could be recorded as follows:

```yaml
capabilities:
  - name: release_checks
    scope: prod/example-service
    owner: service-operations
    status: bound
    provider: git
    locator: tests/smoke/README.md
    operation: read
    connector: git
    release: 2.54.0
```

For unavailable checks use `status: gap` and a `reason` describing what the owner must supply. Explicit opt-outs use `disabled`; a binding needing refresh uses `stale`. Connector releases accept a version number, commit SHA or SHA-256 digest. The optional `mapping` object carries customer field names and lookup details. Keep credentials in the access system.

## Delivery change tracking

[DMVP-11096](https://tutorbot.atlassian.net/browse/DMVP-11096) defines one
published Announcement per prioritized IaC work item once it has a usable
expected window. A tentative window qualifies. Keep later time changes,
execution and verification outcomes, recovery, and communications as events
on that record. Each stage contributes the facts and evidence it owns.

Use the approved `delivery-change-announcement` skill from the customer
repository's standards binding. Resolve its pinned Infra Governance release
and verify the installed package includes `scripts/journal.py`. If the pin or
package is unavailable, report a tracking gap and preserve stage evidence.
The delivery workflow calls the skill itself as stages run.

1. Run `ruby scripts/bootstrap/delivery-bindings.rb --scope SCOPE` from the
   customer checkout. A report with gaps in other capabilities is still
   usable for this task if the exact `announcement_destination` is configured
   in active mode with update authority. A missing, pending, or read-only
   destination leaves Announcement sync pending. Record the gap and continue
   within the delivery stage's existing controls.
2. On each material outcome in the table below, save an event to the shared
   skill's journal before making any Announcement call. Use an original
   timestamp with offset and a stable identity from the stage evidence.
   Resolve the same protected journal from the scoped work identity and the
   evidence location via the shared skill. Carry the verified Announcement
   ID forward. Reuse existing run or Jira evidence when resuming on a
   different checkout.
3. Read and verify the scoped published record through the configured
   connector. Sync pending events through the shared skill and verify readback.
   A failed publication or readback leaves the event pending. Retry pending
   events from stored evidence at the next stage or on resume.
4. At closeout, reconcile with a fresh lookup even if the last sync succeeded.
   If any write remains pending or readback is unavailable, leave an explicit
   **Announcement sync pending** note on the Jira work item with the event
   IDs, reason, and run evidence. A sync retry does not repeat infrastructure
   execution, approvals, or communications.

| Stage | Save this outcome |
| --- | --- |
| Prioritize | Short change description, affected scope, and credible first window. Save once the work item is prioritized and timing is usable. |
| Assess and plan | Risk, impact and expected downtime, plan or PR revision, and applicable Solution or module guidance. If assessment concludes no change is needed or hands off work, close any record already opened with the reason. |
| Prepare validation | Agreed checks and evidence. Capture any approved alternative, risk acceptance, or blocker. |
| Approve and schedule | Approval for the exact plan and revision, agreed or revised window, and customer agreement when required. Preserve each window. |
| Communicate | Internal notice, customer notice, acknowledgement, or applicable no-notice outcome as distinct events. Keep delivery and communication status independent. |
| Execute | Actual start and result of each IaC attempt, with the run and revision. Capture partial or unknown results. |
| Verify and recover | Actual health checks and outcome, recovery action and verification, escalation, and any reapproval. |
| Close | Final impact, disposition, follow-ups, and post-change communications. Save cancellations and postponements at the stage where they occur. |

Module maintainers supply tested version-specific guidance. The IaC owner
applies it to the target environment and owns the actual adoption decisions
and delivery record. Apply the risk-level requirements for execution checks,
approval, and communication. Use the approved Operations templates for
communication and record the actual communications separately. The
[Maintenance Checklist](https://tutorbot.atlassian.net/wiki/spaces/DO/pages/3987931138/Maintenance+Checklist)
and [Maintenance Message Template](https://tutorbot.atlassian.net/wiki/spaces/DO/pages/3987800085/Maintenance+Message+Template)
are the existing references.
