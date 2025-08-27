output "s3_bucket_state" {
  description = "Nombre del bucket S3 para almacenar el estado remoto"
  value       = data.aws_s3_bucket.state.id
}

output "dynamodb_table_locks" {
  description = "Nombre de la tabla DynamoDB usada para locks"
  value       = data.aws_dynamodb_table.locks.id
}
