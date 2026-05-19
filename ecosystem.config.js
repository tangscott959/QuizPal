module.exports = {
  apps: [{
    name: 'quizpal',
    script: '/usr/bin/java',
    args: [
      `-Dspring.datasource.url=${process.env.DB_URL || 'jdbc:mysql://localhost:3306/quiz_db_new'}`,
      `-Dspring.datasource.username=${process.env.DB_USERNAME || 'quizpal'}`,
      `-Dspring.datasource.password=${process.env.DB_PASSWORD || ''}`,
      `-Dspring.datasource.driver-class-name=${process.env.DB_DRIVER || 'com.mysql.cj.jdbc.Driver'}`,
      `-Dserver.port=${process.env.SERVER_PORT || '8080'}`,
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
