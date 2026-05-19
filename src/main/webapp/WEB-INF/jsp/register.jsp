<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>QuizPal - Sign Up</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(-45deg, #0f0c29, #302b63, #24243e, #0f0c29);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            overflow-y: auto;
        }

        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .particles {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 0;
        }

        .particle {
            position: absolute;
            width: 6px;
            height: 6px;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 50%;
            animation: float linear infinite;
        }

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

        @keyframes float {
            0% { transform: translateY(100vh) rotate(0deg); opacity: 0; }
            10% { opacity: 1; }
            90% { opacity: 1; }
            100% { transform: translateY(-10vh) rotate(720deg); opacity: 0; }
        }

        .register-wrapper {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 520px;
            padding: 20px;
            margin: 40px 0;
        }

        .register-card {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 24px;
            padding: 44px 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            animation: cardSlideUp 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards;
            opacity: 0;
            transform: translateY(30px);
        }

        @keyframes cardSlideUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .brand {
            text-align: center;
            margin-bottom: 32px;
        }

        .brand-icon {
            width: 64px;
            height: 64px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 18px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 16px;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            animation: iconPulse 3s ease-in-out infinite;
        }

        @keyframes iconPulse {
            0%, 100% { box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4); }
            50% { box-shadow: 0 4px 25px rgba(102, 126, 234, 0.7); }
        }

        .brand-icon svg {
            width: 32px;
            height: 32px;
        }

        .brand h1 {
            font-size: 28px;
            font-weight: 700;
            color: #fff;
            margin-bottom: 6px;
            letter-spacing: -0.5px;
        }

        .brand p {
            font-size: 14px;
            color: rgba(255, 255, 255, 0.55);
            font-weight: 400;
        }

        .input-group-custom {
            position: relative;
            margin-bottom: 20px;
        }

        .input-group-custom .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 2;
        }

        .input-group-custom .input-icon svg {
            width: 20px;
            height: 20px;
            stroke: rgba(255, 255, 255, 0.35);
            transition: stroke 0.3s ease;
        }

        .input-group-custom input {
            width: 100%;
            padding: 16px 16px 16px 50px;
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 14px;
            color: #fff;
            font-size: 15px;
            font-family: 'Inter', sans-serif;
            transition: all 0.3s ease;
            outline: none;
        }

        .input-group-custom input::placeholder {
            color: rgba(255, 255, 255, 0.35);
        }

        .input-group-custom input:focus {
            background: rgba(255, 255, 255, 0.1);
            border-color: rgba(102, 126, 234, 0.6);
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.15);
        }

        .input-group-custom input:focus ~ .input-icon svg {
            stroke: #667eea;
        }

        .input-row {
            display: flex;
            gap: 16px;
        }

        .input-row .input-group-custom {
            flex: 1;
        }

        .btn-register {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 14px;
            color: #fff;
            font-size: 16px;
            font-weight: 600;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            margin-top: 8px;
        }

        .btn-register::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.15), transparent);
            transition: left 0.5s ease;
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.45);
        }

        .btn-register:hover::before {
            left: 100%;
        }

        .btn-register:active {
            transform: translateY(0);
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 24px 0;
        }

        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: rgba(255, 255, 255, 0.12);
        }

        .divider span {
            padding: 0 16px;
            color: rgba(255, 255, 255, 0.4);
            font-size: 13px;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .login-link {
            text-align: center;
        }

        .login-link a {
            color: rgba(255, 255, 255, 0.55);
            text-decoration: none;
            font-size: 14px;
            font-weight: 400;
            transition: color 0.3s ease;
        }

        .login-link a span {
            color: #667eea;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .login-link a:hover {
            color: rgba(255, 255, 255, 0.8);
        }

        .login-link a:hover span {
            color: #8fa4f0;
        }

        @media (max-width: 480px) {
            .register-card {
                padding: 36px 24px;
                border-radius: 20px;
            }

            .brand-icon {
                width: 56px;
                height: 56px;
                border-radius: 16px;
            }

            .brand h1 {
                font-size: 24px;
            }

            .input-row {
                flex-direction: column;
                gap: 0;
            }

            .input-group-custom input {
                padding: 14px 14px 14px 46px;
                font-size: 14px;
            }

            .btn-register {
                padding: 14px;
                font-size: 15px;
            }
        }
    </style>
</head>
<body>

<div class="particles">
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
</div>

<div class="register-wrapper">
    <div class="register-card">

        <div class="brand">
            <div class="brand-icon">
                <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path d="M16 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    <circle cx="8.5" cy="7" r="4" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    <line x1="20" y1="8" x2="20" y2="14" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    <line x1="23" y1="11" x2="17" y2="11" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
            </div>
            <h1>Create Account</h1>
            <p>Join QuizPal and start learning</p>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/register">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

            <!-- Username -->
            <div class="input-group-custom">
                <input type="text" id="username" name="username" placeholder="Username" required autocomplete="username" />
                <div class="input-icon">
                    <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <circle cx="12" cy="7" r="4" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </div>
            </div>

            <!-- Password -->
            <div class="input-group-custom">
                <input type="password" id="password" name="password" placeholder="Password" required autocomplete="new-password" />
                <div class="input-icon">
                    <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M7 11V7a5 5 0 0110 0v4" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </div>
            </div>

            <!-- First Name & Last Name -->
            <div class="input-row">
                <div class="input-group-custom">
                    <input type="text" id="firstname" name="firstname" placeholder="First Name" required />
                    <div class="input-icon">
                        <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </div>
                </div>
                <div class="input-group-custom">
                    <input type="text" id="lastname" name="lastname" placeholder="Last Name" required />
                    <div class="input-icon">
                        <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </div>
                </div>
            </div>

            <!-- Email & Phone -->
            <div class="input-row">
                <div class="input-group-custom">
                    <input type="email" id="email" name="email" placeholder="Email" required />
                    <div class="input-icon">
                        <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                            <polyline points="22,6 12,13 2,6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </div>
                </div>
                <div class="input-group-custom">
                    <input type="tel" id="phone" name="phone" placeholder="Phone" required />
                    <div class="input-icon">
                        <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07 19.5 19.5 0 01-6-6 19.79 19.79 0 01-3.07-8.67A2 2 0 014.11 2h3a2 2 0 012 1.72 12.84 12.84 0 00.7 2.81 2 2 0 01-.45 2.11L8.09 9.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45 12.84 12.84 0 002.81.7A2 2 0 0122 16.92z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </div>
                </div>
            </div>

            <!-- Submit -->
            <button type="submit" class="btn-register">Create Account</button>
        </form>

        <div class="divider">
            <span>or</span>
        </div>

        <div class="login-link">
            <a href="${pageContext.request.contextPath}/login">
                Already have an account? <span>Sign in</span>
            </a>
        </div>

    </div>
</div>

</body>
</html>
