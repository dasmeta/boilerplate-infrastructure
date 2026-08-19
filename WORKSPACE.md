# Customer Infrastructure Workspace

Populate this file in place during customer bootstrap. Replace every placeholder
before changing readiness; do not rename or relocate it.

## Identity

- Customer: `<customer-id>`
- Accountable owner: `<team-or-person>`
- Readiness: `partial`
- Active IaC root: `.`

## Operating boundary

Describe the infrastructure scope this fork may manage, environments/accounts
included, prohibited scope, and approval authority. Link to the validated
customer-context and standards-binding files rather than duplicating them.

## Source bindings

- Customer context: `config/customer-context.yaml`
- Standards: `config/standards-binding.yaml`
- IaC driver: active `metacloud.yaml`

Do not include secrets, private access instructions, or copied provider
inventory here.
