module "server_iam_policies" {
  source = "git::git@github.com:hashicorp/terraform-aws-consul//modules/consul-iam-policies?ref=v0.3.3"
  iam_role_id = "${module.nomad_cluster_servers.iam_role_id}"
}

module "client_iam_policies" {
  source = "git::git@github.com:hashicorp/terraform-aws-consul//modules/consul-iam-policies?ref=v0.3.3"
  iam_role_id = "${module.nomad_cluster_clients.iam_role_id}"
}

module "vault_iam_policies" {
  source = "git::git@github.com:hashicorp/terraform-aws-consul//modules/consul-iam-policies?ref=v0.3.3"
  iam_role_id = "${module.vault_cluster.iam_role_id}"
}
