# Bootstrap Customer Context

Bootstrap is a bounded setup phase for a new customer fork. It records durable,
non-secret context so later assistants can load facts instead of repeating
discovery questions.

## Procedure

1. Populate the existing `WORKSPACE.md` with the customer ID, accountable
   owner, authorised scope, and prohibited scope.
2. Populate the existing `config/customer-context.yaml` and
   `config/standards-binding.yaml`; populate
   `config/infrastructure-source-index.json` with relevant repository roles,
   authority, scope, and dependencies. Do not create parallel example/active
   files.
3. Replace every example identifier and unresolved placeholder.
4. Bind each management plane to its authoritative system and record status,
   access mode, authority, freshness, owner, and gaps.
5. Select an asset-management adapter. CloudBrowser is one option; use another
   provider when it implements the same context contract.
6. Map deployed stacks and repositories, including delivery orchestrators, to
   the infrastructure scope they create or consume.
7. Populate the existing `metacloud.yaml` with the IaC driver and bind its
   state/run evidence.
8. Bind applicable standards, skills, approvals, and accepted exceptions.
9. Validate the active files against the schemas and set readiness honestly.

Use `skills/infrastructure-bootstrap/SKILL.md` for the reusable two-phase
workflow. Draft a proposal from `templates/bootstrap/proposal.example.json`,
keep unresolved questions explicit, validate it, show its immutable token, and
obtain confirmation before populating active files. The token remains stable
when a `ready` proposal is marked `approved`, but changes if any proposed
binding, driver, source, or file action changes.

## Rules

- Use `bound`, `read-only`, `planned`, `not-applicable`, or `gap` per plane.
- Use `context-ready`, `execution-ready`, or `partial` overall.
- Store locators and identifiers, not secret values or copied inventories.
- Populate values and customer YAML in place. Do not move or rename
  `WORKSPACE.md`, `metacloud.yaml`, `config/`, `0-accounts/`, `1-environments/`,
  or `2-products/` during bootstrap.
- Do not mark execution-ready while required access, approval, driver state, or
  evidence binding is missing.
- Re-bootstrap or refresh bindings when systems, ownership, or standards change.

## Routine-upgrade lookups

Run `ruby scripts/bootstrap/delivery-bindings.rb --scope prod/example-service` from the customer checkout. The report uses exact scope names and obtains the customer identity from local context. It shows the request, service inventory, target environment, declared and observed version sources, release checks, announcement destination and infrastructure documentation. Each row identifies its plane and owner. Exit 0 means all locations are configured, 2 means at least one gap, and 1 means invalid input. The command reads local files. Connector authentication, permission to act, live versions and release outcomes require separate evidence.

During refresh, add a `capabilities` array to the relevant proposal plane. To inspect the proposed locations before approval, add `--preview --proposal PATH`. After the confirmed populate step, copy the reviewed array to the same plane in customer context and commit the matching, non-secret approved proposal at `workspace/bootstrap/proposal.json` in the same customer-repo commit as the active context. During refresh, prepare drafts at a separate path so the last approved record stays usable until the replacement is confirmed. Active lookup checks that each entry matches. Legacy forks can run the report immediately and will see named gaps until they adopt the new fields.

For example, a production release check in the assurance plane could be recorded as follows:

```yaml
capabilities:
  - name: release_checks
    scope: prod/example-service
    owner: service-operations
    status: bound
    provider: git
    locator: tests/smoke/README.md
    operation: read
    connector: git
    release: 2.54.0
```

For unavailable checks use `status: gap` and a `reason` describing what the owner must supply. Explicit opt-outs use `disabled`; a binding needing refresh uses `stale`. Connector releases accept a version number, commit SHA or SHA-256 digest. The optional `mapping` object carries customer field names and lookup details. Keep credentials in the access system.
