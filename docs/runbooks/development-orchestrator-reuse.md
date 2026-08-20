# Development-Orchestrator Reuse Boundary

The infrastructure template reuses generic mechanics from
`dasmeta/development-orchestrator` revision
`f3d3b684f1d8daf7bcc862078e4fd6bd419aaa09`. It does not reuse product-delivery
semantics.

## Adapted mechanics

- Root `AGENTS.md` plus `AI-INDEX.md` navigation and ownership boundaries.
- A portable repository/source index with role, authority, scope, dependency,
  required/optional status, owner, and remote locator fields.
- A bootstrap proposal lifecycle: `draft`, `needs-input`, `ready`, and
  `approved`.
- Explicit unresolved questions, evidence fingerprint, planned file actions,
  approval evidence, and an immutable proposal token that remains stable across
  the `ready` to `approved` transition but changes with proposal content.
- Read-only discovery before proposal; no active-file writes before approval;
  validation and readback after population.
- One shared shell test runner invoked by GitHub, GitLab, and Bitbucket adapters.
- An explicit upstream-owned versus fork-owned path contract.

## Intentionally excluded

- Feature manifests, feature status, stage advancement, mergeability, and
  product-delivery handoffs.
- Product roles such as intent, contracts, implementation, and validation.
- `00-*` through `05-*` workspace classification.
- Moving, cloning, or symlinking child repositories during infrastructure
  bootstrap.
- Development-orchestrator GitHub-state collection and Codex stage execution.

Infrastructure bootstrap instead binds nine infrastructure management planes,
the chosen IaC driver, asset/provider/IaC evidence sources, standards, and
deployed-stack repository relationships. Bootstrap populates final root paths
in place and never grants apply/destroy authority.
