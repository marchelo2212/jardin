---
publish: true
created: 2026-03-24T21:58
modified: 2026-03-25T04:15:13.000Z
---

↩️ [[Teaching/Unisabana/BBDD/BBDD-GuiasPracticas/index|index]]

# Guía 02 - Caso Heladería: DDL, DML y Consultas (QUERIES)

> Entorno: VM Ubuntu + LAMP + phpMyAdmin + MariaDB 10 / Cliente CLI `mysql`

## 1. Contexto del Ejercicio

El dueño de una cadena local de heladerías ha estado registrando sus ventas en una hoja de cálculo. Sin embargo, a medida que el negocio ha crecido, se ha encontrado con problemas graves:

- **Control de inventario y demanda:** No sabe con exactitud qué sabores se venden más y cuáles están estancados.
- **Fidelización:** Los datos de sus clientes están mezclados con las ventas, impidiéndole identificar quiénes son sus compradores frecuentes para ofrecerles promociones.
- **Rendimiento por sucursal:** Le cuesta trabajo comparar las ventas entre sus diferentes locales.

Para solucionar esto, hemos diseñado un modelo relacional básico. En esta guía, serás el encargado de implementar la base de datos, poblarla con datos históricos simulados y ejecutar las consultas estratégicas que el dueño necesita para tomar decisiones.

---

## 2. Creación de la Estructura (DDL)

> 💡 **Nota de Buenas Prácticas:** En el siguiente script notarás que las tablas tienen el prefijo `Table` (ej. `TableClientes`). Aunque funcionalmente correcto, en entornos profesionales se recomienda nombrar las tablas de forma directa (ej. `clientes`, `sabores`, `ventas`) para mantener el código limpio. Mantendremos la estructura actual por motivos didácticos.

Conéctate a MariaDB y ejecuta el siguiente script para construir el esquema relacional (`mydb`). Puedes hacerlo desde la terminal (`mysql -u root -p`) o desde la pestaña SQL de phpMyAdmin.

```sql
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- Tabla Locales
CREATE TABLE IF NOT EXISTS `mydb`.`TableLocal` (
  `idTableLocal` INT NOT NULL AUTO_INCREMENT,
  `LocalCiudad` VARCHAR(45) NULL,
  `LocalSector` VARCHAR(45) NULL,
  PRIMARY KEY (`idTableLocal`))
ENGINE = InnoDB;

-- Tabla Clientes
CREATE TABLE IF NOT EXISTS `mydb`.`TableClientes` (
  `idTableClientes` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  `Telefono` VARCHAR(10) NULL,
  PRIMARY KEY (`idTableClientes`))
ENGINE = InnoDB;

-- Tabla Ventas
CREATE TABLE IF NOT EXISTS `mydb`.`TableVenta` (
  `idTableVenta` INT NOT NULL AUTO_INCREMENT,
  `TableClientes_idTableClientes` INT NOT NULL,
  `TableLocal_idTableLocal` INT NOT NULL,
  `TipoEnvase` VARCHAR(45) NULL,
  `FechaVenta` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idTableVenta`),
  INDEX `fk_TableVenta_Local_idx` (`TableLocal_idTableLocal` ASC) VISIBLE,
  INDEX `fk_TableVenta_Clientes_idx` (`TableClientes_idTableClientes` ASC) VISIBLE,
  CONSTRAINT `fk_TableVenta_Local`
    FOREIGN KEY (`TableLocal_idTableLocal`) REFERENCES `mydb`.`TableLocal` (`idTableLocal`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_TableVenta_Clientes`
    FOREIGN KEY (`TableClientes_idTableClientes`) REFERENCES `mydb`.`TableClientes` (`idTableClientes`) ON DELETE RESTRICT ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Tabla Sabores
CREATE TABLE IF NOT EXISTS `mydb`.`TableSabores` (
  `idTableSabores` INT NOT NULL AUTO_INCREMENT,
  `NombreSabor` VARCHAR(45) NULL,
  `PrecioUnitarioSabor` INT NULL,
  PRIMARY KEY (`idTableSabores`))
ENGINE = InnoDB;

-- Tabla Detalle de Ventas
CREATE TABLE IF NOT EXISTS `mydb`.`TableDetalleVentas` (
  `TableVenta_idTableVenta` INT NOT NULL,
  `TableSabores_idTableSabores` INT NOT NULL,
  `Cantidad` INT NULL,
  PRIMARY KEY (`TableVenta_idTableVenta`, `TableSabores_idTableSabores`),
  INDEX `fk_Detalle_Sabores_idx` (`TableSabores_idTableSabores` ASC) VISIBLE,
  INDEX `fk_Detalle_Venta_idx` (`TableVenta_idTableVenta` ASC) VISIBLE,
  CONSTRAINT `fk_Detalle_Sabores`
    FOREIGN KEY (`TableSabores_idTableSabores`) REFERENCES `mydb`.`TableSabores` (`idTableSabores`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_Detalle_Venta`
    FOREIGN KEY (`TableVenta_idTableVenta`) REFERENCES `mydb`.`TableVenta` (`idTableVenta`) ON DELETE CASCADE ON UPDATE CASCADE)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
