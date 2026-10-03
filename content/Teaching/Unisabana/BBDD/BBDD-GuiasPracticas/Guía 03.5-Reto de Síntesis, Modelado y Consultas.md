---
publish: true
created: 2026-03-25T00:15
modified: 2026-04-16T09:53:27.000Z
---

↩️ [[Teaching/Unisabana/BBDD/BBDD-GuiasPracticas/index|index]]

# Guía 03.5 - Reto de Síntesis: Del Papel al Motor Relacional

> **Objetivo:** Consolidar los conceptos de normalización vistos en clase y trasladarlos a una implementación física real, automatizando la carga de datos y resolviendo problemas de negocio reales mediante SQL Intermedio.

## 1. Contexto del Reto

En las sesiones teóricas previas, hemos analizado y normalizado diversos escenarios de negocio, llegando a definir tablas y diagramas conceptuales. Sin embargo, una base de datos no vive en el papel.

En este reto, dejarás de seguir instrucciones paso a paso para convertirte en el **Arquitecto de Datos** y **Analista de Negocios**. Elegirás un caso, lo construirás desde cero usando herramientas profesionales y extraerás valor de él.

### Elige tu campo de batalla

Selecciona **SOLO UNO** de los siguientes casos trabajados en clase:

1. 📚 **Sistema de Gestión de Biblioteca**
2. 🦁 **Administración de Zoológico**
3. 🚗 **Concesionaria de Autos**
4. 🅿️ **Control de Parqueadero**

---

## 2. Fases del Proyecto

### Fase 1: Modelado Físico (Forward Engineering)

**No escribiremos el DDL a mano.** En la industria, se modela visualmente y se deja que el software genere el código estructural.

1. Abre **MySQL Workbench**.
2. Crea un nuevo modelo E-R (Entity-Relationship) basado en la normalización que hicimos en clase para el caso que elegiste.
3. Asegúrate de definir correctamente: Tipos de datos lógicos, Primary Keys (PK), Foreign Keys (FK) y restricciones (`ON DELETE RESTRICT` / `CASCADE`).
4. Utiliza la herramienta **Forward Engineering** (`Database > Forward Engineer...`) para generar el script DDL y crear la base de datos en tu servidor local.

### Fase 2: Población Inteligente (Data Generation)

Un Analista de Datos no pierde el tiempo tecleando 100 registros a mano.

1. Utiliza herramientas modernas para generar **datos sintéticos realistas**. Puedes usar plataformas como [Mockaroo](https://www.mockaroo.com/) o asistentes de Inteligencia Artificial (ChatGPT, Claude, Gemini) con un prompt como: _"Actúa como un generador de datos SQL. Genera 50 sentencias INSERT realistas para la siguiente tabla DDL..."_
2. **Requisito mínimo:** Las tablas catálogo (ej. libros, especies, autos) deben tener al menos 15 registros. Las tablas transaccionales (ej. préstamos, visitas, ventas, tickets) deben tener **mínimo 50 registros**.
3. Ejecuta el script DML en tu base de datos para poblarla. Asegúrate de que no haya violaciones de integridad referencial.

### Fase 3: Análisis de Negocio (Ingeniería Inversa de Consultas)

Ahora eres el dueño del negocio (el Bibliotecario en Jefe, el Director del Zoológico, etc.).

1. Formula **5 preguntas estratégicas** que el negocio necesita responder para tomar decisiones importantes (rentabilidad, fidelización, inventario, comportamiento de usuarios).
2. Escribe la sentencia SQL en MariaDB para responder a cada pregunta.
3. **Condiciones técnicas:** Entre las 5 consultas, debes demostrar obligatoriamente el uso de:
   - `INNER JOIN` (cruzando 3 o más tablas).
   - `LEFT JOIN` (para encontrar algo que "no existe" o "no tiene movimiento").
   - Funciones de agregación (`SUM`, `COUNT`, `AVG`).
   - Agrupación avanzada (`GROUP BY` + `HAVING`).
   - Al menos un cálculo matemático o formato de fecha (`DATEDIFF`, `YEAR`, etc.).

---

## 3. Entregables en el Aula Virtual

Debes empaquetar tu trabajo en un archivo comprimido (`TuApellido_Nombre_Reto3.5.zip`) que contenga:

1. **`modelo.pdf` / `.png`**: Captura clara de tu diagrama E-R desde MySQL Workbench.
2. **`estructura_y_datos.sql`**: El script completo con la creación de las tablas (DDL) y la inserción de todos los datos (DML). Si yo ejecuto este archivo, la base debe quedar lista.
3. `consultas_estrategicas.md` (`md = markdown` o `.pdf`): Un documento donde detalles:
   - Cuál es la pregunta de negocio.
   - El código SQL que la resuelve.
   - Una captura de pantalla pequeña evidenciando el resultado en tu base de datos.

---

## 4. Rúbrica de Evaluación

Esta entrega será calificada bajo las siguientes dimensiones. Lee atentamente para asegurar la máxima calificación.

| Dimensión                         | Excelente (2.5)                                                                                                                                  | Competente (2.0)                                                                                                                         | En Desarrollo (1,5)                                                                                             | Insatisfactorio (0.5 - 1.0)                                                                      |
| :-------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------- |
| **1. Modelado y DDL (Workbench)** | Diagrama impecable. PKs y FKs correctamente asignadas. Usa tipos de datos óptimos. El _Forward Engineering_ funciona sin errores.                | Diagrama correcto. Omite 1 o 2 tipos de datos óptimos, pero las relaciones (FKs) funcionan correctamente.                                | Faltan claves foráneas o relaciones clave. Tablas desconectadas o errores sintácticos al ejecutar el DDL.       | No usó Workbench o el esquema viola los principios básicos de normalización vistos en clase.     |
| **2. Población Sintética (DML)**  | Volumen exigido alcanzado (>50 transacciones). Los datos son coherentes, realistas y no rompen la integridad referencial. Automatizó el proceso. | Cumple el volumen mínimo, pero los datos son repetitivos, absurdos (ej. nombres como "aaa") o generaron errores menores solucionados.    | Menos de 20 registros transaccionales. Datos insertados a mano o con faltas de coherencia evidentes.            | Datos insuficientes para probar las consultas. Scripts de `INSERT` fallan por violar FKs o PKs.  |
| **3. Complejidad Lógica SQL**     | Las 5 consultas usan impecablemente `JOIN` (múltiples), `GROUP BY`, `HAVING` y funciones solicitadas. Sintaxis limpia y uso de alias.            | Usa las funciones requeridas, pero hay código redundante o ineficiente. Alguna consulta no arroja el resultado matemáticamente correcto. | Faltan requerimientos (ej. no usó `HAVING` o `LEFT JOIN`). Consultas demasiado básicas (solo `SELECT * WHERE`). | Consultas con errores de sintaxis que el motor rechaza, o no entregó las 5 consultas requeridas. |
| **4. Relevancia de Negocio**      | Las preguntas simulan problemas gerenciales reales. El resultado SQL justifica directamente una decisión del dueño del negocio.                  | Las preguntas tienen sentido, pero 1 o 2 son muy triviales (ej. "¿Cuántos libros hay?") en lugar de estratégicas.                        | Preguntas desconectadas del contexto del negocio o meramente descriptivas y superficiales.                      | No formuló preguntas de negocio, solo entregó código SQL suelto sin contexto.                    |

---

↩️ [[Teaching/Unisabana/BBDD/BBDD-GuiasPracticas/index|index]]
