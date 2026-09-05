# 📚 Biblioteca Digital UNTEC

Sistema web dinámico desarrollado con arquitectura **Java EE (J2EE)** y patrón de diseño **MVC (Modelo-Vista-Controlador)** para la gestión integral de catálogo, préstamos, devoluciones y usuarios de la Universidad Tecnológica UNTEC.

---

## 🚀 Características Principales

- **Patrón MVC Estricto**:
  - **Modelo**: Clases JavaBeans (`Usuario`, `Libro`, `Prestamo`).
  - **Vista**: Páginas JSP modernas y responsivas con **JSTL 1.2** (`<c:out>`, `<c:if>`, `<c:forEach>`, `<c:choose>`) y Bootstrap 5.
  - **Controlador**: Servlets HTTP (`LoginServlet`, `DashboardServlet`, `LibroServlet`, `PrestamoServlet`).
- **Capa DAO con JDBC & Patrón Singleton**:
  - Gestión centralizada y parametrizada de conexión en `Conexion.java` leyendo `db.properties`.
  - Consultas protegidas contra inyecciones SQL mediante `PreparedStatement`.
  - Operaciones transaccionales con `con.setAutoCommit(false)` para garantizar consistencia entre stock de libros y préstamos.
- **Gestión de Sesiones & Filtro de Seguridad**:
  - Uso de `HttpSession` para persistir el estado de usuario autenticado.
  - `AuthFilter` que intercepta rutas privadas y restringe acciones administrativas a usuarios no autorizados.
  - Invalidación de sesión y control de cabeceras de no-caché (`Cache-Control`).
- **Dos Roles de Usuario**:
  - **Estudiante**: Consulta de catálogo con filtros en tiempo real, solicitud de préstamos online y revisión de su historial.
  - **Administrador / Bibliotecario**: Panel de estadísticas, CRUD completo de inventario de libros y control/registro de devoluciones.

---

## 🛠️ Tecnologías y Entorno

| Componente | Especificación / Versión |
| :--- | :--- |
| **Lenguaje** | Java 8+ (compatible con JDK 8, 11, 17, 21) |
| **Especificación Web** | Java EE 8 / Servlet 4.0 (`javax.servlet.*`) |
| **Motor de Vistas** | JSP 2.3 + JSTL 1.2 |
| **Servidor de Aplicaciones** | Apache Tomcat 9 |
| **Base de Datos** | MySQL 8.0+ / MariaDB 10.4+ |
| **IDE Recomendado** | Eclipse Enterprise Edition (Dynamic Web Project) |
| **Librerías (WEB-INF/lib)** | `mysql-connector-j-8.3.0.jar`, `taglibs-standard-impl-1.2.5.jar`, `taglibs-standard-spec-1.2.5.jar` |

---

## 📂 Estructura del Proyecto

```
untec/
├── .settings/                          # Facets y metadatos de Eclipse Enterprise
├── .project                            # Proyecto Eclipse
├── .classpath                          # Classpath con contenedor Web App
├── sql/
│   └── database.sql                    # Script DDL/DML de creación y datos de prueba
├── scripts/
│   ├── download-libs.ps1               # Descarga automática de JARs a WEB-INF/lib
│   ├── build.ps1                       # Compilación con javac y empaquetado .WAR
│   └── build.bat                       # Acceso rápido en Windows
├── src/
│   ├── db.properties                   # Parámetros JDBC configurables
│   └── cl/untec/biblioteca/
│       ├── model/                      # JavaBeans (Usuario, Libro, Prestamo)
│       ├── dao/                        # Clases DAO y Singleton (Conexion, UsuarioDAO, LibroDAO, PrestamoDAO)
│       ├── controller/                 # Servlets MVC (Login, Dashboard, Libro, Prestamo)
│       └── filter/                     # Filtro de seguridad AuthFilter
├── WebContent/
│   ├── META-INF/
│   ├── WEB-INF/
│   │   ├── web.xml                     # Descriptor de despliegue Servlet 4.0
│   │   └── lib/                        # Driver MySQL JDBC y librerías JSTL
│   ├── static/
│   │   └── css/untec-custom.css        # Estilos corporativos UNTEC
│   ├── includes/                       # Navbar, Footer y Alertas Flash
│   ├── libros/                         # Catálogo, Admin y Formulario
│   ├── prestamos/                      # Mis Préstamos y Control de Devoluciones
│   ├── error/                          # Vistas personalizadas 404 y 500
│   ├── index.jsp                       # Redirección automática inicial
│   ├── login.jsp                       # Formulario de login institucional
│   └── dashboard.jsp                   # Panel principal con métricas por rol
└── dist/
    └── biblioteca-untec.war            # Archivo empaquetado listo para desplegar
```

---

## 🗄️ Configuración de la Base de Datos

1. Abre tu gestor de base de datos MySQL favorito (MySQL Workbench, phpMyAdmin, DBeaver o consola `mysql`).
2. Ejecuta el script ubicado en:
   ```
   sql/database.sql
   ```
3. El script creará la base de datos `untec_biblioteca`, las tablas `usuarios`, `libros`, `prestamos` y cargará los datos de prueba iniciales.
4. Verifica los datos de conexión en `src/db.properties` (por defecto `localhost:3306`, usuario `root` y contraseña vacía).

---

## 🔑 Credenciales de Prueba

El sistema incluye botones de auto-llenado en la pantalla de login para facilitar la evaluación:

