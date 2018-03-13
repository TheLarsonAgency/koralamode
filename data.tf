data "template_file" "user_data_server" {
  template = "${file("${path.module}/scripts/user-data-server.sh")}"

  vars {
    cluster_tag_key   = "${var.cluster_tag_key}"
    cluster_tag_value = "${var.cluster_name}"
    num_servers       = "${var.num_nomad_servers}"
  }
}

data "template_file" "user_data_client" {
  template = "${file("${path.module}/scripts/user-data-client.sh")}"

  vars {
    cluster_tag_key   = "${var.cluster_tag_key}"
    cluster_tag_value = "${var.cluster_name}"
  }
}

data "template_file" "user_data_vault" {
  template = "${file("${path.module}/scripts/user-data-vault.sh")}"

  vars {
    cluster_tag_key   = "${var.cluster_tag_key}"
    cluster_tag_value = "${var.cluster_name}"
  }
}

data "aws_subnet_ids" "default" {
  vpc_id = "${module.vpc.vpc_id}"
}
