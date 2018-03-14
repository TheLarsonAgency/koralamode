output "aws_region" {
  value = "${var.aws_region}"
}

output "num_nomad_servers" {
  value = "${module.nomad_cluster_servers.cluster_size}"
}

output "asg_name_servers" {
  value = "${module.nomad_cluster_servers.asg_name}"
}

output "launch_config_name_servers" {
  value = "${module.nomad_cluster_servers.launch_config_name}"
}

output "iam_role_arn_servers" {
  value = "${module.nomad_cluster_servers.iam_role_arn}"
}

output "iam_role_id_servers" {
  value = "${module.nomad_cluster_servers.iam_role_id}"
}

output "security_group_id_servers" {
  value = "${module.nomad_cluster_servers.security_group_id}"
}

output "num_clients" {
  value = "${module.nomad_cluster_clients.cluster_size}"
}

output "asg_name_clients" {
  value = "${module.nomad_cluster_clients.asg_name}"
}

output "launch_config_name_clients" {
  value = "${module.nomad_cluster_clients.launch_config_name}"
}

output "iam_role_arn_clients" {
  value = "${module.nomad_cluster_clients.iam_role_arn}"
}

output "iam_role_id_clients" {
  value = "${module.nomad_cluster_clients.iam_role_id}"
}

output "security_group_id_clients" {
  value = "${module.nomad_cluster_clients.security_group_id}"
}

output "nomad_servers_cluster_tag_key" {
  value = "${module.nomad_cluster_servers.cluster_tag_key}"
}

output "nomad_servers_cluster_tag_value" {
  value = "${module.nomad_cluster_servers.cluster_tag_value}"
}

output "vault_fully_qualified_domain_name" {
  value = "${module.vault_elb.fully_qualified_domain_name}"
}

output "vault_elb_dns_name" {
  value = "${module.vault_elb.load_balancer_dns_name}"
}

output "asg_name_vault_cluster" {
  value = "${module.vault_cluster.asg_name}"
}

output "launch_config_name_vault_cluster" {
  value = "${module.vault_cluster.launch_config_name}"
}

output "iam_role_arn_vault_cluster" {
  value = "${module.vault_cluster.iam_role_arn}"
}

output "iam_role_id_vault_cluster" {
  value = "${module.vault_cluster.iam_role_id}"
}

output "security_group_id_vault_cluster" {
  value = "${module.vault_cluster.security_group_id}"
}

output "asg_name_consul_cluster" {
  value = "${module.nomad_cluster_servers.asg_name}"
}

output "launch_config_name_consul_cluster" {
  value = "${module.nomad_cluster_servers.launch_config_name}"
}

output "iam_role_arn_consul_cluster" {
  value = "${module.nomad_cluster_servers.iam_role_arn}"
}

output "iam_role_id_consul_cluster" {
  value = "${module.nomad_cluster_servers.iam_role_id}"
}

output "security_group_id_consul_cluster" {
  value = "${module.nomad_cluster_servers.security_group_id}"
}

output "vault_servers_cluster_tag_key" {
  value = "${module.vault_cluster.cluster_tag_key}"
}

output "vault_servers_cluster_tag_value" {
  value = "${module.vault_cluster.cluster_tag_value}"
}

output "ssh_key_name" {
  value = "${var.ssh_key_name}"
}

output "vault_cluster_size" {
  value = "${var.num_vault_servers}"
}
