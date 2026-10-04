---
publish: true
created: 2026-04-16T09:58:33.000Z
modified: 2026-04-16T09:58:33.000Z
---

# Guía 04.8 - Solución

# 🔑 Solucionario: Evaluación Segundo Parcial - "PetHealth"

## FASE 1: DDL (Estructura) — \[6 Puntos]

### Ejercicio 1: Depuración del Esquema (4 Puntos)

El estudiante debe identificar y corregir:

1. **Orden de Precedencia:** No se puede crear `Mascota` antes que `Propietario` porque la llave foránea fallará.

2. **Sintaxis de Cita:** Faltaba una coma tras `AUTO_INCREMENT` y la definición de la `FOREIGN KEY` requería paréntesis.

**Código Corregido:**

```MYSQL
CREATE DATABASE IF NOT EXISTS veterinaria_db;
USE veterinaria_db;

-- Primero la tabla "madre"
CREATE TABLE Propietario (
    id_propietario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100)
) ENGINE=InnoDB;

-- Luego la tabla "hija"
CREATE TABLE Mascota (
    id_mascota INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    especie VARCHAR(30),
    edad INT, -- Se asume para el Ejercicio 2
    id_propietario INT,
    CONSTRAINT fk_mascota_propietario 
        FOREIGN KEY (id_propietario) REFERENCES Propietario(id_propietario)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE Cita (
    id_cita INT PRIMARY KEY AUTO_INCREMENT, -- Coma corregida
    fecha_cita DATETIME NOT NULL,
	    motivo TEXT,
    id_mascota INT,
    FOREIGN KEY (id_mascota) REFERENCES Mascota(id_mascota) -- Paréntesis corregidos
) ENGINE=InnoDB;
```

### Ejercicio 2: Restricciones de Integridad (2 Puntos)

```SQL
-- Restricción UNIQUE para el correo
ALTER TABLE Propietario ADD CONSTRAINT unq_correo UNIQUE (correo);

-- Restricción CHECK para la edad (MariaDB 10.2+)
ALTER TABLE Mascota ADD CONSTRAINT chk_edad CHECK (edad >= 0);
```

## FASE 2: DML (Datos) — \[5 Puntos]

### Ejercicio 3: Diagnóstico de Inserción (3 Puntos)

- **Registro A:** **Éxito**. Inserción normal de propietario.

- **Registro B:** **Fallo**. Violación de restricción `UNIQUE` en la columna `correo` (ya existe el correo de Ana Rojas).

- **Registro C:** **Fallo**. Violación de Integridad Referencial (`FOREIGN KEY`). El `id_propietario` 99 no existe en la tabla `Propietario`.

### Ejercicio 4: Mantenimiento (2 Puntos)

```SQL
UPDATE Cita 
SET motivo = 'Consulta General de Prevención' 
WHERE DATE(fecha_cita) = '2025-04-14';
```

## FASE 3: SELECT (Consultas) — \[7 Puntos]

### Ejercicio 5: JOINs Múltiples (4 Puntos)

**Instrucción:** Completa la siguiente consulta para obtener un listado que muestre: **Nombre del Propietario**, **Nombre de la Mascota** y **Fecha de su Cita**. Usa alias para las tablas.

```SQL
SELECT p.nombre AS Dueño, m.nombre AS Paciente, c.fecha_cita
FROM Propietario p
JOIN Mascota m ON p.id_propietario = m.id_propietario
JOIN Cita c ON m.id_mascota = c.id_mascota;
```

### Ejercicio 6: Agrupación y HAVING (3 Puntos)

**Instrucción:** "Queremos saber cuántas mascotas tiene cada propietario, pero solo mostrar a aquellos que tienen más de 2 mascotas". Completa la instrucción con `GROUP BY` y `HAVING`.

```SQL
SELECT p.nombre, COUNT(m.id_mascota) AS total_mascotas
FROM Propietario p
JOIN Mascota m ON p.id_propietario = m.id_propietario
GROUP BY p.id_propietario, p.nombre
HAVING total_mascotas > 2;
```

---

## FASE 4: PHP/PDO (Seguridad) — \[2 Puntos]

### Ejercicio 7: Depuración de Conexión y Seguridad

El código original era vulnerable porque concatenaba variables directamente en el String de SQL, permitiendo ataques donde un usuario podría escribir `; DROP TABLE Mascota;` en la URL.

**Codigo inseguro**

```php
// CÓDIGO INSEGURO
$id = $_GET['id'];
$sql = "SELECT * FROM Mascota WHERE id_mascota = " . $id; 
$resultado = $pdo->query($sql);
```

**Solución con Sentencias Preparadas:**

```php
// Uso de placeholders (?) o por nombre (:id)
$id = $_GET['id'];
$sql = "SELECT * FROM Mascota WHERE id_mascota = :id"; 
$stmt = $pdo->prepare($sql);
$stmt->execute(['id' => $id]);
$resultado = $stmt->fetch();
```

Laboratorio de inyeción SQL:

Este laboratorio práctico está diseñado para que los estudiantes de la clínica **"PetHealth"** experimenten cómo un parámetro aparentemente inofensivo en la URL puede convertirse en una puerta de entrada para un desastre en la base de datos.

