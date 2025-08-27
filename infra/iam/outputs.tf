output "admin_role_arn" {
  description = "ARN del rol de administrador"
  value       = aws_iam_role.admin.arn
}

output "security_role_arn" {
  description = "ARN del rol de seguridad/auditoría"
  value       = aws_iam_role.security.arn
}

