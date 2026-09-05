package cl.untec.biblioteca.model;

import static org.junit.jupiter.api.Assertions.*;

import java.sql.Timestamp;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

/**
 * Pruebas unitarias para la entidad Libro y control de disponibilidad de stock.
 */
@DisplayName("Tests de la Entidad Libro y Disponibilidad")
public class LibroTest {

    private Libro libroConStock;
    private Libro libroAgotado;

    @BeforeEach
    void setUp() {
        libroConStock = new Libro(
            1,
            "978-0132350884",
            "Clean Code",
            "Robert C. Martin",
            "Prentice Hall",
            2008,
            "Informática",
            "Guía de buenas prácticas",
            "",
            5,
            3,
            "Estantería B",
            new Timestamp(System.currentTimeMillis())
        );

        libroAgotado = new Libro(
            2,
            "978-0071809252",
            "Java Complete Reference",
            "Herbert Schildt",
            "McGraw-Hill",
            2018,
            "Programación",
            "Manual completo",
            "",
            4,
            0,
            "Estantería A",
            new Timestamp(System.currentTimeMillis())
        );
    }

    @Test
    @DisplayName("Debe responder isDisponible() true cuando stockDisponible > 0")
    void testLibroDisponible() {
        assertTrue(libroConStock.isDisponible(), "El libro con 3 ejemplares disponibles debe figurar disponible");
    }

    @Test
    @DisplayName("Debe responder isDisponible() false cuando stockDisponible == 0")
    void testLibroAgotado() {
        assertFalse(libroAgotado.isDisponible(), "El libro con 0 ejemplares disponibles no debe figurar disponible");
    }

    @Test
    @DisplayName("Constructor por defecto debe inicializar stockTotal y stockDisponible en 1")
    void testConstructorPorDefecto() {
        Libro l = new Libro();
        assertEquals(1, l.getStockTotal());
        assertEquals(1, l.getStockDisponible());
        assertTrue(l.isDisponible());
    }

    @Test
    @DisplayName("Constructor para nuevo libro sin ID debe inicializar atributos correctamente")
    void testConstructorNuevoLibro() {
        Libro nuevo = new Libro(
            "978-1234567890",
            "Estructuras de Datos",
            "Mark Allen Weiss",
            "Pearson",
            2013,
            "Informática",
            "Algoritmos y análisis",
            "",
            6,
            6,
            "Pabellón B - Estante 2"
        );

        assertEquals("978-1234567890", nuevo.getIsbn());
        assertEquals("Estructuras de Datos", nuevo.getTitulo());
        assertEquals(6, nuevo.getStockTotal());
        assertEquals(6, nuevo.getStockDisponible());
        assertTrue(nuevo.isDisponible());
    }

    @Test
    @DisplayName("Debe permitir modificar stock dinámicamente y reflejar cambio de disponibilidad")
    void testCambioDeStockDinamico() {
        assertTrue(libroConStock.isDisponible());

        // Simular que se prestan todos los ejemplares
        libroConStock.setStockDisponible(0);
        assertFalse(libroConStock.isDisponible(), "Al reducir stock a 0 debe pasar a no disponible");

        // Simular restitución de un ejemplar
        libroConStock.setStockDisponible(1);
        assertTrue(libroConStock.isDisponible(), "Al reponer 1 ejemplar debe volver a estar disponible");
    }
}
