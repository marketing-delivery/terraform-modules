module "postgres_rds" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.identifier

  # Postgres specific settings
  engine               = "postgres"
  engine_version       = "15"
  family              = "postgres15"
  major_engine_version = "15"
  instance_class      = var.instance_class
  allocated_storage   = var.allocated_storage

  # Database settings
  db_name  = var.db_name
  username = var.username
  port     = 5432

  # Network settings
  create_db_subnet_group = true
  db_subnet_group_name   = "${var.identifier}-subnet-group"
  subnet_ids             = var.subnet_ids

  vpc_security_group_ids = [aws_security_group.postgres_rds.id]

  # Maintenance settings
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Monitoring
  monitoring_interval    = "30"
  monitoring_role_name   = "${var.identifier}-RDSMonitoringRole"
  create_monitoring_role = true

  # Security settings
  storage_encrypted = true
  multi_az         = var.multi_az
  
  # Development settings (adjust for production)
  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot

  # Add these parameters to allow script execution
  manage_master_user_password = false
  password                    = random_password.db_password.result

  tags = var.tags
}

# Create a random password for the database
resource "random_password" "db_password" {
  length  = 16
  special = false
}