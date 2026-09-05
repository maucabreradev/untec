package cl.untec.biblioteca.controller;

import cl.untec.biblioteca.dao.LibroDAO;
import cl.untec.biblioteca.model.Libro;
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
 * Controlador Servlet para gestión del catálogo de libros (CRUD para Admin y Consulta para Estudiantes).
 */
@WebServlet(name = "LibroServlet", urlPatterns = {"/libros"})
public class LibroServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private LibroDAO libroDAO;

    @Override
    public void init() throws ServletException {
        this.libroDAO = new LibroDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        String accion = request.getParameter("accion");
        if (accion == null || accion.trim().isEmpty()) {
            accion = "listar";
        }

        switch (accion.toLowerCase()) {
            case "nuevo":
                mostrarFormularioNuevo(request, response);
                break;
            case "editar":
                mostrarFormularioEditar(request, response);
                break;
            case "eliminar":
                eliminarLibro(request, response);
                break;
            case "buscar":
                buscarLibros(request, response, usuario);
                break;
            case "listar":
            default:
                listarLibros(request, response, usuario);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if ("guardar".equalsIgnoreCase(accion)) {
            guardarLibro(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void listarLibros(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {
        
        List<Libro> libros = libroDAO.listarTodos();
        List<String> categorias = libroDAO.listarCategorias();
        request.setAttribute("libros", libros);
        request.setAttribute("categorias", categorias);

        if (usuario != null && usuario.isAdmin()) {
            request.getRequestDispatcher("/libros/admin-libros.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/libros/catalogo.jsp").forward(request, response);
        }
    }

    private void buscarLibros(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {
        
        String q = request.getParameter("q");
        String categoria = request.getParameter("categoria");

        List<Libro> libros = libroDAO.buscar(q, categoria);
        List<String> categorias = libroDAO.listarCategorias();

        request.setAttribute("libros", libros);
        request.setAttribute("categorias", categorias);
        request.setAttribute("filtroTexto", q);
        request.setAttribute("filtroCategoria", categoria);

        if (usuario != null && usuario.isAdmin()) {
            request.getRequestDispatcher("/libros/admin-libros.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/libros/catalogo.jsp").forward(request, response);
        }
    }

    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setAttribute("libro", new Libro());
        request.setAttribute("categorias", libroDAO.listarCategorias());
        request.setAttribute("esNuevo", true);
        request.getRequestDispatcher("/libros/form-libro.jsp").forward(request, response);
    }

    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Libro libro = libroDAO.obtenerPorId(id);

            if (libro != null) {
                request.setAttribute("libro", libro);
                request.setAttribute("categorias", libroDAO.listarCategorias());
                request.setAttribute("esNuevo", false);
                request.getRequestDispatcher("/libros/form-libro.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("mensajeError", "El libro solicitado no existe.");
                response.sendRedirect(request.getContextPath() + "/libros");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/libros");
        }
    }

    private void guardarLibro(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        HttpSession session = request.getSession();
        try {
            String strId = request.getParameter("id");
            String isbn = request.getParameter("isbn");
            String titulo = request.getParameter("titulo");
            String autor = request.getParameter("autor");
            String editorial = request.getParameter("editorial");
            int anio = Integer.parseInt(request.getParameter("anioPublicacion"));
            String categoria = request.getParameter("categoria");
            String descripcion = request.getParameter("descripcion");
            String portadaUrl = request.getParameter("portadaUrl");
            int stockTotal = Integer.parseInt(request.getParameter("stockTotal"));
            int stockDisponible = Integer.parseInt(request.getParameter("stockDisponible"));
            String ubicacion = request.getParameter("ubicacion");

            int id = (strId != null && !strId.trim().isEmpty()) ? Integer.parseInt(strId) : 0;

            if (stockDisponible > stockTotal) {
                stockDisponible = stockTotal;
            }

            Libro l = new Libro(isbn, titulo, autor, editorial, anio, categoria, descripcion, portadaUrl, stockTotal, stockDisponible, ubicacion);
            l.setId(id);

            boolean resultado;
            if (id > 0) {
                resultado = libroDAO.actualizar(l);
                if (resultado) {
                    session.setAttribute("mensajeExito", "Libro '" + titulo + "' actualizado exitosamente.");
                } else {
                    session.setAttribute("mensajeError", "No se pudo actualizar el libro.");
                }
            } else {
                resultado = libroDAO.insertar(l);
                if (resultado) {
                    session.setAttribute("mensajeExito", "Libro '" + titulo + "' registrado exitosamente en el catálogo.");
                } else {
                    session.setAttribute("mensajeError", "Error al crear libro (es posible que el ISBN ya exista).");
                }
            }
        } catch (Exception e) {
            session.setAttribute("mensajeError", "Error procesando el formulario: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/libros");
    }

    private void eliminarLibro(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        HttpSession session = request.getSession();
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean exito = libroDAO.eliminar(id);
            if (exito) {
                session.setAttribute("mensajeExito", "Libro eliminado correctamente del catálogo.");
            } else {
                session.setAttribute("mensajeError", "No se puede eliminar el libro porque tiene préstamos asociados en el historial.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("mensajeError", "Identificador de libro inválido.");
        }

        response.sendRedirect(request.getContextPath() + "/libros");
    }
}
