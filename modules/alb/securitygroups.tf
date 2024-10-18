# resource "aws_security_group" "alb_sg" {
#   count = var.security_group_id == "" ? 1 : 0
#   name        = "${var.name}-alb-sg"
#   description = "Security group for Application Load Balancer"
#   vpc_id      = var.vpc_id

#   # Allow inbound HTTPS traffic from the internet
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from anywhere (update with specific IP ranges if needed)
#   }

#   # Allow inbound HTTP traffic from the internet
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from anywhere (update with specific IP ranges if needed)
#   }

#   # Allow outbound traffic to the internet
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_security_group_rule" "alb_to_ecs_health_check" {
#   count = var.security_group_id == "" ? 1 : 0
#   type              = "ingress"
#   from_port         = var.container_port
#   to_port           = var.container_port
#   protocol          = "tcp"
#   security_group_id = aws_security_group.ecs_tasks.id
#   source_security_group_id = aws_security_group.alb_sg.id
# }

# Traffic to the ECS cluster should only come from the ALB
# resource "aws_security_group" "ecs_tasks" {
#     count = var.security_group_id == "" ? 1 : 0
#     name        = "${var.name}-ecs-sg"
#     description = "allow inbound access from the ALB only"
#     vpc_id      = var.vpc_id

#     egress {
#         protocol    = "-1"
#         from_port   = 0
#         to_port     = 0
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     tags = local.tags
# }