---
publish: true
created: 2025-06-28T21:46
modified: 2025-08-01T16:16:09-05:00
tags:
  - Moodle
  - Guía
  - instalación
---

# Guía de Instalación Técnica de Moodle 4.5.4+ en Ubuntu 22.04.4 LTS

Esta guía detalla el proceso de instalación de Moodle 4.5.4+ en un entorno Ubuntu 22.04.4 LTS, utilizando Apache 2.4.52 como servidor web, MySQL 8.0.42 como base de datos y PHP 8.1.32 como lenguaje de scripting. Se proporcionan los comandos exactos y se recomienda la captura de pantalla en cada paso relevante para una referencia visual.

## 1. Preparación del Sistema y Instalación de Dependencias

Antes de proceder con la instalación de Moodle, es fundamental preparar el sistema operativo y asegurar que todas las dependencias necesarias estén instaladas y actualizadas. Esto garantiza un entorno estable y compatible para Moodle.

### 1.1 Actualización del Sistema

Es una buena práctica comenzar actualizando el índice de paquetes y las aplicaciones instaladas en el sistema. Esto asegura que se están utilizando las versiones más recientes de los paquetes y se corrigen posibles vulnerabilidades.

```bash
sudo apt update && sudo apt upgrade -y
```

Este comando primero actualiza la lista de paquetes disponibles (`sudo apt update`) y luego actualiza todos los paquetes instalados a sus últimas versiones (`sudo apt upgrade -y`). La opción `-y` confirma automáticamente todas las preguntas de instalación.

### 1.2 Instalación del Servidor Web Apache

Apache es el servidor web que Moodle utilizará para servir sus páginas a los usuarios. Se instalará la versión 2.4.52, que es la predeterminada en Ubuntu 22.04.

```bash
sudo apt install apache2 -y
```

Una vez completada la instalación, Apache se iniciará automáticamente. Puedes verificar su estado con el siguiente comando:

```bash
sudo systemctl status apache2
```

Si Apache está funcionando correctamente, verás un estado `active (running)`.

### 1.3 Instalación de PHP y Extensiones Requeridas

Moodle es una aplicación basada en PHP, por lo que es esencial instalar la versión correcta de PHP (8.1.32) junto con las extensiones necesarias para su correcto funcionamiento. Estas extensiones proporcionan funcionalidades específicas que Moodle requiere para operar, como la conexión a la base de datos, el procesamiento de XML, la internacionalización, etc.

```bash
sudo apt install php8.1 libapache2-mod-php8.1 php8.1-mysql php8.1-xml php8.1-intl php8.1-zip php8.1-curl php8.1-gd php8.1-mbstring php8.1-soap php8.1-opcache -y
```

Este comando instala el intérprete de PHP 8.1, el módulo de PHP para Apache (`libapache2-mod-php8.1`), y varias extensiones cruciales para Moodle:

- `php8.1-mysql`: Para la conexión con la base de datos MySQL.
- `php8.1-xml`: Para el procesamiento de datos XML.
- `php8.1-intl`: Para la internacionalización y localización.
- `php8.1-zip`: Para la compresión y descompresión de archivos ZIP.
- `php8.1-curl`: Para realizar solicitudes HTTP.
- `php8.1-gd`: Para el procesamiento de imágenes.
- `php8.1-mbstring`: Para el manejo de cadenas de caracteres multibyte.
- `php8.1-soap`: Para la comunicación con servicios web SOAP.
- `php8.1-opcache`: Para mejorar el rendimiento de PHP mediante el almacenamiento en caché del código compilado.

Después de la instalación de PHP y sus extensiones, el módulo de PHP para Apache se habilitará automáticamente y Apache se reiniciará para aplicar los cambios.

## 2. Configuración de Apache y PHP

Una vez instalados Apache y PHP, es necesario configurarlos adecuadamente para optimizar el rendimiento de Moodle y asegurar que el servidor web apunte correctamente a la instalación de Moodle.

### 2.1 Ajustes de Configuración de PHP

Moodle requiere ciertos ajustes en la configuración de PHP para funcionar correctamente y de manera óptima. Estos ajustes se realizan en el archivo `php.ini`.

