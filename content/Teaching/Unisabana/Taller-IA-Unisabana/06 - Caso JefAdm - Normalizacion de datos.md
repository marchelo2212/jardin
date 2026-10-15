---
publish: true
created: 2026-10-15T13:26:41.267Z
modified: 2026-10-15T13:26:43.228Z
tags:
  - taller
  - antigravity
  - unisabana
---

# Caso JefAdm · Normalización de datos

← [[00 - Inicio - Taller Antigravity|Taller de Google Antigravity · Unisabana e-learning]] · **Trabajo individual · 45 minutos**

## Encargo

Preparar registros de personas y sus insignias para una futura integración, manteniendo trazabilidad y una lista de excepciones. El formato final de importación debe confirmarse con el sistema de destino: el taller entrega una **base candidata**, no una carga certificada.

Archivo del facilitador: `/Users/marcelosotaminga/Desktop/Casos Trabajo/JefAdmin/NormalizacionDatos.xlsx`. Trabajar con las hojas `2025` y `2026`. Las demás hojas solo pueden consultarse como referencia de dominio si se justifica; no procesarlas ni mezclarlas automáticamente.

## Pregunta de trabajo

¿Qué registros podemos normalizar con reglas explícitas y cuáles requieren validación de una persona responsable?

## Ruta de 45 minutos

- **0–5:** definir unidad de registro: posible asignación persona–insignia, no solo persona.
- **5–15:** inspeccionar ambas estructuras y acordar un diccionario común.
- **15–35:** transformar de manera conservadora y separar excepciones.
- **35–42:** comprobar conteos, tipos y casos de antes/después.
- **42–45:** preparar el informe de calidad.

## Reglas iniciales para discutir

| Campo | Transformación razonable | Límite |
|---|---|---|
| Identificación, ID, teléfono, idinsignia | Tratar como texto; preservar valor original | No reconstruir ceros perdidos sin fuente |
| Nombres y apellidos | Recortar espacios externos y duplicados internos | No adivinar apellidos ni imponer capitalización que altere nombres |
| Email | Separar valor original y versión normalizada; revisar espacios | Sintaxis válida no prueba titularidad; no adivinar dominios |
| Tipo de identificación | Mapear variantes con catálogo documentado | Desconocido queda como excepción |
| Teléfono | Separar signos y extensión si la regla está definida | No añadir país ni dígitos por suposición |
| Fechas | Interpretar según formato documentado y exportar consistentemente | Fechas ambiguas o imposibles se revisan |
| Estado de pago | Documentar categorías y valores fuera del catálogo | No deducir pago a partir de ausencia o comentario ambiguo |
| Insignia y programa | Preservar relación y verificar identificador disponible | No completar idinsignia por simple parecido |

No eliminar automáticamente columnas llamadas `Unnamed`: algunas contienen datos. No tomar el máximo de filas de Excel como número de personas. Separar bloques secundarios de la tabla principal antes de decidir qué son.

## Prompt inicial

> Inspecciona 2025 y 2026 en entrada/NormalizacionDatos.xlsx. Identifica encabezados, columnas útiles, bloques secundarios, filas vacías, tipos y diferencias de esquema. Muestra un diagnóstico agregado sin exponer datos personales en el chat. Propón un diccionario común, reglas conservadoras y una clave candidata de asignación. No transformes ni elimines filas todavía.

## Prompt de ejecución

> Aplica las reglas revisadas. Conserva hoja y fila de origen, campos originales y normalizados. Añade estado\_calidad y motivos. No inventes identificaciones, correos, nombres, teléfonos ni insignias. Distingue duplicados exactos de posibles repeticiones legítimas de persona con distintas insignias o cohortes. Genera tablas separadas de candidatos listos bajo las reglas acordadas, registros por revisar y registros excluidos con motivo. Incluye bitácora de cambios y controles de conservación de filas.

## Entrega mínima

- `normalizacion.xlsx`: tablas de normalizados, excepciones y diccionario; CSV equivalentes son aceptables.
- Bitácora: origen, campo, valor anterior, valor nuevo, regla y resultado; conservarla únicamente en el entorno autorizado.
- Resumen agregado: registros considerados, reglas aplicadas, problemas pendientes y limitaciones del esquema de destino.

## Aceptación

1. Cada fila considerada tiene un destino trazable; una fila con varios problemas cuenta una vez como registro y puede generar varias incidencias.
2. Separar conteo de filas de tabla principal, bloques secundarios y filas vacías; no ocultar pérdidas al consolidar.
3. Revisar al menos cinco ejemplos de transformación y cinco excepciones, si existen, sin proyectar datos personales.
4. Una segunda ejecución con las mismas entradas y reglas produce los mismos resultados. Si se prueba la idempotencia, aplicar la normalización a su propia salida no debe introducir cambios adicionales injustificados.
5. Las filas sin evidencia suficiente no se etiquetan como listas para importación.

**Extensión:** verificar dominios categóricos contra `Datos_fijos` tras confirmar que es una referencia vigente, sin asumirlo por su nombre.
