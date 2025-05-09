## This file and its content are generated based on config, pleas check README.md for more details

module "this" {
  source  = "dasmeta/service/aws"
  version = "1.1.4"

  alarms = {"enabled":false,"sns_topic":"Default"}
  chart = "strapi"
  chart_version = "16.2.4"
  cluster_name = "eks-prod"
  create_namespace = false
  helm_values = {"cnpg":{"main":{"database":"strapi","enabled":false,"user":"strapi"}},"image":{"repository":"docker.io/vshadbolt/strapi","tag":"4.25.6"},"ingress":{"main":{"annotations":{"alb.ingress.kubernetes.io/group.name":"prod-ingress","alb.ingress.kubernetes.io/group.order":"10","alb.ingress.kubernetes.io/healthcheck-path":"/","alb.ingress.kubernetes.io/listen-ports":"[{\"HTTPS\":443}, {\"HTTP\":80}]","alb.ingress.kubernetes.io/listener-attributes.HTTPS-443":"routing.http.response.access_control_allow_origin.header_value=*,routing.http.response.access_control_allow_headers.header_value=*,routing.http.response.access_control_allow_methods.header_value=POST","alb.ingress.kubernetes.io/success-codes":"200-399","kubernetes.io/ingress.class":"alb"},"enabled":true,"hosts":[{"host":"backend.demo.dasmeta.com","paths":[{"backend":{"service":{"name":"backend-strapi","port":{"number":1337}}},"path":"/","pathType":"Prefix"}]}],"integrations":{"traefik":{"enabled":false}}}},"persistence":{"data":{"enabled":false,"mountPath":"/srv/app"}},"securityContext":{"container":{"readOnlyRootFilesystem":false,"runAsGroup":0,"runAsNonRoot":false,"runAsUser":0}},"service":{"main":{"ports":{"main":{"nodePort":31337,"port":1337,"targetPort":1337}},"type":"NodePort"}},"workload":{"main":{"podSpec":{"containers":{"main":{"env":{"ADMIN_JWT_SECRET":"${data.tfe_outputs.this["0-accounts/prod/master-secret"].values.results.secrets.ADMIN_JWT_SECRET}","ADMIN_URL":"https://backend.demo.dasmeta.com/admin","API_TOKEN_SALT":"${data.tfe_outputs.this["0-accounts/prod/master-secret"].values.results.secrets.API_TOKEN_SALT}","APP_HOST":"0.0.0.0","APP_KEYS":["keya","keyb"],"APP_URL":"https://backend.demo.dasmeta.com/admin","BACKEND_URL":"https://backend.demo.dasmeta.com","DATABASE_CLIENT":"postgres","DATABASE_HOST":"${data.tfe_outputs.this["1-environments/prod/rds-postgres"].values.results.db_instance_address[0].db_instance_address}","DATABASE_NAME":"proddb","DATABASE_PASSWORD":"${data.tfe_outputs.this["0-accounts/prod/master-secret"].values.results.secrets.POSTGRESS_PASS}","DATABASE_PORT":"${data.tfe_outputs.this["1-environments/prod/rds-postgres"].values.results.db_instance_address[0].db_instance_port}","DATABASE_SSL":"true","DATABASE_SSL_REJECT_UNAUTHORIZED":"false","DATABASE_USERNAME":"${data.tfe_outputs.this["1-environments/prod/rds-postgres"].values.results.db_instance_address[0].db_instance_username}","EXTRA_ARGS":"","FAST_REFRESH":false,"HOST":"0.0.0.0","JWT_SECRET":"${data.tfe_outputs.this["0-accounts/prod/master-secret"].values.results.secrets.JWT_SECRET}","NODE_ENV":"development","PORT":1337,"PUBLIC_URL":"https://backend.demo.dasmeta.com","STRAPI_ADMIN_BACKEND_URL":"https://backend.demo.dasmeta.com","STRAPI_DISABLE_UPDATE_NOTIFICATION":true}}}}}}}
  name = "backend"
  namespace = "demo"
  repository = "oci://tccr.io/truecharts"
  providers = {"aws":"aws","kubernetes":"kubernetes"}
}


data "tfe_outputs" "this" {
  for_each = { for workspace in ["0-accounts/prod/master-secret","1-environments/prod/eks","1-environments/prod/rds-postgres"] : workspace => workspace }

  organization = "Demo-Dasmeta"
  workspace    = replace(each.value, "/[^a-zA-Z0-9_-]+/", "_")
}
