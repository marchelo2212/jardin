---
publish: true
created: 2026-10-15T13:26:41.267Z
modified: 2026-10-15T13:26:43.227Z
tags:
  - taller
  - antigravity
  - unisabana
---

# Caso JefProy · Conciliación de insignias

← [[00 - Inicio - Taller Antigravity|Taller de Google Antigravity · Unisabana e-learning]] · **Trabajo individual · 45 minutos**

## Encargo

La jefatura necesita establecer qué insignias del catálogo esperado aparecen en el extracto del sistema, cuáles quedan pendientes y qué discrepancias requieren revisión. No se crean, eliminan ni modifican insignias en el sistema.

Archivo del facilitador: `/Users/marcelosotaminga/Desktop/Casos Trabajo/JefProy/ConsolidadoInsignias.xlsx`.

- `UE-CreacionInsignias`: catálogo esperado según el encargo.
- `Evolusign`: catálogo observado según el encargo, **como fotografía del archivo y no como consulta en vivo**.
- No usar las hojas de personas para este ejercicio.

## Pregunta de trabajo

¿Qué parte del catálogo esperado tiene correspondencia verificable en el sistema y qué decisiones quedan pendientes?

## Secuencia

| Minutos | Trabajo |
|---|---|
| 0–5 | Identificar las dos hojas y la unidad de análisis: una insignia |
| 5–15 | Detectar encabezados, filas útiles, claves candidatas y duplicados; aprobar reglas |
| 15–35 | Conciliar con reglas trazables y producir tablas de resultado |
| 35–42 | Revisar coincidencias, faltantes y ambigüedades con el original |
| 42–45 | Preparar una conclusión y una limitación |

## Reglas que deben decidirse

- Verificar dónde está el encabezado: no asumir que todas las hojas comienzan igual.
- Conservar nombres originales y crear claves auxiliares; no sobrescribir etiquetas.
- Confirmar si existe una clave compartida válida. Si no, usar comparación de nombres como evidencia limitada.
- Espacios, mayúsculas o tildes pueden servir para buscar candidatos, pero no deben borrar diferencias de nivel, programa o modalidad.
- La columna `Creada en sistema` es una declaración del catálogo, no sustituto del contraste con Evolusign.
- Separar duplicados, relaciones uno-a-varios y posibles coincidencias; no forzar un emparejamiento.
- Una insignia observada no prevista no es automáticamente errónea ni debe eliminarse.

## Prompt inicial

> Trabaja exclusivamente con UE-CreacionInsignias y Evolusign de entrada/ConsolidadoInsignias.xlsx. La primera es el catálogo esperado y la segunda el extracto observado. Inspecciona encabezados reales, campos, vacíos y posibles claves. No cambies el archivo. Propón reglas de conciliación y cómo tratar duplicados y relaciones ambiguas. Distingue evidencia de equivalencia y simple semejanza. Presenta el plan antes de transformar.

## Prompt de ejecución, después de revisar el plan

> Ejecuta las reglas acordadas y conserva hoja y fila de origen. Produce tablas de coincidencias confirmadas bajo esas reglas, esperadas sin correspondencia confirmada, observadas sin correspondencia confirmada, y candidatos ambiguos. Marca en las tablas de pendientes cuáles están sujetos a revisión por similitud. No sumes candidatos como si fueran coincidencias ni como una categoría disjunta adicional. Incluye método de comparación y motivo. Guarda resultados, reglas y controles en salida/.

## Entrega mínima

- `conciliacion.xlsx` o tablas CSV equivalentes, con identificadores de origen, nombres originales, estado, método y observación.
- `resumen.md`: conteos, reglas, tres hallazgos y acciones propuestas.
- Script o secuencia reproducible y registro de excepciones; si falta, declararlo.

## Aceptación y verificación

1. Cada registro útil de cada fuente tiene un estado exclusivo en su propio universo: confirmado o sin confirmación. Los ambiguos son una marca de revisión dentro de los no confirmados.
2. Se distinguen conteos de filas y de insignias únicas; los duplicados no inflan cobertura.
3. Se revisan manualmente al menos cinco casos distribuidos entre coincidencias y pendientes, o todos si hay menos.
4. No se presenta una coincidencia aproximada como hecho confirmado.
5. La conclusión dice «no encontrada en este extracto bajo estas reglas», no «no existe» sin más evidencia.

**Extensión si sobra tiempo:** contrastar atributos como modalidad o estado, sin cambiar el alcance de la conciliación principal.
