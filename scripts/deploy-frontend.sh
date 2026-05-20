#!/bin/bash
set -e

BUCKET=$1
DISTRIBUTION_ID=$2
BUILD_DIR=${3:-dist}

echo "🚀 Deploying frontend..."

if [ -z "$BUCKET" ] || [ -z "$DISTRIBUTION_ID" ]; then
  echo "❌ Usage: deploy-frontend.sh <s3-bucket> <cloudfront-id> [build-dir]"
  exit 1
fi

echo "📦 Syncing build to S3..."
aws s3 sync $BUILD_DIR s3://$BUCKET --delete

echo "♻️ Invalidating CloudFront cache..."
aws cloudfront create-invalidation \
  --distribution-id $DISTRIBUTION_ID \
  --paths "/*"

echo "✅ Frontend deployed successfully!"