```

---

## 3. Carga de Datos Semilla (DML - INSERT)

Para que las consultas tengan sentido, cargaremos información inicial: locales, sabores, clientes y un historial de **50 ventas** con sus respectivos detalles.

Asegúrate de estar usando la base de datos correcta (`USE mydb;`) y ejecuta:

```sql
USE `mydb`;

-- 1. Locales
INSERT INTO `TableLocal` (`LocalCiudad`, `LocalSector`) VALUES
('Bogotá', 'Norte'), ('Cajicá', 'Sur'), ('Chía', 'Sur'), ('Bogotá', 'Sur'), ('Zipaquirá', 'Centro');

-- 2. Sabores
INSERT INTO `TableSabores` (`NombreSabor`, `PrecioUnitarioSabor`) VALUES
('Vainilla', 5000), ('Chocolate', 3000), ('Fresa', 6000), ('Maracuya', 4000),
('Chococherry', 9000), ('Arequipe', 1000), ('Limon', 4000), ('Cookies and cream', 11000),
('Pistacho', 2000), ('Frutas del bosque', 5000);

-- 3. Clientes (15 clientes)
INSERT INTO `TableClientes` (`Nombre`, `Telefono`) VALUES
('Ana García', '5550101'), ('Luis Páez', '5550202'), ('Marcelo Sotaminga', '3174751858'),
('Mauricio Berbeo', '3152283523'), ('Laura Triana', '3133134987'), ('Carlos Restrepo', '3101234567'),
('Diana Rojas', '3209876543'), ('Andrés Jaramillo', '3114567890'), ('Camila Vargas', '3123456789'),
('Jorge Mendoza', '3145678901'), ('Valentina Gómez', '3187654321'), ('Santiago Castro', '3198765432'),
('Paula Medina', '3165432109'), ('Felipe Ortiz', '3001122334'), ('Natalia Silva', '3012233445');

