output "aws_region" {
  value = var.aws_region
}

output "alb_dns_name" {
  description = "Load Balancer DNS name"
  value       = aws_lb.app.dns_name
}

output "app_url" {
  description = "URL to submit / open in the browser"
  value       = "http://${aws_lb.app.dns_name}"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "ecr_repository_name" {
  value = aws_ecr_repository.app.name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  value = aws_ecs_service.app.name
}

output "ecs_task_family" {
  value = aws_ecs_task_definition.app.family
}

output "container_name" {
  value = local.container_name
}

output "github_actions_role_arn" {
  description = "Set as the AWS_ROLE_ARN repo variable"
  value       = aws_iam_role.github_deploy.arn
}
