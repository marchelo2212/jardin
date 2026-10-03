---
publish: true
created: 2025-09-24T08:54
modified: 2025-09-30T05:57:47-05:00
---

# Tabla puente

También llamada _tabla intermedia_, _junction table_ o _entidad asociativa_.
Considere que los ejemplos descritos parten del caso de Universidad que hemos trabajo en clase.

## Qué es y para qué sirve

- Es una **tabla que resuelve una relación muchos-a-muchos (N:M)** entre dos (o más) entidades del modelo.
- Convierte esa relación N:M en **dos relaciones 1:N**, garantizando integridad y evitando duplicación.
- Además de enlazar, puede **almacenar atributos propios de la relación** (p. ej., fecha de inscripción, rol, nota).

## Cuándo la necesitas

- Cuando A ↔ B tiene cardinalidad **N:M**:
  - _Student_ ↔ _Course_ (un estudiante cursa muchos cursos y un curso tiene muchos estudiantes) → **Enrollment**.
  - _Libro_ ↔ _Autor_ → **BookAuthor**.
  - **Auto-relación** N:M (seguidores en redes): _User_ ↔ _User_ → **UserFollow**.
- En **relaciones ternarias** (A–B–C) que requieren mantener una **combinación única de tres claves** (p. ej., _Student–Course–Semester_).

## Estructura típica

Una tabla puente suele contener:

1. **Claves foráneas** a las entidades que vincula (NOT NULL).
2. **Clave primaria** que **garantiza unicidad** de la pareja (o tercia) vinculada.
3. **Atributos de la relación** (opcionales).
4. **Restricciones** para reflejar reglas de negocio (UNIQUE, CHECK, ON DELETE…).

### Dos patrones de clave primaria

- **PK compuesta** (recomendada si solo enlazas y no necesitas referenciar la fila desde otros lados):
  - PK = `(fk_a, fk_b)` y `UNIQUE` implícita por la PK.
- **PK surrogate (id autoincremental)** + `UNIQUE(fk_a, fk_b)`:
  - Útil si la fila tendrá **muchos atributos**, si habrá **FK externas** apuntando a este enlace, o **historial**.

## Ejemplo (MySQL/MariaDB) en el caso de Universdiad:

Student ↔ Course → Enrollment

```sql
-- Opción A: PK compuesta
CREATE TABLE enrollment (
  student_id INT NOT NULL,
  course_id  INT NOT NULL,
  enrolled_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  grade TINYINT,
  PRIMARY KEY (student_id, course_id),   -- unicidad del par
  CONSTRAINT fk_enr_student FOREIGN KEY (student_id) REFERENCES student(student_id)
    ON DELETE CASCADE,
  CONSTRAINT fk_enr_course  FOREIGN KEY (course_id)  REFERENCES course(course_id)
    ON DELETE RESTRICT
);

-- Opción B: surrogate key + UNIQUE
CREATE TABLE enrollment (
  enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  course_id  INT NOT NULL,
  enrolled_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  grade TINYINT,
  UNIQUE (student_id, course_id),     -- evita duplicados
  FOREIGN KEY (student_id) REFERENCES student(student_id),
  FOREIGN KEY (course_id)  REFERENCES course(course_id)
);

-- Índices útiles (según consultas más frecuentes)
CREATE INDEX idx_enr_course_student ON enrollment (course_id, student_id);
CREATE INDEX idx_enr_student_course ON enrollment (student_id, course_id);
```

## Cómo llega desde el E-R al relacional

- En el **modelo E-R** trazas una **relación N:M** entre _STUDENT_ y _COURSE_.
- En el **modelo relacional**, esa relación se **mapea** a una **tabla asociativa** con las FKs a cada entidad.
- Si la relación tiene atributos (p. ej., _grade_), **van en la tabla puente** (no en _student_ ni _course_).

## Reglas de negocio típicas (y cómo implementarlas)

- **“Un estudiante no puede inscribirse dos veces al mismo curso”** → PK compuesta o `UNIQUE(student_id, course_id)`.
- **“Si borro un estudiante, borro sus inscripciones”** → `ON DELETE CASCADE` en `fk_enr_student`.
- **“Si un curso tiene historial, no se puede borrar”** → `ON DELETE RESTRICT` en `fk_enr_course`.
- **“La nota debe ser 0–100”** → `CHECK (grade BETWEEN 0 AND 100)`.

## Buenas prácticas

- **Nombre descriptivo**: `enrollment`, `book_author`, `user_follow` (o `student_course` si prefieres compuesto).
- **FKs NOT NULL** (la relación no existe sin ambos lados).
- **Unicidad** del par/terna con PK compuesta o `UNIQUE`.
- **Índices** alineados a los JOIN y filtros más usados.
- **Evitar datos derivados** en la puente (p. ej., totales que se pueden calcular).
- **Transacciones** al insertar desde múltiples sesiones para que el `UNIQUE` evite “doble vínculo” por carrera de concurrencia.