Primero, abre el archivo `php.ini` para la versión de PHP utilizada por Apache. En Ubuntu 22.04 con PHP 8.1, este archivo se encuentra típicamente en `/etc/php/8.1/apache2/php.ini`.

```bash
sudo nano /etc/php/8.1/apache2/php.ini
```

Dentro de este archivo, busca y modifica las siguientes directivas para que coincidan con los valores recomendados por Moodle. Si no encuentras alguna directiva, puedes añadirla al final del archivo.

- `max_execution_time`: Define el tiempo máximo en segundos que un script puede ejecutarse. Moodle puede requerir más tiempo para ciertas operaciones, como la instalación o la actualización.
  ```ini
  max_execution_time = 300
  ```

- `memory_limit`: Establece la cantidad máxima de memoria en bytes que un script puede consumir. Moodle, especialmente con muchos usuarios o plugins, puede necesitar más memoria.
  ```ini
  memory_limit = 512M
  ```

- `post_max_size`: Define el tamaño máximo de datos que se pueden enviar a través de un método POST. Esto es importante para la subida de archivos grandes.
  ```ini
  post_max_size = 128M
  ```

- `upload_max_filesize`: Establece el tamaño máximo permitido para los archivos subidos. Es crucial para la subida de recursos y actividades en Moodle.
  ```ini
  upload_max_filesize = 128M
  ```

- `max_input_vars`: Limita el número de variables de entrada que pueden aceptarse. Moodle puede generar un gran número de variables en formularios complejos.
  ```ini
  max_input_vars = 5000
  ```

- `opcache.enable`: Habilita el módulo OPcache, que mejora el rendimiento de PHP almacenando en caché el código precompilado.
  ```ini
  opcache.enable = 1
  ```

- `opcache.memory_consumption`: Asigna la cantidad de memoria para OPcache.
  ```ini
  opcache.memory_consumption = 128
  ```

- `opcache.max_accelerated_files`: Define el número máximo de scripts que pueden ser almacenados en caché por OPcache.
  ```ini
  opcache.max_accelerated_files = 8000
  ```

Después de realizar los cambios, guarda el archivo (Ctrl+O, Enter) y sal del editor (Ctrl+X).

Para que los cambios en `php.ini` surtan efecto, es necesario reiniciar el servicio de Apache.

```bash
sudo systemctl restart apache2
```

### 2.2 Configuración del Virtual Host de Apache para Moodle

Para que Apache sirva Moodle, crearemos un archivo de configuración de Virtual Host. Esto permite a Apache saber dónde encontrar los archivos de Moodle y cómo manejarlos.

Crea un nuevo archivo de configuración para Moodle. Por convención, se nombra `moodle.conf` y se guarda en `/etc/apache2/sites-available/`.

```bash
sudo nano /etc/apache2/sites-available/moodle.conf
```

Dentro de este archivo, añade la siguiente configuración. Asegúrate de reemplazar `your_domain_or_ip` con el nombre de dominio o la dirección IP de tu servidor.

