# QuizPal

QuizPal is a Spring Boot web quiz application with user login, Google OAuth2 sign-in, admin management, quiz categories, scoring, and persisted quiz history. The app uses JSP views, Spring MVC controllers, a service layer, JDBC DAOs, and MySQL.

## Features

- Multi-category quizzes for Mathematics, Science, History, and Geography.
- User registration and login with BCrypt password hashing.
- Optional Google OAuth2 sign-in.
- Admin dashboard for users, questions, feedback, contacts, and quiz results.
- Persisted quiz attempts and score history.
- CSRF-protected forms through Spring Security.
- Docker image build and EC2 deployment through GitHub Actions.

## Tech Stack

Backend:

- Java 8
- Spring Boot 2.7.3
- Spring MVC
- Spring Security
- Spring OAuth2 Client
- Spring JDBC / JdbcTemplate
- MySQL
- Maven
- Lombok

Frontend:

- JSP / JSTL
- HTML, CSS, JavaScript
- Bootstrap

Infrastructure:

- Docker
- GitHub Actions
- GitHub Container Registry
- AWS EC2
- Nginx reverse proxy

## Architecture

QuizPal is a layered Spring MVC monolith:

- Controllers handle web routes and return JSP views.
- Services hold authentication, registration, quiz, and user business logic.
- DAOs use `JdbcTemplate` to read and write MySQL data.
- Spring Security owns form login, OAuth2 login, logout, CSRF protection, and admin route authorization.
- JSP pages render the user and admin UI.

## Local Setup

### Prerequisites

- Java 8
- Maven 3.6+ or the included Maven wrapper
- MySQL 8+
- Git

### 1. Clone The Repository

```bash
git clone https://github.com/tangscott959/QuizPal.git
cd QuizPal
```

### 2. Create And Seed The Database

```bash
mysql -u root -p -e "CREATE DATABASE quiz_db_new;"
mysql -u root -p quiz_db_new < quiz_db_new_setup.sql
```

Create a local database user:

```bash
mysql -u root -p -e "
CREATE USER 'quizpal'@'localhost' IDENTIFIED BY '<choose-a-local-db-password>';
GRANT ALL PRIVILEGES ON quiz_db_new.* TO 'quizpal'@'localhost';
FLUSH PRIVILEGES;
"
```

### 3. Set Environment Variables

`src/main/resources/application.properties` reads configuration from environment variables with local defaults.

PowerShell:

```powershell
$env:DB_URL="jdbc:mysql://localhost:3306/quiz_db_new"
$env:DB_USERNAME="quizpal"
$env:DB_PASSWORD="<your-local-db-password>"
$env:GOOGLE_CLIENT_ID="local-dev-client-id"
$env:GOOGLE_CLIENT_SECRET="local-dev-client-secret"
```

Bash:

```bash
export DB_URL="jdbc:mysql://localhost:3306/quiz_db_new"
export DB_USERNAME="quizpal"
export DB_PASSWORD="<your-local-db-password>"
export GOOGLE_CLIENT_ID="local-dev-client-id"
export GOOGLE_CLIENT_SECRET="local-dev-client-secret"
```

### 4. Run The App

The app is live at :http://98.89.26.67.
https://quizpal.duckdns.org/login
Windows:

```powershell
.\mvnw.cmd spring-boot:run
```

macOS/Linux:

```bash
chmod +x mvnw
./mvnw spring-boot:run
```

Open `http://localhost:8080/login`.

Sample login:

- Username: `student1`
- Password: `password`

## Testing

Run the test suite:

```bash
./mvnw test
```

On Windows:

```powershell
.\mvnw.cmd test
```

Current tests cover key authentication behavior, including BCrypt registration/login checks and Spring Security role mapping.

## Docker

Build the Docker image locally:

```bash
docker build -t quizpal .
```

Run it against a database reachable from Docker:

