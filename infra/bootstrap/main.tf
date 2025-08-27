# Módulo bootstrap de solo lectura:
# Lee el bucket S3 y la tabla DynamoDB existentes por nombre y los expone como outputs.

# Usa el provider AWS del root;

# Datos del bucket S3 donde vive el estado remoto
data "aws_s3_bucket" "state" {
  bucket = "bank-terraform-state-dev"
}

# Datos de la tabla DynamoDB usada para locks
data "aws_dynamodb_table" "locks" {
  name = "bank-terraform-locks"
}

