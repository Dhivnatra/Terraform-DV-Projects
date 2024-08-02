terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "vault_generic_secret" "aws_creds" {
  path = "secret/aws-creds"

}

provider "aws" {
  region = data.vault_generic_secret.aws_creds.data["region"]
  access_key = data.vault_generic_secret.aws_creds.data["aws_access_key_id"]
  secret_key = data.vault_generic_secret.aws_creds.data["aws_secret_access_key"]
}

resource "aws_instance" "demo" {
        ami = "ami-0c2af51e265bd5e0e"
        instance_type = "t2.micro"
}


