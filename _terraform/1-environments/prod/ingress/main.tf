## This file and its content are generated based on config, pleas check README.md for more details

module "this" {
  source  = "dasmeta/modules/aws//modules/ingress"
  version = "2.14.7"

  additional_hostnames = ["*.demo.dasmeta.com"]
  alarms = {"enabled":false,"sns_topic":"Default"}
  certificate_arn = "${data.tfe_outputs.this["1-environments/prod/certificate"].values.results.arn}"
  healthcheck_path = "/"
  healthcheck_success_codes = "200-399"
  hostname = "demo.dasmeta.com"
  name = "prod-ingress"
  namespace = "frontend"
  tls_hosts = ["*.demo.dasmeta.com"]
  providers = {"aws":"aws","kubernetes":"kubernetes"}
}


data "tfe_outputs" "this" {
  for_each = { for workspace in ["1-environments/prod/eks","1-environments/prod/certificate"] : workspace => workspace }

  organization = "Demo-Dasmeta"
  workspace    = replace(each.value, "/[^a-zA-Z0-9_-]+/", "_")
}
