package cl.untec.biblioteca.dao;

import static org.junit.jupiter.api.Assertions.*;

import java.io.InputStream;
import java.util.Properties;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

/**
 * Pruebas unitarias para el Patrón Singleton de Conexion y carga de db.properties.
 */
@DisplayName("Tests del Patrón Singleton de Conexión y db.properties")
public class ConexionTest {

    @Test
    @DisplayName("Debe garantizar una única instancia global en memoria (Patrón Singleton)")
    void testPatronSingleton() {
        Conexion c1 = Conexion.getInstancia();
        Conexion c2 = Conexion.getInstancia();

        assertNotNull(c1, "La instancia 1 de Conexion no debe ser nula");
        assertNotNull(c2, "La instancia 2 de Conexion no debe ser nula");
        assertSame(c1, c2, "Ambas referencias deben apuntar exactamente al mismo objeto en memoria");
    }

    @Test
    @DisplayName("Debe existir y ser legible el archivo db.properties en el classpath")
    void testLecturaDbProperties() throws Exception {
        try (InputStream is = getClass().getClassLoader().getResourceAsStream("db.properties")) {
            assertNotNull(is, "El archivo db.properties debe existir en la raíz de src / classpath");

            Properties props = new Properties();
            props.load(is);

            assertTrue(props.containsKey("db.driver"), "Debe contener la propiedad 'db.driver'");
            assertTrue(props.containsKey("db.url"), "Debe contener la propiedad 'db.url'");
            assertTrue(props.containsKey("db.user"), "Debe contener la propiedad 'db.user'");

            assertEquals("com.mysql.cj.jdbc.Driver", props.getProperty("db.driver"), "El driver debe ser el conector oficial de MySQL");
            assertTrue(props.getProperty("db.url").contains("untec_biblioteca"), "La URL debe apuntar a la base de datos untec_biblioteca");
        }
    }

    @Test
    @DisplayName("Método utilitario cerrarRecursos() debe manejar nulos de forma segura")
    void testCerrarRecursosSeguro() {
        assertDoesNotThrow(() -> {
            Conexion.cerrarRecursos((AutoCloseable) null, (AutoCloseable) null);
        }, "cerrarRecursos() no debe arrojar NullPointerException ante argumentos nulos");
    }
}
