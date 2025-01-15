# Store the database password in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_password" {
  name        = "rds-db-${random_uuid.db_secret_uuid.result}"
  description = "The secret associated with the primary RDS DB instance: ${module.postgres_rds.db_instance_arn}"
  tags        = var.tags
}

# Generate a random UUID for the secret name
resource "random_uuid" "db_secret_uuid" {}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    username = module.postgres_rds.db_instance_username
    password = random_password.db_password.result
    connection_string = "Host=${module.postgres_rds.db_instance_address};Database=${var.db_name};Username=${module.postgres_rds.db_instance_username};Password=${random_password.db_password.result}"
  })
}