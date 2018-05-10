# Consul

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


# KMS access to decrypt certs

resource "aws_iam_role_policy" "vault_kms_certs_policy" {
  name = "vault_kms_certs"
  role = "${module.vault_cluster.iam_role_id}"
  policy = "${data.aws_iam_policy_document.kms_certs_source.json}"
}

resource "aws_iam_role_policy" "nomad_server_vault_kms_certs_policy" {
  name = "nomad_server_vault_kms_certs"
  role = "${module.nomad_cluster_servers.iam_role_id}"
  policy = "${data.aws_iam_policy_document.kms_certs_source.json}"
}

resource "aws_iam_role_policy" "nomad_client_vault_kms_certs_policy" {
  name = "nomad_client_vault_kms_certs"
  role = "${module.nomad_cluster_clients.iam_role_id}"
  policy = "${data.aws_iam_policy_document.kms_certs_source.json}"
}

data "aws_iam_policy_document" "kms_certs_source" {
  statement = {
    actions = ["kms:Decrypt"],
    resources = ["arn:aws:kms:*:*:key/${var.kms_certs_key_id}"]
  }
}


# S3 access to download certs

resource "aws_iam_role_policy" "vault_s3_certs_policy" {
  name = "vault_s3_certs"
  role = "${module.vault_cluster.iam_role_id}"
  policy = "${data.aws_iam_policy_document.s3_certs_source.json}"
}

resource "aws_iam_role_policy" "nomad_server_vault_s3_certs_policy" {
  name = "nomad_server_vault_s3_certs"
  role = "${module.nomad_cluster_servers.iam_role_id}"
  policy = "${data.aws_iam_policy_document.s3_certs_source.json}"
}

resource "aws_iam_role_policy" "nomad_client_vault_s3_certs_policy" {
  name = "nomad_client_vault_s3_certs"
  role = "${module.nomad_cluster_clients.iam_role_id}"
  policy = "${data.aws_iam_policy_document.s3_certs_source.json}"
}

data "aws_iam_policy_document" "s3_certs_source" {
  statement = {
    actions = ["s3:GetObject"],
    resources = [
      "arn:aws:s3:::${var.cluster_name}-certs/*/certs.tar.gz.enc",
      "arn:aws:s3:::${var.cluster_name}-certs/*/ca.crt.pem"
    ]
  }
}
