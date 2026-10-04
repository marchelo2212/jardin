---
publish: true
created: 2025-09-10T10:50
modified: 2025-09-24T09:58:33-05:00
cssclasses: ""
---

# Guía 2: SQL Intermedio (MariaDB 10)

> Entorno: VM Ubuntu 24.04 + LAMP + phpMyAdmin + MariaDB 10.
## 0) Antes de empezar (setup)

### 0.1. Acceso al cliente de base de datos

Usaremos el cliente `mysql` para ejecutar sentencias SQL. Puedes conectarte así:

```bash
mysql -h localhost -u root -p
# o, si ya tienes un usuario creado:
mysql -h localhost -u cbuser -p
```

El cliente acepta opciones cortas (`-h`, `-u`, `-p`) o largas (`--host`, `--user`, `--password`). `localhost` puede usar socket Unix; para forzar TCP usa `127.0.0.1` o `--protocol=tcp`.   

> Tip: puedes guardar credenciales en `~/.my.cnf` (grupo `[client]`) y luego ejecutar `mysql` sin opciones. Protege ese archivo con `chmod 600 ~/.my.cnf`.   

También puedes usar **phpMyAdmin** desde el navegador como interfaz alternativa.  

### 0.2. Crear base de datos y usuario de práctica

Conéctate como `root` y crea un usuario y una BD de trabajo:

```sql
-- como root en el cliente mysql
CREATE DATABASE ubdemo;
CREATE USER 'ubuser'@'localhost' IDENTIFIED BY 'pass_demo';
GRANT ALL ON ubdemo.* TO 'ubuser'@'localhost';
FLUSH PRIVILEGES;
```

`CREATE USER` crea la cuenta; `GRANT` asigna privilegios (a nivel global, BD, tabla, columna o rutina).   

Desconéctate y prueba el acceso nuevo:

```bash
mysql -h localhost -u ubuser -p
```

## 1) Fundamentos de SQL (DDL/LDD y DML/LMD)

### 1.1. ¿Qué es SQL?

SQL se compone, entre otras cosas, de:

- **LDD/DDL** (Lenguaje de Definición de Datos): define esquemas, borra relaciones y modifica esquemas.
- **LMD/DML** (Lenguaje de Manipulación de Datos): incluye el lenguaje de consultas y comandos para insertar, borrar y modificar tuplas.  

El DDL permite especificar esquemas, dominios (tipos), restricciones de integridad, índices y aspectos de seguridad.  

### 1.2. Tipos de datos básicos (dominios)

Algunos tipos estándar:

- `CHAR(n)`, `VARCHAR(n)` (cadenas de longitud fija/variable)
- `INT`, `SMALLINT`
- `NUMERIC(p,d)` (coma fija), `REAL/DOUBLE`, `FLOAT(n)`
- Casi todos los tipos admiten el valor especial **NULL**.   

> Cadenas entre comillas simples. La comparación de cadenas puede ser sensible o no a mayúsculas según el SGBD; MySQL/MariaDB suelen ser insensibles por defecto (collation).  

### 1.3. Restricciones de integridad y claves

- **PRIMARY KEY**: identifica tuplas, debe ser única y no nula.
- **FOREIGN KEY**: sus valores deben coincidir con la clave primaria (o única) de otra tabla.
- **NOT NULL**: prohíbe valores nulos.   

Ejemplo (esquema “Universidad” clásico):

```sql
CREATE TABLE departamento(
  nombre_dept VARCHAR(20),
  edificio     VARCHAR(15),
  presupuesto  NUMERIC(12,2),
  PRIMARY KEY (nombre_dept)
);

CREATE TABLE asignatura(
  asignatura_id VARCHAR(7),
  nombre        VARCHAR(50),
  nombre_dept   VARCHAR(20),
  creditos      NUMERIC(2,0),
  PRIMARY KEY (asignatura_id),
  FOREIGN KEY (nombre_dept) REFERENCES departamento
);

CREATE TABLE profesor(
  ID           VARCHAR(5),
  nombre       VARCHAR(20) NOT NULL,
  nombre_dept  VARCHAR(20),
  sueldo       NUMERIC(8,2),
  PRIMARY KEY (ID),
  FOREIGN KEY (nombre_dept) REFERENCES departamento
);
``` 

> Los SGBD impiden violar claves primarias/foráneas durante inserciones/actualizaciones.  

### 1.4. DML esencial

- **INSERT**: añade filas.
- **DELETE**: elimina filas.
- **UPDATE**: modifica filas.
- **SELECT**: consulta (lo veremos en la sección 2).

Ejemplos:

```sql
-- INSERT: columnas explícitas (recomendado)
INSERT INTO profesor (id, nombre, nombre_dept, sueldo)
VALUES ('45565', 'Katz', 'Informática', 75000);

-- INSERT múltiple
INSERT INTO departamento (nombre_dept, edificio, presupuesto) VALUES
('Electrónica','Watson',1500000), ('Finanzas','Taylor',1200000);

-- UPDATE: cuidado con el WHERE (si lo omites, actualizas todo)
UPDATE profesor
SET sueldo = sueldo * 1.05  -- +5%
WHERE nombre_dept = 'Informática';

-- DELETE: elimina filas
DELETE FROM profesor
WHERE id = '45565';
```

> Nota sobre **NULL**: SQL incorpora un tercer valor lógico (“unknown”) al trabajar con nulos; tenlo en cuenta en comparaciones y `WHERE`.  

## 2) Consultas SQL básicas

Para avanzar en esta guía deberás borrar las tablas creadas anteriormente o en su defecto crear nueva base de datos.

Comandos para **crear una BBDD nueva**:
```SQL
CREATE DATABASE prueba CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

CREATE USER 'tu_usuario'@'localhost' IDENTIFIED BY 'pass_usuario'; 

GRANT ALL PRIVILEGES ON prueba.* TO 'dev'@'localhost'; 

FLUSH PRIVILEGES; 

EXIT;
```

**NOTA:**  Recuerde el usuario y contraseña que esté empelando.

Para acceder a mysql con el usuario y contraseña de la base datos (considere que debería adaptar acorde usted haya creado la BBDD y el usuario):

```bash
mysql -h localhost -u ubuser -p
```

Aquí los comandos que se podrían emplear inicialmente si usamos una base de datos existente:
```SQL
-- Para ver las bases de datos que tiene el usuario
SHOW DATABASES;

-- Para usar una base de datos llamada 'ubdemo'
USE database_name; --en nuestro caso ubdemo

-- Luego de haber elegido la BBDD con 'USE' se podría ver las tablas que existen en la BBDD
SHOW TABLES;
SHOW TABLES FROM database_name;  
SHOW TABLES IN database_name;

-- Para ver las estructura interna de una de las tablas se usa
DESCRIBE NombreTabla;

-- Borra solo los registros de profesor, tabla sigue existiendo
DELETE FROM profesor WHERE nombre_dept = 'Historia';

-- Borra la tabla profesor (¡se pierde estructura y datos!)
DROP TABLE profesor; --MUCHO OJO

-- Borra tablas si existen (para reintentar esta sección de prácticas)
DROP TABLE IF EXISTS matricula, seccion, prerreq, imparte, estudiante, profesor, asignatura, departamento;
```

