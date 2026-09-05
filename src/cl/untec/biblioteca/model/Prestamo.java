package cl.untec.biblioteca.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;

/**
 * Entidad JavaBean que representa un Préstamo de libro realizado por un Usuario.
 */
public class Prestamo implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int idUsuario;
    private int idLibro;
    private Date fechaPrestamo;
    private Date fechaDevolucionEsperada;
    private Date fechaDevolucionReal;
    private String estado; // "ACTIVO", "DEVUELTO", "VENCIDO"
    private String observaciones;
    private Timestamp fechaRegistro;

    // Relaciones para vistas completas en MVC
    private Usuario usuario;
    private Libro libro;

    public Prestamo() {
        this.estado = "ACTIVO";
    }

    public Prestamo(int id, int idUsuario, int idLibro, Date fechaPrestamo, Date fechaDevolucionEsperada,
                    Date fechaDevolucionReal, String estado, String observaciones, Timestamp fechaRegistro) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.idLibro = idLibro;
        this.fechaPrestamo = fechaPrestamo;
        this.fechaDevolucionEsperada = fechaDevolucionEsperada;
        this.fechaDevolucionReal = fechaDevolucionReal;
        this.estado = estado;
        this.observaciones = observaciones;
        this.fechaRegistro = fechaRegistro;
    }

    // Constructor para solicitud rápida de préstamo (por defecto 7 días de plazo)
    public Prestamo(int idUsuario, int idLibro, int diasPrestamo, String observaciones) {
        this.idUsuario = idUsuario;
        this.idLibro = idLibro;
        LocalDate hoy = LocalDate.now();
        this.fechaPrestamo = Date.valueOf(hoy);
        this.fechaDevolucionEsperada = Date.valueOf(hoy.plusDays(diasPrestamo > 0 ? diasPrestamo : 7));
        this.estado = "ACTIVO";
        this.observaciones = observaciones;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdLibro() {
        return idLibro;
    }

    public void setIdLibro(int idLibro) {
        this.idLibro = idLibro;
    }

    public Date getFechaPrestamo() {
        return fechaPrestamo;
    }

    public void setFechaPrestamo(Date fechaPrestamo) {
        this.fechaPrestamo = fechaPrestamo;
    }

    public Date getFechaDevolucionEsperada() {
        return fechaDevolucionEsperada;
    }

    public void setFechaDevolucionEsperada(Date fechaDevolucionEsperada) {
        this.fechaDevolucionEsperada = fechaDevolucionEsperada;
    }

    public Date getFechaDevolucionReal() {
        return fechaDevolucionReal;
    }

    public void setFechaDevolucionReal(Date fechaDevolucionReal) {
        this.fechaDevolucionReal = fechaDevolucionReal;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public Libro getLibro() {
        return libro;
    }

    public void setLibro(Libro libro) {
        this.libro = libro;
    }

    public boolean isActivo() {
        return "ACTIVO".equalsIgnoreCase(this.estado);
    }

    public boolean isDevuelto() {
        return "DEVUELTO".equalsIgnoreCase(this.estado);
    }

    public boolean isVencido() {
        if ("DEVUELTO".equalsIgnoreCase(this.estado)) {
            return false;
        }
        if (fechaDevolucionEsperada != null) {
            LocalDate hoy = LocalDate.now();
            return hoy.isAfter(fechaDevolucionEsperada.toLocalDate());
        }
        return "VENCIDO".equalsIgnoreCase(this.estado);
    }

    @Override
    public String toString() {
        return "Prestamo [id=" + id + ", idUsuario=" + idUsuario + ", idLibro=" + idLibro + ", estado=" + estado + "]";
    }
}