```bash
docker run --rm -p 8080:8080 \
  -e DB_URL="jdbc:mysql://host.docker.internal:3306/quiz_db_new" \
  -e DB_USERNAME="quizpal" \
  -e DB_PASSWORD="<your-local-db-password>" \
  -e GOOGLE_CLIENT_ID="local-dev-client-id" \
  -e GOOGLE_CLIENT_SECRET="local-dev-client-secret" \
  quizpal
```

Open `http://localhost:8080/login`.

## CI/CD Deployment

The production pipeline is defined in `.github/workflows/deploy.yml`.

On pull requests to `master`, GitHub Actions runs Maven tests.

On pushes to `master` or manual workflow runs, GitHub Actions:

1. Runs the Maven test suite.
2. Builds a Docker image.
3. Publishes `latest` and commit-SHA image tags to GitHub Container Registry.
4. SSHes into the EC2 instance.
5. Installs Docker if it is missing.
6. Cleans old Docker artifacts and old processes using port `8080`.
7. Starts the `quizpal` container with production environment variables.
8. Health-checks `http://localhost:8080/login`.
9. Prints container logs if the health check fails.

The image is published as:

```text
ghcr.io/tangscott959/quizpal
```

## Required GitHub Secrets

Add these in GitHub under `Settings -> Secrets and variables -> Actions`:

- `EC2_HOST`: EC2 public IP or DNS name.
- `EC2_USER`: SSH user, usually `ubuntu`.
- `EC2_SSH_KEY`: private key contents for SSH access to EC2.
- `DB_URL`: production JDBC URL, for example `jdbc:mysql://<database-host>:3306/quiz_db_new`.
- `DB_USERNAME`: production database username.
- `DB_PASSWORD`: production database password.
- `GOOGLE_CLIENT_ID`: Google OAuth client ID.
- `GOOGLE_CLIENT_SECRET`: Google OAuth client secret.

Do not commit `.pem` files, database passwords, or OAuth client secrets.

## EC2 Notes

The deployed container listens on port `8080`. Nginx can expose it on port `80` by proxying to `http://localhost:8080`.

The EC2 root volume should have enough free space for Docker images and layers. A small `8 GiB` root volume may fail during image pulls. `16 GiB` or `20 GiB` is more practical for this project.

If MySQL runs on the same EC2 host, do not use `localhost` in `DB_URL` from inside the container. Use the EC2 private IP, a Docker network, or another reachable database hostname.

More deployment details are in [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md).

## Security Updates

Recent hardening work includes:

- Replaced legacy/plain password handling with BCrypt.
- Added Spring Security form login and OAuth2 login flow.
- Added `UserDetailsService` integration for app users.
- Added CSRF tokens to JSP forms.
- Moved secrets and database settings to environment variables.
- Removed manual admin session checks in favor of Spring Security authorization rules.
- Updated seeded sample users to use BCrypt password hashes.

## Database

Primary tables include:

- `user`
- `category`
- `question`
- `choice`
- `quiz`
- `quiz_question`

Seed data is provided in `quiz_db_new_setup.sql`.

## Useful Commands

Check the deployed container on EC2:

```bash
sudo docker ps
sudo docker logs --tail 100 quizpal
```

Check disk space on EC2:

```bash
df -h
```

Restart the deployed container:

```bash
sudo docker restart quizpal
```

## Documentation

See the [docs/](docs/) folder:

- [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md): Docker EC2 deployment guide
- [docs/GOOGLE-OAUTH.md](docs/GOOGLE-OAUTH.md): Google Sign-In setup
- [docs/AWS-SETUP-GUIDE.md](docs/AWS-SETUP-GUIDE.md): AWS EC2 setup
- [docs/UBUNTU-24.04-SETUP.md](docs/UBUNTU-24.04-SETUP.md): Ubuntu server setup
- [docs/IMPLEMENTATION_GUIDE.md](docs/IMPLEMENTATION_GUIDE.md): Implementation notes
- `quiz_db_new_setup.sql`: schema and seed data

## License

This project is licensed under the MIT License.
