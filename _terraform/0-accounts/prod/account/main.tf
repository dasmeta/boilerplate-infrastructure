## This file and its content are generated based on config, pleas check README.md for more details

module "this" {
  source  = "dasmeta/account/aws"
  version = "1.2.2"

  secrets = {"enabled":true,"values":{}}
  providers = {"aws":"aws","aws.virginia":"aws.virginia"}
}


data "tfe_outputs" "this" {
  for_each = { for workspace in [] : workspace => workspace }

  organization = "Demo-Dasmeta"
  workspace    = replace(each.value, "/[^a-zA-Z0-9_-]+/", "_")
}