-- 4. Ventas (Cabeceras) - 50 registros distribuidos entre clientes y locales
INSERT INTO `TableVenta` (`TableClientes_idTableClientes`, `TableLocal_idTableLocal`, `TipoEnvase`, `FechaVenta`) VALUES
(1, 1, 'Cono', '2026-03-01 14:30:00'), (3, 2, 'Vaso', '2026-03-01 15:45:00'), (5, 1, 'Cono', '2026-03-02 10:15:00'),
(2, 3, 'Cono', '2026-03-02 16:20:00'), (4, 4, 'Vaso', '2026-03-03 11:10:00'), (7, 5, 'Cono', '2026-03-03 18:05:00'),
(6, 1, 'Cono', '2026-03-04 13:40:00'), (8, 2, 'Vaso', '2026-03-04 19:20:00'), (10, 3, 'Cono', '2026-03-05 12:50:00'),
(9, 4, 'Cono', '2026-03-05 17:35:00'), (12, 5, 'Vaso', '2026-03-06 14:15:00'), (11, 1, 'Cono', '2026-03-06 16:40:00'),
(15, 2, 'Cono', '2026-03-07 10:25:00'), (13, 3, 'Vaso', '2026-03-07 15:55:00'), (14, 4, 'Cono', '2026-03-08 11:30:00'),
(1, 5, 'Vaso', '2026-03-08 18:45:00'), (3, 1, 'Cono', '2026-03-09 13:10:00'), (5, 2, 'Cono', '2026-03-09 17:05:00'),
(2, 3, 'Vaso', '2026-03-10 12:20:00'), (4, 4, 'Cono', '2026-03-10 16:15:00'), (7, 5, 'Cono', '2026-03-11 14:50:00'),
(6, 1, 'Vaso', '2026-03-11 19:35:00'), (8, 2, 'Cono', '2026-03-12 10:40:00'), (10, 3, 'Cono', '2026-03-12 15:25:00'),
(9, 4, 'Vaso', '2026-03-13 11:55:00'), (12, 5, 'Cono', '2026-03-13 18:10:00'), (11, 1, 'Cono', '2026-03-14 13:20:00'),
(15, 2, 'Vaso', '2026-03-14 17:45:00'), (13, 3, 'Cono', '2026-03-15 12:15:00'), (14, 4, 'Cono', '2026-03-15 16:50:00'),
(1, 1, 'Vaso', '2026-03-16 14:05:00'), (3, 2, 'Cono', '2026-03-16 19:15:00'), (5, 3, 'Cono', '2026-03-17 10:30:00'),
(2, 4, 'Vaso', '2026-03-17 15:40:00'), (4, 5, 'Cono', '2026-03-18 11:25:00'), (7, 1, 'Cono', '2026-03-18 18:35:00'),
(6, 2, 'Vaso', '2026-03-19 13:50:00'), (8, 3, 'Cono', '2026-03-19 17:10:00'), (10, 4, 'Cono', '2026-03-20 12:45:00'),
(9, 5, 'Vaso', '2026-03-20 16:20:00'), (12, 1, 'Cono', '2026-03-21 14:10:00'), (11, 2, 'Cono', '2026-03-21 19:55:00'),
(15, 3, 'Vaso', '2026-03-22 11:15:00'), (13, 4, 'Cono', '2026-03-22 15:30:00'), (14, 5, 'Cono', '2026-03-23 10:45:00'),
(1, 1, 'Vaso', '2026-03-23 18:00:00'), (3, 2, 'Cono', '2026-03-24 13:25:00'), (5, 3, 'Cono', '2026-03-24 17:40:00'),
(2, 4, 'Vaso', '2026-03-25 12:55:00'), (4, 5, 'Cono', '2026-03-25 16:10:00');

