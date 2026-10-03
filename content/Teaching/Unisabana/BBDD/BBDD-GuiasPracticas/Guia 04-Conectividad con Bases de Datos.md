---
publish: true
created: 2026-04-16T09:58:07.000Z
modified: 2026-04-16T09:58:07.000Z
---

↩️ [[Teaching/Unisabana/BBDD/BBDD-GuiasPracticas/index|index]]

# Guía 04 - Conectividad con Bases de Datos

**Propósito:** Comprender e implementar la conexión entre aplicaciones de software y sistemas gestores de bases de datos (SGBD) utilizando diversos lenguajes de programación.

## Parte A: Fundamentos Teóricos

### 1. ¿Qué es la Conectividad de Bases de Datos?

La conectividad a bases de datos es el mecanismo mediante el cual una aplicación cliente (ya sea web, de escritorio o móvil) se comunica con un servidor de bases de datos. Este proceso permite enviar instrucciones SQL, recuperar conjuntos de resultados y gestionar transacciones de forma programática.

### 2. Controladores (Drivers) y APIs

Para que un lenguaje de programación se comunique con un SGBD específico, requiere un "puente" o traductor.

- **Controladores Nativos:** Específicos para un SGBD (ej. `mysql-connector` para MySQL, `psycopg2` para PostgreSQL).
- **Estándares de Conectividad:**
  - **JDBC (Java Database Connectivity):** Estándar de Java para interactuar con bases de datos relacionales.
  - **ODBC (Open Database Connectivity):** Estándar de C/C++ adoptado por múltiples ecosistemas.

### 3. La Cadena de Conexión (Connection String)

Es una cadena de texto que contiene los parámetros necesarios para establecer la conexión. Comúnmente incluye:

- **Host/Servidor:** Dirección IP o dominio (ej. `localhost` o `127.0.0.1`).
- **Puerto:** Puerto de escucha del SGBD (ej. `3306` para MySQL, `5432` para PostgreSQL).
- **Base de Datos:** Nombre de la base de datos objetivo.
- **Usuario y Contraseña:** Credenciales de acceso.

_Importante:_ Por seguridad, las credenciales nunca deben estar "quemadas" (hardcoded) en el código fuente. Se deben utilizar variables de entorno (`.env`).

## Parte B: Conectividad en Múltiples Lenguajes

A continuación, se presentan ejemplos de cómo establecer una conexión en varios de los lenguajes más utilizados en la industria, comenzando por PHP y MySQL, que es el entorno LAMP central de este curso.

### 1. PHP (usando PDO para MySQL - Entorno LAMP)

```php
<?php
$host = 'localhost';
$db   = 'universidad';
$user = 'root';
$pass = 'admin123';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    $pdo = new PDO($dsn, $user, $pass, $options);
    echo "Conexión exitosa a la base de datos MySQL (LAMP)";
} catch (\PDOException $e) {
    throw new \PDOException($e->getMessage(), (int)$e->getCode());
}
?>
```

### 2. Python (usando PostgreSQL y `psycopg2`)

```python
import psycopg2
import os

try:
    conexion = psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        database=os.getenv("DB_NAME", "universidad"),
        user=os.getenv("DB_USER", "postgres"),
        password=os.getenv("DB_PASS", "admin123")
    )
    print("Conexión exitosa a la base de datos")
except Exception as e:
    print(f"Error al conectar: {e}")
```

### 2. Node.js (usando MySQL y `mysql2`)

```javascript
const mysql = require('mysql2');
require('dotenv').config();

const conexion = mysql.createConnection({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || 'admin123',
  database: process.env.DB_NAME || 'universidad'
});

conexion.connect((err) => {
  if (err) {
    console.error('Error conectando a la base de datos:', err.stack);
    return;
  }
  console.log('Conexión exitosa con el ID ' + conexion.threadId);
});
```

### 3. Java (usando JDBC)

```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://localhost:5432/universidad";
        String user = System.getenv("DB_USER");
        String password = System.getenv("DB_PASS");

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            System.out.println("Conexión exitosa a PostgreSQL!");
        } catch (SQLException e) {
            System.out.println("Error de conexión: " + e.getMessage());
        }
    }
}
```

## Parte C: Sentencias Principales a través de Conexiones

Una vez establecida la conexión, utilizamos objetos como **cursores** (en Python) o **Statements / PDOStatements** (en PHP/Java) para ejecutar comandos CRUD (Create, Read, Update, Delete).

### 1. Consultas (SELECT)

Para recuperar datos, se ejecuta la consulta y se itera sobre los resultados.

_Ejemplo en PHP (PDO - LAMP):_

```php
<?php
$sql = "SELECT id, nombre, apellido FROM estudiantes";
$stmt = $pdo->query($sql);
$estudiantes = $stmt->fetchAll(PDO::FETCH_ASSOC);

foreach ($estudiantes as $estudiante) {
    echo "ID: " . $estudiante['id'] . " - Nombre: " . $estudiante['nombre'] . " " . $estudiante['apellido'] . "<br>";
}
?>
```

### 2. Modificaciones (INSERT, UPDATE, DELETE) y Consultas Parametrizadas

