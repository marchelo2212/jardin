---
publish: true
created: 2026-02-16T10:38
modified: 2026-02-21T16:11
---

# 📌 Informe 1 – Inicio del Proyecto (Grupal)

**Semana 3 – Identificación del problema y bases conceptuales**

En caso de necesitar conocer detalles sobre el proyecto general de la asignatura, revise: [[BBDD-Proyecto Integrador|📌 Proyecto Integrador – Asignatura Base de Datos]]

## Objetivo formativo de esta etapa

Con esta entrega se busca que el estudiante:

- Analice problemas desde la perspectiva de los datos.
- Comprenda la importancia de las reglas de negocio.
- Diferencie contexto, proceso y estructura de información.
- Inicie el modelado conceptual con fundamentos sólidos.

## 1. Propósito de esta entrega

En este semestre el proyecto consistirá en **identificar una problemática u oportunidad real del entorno que pueda resolverse mediante el uso adecuado de una base de datos**.

El propósito de este informe es:

- Analizar una situación real donde el manejo de datos sea manual, desorganizado o ineficiente.
- Justificar por qué una solución basada en bases de datos aportaría valor.
- Definir el alcance preliminar del proyecto.
- Establecer reglas de negocio iniciales.
- Identificar las primeras entidades del sistema.

Este informe será la base para el modelado Entidad–Relación (Semana 4) y el desarrollo técnico posterior.

## 2. Tipo de problemáticas esperadas

Se espera que el equipo identifique situaciones reales como, por ejemplo:

- Control manual de novedades y paquetería en un condominio.
- Gestión de animales, alimentación y atención veterinaria en una finca.
- Organización informal de cupos en vehículos para asistir a la universidad.
- Registro manual de inventarios en pequeños negocios.
- Control de préstamos en bibliotecas comunitarias.
- Gestión de citas en consultorios pequeños.
- Otros que ustedes identifiquen.

⚠️ La problemática debe implicar:

- Manejo de múltiples datos estructurados.
- Necesidad de organización.
- Reglas claras.
- Interacción entre diferentes actores.

No se aceptarán proyectos excesivamente amplios, abstractos o irreales para el tiempo del semestre.

## 3. Organización del equipo (roles sugeridos)

Cada integrante asumirá un rol específico para esta entrega (los roles rotarán en siguientes informes):

| Rol                  | Responsabilidad principal                            |
| -------------------- | ---------------------------------------------------- |
| Analista de contexto | Describe la problemática y su impacto.               |
| Analista de negocio  | Define reglas de negocio (estáticas y dinámicas).    |
| Analista funcional   | Elabora el mapa funcional o diagrama de contexto.    |
| Modelador conceptual | Identifica entidades y realiza boceto ER preliminar. |
| Documentador         | Ensambla y revisa el documento final.                |

Se recomienda registrar quién desempeñó cada rol.

## 4. Estructura obligatoria del informe

**Extensión: 10–12 páginas**

### 4.1. Portada

- Nombre del proyecto
- Integrantes
- Asignatura
- Fecha

### 4.2. Contexto y justificación (1–2 páginas)

Debe incluir:

- Descripción clara del problema u oportunidad.
- ¿Cómo se gestiona actualmente la información?
- ¿Qué dificultades existen?
- ¿Qué impacto tiene en usuarios o procesos?
- Justificación de por qué una base de datos sería una solución adecuada.

### 4.3. Actores y mapa funcional / diagrama de contexto (1–2 páginas)

- Identificación de actores (usuarios del sistema).
- Diagrama que represente:
  - Sistema propuesto.
  - Actores externos.
  - Flujo de información.
- Breve explicación del diagrama.

