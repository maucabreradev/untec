<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${esNuevo ? 'Nuevo Libro' : 'Editar Libro'}" /> &bull; Biblioteca Digital UNTEC</title>
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

        <div class="row justify-content-center">
            <div class="col-lg-9">
                <div class="card border-0 shadow-md rounded-4 overflow-hidden bg-white">
                    <div class="card-header bg-primary text-white p-4">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="fw-bold mb-1">
                                    <i class="bi <c:out value='${esNuevo ? "bi-plus-circle" : "bi-pencil-square"}' /> me-2"></i>
                                    <c:out value="${esNuevo ? 'Registrar Nuevo Libro en Catálogo' : 'Editar Información de Libro'}" />
                                </h4>
                                <p class="mb-0 text-white-50 small">Completa los datos bibliográficos e información de inventario.</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/libros" class="btn btn-sm btn-outline-light">
                                <i class="bi bi-arrow-left me-1"></i> Volver
                            </a>
                        </div>
                    </div>

                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/libros" method="POST" autocomplete="off">
                            <input type="hidden" name="accion" value="guardar">
                            <input type="hidden" name="id" value="<c:out value='${libro.id}' />">

                            <div class="row g-3">
                                <!-- ISBN y Título -->
                                <div class="col-md-4">
                                    <label for="isbn" class="form-label small fw-bold text-secondary">Código ISBN <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="isbn" name="isbn" required 
                                           placeholder="Ej: 978-0132350884" value="<c:out value='${libro.isbn}' />">
                                </div>

                                <div class="col-md-8">
                                    <label for="titulo" class="form-label small fw-bold text-secondary">Título del Libro <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="titulo" name="titulo" required 
                                           placeholder="Ej: Clean Code: A Handbook of Agile Software Craftsmanship" value="<c:out value='${libro.titulo}' />">
                                </div>

                                <!-- Autor y Editorial -->
                                <div class="col-md-6">
                                    <label for="autor" class="form-label small fw-bold text-secondary">Autor / Autores <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="autor" name="autor" required 
                                           placeholder="Ej: Robert C. Martin" value="<c:out value='${libro.autor}' />">
                                </div>

                                <div class="col-md-6">
                                    <label for="editorial" class="form-label small fw-bold text-secondary">Editorial</label>
                                    <input type="text" class="form-control" id="editorial" name="editorial" 
                                           placeholder="Ej: Prentice Hall" value="<c:out value='${libro.editorial}' />">
                                </div>

                                <!-- Categoría y Año -->
                                <div class="col-md-6">
                                    <label for="categoria" class="form-label small fw-bold text-secondary">Categoría / Área <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="categoria" name="categoria" required 
                                           list="categoriasList" placeholder="Ej: Informática, Matemáticas, Economía..." value="<c:out value='${libro.categoria}' />">
                                    <datalist id="categoriasList">
                                        <c:forEach var="cat" items="${categorias}">
                                            <option value="${cat}">
                                        </c:forEach>
                                    </datalist>
                                </div>

                                <div class="col-md-6">
                                    <label for="anioPublicacion" class="form-label small fw-bold text-secondary">Año de Publicación</label>
                                    <input type="number" class="form-control" id="anioPublicacion" name="anioPublicacion" min="1900" max="2099" 
                                           value="<c:out value='${libro.anioPublicacion > 0 ? libro.anioPublicacion : 2024}' />">
                                </div>

                                <!-- Stock Total y Stock Disponible -->
                                <div class="col-md-4">
                                    <label for="stockTotal" class="form-label small fw-bold text-secondary">Ejemplares Totales <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="stockTotal" name="stockTotal" min="1" required 
                                           value="<c:out value='${libro.stockTotal > 0 ? libro.stockTotal : 1}' />">
                                </div>

                                <div class="col-md-4">
                                    <label for="stockDisponible" class="form-label small fw-bold text-secondary">Ejemplares Disponibles <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="stockDisponible" name="stockDisponible" min="0" required 
                                           value="<c:out value='${libro.stockDisponible >= 0 ? libro.stockDisponible : 1}' />">
                                </div>

                                <div class="col-md-4">
                                    <label for="ubicacion" class="form-label small fw-bold text-secondary">Ubicación Física</label>
                                    <input type="text" class="form-control" id="ubicacion" name="ubicacion" 
                                           placeholder="Ej: Pabellón B - Estante 3" value="<c:out value='${libro.ubicacion}' />">
                                </div>

                                <!-- Portada URL -->
                                <div class="col-12">
                                    <label for="portadaUrl" class="form-label small fw-bold text-secondary">URL de Imagen de Portada (Opcional)</label>
                                    <input type="url" class="form-control" id="portadaUrl" name="portadaUrl" 
                                           placeholder="https://..." value="<c:out value='${libro.portadaUrl}' />">
                                </div>

                                <!-- Descripción / Resumen -->
                                <div class="col-12">
                                    <label for="descripcion" class="form-label small fw-bold text-secondary">Sinopsis / Descripción Bibliográfica</label>
                                    <textarea class="form-control" id="descripcion" name="descripcion" rows="3" 
                                              placeholder="Resumen del contenido y temas principales del libro..."><c:out value='${libro.descripcion}' /></textarea>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                                <a href="${pageContext.request.contextPath}/libros" class="btn btn-outline-secondary px-4">Cancelar</a>
                                <button type="submit" class="btn btn-primary px-4 fw-bold shadow-sm">
                                    <i class="bi bi-save me-1"></i> Guardar Libro
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Pie de Página -->
    <jsp:include page="/includes/footer.jsp" />
</body>
</html>
