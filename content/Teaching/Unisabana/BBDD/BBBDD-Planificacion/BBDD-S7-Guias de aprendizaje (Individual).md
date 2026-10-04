# 📘 Guía de Aprendizaje: Diseño de Bases de Datos (Modelo E-R) - Semana 7

## 1. Contexto y Objetivos

En esta etapa de la asignatura, transitamos del análisis de requisitos a la estructuración lógica del conocimiento. Esta guía se centra en el **Modelo Entidad-Relación (E-R)**, la herramienta estándar de ingeniería para el diseño conceptual de bases de datos.

**Objetivos de aprendizaje:**

- Traducir descripciones textuales de requisitos en diagramas Entidad-Relación técnicamente correctos.
- Identificar y mitigar errores comunes de diseño como la redundancia y la incompletitud.
- Aplicar reglas de transformación para convertir esquemas conceptuales en esquemas relacionales (tablas) aptos para su implementación.

## 2. Componentes Clave a Desarrollar

Durante esta semana, el estudiante deberá profundizar en los siguientes elementos técnicos:

- **Modelado de Datos:** Definición de entidades (fuertes y débiles), atributos (simples, compuestos, multivalorados y derivados) y relaciones.
- **Restricciones de Integridad:** Aplicación de cardinalidades de correspondencia (1:1, 1:N, N:1, M:N) y tipos de participación (total o parcial).
- **Derivación de Esquemas:** Proceso de "aplanamiento" de atributos compuestos y creación de tablas para atributos multivalorados y relaciones muchos-a-muchos.

## 3. Actividades Sugeridas
### 3.1. Fase Teórica: 
Revisión del **Glosario Técnico** para estandarizar el lenguaje: Dominio, Esquema de empresa y Relaciones recursivas.
### 3.2. Fase Práctica: 
Revisión detallada de las indicaciones de las actividades prácticas de la Guía (por lo general 2 últimos secciones).  
Realización de las actividades acorde se describe en la Guía, en caso de necesitar usar software, considere los empleados en clase. 

## 4. Recursos de Apoyo
- **Lectura Principal:** Guía de Aprendizaje S07 - Diseño mediante el Modelo E-R. )
- **Material Complementario:** Capítulo 6 del texto guía (Database System Concepts).
- **Herramientas de Diseño:** Se recomienda el uso de software de diagramación técnica (Miro o MySQL Workbench) para la creación de los diagramas E-R.
Para acceder a los recursos visite: [[Teaching/Unisabana/BBDD/BBDD-Recursos]]
## 5. Uso de Inteligencia Artificial

**Nivel: Uso proactivo**
La actividad permite que el estudiante utilice de manera autónoma las herramientas de Inteligencia Artificial seleccionadas por el docente, con el fin de profundizar y consolidar sus aprendizajes a través de una exploración crítica y reflexiva.

- **Herramientas propuestas:**
	- Cuaderno Notebooklm (Cuaderno de google). 
	- Asistente especializado en Bases de Datos relacionales y Lenguaje SQL.
- **Recomendaciones de uso:**
	- Verificar procedimientos.
	- Explorar variaciones de un ejercicio.
	- Solicitar explicaciones alternativas.
	- Contrastar soluciones.
	- <u>Sin embargo:</u>
		- Cada persona es responsable de validar técnicamente todas las respuestas.
		- La solución final debe reflejar comprensión real.
		- El uso debe declararse conforme a las políticas del curso.
- **Evidencias de uso:** Obligatoriamente, esta información deberá ser enviada como parte del documento, en caso de <u>no hacerlo,  se tendrá una penalización directa de 2 puntos en su entrega</u>. 
	- Evidencia solicitada: Una vez que haya finalizado la guía deberán responder personalmente (no generada por IA) a estas preguntas:
		- **Pregunta 1:** ¿Qué tipo de uso se le dio a las herramientas de IA?
		- **Pregunta 2:** ¿De qué manera la IA le aportó a la comprensión de un concepto o elemento?
		- **Pregunta 3:** ¿Podría haber llegado a resolver la guía sin el uso de la herramienta de IA? ¿Por qué?
		- **Pregunta 4:** ¿Qué aspectos destaca (pros y contras) del uso de IA en esta actividad académica?

## 6. Estructura del documento a entregar

