# Arquitectura Cloud (Banco) — AWS + Terraform

Infra de referencia (nivel junior, sólida y compacta) para un banco:
- **Estado remoto**: S3 (`bank-terraform-state-dev`) + **lock** en DynamoDB (`bank-terraform-locks`)
- **Red**: VPC / 2 AZ / subnets públicas y privadas / IGW / NAT GW / ruteo
- **IAM**: rol **admin** y rol **security-audit** (least privilege para auditar)
- **Seguridad**: SG base (sin ingress, sólo egress); SG bastion (SSH restringible por IP /32)

## Estructura
