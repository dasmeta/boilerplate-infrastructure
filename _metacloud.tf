terraform {
  cloud {
    organization = "boilerplate-organisation"
    workspaces {
      name = "boilerplate-infrastructure"
    }
  }
}

module "metacloud" {
  source = "github.com/dasmeta/terraform-tfe-cloud.git?ref=DMVP-2598-simplify-tfe-use"

  org   = "boilerplate-organisation"
  token = "..." # terraform cloud token

  git_provider = "github"
  git_org      = "boilerplate-organisation"
  git_repo     = "boilerplate-infrastructure"
  git_token    = "..." # github oauth token
}
