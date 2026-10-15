#!/usr/bin/env bash
# Pushes the very first image so the ECS service has something to start.
# Only needed once; afterwards GitHub Actions handles every deployment.
set -euo pipefail

cd "$(dirname "$0")/../infra"
REPO_URL="$(terraform output -raw ecr_repository_url)"
REGION="$(terraform output -raw aws_region)"
TAG="${1:-bootstrap}"

aws ecr get-login-password --region "$REGION" \
  | docker login --username AWS --password-stdin "${REPO_URL%%/*}"

# Fargate task is X86_64: force the platform (matters on Apple Silicon).
docker build --platform linux/amd64 -t "$REPO_URL:$TAG" ..
docker push "$REPO_URL:$TAG"
echo "Pushed $REPO_URL:$TAG"
