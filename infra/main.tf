terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider por defecto para la mayoría de módulos
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

# Provider aliased específicamente para el módulo "network"
provider "aws" {
  alias   = "network"
  region  = "us-east-1"
  profile = "default"
}

# -------------------------------------------------------------------
# Módulos
# -------------------------------------------------------------------

module "bootstrap" {
  source = "./bootstrap"
}

module "network" {
  source = "./network"

  # IMPORTANTe: el módulo network usará el provider aliased "aws.network"
  providers = {
    aws = aws.network
  }
}

module "iam" {
  source = "./iam"
}

module "security" {
  source = "./security"

  # Variables del módulo security
  vpc_id           = module.network.vpc_id
  allowed_ssh_cidr = "0.0.0.0/32" # cambia a tu IP/32 real si quieres abrir SSH al bastion
}

# -------------------------------------------------------------------
# Outputs globales
# -------------------------------------------------------------------

output "state_bucket" {
  description = "Bucket S3 para el estado de Terraform"
  value       = module.bootstrap.s3_bucket_state
}

output "dynamodb_table" {
  description = "Tabla DynamoDB para locks"
  value       = module.bootstrap.dynamodb_table_locks
}

output "vpc_id" {
  description = "ID de la VPC"
  value       = module.network.vpc_id
}

output "public_subnets" {
  description = "IDs de las subnets públicas"
  value       = module.network.public_subnets
}

output "private_subnets" {
  description = "IDs de las subnets privadas"
  value       = module.network.private_subnets
}

output "nat_gateways" {
  description = "IDs de los NAT Gateways"
  value       = module.network.nat_gateways
}

output "admin_role_arn" {
  description = "ARN del rol de administrador"
  value       = module.iam.admin_role_arn
}

output "security_role_arn" {
  description = "ARN del rol de seguridad/auditoría"
  value       = module.iam.security_role_arn
}

output "main_security_group" {
  description = "ID del Security Group principal"
  value       = module.security.security_group_id
}

output "bastion_security_group" {
  description = "ID del Security Group de bastion"
  value       = module.security.bastion_sg_id
}
