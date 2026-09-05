package cl.untec.biblioteca.dao;

import cl.untec.biblioteca.model.Libro;
import cl.untec.biblioteca.model.Prestamo;
import cl.untec.biblioteca.model.Usuario;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Capa DAO para gestión transaccional de préstamos y devoluciones de libros.
 */
public class PrestamoDAO {

    private static final Logger LOGGER = Logger.getLogger(PrestamoDAO.class.getName());

    /**
     * Solicita y registra un nuevo préstamo dentro de una transacción ACID:
     * 1. Verifica disponibilidad de stock del libro (bloqueo FOR UPDATE).
     * 2. Descuenta 1 unidad de stock disponible.
     * 3. Registra el préstamo en estado ACTIVO.
     */
    public boolean solicitarPrestamo(Prestamo p) {
        Connection con = null;
        PreparedStatement psVerificar = null;
        PreparedStatement psDescontar = null;
        PreparedStatement psInsertar = null;
        ResultSet rsStock = null;

        try {
            con = Conexion.getInstancia().getConnection();
            con.setAutoCommit(false); // Iniciar transacción

            // 1. Verificar stock actual del libro
            String sqlStock = "SELECT stock_disponible FROM libros WHERE id = ? FOR UPDATE";
            psVerificar = con.prepareStatement(sqlStock);
            psVerificar.setInt(1, p.getIdLibro());
            rsStock = psVerificar.executeQuery();

            if (!rsStock.next()) {
                LOGGER.log(Level.WARNING, "El libro con ID {0} no existe.", p.getIdLibro());
                con.rollback();
                return false;
            }

            int stockDisp = rsStock.getInt("stock_disponible");
            if (stockDisp <= 0) {
                LOGGER.log(Level.WARNING, "No hay ejemplares disponibles para el libro con ID {0}.", p.getIdLibro());
                con.rollback();
                return false;
            }

            // 2. Descontar stock disponible
            String sqlDescontar = "UPDATE libros SET stock_disponible = stock_disponible - 1 WHERE id = ?";
            psDescontar = con.prepareStatement(sqlDescontar);
            psDescontar.setInt(1, p.getIdLibro());
            psDescontar.executeUpdate();

            // 3. Registrar el préstamo
            String sqlInsertar = "INSERT INTO prestamos (id_usuario, id_libro, fecha_prestamo, "
                               + "fecha_devolucion_esperada, estado, observaciones) VALUES (?, ?, ?, ?, ?, ?)";
            psInsertar = con.prepareStatement(sqlInsertar, Statement.RETURN_GENERATED_KEYS);
            psInsertar.setInt(1, p.getIdUsuario());
            psInsertar.setInt(2, p.getIdLibro());
            psInsertar.setDate(3, p.getFechaPrestamo() != null ? p.getFechaPrestamo() : Date.valueOf(LocalDate.now()));
            psInsertar.setDate(4, p.getFechaDevolucionEsperada() != null ? p.getFechaDevolucionEsperada() : Date.valueOf(LocalDate.now().plusDays(7)));
            psInsertar.setString(5, "ACTIVO");
            psInsertar.setString(6, p.getObservaciones() != null ? p.getObservaciones() : "Préstamo regular");
            
            int filas = psInsertar.executeUpdate();
            if (filas > 0) {
                ResultSet rsGen = psInsertar.getGeneratedKeys();
                if (rsGen.next()) {
                    p.setId(rsGen.getInt(1));
                }
                con.commit(); // Confirmar transacción
                return true;
            } else {
                con.rollback();
                return false;
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error transaccional al solicitar prestamo: " + e.getMessage(), e);
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error en rollback: " + ex.getMessage(), ex);
                }
            }
            return false;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                } catch (SQLException ex) {
                    LOGGER.log(Level.FINE, "Error reestableciendo autocommit", ex);
                }
            }
            Conexion.cerrarRecursos(rsStock, psVerificar, psDescontar, psInsertar, con);
        }
    }

    /**
     * Registra la devolución de un libro dentro de una transacción ACID:
     * 1. Cambia estado del préstamo a DEVUELTO y fija fecha_devolucion_real.
     * 2. Restituye 1 unidad al stock disponible del libro.
     */
    public boolean registrarDevolucion(int idPrestamo, String observacionesExtra) {
        Connection con = null;
        PreparedStatement psBuscar = null;
        PreparedStatement psDevolver = null;
        PreparedStatement psRestituir = null;
        ResultSet rsPrestamo = null;

        try {
            con = Conexion.getInstancia().getConnection();
            con.setAutoCommit(false); // Iniciar transacción

            // 1. Obtener id del libro del prestamo activo
            String sqlBuscar = "SELECT id_libro, estado, observaciones FROM prestamos WHERE id = ? FOR UPDATE";
            psBuscar = con.prepareStatement(sqlBuscar);
            psBuscar.setInt(1, idPrestamo);
            rsPrestamo = psBuscar.executeQuery();

            if (!rsPrestamo.next()) {
                LOGGER.log(Level.WARNING, "No se encontro el prestamo con ID {0}", idPrestamo);
                con.rollback();
                return false;
            }

            String estadoActual = rsPrestamo.getString("estado");
            if ("DEVUELTO".equalsIgnoreCase(estadoActual)) {
                LOGGER.log(Level.INFO, "El prestamo ID {0} ya habia sido devuelto.", idPrestamo);
                con.rollback();
                return false;
            }

            int idLibro = rsPrestamo.getInt("id_libro");
            String obsExistente = rsPrestamo.getString("observaciones");
            String obsFinal = obsExistente != null ? obsExistente : "";
            if (observacionesExtra != null && !observacionesExtra.trim().isEmpty()) {
                obsFinal += " | " + observacionesExtra.trim();
            }

            // 2. Actualizar estado y fecha real
            String sqlDevolver = "UPDATE prestamos SET estado = 'DEVUELTO', fecha_devolucion_real = CURDATE(), "
                               + "observaciones = ? WHERE id = ?";
            psDevolver = con.prepareStatement(sqlDevolver);
            psDevolver.setString(1, obsFinal);
            psDevolver.setInt(2, idPrestamo);
            psDevolver.executeUpdate();

            // 3. Restituir stock en tabla libros
            String sqlRestituir = "UPDATE libros SET stock_disponible = stock_disponible + 1 "
                                + "WHERE id = ? AND stock_disponible < stock_total";
            psRestituir = con.prepareStatement(sqlRestituir);
            psRestituir.setInt(1, idLibro);
            psRestituir.executeUpdate();

            con.commit(); // Confirmar transacción
            return true;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error en devolucion transaccional: " + e.getMessage(), e);
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error en rollback devolucion: " + ex.getMessage(), ex);
                }
            }
            return false;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                } catch (SQLException ex) {
                    LOGGER.log(Level.FINE, "Error reestableciendo autocommit", ex);
                }
            }
            Conexion.cerrarRecursos(rsPrestamo, psBuscar, psDevolver, psRestituir, con);
        }
    }

    /**
     * Lista todos los préstamos registrados en el sistema con datos del usuario y libro.
     */
    public List<Prestamo> listarTodos() {
        actualizarEstadosVencidos();
        List<Prestamo> lista = new ArrayList<>();
        String sql = "SELECT p.id, p.id_usuario, p.id_libro, p.fecha_prestamo, p.fecha_devolucion_esperada, "
                   + "p.fecha_devolucion_real, p.estado, p.observaciones, p.fecha_registro, "
                   + "u.nombre AS usuario_nombre, u.email AS usuario_email, u.rut AS usuario_rut, u.carrera AS usuario_carrera, "
                   + "l.titulo AS libro_titulo, l.autor AS libro_autor, l.isbn AS libro_isbn, l.categoria AS libro_categoria "
                   + "FROM prestamos p "
                   + "JOIN usuarios u ON p.id_usuario = u.id "
                   + "JOIN libros l ON p.id_libro = l.id "
                   + "ORDER BY p.fecha_prestamo DESC, p.id DESC";

        Connection con = null;
        Statement st = null;
        ResultSet rs = null;

        try {
            con = Conexion.getInstancia().getConnection();
            st = con.createStatement();
            rs = st.executeQuery(sql);

            while (rs.next()) {
                lista.add(mapearPrestamoConRelaciones(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar prestamos globales: " + e.getMessage(), e);
        } finally {
            Conexion.cerrarRecursos(rs, st, con);
        }
        return lista;
    }

    /**
     * Lista los préstamos correspondientes a un usuario (historial del estudiante).
     */
    public List<Prestamo> listarPorUsuario(int idUsuario) {
        actualizarEstadosVencidos();
        List<Prestamo> lista = new ArrayList<>();
        String sql = "SELECT p.id, p.id_usuario, p.id_libro, p.fecha_prestamo, p.fecha_devolucion_esperada, "
                   + "p.fecha_devolucion_real, p.estado, p.observaciones, p.fecha_registro, "
                   + "u.nombre AS usuario_nombre, u.email AS usuario_email, u.rut AS usuario_rut, u.carrera AS usuario_carrera, "
                   + "l.titulo AS libro_titulo, l.autor AS libro_autor, l.isbn AS libro_isbn, l.categoria AS libro_categoria "
                   + "FROM prestamos p "
                   + "JOIN usuarios u ON p.id_usuario = u.id "
                   + "JOIN libros l ON p.id_libro = l.id "
                   + "WHERE p.id_usuario = ? "
                   + "ORDER BY p.fecha_prestamo DESC, p.id DESC";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = Conexion.getInstancia().getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();

            while (rs.next()) {
                lista.add(mapearPrestamoConRelaciones(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar prestamos por usuario: " + e.getMessage(), e);
        } finally {
            Conexion.cerrarRecursos(rs, ps, con);
        }
        return lista;
    }

    /**
     * Cuenta el total de préstamos activos (no devueltos).
     */
    public int contarPrestamosActivos() {
        String sql = "SELECT COUNT(*) FROM prestamos WHERE estado IN ('ACTIVO', 'VENCIDO')";
        Connection con = null;
        Statement st = null;
        ResultSet rs = null;

        try {
            con = Conexion.getInstancia().getConnection();
            st = con.createStatement();
            rs = st.executeQuery(sql);
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error contando prestamos activos: " + e.getMessage(), e);
        } finally {
            Conexion.cerrarRecursos(rs, st, con);
        }
        return 0;
    }

    /**
     * Cuenta el total de préstamos devueltos históricamente.
     */
    public int contarPrestamosDevueltos() {
        String sql = "SELECT COUNT(*) FROM prestamos WHERE estado = 'DEVUELTO'";
        Connection con = null;
        Statement st = null;
        ResultSet rs = null;

        try {
            con = Conexion.getInstancia().getConnection();
            st = con.createStatement();
            rs = st.executeQuery(sql);
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error contando prestamos devueltos: " + e.getMessage(), e);
        } finally {
            Conexion.cerrarRecursos(rs, st, con);
        }
        return 0;
    }

    /**
     * Actualiza automáticamente los préstamos en estado ACTIVO cuya fecha límite ya pasó.
     */
    public void actualizarEstadosVencidos() {
        String sql = "UPDATE prestamos SET estado = 'VENCIDO' "
                   + "WHERE estado = 'ACTIVO' AND fecha_devolucion_esperada < CURDATE()";
        Connection con = null;
        Statement st = null;

        try {
            con = Conexion.getInstancia().getConnection();
            st = con.createStatement();
            st.executeUpdate(sql);
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error al actualizar estados vencidos: " + e.getMessage());
        } finally {
            Conexion.cerrarRecursos(st, con);
        }
    }

    private Prestamo mapearPrestamoConRelaciones(ResultSet rs) throws SQLException {
        Prestamo p = new Prestamo(
            rs.getInt("id"),
            rs.getInt("id_usuario"),
            rs.getInt("id_libro"),
            rs.getDate("fecha_prestamo"),
            rs.getDate("fecha_devolucion_esperada"),
            rs.getDate("fecha_devolucion_real"),
            rs.getString("estado"),
            rs.getString("observaciones"),
            rs.getTimestamp("fecha_registro")
        );

        Usuario u = new Usuario();
        u.setId(rs.getInt("id_usuario"));
        u.setNombre(rs.getString("usuario_nombre"));
        u.setEmail(rs.getString("usuario_email"));
        u.setRut(rs.getString("usuario_rut"));
        u.setCarrera(rs.getString("usuario_carrera"));
        p.setUsuario(u);

        Libro l = new Libro();
        l.setId(rs.getInt("id_libro"));
        l.setTitulo(rs.getString("libro_titulo"));
        l.setAutor(rs.getString("libro_autor"));
        l.setIsbn(rs.getString("libro_isbn"));
        l.setCategoria(rs.getString("libro_categoria"));
        p.setLibro(l);

        return p;
    }
}