**Crucial:** Para evitar la Inyección SQL, NUNCA se deben concatenar variables directamente en la cadena SQL. Siempre se deben usar sentencias preparadas o parametrizadas.

_Ejemplo de INSERT seguro en PHP (PDO - LAMP):_

```php
<?php
$sql = "INSERT INTO estudiantes (nombre, apellido, correo) VALUES (:nombre, :apellido, :correo)";
$stmt = $pdo->prepare($sql);

// Bind de parámetros
$stmt->bindParam(':nombre', $nombre);
$stmt->bindParam(':apellido', $apellido);
$stmt->bindParam(':correo', $correo);

$nombre = "Ana";
$apellido = "García";
$correo = "ana.garcia@universidad.edu";

$stmt->execute();
echo "Filas afectadas: " . $stmt->rowCount();
?>
```

### 3. Manejo de Transacciones

Las operaciones críticas que modifican datos en secuencia deben confirmarse con `commit()`. Si ocurre un error, se debe revertir con `rollback()` para mantener la integridad de la base de datos.

## Parte D: Ejercicio Práctico - Contexto "Universidad" (Entorno LAMP)

### Escenario

Usted es el desarrollador backend del sistema de registro de la "Universidad Nacional". Se requiere crear pequeños scripts en PHP que interactúen con la base de datos MySQL/MariaDB 10 para gestionar la matrícula de estudiantes.

### Esquema de Base de Datos Base (MySQL / MariaDB 10)

Asegúrese de ejecutar el siguiente DDL en su motor de base de datos antes de iniciar:

```sql
CREATE TABLE estudiantes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    fecha_registro DATE DEFAULT CURRENT_DATE
);

CREATE TABLE cursos (
    codigo VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    creditos INT NOT NULL
);
```

### Desarrollo de Actividades (Resolución en PHP / PDO)

**1. Configuración del Entorno y Módulo de Conexión:**
_Cree un archivo `conexion.php`:_

```php
<?php
$host = 'localhost';
$db   = 'universidad';
$user = 'root';
$pass = 'admin123'; // Cambiar según su configuración
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (\PDOException $e) {
    die("Error de conexión: " . $e->getMessage());
}
?>
```

**2. Operación de Inserción (Create) y Manejo de Errores (Integridad):**
_Cree un archivo `insertar_estudiante.php` que maneje correos duplicados:_

```php
<?php
require 'conexion.php';

$nombre = "Carlos";
$apellido = "Mendoza";
$correo = "carlos.mendoza@universidad.edu";

try {
    $sql = "INSERT INTO estudiantes (nombre, apellido, correo) VALUES (:nombre, :apellido, :correo)";
    $stmt = $pdo->prepare($sql);
    $stmt->execute(['nombre' => $nombre, 'apellido' => $apellido, 'correo' => $correo]);
    echo "Estudiante registrado correctamente.";
} catch (\PDOException $e) {
    if ($e->getCode() == 23000) { // Código SQLSTATE para violación de integridad (ej. UNIQUE)
        echo "Error: El correo electrónico ya se encuentra registrado.";
    } else {
        echo "Error en la base de datos: " . $e->getMessage();
    }
}
?>
```

**3. Operación de Lectura (Read):**
_Cree un archivo `listar_estudiantes.php` ordenados alfabéticamente:_

```php
<?php
require 'conexion.php';

$sql = "SELECT nombre, apellido, correo FROM estudiantes ORDER BY apellido ASC";
$stmt = $pdo->query($sql);
$estudiantes = $stmt->fetchAll();

echo "<h2>Lista de Estudiantes</h2><ul>";
foreach ($estudiantes as $est) {
    echo "<li>{$est['apellido']}, {$est['nombre']} - {$est['correo']}</li>";
}
echo "</ul>";
?>
```

### Nuevas Actividades para el Estudiante

**4. Actualización de Datos (Update):**
Desarrolle un script en PHP (`actualizar_correo.php`) que reciba el ID de un estudiante y un nuevo correo electrónico, y actualice el registro correspondiente en la tabla `estudiantes` utilizando sentencias preparadas. Muestre un mensaje indicando si la actualización fue exitosa o si el ID no existe.

**5. Eliminación Segura (Delete):**
Cree un script (`eliminar_estudiante.php`) que permita eliminar a un estudiante dado su ID. Antes de ejecutar el `DELETE`, el script debe realizar un `SELECT` para verificar que el estudiante exista y mostrar un mensaje de confirmación con el nombre del estudiante eliminado.

**6. Transacciones (Inscripción en Lote):**
Desarrolle un script (`registro_masivo.php`) que intente insertar tres estudiantes nuevos al mismo tiempo dentro de un bloque de transacción (`$pdo->beginTransaction()`). Provoque intencionalmente un error en el tercer insert (por ejemplo, duplicando un correo) y asegúrese de que el bloque `catch` ejecute un `$pdo->rollBack()`, verificando luego en la base de datos que ninguno de los estudiantes del lote fue insertado.

↩️ [[Teaching/Unisabana/BBDD/BBDD-GuiasPracticas/index|index]]
