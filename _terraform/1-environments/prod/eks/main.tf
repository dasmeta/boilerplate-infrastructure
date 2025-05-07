## This file and its content are generated based on config, pleas check README.md for more details

module "this" {
  source  = "dasmeta/eks/aws"
  version = "2.21.2"

  account_id = "817342036967"
  adot_config = {"accept_namespace_regex":"(prod)","additional_metrics":[],"log_group_name":"adot-logs"}
  alarms = {"sns_topic":"Default"}
  cluster_enabled_log_types = ["audit"]
  cluster_name = "eks-prod"
  enable_kube_state_metrics = true
  karpenter = {"configs":{"replicas":1},"enabled":true,"resource_configs":{"nodePools":{"general":{"weight":1}}},"resource_configs_defaults":{"limits":{"cpu":100}}}
  map_roles = [{"groups":["system:masters"],"rolearn":"arn:aws:iam::817342036967:role/AWSReservedSSO_AdministratorAccess_78a9f6cd5bce880a","username":"AWSReservedSSO_AdministratorAccess_78a9f6cd5bce880a"}]
  node_groups = {"prod_nodes_on_demond":{"capacity_type":"ON_DEMAND","desired_size":1,"max_capacity":1,"max_size":1,"min_size":1}}
  node_groups_default = {"capacity_type":"SPOT","disk_size":50,"instance_types":["t3.large","t3.medium","t3a.large","m5.large"]}
  prometheus_metrics = ["kube_node_status_condition","kube_node_status_capacity","kube_deployment_spec_replicas","kube_deployment_status_replicas_available"]
  users = [{"username":"terraform"}]
  vpc = {"link":{"id":"${data.tfe_outputs.this["1-environments/prod/vpc"].values.results.id}","private_subnet_ids":"${data.tfe_outputs.this["1-environments/prod/vpc"].values.results.private_subnets}"}}
  providers = {"aws":"aws"}
}


data "tfe_outputs" "this" {
  for_each = { for workspace in ["1-environments/prod/vpc"] : workspace => workspace }

  organization = "Demo-Dasmeta"
  workspace    = replace(each.value, "/[^a-zA-Z0-9_-]+/", "_")
}
