# boilerplate-infrastructure

## Configure
1. Copy metacloud.example.yaml metacloud.yaml
2. Set right values in _metacloud.tf file

## Run
1. `export TF_TOKEN_app_terraform_io="<Terraform Cloud OAuth Token>"`
2. `export TF_VAR_tfc_token="<Terraform Cloud OAuth Token>"`
3. `export TF_VAR_git_token="<Terraform Cloud OAuth Token>"`
4. `terraform init && terraform apply -auto-approve`
5. `git add _terraform && git commit`
