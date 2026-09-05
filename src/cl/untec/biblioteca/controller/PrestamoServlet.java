package cl.untec.biblioteca.controller;

import cl.untec.biblioteca.dao.PrestamoDAO;
import cl.untec.biblioteca.model.Prestamo;
import cl.untec.biblioteca.model.Usuario;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Controlador Servlet para gestión de solicitudes de préstamos y registro de devoluciones.
 */
@WebServlet(name = "PrestamoServlet", urlPatterns = {"/prestamos"})
public class PrestamoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private PrestamoDAO prestamoDAO;

    @Override
    public void init() throws ServletException {
        this.prestamoDAO = new PrestamoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null || accion.trim().isEmpty()) {
            accion = usuario.isAdmin() ? "gestionar" : "mis-prestamos";
        }

        if ("gestionar".equalsIgnoreCase(accion)) {
            if (!usuario.isAdmin()) {
                session.setAttribute("mensajeError", "Solo el personal de biblioteca puede gestionar préstamos globales.");
                response.sendRedirect(request.getContextPath() + "/prestamos?accion=mis-prestamos");
                return;
            }
            List<Prestamo> prestamos = prestamoDAO.listarTodos();
            request.setAttribute("prestamos", prestamos);
            request.getRequestDispatcher("/prestamos/gestion-prestamos.jsp").forward(request, response);

        } else if ("mis-prestamos".equalsIgnoreCase(accion)) {
            List<Prestamo> misPrestamos = prestamoDAO.listarPorUsuario(usuario.getId());
            request.setAttribute("misPrestamos", misPrestamos);
            request.getRequestDispatcher("/prestamos/mis-prestamos.jsp").forward(request, response);

        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String accion = request.getParameter("accion");

        if ("solicitar".equalsIgnoreCase(accion)) {
            solicitarPrestamo(request, response, usuario, session);
        } else if ("devolver".equalsIgnoreCase(accion)) {
            devolverPrestamo(request, response, usuario, session);
        } else {
            doGet(request, response);
        }
    }

    private void solicitarPrestamo(HttpServletRequest request, HttpServletResponse response, 
                                   Usuario usuario, HttpSession session) throws IOException {
        try {
            int idLibro = Integer.parseInt(request.getParameter("idLibro"));
            int dias = 7;
            String strDias = request.getParameter("dias");
            if (strDias != null && !strDias.trim().isEmpty()) {
                dias = Integer.parseInt(strDias.trim());
            }
            String observaciones = request.getParameter("observaciones");
            if (observaciones == null || observaciones.trim().isEmpty()) {
                observaciones = "Solicitado online por estudiante: " + usuario.getNombre();
            }

            Prestamo prestamo = new Prestamo(usuario.getId(), idLibro, dias, observaciones);
            boolean exito = prestamoDAO.solicitarPrestamo(prestamo);

            if (exito) {
                session.setAttribute("mensajeExito", "¡Préstamo solicitado con éxito! Fecha límite de devolución: " + prestamo.getFechaDevolucionEsperada() + ".");
            } else {
                session.setAttribute("mensajeError", "No se pudo realizar el préstamo. Es probable que no queden ejemplares disponibles en este momento.");
            }
        } catch (Exception e) {
            session.setAttribute("mensajeError", "Error al procesar la solicitud de préstamo: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/prestamos?accion=mis-prestamos");
    }

    private void devolverPrestamo(HttpServletRequest request, HttpServletResponse response, 
                                  Usuario usuario, HttpSession session) throws IOException {
        if (!usuario.isAdmin()) {
            session.setAttribute("mensajeError", "Solo los administradores pueden registrar devoluciones.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            int idPrestamo = Integer.parseInt(request.getParameter("idPrestamo"));
            String observaciones = request.getParameter("observacionesDevolucion");

            boolean exito = prestamoDAO.registrarDevolucion(idPrestamo, observaciones);
            if (exito) {
                session.setAttribute("mensajeExito", "Devolución registrada exitosamente. El ejemplar ha sido devuelto al stock activo.");
            } else {
                session.setAttribute("mensajeError", "No se pudo registrar la devolución del préstamo.");
            }
        } catch (Exception e) {
            session.setAttribute("mensajeError", "Error al procesar la devolución: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/prestamos?accion=gestionar");
    }
}
