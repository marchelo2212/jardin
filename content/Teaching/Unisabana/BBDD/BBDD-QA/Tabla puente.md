---
publish: true
created: 2025-09-24T08:54
modified: 2025-09-30T05:57:47-05:00
tags:
  - mysql
  - TablaPuente
  - QA
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