Aquí los comandos para agregar las tablas y cargar la información inicial.

**Siga leyendo cada linea y bloque:**

```SQL
-- Departamentos
CREATE TABLE departamento (
  nombre_dept   VARCHAR(20)  NOT NULL,
  edificio      VARCHAR(15),
  presupuesto   DECIMAL(12,2) CHECK (presupuesto >= 0),
  PRIMARY KEY (nombre_dept)
) ENGINE=InnoDB;

-- Asignaturas
CREATE TABLE asignatura (
  asignatura_id VARCHAR(7)   NOT NULL,
  nombre        VARCHAR(50)  NOT NULL,
  nombre_dept   VARCHAR(20)  NOT NULL,
  creditos      TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (asignatura_id),
  CONSTRAINT fk_asig_dept
    FOREIGN KEY (nombre_dept) REFERENCES departamento(nombre_dept)
      ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Profesores
CREATE TABLE profesor (
  id            VARCHAR(5)    NOT NULL,
  nombre        VARCHAR(30)   NOT NULL,
  nombre_dept   VARCHAR(20)   NOT NULL,
  sueldo        DECIMAL(9,2)  CHECK (sueldo >= 0),
  PRIMARY KEY (id),
  CONSTRAINT fk_prof_dept
    FOREIGN KEY (nombre_dept) REFERENCES departamento(nombre_dept)
      ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Secciones (ofertas de una asignatura en un semestre y año)
CREATE TABLE seccion (
  asignatura_id VARCHAR(7)  NOT NULL,
  secc_id       SMALLINT    NOT NULL,
  semestre      ENUM('Primavera','Verano','Otoño') NOT NULL,
  anio          YEAR        NOT NULL,
  edificio      VARCHAR(15),
  aula          VARCHAR(10),
  fran_horaria  CHAR(1),
  PRIMARY KEY (asignatura_id, secc_id, semestre, anio),
  CONSTRAINT fk_sec_asig
    FOREIGN KEY (asignatura_id) REFERENCES asignatura(asignatura_id)
      ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Quién imparte qué sección
CREATE TABLE imparte (
  id            VARCHAR(5) NOT NULL,
  asignatura_id VARCHAR(7) NOT NULL,
  secc_id       SMALLINT   NOT NULL,
  semestre      ENUM('Primavera','Verano','Otoño') NOT NULL,
  anio          YEAR NOT NULL,
  PRIMARY KEY (id, asignatura_id, secc_id, semestre, anio),
  CONSTRAINT fk_imp_prof   FOREIGN KEY (id)            REFERENCES profesor(id),
  CONSTRAINT fk_imp_sec    FOREIGN KEY (asignatura_id, secc_id, semestre, anio)
                           REFERENCES seccion(asignatura_id, secc_id, semestre, anio)
) ENGINE=InnoDB;

-- Estudiantes
CREATE TABLE estudiante (
  id            VARCHAR(5)  NOT NULL,
  nombre        VARCHAR(30) NOT NULL,
  tot_creditos  SMALLINT UNSIGNED DEFAULT 0,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

-- Matrículas (estudiante toma sección)
CREATE TABLE matricula (
  id            VARCHAR(5)  NOT NULL,
  asignatura_id VARCHAR(7)  NOT NULL,
  secc_id       SMALLINT    NOT NULL,
  semestre      ENUM('Primavera','Verano','Otoño') NOT NULL,
  anio          YEAR NOT NULL,
  nota          DECIMAL(3,1),
  PRIMARY KEY (id, asignatura_id, secc_id, semestre, anio),
  CONSTRAINT fk_mat_est   FOREIGN KEY (id) REFERENCES estudiante(id),
  CONSTRAINT fk_mat_sec   FOREIGN KEY (asignatura_id, secc_id, semestre, anio)
                          REFERENCES seccion(asignatura_id, secc_id, semestre, anio)
) ENGINE=InnoDB;

-- Prerrequisitos (relación muchos-a-muchos sobre asignatura)
CREATE TABLE prerreq (
  asignatura_id VARCHAR(7) NOT NULL,
  prerreq_id    VARCHAR(7) NOT NULL,
  PRIMARY KEY (asignatura_id, prerreq_id),
  CONSTRAINT fk_pre_a  FOREIGN KEY (asignatura_id) REFERENCES asignatura(asignatura_id),
  CONSTRAINT fk_pre_b  FOREIGN KEY (prerreq_id)    REFERENCES asignatura(asignatura_id)
) ENGINE=InnoDB;

```

### ¿Por qué necesito especificar `ENGINE=InnoDB` y qué pasa si lo omito?

- En MariaDB/MySQL, cada tabla se crea con un **motor de almacenamiento**.
- `InnoDB` es el motor recomendado porque soporta:
    - ✅ **Claves foráneas (FOREIGN KEY)**
    - ✅ **Transacciones ACID**
    - ✅ **Bloqueo por fila** (mejor concurrencia)
Si lo omites:
- En versiones modernas, el **motor por defecto es InnoDB** (no pasa nada).
- En versiones antiguas (antes de MySQL 5.5), el motor por defecto era **MyISAM** (no soporta claves foráneas ni transacciones). Tus `FOREIGN KEY` se **ignorarían** silenciosamente.

👉 Siempre explícitalo: garantiza consistencia en cualquier entorno.

Ahora carguemos los datos dentro de las tablas:

```SQL
-- Datos mínimos para empezar a consultar
INSERT INTO departamento VALUES
('Biología','Watson', 1200000),
('Informática','Taylor', 2000000),
('Física','Packard', 1900000),
('Historia','Painter', 900000),
('Música','Smith', 600000);

INSERT INTO asignatura VALUES
('BIO-101','Introducción a la Biología','Biología',4),
('BIO-301','Genética','Biología',4),
('CS-101','Introducción a la Informática','Informática',4),
('CS-315','Robótica','Informática',3),
('CS-347','Fundamentos de bases de datos','Informática',3),
('PHY-101','Fundamentos de Física','Física',4);
```

**OJO:** Aquí, preste atención a la siguiente sección de código y los comentarios. 

```SQL
INSERT INTO profesor VALUES
('10101','Srinivasan','Informática',65000),
('12121','Wu','Finanzas',90000),      -- no existe depto Finanzas, por ello dará un error en este bloque de código. Revise los datos de tabla departamento para identificar el error.
('22222','Einstein','Física',95000),
('76766','Crick','Biología',72000),
('83821','Brandt','Informática',92000);

-- Debido al error del profesor Wu, el bloque de código anterior no se ejecutará y dará un error. 
-- Posibles soluciones
	1) Agregar 'Finanzas' en la tabla 'departamento'
	2) Modificar la tupla 12121 del profesor Wu y cambiar 'finanzas' por un departamento que sí existe. 
-- En nuestro caso, se deberá emplear la opción 2. Editar a mano el código con el que se está agregando datos a 'profesores', específicamente el caso del profesor Wu cambiando el departamento de 'Finanzas' a 'Informática'.

--Para continuar, haga esa modificación manualmente y envíe el código para cargar los valores a la tabla de 'profesores'.

```

