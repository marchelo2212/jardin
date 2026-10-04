---
publish: true
created: 2025-09-09T09:43
modified: 2025-09-09T19:42:12-05:00
---

↩️  [[Teaching/Unisabana/BBDD/BBDD-GuiasPracticas/index|index]]

# Guía 01 - Instalación LAMP con MariaDB 10  Autor

# 1) Actualiza e instala Apache

```bash
sudo apt update 
sudo apt -y install apache2 
sudo systemctl enable --now apache2 
#(Opcional si usas UFW) 
sudo ufw allow 'Apache Full'
```

Prueba en el navegador: `http://localhost/` o `http://<IP>`

# 2) Instala PHP (y extensiones típicas)

```bash
sudo apt -y install php libapache2-mod-php php-mysql php-cli php-curl php-xml php-mbstring php-zip php-gd 

sudo systemctl restart apache2 

php -v

```

# 3) Instala MariaDB (10.11 LTS) y asegúrala

```Bash
sudo apt -y install mariadb-server mariadb-client 
sudo systemctl enable --now mariadb 
sudo mysql_secure_installation
```

En `mysql_secure_installation` acepta endurecer contraseñas, eliminar usuarios anónimos y deshabilitar acceso root remoto.

# 4) Crea un usuario y una base de datos de pruebas

```bash
sudo mariadb
```

Dentro de CLI:

```MySQL
CREATE DATABASE prueba CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

CREATE USER 'dev'@'localhost' IDENTIFIED BY 'TuPassFuerte!'; 

GRANT ALL PRIVILEGES ON prueba.* TO 'dev'@'localhost'; 

FLUSH PRIVILEGES; 

EXIT;
```

Prueba login:

```MySQL
mysql -u dev -p prueba
```

Te pedirá la contraseña del usuario de la base de datos que creaste (DB=dev y pass = TuPassFuerte!) y luego estarán dentro de mysql.

Mostrará algo similar a esto:
![](https://i.imgur.com/OURBy4Z.png)

Para salir de MariaDB (MySQL)

```MySQL
exit;
```

# 5) Instala phpMyAdmin

```bash
sudo apt -y install phpmyadmin
```

- Cuando pregunte por servidor web, marca **apache2** (barra espaciadora → asterisco) y **OK**.
- Si pregunta por **dbconfig-common**, di **Sí** y pon una clave para el usuario interno `phpmyadmin`.

**OJO:** En caso de que no se haya habilitado la conf de Apache automáticamente te mostrará una imgen así:
![700](https://i.imgur.com/VuyyXES.png)

Para solucionar aplica esto:

```bash
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf

sudo a2enconf phpmyadmin 

sudo phpenmod mbstring 

sudo systemctl reload apache2
```

Abre: `http://localhost/phpmyadmin`

![600](https://i.imgur.com/fG4XZ8H.png)

Entra con `dev` / `TuPassFuerte!` (o con el usuario y pass que hayas creado).
![700](https://i.imgur.com/UYsGM2P.png)

# 6) Archivo PHP de prueba (para verificar PHP y MySQL)

Ir a la ubicación: /var/www/html y crear un archivo "info.php" con esta información

```bash
cd /var/www/html

sudo touch info.php

```

modifica el archivo creado info.php con nano

```bash
sudo nano info.php
```

Aquí el código a ingresar a info.php

```php
<?php phpinfo(); ?>

```

Prueba en el navegador:

- `http://localhost/info.php` (deberías ver phpinfo)

![700](https://i.imgur.com/xWTbUfn.png)

# 7) Permisos básicos en el DocumentRoot (si vas a desplegar código)

```bash
sudo usermod -aG www-data $USER && \

sudo chown -R $USER:www-data /var/www/html && \

find /var/www/html -type d -exec chmod 775 {} \; && \

find /var/www/html -type f -exec chmod 664 {} \;
```

# 8) Servicios al arranque y estado (sanidad)

```bash
systemctl status apache2 

systemctl status mariadb
```

**NOTA:** Por si acaso para salir luego de que les muestre el estatus de apache2 o de mariadb deben salir presionando ctrl+c

# 9) En caso que exista errores

En el caso de que existan errores mostrando phpmyadmin desde el servidor local (localhost) en el navegador web, podemos revisar el log de error de apache para revisar los detalles e investigar en internet el error, su causa y su solución.

_No es recomendable hacer caso a todo lo que dice ChatGPT ya que puede darnos instrucciones contraproducentes._

# 10) Resultado esperado

![](https://i.imgur.com/kZ7goNJ.png)

# 11) Comprobación de conexión con la base de datos

dentro de la ruta: /var/www/html/ crea un documento "test\_sql.php"

```bash
sudo touch test_sql.php
```

Modifica con nano el archivo creado:

```bash
sudo nano  test_sql.php
```

Aquí lo que debe contener el archivo test\_sql.php

```php
<?php
try {
    $pdo = new PDO(
        'mysql:host=localhost;dbname=prueba;charset=utf8mb4', //Ubicar los datos de su base de datos de mariadb
        'dev',   //Usuario de base de datos
        'Marcelo!',  //Contraseña de base de datos
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
    $stmt = $pdo->query("SELECT 'OK LAMP + MariaDB + PHP' AS mensaje");
    echo $stmt->fetch(PDO::FETCH_ASSOC)['mensaje'];
} catch (PDOException $e) {
    echo "Error de conexión: " . $e->getMessage();
}
```

Recuerda que para que se pueda revisar el documento debes de haber realizado el **paso 7** de este manual, si aún no lo ha hecho o si en caso de falla, puede aplicar nuevamente este paso.

`http://localhost/test_sql.php`

El resultado debería ser una ventana de navegador web con el texto:

![](https://i.imgur.com/UxQjJMQ.png)

**OK LAMP + MariaDB + PHP**

↩️  [[Teaching/Unisabana/BBDD/BBDD-GuiasPracticas/index|index]]
