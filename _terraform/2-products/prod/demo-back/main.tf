## This file and its content are generated based on config, pleas check README.md for more details

module "this" {
  source  = "dasmeta/service/aws"
  version = "1.1.4"

  alarms = {"enabled":false,"sns_topic":"Default"}
  cluster_name = "eks-prod"
  create_namespace = false
  helm_values = {"containerPort":1337,"image":{"repository":"vshadbolt/strapi","tag":"5.12.7"},"ingress":{"annotations":{"alb.ingress.kubernetes.io/group.name":"prod-ingress","alb.ingress.kubernetes.io/group.order":"10","alb.ingress.kubernetes.io/healthcheck-path":"/","alb.ingress.kubernetes.io/listen-ports":"[{\"HTTPS\":443}, {\"HTTP\":80}]","alb.ingress.kubernetes.io/success-codes":"200-399","kubernetes.io/ingress.class":"alb"},"enabled":true,"hosts":[{"host":"api.demo.dasmeta.com","paths":[{"backend":{"service":{"name":"backend","port":"http"}},"path":"/","pathType":"Prefix"}]}]},"service":{"port":1337},"strapi":{"env":[{"name":"HOST","value":"0.0.0.0"},{"name":"PORT","value":"1337"},{"name":"STRAPI_ADMIN_BACKEND_URL","value":"https://api.demo.dasmeta.com"},{"name":"STRAPI_PUBLIC_URL","value":"https://api.demo.dasmeta.com"}]}}
  name = "backend"
  namespace = "demo"
  providers = {"aws":"aws","kubernetes":"kubernetes"}
}


data "tfe_outputs" "this" {
  for_each = { for workspace in ["1-environments/prod/eks"] : workspace => workspace }

  organization = "Demo-Dasmeta"
  workspace    = replace(each.value, "/[^a-zA-Z0-9_-]+/", "_")
}
