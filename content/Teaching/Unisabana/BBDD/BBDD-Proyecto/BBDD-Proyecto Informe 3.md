---
publish: true
created: 2025-09-24T09:17
modified: 2025-09-24T10:18:23-05:00
---

# 📌 Informe 3 –  Video carga de datos del proyecto

**NOTA: Aquí solo se entregará un vídeo**

## 1) Estructura sugerida del video (6–8 min, máx. 10)

**Título & objetivo**

- Nombre del equipo, app, motor de BD y propósito del video
  **Contexto**
- 1 frase que enlace con el Informe de inicio (reglas clave) y el Informe de diseño (ER → relacional).
  **Setup del entorno**
- Mostrar versión del SGBD (p. ej. `SELECT version();`).
- Crear base / conectar (sin exponer contraseñas).
- Estructura de carpetas: `01_schema.sql`, `02_seed.sql`, `03_queries.sql`.

**Esquema (DDL)**

- Ejecutar `01_schema.sql` (tablas, PK, FK, UNIQUE, NOT NULL, CHECK).
- Señalar **una decisión de diseño** (p. ej. tabla puente para N:M).

**Carga de datos (DML/Bulk)**

- Ejecutar `02_seed.sql` o `COPY/LOAD DATA`.
- Validación rápida: conteos por tabla.

**Consultas representativas (03\_queries.sql)**\
Mínimo 5 consultas, cada una responde a una regla/objetivo:

1. SELECT + WHERE (filtro por criterio de negocio).
2. JOIN (≥ 2 tablas) que responda una pregunta real.
3. Agregación con GROUP BY y HAVING.
4. Subconsulta

**Transacción breve**

- `BEGIN;` → `UPDATE/INSERT` → `ROLLBACK` o `COMMIT`.
- Explica en 1 frase cómo se garantiza la consistencia de datos  en la transacción.

**Seguridad**

- Usuario de solo lectura para reporting: `CREATE USER …; GRANT SELECT ON schema.* TO …;`.

**Cierre**

- Cómo reproducir (README), límites conocidos y próximos pasos.

## 2) Artefactos que deben acompañar al video

- **Repositorio/ZIP** con:
  ```
  /sql
    01_schema.sql
    02_seed.sql
    03_queries.sql

  README.md  (paso a paso para correr)
  ```

- **README.md** (obligatorio) con: requisitos, motor y versión, comandos para levantar/cargar/consultar, orden de ejecución de scripts.

## 3) Requisitos técnicos mínimos

- **Motor**: MySQL/MariaDB (indicar versión).
- **Reproducibilidad**: Uso de comandos simples con los archivos sql
- **Naming** coherente con el diccionario de datos entregado en el informe 2 (ej.: `student_id`, `course_id`).
- **Consistencia con el Informe 2**: tablas/relaciones deben coincidir.

## 4) Guion mínimo de locución (plantilla)

- “Somos **Equipo 04**, mostraremos:
- La **creación del esquema** (PK/FK/constraints).
- La **carga de datos** y **5 consultas** que prueban nuestras reglas de negocio X, Y, Z.
- **Decisión clave**: resolvimos la relación N:M... por ejemplo, _Student–Course_ con `enrollment`.
- **Transacción demo**: garantizamos que... por ejemplo, el cupo no se sobreasigne (rollback si falla).
- **Seguridad**: usuario `report_reader` con permisos `SELECT`.

## 5) Rúbrica de evaluación (100 pts)

La evaluación se basará en la correcta ejecución técnica, claridad de las consultas y la reproducibilidad del proyecto.

