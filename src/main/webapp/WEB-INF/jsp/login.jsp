<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>QuizPal - Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(-45deg, #0f0c29, #302b63, #24243e, #0f0c29);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            overflow: hidden;
        }

        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .particles { position: fixed; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none; z-index: 0; }
        .particle { position: absolute; width: 6px; height: 6px; background: rgba(255,255,255,0.15); border-radius: 50%; animation: float linear infinite; }
        .particle:nth-child(1)  { left: 10%; animation-duration: 12s; animation-delay: 0s; width: 4px; height: 4px; }
        .particle:nth-child(2)  { left: 20%; animation-duration: 15s; animation-delay: 2s; width: 8px; height: 8px; }
        .particle:nth-child(3)  { left: 30%; animation-duration: 10s; animation-delay: 4s; }
        .particle:nth-child(4)  { left: 40%; animation-duration: 18s; animation-delay: 1s; width: 5px; height: 5px; }
        .particle:nth-child(5)  { left: 50%; animation-duration: 14s; animation-delay: 3s; width: 7px; height: 7px; }
        .particle:nth-child(6)  { left: 60%; animation-duration: 11s; animation-delay: 5s; }
        .particle:nth-child(7)  { left: 70%; animation-duration: 16s; animation-delay: 0s; width: 4px; height: 4px; }
        .particle:nth-child(8)  { left: 80%; animation-duration: 13s; animation-delay: 2s; width: 9px; height: 9px; }
        .particle:nth-child(9)  { left: 90%; animation-duration: 17s; animation-delay: 4s; }
        .particle:nth-child(10) { left: 15%; animation-duration: 19s; animation-delay: 1s; width: 5px; height: 5px; }
        .particle:nth-child(11) { left: 45%; animation-duration: 12s; animation-delay: 3s; width: 3px; height: 3px; }
        .particle:nth-child(12) { left: 75%; animation-duration: 14s; animation-delay: 5s; width: 6px; height: 6px; }

        @keyframes float {
            0% { transform: translateY(100vh) rotate(0deg); opacity: 0; }
            10% { opacity: 1; }
            90% { opacity: 1; }
            100% { transform: translateY(-10vh) rotate(720deg); opacity: 0; }
        }

        .login-wrapper { position: relative; z-index: 1; width: 100%; max-width: 440px; padding: 20px; }

        .login-card {
            background: rgba(255,255,255,0.08);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 24px;
            padding: 48px 40px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
            animation: cardSlideUp 0.8s cubic-bezier(0.16,1,0.3,1) forwards;
            opacity: 0;
            transform: translateY(30px);
        }

        @keyframes cardSlideUp { to { opacity: 1; transform: translateY(0); } }

        .brand { text-align: center; margin-bottom: 36px; }
        .brand-icon {
            width: 64px; height: 64px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 18px;
            display: inline-flex; align-items: center; justify-content: center;
            margin-bottom: 16px;
            box-shadow: 0 4px 15px rgba(102,126,234,0.4);
            animation: iconPulse 3s ease-in-out infinite;
        }
        @keyframes iconPulse {
            0%, 100% { box-shadow: 0 4px 15px rgba(102,126,234,0.4); }
            50% { box-shadow: 0 4px 25px rgba(102,126,234,0.7); }
        }
        .brand-icon svg { width: 32px; height: 32px; fill: white; }
        .brand h1 { font-size: 28px; font-weight: 700; color: #fff; margin-bottom: 6px; letter-spacing: -0.5px; }
        .brand p { font-size: 14px; color: rgba(255,255,255,0.55); font-weight: 400; }

        .input-group-custom { position: relative; margin-bottom: 24px; }
        .input-group-custom .input-icon { position: absolute; left: 16px; top: 50%; transform: translateY(-50%); z-index: 2; }
        .input-group-custom .input-icon svg { width: 20px; height: 20px; stroke: rgba(255,255,255,0.35); transition: stroke 0.3s ease; }
        .input-group-custom input {
            width: 100%; padding: 16px 16px 16px 50px;
            background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1);
            border-radius: 14px; color: #fff; font-size: 15px;
            font-family: 'Inter', sans-serif; transition: all 0.3s ease; outline: none;
        }
        .input-group-custom input::placeholder { color: rgba(255,255,255,0.35); }
        .input-group-custom input:focus { background: rgba(255,255,255,0.1); border-color: rgba(102,126,234,0.6); box-shadow: 0 0 0 3px rgba(102,126,234,0.15); }
        .input-group-custom input:focus ~ .input-icon svg { stroke: #667eea; }

        .toggle-password { position: absolute; right: 16px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; padding: 4px; z-index: 2; }
        .toggle-password svg { width: 20px; height: 20px; stroke: rgba(255,255,255,0.35); transition: stroke 0.3s ease; }
        .toggle-password:hover svg { stroke: rgba(255,255,255,0.7); }

        .btn-login {
            width: 100%; padding: 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none; border-radius: 14px; color: #fff;
            font-size: 16px; font-weight: 600; font-family: 'Inter', sans-serif;
            cursor: pointer; transition: all 0.3s ease;
            position: relative; overflow: hidden; margin-top: 8px;
        }
        .btn-login::before { content: ''; position: absolute; top: 0; left: -100%; width: 100%; height: 100%; background: linear-gradient(90deg, transparent, rgba(255,255,255,0.15), transparent); transition: left 0.5s ease; }
        .btn-login:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(102,126,234,0.45); }
        .btn-login:hover::before { left: 100%; }
        .btn-login:active { transform: translateY(0); }

        .btn-google {
            width: 100%; padding: 14px;
            background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.15);
            border-radius: 14px; color: #fff; font-size: 15px; font-weight: 500;
            font-family: 'Inter', sans-serif; cursor: pointer; transition: all 0.3s ease;
            display: flex; align-items: center; justify-content: center; gap: 12px; text-decoration: none;
        }
        .btn-google:hover { background: rgba(255,255,255,0.12); border-color: rgba(255,255,255,0.25); transform: translateY(-2px); box-shadow: 0 4px 15px rgba(0,0,0,0.2); color: #fff; text-decoration: none; }
        .btn-google:active { transform: translateY(0); }
        .btn-google svg { width: 20px; height: 20px; flex-shrink: 0; }

        .divider { display: flex; align-items: center; margin: 28px 0; }
        .divider::before, .divider::after { content: ''; flex: 1; height: 1px; background: rgba(255,255,255,0.12); }
        .divider span { padding: 0 16px; color: rgba(255,255,255,0.4); font-size: 13px; font-weight: 500; text-transform: uppercase; letter-spacing: 1px; }

        .register-link { text-align: center; }
        .register-link a { color: rgba(255,255,255,0.55); text-decoration: none; font-size: 14px; font-weight: 400; transition: color 0.3s ease; }
        .register-link a span { color: #667eea; font-weight: 600; transition: color 0.3s ease; }
        .register-link a:hover { color: rgba(255,255,255,0.8); }
        .register-link a:hover span { color: #8fa4f0; }

        .login-alert {
            padding: 12px 14px;
            border-radius: 12px;
            margin-bottom: 18px;
            font-size: 0.92rem;
            line-height: 1.45;
        }
        .login-alert-error {
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.35);
            color: #fecaca;
        }

        @media (max-width: 480px) {
            .login-card { padding: 36px 24px; border-radius: 20px; }
            .brand-icon { width: 56px; height: 56px; border-radius: 16px; }
            .brand h1 { font-size: 24px; }
            .input-group-custom input { padding: 14px 14px 14px 46px; font-size: 14px; }
            .btn-login { padding: 14px; font-size: 15px; }
        }
    </style>
</head>
<body>

<div class="particles">
    <div class="particle"></div><div class="particle"></div><div class="particle"></div>
    <div class="particle"></div><div class="particle"></div><div class="particle"></div>
    <div class="particle"></div><div class="particle"></div><div class="particle"></div>
    <div class="particle"></div><div class="particle"></div><div class="particle"></div>
</div>

<div class="login-wrapper">
    <div class="login-card">

        <div class="brand">
            <div class="brand-icon">
                <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
            </div>
            <h1>QuizPal</h1>
            <p>Sign in to test your knowledge</p>
        </div>

        <% if (request.getParameter("error") != null) { %>
        <div class="login-alert login-alert-error">
            Invalid username or password.
        </div>
        <% } %>

        <% if (request.getParameter("oauth_error") != null) { %>
        <div class="login-alert login-alert-error">
            Google sign-in failed. Production Google OAuth requires an HTTPS domain name
            (not a raw IP address). Use username/password for now, or see docs/GOOGLE-OAUTH.md.
        </div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/login">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <div class="input-group-custom">
                <input type="text" id="username" name="username" placeholder="Username" required autocomplete="username" />
                <div class="input-icon">
                    <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <circle cx="12" cy="7" r="4" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </div>
            </div>

            <div class="input-group-custom">
                <input type="password" id="password" name="password" placeholder="Password" required autocomplete="current-password" />
                <div class="input-icon">
                    <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M7 11V7a5 5 0 0110 0v4" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </div>
                <button type="button" class="toggle-password" onclick="togglePassword()">
                    <svg id="eyeIcon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <circle cx="12" cy="12" r="3" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </button>
            </div>

            <button type="submit" class="btn-login">Sign In</button>
        </form>

        <div class="divider">
            <span>or continue with</span>
        </div>

        <a href="${pageContext.request.contextPath}/oauth2/authorization/google" class="btn-google">
            <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 01-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z" fill="#4285F4"/>
                <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
                <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
                <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
            </svg>
            Sign in with Google
        </a>

        <div class="divider" style="margin: 20px 0 16px 0;">
            <span>new here?</span>
        </div>

        <div class="register-link">
            <a href="${pageContext.request.contextPath}/register">
                Don't have an account? <span>Sign up</span>
            </a>
        </div>

    </div>
</div>

<script>
    function togglePassword() {
        const passwordInput = document.getElementById('password');
        const eyeIcon = document.getElementById('eyeIcon');
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            eyeIcon.innerHTML = '<path d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19m-6.72-1.07a3 3 0 11-4.24-4.24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><line x1="1" y1="1" x2="23" y2="23" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>';
        } else {
            passwordInput.type = 'password';
            eyeIcon.innerHTML = '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><circle cx="12" cy="12" r="3" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>';
        }
    }
</script>

</body>
</html>