<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catálogo de Libros &bull; Biblioteca Digital UNTEC</title>
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
        <!-- Alertas Flash -->
        <jsp:include page="/includes/alerts.jsp" />

        <!-- Encabezado y Barra de Búsqueda -->
        <div class="row align-items-center mb-4 pb-2 border-bottom">
            <div class="col-lg-6 mb-3 mb-lg-0">
                <h2 class="fw-bold text-dark mb-1">
                    <i class="bi bi-collection me-2 text-primary"></i> Catálogo de Biblioteca
                </h2>
                <p class="text-muted mb-0">Explora los libros disponibles y solicita préstamos para tus asignaturas.</p>
            </div>
            <div class="col-lg-6 text-lg-end">
                <c:if test="${sessionScope.usuarioLogueado.rol == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/libros?accion=nuevo" class="btn btn-primary shadow-sm me-2">
                        <i class="bi bi-plus-circle me-1"></i> Agregar Libro
                    </a>
                    <a href="${pageContext.request.contextPath}/libros?accion=listar" class="btn btn-outline-secondary">
                        <i class="bi bi-gear me-1"></i> Vista de Gestión
                    </a>
                </c:if>
            </div>
        </div>

        <!-- Filtros y Búsqueda -->
        <div class="card border-0 shadow-sm rounded-4 p-3 mb-4 bg-white">
            <form action="${pageContext.request.contextPath}/libros" method="GET" class="row g-2 align-items-center">
                <input type="hidden" name="accion" value="buscar">

                <div class="col-md-7">
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-search"></i></span>
                        <input type="text" name="q" class="form-control bg-light border-start-0" 
                               placeholder="Buscar por título, autor o código ISBN..." 
                               value="<c:out value='${filtroTexto}' />">
                    </div>
                </div>

                <div class="col-md-3">
                    <select name="categoria" class="form-select bg-light">
                        <option value="TODAS">Todas las Categorías</option>
                        <c:forEach var="cat" items="${categorias}">
                            <option value="${cat}" ${filtroCategoria == cat ? 'selected' : ''}>
                                <c:out value="${cat}" />
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-2 d-grid">
                    <button type="submit" class="btn btn-primary fw-semibold">
                        <i class="bi bi-funnel me-1"></i> Filtrar
                    </button>
                </div>
            </form>
        </div>

        <!-- Cuadrícula de Libros -->
        <div class="row g-4">
            <c:choose>
                <c:when test="${empty libros}">
                    <div class="col-12 text-center py-5">
                        <i class="bi bi-journal-x display-1 text-muted"></i>
                        <h4 class="mt-3 text-secondary">No se encontraron libros</h4>
                        <p class="text-muted">Intenta ajustando tus términos de búsqueda o cambiando la categoría.</p>
                        <a href="${pageContext.request.contextPath}/libros" class="btn btn-outline-primary">Ver Todos</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="l" items="${libros}">
                        <div class="col-md-6 col-lg-4">
                            <div class="book-card p-3">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="book-badge-category">
                                        <c:out value="${l.categoria}" />
                                    </span>
                                    <c:choose>
                                        <c:when test="${l.stockDisponible > 0}">
                                            <span class="badge bg-success-subtle text-success border border-success-subtle fw-semibold">
                                                <i class="bi bi-check-circle me-1"></i> Disponible (<c:out value="${l.stockDisponible}" />)
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger-subtle text-danger border border-danger-subtle fw-semibold">
                                                <i class="bi bi-x-circle me-1"></i> Agotado
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <h5 class="book-title"><c:out value="${l.titulo}" /></h5>
                                <div class="book-author"><i class="bi bi-person me-1"></i> <c:out value="${l.autor}" /></div>

                                <p class="text-muted small mb-3 flex-grow-1" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                    <c:out value="${l.descripcion}" />
                                </p>

                                <div class="pt-2 border-top mt-auto">
                                    <div class="d-flex justify-content-between align-items-center text-muted small mb-3">
                                        <span><i class="bi bi-upc-scan me-1"></i> <c:out value="${l.isbn}" /></span>
                                        <span><i class="bi bi-geo-alt me-1"></i> <c:out value="${l.ubicacion}" /></span>
                                    </div>

                                    <c:choose>
                                        <c:when test="${l.stockDisponible > 0}">
                                            <button type="button" class="btn btn-primary w-100 shadow-sm" 
                                                    data-bs-toggle="modal" data-bs-target="#modalSolicitar"
                                                    onclick="prepararModalSolicitud('${l.id}', '${l.titulo}', '${l.autor}', '${l.stockDisponible}')">
                                                <i class="bi bi-book me-1"></i> Solicitar Préstamo
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-secondary w-100 disabled" disabled>
                                                <i class="bi bi-clock me-1"></i> Sin Stock Disponible
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <!-- Modal de Solicitud de Préstamo -->
    <div class="modal fade" id="modalSolicitar" tabindex="-1" aria-labelledby="modalSolicitarLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <form action="${pageContext.request.contextPath}/prestamos" method="POST">
                    <input type="hidden" name="accion" value="solicitar">
                    <input type="hidden" name="idLibro" id="modalIdLibro">

                    <div class="modal-header bg-primary text-white rounded-top-4">
                        <h5 class="modal-title fw-bold" id="modalSolicitarLabel">
                            <i class="bi bi-journal-plus me-2"></i> Confirmar Préstamo de Libro
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body p-4">
                        <div class="alert alert-info py-2 small mb-3">
                            <i class="bi bi-info-circle me-1"></i> Al solicitar un libro, te comprometes a cuidarlo y devolverlo en la fecha estipulada.
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Libro Seleccionado:</label>
                            <div class="fw-bold text-dark fs-6" id="modalTituloLibro"></div>
                            <small class="text-secondary" id="modalAutorLibro"></small>
                        </div>

                        <div class="mb-3">
                            <label for="modalDias" class="form-label text-muted small fw-bold">Plazo de Préstamo:</label>
                            <select name="dias" id="modalDias" class="form-select">
                                <option value="7" selected>7 días (1 semana - Préstamo regular)</option>
                                <option value="14">14 días (2 semanas - Proyecto académico)</option>
                                <option value="21">21 días (3 semanas - Tesis de grado)</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="modalObservaciones" class="form-label text-muted small fw-bold">Motivo u Observaciones (Opcional):</label>
                            <textarea name="observaciones" id="modalObservaciones" class="form-control" rows="2" 
                                      placeholder="Ej. Estudio para examen de recuperación..."></textarea>
                        </div>
                    </div>

                    <div class="modal-footer bg-light rounded-bottom-4">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary fw-bold shadow-sm">
                            <i class="bi bi-check2 me-1"></i> Confirmar Préstamo
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Script para alimentar modal dinámico -->
    <script>
        function prepararModalSolicitud(id, titulo, autor, stock) {
            document.getElementById('modalIdLibro').value = id;
            document.getElementById('modalTituloLibro').innerText = titulo;
            document.getElementById('modalAutorLibro').innerText = 'Autor: ' + autor + ' | Stock disponible: ' + stock;
        }
    </script>

    <!-- Pie de Página -->
    <jsp:include page="/includes/footer.jsp" />
</body>
</html>
