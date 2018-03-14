module "vault_elb" {
  # Use version v0.3.0 of the vault-elb module
  source = "github.com/hashicorp/terraform-aws-vault//modules/vault-elb?ref=v0.3.0"

  name = "vault"
  vpc_id = "${module.vpc.vpc_id}"
  subnet_ids = "${module.vpc.public_subnets}"
  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
}

module "vault_cluster" {
  # Use version v0.3.0 of the vault-cluster module
  source = "github.com/hashicorp/terraform-aws-vault//modules/vault-cluster?ref=v0.3.0"

  # Specify the ID of the Vault AMI. You should build this using the scripts in the install-vault module.
  ami_id = "${var.ami_id == "" ? data.aws_ami.nomad_consul.image_id : var.ami_id}"

  load_balancers = ["${module.vault_elb.load_balancer_name}"]

  cluster_name  = "vault-${var.cluster_name}"
  instance_type = "${var.vault_instance_type}"
  cluster_size  = "${var.num_vault_servers}"

  cluster_tag_key   = "${var.vault_cluster_tag_key}"

  user_data = "${data.template_file.user_data_vault.rendered}"

  vpc_id     = "${module.vpc.vpc_id}"
  subnet_ids = "${module.vpc.public_subnets}"

  allowed_inbound_security_group_ids = []
  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
  allowed_ssh_cidr_blocks     = ["${var.vpc_cidr}"]
  ssh_key_name                = "${var.ssh_key_name}"
}
