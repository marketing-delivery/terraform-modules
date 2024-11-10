output "cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

# output "task_execution_role_arn" {
#   value = aws_iam_role.task_execution_role.arn
# }

output "service_role_arn" {
  value = aws_iam_role.service-role.arn
}