---
publish: true
created: 2026-04-16T09:58:26.000Z
modified: 2026-04-16T09:58:26.000Z
---

↩️ [[Teaching/Unisabana/BBDD/BBDD-GuiasPracticas/index|index]]

# Guía 04.8 - Ejercicio pre-parcial

# Ejercicio de evaluación segundo parcial: Ingeniería de BBDD - Caso "PetHealth"

**Asignatura:** Bases de Datos
**Facultad de Ingeniería** **Puntaje Total:** 20 Puntos

## 📑 Introducción al Reto

La clínica veterinaria "PetHealth" ha intentado migrar su sistema de archivos Excel a una base de datos relacional en MariaDB. Sin embargo, el equipo de desarrollo junior dejó el código con múltiples errores de integridad, sintaxis y lógica.

**Tu misión:** Como Ingeniero de Datos, debes depurar el código, completar las instrucciones faltantes y asegurar que la base de datos sea capaz de generar reportes estratégicos para la gerencia.

## 🛠️ FASE 1: Diseño Físico y Estructura (DDL) — \[6 Puntos]

### Acción 1: Creación del Esquema

El siguiente script tiene errores intencionales. El motor de base de datos rechazará la ejecución debido a problemas en el orden de las tablas y errores en las llaves foráneas.

#### Ejercicio 1: Depuración del Esquema (4 Puntos)

**Instrucción:** Identifica los 3 errores técnicos que impiden que este script se ejecute correctamente en MariaDB. Corrige el código y ejecútalo.

```SQL
-- ERROR SEMBRADO: ¿Se puede crear una tabla que referencia a otra que aún no existe?
CREATE DATABASE IF NOT EXISTS veterinaria_db;
USE veterinaria_db;

CREATE TABLE Mascota (
    id_mascota INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    especie VARCHAR(30),
    id_propietario INT,
    CONSTRAINT fk_mascota_propietario 
        FOREIGN KEY (id_propietario) REFERENCES Propietario(id_propietario)
);

CREATE TABLE Propietario (
    id_propietario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100)
);

-- ERROR DE SINTAXIS: Falta una coma o tipo de dato incorrecto
CREATE TABLE Cita (
    id_cita INT PRIMARY KEY AUTO_INCREMENT
    fecha_cita DATETIME NOT NULL,
    motivo TEXT
    id_mascota INT,
    FOREIGN KEY id_mascota REFERENCES Mascota(id_mascota)
);
```

Aquí tu respuesta a las preguntas:

```
Respuesta en texto
```

Aquí tu código corregido:

```SQL
Código corregido
```

#### Ejercicio 2: Restricciones de Integridad (2 Puntos)

**Instrucción:** Modifica la tabla `Mascota` para asegurar que la edad sea siempre un valor positivo (usando `CHECK`) y que el correo del `Propietario` sea único (usando `UNIQUE`). Escribe las sentencias `ALTER TABLE` correspondientes.

Aquí tu código :

```SQL
Aquí tu código 
```

## 💾 FASE 2: Manipulación y Mantenimiento (DML) — \[5 Puntos]

### Acción 2: Población de Datos

El dueño de la clínica quiere insertar los siguientes registros, pero algunos violarán las reglas de integridad que acabas de crear.

#### Ejercicio 3: Diagnóstico de Inserción (3 Puntos)

**Instrucción:** Sin ejecutar el código aún, interpreta qué filas darán error y justifica por qué (basado en PK, FK o restricciones).

```SQL
-- Registro A
INSERT INTO Propietario (nombre, correo) VALUES ('Ana Rojas', 'ana@mail.com');
-- Registro B
INSERT INTO Propietario (nombre, correo) VALUES ('Luis Perez', 'ana@mail.com'); 
-- Registro C
INSERT INTO Mascota (nombre, especie, id_propietario) VALUES ('Firulais', 'Perro', 99); 
```

Aquí tu respuesta a la/s preguntas:

```
Respuesta en texto
```

#### Ejercicio 4: Mantenimiento de Datos (2 Puntos)

**Instrucción:** Escribe una sentencia `UPDATE` para cambiar el motivo de todas las citas del día "2025-04-14" a "Consulta General de Prevención".

Aquí tu código :

```SQL
Aquí tu código 
```

## 📈 FASE 3: Consultas de Negocio e Inteligencia (SELECT) — \[7 Puntos]

### Acción 3: Extracción de Valor

La gerencia necesita reportes claros para la toma de decisiones.

#### Ejercicio 5: Relaciones Cruzadas (JOINs) (4 Puntos)

**Instrucción:** Completa la siguiente consulta para obtener un listado que muestre: **Nombre del Propietario**, **Nombre de la Mascota** y **Fecha de su Cita**. Usa alias para las tablas.

```SQL
SELECT ____.nombre AS Dueño, ____.nombre AS Paciente, ____.fecha_cita
FROM Propietario ____
JOIN Mascota ____ ON ____.id_propietario = ____.id_propietario
____ Cita ____ ON ____.id_mascota = ____.id_mascota;
```

Aquí tu código :

```SQL
Aquí tu código 
```

#### Ejercicio 6: Agrupación Avanzada (3 Puntos)

**Instrucción:** "Queremos saber cuántas mascotas tiene cada propietario, pero solo mostrar a aquellos que tienen más de 2 mascotas". Completa la instrucción con `GROUP BY` y `HAVING`.

Aquí tu código :

```SQL
Aquí tu código 
```

## 🔌 FASE 4: Conectividad y Seguridad (PHP/PDO) — \[2 Puntos]

### Acción 4: Seguridad del Backend

El siguiente script de PHP es vulnerable a **Inyección SQL**.

#### Ejercicio 7: Depuración de Conexión (2 Puntos)

**Instrucción:** Identifica por qué el siguiente código es inseguro y reescríbelo usando **Sentencias Preparadas (PDO)**.

```php
// CÓDIGO INSEGURO
$id = $_GET['id'];
$sql = "SELECT * FROM Mascota WHERE id_mascota = " . $id; 
$resultado = $pdo->query($sql);
```

Aquí tu código :

```SQL
Aquí tu código 
```

## 🏁 Criterios de Entrega

1. **Script Final:** Un archivo `.sql` que se ejecute de principio a fin sin errores.
2. **Análisis:** Un documento Markdown con las capturas de pantalla de los resultados de las consultas (Ejercicios 5 y 6) y la justificación técnica de las correcciones realizadas.

↩️ [[Teaching/Unisabana/BBDD/BBDD-GuiasPracticas/index|index]]
