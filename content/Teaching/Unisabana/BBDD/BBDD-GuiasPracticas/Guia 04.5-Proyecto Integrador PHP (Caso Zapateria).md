---
publish: true
created: 2025-09-30T10:49
modified: 2025-09-30T12:13:12-05:00
---

↩️ [[Teaching/Unisabana/BBDD/BBDD-GuiasPracticas/index|index]]

# Guía 04.5 - Proyecto Integrador PHP (Caso Zapatería)

_Habiendo superado la Guía 4 (donde aprendimos a conectar de forma segura el backend a la base de datos usando PDO y sentencias preparadas), ahora daremos el siguiente paso: integrar esos scripts de conexión con una interfaz de usuario real en HTML para capturar datos._

## Objetivo

1. Crear la base de datos `zapateria_db`.
2. Crear tablas mínimas: `marca` y `producto`.
3. Insertar algunos datos de prueba.
4. Construir un formulario HTML + PHP (PDO) para **agregar productos**.

## A) SQL

```sql
-- 01) Crear la base de datos (si no existe ya).
-- utf8mb4 es el conjunto de caracteres más recomendado en MySQL/MariaDB.
CREATE DATABASE IF NOT EXISTS zapateria_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- OJO:Asigne la BBDD a un usuario o cree un usuario.
-- ACCEDA CON ESE USUARIO A MYSQL

-- Seleccionamos la BD recién creada
USE zapateria_db;

-- 02) Crear tabla "marca"
-- id_marca es PRIMARY KEY con AUTO_INCREMENT (se genera automáticamente).
-- nombre es único: no puede haber dos marcas con el mismo nombre.
CREATE TABLE IF NOT EXISTS marca (
  id_marca INT AUTO_INCREMENT PRIMARY KEY,
  nombre   VARCHAR(60) NOT NULL UNIQUE
);

-- 03) Crear tabla "producto"
-- Se definen validaciones con CHECK (precio >= 0 y stock >= 0).
-- id_marca es una clave foránea que referencia a marca(id_marca).
CREATE TABLE IF NOT EXISTS producto (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre      VARCHAR(100) NOT NULL,
  talla       DECIMAL(4,1) NOT NULL,           -- Ejemplo: 36.0, 42.5
  precio      DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
  stock       INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
  id_marca    INT NOT NULL,
  CONSTRAINT fk_prod_marca
    FOREIGN KEY (id_marca) REFERENCES marca(id_marca)
    ON UPDATE CASCADE     -- Si cambia id_marca en la tabla marca, se actualiza aquí
    ON DELETE RESTRICT    -- No permite borrar una marca si hay productos asociados
);

-- 04) Insertar algunos datos de prueba en marcas
INSERT INTO marca (nombre) VALUES
  ('Nike'), ('Adidas'), ('Puma');

-- 05) Insertar productos iniciales
INSERT INTO producto (nombre, talla, precio, stock, id_marca) VALUES
  ('Zapatilla Runner X', 41.0, 299.90, 8, 1),
  ('Zapatilla Urbana Pro', 38.0, 199.50, 12, 2),
  ('Botín Classic', 39.0, 249.00, 5, 3);
```

## B) Archivos PHP/HTML con comentarios

Se deben crear en dentro de la ruta: /var/www/html/zapateria "
zapateria es una nueva carpeta que se ha creado para este proyecto y se deben cargar todos los documentos.

### 1) `config.php`

```php
<?php
// config.php: centraliza la conexión a la BD

// Parámetros de conexión
$DB_HOST = 'localhost';
$DB_NAME = 'zapateria_db';
$DB_USER = 'dev';      // Cambiar por el usuario real
$DB_PASS = 'devpass';  // Cambiar por la contraseña real

// DSN = cadena de conexión para PDO
$dsn = "mysql:host=$DB_HOST;dbname=$DB_NAME;charset=utf8mb4";

// Opciones para un PDO más seguro y robusto
$options = [
  PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION, // Lanza excepciones en errores
  PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,       // Devuelve arrays asociativos
  PDO::ATTR_EMULATE_PREPARES   => false,                  // Usa consultas preparadas nativas
];

// Intentar conexión
try {
  $pdo = new PDO($dsn, $DB_USER, $DB_PASS, $options);
} catch (PDOException $e) {
  exit("❌ Error de conexión con la base de datos.");
}
```

