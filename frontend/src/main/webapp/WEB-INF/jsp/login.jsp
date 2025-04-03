<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" integrity="sha512-jnSuA4Ss2PkkikSOLtYs8BlYIeeIK1h99ty4YfvRPAlzr377vr3CXDb7sb7eEEBYjDtcYj+AjBH3FLv5uSJuXg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        #errorMessage { color: red; margin-top: 10px; }
    </style>
</head>
<body class="container mt-5">
<h2>Iniciar Sesión</h2>
<form id="loginForm">
    <div class="mb-3">
        <label for="username" class="form-label">Usuario:</label>
        <input type="text" id="username" name="username" class="form-control" required>
    </div>
    <div class="mb-3">
        <label for="password" class="form-label">Contraseña:</label>
        <input type="password" id="password" name="password" class="form-control" required>
    </div>
    <button type="submit" class="btn btn-primary">Entrar</button>
    <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary">Registrarse</a>
</form>
<div id="errorMessage" class=""></div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js" integrity="sha512-7Pi/otdlbbCR+LnW+F7PwFcSDJOuUJB3OxtEHbg4vSMvzvJjde4Po1v4BR9Gdc9aXNUNFVUY+SK51wWT8WF0Gg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script>
    document.getElementById('loginForm').addEventListener('submit', function(event) {
        event.preventDefault();

        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;
        const errorMessageDiv = document.getElementById('errorMessage');
        errorMessageDiv.textContent = '';

        fetch('/api/auth/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ username: username, password: password })
        })
            .then(response => {
                if (response.ok) {
                    return response.json();
                } else {
                    if (response.status === 403) {
                        throw new Error('Usuario o contraseña incorrectos.');
                    }

                    response.text().then(text => {
                        throw new Error(text || 'Error en el servidor.');
                    });
                }
            })
            .then(data => {
                console.log('Login exitoso:', data);

                localStorage.setItem("token", data.token);

                window.location.href = "/";
            })
            .catch(error => {
                errorMessageDiv.textContent = error.message || 'Usuario o contraseña incorrectos.';
            });
    });
</script>
</body>
</html>