==\*\*NOTA:\*\*== Sobre el Diagrama,  **revisar:** [What is a context diagram and how do you use it? | MiroBlog](https://miro.com/blog/context-diagram/?utm_source=chatgpt.com)

### 4.4. Reglas de negocio preliminares (1–2 páginas)

Deben presentar entre **5 y 10 reglas**, clasificadas en:

- **Reglas estáticas (integridad):**
  - Restricciones sobre los datos.
- **Reglas dinámicas (proceso):**
  - Eventos que generan cambios en la información.

Formato sugerido:
**RN-01 (Estática):**\
Descripción.\
Justificación.

**RN-02 (Dinámica):**\
Evento.\
Condición.\
Resultado en los datos.

Las reglas deben estar directamente relacionadas con el problema identificado.

### 4.5. Alcance y delimitación del proyecto (1 página)

Debe incluir:

- Qué incluirá el sistema.
- Qué NO incluirá.
- Priorización tipo MoSCoW (Must, Should, Could, Won’t).
- Definición de un alcance viable para el semestre.

**⚠️** Se recomienda trabajar con un sistema manejable (entre 5 y 8 entidades principales).

**==NOTA:==** Sobre MoSCoW, **revisar**: [MoSCoW. ¿Qué es y cómo priorizar en el desarrollo de tu aplicación?](https://www.itdo.com/blog/moscow-que-es-y-como-priorizar-en-el-desarrollo-de-tu-aplicacion/)

### 4.6. Inventario preliminar de entidades (1–2 páginas)

Avance conceptual que incluya:

- Tabla con:
  - Nombre de la entidad
  - Descripción
  - Atributos clave
  - Posible llave primaria
- Boceto inicial de Modelo Entidad–Relación (no definitivo).

Este modelo será refinado en la siguiente entrega.

### 4.7. Referencias

- Citar al menos una referencia bibliográfica.
- Incluir el capítulo 1 del libro guía de la asignatura.
- Usar formato de citación académico (APA o IEEE).

### 4.8. Evidencias de uso de IA (2-3 páginas)

- 1 ejemplo de prompt utilizado.
- Síntesis de principales mejoras sugeridas.
- Reflexión grupal (máximo 1 página) respondiendo:
  - ¿Qué mejoras relevantes aportó la IA?
  - ¿Cuáles aplicaron y por qué?
  - ¿Cuáles no aplicaron y por qué?
  - ¿Qué ventajas y limitaciones encontraron en el uso de IA?.

## 5. Uso de Herramientas de Inteligencia Artificial

**Nivel de uso : Guiado**
El nivel de uso de IA planificado dentro de esta actividad es el de **"Uso guiado"**, por lo que el estudiante deberá contemplar estas indicaciones:

- **Herramientas propuestas:** Cuaderno Notebooklm (Cuaderno de Google) de la asignatura (revise la sección recursos del aula virtual).
- **Indicaciones de uso:** Al finalizar cada una de las secciones del informe solicitado (4. Estructura obligatoria del informe), cada grupo deberá realizar lo siguiente:
  - 1. Estructurar un prompt que permita que la herramienta de IA analice su trabajo desarrollado manera estructural y profunda a fin de que les brinde "pros" y "contras/cosas por mejorar" al trabajo desarrollado.
  - 2. El grupo deberá recibir la respuesta de la herramienta y debatir cuáles de las mejoras o contras integrarán/atenderán para mejorar su trabajo y cuáles no.
  - 3. Una vez que hayan atendido los aspectos a mejorar o contras, deberán iterar nuevamente, es decir, aplicarán el punto 1.
  - 4. Por cada sección del informe, el grupo deberá iterar/repetir su interacción con la  herramienta de IA por lo menos por 2 ocasiones.
- **Evidencias de uso:** Obligatoriamente, esta información deberá ser enviada como parte de este informe, en caso de <u>no hacerlo el grupo tendrá una penalización directa de 2 puntos en su entrega</u>.
  - Evidencia solicitada: Una vez que hayan avanzado con el informe deberán responder como grupo (una respuesta en consenso, no generada por IA) a estas preguntas:
    - **Pregunta 1:** ¿Cuáles fueron mejoras mas relevantes que les aportó la herramienta de IA?
    - **Pregunta 2:** De las mejoras relevantes, ¿Cuáles si aplicaron? ¿Por qué?.
    - **Pregunta 3:** De las mejoras relevantes,  ¿Cuáles no aplicaron? ¿Por qué?.
    - **Pregunta 4:** ¿Podrían haber llegado a establecer estas mejoras relevantes sin el uso de la herramienta de IA? ¿Por qué?
    - **Pregunta 5:** ¿Qué aspectos destacan (pros y contras) del uso de IA en esta actividad académica?

## 6. Criterios de evaluación (20 puntos)

| **Criterio**                                          | **Nivel 4 – Excelente**                                                                                                                                                                      | **Nivel 3 – Bueno**                                                                                                 | **Nivel 2 – Aceptable**                                                                                        | **Nivel 1 – Insuficiente**                                                         | **Puntos Máx.** |
| ----------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- | --------------- |
| **Claridad del problema y justificación**             | Problema claramente definido, contextualizado y delimitado. Describe la situación actual con precisión. Justificación sólida y convincente del uso de base de datos. Evidencia impacto real. | Problema definido y contextualizado adecuadamente. Justificación válida pero con menor profundidad o argumentación. | Problema general o poco delimitado. Justificación superficial o poco conectada con la gestión de datos.        | Problema ambiguo, irreal o desconectado del uso de datos. Sin justificación clara. | **3**           |
| **Calidad del análisis del contexto y actores**       | Identifica todos los actores relevantes. Diagrama de contexto claro, coherente y técnicamente correcto. Flujo de información bien explicado.                                                 | Identifica actores principales. Diagrama correcto con pequeñas omisiones o menor claridad gráfica.                  | Identificación parcial de actores. Diagrama confuso o explicación limitada.                                    | Actores mal definidos o ausentes. Diagrama incorrecto o inexistente.               | **3**           |
| **Pertinencia y redacción de reglas de negocio**      | 5–10 reglas claras, específicas y bien redactadas. Correcta clasificación (estáticas/dinámicas). Relación directa con el problema. Evidencian impacto en datos.                              | Reglas pertinentes y clasificadas correctamente, aunque algunas podrían ser más precisas o mejor formuladas.        | Reglas generales, ambiguas o parcialmente relacionadas con el problema. Clasificación incompleta o poco clara. | Reglas escasas, incorrectas o mal redactadas. No se distingue tipo de regla.       | **4**           |
| **Viabilidad y delimitación del alcance**             | Alcance claramente delimitado. Incluye y excluye funcionalidades explícitamente. Priorización MoSCoW coherente. Proyecto realista y viable.                                                  | Alcance definido pero con menor precisión en límites o priorización.                                                | Alcance amplio o poco claro. Riesgo de sobredimensionamiento.                                                  | No hay delimitación clara o el proyecto es inviable para el semestre.              | **3**           |
| **Coherencia del inventario preliminar de entidades** | Entidades pertinentes y alineadas con reglas de negocio. Atributos clave bien definidos. Posibles llaves primarias coherentes. Boceto ER lógico y consistente.                               | Entidades adecuadas pero con leves omisiones o atributos poco refinados.                                            | Entidades muy generales o débilmente conectadas con el problema. Relaciones poco claras.                       | Entidades incorrectas, redundantes o sin relación con el problema.                 | **3**           |
| **Presentación, referencias y redacción**             | Documento claro, estructurado y coherente. Sin errores ortográficos significativos. Referencias en formato académico correcto.                                                               | Presentación adecuada con pocos errores menores de redacción o formato.                                             | Varios errores de redacción o formato. Referencias incompletas.                                                | Documento desorganizado, con errores frecuentes o sin referencias.                 | **2**           |
| **Uso crítico de IA y evidencias**                    | Evidencias claras, con una reflexión profunda y crítica de las interacciones realizadas.                                                                                                     | Evidencias claras, reflexión correcta y puntual.                                                                    | Evidencias parciales y reflexión superficial .                                                                 | Evidencias o reflexión  escasas y/o son inadecuadas.                               | **2**           |

**Formato de archivo:** `Equipo##-NOMBREEQUIPO_InformeInicio_FECHA-AA-MM-DD.pdf`

**==NOTA 1:==** Solamente el coordinador del grupo deberá subir el informe (PDF) a la tarea dentro del aula virtual.
**==NOTA 2:==** Considere con especial atención lo descrito en "5. Uso de Herramientas de Inteligencia Artificial".

## 7. Consideraciones importantes

- El proyecto debe surgir de una situación real o verosímil.
- No se evaluará complejidad extrema, sino coherencia y viabilidad.
- Esta entrega define el éxito del resto del semestre.
- Las reglas de negocio son la base del modelo de datos.
- El alcance debe ser realista y manejable.

Este informe marca el inicio formal del proyecto. Una definición clara y bien estructurada facilitará todo el desarrollo posterior del curso.
