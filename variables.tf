variable "ami_id" {
  description = "The ID of the AMI to run in the cluster. This should be an AMI built from the Packer template under ami/nomad-consul.json. If no AMI is specified, the template will 'just work' by using the example public AMIs. WARNING! Do not use the example AMIs in a production setting!"
  default = "ami-0eebab597b7dda990" # ubuntu16-ami
  #default = "ami-01fced5ffed58d19a" # amazon-linux-ami
}

variable "aws_region" {
  description = "The AWS region to deploy into (e.g. us-east-1)."
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Domain under which all services should reside."
  #default     = "service.consul"
  default     = "coolly.ninja"
}

variable "bastion_hostname" {
  description = "The hostname to assign to the bastion host (eg. bastion.${var.domain_name})"
  default     = "console"
}

variable "cluster_name" {
  description = "What to name the cluster and all of its associated resources"
  default     = "koralamode"
}

variable "bastion_instance_type" {
   description = "What kind of instance type to use for the bastion servers"
   default     = "t2.nano"
}

variable "vault_instance_type" {
   description = "What kind of instance type to use for the vault servers"
   default     = "t2.nano"
}

variable "nomad_instance_type" {
   description = "What kind of instance type to use for the nomad servers"
   default     = "t2.nano"
}

variable "client_instance_type" {
   description = "What kind of instance type to use for the nomad clients"
   default     = "t2.small"
}

variable "num_vault_servers" {
  description = "The number of server nodes to deploy. We strongly recommend using 3 or 5."
  default     = 3
}

variable "num_nomad_servers" {
  description = "The number of server nodes to deploy. We strongly recommend using 3 or 5."
  default     = 3
}

variable "num_clients_min" {
  description = "The minimum number of client nodes to deploy."
  default     = 1
}

variable "num_clients_max" {
  description = "The maximum number of client nodes to deploy."
  default     = 6
}

variable "cluster_tag_key" {
  description = "The tag the EC2 Instances will look for to automatically discover each other and form a cluster."
  default     = "Cluster"
}

variable "vault_cluster_tag_key" {
  description = "The tag the EC2 Instances will look for to automatically discover each other and form a cluster."
  default     = "vault-servers"
}

variable "nomad_cluster_tag_key" {
  description = "The tag the EC2 Instances will look for to automatically discover each other and form a cluster."
  default     = "nomad-servers"
}

variable "client_cluster_tag_key" {
  description = "The tag the EC2 Instances will look for to automatically discover each other and form a cluster."
  default     = "nomad-clients"
}

variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair."
  default     = "coollyninja"
}

variable "kms_certs_key_id" {
  description = "The id of a KMS Key that can be used to decrypt the certs from S3"
  default     = "9e4f0608-8ed4-421d-98b5-adaedf6dce19"
}

variable "vpc_cidr" {
  description = "The overarching cidr for the entire VPC"
  default     = "10.10.0.0/16"
}