### 2) `index.html`

```html
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Zapatería PasoFirme - Agregar producto</title>
</head>
<body>
  <h1>Zapatería PasoFirme</h1>
  <h2>Agregar producto</h2>

  <!-- Formulario que envía datos a guardar_producto.php usando POST -->
  <form method="post" action="guardar_producto.php">
    <!-- Campo de texto -->
    <label for="nombre">Nombre del producto</label>
    <input id="nombre" name="nombre" type="text" required maxlength="100">

    <!-- Campo numérico decimal con step=0.5 -->
    <label for="talla">Talla</label>
    <input id="talla" name="talla" type="number" step="0.5" min="20" max="50" required>

    <!-- Campo numérico decimal con step=0.01 -->
    <label for="precio">Precio</label>
    <input id="precio" name="precio" type="number" step="0.01" min="0" required>

    <!-- Stock inicial, valor por defecto 0 -->
    <label for="stock">Stock</label>
    <input id="stock" name="stock" type="number" step="1" min="0" value="0">

    <!-- Select con las marcas predefinidas -->
    <label for="id_marca">Marca</label>
    <select id="id_marca" name="id_marca" required>
      <option value="">-- Selecciona --</option>
      <option value="1">Nike</option>
      <option value="2">Adidas</option>
      <option value="3">Puma</option>
    </select>

    <button type="submit">Guardar</button>
  </form>
</body>
</html>
```

### 3) `guardar_producto.php`

```php
<?php
require __DIR__ . '/config.php'; // Importa la conexión PDO

// Captura de datos enviados por el formulario
$nombre  = trim($_POST['nombre'] ?? '');
$talla   = filter_input(INPUT_POST, 'talla',  FILTER_VALIDATE_FLOAT);
$precio  = filter_input(INPUT_POST, 'precio', FILTER_VALIDATE_FLOAT);
$stock   = filter_input(INPUT_POST, 'stock',  FILTER_VALIDATE_INT);
$idMarca = filter_input(INPUT_POST, 'id_marca', FILTER_VALIDATE_INT);

// Validaciones básicas
if ($nombre === '' || $talla === false || $precio === false || $precio < 0 || $stock === false || $stock < 0 || !$idMarca) {
  exit('❌ Datos inválidos. <a href="index.html">Volver</a>');
}

// Preparar sentencia SQL segura con placeholders
$sql = "INSERT INTO producto (nombre, talla, precio, stock, id_marca)
        VALUES (:nombre, :talla, :precio, :stock, :id_marca)";

// Ejecutar consulta con parámetros
$stmt = $pdo->prepare($sql);
$stmt->execute([
  ':nombre'   => $nombre,
  ':talla'    => number_format($talla, 1, '.', ''), // normaliza formato 41 → 41.0
  ':precio'   => number_format($precio, 2, '.', ''), // normaliza decimales
  ':stock'    => $stock,
  ':id_marca' => $idMarca
]);

echo "✅ Producto guardado correctamente. <a href='index.html'>Agregar otro</a>";
```

### 4) `listado.php`

