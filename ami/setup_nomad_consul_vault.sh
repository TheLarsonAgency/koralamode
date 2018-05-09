#!/bin/sh
set -e

# Environment variables are set by packer

# Install Nomad
git clone --branch "${NOMAD_MODULE_VERSION}" https://github.com/hashicorp/terraform-aws-nomad.git /tmp/terraform-aws-nomad
/tmp/terraform-aws-nomad/modules/install-nomad/install-nomad --version "${NOMAD_VERSION}"

sudo tee /opt/nomad/config/vault.hcl << EOF
vault {
  enabled   = true
  cert_file = "/opt/nomad/tls/vault.crt.pem"
  key_file  = "/opt/nomad/tls/vault.key.pem"
  create_from_role = "nomad-cluster"
}
EOF

# Install Vault
git clone --branch "${VAULT_MODULE_VERSION}" https://github.com/hashicorp/terraform-aws-vault.git /tmp/terraform-aws-vault
/tmp/terraform-aws-vault/modules/install-vault/install-vault --version "${VAULT_VERSION}"

# Install Consul
git clone --branch "${CONSUL_MODULE_VERSION}"  https://github.com/hashicorp/terraform-aws-consul.git /tmp/terraform-aws-consul
/tmp/terraform-aws-consul/modules/install-consul/install-consul --version "${CONSUL_VERSION}"

# Download, decrypt, and install certs
wget -O - https://s3.amazonaws.com/koralamode-vault/certs.tar.gz.enc | base64 -d > certs.tar.gz.enc
aws kms decrypt --region us-east-1 --ciphertext-blob fileb://certs.tar.gz.enc --output text --query Plaintext | base64 -d | gzip -d | sudo tar x -C /opt/vault/tls/
sudo chown -R vault:vault /opt/vault/tls
sudo cp -a /opt/vault/tls /opt/nomad/
sudo chown -R nomad:nomad /opt/nomad

# Add the Vault CA
sudo aws s3 cp s3://koralamode-vault/ca.crt.pem /var/certs/
sudo /tmp/terraform-aws-vault/modules/update-certificate-store/update-certificate-store --cert-file-path /var/certs/ca.crt.pem
