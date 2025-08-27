#  Bank Cloud Architecture — AWS + Terraform

Este repo contiene una infraestructura base para un **banco en la nube**, usando **Terraform** sobre **AWS**.  
La idea es tener un setup **sólido, limpio y reutilizable**, pero a un nivel manejable (no ultra corporativo todavía).


¿Qué incluye?

- **Estado remoto**:
  - S3 bucket para guardar el `terraform.tfstate`.
  - DynamoDB table para locks y evitar conflictos.

- **Red (VPC)**:
  - 1 VPC (`10.0.0.0/16`).
  - 2 zonas de disponibilidad (us-east-1a, us-east-1b).
  - Subnets públicas y privadas.
  - Internet Gateway + NAT Gateway.
  - Tablas de ruteo.

- **IAM**:
  - Rol **Admin**.
  - Rol **Security Audit** (solo permisos de auditoría).

- **Seguridad**:
  - Security Group base (solo egress, sin ingress).
  - Security Group para bastion (SSH limitado por IP/32).
  - CloudTrail habilitado para auditoría.
  - S3 con KMS para cifrado.

---

## 📂 Estructura del repo

```bash
bank-cloud-arch/
├── .github/workflows/       # Pipelines de Terraform (plan/apply)
├── docs/                    # Documentación adicional (ej: ISO 27001 mapeo)
├── infra/                   # Infraestructura IaC (Terraform)
│   ├── bootstrap/           # Backend remoto (S3 + DynamoDB)
│   ├── iam/                 # Roles y políticas
│   ├── network/             # VPC, subnets, NAT, ruteo
│   ├── security/            # SG, CloudTrail, KMS
│   └── main.tf              # Orquestación de módulos
├── services/                # Microservicios de ejemplo
│   ├── api-gateway/         # API Gateway + Terraform
│   └── sample-microservice/ # Microservicio Python + Dockerfile
└── README.md

