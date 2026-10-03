---
publish: true
created: 2025-09-24T08:54
modified: 2025-09-30T05:57:47-05:00
tags:
  - Constraint
  - "#MySQL"
  - "#QA"
---

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
