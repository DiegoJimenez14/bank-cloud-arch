terraform {
  backend "s3" {
    bucket         = "bank-terraform-state-dev"
    key            = "root/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "bank-terraform-locks" # warning deprecado: lo ignoramos aquí
    encrypt        = true
  }
}


