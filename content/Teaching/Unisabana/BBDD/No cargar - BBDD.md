---
publish: true
created: 2026-02-13T11:23
modified: 2026-02-15T16:51:12-05:00
---

Estimados estudiantes,

Este mensaje es para dar indicaciones sobre la entrega de las actividades de este parcial, todas las actividades han sido programadas para que puedan hacer la entrega hasta el día miércoles 04 de marzo 9h00:

**Semana 1-Quiz-Fundamentos de Bases de Datos:** Cada uno lo rindió en clase.
**Semana 1-Tarea-Linea de tiempo evolución de las bases de datos (Individual):** Fue revisada en clase, por favor cargarla para registrar su nota.
**Semana 2-Quiz-Introdución Modelo Relacional:** Cada uno lo rindió en clase.
**Semana 2-Tarea-Mapa de conceptos(Grupal):** Por favor, que el coordinador de cada grupo cargue la tarea.
**Semana 3-Quiz-Conceptos modelo relacional:** Cada uno lo rindió en clase, para el que aún necesite mejorar su calificación se configuró un segundo intento.
**Semana 3-Informe de proyecto 1 (Grupal):** Lean los detalles y realicen la actividad.
**Semana 3-Tarea-Diagrama entidad relación(Grupal):** Por favor, que el coordinador de cada grupo cargue la tarea.
**Semana 4-Guias de aprendizaje (Parte1-Grupal):** Lean los detalles y realicen la actividad.
**Semana 5-Guías de aprendizaje (Parte2-Grupal) Videoforo:** Se optó por aplazar esta actividad, esta oculta y no deben hacerla.
**Semana 5-Tarea-Guías de aprendizaje (Parte3-Individual):** Por favor, revisen con detalle y hagan la actividad.

He visto que en la plataforma las fechas que se mostraban eran otras, por lo que envío este mensaje para que todos estemos al tanto.
Por favor, revisen con detalle cada actividad y busquen cumplir con los criterios descritos en la rúbrica de evaluación. El hecho que tengan más días para entregar significa que pueden aprovechar y entregar algo excelente.

Les comento que se emplearán herramientas de IA para su evaluación y retroalimentación así como una revisión por mi parte, esperemos que todo vaya de lo mejor y todos logre un merecido 5.

Cualquier cosa, pueden preguntar por aquí. Por favor, envíen un emoji para saber que han leído este mensaje.

Saludos cordiales.

| **Unidad del Syllabus**                                        |                                                                                                                                                                       | **Capítulos del Libro (7ma Edición)**  | **Enfoque Principal**                                                                      |
| -------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- | ------------------------------------------------------------------------------------------ |
| **Tema 0 y 1:** Introducción y Conceptos Generales             | "Introducción<br>•Evolución de los sistemas de Bases de Datos "<br>"•Tipos de Bases de Datos <br>•Diseño de Bases de datos <br>•Reglas del Negocio y Objetivos  "<br> | **Capítulo 1:** Introduction           | Evolución histórica, tipos de bases de datos, abstracción de datos y arquitectura general. |
| **Tema 2:** Diseño de bases de datos Relacionales              |                                                                                                                                                                       | **Capítulo 2, 6, 7 y 14**              | Modelo E/R, atributos de tablas, normalización y estructuras de índices.                   |
| **Tema 3:** SQL                                                | "•Elementos básicos de un modelo entidad/relación <br>•Elementos Básicos de una tabla "<br>                                                                           | **Capítulo 3, 4 y 5**                  | Desde las consultas básicas hasta la agregación avanzada.                                  |
| **Tema 4:** Conectividad con Bases de Datos                    | "•Representando relaciones en un modelo entidad/relación <br>•Llaves e Índices •Normalización"                                                                        | **Capítulo 5 (Sec. 5.1) y Capítulo 9** | Conexiones vía lenguajes de programación (JDBC/ODBC) y arquitecturas de aplicación.        |
| **Tema 5:** Programación de Bases de Datos                     |                                                                                                                                                                       | **Capítulo 5 (Sec. 5.2 y 5.3)**        | Creación y gestión de funciones, procedimientos almacenados y _triggers_.                  |
| **Tema 6:** Gestión de Transacciones y Control de Concurrencia |                                                                                                                                                                       | **Capítulos 17, 18 y 19**              | Propiedades ACID, bloqueos, serializabilidad y recuperación de fallos.                     |
| **Tema 7:** Arquitectura de Sistemas de Base de Datos          |                                                                                                                                                                       | **Capítulo 20**                        | Bases de datos centralizadas, cliente-servidor, paralelas y distribuidas.                  |

Para utilizar **NotebookLM** de manera efectiva en la creación de estos recursos, el primer paso es **cargar tus fuentes** (el _Syllabus_ y los capítulos del libro de Silberschatz correspondientes a cada unidad).

