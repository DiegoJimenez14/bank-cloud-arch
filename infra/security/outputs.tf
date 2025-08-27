output "security_group_id" {
  description = "ID del Security Group principal"
  value       = aws_security_group.main.id
}

output "bastion_sg_id" {
  description = "ID del Security Group de bastion"
  value       = aws_security_group.bastion.id
}
