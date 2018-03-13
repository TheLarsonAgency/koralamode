#!/bin/bash
# This script is meant to be run in the User Data of each EC2 Instance while it's booting. The script uses the
# run-vault and run-consul scripts to configure and start Consul and Vault in server mode. Note that this script
# assumes it's running in an AMI built from the Packer template in ami folder.

set -e

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# These variables are passed in via Terraform template interplation
/opt/consul/bin/run-consul --server --cluster-tag-key "${cluster_tag_key}" --cluster-tag-value "${cluster_tag_value}"
/opt/vault/bin/run-vault --tls-cert-file /opt/vault/tls/vault.crt.pem --tls-key-file /opt/vault/tls/vault.key.pem

# Setup CA
git clone --branch <VERSION> https://github.com/hashicorp/terraform-aws-vault.git
terraform-aws-vault/modules/update-certificate-script/update-certificate-script --cert-file-path /opt/vault/tls/ca.cert.pem
