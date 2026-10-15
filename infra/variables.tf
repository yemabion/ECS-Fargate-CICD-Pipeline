variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Short project name used as a resource prefix."
  type        = string
  default     = "cicd-demo"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,19}$", var.project_name))
    error_message = "project_name must be 2-20 chars, lowercase letters, digits and hyphens, starting with a letter."
  }
}

variable "environment" {
  description = "Environment name (e.g. dev, staging, prod)."
  type        = string
  default     = "prod"
}

variable "github_repository" {
  description = "GitHub repository allowed to deploy, in owner/name form."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$", var.github_repository))
    error_message = "github_repository must look like owner/name."
  }
}

variable "github_environment" {
  description = "GitHub Actions environment name the deploy job runs in (part of the OIDC trust condition)."
  type        = string
  default     = "production"
}

variable "create_github_oidc_provider" {
  description = "Create the GitHub OIDC provider. Set false if your AWS account already has one (only one is allowed per account)."
  type        = bool
  default     = true
}

# ---- Networking ----
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of Availability Zones to spread across."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "Use 2 or 3 AZs for high availability."
  }
}

variable "assign_public_ip" {
  description = "Give Fargate tasks a public IP. Needed to pull from ECR without NAT/VPC endpoints; tasks are still only reachable from the ALB security group."
  type        = bool
  default     = true
}

# ---- Application / ECS ----
variable "container_port" {
  type    = number
  default = 3000
}

variable "health_check_path" {
  type    = string
  default = "/health"
}

variable "task_cpu" {
  type    = number
  default = 256
}

variable "task_memory" {
  type    = number
  default = 512
}

variable "desired_count" {
  description = "Initial number of tasks (autoscaling manages it afterwards)."
  type        = number
  default     = 2
}

variable "min_capacity" {
  type    = number
  default = 2
}

variable "max_capacity" {
  type    = number
  default = 4
}

variable "initial_image_tag" {
  description = "Image tag used by the Terraform-created task definition. Must exist in ECR before the service is created (see README: first-push step)."
  type        = string
  default     = "bootstrap"
}

# ---- Operations ----
variable "log_retention_days" {
  type    = number
  default = 30
}

variable "alert_email" {
  description = "Optional email for CloudWatch alarm notifications (must confirm the SNS subscription)."
  type        = string
  default     = ""
}

variable "ecr_force_delete" {
  description = "Allow terraform destroy to delete a non-empty ECR repo. Set false for real production."
  type        = bool
  default     = true
}

variable "alb_deletion_protection" {
  description = "Enable ALB deletion protection. Set true for real production."
  type        = bool
  default     = false
}
