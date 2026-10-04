# 📑 Guía de Elaboración: Informe Final del Proyecto Integrador

**Asignatura:** Bases de Datos

**Entrega:** Semana 17

**Formato:** Documento PDF

### 🎯 Objetivo del Informe

Consolidar en un único documento técnico riguroso todo el proceso de análisis, diseño, normalización, implementación, conectividad y seguridad de la base de datos desarrollada para resolver la problemática real seleccionada al inicio del curso. Este documento debe reflejar las mejoras iterativas sugeridas en las retroalimentaciones previas.

## 🧱 Estructura y Contenido del Informe

El informe final deberá seguir estrictamente la siguiente estructura capitular:

### 1. Introducción y Contextualización (Basado en Semanas 1 y 2)

- **Descripción del Problema:** Explicación detallada de la problemática u oportunidad real de negocio identificada.

- **Alcance del Proyecto:** Delimitación clara de lo que abarca (y lo que no) la solución propuesta.

- **Reglas de Negocio:** Listado definitivo y refinado de las políticas, restricciones y lógicas operativas que gobiernan el flujo de los datos.

### 2. Diseño Conceptual y Lógico (Basado en Semanas 3 y 4)

- **Modelo Entidad-Relación (E-R):** Diagrama conceptual completo y legible que represente fielmente las reglas de negocio.

- **Diccionario de Datos:** Tabla detallada por cada entidad/relación indicando: nombre del atributo, tipo de datos, restricciones (NOT NULL, UNIQUE, etc.), clave primaria (PK) y clave foránea (FK).

- **Proceso de Normalización:** Evidencia explícita y justificada de la transformación de las tablas hasta la **Tercera Forma Normal (3FN)** o Forma Normal de Boyce-Codd (BCNF). Se deben explicar las dependencias funcionales eliminadas en cada paso.

### 3. Implementación Física en SQL (Basado en Semanas 7 y 8)

- **Script de Creación (DDL):** Código SQL limpio utilizado para estructurar la base de datos en MySQL / MariaDB (creación de tablas, asignación de llaves, índices e integridad referencial).

- **Poblamiento Inicial (DML):** Descripción de la estrategia de carga de datos de prueba o reales para validar el sistema.

- **Consultas de Alto Valor Académico/Negocio:** Presentación de al menos 5 consultas complejas utilizando:

  - Joins múltiples (INNER, LEFT/RIGHT).

  - Funciones de agregación (`GROUP BY`, `HAVING`).

  - Subconsultas (correlacionadas o no correlacionadas) o expresiones de tabla comunes (CTEs).

### 4. Conectividad y Capa de Aplicación (Basado en Semanas 9, 10 y 11)

- **Arquitectura de Conexión:** Breve explicación del entorno tecnológico o lenguajes de programación utilizados para conectarse a la BBDD.

- **Manejo de Sentencias y Persistencia:** Muestras de código que evidencien cómo la aplicación realiza operaciones CRUD (Create, Read, Update, Delete) de forma segura hacia el motor relacional.

### 5. Programación en la Base de Datos (Basado en Semana 14)

- **Objetos Programables Implementados:** Inclusión del código fuente, propósito y pruebas de funcionamiento de:

  - **Funciones:** Operaciones de cálculo o transformación de datos.

  - **Procedimientos Almacenados (Stored Procedures):** Automatización de tareas o encapsulamiento de lógica compleja.

  - **Disparadores (Triggers):** Mecanismos para auditoría, validación avanzada o mantenimiento de consistencia interna.

### 6. Transacciones, Concurrencia y Recuperación (Basado en Semanas 15 y 16)

- **Diseño Transaccional:** Identificación de los procesos críticos que requieren propiedades ACID. Código SQL que demuestre el uso de `START TRANSACTION`, `COMMIT` y `ROLLBACK`.

- **Control de Concurrencia y Recuperación:** Análisis de los niveles de aislamiento configurados (ej. _Read Committed_, _Repeatable Read_) y justificación de cómo la base de datos previene anomalías como lecturas sucias o escrituras perdidas bajo alta concurrencia.

### 7. Conclusiones y Lecciones Aprendidas

- Evaluación del prototipo funcional frente al alcance planteado inicialmente.

- Reflexión técnica sobre las ventajas y limitaciones del modelo relacional implementado en comparación con arquitecturas distribuidas estudiadas al final del ciclo.

-

## 📐 Criterios Técnicos de Evaluación (Rúbrica de Apoyo)

Para garantizar la máxima calidad académica, se sugiere evaluar el informe bajo los siguientes pesos o focos principales:

1. **Rigor Metodológico (30%):** Coherencia absoluta entre las reglas de negocio, el diagrama E-R, la posterior transformación al modelo relacional y la justificación teórica de la normalización.

2. **Calidad del Código e Implementación (30%):** Correcto uso de restricciones de integridad (claves primarias, foráneas, `ON DELETE/UPDATE CASCADE`) , optimización mediante índices y legibilidad en los scripts SQL (DDL/DML).

3. **Lógica Avanzada (20%):** Correcto diseño y funcionamiento de los disparadores, procedimientos, funciones y la robustez de la gestión transaccional.

4. **Sustentación del Prototipo (20%):** Documentación clara de la conectividad con la aplicación y claridad expositiva global en la redacción técnica.

## 🤖 Lineamientos sobre el Uso de Inteligencia Artificial

Recordando los acuerdos institucionales de la asignatura, para esta actividad final se aplica un **Nivel 3: Uso Proactivo** . Los estudiantes que utilicen herramientas de IA (como el cuaderno de NotebookLM provisto para soporte del libro guía u el asistente de revisión de código) para depurar scripts, optimizar consultas o estructurar texto, deberán incluir obligatoriamente un **Anexo de Evidencias de IA** que contenga:

- Registro de las interacciones principales (prompts utilizados).
- Análisis crítico y justificación de los ajustes realizados sobre el código o diseño sugerido por la IA.

Nota: La ausencia de este anexo en caso de detectarse uso no declarado de IA incurrirá en penalizaciones académicas según la planificación.