**NOTA:** En caso de necesitar modificar un atributo/campo de una entidad/tabla, aquí se muestra el código para hacerlo
```SQL
-- Considera que en caso de necesitar cambiar el dpto de un profesor se debería hacer un 'UPDATE' de esta manera:
-- Aquí un ejemplo de actualización de dpto en el caso del profesor Wu cuyo Id es 12121:
UPDATE profesor SET nombre_dept='Física' WHERE id='12121';
-- De esta manera, el profesor Wu, cambiaría de departamento de 'informática' a 'física'.

```

**Continuemos con la carga de datos:**
```SQL

INSERT INTO seccion VALUES
('CS-101',1,'Otoño',2009,'Packard','101','H'),
('CS-101',1,'Primavera',2010,'Packard','101','F'),
('CS-347',1,'Otoño',2009,'Taylor','3128','A'),
('BIO-101',1,'Verano',2009,'Painter','514','B'),
('PHY-101',1,'Otoño',2009,'Watson','100','A');

INSERT INTO imparte VALUES
('10101','CS-101',1,'Otoño',2009),
('83821','CS-347',1,'Otoño',2009),
('22222','PHY-101',1,'Otoño',2009);

INSERT INTO estudiante VALUES
('00128','Zhang',30), ('12345','Shankar',60), ('19991','Brandt',45);

INSERT INTO matricula VALUES
('00128','CS-101',1,'Otoño',2009,4.0),
('12345','CS-347',1,'Otoño',2009,3.7),
('19991','BIO-101',1,'Verano',2009,3.3);

INSERT INTO prerreq VALUES
('BIO-301','BIO-101'),
('CS-315','CS-101'),
('CS-347','CS-101');

```

### 2.1. Plantilla general

Una consulta típica usa **SELECT–FROM–WHERE**. SQL incluye estas cláusulas como núcleo del lenguaje de consultas.  

```sql
SELECT lista_de_columnas          -- proyección
FROM   tabla_o_tablas             -- origen de datos
WHERE  condiciones_de_filtrado;   -- selección
```

#### Alias (renombrado)

##### ¿Qué es un alias en SQL?
Un **alias** es un **nombre alternativo** (temporal) que le damos a una **columna** o a una **tabla** dentro de una consulta.

Se define con la palabra clave `AS` (aunque en muchos motores como MariaDB se puede omitir `AS` y poner solo el nombre).

👉 Los alias **no cambian** el nombre real de la tabla o columna en la base de datos; solo existen mientras se ejecuta la consulta.

##### Alias en columnas
Sirven para:
- Hacer más legibles los resultados.
- Dar nombres más claros en reportes.
- Usar nombres más cortos al manipular funciones o cálculos.

```sql
-- Ejemplo: promedio de sueldos por departamento
SELECT nombre_dept AS departamento,
       AVG(sueldo) AS promedio_sueldo
FROM profesor
GROUP BY nombre_dept;
```

Posible salida:

|departamento|promedio_sueldo|
|---|---|
|Informática|82333.33|
|Biología|72000.00|
|Física|95000.00|

> Sin alias, la columna aparecería como `AVG(sueldo)`, lo cual es menos legible.

##### Alias en tablas
Sirven para:
- Escribir **menos** cuando una tabla tiene un nombre largo.
- Evitar ambigüedad cuando se consultan varias tablas que tienen columnas con el mismo nombre.
- Hacer más claras las auto–joins (cuando una tabla se une consigo misma).

```sql
-- Ejemplo con alias cortos
SELECT p.nombre, e.asignatura_id
FROM profesor AS p
JOIN enseña   AS e ON p.id = e.id;
```

- `profesor` → `p`
- `enseña` → `e`

De esta forma, en lugar de escribir `profesor.id` y `enseña.id`, basta con `p.id` y `e.id`.

##### Auto–join con alias
Los alias son **imprescindibles** cuando una tabla se une consigo misma:

Ejemplo: encontrar profesores cuyo sueldo es mayor que el de algún profesor de Biología.
```sql
SELECT t.nombre AS profesor,
       t.sueldo,
       s.nombre AS colega_biologia,
       s.sueldo AS sueldo_bio
FROM profesor AS t
JOIN profesor AS s
  ON t.sueldo > s.sueldo
WHERE s.nombre_dept = 'Biología';
```

- La misma tabla `profesor` aparece dos veces, pero con alias distintos:
    - `t` = “tabla principal”
    - `s` = “subtabla de referencia”

Sin alias, sería imposible distinguir a qué instancia de `profesor` nos referimos.

##### Alias sin `AS`
MariaDB y MySQL permiten omitir `AS`:

```sql
-- Con AS
SELECT nombre AS profesor FROM profesor;

-- Sin AS
SELECT nombre profesor FROM profesor;
```

Ambas son equivalentes, pero **usar `AS` se recomienda didácticamente** porque hace explícito que estamos renombrando.

#####  Buenas prácticas con alias
1. **Nombres cortos para tablas** → `p`, `e`, `s` (cuando escribes mucho).
2. **Nombres descriptivos para columnas** → `promedio_sueldo`, `total_asignaturas`.
3. **Evita alias crípticos** que dificulten la lectura.
4. Usa alias siempre que hagas **subconsultas**:
    ```sql
    SELECT depto, promedio
    FROM (
      SELECT nombre_dept AS depto, AVG(sueldo) AS promedio
      FROM profesor
      GROUP BY nombre_dept
    ) AS resumen;
    ```
### 2.2. Proyección, origen y selección

**Ejemplo simple 1 — listado de profesores de Biología**
```sql
SELECT nombre
FROM profesor
WHERE nombre_dept = 'Biología';
```

**Ejemplo simple 2 — asignaturas de Otoño 2009**
```sql
SELECT asignatura_id
FROM seccion
WHERE semestre = 'Otoño' AND año = 2009; -- Aquí hay un error, identifiquelo!!!
```

**Orden y eliminación de duplicados**
```sql
SELECT DISTINCT nombre_dept
FROM profesor
ORDER BY nombre_dept;
```

(El estándar contempla `ORDER BY`; `DISTINCT` elimina duplicados.)  

> Cadenas y mayúsculas: recuerda la nota de sensibilidad a mayúsculas según collation.  

```MySQL
-- Departamentos sin duplicados
SELECT DISTINCT nombre_dept
FROM profesor
ORDER BY nombre_dept ASC;   -- ASC/DSC

-- Paginación simple
SELECT id, nombre FROM estudiante
ORDER BY id
LIMIT 10 OFFSET 0;          -- página 1
```

### 2.3. Predicados comunes

#### ¿Qué son los “predicados comunes” en SQL?
Un **predicado** es una expresión que el motor evalúa a **TRUE / FALSE / UNKNOWN** (lógica de 3 valores) y que se usa en `WHERE`, `HAVING`, `ON`, `CHECK` y `CASE`.  
Ej.: `sueldo > 80000` es un predicado; si `sueldo` es `NULL`, el resultado es `UNKNOWN`.

> Regla práctica: en `WHERE` solo pasan las filas cuyo predicado es **TRUE**.  
> `FALSE` y `UNKNOWN` (por `NULL`) se descartan.

A continuación, los **predicados más usados**, con ejemplos sobre el esquema “universidad” que hemos trabajado.
#### a) Comparación: =, <> (o !=), <, <=, >, >=

```sql
-- Profesores con s2ueldo alto
SELECT id, nombre, sueldo
FROM profesor
WHERE sueldo >= 90000;
```

