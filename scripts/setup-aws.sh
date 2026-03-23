#!/bin/bash

# AWS EC2 Initial Setup Script for QuizPal
# Run this script once to set up the EC2 instance

set -e

echo "🌊 Setting up AWS EC2 for QuizPal deployment..."

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}📦 Installing system dependencies...${NC}"

# Update system
sudo apt update && sudo apt upgrade -y

# Install essential packages
sudo apt install -y \
    openjdk-8-jdk \
    maven \
    git \
    mysql-client \
    nginx \
    curl \
    wget \
    unzip \
    htop \
    nano

echo -e "${GREEN}✅ Dependencies installed${NC}"

# Install Node.js and PM2
echo -e "${BLUE}📦 Installing Node.js and PM2...${NC}"
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g pm2

echo -e "${GREEN}✅ Node.js and PM2 installed${NC}"

# Verify installations
echo -e "${BLUE}🔍 Verifying installations...${NC}"
java -version
mvn -version
git --version
node --version
pm2 --version

# Create application directory
echo -e "${BLUE}📁 Setting up application directory...${NC}"
cd /home/ubuntu
git clone https://github.com/tangscott959/QuizPal.git
cd QuizPal

# Build application
echo -e "${BLUE}🔨 Building QuizPal application...${NC}"
mvn clean package -DskipTests

# Create PM2 ecosystem file
echo -e "${BLUE}⚙️ Creating PM2 configuration...${NC}"
cat > ecosystem.config.js << 'EOF'
module.exports = {
  apps: [{
    name: 'quizpal',
    script: 'java',
    args: ['-jar', 'target/quiz-project-0.0.1-SNAPSHOT.war'],
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production',
      SPRING_PROFILES_ACTIVE: 'production'
    }
  }]
};
EOF

# Start application with PM2
echo -e "${BLUE}🚀 Starting application with PM2...${NC}"
pm2 start ecosystem.config.js
pm2 save
pm2 startup

# Setup Nginx
echo -e "${BLUE}🌐 Configuring Nginx...${NC}"
sudo rm -f /etc/nginx/sites-enabled/default

cat > /tmp/quizpal << 'EOF'
server {
    listen 80;
    server_name _;
    
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Handle WebSocket connections
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
    
    # Static files caching
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        proxy_pass http://localhost:8080;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

sudo mv /tmp/quizpal /etc/nginx/sites-available/quizpal
sudo ln -s /etc/nginx/sites-available/quizpal /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# Setup firewall
echo -e "${BLUE}🔥 Configuring firewall...${NC}"
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw --force enable

# Create deployment script
echo -e "${BLUE}📜 Creating deployment script...${NC}"
cat > /home/ubuntu/deploy.sh << 'EOF'
#!/bin/bash
cd /home/ubuntu/QuizPal
git pull origin master
mvn clean package -DskipTests
pm2 restart quizpal
echo "Deployment completed at $(date)"
EOF

chmod +x /home/ubuntu/deploy.sh

echo -e "${GREEN}✅ Setup completed!${NC}"
echo -e "${YELLOW}🌍 Application will be available at: http://$(curl -s ifconfig.me)${NC}"
echo -e "${YELLOW}📊 Check application status: pm2 status${NC}"
echo -e "${YELLOW}📋 View logs: pm2 logs quizpal${NC}"
echo -e "${YELLOW}🔄 Deploy updates: /home/ubuntu/deploy.sh${NC}"

# Show current status
echo -e "${BLUE}📊 Current application status:${NC}"
pm2 status
echo -e "${BLUE}🌐 Nginx status:${NC}"
sudo systemctl status nginx --no-pager -l
