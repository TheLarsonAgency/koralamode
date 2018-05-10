resource "aws_s3_bucket_object" "ca_cert" {
  bucket = "koralamode-certs"
  content_type = "text/plain; charset=utf-8"
  etag = "${md5(file(\"private-tls-cert/certs/vault/ca.crt.pem\"))}"
  key = "vault/ca.crt.pem"
  source = "private-tls-cert/certs/vault/ca.crt.pem"
}

resource "aws_s3_bucket_object" "vault_key" {
  bucket = "koralamode-certs"
  content_type = "text/plain; charset=utf-8"
  etag = "${md5(file(\"private-tls-cert/certs/vault/vault.key.pem\"))}"
  key = "vault/vault.key.pem"
  source = "private-tls-cert/certs/vault/vault.key.pem"
}

resource "aws_s3_bucket_object" "vault_crt" {
  bucket = "koralamode-certs"
  content_type = "text/plain; charset=utf-8"
  etag = "${md5(file(\"private-tls-cert/certs/vault/vault.crt.pem\"))}"
  key = "vault/vault.crt.pem"
  source = "private-tls-cert/certs/vault/vault.crt.pem"
}