- Con `NULL`, cualquier comparación produce `UNKNOWN` → la fila no pasa el `WHERE`.

#### b) `BETWEEN` (rango **incluye** extremos)

```sql
-- Sueldos entre 70k y 90k (70k y 90k incluidos)
SELECT nombre, sueldo
FROM profesor
WHERE sueldo BETWEEN 70000 AND 90000;

-- Negación
SELECT nombre, sueldo
FROM profesor
WHERE sueldo NOT BETWEEN 70000 AND 90000;
```

#### c) `IN` / `NOT IN` (pertenencia a conjunto)

```sql
-- Profesores de Biología o Informática
SELECT nombre, nombre_dept
FROM profesor
WHERE nombre_dept IN ('Biología','Informática');
```

> ⚠️ **Cuidado con `NOT IN` + `NULL`**  
> `x NOT IN (subconsulta)` puede devolver **cero filas** si la subconsulta trae algún `NULL`.  
> Prefiere `NOT EXISTS` (ver más abajo) o filtra `NULL` en la subconsulta:

```sql
-- Profesores que NO imparten ninguna sección (patrón correcto)
SELECT p.id, p.nombre
FROM profesor p
WHERE NOT EXISTS (
  SELECT 1
  FROM imparte i
  WHERE i.id = p.id
);
```

#### d) `LIKE` (patrones de cadena)

- `%` = cualquier cadena (incluida vacía)
- `_` = un solo carácter

```sql
-- Nombres que empiezan por 'S'
SELECT nombre FROM profesor
WHERE nombre LIKE 'S%';

-- Escapar el comodín (buscar literalmente '50%')
SELECT texto
FROM notas
WHERE texto LIKE '50\%%' ESCAPE '\';
```

> Mayúsculas/minúsculas: en MariaDB suelen ser **insensibles** por colación.  
> Para forzar sensibilidad usa `COLLATE utf8mb4_bin` o `LIKE BINARY 'Patrón'`.

```sql
-- Búsqueda sensible a mayúsculas
SELECT nombre
FROM profesor
WHERE nombre COLLATE utf8mb4_bin LIKE 'S%';
```

#### e) `IS NULL` / `IS NOT NULL` (nulos explícitos)

```sql
-- Registros con datos faltantes
SELECT id, nombre, sueldo
FROM profesor
WHERE sueldo IS NULL OR nombre_dept IS NULL;
```

> No uses  ni `<> NULL`: siempre dan `UNKNOWN`.

#### f) `EXISTS` / `NOT EXISTS` (subconsultas correlacionadas)

```sql
-- Asignaturas que tienen al menos una sección abierta en 2009
SELECT a.asignatura_id, a.nombre
FROM asignatura a
WHERE EXISTS (
  SELECT 1
  FROM seccion s
  WHERE s.asignatura_id = a.asignatura_id
    AND s.anio = 2009
);
```

- `EXISTS` es **verdadero** si la subconsulta devuelve **al menos una fila** (no importa su contenido).
- Patrón ideal para “hay/no hay relación” y para evitar el problema de `NOT IN + NULL`.
#### g) `ANY` / `ALL` (cuantificadores sobre subconsulta)

```sql
-- Profesores con sueldo mayor que el de TODOS los de Biología
SELECT nombre, sueldo
FROM profesor
WHERE sueldo > ALL (
  SELECT sueldo FROM profesor WHERE nombre_dept = 'Biología'
);

-- Mayor que AL MENOS UNO de Biología
SELECT nombre, sueldo
FROM profesor
WHERE sueldo > ANY (
  SELECT sueldo FROM profesor WHERE nombre_dept = 'Biología'
); -- ANY ≈ SOME
```

#### h) `REGEXP` (expresiones regulares de MariaDB)

```sql
-- Asignaturas que empiezan por 'CS-' seguidas de dígitos
SELECT asignatura_id, nombre
FROM asignatura
WHERE asignatura_id REGEXP '^CS-[0-9]+$';
```

> Útil cuando `LIKE` se queda corto. Ten en cuenta el costo sobre tablas grandes.

#### i) Combinación lógica: `AND`, `OR`, `NOT` (y `UNKNOWN`)

En SQL, cuando se utilizan múltiples operadores lógicos (`AND`, `OR`, `NOT`) dentro de una misma condición (especialmente en la cláusula `WHERE`), existe un orden de precedencia que determina cómo se evalúan estas operaciones. La regla es la siguiente:

• **NOT** tiene la mayor precedencia.
• Luego le sigue **AND**.
• Finalmente, **OR** tiene la menor precedencia.

Esto significa que las operaciones `NOT` se evalúan primero, luego las `AND`, y por último las `OR`. Para **evitar ambigüedades** o forzar un orden de evaluación diferente al predeterminado, se deben usar **paréntesis** **()**. Al encerrar partes de la condición entre paréntesis, se asegura que esas expresiones se evalúen primero, independientemente de la precedencia de los operadores que contengan.

```sql
-- Profesores de Informática con sueldo entre 80k y 100k
SELECT nombre, sueldo
FROM profesor
WHERE nombre_dept = 'Informática'
  AND sueldo BETWEEN 80000 AND 100000;

-- Uso de paréntesis para evitar ambigüedad
SELECT *
FROM asignatura
WHERE nombre_dept = 'Física'
  AND (creditos = 3 OR creditos = 4);
```

**Precedencia**: `NOT` > `AND` > `OR`. Usa paréntesis si hay dudas.

> Mini‐tabla mental con `UNKNOWN`:
> - `TRUE AND UNKNOWN` → `UNKNOWN` (se filtra en `WHERE`)
> - `FALSE OR UNKNOWN` → `UNKNOWN`
> - `NOT UNKNOWN` → `UNKNOWN`

#### Consejos de uso y rendimiento

- En `LIKE`, un patrón que **empieza** con `%` (ej. `%algo`) **no** usa índice → puede ser lento.
- `IN` con pocos literales suele ser eficiente; con subconsultas correlacionadas, compara con `EXISTS`.
- Si esperas `NULL` en la subconsulta, evita `NOT IN`; usa `NOT EXISTS`.
- Documenta la **intención**: escribe filtros simples y añade comentarios en las consultas complejas.
#### Mini-resumen 

| Predicado                       | Para…                       | Ejemplo                             |
| ------------------------------- | --------------------------- | ----------------------------------- |
| <>`, `<`, `<=`, `>`, `>=` | Comparar valores            | `sueldo >= 90000`                   |
| `BETWEEN a AND b`               | Rango **incluye** extremos  | `creditos BETWEEN 3 AND 4`          |
| `IN (…)/NOT IN`                 | Conjunto                    | `nombre_dept IN ('Bio','Info')`     |
| `LIKE`                          | Patrón simple               | `nombre LIKE 'S_%'`                 |
| `IS NULL`                       | Nulos                       | `nota IS NULL`                      |
| `EXISTS`                        | “Hay filas” en subconsulta  | `EXISTS (SELECT 1 …)`               |
| `ANY`/`ALL`                     | Cuantificar contra conjunto | `sueldo > ALL (SELECT …)`           |
| `REGEXP`                        | Patrón avanzado             | `codigo REGEXP '^[A-Z]{3}-[0-9]+$'` |

Aquí otros ejemplos:

```sql
-- Rango
SELECT nombre, sueldo
FROM profesor
WHERE sueldo BETWEEN 70000 AND 90000;   -- inclusivo

