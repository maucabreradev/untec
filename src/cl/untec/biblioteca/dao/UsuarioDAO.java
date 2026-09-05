package cl.untec.biblioteca.dao;

import cl.untec.biblioteca.model.Usuario;
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
 * Capa DAO para operaciones sobre la tabla usuarios.
 */
public class UsuarioDAO {

    private static final Logger LOGGER = Logger.getLogger(UsuarioDAO.class.getName());

    /**
     * Valida credenciales de login (email y password).
     * @return Usuario autenticado o null si las credenciales son incorrectas.
     */
    public Usuario autenticar(String email, String password) {
        String sql = "SELECT id, rut, nombre, email, password, rol, carrera, telefono, activo, fecha_registro "
                   + "FROM usuarios WHERE email = ? AND password = ? AND activo = TRUE";
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = Conexion.getInstancia().getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, email != null ? email.trim() : "");
            ps.setString(2, password != null ? password.trim() : "");
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapearUsuario(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error en autenticar usuario: " + e.getMessage(), e);
        } finally {
            Conexion.cerrarRecursos(rs, ps, con);
        }
        return null;
    }

    /**
     * Busca un usuario por su ID.
     */
    public Usuario obtenerPorId(int id) {
        String sql = "SELECT id, rut, nombre, email, password, rol, carrera, telefono, activo, fecha_registro "
                   + "FROM usuarios WHERE id = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = Conexion.getInstancia().getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapearUsuario(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error en obtenerPorId: " + e.getMessage(), e);
        } finally {
            Conexion.cerrarRecursos(rs, ps, con);
        }
        return null;
    }

    /**
     * Busca un usuario por su Email.
     */
    public Usuario obtenerPorEmail(String email) {
        String sql = "SELECT id, rut, nombre, email, password, rol, carrera, telefono, activo, fecha_registro "
                   + "FROM usuarios WHERE email = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = Conexion.getInstancia().getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, email != null ? email.trim() : "");
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapearUsuario(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error en obtenerPorEmail: " + e.getMessage(), e);
        } finally {
            Conexion.cerrarRecursos(rs, ps, con);
        }
        return null;
    }

    /**
     * Lista todos los usuarios registrados.
     */
    public List<Usuario> listarTodos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT id, rut, nombre, email, password, rol, carrera, telefono, activo, fecha_registro "
                   + "FROM usuarios ORDER BY nombre ASC";
        Connection con = null;
        Statement st = null;
        ResultSet rs = null;

        try {
            con = Conexion.getInstancia().getConnection();
            st = con.createStatement();
            rs = st.executeQuery(sql);

            while (rs.next()) {
                lista.add(mapearUsuario(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar usuarios: " + e.getMessage(), e);
        } finally {
            Conexion.cerrarRecursos(rs, st, con);
        }
        return lista;
    }

    /**
     * Inserta un nuevo usuario en la base de datos.
     */
    public boolean insertar(Usuario u) {
        String sql = "INSERT INTO usuarios (rut, nombre, email, password, rol, carrera, telefono, activo) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = Conexion.getInstancia().getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, u.getRut());
            ps.setString(2, u.getNombre());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getPassword());
            ps.setString(5, u.getRol() != null ? u.getRol() : "ESTUDIANTE");
            ps.setString(6, u.getCarrera());
            ps.setString(7, u.getTelefono());
            ps.setBoolean(8, u.isActivo());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al insertar usuario: " + e.getMessage(), e);
            return false;
        } finally {
            Conexion.cerrarRecursos(ps, con);
        }
    }

    /**
     * Cuenta la cantidad total de estudiantes registrados.
     */
    public int contarTotalEstudiantes() {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE rol = 'ESTUDIANTE' AND activo = TRUE";
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
            LOGGER.log(Level.SEVERE, "Error contando estudiantes: " + e.getMessage(), e);
        } finally {
            Conexion.cerrarRecursos(rs, st, con);
        }
        return 0;
    }

    private Usuario mapearUsuario(ResultSet rs) throws SQLException {
        return new Usuario(
            rs.getInt("id"),
            rs.getString("rut"),
            rs.getString("nombre"),
            rs.getString("email"),
            rs.getString("password"),
            rs.getString("rol"),
            rs.getString("carrera"),
            rs.getString("telefono"),
            rs.getBoolean("activo"),
            rs.getTimestamp("fecha_registro")
        );
    }
}
