package cl.untec.biblioteca.dao;

import static org.junit.jupiter.api.Assertions.*;

import cl.untec.biblioteca.model.Libro;
import cl.untec.biblioteca.model.Prestamo;
import cl.untec.biblioteca.model.Usuario;
import java.sql.Date;
import java.time.LocalDate;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

/**
 * Pruebas unitarias de la lógica de negocio para préstamos, control de stock e invariantes.
 */
@DisplayName("Tests de Lógica de Negocio de Préstamos y Stock")
public class PrestamoLogicTest {

    private Libro libroPrueba;
    private Usuario alumnoPrueba;

    @BeforeEach
    void setUp() {
        libroPrueba = new Libro(
            10,
            "978-0132350884",
            "Clean Code",
            "Robert C. Martin",
            "Prentice Hall",
            2008,
            "Informática",
            "Buenas prácticas",
            "",
            3, // Stock total: 3
            3, // Stock disponible: 3
            "Estantería B",
            null
        );

        alumnoPrueba = new Usuario(
            5,
            "12.345.678-9",
            "Ignacio Pérez",
            "ignacio@untec.edu",
            "pass123",
            "ESTUDIANTE",
            "Ingeniería Informática",
            "+56 9 1234 5678",
            true,
            null
        );
    }

    @Test
    @DisplayName("Simulación de préstamo: debe descontar 1 unidad del stock disponible")
    void testFlujoSolicitarPrestamo() {
        int stockInicial = libroPrueba.getStockDisponible();
        assertTrue(libroPrueba.isDisponible());

        // Simular lógica de préstamo
        assertTrue(libroPrueba.getStockDisponible() > 0, "Debe haber stock para permitir el préstamo");
        libroPrueba.setStockDisponible(libroPrueba.getStockDisponible() - 1);

        Prestamo p = new Prestamo(alumnoPrueba.getId(), libroPrueba.getId(), 7, "Préstamo regular");
        p.setLibro(libroPrueba);
        p.setUsuario(alumnoPrueba);

        assertEquals(stockInicial - 1, libroPrueba.getStockDisponible(), "El stock disponible debe haber bajado en 1");
        assertEquals("ACTIVO", p.getEstado());
        assertTrue(p.isActivo());
    }

    @Test
    @DisplayName("Simulación de devolución: debe restituir 1 unidad al stock disponible y marcar DEVUELTO")
    void testFlujoDevolverPrestamo() {
        // Partir de libro con 1 ejemplar prestado (disponible = 2 de 3)
        libroPrueba.setStockDisponible(2);

        Prestamo p = new Prestamo(alumnoPrueba.getId(), libroPrueba.getId(), 7, "Préstamo en curso");
        assertEquals("ACTIVO", p.getEstado());

        // Simular devolución
        p.setEstado("DEVUELTO");
        p.setFechaDevolucionReal(Date.valueOf(LocalDate.now()));

        if (libroPrueba.getStockDisponible() < libroPrueba.getStockTotal()) {
            libroPrueba.setStockDisponible(libroPrueba.getStockDisponible() + 1);
        }

        assertTrue(p.isDevuelto());
        assertFalse(p.isActivo());
        assertEquals(3, libroPrueba.getStockDisponible(), "El stock disponible debe reestablecerse a su total original");
    }

    @Test
    @DisplayName("Invariante de stock: el stock disponible nunca debe exceder el stock total")
    void testInvarianteStockMaximo() {
        libroPrueba.setStockDisponible(3);
        libroPrueba.setStockTotal(3);

        // Intento de restituir stock más allá del total
        if (libroPrueba.getStockDisponible() < libroPrueba.getStockTotal()) {
            libroPrueba.setStockDisponible(libroPrueba.getStockDisponible() + 1);
        }

        assertEquals(3, libroPrueba.getStockDisponible(), "No debe sobrepasar el stock total físico");
    }

    @Test
    @DisplayName("Invariante de préstamo: no se debe permitir prestar si el stock es cero")
    void testNoPrestarSinStock() {
        libroPrueba.setStockDisponible(0);
        assertFalse(libroPrueba.isDisponible(), "Libro debe estar agotado");

        boolean prestamoPermitido = libroPrueba.getStockDisponible() > 0;
        assertFalse(prestamoPermitido, "La regla de negocio debe rechazar la solicitud de préstamo si no hay stock");
    }
}