-- Conjunto
SELECT nombre, nombre_dept
FROM profesor
WHERE nombre_dept IN ('Biología','Informática');

-- Patrón (LIKE: % = cualquier cadena; _ = un carácter)
SELECT nombre
FROM profesor
WHERE nombre LIKE 'S%';

-- Nulos (usa IS NULL / IS NOT NULL)
SELECT nombre
FROM profesor
WHERE sueldo IS NULL OR nombre_dept IS NULL;

-- Lógicos: AND, OR, NOT (recuerda la lógica de 3 valores con NULL)
SELECT *
FROM asignatura
WHERE NOT (creditos = 3) OR nombre_dept = 'Física';
```

¡Perfecto! Para consolidar el tema de **2.3. Predicados comunes**, aquí tienes una serie de **mini-ejercicios de refuerzo** diseñados para que tus estudiantes practiquen lo aprendido.

### Mini-ejercicios de refuerzo — Predicados comunes

##### 1) Comparación
Muestra los profesores cuyo sueldo es **mayor o igual a 90 000**.
```sql
-- Completa la condición
SELECT id, nombre, sueldo
FROM profesor
WHERE ............. ;
```
##### 2) BETWEEN
Lista las asignaturas que tienen entre **3 y 4 créditos** (incluidos los extremos).
```sql
SELECT asignatura_id, nombre, creditos
FROM asignatura
WHERE ............. ;
```
##### 3) IN / NOT IN
Obtén los nombres de los profesores que trabajan en los departamentos **Biología o Informática**.
```sql
SELECT nombre, nombre_dept
FROM profesor
WHERE ............. ;
```

👉 Extensión: cambia la consulta para obtener los profesores que **NO** trabajan en esos departamentos.

##### 4) LIKE
Encuentra los estudiantes cuyo nombre **empiece con la letra "B"**.
```sql
SELECT id, nombre
FROM estudiante
WHERE ............. ;
```

👉 Variante: busca profesores cuyo nombre **termine con “n”**.

##### 5) IS NULL / IS NOT NULL
Lista todas las matrículas en las que la **nota todavía no ha sido asignada** (`nota IS NULL`).
```sql
SELECT id, asignatura_id, semestre, anio
FROM matricula
WHERE ............. ;
```

##### 6) EXISTS
Muestra las asignaturas que tienen al menos **una sección ofertada en el año 2009**.
```sql
SELECT a.asignatura_id, a.nombre
FROM asignatura a
WHERE ............. (
  SELECT 1
  FROM seccion s
  WHERE s.asignatura_id = a.asignatura_id
    AND s.anio = 2009
);
```
##### 7) ANY / ALL
Encuentra los profesores cuyo sueldo sea **mayor que el de todos los profesores de Biología**.
```sql
SELECT nombre, sueldo
FROM profesor
WHERE sueldo > ALL (
  SELECT sueldo
  FROM profesor
  WHERE nombre_dept = 'Biología'
);
```
##### 8) REGEXP
Lista las asignaturas cuyo código comience con **“CS-” seguido de números** (ej. `CS-101`).
```sql
SELECT asignatura_id, nombre
FROM asignatura
WHERE asignatura_id REGEXP ............. ;
```
##### 9) Combinación lógica
Muestra todas las asignaturas del departamento de **Física** que tengan **3 o 4 créditos**.
```sql
SELECT asignatura_id, nombre, creditos
FROM asignatura
WHERE nombre_dept = 'Física'
  AND (creditos = 3 OR ............. );
```

### 2.4 Agregación + `GROUP BY` / `HAVING` (explicado a fondo)

#### Idea clave

Una **agregación** resume varias filas en **un solo valor** por **grupo**.  
Si no hay `GROUP BY`, se considera **toda la tabla** como un único grupo.

- Funciones típicas: `COUNT(*)`, `COUNT(col)`, `COUNT(DISTINCT col)`, `SUM`, `AVG`, `MIN`, `MAX`.
- Las agregaciones **ignoran `NULL`** (excepto `COUNT(*)`, que cuenta filas aunque una columna sea `NULL`).

#### Flujo mental (orden lógico de ejecución)

1. `FROM` (+ `JOINs`) → 2) `WHERE` (filtra filas) →
2. `GROUP BY` (forma grupos) → 4) **Agregación** →
3. `HAVING` (filtra **grupos**) → 6) `SELECT` → 7) `ORDER BY` → 8) `LIMIT`.

> Regla de oro: **`WHERE` filtra filas; `HAVING` filtra grupos** (usa `HAVING` solo si el filtro depende de agregados).

#### Diferencias importantes (con `NULL` y variantes de `COUNT`)

```sql
-- Cuenta todas las filas (incluye filas aunque sueldo sea NULL)
SELECT COUNT(*) FROM profesor;

-- Cuenta solo filas donde sueldo NO es NULL
SELECT COUNT(sueldo) FROM profesor;

-- Cuenta valores distintos (no cuenta NULL)
SELECT COUNT(DISTINCT nombre_dept) FROM profesor;
```

> `AVG(col)` ignora `NULL`. Si no hay filas tras el `WHERE`, `AVG` devuelve `NULL`.  
> Úsalo con `COALESCE` si quieres un valor por defecto: `COALESCE(AVG(col), 0)`.

#### `GROUP BY` correcto (y error típico)

Cada expresión del `SELECT` debe ser:
- o bien **agregada** (`SUM(...)`, `MAX(...)`…),
- o bien aparecer en el **`GROUP BY`**

```sql
-- ✔ Correcto: todas las no agregadas están en GROUP BY
SELECT nombre_dept, COUNT(*) AS total
FROM profesor
GROUP BY nombre_dept;

-- ✖ Incorrecto (cuando está activo ONLY_FULL_GROUP_BY):
SELECT nombre_dept, nombre 
FROM profesor 
GROUP BY nombre_dept;
--'nombre' no está en GROUP BY ni es agregada → ambiguo
```

> Si tu servidor permite la consulta “ambigua”, elige **activar** `ONLY_FULL_GROUP_BY` en `sql_mode` para evitar resultados sorprendentes.

#### `HAVING` (cuándo usarlo y cómo optimizar)

`HAVING` filtra **después** de agrupar y **sí** puede referirse a agregados.

```sql
-- Promedio por depto, pero solo departamentos con promedio > 80k
SELECT nombre_dept, AVG(sueldo) AS promedio
FROM profesor
GROUP BY nombre_dept
HAVING AVG(sueldo) > 80000;   -- o HAVING promedio > 80000
```

**Optimización**: todo filtro que **no** necesite agregados (p. ej. `nombre_dept='Informática'`) ponlo en `WHERE` para reducir filas **antes** de agrupar.

```sql
-- Mejor: filtra primero, agrupa después
SELECT nombre_dept, AVG(sueldo) AS promedio
FROM profesor
WHERE nombre_dept IN ('Informática','Física')   -- filtro temprano
GROUP BY nombre_dept
HAVING AVG(sueldo) > 80000;
```

#### Ejemplos guiados

##### 1) Conteos por grupo y orden

```sql
-- ¿Cuántos profesores hay por departamento?
SELECT
  nombre_dept,
  COUNT(*) AS total_profes
