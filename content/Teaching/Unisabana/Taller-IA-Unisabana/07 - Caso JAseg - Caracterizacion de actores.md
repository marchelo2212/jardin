---
publish: true
created: 2026-10-15T13:26:41.267Z
modified: 2026-10-15T13:26:43.229Z
tags:
  - taller
  - antigravity
  - unisabana
---

# Caso JAseg · Caracterización de actores de ferias educativas

← [[00 - Inicio - Taller Antigravity|Taller de Google Antigravity · Unisabana e-learning]] · **Parejas · 45 minutos**

## Encargo

Explorar respuestas de una encuesta para identificar y caracterizar los actores y formular recomendaciones sustentadas. “Identificar” se refiere a perfiles o categorías de actores, **no a reidentificar personas**.

Archivo del facilitador: `/Users/marcelosotaminga/Desktop/Casos Trabajo/JAseg/DatosParticipacionFerias.csv`.

## Pregunta de trabajo

¿Quiénes respondieron, cómo varían su experiencia y necesidades por rol y qué oportunidades de apoyo sugieren las respuestas?

## Organización

Una persona conduce Antigravity; la otra comprueba denominadores, categorías y evidencia. Intercambiar funciones al minuto 20. Ambas deben poder explicar una tabla y una limitación.

## Ruta

| Minutos | Acción |
|---|---|
| 0–5 | Formular dos preguntas descriptivas por rol |
| 5–15 | Inspeccionar CSV, roles, faltantes y posibles saltos del cuestionario |
| 15–35 | Producir tablas y hasta dos gráficos; revisar textos abiertos si alcanza |
| 35–42 | Recalcular un indicador y validar denominadores |
| 42–45 | Preparar tres hallazgos y una recomendación condicionada |

## Campos de entrada útiles

- `G01Q01. Rol`: punto de partida para los actores.
- `G01Q46. Área de acción.`: contexto de actuación.
- `G01Q03. Seleccione su provincia`: distribución territorial, si es pertinente.
- `G01Q05. Rango de edad:`: categorías etarias, sin inferir edades exactas.
- `G02Q06. ¿Ha participado en alguna Feria de Proyectos Educativos?`: experiencia declarada.
- Bloques posteriores de experiencia, formación e intereses: verificar a quién aplica cada pregunta.

Algunas columnas tienen etiquetas incompletas y otras son temporizadores. No interpretar una columna sin etiqueta por su posición ni confundir tiempos con respuestas. Si no se cuenta con cuestionario o diccionario, declarar la limitación y excluir esas variables de conclusiones sustantivas.

## Prompt inicial

> Inspecciona entrada/DatosParticipacionFerias.csv sin modificarlo. Usa un lector CSV que respete comillas y saltos de línea dentro de respuestas. Informa codificación, separador, registros, columnas, unicidad del ID y perfiles de Rol. Distingue preguntas, metadatos y temporizadores. Identifica posibles saltos o preguntas por perfil, pero no los des por confirmados sin cuestionario. No muestres IP ni respuestas identificables. Propón dos análisis descriptivos viables y sus denominadores.

## Prompt de ejecución

> Produce una caracterización por rol con n, porcentaje del total y participación previa. Para cada indicador informa numerador, denominador válido, faltantes y criterio de aplicabilidad. No conviertas vacíos en No. Separa preguntas de selección múltiple: los porcentajes pueden sumar más de 100%. Genera como máximo dos gráficos legibles y un informe con tres hallazgos, evidencia, limitaciones y recomendaciones. No infieras causalidad ni representatividad poblacional.

## Entrega mínima

- Tabla de actores: rol, n, porcentaje, participación previa y una característica adicional bien definida.
- Una o dos visualizaciones con título, unidad, denominador y fuente.
- `hallazgos.md`: tres hallazgos enlazados a tablas, una recomendación y límites.
- Reglas o script reproducible y evidencia de un recálculo independiente.

## Validación

1. La suma de participantes por rol coincide con los registros incluidos; explicitar exclusiones.
2. Un porcentaje de experiencia previa por rol usa el denominador válido de ese rol, no toda la muestra.
3. Faltantes, no aplica y respuestas negativas se mantienen distintos cuando el instrumento permita distinguirlos. Sin instrumento, no inventar esa distinción.
4. Las escalas ordinales conservan categorías; calcular promedios solo con justificación explícita.
5. No se muestran IP, identificación individual ni citas con datos personales.

**Extensión cualitativa:** tomar una muestra documentada de respuestas abiertas, proponer categorías, permitir codificación múltiple y revisar manualmente diez asignaciones. No presentar la frecuencia de una muestra como frecuencia del conjunto.