| Rol | Correo Institucional | Contraseña | Perfil y Permisos |
| :--- | :--- | :--- | :--- |
| **Administrador / Bibliotecario** | `admin@untec.edu` | `admin123` | Control total, CRUD de libros y recepción de devoluciones |
| **Estudiante** | `estudiante@untec.edu` | `alumno123` | Consulta de catálogo y solicitud de préstamos |
| **Estudiante (Alternativo)** | `carla.rojas@untec.edu` | `alumno123` | Consulta y préstamos individuales |

---

## 📦 Compilación y Generación del archivo `.WAR`

### Opción 1: Mediante Script Automatizado (Recomendado)
Puedes generar el archivo `.WAR` por consola sin necesidad de abrir Eclipse:
- En Windows (Cmd): Haz doble clic en `scripts\build.bat`.
- En PowerShell:
  ```powershell
  .\scripts\build.ps1
  ```
El archivo final se creará en:
```
dist/biblioteca-untec.war
```

### Opción 2: Desde Eclipse Enterprise Edition
1. En Eclipse, haz clic derecho sobre el proyecto `untec-biblioteca`.
2. Selecciona **Export** > **WAR file**.
3. Elige la ruta de destino y marca la casilla *Overwrite existing file*.

---

## 🌐 Despliegue en Apache Tomcat 9

### Método A: Despliegue directo en carpeta `webapps`
1. Copia `dist/biblioteca-untec.war` a la carpeta `webapps` de tu instalación de Tomcat:
   ```
   C:\apache-tomcat-9.x.x\webapps\
   ```
2. Inicia Tomcat ejecutando `bin\startup.bat`.
3. Accede en el navegador a:
   ```
   http://localhost:8080/biblioteca-untec/
   ```

### Método B: Despliegue mediante Tomcat Manager
1. Ingresa a `http://localhost:8080/manager/html`.
2. En la sección **WAR file to deploy**, selecciona el archivo `biblioteca-untec.war` y pulsa **Deploy**.
3. Haz clic en la ruta `/biblioteca-untec` de la lista de aplicaciones desplegadas.

---

## 🧪 Suite de Pruebas Automatizadas (Testing con JUnit 5)

El proyecto cuenta con una batería de **24 pruebas unitarias y de integración** desarrolladas con **JUnit 5 (Jupiter)**, cubriendo:

- **Modelos y Lógica de Negocio**:
  - `UsuarioTest`: Verificación de roles institucionales, estados activo/inactivo y método `isAdmin()`.
  - `LibroTest`: Comportamiento de stock total vs disponible, lógica de disponibilidad (`isDisponible()`) y valores por defecto.
  - `PrestamoTest`: Cálculo automático de fechas límites (7, 14, 21 días), verificación de estados (`ACTIVO`, `DEVUELTO`) y cálculo dinámico de morosidad (`isVencido()`).
- **Capa DAO y Patrón Singleton**:
  - `ConexionTest`: Comprobación del patrón Singleton (`assertSame`), lectura y carga correcta de `db.properties` y cierre seguro de recursos.
  - `PrestamoLogicTest`: Simulación de invariantes de negocio (descuento transaccional de stock al prestar, restitución al devolver, prevención de préstamos sin stock).
- **Controladores y Seguridad**:
  - `AuthFilterLogicTest`: Clasificación de rutas públicas vs privadas y restricción estricta de acciones administrativas a usuarios con rol `ESTUDIANTE`.

### Ejecución de Pruebas por Consola (CLI)
- **Windows (Cmd)**: Haz doble clic o ejecuta:
  ```cmd
  scripts\test.bat
  ```
- **PowerShell**:
  ```powershell
  .\scripts\test.ps1
  ```

### Ejecución de Pruebas en Eclipse Enterprise
1. En el *Project Explorer*, despliega la carpeta `test/`.
2. Haz clic derecho sobre la carpeta `test` (o sobre cualquier clase de prueba individual como `PrestamoTest.java`).
3. Selecciona **Run As** > **JUnit Test**.
4. La pestaña de **JUnit** mostrará la barra verde con el 100% de los tests aprobados.

---

## ✅ Cumplimiento de Rúbrica y Requerimientos

- [x] **Paso 1 (JEE y Entorno)**: Estructura Dynamic Web Project compatible con Eclipse y Apache Tomcat 9.
- [x] **Paso 2 (JSP y JSTL)**: Páginas JSP con directivas JSTL (`c:out`, `c:if`, `c:forEach`, `c:choose`) y diseño responsivo con Bootstrap 5 y CSS personalizado.
- [x] **Paso 3 (Servlets & Sesiones)**: `LoginServlet`, `LibroServlet`, `PrestamoServlet` y `DashboardServlet` implementando peticiones GET/POST y gestión de estado con `HttpSession`.
- [x] **Paso 4 (Capa DAO y JDBC)**: Clases `LibroDAO`, `UsuarioDAO`, `PrestamoDAO` conectadas vía JDBC mediante el patrón Singleton `Conexion.java` y soporte a transacciones ACID.
- [x] **Paso 5 (Patrón MVC)**: Separación estricta de paquetes (`model`, `view` [JSP], `controller`, `dao` y `filter`).
- [x] **Paso 6 (Despliegue JEE)**: Descriptor `web.xml` configurado y generación automatizada de archivo `.WAR` probado y funcional.
- [x] **Testing**: Suite automatizada con 24 tests en JUnit 5 ejecutables por consola y en Eclipse.
