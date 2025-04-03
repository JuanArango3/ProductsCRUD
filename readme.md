# Aplicación ProductsCRUD

Aplicación web simple para gestionar productos (CRUD), separada en un frontend basado en JSP y un backend API REST construido con Spring Boot.

## Versión Desplegada

Puedes acceder a una versión desplegada de la aplicación (frontend) en:
[https://productscrud.jmarango.me/](https://productscrud.jmarango.me/)

La API backend correspondiente se encuentra en `https://productscrud.jmarango.me/api/`.

## Ejecución en Local (Usando WARs Pre-compilados)

Sigue estos pasos para ejecutar la aplicación en tu entorno local utilizando los archivos WAR proporcionados.

### Prerrequisitos

Asegúrate de tener instalado lo siguiente:

* **Java Development Kit (JDK):** Versión 17.
* **Apache Tomcat:** Versión 8.x (específicamente probado con 8.5). Descarga desde [Apache Tomcat® - Apache Tomcat 8 Software Downloads](https://tomcat.apache.org/download-80.cgi).
* **MySQL Server:** Versión 8.x. Descarga desde [MySQL Community Downloads](https://dev.mysql.com/downloads/).

### 1. Configuración de la Base de Datos

* Asegúrate de que tu servidor MySQL 8 esté ejecutándose. Por defecto, la aplicación backend (`api.war`) intentará conectarse a `localhost:3306` con el usuario `root` y contraseña `password`. Si se requieren otras credenciales, edita el archivo `application.properties` en el backend (ver sección "Construir desde el Código Fuente").
* Obtén el archivo `init_db.sql`. Este archivo puede estar adjunto en el correo electrónico de entrega o disponible en la sección de "Releases" de este repositorio Git.
* Ejecuta el script `init_db.sql` en tu servidor MySQL para crear el esquema (`products_crud`) y las tablas necesarias. Puedes usar un cliente MySQL o la línea de comandos:
    ```bash
    # Ejemplo usando el cliente mysql (reemplaza <usuario> y <database>)
    # Te pedirá la contraseña
    mysql -u <tu_usuario_mysql> -p products_crud < ruta/a/init_db.sql
    ```

### 2. Despliegue de los WARs

* Descarga los archivos `api.war` (backend) y `ROOT.war` (frontend) proporcionados (ya sea desde el correo o la sección de Releases del repositorio).
* Copia **ambos** archivos (`api.war` y `ROOT.war`) dentro del directorio `webapps` de tu instalación de Apache Tomcat 8.

### 3. Ejecutar Tomcat

* Navega al directorio `bin` dentro de tu instalación de Tomcat 8.
* Inicia el servidor Tomcat.
    * En Linux/macOS: `bash catalina.sh run` (o `bash startup.sh` para ejecutar en segundo plano).
    * En Windows: `catalina.bat run` (o `startup.bat`).
* Tomcat detectará y desplegará automáticamente los archivos WAR copiados en `webapps`.

### 4. Acceder a la Aplicación

* **Frontend (JSP):** Abre tu navegador y ve a `http://localhost:8080/` (Tomcat usa el puerto 8080 por defecto). Deberías ver la interfaz de usuario.
* **Backend (API):** La API estará disponible bajo el context path `/api`. Por ejemplo, la lista de productos estaría en `http://localhost:8080/api/product`.

## Construir desde el Código Fuente (Opcional)

Si deseas compilar la aplicación tú mismo:

1.  **Clona el Repositorio:**
    ```bash
    git clone https://github.com/JuanArango3/ProductsCRUD.git
    cd ProductsCRUD
    ```
2.  **Prerrequisito:** Necesitas tener instalado **Apache Maven** (versión 3.6 o superior).
3.  **Configuración Backend (Opcional):** Si tu base de datos MySQL no está en `localhost:3306` o usa credenciales diferentes a `root`/`password`, edita el archivo `backend/src/main/resources/application.properties` y ajusta las propiedades `spring.datasource.url`, `spring.datasource.username` y `spring.datasource.password`.
4.  **Compila y Empaqueta:** Desde el directorio raíz (`ProductsCRUD-Parent` o el nombre que le hayas dado), ejecuta:
    ```bash
    mvn clean package
    ```
5.  **Encuentra los WARs:**
    * El backend se encontrará en: `backend/target/api.war`
    * El frontend se encontrará en: `frontend/target/ROOT.war`
6.  **Despliega:** Copia estos WARs generados a la carpeta `webapps` de tu Tomcat 8 y procede como en los pasos de "Ejecución en Local".

## Tecnologías Utilizadas

* **Backend:**
    * Java 17
    * Spring Boot 2.7.x
    * Spring Framework 5.3.x
    * Spring Data JPA
    * Spring Security
    * Hibernate 5.6.x
    * MySQL 8 (Driver JDBC)
    * Lombok
    * JJWT (JSON Web Tokens)
    * SpringDoc OpenAPI UI 1.8.0 (para documentación API)
    * Scrimage (para manejo de imágenes)
    * **me.jmarango:spring-base-modules:** Librería personalizada que incluye DTOs comunes (PageInfo, LoginRequest, etc.) y configuración de seguridad JWT auto-activada mediante `@EnableAuthentication`. Provee anotaciones como `@RequireAuth` (requiere token válido) y `@RequireAuthority` (requiere token válido con una autoridad específica).
* **Frontend:**
    * JavaServer Pages (JSP)
    * JavaServer Pages Standard Tag Library (JSTL - `javax.servlet:jstl`)
    * HTML / CSS / JavaScript
    * Bootstrap 5
* **Servidor de Aplicaciones:**
    * Apache Tomcat 8.x
* **Construcción:**
    * Apache Maven
* **Despliegue:**
    * Docker (incluido en el Dockerfile)