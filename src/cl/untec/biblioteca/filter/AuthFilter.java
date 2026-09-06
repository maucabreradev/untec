package cl.untec.biblioteca.filter;

import cl.untec.biblioteca.model.Usuario;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Filtro de seguridad que intercepta peticiones a rutas protegidas.
 * Verifica sesión activa y rol de usuario (ESTUDIANTE vs ADMIN).
 */
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inicialización del filtro
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Desactivar caché en el navegador para páginas protegidas (evita volver atrás post-logout)
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        String contextPath = req.getContextPath();
        String uri = req.getRequestURI();
        String path = uri.substring(contextPath.length());

        // Recursos públicos permitidos sin autenticación
        boolean esEstatico = path.startsWith("/static/") || path.endsWith(".css") || path.endsWith(".js") || path.endsWith(".png") || path.endsWith(".ico");
        boolean esLogin = path.equals("/login") || path.equals("/login.jsp") || path.equals("/index.jsp") || path.equals("/");

        if (esEstatico || esLogin) {
            chain.doFilter(request, response);
            return;
        }

        // Verificar sesión activa
        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (usuario == null) {
            // Usuario no autenticado: redirigir al login
            req.getSession(true).setAttribute("mensajeError", "Debes iniciar sesión para acceder a este recurso.");
            res.sendRedirect(contextPath + "/login");
            return;
        }

        // Control de autorización por roles para acciones administrativas
        String accion = req.getParameter("accion");
        boolean intentaAccionAdmin = "nuevo".equalsIgnoreCase(accion) ||
                                     "guardar".equalsIgnoreCase(accion) ||
                                     "editar".equalsIgnoreCase(accion) ||
                                     "eliminar".equalsIgnoreCase(accion) ||
                                     "gestionar".equalsIgnoreCase(accion) ||
                                     "devolver".equalsIgnoreCase(accion);

        boolean rutaAdmin = path.contains("admin") || path.contains("gestion");

        if ((intentaAccionAdmin || rutaAdmin) && !usuario.isAdmin()) {
            // Estudiante intentando acceder a funciones administrativas
            session.setAttribute("mensajeError", "Acceso denegado: no tienes permisos de Administrador para esta acción.");
            res.sendRedirect(contextPath + "/dashboard");
            return;
        }

        // Continuar con la petición si todo es correcto
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Liberación de recursos del filtro
    }
}
