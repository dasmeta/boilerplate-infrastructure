# Infrastructure delivery platform vision

Type: target requirements and planning scope  
Tracking and named decision owners: [DMVP-10650](https://tutorbot.atlassian.net/browse/DMVP-10650)  
Approval and review records: [PR #9](https://github.com/dasmeta/boilerplate-infrastructure/pull/9)

## Vision

Continuously improve this boilerplate into a configurable delivery foundation
that enables developers, customers, and DasMeta delivery and support teams to
bring service changes and related infrastructure changes to production quickly
and predictably. Aim for the greatest practical autonomy and speed while
maintaining agreed reliability, security, safety, and auditability.

The foundation combines a YAML interface, customer context, AI assistance,
automation, standards, and agreed tools, modules, and capabilities. Human
participation remains available where judgment, review, consultation, or
exception handling adds value. Near-total automation is the long-term
ambition; "99%" is an aspiration whose scope and measurement need definition,
rather than a commitment for this ticket or every request.

This is a target vision for developer review and incremental planning.
Existing repository instructions, approval boundaries, skills, and driver
runbooks continue to govern execution until changes to them are deliberately
designed, reviewed, and released.

## Scope and users

Delivery means making and verifying changes in production or lower
environments: new provisioning, maintenance, configuration changes, cleanup,
optimization, and service deployment where managed through this foundation.
The account, environment, product, and service layers belong in the scope.

A customer and DasMeta configure the foundation together. Customer developers
and operators, DasMeta delivery managers, and support then use it under the
agreed standards and capabilities. Existing independent and external adopters
must be considered when deciding future distribution and access. DMVP-10650
must decide whether the upstream remains public or is restricted to customers
and other authorized users; this vision does not preselect that decision.

Customer application teams may retain their own CI/CD for frequent service
releases. Design must identify ownership and handoffs between that CI/CD and
managed service/infrastructure delivery so that multiple tools do not
silently compete to manage the same resources. Shared modules, drivers,
generic standards, and application development remain in their owning
repositories; this boilerplate consumes their capabilities and bindings.

## Desired operator experience

An operator launches the configured assistant runtime (for example, Codex),
supplies a ticket, problem, or desired outcome,
and works through a smooth, informed conversation. The assistant loads
customer context, understands what and where work belongs, gathers current
evidence, and follows the applicable request workflow.

Most coordination happens under the hood. Questions should primarily concern
intent, customer impact, priorities, tradeoffs, or authorization rather than
require the operator to reconstruct infrastructure details. Unresolved
technical facts may still require the appropriate specialist. Blockers,
conflicting evidence, risks, consequential decisions, and approval requests
must remain understandable. Before execution, the operator must be able to see
the intended change, target scope, execution identity and authority, and the
stop/recovery options, including limits where rollback is unavailable.

Delivery state must persist in the configured ticket/repository or other agreed
durable system across sessions and operators. Define the authoritative record,
current stage, evidence and artifact references, approvals and their validity,
and next action. A resumed session must revalidate relevant scope, authority,
and execution evidence rather than treat a previous conversation as current
authorization.

A possible journey is understanding and diagnosis, brainstorming and
finalizing a proposal, review and approval, implementation preparation,
execution approval where applicable, release, verification, and documentation.
This is illustrative. DMVP-10650 must agree the workflow steps, their purpose,
human/AI responsibilities, and review/approval points, including useful variants
for different request types. Detailed technical enforcement designs follow in
the implementation tickets.

For example, "the database is slow for these queries" should lead to evidence
from traces, metrics, query behavior, database size/configuration, and dependent
services before proposing action. The outcome might be a query optimization
recommendation or handoff, a database configuration change, additional
capacity, or further investigation. A correct diagnosis or handoff is useful
even when no infrastructure change is appropriate.

## Target requirements

| ID | Requirement |
| --- | --- |
| DEL-01 | Enable fast, convenient delivery within the standards and tools, modules, and capabilities agreed for the customer. The platform should know the applicable approach for each supported request type and expose limits clearly. |
| DEL-02 | Require bootstrap before operational delivery. Bootstrap must establish customer scope, owners, context, tools/process bindings, standards, capabilities, and readiness. Migration and reconfiguration must support existing customer copies. |
| DEL-03 | Support customer-owned ticketing, asset management, SDLC tools, cloud providers, IaC platforms, and assistant runtimes through explicit bindings/adapters. Record the supported runtime and model/provider configuration rather than hardcode Codex. Bootstrap must explicitly enable configured integrations or record them as disabled/not used. Disabling expected supporting systems should not be encouraged or silently substituted, and the resulting capability and assurance gaps must be visible. Jira is one adapter, not a requirement to use DasMeta's Jira. |
| DEL-04 | Ground assistant decisions in configured authority, dependency/context information, and current observed evidence. Missing or conflicting evidence must surface as a gap instead of an invented customer fact. |
| DEL-05 | Increase autonomy and speed through AI assistance and automation. Delivery managers, support, customers, and specialists can remain in the loop. Automation must be demonstrated through reliable outcomes, not assumed from AI capability or the number of automated steps. |
| DEL-06 | Make delivery predictable and accountable for its operational consequences through appropriate checks, risk controls, verification, failure handling, and recovery. Each gate should address a concrete risk while avoiding unnecessary waiting. |
| DEL-07 | Prioritize temporary access elevation, controlled authority, reviews for critical changes, approval handling, and traceable audit evidence as first-class capabilities. AI instructions alone must not be assumed to enforce controls. Increased autonomy depends on implemented and verified boundaries: agent execution identity and scoped credentials, temporary elevation and emergency access, repository/CI/environment protections, and concurrency/ownership controls across operators and customer CI/CD. Plan the agent credential model in the first batch and verify applicable controls before enabling expanded authority. Exact mechanisms are implementation design decisions. |
| DEL-08 | Release improvements to workflow behavior, skills, rules, stages, and capabilities continuously in useful increments. Distinguish upstream template evolution from customer-specific delivery and preserve customer context and declared intent during adoption. Define versioned schema, binding, skill, and rule contracts; supported-version windows, deprecation policy, and migrations runnable within the customer copy. |
| DEL-09 | Let each copy choose when to adopt upstream releases. Provide useful local visibility of available updates, their impact, and an upgrade/migration path. Do not force upgrades or assume central read access, telemetry, or inventory of customer and external forks. Upgrade encouragement must work from the consumer's own environment. State the support and assurance available for each version without forcing adoption or assuming all historical releases are supported indefinitely. |
| DEL-10 | Retain useful evidence and documentation of diagnosis, decisions, authorization, changes, execution, and verified results through the configured systems. Evidence must follow the configured access, data-processing, redaction, and retention rules. |
| DEL-11 | Bootstrap must record which customer data classes may be read locally and which may be sent to the configured model/provider, the customer's agreement and applicable provider/region, and rules for secrets, personal data, conversation logs, retained evidence, and retention/deletion. Minimize and redact evidence before external transfer or logging; gathering evidence does not authorize sending raw customer data to a model. Missing permission or assurance must restrict the affected capability and remain visible. |
| DEL-12 | Persist workflow state in a configured authoritative system so work can resume across sessions and operators. Expose the planned change, scope, execution identity/authority, and stop/recovery options before acting; revalidate approvals and evidence when resuming. |

## Continuous improvement and adoption

Every increment should provide a useful operator capability, improve autonomy,
speed, or risk reduction, and show what was verified and what gaps remain.
Permanent judgment/exception roles and temporary automation gaps should be
distinguishable. Supported tools, modules, schemas, workflows, and skills need
clear version and compatibility expectations.

Upgrade assistance should explain the installed version, relevant changes,
operational impact, and migration effort from within the fork's environment.
Notification, migration PRs, and update checks are possible approaches for
design review; this vision does not select a mechanism or assume access to
external forks.

Security, reliability, recovery, and auditability belong in the roadmap from
the beginning. The target capabilities may arrive through successive batches.
An increment must accurately describe its assurance limits rather than claim
the whole vision is already implemented.

## Stakeholder review and feedback

The delivery model must account for different ways of interacting with the
system. Technical feasibility review alone is insufficient to validate the
experience of delivery, support, account management, and customer operators.

The participant roster and customer affiliations are tracked in
[DMVP-10650](https://tutorbot.atlassian.net/browse/DMVP-10650). Review must include
the following perspectives. These focuses are prompts to validate with the
participants, not predefined permissions or an assumption that every role
executes infrastructure changes.

| Perspective | Review focus |
| --- | --- |
| Foundation development | Technical feasibility, implementation, maintainability, integration and enforcement boundaries. |
| Delivery team leadership | Delivery coordination, planning, reviews and approvals, handoffs, operator effort, and predictable outcomes. |
| Account management | Customer expectations, communication, visibility of progress and consequences, and coordination between customers and delivery/support. |
| Support team leadership | Diagnosis, maintenance and incident-related requests, escalation, handoffs, recovery, and access to useful evidence. |
| Customer development | Self-service speed, service/infrastructure changes, questions and gates, and interaction with existing CI/CD. |
| Customer DevOps | Tool/process compatibility, operational control, infrastructure changes, and adoption effort. |
| Frequent customer infrastructure contributors | Frequent change experience, iteration speed, clarity of standards/capabilities, and friction in the delivery workflow. |

Collect feedback on the delivery model and visual workflow using representative
requests from each participant's own work. Ask how they interact now, what they
need to know or decide, where the proposed process adds waiting or confusion,
which human interactions remain useful, and what would make the model practical
for them.

The team should nominate additional participants from other customers to cover
different operating models and usage patterns. Record nominees, the perspective
they add, and who coordinates their feedback in the ticket. Access and
participation must use the agreed customer channels; the roster does not mean
participants have already been contacted or accepted review assignments.

Use a timeboxed review. Before invitations, name a coordination owner and
record the complete review packet, start date, and due date in the ticket.
The default window is ten working days from sharing that packet; the
requirement owner may adjust it before invitations or record an extension
with a reason and a new due date.

At the deadline, each required perspective must be represented by recorded
feedback or explicitly marked missing, with outreach attempts, reason,
potential impact, and mitigation or follow-up owner. The requirement owner and
developer must accept any missing coverage when finalizing the workflow.
Silence is not approval. Material unresolved concerns require resolution or an
explicit decision with linked work and stated limits. Additional nominations
do not automatically restart the window or make the participant list unbounded.
A linked coordination ticket may organize outreach; the feedback assessment
and its disposition remain required inputs to DMVP-10650.

Record feedback against the relevant workflow step, the concern or suggestion,
and its disposition: incorporated, deferred with a linked gap/ticket, or declined
with a rationale. Keep identifying information and customer-specific evidence
in authorized systems. Make conflicts and missing feedback visible for the
requirement owner and developer to resolve before final agreement. Participants
provide stakeholder feedback; final requirement-owner agreement and developer
review remain explicit, separate decisions.

## DMVP-10650 deliverables and completion

1. Review this vision with the requirement owner and developer and record
   agreement, requested changes, and unresolved concerns.
2. Assess the existing foundation, starting with the
   [DEV-2013 v1 baseline](../plans/DEV-2013-boilerplate-infrastructure-v1.md),
   bootstrap schemas, skills, YAML layers, CI validation, and driver runbooks.
   Distinguish implemented behavior from documented intent and target behavior.
3. Examine representative recent delivery requests referenced by the Jira
   meeting notes. Identify useful request categories, workflow variants, and
   operator friction. Keep customer-specific evidence in authorized systems.
4. Document a clear, visually well-presented delivery workflow in this
   repository. Include a rendered diagram and accompanying step descriptions
   that agree the inputs, outputs, responsible AI/human roles, decision criteria,
   review/approval points, and evidence expected at each step. Show request
   variants, blockers, failure/recovery paths, and handoffs where relevant.
   Make the main journey easy to follow without requiring readers to decode
   all technical detail.
5. Maintain a gap register in the repository linking the target workflow to
   current capabilities. Record each gap's evidence, operational impact,
   priority, dependencies, owner, and implementation ticket or decision needed.
   Readers must be able to see which workflow steps are supported now and which
   depend on future work.
6. Agree the implementation order with the requirement owner and developer.
   Prioritize useful batches across workflow, skills, integrations, automation,
   security, reviews, audit, verification, recovery, and adoption assistance.
   Explain outcomes, dependencies, risk reduction, and measurable acceptance.
   Identify ownership across this repository, shared modules, drivers, Infra
   Governance, and customer/application repositories. Verify existing version
   history before assigning v2/v3/v4/v5 labels.
7. Create and link the implementation tickets for the agreed plan, including
   the first bounded batch and identified later batches. Each ticket needs a
   clear outcome, scope, acceptance criteria, dependencies, and responsible
   team or repository. Link tickets to this planning ticket, the workflow, and
   relevant gaps so that the plan can be executed and reviewed.
8. Decide the repository access and distribution model within this ticket:
   retaining public access or restricting future access to customers and other
   authorized users. Record the alternatives, rationale, decision owner,
   approval, consequences, and any transition work as described below.
9. Record a baseline before batch 1 for delivery time, operator effort,
   autonomy, failed changes, recovery, and traceability using representative
   historical requests or a documented observation period. Record sample,
   definitions, sources, and missing measurements; link work to collect missing
   data. Define the scope and denominator before proposing an automation
   percentage, then use comparable evidence to assess improvements.
10. Publish the workflow, gap register, decisions, implementation order, and
    ticket links as a coherent set of repository documents discoverable from
    the repository index. Give internal delivery/support, developers, and the
    intended customer stakeholders an authorized route to review and provide
    feedback. Collect feedback from the internal and customer participants
    tracked in the ticket, invite additional customer perspectives nominated
    by the team, and apply the timebox and coverage exit criteria above.
    Record feedback disposition, missing participation, and its acceptance.
    Record requirement-owner/developer agreement on the workflow steps and
    implementation order.

Completion requires an agreed, documented visual workflow and implementation
order, a grounded gap register, created and linked implementation tickets, and
a recorded repository access/distribution decision. It also requires the
requirement-owner and developer review records, the timeboxed feedback
assessment with accepted coverage gaps, and a visible feedback route.
These are deliverables to produce during DMVP-10650, not outputs already
completed by this vision document.

Runtime controls, adapter implementations, technical enforcement designs, and
migration mechanisms are delivered and verified in the subsequent tickets.
The planning ticket does not require implementing the entire platform or
reaching 99% automation.

## Repository access and distribution decision

The requirement owner must name a business decision owner in the ticket.
That owner decides access/distribution with appropriate legal/licensing input.
The developer supplies technical consequences and feasibility; developer
review alone does not authorize a business or licensing decision. A separate
linked decision record or coordination ticket may hold the assessment, but
the decided outcome remains a completion requirement of DMVP-10650.

Assess whether public distribution supports the intended business and support
model, or whether future upstream access should be limited to customers and
explicitly authorized people. Review at least:

- How customers and external collaborators receive, bootstrap, update, and
  provide feedback on their copies under each option.
- Authorization ownership, customer onboarding/offboarding, support access,
  and upgrade availability without assuming central access to customer copies.
- Existing public forks/copies, current licensing and distribution terms,
  shared dependencies, release/package channels, automation credentials, and
  the effect of a visibility change on repository features and integrations.
- The migration effort, communication needs, and resulting implementation
  tasks, including the intended access to workflow documentation and tickets.

Changing upstream visibility must not be treated as proof that only authorized
people can use previously distributed material. GitHub states that existing
public forks are detached into a new network when the upstream becomes
private; see [GitHub repository visibility guidance](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings/setting-repository-visibility).
Evaluate access to future releases and permitted use/distribution explicitly.
The developer review reports no explicit repository licence; verify the
licensing baseline, repository history, dependencies, and any applicable
customer agreements as part of the decision. Do not infer unrestricted use
from public visibility or claim there are no rights at all: GitHub permits
viewing and forking public repositories through its service. Broader permissions
need explicit assessment; see [GitHub licensing guidance](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository).

Record the decision and its approval within DMVP-10650, even if the outcome is
to retain public access. Any visibility change must follow that approved
decision and its transition plan.

## Review record and planning priorities

[Developer review](https://github.com/dasmeta/boilerplate-infrastructure/pull/9#pullrequestreview-5379527542)
identified data-processing, enforcement, compatibility, continuity, and
measurement gaps. The revised requirements above are target obligations, not
claims that the controls exist today. Named reviewers, review status, and
approvals belong in the ticket and PR.

The current-state assessment and gap register must include:

- Data access versus transfer to the model/provider, customer agreement,
  permitted providers/regions, secret redaction, and evidence/log retention.
- Agent credential ownership, least privilege, temporary elevation, emergency
  access, repository/CI/environment protections, and competing execution.
  Applicable boundaries must be verified before autonomy increases; the
  credential model belongs in first-batch planning.
- Versioned schemas, bindings, skills and rules; support/deprecation policy
  and local migrations that preserve customer choices.
- Assistant runtime binding and durable workflow state, resumption, handoffs,
  approval validity, and operator visibility of execution/recovery.
- Measurement baselines, missing data, and comparable outcome measurements.
- Timeboxed stakeholder coverage and a business-owned access/distribution
  decision, with technical and licensing assessment.

Require agreement on the workflow and implementation sequence after review.
A separate outreach ticket or decision record can organize work, while their
required outcomes remain within DMVP-10650. Implementing all target controls
remains work for the agreed delivery batches.