```php
<?php
// Importa el archivo de configuración, donde está la conexión PDO ($pdo)
require __DIR__ . '/config.php';

// Realiza una consulta SQL con JOIN:
// - Trae todos los productos de la tabla "producto" (alias p)
// - Junta la tabla "marca" (alias m) para obtener el nombre de la marca
// - Usa p.id_marca = m.id_marca como condición de relación
// - Ordena de forma descendente por id_producto (el último insertado aparece primero)
$stmt = $pdo->query("
  SELECT p.id_producto, p.nombre, p.talla, p.precio, p.stock, m.nombre AS marca
  FROM producto p
  JOIN marca m ON m.id_marca = p.id_marca
  ORDER BY p.id_producto DESC
");

// fetchAll() obtiene todos los resultados de la consulta en un arreglo asociativo
$rows = $stmt->fetchAll();
?>
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Listado de productos</title>
</head>
<body>
  <h1>Productos registrados</h1>

  <!-- Tabla HTML para mostrar los resultados -->
  <table border="1" cellpadding="6" cellspacing="0">
    <tr>
      <!-- Encabezados de la tabla -->
      <th>ID</th>
      <th>Nombre</th>
      <th>Talla</th>
      <th>Precio</th>
      <th>Stock</th>
      <th>Marca</th>
    </tr>

    <!-- Bucle PHP: recorre cada fila ($r) de resultados obtenidos -->
    <?php foreach ($rows as $r): ?>
      <tr>
        <!-- Cada celda de la tabla corresponde a un atributo del producto -->
        <!-- (int) convierte el valor a número entero, por seguridad -->
        <td><?= (int)$r['id_producto'] ?></td>

        <!-- htmlspecialchars convierte caracteres especiales en HTML seguro,
             evitando inyecciones o que el navegador ejecute código -->
        <td><?= htmlspecialchars($r['nombre']) ?></td>
        <td><?= htmlspecialchars($r['talla']) ?></td>
        <td><?= htmlspecialchars($r['precio']) ?></td>

        <!-- Stock mostrado como número entero -->
        <td><?= (int)$r['stock'] ?></td>

        <!-- Nombre de la marca obtenido del JOIN -->
        <td><?= htmlspecialchars($r['marca']) ?></td>
      </tr>
    <?php endforeach; ?>
  </table>
</body>
</html>
```

Luego de esto realice:

**1)** Responda la siguientes preguntas:

1. ¿Cómo se podría agregar una nueva marca de zapatos?
2. ¿Cómo se podría agregar un nuevo producto?

**2)** Agregue una nueva marca de zapatos y un nuevo producto para esta marca. Use phpmyadmin.

**3)** Emplee el formulario creado para agregar un nuevo producto para la marca que agregó ¿Ha funcionado? ¿Si, no por qué?. Revise el archivo index.html con detalle.

**4)** ¿Qué se debería hacer para mejorar la situación actual?

## Solución Ejercicio 1: Formulario Maestro de Marcas (`nueva_marca.php`)

Este archivo "nueva\_marca.php" permite que la base de datos crezca sin tocar el código SQL manualmente.

```
<?php
require __DIR__ . '/config.php';

$mensaje = "";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nombreMarca = trim($_POST['nombre_marca'] ?? '');

    if ($nombreMarca !== '') {
        try {
            $sql = "INSERT INTO marca (nombre) VALUES (:nombre)";
            $stmt = $pdo->prepare($sql);
            $stmt->execute([':nombre' => $nombreMarca]);
            $mensaje = "✅ Marca '{$nombreMarca}' registrada con éxito.";
        } catch (PDOException $e) {
            // Manejo de error para el CONSTRAINT UNIQUE del nombre
            if ($e->getCode() == 23000) {
                $mensaje = "❌ Error: La marca ya existe.";
            } else {
                $mensaje = "❌ Error inesperado: " . $e->getMessage();
            }
        }
    }
}
?>
<!doctype html>
<html lang="es">
<head><meta charset="utf-8"><title>Nueva Marca</title></head>
<body>
    <h1>Registrar Nueva Marca</h1>
    <p><?php echo $mensaje; ?></p>
    <form method="post">
        <label>Nombre de la marca:</label>
        <input type="text" name="nombre_marca" required>
        <button type="submit">Guardar Marca</button>
    </form>
    <br><a href="index.php">Volver al Formulario de Productos</a>
</body>
</html>
```

