## 🛠️ Solución Técnica: PizzaMaster Solutions

### 1. Fase DDL: Estructura de Datos (Corregida)

Para evitar errores de "llave foránea", primero debemos crear la tabla que no tiene dependencias (`clientes` y `pizzas`) y luego la tabla que las relaciona (`pedidos`).

SQL

```
-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS pizzamaster_db;
USE pizzamaster_db;

-- 1. Tabla Clientes (Corregida: PK definida y AUTO_INCREMENT)
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE, -- Garantizamos unicidad del correo
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabla Pizzas (Corregida: Sintaxis de creación)
CREATE TABLE pizzas (
    id_pizza INT AUTO_INCREMENT PRIMARY KEY,
    nombre_pizza VARCHAR(50) NOT NULL,
    tamano ENUM('Pequena', 'Mediana', 'Familiar'),
    precio DECIMAL(10,2)
);

-- 3. Tabla Pedidos (Corregida: Relación correcta con clientes y PK autoincremental)
CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_pago DECIMAL(10,2),
    CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);
```

---

### 2. Fase DML: Poblado de Datos

Corregimos los valores erróneos (como el cliente 99 que no existe o el precio que no era numérico).

SQL

```
-- Inserción de Clientes
INSERT INTO clientes (nombre, email) VALUES 
('Juan Perez', 'juan@mail.com'),
('Maria Garcia', 'maria@mail.com'),
('Luis Diaz', 'luis@mail.com'),
('Carlos Solo', 'carlos@mail.com'); -- Corregido: se añade email

-- Inserción de Pizzas
INSERT INTO pizzas (nombre_pizza, tamano, precio) VALUES 
('Pepperoni', 'Familiar', 50000.00),
('Hawaiana', 'Mediana', 35000.00),
('Veggie', 'Pequena', 25000.00),
('Carnes', 'Familiar', 60000.00); -- Corregido: precio numérico

-- Inserción de Pedidos (Relacionando IDs reales)
-- Juan (ID 1) compró Pepperoni (50000)
INSERT INTO pedidos (id_cliente, total_pago) VALUES (1, 50000.00);
-- Maria (ID 2) compró Veggie (25000)
INSERT INTO pedidos (id_cliente, total_pago) VALUES (2, 25000.00);
```

---

### 3. Fase de Consultas (Queries Estratégicas)

Aquí corregimos el uso de `GROUP BY` y los tipos de `JOIN`.

SQL

```
-- Query 1: Ventas por tamaño (Suma agrupada correctamente)
SELECT tamano, SUM(precio) AS total_ventas
FROM pizzas
GROUP BY tamano;

-- Query 2: Clientes sin pedidos (Uso de LEFT JOIN para hallar nulos)
SELECT c.nombre 
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.id_pedido IS NULL;

-- Query 3: Ticket Promedio (Promedio sobre la tabla pedidos, no sobre el catálogo)
SELECT AVG(total_pago) AS ticket_promedio 
FROM pedidos;

-- Query 4: Cliente y su pizza más cara
SELECT c.nombre, MAX(p.precio) as max_precio
FROM clientes c
JOIN pedidos pd ON c.id_cliente = pd.id_cliente
JOIN pizzas p ON pd.total_pago = p.precio
GROUP BY c.nombre;
```

---

### 4. Conectividad y Seguridad (PHP PDO)

**Errores corregidos:** Driver incorrecto (`sqlserver` -> `mysql`), variable `$database` mal mapeada y uso de constantes sin `$`.

PHP

```
<?php
$host = 'localhost';
$database = 'pizzamaster_db'; // Nombre corregido
$user = 'admin_pizza';
$password = 'Pizza123!';
$charset = 'utf8mb4';

// Corregido: dsn con variables correctas y driver mysql
$dsn = "mysql:host=$host;dbname=$database;charset=$charset"; 

$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
];

try {
    $pdo = new PDO($dsn, $user, $password, $options); // $dsn corregido
} catch (PDOException $e) {
    die("Error de conexión: " . $e->getMessage());
}
?>
```

---

### 5. Registro Seguro de Pedidos (Prepared Statements)

Corregimos el nombre de la tabla (`pedidoz` -> `pedidos`) y aplicamos sentencias preparadas contra SQL Injection.

PHP

```
<?php
include 'config.php';

$id_c = $_POST['cliente_id'];
$total = $_POST['total'];

// Corregido: Sentencia preparada y nombres de campos
$sql = "INSERT INTO pedidos (id_cliente, total_pago) VALUES (:id_c, :total)";
$stmt = $pdo->prepare($sql);
$stmt->execute(['id_c' => $id_c, 'total' => $total]);

echo "Pedido registrado con éxito";
?>
```

### 📝 Registro de Clientes Adicionales (Fase 6)

SQL

```
-- Cliente 3: Datos del estudiante (Usaremos un placeholder)
INSERT INTO clientes (nombre, email) 
VALUES ('Tu Nombre Apellido', 'tu_correo@estudiante.edu'); 

-- Cliente 4: Mónica Males
INSERT INTO clientes (nombre, email) 
VALUES ('Mónica Males', 'mona@correo.com'); 
```

---

### 🍕 Registro de Pedidos (Simulación del Formulario)

Según las instrucciones de la guía, estos clientes realizaron compras específicas que deben quedar reflejadas en la tabla `pedidos`:

SQL

```
-- Cliente 3: Compra de 2 pizzas Pepperoni Familiar ($50.000 c/u)
-- Total: 100000
INSERT INTO pedidos (id_cliente, total_pago) 
VALUES (5, 100000.00); 

-- Cliente 4: Compra de 10 pizzas Hawaiana Mediana ($35.000 c/u)
-- Total: 350000
INSERT INTO pedidos (id_cliente, total_pago) 
VALUES (6, 350000.00);
```

> **Nota técnica:** He usado los IDs **5** y **6** asumiendo que los 4 anteriores ya fueron ocupados por los clientes de la Fase 3.1 ('Juan', 'Maria', 'Luis', 'Carlos').

---

### 🧠 Reflexión sobre las preguntas de la Fase 6

Para que estés listo si el docente te pregunta tras la entrega:

- **¿Es funcional tener el campo "total\_pago"?** Es funcional para la velocidad de las consultas (reportes rápidos), pero rompe la normalización si no se valida contra un detalle de pedido. Si el precio de la pizza cambia, el histórico de `total_pago` se mantiene, lo cual es bueno para contabilidad.

- **¿Qué hacer para tener un detalle de compra?** Se debe crear una tabla intermedia llamada `detalles_pedidos` que relacione `id_pedido` con `id_pizza` y la `cantidad`.

- **¿Ventajas de `ENUM`?** Garantiza **integridad de datos** al impedir que alguien escriba "Grande" en lugar de "Familiar", y optimiza el almacenamiento interno de la base de datos.

### 6. Respaldo (Dump Correcto)

El comando correcto para generar un respaldo desde la terminal es:

Bash

```
# La forma correcta (solicitando contraseña de forma segura)
mysqldump -u admin_pizza -p pizzamaster_db > Parcial2_NombreApellido.sql
```
