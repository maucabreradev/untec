<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error Interno del Servidor (500) &bull; UNTEC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/untec-custom.css">
</head>
<body class="bg-light d-flex align-items-center justify-content-center min-vh-100">
    <div class="text-center p-5 bg-white rounded-4 shadow-sm border" style="max-width: 550px;">
        <i class="bi bi-shield-exclamation display-1 text-danger mb-3"></i>
        <h2 class="fw-bold text-dark">500 - Error Interno</h2>
        <p class="text-muted mb-3">Ocurrió un problema procesando tu solicitud en el servidor. Por favor verifica que el servicio de base de datos MySQL esté iniciado y configurado.</p>
        
        <% if (exception != null && exception.getMessage() != null) { %>
            <div class="alert alert-light text-start border small text-secondary mb-4 p-2 text-truncate">
                <strong>Detalle:</strong> <%= exception.getMessage() %>
            </div>
        <% } %>

        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary fw-bold px-4">
            <i class="bi bi-arrow-clockwise me-1"></i> Reintentar
        </a>
    </div>
</body>
</html>
