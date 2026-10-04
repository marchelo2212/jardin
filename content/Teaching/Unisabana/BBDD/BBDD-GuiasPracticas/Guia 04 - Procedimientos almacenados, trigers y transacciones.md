---
publish: true
created: 2025-11-04T11:15:28.369-05:00
modified: 2026-03-11T10:00:55.430-05:00
cssclasses: ""
---

# Guía 04 – Programación en SQL (Procedimientos, Disparadores, Funciones y Transacciones)**

---

## 🎯 **Objetivos de aprendizaje**

Al finalizar esta guía, el estudiante será capaz de:

1. Comprender qué son los objetos programables dentro de una base de datos y su papel en la automatización de procesos.
    
2. Crear, ejecutar y modificar **procedimientos almacenados**, **disparadores**, **funciones** y **transacciones** en MySQL/MariaDB.
    
3. Llamar e integrar estos elementos desde aplicaciones (PHP, Python o interfaces de conexión).
    
4. Aplicar estos conceptos en escenarios reales: Universidad, Zoológico, Concesionario y Club Campestre.
    
5. Implementar un caso práctico integrador con lógica SQL avanzada.
    

---

## 🧩 **1. PROCEDIMIENTOS ALMACENADOS**

---

### 🧠 **PARTE TEÓRICA**

#### ¿Qué es?

Un **procedimiento almacenado (Stored Procedure)** es un conjunto de instrucciones SQL almacenadas en el servidor.  
Permite ejecutar un bloque de operaciones (inserción, actualización, cálculos, validaciones) mediante una sola llamada (`CALL`).

#### Importancia / Ventajas

- Automatiza operaciones repetitivas.
    
- Aumenta la **seguridad**, ya que el usuario no necesita conocer las tablas directamente.
    
- Mejora la **eficiencia**, reduciendo el tráfico entre el cliente y el servidor.
    
- Facilita la **reutilización** de lógica de negocio.
    

#### Casos reales de uso

- **Universidad:** Registrar un nuevo estudiante y su matrícula.
    
- **Zoológico:** Registrar una nueva alimentación y actualizar el peso del animal.
    
- **Concesionario:** Registrar una venta de vehículo y actualizar el inventario.
    
- **Club campestre:** Registrar una reserva y actualizar el estado del espacio.
    

---

### 💻 **PARTE PRÁCTICA**

#### Sintaxis básica:

```sql
DELIMITER //
CREATE PROCEDURE nombre_procedimiento([parámetros])
BEGIN
   -- Bloque de instrucciones SQL
END //
DELIMITER ;
```

#### Parámetros

- `IN`: Entrada de datos.
    
- `OUT`: Devuelve un valor.
    
- `INOUT`: Entrada y salida.
    

#### Ejemplo básico

```sql
DELIMITER //
CREATE PROCEDURE registrar_socio(IN p_nombre VARCHAR(50), IN p_correo VARCHAR(80))
BEGIN
   INSERT INTO socios(nombre, correo) VALUES (p_nombre, p_correo);
END //
DELIMITER ;

CALL registrar_socio('Carlos Pérez', 'carlos@club.com');
```

#### Ejemplo avanzado

Registrar una venta en un concesionario:

```sql
DELIMITER //
CREATE PROCEDURE registrar_venta(
   IN p_id_cliente INT, 
   IN p_id_vehiculo INT, 
   IN p_precio DECIMAL(10,2)
)
BEGIN
   START TRANSACTION;
      INSERT INTO ventas(id_cliente, id_vehiculo, fecha, precio)
      VALUES (p_id_cliente, p_id_vehiculo, NOW(), p_precio);
      UPDATE vehiculos SET disponible = FALSE WHERE id = p_id_vehiculo;
   COMMIT;
END //
DELIMITER ;
```

---

### ⚙️ **Uso desde la aplicación o entorno MySQL**

#### 🔹 En consola o phpMyAdmin:

```sql
CALL registrar_venta(3, 12, 45000.00);
```

