module "server_iam_policies" {
  source = "git::git@github.com:hashicorp/terraform-aws-consul//modules/consul-iam-policies?ref=v0.3.3"
  iam_role_id = "${module.nomad_cluster_servers.iam_role_id}"
}

module "consul_server_security_group_rules" {
  source = "git::git@github.com:hashicorp/terraform-aws-consul//modules/consul-client-security-group-rules?ref=v0.3.3"
  security_group_id = "${module.nomad_cluster_servers.security_group_id}"
  allowed_inbound_cidr_blocks = ["${var.vpc_cidr}"]
}

module "client_iam_policies" {
  source = "git::git@github.com:hashicorp/terraform-aws-consul//modules/consul-iam-policies?ref=v0.3.3"
  iam_role_id = "${module.nomad_cluster_clients.iam_role_id}"
}

module "consul_client_security_group_rules" {
  source = "git::git@github.com:hashicorp/terraform-aws-consul//modules/consul-client-security-group-rules?ref=v0.3.3"
  security_group_id = "${module.nomad_cluster_clients.security_group_id}"
  allowed_inbound_cidr_blocks = ["${var.vpc_cidr}"]
}

module "vault_iam_policies" {
  source = "git::git@github.com:hashicorp/terraform-aws-consul//modules/consul-iam-policies?ref=v0.3.3"
  iam_role_id = "${module.vault_cluster.iam_role_id}"
}

module "consul_vault_security_group_rules" {
  source = "git::git@github.com:hashicorp/terraform-aws-consul//modules/consul-security-group-rules?ref=v0.3.3"
  security_group_id = "${module.vault_cluster.security_group_id}"
  allowed_inbound_cidr_blocks = ["${var.vpc_cidr}"]
}
