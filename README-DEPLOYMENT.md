# 🚀 QuizPal Deployment Guide

## CI/CD Options for QuizPal

### 📋 **Quick Setup Checklist**
- [ ] Choose your deployment platform
- [ ] Set up required secrets in GitHub
- [ ] Push to master branch to trigger deployment
- [ ] Test your deployed application

---

## 🐳 **Option 1: Docker + Any Cloud Provider (Recommended)**

### **Setup Required:**
```bash
# No additional setup needed - uses GitHub Container Registry
```

### **GitHub Secrets:**
- `GITHUB_TOKEN` (auto-provided by GitHub)

### **Commands:**
```bash
# Build and run locally
docker build -t quizpal .
docker run -p 8080:8080 quizpal

# Deploy to any cloud provider
docker push ghcr.io/tangscott959/QuizPal:latest
```

### **Pros:**
✅ Universal deployment  
✅ Version control  
✅ Easy rollback  
✅ Cost-effective  

---

## ☁️ **Option 2: Heroku (Simple)**

### **Setup Required:**
1. Create free account at [heroku.com](https://heroku.com)
2. Create new app: `quizpal-app`
3. Install Heroku CLI

### **GitHub Secrets:**
- `HEROKU_API_KEY`: Your Heroku API key
- `HEROKU_APP_NAME`: quizpal-app
- `HEROKU_EMAIL`: Your email

### **Commands:**
```bash
# Install Heroku CLI
npm install -g heroku

# Login
heroku login

# Create app
heroku create quizpal-app

# Deploy manually
heroku deploy:jar target/quiz-project-0.0.1-SNAPSHOT.war --app quizpal-app
```

### **Pros:**
✅ Free tier available  
✅ Easy setup  
✅ Git integration  
✅ Automatic SSL  

---

## 🌊 **Option 3: AWS EC2 (Professional)**

### **Setup Required:**
1. Create AWS account
2. Launch EC2 instance (t2.micro free tier)
3. Install Java, Maven, Git

### **GitHub Secrets:**
- `AWS_EC2_HOST`: Your EC2 public IP
- `AWS_EC2_USERNAME`: ec2-user
- `AWS_EC2_PRIVATE_KEY`: Your EC2 private key

### **Commands:**
```bash
# SSH into EC2
ssh -i your-key.pem ec2-user@your-ec2-ip

# Install dependencies
sudo yum update -y
sudo yum install java-1.8.0-openjdk-devel maven git -y

# Clone and setup
git clone https://github.com/tangscott959/QuizPal.git
cd QuizPal
mvn clean package -DskipTests

# Create systemd service
sudo nano /etc/systemd/system/quizpal.service
```

### **Service File Content:**
```ini
[Unit]
Description=QuizPal Application
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/QuizPal
ExecStart=/usr/bin/java -jar target/quiz-project-0.0.1-SNAPSHOT.war
Restart=always

[Install]
WantedBy=multi-user.target
```

### **Pros:**
✅ Full control  
✅ Scalable  
✅ Professional  
✅ Cost-effective (free tier)  

---

## 🌊 **Option 4: DigitalOcean App Platform**

### **Setup Required:**
1. Create DigitalOcean account
2. Create new app: `quizpal`
3. Connect GitHub repository

### **GitHub Secrets:**
- `DIGITALOCEAN_APP_NAME`: quizpal
- `DIGITALOCEAN_TOKEN`: Your API token
- `DIGITALOCEAN_IMAGE_REGISTRY`: Your registry URL

### **Pros:**
✅ Modern platform  
✅ Good free tier  
✅ Easy setup  
✅ Built-in CI/CD  

---

## 🚂 **Option 5: Railway (Easiest)**

### **Setup Required:**
1. Create account at [railway.app](https://railway.app)
2. Connect GitHub repository
3. Deploy automatically

### **GitHub Secrets:**
- `RAILWAY_TOKEN`: Your Railway API token
- `RAILWAY_SERVICE_ID`: Your service ID

### **Commands:**
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Link project
railway link

# Deploy
railway up
```

### **Pros:**
✅ Easiest setup  
✅ Free tier available  
✅ Automatic deployments  
✅ Great for beginners  

---

## 🔧 **Configuration Files Created**

All CI/CD workflows have been created in `.github/workflows/`:
- `docker-deploy.yml` - Docker deployment
- `heroku-deploy.yml` - Heroku deployment  
- `aws-deploy.yml` - AWS EC2 deployment
- `digitalocean-deploy.yml` - DigitalOcean deployment
- `railway-deploy.yml` - Railway deployment

---

## 🎯 **Recommendation**

### **For Beginners: Railway** 🚂
- Easiest setup
- Free tier available
- Automatic deployments from GitHub

### **For Production: Docker + AWS** 🐳
- Most professional
- Full control
- Scalable

### **For Quick Testing: Heroku** ☁️
- Fastest setup
- Reliable
- Good for demos

---

## 🚀 **Quick Start (Railway)**

1. **Create Railway Account**
   ```bash
   # Go to https://railway.app
   # Sign up with GitHub
   ```

2. **Connect Repository**
   ```bash
   # Click "New Project" → "Deploy from GitHub repo"
   # Select QuizPal repository
   ```

3. **Add Environment Variables**
   ```bash
   # In Railway dashboard, add variables:
   DATABASE_URL=your_mysql_url
   SPRING_PROFILES_ACTIVE=production
   ```

4. **Deploy!**
   ```bash
   # Railway will automatically deploy on push to master
   # Your app will be available at: your-app-name.railway.app
   ```

---

## 📞 **Need Help?**

- Check the workflow logs in GitHub Actions tab
- Verify all secrets are correctly set
- Make sure your `pom.xml` has correct packaging
- Test locally before deploying

Happy deploying! 🎉
