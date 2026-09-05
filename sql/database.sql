-- =====================================================================
-- SCRIPT DE BASE DE DATOS: BIBLIOTECA DIGITAL UNTEC
-- Motor: MySQL 8.0+ / MariaDB 10.4+
-- Base de Datos: untec_biblioteca
-- =====================================================================

CREATE DATABASE IF NOT EXISTS untec_biblioteca
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE untec_biblioteca;

-- Desactivar temporalmente chequeo de claves foráneas para recrear tablas
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS prestamos;
DROP TABLE IF EXISTS libros;
DROP TABLE IF EXISTS usuarios;
SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------------------
-- 1. TABLA: usuarios
-- ---------------------------------------------------------------------
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rut VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    rol VARCHAR(20) NOT NULL DEFAULT 'ESTUDIANTE', -- 'ESTUDIANTE' o 'ADMIN'
    carrera VARCHAR(120) DEFAULT 'Sin Asignar',
    telefono VARCHAR(30) DEFAULT '',
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 2. TABLA: libros
-- ---------------------------------------------------------------------
CREATE TABLE libros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(30) NOT NULL UNIQUE,
    titulo VARCHAR(200) NOT NULL,
    autor VARCHAR(150) NOT NULL,
    editorial VARCHAR(100) DEFAULT 'Editorial Universitaria',
    anio_publicacion INT DEFAULT 2020,
    categoria VARCHAR(80) NOT NULL,
    descripcion TEXT,
    portada_url VARCHAR(255) DEFAULT '',
    stock_total INT NOT NULL DEFAULT 1,
    stock_disponible INT NOT NULL DEFAULT 1,
    ubicacion VARCHAR(60) DEFAULT 'Estantería General',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_stock CHECK (stock_disponible >= 0 AND stock_disponible <= stock_total)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 3. TABLA: prestamos