#### 🔹 Desde PHP:

```php
$conn = new mysqli("localhost", "usuario", "clave", "concesionario");
$stmt = $conn->prepare("CALL registrar_venta(?, ?, ?)");
$stmt->bind_param("iid", $id_cliente, $id_vehiculo, $precio);
$id_cliente = 3; $id_vehiculo = 12; $precio = 45000.00;
$stmt->execute();
```

#### 🔹 Desde Python:

```python
cursor.callproc('registrar_venta', [3, 12, 45000.00])
```

---

## 🧩 **2. DISPARADORES (TRIGGERS)**

---

### 🧠 **PARTE TEÓRICA**

#### ¿Qué es?

Un **disparador** (trigger) es un bloque de código SQL que se ejecuta automáticamente antes o después de que ocurra un evento (`INSERT`, `UPDATE`, `DELETE`) sobre una tabla.

#### Importancia / Ventajas

- Permite **automatizar reglas de negocio** sin intervención del usuario.
    
- **Asegura integridad** de datos.
    
- **Genera auditorías** automáticas de cambios.
    
- Previene errores humanos o valores incorrectos.
    

#### Casos reales de uso

- **Universidad:** Crear un registro de auditoría cuando se modifica la nota de un estudiante.
    
- **Zoológico:** Registrar automáticamente el control veterinario al actualizar el estado de salud de un animal.
    
- **Concesionario:** Impedir ventas cuando el stock sea cero.
    
- **Club campestre:** Registrar automáticamente los movimientos de reservas o cancelaciones.
    

---

### 💻 **PARTE PRÁCTICA**

#### Sintaxis básica:

```sql
CREATE TRIGGER nombre_trigger
[BEFORE|AFTER] [INSERT|UPDATE|DELETE]
ON tabla
FOR EACH ROW
BEGIN
   -- Código SQL automático
END;
```

#### Ejemplo básico

Auditar cambios de salario en profesores (Universidad):

```sql
DELIMITER //

CREATE TRIGGER audita_salarios
AFTER UPDATE ON profesores
FOR EACH ROW
BEGIN
   INSERT INTO log_salarios(id_profesor, salario_ant, salario_nuevo, fecha)
   VALUES (OLD.id, OLD.salario, NEW.salario, NOW());
END //

DELIMITER ;

```

#### Ejemplo avanzado

Controlar stock en concesionario:

```sql
DELIMITER //

CREATE TRIGGER validar_stock
BEFORE INSERT ON ventas
FOR EACH ROW
BEGIN
   DECLARE stock_actual INT;

   -- asegurar que venga un id válido
   IF NEW.id_vehiculo IS NULL THEN
      SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Debe indicar el vehículo';
   END IF;

   SELECT stock
     INTO stock_actual
     FROM vehiculos
    WHERE id = NEW.id_vehiculo;

   -- si no existe el vehículo o no hay stock
   IF stock_actual IS NULL THEN
      SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Vehículo inexistente';
   END IF;

   IF stock_actual <= 0 THEN
      SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'No hay stock disponible para este vehículo';
   END IF;
END //

DELIMITER ;

```

---

### ⚙️ **Uso desde la aplicación o entorno MySQL**

- Los **disparadores no se ejecutan directamente**, sino **automáticamente** cuando se realiza una operación relacionada.
    
- Por ejemplo, al insertar una venta:
    

```sql
INSERT INTO ventas(id_cliente, id_vehiculo, fecha, precio)
VALUES (2, 15, NOW(), 38000.00);
```

→ Si el stock está en cero, el trigger **lanza un error** automáticamente.

#### Desde PHP o Python

- No se llama al trigger; se **activa implícitamente** al ejecutar la instrucción que lo dispara.
    
- Si hay un error (`SIGNAL SQLSTATE`), se captura en la aplicación con manejo de excepciones.
    

---

## 🧩 **3. FUNCIONES DEFINIDAS POR EL USUARIO (UDFs)**

---

### 🧠 **PARTE TEÓRICA**

