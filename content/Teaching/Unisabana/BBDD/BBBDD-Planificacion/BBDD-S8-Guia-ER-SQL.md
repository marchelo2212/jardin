# 📘 Guía de Aprendizaje: Del Modelo Entidad-Relación al SQL Avanzado - Semana 08

## 1. Contexto y Objetivos

En esta etapa de la asignatura, el diseño de bases de datos no es un proceso accidental; es una transición disciplinada desde la abstracción conceptual hasta la implementación física optimizada. Esta guía se centra en **El Ciclo de Vida del Diseño de Bases de Datos y el Modelo E-R**, la herramienta estándar para trascender la mera escritura de código y alcanzar la arquitectura de sistemas de información robustos.

**Objetivos de aprendizaje:**
- Comprender el ciclo de vida del diseño de bases de datos (Conceptual, Lógico, Físico).
- Identificar y aplicar correctamente los conceptos del Modelo Entidad-Relación (E-R) como entidades, relaciones, atributos y cardinalidades.
- Aplicar reglas de transformación del Diagrama E-R a un Esquema Relacional (SQL), incluyendo entidades débiles y restricciones de integridad.

## 2. Componentes Clave a Desarrollar

Durante esta semana, el estudiante deberá profundizar en los siguientes elementos técnicos:
- **Modelo Entidad-Relación:** Entidades, Conjunto de Entidades, Relaciones y Conjunto de Relaciones.
- **Complejidad de Atributos:** Simples, compuestos, monovalorados, multivalorados y derivados.
- **Mapeo de Cardinalidades y Claves:** Restricciones de participación, claves primarias, entidades débiles y discriminadores.
- **Reglas de Transformación a SQL:** Aplanamiento de atributos, atributos multivalorados, combinación de esquemas y redundancia de entidades débiles.

## 3. Actividades Sugeridas

### 3.1. Fase Teórica: 
Revisión del **Glosario Técnico** para estandarizar el lenguaje: Entidad, Relación, Atributo, Cardinalidad, Entidad Débil, Discriminador, Clave Primaria, Clave Foránea.

### 3.2. Fase Práctica: 
Revisión detallada de las indicaciones de las actividades prácticas de la Guía.  
Realización de las actividades acorde se describe en la Guía (Ejercicios de la sección 8 original: Preguntas de Concepto, Práctica de Modelado con relaciones ternarias, Reto de SQL para implementación de integridad). En caso de necesitar usar software, considere los empleados en clase.

## 4. Recursos de Apoyo

- **Lectura Principal:** Guía Maestra de Aplicación: Del Modelo Entidad-Relación al SQL Avanzado.
- **Material Complementario:** Caso de Estudio: El E-R de la Universidad Enterprise.
- **Herramientas de Diseño/Desarrollo:** Se recomienda el uso de motores de base de datos relacional y herramientas de modelado E-R (ej. MySQL Workbench, pgAdmin, DataGrip, etc.).
Para acceder a los recursos visite: [[Teaching/Unisabana/BBDD/BBDD-Recursos]]

## 5. Uso de Inteligencia Artificial

**Nivel: Uso proactivo**
La actividad permite que el estudiante utilice de manera autónoma las herramientas de Inteligencia Artificial seleccionadas por el docente, con el fin de profundizar y consolidar sus aprendizajes a través de una exploración crítica y reflexiva.

- **Herramientas propuestas:**
	- Cuaderno NotebookLM. 
	- Asistente especializado en Bases de Datos relacionales y Lenguaje SQL.
- **Recomendaciones de uso:**
	- Verificar procedimientos.
	- Explorar variaciones de un ejercicio.
	- Solicitar explicaciones alternativas.
	- Contrastar soluciones.
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
- Preguntas, ejercicios y/o prácticas resueltas de forma detallada (sección de ejercicios de aplicación y práctica SQL).

### Uso de Inteligencia Artificial
Debe incluir:
- Todas las preguntas obligatorias y sus respectivas respuestas de reflexión.

## 7. Rúbrica de evaluación

| **Criterio** | **Nivel 4 – Excelente** | **Nivel 3 – Bueno** | **Nivel 2 – Aceptable** | **Nivel 1 – Insuficiente** | **Puntos Máx.** |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Rigor técnico en Transformación E-R a SQL** | Transforma correctamente todas las entidades, relaciones y atributos siguiendo las 4 reglas de oro. | Transforma la mayoría de elementos con errores menores. | Transforma algunos elementos, pero comete errores conceptuales. | No logra transformar el modelo E-R a SQL adecuadamente. | **5** |
| **Aplicación de Claves e Integridad** | Define correctamente todas las PKs, FKs y restricciones de integridad (ej. en entidades débiles). | Define la mayoría de las claves correctamente, omitiendo restricciones menores. | Errores significativos en la definición de claves o integridad. | No aplica conceptos de claves e integridad. | **4** |
| **Argumentación y Reflexión Técnica** | Justifica cada decisión. No se limita a entregar resultados, sino el sustento. | Incluye explicaciones para la mayoría de sus decisiones. | Explicaciones superficiales. | Predominan las respuestas sin explicación. | **3** |
| **Uso Crítico y Reflexivo de IA** | Declara el uso. Responde las 4 preguntas con honestidad y profundidad. | Declara el uso y responde claramente, aunque la reflexión es breve. | Declaración incompleta o respuestas genéricas. | No presenta la sección o las respuestas son de IA (Penalización -2 pts). | **3** |
| **Resolución de Prácticas** | Resuelve la totalidad de los ejercicios con rigor. | Resuelve la mayoría con fallos mínimos. | Resolución parcial o incompleta. | No resuelve los ejercicios prácticos. | **3** |
| **Cumplimiento de Estructura y Formato** | Entrega en PDF con Portada, Resolución y Sección IA. Organización impecable. | Cumple con la estructura y formato, con errores menores. | Faltan secciones menores o el formato presenta problemas. | Documento desorganizado, no cumple estructura obligatoria o formato. | **2** |
