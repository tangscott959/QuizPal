module.exports = {
  apps: [{
    name: 'quizpal',
    script: '/usr/bin/java',
    args: [
      '-Dspring.datasource.url=jdbc:mysql://localhost:3306/quiz_db_new',
      '-Dspring.datasource.username=quizpal',
      '-Dspring.datasource.password=Quizpal@123',
      '-Dspring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver',
      '-Dserver.port=8080',
      '-jar', '/home/ubuntu/QuizPal/target/Quiz_project-0.0.1-SNAPSHOT.jar'
    ],
    cwd: '/home/ubuntu/QuizPal',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '600M',
    error_file: '/home/ubuntu/.pm2/logs/quizpal-error.log',
    out_file: '/home/ubuntu/.pm2/logs/quizpal-out.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z'
  }]
};
