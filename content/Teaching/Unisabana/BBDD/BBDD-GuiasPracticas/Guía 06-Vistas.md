---
publish: true
created: 2026-05-06T17:41:02.000Z
modified: 2026-05-06T17:41:02.000Z
---

↩️ [[Teaching/Unisabana/BBDD/BBDD-GuiasPracticas/index|index]]

# Guía 06 - Vistas en MySQL

## 🎯 **Objetivos de aprendizaje**

Al finalizar esta guía, el estudiante será capaz de:

1. Comprender el concepto y la utilidad de las **vistas** en MySQL.
2. Crear vistas simples y complejas utilizando sentencias `SELECT`.
3. Modificar y eliminar vistas existentes.
4. Entender y aplicar el concepto de **vistas actualizables**.
5. Utilizar vistas para simplificar consultas complejas y mejorar la seguridad de los datos.

---

## 🧩 **1. VISTAS**

### 🧠 **PARTE TEÓRICA**

#### ¿Qué es una Vista?

Una **vista** es una tabla virtual o lógica que se basa en el conjunto de resultados de una consulta SQL. No almacena datos por sí misma (excepto en el caso de vistas materializadas, que no son el estándar en MySQL y no cubriremos aquí), sino que "almacena" la definición de una consulta. Cada vez que se consulta la vista, la base de datos ejecuta la consulta subyacente para mostrar los datos.

#### Importancia / Ventajas

- **Simplificación de Consultas:** Permite abstraer la complejidad de un `SELECT` largo con `JOIN`s, `WHERE`s, y funciones, ofreciendo una tabla simplificada para el usuario final.
- **Seguridad:** Se puede conceder acceso a los usuarios solo a vistas específicas, ocultando las tablas subyacentes y ciertas columnas. Esto significa que los usuarios pueden ver y manipular solo los datos relevantes para ellos, sin acceder a la estructura completa de la base de datos o a información sensible.
- **Consistencia de Datos:** Asegura que todos los usuarios vean los datos de la misma manera, ya que la definición de la vista es centralizada.
- **Reutilización:** Una vez definida, una vista puede ser consultada por múltiples aplicaciones o usuarios, evitando la duplicación de código SQL.
- **Independencia Lógica de Datos:** Si la estructura de las tablas base cambia (ej., se añade una columna), la vista puede ajustarse para mantener la interfaz consistente para las aplicaciones, que no necesitan ser modificadas.

#### Casos reales de uso

- **Universidad:** Una vista `VistaNotasEstudiantes` que combina `Estudiantes`, `Cursos` y `Calificaciones` para mostrar el nombre del estudiante, el curso y su nota final, sin exponer todos los campos de cada tabla.
- **Zoológico:** Una vista `VistaAnimalesEnfermos` que muestra solo los animales cuyo estado de salud indica alguna enfermedad o necesidad de atención especial.
- **Concesionario:** Una vista `VistaInventarioVehiculosDisponibles` que solo muestra los vehículos que están `disponible = TRUE` y con todos sus detalles relevantes para la venta.
- **Club campestre:** Una vista `VistaReservasActivas` que muestra las reservas vigentes para los espacios del club.

---

### 💻 **PARTE PRÁCTICA**

Para los siguientes ejemplos, asumiremos una base de datos `veterinaria_db` con las tablas `Propietario`, `Mascota` y `Cita`, similar a la definida en guías anteriores.

```sql
-- Ejemplo de tablas para el contexto
CREATE DATABASE IF NOT EXISTS veterinaria_db;
USE veterinaria_db;

CREATE TABLE Propietario (
    id_propietario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE
);

CREATE TABLE Mascota (
    id_mascota INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    especie VARCHAR(30),
    edad INT CHECK (edad > 0),
    id_propietario INT,
    CONSTRAINT fk_mascota_propietario
        FOREIGN KEY (id_propietario) REFERENCES Propietario(id_propietario)
);

CREATE TABLE Cita (
    id_cita INT PRIMARY KEY AUTO_INCREMENT,
    fecha_cita DATETIME NOT NULL,
    motivo TEXT,
    id_mascota INT,
    CONSTRAINT fk_cita_mascota
        FOREIGN KEY (id_mascota) REFERENCES Mascota(id_mascota)
);

-- Insertar algunos datos de ejemplo
INSERT INTO Propietario (nombre, correo) VALUES ('Ana Rojas', 'ana@mail.com');
INSERT INTO Propietario (nombre, correo) VALUES ('Luis Perez', 'luis@mail.com');
INSERT INTO Mascota (nombre, especie, edad, id_propietario) VALUES ('Firulais', 'Perro', 5, 1);
INSERT INTO Mascota (nombre, especie, edad, id_propietario) VALUES ('Minina', 'Gato', 3, 1);
INSERT INTO Mascota (nombre, especie, edad, id_propietario) VALUES ('Rocky', 'Perro', 2, 2);
INSERT INTO Cita (fecha_cita, motivo, id_mascota) VALUES ('2025-04-14 10:00:00', 'Chequeo anual', 1);
INSERT INTO Cita (fecha_cita, motivo, id_mascota) VALUES ('2025-04-15 14:30:00', 'Vacunación', 2);
INSERT INTO Cita (fecha_cita, motivo, id_mascota) VALUES ('2025-04-14 11:00:00', 'Consulta general', 3);
```

