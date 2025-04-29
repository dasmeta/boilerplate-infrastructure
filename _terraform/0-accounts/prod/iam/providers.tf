## This file and its content are generated based on config, pleas check README.md for more details

provider "aws" {



  assume_role {


external_id = "817342036967"

role_arn = "arn:aws:iam::817342036967:role/OrganizationAccountAccessRole"

session_name = "AssumeRoleSession"

  }

  default_tags {

    tags = {"Account":"Dasmeta-Demo","AppliedFrom":"terraform-cloud","ManageLevel":"accountt","ManagedBy":"terraform","TerraformCloudWorkspace":"0-accounts_prod_iam","TerraformModuleSource":"terraform-aws-modules/iam/aws//modules/iam-user","TerraformModuleVersion":"5.30.0"}
  }
}