## Solución Ejercicio 2: El Select Dinámico (`index.php`)

El paso de un archivo `.html` estático a uno `.php` dinámico representa la transición de un diseño rígido a una arquitectura orientada a datos. Al integrar una consulta `SELECT` de PDO directamente en la generación del formulario, garantizamos que la interfaz de usuario sea un reflejo fiel y en tiempo real del estado de la base de datos. Esto elimina el riesgo de **inconsistencia de datos**, ya que cualquier nueva marca registrada mediante SQL o `nueva_marca.php` aparecerá automáticamente en el menú desplegable sin necesidad de modificar manualmente el código fuente. Además, el uso de `htmlspecialchars()` en esta solución es una práctica de seguridad esencial para prevenir ataques de Inyección de Script (XSS), asegurando que el contenido proveniente de la base de datos se renderice únicamente como texto plano en el navegador del cliente.

```
<?php
require __DIR__ . '/config.php';

// Consultar todas las marcas registradas
$stmt = $pdo->query("SELECT id_marca, nombre FROM marca ORDER BY nombre ASC");
$marcas = $stmt->fetchAll();
?>
<!doctype html>
<html lang="es">
<head><meta charset="utf-8"><title>Zapatería PasoFirme - Agregar</title></head>
<body>
  <h1>Zapatería PasoFirme</h1>
  <h2>Agregar nuevo producto</h2>

  <form method="post" action="guardar_producto.php">
    <label for="nombre">Nombre:</label>
    <input id="nombre" name="nombre" type="text" required><br><br>

    <label for="talla">Talla:</label>
    <input id="talla" name="talla" type="number" step="0.5" required><br><br>

    <label for="precio">Precio:</label>
    <input id="precio" name="precio" type="number" step="0.01" required><br><br>

    <label for="stock">Stock:</label>
    <input id="stock" name="stock" type="number" value="0"><br><br>

    <label for="id_marca">Marca:</label>
    <select id="id_marca" name="id_marca" required>
      <option value="">-- Seleccione una marca --</option>
      <?php foreach ($marcas as $m): ?>
        <option value="<?= $m['id_marca'] ?>">
            <?= htmlspecialchars($m['nombre']) ?>
        </option>
      <?php endforeach; ?>
    </select><br><br>

    <button type="submit">Guardar Producto</button>
  </form>
  <hr>
  <a href="nueva_marca.php">Registrar una marca que no esté en la lista</a>
</body>
</html>
```

---

## Solución Ejercicio 3: Evolución del Modelo (Categoría)

3.1) SQL: Creación de tabla y Alteración

```
-- Crear tabla categoría
CREATE TABLE IF NOT EXISTS categoria (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL UNIQUE
);

-- Insertar datos iniciales
INSERT INTO categoria (nombre) VALUES ('Deportivo'), ('Casual'), ('Formal');

-- Alterar tabla producto para incluir la Foreign Key
ALTER TABLE producto 
ADD COLUMN id_categoria INT NOT NULL,
ADD CONSTRAINT fk_prod_cat 
FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria);
```

3.2) Actualización de `guardar_producto.php`

Deben añadir la captura del nuevo campo:

PHP

```
// ... después de capturar $idMarca ...
$idCategoria = filter_input(INPUT_POST, 'id_categoria', FILTER_VALIDATE_INT);

// Actualizar el INSERT
$sql = "INSERT INTO producto (nombre, talla, precio, stock, id_marca, id_categoria)
        VALUES (:nombre, :talla, :precio, :stock, :id_marca, :id_categoria)";

$stmt->execute([
  ':nombre'   => $nombre,
  ':talla'    => $talla,
  ':precio'   => $precio,
  ':stock'    => $stock,
  ':id_marca' => $idMarca,
  ':id_categoria' => $idCategoria // Nuevo parámetro
]);
```

↩️ [[Teaching/Unisabana/BBDD/BBDD-GuiasPracticas/index|index]]
