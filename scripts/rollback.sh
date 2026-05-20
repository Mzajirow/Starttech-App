#!/bin/bash
set -e

SERVICE=$1

echo "⏪ Starting rollback for $SERVICE..."

if [ "$SERVICE" == "frontend" ]; then
  BUCKET=$2
  VERSION_ID=$3

  echo "🔁 Rolling back frontend..."

  aws s3 cp s3://$BUCKET/index.html s3://$BUCKET/index.html \
    --version-id $VERSION_ID

  echo "♻️ Invalidating CloudFront..."
  aws cloudfront create-invalidation --distribution-id $4 --paths "/*"

elif [ "$SERVICE" == "backend" ]; then
  ASG_NAME=$2
  TEMPLATE_VERSION=$3

  echo "🔁 Rolling back backend..."

  aws autoscaling update-auto-scaling-group \
    --auto-scaling-group-name $ASG_NAME \
    --launch-template "LaunchTemplateName=$ASG_NAME,Version=$TEMPLATE_VERSION"

  aws autoscaling start-instance-refresh \
    --auto-scaling-group-name $ASG_NAME

else
  echo "❌ Usage:"
  echo "  rollback.sh frontend <bucket> <version-id> <cloudfront-id>"
  echo "  rollback.sh backend <asg-name> <template-version>"
  exit 1
fi

echo "✅ Rollback completed!"