| Criterio                                    | Nivel 4 – Excelente                                                                                                                          | Nivel 3 – Bueno                                                                                                   | Nivel 2 – Aceptable                                                                                            | Nivel 1 – Insuficiente                                                                                            | Puntos Máximos |
| :------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------- | :------------: |
| **1. Correcta técnica (DDL + constraints)** | Esquema creado sin errores. Uso perfecto de constraints (PK, FK, UNIQUE, CHECK). Refleja fielmente el Informe 2.                             | Esquema funcional con constraints principales. Errores mínimos que no afectan la integridad de los datos.         | Esquema creado pero faltan constraints clave o hay desajustes notorios con el Informe 2.                       | Fallos críticos en la creación del esquema. Faltan PK/FK o el script no ejecuta.                                  |  **2.5 pts**   |
| **2. Carga de datos (DML/Bulk)**            | Scripts de carga (`seed.sql`) impecables y eficientes. Validación clara del volumen de datos esperado.                                       | Carga de datos exitosa mediante scripts. Faltan validaciones de volumen o hay datos inconsistentes menores.       | Carga manual parcial o uso de scripts con errores que requieren intervención manual para funcionar.            | No se presentan scripts de carga, o los scripts fallan completamente. No hay datos suficientes para probar.       |  **1.5 pts**   |
| **3. Calidad de consultas y transacciones** | 5+ consultas complejas (JOIN, GROUP BY, subconsultas) que validan reglas de negocio. Transacción demo impecable (COMMIT/ROLLBACK explícito). | Consultas correctas y funcionales, pero alguna no responde claramente a una regla de negocio. Transacción básica. | Consultas simples o repetitivas. Fallos lógicos en los JOINs. Transacción ausente o incorrectamente explicada. | Consultas con errores de sintaxis, uso exclusivo de `SELECT *`. No demuestran cobertura de las reglas de negocio. |  **2.5 pts**   |
| **4. Reproducibilidad (README, scripts)**   | Repositorio estructurado (`schema`, `seed`, `queries`). README detallado, claro y paso a paso. Reproducibilidad 100% garantizada.            | Estructura de carpetas correcta. README funcional pero omite detalles menores de configuración o versiones.       | Archivos desorganizados. README confuso o incompleto, dificultando la ejecución independiente.                 | Scripts mezclados o faltantes. Sin README o instrucciones de ejecución inútiles.                                  |  **1.5 pts**   |
| **5. Seguridad básica (roles/permisos)**    | Creación de usuario específico (ej. `report_reader`) con permisos granulares (solo `SELECT` en tablas específicas) demostrada en video.      | Creación de usuario con permisos limitados a nivel de esquema, pero sin granularidad o justificación clara.       | Menciona la seguridad pero la implementación es defectuosa o se usan permisos excesivos.                       | Todo ejecutado como `root`/`admin`. No hay demostración de roles o permisos restringidos.                         |  **1.0 pts**   |
| **6. Comunicación (claridad del video)**    | Video dinámico (<10 min), audio claro, ritmo excelente. Todos los miembros explican con dominio técnico sus partes.                          | Video dentro del tiempo, buen audio. Explicaciones claras aunque con leves titubeos técnicos.                     | Video largo o apresurado. Audio deficiente en partes. Explicaciones superficiales o leídas textualmente.       | Video incomprensible, sin estructura clara o excede excesivamente el tiempo. Falta de dominio del tema.           |  **1.0 pts**   |

## 6) Checklist final antes de grabar

- Aplicar los scripts previamente.
- **Cada consulta** está vinculada a una **regla de negocio** del Informe 1.
- Se emplea el **usuario correcto (no root)**.
- Video < 10 min, fuente legible, teclado en pantalla desactivado, **subtítulos** si es posible.

## 7) Errores comunes a evitar

- Ejecutar scripts **fuera de orden** (rompe carga).
- Usar `SELECT *` en el video (muestra columnas irrelevantes y oculta intención).
- Cargar datos “a mano” desde terminal; **usen scripts** para reproducir.
- Mezclar **usuarios** (root, admin y lector) durante la demo.
- Repetir consultas sin explicar **qué regla** validan.

## 8) Entrega

- **Formato**: enlace a MP4 (Teams/Zoom/otro) + ZIP/Repo con los artefactos.
- **Nombre de archivo**: `Equipo##_VideoImplementacion_YYYY-MM-DD.mp4`.
- **Plazo**: Miércoles 08 de octubre.
