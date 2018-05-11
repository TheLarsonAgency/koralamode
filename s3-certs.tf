resource "aws_kms_key" "hashicorp_certs_kms" {
  description             = "KMS key for Hashicorp services"
  deletion_window_in_days = 7
}

resource "aws_s3_bucket" "hashicorp_certs" {
  bucket = "${var.cluster_name}_cert_key"
  acl    = "private"
}

resource "aws_s3_bucket_object" "ca_cert" {
  bucket = "${aws_s3_bucket.hashicorp_certs.id}"
  content_type = "text/plain; charset=utf-8"
  etag = "${md5(file(\"private-tls-cert/certs/vault/ca.crt.pem\"))}"
  key = "vault/ca.crt.pem"
  source = "private-tls-cert/certs/vault/ca.crt.pem"
  kms_key_id = "${aws_kms_key.hashicorp_certs_kms.arn}"
}

resource "aws_s3_bucket_object" "vault_key" {
  bucket = "${aws_s3_bucket.hashicorp_certs.id}"
  content_type = "text/plain; charset=utf-8"
  etag = "${md5(file(\"private-tls-cert/certs/vault/vault.key.pem\"))}"
  key = "vault/vault.key.pem"
  source = "private-tls-cert/certs/vault/vault.key.pem"
  kms_key_id = "${aws_kms_key.hashicorp_certs_kms.arn}"
}

resource "aws_s3_bucket_object" "vault_crt" {
  bucket = "${aws_s3_bucket.hashicorp_certs.id}"
  content_type = "text/plain; charset=utf-8"
  etag = "${md5(file(\"private-tls-cert/certs/vault/vault.crt.pem\"))}"
  key = "vault/vault.crt.pem"
  source = "private-tls-cert/certs/vault/vault.crt.pem"
  kms_key_id = "${aws_kms_key.hashicorp_certs_kms.arn}"
}
