# 🌊 AWS EC2 Deployment Guide for QuizPal

## 📋 **Prerequisites**
- AWS account (free tier available)
- Git installed locally
- Basic Linux knowledge

---

## 🚀 **Step 1: Create EC2 Instance**

### **Login to AWS Console**
1. Go to [AWS Console](https://console.aws.amazon.com/)
2. Navigate to **EC2 Service**
3. Click **"Launch Instances"**

### **Instance Configuration**
- **AMI**: Ubuntu Server 24.04 LTS (Free tier eligible) ✅
- **Instance Type**: `t3.micro` (Free tier eligible) ✅
- **Key Pair**: Create new key pair (e.g., `quizpal-key`)
- **Security Group**: 
  - SSH: Port 22 (Your IP)
  - HTTP: Port 80 (0.0.0.0/0)
  - HTTPS: Port 443 (0.0.0.0/0)
- **Storage**: 8 GB (Free tier)

### **Download Key Pair**
```bash
# Save the .pem file securely
chmod 400 quizpal-key.pem
```

---

## 🔧 **Step 2: Configure Instance**

### **SSH into EC2**
```bash
ssh -i quizpal-key.pem ubuntu@your-ec2-public-ip
```

### **Install Dependencies**
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Java 8
sudo apt install openjdk-8-jdk -y

# Install Maven
sudo apt install maven -y

# Install Git
sudo apt install git -y

# Install MySQL Client
sudo apt install mysql-client -y

# Install Nginx (for reverse proxy)
sudo apt install nginx -y

# Install PM2 (process manager)
sudo npm install -g pm2
```

### **Verify Installation**
```bash
# Check Java version
java -version

# Check Maven version
mvn -version

# Check Git version
git --version
```

---

## 📁 **Step 3: Deploy Application**

### **Clone Repository**
```bash
cd /home/ubuntu
git clone https://github.com/tangscott959/QuizPal.git
cd QuizPal
```

### **Build Application**
```bash
mvn clean package -DskipTests
```

### **Create PM2 Ecosystem File**
```bash
nano ecosystem.config.js
```

### **ecosystem.config.js Content:**
```javascript
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
      NODE_ENV: 'production'
    }
  }]
};
```

### **Start Application with PM2**
```bash
pm2 start ecosystem.config.js
pm2 save
pm2 startup
```

---

## 🗄️ **Step 4: Database Setup**

### **Option A: Use AWS RDS (Recommended)**
1. Go to **RDS Service** in AWS Console
2. Create **MySQL** database
3. Set up security group to allow EC2 access
4. Update application.properties

### **Option B: Install MySQL on EC2**
```bash
# Install MySQL Server
sudo apt install mysql-server -y

# Secure MySQL
sudo mysql_secure_installation

# Create database and user
mysql -u root -p
```

```sql
CREATE DATABASE quiz_db_new;
CREATE USER 'quizpal'@'%' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON quiz_db_new.* TO 'quizpal'@'%';
FLUSH PRIVILEGES;
EXIT;
```

### **Import Database**
```bash
mysql -u quizpal -p quiz_db_new < quiz_db_new_setup.sql
```

---

## 🌐 **Step 5: Configure Nginx**

### **Create Nginx Config**
```bash
sudo nano /etc/nginx/sites-available/quizpal
```

### **Nginx Configuration:**
```nginx
server {
    listen 80;
    server_name your-domain.com;  # Replace with your domain or IP

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### **Enable Site**
```bash
sudo ln -s /etc/nginx/sites-available/quizpal /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx
```

---

## 🔐 **Step 6: Configure GitHub Secrets**

### **Required Secrets**
Go to your GitHub repository → Settings → Secrets and variables → Actions

Add these secrets:
- `AWS_EC2_HOST`: Your EC2 public IP
- `AWS_EC2_USERNAME`: ubuntu
- `AWS_EC2_PRIVATE_KEY`: Your entire .pem file content

### **Private Key Format**
```
-----BEGIN RSA PRIVATE KEY-----
[Your entire key content here]
-----END RSA PRIVATE KEY-----
```

---

## 🚀 **Step 7: Test CI/CD**

### **Push Changes**
```bash
git add .
git commit -m "Setup AWS EC2 deployment"
git push origin master
```

### **Monitor Deployment**
- Go to **GitHub Actions** tab
- Click on the running workflow
- Check deployment logs

---

## 🔧 **Application Configuration**

### **Update application.properties**
```properties
# Production settings
spring.datasource.url=jdbc:mysql://localhost:3306/quiz_db_new
spring.datasource.username=quizpal
spring.datasource.password=your_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

server.port=8080
```

---

## 📊 **Step 8: Monitor and Maintain**

### **Useful Commands**
```bash
# Check application logs
pm2 logs quizpal

# Restart application
pm2 restart quizpal

# Check system resources
free -h
df -h

# Check Nginx status
sudo systemctl status nginx

# Check MySQL status
sudo systemctl status mysql
```

### **Backup Database**
```bash
# Create backup script
mysqldump -u quizpal -p quiz_db_new > backup_$(date +%Y%m%d_%H%M%S).sql
```

---

## 🎯 **Expected Results**

After successful deployment:
- **Application URL**: `http://your-ec2-ip` or `http://your-domain.com`
- **Application running on port 80** (via Nginx reverse proxy)
- **Automatic deployments** on push to master
- **PM2 process management** for auto-restart
- **Free tier usage** (t2.micro + 8GB storage)

---

## 🆘 **Troubleshooting**

### **Common Issues:**
1. **Port 8080 not accessible**: Check security group
2. **Database connection failed**: Verify MySQL credentials
3. **502 Bad Gateway**: Check if application is running
4. **Permission denied**: Check file permissions

### **Debug Commands:**
```bash
# Check if Java app is running
sudo netstat -tlnp | grep :8080

# Check Nginx logs
sudo tail -f /var/log/nginx/error.log

# Check application logs
pm2 logs quizpal --lines 100
```

---

## 💰 **Cost Optimization**

### **Free Tier Limits:**
- **EC2**: 750 hours/month (t3.micro) ✅
- **Storage**: 8 GB EBS
- **Data Transfer**: 15 GB/month

### **To Stay Within Free Tier:**
- Use t3.micro instance ✅
- Monitor data transfer
- Set up billing alerts
- Consider using S3 for static assets

---

## 🎉 **Success!**

Your QuizPal application is now:
✅ Deployed on AWS EC2  
✅ Configured with CI/CD  
✅ Running with process manager  
✅ Behind reverse proxy  
✅ Connected to database  
✅ Automatically deploying  

**🌍 Access your application at: http://your-ec2-ip**
