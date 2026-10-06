# Delivery platform — inputs for detailed planning and tasks

Tracking: [DMVP-10650](https://tutorbot.atlassian.net/browse/DMVP-10650)  
Definition: [Delivery platform vision](delivery-platform-vision.md)  
Stage of this register: later planning input — not an approved implementation design

## Purpose and boundary

The requirement owner narrowed the current review to the vision at Definition
on 2026-10-05. The five Definition concerns are in the vision document.
The detail below preserves earlier elaboration and reviewer feedback for the
detailed planning/task stages. It is not a set of new blockers to Definition
approval, and it does not select exact mechanisms or implementation order.

Before closing the later planning work, assess every input, identify the
responsible team/system, record an incorporated/deferred/declined disposition
with rationale, and link the relevant gap, decision, or implementation ticket.
Inputs outside this repository must be routed to their owning teams.
A deferred input is not an implemented control or accepted operational risk.

Names, customer-specific examples, evidence, and business decisions remain in
authorized systems. Public review links provide provenance without copying
customer context or restricted checklist material into this repository.

## Detailed planning inputs

| ID | Area / linked outcomes | Concerns and questions to address during planning/tasks |
| --- | --- | --- |
| PLN-01 | Workflow and routing — DEL-01, DEL-06 | Define authoritative stages and transitions, entry/exit criteria, cancellation/reopening, and conflict resolution between systems. Distinguish diagnosis/no-change/handoff, routine lower-risk work, higher-risk changes, maintenance/optimization, incidents/emergencies, and upstream module gaps. Show representative small-change and higher-risk examples. |
| PLN-02 | Authority and approval — DEL-07 | Define proposing, classification, approval, execution, verification, risk acceptance, customer communication, escalation, substitutes, and separation of duties. Bind approval to identifiable scope, artifacts, environment, identity, and validity conditions; resolve standing approvals, expiry, revocation, invalidation, and material-change reapproval. Support asks for human approval of production changes during incidents and an authorized backup approver; assess this as a policy proposal, not a settled universal policy. |
| PLN-03 | Enforceable boundaries — DEL-02, DEL-07 | Assess agent identity, least-privilege credentials, temporary elevation, emergency access, repository/CI/environment protections, and concurrency/ownership across operators and customer CI/CD. Earlier developer feedback prioritizes credential-model planning in the first batch; agree the actual batch order during planning. Verify applicable controls before expanded authority is enabled. |
| PLN-04 | Customer data and AI safety — DEL-04, DEL-11 | Distinguish permission to read evidence from permission to send it to a model/provider. Assess permitted data classes, customer agreement, provider/region, minimization, secret/personal-data redaction, logs, evidence retention/deletion, data quality/lineage/sovereignty, third-party model/tool evaluation, prompt-injection defenses/testing, and AI-specific incident handling. Evidence gathering does not authorize raw transfer. |
| PLN-05 | Continuity, fallback, and recovery — DEL-06, DEL-12 | Select durable authoritative state and resumption behavior, including approval validity and actual remote run/resource evidence. Distinguish not started, running, partial, and unknown outcomes before retrying. Address duplicate execution, safe retry, stop/cancellation, rollback versus roll-forward, irreversible changes, manual repair/IaC reconciliation, and recovery ownership. Define authorized human/runbook fallback, on-call escalation, minimal evidence, and later reconciliation during dependency/approver outages. Missing authority still blocks the affected mutation. |
| PLN-06 | Service outcomes, communication, and completion — DEL-06, DEL-10 | Define verification of customer/service impact beyond tool success, appropriate observation, verification ownership, recovery/escalation triggers, residual risks, and completion criteria. Assess minimum evidence, documentation/configuration records, privilege removal, customer notice/updates/acceptance, and follow-up work. Avoid treating a successful apply as proof of a healthy service. |
| PLN-07 | Practical operator experience — DEL-01, DEL-05 | Specify what AI discovers/does automatically and what needs operator judgment; avoid unnecessary questions, universal ceremony, and duplicate records. Fit existing tools through links and projections. Make proposal, impact, evidence, authority, and recovery understandable. Use complete internal work packages and consolidated feedback where useful without importing another workflow's exact stages or extra gates. |
| PLN-08 | Ownership and upstream module cooperation — DEL-01, DEL-04 | Make application/CI/CD/module/driver handoffs accountable, including incident coordination while another team acts. Assess module-gap intake, sanitized public reports, triage owner and expected turnaround, and the route from gap to issue, change, release, and voluntary adoption. Module development remains in its owning repositories. |
| PLN-09 | Module and version compatibility — DEL-08, DEL-09 | Assess module capability metadata, prerequisites/IAM, minimum provider/Terraform versions, cost-relevant defaults, and limits. Define versioned schema/binding/skill/rule/module contracts, semver and behavior-change notes, migration/refactor guidance, provider-floor policy, support/deprecation windows, and migrations runnable in customer copies. Assess immutable releases equally for DasMeta and alternative modules, effective CI/release test gates, and later provenance/review rules for agent-authored module changes. Specific repository conditions and release-tool claims from review require verification in the owning repositories. |
| PLN-10 | MSP applicability and evidence — DEF-05 | Verify the authoritative checklist version, control IDs, mandatory/recommended status, and exemptions. Map applicability, rationale, current objective evidence, evidence location/owner, gaps/risk, validation method, and linked work. Include ownership outside this repository. Review the proposed Responsible AI/RACI, model/agent lifecycle/registry, knowledge, customer outcomes, provider evaluation, AWS-specific evidence, ITSM/AIOps, resilience/DR, and configuration/change concerns. Map supported/excluded MSP service categories to workflow scope. Organization-wide obligations need responsible teams; mapping does not make this ticket implement every MSP capability. Do not claim VCL 8.0 alignment from an unverified review or target intent. |
| PLN-11 | Measurement and validation — DEL-05, DEL-06 | Establish comparable baselines for delivery time, useful diagnosis, operator minutes, approval waiting, failure/recovery, traceability, and customer outcomes. Record sources, sample/definitions, missing data, and collection work; define any automation denominator. Validate representative requests and distinguish walkthrough reasoning, simulated tests, and real operational evidence. |
| PLN-12 | Ongoing process and roadmap ownership — DEL-08 | Assign owners for workflow maintenance, operator enablement, feedback, review cadence, retirement, and out-of-cycle improvement. Define readiness of implementation tickets, dependency/acceptance review, traceability, and governance of deferred/reordered work. Give external business/legal/customer dependencies owners and target dates. |

## Required PoC before workflow enforcement

The requirement owner's Definition decision requires a bounded PoC before the
final workflow is enforced. PoC discussion and design begin after Definition
approval; completing Definition does not require a finished PoC design or trial.
Tigran will lead the subsequent PoC planning and delivery, with input from
relevant delivery, support, account-management, and customer perspectives.
Participants should discuss detailed PoC questions with him.

Plan three representative paths: routine low-risk
change, higher-risk production change, and urgent incident. Compare operator
steps, effort, questions, and waiting with current practice.

For each path, assess risk-level activities and classification responsibility;
information the assistant can gather/record from existing systems without
duplicate entry; human approval and incident substitutes; human/runbook
fallback; conflicting or duplicate execution across operators/customer CI/CD;
and service-health verification beyond a successful tool run.

Define scope, safe environment/data/actions or simulations, accountable owner,
baseline, acceptance criteria, evidence, and linked tasks during detailed
planning. Preserve the additional delivery questions: measurable thresholds for
adoption, revision, or further validation; representative scenario selection;
comparison of engineer time, repeated questions, approval waiting, handoffs,
and recovery; safe trial/simulation selection and authorization; who reviews
results and decides adoption; and revision triggers if routine work becomes
slower. Address these before running the PoC, not as Definition approval
conditions. [Source feedback](https://das-meta.slack.com/archives/C08J12Q06JH/p1791271582327729?thread_ts=1790852409.494619&cid=C08J12Q06JH). Review actual results and limitations, then record an adoption,
revision, or further-validation decision before enforcement. The ticket's
planning outputs must include this PoC plan and linked execution/acceptance
work; Definition approval is not proof that the PoC has been performed.
Implementation/testing occurs under the later authorized work.

## Candidate validation scenarios

Support proposed four useful walkthroughs: authorized slow-database diagnosis
and handoff; a bounded nonproduction change; an incident with an unavailable
dependency or approver; and interrupted/partial execution with competing
customer CI/CD. Delivery also asks for an explicit higher-risk example.

Select suitable authorized real requests and safe simulations during planning.
Record actual timings, operator questions, decisions, handoffs, verification,
and recovery evidence. These additional scenarios complement the required three-path PoC; they are
not completed tests or a new universal gate for every request.

## Overall ticket outputs retained for later stages

DMVP-10650 must still produce:

1. An agreed, visually clear workflow and step descriptions.
2. A grounded current-state assessment and gap register.
3. An agreed implementation order, first bounded batch, and identified later
   batches; verify version history before assigning v2/v3/v4/v5 labels.
4. Created and linked implementation tickets with outcomes, scope, acceptance,
   dependencies, and responsible teams/repositories.
5. A stakeholder feedback assessment and recorded decisions.
6. A repository access/distribution decision: public or restricted future access,
   with a named business owner, appropriate licensing input, technical impact,
   existing adopter implications, and transition work.
7. Discoverable repository documentation, an authorized feedback route, and a
   measurement/validation plan including the required PoC and linked work
   before workflow enforcement.

The established default stakeholder-review window is ten working days after a
complete review packet is shared, with a named coordinator and recorded dates.
The requirement owner may adjust it or record an extension. Missing coverage
requires recorded outreach, reason, impact, follow-up, and owner/developer
acceptance; silence is not approval. Definition approval does not establish
that a complete workflow packet has been shared or start an unrecorded clock.

For the access decision, assess licence/history/customer agreements, existing
copies/forks, updates, dependencies, releases, credentials, and integrations.
A separate decision record may hold the assessment, but the decision remains
a ticket-completion requirement. Current visibility is unchanged.
See [GitHub visibility guidance](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings/setting-repository-visibility)
and [licensing guidance](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository).

## Feedback provenance

- [Delivery PoC request and daily-work questions](https://das-meta.slack.com/archives/C08J12Q06JH/p1791269595085669?thread_ts=1790852409.494619&cid=C08J12Q06JH).

- [Initial developer review](https://github.com/dasmeta/boilerplate-infrastructure/pull/9#pullrequestreview-5379527542)
  and [approval of the prior revision, with follow-ups](https://github.com/dasmeta/boilerplate-infrastructure/pull/9#pullrequestreview-5389480784).
- [MSP assessment](https://github.com/dasmeta/boilerplate-infrastructure/pull/9#issuecomment-5952475710)
  and [process requirements](https://github.com/dasmeta/boilerplate-infrastructure/pull/9#issuecomment-5952910163).
- [Support analysis](https://github.com/dasmeta/boilerplate-infrastructure/pull/9#pullrequestreview-5412907525)
  and [confirmed support position](https://github.com/dasmeta/boilerplate-infrastructure/pull/9#issuecomment-5993702080).
- [Delivery review](https://github.com/dasmeta/boilerplate-infrastructure/pull/9#pullrequestreview-5413771563)
  and [additional delivery questions](https://github.com/dasmeta/boilerplate-infrastructure/pull/9#pullrequestreview-5413794953).
- [Development/module perspective](https://github.com/dasmeta/boilerplate-infrastructure/pull/9#issuecomment-5994903698).

Prior approved text and decisions remain in commit/review history. This register
preserves their detailed topics for planning; it does not silently represent
reviewer proposals as approved designs. The requirement owner's current stage
clarification governs what is being approved now.