#### ¿Qué es?

Una **función definida por el usuario** devuelve un **valor único** como resultado de un cálculo o transformación, a partir de uno o más parámetros.

#### Importancia / Ventajas

- Permite encapsular lógica de cálculo reutilizable.
    
- Simplifica consultas complejas.
    
- Mejora la legibilidad del código SQL.
    
- Ejecuta cálculos directamente en el servidor.
    

#### Casos reales de uso

- **Universidad:** Calcular promedio de notas o matrícula según créditos.
    
- **Zoológico:** Calcular el alimento diario por especie.
    
- **Concesionario:** Calcular el valor total con impuestos.
    
- **Club campestre:** Calcular tarifa de reserva según tipo de espacio y duración.
    

---

### 💻 **PARTE PRÁCTICA**

#### Sintaxis básica:

```sql
DELIMITER //
CREATE FUNCTION nombre_funcion(parámetros)
RETURNS tipo_dato
DETERMINISTIC
BEGIN
   RETURN expresión;
END //
DELIMITER ;
```

#### Ejemplo básico

Calcular IVA:

```sql
DELIMITER //

CREATE FUNCTION calcular_iva(precio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
   RETURN precio * 0.19;
END //

DELIMITER ;

```

#### Ejemplo avanzado

Calcular tarifa de reserva (Club Campestre):

```sql
DELIMITER //

CREATE FUNCTION valor_reserva(tipo VARCHAR(20), horas INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
   DECLARE total DECIMAL(10,2);

   IF tipo = 'Cancha' THEN
      SET total = horas * 50000;
   ELSEIF tipo = 'Salon' THEN
      SET total = horas * 120000;
   ELSE
      SET total = horas * 30000;
   END IF;

   RETURN total;
END //

DELIMITER ;


```

---

### ⚙️ **Uso desde la aplicación o entorno MySQL**

#### En consola o phpMyAdmin:

```sql
SELECT nombre, calcular_iva(precio) AS iva FROM productos;
SELECT socio, valor_reserva('Cancha', 3) AS total FROM socios;
```

#### En PHP:

```php
$result = $conn->query("SELECT valor_reserva('Salon', 4) AS total");
$row = $result->fetch_assoc();
echo "Costo total: " . $row['total'];
```

#### En Python:

```python
cursor.execute("SELECT calcular_iva(2500) AS iva")
print(cursor.fetchone()[0])
```

---

## 🧩 **4. TRANSACCIONES**

---

### 🧠 **PARTE TEÓRICA**

#### ¿Qué es?

Una **transacción** es una unidad lógica que agrupa varias operaciones SQL, garantizando que todas se ejecuten correctamente o ninguna se aplique.

#### Importancia / Ventajas

- Asegura las propiedades **ACID**: Atomicidad, Consistencia, Aislamiento y Durabilidad.
    
- Protege contra fallos o errores.
    
- Permite revertir cambios (ROLLBACK) o confirmarlos (COMMIT).
    
- Garantiza la integridad en operaciones críticas.
    

#### Casos reales de uso

- **Universidad:** Inscribir estudiante y registrar su pago.
    
- **Zoológico:** Registrar atención médica y actualizar dieta.
    
- **Concesionario:** Registrar venta y disminuir inventario.
    
- **Club campestre:** Registrar reserva y pago de forma conjunta.
    

---

### 💻 **PARTE PRÁCTICA**

#### Sintaxis básica:

```sql
START TRANSACTION;
-- operaciones
COMMIT;
-- o ROLLBACK;
```

#### Ejemplo básico

Transferencia entre cuentas:

```sql
START TRANSACTION;
UPDATE cuentas SET saldo = saldo - 100 WHERE id = 1;
UPDATE cuentas SET saldo = saldo + 100 WHERE id = 2;
COMMIT;
```

#### Ejemplo avanzado

Reserva en club campestre:

