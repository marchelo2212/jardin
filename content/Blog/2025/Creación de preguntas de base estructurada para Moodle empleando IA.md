---
publish: true
created: 2025-08-01T16:27
modified: 2025-08-11T18:23:08-05:00
tags:
  - moodle
  - IA
  - preguntas
  - cuestionario
  - actividades
---

# Creación de preguntas de base estructurada para Moodle empleando IA

**Rol:** Eres un asistente de IA experto en pedagogía y creación de contenido educativo.

**Objetivo:** Analizar el material de una asignatura y generar un banco de preguntas en formato CSV, siguiendo una estructura específica.

**Instrucciones Detalladas:**

1. **Revisión de Material:**
   - Lee y analiza detenidamente los siguientes archivos adjuntos:
     - El sílabo de la asignatura: `Electiva2-Silabo.pdf`
     - Las lecturas proporcionadas: `[La seguridad para los menores en internet.txt,Guía-práctica-para-el-abordaje-del-Acoso-Escolar.txt,política_publica_internet_segura.txt,protocolo_frente_a_violencia_digital-1.txt]`
   - Identifica los temas centrales, conceptos clave y objetivos de aprendizaje de la asignatura a partir del sílabo y las lecturas.

2. **Generación de Preguntas:**
   - Crea un total de `[40]` preguntas basadas en el contenido de las lecturas.
   - Distribuye las preguntas de la siguiente manera:
     - `[Número, ej: 15]` preguntas de tipo **Verdadero/Falso**.
     - `[Número, ej: 25]` preguntas de tipo **Opción Múltiple** (con 1 respuesta correcta y 3 incorrectas).
   - Asegúrate de que las preguntas estén alineadas con objetivo descrito en el documento `Electiva2-Silabo.pdf`

3. **Creación del Archivo CSV:**
   - Construye un único archivo CSV llamado `preguntas_electiva2.csv`.
   - El archivo debe tener la siguiente estructura de columnas, separadas por punto y coma (`;`):
     `num;type;question;correct;feedback;wrong_1;feedback_1;wrong_2;feedback_2;wrong_3;feedback_3`

4. **Especificaciones de Contenido del CSV:**
   - `num`: Número secuencial de la pregunta, comenzando en 1.
   - `type`: Usa `"truefalse"` para preguntas de Verdadero/Falso y `"multichoice"` para las de Opción Múltiple.
   - `question`: El texto completo de la pregunta.
   - `correct`: La respuesta correcta.
   - `feedback`: La retroalimentación para la respuesta correcta.
   - `wrong_1`, `wrong_2`, `wrong_3`: Las opciones incorrectas. Para preguntas `truefalse`, solo se llenará `wrong_1` con la opción opuesta (ej: si la correcta es "Verdadero", `wrong_1` será "Falso").
   - `feedback_1`, `feedback_2`, `feedback_3`: La retroalimentación específica para cada una de las respuestas incorrectas. **Es crucial que todas las opciones incorrectas en las preguntas `multichoice` tengan su propia retroalimentación.**

5. **Formato del CSV:**
   - **Todos los campos de texto** (preguntas, respuestas, retroalimentaciones) deben estar encerrados entre comillas dobles (`"`).
   - El separador de columnas debe ser un punto y coma (`;`).
   - El archivo debe estar codificado en UTF-8.

**Ejemplo de Fila (Opción Múltiple):**
`"15";"multichoice";"¿Cuál es el primer paso en el método científico?";"La observación";"Correcto, la observación es el punto de partida para formular una pregunta de investigación.";"La experimentación";"Incorrecto, la experimentación se realiza después de formular una hipótesis.";"La conclusión";"Incorrecto, la conclusión es el resultado final del proceso.";"La hipótesis";"Incorrecto, la hipótesis se formula después de la observación inicial."`

**Verificación Final:**
Antes de entregar el archivo final, verifica que se cumplan todos los puntos, especialmente la estructura del CSV, el uso de comillas dobles y la inclusión de retroalimentación para todas las respuestas incorrectas en las preguntas de opción múltiple.
