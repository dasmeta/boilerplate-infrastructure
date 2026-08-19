# Template and Fork Contract

## Ownership

Upstream owns tenant-neutral structure, schemas, bootstrap guidance, tests,
driver compatibility profiles, packaged skill provenance, and safe placeholders.

A customer fork owns `WORKSPACE.md`, active context and standards bindings,
`metacloud.yaml`, customer IaC YAML, stack mappings, customer exceptions, and
execution evidence. Fork-local facts and secrets must never flow back upstream.

## Root layout contract

A clone or fork is already structurally operational. `WORKSPACE.md`,
`metacloud.yaml`, `config/`, `0-accounts/`, `1-environments/`, and `2-products/`
exist at their final paths. Bootstrap populates them in place. It must not create
a nested seed, copy an example tree, or relocate customer YAML.

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
