# boilerplate-infrastructure

## Configure
1. Copy metacloud.example.yaml metacloud.yaml
2. Set right values in _metacloud.tf file

## Run
1. `export TF_TOKEN_app_terraform_io="<Terraform Cloud OAuth Token>"`
2. `terraform init && terraform apply -auto-approve`
3. `git add _terraform && git commit`
