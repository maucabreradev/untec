<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Inicio &bull; Biblioteca Digital UNTEC</title>
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

        <!-- Encabezado de Bienvenida -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center pb-3 mb-4 border-bottom">
            <div>
                <h2 class="fw-bold text-dark mb-1">
                    ¡Hola, <c:out value="${sessionScope.usuarioLogueado.nombre}" />!
                </h2>
                <p class="text-muted mb-0">
                    <i class="bi bi-mortarboard me-1"></i> <c:out value="${sessionScope.usuarioLogueado.carrera}" /> &bull; 
                    <span class="badge ${sessionScope.usuarioLogueado.rol == 'ADMIN' ? 'bg-warning text-dark' : 'bg-primary'}">
                        <c:out value="${sessionScope.usuarioLogueado.rol}" />
                    </span>
                </p>
            </div>
            <div class="mt-3 mt-md-0 d-flex gap-2">
                <a href="${pageContext.request.contextPath}/libros" class="btn btn-outline-primary">
                    <i class="bi bi-search me-1"></i> Buscar en Catálogo
                </a>
                <c:if test="${sessionScope.usuarioLogueado.rol == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/libros?accion=nuevo" class="btn btn-primary shadow-sm">
                        <i class="bi bi-plus-circle me-1"></i> Nuevo Libro
                    </a>
                </c:if>
            </div>
        </div>

        <!-- ================================================================ -->
        <!-- VISTA DE ADMINISTRADOR / PERSONAL DE BIBLIOTECA -->
        <!-- ================================================================ -->
        <c:if test="${sessionScope.usuarioLogueado.rol == 'ADMIN'}">
            <!-- Métricas Clave -->
            <div class="row g-4 mb-4">
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="stat-label">Títulos Registrados</span>
                                <div class="stat-value"><c:out value="${totalTitulos}" /></div>
                            </div>
                            <div class="stat-icon bg-primary-subtle">
                                <i class="bi bi-journal-text"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card stat-emerald">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="stat-label">Ejemplares Disponibles</span>
                                <div class="stat-value"><c:out value="${ejemplaresDisponibles}" /></div>
                            </div>
                            <div class="stat-icon bg-emerald-subtle">
                                <i class="bi bi-check2-circle"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card stat-gold">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="stat-label">Préstamos Activos</span>
                                <div class="stat-value"><c:out value="${prestamosActivos}" /></div>
                            </div>
                            <div class="stat-icon bg-gold-subtle">
                                <i class="bi bi-arrow-repeat"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card stat-rose">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="stat-label">Alumnos Registrados</span>
                                <div class="stat-value"><c:out value="${totalEstudiantes}" /></div>
                            </div>
                            <div class="stat-icon bg-rose-subtle">
                                <i class="bi bi-people"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tabla de Actividad Reciente de Préstamos -->
            <div class="untec-table-card mb-4">
                <div class="p-3 border-bottom d-flex justify-content-between align-items-center bg-white">
                    <h5 class="fw-bold mb-0 text-dark">
                        <i class="bi bi-clock-history me-2 text-primary"></i> Préstamos Recientes
                    </h5>
                    <a href="${pageContext.request.contextPath}/prestamos?accion=gestionar" class="btn btn-sm btn-outline-secondary">
                        Ver Todos los Préstamos &rarr;
                    </a>
                </div>

                <div class="table-responsive">
                    <table class="table table-untec table-hover mb-0">
                        <thead>
                            <tr>
                                <th># ID</th>
                                <th>Estudiante</th>
                                <th>Libro Solicitado</th>
                                <th>Fecha Préstamo</th>
                                <th>Fecha Devolución</th>
                                <th>Estado</th>
                                <th class="text-end">Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty prestamosRecientes}">
                                    <tr>
                                        <td colspan="7" class="text-center py-4 text-muted">
                                            No hay registros de préstamos recientes.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="p" items="${prestamosRecientes}">
                                        <tr>
                                            <td class="fw-semibold text-secondary">#<c:out value="${p.id}" /></td>
                                            <td>
                                                <div class="fw-bold text-dark"><c:out value="${p.usuario.nombre}" /></div>
                                                <small class="text-muted"><c:out value="${p.usuario.carrera}" /></small>
                                            </td>
                                            <td>
                                                <span class="fw-semibold text-dark"><c:out value="${p.libro.titulo}" /></span>
                                            </td>
                                            <td><c:out value="${p.fechaPrestamo}" /></td>
                                            <td><c:out value="${p.fechaDevolucionEsperada}" /></td>
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
                                            <td class="text-end">
                                                <c:if test="${p.estado != 'DEVUELTO'}">
                                                    <form action="${pageContext.request.contextPath}/prestamos" method="POST" class="d-inline">
                                                        <input type="hidden" name="accion" value="devolver">
                                                        <input type="hidden" name="idPrestamo" value="${p.id}">
                                                        <input type="hidden" name="observacionesDevolucion" value="Recepción en mesón">
                                                        <button type="submit" class="btn btn-sm btn-outline-success" title="Registrar Devolución">
                                                            <i class="bi bi-box-arrow-down me-1"></i> Devolver
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

        <!-- ================================================================ -->
        <!-- VISTA DE ESTUDIANTE -->
        <!-- ================================================================ -->
        <c:if test="${sessionScope.usuarioLogueado.rol != 'ADMIN'}">
            <!-- Métricas del Estudiante -->
            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="stat-card stat-gold">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="stat-label">Libros en mi Posesión</span>
                                <div class="stat-value"><c:out value="${misPrestamosActivos}" /></div>
                            </div>
                            <div class="stat-icon bg-gold-subtle">
                                <i class="bi bi-book"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card stat-emerald">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="stat-label">Libros Devueltos</span>
                                <div class="stat-value"><c:out value="${misPrestamosDevueltos}" /></div>
                            </div>
                            <div class="stat-icon bg-emerald-subtle">
                                <i class="bi bi-check-circle"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="stat-label">Disponibles en Biblioteca</span>
                                <div class="stat-value"><c:out value="${librosDisponiblesCatalogo}" /></div>
                            </div>
                            <div class="stat-icon bg-primary-subtle">
                                <i class="bi bi-collection"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Banner para Explorar Catálogo -->
            <div class="p-4 mb-4 rounded-4 text-white shadow-sm" style="background: linear-gradient(135deg, #1e3a8a 0%, #0284c7 100%);">
                <div class="row align-items-center">
                    <div class="col-lg-8">
                        <h4 class="fw-bold mb-2">¿Buscas material para tus asignaturas?</h4>
                        <p class="mb-0 text-white-50">
                            Explora el catálogo digitalizado de la biblioteca UNTEC y solicita préstamos en línea de manera inmediata.
                        </p>
                    </div>
                    <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                        <a href="${pageContext.request.contextPath}/libros" class="btn btn-light btn-lg fw-bold text-primary shadow-sm">
                            <i class="bi bi-search me-1"></i> Ir al Catálogo
                        </a>
                    </div>
                </div>
            </div>

            <!-- Tabla de Mis Préstamos Recientes -->
            <div class="untec-table-card">
                <div class="p-3 border-bottom d-flex justify-content-between align-items-center bg-white">
                    <h5 class="fw-bold mb-0 text-dark">
                        <i class="bi bi-journal-check me-2 text-primary"></i> Mis Últimos Préstamos
                    </h5>
                    <a href="${pageContext.request.contextPath}/prestamos?accion=mis-prestamos" class="btn btn-sm btn-outline-secondary">
                        Ver Historial Completo &rarr;
                    </a>
                </div>

                <div class="table-responsive">
                    <table class="table table-untec table-hover mb-0">
                        <thead>
                            <tr>
                                <th>Libro</th>
                                <th>Fecha Préstamo</th>
                                <th>Fecha Límite</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty ultimosPrestamos}">
                                    <tr>
                                        <td colspan="4" class="text-center py-4 text-muted">
                                            Aún no tienes préstamos registrados. ¡Visita el catálogo para solicitar tu primer libro!
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="p" items="${ultimosPrestamos}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-dark"><c:out value="${p.libro.titulo}" /></div>
                                                <small class="text-muted"><c:out value="${p.libro.autor}" /></small>
                                            </td>
                                            <td><c:out value="${p.fechaPrestamo}" /></td>
                                            <td><c:out value="${p.fechaDevolucionEsperada}" /></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.estado == 'ACTIVO'}">
                                                        <span class="badge-estado badge-activo"><i class="bi bi-hourglass-split me-1"></i> En posesión</span>
                                                    </c:when>
                                                    <c:when test="${p.estado == 'DEVUELTO'}">
                                                        <span class="badge-estado badge-devuelto"><i class="bi bi-check-all me-1"></i> Devuelto</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-estado badge-vencido"><i class="bi bi-exclamation-circle me-1"></i> Vencido</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>
    </main>

    <!-- Pie de Página -->
    <jsp:include page="/includes/footer.jsp" />
</body>
</html>
