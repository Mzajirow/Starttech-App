#!/bin/bash
set -e

ECR_REPO=$1
AWS_REGION=$2
ASG_NAME=$3
IMAGE_TAG=${4:-latest}

echo "🚀 Deploying backend..."

if [ -z "$ECR_REPO" ] || [ -z "$AWS_REGION" ] || [ -z "$ASG_NAME" ]; then
  echo "❌ Usage: deploy-backend.sh <ecr-repo> <region> <asg-name> [tag]"
  exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_URI="$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO"

echo "🔐 Logging into ECR..."
aws ecr get-login-password --region $AWS_REGION | \
docker login --username AWS --password-stdin $ECR_URI

echo "🐳 Building Docker image..."
docker build -t $ECR_REPO:$IMAGE_TAG .

echo "🏷 Tagging image..."
docker tag $ECR_REPO:$IMAGE_TAG $ECR_URI:$IMAGE_TAG

echo "📤 Pushing image..."
docker push $ECR_URI:$IMAGE_TAG

echo "🔄 Triggering ASG instance refresh..."
aws autoscaling start-instance-refresh \
  --auto-scaling-group-name $ASG_NAME

echo "✅ Backend deployment triggered!"