output "arn" {
  value = aws_lb.this.arn
}

output "dns_name" {
  value = aws_lb.this.dns_name
}

# output "task_security_group_arn" {
#   value = aws_security_group.ecs_tasks.id
# }
