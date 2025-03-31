<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Registro</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" integrity="sha512-jnSuA4Ss2PkkikSOLtYs8BlYIeeIK1h99ty4YfvRPAlzr377vr3CXDb7sb7eEEBYjDtcYj+AjBH3FLv5uSJuXg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        /* Opcional: Ocultar el div de mensajes inicialmente */
        #alertMessage { margin-top: 15px; }
    </style>
</head>
<body class="container mt-5">
<h2>Registro</h2>
<form id="registerForm">
    <div class="mb-3">
        <label for="username" class="form-label">Usuario:</label>
        <input type="text" id="username" name="username" class="form-control" required>
        <div id="usernameError" class="invalid-feedback"></div> </div>
    <div class="mb-3 row">
        <div class="col">
            <label for="password" class="form-label">Contraseña:</label>
            <input type="password" id="password" name="password" class="form-control" required>
            <div id="passwordError" class="invalid-feedback"></div> </div>
        <div class="col">
            <label for="password2" class="form-label">Confirmar Contraseña:</label>
            <input type="password" id="password2" name="password2" class="form-control" required>
            <div id="password2Error" class="invalid-feedback"></div> </div>
    </div>
    <button type="submit" class="btn btn-primary">Registrarse</button>
    <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">Iniciar sesión</a>
</form>
<div id="alertMessage" class="alert" role="alert" style="display: none;"></div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js" integrity="sha512-7Pi/otdlbbCR+LnW+F7PwFcSDJOuUJB3OxtEHbg4vSMvzvJjde4Po1v4BR9Gdc9aXNUNFVUY+SK51wWT8WF0Gg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script>
    const registerForm = document.getElementById('registerForm');
    const usernameInput = document.getElementById('username');
    const passwordInput = document.getElementById('password');
    const password2Input = document.getElementById('password2');
    const alertMessageDiv = document.getElementById('alertMessage');

    const usernameErrorDiv = document.getElementById('usernameError');
    const passwordErrorDiv = document.getElementById('passwordError');
    const password2ErrorDiv = document.getElementById('password2Error');

    function showMessage(message, isSuccess = false) {
        alertMessageDiv.textContent = message;
        alertMessageDiv.className = `alert \${isSuccess ? 'alert-success' : 'alert-danger'}`;
        alertMessageDiv.style.display = 'block';
    }

    // Función para limpiar errores específicos de campos
    function clearFieldErrors() {
        usernameInput.classList.remove('is-invalid');
        passwordInput.classList.remove('is-invalid');
        password2Input.classList.remove('is-invalid');
        usernameErrorDiv.textContent = '';
        passwordErrorDiv.textContent = '';
        password2ErrorDiv.textContent = '';
        alertMessageDiv.style.display = 'none';
    }

    // Función para mostrar errores específicos de campos
    function showFieldError(fieldId, message) {
        const inputElement = document.getElementById(fieldId);
        const errorDiv = document.getElementById(`\${fieldId}Error`);
        if(inputElement && errorDiv) {
            inputElement.classList.add('is-invalid');
            errorDiv.textContent = message;
        }
    }


    registerForm.addEventListener('submit', function(event) {
        event.preventDefault();
        clearFieldErrors();

        const username = usernameInput.value;
        const password = passwordInput.value;
        const password2 = password2Input.value;

        if (password !== password2) {
            const errorMessage = 'Las contraseñas no coinciden.';
            showFieldError('password1', errorMessage);
            showFieldError('password2', errorMessage);
            return;
        }

        fetch('/api/auth/register', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ username: username, password: password })
        })
            .then(response => {
                return response.json().then(data => ({ ok: response.ok, status: response.status, body: data }));
            })
            .catch(() => {
                throw new Error('Error de red o respuesta no válida del servidor.'); // Error genérico si .json() falla
            })
            .then(result => {
                if (result.ok) {
                    // ÉXITO (status 2xx)
                    localStorage.setItem("token", result.token);
                    window.location.href = "/";
                    return;
                }

                // La API devuelve 409 si el nombre de usuario ya está en uso
                if (result.status === 409) {
                    showFieldError('username', 'El nombre de usuario ya está en uso.');
                    return;
                }

                // ERROR (status 4xx, 5xx con cuerpo JSON parseado)
                console.error(`Error \${result.status}:`, result.body);
                const errorData = result.body;

                if (errorData.errors && typeof errorData.errors === 'object') {
                    let specificErrorsFound = false;
                    // Mostrar errores específicos por campo si existen
                    for (const field in errorData.errors) {

                        showFieldError(field, errorData.errors[field]);
                        specificErrorsFound = true;
                    }
                }
            });

    });
</script>
</body>
</html>