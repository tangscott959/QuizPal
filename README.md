# 🧠 QuizPal - Interactive Web Quiz Application

## 📋 **Overview**

QuizPal is a comprehensive web-based quiz application built with Spring Boot that provides an engaging platform for users to test their knowledge across multiple categories including Mathematics, Science, History, and Geography.

## 🚀 **Features**

### **Core Functionality**
- ✅ **Multi-category Quizzes**: Mathematics, Science, History, Geography
- ✅ **5 Questions per Quiz**: Consistent quiz format with navigation
- ✅ **Multiple Choice Questions**: Interactive answer selection
- ✅ **Real-time Scoring**: Instant feedback on quiz performance
- ✅ **User Authentication**: Secure login and registration system
- ✅ **Google SSO**: Sign in with Google OAuth2 integration
- ✅ **Admin Dashboard**: Manage users, questions, and quiz results

### **Technical Features**
- ✅ **Responsive Design**: Mobile-friendly interface
- ✅ **RESTful APIs**: Clean API architecture
- ✅ **Database Integration**: MySQL with optimized queries
- ✅ **Process Management**: PM2 for production deployment
- ✅ **Reverse Proxy**: Nginx for load balancing
- ✅ **CI/CD Ready**: GitHub Actions workflows

## 🛠️ **Technology Stack**

### **Backend**
- **Java 8+**: Core programming language
- **Spring Boot**: Application framework
- **Spring MVC**: Web framework
- **Spring Security**: Authentication and authorization
- **Spring OAuth2 Client**: Google SSO integration
- **MySQL**: Database management
- **Maven**: Build and dependency management

### **Frontend**
- **JSP**: Server-side templating
- **Bootstrap 5**: Responsive CSS framework
- **JavaScript**: Client-side interactions
- **HTML5/CSS3**: Modern web standards

### **Infrastructure**
- **AWS EC2**: Cloud hosting
- **Nginx**: Reverse proxy and load balancer
- **PM2**: Process manager
- **GitHub**: Version control and CI/CD

## 🌐 **Live Demo**

