## This file and its content are generated based on config, pleas check README.md for more details

provider "aws" {


  region = "eu-central-1"


  default_tags {

    tags = {"Account":"Dasmeta-Demo","AppliedFrom":"terraform-cloud","ManageLevel":"environment","ManagedBy":"terraform","TerraformCloudWorkspace":"1-environments_prod_ingress","TerraformModuleSource":"dasmeta/modules/aws//modules/ingress","TerraformModuleVersion":"2.14.7"}
  }
}
provider "kubernetes" {


  cluster_ca_certificate = "${data.tfe_outputs.this["1-environments/prod/eks"].values.results.cluster_certificate}"
  host = "${data.tfe_outputs.this["1-environments/prod/eks"].values.results.cluster_host}"

  exec {


api_version = "client.authentication.k8s.io/v1beta1"

args = ["eks","--region","eu-central-1","get-token","--cluster-name","eks-prod"]

command = "aws"

  }

}
