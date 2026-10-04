---
publish: true
created: 2025-09-24T08:44
modified: 2025-09-24T09:21:21-05:00
---

# 📌 Informe 2 – Modelo E-R  del proyecto (Grupal)

## ¿Qué deben entregar?

**Informe de Diseño (PDF)** — evidencia de que el equipo pasó de **conceptual** a **lógico** y aplicó **normalización**.
**Nombre de archivo:** `Equipo##_InformeDiseno_FECHA.pdf`

## Objetivo del informe

1. Consolidar el **modelo E-R** con cardinalidades;
2. **Mapear** E-R → esquema relacional (tablas, PK, FK);
3. **Normalizar** hasta **3FN**;
4. Definir **restricciones** e **índices** iniciales;
5. Dejar **diccionario de datos** base.

> Debe trazarse con el Informe de inicio (semana 2): cada regla de negocio debe verse reflejada en entidades/relaciones o restricciones o en su defento agregarlas.

## Estructura obligatoria (6–8 páginas + anexos)

1. **Resumen y alcance actualizado** (½ pág.)
   - Qué cambió desde el Informe de inicio y por qué.
2. **Modelo E-R (conceptual)** (1–2 págs.)
   - Diagrama legible con **entidades, atributos clave, relaciones, cardinalidades** y participación (total/parcial).
   - Supuestos explícitos (p.ej., “un Student puede pertenecer a un solo Department”).
3. **Mapeo E-R → Relacional** (1–2 págs.)
   - Detalle de tablas:\
     `Entidad/Relación | Tabla | Atributos | PK | FK | Observaciones (resolución N:M, participación, Otros detalles)`
   - Resolver relaciones **N:M** con **tablas puente** (Más info: [[Tabla puente]]).
4. **Normalización (1FN → 2FN → 3FN)** (2–3 págs.)
   - Para cada tabla **de partida**:
     - **DF** relevantes (dependencias funcionales) que justifican cada paso.
     - Evidencia breve de eliminación de **repetición, parcialidad y transitividad**.
     - Resultado final por tabla (en 3FN o BCNF) y nota si quedó una **PK compuesta**.
5. **Restricciones e Integridad** (½–1 pág.)
   - **PK**, **FK**, **UNIQUE**, **NOT NULL**, **CHECK** (ej.: límites de créditos, rangos de fechas).
   - Reglas de negocio mapeadas a restricciones (mini matriz: Regla → Tabla/Columna/Constraint). (Más info: [[Constraint]])
6. **Índices iniciales (borrador)** (½ pág.)
   - ¿Qué columnas indexarías y por qué? (búsqueda por código, uniones frecuentes).
7. **Diccionario de datos (extracto)** (1 pág.)
   - Describe de tablas:
     - `Tabla | Atributo | Descripción | Dominio/Unidad | Null? | Observaciones`.
   - No necesitas fijar tipos de datos del motor; vale con dominios (entero, texto corto, fecha, booleano).

**Anexos:**

- Fuente del E-R (MySQL WorkBench).
- Hojas de normalización (plantilla 1FN→3FN).
- Cualquier nota de revisión del grupo.

## Checklist antes de entregar

- (  ) Todas las **relaciones N:M** pasan por **tabla puente**.
- (  )  No hay **atributos multivaluados** sin resolver.
- (  )  **PK** y **FK** están identificadas en **todas** las tablas.
- (  )  Cada regla de negocio importante tiene **reflejo** en el esquema (constraint o diseño).
- (  )  Hay **DF** por cada tabla que normalizaste y queda claro el paso a 3FN.
- (  ) Diccionario de datos incluye **definiciones semánticas**, no solo nombres.

## Errores comunes a evitar

- Llamar “ID” distinto en cada tabla sin convención (usa prefijos: `student_id`, `course_id`).
- Confundir 1:N con N:M (si un estudiante puede inscribirse en muchos cursos **y** un curso tiene muchos estudiantes → **N:M**).
- Mantener atributos calculados/derivados sin justificación (p.ej., `total_credits` almacenado).
- Dejar **nullable** campos que deberían ser **NOT NULL** según la regla de negocio.

## Herramientas recomendadas

- **E-R**: MySQL Workbench
- **Normalización**: hoja de trabajo (1FN→3FN) con tablas.

## Rúbrica de Evaluación (20 pts)

La evaluación se basará en la completitud, precisión técnica y justificación de las decisiones de diseño.

| Criterio | Nivel 4 – Excelente | Nivel 3 – Bueno | Nivel 2 – Aceptable | Nivel 1 – Insuficiente | Puntos Máximos |
| :--- | :--- | :--- | :--- | :--- | :---: |
| **1. Modelo Conceptual (E-R)** | Diagrama impecable. Entidades, relaciones, cardinalidades (min, max) y participación claramente definidas y sustentadas en reglas de negocio. | Diagrama claro, con detalles menores omitidos en participación o cardinalidad. | Faltan algunas cardinalidades, ambigüedades menores o participación no explícita, pero funcional. | Entidades mal identificadas, relaciones erróneas, omisión de cardinalidades, diseño incomprensible. | **5 pts** |
| **2. Mapeo al Modelo Relacional** | Transformación correcta. PKs/FKs bien definidas. Relaciones N:M resueltas impecablemente con tablas puente. | Mapeo mayormente correcto, con fallos leves en nombres o resolución de algunas FKs. | Errores menores en el mapeo (ej. FK en la tabla incorrecta), pero se resuelven las N:M de forma aceptable. | Mapeo incorrecto. Atributos multivaluados sin resolver. Tablas puente faltantes o mal estructuradas. | **5 pts** |
| **3. Proceso de Normalización** | Evidencia clara paso a paso (1FN → 2FN → 3FN). Dependencias Funcionales (DF) explícitas y justificadas. | Normalización completa a 3FN, pero con justificación parcial de dependencias. | Normalización correcta en resultado, pero sin documentar claramente las DF o pasos intermedios. | Tablas no normalizadas (parcialidades, transitividades). Sin justificación de dependencias. | **4 pts** |
| **4. Restricciones e Integridad** | Definición exhaustiva (UNIQUE, CHECK, NOT NULL) alineada al negocio. Propuesta de índices coherente. | Incluye restricciones principales y de negocio, pero faltan algunos índices clave. | Restricciones básicas (PK/FK) pero faltan validaciones de negocio o índices sin justificar. | Ausencia de restricciones de integridad. Índices ilógicos, nulos o que empeoran el rendimiento. | **3 pts** |
| **5. Diccionario y Formato** | Diccionario completo (semántica, dominios, nulos). Documento estructurado, trazable con el Informe 1. | Diccionario adecuado, faltan pocos detalles o dominios. Formato estructurado. | Diccionario incompleto o descripciones obvias. Formato aceptable pero trazabilidad débil. | No hay diccionario de datos. Presentación descuidada, sin relación con el informe de inicio. | **3 pts** |
