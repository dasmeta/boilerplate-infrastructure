## This file and its content are generated based on config, pleas check README.md for more details

module "this" {
  source  = "dasmeta/grafana/onpremise"
  version = "1.16.3"

  alerts = {"rules":[{"datasource":"prometheus","equation":"gt","expr":"sum(rate(container_cpu_usage_seconds_total{namespace=\\\"demo\\\",pod=~\\\"frontend.*\\\"}[5m]))","function":"Last","name":"Frontend High CPU Alert","threshold":95}]}
  aws_region = "eu-central-1"
  cluster_name = "eks-prod"
  grafana_admin_password = "password"
  grafana_configs = {"datasources":[{"name":"cloudwatch","type":"cloudwatch"}],"ingress":{"annotations":{"alb.ingress.kubernetes.io/group.name":"prod-ingress"},"hosts":["grafana.demo.dasmeta.com"]},"persistence":{"size":"10Gi","storage_class":"gp2"},"redundency":{"enabled":true},"resources":{"limits":{"cpu":"1","mem":"2Gi"},"request":{"cpu":"1","mem":"2Gi"}}}
  loki_configs = {"enabled":true}
  name = "demo-prod-grafana"
  prometheus_configs = {"enabled":true,"replicas":1,"resources":{"limit":{"cpu":"1500m","mem":"1.5Gi"},"request":{"cpu":"1","mem":"1Gi"}},"storage_class":"gp2","storage_size":"10Gi"}
  tempo_configs = {"enabled":false}
  providers = {"aws":"aws","kubernetes":"kubernetes"}
}


data "tfe_outputs" "this" {
  for_each = { for workspace in ["1-environments/prod/eks"] : workspace => workspace }

  organization = "Demo-Dasmeta"
  workspace    = replace(each.value, "/[^a-zA-Z0-9_-]+/", "_")
}
