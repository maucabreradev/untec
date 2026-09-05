# 📖 Guía de Configuración: Eclipse Enterprise Edition y Apache Tomcat 9

Esta guía detalla los pasos exactos para importar, configurar y ejecutar el proyecto **Biblioteca Digital UNTEC** en **Eclipse Enterprise Edition** con **Apache Tomcat 9** y **MySQL**.

---

## 1. Requisitos Previos

1. **Java JDK 8, 11, 17 o 21** instalado y configurado en las variables de entorno (`JAVA_HOME`).
2. **Eclipse IDE for Enterprise Java and Web Developers** (anteriormente Eclipse Java EE).
3. **Apache Tomcat 9** descargado y descomprimido en tu equipo (ej. `C:\apache-tomcat-9.0.x`).
4. **Servidor MySQL** (MySQL Server 8.0, XAMPP o WampServer) ejecutándose en el puerto 3306.

---

## 2. Inicialización de la Base de Datos

Antes de iniciar la aplicación en Tomcat:

1. Abre tu cliente MySQL favorito (MySQL Workbench, DBeaver, phpMyAdmin o terminal).
2. Ejecuta el archivo SQL ubicado en el proyecto:
   ```
   sql/database.sql
   ```
3. Verifica que la base de datos `untec_biblioteca` y las tablas `usuarios`, `libros` y `prestamos` hayan sido creadas con sus registros iniciales.
4. Si tu usuario o contraseña de MySQL no es `root` con clave en blanco, edita el archivo:
   ```
   src/db.properties
   ```

---

## 3. Importación del Proyecto en Eclipse

1. Abre **Eclipse Enterprise Edition**.
2. Ve al menú superior: **File** > **Import...**
3. En la ventana de importación, expande la carpeta **General** y selecciona **Existing Projects into Workspace**. Haz clic en **Next**.
4. En **Select root directory**, haz clic en **Browse...** y selecciona la carpeta raíz del repositorio:
   ```
   c:\Users\mauro\Development\maucabreradev\untec
   ```
5. Asegúrate de que aparezca marcado el proyecto `untec-biblioteca`.
6. Haz clic en **Finish**.

> [!NOTE]
> Eclipse reconocerá automáticamente el proyecto como un **Dynamic Web Project** gracias a los archivos `.project`, `.classpath` y `.settings/` ya incluidos.

---

## 4. Configurar el Servidor Apache Tomcat 9 en Eclipse

Si aún no has vinculado Apache Tomcat en Eclipse:

1. Abre la pestaña **Servers** en la parte inferior de Eclipse (si no la ves, ve a **Window** > **Show View** > **Servers**).
2. Haz clic en el enlace azul: *"No servers are available. Click this link to create a new server..."* (o clic derecho en el panel > **New** > **Server**).
3. En la lista de servidores:
   - Despliega la carpeta **Apache**.
   - Selecciona **Tomcat v9.0 Server**.
   - Haz clic en **Next**.
4. En el campo **Tomcat installation directory**, haz clic en **Browse...** y selecciona la carpeta donde tienes descomprimido Tomcat 9.
5. Selecciona tu **JRE / JDK** instalado.
6. En la pantalla **Add and Remove**, selecciona `untec-biblioteca` en la columna izquierda y pulsa **Add >** para moverlo a la columna derecha (*Configured*).
7. Haz clic en **Finish**.

---

## 5. Ejecutar la Aplicación

1. En el panel **Servers**, haz clic derecho sobre **Tomcat v9.0 Server at localhost** y selecciona **Start** (o haz clic en el ícono verde de Play).
2. Alternativamente, puedes hacer clic derecho sobre el proyecto `untec-biblioteca` > **Run As** > **Run on Server**.
3. Abre tu navegador web favorito (Chrome, Edge o Firefox) e ingresa a:
   ```
   http://localhost:8080/untec-biblioteca/
   ```
4. El sistema te redirigirá a la pantalla de login institucional.

---

## 6. Probar las Funcionalidades

### A. Prueba como Administrador / Bibliotecario
- **Correo**: `admin@untec.edu`
- **Contraseña**: `admin123`
*(O pulsa el botón "Admin / Biblio" para autocompletar)*
- **Acciones a verificar**:
  1. Observa el panel de métricas con títulos, stock de ejemplares y préstamos activos.
  2. Haz clic en **Nuevo Libro** y agrega un ejemplar con su ISBN, autor y stock.
  3. Revisa la pestaña **Control de Préstamos** y registra la devolución de un libro prestado. Verifica cómo el stock disponible se repone automáticamente.

### B. Prueba como Estudiante
- **Correo**: `estudiante@untec.edu`
- **Contraseña**: `alumno123`
*(O pulsa el botón "Estudiante" para autocompletar)*
- **Acciones a verificar**:
  1. Ingresa al **Catálogo de Libros**, filtra por categoría o escribe una palabra en el buscador.
  2. Pulsa **Solicitar Préstamo** en un libro disponible y confirma el plazo.
  3. Ve a **Mis Préstamos** y observa cómo figura con su fecha límite y estado `ACTIVO`.
  4. Si cierras sesión e ingresas como Administrador, verás que el stock de ese libro bajó en 1 y figura en los préstamos por cobrar.

---

## 7. Exportación del Archivo `.WAR` desde Eclipse

1. Haz clic derecho sobre el proyecto `untec-biblioteca`.
2. Selecciona **Export** > **WAR file**.
3. En **Destination**, elige la carpeta deseada (ej. `C:\despliegues\biblioteca-untec.war`).
4. Selecciona el runtime **Apache Tomcat v9.0** y marca **Overwrite existing file**.
5. Pulsa **Finish**.

---

## 8. Ejecución de Pruebas Unitarias (JUnit 5) en Eclipse

1. En la vista **Package Explorer** o **Project Explorer**, despliega la carpeta de fuentes de prueba:
   ```
   untec-biblioteca/test
   ```
2. Haz clic derecho sobre la carpeta `test` o sobre un paquete específico (ej. `cl.untec.biblioteca.model`).
3. Selecciona **Run As** > **JUnit Test** (o usa el atajo `Alt + Shift + X, T`).
4. Se abrirá la vista **JUnit** mostrando la barra verde indicando que todos los tests fueron superados satisfactoriamente.

> [!TIP]
> También puedes correr todas las pruebas sin abrir Eclipse ejecutando el archivo `scripts\test.bat` (o `.\scripts\test.ps1` en PowerShell).
