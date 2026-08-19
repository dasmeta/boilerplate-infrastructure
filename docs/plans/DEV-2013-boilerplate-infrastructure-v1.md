# DEV-2013 — Customer Infrastructure-Management Boilerplate v1

Status: approved; implementation in progress
Tracking: DEV-2013

## Outcome

Turn this repository into a tenant-neutral, customer-forkable infrastructure
management template. After a bounded bootstrap, an AI assistant should know the
repository's role, customer context sources, IaC lifecycle, applicable
standards, execution limits, and evidence sources well enough to reason about
and carry out routine infrastructure work without repeatedly asking foundational
questions.

This repository is the customer IaC control surface. It is not a new general
orchestrator, Terraform module library, application delivery orchestrator,
asset-management product, or owner of cross-customer infrastructure governance.

## V1 principles

1. Deliver useful structure quickly; do not wait for every adapter or automation.
2. Keep upstream/template material tenant-neutral and keep customer facts in forks.
3. Store bindings and identifiers, not secrets or duplicated customer inventory.
4. Prefer DasMeta modules, but allow approved customer/private/external modules
   with immutable versions, provenance, ownership, standards checks, and a
   recorded reason.
5. Treat Git intent, provider-observed state, asset-management context, IaC run
   state, and organisational standards as distinct evidence sources.
6. Keep generated Terraform non-editable. Its commit policy is driver-specific.

## Repository and fork contract

The current repository contains two trees. V1 keeps that layout to avoid an
unrelated migration:

- `boilerplate-infrastructure/` is the canonical customer-fork seed.
- `demo-infrastructure/` is example material, not authoritative customer intent.
- root AI entrypoints explain the distinction and route work correctly.

The upstream owns role/boundary documentation, schemas, examples, bootstrap
guidance, compatibility fixtures, validation, and packaged skills. A customer
fork owns its `WORKSPACE.md`, context/standards bindings, active
`metacloud.yaml`, IaC YAML, stack mappings, customer exceptions, and execution
evidence.

The contract must answer for every fork:

- why the repository exists;
- what it owns and may change;
- what it explicitly does not own;
- which systems are authoritative for each kind of fact;
- which actions require approval or another repository/team; and
- how upstream improvements are adopted without overwriting customer context.

The generic repository-authority schema remains owned by
`meta-level-constitution` under DEV-2012. This work consumes that contract when
available and must not create a competing universal governance schema.

## Bootstrap and runtime context

V1 provides a guided, schema-backed bootstrap. Automation can follow later.
Bootstrap creates only durable, non-secret customer configuration and source
bindings. It records one of `bound`, `read-only`, `planned`, `not-applicable`,
or `gap` for every required management plane and derives repository readiness
as `context-ready`, `execution-ready`, or `partial`.

Required management planes:

| Plane | What the binding identifies |
| --- | --- |
| Asset and service context | Customer topology, ownership, scope, service relationships |
| Source and configuration | Git repositories, active YAML roots, stack/repository mappings |
| IaC lifecycle | Driver, backend/state, plans, runs, execution evidence |
| Resource control | Cloud/provider accounts, projects, subscriptions, regions |
| Identity/access/secrets | Authorisation and secret-system references, never secret values |
| Standards/policy/exceptions | Organisation standards, applicable skills, accepted exceptions |
| Change/delivery | Review, approval, promotion, and deployment controls |
| Operational assurance | Health, incident, recovery, and post-change evidence sources |
| Knowledge/evidence | Documentation and decision/evidence locations |

Asset management is a provider role. CloudBrowser is one supported option, not
a mandatory dependency. Other systems can implement the same binding contract.
Cloud/provider APIs remain the source for observed technical state; the
asset-management system does not replace them.

Naming CloudBrowser as an example adapter in this public template is
intentional: it makes the existing integration discoverable without granting it
special status in the binding contract. Customer-specific endpoints and private
adapter details remain fork-local.

On assistant startup, load context in this order:

1. repository role, boundaries, and customer overlay;
2. authorised asset-management context;
3. Git/YAML declared intent;
4. IaC driver, backend/state, and run evidence;
5. applicable standards, exceptions, and skills;
6. mappings to deployed stacks such as development-orchestrator and the data
   analytics platform; then
