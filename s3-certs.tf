## Generate a temp KMS key to encrypt generated certs
#
#
## private-tls-cert's
#
## vault
#module "vault_certs" {
#  source = "git::git@github.com:hashicorp/terraform-aws-vault//modules/private-tls-cert?ref=v0.6.2"
#
#  ca_public_key_file_path = "certs/vault/ca.crt.pem"
#  public_key_file_path = "certs/vault/vault.crt.pem"
#  private_key_file_path = "certs/vault/vault.key.pem"
#
#  owner = "amigx"
#  organization_name = "${var.cluster_name}"
#  ca_common_name = "${var.domain_name}"
#  common_name = "${var.domain_name}"
#  dns_names = ["active.vault.service.consul", "vault.service.consul"]
#  ip_addresses = []
#  validity_period_hours = 86700
#}
#
#
## KMS
#resource "aws_kms_key" "hashicorp_certs_kms" {
#  description             = "KMS key for Hashicorp services"
#  deletion_window_in_days = 7
#}
#
#
## S3 bucket
#resource "aws_s3_bucket" "hashicorp_certs" {
#  bucket = "${var.cluster_name}-certs"
#  acl    = "private"
#}
#
#
## CA, cert, and key
#resource "aws_s3_bucket_object" "ca_cert" {
#  bucket = "${aws_s3_bucket.hashicorp_certs.id}"
#  content_type = "text/plain; charset=utf-8"
#  etag = "${md5(file("private-tls-cert/certs/vault/ca.crt.pem"))}"
#  key = "vault/ca.crt.pem"
#  source = ".terraform/modules/private-tls-cert/certs/vault/ca.crt.pem"
#  kms_key_id = "${aws_kms_key.hashicorp_certs_kms.arn}"
#}
#
#resource "aws_s3_bucket_object" "vault_key" {
#  bucket = "${aws_s3_bucket.hashicorp_certs.id}"
#  content_type = "text/plain; charset=utf-8"
#  etag = "${md5(file("private-tls-cert/certs/vault/vault.key.pem"))}"
#  key = "vault/vault.key.pem"
#  source = "private-tls-cert/certs/vault/vault.key.pem"
#  kms_key_id = "${aws_kms_key.hashicorp_certs_kms.arn}"
#}
#
#resource "aws_s3_bucket_object" "vault_crt" {
#  bucket = "${aws_s3_bucket.hashicorp_certs.id}"
#  content_type = "text/plain; charset=utf-8"
#  etag = "${md5(file("private-tls-cert/certs/vault/vault.crt.pem"))}"
#  key = "vault/vault.crt.pem"
#  source = "private-tls-cert/certs/vault/vault.crt.pem"
#  kms_key_id = "${aws_kms_key.hashicorp_certs_kms.arn}"
#}
