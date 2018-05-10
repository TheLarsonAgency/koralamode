#!/bin/bash
# This script is meant to be run in the User Data of each EC2 Instance while it's booting. The script uses the
# run-nomad and run-consul scripts to configure and start Consul and Nomad in server mode. Note that this script
# assumes it's running in an AMI built from the Packer template in examples/nomad-consul-ami/nomad-consul.json.

set -v -e

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Configure vault integration
tee /opt/nomad/config/vault.hcl << EOF
vault {
  enabled          = true
  cert_file        = "/opt/nomad/tls/vault.crt.pem"
  key_file         = "/opt/nomad/tls/vault.key.pem"
  address          = "https://active.vault.service.consul:8200"
  create_from_role = "nomad-cluster"
}
EOF
chmod 600 /opt/nomad/config/vault.hcl
chown nomad:nomad /opt/nomad/config/vault.hcl

# Decrypt certs
mkdir /opt/nomad/tls
aws s3 cp s3://koralamode-certs/vault/certs.tar.gz.enc /opt/nomad/tls/certs.tar.gz.enc.b64
base64 -d /opt/nomad/tls/certs.tar.gz.enc.b64 > /opt/nomad/tls/certs.tar.gz.enc

{
  cd /opt/nomad/tls
  aws kms decrypt --region us-east-1 --ciphertext-blob \
		  fileb://certs.tar.gz.enc --output text --query Plaintext \
		  | base64 -d | gzip -d | tar x
}

# Fix perms
chown -R nomad:nomad /opt/nomad/tls
chmod -R 600 /opt/nomad/tls/*

# Install CA
git clone https://github.com/hashicorp/terraform-aws-vault.git /tmp/terraform-aws-vault
/tmp/terraform-aws-vault/modules/update-certificate-store/update-certificate-store --cert-file-path /opt/nomad/tls/ca.crt.pem

# These variables are passed in via Terraform template interplation
/opt/consul/bin/run-consul --client --cluster-tag-key "${cluster_tag_key}" --cluster-tag-value "${cluster_tag_value}"
/opt/nomad/bin/run-nomad --server --num-servers "${num_servers}"