**URL**: [98.89.26.67](http://98.89.26.67)

**Test Credentials**:
- **Username**: `testuser`
- **Password**: `password123`

## 📦 **Installation**

### **Prerequisites**
- Java 8 or higher
- Maven 3.6+
- MySQL 8.0+
- Git

### **Local Setup**

1. **Clone the repository**
```bash
git clone https://github.com/tangscott959/QuizPal.git
cd QuizPal
```

2. **Database Setup**
```bash
# Create database
mysql -u root -p -e "CREATE DATABASE quiz_db_new;"

# Import schema
mysql -u root -p quiz_db_new < quiz_db_new_setup.sql

# Create user
mysql -u root -p -e "
CREATE USER 'quizpal'@'localhost' IDENTIFIED BY 'Quizpal@123';
GRANT ALL PRIVILEGES ON quiz_db_new.* TO 'quizpal'@'localhost';
FLUSH PRIVILEGES;
"
```

3. **Configure Application**
```bash
# Update src/main/resources/application.properties
spring.datasource.url=jdbc:mysql://localhost:3306/quiz_db_new
spring.datasource.username=quizpal
spring.datasource.password=Quizpal@123
server.port=8080
```

4. **Build and Run**
```bash
mvn clean install
mvn spring-boot:run
```

5. **Access Application**
- **URL**: http://localhost:8080
- **Login**: testuser / password123

## 🗄️ **Database Schema**

### **Tables**
- **question**: Quiz questions with categories
- **choice**: Multiple choice options
- **quiz**: User quiz sessions
- **quiz_answer**: User quiz responses
- **user**: User authentication data
- **category**: Question categories

### **Question Categories**
1. **Mathematics** (22+ questions)
2. **Science** (21+ questions)
3. **History** (21+ questions)
4. **Geography** (26+ questions)

## 🚀 **Deployment**

### **AWS EC2 Deployment**

1. **Create EC2 Instance**
```bash
# Ubuntu 24.04 LTS, t3.micro
# Security Group: SSH(22), HTTP(80), HTTPS(443)
```

2. **Setup Dependencies**
```bash
sudo apt update
sudo apt install -y openjdk-17-jdk maven mysql-server nginx nodejs npm
```

3. **Deploy Application**
```bash
git clone https://github.com/tangscott959/QuizPal.git
cd QuizPal
mvn clean package -DskipTests
pm2 start ecosystem.config.js
```

4. **Configure Nginx**
```bash
# Setup reverse proxy to http://localhost:8080
```

### **Docker Deployment**
```bash
# Build image
docker build -t quizpal .

# Run container
docker run -p 8080:8080 quizpal
```

## 📱 **Mobile Responsiveness**

QuizPal is fully responsive and works seamlessly on:
- ✅ **Desktop** (1920x1080+)
- ✅ **Tablet** (768px-1024px)
- ✅ **Mobile** (320px-768px)

### **Mobile Features**
- Touch-friendly buttons (44px min height)
- Responsive layout with proper scaling
- Optimized navigation for small screens
- No horizontal scrolling

## 🔧 **Configuration**

### **Application Properties**
```properties
# Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/quiz_db_new
spring.datasource.username=quizpal
spring.datasource.password=Quizpal@123

# Server Configuration
server.port=8080

# JSP Configuration
spring.mvc.view.prefix=/WEB-INF/jsp/
spring.mvc.view.suffix=.jsp
```

### **PM2 Configuration**
```javascript
module.exports = {
  apps: [{
    name: 'quizpal',
    script: 'java',
    args: ['-jar', 'target/Quiz_project-0.0.1-SNAPSHOT.jar'],
    cwd: '/path/to/QuizPal',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G'
  }]
};
```

## 🧪 **Testing**

### **Unit Tests**
```bash
mvn test
```

### **Integration Tests**
```bash
mvn verify
```

### **Manual Testing**
- User registration and login
- Quiz functionality across all categories
- Admin dashboard operations
- Mobile responsiveness

## 📊 **Performance**

### **Database Optimization**
- Indexed queries for fast performance
- Connection pooling for database efficiency
- Optimized SQL queries

### **Application Performance**
- Sub-second page load times
- Efficient memory usage
- Scalable architecture

## 🔐 **Security**

### **Authentication**
- Password hashing with BCrypt
- Session management
- CSRF protection
- Google OAuth2 Single Sign-On (SSO)

### **Google SSO Setup**
QuizPal supports Google Sign-In via OAuth2. To enable it:

1. Create a project on [Google Cloud Console](https://console.cloud.google.com/)
2. Go to **APIs & Services → Credentials → Create OAuth 2.0 Client ID**
3. Set Application type to **Web application**
4. Add redirect URI: `http://localhost:8080/login/oauth2/code/google`
5. Set environment variables before running:
```bash
export GOOGLE_CLIENT_ID="your-client-id"
export GOOGLE_CLIENT_SECRET="your-client-secret"
```

> **Note**: Google OAuth2 requires a valid domain for redirect URIs in production. Raw IP addresses are not supported. Use a domain name or SSH tunnel (`ssh -L 8080:localhost:8080 user@server`) for testing.

### **Database Security**
- Parameterized queries to prevent SQL injection
- User input validation
- Secure password storage

## 🔄 **CI/CD**

### **GitHub Actions**
- Automated testing on push
- Build and deployment workflows
- Multi-environment support

### **Deployment Options**
- **AWS EC2**: Production hosting
- **Heroku**: Quick deployment
- **DigitalOcean**: Alternative cloud hosting
- **Docker**: Containerized deployment

## 📈 **Monitoring**

### **Application Logs**
- PM2 process monitoring
- Application error tracking
- Performance metrics

### **Database Monitoring**
- Query performance tracking
- Connection pool monitoring
- Error logging

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### **Development Guidelines**
- Follow Java coding standards
- Write unit tests for new features
- Update documentation
- Ensure mobile responsiveness

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 **Support**

### **Issues and Questions**
- **GitHub Issues**: [Create an issue](https://github.com/tangscott959/QuizPal/issues)
- **Email**: tangscott959@gmail.com

### **Documentation**
- [AWS Setup Guide](AWS-SETUP-GUIDE.md)
- [Ubuntu 24.04 Setup](UBUNTU-24.04-SETUP.md)
- [Implementation Guide](IMPLEMENTATION_GUIDE.md)

## 🏆 **Achievements**

### **Project Milestones**
- ✅ **Complete Quiz System**: 88+ questions across 4 categories
- ✅ **Production Deployment**: Live on AWS EC2
- ✅ **Mobile Responsive**: Works on all device sizes
- ✅ **Database Optimized**: Clean schema with proper relationships
- ✅ **CI/CD Ready**: GitHub Actions configured
- ✅ **Google SSO**: OAuth2 Sign-In with Google
- ✅ **Documentation**: Comprehensive guides and README

### **Technical Highlights**
- **Clean Architecture**: MVC pattern with proper separation of concerns
- **Scalable Design**: Handles multiple concurrent users
- **Security First**: Proper authentication and data protection
- **Performance Optimized**: Fast response times and efficient queries

## 🚀 **Future Enhancements**

### **Planned Features**
- [ ] **Google SSO Production Domain**: Configure custom domain for OAuth2 redirect
- [ ] **Real-time Multiplayer**: Compete with other users
- [ ] **Advanced Analytics**: Detailed performance insights
- [ ] **Question Categories**: More diverse topics
- [ ] **Gamification**: Points, badges, and leaderboards
- [ ] **API Integration**: Third-party quiz sources
- [ ] **Mobile App**: Native iOS/Android applications

### **Technical Improvements**
- [ ] **Microservices Architecture**: Scale individual components
- [ ] **Redis Caching**: Improve performance with caching
- [ ] **Docker Compose**: Multi-container deployment
- [ ] **Kubernetes**: Container orchestration
- [ ] **GraphQL API**: More efficient data fetching

---

**🎉 Thank you for checking out QuizPal!**

**Built with ❤️ by [tangscott959](https://github.com/tangscott959)**

**🌟 Star this repository if you find it useful!**
