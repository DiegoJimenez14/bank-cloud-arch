output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.this.id
}

output "public_subnets" {
  description = "IDs de las subnets públicas"
  value       = values(aws_subnet.public)[*].id
}

output "private_subnets" {
  description = "IDs de las subnets privadas"
  value       = values(aws_subnet.private)[*].id
}

output "nat_gateways" {
  description = "IDs de los NAT Gateways"
  value       = values(aws_nat_gateway.gw)[*].id
}

