#!/bin/sh
set -e

# Environment variables are set by packer

# Install Nomad
git clone --branch "${NOMAD_MODULE_VERSION}" https://github.com/hashicorp/terraform-aws-nomad.git /tmp/terraform-aws-nomad
/tmp/terraform-aws-nomad/modules/install-nomad/install-nomad --version "${NOMAD_VERSION}"

# Setup dnsmasq config
sudo tee /etc/dnsmasq.d/10-consul << EOF
# Enable forward lookup of the 'consul' domain:
server=/consul/127.0.0.1#8600

# Modify as appropriate to enable reverse DNS lookups for
# common netblocks found in RFC 1918, 5735, and 6598:
rev-server=10.10.0.0/16,127.0.0.1#8600
EOF

# Install Vault
git clone --branch "${VAULT_MODULE_VERSION}" https://github.com/hashicorp/terraform-aws-vault.git /tmp/terraform-aws-vault
/tmp/terraform-aws-vault/modules/install-vault/install-vault --version "${VAULT_VERSION}"

# Install Consul
git clone --branch "${CONSUL_MODULE_VERSION}"  https://github.com/hashicorp/terraform-aws-consul.git /tmp/terraform-aws-consul
/tmp/terraform-aws-consul/modules/install-consul/install-consul --version "${CONSUL_VERSION}"

# Install dnsmasq
/tmp/terraform-aws-consul/modules/install-dnsmasq/install-dnsmasq
