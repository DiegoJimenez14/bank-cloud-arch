########################################
# Variables esperadas por este módulo
# (deben existir en variables.tf)
# - vpc_cidr
# - name_prefix
# - environment
# - azs
# - public_subnets
# - private_subnets
########################################

########################################
# Locals
########################################
locals {
  public_map  = zipmap(var.azs, var.public_subnets)
  private_map = zipmap(var.azs, var.private_subnets)
}

########################################
# VPC
########################################
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.name_prefix}-vpc"
    Environment = var.environment
  }
}

########################################
# Internet Gateway (IGW)
########################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.name_prefix}-igw"
    Environment = var.environment
  }
}

########################################
# Subnets Públicas
########################################
resource "aws_subnet" "public" {
  for_each = local.public_map

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.name_prefix}-public-${each.key}"
    Environment = var.environment
    AZ          = each.key
  }
}

########################################
# Subnets Privadas
########################################
resource "aws_subnet" "private" {
  for_each = local.private_map

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.name_prefix}-private-${each.key}"
    Environment = var.environment
    AZ          = each.key
  }
}

########################################
# Tabla de Ruteo Pública + Ruta a IGW
########################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.name_prefix}-rt-public"
    Environment = var.environment
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

########################################
# Elastic IPs para NAT Gateways
########################################
resource "aws_eip" "nat" {
  for_each = toset(var.azs)
  domain   = "vpc"

  tags = {
    Name        = "${var.name_prefix}-eip-nat-${each.key}"
    Environment = var.environment
  }
}

########################################
# NAT Gateways (uno por AZ)
########################################
resource "aws_nat_gateway" "gw" {
  for_each      = aws_subnet.public
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id

  tags = {
    Name        = "${var.name_prefix}-nat-${each.key}"
    Environment = var.environment
    AZ          = each.key
  }

  depends_on = [aws_internet_gateway.igw]
}

########################################
# Tablas de Ruteo Privadas + Rutas a NAT
########################################
resource "aws_route_table" "private" {
  for_each = toset(var.azs)
  vpc_id   = aws_vpc.this.id

  tags = {
    Name        = "${var.name_prefix}-rt-private-${each.key}"
    Environment = var.environment
    AZ          = each.key
  }
}

resource "aws_route" "private_to_nat" {
  for_each               = toset(var.azs)
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw[each.key].id
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
