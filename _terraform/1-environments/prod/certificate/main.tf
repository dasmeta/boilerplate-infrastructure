## This file and its content are generated based on config, pleas check README.md for more details

module "this" {
  source  = "dasmeta/modules/aws//modules/ssl-certificate"
  version = "2.6.2"

  alternative_domains = ["*.demo.dasmeta.com"]
  alternative_zones = ["demo.dasmeta.com"]
  domain = "demo.dasmeta.com"
  zone = "demo.dasmeta.com"
  providers = {"aws":"aws"}
}


data "tfe_outputs" "this" {
  for_each = { for workspace in [] : workspace => workspace }

  organization = "Demo-Dasmeta"
  workspace    = replace(each.value, "/[^a-zA-Z0-9_-]+/", "_")
}