-- 5. Detalle de Ventas (Asociando ventas con sabores y cantidades)
INSERT INTO `TableDetalleVentas` (`TableVenta_idTableVenta`, `TableSabores_idTableSabores`, `Cantidad`) VALUES
(1, 2, 2), (1, 8, 1), (2, 3, 1), (3, 1, 3), (3, 5, 1), (4, 4, 2), (5, 9, 1), (5, 7, 1),
(6, 10, 2), (7, 6, 4), (8, 2, 2), (8, 3, 1), (9, 8, 1), (10, 1, 2), (10, 4, 2), (11, 5, 1),
(12, 9, 3), (13, 7, 2), (13, 10, 1), (14, 6, 1), (15, 2, 3), (16, 3, 2), (17, 8, 4),
(18, 1, 1), (18, 4, 1), (19, 5, 2), (20, 9, 1), (20, 7, 3), (21, 10, 2), (22, 6, 1),
(22, 2, 1), (23, 3, 3), (24, 8, 2), (25, 1, 1), (26, 4, 2), (26, 5, 1), (27, 9, 2),
(28, 7, 1), (29, 10, 3), (29, 6, 1), (30, 2, 2), (31, 3, 1), (31, 8, 2), (32, 1, 4),
(33, 4, 1), (34, 5, 2), (35, 9, 1), (36, 7, 2), (36, 10, 2), (37, 6, 1), (38, 2, 3),
(39, 3, 2), (40, 8, 1), (40, 1, 1), (41, 4, 3), (42, 5, 2), (43, 9, 1), (44, 7, 4),
(45, 10, 1), (45, 6, 1), (46, 2, 2), (47, 3, 1), (48, 8, 3), (48, 1, 1), (49, 4, 2),
(50, 5, 1), (50, 9, 2);
```

---

## 4. Fundamentos Teóricos: SQL Intermedio y DML

Antes de realizar operaciones o consultas complejas, es importante asentar conceptos clave del **SQL Intermedio** (basado en la teoría de bases de datos relacionales, como el capítulo 4 de Silberschatz et al.).

### Integridad Referencial y Transacciones

- **Integridad Referencial (Restricciones):** En el DDL usamos `ON DELETE RESTRICT` y `ON DELETE CASCADE`. Esto asegura que no puedas borrar un sabor si hay ventas que lo usan (`RESTRICT`), pero si borras una venta, se borra automáticamente su detalle (`CASCADE`).
- **Transacciones:** Las operaciones DML (inserciones, actualizaciones, borrados) modifican el estado de la base de datos. En entornos críticos, se agrupan en transacciones usando `START TRANSACTION`, y se confirman con `COMMIT` o se deshacen con `ROLLBACK` en caso de error o arrepentimiento antes de confirmar.

### Lenguaje de Manipulación de Datos (DML)

El DML no es solo insertar (`INSERT`); el mantenimiento de los datos es clave:

- **`UPDATE`**: Modifica registros existentes. ¡Siempre debe llevar una cláusula `WHERE` para evitar modificar toda la tabla!
- **`DELETE`**: Elimina registros. De nuevo, la cláusula `WHERE` es obligatoria para evitar vaciar la tabla.

### Teoría de Conjuntos y Vistas: JOINs

Para responder preguntas del negocio cruzando información, unimos tablas usando `JOIN`.
$\text{Ventas Completas} = \text{Ventas} \bowtie \text{Clientes} \bowtie \text{Detalle} \bowtie \text{Sabores}$

- **INNER JOIN:** Trae únicamente los registros donde hay coincidencia en ambas tablas.
- **LEFT / RIGHT OUTER JOIN:** Trae TODOS los registros de la tabla izquierda/derecha. Si no hay coincidencias, llena los vacíos con `NULL`.
- **Vistas (Views):** Consultas que se guardan como tablas virtuales (ej. `CREATE VIEW vista_ventas AS SELECT ...`). Ayudan a simplificar queries recurrentes y a ocultar complejidad.

### Agrupación (`GROUP BY` y `HAVING`)

- `WHERE` filtra **filas individuales** antes de agrupar.
- `HAVING` filtra **grupos** después de haber aplicado las funciones de agregación (`SUM`, `COUNT`, `AVG`).

> **Orden lógico de ejecución de SQL vs. Sintaxis de escritura:**
>
> Es vital entender que **no escribimos las consultas en el mismo orden en el que el motor de base de datos las procesa**.
>
> - **Orden de escritura (Sintaxis):** `SELECT` ➔ `FROM` ➔ `JOIN` ➔ `WHERE` ➔ `GROUP BY` ➔ `HAVING` ➔ `ORDER BY` ➔ `LIMIT`
> - **Orden de ejecución (Lógica del motor):**
>   1. `FROM` y `JOIN`: Primero, el motor busca de dónde sacar los datos y cómo cruzar las tablas.
>   2. `WHERE`: Luego, filtra las filas que cumplen la condición.
>   3. `GROUP BY`: Después, agrupa las filas restantes en bloques.
>   4. `HAVING`: Filtra esos grupos creados (por ej. descartar grupos muy pequeños).
>   5. `SELECT`: Recién en este punto extrae las columnas exactas a mostrar.
>   6. `ORDER BY`: Ordena el resultado final.
>   7. `LIMIT`: Corta la cantidad de resultados devueltos al final.

---

## 5. Ejercicios Prácticos de DML (Actualizaciones y Borrados)

El dueño te pide ajustar ciertos datos operativos mediante sentencias `UPDATE` y `DELETE`. Aquí tienes 10 ejercicios con sus soluciones.

### Ejercicio 1: Actualización de precios (Inflación)

El precio de importación del Pistacho subió. Debes actualizar el precio unitario del sabor "Pistacho" incrementándolo en 1000 pesos.

```sql
UPDATE TableSabores 
SET PrecioUnitarioSabor = PrecioUnitarioSabor + 1000 
WHERE NombreSabor = 'Pistacho';
```

### Ejercicio 2: Corrección de un registro

El local registrado en la ciudad de "Bogotá" y sector "Sur" tuvo un error tipográfico en el sector y debe cambiarse a "Occidente".

```sql
UPDATE TableLocal 
SET LocalSector = 'Occidente' 
WHERE LocalCiudad = 'Bogotá' AND LocalSector = 'Sur';
```

### Ejercicio 3: Borrado controlado (Simulación)

Escribe la sentencia para intentar eliminar a la cliente "Natalia Silva".

> **Advertencia:** El SGBD mostrará un error por la restricción `ON DELETE RESTRICT`, protegiendo la integridad, ya que Natalia podría tener compras asociadas.

```sql
DELETE FROM TableClientes 
WHERE Nombre = 'Natalia Silva';
```

### Ejercicio 4: Actualización masiva con condición

Por una promoción especial, todos los sabores que cuesten más de 6000 pesos tendrán un descuento de 500 pesos.

```sql
UPDATE TableSabores 
SET PrecioUnitarioSabor = PrecioUnitarioSabor - 500 
WHERE PrecioUnitarioSabor > 6000;
```

### Ejercicio 5: Cambio de formato de teléfono

Se necesita actualizar el teléfono del cliente "Luis Páez", que cambió de número a "3220001111".

```sql
UPDATE TableClientes 
SET Telefono = '3220001111' 
WHERE Nombre = 'Luis Páez';
```

### Ejercicio 6: Limpieza de datos (Borrado)

Se ha decidido dejar de vender el sabor "Arequipe". Como no ha tenido ventas, la restricción no nos impedirá borrarlo (si tuviera ventas habría que borrar el detalle primero o cambiar el estado).

```sql
DELETE FROM TableSabores 
WHERE NombreSabor = 'Arequipe';
```

### Ejercicio 7: Inserción de un nuevo producto (DML)

Llegó un nuevo sabor a la heladería: "Menta con chispas", con un precio de 5500 pesos.

```sql
INSERT INTO TableSabores (NombreSabor, PrecioUnitarioSabor) 
VALUES ('Menta con chispas', 5500);
```

### Ejercicio 8: Actualización de múltiples campos

El cliente "Ana García" se casó y cambió su apellido a "Ana de Silva", y también cambió su teléfono a "3109998888".

```sql
UPDATE TableClientes 
SET Nombre = 'Ana de Silva', Telefono = '3109998888' 
WHERE Nombre = 'Ana García';
```

### Ejercicio 9: Borrar locales sin actividad (Simulación)

Eliminar el local de "Cajicá" "Sur". Esto generará un error debido a que ya hay transacciones asociadas a ese local en `TableVenta`.

```sql
DELETE FROM TableLocal 
WHERE LocalCiudad = 'Cajicá' AND LocalSector = 'Sur';
```

### Ejercicio 10: Traslado de local (Actualización de claves foráneas)

El local de "Zipaquirá" cerró, y todas sus ventas históricas deben reasignarse contablemente al local principal de "Bogotá Norte" (asumiendo que los IDs sean 5 y 1, respectivamente).

```sql
UPDATE TableVenta 
SET TableLocal_idTableLocal = 1 
WHERE TableLocal_idTableLocal = 5;
```

---

## 6. Las 10 Consultas Estratégicas del Negocio

A continuación, implementaremos 10 consultas (`SELECT`) diseñadas para resolver los problemas reales de la heladería.

### 1. Directorio de clientes básico

_El dueño quiere un listado alfabético de sus clientes para una campaña SMS._

```sql
SELECT Nombre, Telefono
FROM TableClientes
ORDER BY Nombre ASC;
```

> **📚 Nota Técnica:** `ORDER BY` organiza los resultados. `ASC` indica orden ascendente (A-Z) y `DESC` descendente (Z-A). Si no especificas nada, el motor asume `ASC` por defecto.

### 2. Catálogo de sabores por rango de precio

_Mostrar sabores que cuestan entre 4000 y 8000 pesos._

```sql
SELECT NombreSabor, PrecioUnitarioSabor
FROM TableSabores
WHERE PrecioUnitarioSabor BETWEEN 4000 AND 8000
ORDER BY PrecioUnitarioSabor DESC;
```

> **📚 Nota Técnica:** `BETWEEN` es un operador lógico que evalúa si un valor está dentro de un rango inclusivo (incluye el 4000 y el 8000). Es más limpio y legible que escribir `PrecioUnitarioSabor >= 4000 AND PrecioUnitarioSabor <= 8000`.

### 3. Historial de una venta específica (Uso de INNER JOIN y Alias)

_Mostrar el detalle de la venta #1: qué cliente compró, qué sabor y la cantidad._

```sql
SELECT v.idTableVenta, c.Nombre AS Cliente, s.NombreSabor, d.Cantidad
FROM TableVenta v
JOIN TableClientes c ON v.TableClientes_idTableClientes = c.idTableClientes
JOIN TableDetalleVentas d ON v.idTableVenta = d.TableVenta_idTableVenta
JOIN TableSabores s ON d.TableSabores_idTableSabores = s.idTableSabores
WHERE v.idTableVenta = 1;
```

> **📚 Notas Técnicas sobre Sintaxis:**
>
> - **Alias de Tabla (`FROM TableVenta v`):** En lugar de escribir el nombre completo de la tabla en toda la consulta, le asignamos una "letra" o alias (`v`, `c`, `d`, `s`). Por eso en el `SELECT` escribimos `v.idTableVenta`. Esto le dice al motor exactamente de qué tabla sacar la columna, evitando ambigüedades si dos tablas tienen columnas con el mismo nombre.
> - **Alias de Columna (`AS Cliente`):** Usamos `AS` para renombrar temporalmente la columna en el resultado visual. En la base de datos la columna sigue llamándose `Nombre`, pero en la pantalla de resultados aparecerá como `Cliente`.

### 4. Ingresos totales generados por Venta (Matemática básica)

_Para la venta #10, calcular cuánto dinero ingresó multiplicando cantidad por precio unitario._

```sql
SELECT d.TableVenta_idTableVenta AS No_Venta,
       s.NombreSabor,
       d.Cantidad,
       s.PrecioUnitarioSabor,
       (d.Cantidad * s.PrecioUnitarioSabor) AS Subtotal
