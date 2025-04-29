## This file and its content are generated based on config, pleas check README.md for more details

module "this" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.30.0"

  create_iam_access_key = true
  create_iam_user_login_profile = false
  name = "terraform"
  policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]

}


data "tfe_outputs" "this" {
  for_each = { for workspace in [] : workspace => workspace }

  organization = "Demo-Dasmeta"
  workspace    = replace(each.value, "/[^a-zA-Z0-9_-]+/", "_")
}