FROM profesor
GROUP BY nombre_dept
ORDER BY total_profes DESC;   -- ordena por el agregado
```

##### 2) Filtrar grupos con `HAVING`

```sql
-- Departamentos cuyo salario promedio supera 80k
SELECT
  nombre_dept,
  AVG(sueldo) AS promedio
FROM profesor
GROUP BY nombre_dept
HAVING promedio > 80000;   -- podemos usar el alias en HAVING en MariaDB
```

##### 3) `COUNT(DISTINCT ...)` y claves compuestas

```sql
-- Asignaturas únicas ofertadas por (semestre, año)
SELECT
  semestre,
  anio,
  COUNT(DISTINCT asignatura_id) AS cursos_unicos
FROM seccion
GROUP BY semestre, anio
ORDER BY anio, semestre;

-- Distintos pares (asignatura, sección) en 2009
SELECT COUNT(DISTINCT asignatura_id, secc_id) AS ofertas_unicas_2009
FROM seccion
WHERE anio = 2009;
```

##### 4) Tratamiento de `NULL` en agregaciones

```sql
-- Si no hubo matrículas en 2009, AVG(nota) sería NULL → repón 0
SELECT COALESCE(AVG(nota), 0) AS promedio_nota
FROM matricula
WHERE anio = 2009;
```

##### 5) Agregación condicional (muy útil para reportes)

```sql
-- Conteo de secciones por semestre en 2009 (pivot mini con CASE)
SELECT
  anio,
  SUM(CASE WHEN semestre='Primavera' THEN 1 ELSE 0 END) AS prim_2009,
  SUM(CASE WHEN semestre='Verano'     THEN 1 ELSE 0 END) AS ver_2009,
  SUM(CASE WHEN semestre='Otoño'      THEN 1 ELSE 0 END) AS oto_2009
FROM seccion
WHERE anio = 2009
GROUP BY anio;
```

##### 6) Promedios ponderados (patrón frecuente)

```sql
-- Promedio ponderado de notas por estudiante, ponderando por créditos de la asignatura
SELECT
  m.id AS estudiante_id,
  ROUND(SUM(m.nota * a.creditos) / NULLIF(SUM(a.creditos), 0), 2) AS promedio_pond
FROM matricula AS m
JOIN asignatura AS a USING (asignatura_id)
GROUP BY m.id;

-- NOTA: NULLIF evita división por 0; si no tiene créditos → resultado NULL
```

##### 7) Totales con `WITH ROLLUP`

```sql
-- Totales por departamento y gran total
SELECT nombre_dept, COUNT(*) AS total_profes
FROM profesor
GROUP BY nombre_dept WITH ROLLUP;

-- La fila de 'gran total' trae nombre_dept = NULL → dale etiqueta:
SELECT COALESCE(nombre_dept, 'TOTAL') AS grupo, COUNT(*) AS total
FROM profesor
GROUP BY nombre_dept WITH ROLLUP;
```

#### Errores típicos y cómo evitarlos

1. **Usar `HAVING` para todo**: si el filtro no depende de agregados, **muévelo a `WHERE`**.
2. **Elegir mal la columna de conteo**:
    - `COUNT(*)` cuenta filas;
    - `COUNT(col)` ignora filas donde `col` es `NULL`.
3. **Seleccionar columnas no agrupadas**: activa `ONLY_FULL_GROUP_BY` para forzar buenas prácticas.
4. **Olvidar `DISTINCT`** cuando quieres valores únicos (o usar `DISTINCT` sin necesitarlo, encareciendo el cálculo).
5. **Promedios “raros” por `NULL`**: usa `COALESCE` en agregados o `WHERE col IS NOT NULL`.

### Mini-ejercicios de refuerzo

1. **Top-3** departamentos por número de asignaturas ofertadas en 2009.
2. Para cada **profesor**, cuántas **secciones** impartió por **año** (usa `GROUP BY id, anio`).
3. Nota media por estudiante y **ranking** simple (sin ventanas): ordena de mayor a menor.
4. Número de prerrequisitos por asignatura (`COUNT(prerreq_id)`).

### 2.5 Depuración y comprobaciones 

#### 1) “Ensayo general” antes de tocar datos

**Patrón seguro**: prueba con `SELECT` exactamente la **misma condición** que usarás en `UPDATE/DELETE`.  
Así validas que no te “lleves” filas de más (o de menos).

```sql
-- 1) ENSAYO (no muta datos)
SELECT id, nombre, sueldo
FROM profesor
WHERE nombre_dept = 'Informática';

-- 2) AHORA SÍ: aplica el cambio (misma condición)
UPDATE profesor
SET sueldo = sueldo * 1.05
WHERE nombre_dept = 'Informática';
```

#### Pro tip (aún más seguro): usa transacción

```sql
START TRANSACTION;

-- Ensayo cuantitativo
SELECT COUNT(*) AS candidatos
FROM profesor
WHERE nombre_dept = 'Informática';

-- Cambio real
UPDATE profesor
SET sueldo = sueldo * 1.05
WHERE nombre_dept = 'Informática';

-- Verifica impacto
SELECT ROW_COUNT() AS filas_afectadas;  -- debería ≈ candidatos

-- ¿Todo OK?
-- COMMIT;
-- ¿Algo raro?
ROLLBACK;
```

> 💡 `ROW_COUNT()` te dice cuántas filas afectó la última sentencia DML.  
> 💡 Activa guardarraíl temporal: `SET sql_safe_updates = 1;` (impide UPDATE/DELETE sin `WHERE` o sin clave).
#### 2) Ver resultados intermedios (divide y vencerás)

Cuando la consulta es compleja, **parte** el problema:

```sql
-- Paso 1: ver filas filtradas (sin agrupar)
SELECT * 
FROM profesor
WHERE nombre_dept = 'Informática';

-- Paso 2: ahora agrega sobre ese mismo filtro
SELECT nombre_dept, AVG(sueldo) AS promedio
FROM profesor
WHERE nombre_dept = 'Informática'
GROUP BY nombre_dept;
```

Otros dos enfoques útiles:

**a) Comenta bloques** con `/* ... */` para “apagar” trozos:

```sql
SELECT nombre_dept, AVG(sueldo) AS promedio
FROM profesor
/* WHERE sueldo > 80000 */       -- apaga/enciende esta línea
GROUP BY nombre_dept;
```

**b) Encapsula subpasos** (derivada o CTE) para inspeccionar:

La idea es **envolver partes intermedias de una consulta** dentro de una **subconsulta derivada** (`FROM ( ... ) AS alias`) o de una **CTE (Common Table Expression, `WITH ...`)**. Esto permite “aislar” ese subpaso, ejecutarlo por separado y ver si devuelve lo esperado, antes de integrarlo en la consulta completa.

##### Ejemplo con **subconsulta derivada**

Supongamos que quieres obtener los departamentos con sueldo medio mayor a 80 000:

``` SQL
SELECT nombre_dept, promedio 
FROM (
   SELECT nombre_dept, AVG(sueldo) AS promedio   
   FROM profesor   
   GROUP BY nombre_dept ) 
   AS depto_avg WHERE promedio > 80000;
