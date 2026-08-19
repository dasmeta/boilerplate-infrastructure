# Customer Infrastructure Workspace

Copy this file to `WORKSPACE.md` during customer bootstrap.

## Identity

- Customer: `<customer-id>`
- Accountable owner: `<team-or-person>`
- Readiness: `partial`
- Active IaC root: `boilerplate-infrastructure/`

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
