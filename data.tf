data "template_file" "user_data_server" {
  template = "${file("${path.module}/scripts/user-data-server.sh")}"

  vars {
    cluster_tag_key   = "${var.nomad_cluster_tag_key}"
    cluster_tag_value = "${var.cluster_name}"
    num_servers       = "${var.num_nomad_servers}"
  }
}

data "template_file" "user_data_client" {
  template = "${file("${path.module}/scripts/user-data-client.sh")}"

  vars {
    cluster_tag_key   = "${var.client_cluster_tag_key}"
    cluster_tag_value = "${var.cluster_name}"
  }
}

data "template_file" "user_data_vault" {
  template = "${file("${path.module}/scripts/user-data-vault.sh")}"

  vars {
    cluster_tag_key   = "${var.vault_cluster_tag_key}"
    cluster_tag_value = "${var.cluster_name}"
  }
}

data "aws_subnet_ids" "default" {
  vpc_id = "${module.vpc.vpc_id}"
}

data "aws_instance" "bastion" {
  filter {
    name   = "tag:Name"
    values = ["global-${var.cluster_name}-${var.bastion_hostname}"]
  }
}

data "aws_subnet" "bastion" {
  id = "${data.aws_instance.bastion.subnet_id}"
}

data "aws_route53_zone" "domain" {
  name = "${var.domain_name}."
  private_zone = false
}

data "aws_security_group" "bastion" {
  name = "global-${var.cluster_name}-${var.bastion_hostname}"
}

#data "aws_security_group" "nomad_clients" {
#  name = "nomad-${var.cluster_name}-clients"
#}
#
#data "aws_security_group" "nomad_servers" {
#  name = "nomad-${var.cluster_name}-servers"
#}
#
#data "aws_security_group" "vault" {
#  name = "vault-${var.cluster_name}"
#}