#### Sintaxis básica para crear una vista:

```sql
CREATE VIEW nombre_vista AS
SELECT columna1, columna2, ...
FROM tabla1
JOIN tabla2 ON ...
WHERE condicion;
```

#### Ejemplo básico: Vista de Mascotas y sus Propietarios

Creamos una vista para ver fácilmente el nombre de cada mascota y el nombre de su propietario.

```sql
CREATE VIEW VistaMascotasPropietarios AS
SELECT
    M.nombre AS nombre_mascota,
    M.especie,
    P.nombre AS nombre_propietario,
    P.correo AS correo_propietario
FROM
    Mascota M
JOIN
    Propietario P ON M.id_propietario = P.id_propietario;
```

Para usar esta vista, simplemente la consultamos como si fuera una tabla:

```sql
SELECT * FROM VistaMascotasPropietarios;
-- Resultado:
-- +----------------+---------+--------------------+---------------------+
-- | nombre_mascota | especie | nombre_propietario | correo_propietario |
-- +----------------+---------+--------------------+---------------------+
-- | Firulais | Perro | Ana Rojas | ana@mail.com |
-- | Minina | Gato | Ana Rojas | ana@mail.com |
-- | Rocky | Perro | Luis Perez | luis@mail.com |
-- +----------------+---------+--------------------+---------------------+
```

#### Ejemplo avanzado: Vista de Citas con Detalles Completos

Una vista que muestre la fecha de la cita, el motivo, el nombre de la mascota y el nombre del propietario.

```sql
CREATE VIEW VistaCitasDetalladas AS
SELECT
    C.fecha_cita,
    C.motivo,
    M.nombre AS nombre_mascota,
    M.especie,
    P.nombre AS nombre_propietario,
    P.correo AS correo_propietario
FROM
    Cita C
JOIN
    Mascota M ON C.id_mascota = M.id_mascota
JOIN
    Propietario P ON M.id_propietario = P.id_propietario;
```

Consulta de la vista:

```sql
SELECT * FROM VistaCitasDetalladas
WHERE fecha_cita BETWEEN '2025-04-14 00:00:00' AND '2025-04-14 23:59:59';
-- Resultado (ejemplo filtrado por fecha):
-- +---------------------+-------------------+----------------+---------+--------------------+---------------------+
-- | fecha_cita | motivo | nombre_mascota | especie | nombre_propietario | correo_propietario |
-- +---------------------+-------------------+----------------+---------+--------------------+---------------------+
-- | 2025-04-14 10:00:00 | Chequeo anual | Firulais | Perro | Ana Rojas | ana@mail.com |
-- | 2025-04-14 11:00:00 | Consulta general | Rocky | Perro | Luis Perez | luis@mail.com |
-- +---------------------+-------------------+----------------+---------+--------------------+---------------------+
```

#### Modificación de Vistas (`ALTER VIEW`)

Puedes modificar la definición de una vista existente.

```sql
ALTER VIEW VistaMascotasPropietarios AS
SELECT
    M.nombre AS nombre_mascota,
    M.especie,
    M.edad, -- Añadimos la edad de la mascota
    P.nombre AS nombre_propietario
FROM
    Mascota M
JOIN
    Propietario P ON M.id_propietario = P.id_propietario;
```

#### Eliminación de Vistas (`DROP VIEW`)

```sql
DROP VIEW VistaMascotasPropietarios;
```

#### Vistas Actualizables (Updatable Views)

Una vista es "actualizable" (se puede usar con `INSERT`, `UPDATE`, `DELETE`) si la `SELECT` subyacente cumple ciertas condiciones:

