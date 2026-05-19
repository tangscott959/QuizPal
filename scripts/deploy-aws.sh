#!/bin/bash

# Manual Docker deployment helper. GitHub Actions normally runs this flow.

set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <ec2-host> <ssh-key-path> [image-tag]"
  echo "Example: $0 1.2.3.4 ~/.ssh/quizpal-key.pem latest"
  exit 1
fi

EC2_HOST="$1"
KEY_PATH="$2"
IMAGE_TAG="${3:-latest}"
EC2_USER="${EC2_USER:-ubuntu}"
IMAGE_NAME="${IMAGE_NAME:-ghcr.io/tangscott959/quizpal}"

if [ -z "${DB_URL:-}" ] || [ -z "${DB_USERNAME:-}" ] || [ -z "${DB_PASSWORD:-}" ]; then
  echo "DB_URL, DB_USERNAME, and DB_PASSWORD must be set in your environment."
  exit 1
fi

ssh -i "$KEY_PATH" -o StrictHostKeyChecking=accept-new "$EC2_USER@$EC2_HOST" \
  IMAGE_NAME="$IMAGE_NAME" \
  IMAGE_TAG="$IMAGE_TAG" \
  DB_URL="$DB_URL" \
  DB_USERNAME="$DB_USERNAME" \
  DB_PASSWORD="$DB_PASSWORD" \
  GOOGLE_CLIENT_ID="${GOOGLE_CLIENT_ID:-}" \
  GOOGLE_CLIENT_SECRET="${GOOGLE_CLIENT_SECRET:-}" \
  'bash -s' <<'EOF'
set -euo pipefail

DOCKER="docker"
if ! docker ps >/dev/null 2>&1; then
  DOCKER="sudo docker"
fi

$DOCKER pull "$IMAGE_NAME:$IMAGE_TAG"
$DOCKER stop quizpal >/dev/null 2>&1 || true
$DOCKER rm quizpal >/dev/null 2>&1 || true

$DOCKER run -d \
  --name quizpal \
  --restart unless-stopped \
  -p 8080:8080 \
  -e DB_URL="$DB_URL" \
  -e DB_USERNAME="$DB_USERNAME" \
  -e DB_PASSWORD="$DB_PASSWORD" \
  -e GOOGLE_CLIENT_ID="$GOOGLE_CLIENT_ID" \
  -e GOOGLE_CLIENT_SECRET="$GOOGLE_CLIENT_SECRET" \
  "$IMAGE_NAME:$IMAGE_TAG"

sleep 15
curl -fsS http://localhost:8080/login >/dev/null
echo "QuizPal is running."
EOF
