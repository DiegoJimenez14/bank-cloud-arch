variable "vpc_id" {
  description = "VPC donde se crean los SG"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR permitido para SSH al bastion (ej. 181.50.100.25/32). Usa 0.0.0.0/32 para deshabilitar."
  type        = string
  default     = "0.0.0.0/32"
}
