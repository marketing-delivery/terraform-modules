resource "aws_security_group" "rds" {
  name        = "${var.name}-rds"
  vpc_id      = var.vpc_id
  description = "${var.name}-rds"

  ingress {
    from_port       = local.port
    to_port         = local.port
    protocol        = "tcp"
    security_groups = var.ingress_security_groups
    self            = var.allow_self
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}