#!/bin/bash

# One-time EC2 setup for QuizPal Docker deployments.

set -euo pipefail

echo "Setting up Docker and Nginx for QuizPal..."

sudo apt update
sudo apt install -y ca-certificates curl gnupg nginx

sudo install -m 0755 -d /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
fi
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker

if id ubuntu >/dev/null 2>&1; then
  sudo usermod -aG docker ubuntu
fi

sudo tee /etc/nginx/sites-available/quizpal >/dev/null <<'EOF'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/quizpal /etc/nginx/sites-enabled/quizpal
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl enable --now nginx
sudo systemctl reload nginx

echo "Setup complete."
echo "Add the GitHub Actions secrets from README-DEPLOYMENT.md, then push to master to deploy."
echo "If this user was just added to the docker group, log out and back in before running docker without sudo."