```apache
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html/moodle
    ServerName your_domain_or_ip

    <Directory /var/www/html/moodle/>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

**Explicación de las directivas:**

- `<VirtualHost *:80>`: Indica que este bloque de configuración se aplica a todas las solicitudes en el puerto 80 (HTTP).
- `ServerAdmin webmaster@localhost`: Dirección de correo electrónico del administrador del servidor.
- `DocumentRoot /var/www/html/moodle`: Especifica el directorio raíz donde se encuentran los archivos de Moodle. Aquí es donde colocaremos los archivos de Moodle más adelante.
- `ServerName your_domain_or_ip`: El nombre de dominio o la dirección IP de tu servidor. Los usuarios accederán a Moodle a través de esta dirección.
- `<Directory /var/www/html/moodle/>`: Define las configuraciones específicas para el directorio de Moodle.
  - `Options Indexes FollowSymLinks`: Permite la visualización de directorios y el seguimiento de enlaces simbólicos.
  - `AllowOverride All`: Permite el uso de archivos `.htaccess` para sobrescribir configuraciones de Apache a nivel de directorio. Moodle utiliza esto para sus reglas de reescritura de URL.
  - `Require all granted`: Permite el acceso a todos los usuarios.
- `ErrorLog` y `CustomLog`: Definen las ubicaciones de los archivos de registro de errores y acceso de Apache.

Guarda el archivo (Ctrl+O, Enter) y sal del editor (Ctrl+X).

Ahora, habilita el nuevo Virtual Host y el módulo `rewrite` de Apache, que es necesario para las URLs amigables de Moodle.

```bash
sudo a2ensite moodle.conf
sudo a2enmod rewrite
```

Finalmente, reinicia Apache para que los cambios surtan efecto.

```bash
sudo systemctl restart apache2
```

Con esto, Apache está configurado para servir Moodle. En el siguiente paso, configuraremos la base de datos MySQL.

## 3. Instalación y Configuración de MySQL

Moodle requiere una base de datos para almacenar toda su información, incluyendo usuarios, cursos, actividades y configuraciones. Utilizaremos MySQL 8.0.42 para este propósito.

### 3.1 Instalación del Servidor MySQL

Instala el servidor MySQL utilizando el siguiente comando:

```bash
sudo apt install mysql-server -y
```

Una vez completada la instalación, el servicio MySQL se iniciará automáticamente. Puedes verificar su estado con:

```bash
sudo systemctl status mysql
```

Si MySQL está funcionando correctamente, verás un estado `active (running)`.

### 3.2 Asegurar la Instalación de MySQL

Es crucial asegurar la instalación de MySQL para proteger tu base de datos. El script `mysql_secure_installation` te guiará a través de una serie de preguntas para mejorar la seguridad de tu servidor MySQL.

```bash
sudo mysql_secure_installation
```

Durante la ejecución de este script, se te harán las siguientes preguntas. Las respuestas recomendadas para un entorno de producción son:

1. **VALIDATE PASSWORD COMPONENT? (Press y|Y for Yes, any other key for No):** `n` (A menos que desees forzar políticas de contraseña fuertes, lo cual puede ser útil en entornos de producción, pero para esta guía lo omitiremos para simplificar).
2. **Remove anonymous users? (Press y|Y for Yes, any other key for No) :** `y` (Elimina usuarios anónimos que podrían acceder a tu base de datos sin credenciales).
3. **Disallow root login remotely? (Press y|Y for Yes, any other key for No) :** `y` (Deshabilita el inicio de sesión remoto para el usuario `root`, lo que aumenta la seguridad).
4. **Remove test database and access to it? (Press y|Y for Yes, any other key for No) :** `y` (Elimina la base de datos de prueba predeterminada y sus privilegios).
5. **Reload privilege tables now? (Press y|Y for Yes, any other key for No) :** `y` (Aplica los cambios de privilegios inmediatamente).

### 3.3 Crear la Base de Datos y el Usuario para Moodle

Ahora, crearemos una base de datos específica para Moodle y un usuario con los privilegios necesarios para acceder a ella. Esto es una buena práctica de seguridad para evitar que Moodle utilice el usuario `root` de MySQL.

Accede a la consola de MySQL como usuario `root`:

```bash
sudo mysql -u root -p
```

Se te pedirá la contraseña de `root` de MySQL. Si no estableciste una durante `mysql_secure_installation` (como en esta guía), simplemente presiona Enter.

Una vez dentro de la consola de MySQL, ejecuta los siguientes comandos. Asegúrate de reemplazar `moodle_user` con el nombre de usuario que desees y `your_password` con una contraseña segura.

```sql
CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'moodle_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON moodle.* TO 'moodle_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

**Explicación de los comandos SQL:**

- `CREATE DATABASE moodle ...`: Crea una nueva base de datos llamada `moodle` con la codificación de caracteres `utf8mb4` y la intercalación `utf8mb4_unicode_ci`, que son recomendadas para Moodle para soportar una amplia gama de caracteres.
- `CREATE USER 'moodle_user'@'localhost' ...`: Crea un nuevo usuario de MySQL llamado `moodle_user` que solo puede conectarse desde `localhost` (el mismo servidor donde está MySQL) y le asigna una contraseña.
- `GRANT SELECT,INSERT,... ON moodle.* TO 'moodle_user'@'localhost';`: Otorga los permisos necesarios al `moodle_user` sobre todas las tablas de la base de datos `moodle`.
- `FLUSH PRIVILEGES;`: Recarga los privilegios para que los cambios surtan efecto inmediatamente.
- `EXIT;`: Sale de la consola de MySQL.

