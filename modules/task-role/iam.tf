resource "aws_iam_role" "task_execution_role" {
  name = "ecs-task-execution-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "ecs-tasks.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.task_execution_role.name
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_cloudwatch" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.task_execution_role.name
}

resource "aws_iam_policy" "ecr_pull_policy" {
  name = "ecr-pull-policy"
  description = "Policy for ECR pull access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability"
        ]
        Resource = [
          "arn:aws:ecr:eu-west-2:767398122598:repository/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_pull_policy_attachment" {
  policy_arn = aws_iam_policy.ecr_pull_policy.arn
  role       = aws_iam_role.task_execution_role.name
}
