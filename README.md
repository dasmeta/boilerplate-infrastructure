# Boilerplate Infrastructure

This repository provides the tenant-neutral structure for customer
infrastructure-management forks. Start with `AGENTS.md` and `AI-INDEX.md`.

- `boilerplate-infrastructure/` is the canonical customer-fork seed.
- `demo-infrastructure/` is non-authoritative reference material.
- `config/`, `schemas/`, and `WORKSPACE.example.md` define customer bootstrap.
- `skills/infra-execution/` is the locally discoverable execution contract.
- `docs/runbooks/` defines fork and IaC driver behavior.

Copy the repository for a customer, complete the schema-backed non-secret
bootstrap, select an IaC driver, and validate before any generation or plan.
CloudBrowser is one supported asset-management adapter; other systems can
implement the same binding contract.

```bash
bash tests/test-template-foundation.sh
```
