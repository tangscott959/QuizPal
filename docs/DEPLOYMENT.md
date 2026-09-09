# QuizPal Docker EC2 Deployment Guide

QuizPal deploys from GitHub Actions to AWS EC2 as a Docker container. The workflow in `.github/workflows/deploy.yml` runs tests, publishes an image to GitHub Container Registry, then restarts the container on EC2 after pushes to `master`.

## EC2 Host

A typical host is Ubuntu 24.04 on a `t3.micro` instance. Use at least 16 GiB of root disk; 8 GiB is tight for Docker image layers. Security group ports:

- SSH 22 from your IP
- HTTP 80
- HTTPS 443

## Pipeline

1. Pull request to `master`: run Maven tests.
2. Push to `master`: run Maven tests, build Docker image, push `latest` and commit-SHA tags to GHCR, deploy to EC2.
3. Manual run: use the GitHub Actions `workflow_dispatch` button to redeploy.

## Required GitHub Secrets

Add these under GitHub repository settings: `Settings -> Secrets and variables -> Actions`.

- `EC2_HOST`: EC2 public IP or DNS name.
- `EC2_USER`: SSH user, usually `ubuntu`.
- `EC2_SSH_KEY`: private key that can SSH to the EC2 host.
- `DB_URL`: production JDBC URL, for example `jdbc:mysql://10.0.1.10:3306/quiz_db_new`.
- `DB_USERNAME`: production database username.
- `DB_PASSWORD`: production database password.
- `GOOGLE_CLIENT_ID`: Google OAuth client ID.
- `GOOGLE_CLIENT_SECRET`: Google OAuth client secret.
- `GOOGLE_REDIRECT_URI`: Optional. Production redirect URI, e.g. `https://your-domain.com/login/oauth2/code/google`. Required for Google Sign-In in production (see [GOOGLE-OAUTH.md](GOOGLE-OAUTH.md)).

`GITHUB_TOKEN` is provided automatically by GitHub Actions and is used to publish `ghcr.io/tangscott959/quizpal`.

## One-Time EC2 Setup

On a fresh Ubuntu host, run `scripts/setup-aws.sh`. It installs Docker and Nginx and configures a reverse proxy to `localhost:8080`.

Log out and back in after the `ubuntu` user is added to the `docker` group. The workflow also falls back to `sudo docker` if needed.

## Nginx Reverse Proxy

The container listens on `localhost:8080`. Nginx can expose it on port `80`:

```nginx
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
```

Enable and reload:

```bash
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
sudo systemctl reload nginx
```

## Database URL Notes

If MySQL runs on RDS or another host, set `DB_URL` to that host.

If MySQL runs directly on the same EC2 instance, `localhost` inside the container means the container, not the EC2 host. Use one of these instead:

- The EC2 private IP in `DB_URL`.
- A Docker network with a MySQL container named `mysql`.
- Host gateway configuration if you explicitly add it to the container runtime.

## Runtime Container

The workflow starts the container like this:

```bash
docker run -d \
  --name quizpal \
  --restart unless-stopped \
  -p 8080:8080 \
  -e DB_URL="$DB_URL" \
  -e DB_USERNAME="$DB_USERNAME" \
  -e DB_PASSWORD="$DB_PASSWORD" \
  -e GOOGLE_CLIENT_ID="$GOOGLE_CLIENT_ID" \
  -e GOOGLE_CLIENT_SECRET="$GOOGLE_CLIENT_SECRET" \
  ghcr.io/tangscott959/quizpal:<sha>
```

Before enabling Docker deployment, stop any old PM2/JAR process using port `8080`:

```bash
pm2 stop quizpal || true
pm2 delete quizpal || true
```

## Local Docker Check

```bash
docker build -t quizpal .
docker run --rm -p 8080:8080 \
  -e DB_URL="jdbc:mysql://host.docker.internal:3306/quiz_db_new" \
  -e DB_USERNAME="quizpal" \
  -e DB_PASSWORD="your-local-password" \
  quizpal
```

Open `http://localhost:8080/login`.
