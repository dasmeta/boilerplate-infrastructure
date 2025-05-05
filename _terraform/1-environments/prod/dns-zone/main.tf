## This file and its content are generated based on config, pleas check README.md for more details

module "this" {
  source  = "dasmeta/dns/aws"
  version = "1.0.4"

  create_zone = true
  records = [{"alb":"prod-ingress","name":"demo.dasmeta.com","target_type":"alb"},{"alb":"prod-ingress","name":"api.demo.dasmeta.com","target_type":"alb"}]
  zone = "demo.dasmeta.com"
  providers = {"aws":"aws"}
}


data "tfe_outputs" "this" {
  for_each = { for workspace in [] : workspace => workspace }

  organization = "Demo-Dasmeta"
  workspace    = replace(each.value, "/[^a-zA-Z0-9_-]+/", "_")
}
