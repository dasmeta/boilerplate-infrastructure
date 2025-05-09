## This file and its content are generated based on config, pleas check README.md for more details

module "this" {
  source  = "dasmeta/rds/aws"
  version = "1.4.4"

  alarms = {"enabled":true,"sns_topic":"account-alarms-handling"}
  allocated_storage = 20
  apply_immediately = true
  create_cloudwatch_log_group = false
  create_security_group = true
  db_name = "proddb"
  db_password = "${data.tfe_outputs.this["0-accounts/prod/master-secret"].values.results.secrets.POSTGRESS_PASS}"
  db_username = "postgres"
  egress_with_cidr_blocks = [{"cidr_blocks":"0.0.0.0/0","from_port":0,"protocol":"-1","to_port":0}]
  engine = "postgres"
  engine_version = "15.10"
  identifier = "rds-proddb"
  ingress_with_cidr_blocks = [{"cidr_blocks":"195.250.69.234/32","description":"5432 from VPN","from_port":5432,"protocol":"tcp","to_port":5432}]
  instance_class = "db.t3.medium"
  multi_az = false
  port = "5432"
  skip_final_snapshot = true
  slow_queries = {"enabled":false,"query_duration":1}
  storage_encrypted = true
  storage_type = "gp2"
  subnet_ids = "${data.tfe_outputs.this["1-environments/prod/vpc"].values.results.public_subnets}"
  vpc_id = "${data.tfe_outputs.this["1-environments/prod/vpc"].values.results.id}"
  providers = {"aws":"aws"}
}


data "tfe_outputs" "this" {
  for_each = { for workspace in ["0-accounts/prod/master-secret","1-environments/prod/vpc"] : workspace => workspace }

  organization = "Demo-Dasmeta"
  workspace    = replace(each.value, "/[^a-zA-Z0-9_-]+/", "_")
}
