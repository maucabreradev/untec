<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar navbar-expand-lg untec-navbar py-2 sticky-top">
    <div class="container">
        <!-- Logo y Marca UNTEC -->
        <a class="navbar-brand untec-brand d-flex align-items-center" href="${pageContext.request.contextPath}/dashboard">
            <i class="bi bi-book-half me-2 fs-3 text-info"></i>
            <span>UNTEC</span>&nbsp;Biblioteca
        </a>

        <!-- Botón Hamburguesa Responsive -->
        <button class="navbar-toggler border-0 text-white" type="button" data-bs-toggle="collapse" 
                data-bs-target="#navbarContenido" aria-controls="navbarContenido" aria-expanded="false" 
                aria-label="Toggle navigation">
            <i class="bi bi-list fs-2"></i>
        </button>

        <div class="collapse navbar-collapse" id="navbarContenido">
            <c:if test="${not empty sessionScope.usuarioLogueado}">
                <!-- Menú Principal según Rol -->
                <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-3">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                            <i class="bi bi-speedometer2 me-1"></i> Panel de Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/libros">
                            <i class="bi bi-grid-3x3-gap me-1"></i> Catálogo de Libros
                        </a>
                    </li>

                    <c:choose>
                        <%-- Opciones de Administrador / Bibliotecario --%>
                        <c:when test="${sessionScope.usuarioLogueado.rol == 'ADMIN'}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/prestamos?accion=gestionar">
                                    <i class="bi bi-arrow-left-right me-1"></i> Control de Préstamos
                                </a>
                            </li>
                        </c:when>

                        <%-- Opciones de Estudiante --%>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/prestamos?accion=mis-prestamos">
                                    <i class="bi bi-journal-bookmark me-1"></i> Mis Préstamos
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>

                <!-- Sección de Usuario y Cierre de Sesión -->
                <div class="d-flex align-items-center mt-3 mt-lg-0">
                    <div class="text-white me-3 text-end d-none d-md-block">
                        <div class="fw-bold small lh-1 mb-1">
                            <c:out value="${sessionScope.usuarioLogueado.nombre}" />
                        </div>
                        <span class="badge ${sessionScope.usuarioLogueado.rol == 'ADMIN' ? 'bg-warning text-dark' : 'bg-info text-dark'} small" style="font-size: 0.72rem;">
                            <c:out value="${sessionScope.usuarioLogueado.rol}" />
                        </span>
                    </div>

                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm px-3 rounded-pill" title="Cerrar Sesión">
                        <i class="bi bi-box-arrow-right me-1"></i> Salir
                    </a>
                </div>
            </c:if>
        </div>
    </div>
</nav>
