# Provenance

Adapted from the proposal/approval/bootstrap mechanics in
`dasmeta/development-orchestrator` at revision
`f3d3b684f1d8daf7bcc862078e4fd6bd419aaa09`.

The infrastructure adaptation intentionally removes repository move, symlink,
clone, feature-stage, and product-routing behavior. It keeps read-only
discovery, unresolved-question state, deterministic proposal validation,
immutable confirmation tokens, populate-after-approval behavior, and readback
verification. Infrastructure-specific management planes, source authority,
driver readiness, generated boundaries, and no-secret rules replace the
development-orchestrator taxonomy.