- Debe seleccionar de una sola tabla.
- No puede contener cláusulas `GROUP BY`, `HAVING`, `UNION`, `DISTINCT`.
- No puede contener funciones de agregación.
- No puede contener subconsultas en la cláusula `SELECT`.
- Todas las columnas NOT NULL de la tabla base deben estar en la vista si se intenta un `INSERT`.

**Ejemplo de vista actualizable:**

```sql
CREATE VIEW VistaPropietariosBasico AS
SELECT id_propietario, nombre, correo
FROM Propietario;

-- Podemos insertar en esta vista:
INSERT INTO VistaPropietariosBasico (nombre, correo) VALUES ('Elena Garcia', 'elena@mail.com');

-- Podemos actualizar:
UPDATE VistaPropietariosBasico SET nombre = 'Elena R. Garcia' WHERE id_propietario = 3;

-- Podemos eliminar:
DELETE FROM VistaPropietariosBasico WHERE id_propietario = 3;
```

**Ejemplo de vista NO actualizable:**

`VistaCitasDetalladas` no es actualizable porque involucra múltiples `JOIN`s. Intentar un `INSERT` o `UPDATE` sobre ella resultaría en un error.

---

### ⚙️ **Uso desde la aplicación o entorno MySQL**

Las vistas se consultan de la misma manera que una tabla, lo que las hace muy fáciles de integrar en cualquier entorno.

#### 🔹 En consola o phpMyAdmin:

```sql
SELECT * FROM VistaMascotasPropietarios WHERE especie = 'Perro';
SELECT nombre_propietario, COUNT(nombre_mascota) AS TotalMascotas
FROM VistaMascotasPropietarios
GROUP BY nombre_propietario
HAVING TotalMascotas > 1;
```

#### 🔹 Desde PHP:

```php
<?php
$conn = new mysqli("localhost", "usuario", "clave", "veterinaria_db");

if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

$sql = "SELECT nombre_mascota, nombre_propietario FROM VistaMascotasPropietarios";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    echo "<h2>Mascotas y sus Propietarios:</h2>";
    while($row = $result->fetch_assoc()) {
        echo "Mascota: " . $row["nombre_mascota"]. " - Propietario: " . $row["nombre_propietario"]. "<br>";
    }
} else {
    echo "0 resultados";
}
$conn->close();
?>
```

#### 🔹 Desde Python:

```python
import mysql.connector

try:
    conn = mysql.connector.connect(
        host="localhost",
        user="usuario",
        password="clave",
        database="veterinaria_db"
    )
    cursor = conn.cursor()

    query = "SELECT fecha_cita, nombre_mascota, nombre_propietario FROM VistaCitasDetalladas WHERE especie = 'Gato';"
    cursor.execute(query)

    print("Citas detalladas de gatos:")
    for (fecha_cita, nombre_mascota, nombre_propietario) in cursor:
        print(f"Fecha: {fecha_cita}, Mascota: {nombre_mascota}, Propietario: {nombre_propietario}")

except mysql.connector.Error as err:
    print(f"Error: {err}")
finally:
    if 'conn' in locals() and conn.is_connected():
        cursor.close()
        conn.close()
```

---

## 🧩 **5. DESARROLLO PRÁCTICO: Ejercicios con Vistas**

Para estos ejercicios, utilizaremos el esquema `veterinaria_db` con los datos de ejemplo proporcionados anteriormente.

### Ejercicio 1: Vista de Propietarios con Múltiples Mascotas

Crea una vista llamada `VistaPropietariosConMuchasMascotas` que muestre el nombre del propietario y la cantidad de mascotas que posee, pero solo para aquellos propietarios que tengan más de una mascota.

```sql
-- Aquí tu código SQL
```

### Ejercicio 2: Vista de Citas Pendientes

Crea una vista llamada `VistaCitasPendientes` que muestre todas las citas que están programadas para una fecha futura. La vista debe incluir la fecha de la cita, el motivo, el nombre de la mascota y el nombre del propietario.

```sql
-- Aquí tu código SQL
```

### Ejercicio 3: Vista Actualizable (Desafío)

Crea una vista `VistaInfoMascotas` que incluya `id_mascota`, `nombre` y `especie` de la tabla `Mascota`. Luego, intenta actualizar el nombre de una mascota a través de esta vista y justifica si la operación es exitosa o no, y por qué.

```sql
-- Aquí tu código SQL para crear la vista
```

```sql
-- Aquí tu código SQL para intentar actualizar la vista
```

**Justificación:**

```
Tu justificación aquí
```

---

↩️ [[Teaching/Unisabana/BBDD/BBDD-GuiasPracticas/index|index]]

```
```
