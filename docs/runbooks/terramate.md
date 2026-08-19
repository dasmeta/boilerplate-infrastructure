# Terramate Driver

Select `driver: terramate` in `metacloud.yaml`. Bind the chosen backend, stack
root, output-sharing mode, mock-input policy, and execution evidence during
bootstrap.

With an existing `metacloud.yaml`, run `meta init` directly, then
`meta validate-yaml`, `meta validate`, and a scoped `meta plan`. Apply only the
approved stacks. `_metacloud.tf` and `_terraform/` are generated and must not be
hand-edited; their commit policy comes from the customer delivery binding, not
the Terraform Cloud policy.
