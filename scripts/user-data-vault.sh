#!/bin/bash
# This script is meant to be run in the User Data of each EC2 Instance while it's booting. The script uses the
# run-vault and run-consul scripts to configure and start Consul and Vault in server mode. Note that this script
# assumes it's running in an AMI built from the Packer template in ami folder.

set -v -e

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

readonly VAULT_TLS_CERT_FILE="/opt/vault/tls/vault.crt.pem"
readonly VAULT_TLS_KEY_FILE="/opt/vault/tls/vault.key.pem"

aws s3 cp s3://koralamode-certs/vault/certs.tar.xz.enc /opt/vault/tls/certs.tar.xz.enc

{  # Decrypt certs
  cd /opt/vault/tls
  aws kms decrypt --region us-east-1 --ciphertext-blob \
		  fileb://certs.tar.xz.enc --output text --query Plaintext \
		  | base64 -d | xz -d | tar x
}

# Fix perms
chown -R vault:vault /opt/vault/tls
chmod -R 600 /opt/vault/tls/*

# Install CA
git clone https://github.com/hashicorp/terraform-aws-vault.git /tmp/terraform-aws-vault
/tmp/terraform-aws-vault/modules/update-certificate-store/update-certificate-store --cert-file-path /opt/vault/tls/ca.crt.pem

# These variables are passed in via Terraform template interplation
/opt/consul/bin/run-consul --server --cluster-tag-key "${cluster_tag_key}" --cluster-tag-value "${cluster_tag_value}"
/opt/vault/bin/run-vault --tls-cert-file "$VAULT_TLS_CERT_FILE"  --tls-key-file "$VAULT_TLS_KEY_FILE"
