<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:choose>
    <c:when test="${not empty sessionScope.usuarioLogueado}">
        <c:redirect url="/dashboard" />
    </c:when>
    <c:otherwise>
        <c:redirect url="/login" />
    </c:otherwise>
</c:choose>
