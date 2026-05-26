#!/bin/bash
set -e

FRONTEND_URL=$1
BACKEND_URL=$2

echo "🔍 Running health checks..."

# Frontend check
echo "🌐 Checking frontend..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" $FRONTEND_URL)

if [ "$HTTP_CODE" -eq 200 ]; then
  echo "✅ Frontend healthy"
else
  echo "❌ Frontend failed (HTTP $HTTP_CODE)"
  exit 1
fi

# Backend check
echo "⚙️ Checking backend..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" $BACKEND_URL/health)

if [ "$HTTP_CODE" -eq 200 ]; then
  echo "✅ Backend healthy"
else
  echo "❌ Backend failed (HTTP $HTTP_CODE)"
  exit 1
fi

echo "🎉 All systems healthy!"