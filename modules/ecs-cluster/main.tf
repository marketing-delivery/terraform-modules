resource "aws_kms_key" "this" {
  description             = "KMS ECS key"
  deletion_window_in_days = 7
  tags                    = local.tags
}

resource "aws_cloudwatch_log_group" "this" {
  name              = var.log_group
  retention_in_days = var.log_retention_days
  tags              = local.tags
}

resource "aws_ecs_cluster" "this" {
  name = var.name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.this.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.this.name
      }
    }
  }
  tags = local.tags
}

# resource "aws_iam_role" "task_execution_role" {
#   name = "${var.name}-task-execution-role"
#   assume_role_policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [{
#       "Effect" : "Allow",
#       "Principal" : {
#         "Service" : "ecs-tasks.amazonaws.com"
#       },
#       "Action" : "sts:AssumeRole"
#     }]
#   })
#   tags = local.tags
# }

# resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
#   role       = aws_iam_role.task_execution_role.name
# }

# resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_cloudwatch" {
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
#   role       = aws_iam_role.task_execution_role.name
# }

# resource "aws_iam_role" "service-role" {
#   name = "${var.name}-service-role"
#   assume_role_policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [{
#       "Effect" : "Allow",
#       "Principal" : {
#         "Service" : "ecs.amazonaws.com"
#       },
#       "Action" : "sts:AssumeRole"
#     }]
#   })
#   tags = local.tags
# }

# resource "aws_iam_role_policy_attachment" "ecs_service_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
#   role       = aws_iam_role.service-role.name
# }
