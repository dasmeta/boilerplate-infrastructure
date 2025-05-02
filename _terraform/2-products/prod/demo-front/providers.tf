## This file and its content are generated based on config, pleas check README.md for more details

provider "aws" {




  default_tags {

    tags = {"Account":"prod","AppliedFrom":"terraform-cloud","ManageLevel":"product","ManagedBy":"terraform","TerraformCloudWorkspace":"2-products_prod_demo-front","TerraformModuleSource":"dasmeta/service/aws","TerraformModuleVersion":"1.1.4"}
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
provider "helm" {



  kubernetes {




cluster_ca_certificate = "${data.tfe_outputs.this["1-environments/prod/eks"].values.results.cluster_certificate}"

host = "${data.tfe_outputs.this["1-environments/prod/eks"].values.results.cluster_host}"


exec {
  
  api_version = "client.authentication.k8s.io/v1beta1"
  
  args = ["eks","--region","eu-central-1","get-token","--cluster-name","eks-prod"]
  
  command = "aws"
  }

  }

}
