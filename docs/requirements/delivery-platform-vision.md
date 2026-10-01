# Infrastructure delivery platform vision

Status: requirement owner confirmed; developer review pending  
Tracking: [DMVP-10650](https://tutorbot.atlassian.net/browse/DMVP-10650)  
Developer reviewer: Tigran Muradyan  
Recorded: 2026-10-01

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
agreed standards and capabilities. Public and independent adopters must also
be able to configure and operate their own copies.

Customer application teams may retain their own CI/CD for frequent service
releases. Design must identify ownership and handoffs between that CI/CD and
managed service/infrastructure delivery so that multiple tools do not
silently compete to manage the same resources. Shared modules, drivers,
generic standards, and application development remain in their owning
repositories; this boilerplate consumes their capabilities and bindings.

## Desired operator experience

An operator launches Codex, supplies a ticket, problem, or desired outcome,
and works through a smooth, informed conversation. The assistant loads
customer context, understands what and where work belongs, gathers current
evidence, and follows the applicable request workflow.

Most coordination happens under the hood. Questions should primarily concern
intent, customer impact, priorities, tradeoffs, or authorization rather than
require the operator to reconstruct infrastructure details. Unresolved
technical facts may still require the appropriate specialist. Blockers,
conflicting evidence, risks, consequential decisions, and approval requests
must remain understandable.

A possible journey is understanding and diagnosis, brainstorming and
finalizing a proposal, review and approval, implementation preparation,
execution approval where applicable, release, verification, and documentation.
This is illustrative. Different request types may use different stages and
human involvement; the exact stage and approval design remains open.

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
| DEL-03 | Support customer-owned ticketing, asset management, SDLC tools, cloud providers, and IaC platforms through explicit bindings/adapters. Bootstrap must explicitly enable configured integrations or record them as disabled/not used. Disabling expected supporting systems should not be encouraged or silently substituted, and the resulting capability and assurance gaps must be visible. Jira is one adapter, not a requirement to use DasMeta's Jira. |
| DEL-04 | Ground assistant decisions in configured authority, dependency/context information, and current observed evidence. Missing or conflicting evidence must surface as a gap instead of an invented customer fact. |
| DEL-05 | Increase autonomy and speed through AI assistance and automation. Delivery managers, support, customers, and specialists can remain in the loop. Automation must be demonstrated through reliable outcomes, not assumed from AI capability or the number of automated steps. |
| DEL-06 | Make delivery predictable and accountable for its operational consequences through appropriate checks, risk controls, verification, failure handling, and recovery. Each gate should address a concrete risk while avoiding unnecessary waiting. |
| DEL-07 | Prioritize temporary access elevation, controlled authority, reviews for critical changes, approval handling, and traceable audit evidence as first-class capabilities. AI instructions alone must not be assumed to enforce controls; the developer must identify enforceable boundaries during design. Exact policies and mechanisms are later design decisions. |
| DEL-08 | Release improvements to workflow behavior, skills, rules, stages, and capabilities continuously in useful increments. Distinguish upstream template evolution from customer-specific delivery and preserve customer context and declared intent during adoption. |
| DEL-09 | Let each copy choose when to adopt upstream releases. Provide useful local visibility of available updates, their impact, and an upgrade/migration path. Do not force upgrades or assume central read access, telemetry, or inventory of customer and external forks. Upgrade encouragement must work from the consumer's own environment. |
| DEL-10 | Retain useful evidence and documentation of diagnosis, decisions, authorization, changes, execution, and verified results through the configured systems. Such evidence may support MSP review and later case study or AWS opportunity work; those business uses are downstream and should not become mandatory delivery stages. |

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

## DMVP-10650 planning deliverables

1. Review this vision with the requirement owner and developer and record the
   decision and unresolved concerns.
2. Assess the existing foundation, starting with the
   [DEV-2013 v1 baseline](../plans/DEV-2013-boilerplate-infrastructure-v1.md),
   bootstrap schemas, skills, YAML layers, CI validation, and driver runbooks.
   Separate implemented behavior from documented intent and gaps.
3. Examine representative recent delivery requests, referenced by the Jira meeting notes, and identify useful request categories, workflow needs, and operator friction. Keep
   customer-specific evidence in authorized systems.
4. Propose prioritized batches for workflow, skill, integration, automation,
   security, review, audit, verification, and recovery improvements. Explain
   user benefit, dependencies, risk reduction, and measurable acceptance for
   each batch.
5. Identify which work belongs in this repository versus shared modules,
   drivers, Infra Governance, or customer/application repositories.
6. Define a first bounded batch and the later improvement backlog. Verify
   existing batch/version history before assigning v2/v3/v4/v5 labels.
7. Propose how to measure delivery time, operator effort, autonomy, failed
   changes, recovery, and traceability. Targets and the automation denominator
   need developer review.

Completion of this ticket means an agreed vision, a grounded gap assessment,
and a prioritized delivery plan. It does not require implementing the entire
platform or all adapters, changing runtime authorization, or reaching 99%
automation. Architecture, exact gates, role/permission rules, adapter contracts,
and migration mechanisms must be proposed in the relevant design batches.

## Developer review

Review whether the target operator experience is feasible and where customer
context, integration, or runtime controls are missing. Challenge scope,
ownership, compatibility, failure behavior, and adoption assumptions, and
recommend the first valuable increment and subsequent sequence.

Tigran's review is pending. This document must not be presented as developer
approved until the review decision is recorded.
