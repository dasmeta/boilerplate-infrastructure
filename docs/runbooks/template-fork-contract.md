# Template and Fork Contract

## Ownership

Upstream owns tenant-neutral structure, schemas, bootstrap guidance, tests,
driver compatibility profiles, packaged skill provenance, and safe placeholders.

A customer fork owns `WORKSPACE.md`, active context and standards bindings,
the infrastructure source index, `metacloud.yaml`, customer IaC YAML, stack
mappings, customer exceptions, and execution evidence. Fork-local facts and
secrets must never flow back upstream.

## Root layout contract

A clone or fork is already structurally operational. `WORKSPACE.md`,
`metacloud.yaml`, `config/`, `0-accounts/`, `1-environments/`, and `2-products/`
exist at their final paths. Bootstrap populates them in place. It must not create
a nested seed, copy an example tree, or relocate customer YAML.

Generic schemas, skills, scripts, tests, runbooks, and forge adapters remain
upstream-owned. The active `WORKSPACE.md`, `config/*.yaml`,
`config/infrastructure-source-index.json`, `metacloud.yaml`, and root IaC trees
become fork-owned as soon as a customer fork is created. Upstream sync must not
overwrite those populated files.

## Inherited forge validation

Customer forks inherit the template contract adapters for GitHub, GitLab, and
Bitbucket. They run schema, root-layout, generated-output, and YAML validation
for pull requests and the default branch so customer changes cannot silently
break the fork contract.

GitLab uses only the canonical `.gitlab-ci.yml`. Its `template-contract` job
runs first; the retained `apply` job runs on the default branch only after
validation. Fork owners own deployment credentials and may add stricter
approval rules, but must not bypass the template contract. GitHub and Bitbucket
adapters in v1 run validation only. Empty legacy `.github.yaml`,
`.bitbucket.yaml`, and non-default `.gitlab-ci.yaml` placeholders are not part
of the fork contract.

## Adoption contract

An upstream update may change generic structure or validation but must not
overwrite fork-owned context or declared customer intent. The fork reviews
schema changes, migrates its bindings explicitly, regenerates driver output,
and records any accepted exception.

For conflicts in generated paths, resolve authoritative YAML and driver inputs,
discard both generated sides, regenerate with the fork's pinned toolchain, then
review and commit the result. Never manually merge generated Terraform.

## Module contract

Prefer DasMeta modules when they meet the requirement and customer standards.
Approved private, customer, or external modules are allowed only with immutable
version/digest, provenance, maintenance owner, security/license review,
standards fit, and a recorded reason.

## Approval boundaries

Bootstrap records authority; it does not grant it. Shared scope, access,
exceptions, `auto_apply`, apply, and destroy require the approval source bound
for that customer and scope. Asset-management writes are separate from IaC
execution approval.