## ¿Es una entidad débil?

- No por definición. Es una **entidad asociativa**.
- Puede _comportarse como débil_ si su identidad depende completamente de las FKs y no tiene clave propia; aun así, en la práctica la nombramos **tabla puente** o **entidad asociativa** para N:M.

# Constraint

## Qué es un constraint

Un **constraint** (restricción) es una **regla que el SGBD hace cumplir automáticamente** para proteger la **integridad de los datos**.\
Si una instrucción `INSERT`/`UPDATE` viola la regla, **la operación falla** y la base **no queda en un estado inválido**.

Tres grandes objetivos que cubren los constraints:

- **Dominio**: que cada columna tenga valores válidos (tipo, rango, obligatoriedad).
- **Entidad**: que cada fila sea identificable de forma única.
- **Referencia**: que las relaciones entre tablas se mantengan coherentes.

## Tipos de constraints (estándar SQL)

1. **NOT NULL** – prohíbe valores nulos en una columna.
2. **UNIQUE** – asegura que **no se repitan** valores (puede ser de **una o varias columnas**).
3. **PRIMARY KEY** – identifica de forma única a cada fila (implícitamente `NOT NULL` + `UNIQUE`).
4. **FOREIGN KEY** – obliga a que un valor exista **previamente** en la tabla referenciada (integridad referencial).
5. **CHECK** – valida una **condición booleana** (rango, patrón, consistencia simple).

> Nota de versiones: **CHECK** se **enfuerza** en **MySQL ≥ 8.0.16** y **MariaDB ≥ 10.2.x**. En versiones más antiguas se ignoraba o requería alternativas (triggers).

## Ejemplos rápidos (MariaDB/MySQL)

### A. Definir constraints al crear tablas

```sql
CREATE TABLE student (
  student_id   INT AUTO_INCREMENT,
  student_code VARCHAR(20) NOT NULL,         -- NOT NULL
  email        VARCHAR(255) UNIQUE,          -- UNIQUE
  PRIMARY KEY (student_id),                  -- PRIMARY KEY
  CONSTRAINT uq_student_code UNIQUE (student_code),   -- UNIQUE nombrado
  CONSTRAINT chk_code_len CHECK (CHAR_LENGTH(student_code) >= 3) -- CHECK
) ENGINE=InnoDB;

CREATE TABLE course (
  course_id INT AUTO_INCREMENT PRIMARY KEY,
  code      VARCHAR(20) NOT NULL UNIQUE,
  credits   TINYINT NOT NULL,
  CONSTRAINT chk_credits CHECK (credits BETWEEN 1 AND 10)
) ENGINE=InnoDB;

CREATE TABLE enrollment (
  student_id INT NOT NULL,
  course_id  INT NOT NULL,
  enrolled_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (student_id, course_id),                 -- UNIQUE del par
  CONSTRAINT fk_enr_student FOREIGN KEY (student_id)
    REFERENCES student(student_id) ON DELETE CASCADE,
  CONSTRAINT fk_enr_course  FOREIGN KEY (course_id)
    REFERENCES course(course_id)  ON DELETE RESTRICT
) ENGINE=InnoDB;
```

### B. Añadir o quitar constraints después (ALTER TABLE)

```sql
-- Agregar UNIQUE compuesto
ALTER TABLE student
  ADD CONSTRAINT uq_student_name_email UNIQUE (full_name, email);

-- Agregar FOREIGN KEY
ALTER TABLE enrollment
  ADD CONSTRAINT fk_enr_course FOREIGN KEY (course_id)
  REFERENCES course(course_id) ON DELETE RESTRICT;

-- Quitar una FOREIGN KEY (usa su nombre)
ALTER TABLE enrollment DROP FOREIGN KEY fk_enr_course;

-- Quitar un UNIQUE en MySQL/MariaDB se hace como índice:
ALTER TABLE student DROP INDEX uq_student_name_email;

-- Quitar un CHECK (MySQL 8+)
ALTER TABLE course DROP CHECK chk_credits;
```

## ¿Por qué usar constraints y no sólo validación en la app?

- **Consistencia centralizada**: protegen los datos aunque haya **múltiples aplicaciones** o usuarios conectados.
- **Atómicas**: se aplican dentro de la transacción; no hay “ventanas” para estados inválidos.
- **Performance**: `PRIMARY KEY` y `UNIQUE` crean índices útiles; las **FK** suelen beneficiarse de índices en las columnas referenciadas.

## Buenas prácticas

