# Google OAuth Setup for QuizPal

Google Sign-In works on **localhost** during development. Production requires an **HTTPS domain**. Google does not allow raw IP addresses in OAuth redirect URIs.

If you see `Error 400: invalid_request`, the app is usually sending an HTTP IP redirect such as `http://<ec2-public-ip>/login/oauth2/code/google`.

## Fix overview

1. Get a domain name pointing to your EC2 IP
2. Enable HTTPS (Let's Encrypt)
3. Register the HTTPS redirect URI in Google Cloud Console
4. Set `GOOGLE_REDIRECT_URI` in GitHub Actions secrets
5. Redeploy

## Step 1: Get a free domain (DuckDNS example)

1. Go to [https://www.duckdns.org](https://www.duckdns.org)
2. Sign in and create a subdomain, e.g. `quizpal.duckdns.org`
3. Point it to your EC2 public IP

## Step 2: Enable HTTPS on EC2

SSH into EC2 and install Certbot:

```bash
sudo apt update
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d quizpal.duckdns.org
```

Confirm you can open:

```text
https://quizpal.duckdns.org/login
```

Your Nginx config should proxy to `localhost:8080` and include:

```nginx
proxy_set_header Host $host;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
```

QuizPal already sets `server.forward-headers-strategy=framework` so Spring builds OAuth URLs with the correct public scheme/host.

## Step 3: Google Cloud Console

1. Open [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
2. Select your OAuth 2.0 **Web client**
3. Under **Authorized JavaScript origins**, add:

   ```text
   https://quizpal.duckdns.org
   ```

4. Under **Authorized redirect URIs**, add **exactly**:

   ```text
   https://quizpal.duckdns.org/login/oauth2/code/google
   ```

5. Save

### OAuth consent screen

1. Go to **APIs & Services → OAuth consent screen**
2. Set app name: `QuizPal`
3. Add your email under **Developer contact information**
4. If the app is in **Testing** mode, add test users
5. For public use, publish the app

## Step 4: GitHub Secrets

In GitHub → **Settings → Secrets and variables → Actions**, set:

| Secret | Example |
|--------|---------|
| `GOOGLE_CLIENT_ID` | your Google OAuth client ID |
| `GOOGLE_CLIENT_SECRET` | your Google OAuth client secret |
| `GOOGLE_REDIRECT_URI` | `https://quizpal.duckdns.org/login/oauth2/code/google` |

`GOOGLE_REDIRECT_URI` must match Google Console **exactly** (including `/login/oauth2/code/google`).

Redeploy by pushing to `master` or re-running the CI/CD workflow.

## Step 5: Verify

1. Open `https://quizpal.duckdns.org/login`
2. Click **Sign in with Google**
3. You should see Google's consent screen, then land on `/quiz/index`

Debug tip — inspect the redirect URL before approving Google:

```bash
curl -I "https://quizpal.duckdns.org/oauth2/authorization/google"
```

The `Location` header should contain:

```text
redirect_uri=https://quizpal.duckdns.org/login/oauth2/code/google
```

## Local development

Localhost continues to use:

```text
http://localhost:8080/login/oauth2/code/google
```

Register that URI in Google Console under the same OAuth client (or a separate dev client).
