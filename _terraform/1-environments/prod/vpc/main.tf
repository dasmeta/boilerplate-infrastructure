## This file and its content are generated based on config, pleas check README.md for more details

module "this" {
  source  = "dasmeta/vpc/aws"
  version = "1.0.1"

  availability_zones = ["eu-central-1a","eu-central-1b"]
  cidr = "10.17.0.0/16"
  name = "prod-vpc"
  private_subnet_tags = {"kubernetes.io/cluster/eks-prod":"shared","kubernetes.io/role/internal-elb":"1"}
  private_subnets = ["10.17.1.0/24","10.17.2.0/24"]
  public_subnet_tags = {"kubernetes.io/cluster/eks-prod":"shared","kubernetes.io/role/elb":"1"}
  public_subnets = ["10.17.3.0/24","10.17.4.0/24"]

}


data "tfe_outputs" "this" {
  for_each = { for workspace in [] : workspace => workspace }

  organization = "Demo-Dasmeta"
  workspace    = replace(each.value, "/[^a-zA-Z0-9_-]+/", "_")
}
