# Provider-neutral diagnosis in customer infrastructure repositories

Implementation plan for DEV-2356, proposed for human review. The first increment serves the diagnosis step in [delivery workflow PR #10](https://github.com/dasmeta/boilerplate-infrastructure/pull/10). Given a scoped request, an operator should be able to identify the affected service, its environment, its owner and the relevant live evidence, then hand the result back to the workflow.

## Who owns each part

| Owner | Deliverable |
| --- | --- |
| Administration and Operations | Role responsibilities, authority and handoffs for Support, SRE, Delivery and customer operators. |
| Infra Governance | Shared technical meanings, evidence rules and the reusable diagnosis skill. |
| Boilerplate | The abstract concepts and capabilities exposed to skills, binding schema, bootstrap validation and tests of the assembled foundation. Reuse the Governance definitions when publishing the customer-facing contract. |
| Derived infrastructure repo | Customer-approved provider, instance, tenant scope, connection reference and local conventions for each capability. |
| Product integration | Product-specific object meanings, relationships, supported reads, errors and evidence references, exposed through MCP guidance or its versioned companion package. |
| Delivery workflow | The stage trigger, which facts are required for this request, and the decision after diagnosis. Coordinate these with the owner of PR #10. |

## First contract

The workflow supplies a request reference, authorized customer scope and any known environment or service hints. The diagnosis stage reads the fork's approved bindings. It asks the selected inventory provider for service context and consults the relevant source for each additional fact. Credentials stay in the configured access system.

| Concept | Meaning | Example source or mapping |
| --- | --- | --- |
| Change request | Stable reference to the work and its stated intent | Jira issue. A customer-specific service field belongs in the fork's mapping. |
| Service | Identifiable workload affected by the request | CloudBrowser's integration resolves the relevant scoped record and relationships. A second inventory provider can expose the same concept. |
| Environment | Deployment scope of that service | A customer may have distinct staging and production instances with the same service name. |
| Service owner | Party accountable for the service | Inventory ownership assignment with a source reference. Keep change approval authority distinct. |
| Declared version | Version intended for the specified component in the environment | Git file at a specific revision. |
| Observed version | Version actually observed for that component in the environment | Runtime or provider observation with timestamp. |
| Health evidence | Observations relevant to the question and time interval | Monitoring query or check with scope, time window and result. |

For example, bootstrap can bind inventory to CloudBrowser, declared versions to Git, production runtime observations to Kubernetes, and health to the customer's monitoring system. Another fork can bind inventory to a CMDB. The adapter owns its product's lookup procedure. The fork supplies the local project, field IDs and authorized scope. One source may serve several concepts, and different concepts about the same service may come from different systems.

**Result returned to the workflow.** Include resolved scope and stable identifiers, requested facts with source references and observation times or revisions, conflicting or missing evidence, and a proposed disposition: no change, handoff/further investigation, or candidate for change planning. If Git declares 1.32 and the runtime reports 1.31, return both and flag drift. If the runtime is inaccessible, return the declaration and mark the observed version unknown. Unresolved tenant scope stops customer-scoped reads. Diagnosis may propose an inventory correction for a separate authorized action.

## Implementation order

| Batch and owner | Work | Evidence needed to finish |
| --- | --- | --- |
| 1. Agree the handoff · Governance, Operations and delivery workflow owner | Review the seven concepts and the result above against a planned upgrade and a reported symptom. Identify which facts are required for each. Use the existing operational-diagnostic skill for symptom investigation. A planned upgrade only needs the context relevant to that change. | Walk through both requests. The reviewer can tell which evidence permits planning, which gap requires a handoff, and who takes the next decision. |
| 2. Bind concepts at bootstrap · Boilerplate | Extend [customer context](../../config/customer-context.yaml), [its schema](../../schemas/customer-context.schema.json), the bootstrap proposal and validation together. Support a default provider per management plane and scoped overrides where one provider cannot answer every concept. Resolve exactly one authoritative binding for a requested fact and scope, or return an actionable gap. Preserve existing v1 forks during migration. | Bootstrap tests exercise a default, an override, an explicitly disabled source, ambiguous bindings, and an existing fork without new fields. A missing read capability has a visible consequence for the requested fact. |
| 3. Supply the lookup and skill · Product integration and Governance | For CloudBrowser, map the concepts to supported scoped lookups and document the returned evidence and limits under DEV-2352. Adapt operational-diagnostic to request concepts through the fork binding, retain its evidence comparisons, and replace workstation-specific references with package-relative paths. Use a pinned, customer-accessible skill release in the test runner. Coordinate the distribution decision with DEV-2329. | A clean runner can load the reviewed version and its dependencies without access to private authoring repositories or committing skill bodies into a fork. A connector cannot expand the request's authorized customer scope. |
| 4. Test the complete path · Boilerplate | Run the same request through bootstrap, skill selection, lookup and handoff with two synthetic customer configurations. Use CloudBrowser and an alternative inventory fixture. Record provider and skill versions. | Both configurations return the same result shape with source evidence. Test version drift, stale inventory, missing telemetry, ambiguous identity and denied access. Confirm no infrastructure or asset mutation during diagnosis. Alternate-provider fixtures prove portability of the contract. |
| 5. Pilot in a derived repo · Customer repo owner with Support/SRE/Delivery | After review, adopt the pinned version through bootstrap and run one authorized, read-only request. Compare against a manual lookup. Record actual tool calls, sources consulted, any corrections, elapsed time and operator questions in the authorized work record. | A reviewer can reproduce the result and explain the next workflow decision. Record adopt, revise or repeat. Use the result to prioritize the next increment, such as verified announcement publishing. |

## Human review requested

Does the handoff give PR #10 enough information to choose between change planning, closure and escalation? Which facts should block each path if unavailable? Please flag any responsibility assigned to the wrong repository or duplicated in the delivery workflow. The binding field names, product object mapping and distribution mechanism can be finalized in their owning implementation tasks once the handoff is agreed.
