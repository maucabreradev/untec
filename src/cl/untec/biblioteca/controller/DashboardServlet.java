package cl.untec.biblioteca.controller;

import cl.untec.biblioteca.dao.LibroDAO;
import cl.untec.biblioteca.dao.PrestamoDAO;
import cl.untec.biblioteca.dao.UsuarioDAO;
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
 * Controlador Servlet que carga las métricas, accesos rápidos y panel principal según el rol.
 */
@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private LibroDAO libroDAO;
    private PrestamoDAO prestamoDAO;
    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException {
        this.libroDAO = new LibroDAO();
        this.prestamoDAO = new PrestamoDAO();
        this.usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (usuario.isAdmin()) {
            // Métricas para Bibliotecario / Administrador
            int totalTitulos = libroDAO.contarTotalTitulos();
            int ejemplaresDisponibles = libroDAO.contarEjemplaresDisponibles();
            int prestamosActivos = prestamoDAO.contarPrestamosActivos();
            int totalEstudiantes = usuarioDAO.contarTotalEstudiantes();
            List<Prestamo> prestamosRecientes = prestamoDAO.listarTodos();
            if (prestamosRecientes.size() > 5) {
                prestamosRecientes = prestamosRecientes.subList(0, 5);
            }

            request.setAttribute("totalTitulos", totalTitulos);
            request.setAttribute("ejemplaresDisponibles", ejemplaresDisponibles);
            request.setAttribute("prestamosActivos", prestamosActivos);
            request.setAttribute("totalEstudiantes", totalEstudiantes);
            request.setAttribute("prestamosRecientes", prestamosRecientes);

        } else {
            // Métricas para Estudiante
            List<Prestamo> misPrestamos = prestamoDAO.listarPorUsuario(usuario.getId());
            long activosCount = misPrestamos.stream().filter(p -> "ACTIVO".equalsIgnoreCase(p.getEstado()) || "VENCIDO".equalsIgnoreCase(p.getEstado())).count();
            long devueltosCount = misPrestamos.stream().filter(p -> "DEVUELTO".equalsIgnoreCase(p.getEstado())).count();
            int librosDisponibles = libroDAO.contarEjemplaresDisponibles();

            request.setAttribute("misPrestamosActivos", activosCount);
            request.setAttribute("misPrestamosDevueltos", devueltosCount);
            request.setAttribute("librosDisponiblesCatalogo", librosDisponibles);
            request.setAttribute("ultimosPrestamos", misPrestamos.size() > 4 ? misPrestamos.subList(0, 4) : misPrestamos);
        }

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
