# 🐧 Ubuntu 24.04 LTS + t3.micro Setup Notes

## ✅ **Why Your Choice is Perfect!**

### **Ubuntu 24.04 LTS Benefits:**
- 🆕 **Latest LTS release** (April 2024)
- 🔒 **5 years security support** (until April 2029)
- ⚡ **Better performance** with updated kernel
- 📦 **Newer package versions** (Java 21, Maven 3.9, etc.)
- 🛡️ **Enhanced security features**

### **t3.micro vs t2.micro:**
- 🚀 **Better performance**: t3.micro is ~25% faster
- 💰 **Same cost**: Still free tier eligible
- 🔄 **Burstable performance**: Better CPU credits system
- 📈 **Future-proof**: Newer generation instance

---

## 🔧 **Updated Installation Commands**

### **Java Installation (Ubuntu 24.04)**
```bash
# Ubuntu 24.04 has newer Java packages
sudo apt update
sudo apt install openjdk-17-jdk -y  # Java 17 LTS (better than Java 8)

# Or install Java 8 if needed (for compatibility)
sudo apt install openjdk-8-jdk -y

# Set default Java version
sudo update-alternatives --config java
```

### **Maven Installation**
```bash
# Ubuntu 24.04 includes Maven 3.9
sudo apt install maven -y
mvn -version  # Should show Maven 3.9.x
```

### **Node.js & PM2 (Updated for 24.04)**
```bash
# Install Node.js 18 LTS (recommended for Ubuntu 24.04)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g pm2
```

---

## 🚀 **Performance Optimizations**

### **t3.micro Specific Settings**
```bash
# Optimize for t3.micro burstable performance
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Set Java memory for t3.micro (1GB RAM)
export JAVA_OPTS="-Xms512m -Xmx768m"
```

### **Application.properties Optimization**
```properties
# Optimized for t3.micro
server.tomcat.max-threads=50
server.tomcat.min-spare-threads=10
spring.datasource.hikari.maximum-pool-size=10
spring.datasource.hikari.minimum-idle=5
```

---

## 🔒 **Security Enhancements (Ubuntu 24.04)**

### **Enhanced Firewall Setup**
```bash
# Ubuntu 24.04 has improved UFW
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw --force enable
```

### **Automatic Security Updates**
```bash
# Ubuntu 24.04 improved automatic updates
sudo apt install unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```

---

## 📊 **Resource Monitoring**

### **t3.micro Specific Monitoring**
```bash
# Monitor CPU credits (t3.micro specific)
aws ec2 describe-instance-types --instance-types t3.micro

# System monitoring tools
sudo apt install htop iotop nethogs
htop  # Monitor CPU and memory usage
```

### **PM2 Configuration for t3.micro**
```javascript
module.exports = {
  apps: [{
    name: 'quizpal',
    script: 'java',
    args: ['-jar', 'target/quiz-project-0.0.1-SNAPSHOT.war', '-Xmx768m'],
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '600M',  # Conservative for t3.micro
    env: {
      NODE_ENV: 'production',
      JAVA_OPTS: '-Xms256m -Xmx768m'
    }
  }]
};
```

---

## 🎯 **Expected Performance**

### **t3.micro Specifications:**
- **CPU**: 2 vCPUs (burstable)
- **Memory**: 1 GB RAM
- **Storage**: 8 GB EBS
- **Network**: Up to 5 Gbps

### **Your QuizPal Will Handle:**
- ✅ **50+ concurrent users** easily
- ✅ **Database operations** smoothly
- ✅ **Static file serving** efficiently
- ✅ **API requests** responsively

---

## 🔄 **Migration from t2.micro**

If you ever need to migrate from t2.micro to t3.micro:

```bash
# Stop application
pm2 stop quizpal

# Create AMI backup
aws ec2 create-image --instance-id i-1234567890abcdef0 --name "QuizPal-backup-$(date +%Y%m%d)"

# Launch new t3.micro instance from AMI
# Update DNS records
# Test new instance
# Decommission old instance
```

---

## 🎉 **Summary**

Your choice of **Ubuntu 24.04 LTS + t3.micro** is perfect because:

✅ **Latest technology** with long-term support  
✅ **Better performance** than older options  
✅ **Still free tier eligible**  
✅ **Future-proof** for years to come  
✅ **Optimized for modern applications**  

**Your QuizPal will run faster and more reliably on this setup!** 🚀
