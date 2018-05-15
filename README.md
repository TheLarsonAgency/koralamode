# Koralamode

A (somewhat) generic Terraform AWS implementation with the following
requirements in mind:

- Easy to execute
- Secure
- Modular
- Extensible


## Setup

Grab a copy of this project (clone/fork/whatever) and follow these instructions:

1. Use [private-tls-cert](https://github.com/hashicorp/terraform-aws-vault/tree/master/modules/private-tls-cert) to generate some keys.
2. Generate a KMS key in AWS for encrypting/decrypting your certs.
3. Encrypt your certs using the KMS key and upload them to S3.
4. Validate that the `packer` scripts look good in the `ami` directory.
5. Use the provided `ami` directory to generate an AMI (see the README).
6. Validate that the USER-DATA scripts look good in the `scripts` directory.
7. Execute:
    - `terraform init`
	- `terraform plan`
	- `terraform apply`

