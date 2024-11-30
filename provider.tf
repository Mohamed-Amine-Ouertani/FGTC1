terraform {
  required_version = ">= 0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
}
  }
}

data "vault_aws_access_credentials" "creds" {
  backend = var.backend
  role    = var.role
}

provider "aws" {
  region = var.region
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key

}
provider "vault" {
  address = var.address
}
