---
publish: true
created: 2025-09-10T06:21
modified: 2025-01-16T07:45:44-05:00
---

↩️  [[Teaching/Unisabana/BBDD/BBDD-GuiasPracticas/index|index]]

# Cursos, tips tricks SQL

[Capacítate para el empleo - Administrador de bases de datos relacionales](https://capacitateparaelempleo.org/cursos/view/100146)
[Course - Introducción a SQL y bases de datos relacionales| edX](https://learning.edx.org/course/course-v1:UPValenciaX+SQL101x+1T2025/home)

# Gestión del Servicio MySQL

Antes de ejecutar cualquier consulta, debemos asegurarnos de que el motor de base de datos esté corriendo.

- **Verificar el estado del servicio:** `sudo systemctl status mysql`
- **Iniciar el servicio:** `sudo systemctl start mysql`
- **Habilitar para que inicie con el sistema:** `sudo systemctl enable mysql`
- **Entrar al monitor de MySQL (como root):** `sudo mysql -u root -p`

# Métodos de acceso a MySQL / MariaDB

## Métodos 1  - Tabla de usuarios de MySQL

En la terminal
`sudo mysql`

-u root: Le dice a MySQL que quieres entrar como el usuario llamado "root" dentro de la base de datos.
-p: Le indica al programa que debe pedirte una contraseña de MySQL.
**Cómo funciona:** El servidor de MySQL busca en su propia tabla interna de usuarios (mysql.user), verifica que el usuario root tenga una contraseña definida y la compara con la que tú escribes.
**Uso común:** Se usa en Windows, macOS o en servidores Linux donde el usuario root de la base de datos tiene una contraseña específica distinta a la del sistema operativo.

## Método 2 - Conexión por socket

En la terminal
`mysql -u root -p`

Este método utiliza un plugin llamado auth\_socket (o unix\_socket).
**sudo:** Ejecutas el comando con privilegios del administrador del sistema (Linux/macOS).
**Cómo funciona:** MySQL confía en la seguridad del sistema operativo. Si ya eres el "root" del sistema (o tienes permisos sudo), MySQL asume que tienes permiso para entrar como "root" en la base de datos sin pedirte una contraseña adicional.
**Uso común:** Es el estándar en instalaciones modernas de Ubuntu, Debian y otras distros Linux. Por seguridad, muchas veces el usuario root de MySQL ni siquiera tiene una contraseña definida inicialmente, ya que se espera que entres vía sudo.

# Comandos básicos

## Comandos de Administración de Seguridad (SQL)

- **Crear un nuevo usuario:** `CREATE USER 'nombre_usuario'@'localhost' IDENTIFIED BY 'contraseña';`
- **Otorgar todos los privilegios sobre una base de datos específica:** `GRANT ALL PRIVILEGES ON nombre_bd.* TO 'nombre_usuario'@'localhost';`
- **Actualizar la tabla de privilegios:** `FLUSH PRIVILEGES;`
- **Eliminar un usuario:**  `DROP USER 'nombre_usuario'@'localhost';`

## Definición de Datos (DDL) y Exploración

- **Listar bases de datos existentes:** `SHOW DATABASES;`
- **Seleccionar base de datos para trabajar:** `USE nombre_proyecto;`
- **Eliminar una base de datos completa:** `DROP DATABASE nombre_base_datos;`
- **Crear una base de datos:** `CREATE DATABASE nombre_proyecto;`
- **Listar tablas de la base de datos:** `SHOW TABLES;`
- **Eliminar una tabla:** `DROP TABLE nombre_tabla;`
- **Ver la estructura de una tabla (columnas, tipos, llaves):** `DESCRIBE nombre_tabla;`
- **Eliminar una columna (usando ALTER):** `ALTER TABLE nombre_tabla DROP COLUMN nombre_columna;`

## Manipulación de Datos (DML)

Fundamentales para las entregas de consultas y carga de datos.

- **Insertar datos:** `INSERT INTO nombre_tabla (columna1, columna2) VALUES (valor1, valor2);`
- **Consultar datos (Básico):** `SELECT * FROM nombre_tabla;`
- **Actualizar registros:** `UPDATE nombre_tabla SET columna1 = valor nuevo WHERE id = 1;`
- **Eliminar registros:** `DELETE FROM nombre_tabla WHERE id = 1;`

**NOTA:**

- **DROP:** Elimina la tabla completa (la estructura y los datos desaparecen).
- **TRUNCATE:** Vacía la tabla (borra los datos, pero mantiene la estructura/columnas para nuevos registros).
- **DELETE:** Borra registros específicos (usualmente con un `WHERE`), pero es una operación más lenta porque registra cada fila eliminada.

## Copias de Seguridad y Restauración (Terminal de Ubuntu)

Evitar pérdida de avances en su proyecto.

- **Exportar base de datos (Backup):** `mysqldump -u usuario -p nombre_bd > respaldo.sql`
- **Importar base de datos:** `mysql -u usuario -p nombre_bd < archivo_a_importar.sql`

# Cambiar la contraseña de un usuario en concreto:

Accede como usuario root a mysql:
`sudo mysql` o `mysql -u root -p`

Luego aparecerá interfaz de MySQL-MariaDB:
`MariaDB [(none)]> select user, host from mysql.user;`

Debería mostrar una lista de usuarios como esta:
![500](https://i.imgur.com/06m4l9Q.png)

En base al usuario que se necesite, cambiamos la contraseña del usuario

`ALTER USER ‘nombreUsuario’@’localhost’ IDENTIFIED BY ‘NuevaContraseña’;`

# Reconfigurar phpmyadmin

Dentro de la terminal ejecute este comando:
`sudo dpkg-reconfigure phpmyadmin`

Lea las indicaciones, por defecto debería estar:
Paso 1:
![900](https://i.imgur.com/tZboVC3.png)
Paso 2:
![900](https://i.imgur.com/d8Th0Al.png)
Paso 3:
![900](https://i.imgur.com/IMnJC84.png)
Paso 4:
![900](https://i.imgur.com/eip0AXW.png)
Paso 5:
![1200](https://i.imgur.com/xfInNxm.png)
Paso 6: Aquí ponga la nueva contraseña para el phpmyadmin
![1200](https://i.imgur.com/FVTmr8m.png)

Paso 7: Confirme contraseña:
![](https://i.imgur.com/oMtl1uA.png)

Paso 8: Usuario para ser el administrador de phpmyadmin
![](https://i.imgur.com/6yfuKEx.png)

Paso 9: Seleccionar el servidor web, debe ser apache2
![1200](https://i.imgur.com/PNiLh3M.png)

Listo, mensaje de resumen:
![900](https://i.imgur.com/SneHZN3.png)

# Comentarios en php

<?php
    echo 'Esto es una prueba\n'; // Esto es un comentario de una sola línea, estilo c++
    /* Esto es un comentario de
       varias líneas */
    echo 'Esto es otra prueba\n';
    echo 'Y una prueba final\n'; # Esto es un comentario de una sola línea estilo shell
?>123

# Normalización, entidades y relaciones

- **Conjuntos de entidades fuertes:**  Se crea una tabla con los mismos atributos simples. Los atributos compuestos se "aplanan" en sus componentes individuales.
- **Atributos multivalorados:**  Se crea una tabla separada que incluye la clave primaria de la entidad original y el atributo multivalorado.
- **Conjuntos de entidades débiles:**  Se crea una tabla que incluye la clave primaria de la entidad fuerte más el discriminador de la débil.
- **Conjuntos de relaciones:**
  - _Para relaciones  M:N_ , se crea una tabla con las claves primarias de ambos conjuntos y los atributos descriptivos de la relación.
  - _Para relaciones  1:N_  con participación total en el lado "muchos", se puede optimizar combinando el esquema de la relación con el esquema de la entidad del lado "muchos".

↩️  [[Teaching/Unisabana/BBDD/BBDD-GuiasPracticas/index|index]]
