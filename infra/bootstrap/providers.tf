terraform {
  required_version = ">= 1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider principal: Management Account
provider "aws" {
  alias  = "management"
  region = var.region
}

# Provider para cuentas hijas (se conecta vía assume_role)
provider "aws" {
  alias  = "target"
  region = var.region
  assume_role {
    role_arn     = var.org_account_access_role_arn
    session_name = "tf-bootstrap"
  }
}
