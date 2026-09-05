package cl.untec.biblioteca.controller;

import cl.untec.biblioteca.dao.UsuarioDAO;
import cl.untec.biblioteca.model.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Controlador Servlet para gestión de autenticación, inicio de sesión y cierre de sesión.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login", "/logout"})
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException {
        this.usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        // Procesar Logout
        if ("/logout".equals(path)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("mensajeExito", "Has cerrado sesión correctamente. ¡Hasta pronto!");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Si ya está autenticado, redirigir directo al dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuarioLogueado") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Mostrar formulario de login
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Por favor completa todos los campos.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        Usuario usuario = usuarioDAO.autenticar(email, password);

        if (usuario != null) {
            // Iniciar sesión exitosa
            HttpSession session = request.getSession(true);
            session.setAttribute("usuarioLogueado", usuario);
            session.setAttribute("mensajeExito", "¡Bienvenido/a, " + usuario.getNombre() + "!");
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            // Credenciales inválidas
            request.setAttribute("emailIngresado", email);
            request.setAttribute("error", "Credenciales incorrectas o usuario inactivo. Verifica tu correo y contraseña.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
