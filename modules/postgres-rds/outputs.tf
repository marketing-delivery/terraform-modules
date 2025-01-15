output "security_group_id" {
  value = aws_security_group.postgres_rds.id
}

output "db_instance_arn" {
  value = module.postgres_rds.db_instance_arn
}

output "db_name" {
  value = var.db_name
}

output "username" {
  value = module.postgres_rds.db_instance_username
}

output "password" {
  value = random_password.db_password.result
}

output "credentials_secret_id" {
  value = aws_secretsmanager_secret.db_password.id
}

output "port" {
  value = module.postgres_rds.db_instance_port
}

output "host" {
  value = module.postgres_rds.db_instance_address
}