7. diagnose, plan, or execute within the resolved readiness and approvals.

## IaC driver model

`metacloud.yaml` selects the customer's IaC management driver. V1 keeps roles
and placeholders provider-neutral while supporting the current drivers:

- `terraform-cloud`
- `terramate`
- `terragrunt`

New forks use an explicit driver. Existing `metacloud.yaml` without `driver`
must continue to mean `terraform-cloud`.

Each driver profile defines bootstrap prerequisites, generated paths, state/run
evidence, validation/plan/apply commands, approval gates, and whether generated
delivery artifacts are committed.

## Terraform Cloud/TFE compatibility baseline

Terraform Cloud is a first-class compatibility profile, not merely the legacy
default. V1 targets the current `dasmeta/cloud/tfe` 2.5 release line (currently
v2.5.10), requires `meta-cli >= 0.0.15`, and protects both modern and legacy
flows.

The profile must distinguish three independent Terraform versions:

1. TFE driver management workspace: Terraform `~> 1.8`;
2. generated workspace `terraform_version` rendered from YAML; and
3. HCP workspace executor version, otherwise inherited from the organisation.

Compatibility fixtures must assert the management-workspace Terraform
constraint and generated-workspace `terraform_version` separately. They must
also assert that the HCP executor selection is an independent binding rather
than implying it follows either Terraform configuration value.

Current behavior to document and exercise in fixtures:

- loader and renderer alignment at 1.2.2;
- source/version-based workspace discovery;
- shared `_.yaml` configuration;
- name-based `variable_sets` (preferred) with legacy `variable_set_ids` support;
- explicit `linked_workspaces` and `${workspace.path.output}` references;
- `workspace.agent_pool_name` and shared agent-pool precedence;
- default-enabled TFE token variable set;
- default-enabled AWS variable set with `aws.enabled` opt-out;
- `git_enabled`, optional `git_branch`, and explicit `auto_apply` approval.

For VCS-driven TFC workspaces, generated `_terraform/` workspace code is a
generated delivery artifact: never hand-edit it, but commit it with the source
YAML so HCP Terraform can run it. `_metacloud.tf` is generated by `meta init`
and must not be manually maintained.

When an upstream/fork merge conflicts in a generated path, do not merge the
generated Terraform manually. Resolve the authoritative YAML and driver inputs,
discard both generated sides, and regenerate with the fork's pinned toolchain.
Review and commit the regenerated result.

### Confirmed dependency gap

`meta-cli` 0.0.15 passes `tfe_token_variable_set`, `aws.enabled`, and
`auto_apply` from `metacloud.yaml` into generated `_metacloud.tf`. The current
remaining gap is `git_branch` and `git_enabled`: the TFE module exposes both,
but meta-cli does not normalise or render them.

Recommended resolution: a small, separately reviewed `meta-cli` change adds
schema, normalisation, HCL generation, and regression tests for these two Git
settings. Boilerplate acceptance tests then consume that released meta-cli
contract. Until it lands, the boilerplate must document the unavailable
overrides rather than present ignored YAML as working configuration.

## AI and skill surfaces

Add:

- root `AGENTS.md` with mandatory read order, authority, safety, and routing;
- root `AI-INDEX.md` mapping canonical sources, generated output, validation,
  skills, and human approval boundaries;
- fork/template contract and driver runbooks;
- versioned, repository-local `infra-execution` skill with provenance and a
  clone-safe `.agents/skills` discovery path.

The discovery path remains a committed relative symlink
`.agents/skills -> ../skills`. POSIX/Git symlink support is a repository
prerequisite; Windows checkouts without symlink support are out of scope for v1.

The packaged skill operates only after bootstrap/context loading. It remains
YAML-first and never edits generated Terraform. Its module policy is adapted to
this template: prefer DasMeta modules but permit approved, pinned alternatives.
Relevant Infra Governance skills remain canonical upstream and are referenced
through the standards binding; they may be packaged locally later.

## Proposed V1 files

