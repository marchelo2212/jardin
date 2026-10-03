---
publish: true
created: 2026-02-18T07:44
modified: 2026-02-21T16:11
---

# Guía de Estudio: Normalización y Diseño de Bases de Datos Relacionales

Esta guía de estudio presenta un caso práctico de diseño de bases de datos basado en los principios de integridad y estructuras relacionales. A través de un ejemplo de una biblioteca, se ilustra el proceso de normalización para asegurar la consistencia de los datos y eliminar redundancias innecesarias, utilizando como referencia los modelos de datos de estudiantes, cursos y departamentos.

## 1. Caso de Estudio Práctico: El Sistema de la Biblioteca

En un entorno de biblioteca, se desea registrar la información de los usuarios, los libros que retiran y los departamentos a los que pertenecen. Inicialmente, el sistema utiliza una **tabla plana (sin normalizar)** que combina toda la información en una sola estructura, similar a lo que resultaría de una operación de _natural join_ entre múltiples relaciones.

### Tabla Plana: Registro\_Biblioteca (Sin Normalizar)

Esta tabla presenta redundancias significativas. Por ejemplo, los datos del usuario y del departamento se repiten cada vez que se retira un libro diferente.

### Tabla de préstamos de libros de la biblioteca

| ID\_Usuario | Nombre\_Usuario | Nombre\_Depto | Edificio\_Depto | ID\_Libro | Título\_Libro     | Fecha\_Retiro |
| ---------- | -------------- | ------------ | -------------- | -------- | ---------------- | ------------ |
| 00128      | Zhang          | Comp. Sci.   | Taylor         | CS-101   | Intro. a SQL     | 2017-10-01   |
| 00128      | Zhang          | Comp. Sci.   | Taylor         | CS-347   | Bases de Datos   | 2017-10-15   |
| 12345      | Shankar        | Comp. Sci.   | Taylor         | CS-101   | Intro. a SQL     | 2017-09-20   |
| 19991      | Brandt         | History      | Painter        | HIS-351  | Historia Mundial | 2018-02-10   |

## 2. Proceso de Normalización Paso a Paso

El objetivo de la normalización es utilizar **restricciones de integridad** (como claves primarias y foráneas) para evitar la pérdida de consistencia y proteger contra daños accidentales en la base de datos.

### Paso 1: Primera Forma Normal (1FN)

**Requisito:** Todos los atributos deben ser atómicos (valores indivisibles) y no deben existir grupos repetidos.

En nuestra tabla original, los valores ya son atómicos. Sin embargo, para cumplir con la 1FN, debemos definir una **clave primaria (primary key)** que identifique de forma única cada fila. En este caso, la combinación de `ID_Usuario`, `ID_Libro` y `Fecha_Retiro` actúa como superclave.

- **Dependencia eliminada:** Atributos no atómicos o multivaluados.

### Paso 2: Segunda Forma Normal (2FN)

**Requisito:** Estar en 1FN y que todos los atributos que no forman parte de la clave primaria dependan de toda la clave, no solo de una parte de ella.

**Análisis de Dependencias Parciales:**

- `Nombre_Usuario` y `Nombre_Depto` dependen solo de `ID_Usuario`.
- `Título_Libro` depende solo de `ID_Libro`.

**Transformación:** Separamos los datos del usuario y los datos del libro en tablas independientes para eliminar estas dependencias parciales.

- **Tabla Usuario:** (`ID_Usuario`, Nombre\_Usuario, Nombre\_Depto, Edificio\_Depto)
- **Tabla Libro:** (`ID_Libro`, Título\_Libro)
- **Tabla Retiro:** (`ID_Usuario`, `ID_Libro`, Fecha\_Retiro) — _Aquí ID\_Usuario e ID\_Libro actúan como claves foráneas (foreign keys)._

### Paso 3: Tercera Forma Normal (3FN)

**Requisito:** Estar en 2FN y que no existan dependencias transitivas (un atributo no clave no puede depender de otro atributo no clave).

**Análisis de Dependencia Transitiva en la Tabla Usuario:**

- `ID_Usuario` determina el `Nombre_Depto`.
- `Nombre_Depto` determina el `Edificio_Depto`.
- Por lo tanto, `Edificio_Depto` depende de `ID_Usuario` de forma transitiva a través de `Nombre_Depto`.

**Transformación:** Creamos una relación separada para los departamentos, asegurando que cada hecho se registre solo una vez.