```

Aquí:
- La parte `SELECT nombre_dept, AVG(sueldo)...` está “encapsulada” como una tabla temporal (`depto_avg`).
- Puedes ejecutar **solo esa subconsulta** para revisar si los promedios se calculan bien.
- Luego añades el filtrado externo (`WHERE promedio > 80000`).

##### Ejemplo con **CTE (Common Table Expression)**

Las CTE son más legibles, porque definen los subpasos con nombre:

``` SQL
WITH depto_avg AS (
   SELECT nombre_dept, AVG(sueldo) AS promedio   
   FROM profesor   
   GROUP BY nombre_dept 
) 
SELECT nombre_dept, promedio 
FROM depto_avg 
WHERE promedio > 80000;
```

Ventajas:
- `WITH` hace más clara la lógica paso a paso.
- Permite reutilizar el mismo resultado intermedio en varias partes de la consulta.

#### 3) Usa `EXPLAIN` para “ver” el plan y bajar el costo

`EXPLAIN` **no ejecuta** la consulta; muestra cómo **planea** ejecutarla el optimizador: qué tablas lee, si hará **full scan**, si puede usar **índices**, si creará **tablas temporales**, etc.

```sql
EXPLAIN
SELECT nombre_dept, AVG(sueldo)
FROM profesor
WHERE nombre_dept = 'Informática'
GROUP BY nombre_dept;
```

##### Cómo leer lo importante

- **type**: calidad del acceso. (De peor a mejor: `ALL` → `range/ref` → `const`/`eq_ref`).
- **key / possible_keys**: qué índice usa (o podría usar).
- **rows**: filas **estimadas** a leer. Menos es mejor.
- **Extra**:
    - `Using where` → aplica filtro.
    - `Using temporary` → crea tabla temporal (típico en `GROUP BY`/`ORDER BY`).
    - `Using filesort` → ordenación extra (no implica disco necesariamente, pero puede costar)
##### Empujar filtros “temprano”

Si pones el filtro en `HAVING`, el motor **agrupa primero** y filtra después → más trabajo.  
Si lo pones en `WHERE` (cuando sea posible), **reduce** filas antes de agrupar.

```sql
-- Menos eficiente (agrupa todo y luego filtra):
SELECT nombre_dept, AVG(sueldo) AS prom
FROM profesor
GROUP BY nombre_dept
HAVING prom > 80000;

-- Más eficiente (filtra antes):
SELECT nombre_dept, AVG(sueldo) AS prom
FROM profesor
WHERE sueldo > 80000
GROUP BY nombre_dept;
```

> 🧠 Regla: **Si el predicado no usa agregados**, llévalo a `WHERE`.

##### Índices que ayudan a agrupar/filtrar

Para `WHERE nombre_dept = 'Informática' GROUP BY nombre_dept`, un índice en `nombre_dept` reduce lecturas:

```sql
CREATE INDEX idx_profesor_dept ON profesor(nombre_dept);
```

- Repite `EXPLAIN` y compara **type**, **rows** y **Extra**.
- En agrupaciones grandes, verás a veces `Using temporary`; aceptable, pero un buen índice puede bajar el costo de lectura previa.
##### Ordenación y `ORDER BY`

Si ordenas por una columna **indexada y compatible** con el plan, `EXPLAIN` puede evitar `filesort`.
```sql
-- Si existe idx_profesor_dept, este ORDER BY puede aprovecharlo
SELECT nombre_dept, COUNT(*) AS total
FROM profesor
GROUP BY nombre_dept
ORDER BY nombre_dept;
```

#### 4) Patrón “prueba y confirma” para `DELETE` masivo

Borrar por lotes reduce bloqueos y te permite **verificar**:
```sql
-- Ensayo: ¿qué borrarías?
SELECT id, nombre
FROM profesor
WHERE nombre_dept = 'Historia'
ORDER BY id
LIMIT 100;

-- Borrado por lotes (en transacción)
START TRANSACTION;
DELETE FROM profesor
WHERE nombre_dept = 'Historia'
ORDER BY id
LIMIT 100;             -- solo las primeras 100
SELECT ROW_COUNT() AS borradas;
COMMIT;
```

> 💡 Conjunta `ORDER BY` + `LIMIT` en `DELETE` para lotes previsibles.  
> 💡 Repite hasta que `ROW_COUNT()` devuelva 0.

#### 5) “Dry run” para `UPDATE` con expresiones

A veces la expresión es compleja (proporciones, `CASE`, etc.). Replica la **misma** lógica en un `SELECT` para visualizar el nuevo valor:

```sql
-- Dry run: ver nuevo sueldo calculado
SELECT id, nombre, sueldo,
       sueldo * 1.07 AS sueldo_nuevo
FROM profesor
WHERE nombre_dept = 'Física';

-- Cambio real con la misma fórmula:
UPDATE profesor
SET sueldo = sueldo * 1.07
WHERE nombre_dept = 'Física';
```

#### 6) Concurrencia mínima: bloquea lo que vas a tocar (cuando aplique)

Si vas a leer y luego **actualizar** filas “críticas” (por clave), usa `FOR UPDATE` dentro de una transacción para evitar carreras:

```sql
START TRANSACTION;

-- Lee y bloquea las filas objetivo
SELECT id, sueldo
FROM profesor
WHERE id = '83821'
FOR UPDATE;

-- Aplica cambio coherente
UPDATE profesor
SET sueldo = sueldo + 1000
WHERE id = '83821';

