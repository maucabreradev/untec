<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Préstamos &bull; Biblioteca Digital UNTEC</title>
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
<body>

    <!-- Barra de Navegación -->
    <jsp:include page="/includes/navbar.jsp" />

    <main class="container py-4">
        <!-- Alertas de Sesión -->
        <jsp:include page="/includes/alerts.jsp" />

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center pb-3 mb-4 border-bottom">
            <div>
                <h2 class="fw-bold text-dark mb-1">
                    <i class="bi bi-journal-bookmark me-2 text-primary"></i> Mi Historial de Préstamos
                </h2>
                <p class="text-muted mb-0">Consulta tus libros solicitados, plazos de entrega y estado de devoluciones.</p>
            </div>
            <div class="mt-3 mt-md-0">
                <a href="${pageContext.request.contextPath}/libros" class="btn btn-outline-primary">
                    <i class="bi bi-search me-1"></i> Explorar Catálogo
                </a>
            </div>
        </div>

        <div class="untec-table-card">
            <div class="table-responsive">
                <table class="table table-untec table-hover mb-0">
                    <thead>
                        <tr>
                            <th># Préstamo</th>
                            <th>Libro y Autor</th>
                            <th>Categoría</th>
                            <th>Fecha Solicitud</th>
                            <th>Fecha Límite</th>
                            <th>Fecha Entrega</th>
                            <th>Estado</th>
                            <th>Observaciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty misPrestamos}">
                                <tr>
                                    <td colspan="8" class="text-center py-5">
                                        <i class="bi bi-inbox display-4 text-muted d-block mb-3"></i>
                                        <p class="text-secondary fw-semibold mb-2">Aún no has solicitado préstamos en la biblioteca.</p>
                                        <a href="${pageContext.request.contextPath}/libros" class="btn btn-sm btn-primary">
                                            Solicitar mi primer libro
                                        </a>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="p" items="${misPrestamos}">
                                    <tr>
                                        <td class="fw-semibold text-secondary">#<c:out value="${p.id}" /></td>
                                        <td>
                                            <div class="fw-bold text-dark"><c:out value="${p.libro.titulo}" /></div>
                                            <small class="text-muted"><c:out value="${p.libro.autor}" /></small>
                                        </td>
                                        <td>
                                            <span class="badge bg-light text-dark border"><c:out value="${p.libro.categoria}" /></span>
                                        </td>
                                        <td><c:out value="${p.fechaPrestamo}" /></td>
                                        <td><span class="fw-bold text-dark"><c:out value="${p.fechaDevolucionEsperada}" /></span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty p.fechaDevolucionReal}">
                                                    <c:out value="${p.fechaDevolucionReal}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted fst-italic">Pendiente</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.estado == 'ACTIVO'}">
                                                    <span class="badge-estado badge-activo"><i class="bi bi-hourglass-split me-1"></i> Activo</span>
                                                </c:when>
                                                <c:when test="${p.estado == 'DEVUELTO'}">
                                                    <span class="badge-estado badge-devuelto"><i class="bi bi-check-all me-1"></i> Devuelto</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-estado badge-vencido"><i class="bi bi-exclamation-circle me-1"></i> Vencido</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><small class="text-muted"><c:out value="${p.observaciones}" /></small></td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Pie de Página -->
    <jsp:include page="/includes/footer.jsp" />
</body>
</html>