- **Tabla Usuario:** (`ID_Usuario`, Nombre\_Usuario, **Nombre\_Depto**)
- **Tabla Departamento:** (`Nombre_Depto`, Edificio\_Depto)
- **Tabla Libro:** (`ID_Libro`, Título\_Libro)
- **Tabla Retiro:** (`ID_Usuario`, `ID_Libro`, Fecha\_Retiro)

### Paso 4: Forma Normal de Boyce-Codd (FNBC)

**Requisito:** Para cada dependencia funcional A \rightarrow B, A debe ser una superclave.

En el diseño de la biblioteca, supongamos que cada departamento tiene múltiples edificios pero cada edificio pertenece a un solo departamento. Si tuviéramos una relación donde el edificio determina el departamento, y el edificio no fuera clave primaria, estaríamos violando la FNBC. Al separar `Departamento` y `Usuario`, y asegurar que `Nombre_Depto` es la clave en su propia tabla, eliminamos anomalías donde la información del edificio se perdería si se eliminara al último usuario de ese departamento.

---

## 3. Cuestionario de Evaluación (Quiz)

**Pregunta 1:** En una base de datos relacional, ¿qué tipo de restricción asegura que un valor que aparece en una relación para un conjunto de atributos también deba aparecer en otra relación?

- A) Restricción de Dominio.
- B) Restricción de Integridad Referencial (Clave Foránea).
- C) Restricción Check.

**Pregunta 2:** Si realizamos un `natural join` entre las tablas `Usuario` y `Retiro`, y un usuario no ha realizado ningún retiro, ¿qué sucede con sus datos en el resultado?

- A) Aparecen con valores nulos en los campos del libro.
- B) Los datos del usuario se pierden en el resultado.
- C) El sistema genera un error de ejecución.

**Pregunta 3:** ¿Cuál es la función del comando `rollback work` en una transacción?

- A) Hacer permanentes todos los cambios en la base de datos.
- B) Deshacer todas las actualizaciones realizadas por la transacción actual, restaurando el estado anterior.
- C) Eliminar una tabla de la base de datos.

**Pregunta 4:** ¿Para qué se utiliza la cláusula `on delete cascade` en una declaración de clave foránea?

- A) Para impedir que se elimine cualquier registro que sea referenciado por otra tabla.
- B) Para eliminar automáticamente los registros dependientes en la tabla que hace la referencia cuando se elimina el registro original.
- C) Para convertir todos los valores referenciados en nulos.

**Pregunta 5:** Un índice en un atributo de una relación es una estructura de datos que permite:

- A) Modificar el esquema lógico de la base de datos.
- B) Encontrar de manera eficiente las tuplas que tienen un valor específico para ese atributo sin escanear toda la relación.
- C) Crear copias de seguridad automáticas.

---

## 4. Clave de Respuestas

1. **B.** La **integridad referencial** asegura que las referencias entre tablas sean consistentes (ej. que el `ID_Usuario` en la tabla `Retiro` exista en la tabla `Usuario`).
2. **B.** En un **natural join** (o _inner join_), solo se preservan las tuplas que coinciden en ambas relaciones. Para mantener al usuario sin retiros, se requeriría un _left outer join_.
3. **B.** El comando **rollback** garantiza la atomicidad, asegurando que si ocurre un error, la base de datos no quede en un estado parcialmente actualizado.
4. **B.** La opción **cascade** permite que las eliminaciones se propaguen a través de la cadena de dependencias de claves foráneas.
5. **B.** Los **índices** forman parte del esquema físico y mejoran el rendimiento de las consultas de selección.

---

## 5. Glosario de Términos Clave

- **Clave Primaria (Primary Key):** Conjunto de atributos que identifica de forma única cada tupla en una relación. No permite valores nulos.
- **Integridad Referencial:** Regla que garantiza que si una tabla A referencia a una tabla B, el registro referenciado en B debe existir.
- **Join (Combinación):** Operación que permite combinar información de múltiples relaciones. El _natural join_ lo hace basándose en atributos con nombres iguales.
- **Outer Join (Combinación Externa):** Operación de combinación que preserva las tuplas que no tienen coincidencia en la otra relación, rellenando los atributos faltantes con valores **null**.
- **Transacción:** Secuencia de operaciones de consulta y actualización que se ejecutan como una unidad atómica (todo o nada).
- **Vista (View):** Una "relación virtual" definida por una consulta SQL. No se almacena físicamente (a menos que sea una _materialized view_), sino que se computa bajo demanda.
- **Índice:** Estructura de datos redundante que acelera la recuperación de registros específicos, similar al índice de un libro en una biblioteca.
- **Restricción Check:** Predicado que debe ser satisfecho por cada tupla en una relación (ej. `check (presupuesto > 0)`).