FROM TableDetalleVentas d
JOIN TableSabores s ON d.TableSabores_idTableSabores = s.idTableSabores
WHERE d.TableVenta_idTableVenta = 10;
```

> **📚 Nota Técnica:** SQL permite hacer cálculos matemáticos directamente en la instrucción `SELECT` (`*`, `/`, `+`, `-`). Observa cómo renombramos esa operación al final usando `AS Subtotal` para darle sentido al resultado.

### 5. Clientes más fieles (Uso de GROUP BY y COUNT)

_Identificar a los clientes que han realizado más de 3 compras en la historia de la heladería._

```sql
SELECT c.Nombre, COUNT(v.idTableVenta) AS Total_Compras
FROM TableClientes c
JOIN TableVenta v ON c.idTableClientes = v.TableClientes_idTableClientes
GROUP BY c.idTableClientes, c.Nombre
HAVING Total_Compras > 3
ORDER BY Total_Compras DESC;
```

> **📚 Nota Técnica:** Usamos `GROUP BY` para agrupar todas las ventas que le pertenecen al mismo cliente. Luego, la función `COUNT` cuenta cuántas ventas hay en cada grupo. Finalmente, `HAVING` actúa como un "WHERE para grupos", filtrando y mostrando únicamente aquellos grupos donde el conteo fue mayor a 3.

### 6. Rendimiento del inventario: Sabores más vendidos

_¿Cuál es el sabor que más unidades ha vendido globalmente?_

```sql
SELECT s.NombreSabor, SUM(d.Cantidad) AS Unidades_Vendidas
FROM TableSabores s
JOIN TableDetalleVentas d ON s.idTableSabores = d.TableSabores_idTableSabores
GROUP BY s.idTableSabores, s.NombreSabor
ORDER BY Unidades_Vendidas DESC
LIMIT 5; -- Mostramos el Top 5
```

> **📚 Nota Técnica:** A diferencia de `COUNT` (que cuenta cuántas filas hay), `SUM` suma matemáticamente el valor que hay dentro de la columna `Cantidad`. `LIMIT 5` le dice al motor de la base de datos que, después de ordenar de mayor a menor, solo nos devuelva las primeras 5 filas (el Top 5).

### 7. Rendimiento por sucursal

_¿Cuántas ventas (tickets) se han emitido en cada local?_

```sql
SELECT l.LocalCiudad, l.LocalSector, COUNT(v.idTableVenta) AS Cantidad_Tickets
FROM TableLocal l
JOIN TableVenta v ON l.idTableLocal = v.TableLocal_idTableLocal
GROUP BY l.idTableLocal, l.LocalCiudad, l.LocalSector
ORDER BY Cantidad_Tickets DESC;
```

### 8. Ventas por tipo de envase

_¿La gente prefiere, Vaso o Cono? Esto ayuda a la gestión de compras (vasos de cartón vs galleta -cono-)._

```sql
SELECT TipoEnvase, COUNT(*) AS Preferencia
FROM TableVenta
GROUP BY TipoEnvase
ORDER BY Preferencia DESC;
```

### 9. El "Ticket Promedio" general de la cadena

_¿Cuánto es el promedio de unidades de helado que un cliente se lleva por cada visita?_

```sql
SELECT AVG(TotalUnidades) AS Promedio_Unidades_Por_Venta
FROM (
    SELECT TableVenta_idTableVenta, SUM(Cantidad) AS TotalUnidades
    FROM TableDetalleVentas
    GROUP BY TableVenta_idTableVenta
) AS Subconsulta;
```

_(Nota técnica: Usamos una subconsulta para sumar las unidades por venta primero, y luego calcular el promedio global)._

### 10. Análisis de ingresos: El mejor cliente

_¿Qué cliente ha gastado más dinero en la heladería?_

```sql
SELECT c.Nombre, SUM(d.Cantidad * s.PrecioUnitarioSabor) AS Dinero_Invertido
FROM TableClientes c
JOIN TableVenta v ON c.idTableClientes = v.TableClientes_idTableClientes
JOIN TableDetalleVentas d ON v.idTableVenta = d.TableVenta_idTableVenta
JOIN TableSabores s ON d.TableSabores_idTableSabores = s.idTableSabores
GROUP BY c.idTableClientes, c.Nombre
ORDER BY Dinero_Invertido DESC
LIMIT 1;
```

---

↩️ [[Teaching/Unisabana/BBDD/BBDD-GuiasPracticas/index|index]]
