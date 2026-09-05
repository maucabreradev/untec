<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página No Encontrada (404) &bull; UNTEC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/untec-custom.css">
</head>
<body class="bg-light d-flex align-items-center justify-content-center min-vh-100">
    <div class="text-center p-5 bg-white rounded-4 shadow-sm border" style="max-width: 500px;">
        <i class="bi bi-compass display-1 text-primary mb-3"></i>
        <h2 class="fw-bold text-dark">404 - Recurso No Encontrado</h2>
        <p class="text-muted mb-4">La página o archivo que estás buscando no existe o ha sido movido en la Biblioteca UNTEC.</p>
        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary fw-bold px-4">
            <i class="bi bi-house me-1"></i> Volver al Inicio
        </a>
    </div>
</body>
</html>
