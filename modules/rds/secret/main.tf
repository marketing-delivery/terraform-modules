resource "aws_secretsmanager_secret" "secret" {
  name                           = "${var.secret_prefix}/db/${var.name}"
  description                    = var.description
  force_overwrite_replica_secret = true
  tags                           = var.tags
}

resource "aws_secretsmanager_secret_version" "secret_value" {
  secret_id = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode({
    username             = var.username
    password             = var.password
    engine               = var.engine
    host                 = var.host
    port                 = var.port
    dbname               = var.dbname
    dbInstanceIdentifier = var.dbInstanceIdentifier
    connectionString     = "Server=${var.host};Port=${var.port};Database=${var.dbname};Username=${var.username};Password=${var.password};Pooling=false;CommandTimeout=1800;"
  })
}