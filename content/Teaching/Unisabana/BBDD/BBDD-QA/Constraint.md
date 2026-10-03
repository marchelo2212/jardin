---
publish: true
created: 2025-09-24T08:54
modified: 2025-09-30T05:57:47-05:00
tags:
  - Constraint
  - "#MySQL"
  - "#QA"
---

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