Con la base de datos y el usuario creados, estamos listos para descargar e instalar Moodle.

## 4. Descarga e Instalación de Moodle

En esta sección, descargaremos los archivos de Moodle y los colocaremos en el directorio adecuado para que Apache pueda servirlos.

### 4.1 Descarga de los Archivos de Moodle

Descargaremos la versión 4.5.4+ de Moodle desde el sitio oficial. Aunque la búsqueda inicial puede mostrar enlaces a SourceForge, es recomendable obtener la versión más reciente y estable directamente desde `download.moodle.org` o `moodledev.io` para asegurar la compatibilidad y las últimas correcciones.

Para esta guía, utilizaremos el archivo ZIP de Moodle 4.5.x. Puedes descargarlo directamente usando `wget`.

```bash
wget https://sourceforge.net/projects/moodle/files/Moodle/stable405/moodle-4.5.zip/download -O moodle-4.5.zip
```

Este comando descargará el archivo `moodle-4.5.zip` en tu directorio actual.

### 4.2 Descompresión de los Archivos de Moodle

Una vez descargado, descomprime el archivo ZIP en el directorio `/var/www/html/`.

```bash
sudo unzip moodle-4.5.zip -d /var/www/html/
```

Esto creará un directorio llamado `moodle` dentro de `/var/www/html/`, conteniendo todos los archivos de la aplicación Moodle.

Para verificar que los archivos se han descomprimido correctamente, puedes listar el contenido del directorio:

```bash
ls -l /var/www/html/moodle
```

Deberías ver una lista de directorios y archivos que componen la instalación de Moodle.

## 5. Configuración Inicial de Moodle y Permisos

Ahora que los archivos de Moodle están en su lugar, necesitamos crear el directorio de datos de Moodle y establecer los permisos adecuados para que Moodle pueda escribir en él y en su propio directorio de instalación.

### 5.1 Creación del Directorio de Datos de Moodle y Permisos

Moodle necesita un directorio para almacenar los datos de los usuarios, archivos subidos, sesiones, etc. Este directorio debe estar fuera del directorio accesible por el servidor web por razones de seguridad. Crearemos este directorio y le asignaremos los permisos adecuados.

```bash
sudo mkdir /var/www/moodledata
```

Ahora, asigna la propiedad de los directorios de Moodle y `moodledata` al usuario `www-data` (el usuario bajo el cual se ejecuta Apache) y establece los permisos correctos. El directorio `moodledata` necesita permisos de escritura para el servidor web.

```bash
sudo chown -R www-data:www-data /var/www/html/moodle
sudo chmod -R 755 /var/www/html/moodle
sudo chown -R www-data:www-data /var/www/moodledata
sudo chmod -R 777 /var/www/moodledata
```

**Explicación de los permisos:**

- `chown -R www-data:www-data /var/www/html/moodle`: Cambia el propietario y el grupo del directorio de Moodle y su contenido a `www-data`.
- `chmod -R 755 /var/www/html/moodle`: Establece permisos de lectura y ejecución para todos, y escritura para el propietario en el directorio de Moodle. Esto es seguro para los archivos de la aplicación.
- `chown -R www-data:www-data /var/www/moodledata`: Cambia el propietario y el grupo del directorio de datos de Moodle a `www-data`.
- `chmod -R 777 /var/www/moodledata`: Otorga permisos completos (lectura, escritura, ejecución) al propietario, grupo y otros en el directorio `moodledata`. Esto es necesario para que Moodle pueda crear y gestionar archivos en este directorio. **Nota:** Aunque `777` es funcional, en un entorno de producción se recomienda una configuración más restrictiva como `770` o `775` si es posible, asegurándose de que el usuario `www-data` tenga los permisos de escritura necesarios.

### 5.2 Creación del Archivo `config.php`

Moodle necesita un archivo de configuración llamado `config.php` que contiene la información de la base de datos y la ubicación del directorio de datos. Moodle proporciona un archivo de ejemplo llamado `config-dist.php` que podemos copiar y modificar.

```bash
sudo cp /var/www/html/moodle/config-dist.php /var/www/html/moodle/config.php
sudo nano /var/www/html/moodle/config.php
```

