package cl.untec.biblioteca.dao;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Clase Singleton para gestionar la conexión JDBC con la base de datos MySQL.
 * Lee la configuración desde src/db.properties de manera desacoplada.
 */
public class Conexion {

    private static final Logger LOGGER = Logger.getLogger(Conexion.class.getName());
    private static Conexion instancia;

    private String driver;
    private String url;
    private String user;
    private String password;

    /**
     * Constructor privado: carga las propiedades de configuración JDBC.
     */
    private Conexion() {
        Properties prop = new Properties();
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) {
                prop.load(input);
                this.driver = prop.getProperty("db.driver", "com.mysql.cj.jdbc.Driver");
                this.url = prop.getProperty("db.url", "jdbc:mysql://localhost:3306/untec_biblioteca?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&characterEncoding=UTF-8");
                this.user = prop.getProperty("db.user", "root");
                this.password = prop.getProperty("db.password", "");
            } else {
                LOGGER.log(Level.WARNING, "No se encontro db.properties en el classpath. Usando valores predeterminados.");
                this.driver = "com.mysql.cj.jdbc.Driver";
                this.url = "jdbc:mysql://localhost:3306/untec_biblioteca?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&characterEncoding=UTF-8";
                this.user = "root";
                this.password = "";
            }

            // Cargar el driver JDBC
            Class.forName(this.driver);
            LOGGER.log(Level.INFO, "Driver JDBC {0} cargado con exito.", this.driver);

        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error de I/O al leer db.properties: " + e.getMessage(), e);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "No se encontro la clase del Driver MySQL: " + this.driver, e);
        }
    }

    /**
     * Obtiene la única instancia de la clase Conexion (Patrón Singleton con hilo seguro).
     */
    public static synchronized Conexion getInstancia() {
        if (instancia == null) {
            instancia = new Conexion();
        }
        return instancia;
    }

    /**
     * Proporciona una nueva conexión activa hacia MySQL.
     * @return Connection lista para operaciones JDBC.
     * @throws SQLException Si ocurre un error al conectar.
     */
    public Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(this.url, this.user, this.password);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al conectar con la base de datos: " + e.getMessage(), e);
            throw e;
        }
    }

    /**
     * Utilidad para cerrar recursos JDBC de manera segura y silenciosa.
     */
    public static void cerrarRecursos(AutoCloseable... recursos) {
        for (AutoCloseable recurso : recursos) {
            if (recurso != null) {
                try {
                    recurso.close();
                } catch (Exception e) {
                    LOGGER.log(Level.FINE, "Error cerrando recurso: " + e.getMessage(), e);
                }
            }
        }
    }
}