Dado que NotebookLM es un asistente basado en los documentos que le proporcionas, he diseñado estos **prompts base (plantillas)** para que los copies y pegues. Solo debes reemplazar los corchetes `[TEMA]` con la unidad específica que estés trabajando.

Aquí tienes los prompts maestros:

### 🎧 1. Audio Podcast Explicativo

_(Nota: NotebookLM tiene una función nativa de "Resumen de audio" que genera un podcast en inglés automáticamente. Si necesitas el contenido en español o prefieres grabarlo tú mismo/con IA de voz, usa este prompt para generar el guion)._

> **Prompt:** "Actúa como un guionista de podcasts educativos. Basándote en los documentos cargados, escribe un guion detallado para un podcast de 5 a 8 minutos sobre **\[TEMA, ej: Tema 6: Gestión de Transacciones]**. El formato debe incluir dos locutores: 'Locutor A' (un experto en bases de datos que explica con analogías de la vida real) y 'Locutor B' (un estudiante curioso que hace preguntas para aclarar conceptos). Incluye pausas, sugerencias de efectos de sonido (SFX) y un tono conversacional, dinámico y fácil de entender."

### 📊 2. Infografía Explicativa del Tema

> **Prompt:** "Analiza el contenido de **\[TEMA]** y genera la estructura textual para una infografía educativa. Divide el resultado en 4 o 5 secciones visuales. Para cada sección, proporciona: 1) Un título corto y llamativo. 2) Un resumen en viñetas muy conciso (máximo 3 líneas). 3) Datos clave o palabras que deban resaltarse. 4) Una sugerencia visual precisa (por ejemplo, 'Icono de un candado' o 'Diagrama de flujo simple') que el diseñador gráfico deba incluir en esa sección."
>
> ![Imagen de educational infographic design layout](https://encrypted-tbn3.gstatic.com/licensed-image?q=tbn:ANd9GcQbpFdqXBQgIwwMuat_pEtNhcSaj9Z_INdikWF1gsDy7BZOTmbQVQMnWjJeZFO-9407u4DTnfYl1URtMCKAINQ_OTjjANifv8m3Ok3BiUxqFCzic2o)
>
> Shutterstock
>
> Explorar

### 🎬 3. Vídeo Explicativo

> **Prompt:** "Escribe un guion técnico y literario para un vídeo explicativo (tipo _microlearning_ de 3 a 5 minutos) sobre **\[TEMA]**. Organiza la respuesta en una tabla de dos columnas: la columna izquierda debe llamarse 'Visual/Pantalla' (donde describas exactamente qué animaciones, textos, diagramas o código de bases de datos deben aparecer en pantalla) y la columna derecha debe llamarse 'Narración (Voz en off)' (con el texto exacto que leerá el narrador). Asegúrate de incluir una introducción que enganche, el desarrollo del concepto y un cierre o llamado a la acción."

### 📝 4. Cuestionario de Preguntas de Base Estructurada

> **Prompt:** "Genera un cuestionario de evaluación estructurada de 10 preguntas de opción múltiple (A, B, C, D) sobre **\[TEMA]**. Asegúrate de que las preguntas evalúen diferentes niveles de comprensión (memorización, aplicación de conceptos y resolución de problemas, como analizar un pequeño fragmento de código SQL o un diagrama E/R). Después de las 10 preguntas, incluye una sección de 'Clave de Respuestas' donde indiques la opción correcta y añadas una breve retroalimentación justificando por qué esa es la correcta basándote en el texto de Silberschatz."

### 📽️ 5. Presentación Explicativa del Tema

> **Prompt:** "Diseña el esquema de una presentación de diapositivas académica sobre **\[TEMA]**. Para cada diapositiva (calcula entre 8 y 12 diapositivas en total), proporciona:
>
> 1. El título de la diapositiva.
>
> 2. Los puntos clave (bullet points) que aparecerán en pantalla (deben ser breves, no párrafos largos).
>
> 3. Sugerencia visual (qué gráfico, fragmento de código SQL, diagrama o tabla debe incluirse).
>
> 4. Notas del orador (el texto detallado que el profesor o expositor debe decir mientras se proyecta esa diapositiva, citando los conceptos del libro)."

### 📖 6. Textos Guía para el Estudiante (Apunte de Estudio)

> **Prompt:** "Crea un documento de texto guía para el estudiante (Study Guide) sobre **\[TEMA]**. El documento debe tener la siguiente estructura:
>
> 1. Resumen ejecutivo del tema (1 párrafo).
>
> 2. Glosario de términos clave (5 a 7 conceptos fundamentales definidos de forma sencilla).
>
> 3. Explicación de los principios o teorías principales.
>
> 4. Un ejemplo práctico o caso de estudio aplicado al mundo real.
>
> 5. Tres preguntas de reflexión para que el estudiante evalúe su propio aprendizaje.
>
>    Utiliza un tono académico pero accesible."

---

### ⚠️ Estrategia para Subtemas Complejos

Al revisar tu Syllabus y el libro de Silberschatz, hay temas que históricamente son "cuellos de botella" para los estudiantes de Ingeniería Informática y Ciencia de Datos. Para estos casos, te sugiero generar **recursos adicionales específicos** usando estos prompts:

**A. Para la Normalización (Tema 2 / Capítulo 7)**

La normalización es muy abstracta. Los estudiantes suelen fallar al pasar de 1FN a 3FN.

- **Recurso adicional (Guía paso a paso):** > _"Genera un caso de estudio práctico donde se presente una tabla de base de datos 'plana' (sin normalizar) sobre un sistema de facturación o biblioteca. Luego, muestra paso a paso la transformación a la Primera, Segunda y Tercera Forma Normal (1FN, 2FN, 3FN), explicando claramente qué dependencias funcionales se están eliminando en cada paso."_

**B. Para el Control de Concurrencia y Transacciones (Tema 6 / Capítulos 17 y 18)**

Entender las propiedades ACID y los bloqueos (Deadlocks) requiere visualizar el tiempo.

- **Recurso adicional (Análisis de Caso / Diagrama de tiempo):** > _"Diseña una tabla cronológica comparativa (T1 y T2) que muestre un escenario de abrazo mortal (Deadlock) entre dos transacciones en una base de datos. Explica paso a paso cómo y por qué se produce el bloqueo y cómo el sistema gestor de base de datos (DBMS) debería resolverlo según el protocolo de bloqueo de dos fases (2PL)."_

**C. Consultas Avanzadas en SQL (Tema 3 / Capítulo 5)**

Los _JOINs_ anidados y las funciones de agregación complejas suelen ser difíciles de visualizar.

- **Recurso adicional (Laboratorio de Código Comentado):** > _"Genera un 'Laboratorio Visual de SQL'. Crea 3 tablas pequeñas con datos de prueba (Insert statements). Luego, redacta 3 consultas SQL complejas (que incluyan INNER JOIN, GROUP BY y HAVING). Para cada consulta, no solo des el código, sino que dibuja una tabla de texto mostrando cómo se vería el 'Output' o resultado exacto que arrojaría la base de datos."_

Actúa como un guionista de podcasts educativos en ingeniería. Basándote en los documentos cargados, escribe un guion detallado para un podcast sobre "Introducción: •Evolución de los sistemas de Bases de Datos ". El formato debe incluir dos locutores: 'Locutor A' (un experto en bases de datos que explica con analogías de la vida real) y 'Locutor B' (un estudiante curioso que hace preguntas para aclarar conceptos). Incluye pausas, sugerencias de efectos de sonido (SFX) y un tono conversacional, dinámico y fácil de entender.

Genera una Guía de aprendizaje detallado y exhaustivo sobre "•Elementos básicos de un modelo entidad/relación y Elementos Básicos de una tabla ", desde un enfoque técnico del tema, dirigido a estudiantes de Ingeniería. Se busca comprender los detalles técnicos, las metodologías, las tecnologías, las innovaciones y los logros descritos en estas fuentes. IMPORTANTE: Agrega las preguntas y prácticas de los capítulos del libro como ejercicios finales de la Guía.

Genera un podcast detallado y exhaustivo sobre "Representando relaciones en un modelo entidad/relación,
Llaves e Índices y Normalización; desde un enfoque técnico del tema, dirigido a estudiantes de Ingeniería. Se busca comprender los detalles técnicos, las metodologías, las tecnologías, las innovaciones y los logros descritos en estas fuentes.

[[BBDD-Recursos.excalidraw|Youtube-Videos]]

![[Paper1.excalidraw.svg]]

[[BBDD-Recursos.excalidraw|Youtube-Videos]]

"Analiza el contenido de Introducción: •Evolución de los sistemas de Bases de Datos y genera la estructura textual para una infografía educativa. Divide el resultado en 4 o 5 secciones visuales. Para cada sección, proporciona: 1) Un título corto y llamativo. 2) Un resumen en viñetas muy conciso (máximo 3 líneas). 3) Datos clave o palabras que deban resaltarse. 4) Una sugerencia visual precisa (por ejemplo, 'Icono de un candado' o 'Diagrama de flujo simple') que el diseñador gráfico deba incluir en esa sección."

Aplica un guion técnico y literario de un vídeo explicativo (tipo microlearning) sobre Evolución de los sistemas de Bases de Datos. Organiza la respuesta en una tabla de dos columnas: la columna izquierda debe llamarse 'Visual/Pantalla' (donde describas exactamente qué animaciones, textos, diagramas o código de bases de datos deben aparecer en pantalla) y la columna derecha debe llamarse 'Narración (Voz en off)' (con el texto exacto que leerá el narrador). Asegúrate de incluir una introducción que enganche, el desarrollo del concepto y un cierre o llamado a la acción."
