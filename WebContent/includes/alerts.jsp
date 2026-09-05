<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Mensaje de Éxito Flash --%>
<c:if test="${not empty sessionScope.mensajeExito}">
    <div class="alert alert-success alert-dismissible fade show d-flex align-items-center mb-4 shadow-sm" role="alert">
        <i class="bi bi-check-circle-fill me-2 fs-5"></i>
        <div>
            <c:out value="${sessionScope.mensajeExito}" />
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
    </div>
    <c:remove var="mensajeExito" scope="session" />
</c:if>

<%-- Mensaje de Error Flash --%>
<c:if test="${not empty sessionScope.mensajeError}">
    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-4 shadow-sm" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
        <div>
            <c:out value="${sessionScope.mensajeError}" />
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
    </div>
    <c:remove var="mensajeError" scope="session" />
</c:if>

<%-- Mensaje de Error en Request Scope (ej. formulario de login) --%>
<c:if test="${not empty requestScope.error}">
    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-4 shadow-sm" role="alert">
        <i class="bi bi-exclamation-circle-fill me-2 fs-5"></i>
        <div>
            <c:out value="${requestScope.error}" />
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
    </div>
</c:if>
