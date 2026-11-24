# Customer bootstrap bindings for infrastructure delivery

[DEV-2356](https://tutorbot.atlassian.net/browse/DEV-2356) proposes extending the [bootstrap skill](../../skills/infrastructure-bootstrap/SKILL.md) so Support, SRE, Delivery and customer operators can use the same approved customer configuration throughout delivery. Bootstrap records where to find or publish each kind of information, who owns that binding and how to connect. Subsequent runs use the saved references to obtain current facts. The customer and the DasMeta operator review these choices at bootstrap and refresh them when something changes.

For example, the customer might choose CloudBrowser for product inventory and maintenance announcements, Jira for requests and Git for infrastructure documentation. A second customer could use a CMDB, a service desk and a wiki. Their skills can ask the same questions. Publishing an announcement and notifying a chat channel are separate capabilities even when both concern the same change.

## Ownership

| Where | Responsibility |
| --- | --- |
| Administration and Operations | Define who may perform, approve or own the work for each role. Account Management helps identify customer-facing owners and announcement channels. |
| Infra Governance and boilerplate | Governance defines shared concepts and reusable skills. Boilerplate publishes the customer-facing vocabulary, schema, bootstrap procedure and validation. External operators can consume supported, versioned releases without access to private authoring repos or copying skill bodies into the delivery repo. |
| Customer IaC repo | Bind each capability to an approved provider, instance, scope, owner and connector release. Record local conventions such as project and field IDs in the customer fork. Customer identifiers and access references belong there. |
| Product integration | Document the mapping from each supported concept and action to product objects, operations, required permissions and limitations. CloudBrowser can supply this through its MCP or versioned companion under DEV-2352. |
| Delivery workflow owner | [DMVP-10650](https://tutorbot.atlassian.net/browse/DMVP-10650) owns when to use the bindings, per-ticket evidence and decisions, declared-versus-observed comparisons, and the upgrade and symptom walkthroughs. The [workflow proposal](https://github.com/dasmeta/boilerplate-infrastructure/pull/10) owns the PoC. |

## What bootstrap captures

Extend the nine planes already in [customer context](../../config/customer-context.yaml). The table proposes capabilities to bind within each plane. One provider can fill several roles. A customer can choose different providers for the same concept by environment or action.

| Existing plane | Customer choices and example locators |
| --- | --- |
| `asset_service_context` | Product and service inventory, environment relationships, accountable owners, entitlements or license records. Identify the authoritative inventory and its customer scope. |
| `source_configuration` | IaC and service configuration repositories, branch and YAML paths holding declared configuration and versions. |
| `iac_lifecycle` | IaC driver, workspace and backend, plan and run records, and execution evidence. |
| `resource_control` | Cloud, accounts or projects, regions, environments and runtime sources for observed resource versions. |
| `identity_access_secrets` | Access broker, approved role and elevation route, secret references and authorised scope. Credential values stay in the access system. |
| `standards_policy_exceptions` | Adopted standards revision, allowed capabilities and modules, and the customer's exception register. |
| `change_delivery` | Task system, project, issue types and local field mappings, SCM review and approval locations, maintenance announcement destination and chat channel or audience. Distinguish authority to read a ticket, update it and publish externally. |
| `operational_assurance` | Monitoring, traces and health sources, scan sources and finding destinations, test/check suites and their invocation or runbook references, plus the location of validation results. Record an unknown test location as a gap. |
| `knowledge_evidence` | Infrastructure documentation location and update destination, decision records, audit evidence and their owners. |

For every enabled system record its connector or MCP identifier and pinned release, supported actions, non-secret connection reference, authorized scope, locator and local mapping. For a hosted service that offers no server-version pin, pin the customer-controlled adapter or versioned contract and explicitly record the upstream limitation. Reuse the existing owner, authority, freshness, access mode and status fields. Define how to verify the binding itself separately from the freshness of data it returns. An explicit opt-out records the owner, reason and affected capability. An unconfigured fork requires bootstrap before it can operate.

## Implementation batches

| Order | Owner and change | Acceptance evidence |
| --- | --- | --- |
| 1. Agree coverage | Integration owner with Operations and the workflow owner maps the capabilities above to the nine planes and identifies required reads, writes and optional integrations. | Each workflow dependency has a concept, authorized source or destination, and accountable owner. Include announcements, infrastructure documentation and test discovery in the review. |
| 2. Extend bootstrap and refresh | Boilerplate owner updates the [context schema](../../schemas/customer-context.schema.json), example, proposal schema, validator and [bootstrap runbook](../../docs/runbooks/bootstrap-customer-context.md) together. Reuse discovery, proposal, confirmation and read-back. | A new fork and an existing v1 fork can propose scoped bindings. Updating an approved binding requires a new proposal token. Missing, disabled, ambiguous and stale bindings produce visible gaps. Existing forks can adopt the update on their own schedule. |
| 3. Supply provider mappings | Product integration owners publish versioned mappings. Customer repo owners select and verify connectors and maintain references. Coordinate customer-accessible distribution under DEV-2329. | Two synthetic forks resolve the same inventory concept using CloudBrowser and an alternative provider. A clean runner can identify the approved connector version, customer scope and allowed operations. Denied access and unavailable connectors produce an attributable gap without fallback to another tenant or unapproved provider. |
| 4. Exercise the bindings in the workflow PoC | Tigran owns the DMVP-10650 PoC. The integration owner supplies the bootstrap fixtures and records coverage and gaps for the routine, higher-risk and incident paths. | Each path can locate its configured systems, tests, documentation and communication destinations, or identify the exact missing binding and its owner. Record results on the existing PoC and use them to prioritize implementation before enforcement. |

Each binding owner refreshes the approved configuration when the provider, connector version, permissions, ownership or locator changes. A failed lookup or stale binding identifies the affected capability, scope and owner for repair. The workflow owner determines what that gap means for the current ticket.

## Review decision

Can the nine-plane mapping and connector metadata support the workflow PoC for a newly bootstrapped customer and an existing fork? Confirm any missing capability, the responsible owner and the first batch it affects.
