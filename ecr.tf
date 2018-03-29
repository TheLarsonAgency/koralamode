# IAM Role is provided. It will be granted ECR permissions
data "aws_iam_role" "ecr" {
  name = "ecr"
}

module "ecr" {
  source              = "git::https://github.com/cloudposse/terraform-aws-ecr.git?ref=master"
  name                = "${var.domain_name}"
  namespace           = "${var.cluster_name}"
  stage               = "${terraform.env}"
  #roles               = ["${data.aws_iam_role.ecr.name}"]
}