-- ---------------------------------------------------------------------
CREATE TABLE prestamos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_libro INT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion_esperada DATE NOT NULL,
    fecha_devolucion_real DATE NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO', -- 'ACTIVO', 'DEVUELTO', 'VENCIDO'
    observaciones VARCHAR(255) DEFAULT 'Préstamo regular de biblioteca',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_prestamo_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_prestamo_libro FOREIGN KEY (id_libro) REFERENCES libros(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Índices para optimizar consultas frecuentes
CREATE INDEX idx_libros_titulo ON libros(titulo);
CREATE INDEX idx_libros_categoria ON libros(categoria);
CREATE INDEX idx_prestamos_estado ON prestamos(estado);
CREATE INDEX idx_prestamos_usuario ON prestamos(id_usuario);

-- ---------------------------------------------------------------------
-- DATOS INICIALES DE PRUEBA (SEED DATA)
-- ---------------------------------------------------------------------

-- Usuarios (1 Administrador / Bibliotecario y 2 Estudiantes)
INSERT INTO usuarios (rut, nombre, email, password, rol, carrera, telefono, activo) VALUES
('11.111.111-1', 'Administrador UNTEC', 'admin@untec.edu', 'admin123', 'ADMIN', 'Gestión Bibliotecaria', '+56 9 1111 2222', TRUE),
('22.222.222-2', 'Matías Silva Bravo', 'estudiante@untec.edu', 'alumno123', 'ESTUDIANTE', 'Ingeniería Civil Informática', '+56 9 3333 4444', TRUE),
('33.333.333-3', 'Carla Rojas Vega', 'carla.rojas@untec.edu', 'alumno123', 'ESTUDIANTE', 'Ingeniería Comercial', '+56 9 5555 6666', TRUE);

-- Libros de muestra con diversidad de áreas académicas
INSERT INTO libros (isbn, titulo, autor, editorial, anio_publicacion, categoria, descripcion, stock_total, stock_disponible, ubicacion) VALUES
('978-0132350884', 'Clean Code: A Handbook of Agile Software Craftsmanship', 'Robert C. Martin', 'Prentice Hall', 2008, 'Informática', 'Guía fundamental de buenas prácticas para desarrolladores de software sobre escritura de código limpio y mantenible.', 5, 4, 'Pabellón B - Estante 3'),
('978-0071809252', 'Java: The Complete Reference', 'Herbert Schildt', 'McGraw-Hill Education', 2018, 'Programación', 'Referencia exhaustiva del lenguaje Java, Servlets, programación orientada a objetos y concurrencia.', 4, 3, 'Pabellón B - Estante 1'),
('978-0201633610', 'Design Patterns: Elements of Reusable Object-Oriented Software', 'Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides', 'Addison-Wesley', 1994, 'Arquitectura de Software', 'El libro clásico de patrones de diseño GoF que transformó el diseño orientado a objetos.', 3, 3, 'Pabellón B - Estante 2'),
('978-0133591620', 'Sistemas Operativos Modernos', 'Andrew S. Tanenbaum, Herbert Bos', 'Pearson Educación', 2015, 'Sistemas', 'Texto fundamental sobre procesos, memoria virtual, sistemas de archivos y seguridad en sistemas operativos.', 4, 4, 'Pabellón B - Estante 4'),
('978-6071505781', 'Fundamentos de Bases de Datos', 'Abraham Silberschatz, Henry F. Korth, S. Sudarshan', 'McGraw-Hill', 2014, 'Bases de Datos', 'Conceptos de diseño relacional, SQL, álgebra relacional, normalización y transacciones ACID.', 6, 5, 'Pabellón B - Estante 5'),
('978-6075220130', 'Cálculo de una Variable: Trascendentes Tempranas', 'James Stewart', 'Cengage Learning', 2016, 'Ciencias Básicas', 'Texto de referencia para cursos de cálculo diferencial e integral con aplicaciones prácticas.', 8, 8, 'Pabellón A - Estante 1'),
('978-6073238472', 'Álgebra Lineal y sus Aplicaciones', 'David C. Lay', 'Pearson Educación', 2016, 'Matemáticas', 'Fundamentos de vectores, transformaciones lineales, determinantes y autovalores para ingeniería.', 5, 5, 'Pabellón A - Estante 2'),
('978-6075265506', 'Principios de Economía', 'N. Gregory Mankiw', 'Cengage Learning', 2017, 'Economía', 'Introducción comprensible y rigurosa a la microeconomía y macroeconomía para ciencias sociales y gestión.', 4, 4, 'Pabellón C - Estante 1'),
('978-0136042594', 'Artificial Intelligence: A Modern Approach', 'Stuart Russell, Peter Norvig', 'Pearson', 2020, 'Inteligencia Artificial', 'La obra estándar mundial sobre búsqueda heurística, aprendizaje automático y agentes inteligentes.', 3, 3, 'Pabellón B - Estante 6');

-- Préstamos de muestra
-- 1 Préstamo Activo del libro Clean Code (id 1) para Matías Silva (id 2)
INSERT INTO prestamos (id_usuario, id_libro, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado, observaciones) VALUES
(2, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), NULL, 'ACTIVO', 'Préstamo regular de estudio para proyecto de título');

-- 1 Préstamo Devuelto del libro Java Complete Reference (id 2) para Matías Silva (id 2)
INSERT INTO prestamos (id_usuario, id_libro, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado, observaciones) VALUES
(2, 2, DATE_SUB(CURDATE(), INTERVAL 14 DAY), DATE_SUB(CURDATE(), INTERVAL 7 DAY), DATE_SUB(CURDATE(), INTERVAL 8 DAY), 'DEVUELTO', 'Devuelto en óptimas condiciones en mesón de atención');

-- 1 Préstamo Activo del libro Fundamentos de Bases de Datos (id 5) para Carla Rojas (id 3)
INSERT INTO prestamos (id_usuario, id_libro, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado, observaciones) VALUES
(3, 5, DATE_SUB(CURDATE(), INTERVAL 2 DAY), DATE_ADD(CURDATE(), INTERVAL 5 DAY), NULL, 'ACTIVO', 'Solicitud online desde catálogo de alumnos');
