package cl.untec.biblioteca.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Entidad JavaBean que representa un Libro en el catálogo de la Biblioteca Digital UNTEC.
 */
public class Libro implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String isbn;
    private String titulo;
    private String autor;
    private String editorial;
    private int anioPublicacion;
    private String categoria;
    private String descripcion;
    private String portadaUrl;
    private int stockTotal;
    private int stockDisponible;
    private String ubicacion;
    private Timestamp fechaRegistro;

    public Libro() {
        this.stockTotal = 1;
        this.stockDisponible = 1;
    }

    public Libro(int id, String isbn, String titulo, String autor, String editorial, int anioPublicacion,
                 String categoria, String descripcion, String portadaUrl, int stockTotal, 
                 int stockDisponible, String ubicacion, Timestamp fechaRegistro) {
        this.id = id;
        this.isbn = isbn;
        this.titulo = titulo;
        this.autor = autor;
        this.editorial = editorial;
        this.anioPublicacion = anioPublicacion;
        this.categoria = categoria;
        this.descripcion = descripcion;
        this.portadaUrl = portadaUrl;
        this.stockTotal = stockTotal;
        this.stockDisponible = stockDisponible;
        this.ubicacion = ubicacion;
        this.fechaRegistro = fechaRegistro;
    }

    // Constructor para alta de libros sin ID
    public Libro(String isbn, String titulo, String autor, String editorial, int anioPublicacion,
                 String categoria, String descripcion, String portadaUrl, int stockTotal, 
                 int stockDisponible, String ubicacion) {
        this.isbn = isbn;
        this.titulo = titulo;
        this.autor = autor;
        this.editorial = editorial;
        this.anioPublicacion = anioPublicacion;
        this.categoria = categoria;
        this.descripcion = descripcion;
        this.portadaUrl = portadaUrl;
        this.stockTotal = stockTotal;
        this.stockDisponible = stockDisponible;
        this.ubicacion = ubicacion;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getAutor() {
        return autor;
    }

    public void setAutor(String autor) {
        this.autor = autor;
    }

    public String getEditorial() {
        return editorial;
    }

    public void setEditorial(String editorial) {
        this.editorial = editorial;
    }

    public int getAnioPublicacion() {
        return anioPublicacion;
    }

    public void setAnioPublicacion(int anioPublicacion) {
        this.anioPublicacion = anioPublicacion;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getPortadaUrl() {
        return portadaUrl;
    }

    public void setPortadaUrl(String portadaUrl) {
        this.portadaUrl = portadaUrl;
    }

    public int getStockTotal() {
        return stockTotal;
    }

    public void setStockTotal(int stockTotal) {
        this.stockTotal = stockTotal;
    }

    public int getStockDisponible() {
        return stockDisponible;
    }

    public void setStockDisponible(int stockDisponible) {
        this.stockDisponible = stockDisponible;
    }

    public String getUbicacion() {
        return ubicacion;
    }

    public void setUbicacion(String ubicacion) {
        this.ubicacion = ubicacion;
    }

    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public boolean isDisponible() {
        return this.stockDisponible > 0;
    }

    @Override
    public String toString() {
        return "Libro [id=" + id + ", titulo=" + titulo + ", autor=" + autor + ", stock=" + stockDisponible + "/" + stockTotal + "]";
    }
}
