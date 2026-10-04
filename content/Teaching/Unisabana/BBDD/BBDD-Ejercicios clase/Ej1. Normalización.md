---
publish: true
created: 2026-02-18T07:42
modified: 2026-02-21T16:11
---

# Guía de Estudio: Normalización y Diseño de Bases de Datos Relacionales

Esta guía de estudio presenta un caso práctico de diseño de bases de datos basado en los principios de integridad y estructuras relacionales. A través de un ejemplo de una biblioteca, se ilustra el proceso de normalización para asegurar la consistencia de los datos y eliminar redundancias innecesarias, utilizando como referencia los modelos de datos de estudiantes, cursos y departamentos.

## 1. Caso de Estudio Práctico: El Sistema de la Biblioteca

En un entorno de biblioteca, se desea registrar la información de los usuarios, los libros que retiran y los departamentos a los que pertenecen. Inicialmente, el sistema utiliza una **tabla plana (sin normalizar)** que combina toda la información en una sola estructura, similar a lo que resultaría de una operación de _natural join_ entre múltiples relaciones.

### Tabla Plana: Registro\_Biblioteca (Sin Normalizar)

Esta tabla presenta redundancias significativas. Por ejemplo, los datos del usuario y del departamento se repiten cada vez que se retira un libro diferente.

| ID\_Usuario | Nombre\_Usuario | Nombre\_Depto | Edificio\_Depto | ID\_Libro | Título\_Libro     | Fecha\_Retiro |
| ---------- | -------------- | ------------ | -------------- | -------- | ---------------- | ------------ |
| 00128      | Zhang          | Comp. Sci.   | Taylor         | CS-101   | Intro. a SQL     | 2017-10-01   |
| 00128      | Zhang          | Comp. Sci.   | Taylor         | CS-347   | Bases de Datos   | 2017-10-15   |
| 12345      | Shankar        | Comp. Sci.   | Taylor         | CS-101   | Intro. a SQL     | 2017-09-20   |
| 19991      | Brandt         | History      | Painter        | HIS-351  | Historia Mundial | 2018-02-10   |
