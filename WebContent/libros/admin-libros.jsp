<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Libros &bull; Biblioteca Digital UNTEC</title>
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
                    <i class="bi bi-book me-2 text-primary"></i> Gestión de Inventario de Libros
                </h2>
                <p class="text-muted mb-0">Panel exclusivo para administración del catálogo, stock y ejemplares.</p>
            </div>
            <div class="mt-3 mt-md-0 d-flex gap-2">
                <a href="${pageContext.request.contextPath}/libros?accion=nuevo" class="btn btn-primary shadow-sm">
                    <i class="bi bi-plus-circle me-1"></i> Registrar Nuevo Libro
                </a>
            </div>
        </div>

        <!-- Tabla CRUD de Libros -->
        <div class="untec-table-card">
            <div class="p-3 border-bottom bg-white d-flex justify-content-between align-items-center flex-wrap gap-2">
                <form action="${pageContext.request.contextPath}/libros" method="GET" class="d-flex gap-2" style="max-width: 400px; width: 100%;">
                    <input type="hidden" name="accion" value="buscar">
                    <div class="input-group input-group-sm">
                        <input type="text" name="q" class="form-control" placeholder="Buscar libro..." value="<c:out value='${filtroTexto}' />">
                        <button class="btn btn-outline-secondary" type="submit"><i class="bi bi-search"></i></button>
                    </div>
                </form>
                <div class="text-muted small">
                    Mostrando <strong><c:out value="${libros.size()}" /></strong> libros en inventario
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-untec table-hover mb-0">
                    <thead>
                        <tr>
                            <th>ISBN</th>
                            <th>Título y Autor</th>
                            <th>Categoría</th>
                            <th>Año</th>
                            <th>Stock Disponible</th>
                            <th>Ubicación</th>
                            <th class="text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty libros}">
                                <tr>
                                    <td colspan="7" class="text-center py-4 text-muted">
                                        No hay libros registrados con los criterios seleccionados.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="l" items="${libros}">
                                    <tr>
                                        <td>
                                            <code class="text-secondary"><c:out value="${l.isbn}" /></code>
                                        </td>
                                        <td>
                                            <div class="fw-bold text-dark"><c:out value="${l.titulo}" /></div>
                                            <small class="text-muted"><c:out value="${l.autor}" /> &bull; <c:out value="${l.editorial}" /></small>
                                        </td>
                                        <td>
                                            <span class="badge bg-light text-dark border"><c:out value="${l.categoria}" /></span>
                                        </td>
                                        <td><c:out value="${l.anioPublicacion}" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${l.stockDisponible > 0}">
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle">
                                                        <c:out value="${l.stockDisponible}" /> de <c:out value="${l.stockTotal}" />
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle">
                                                        0 de <c:out value="${l.stockTotal}" /> (Agotado)
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><small class="text-muted"><c:out value="${l.ubicacion}" /></small></td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/libros?accion=editar&id=${l.id}" 
                                               class="btn btn-sm btn-outline-primary me-1" title="Editar Libro">
                                                <i class="bi bi-pencil-square"></i>
                                            </a>
                                            <button type="button" class="btn btn-sm btn-outline-danger" title="Eliminar Libro"
                                                    onclick="confirmarEliminacion('${l.id}', '${l.titulo}')">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Modal de Confirmación de Eliminación -->
    <div class="modal fade" id="modalEliminar" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header bg-danger text-white rounded-top-4">
                    <h5 class="modal-title fw-bold"><i class="bi bi-exclamation-triangle me-2"></i> Confirmar Eliminación</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <p class="mb-1">¿Estás seguro de que deseas eliminar este libro del catálogo?</p>
                    <div class="fw-bold text-dark fs-6 mt-2" id="eliminarTituloLibro"></div>
                    <small class="text-muted d-block mt-2">Nota: No se puede eliminar un libro si posee préstamos registrados en el historial de la biblioteca.</small>
                </div>
                <div class="modal-footer bg-light rounded-bottom-4">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="#" id="btnConfirmarEliminar" class="btn btn-danger fw-bold">
                        <i class="bi bi-trash me-1"></i> Sí, Eliminar
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function confirmarEliminacion(id, titulo) {
            document.getElementById('eliminarTituloLibro').innerText = titulo;
            document.getElementById('btnConfirmarEliminar').href = '${pageContext.request.contextPath}/libros?accion=eliminar&id=' + id;
            var modal = new bootstrap.Modal(document.getElementById('modalEliminar'));
            modal.show();
        }
    </script>

    <!-- Pie de Página -->
    <jsp:include page="/includes/footer.jsp" />
</body>
</html>
