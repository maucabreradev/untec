<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión &bull; Biblioteca Digital UNTEC</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Google Fonts Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Estilos Personalizados UNTEC -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/untec-custom.css">
</head>
<body class="bg-light">

    <main class="login-wrapper">
        <div class="login-card">
            <div class="login-card-header">
                <div class="mb-3">
                    <i class="bi bi-book-half display-4 text-info"></i>
                </div>
                <h3 class="fw-bold mb-1">Biblioteca Digital</h3>
                <p class="text-light opacity-75 mb-0 small">Universidad Tecnológica UNTEC</p>
            </div>

            <div class="login-card-body">
                <%-- Componente de Mensajes y Alertas --%>
                <jsp:include page="/includes/alerts.jsp" />

                <form action="${pageContext.request.contextPath}/login" method="POST" autocomplete="off" id="formLogin">
                    <div class="mb-3">
                        <label for="email" class="form-label small fw-semibold text-secondary">Correo Institucional</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white text-muted"><i class="bi bi-envelope"></i></span>
                            <input type="email" class="form-control" id="email" name="email" 
                                   placeholder="usuario@untec.edu" required 
                                   value="<c:out value='${emailIngresado}' />">
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="password" class="form-label small fw-semibold text-secondary">Contraseña</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white text-muted"><i class="bi bi-shield-lock"></i></span>
                            <input type="password" class="form-control" id="password" name="password" 
                                   placeholder="••••••••" required>
                        </div>
                    </div>

                    <div class="d-grid mb-4">
                        <button type="submit" class="btn btn-primary btn-lg shadow-sm fw-bold">
                            <i class="bi bi-box-arrow-in-right me-2"></i> Ingresar al Sistema
                        </button>
                    </div>
                </form>

                <!-- Panel de Acceso Rápido para Evaluación / Testing -->
                <div class="border-top pt-3 mt-2">
                    <p class="text-center text-muted small fw-semibold mb-2">Credenciales de Evaluación Docente:</p>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-outline-warning btn-sm w-50" onclick="autoFill('admin@untec.edu', 'admin123')">
                            <i class="bi bi-person-badge me-1"></i> Admin / Biblio
                        </button>
                        <button type="button" class="btn btn-outline-primary btn-sm w-50" onclick="autoFill('estudiante@untec.edu', 'alumno123')">
                            <i class="bi bi-mortarboard me-1"></i> Estudiante
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        function autoFill(email, pass) {
            document.getElementById('email').value = email;
            document.getElementById('password').value = pass;
        }
    </script>
    <!-- Bootstrap 5 Bundle JS (necesario para dismiss de alertas) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
