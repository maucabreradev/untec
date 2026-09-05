package cl.untec.biblioteca.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Entidad JavaBean que representa a un Usuario de la Biblioteca Digital UNTEC.
 */
public class Usuario implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String rut;
    private String nombre;
    private String email;
    private String password;
    private String rol; // "ADMIN" o "ESTUDIANTE"
    private String carrera;
    private String telefono;
    private boolean activo;
    private Timestamp fechaRegistro;

    public Usuario() {
        this.activo = true;
        this.rol = "ESTUDIANTE";
    }

    public Usuario(int id, String rut, String nombre, String email, String password, String rol, 
                   String carrera, String telefono, boolean activo, Timestamp fechaRegistro) {
        this.id = id;
        this.rut = rut;
        this.nombre = nombre;
        this.email = email;
        this.password = password;
        this.rol = rol;
        this.carrera = carrera;
        this.telefono = telefono;
        this.activo = activo;
        this.fechaRegistro = fechaRegistro;
    }

    // Constructor para registro/creación sin id
    public Usuario(String rut, String nombre, String email, String password, String rol, 
                   String carrera, String telefono) {
        this.rut = rut;
        this.nombre = nombre;
        this.email = email;
        this.password = password;
        this.rol = rol;
        this.carrera = carrera;
        this.telefono = telefono;
        this.activo = true;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getRut() {
        return rut;
    }

    public void setRut(String rut) {
        this.rut = rut;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public String getCarrera() {
        return carrera;
    }

    public void setCarrera(String carrera) {
        this.carrera = carrera;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }

    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(this.rol);
    }

    @Override
    public String toString() {
        return "Usuario [id=" + id + ", nombre=" + nombre + ", email=" + email + ", rol=" + rol + "]";
    }
}
