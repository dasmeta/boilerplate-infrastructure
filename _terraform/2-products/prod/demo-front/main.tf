## This file and its content are generated based on config, pleas check README.md for more details

module "this" {
  source  = "dasmeta/service/aws"
  version = "1.1.4"

  alarms = {"enabled":false,"sns_topic":"Default"}
  cluster_name = "eks-prod"
  create_namespace = true
  helm_values = {"containerPort":80,"image":{"repository":"public.ecr.aws/r0j4a4t3/demo-frontend","tag":"version5"},"ingress":{"annotations":{"alb.ingress.kubernetes.io/group.name":"prod-ingress","alb.ingress.kubernetes.io/group.order":"20","alb.ingress.kubernetes.io/healthcheck-path":"/health","alb.ingress.kubernetes.io/listen-ports":"[{\"HTTPS\":443}, {\"HTTP\":80}]","alb.ingress.kubernetes.io/success-codes":"200-399","kubernetes.io/ingress.class":"alb"},"enabled":true,"hosts":[{"host":"demo.dasmeta.com","paths":[{"backend":{"service":{"name":"frontend","port":"http"}},"path":"/","pathType":"Prefix"}]}]},"service":{"port":80}}
  name = "frontend"
  namespace = "demo"
  providers = {"aws":"aws","kubernetes":"kubernetes"}
}


data "tfe_outputs" "this" {
  for_each = { for workspace in ["1-environments/prod/eks"] : workspace => workspace }

  organization = "Demo-Dasmeta"
  workspace    = replace(each.value, "/[^a-zA-Z0-9_-]+/", "_")
}
