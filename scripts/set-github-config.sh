#!/usr/bin/env bash
# Copies Terraform outputs into GitHub repository variables (needs the gh CLI,
# authenticated, run from inside the cloned repo).
set -euo pipefail

cd "$(dirname "$0")/../infra"
out() { terraform output -raw "$1"; }

gh variable set AWS_REGION       --body "$(out aws_region)"
gh variable set AWS_ROLE_ARN     --body "$(out github_actions_role_arn)"
gh variable set ECR_REPOSITORY   --body "$(out ecr_repository_name)"
gh variable set ECS_CLUSTER      --body "$(out ecs_cluster_name)"
gh variable set ECS_SERVICE      --body "$(out ecs_service_name)"
gh variable set ECS_TASK_FAMILY  --body "$(out ecs_task_family)"
gh variable set CONTAINER_NAME   --body "$(out container_name)"
echo "GitHub variables configured."
