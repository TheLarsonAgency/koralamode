module "bastion" {
  source = "git::git@github.com:cloudposse/terraform-aws-ec2-bastion-server?ref=0.2.1"

  instance_type = "${var.bastion_instance_type}"
  ami = "${var.ami_id == "" ? data.aws_ami.nomad_consul.image_id : var.ami_id}"
  key_name = "${var.ssh_key_name}"
  name = "${var.bastion_hostname}"  # VPC requires DNS hostnames

  stage = "${var.cluster_name}"

  vpc_id = "${module.vpc.vpc_id}"
  subnets = "${module.vpc.public_subnets}"

  zone_id = "${data.aws_route53_zone.domain.zone_id}"
  security_groups = []
}
