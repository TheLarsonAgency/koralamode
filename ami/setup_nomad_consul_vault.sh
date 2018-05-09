#!/bin/sh
set -e

# Environment variables are set by packer

# Install Nomad
git clone --branch "${NOMAD_MODULE_VERSION}" https://github.com/hashicorp/terraform-aws-nomad.git /tmp/terraform-aws-nomad
/tmp/terraform-aws-nomad/modules/install-nomad/install-nomad --version "${NOMAD_VERSION}"

sudo tee /opt/nomad/config/vault.hcl << EOF
vault {
  enabled          = true
  cert_file        = "/opt/nomad/tls/vault.crt.pem"
  key_file         = "/opt/nomad/tls/vault.key.pem"
  address          = "https://vault.service.consul:8200"
  create_from_role = "nomad-cluster"
}
EOF

sudo mkdir /etc/dnsmasq.d
sudo tee /etc/dnsmasq.d/10-consul << EOF
# Enable forward lookup of the 'consul' domain:
server=/consul/127.0.0.1#8600

# Uncomment and modify as appropriate to enable reverse DNS lookups for
# common netblocks found in RFC 1918, 5735, and 6598:
#rev-server=0.0.0.0/8,127.0.0.1#8600
rev-server=10.0.0.0/8,127.0.0.1#8600
#rev-server=100.64.0.0/10,127.0.0.1#8600
#rev-server=127.0.0.1/8,127.0.0.1#8600
#rev-server=169.254.0.0/16,127.0.0.1#8600
#rev-server=172.16.0.0/12,127.0.0.1#8600
#rev-server=192.168.0.0/16,127.0.0.1#8600
#rev-server=224.0.0.0/4,127.0.0.1#8600
#rev-server=240.0.0.0/4,127.0.0.1#8600
EOF
sudo service dnsmasq enable

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
sudo /tmp/terraform-aws-vault/modules/update-certificate-store/update-certificate-store --cert-file-path /opt/vault/tls/ca.crt.pem
