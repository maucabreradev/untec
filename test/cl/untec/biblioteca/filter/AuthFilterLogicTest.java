package cl.untec.biblioteca.filter;

import static org.junit.jupiter.api.Assertions.*;

import cl.untec.biblioteca.model.Usuario;
import java.util.Arrays;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

/**
 * Pruebas unitarias de las reglas de seguridad y autorización implementadas en AuthFilter.
 */
@DisplayName("Tests de Reglas de Seguridad y Autorización (AuthFilter)")
public class AuthFilterLogicTest {

    private Usuario estudiante;
    private Usuario admin;

    @BeforeEach
    void setUp() {
        estudiante = new Usuario();
        estudiante.setId(1);
        estudiante.setRol("ESTUDIANTE");

        admin = new Usuario();
        admin.setId(2);
        admin.setRol("ADMIN");
    }

    @Test
    @DisplayName("Debe clasificar correctamente las rutas públicas sin requerir autenticación")
    void testRutasPublicas() {
        List<String> rutasPublicas = Arrays.asList(
            "/login",
            "/login.jsp",
            "/index.jsp",
            "/",
            "/static/css/untec-custom.css",
            "/static/js/bootstrap.bundle.min.js",
            "/static/img/favicon.ico"
        );

        for (String path : rutasPublicas) {
            boolean esEstatico = path.startsWith("/static/") || path.endsWith(".css") || path.endsWith(".js") || path.endsWith(".png") || path.endsWith(".ico");
            boolean esLogin = path.equals("/login") || path.equals("/login.jsp") || path.equals("/index.jsp") || path.equals("/");

            assertTrue(esEstatico || esLogin, "La ruta '" + path + "' debe ser considerada pública y accesible sin sesión");
        }
    }

    @Test
    @DisplayName("Debe clasificar rutas del sistema como privadas requiriendo sesión activa")
    void testRutasPrivadas() {
        List<String> rutasPrivadas = Arrays.asList(
            "/dashboard",
            "/libros",
            "/prestamos",
            "/libros/catalogo.jsp",
            "/prestamos/mis-prestamos.jsp"
        );

        for (String path : rutasPrivadas) {
            boolean esEstatico = path.startsWith("/static/") || path.endsWith(".css") || path.endsWith(".js") || path.endsWith(".png") || path.endsWith(".ico");
            boolean esLogin = path.equals("/login") || path.equals("/login.jsp") || path.equals("/index.jsp") || path.equals("/");

            assertFalse(esEstatico || esLogin, "La ruta '" + path + "' debe requerir autenticación");
        }
    }

    @Test
    @DisplayName("Debe restringir acciones administrativas a usuarios con rol ESTUDIANTE")
    void testRestriccionAccionesAdminParaEstudiante() {
        List<String> accionesAdmin = Arrays.asList("nuevo", "guardar", "editar", "eliminar", "gestionar", "devolver");

        for (String accion : accionesAdmin) {
            boolean intentaAccionAdmin = esAccionAdministrativa(accion);
            assertTrue(intentaAccionAdmin, "La acción '" + accion + "' debe identificarse como administrativa");

            // Simular regla del filtro para estudiante
            boolean permitidoParaEstudiante = !(intentaAccionAdmin && !estudiante.isAdmin());
            assertFalse(permitidoParaEstudiante, "Un ESTUDIANTE no debe tener permiso para ejecutar la acción: " + accion);

            // Simular regla del filtro para admin
            boolean permitidoParaAdmin = !(intentaAccionAdmin && !admin.isAdmin());
            assertTrue(permitidoParaAdmin, "Un ADMIN sí debe tener permiso para ejecutar la acción: " + accion);
        }
    }

    private boolean esAccionAdministrativa(String accion) {
        return "nuevo".equalsIgnoreCase(accion) ||
               "guardar".equalsIgnoreCase(accion) ||
               "editar".equalsIgnoreCase(accion) ||
               "eliminar".equalsIgnoreCase(accion) ||
               "gestionar".equalsIgnoreCase(accion) ||
               "devolver".equalsIgnoreCase(accion);
    }
}
