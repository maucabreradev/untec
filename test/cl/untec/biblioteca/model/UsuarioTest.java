package cl.untec.biblioteca.model;

import static org.junit.jupiter.api.Assertions.*;

import java.sql.Timestamp;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

/**
 * Pruebas unitarias para la entidad Usuario y control de roles institucionales.
 */
@DisplayName("Tests de la Entidad Usuario")
public class UsuarioTest {

    private Usuario usuarioEstudiante;
    private Usuario usuarioAdmin;

    @BeforeEach
    void setUp() {
        usuarioEstudiante = new Usuario(
            1,
            "12.345.678-9",
            "Carlos Alumno",
            "carlos@untec.edu",
            "pass123",
            "ESTUDIANTE",
            "Ingeniería Civil Informática",
            "+56 9 1234 5678",
            true,
            new Timestamp(System.currentTimeMillis())
        );

        usuarioAdmin = new Usuario(
            2,
            "11.111.111-1",
            "Admin Bibliotecario",
            "admin@untec.edu",
            "admin123",
            "ADMIN",
            "Gestión Bibliotecaria",
            "+56 9 8765 4321",
            true,
            new Timestamp(System.currentTimeMillis())
        );
    }

    @Test
    @DisplayName("Debe instanciar con valores por defecto correctos (rol ESTUDIANTE y activo true)")
    void testConstructorPorDefecto() {
        Usuario u = new Usuario();
        assertEquals("ESTUDIANTE", u.getRol(), "El rol por defecto debe ser ESTUDIANTE");
        assertTrue(u.isActivo(), "El usuario debe crearse en estado activo");
        assertFalse(u.isAdmin(), "Un usuario por defecto no debe tener privilegios de administrador");
    }

    @Test
    @DisplayName("Debe verificar correctamente los privilegios de administrador con isAdmin()")
    void testIsAdmin() {
        assertTrue(usuarioAdmin.isAdmin(), "usuarioAdmin debe responder true a isAdmin()");
        assertFalse(usuarioEstudiante.isAdmin(), "usuarioEstudiante debe responder false a isAdmin()");

        // Probar insensibilidad a mayúsculas/minúsculas
        usuarioEstudiante.setRol("admin");
        assertTrue(usuarioEstudiante.isAdmin(), "El rol 'admin' en minúsculas debe ser reconocido como administrador");

        usuarioEstudiante.setRol("Admin");
        assertTrue(usuarioEstudiante.isAdmin(), "El rol 'Admin' con mayúscula inicial debe ser reconocido");
    }

    @Test
    @DisplayName("Debe actualizar y retornar atributos correctamente mediante getters y setters")
    void testGettersYSetters() {
        usuarioEstudiante.setNombre("Carlos Modificado");
        assertEquals("Carlos Modificado", usuarioEstudiante.getNombre());

        usuarioEstudiante.setCarrera("Ingeniería Industrial");
        assertEquals("Ingeniería Industrial", usuarioEstudiante.getCarrera());

        usuarioEstudiante.setActivo(false);
        assertFalse(usuarioEstudiante.isActivo(), "Debe reflejar la desactivación del usuario");
    }

    @Test
    @DisplayName("Debe crear usuario correctamente con constructor de registro rápido")
    void testConstructorRegistroRapido() {
        Usuario nuevo = new Usuario(
            "18.765.432-1",
            "Lucía Soto",
            "lucia@untec.edu",
            "clave456",
            "ESTUDIANTE",
            "Medicina",
            "+56 9 9999 8888"
        );

        assertEquals("18.765.432-1", nuevo.getRut());
        assertEquals("Lucía Soto", nuevo.getNombre());
        assertEquals("Medicina", nuevo.getCarrera());
        assertTrue(nuevo.isActivo());
    }
}
