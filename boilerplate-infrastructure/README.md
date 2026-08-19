# Canonical Customer Infrastructure Seed

This directory becomes the active IaC root in a customer fork. Complete the
repository's schema-backed bootstrap before adding infrastructure so customer
scope, source bindings, standards, approvals, and the IaC lifecycle are known.

## Configure

1. Read `../AGENTS.md`, `../AI-INDEX.md`, and the fork contract.
2. Create the fork-local `WORKSPACE.md` and validated context/standards files.
3. Copy `metacloud.example.yaml` to `metacloud.yaml` and replace only non-secret
   customer identifiers.
4. Select the driver and follow its runbook under `../docs/runbooks/`.
5. Put active IaC YAML under `infrastructure/` or change `yaml_dir` explicitly.

For Terraform Cloud, install `meta-cli >= 0.0.16`, then use `meta exec` and `meta init` to generate
`_metacloud.tf`. Do not edit generated HCL. Validate source YAML before the
authorised generation workflow:

```bash
meta validate-yaml --yaml-dir infrastructure
```

For a VCS-driven HCP workspace, review and commit regenerated `_terraform/`
delivery output together with its source YAML, then verify the remote run.

The content under `examples/legacy-yaml/` is non-authoritative migration
reference and is outside the active YAML root.
