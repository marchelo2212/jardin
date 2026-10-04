# 📘 Guía de Aprendizaje: Diseño de Bases de Datos mediante el Modelo Entidad-Relación - Semana 09

## 1. Contexto y Objetivos

En esta etapa de la asignatura, nos enfocamos en los conceptos de diseño lógico y avanzado de bases de datos. Esta guía se centra en el **Modelo Entidad-Relación (E-R)**, la herramienta estándar para crear un esquema conceptual que especifica entidades, atributos y relaciones, y su posterior reducción a esquemas relacionales.

**Objetivos de aprendizaje:**
- Traducir descripciones textuales y requisitos en un modelo de datos de alto nivel (Diseño Conceptual y Lógico).
- Identificar y evitar errores comunes en el diseño (pitfalls) como la redundancia y la incompletitud.
- Aplicar reglas algorítmicas estrictas para la reducción de diagramas E-R a esquemas relacionales.

## 2. Componentes Clave a Desarrollar

Durante esta semana, el estudiante deberá profundizar en los siguientes elementos técnicos:
- **Componentes del Modelo E-R:** Entidades (fuertes y débiles), conjuntos de entidades, y los diferentes tipos de atributos (simples, compuestos, monovalorados, multivalorados, derivados, nulos).
- **Relaciones y Restricciones:** Conjuntos de relaciones, roles, atributos descriptivos, cardinalidades de mapeo (1:1, 1:N, N:1, N:N) y restricciones de participación (total y parcial).
- **Claves (Keys):** Superclaves, claves candidatas, claves primarias y discriminadores para entidades débiles, así como la asignación de claves en conjuntos de relaciones.

## 3. Actividades Sugeridas

### 3.1. Fase Teórica: 
Revisión del **Glosario Técnico** para estandarizar el lenguaje: 
- Atributo Compuesto, Atributo Derivado, Cardinalidad, Discriminador, Entidad Débil, Esquema Conceptual, Relación Recursiva, Superclave.
- Resolver el Cuestionario de Autoevaluación para consolidar los conceptos sobre participación, atributos, claves primarias e incompletitud.

### 3.2. Fase Práctica: 
Revisión detallada de las indicaciones de las actividades prácticas de la Guía:
- **Ejercicio 1: Modelado de Atributos.** Diseñar un conjunto de entidades con atributos compuestos, derivados y multivalorados.
- **Ejercicio 2: Cardinalidad y Restricciones.** Modelar relaciones con diferentes cardinalidades y restricciones de participación total/parcial.
- **Ejercicio 3: Reducción a Tablas.** Convertir un esquema E-R con entidades fuertes y débiles a un esquema relacional.

Realización de las actividades acorde se describe en la Guía. En caso de necesitar usar software, considere los empleados en clase. 

## 4. Recursos de Apoyo

- **Lectura Principal:** Guía de Estudio: Diseño de Bases de Datos mediante el Modelo Entidad-Relación (Capítulo 6).
- **Herramientas de Diseño/Desarrollo:** Se recomienda el uso de herramientas de modelado E-R (ej. draw.io, Lucidchart o herramientas CASE específicas vistas en clase).

## 5. Uso de Inteligencia Artificial

**Nivel: Uso proactivo**
La actividad permite que el estudiante utilice de manera autónoma las herramientas de Inteligencia Artificial seleccionadas por el docente, con el fin de profundizar y consolidar sus aprendizajes a través de una exploración crítica y reflexiva.

- **Herramientas propuestas:**
	- Cuaderno NotebookLM. 
	- Asistente especializado en Bases de Datos relacionales y Lenguaje SQL.
- **Recomendaciones de uso:**
	- Verificar procedimientos de reducción a esquemas relacionales.
	- Explorar variaciones de un ejercicio de modelado.
	- Solicitar explicaciones alternativas sobre cardinalidades y restricciones.
	- Contrastar soluciones de diseño E-R.