Dentro de `config.php`, busca las siguientes líneas y modifícalas con la información de tu base de datos y la ruta a tu directorio de datos de Moodle. Recuerda usar el nombre de usuario y la contraseña que creaste en la sección de MySQL.

```php
<?php  // Moodle configuration file

unset($CFG);
global $CFG;
$CFG = new stdClass();

$CFG->dbtype    = 'mysqli';       // 'pgsql', 'mariadb', 'mysqli', 'sqlsrv', 'oci'
$CFG->dblibrary = 'native';     // 'native' only at the moment
$CFG->dbhost    = 'localhost';    // eg 'localhost' or 'db.someserver.com'
$CFG->dbname    = 'moodle';       // database name, eg 'moodle'
$CFG->dbuser    = 'moodle_user';  // your database username
$CFG->dbpass    = 'your_password';  // your database password
$CFG->prefix    = 'mdl_';         // prefix to use for all table names
$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbport' => '',
  'dbsocket' => '',
  'dbcollation' => 'utf8mb4_unicode_ci',
);

$CFG->wwwroot   = 'http://your_domain_or_ip';
$CFG->dataroot  = '/var/www/moodledata';
$CFG->admin     = 'admin';

$CFG->directorypermissions = 0777;

require_once(__DIR__ . '/lib/setup.php');

// There is no php closing tag in this file, it is intentional.

```

**Asegúrate de cambiar:**

- `$CFG->dbuser`: El usuario de la base de datos que creaste (ej. `moodle_user`).
- `$CFG->dbpass`: La contraseña de ese usuario (ej. `your_password`).
- `$CFG->wwwroot`: La URL de tu sitio Moodle (ej. `http://your_domain_or_ip`). Si estás usando una dirección IP, asegúrate de que sea la correcta.
- `$CFG->dataroot`: La ruta absoluta al directorio de datos de Moodle que creaste (`/var/www/moodledata`).

Guarda el archivo (Ctrl+O, Enter) y sal del editor (Ctrl+X).

### 5.3 Instalación Web de Moodle

Con `config.php` configurado, ahora puedes acceder a Moodle a través de tu navegador web para completar la instalación. Abre tu navegador y navega a la dirección de tu servidor (ej. `http://your_domain_or_ip`).

Serás redirigido a la página de instalación de Moodle. Sigue los pasos en pantalla:

1. **Idioma:** Selecciona tu idioma preferido y haz clic en `Siguiente`.
2. **Rutas:** Confirma las rutas de Moodle y del directorio de datos. Deberían ser correctas si seguiste los pasos anteriores. Haz clic en `Siguiente`.
3. **Base de Datos:** Verifica la configuración de la base de datos. Moodle intentará conectarse con la información proporcionada en `config.php`. Si todo es correcto, haz clic en `Siguiente`.
4. **Licencia:** Lee y acepta la licencia GPL de Moodle. Haz clic en `Continuar`.
5. **Comprobación de Servidor:** Moodle realizará una serie de comprobaciones para asegurarse de que tu servidor cumple con todos los requisitos. Si hay advertencias o errores, deberás solucionarlos antes de continuar. Presta especial atención a las extensiones de PHP faltantes o a los ajustes de `php.ini` que no cumplan con los requisitos. Una vez que todo esté en verde, haz clic en `Continuar`.
6. **Instalación:** Moodle comenzará a instalar las tablas de la base de datos y a configurar los componentes. Este proceso puede tardar varios minutos. Una vez completado, haz clic en `Continuar`.
7. **Cuenta de Administrador:** Crea la cuenta de administrador principal para tu sitio Moodle. Asegúrate de usar una contraseña segura y de recordarla. Haz clic en `Actualizar perfil`.
8. **Configuración de la Página Principal:** Configura el nombre completo y corto de tu sitio Moodle, así como la zona horaria. Haz clic en `Guardar cambios`.

¡Felicidades! Moodle debería estar ahora completamente instalado y listo para usar. Serás redirigido a la página principal de tu nuevo sitio Moodle.

## 6. Documentación Final y Entrega de la Guía

En esta fase, se consolidará toda la información y se presentará la guía completa al usuario.
