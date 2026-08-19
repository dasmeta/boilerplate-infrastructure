# Bootstrap Customer Context

Bootstrap is a bounded setup phase for a new customer fork. It records durable,
non-secret context so later assistants can load facts instead of repeating
discovery questions.

## Procedure

1. Copy `WORKSPACE.example.md` to `WORKSPACE.md`.
2. Copy both files under `config/` from `.example.yaml` to their active names.
3. Resolve the customer ID, accountable owner, and authorised scope.
4. Bind each management plane to its authoritative system and record status,
   access mode, authority, freshness, owner, and gaps.
5. Select an asset-management adapter. CloudBrowser is one option; use another
   provider when it implements the same context contract.
6. Map deployed stacks and repositories, including delivery orchestrators, to
   the infrastructure scope they create or consume.
7. Select an IaC driver in `metacloud.yaml` and bind its state/run evidence.
8. Bind applicable standards, skills, approvals, and accepted exceptions.
9. Validate the active files against the schemas and set readiness honestly.

## Rules

- Use `bound`, `read-only`, `planned`, `not-applicable`, or `gap` per plane.
- Use `context-ready`, `execution-ready`, or `partial` overall.
- Store locators and identifiers, not secret values or copied inventories.
- Do not mark execution-ready while required access, approval, driver state, or
  evidence binding is missing.
- Re-bootstrap or refresh bindings when systems, ownership, or standards change.
