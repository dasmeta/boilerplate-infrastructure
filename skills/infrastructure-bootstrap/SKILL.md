---
name: infrastructure-bootstrap
description: Bootstrap or refresh a customer infrastructure-management fork by discovering authorized context, proposing non-secret bindings, and populating the existing root structure in place after approval.
---

# Infrastructure Bootstrap

## Purpose

Turn this tenant-neutral fork into a customer-aware infrastructure control
repository without relocating its IaC tree. Use for initial customer bootstrap
and later binding refreshes. Use `infra-execution` only after the requested
scope has sufficient readiness.

## Invariants

- Discovery is read-only until an approved proposal exists.
- Bootstrap may populate values and adapt customer YAML, but it must not move or
  rename `WORKSPACE.md`, `metacloud.yaml`, `config/`, `0-accounts/`,
  `1-environments/`, or `2-products/`.
- Record locators, identifiers, authority, freshness, and owners; never record
  tokens, passwords, private keys, copied provider inventory, or private access
  instructions.
- Asset management is provider-neutral. CloudBrowser is supported but not
  required when another system implements the binding contract.
- Provider APIs remain authoritative for observed state; Git/YAML for declared
  intent; the IaC platform for state/runs; standards bindings for policy.
- Do not mark execution-ready or run IaC while required bindings, access,
  approvals, or evidence are missing.

## Phase 1: Discover And Propose

1. Read `AGENTS.md`, `AI-INDEX.md`, `WORKSPACE.md`, all active files under
   `config/`, `metacloud.yaml`, and the driver runbook.
2. Inspect authorized asset, cloud/provider, Git, IaC-platform, standards,
   change, operations, and knowledge sources. Compare conflicting claims; do
   not choose silently.
3. Refresh `config/infrastructure-source-index.json` with infrastructure,
   delivery-orchestrator, data-platform, governance, module, and validation
   repositories relevant to the customer. Preserve authority and dependency
   boundaries.
4. Draft `workspace/bootstrap/proposal.json` from
   `templates/bootstrap/proposal.example.json`. Populate all nine management
   planes and keep status `needs-input` while questions remain.
5. Ask one focused question at a time for ambiguous customer identity, scope,
   ownership, source authority, driver, access, or approval.
6. Resolve all questions, set the proposal status to `ready`, then validate and
   print the immutable proposal token:

   ```bash
   scripts/bootstrap/validate-proposal.sh \
     --proposal workspace/bootstrap/proposal.json \
     --print-token
   ```

7. Show the proposed value/file changes and the exact token. Obtain explicit
   confirmation before changing active customer files.

## Phase 2: Populate In Place

After confirmation, set proposal status and approval evidence consistently,
revalidate it, and verify that the token is unchanged. The token excludes only
the `ready` to `approved` lifecycle transition and approval evidence; any
proposed customer, binding, driver, source, or file change produces a new token.
Then populate only the approved targets:

- `WORKSPACE.md`
- `config/customer-context.yaml`
- `config/standards-binding.yaml`
- `config/infrastructure-source-index.json`
- `metacloud.yaml`
- customer YAML within the existing `0-accounts/`, `1-environments/`, and
  `2-products/` trees

Do not edit `_metacloud.tf`, `_terraform/`, or `_terragrunt/`. Generate those
through the selected driver only after the context is execution-ready and the
operator separately authorizes generation or execution.

## Verification

1. Validate active context files against their schemas.
2. Run `meta validate-yaml --yaml-dir .`.
3. Read every populated binding back and verify locator, authority, freshness,
   owner, access mode, status, and unresolved gaps.
4. Record actual readiness. `partial` is correct when required context remains
   planned, stale, inaccessible, or a gap.
5. Report evidence consulted, accepted conflicts, populated files, validation,
   approval token, readiness, and next action.
