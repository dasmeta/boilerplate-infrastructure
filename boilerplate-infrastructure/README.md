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
5. Keep active IaC YAML in the established root-level `0-accounts/`,
   `1-environments/`, and `2-products/` directories. The default `yaml_dir` is
   `.` for backward compatibility.

For Terraform Cloud, install `meta-cli >= 0.0.16`, then use `meta exec` and `meta init` to generate
`_metacloud.tf`. Do not edit generated HCL. Validate source YAML before the
authorised generation workflow:

```bash
meta validate-yaml --yaml-dir .
```

For a VCS-driven HCP workspace, review and commit regenerated `_terraform/`
delivery output together with its source YAML, then verify the remote run.

Do not relocate the root YAML directories in a template update. Existing
customer forks and generated workspace paths depend on that layout.