COMMIT;
```

> Úsalo con moderación: bloquea justo lo necesario.

#### 7) Checklist rápido antes de pulsar “Enter”
- ¿Probé la condición con `SELECT`?
- ¿Sé cuántas filas voy a afectar (`COUNT(*)` / `ROW_COUNT()`)?
- ¿Tengo transacción y posibilidad de `ROLLBACK`?
- ¿Puedo mover filtros a `WHERE` para **filtrar temprano**?
- ¿Un índice en las columnas de **filtro** o **join** bajaría el costo según `EXPLAIN`?
- ¿Necesito lotes (`ORDER BY ... LIMIT`) para minimizar bloqueos?

#### Mini-ejercicios de depuración

1. **Bajar 3%** el sueldo de todos los profesores con sueldo > **percentil 90** del total (pista: subconsulta + `WHERE`; prueba con `SELECT` primero).
2. Eliminar **matrículas duplicadas exactas** dejando solo una por `(id, asignatura_id, secc_id, semestre, anio)` (pista: CTE/derivada con `ROW_NUMBER()` _no está en MariaDB clásico_, usa `GROUP BY` + `MIN()` de `pk` auxiliar o crea una tabla temporal).
3. Encontrar consultas con `HAVING` que puedas reescribir moviendo filtros a `WHERE`; demuestra en `EXPLAIN` que cae el estimado de `rows`.


### 2.6. JOINs básicos
Un **JOIN** sirve para combinar filas de dos o más tablas basándose en una condición lógica. Es el “puente” entre tablas relacionadas.
#### 1. Estilo antiguo (coma + `WHERE`)
```sql
SELECT p.nombre, e.asignatura_id
FROM profesor AS p, enseña AS e
WHERE p.ID = e.ID;
```

- Funciona, pero es **menos legible**: la condición de unión se mezcla con otros filtros.
- Si olvidas el `WHERE`, produces un **producto cartesiano** (todas las combinaciones → explosión de filas).

👉 Se recomienda **evitarlo** en proyectos reales.

#### 2. JOIN moderno (ANSI SQL, recomendado)

```sql
SELECT p.nombre, e.asignatura_id
FROM profesor AS p
JOIN enseña   AS e ON p.ID = e.ID;
```

- La condición de unión (`ON`) queda **separada** de los filtros (`WHERE`).
- Más fácil de leer y mantener.
- Compatible con OUTER JOIN (que el estilo antiguo no soporta).

**ANSI** son las siglas de **American National Standards Institute** (Instituto Nacional Estadounidense de Estándares).  
Es una organización privada sin fines de lucro que coordina el desarrollo de **estándares técnicos** en muchas áreas: desde tornillos hasta protocolos de telecomunicaciones.
#### 📌 ANSI y las bases de datos

En el contexto de SQL, cuando hablamos de **“ANSI SQL”**, nos referimos al **estándar del lenguaje SQL definido por ANSI** (y también por ISO).
- En 1986, ANSI publicó el primer estándar oficial de SQL.
- Desde entonces ha habido varias versiones (SQL-89, SQL-92, SQL:1999, SQL:2003, SQL:2011, etc.).
- El estándar busca que cualquier sistema gestor de bases de datos (Oracle, SQL Server, PostgreSQL, MySQL/MariaDB…) use **un mismo núcleo de instrucciones SQL** (ej.: `SELECT`, `JOIN`, `INSERT`, `UPDATE`, `DELETE`).

👉 Ejemplo:
`-- Esto es ANSI SQL (válido en cualquier SGBD) SELECT nombre, sueldo FROM profesor WHERE sueldo > 80000;`

#### 📌 ANSI SQL vs. extensiones de cada motor

Cada motor añade **extensiones propietarias**:

- Oracle tiene `CONNECT BY` para jerarquías.
- MySQL/MariaDB tienen `LIMIT`.
- SQL Server tiene `TOP`.

Estas no siempre son parte del estándar ANSI.
#### 📌 ¿Por qué es importante?

- **Portabilidad**: consultas ANSI son más fáciles de mover de un sistema a otro.
- **Legibilidad**: estilo ANSI de `JOIN` (con `JOIN ... ON`) es más claro que el estilo antiguo de coma.
- **Compatibilidad académica**: al enseñar SQL, lo mejor es partir del ANSI (luego ver particularidades de cada SGBD).

#### 3. `NATURAL JOIN`

```sql
SELECT nombre_dept, COUNT(*) AS total
FROM profesor NATURAL JOIN enseña
WHERE semestre='Primavera' AND anio=2010
GROUP BY nombre_dept;
```

- Une automáticamente por **todas** las columnas con el mismo nombre en ambas tablas (`ID` en este caso).
- Elimina columnas duplicadas en el resultado.

⚠️ **Cuidado:**
- Si las tablas comparten más columnas con el mismo nombre (ej. `nombre_dept`), también se unirán → puede dar resultados incorrectos.
- Por eso, **no se recomienda en sistemas grandes**, salvo en entornos controlados (ejercicios didácticos).

#### 4. Variantes útiles: `USING` y `ON`

```sql
-- USING (cuando las columnas tienen el mismo nombre)
SELECT p.nombre, e.asignatura_id
FROM profesor p
JOIN enseña e USING (ID);

-- ON (condiciones más complejas)
SELECT p.nombre, e.asignatura_id
FROM profesor p
JOIN enseña e ON p.ID = e.ID AND e.semestre='Otoño';
```

👉 `USING` es conciso, `ON` es flexible.
#### 5. Errores típicos al unir tablas

- ❌ Usar `NATURAL JOIN` sin saber qué columnas coinciden.
- ❌ Olvidar condición de unión (`JOIN ... ON ...`) → producto cartesiano.
- ❌ Colocar filtros de la tabla derecha en `WHERE` en vez de en `ON` al usar `LEFT JOIN`, lo que convierte el JOIN en INNER.
#### Ejemplo

**Pregunta**: ¿Qué profesores impartieron cursos en 2009?

```sql
SELECT p.nombre, s.asignatura_id, s.semestre, s.anio
FROM profesor p
JOIN imparte i ON p.id = i.id
JOIN seccion s ON i.asignatura_id = s.asignatura_id
              AND i.secc_id = s.secc_id
              AND i.semestre = s.semestre
              AND i.anio = s.anio
WHERE s.anio = 2009;
```

> Aquí se usan varios `JOIN ... ON` para respetar la clave compuesta de `seccion`.  
> Es más largo, pero **explícito** y fácil de verificar.
### 2.7. Operaciones de conjuntos 

SQL permite combinar resultados de **consultas independientes** como si fueran conjuntos matemáticos.

#### 1. `UNION` (unión sin duplicados)

```sql
(SELECT asignatura_id FROM seccion WHERE semestre='Otoño' AND anio=2009)
UNION
(SELECT asignatura_id FROM seccion WHERE semestre='Primavera' AND anio=2010);
```

- Une resultados y elimina duplicados (usa un paso extra de `DISTINCT`).
- Puede ser más lento que `UNION ALL`.

#### 2. `UNION ALL` (unión con duplicados)

```sql
(SELECT asignatura_id FROM seccion WHERE semestre='Otoño' AND anio=2009)
UNION ALL
(SELECT asignatura_id FROM seccion WHERE semestre='Primavera' AND anio=2010);
```

- Mantiene los duplicados.
- Más rápido, porque no requiere comparar/eliminar repeticiones.
- Útil para contar ocurrencias.

####  3. `INTERSECT` (intersección)

```sql
(SELECT asignatura_id FROM seccion WHERE semestre='Otoño' AND anio=2009)
INTERSECT
(SELECT asignatura_id FROM seccion WHERE semestre='Primavera' AND anio=2010);
```

- Devuelve solo las filas presentes en **ambos conjuntos**.
- ⚠️ No está implementado en todas las versiones de MySQL/MariaDB (se emula con `JOIN`).

#### 4. `EXCEPT` o `MINUS` (diferencia)

```sql
(SELECT asignatura_id FROM seccion WHERE semestre='Otoño' AND anio=2009)
EXCEPT
(SELECT asignatura_id FROM seccion WHERE semestre='Primavera' AND anio=2010);
```

- Devuelve filas del primer conjunto que no aparecen en el segundo.
- ⚠️ No estándar en MariaDB → se emula con `LEFT JOIN ... IS NULL` o `NOT IN`.

#### Ejemplo práctico: cursos únicos por año

```sql
-- Asignaturas que se ofrecieron en 2009 pero no en 2010
SELECT asignatura_id
FROM seccion s2009
WHERE s2009.anio = 2009
  AND asignatura_id NOT IN (
    SELECT asignatura_id FROM seccion WHERE anio = 2010
  );
```

#### Consejos prácticos

- Usa `UNION` si necesitas eliminar duplicados, `UNION ALL` si no.
- Si tu motor no soporta `INTERSECT` o `EXCEPT`, usa `JOIN` + `WHERE` o `NOT EXISTS`.
- Siempre que uses operaciones de conjuntos, asegúrate de que ambas consultas tengan el **mismo número y tipo de columnas**.

