-- Repara texto guardado como UTF-8 interpretado previamente como latin1.
-- Ejecutar una sola vez sobre la base existente después de hacer un respaldo.
USE untec_biblioteca;
SET NAMES utf8mb4;

START TRANSACTION;

UPDATE usuarios
SET nombre = CASE
        WHEN nombre LIKE '%Ã%' OR nombre LIKE '%Â%'
        THEN CONVERT(CAST(CONVERT(nombre USING latin1) AS BINARY) USING utf8mb4)
        ELSE nombre
    END,
    carrera = CASE
        WHEN carrera LIKE '%Ã%' OR carrera LIKE '%Â%'
        THEN CONVERT(CAST(CONVERT(carrera USING latin1) AS BINARY) USING utf8mb4)
        ELSE carrera
    END,
    telefono = CASE
        WHEN telefono LIKE '%Ã%' OR telefono LIKE '%Â%'
        THEN CONVERT(CAST(CONVERT(telefono USING latin1) AS BINARY) USING utf8mb4)
        ELSE telefono
    END;

UPDATE libros
SET titulo = CASE
        WHEN titulo LIKE '%Ã%' OR titulo LIKE '%Â%'
        THEN CONVERT(CAST(CONVERT(titulo USING latin1) AS BINARY) USING utf8mb4)
        ELSE titulo
    END,
    autor = CASE
        WHEN autor LIKE '%Ã%' OR autor LIKE '%Â%'
        THEN CONVERT(CAST(CONVERT(autor USING latin1) AS BINARY) USING utf8mb4)
        ELSE autor
    END,
    editorial = CASE
        WHEN editorial LIKE '%Ã%' OR editorial LIKE '%Â%'
        THEN CONVERT(CAST(CONVERT(editorial USING latin1) AS BINARY) USING utf8mb4)
        ELSE editorial
    END,
    categoria = CASE
        WHEN categoria LIKE '%Ã%' OR categoria LIKE '%Â%'
        THEN CONVERT(CAST(CONVERT(categoria USING latin1) AS BINARY) USING utf8mb4)
        ELSE categoria
    END,
    descripcion = CASE
        WHEN descripcion LIKE '%Ã%' OR descripcion LIKE '%Â%'
        THEN CONVERT(CAST(CONVERT(descripcion USING latin1) AS BINARY) USING utf8mb4)
        ELSE descripcion
    END,
    ubicacion = CASE
        WHEN ubicacion LIKE '%Ã%' OR ubicacion LIKE '%Â%'
        THEN CONVERT(CAST(CONVERT(ubicacion USING latin1) AS BINARY) USING utf8mb4)
        ELSE ubicacion
    END;

UPDATE prestamos
SET observaciones = CASE
        WHEN observaciones LIKE '%Ã%' OR observaciones LIKE '%Â%'
        THEN CONVERT(CAST(CONVERT(observaciones USING latin1) AS BINARY) USING utf8mb4)
        ELSE observaciones
    END;

COMMIT;
