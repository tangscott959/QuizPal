#!/bin/bash

# AWS EC2 Deployment Script for QuizPal
# This script automates the deployment process

set -e  # Exit on any error

echo "🚀 Starting AWS EC2 deployment for QuizPal..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
EC2_HOST=$1
EC2_USER="ubuntu"
KEY_PATH="$2"
APP_DIR="/home/ubuntu/QuizPal"
WAR_FILE="quiz-project-0.0.1-SNAPSHOT.war"

# Check if parameters are provided
if [ $# -ne 2 ]; then
    echo -e "${RED}❌ Usage: $0 <EC2_HOST> <KEY_PATH>${NC}"
    echo -e "${YELLOW}Example: $0 1.2.3.4 ~/.ssh/quizpal-key.pem${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Configuration:${NC}"
echo -e "  Host: ${YELLOW}$EC2_HOST${NC}"
echo -e "  User: ${YELLOW}$EC2_USER${NC}"
echo -e "  Key: ${YELLOW}$KEY_PATH${NC}"

# Test SSH connection
echo -e "\n${YELLOW}🔍 Testing SSH connection...${NC}"
ssh -i "$KEY_PATH" -o ConnectTimeout=10 -o BatchMode=yes -o StrictHostKeyChecking=no "$EC2_USER@$EC2_HOST" 'echo "SSH connection successful"' || {
    echo -e "${RED}❌ SSH connection failed! Check your key and host.${NC}"
    exit 1
}

echo -e "${GREEN}✅ SSH connection successful!${NC}"

# Deploy commands to run on EC2
echo -e "\n${YELLOW}🚀 Deploying to EC2...${NC}"

ssh -i "$KEY_PATH" "$EC2_USER@$EC2_HOST" << 'EOF'
set -e

echo "📁 Updating application..."
cd /home/ubuntu/QuizPal

echo "🔄 Pulling latest changes..."
git pull origin master

echo "🔨 Building application..."
mvn clean package -DskipTests

echo "🔄 Restarting application with PM2..."
pm2 restart quizpal

echo "📊 Checking application status..."
pm2 status quizpal

echo "✅ Deployment completed!"
EOF

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}🎉 Deployment successful!${NC}"
    echo -e "${GREEN}🌍 Application available at: http://$EC2_HOST${NC}"
else
    echo -e "\n${RED}❌ Deployment failed! Check the logs above.${NC}"
    exit 1
fi

echo -e "\n${YELLOW}📊 Application status:${NC}"
ssh -i "$KEY_PATH" "$EC2_USER@$EC2_HOST" 'pm2 logs quizpal --lines 20'
