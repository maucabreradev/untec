<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Control de Préstamos &bull; Biblioteca Digital UNTEC</title>
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
                    <i class="bi bi-arrow-left-right me-2 text-primary"></i> Control de Préstamos y Devoluciones
                </h2>
                <p class="text-muted mb-0">Supervisa las solicitudes de los estudiantes y registra las devoluciones físicas al inventario.</p>
            </div>
            <div class="mt-3 mt-md-0">
                <a href="${pageContext.request.contextPath}/libros" class="btn btn-outline-secondary">
                    <i class="bi bi-collection me-1"></i> Ver Catálogo
                </a>
            </div>
        </div>

        <div class="untec-table-card">
            <div class="table-responsive">
                <table class="table table-untec table-hover mb-0">
                    <thead>
                        <tr>
                            <th># Préstamo</th>
                            <th>Estudiante</th>
                            <th>Libro Solicitado</th>
                            <th>Fecha Préstamo</th>
                            <th>Fecha Límite</th>
                            <th>Fecha Devolución</th>
                            <th>Estado</th>
                            <th class="text-end">Operación</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty prestamos}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        No hay registros de préstamos en el sistema.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="p" items="${prestamos}">
                                    <tr>
                                        <td class="fw-semibold text-secondary">#<c:out value="${p.id}" /></td>
                                        <td>
                                            <div class="fw-bold text-dark"><c:out value="${p.usuario.nombre}" /></div>
                                            <small class="text-muted"><c:out value="${p.usuario.rut}" /> &bull; <c:out value="${p.usuario.carrera}" /></small>
                                        </td>
                                        <td>
                                            <div class="fw-bold text-dark"><c:out value="${p.libro.titulo}" /></div>
                                            <small class="text-muted">ISBN: <c:out value="${p.libro.isbn}" /></small>
                                        </td>
                                        <td><c:out value="${p.fechaPrestamo}" /></td>
                                        <td><span class="fw-bold text-dark"><c:out value="${p.fechaDevolucionEsperada}" /></span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty p.fechaDevolucionReal}">
                                                    <span class="text-success fw-semibold"><c:out value="${p.fechaDevolucionReal}" /></span>
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
                                        <td class="text-end">
                                            <c:choose>
                                                <c:when test="${p.estado != 'DEVUELTO'}">
                                                    <button type="button" class="btn btn-sm btn-success shadow-sm" 
                                                            data-bs-toggle="modal" data-bs-target="#modalDevolucion"
                                                            onclick="prepararDevolucion('${p.id}', '${p.libro.titulo}', '${p.usuario.nombre}')">
                                                        <i class="bi bi-arrow-return-left me-1"></i> Registrar Devolución
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted small"><i class="bi bi-check-circle text-success me-1"></i> Finalizado</span>
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
    </main>

    <!-- Modal de Registro de Devolución -->
    <div class="modal fade" id="modalDevolucion" tabindex="-1" aria-labelledby="modalDevolucionLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <form action="${pageContext.request.contextPath}/prestamos" method="POST">
                    <input type="hidden" name="accion" value="devolver">
                    <input type="hidden" name="idPrestamo" id="modalIdPrestamo">

                    <div class="modal-header bg-success text-white rounded-top-4">
                        <h5 class="modal-title fw-bold" id="modalDevolucionLabel">
                            <i class="bi bi-box-arrow-down me-2"></i> Confirmar Devolución de Libro
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body p-4">
                        <p class="mb-2">Vas a registrar el reintegro de este ejemplar al inventario activo de la biblioteca.</p>
                        
                        <div class="card bg-light border-0 p-3 mb-3">
                            <div class="small text-muted fw-bold">Libro:</div>
                            <div class="fw-bold text-dark" id="modalDevTitulo"></div>
                            <div class="small text-muted fw-bold mt-2">Estudiante:</div>
                            <div class="text-secondary" id="modalDevAlumno"></div>
                        </div>

                        <div class="mb-3">
                            <label for="observacionesDevolucion" class="form-label small fw-bold text-secondary">
                                Observaciones de Recepción / Estado del Libro:
                            </label>
                            <input type="text" name="observacionesDevolucion" id="observacionesDevolucion" 
                                   class="form-control" value="Ejemplar devuelto en buenas condiciones en mesón de atención">
                        </div>
                    </div>

                    <div class="modal-footer bg-light rounded-bottom-4">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success fw-bold shadow-sm">
                            <i class="bi bi-check2-circle me-1"></i> Confirmar Recepción
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function prepararDevolucion(id, titulo, alumno) {
            document.getElementById('modalIdPrestamo').value = id;
            document.getElementById('modalDevTitulo').innerText = titulo;
            document.getElementById('modalDevAlumno').innerText = alumno;
        }
    </script>

    <!-- Pie de Página -->
    <jsp:include page="/includes/footer.jsp" />
</body>
</html>
