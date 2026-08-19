# Demo Infrastructure (Non-Authoritative)

This directory is historical demo material, not the canonical customer-fork
seed. Use `../boilerplate-infrastructure/` for new forks. Do not copy this demo
without reviewing every module, provider, account, secret reference, and
driver setting against current customer standards.

## Configure
1. Copy .env.example to .env
2. add variables in the .env file
3. `source .env`
4. Regenerate `_metacloud.tf` from an active `metacloud.yaml`; do not edit it.

## Configure yaml files
1. change domain for the certificate, dns-zone, ingress & apps
2. in the eks add your account_id, AWSReservedSSO_AdministratorAccess_arn, AWSReservedSSO_AdministratorAccess_username
3. by default in the files using region eu-central-1
 
## Run
1. Validate and review a plan before an explicitly approved apply.
2. `git add _terraform && git commit`
