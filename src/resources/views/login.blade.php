<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="app-base-url" content="{{ url('/') }}">
    <title>{{ config('settings.application.company_name') }} - Login</title>
    <link rel="shortcut icon" href="{{ config('settings.application.company_icon') }}">
    <style>
        :root {
            --primary: #4f46e5;
            --primary-hover: #4338ca;
            --text: #111827;
            --muted: #6b7280;
            --bg: #f3f4f6;
            --card-bg: #ffffff;
            --danger: #dc2626;
            --border: #d1d5db;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            color: var(--text);
            background: radial-gradient(circle at top, #eef2ff 0%, var(--bg) 35%, #e5e7eb 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }

        .login-card {
            width: 100%;
            max-width: 430px;
            background: var(--card-bg);
            border-radius: 18px;
            box-shadow: 0 20px 55px rgba(15, 23, 42, 0.15);
            padding: 32px;
        }

        .login-title {
            margin: 0 0 8px;
            font-size: 28px;
            font-weight: 700;
            text-align: center;
        }

        .login-subtitle {
            margin: 0 0 24px;
            text-align: center;
            color: var(--muted);
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 16px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 600;
        }

        input {
            width: 100%;
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 12px 14px;
            font-size: 14px;
            outline: none;
            transition: border-color .2s ease, box-shadow .2s ease;
        }

        input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, .15);
        }

        .error {
            display: none;
            margin-top: 8px;
            color: var(--danger);
            font-size: 12px;
        }

        .alert {
            display: none;
            margin-bottom: 16px;
            border: 1px solid #fecaca;
            background: #fef2f2;
            color: #991b1b;
            border-radius: 10px;
            padding: 10px 12px;
            font-size: 13px;
        }

        .btn {
            width: 100%;
            border: 0;
            border-radius: 10px;
            padding: 12px 14px;
            background: var(--primary);
            color: #fff;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color .2s ease;
        }

        .btn:hover {
            background: var(--primary-hover);
        }

        .btn:disabled {
            opacity: .65;
            cursor: not-allowed;
        }

        .loading {
            display: none;
            font-size: 13px;
            color: var(--muted);
            text-align: center;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div class="login-card">
    <h1 class="login-title">Sign in</h1>
    <p class="login-subtitle">Use your account credentials to access your dashboard.</p>

    <div id="generalError" class="alert"></div>

    <form id="loginForm" novalidate>
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" placeholder="name@example.com" required>
            <div id="emailError" class="error"></div>
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="••••••••" required>
            <div id="passwordError" class="error"></div>
        </div>

        <button type="submit" id="submitBtn" class="btn">Sign in</button>
        <div id="loadingText" class="loading">Signing in...</div>
    </form>
</div>

<script>
    const form = document.getElementById('loginForm');
    const submitBtn = document.getElementById('submitBtn');
    const loadingText = document.getElementById('loadingText');
    const generalError = document.getElementById('generalError');
    const emailError = document.getElementById('emailError');
    const passwordError = document.getElementById('passwordError');

    const setLoading = (isLoading) => {
        submitBtn.disabled = isLoading;
        loadingText.style.display = isLoading ? 'block' : 'none';
    };

    const clearErrors = () => {
        [generalError, emailError, passwordError].forEach((el) => {
            el.style.display = 'none';
            el.textContent = '';
        });
    };

    const showFieldErrors = (errors = {}) => {
        if (errors.email) {
            emailError.textContent = errors.email[0] || 'Invalid email.';
            emailError.style.display = 'block';
        }

        if (errors.password) {
            passwordError.textContent = errors.password[0] || 'Invalid password.';
            passwordError.style.display = 'block';
        }
    };

    form.addEventListener('submit', async (event) => {
        event.preventDefault();
        clearErrors();
        setLoading(true);

        const payload = {
            email: form.email.value.trim(),
            password: form.password.value
        };

        try {
            const response = await fetch('/api/auth/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
                },
                body: JSON.stringify(payload)
            });

            const data = await response.json();

            if (!response.ok) {
                if (response.status === 422) {
                    showFieldErrors(data.errors || {});
                } else {
                    generalError.textContent = data.message || 'Login failed. Please try again.';
                    generalError.style.display = 'block';
                }
                return;
            }

            if (data.access_token) {
                localStorage.setItem('access_token', data.access_token);
            }

            if (data.permissions) {
                localStorage.setItem('authPermission', JSON.stringify(data.permissions));
            }

            window.location.href = '/';
        } catch (error) {
            generalError.textContent = 'Network error. Please try again.';
            generalError.style.display = 'block';
        } finally {
            setLoading(false);
        }
    });
</script>
</body>
</html>
