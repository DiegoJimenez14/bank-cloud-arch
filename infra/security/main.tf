########################################
# Security Groups base
########################################

# SG principal: sin ingress, egress a Internet
resource "aws_security_group" "main" {
  name        = "bank-sg-main"
  description = "SG base sin ingress, egress all"
  vpc_id      = var.vpc_id

  revoke_rules_on_delete = true

  # Sin reglas de entrada
  # (Si una app las necesita, se crean SGs específicos por servicio)
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "bank-sg-main"
    Environment = "dev"
  }
}

# SG bastion opcional: SSH desde tu IP (setea allowed_ssh_cidr a tu /32 real)
resource "aws_security_group" "bastion" {
  name        = "bank-sg-bastion"
  description = "Permite SSH desde IP administrada"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH desde tu IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "bank-sg-bastion"
    Environment = "dev"
  }
}

