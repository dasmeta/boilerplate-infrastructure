## This file and its content are generated based on config, pleas check README.md for more details

module "this" {
  source  = "terraform/any/shared//modules/service"
  version = "1.1.1"

  alarms = {"sns_topic":"Default"}
  cluster_name = "eks-prod"
  helm_values = {"containerPort":80,"image":{"repository":"public.ecr.aws/r0j4a4t3/demo-frontend","tag":"latest"},"service":{"port":80}}
  name = "frontend"
  namespace = "frontend"
  providers = {"aws":"aws","kubernetes":"kubernetes"}
}


data "tfe_outputs" "this" {
  for_each = { for workspace in ["1-environments/prod/eks"] : workspace => workspace }

  organization = "Demo-Dasmeta"
  workspace    = replace(each.value, "/[^a-zA-Z0-9_-]+/", "_")
}