```sql
START TRANSACTION;
INSERT INTO reservas(id_socio, id_espacio, fecha, hora_inicio, hora_fin)
VALUES (3, 1, CURDATE(), '10:00', '12:00');
UPDATE espacios SET disponible = FALSE WHERE id = 1;
COMMIT;
```

---

### ⚙️ **Uso desde la aplicación o entorno MySQL**

#### En consola:

```sql
SET autocommit = 0;
START TRANSACTION;
-- operaciones
COMMIT;
```

#### Desde PHP:

```php
$conn->begin_transaction();
$conn->query("UPDATE cuentas SET saldo = saldo - 100 WHERE id = 1");
$conn->query("UPDATE cuentas SET saldo = saldo + 100 WHERE id = 2");
$conn->commit();
```

#### Desde Python:

```python
conn.autocommit = False
cursor.execute("UPDATE cuentas SET saldo = saldo - 100 WHERE id = 1")
cursor.execute("UPDATE cuentas SET saldo = saldo + 100 WHERE id = 2")
conn.commit()
```

---

## 🧩 **5. DESARROLLO PRÁCTICO**

### Caso: “Gestión de Ventas”

Se desea gestionar las ventas de una tienda.  
Tablas mínimas sugeridas:

```sql
CREATE TABLE productos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  stock INT NOT NULL CHECK (stock >= 0)
);

CREATE TABLE ventas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP   -- en MySQL usa CURRENT_TIMESTAMP
);

CREATE TABLE detalle_venta (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_venta INT NOT NULL,
  id_producto INT NOT NULL,
  cantidad INT NOT NULL CHECK (cantidad > 0),
  subtotal DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (id_venta) REFERENCES ventas(id),
  FOREIGN KEY (id_producto) REFERENCES productos(id)
);
```

### Procedimiento almacenado: registrar venta


```sql
DELIMITER //

CREATE PROCEDURE registrar_venta(IN p_id_producto INT, IN p_cant INT)
BEGIN
   DECLARE v_precio DECIMAL(10,2);
   DECLARE v_total  DECIMAL(10,2);
   DECLARE v_stock  INT;

   DECLARE EXIT HANDLER FOR SQLEXCEPTION
   BEGIN
     ROLLBACK;
     RESIGNAL;
   END;

   -- Validaciones básicas
   IF p_cant IS NULL OR p_cant <= 0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Cantidad inválida';
   END IF;

   SELECT precio, stock INTO v_precio, v_stock
   FROM productos WHERE id = p_id_producto;

   IF v_precio IS NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Producto inexistente';
   END IF;

   IF v_stock < p_cant THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Stock insuficiente';
   END IF;

   SET v_total = v_precio * p_cant;

   START TRANSACTION;
     INSERT INTO ventas() VALUES ();
     INSERT INTO detalle_venta(id_venta, id_producto, cantidad, subtotal)
     VALUES (LAST_INSERT_ID(), p_id_producto, p_cant, v_total);
     UPDATE productos SET stock = stock - p_cant WHERE id = p_id_producto;
   COMMIT;
END //

DELIMITER ;

```

### Disparador: control de stock

```sql
DELIMITER //

CREATE TRIGGER control_stock
BEFORE UPDATE ON productos
FOR EACH ROW
BEGIN
   IF NEW.stock < 0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: stock insuficiente';
   END IF;
END //

DELIMITER ;
```

### Función: calcular total con IVA

```sql
DELIMITER //

CREATE FUNCTION total_con_iva(subtotal DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
   RETURN subtotal * 1.19;
END //

DELIMITER ;
```

### Transacción: venta si hay stock

```sql
START TRANSACTION;

-- 1) Crear cabecera
INSERT INTO ventas() VALUES ();
SET @venta_id := LAST_INSERT_ID();

-- 2) Insertar detalle (ej: producto 7, cantidad 2)
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, subtotal)
VALUES (
  @venta_id,
  7,
  2,
  (SELECT precio FROM productos WHERE id = 7) * 2
);

-- 3) Descontar stock
UPDATE productos
SET stock = stock - 2
WHERE id = 7;

COMMIT;


```



