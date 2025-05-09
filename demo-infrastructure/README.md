# boilerplate-infrastructure

## Configure
1. Copy .env.example to .env
2. add variables in the .env file
3. `source .env`
4. Set right values in _metacloud.tf file section terraform cloud

## Configure yaml files
1. change domain for the certificate, dns-zone, ingress
2. in the eks add your account_id, AWSReservedSSO_AdministratorAccess_arn, AWSReservedSSO_AdministratorAccess_username
3. by default in the files using region eu-central-1
 
## Run
1. `terraform init && terraform apply -auto-approve`
2. `git add _terraform && git commit`