```text
AGENTS.md
AI-INDEX.md
docs/runbooks/template-fork-contract.md
docs/runbooks/terraform-cloud-compatibility.md
schemas/customer-context.schema.json
schemas/standards-binding.schema.json
config/customer-context.example.yaml
config/standards-binding.example.yaml
skills/infra-execution/{SKILL.md,PROVENANCE.md}
.agents/skills -> ../skills
tests/test-template-foundation.sh
tests/fixtures/terraform-cloud/{current,legacy-without-driver}/
```

Inside `boilerplate-infrastructure/`, modernise `README.md`,
`metacloud.example.yaml`, active YAML placement, generated-output policy, and
unsafe/stale examples. Keep `demo-infrastructure/` operationally separate and
label it as non-canonical.

## Implementation sequence

1. Add failing contract tests and current/legacy TFE fixtures.
2. Add root role, authority, fork, AI navigation, and packaged skill surfaces.
3. Add context and standards schemas plus guided bootstrap examples.
4. Modernise the canonical seed and move non-active examples out of its active
   YAML discovery path; remove secret-like sample values.
5. Add driver-specific generated-output and execution runbooks.
6. Land `meta-cli` passthrough for `git_branch` and `git_enabled`, or explicitly
   defer those two overrides with a tracked gap. Require at least meta-cli
   0.0.15 for the already-released variable-set controls.
7. Run credential-free validation and record live TFC verification as a
   customer-fork acceptance step rather than pretending the template test
   proves remote execution.

## Compatibility and migration safeguards

- Do not break no-driver legacy Terraform Cloud configuration.
- Do not require CloudBrowser when another asset-management provider is chosen.
- Do not require DasMeta modules when an approved alternative meets standards.
- Do not hand-edit or treat generated Terraform as declared intent.
- Resolve generated-path merge conflicts by resolving source intent, discarding
  both generated sides, and regenerating with the pinned fork toolchain.
- Do not silently change shared `_.yaml`, backend, agent pool, auto-apply,
  identity/access, or policy-exception scope.
- Preserve the current top-level repository layout during v1.
- Keep customer secrets and copied cloud inventory out of Git.

## V1 acceptance criteria

- A fresh fork explains its role, limits, sources of truth, read order, and
  approval boundaries without external tribal knowledge.
- Bootstrap examples cover every management plane and validate against schemas.
- A fork can select CloudBrowser or another asset-management provider.
- `terraform-cloud`, `terramate`, and `terragrunt` have explicit lifecycle
  roles and generated-output rules.
- Current TFE and legacy no-driver fixtures pass credential-free validation.
- TFE docs/tests cover the current 2.5 behavior and Terraform 1.8 management
  requirement.
- TFE fixtures distinguish the management-workspace constraint, generated
  workspace version, and independently bound HCP executor version.
- The bootstrap requires `meta-cli >= 0.0.16`, including `git_branch` and
  `git_enabled` passthrough to the TFE module.
- The stale v2.0.2 hand-maintained bootstrap is no longer the recommended flow.
- `infra-execution` is locally discoverable after cloning and enforces the
  bootstrapped customer standards and module policy.
- No fixture contains a real or secret-like credential.
- Validation does not require a live customer account; remote apply evidence is
  required before claiming customer execution success.

## Out of scope for V1

- A new infrastructure orchestrator service.
- Full live adapters for every asset-management system.
- Automatic migration of existing customer forks.
- Moving every Infra Governance skill into this repository.
- Live cloud/TFC deployment from template CI.
- Redefining the universal repository-authority schema owned by DEV-2012.
- Supporting Windows checkouts without Git symlink support.

## Approved review decisions

1. Accept `boilerplate-infrastructure/` as the canonical seed and keep the
   current two-tree layout for v1.
2. Accept the management-plane schema and progressive readiness states.
3. Accept provider-neutral asset-management binding with CloudBrowser as one
   adapter.
4. Accept the TFC-specific generated-delivery-artifact commit policy.
5. Land the small `meta-cli` dependency change for `git_branch` and
   `git_enabled`, with `meta-cli >= 0.0.16` as the boilerplate baseline.
