# Security group for RDS
locals {
  security_group_name = "${var.identifier}-sg"
}

resource "aws_security_group" "postgres_rds" {
  name        = local.security_group_name
  description = "Security group for ${var.identifier} Postgres RDS"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = local.security_group_name
    }
  )
}