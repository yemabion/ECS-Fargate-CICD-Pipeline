locals {
  name           = "${var.project_name}-${var.environment}"
  container_name = "app"

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Repository  = var.github_repository
  }
}
