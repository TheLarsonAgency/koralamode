module "nomad_cluster_servers" {
  source = "git::git@github.com:hashicorp/terraform-aws-nomad.git//modules/nomad-cluster?ref=v0.4.0"

  # Specify the ID of the Nomad AMI. You should build this using the scripts in the install-nomad module.
  ami_id = "${var.ami_id == "" ? data.aws_ami.nomad_consul.image_id : var.ami_id}"

  cluster_name  = "nomad-${var.cluster_name}-servers"
  instance_type = "${var.nomad_instance_type}"

  min_size         = "${var.num_nomad_servers}"
  max_size         = "${var.num_nomad_servers}"
  desired_capacity = "${var.num_nomad_servers}"

  # The EC2 Instances will use these tags to automatically discover each other and form a cluster
  cluster_tag_key   = "${var.nomad_cluster_tag_key}"
  cluster_tag_value = "${var.cluster_name}"

  user_data = "${data.template_file.user_data_server.rendered}"

  vpc_id     = "${module.vpc.vpc_id}"
  subnet_ids = "${module.vpc.private_subnets}"

  allowed_ssh_cidr_blocks     = ["${var.vpc_cidr}"]
  allowed_inbound_cidr_blocks = ["${var.vpc_cidr}"]
  ssh_key_name                = "${var.ssh_key_name}"
}

module "nomad_cluster_clients" {
  source = "git::git@github.com:hashicorp/terraform-aws-nomad.git//modules/nomad-cluster?ref=v0.4.0"

  # Specify the ID of the Nomad AMI. You should build this using the scripts in the install-nomad module.
  ami_id = "${var.ami_id == "" ? data.aws_ami.nomad_consul.image_id : var.ami_id}"

  cluster_name = "nomad-${var.cluster_name}-clients"
  instance_type = "${var.client_instance_type}"

  min_size         = "${var.num_clients_min}"
  max_size         = "${var.num_clients_max}"
  desired_capacity = "${var.num_clients_min}"

  # The EC2 Instances will use these tags to automatically discover each other and form a cluster
  cluster_tag_key   = "${var.client_cluster_tag_key}"
  cluster_tag_value = "${var.cluster_name}"

  user_data = "${data.template_file.user_data_client.rendered}"

  vpc_id     = "${module.vpc.vpc_id}"
  subnet_ids = "${module.vpc.public_subnets}"

  allowed_ssh_cidr_blocks     = ["${var.vpc_cidr}"]
  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
  ssh_key_name                = "${var.ssh_key_name}"
}

module "nomad_server_security_group_rules" {
  source = "git::git@github.com:hashicorp/terraform-aws-nomad.git//modules/nomad-security-group-rules?ref=v0.4.0"
  security_group_id = "${module.nomad_cluster_servers.security_group_id}"
  allowed_inbound_cidr_blocks = ["${var.vpc_cidr}"]
}

#module "nomad_client_security_group_rules" {
#  source = "git::git@github.com:hashicorp/terraform-aws-nomad.git//modules/nomad-security-group-rules?ref=v0.4.0"
#  security_group_id = "${module.nomad_cluster_clients.security_group_id}"
#  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
#}