- **Nombra tus constraints** (`fk_enr_course`, `chk_credits`): facilita depurar y alterar.
- **Usa `NOT NULL` por defecto** salvo que _nulo_ tenga un significado claro.
- **Prefiere `UNIQUE` multicolumna** para reglas como “no hay dos matrículas del mismo estudiante en el mismo curso”.
- **Define `ON DELETE/UPDATE`** en FKs de acuerdo al negocio (`CASCADE`, `RESTRICT`, `SET NULL`).
- **CHECK para reglas de dominio** (rangos, formatos). Para reglas complejas que cruzan varias filas/ tablas, evalúa **triggers**.
- **Índices para FKs**: añade un índice en la columna que referencia; mejora `JOIN` y borrados/actualizaciones en cascada.

## Errores típicos

- Confiar sólo en la app: otro cliente puede saltarse la validación.
- `CHECK` en versiones antiguas de MySQL/MariaDB → no se aplicaba (ver tu versión).
- Falta de índices en FKs → `JOIN` lentos y cascadas costosas.
- `PRIMARY KEY` no estable (p. ej., usar un dato que cambia). Mejor **surrogate key** (`AUTO_INCREMENT`) y **UNIQUE** para la llave natural.

# 📘 Guía práctica: Organización de scripts SQL en Ubuntu (LAMP con MariaDB/MySQL)

## 0) (Opcional) Instalar LAMP con MariaDB

Si todavía no tienes tu entorno:

```bash
sudo apt update
sudo apt install -y apache2 mariadb-server php libapache2-mod-php php-mysql
sudo systemctl enable --now mariadb
sudo mysql_secure_installation   # asegura root, elimina test DB, etc.
```

> Nota: en MariaDB puedes entrar al cliente con `sudo mysql` o `sudo mariadb`.

## 1) Crear base de datos y usuario de trabajo

Abre el cliente como root:

```bash
sudo mysql
```

En el prompt SQL:

```sql
-- Crea la BD (utf8mb4 = Unicode completo)
CREATE DATABASE IF NOT EXISTS uni_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- Usuario para base de datos
CREATE USER IF NOT EXISTS 'dev'@'localhost' IDENTIFIED BY 'Dev.2025!';

-- OJO: Aquí según se requiera puede dar privilegios

-- Todos los privilegios para el usuario
GRANT ALL ON uni_db.* TO 'dev'@'localhost';

-- Privilegios (no root, sólo lo necesario)
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX
  ON uni_db.* TO 'dev'@'localhost';

FLUSH PRIVILEGES;
EXIT;
```

## 2) Estructura de carpetas y archivos `/sql`

Dentro de tu proyecto:
Considera que podría estár en cualquier carpeta, pero, para ser ordenado/a, podría ser recomendable ubicarlos en la carpeta html:
`cd /var/www/html`
Luego de ello:

```bash
cd /var/www/html
mkdir -p proyecto/sql
cd proyecto/sql
touch 01_schema.sql 02_seed.sql 03_queries.sql
```

## 3) Contenido de ejemplo (Universidad)

### 📂 `01_schema.sql` — Definición de tablas (DDL)

```sql
-- 01_schema.sql
SET NAMES utf8mb4;
SET time_zone = '+00:00';

CREATE DATABASE IF NOT EXISTS uni_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE uni_db;

-- Tabla STUDENT
CREATE TABLE IF NOT EXISTS student (
  student_id   INT AUTO_INCREMENT PRIMARY KEY,
  student_code VARCHAR(20) NOT NULL UNIQUE,
  full_name    VARCHAR(100) NOT NULL,
  email        VARCHAR(255) UNIQUE,
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Tabla COURSE
CREATE TABLE IF NOT EXISTS course (
  course_id INT AUTO_INCREMENT PRIMARY KEY,
  code      VARCHAR(20) NOT NULL UNIQUE,
  title     VARCHAR(120) NOT NULL,
  credits   TINYINT NOT NULL CHECK (credits BETWEEN 1 AND 10)
) ENGINE=InnoDB;

-- Relación N:M → ENROLLMENT
CREATE TABLE IF NOT EXISTS enrollment (
  enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  course_id  INT NOT NULL,
  enrolled_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_enr_student FOREIGN KEY (student_id)
    REFERENCES student(student_id) ON DELETE CASCADE,
  CONSTRAINT fk_enr_course FOREIGN KEY (course_id)
    REFERENCES course(course_id)  ON DELETE RESTRICT,
  CONSTRAINT uq_enr UNIQUE (student_id, course_id)
) ENGINE=InnoDB;

-- Índice para consultas frecuentes
CREATE INDEX idx_enr_course_student ON enrollment (course_id, student_id);
```

