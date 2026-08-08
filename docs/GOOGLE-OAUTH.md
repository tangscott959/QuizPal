# Google OAuth Setup for QuizPal

Google Sign-In works on **localhost** during development, but **production requires an HTTPS domain**. Google does **not** allow raw IP addresses such as `http://98.89.26.67` in OAuth redirect URIs.

That is why you see:

> Access blocked: Authorization Error — Error 400: invalid_request

## What QuizPal sends today

Production currently redirects to Google with:

```text
redirect_uri=http://98.89.26.67/login/oauth2/code/google
```

Google rejects this because:

1. **Raw public IPs are not allowed** in redirect URIs
2. **HTTPS is required** for production (HTTP is only allowed for localhost)

## Fix overview

1. Get a domain name pointing to your EC2 IP
2. Enable HTTPS (Let's Encrypt)
3. Register the HTTPS redirect URI in Google Cloud Console
4. Set `GOOGLE_REDIRECT_URI` in GitHub Actions secrets
5. Redeploy

---

## Step 1: Get a free domain (DuckDNS example)

1. Go to [https://www.duckdns.org](https://www.duckdns.org)
2. Sign in and create a subdomain, e.g. `quizpal.duckdns.org`
3. Point it to your EC2 public IP: `98.89.26.67`

---

## Step 2: Enable HTTPS on EC2

SSH into EC2 and install Certbot:

```bash
sudo apt update
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d quizpal.duckdns.org
```

Certbot updates Nginx to use HTTPS. Confirm you can open:

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

---

## Step 3: Google Cloud Console

1. Open [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
2. Select your OAuth 2.0 **Web client** (the one ending in `.apps.googleusercontent.com`)
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
4. If app is in **Testing** mode, add test users (including `tangscott959@gmail.com`)
5. For public use, publish the app (verification may be required for sensitive scopes; `openid profile email` is usually fine for testing)

---

## Step 4: GitHub Secrets

In GitHub → **Settings → Secrets and variables → Actions**, set:

| Secret | Example |
|--------|---------|
| `GOOGLE_CLIENT_ID` | `479112306800-....apps.googleusercontent.com` |
| `GOOGLE_CLIENT_SECRET` | your client secret |
| `GOOGLE_REDIRECT_URI` | `https://quizpal.duckdns.org/login/oauth2/code/google` |

`GOOGLE_REDIRECT_URI` must match Google Console **exactly** (including `/login/oauth2/code/google`).

Redeploy by pushing to `master` or re-running the CI/CD workflow.

---

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

---

## Local development

Localhost continues to use:

```text
http://localhost:8080/login/oauth2/code/google
```

Register that URI in Google Console under the same OAuth client (or a separate dev client).

---

## Until HTTPS is configured

Users can still log in with **username/password**:

- `student1` / `password`
- `admin` / `password`

Google Sign-In will not work on the raw IP address `http://98.89.26.67`.