Dentro de las Guías de aprendizaje existen secciones (por lo general las 2 últimas) que contienen preguntas,  ejercicios y/o prácticas que deben ser resultas por el estudiante. 
Cada persona deberá crear un solo documento y entregarlo en formato PDF, las secciones propuestas son:
### Portada
- Nombre
- Asignatura
- Fecha
### Resolución de la Guía 
Debe incluir:
- Preguntas, ejercicios y/o prácticas resueltas. 
### Uso de Inteligencia Artificial
Debe incluir:
- Todas las preguntas y sus respuestas requeridas.
## 7. Rúbrica de evaluación

| **Criterio**                                      | **Nivel 4 – Excelente**                                                                                                                                     | **Nivel 3 – Bueno**                                                                                                                              | **Nivel 2 – Aceptable**                                                                                                           | **Nivel 1 – Insuficiente**                                                                                                       | **Puntos Máx.** |
| ------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| **Rigor técnico en el Modelado E-R**              | Traduce requisitos a diagramas E-R sin errores. Identifica correctamente entidades fuertes/débiles, atributos (multivalorados/compuestos) y cardinalidades. | Realiza el modelado con precisión, aunque presenta errores menores en la notación de atributos o en la definición de cardinalidades específicas. | El diagrama es funcional pero presenta errores conceptuales (ej. confusión entre relación y entidad) o redundancias no mitigadas. | Diagrama incorrecto, incompleto o que no sigue las reglas lógicas del modelo E-R descrito en la guía.                            | **5**           |
| **Derivación y Transformación Relacional**        | Aplica correctamente el "aplanamiento" de atributos y la creación de tablas para multivalorados (ej. `instructor_phone`). Justifica cada transformación.    | Realiza la transformación a tablas de forma mayormente correcta, con omisiones leves en claves foráneas o nombres de esquemas.                   | La transformación es incompleta. No logra derivar correctamente las relaciones muchos-a-muchos o los atributos compuestos.        | Errores graves en la lógica de transformación. No se evidencia comprensión de cómo pasar del modelo conceptual al relacional.    | **4**           |
| **Argumentación y Reflexión Técnica**             | Justifica cada decisión de diseño (por qué una entidad es débil o por qué cierta cardinalidad). No se limita a entregar el dibujo, sino el sustento.        | Incluye explicaciones para la mayoría de sus decisiones, aunque algunas justificaciones carecen de profundidad técnica.                          | Explicaciones superficiales. Se limita a describir el diagrama sin argumentar las reglas de negocio subyacentes.                  | Predominan las respuestas sin explicación. No hay evidencia de análisis sobre los _pitfalls_ (redundancia/incompletitud).        | **3**           |
| **Uso Crítico y Reflexivo de IA (Uso Proactivo)** | Declara el uso de NotebookLM/Asistente. Responde las 4 preguntas con honestidad y profundidad. Valida técnicamente las respuestas de la IA.                 | Declara el uso de IA y responde las 4 preguntas de forma clara, aunque la reflexión sobre los "pros y contras" es breve.                         | Declaración de IA incompleta o respuestas a las preguntas de reflexión muy genéricas/superficiales.                               | **No presenta la sección de IA o las respuestas son generadas por la propia IA.** (Penalización directa de 2 puntos según guía). | **3**           |
| **Resolución de Prácticas y Ejercicios**          | Resuelve la totalidad de los ejercicios de las últimas secciones de la guía (ej. Modelado Universidad y Análisis Ternario) con rigor.                       | Resuelve la mayoría de los ejercicios con procedimientos correctos, presentando fallos mínimos en los resultados finales.                        | Resolución parcial de los ejercicios propuestos o procedimientos incompletos que dificultan la validación.                        | No resuelve los ejercicios prácticos o los resultados son incoherentes con lo solicitado en la guía.                             | **2**           |
| **Cumplimiento de Estructura y Formato**          | Entrega un único PDF con: Portada, Resolución de Guía y Sección de IA. Organización impecable y profesional.                                                | Cumple con la estructura solicitada y el formato PDF, con errores menores de organización o estética.                                            | Faltan secciones menores de la estructura o el formato PDF presenta problemas de lectura en los diagramas.                        | Documento desorganizado, no cumple con la estructura obligatoria o no se entrega en formato PDF.                                 | **2**           |
| **Redacción y Notación Técnica**                  | Usa términos del glosario (Dominio, Esquema, Recursividad) correctamente. Ortografía perfecta y diagramas claros (Miro/Workbench).                          | Buena redacción técnica con pocos errores. Los diagramas son legibles pero podrían mejorar en limpieza.                                          | Uso limitado de terminología técnica. Errores ortográficos o diagramas difíciles de interpretar por falta de orden.               | Lenguaje impreciso o coloquial. Diagramas ilegibles o hechos manualmente sin herramientas técnicas.                              | **1**           |