# 🧪 Laboratorio de Hacking Ético: El Expediente Expuesto (Caso Veterinaria)

En este escenario, simularemos un sistema donde un médico veterinario consulta el historial de una mascota ingresando su ID en el sistema.

## Paso 1: Crear el escenario vulnerable

Crea un archivo en tu servidor LAMP llamado `ver_mascota_inseguro.php`. Este código representa una práctica de programación deficiente al confiar en la entrada del usuario sin procesarla.

```PHP
<?php
// ver_mascota_inseguro.php
require 'config.php'; 

// El ID se recibe desde la URL (ej. ?id=1)
$id = $_GET['id']; 

// PELIGRO: El dato del usuario se pega directamente en la sentencia SQL
$sql = "SELECT nombre, especie, id_propietario FROM Mascota WHERE id_mascota = " . $id;

echo "<h3>Consulta generada en el servidor:</h3><code>$sql</code><br><hr>";

try {
    // Ejecución directa vulnerable
    $resultado = $pdo->query($sql);
    $mascota = $resultado->fetch();

    if ($mascota) {
        echo "🐾 Mascota: " . $mascota['nombre'] . "<br>";
        echo "🧬 Especie: " . $mascota['especie'] . "<br>";
        echo "👤 ID Propietario: " . $mascota['id_propietario'] . "<br>";
    } else {
        echo "No se encontró la mascota.";
    }
} catch (PDOException $e) {
    echo "Error técnico: " . $e->getMessage();
}
?>
```

---

## Paso 2: El Ataque de "Bypass" de Lógica

Un atacante no solo quiere ver una mascota; quiere extraer información de **todos** los clientes o incluso saltarse restricciones de privacidad.

**Instrucción:** Prueba estas dos URLs en tu navegador y observa la diferencia en la "Consulta generada":

1. **Búsqueda Normal:**

   `http://localhost/ver_mascota_inseguro.php?id=1`

2. **Inyección de Lógica (Ver todo):**

   `http://localhost/ver_mascota_inseguro.php?id=1 OR 1=1`

### 🧐 ¿Qué está ocurriendo?

- Al escribir `OR 1=1`, el atacante añade una condición que siempre es verdadera.

- Como la base de datos evalúa la consulta completa, el `WHERE` deja de filtrar por una mascota específica y devuelve el primer registro que encuentre, o incluso podría usarse para contar cuántas filas hay en la tabla.

- **Riesgo Mayor:** En sistemas más complejos, un atacante podría usar `UNION SELECT` para extraer nombres y contraseñas de la tabla de usuarios.

## Paso 3: Implementar la Defensa (PDO Prepared Statements)

Para corregir esto, debemos separar la **lógica de la consulta** de los **datos del usuario**. Modifica tu archivo (o crea `ver_mascota_seguro.php`) con el siguiente estándar profesional:

```PHP
<?php
// ver_mascota_seguro.php
require 'config.php';

$id = $_GET['id'];

// 1. La plantilla SQL usa un marcador de posición (:id)
$sql = "SELECT nombre, especie, id_propietario FROM Mascota WHERE id_mascota = :id";

// 2. Preparamos la sentencia (El servidor ya sabe qué hacer, solo espera el dato)
$stmt = $pdo->prepare($sql);

// 3. Vinculamos el dato de forma segura y ejecutamos
$stmt->execute(['id' => $id]);

$mascota = $stmt->fetch();

if ($mascota) {
    echo "<h3>Expediente Seguro:</h3>";
    echo "🐾 Mascota: " . htmlspecialchars($mascota['nombre']) . "<br>";
    echo "🧬 Especie: " . htmlspecialchars($mascota['especie']) . "<br>";
} else {
    echo "ID de mascota no válido.";
}
?>
```

## 🛡️ ¿Por qué esta versión es inmune?

Al usar `prepare()` y `execute()`, el flujo cambia radicalmente:

- **Tratamiento de Datos:** Si el atacante intenta enviar `1 OR 1=1`, el sistema buscará una mascota cuyo ID sea literalmente la cadena de texto `"1 OR 1=1"`.

- **Falla de Búsqueda:** Como no existe ninguna mascota con un ID que contenga palabras como "OR", la consulta simplemente no devolverá nada, protegiendo el resto de la base de datos.

- **Integridad:** El motor de la base de datos nunca llegará a ejecutar el código `OR 1=1` como una instrucción lógica, sino que lo verá como un simple valor de búsqueda fallido.

### Resumen de Aprendizaje para el Parcial:

1. **Vulnerabilidad:** Concatenar variables (`. $id`) en SQL es una invitación al desastre.

2. **Riesgo:** Pérdida de datos, acceso no autorizado y ejecución de comandos maliciosos.

3. **Defensa:** Las sentencias preparadas de PDO son la herramienta estándar en aplicaciones modernas para garantizar la seguridad del backend.

cd /var/www/html (ir a carpeta de servidor)
mkdir veterinaria (creamos carpeta del nuevo proyecto)
cd veterinaria (acceder a carpeta nueva )
cp /var/www/html/zapateria/config.php .    (copiamos el archivo config de zapateria al proyecto veterinaria)
ls -l (muestra alchivos existentes en la carpeta)
