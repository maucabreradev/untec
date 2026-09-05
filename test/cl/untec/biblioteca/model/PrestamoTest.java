package cl.untec.biblioteca.model;

import static org.junit.jupiter.api.Assertions.*;

import java.sql.Date;
import java.time.LocalDate;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

/**
 * Pruebas unitarias para la entidad Prestamo, cálculo de plazos y control de vencimiento.
 */
@DisplayName("Tests de la Entidad Préstamo y Vencimientos")
public class PrestamoTest {

    @Test
    @DisplayName("Debe calcular fecha límite de 7 días por defecto en solicitud rápida")
    void testCalculoFechaPorDefecto() {
        Prestamo p = new Prestamo(10, 20, 7, "Préstamo de prueba regular");

        LocalDate hoy = LocalDate.now();
        LocalDate esperado = hoy.plusDays(7);

        assertEquals(Date.valueOf(esperado), p.getFechaDevolucionEsperada(), "El plazo por defecto debe ser hoy + 7 días");
        assertEquals("ACTIVO", p.getEstado());
        assertTrue(p.isActivo());
        assertFalse(p.isDevuelto());
        assertFalse(p.isVencido(), "Un préstamo recién solicitado no debe figurar como vencido");
    }

    @Test
    @DisplayName("Debe admitir plazos personalizados de 14 y 21 días")
    void testPlazosPersonalizados() {
        Prestamo p14 = new Prestamo(10, 20, 14, "Proyecto de 2 semanas");
        LocalDate fechaEsperada14 = LocalDate.now().plusDays(14);
        assertEquals(Date.valueOf(fechaEsperada14), p14.getFechaDevolucionEsperada());

        Prestamo p21 = new Prestamo(10, 20, 21, "Tesis de 3 semanas");
        LocalDate fechaEsperada21 = LocalDate.now().plusDays(21);
        assertEquals(Date.valueOf(fechaEsperada21), p21.getFechaDevolucionEsperada());
    }

    @Test
    @DisplayName("Debe detectar como vencido un préstamo activo cuya fecha límite ya pasó")
    void testDeteccionPrestamoVencido() {
        Prestamo p = new Prestamo();
        p.setId(1);
        p.setIdUsuario(2);
        p.setIdLibro(5);
        p.setEstado("ACTIVO");

        // Fijar fecha límite en el pasado (hace 3 días)
        LocalDate fechaPasada = LocalDate.now().minusDays(3);
        p.setFechaPrestamo(Date.valueOf(fechaPasada.minusDays(7)));
        p.setFechaDevolucionEsperada(Date.valueOf(fechaPasada));

        assertTrue(p.isVencido(), "El préstamo cuya fecha límite ya expiró debe reportar isVencido() true");
    }

    @Test
    @DisplayName("Un préstamo DEVUELTO nunca debe reportar isVencido() true aunque la fecha esperada haya pasado")
    void testPrestamoDevueltoNoEsVencido() {
        Prestamo p = new Prestamo();
        p.setId(2);
        p.setIdUsuario(2);
        p.setIdLibro(5);
        p.setEstado("DEVUELTO");

        // Fecha esperada en el pasado
        LocalDate fechaPasada = LocalDate.now().minusDays(10);
        p.setFechaDevolucionEsperada(Date.valueOf(fechaPasada));
        p.setFechaDevolucionReal(Date.valueOf(LocalDate.now().minusDays(9)));

        assertTrue(p.isDevuelto());
        assertFalse(p.isActivo());
        assertFalse(p.isVencido(), "Un libro devuelto nunca debe considerarse moroso o vencido");
    }

    @Test
    @DisplayName("Debe mantener relaciones con entidades Usuario y Libro para capas de vista")
    void testRelacionesModelo() {
        Prestamo p = new Prestamo(1, 2, 7, "Prueba");

        Usuario u = new Usuario();
        u.setNombre("Estudiante Prueba");
        p.setUsuario(u);

        Libro l = new Libro();
        l.setTitulo("Libro de Prueba");
        p.setLibro(l);

        assertNotNull(p.getUsuario());
        assertEquals("Estudiante Prueba", p.getUsuario().getNombre());
        assertNotNull(p.getLibro());
        assertEquals("Libro de Prueba", p.getLibro().getTitulo());
    }
}
