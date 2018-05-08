#module "vault_elb" {
#  source = "github.com/hashicorp/terraform-aws-vault//modules/vault-elb?ref=v0.6.2"
#
#  name = "vault"
#  vpc_id = "${module.vpc.vpc_id}"
#  subnet_ids = "${module.vpc.public_subnets}"
#  allowed_inbound_cidr_blocks = ["${var.vpc_cidr}"]
#  vault_asg_name = "${module.vault_cluster.asg_name}"
#  create_dns_entry = true
#  hosted_zone_id = "vault"
#  domain_name = "coolly.ninja"
#}

module "vault_cluster" {
  source = "github.com/hashicorp/terraform-aws-vault//modules/vault-cluster?ref=v0.6.2"

  # Specify the ID of the Vault AMI. You should build this using the scripts in the install-vault module.
  ami_id = "${var.ami_id == "" ? data.aws_ami.nomad_consul.image_id : var.ami_id}"

#  load_balancers = ["${module.vault_elb.load_balancer_name}"]

  cluster_name  = "vault-${var.cluster_name}"
  instance_type = "${var.vault_instance_type}"
  cluster_size  = "${var.num_vault_servers}"

  cluster_tag_key   = "Name"

  user_data = "${data.template_file.user_data_vault.rendered}"

  vpc_id     = "${module.vpc.vpc_id}"
  subnet_ids = "${module.vpc.private_subnets}"

  allowed_inbound_security_group_ids = []
  allowed_inbound_cidr_blocks = ["${var.vpc_cidr}"]
  allowed_ssh_cidr_blocks     = ["${var.vpc_cidr}"]
  ssh_key_name                = "${var.ssh_key_name}"

  cluster_extra_tags = [
    {
      key = "${var.cluster_tag_key}"
      value = "${var.cluster_name}"
      propagate_at_launch = true
    }
  ]
}
