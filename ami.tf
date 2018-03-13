# Set the default AMIs (NOTE: Don't use these in production!)

data "aws_ami" "nomad_consul" {
  most_recent      = true

  # If we change the AWS Account in which test are run, update this value.
  owners     = ["562637147889"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "is-public"
    values = ["true"]
  }
 
  filter {
    name   = "name"
    values = ["nomad-consul-ubuntu-*"]
  }
}


data "aws_ami" "vault_consul" {
  most_recent      = true

  # If we change the AWS Account in which test are run, update this value.
  owners     = ["562637147889"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "is-public"
    values = ["true"]
  }
 
  filter {
    name   = "name"
    values = ["vault-consul-ubuntu-*"]
  }
}
