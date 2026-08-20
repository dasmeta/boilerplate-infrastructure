# Terragrunt Driver

Select `driver: terragrunt` in `metacloud.yaml`. Bind the backend, unit root,
dependency/mocking policy, and execution evidence during bootstrap.

With an existing `metacloud.yaml`, run `meta init` directly, then
`meta validate-yaml`, `meta validate`, and a scoped `meta plan`. Apply only the
approved units. `_metacloud.tf` and `_terragrunt/` are generated and must not be
hand-edited; their commit policy comes from the customer delivery binding, not
the Terraform Cloud policy.
