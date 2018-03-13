module "vpc" {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git?ref=v1.26.0"

  name = "vpc-${var.cluster_name}"

  cidr = "${var.vpc_cidr}"

  azs                 = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets      = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]

  enable_nat_gateway = false
  #enable_nat_gateway = true
  #single_nat_gateway = true

  #enable_s3_endpoint       = true
  #enable_dynamodb_endpoint = true

  #enable_dhcp_options              = true
  #dhcp_options_domain_name         = "${var.domain_name}"
  #dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Owner       = "user"
    Environment = "${terraform.env}"
    Name        = "${var.domain_name}"
  }
}