- **Sin embargo:**
	- Cada persona es responsable de validar técnicamente todas las respuestas.
	- La solución final debe reflejar comprensión real.
	- El uso debe declararse conforme a las políticas del curso.
- **Evidencias de uso:** Obligatoriamente, esta información deberá ser enviada como parte del documento. En caso de <u>no hacerlo, se tendrá una penalización directa de 2 puntos en su entrega</u>. 
	- Evidencia solicitada: Una vez que haya finalizado la guía, deberá responder personalmente (no generado por IA) a estas preguntas:
		- **Pregunta 1:** ¿Qué tipo de uso se le dio a las herramientas de IA?
		- **Pregunta 2:** ¿De qué manera la IA le aportó a la comprensión de un concepto o elemento?
		- **Pregunta 3:** ¿Podría haber llegado a resolver la guía sin el uso de la herramienta de IA? ¿Por qué?
		- **Pregunta 4:** ¿Qué aspectos destaca (pros y contras) del uso de IA en esta actividad académica?

## 6. Estructura del documento a entregar

Dentro de las Guías de aprendizaje existen secciones que contienen preguntas, ejercicios y/o prácticas que deben ser resueltas de forma **individual**. 
Se deberá crear un solo documento y entregarlo en formato PDF. Las secciones propuestas son:

### Portada
- Nombre(s)
- Asignatura
- Fecha

### Resolución de la Guía 
Debe incluir:
- Preguntas de autoevaluación, ejercicios de modelado y prácticas de reducción a tablas resueltas de forma detallada.

### Uso de Inteligencia Artificial
Debe incluir:
- Todas las preguntas obligatorias y sus respectivas respuestas de reflexión.

## 7. Rúbrica de evaluación

| **Criterio** | **Nivel 4 – Excelente** | **Nivel 3 – Bueno** | **Nivel 2 – Aceptable** | **Nivel 1 – Insuficiente** | **Puntos Máx.** |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Rigor técnico en Modelado E-R** | Diseña los diagramas E-R con precisión, aplicando correctamente atributos, cardinalidades y restricciones. | Diseña los diagramas con algunos errores menores en restricciones o tipos de atributos. | Presenta errores moderados en el modelado conceptual que afectan la lógica del dominio. | El diseño no refleja los requisitos del dominio de forma adecuada. | **5** |
| **Reducción a Esquemas Relacionales** | Convierte correctamente el esquema E-R a tablas relacionales, identificando claves primarias y foráneas sin errores. | Convierte el esquema con errores menores en la definición de claves foráneas o atributos compuestos. | La conversión presenta múltiples errores, como pérdida de información o claves incorrectas. | No logra reducir el esquema E-R a tablas relacionales funcionales. | **4** |
| **Argumentación y Reflexión Técnica** | Justifica cada decisión. No se limita a entregar resultados, sino el sustento. | Incluye explicaciones para la mayoría de sus decisiones. | Explicaciones superficiales. | Predominan las respuestas sin explicación. | **3** |
| **Uso Crítico y Reflexivo de IA** | Declara el uso. Responde las 4 preguntas con honestidad y profundidad. | Declara el uso y responde claramente, aunque la reflexión es breve. | Declaración incompleta o respuestas genéricas. | No presenta la sección o las respuestas son de IA (Penalización -2 pts). | **3** |
| **Resolución de Prácticas** | Resuelve la totalidad de los ejercicios con rigor. | Resuelve la mayoría con fallos mínimos. | Resolución parcial o incompleta. | No resuelve los ejercicios prácticos. | **3** |
| **Cumplimiento de Estructura y Formato** | Entrega en PDF con Portada, Resolución y Sección IA. Organización impecable. | Cumple con la estructura y formato, con errores menores. | Faltan secciones menores o el formato presenta problemas. | Documento desorganizado, no cumple estructura obligatoria o formato. | **2** |
