# Define ECS task definition
resource "aws_ecs_task_definition" "this" {
  family                   = var.name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu  # CPU units for the task (Fargate requires this)
  memory                   = var.task_memory

  container_definitions = jsonencode([
    {
      name      = var.name
      image     = var.image_uri
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
            "awslogs-group"         = "/ecs/${var.name}"
            "awslogs-region"        = var.region
            "awslogs-stream-prefix" = "ecs"
            "awslogs-create-group"  = "true"
        }
      }
      environment = concat([
        {
            "name": "ASPNETCORE_HTTP_PORTS"
            "value": tostring(var.container_port)
        },
        {
            "name": "DOTNET_RUNNING_IN_CONTAINER"
            "value": "true"
        }
      ],
      [for k, v in var.environment_variables : { name = k, value = v }])
      healthCheck = {
            command = [
                "CMD-SHELL",
                "curl -f ${var.health_check_endpoint} || exit 1"
            ]
            interval = 30
            timeout  = 5
            retries  = 3
        }
    }
  ])
  
  execution_role_arn = var.task_execution_role_arn
  
  #task_role_arn      = 
  tags = local.tags
}

# Define ECS service
resource "aws_ecs_service" "this" {
  name            = var.name
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count  # Number of tasks to run
  launch_type      = "FARGATE"
  iam_role = var.service_role_arn

  dynamic "load_balancer" {
    for_each = var.target_group_arn == "" ? toset([]) : toset([1])

    content {
      target_group_arn = var.target_group_arn
      container_name   = var.name  # Name of the container in your task definition
      container_port   = var.container_port  # Port on which your application is listening
    }
  }

  network_configuration {
    subnets          = var.subnets  # Subnets where your Fargate tasks can run
    security_groups  = [var.task_security_group_arn]
    assign_public_ip = false
  }
  tags = local.tags
}

resource "aws_appautoscaling_target" "this" {
  max_capacity       = var.max_capacity  # Maximum number of tasks
  min_capacity       = var.min_capacity   # Minimum number of tasks
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_scaling_policy" {
  name               = "ecs-cpu-utilization-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    # scale_in should be the time it takes to start the container
    scale_in_cooldown  = 60  # Seconds to wait before scaling in
    scale_out_cooldown = 60  # Seconds to wait before scaling out
    target_value       = 50  # Maintain 50% average CPU utilization
  }
}
