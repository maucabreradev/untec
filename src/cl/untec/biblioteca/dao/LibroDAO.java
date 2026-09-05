package cl.untec.biblioteca.dao;

import cl.untec.biblioteca.model.Libro;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Capa DAO para operaciones CRUD y de catálogo sobre la tabla libros.
 */
public class LibroDAO {

    private static final Logger LOGGER = Logger.getLogger(LibroDAO.class.getName());

    /**
     * Lista todos los libros del catálogo ordenados por título.
     */
    public List<Libro> listarTodos() {
        List<Libro> lista = new ArrayList<>();
        String sql = "SELECT id, isbn, titulo, autor, editorial, anio_publicacion, categoria, descripcion, "
                   + "portada_url, stock_total, stock_disponible, ubicacion, fecha_registro "
                   + "FROM libros ORDER BY titulo ASC";
        Connection con = null;
        Statement st = null;
        ResultSet rs = null;

        try {
            con = Conexion.getInstancia().getConnection();
            st = con.createStatement();
            rs = st.executeQuery(sql);

            while (rs.next()) {
                lista.add(mapearLibro(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar libros: " + e.getMessage(), e);
        } finally {
            Conexion.cerrarRecursos(rs, st, con);
        }
        return lista;
    }

    /**
     * Lista únicamente los libros con stock disponible > 0.
     */
    public List<Libro> listarDisponibles() {
        List<Libro> lista = new ArrayList<>();
        String sql = "SELECT id, isbn, titulo, autor, editorial, anio_publicacion, categoria, descripcion, "
                   + "portada_url, stock_total, stock_disponible, ubicacion, fecha_registro "
                   + "FROM libros WHERE stock_disponible > 0 ORDER BY titulo ASC";
        Connection con = null;
        Statement st = null;
        ResultSet rs = null;

        try {
            con = Conexion.getInstancia().getConnection();
            st = con.createStatement();
            rs = st.executeQuery(sql);

            while (rs.next()) {
                lista.add(mapearLibro(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar libros disponibles: " + e.getMessage(), e);
        } finally {
            Conexion.cerrarRecursos(rs, st, con);
        }
        return lista;
    }

    /**
     * Busca libros por coincidencia en título/autor/isbn y opcionalmente por categoría.
     */
    public List<Libro> buscar(String query, String categoria) {
        List<Libro> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT id, isbn, titulo, autor, editorial, anio_publicacion, categoria, descripcion, "
          + "portada_url, stock_total, stock_disponible, ubicacion, fecha_registro FROM libros WHERE 1=1 "
        );

        boolean tieneQuery = query != null && !query.trim().isEmpty();
        boolean tieneCategoria = categoria != null && !categoria.trim().isEmpty() && !"TODAS".equalsIgnoreCase(categoria.trim());

        if (tieneQuery) {
            sql.append("AND (LOWER(titulo) LIKE ? OR LOWER(autor) LIKE ? OR isbn LIKE ?) ");
        }
        if (tieneCategoria) {
            sql.append("AND categoria = ? ");
        }
        sql.append("ORDER BY titulo ASC");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = Conexion.getInstancia().getConnection();
            ps = con.prepareStatement(sql.toString());
            int idx = 1;

            if (tieneQuery) {
                String pattern = "%" + query.trim().toLowerCase() + "%";
                ps.setString(idx++, pattern);
                ps.setString(idx++, pattern);
                ps.setString(idx++, pattern);
            }
            if (tieneCategoria) {
                ps.setString(idx++, categoria.trim());
            }

            rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapearLibro(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error en busqueda de libros: " + e.getMessage(), e);
        } finally {
            Conexion.cerrarRecursos(rs, ps, con);
        }
        return lista;
    }

    /**
     * Obtiene un libro por su ID primario.
     */
    public Libro obtenerPorId(int id) {
        String sql = "SELECT id, isbn, titulo, autor, editorial, anio_publicacion, categoria, descripcion, "
                   + "portada_url, stock_total, stock_disponible, ubicacion, fecha_registro "
                   + "FROM libros WHERE id = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = Conexion.getInstancia().getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapearLibro(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error en obtenerPorId libro: " + e.getMessage(), e);
        } finally {
            Conexion.cerrarRecursos(rs, ps, con);
        }
        return null;
    }

    /**
     * Obtiene un libro por su ISBN.
     */
    public Libro obtenerPorIsbn(String isbn) {
        String sql = "SELECT id, isbn, titulo, autor, editorial, anio_publicacion, categoria, descripcion, "
                   + "portada_url, stock_total, stock_disponible, ubicacion, fecha_registro "
                   + "FROM libros WHERE isbn = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = Conexion.getInstancia().getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, isbn != null ? isbn.trim() : "");
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapearLibro(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error en obtenerPorIsbn: " + e.getMessage(), e);
        } finally {
            Conexion.cerrarRecursos(rs, ps, con);
        }
        return null;
    }

    /**
     * Inserta un nuevo libro en la base de datos.
     */
    public boolean insertar(Libro l) {
        String sql = "INSERT INTO libros (isbn, titulo, autor, editorial, anio_publicacion, categoria, "
                   + "descripcion, portada_url, stock_total, stock_disponible, ubicacion) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = Conexion.getInstancia().getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, l.getIsbn());
            ps.setString(2, l.getTitulo());
            ps.setString(3, l.getAutor());
            ps.setString(4, l.getEditorial());
            ps.setInt(5, l.getAnioPublicacion());
            ps.setString(6, l.getCategoria());
            ps.setString(7, l.getDescripcion());
            ps.setString(8, l.getPortadaUrl());
            ps.setInt(9, l.getStockTotal());
            ps.setInt(10, l.getStockDisponible());
            ps.setString(11, l.getUbicacion());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al insertar libro: " + e.getMessage(), e);
            return false;
        } finally {
            Conexion.cerrarRecursos(ps, con);
        }
    }

    /**
     * Actualiza la información de un libro existente.
     */
    public boolean actualizar(Libro l) {
        String sql = "UPDATE libros SET isbn = ?, titulo = ?, autor = ?, editorial = ?, anio_publicacion = ?, "
                   + "categoria = ?, descripcion = ?, portada_url = ?, stock_total = ?, stock_disponible = ?, "
                   + "ubicacion = ? WHERE id = ?";
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = Conexion.getInstancia().getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, l.getIsbn());
            ps.setString(2, l.getTitulo());
            ps.setString(3, l.getAutor());
            ps.setString(4, l.getEditorial());
            ps.setInt(5, l.getAnioPublicacion());
            ps.setString(6, l.getCategoria());
            ps.setString(7, l.getDescripcion());
            ps.setString(8, l.getPortadaUrl());
            ps.setInt(9, l.getStockTotal());
            ps.setInt(10, l.getStockDisponible());
            ps.setString(11, l.getUbicacion());
            ps.setInt(12, l.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al actualizar libro: " + e.getMessage(), e);
            return false;
        } finally {
            Conexion.cerrarRecursos(ps, con);
        }
    }

    /**
     * Elimina un libro de la base de datos (siempre que no tenga préstamos vinculados).
     */
    public boolean eliminar(int id) {
        String sql = "DELETE FROM libros WHERE id = ?";
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = Conexion.getInstancia().getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "No se pudo eliminar el libro (puede tener prestamos asociados): " + e.getMessage());
            return false;
        } finally {
            Conexion.cerrarRecursos(ps, con);
        }
    }

    /**
     * Obtiene el listado de categorías distintas registradas en la base de datos.
     */
    public List<String> listarCategorias() {
        List<String> categorias = new ArrayList<>();
        String sql = "SELECT DISTINCT categoria FROM libros ORDER BY categoria ASC";
        Connection con = null;
        Statement st = null;
        ResultSet rs = null;

        try {
            con = Conexion.getInstancia().getConnection();
            st = con.createStatement();
            rs = st.executeQuery(sql);
            while (rs.next()) {
                categorias.add(rs.getString("categoria"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error listando categorias: " + e.getMessage(), e);
        } finally {
            Conexion.cerrarRecursos(rs, st, con);
        }
        return categorias;
    }

    /**
     * Cuenta el total de títulos registrados.
     */
    public int contarTotalTitulos() {
        String sql = "SELECT COUNT(*) FROM libros";
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
            LOGGER.log(Level.SEVERE, "Error contando titulos: " + e.getMessage(), e);
        } finally {
            Conexion.cerrarRecursos(rs, st, con);
        }
        return 0;
    }

    /**
     * Cuenta el total de ejemplares físicos disponibles en la biblioteca.
     */
    public int contarEjemplaresDisponibles() {
        String sql = "SELECT COALESCE(SUM(stock_disponible), 0) FROM libros";
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
            LOGGER.log(Level.SEVERE, "Error contando ejemplares disponibles: " + e.getMessage(), e);
        } finally {
            Conexion.cerrarRecursos(rs, st, con);
        }
        return 0;
    }

    private Libro mapearLibro(ResultSet rs) throws SQLException {
        return new Libro(
            rs.getInt("id"),
            rs.getString("isbn"),
            rs.getString("titulo"),
            rs.getString("autor"),
            rs.getString("editorial"),
            rs.getInt("anio_publicacion"),
            rs.getString("categoria"),
            rs.getString("descripcion"),
            rs.getString("portada_url"),
            rs.getInt("stock_total"),
            rs.getInt("stock_disponible"),
            rs.getString("ubicacion"),
            rs.getTimestamp("fecha_registro")
        );
    }
}