### 📂 `02_seed.sql` — Datos iniciales (DML)

```sql
-- 02_seed.sql
USE uni_db;
START TRANSACTION;

-- Estudiantes
INSERT INTO student (student_code, full_name, email) VALUES
  ('S-001','Ana Pérez','ana.perez@example.edu'),
  ('S-002','Luis Díaz','luis.diaz@example.edu'),
  ('S-003','Marta Ríos','marta.rios@example.edu');

-- Cursos
INSERT INTO course (code, title, credits) VALUES
  ('CS101','Fundamentos de Programación',4),
  ('DB201','Bases de Datos I',3),
  ('MA110','Cálculo I',4);

-- Matrículas (usando SELECT para obtener IDs)
INSERT INTO enrollment (student_id, course_id)
SELECT s.student_id, c.course_id
FROM student s JOIN course c
WHERE s.student_code='S-001' AND c.code='CS101';

INSERT INTO enrollment (student_id, course_id)
SELECT s.student_id, c.course_id
FROM student s JOIN course c
WHERE s.student_code='S-001' AND c.code='DB201';

INSERT INTO enrollment (student_id, course_id)
SELECT s.student_id, c.course_id
FROM student s JOIN course c
WHERE s.student_code='S-002' AND c.code='DB201';

COMMIT;

-- Validaciones rápidas
SELECT COUNT(*) AS total_students  FROM student;
SELECT COUNT(*) AS total_courses   FROM course;
SELECT COUNT(*) AS total_enrollments FROM enrollment;
```

### 📂 `03_queries.sql` — Consultas representativas

```sql
-- 03_queries.sql
USE uni_db;

-- Q1: Filtrar por nombre
SELECT student_id, full_name, email
FROM student
WHERE full_name LIKE 'Ana%';

-- Q2: JOIN → lista inscripciones con nombre de alumno y curso
SELECT e.enrollment_id, s.full_name, c.title, e.enrolled_at
FROM enrollment e
JOIN student s ON s.student_id = e.student_id
JOIN course  c ON c.course_id  = e.course_id
ORDER BY e.enrolled_at DESC;

-- Q3: Agregación → número de estudiantes por curso
SELECT c.code, c.title, COUNT(*) AS enrolled_students
FROM enrollment e
JOIN course c ON c.course_id = e.course_id
GROUP BY c.course_id, c.code, c.title
HAVING COUNT(*) >= 1
ORDER BY enrolled_students DESC;

-- Q4: Subconsulta → estudiantes SIN matrícula en DB201
SELECT s.full_name
FROM student s
WHERE s.student_id NOT IN (
  SELECT e.student_id
  FROM enrollment e
  JOIN course c ON c.course_id = e.course_id
  WHERE c.code='DB201'
);

-- Q5: Vista de resumen
CREATE OR REPLACE VIEW vw_enroll_summary AS
SELECT s.student_code, s.full_name, c.code AS course_code, c.title, e.enrolled_at
FROM enrollment e
JOIN student s ON s.student_id = e.student_id
JOIN course  c ON c.course_id  = e.course_id;

-- Consultar la vista
SELECT * FROM vw_enroll_summary;
```

## 4) Ejecutar los scripts en orden

```bash
#Ubiquese en en la carpeta de trabajo.
cd var/www/html/proyecto/sql 

# 1) Esquema (DDL)
mysql -u root -p < 01_schema.sql

# 2) Datos iniciales (DML)
mysql -u dev -p --database=uni_db < 02_seed.sql

# 3) Consultas y vista
mysql -u dev -p --database=uni_db < 03_queries.sql
```

> ⚠️ Recuerda: el **orden importa** → primero el esquema, luego los datos, después las consultas.

## 5) Integración con proyecto LAMP

Si tu aplicación web está en `/var/www/html/miapp`, puedes copiar los scripts allí:

```bash
sudo mkdir -p /var/www/html/miapp/sql
sudo cp var/www/html/proyecto/sql/*.sql /var/www/html/miapp/sql/
sudo chown -R $USER:www-data /var/www/html/miapp/sql
sudo chmod -R 750 /var/www/html/miapp/sql
```

> Apache no ejecuta SQL: estos archivos se usan desde la consola o desde tu app PHP.

## 🚀 Consejos finales

- **Valida siempre**: después de correr `02_seed.sql`, usa `SELECT COUNT(*)` para comprobar registros.
- **Evita sorpresas**: si necesitas rehacer, crea un `00_reset.sql` con `DROP TABLE ...` en orden inverso.
- **Documenta**: pon comentarios (`-- ...`) en cada bloque de tus scripts para que sepas qué hace cada parte.
- **Engine**: mantén `InnoDB` para soportar claves foráneas y transacciones.
